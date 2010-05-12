From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: block_abort_queue (blk_abort_request) racing with scsi_request_fn
Date: Tue, 11 May 2010 22:23:37 -0700
Message-ID: <20100512052336.GB15240@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:38669 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab0ELFXj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2010 01:23:39 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e36.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id o4C5KUI8014318
	for <linux-scsi@vger.kernel.org>; Tue, 11 May 2010 23:20:30 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o4C5NcEt128058
	for <linux-scsi@vger.kernel.org>; Tue, 11 May 2010 23:23:38 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o4BMNasI014676
	for <linux-scsi@vger.kernel.org>; Tue, 11 May 2010 16:23:37 -0600
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@suse.de>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org

I was looking at a dump from a weekend run and I believe I am seeing a
case where blk_abort_request through blk_abort_queue picked up a request
for timeout that scsi_request_fn decided not to start. This test was under
error injection.

I assume the case in scsi_request_fn this is hitting is that a request has
been put on the timeout_list with blk_start_request and then one of the
not_ready checks is hit and the request is decided not to be started. I
believe the drop 

It appears that my usage of walking the timeout_list in block_abort_queue
and using blk_mark_rq_complete in block_abort_request will not work in
this case.
 
While it would be good to have way to ensure a command is started, it is
unclear if even at a low timeout of 1 second that a user other than
blk_abort_queue would hit this race.

The dropping / acquiring of host_lock and queue_lock in scsi_request_fn
and scsi_dispatch_cmd make it unclear to me if usage of
blk_mark_rq_complete will cover all cases.

I looked at checking serial_number in scsi_times_out along with a couple
blk_mark_rq_complete additions, but unclear if this would be good and / or
work in all cases.

I looked at just accelerating deadline by some default value but unclear
if that would be acceptable. 

I also looked at just using just the mark interface I previously posted
and not calling blk_abort_request at all, but that would change current
behavior that has been in use for a while.

Looking for suggestions.

Thanks,

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
