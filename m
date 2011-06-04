From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 39/42] target: Call transport_new_cmd instead of adding
	to cmd queue
Date: Fri, 03 Jun 2011 19:33:58 -0700
Message-ID: <1307154838.8419.55.camel@haakon2.linux-iscsi.org>
References: <1306523240-15543-1-git-send-email-agrover@redhat.com>
	 <1306523240-15543-40-git-send-email-agrover@redhat.com>
	 <1306834367.8193.169.camel@haakon2.linux-iscsi.org>
	 <20110531101755.GA31447@lst.de>
	 <1306840694.8193.206.camel@haakon2.linux-iscsi.org>
	 <20110601040945.GB15488@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51785 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab1FDCm2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2011 22:42:28 -0400
In-Reply-To: <20110601040945.GB15488@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-iscsi-target-dev@googlegroups.com, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2011-06-01 at 06:09 +0200, Christoph Hellwig wrote:
> On Tue, May 31, 2011 at 04:18:14AM -0700, Nicholas A. Bellinger wrote:
> > I very much agree with these points, and moving to workqueues for TCM
> > v4.1 (mainline v3.1) for these reasons makes alot of sense to me.  I
> > need to get a better idea of how this will actually look, but am eager
> > to move ahead..
> 
> I think the first step would be to move split the se_task execution
> from the current thread into a workqueue.  That would also help with
> making the file backend scale much better.  If it wasn't for head of queue
> semantics this would be almost trivial - just embedd a work_struct in
> every task and queue it up to the work queue, which handles concurrency.
> I'm not entirely sure how to handle head of queue semantics correctly,
> maybe just adding a pointer to pending head of queue tasks to the
> se_dev and executing those first might work.
> 
> 

<nod>.  I need to think about this a bit more wrt to HOQ, but I think
this sounds like a reasonable first step.

> Btw, I can't fully make sense of the current task execution, so
> here's a few questions:
> 
>  - why do we have separate __transport_execute_tasks and
>    transport_execute_tasks, or rather why is it safe to use
>    __transport_execute_tasks transport_processing_thread
>    without the checks for shutting down?

This is because the current code in transport_processing_thread() cannot
be shutdown until last fabric port symlink reference has dropped from
configfs.  We currrently expect all outstanding I/O to be accounted
during fabric port shutdown for individual struct se_lun <-> struct
se_device fabric mappings in __transport_clear_lun_from_sessions()

>  - what is the point of the transport_generic_process_write wrapper?

Minus the stubbed WRITE overflow copy stuff, this primarly used by
tcm_loop to queue up the cmd's tasks for execution via
transport_execute_tasks() instead of a direct fabric module call..

Currently tcm_loop is the only user of this as we know the full WRITE
payload is available once the struct scsi_cmd as been dispatched via
->queuecommand().

>  - why does transport_generic_new_cmd call transport_execute_tasks
>    for reads, but for writes we leave it to the ->write_pending
>    method which only calls transport_execute_tasks for some of
>    the fabrics?

This is because all of the necessary SCSI WRITE payload may have not
been received to execute tasks to the struct se_device backends.

>    Note that with the current code transport_generic_new_cmd
>    might not get called from the fabric thread and thus stall the
>    caller - it might make sense switch to calling transport_generic_handle_data
>    for that case.

Not exactly..  Andy's patches call transport_generic_new_cmd() directly
only for the immediate WRITE payload case in iscsit_handle_scsi_cmd() to
alloc + build + queue via RX thread context, but not for the other non
immediate WRITEs cases.  The other case currently follows:

    iscsit_handle_scsi_cmd() ->
         iscsit_sequence_cmd () ->
              iscsit_execute_cmd() ->
                 transport_generic_handle_cdb() (queue via processing context)

This was originally done because it's possible for
transport_generic_handle_cdb() to be called from a different iSCSI
connection RX context depending upon CmdSN ordering.

So the immediate WRITE case appear to be working as expected now with
the most recent series, and I am still investigating the other codepaths
for possible breakage..

--nab


