From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: stack overflow: scsi_request_fn/blk_run_queue ping-pong
Date: Tue, 8 Aug 2006 18:05:08 +0200
Message-ID: <20060808160508.GA19011@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:60355 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP id S932441AbWHHQJL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Aug 2006 12:09:11 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.13.7/8.13.7) with ESMTP id k78G9AFG027044
	for <linux-scsi@vger.kernel.org>; Tue, 8 Aug 2006 16:09:10 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k78GCmdh086030
	for <linux-scsi@vger.kernel.org>; Tue, 8 Aug 2006 18:12:48 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k78G99Pr019443
	for <linux-scsi@vger.kernel.org>; Tue, 8 Aug 2006 18:09:09 +0200
Received: from lion28.boeblingen.de.ibm.com (lion28.boeblingen.de.ibm.com [9.152.198.37])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k78G99mH019438
	for <linux-scsi@vger.kernel.org>; Tue, 8 Aug 2006 18:09:09 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI <linux-scsi@vger.kernel.org>

Hi,

Recently I observed a kernel stack overflow due to a 
recursion between scsi_request_fn and blk_run_queue.
(We did error injection tests on s390 with zfcp using 32 LUNs and multiple
paths.)

Calling sequence was:
  scsi_request_fn->scsi_dispatch_cmd->scsi_queue_insert->
  scsi_run_queue->blk_run_queue->scsi_request_fn
Recursion depth was about 18.

On each iteration the request_queue passed to blk_run_queue/scsi_request_fn
was different. This is due to the fact that blk_run_queue was called
iterating shost->starved_list in scsi_run_queue:

        while (!list_empty(&shost->starved_list) &&
               !shost->host_blocked && !shost->host_self_blocked &&
                !((shost->can_queue > 0) &&
                  (shost->host_busy >= shost->can_queue))) {

...
                sdev = list_entry(shost->starved_list.next,
                                          struct scsi_device, starved_entry);

...
                blk_run_queue(sdev->request_queue);
...
	}

Because a different request_queue was passed to blk_run_queue the
check for QUEUE_FLAG_REENTER in blk_run_queue did not help to avoid
the recursion.

My explanation for this situation is as follows:
The shost was blocked temporary and the starved_list was filled.
Following some remote port was deleted which caused that sdev_state
for some scsi device was SDEV_BLOCK. And this in turn led to the above
recursion. (At time when recursion started shost was not blocked anymore.)

Of course this recursion ends if the starved_list is empty.
But always a stack overflow is imminent depending on the number of
entries in starved_list.

A quick hack would be to do the following before calling
blk_run_queue in scsi_run_queue:

	if (test_bit(QUEUE_FLAG_REENTER, &q->queue_flags))
		set_bit(QUEUE_FLAG_REENTER, &sdev->request_queue->queue_flags);

	blk_run_queue(sdev->request_queue);

Any opinion regarding the problem and the suggestion to fix the problem?
If there are no objections I will make a patch containing this fix.


Regards,

Andreas
