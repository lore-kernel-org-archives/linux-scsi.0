From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Open-FCoE] transport_generic_handle_data - BUG:
	scheduling	while atomic
Date: Thu, 11 Nov 2010 17:29:02 -0800
Message-ID: <1289525342.2867.200.camel@haakon2.linux-iscsi.org>
References: <FE279AF0CA06284B8C26150408F3EB120787382F@CBSSEXM02P.crossbeamsys.com>
	 <4CDC494A.5030207@cisco.com>
	 <13830B75AD5A2F42848F92269B11996F0107633CE4@orsmsx509.amr.corp.intel.com>
	 <1289523519.2867.181.camel@haakon2.linux-iscsi.org>
	 <4CDC95CB.50702@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:43128 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068Ab0KLBeP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2010 20:34:15 -0500
In-Reply-To: <4CDC95CB.50702@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: linux-iscsi-target-dev@googlegroups.com, "Patil, Kiran" <kiran.patil@intel.com>, "Jansen, Frank" <fjansen@CROSSBEAMSYS.COM>, "devel@open-fcoe.org" <devel@open-fcoe.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On Thu, 2010-11-11 at 17:18 -0800, Joe Eykholt wrote:
> 
> On 11/11/10 4:58 PM, Nicholas A. Bellinger wrote:
> > On Thu, 2010-11-11 at 14:57 -0800, Patil, Kiran wrote:
> >> Yes, transport_generic_handle_data which is called from ft_recv_write_data can do msleep_interruptible only if transport is active.
> >>
> >> FYI, this msleep was not introduced by my patch, it has been there.
> >>
> >> Agree with Joe's both suggestion (fcoe_rcv - always let it go to processing thread and TCM should not block per CPU receive thread). Will let Nick comment on that.
> >>
> > 
> > Hey guys,
> > 
> > So the split for interrupt context setup of individual se_cmd
> > descriptors for TCM_Loop (and other WIP HW FC target mode drivers) is to
> > use the optional target_core_fabric_ops->new_cmd_map() for the pieces of
> > se_cmd setup logic that are currently not done in interrupt context.
> > For TCM_Loop this is currently:
> > 
> > *) transport_generic_allocate_tasks() (access of lun, PR and ALUA 
> >         specifics locks currently using spin_lock() + spin_unlock()
> > *) transport_generic_map_mem_to_cmd() using GFP_KERNEL allocations
> > 
> > However for this specific transport_generic_handle_data() case:
> > 
> >         /*
> >          * Make sure that the transport has been disabled by
> >          * transport_write_pending() before readding this struct se_cmd to the
> >          * processing queue.  If it has not yet been reset to zero by the
> >          * processing thread in transport_add_cmd_to_queue(), let other
> >          * processes run.  If a signal was received, then we assume the
> >          * connection is being failed/shutdown, so we return a failure.
> >          */
> >         while (atomic_read(&T_TASK(cmd)->t_transport_active)) {
> >                 msleep_interruptible(10);
> >                 if (signal_pending(current))
> >                         return -1;
> >         }
> > 
> > is specific for existing drivers/target/lio-target iSCSI code, which need this for
> > traditional kernel sockets recv side iSCSI WRITE case.
> > 
> > Since we have already have FCP write data ready for submission to
> 
> (We have some, usually not all of the data)

Correct, because the above msleep_interruptible() case is waiting for
TCM to perform internal physical memory for T_TASK(cmd)->t_mem_list and
signal back to fabric module code.

In the case the se_Cmd coming from pre-mapped SGLs into
transport_generic_map_mem_to_cmd() -> T_TASK(cmd)->t_mem_list I am
pretty certain we don't ever need to hit this msleep_interruptible() in
per se_cmd WRITE descriptor dispatch for backend ->do_task() execution.

> 
> > backend devices at this point, I think we want something in the
> > transport_generic_new_cmd() -> transport_generic_write_pending() code
> > that does the immediate SCSI write submission and skips the
> > TFO->write_pending() callback / extra fabric API exchange/response..  
> 
> If I understand, the write_pending() callback is when we send the transfer ready
> to the initiator, and we don't have the data yet.
> 
> > Here is how TCM_loop is currently doing that with SCSI WRITE data mapped
> > from incoming ->queuecommand() cmd->table.sgl memory:
> > 
> > int tcm_loop_write_pending(struct se_cmd *se_cmd)
> > {
> >         /*
> >          * Since Linux/SCSI has already sent down a struct scsi_cmnd
> >          * sc->sc_data_direction of DMA_TO_DEVICE with struct scatterlist array
> >          * memory, and memory has already been mapped to struct se_cmd->t_mem_list
> >          * format with transport_generic_map_mem_to_cmd().
> >          *
> >          * We now tell TCM to add this WRITE CDB directly into the TCM storage
> >          * object execution queue.
> >          */
> >         transport_generic_process_write(se_cmd);
> >         return 0;
> > }
> > 
> > This will skip the transport_check_aborted_status() in
> > transport_generic_handle_data(), and immediately add the
> > T_TASK(cmd)->t_task_list for se_task execution down to
> > se_subsystem_api->do_task() and out to backend subsystem code.
> > 
> > So just to reiterate the point with current v4.0 code, we currently
> > cannot safely call transport_generic_allocate_tasks() or
> > transport_generic_map_mem_to_cmd() from interrupt context, so you want
> > to do these calls using TFO->new_cmd_map() callback in the backend
> > kernel thread process context..  
> 
> The workaround I gave calls them from thread context, but we don't
> want that thread to block (at least not for very long) either.  It is
> holding up more incoming requests and data for unrelated I/O.
> 

<nod>

> > So I think this means you want to call transport_generic_process_write()
> > to immediate queue the WRITE from TFO->write_pending(), but not very
> > certain after looking at ft_write_pending().
> > 
> > Joe, any thoughts here..?
> 
> I find this all confusing, mainly because I'm not taking time to figure
> it all out, and there seem to be so many related issues.  So, I'm not
> sure I've researched it enough to make any of these comments.
> 

Yes, eventually I would like to be able to
transport_generic_allocate_tasks() (which really needs to be renamed,
because it's not actually allocating anything yet) and a special case
for transport_generic_map_mem_to_cmd() using GFP_ATOMIC (and eventually
some pre-allocated threshold perhaps..?) for handling the full interrupt
context setup case.

But I think this is going to be a v4.1 think at this point, unless this
can happen in the next weeks while I am coding on existing HW FC target
mode fabric mod ports..

> Eventually, we want to accumulate all the write data frames and then
> give you an s/g list for them which you pass to the back end driver.
> For FCP, however, the sequence is:
> 	
> receive command - verify LUN, etc.

<nod> transport_get_lun_for_cmd() can be safely called from interrupt
context.

>   TCM calls tcm_fc to send transfer-ready.
> When all the data frames have been received, tcm_fc makes the S/G list and give
> them to TCM.  When the back end is done, tcm_fc sends status and free the frames.
> 
> In the mean time, the current interface is probably fine, but means we need
> to do a copy, unless the LLD uses direct data placement.
> 

Yes, so in that sense the copy still requires an internal TCM
T_TASK(cmd)->t_mem_list allocation, which means the
msleep_interruptible() check in transport_handle_data() is required and
your short term workaround is necessary..

Shall I merge this now or do you want to do want something else..?

Thanks Joe,

--nab



