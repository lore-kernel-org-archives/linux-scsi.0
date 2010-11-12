From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [dm-devel] block_abort_queue (blk_abort_request) racing with
 scsi_request_fn
Date: Fri, 12 Nov 2010 09:54:40 -0800
Message-ID: <20101112175440.GA3978@linux.vnet.ibm.com>
References: <20100512052336.GB15240@linux.vnet.ibm.com>
 <4CDA4524.4010204@cs.wisc.edu>
 <4CDA49F8.9050406@cs.wisc.edu>
 <20101110163047.GA26201@linux.vnet.ibm.com>
 <4CDB0BAA.8060801@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40186 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab0KLRy5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Nov 2010 12:54:57 -0500
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e9.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id oACHXIwY007750
	for <linux-scsi@vger.kernel.org>; Fri, 12 Nov 2010 12:33:18 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id oACHsj7a1147080
	for <linux-scsi@vger.kernel.org>; Fri, 12 Nov 2010 12:54:45 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id oACHsiQV002067
	for <linux-scsi@vger.kernel.org>; Fri, 12 Nov 2010 12:54:45 -0500
Content-Disposition: inline
In-Reply-To: <4CDB0BAA.8060801@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

Mike Christie <michaelc@cs.wisc.edu> wrote:
> On 11/10/2010 10:30 AM, Mike Anderson wrote:
> >
> >Is your test configuration / error injection testing able to reproduce
> >fairly reliably. If so can you provide some general details on how you
> >are generating this error.
> 
> In one test we just run dm-mutlipath over FC with the default
> timeouts, then disable the target controller. This leads to IO
> timing out and the scsi eh running. We then bring the controller
> back up and depending on timing that then can lead to either the
> scsi eh failing and IO being failed upwards or the scsi eh
> succeeding and IO retried.
> 
> Also a really easy way, but probably unrealistic, to hit something
> similar (more like what you hit in your 1 second timeout case in the
> other mail) is if you just set the queue timeout to 0, the
> queue_depth lower than the number of commands you are sending and
> let the IO test run on the scsi disk. This sort of replicates the
> problem because the request timesout while it is in the
> scsi_request_fn similar to how the blk_abort_queue can be called on
> the cmd while is in there.
> 

I ran the timeout set to zero test using "modprobe scsi_debug
max_queue=2 virtual_gb=20" along with fio. Wihtout any changes the I/O
locks up in with in a minute. I applied your patch and the I/O locked up
in near the same amount of time which based on your previously mail I
think this is to be expected. I then reordered scsi_request_fn to do the
host_busy work up front prior to getting a request and starting it. It
has been running for ~ 18 hours (although it is slow due to all the
timeouts occurring).

The reordering in scsi_request_fn concerns me as we are bouncing the
locks more and unclear how much impact the reordering has on I/O rates. I
did not attach a patch as currently it does not look very good and I think
I am missing the handling of a couple of error cases.

