From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [ANNOUNCE] Status of unlocked_qcmds=1 operation for .37
Date: Tue, 26 Oct 2010 15:34:24 -0700
Message-ID: <1288132464.5169.112.camel@haakon2.linux-iscsi.org>
References: <1287607774.10283.78.camel@haakon2.linux-iscsi.org>
	 <20101021150840.GA24309@linux.vnet.ibm.com>
	 <1288130914.5169.97.camel@haakon2.linux-iscsi.org>
	 <1288132071.8283.689.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm13-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.48]:42495 "HELO
	nm13-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751588Ab0JZWjW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2010 18:39:22 -0400
In-Reply-To: <1288132071.8283.689.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>

On Tue, 2010-10-26 at 17:27 -0500, James Bottomley wrote:
> On Tue, 2010-10-26 at 15:08 -0700, Nicholas A. Bellinger wrote:
> > On Thu, 2010-10-21 at 08:08 -0700, Mike Anderson wrote:
> > > Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> > > > *) core drivers/scsi remaining issue(s):
> > > > 
> > > > The issue raised by andmike during RFCv4 described as:
> > > > 
> > > > "If we skip __scsi_try_to_abort_cmd when REQ_ATOM_COMPLETE is set it
> > > > would be correct for the scsi_decide_disposition cases but it would
> > > > appear this would stop __scsi_try_to_abort_cmd from being called in the
> > > > time out case as REQ_ATOM_COMPLETE is set prior to calling
> > > > blk_rq_timed_out."
> > > > 
> > > > The complete discussion is here:
> > > > 
> > > > http://marc.info/?l=linux-scsi&m=128535319915212&w=2
> > > > 
> > > > We still need folks with experience to dig into this code, so you know
> > > > the scsi_error.c code please jump in!
> > > > 
> > > 
> > > I provided two logging traces below for the two cases mentioned in the
> > > above email thread. The second trace used a modified version of
> > > scsi_debug so that I could generate the needed unit attention codes.
> > > 1.) On the check for complete comment the logging below marked with
> > > "***" indicated that during a timeout that the complete bit is set. We
> > > would not want to have a check for complete skip the call to
> > > __scsi_try_to_abort_cmd. 
> > > 
> > > scsi_debug: cmd 28 00 00 00 00 00 00 00 20 00 
> > > sd 1:0:0:0: [sdb] Done: TIMEOUT
> > > sd 1:0:0:0: [sdb]  Result: hostbyte=DID_OK driverbyte=DRIVER_OK
> > > sd 1:0:0:0: [sdb] CDB: Read(10): 28 00 00 00 00 00 00 00 20 00
> > > Waking error handler thread
> > > Error handler scsi_eh_1 waking up
> > > sd 1:0:0:0: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
> > > Total of 1 commands on 1 devices require eh work
> > > scsi_eh_1: aborting cmd:0xffff88019e171b80
> > > 
> > > ***
> > > sd 1:0:0:0: scsi_try_to_abort_cmd: Comp bit set
> > > ***
> > > 
> > > scsi_debug: abort
> > > scsi_debug: cmd 00 00 00 00 00 00 
> > > scsi_eh_done scmd: ffff88019e171b80 result: 0
> > > scsi_send_eh_cmnd: scmd: ffff88019e171b80, timeleft: 10000
> > > scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
> > > scsi_eh_tur: scmd ffff88019e171b80 rtn 2002
> > > scsi_eh_1: flush retry cmd: ffff88019e171b80
> > > scsi_restart_operations: waking up host to restart
> > > scsi_debug: cmd 28 00 00 00 00 00 00 00 20 00 
> > > Error handler scsi_eh_1 sleeping
> > > 
> > 
> > Hi Mike and Co,
> > 
> > After considering a couple of different approches here, I ended up with
> > the following simple patch that has been tested on linus HEAD from this
> > afternoon w/ forcing scsi_debug cmd TIMEOUT during modprobe and via
> > sg_dd ops.  (See comments below)
> > 
> > [PATCH] scsi: Add SCSI_EH_SOFTIRQ_DONE usage
> > 
> > This patch introduces a SCSI_EH_SOFTIRQ_DONE flag that is set in scsi_softirq_done()
> > from block soft_irq context that is used to signal when scsi_try_to_abort_cmd() should
> > be calling __scsi_try_to_abort_cmd() for a timed out struct scsi_cmnd instead of
> > returning SUCCESS via checking only blk_test_rq_complete().  This is done because
> > blk_rq_timed_out_timer() calls blk_mark_rq_complete() before blk_rq_timed_out() ->
> > struct request_queue->rq_timed_out_fn().
> 
> This is getting pretty far off into the weeds.  I think the first step
> should be queue lock push down into ->queuecommand.  This would still
> necessitate locking around the serial number.

Hmmm, I am not sure I understand what you mean here.  My understanding
is that the whole point of the series was to remove any locking around
the serial number in order to make scsi_dispatch_cmd() lockless,
right..?

That is what the current patch series already does, in that it makes the
use of cmd->serial_number optional and requires LLDs who use this for
anything beyond an informational purpose to explictly call
scsi_cmd_get_serial(). 

> The next step might be
> serial number elimination/reduction which might need to address issues
> like this (or not ... block already knows the information, there's not
> really much need for us to track it twice).  There might also be other
> lock aquisition reduction as part of step 2.
> 

Correct, with this series cmd->serial_number still exists, but is
completly optional and no longer used for any SCSI ML functionality.  It
remains used only beyond an information purpose by a handful of LLDs in
their legacy error recovery handling, which have been updated in this
series to explictly call scsi_cmd_get_serial().

So other than those handful special cases, all of the LLDs included in
the series which explict set SHT->unlocked_qcmd=1 to run in
scsi_dispatch_cmd() lockless mode will no longer need ->serial_number.

--nab

