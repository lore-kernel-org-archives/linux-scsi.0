From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [PATCH v2] scsi: Unblock devices in SDEV_CANCEL
Date: Wed, 6 Oct 2010 13:45:00 +0200
Message-ID: <20101006114459.GA8812@schmichrtp.mainz.de.ibm.com>
References: <20100902110540.GB4097@schmichrtp.mainz.de.ibm.com>
 <4C83DC70.5030304@cs.wisc.edu>
 <20100906104742.GA23653@schmichrtp.mainz.de.ibm.com>
 <20100906105938.GB23653@schmichrtp.mainz.de.ibm.com>
 <4CAC2F13.60901@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:53156 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab0JFLpJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2010 07:45:09 -0400
Received: from d06nrmr1707.portsmouth.uk.ibm.com (d06nrmr1707.portsmouth.uk.ibm.com [9.149.39.225])
	by mtagate7.uk.ibm.com (8.13.1/8.13.1) with ESMTP id o96Bj1DO003766
	for <linux-scsi@vger.kernel.org>; Wed, 6 Oct 2010 11:45:01 GMT
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by d06nrmr1707.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o96Bj1or3497990
	for <linux-scsi@vger.kernel.org>; Wed, 6 Oct 2010 12:45:01 +0100
Received: from d06av04.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o96Bj0fN020208
	for <linux-scsi@vger.kernel.org>; Wed, 6 Oct 2010 12:45:01 +0100
Content-Disposition: inline
In-Reply-To: <4CAC2F13.60901@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, stable@kernel.org

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Deleting a SCSI device on a blocked fc_remote_port (before
fast_io_fail_tmo fires) results in a hanging thread:

  STACK:
  0 schedule+1108 [0x5cac48]
  1 schedule_timeout+528 [0x5cb7fc]
  2 wait_for_common+266 [0x5ca6be]
  3 blk_execute_rq+160 [0x354054]
  4 scsi_execute+324 [0x3b7ef4]
  5 scsi_execute_req+162 [0x3b80ca]
  6 sd_sync_cache+138 [0x3cf662]
  7 sd_shutdown+138 [0x3cf91a]
  8 sd_remove+112 [0x3cfe4c]
  9 __device_release_driver+124 [0x3a08b8]
10 device_release_driver+60 [0x3a0a5c]
11 bus_remove_device+266 [0x39fa76]
12 device_del+340 [0x39d818]
13 __scsi_remove_device+204 [0x3bcc48]
14 scsi_remove_device+66 [0x3bcc8e]
15 sysfs_schedule_callback_work+50 [0x260d66]
16 worker_thread+622 [0x162326]
17 kthread+160 [0x1680b0]
18 kernel_thread_starter+6 [0x10aaea]

During the delete, the SCSI device is moved to SDEV_CANCEL.  When the
FC transport class later calls scsi_target_unblock, this has no
effect, since scsi_internal_device_unblock ignores SCSI devices in
this state.  Fix this by also accepting SDEV_CANCEL in
scsi_internal_device_unblock.

[michaelc@cs.wisc.edu: If the device goes from block to offline then
the IO gets stuck in the queue and we can hang like above. The
attached patch just modifies your patch to also handle the offline
case.

It looks like all these are regressions caused by:
5c10e63c943b4c67561ddc6bf61e01d4141f881f [SCSI] limit state
transitions in scsi_internal_device_unblock]

Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: stable@kernel.org
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/scsi/scsi_lib.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2428,7 +2428,8 @@ scsi_internal_device_unblock(struct scsi
 		sdev->sdev_state = SDEV_RUNNING;
 	else if (sdev->sdev_state == SDEV_CREATED_BLOCK)
 		sdev->sdev_state = SDEV_CREATED;
-	else
+	else if (sdev->sdev_state != SDEV_CANCEL &&
+		 sdev->sdev_state != SDEV_OFFLINE)
 		return -EINVAL;
 
 	spin_lock_irqsave(q->queue_lock, flags);