> 
> >>>
> >>>I also tried a patch where we just add another req bit. We set it in
> >>>blk_rq_timed_out_timer and clear it in a new function that clears it
> >>>then calls blk_requeue_reqeust. The new function:
> >>>
> >>>blk_requeue_timedout_request - used when request is to be requeued if a
> >>>LLD q->rq_timed_out_fn returned BLK_EH_NOT_HANDLED and has resolved the
> >>>problem and wants the request to be requeued. This function clears
> >>>REQ_ATOM_TIMEDOUT and then calls blk_requeue_request.
> >>>
> >>>blk_reqeuue_request would then check if REQ_ATOM_TIMEDOUT is set and if
> >>>it was just drop the request assuming the rq_timed_out_fn was handling
> >>>it. This still requires the caller to know how the command is supposed
> >>>to be reqeueud. But I think it might be easier since the driver here has
> >>>returned BLK_EH_NOT_HANDLED in the q timeout fn so they know that they
> >>>are going to be handling the request in a special way.
> >>>
> >>>I attached the last idea here. Made over Linus's tree. Only compile tested.
> >>>
> >>
> >>Oops, nevermind. I think this is trying to solve a slightly
> >>different problem. I saw your other mail. My patch will not handle
> >>the case where:
> >>
> >>1. cmd is in scsi_reqeust_fn has run blk_start_request and dropped
> >>the queue_lock. Has not yet taken the host lock and incremented host
> >>busy counters.
> >>2. blk_abort_queue runs q->rq_timed_out_fn and adds cmd to host eh list.
> >>3. Somehow scsi eh runs and is finishing its stuff before #1 has
> >>done anything, so the cmd was just processed by scsi eh *and* at the
> >>same time is still lingering in scsi_request_fn (somehow #1 has
> >>still not taken the host lock).
> >>
> >
> >While #1 could also return with a busy from queuecommand which will call
> >scsi_queue_insert with no check for complete. One could add a
> >blk_mark_rq_complete check prior to calling scsi_queue_insert. This does
> >not cover the not_ready label case in scsi_request_fn.
> >
> 
> Yeah, I was trying to not to have to add blk_mark_rq_complete checks
> in the scsi layer and just have the block layer handle it. I think
> my patch in the previous mail covers both the scsi_request_fn and
> scsi_dispatch_cmd/queuecommand cases. The patch should work as long
> as the scsi eh has not already completed and run blk_requeue_request
> on it. The problem with my patch is only that case above where the
> cmd gets blk_abort_queued/timedout run on it and the scsi eh somehow
> is able to complete and run scsi_queue_insert while scsi_request_fn
> is still trying to process the request.
> 
> This could be solved by just having the scsi eh thread flush the
> queue before running. This would make sure the cmd is not running in
> scsi_request_fn while the scsi the scsi is also processing it. We
> sort of do this today with the host_busy checks in
> scsi_error_handler. The problem is that window from the time
> scsi_request_fn drops the queue_lock and grabs the host_lock to
> increment host_busy. In the window, blk_abort_request can run, the
> scsi_eh thread can see host_busy == host_failed, start the scsi eh,
> run to completion and hit the problem I described above.
> 
> 
> 
> 
> >Another option might be to make blk_abort less aggressive if we cannot
> >close all the paths and switch it to more of a drain model, but then we
> >may be in the same boat in selecting how fast we can drain based what we
> >perceive to be a safe time value. This option leaves the existing races
> >open in the scsi_request_fn / scsi_dispatch_cmd.


With the lock push down work and other clean ups I assume some of the lock / unlocks in scsi_request_fn might be reduced making a reordering / addressing this issue less impact to the I/O path. This might be incorrect.

As mentioned above an option might be to provide a floor for the timeout
part of the abort instead of calling a timeout directly. 

While this seems like leaving a hole for others to fall into, it might
be the least disruptive to most users and may have the side effect of
avoiding a eh wakeup in some cases. At the same time a safe in all cases
value cannot really be selected.

We currently are providing some protection to the SG interfaces from
hitting this race by providing a floor for a timeout value of
BLK_MIN_SG_TIMEOUT. We also default the sd interface to SD_TIMEOUT
making it unlikely that a user would hit this case unless they modified
the timeout to low value like in the experiment above.

By not directly timing out the I/O but accelerating the timeout by a
factor. The value could be calculated as a percentage of the queue timeout
value for a default with the option of exposing a sysfs attribute
similar to fast_io_fail_tmo. The attribute could also provide a off
method which we do not have today and is my bad that we do not have one
(I posted the features patch to multipath but did not followup which
would have provided a off).  Since the queue is cleared increasing the
lifetime of the I/O a small amount should still provide good latency
reduction. The intent was to reduce high I/O latency during some failure
cases (since we do not fast fail timeouts anymore the timeout * N
retries plus a large number of I/Os queue case). At the same time this
interface needs to safe.

Is this pushing off the real fix a bad idea to consider / direction to
look at?

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
