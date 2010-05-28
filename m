From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: scsi_eh startup on scsi_dispatch_cmd busy calls to scsi_queue_insert
Date: Fri, 28 May 2010 09:20:56 -0700
Message-ID: <20100528162055.GA32022@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35367 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757431Ab0E1QVL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2010 12:21:11 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e4.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id o4SG86OI026763
	for <linux-scsi@vger.kernel.org>; Fri, 28 May 2010 12:08:06 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o4SGKwGg119796
	for <linux-scsi@vger.kernel.org>; Fri, 28 May 2010 12:20:58 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o4SGKucQ015184
	for <linux-scsi@vger.kernel.org>; Fri, 28 May 2010 12:20:57 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

This email is on a similar topic to a previous email that I posted on the
subject of blk_abort_request calls through blk_abort_queue racing with requests
that had a timer started on them, but where later requeued due to condition
checks in scsi_request_fn / scsi_dispatch_cmd instead of completing through the
softirq path.
http://markmail.org/message/23vfel74dbtjzzho


While I have seen error cases using standard mainline kernels I have attempted
to accelerated the error cases using a patched kernel. I added a patch for a
few sysfs attributes for controlling abort calls, target busy, and queuecommand
busy. During testing with IO load I could generate two error signatures.

1.) Timeout handler not starting up as failed is greater than busy.

2.) Bug on case in "kernel BUG at block/blk-core.c:956!" which is "BUG_ON(blk_queued_rq(rq));".

These error cases occur if a request that is marked started is added to the
scis_eh list, but later determination decides not to completely start the
request. The not completely starting the request can occur through the path of
scsi_request_fn to the checking of the return value of queuecommand in
scsi_dispatch_cmd.

James, in a response to a ping you indicated that if I was really seeing a
error in this area that I may need a check for complete in the non-softirq
requeue cases. I ran testing with a simple change that was not much more than a
wrapper around blk_mark_rq_complete with a return value. This appeared to
address the issue, but in one test case I created it still failed.

Using a modified scsi_debug module that had a delay in queuecommand of 100ms
more than the timeout value prior to returning a busy response. Prior to
delaying in the queuecommand I dropped the host_lock which a few queuecommand
functions do. I was able at a timeout value of 1 second to generate the bug on
case.

While this test case is on the edge it does point out that the lock dance of
queue_lock / host_lock from scsi_request_fn through the checking of the return
value of queuecommand would appear to leave a window open in the determination
of request ownership.

I also tried a patched test run attempting to use the cmd serial_number to hold
off scsi_eh startup on a command, but the possible drop of the host_lock in
queuecommand functions effects this alternate solution as well.

In older kernels we used to have serialization with the timeout handler in
scsi_dispatch_cmd through the use of  " if (scsi_delete_timer(cmd))" which we
do not have anymore with the newer blk timeout. Since I did not run similar
testing on older kernels it is unclear if a windows existed there.

Question:

1.) Does the edge case using the modified scsi_debug appear to a be a valid
case? If so do you see a method to close this window, or with the current
structure is there a timeout floor where this window will always exist?


Thanks,

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
