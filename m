From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: 2.6.24-rc4-mm1: hostbyte=0x01 driverbyte=0x00 (now bisected)
Date: Thu, 6 Dec 2007 02:41:54 +0300
Message-ID: <20071205234154.GA4041@martell.zuzino.mipt.ru>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:20563 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbXLEXmB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Dec 2007 18:42:01 -0500
Received: by ug-out-1314.google.com with SMTP id z38so595145ugc
        for <linux-scsi@vger.kernel.org>; Wed, 05 Dec 2007 15:41:59 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20071204211701.994dfce6.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, hare@suse.de
Cc: linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

>  git-scsi-misc.patch

Apologies for not looking into the problem earlier. See
http://marc.info/?t=119628022300005&r=1&w=2
"2.6.24-rc3-mm2: Result: hostbyte=0x01 driverbyte=0x00\nend_request: I/O error"
for previous installment.

I've bisected it to the following patch in git-scsi-misc branch.
Revert on top of 2.6.24-rc4-mm1 also helps.

commit 8655a546c83fc43f0a73416bbd126d02de7ad6c0
Author: Hannes Reinecke <hare@suse.de>
Date:   Tue Nov 6 09:23:40 2007 +0100

    [SCSI] Do not requeue requests if REQ_FAILFAST is set
    
    Any requests with the REQ_FAILFAST flag set should not be requeued
    to the requeust queue, but rather terminated directly.
    Otherwise the multipath failover will stall until the command
    timeout triggers.
    
    Signed-off-by: Hannes Reinecke <hare@suse.de>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0f44bdb..0da0dd0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1286,6 +1286,11 @@ int scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
 			 */
 			if (!(req->cmd_flags & REQ_PREEMPT))
 				ret = BLKPREP_DEFER;
+			/*
+			 * Return failfast requests immediately
+			 */
+			if (req->cmd_flags & REQ_FAILFAST)
+				ret = BLKPREP_KILL;
 			break;
 		default:
 			/*
@@ -1414,6 +1419,17 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
 	return 1;
 }
 
+static void __scsi_kill_request(struct request *req)
+{
+	struct scsi_cmnd *cmd = req->special;
+	struct scsi_device *sdev = cmd->device;
+
+	cmd->result = DID_NO_CONNECT << 16;
+	atomic_inc(&cmd->device->iorequest_cnt);
+	sdev->device_busy--;
+	__scsi_done(cmd);
+}
+
 /*
  * Kill a request for a dead device
  */
@@ -1527,8 +1543,16 @@ static void scsi_request_fn(struct request_queue *q)
 		 * accept it.
 		 */
 		req = elv_next_request(q);
-		if (!req || !scsi_dev_queue_ready(q, sdev))
+		if (!req)
+			break;
+
+		if (!scsi_dev_queue_ready(q, sdev)) {
+			if (req->cmd_flags & REQ_FAILFAST) {
+				scsi_kill_request(req, q);
+				continue;
+			}
 			break;
+		}
 
 		if (unlikely(!scsi_device_online(sdev))) {
 			sdev_printk(KERN_ERR, sdev,
@@ -1609,8 +1633,12 @@ static void scsi_request_fn(struct request_queue *q)
 	 * later time.
 	 */
 	spin_lock_irq(q->queue_lock);
-	blk_requeue_request(q, req);
-	sdev->device_busy--;
+	if (unlikely(req->cmd_flags & REQ_FAILFAST))
+		__scsi_kill_request(req);
+	else {
+		blk_requeue_request(q, req);
+		sdev->device_busy--;
+	}
 	if(sdev->device_busy == 0)
 		blk_plug_device(q);
  out:
