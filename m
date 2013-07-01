From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/7] dpt_i2o: Remove DPTI_STATE_IOCTL
Date: Mon,  1 Jul 2013 08:50:49 +0200
Message-ID: <1372661455-122384-2-git-send-email-hare@suse.de>
References: <1372661455-122384-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42507 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734Ab3GAGvD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Jul 2013 02:51:03 -0400
In-Reply-To: <1372661455-122384-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Bart van Assche <bvanassche@acm.org>, Joern Engel <joern@logfs.org>, Hannes Reinecke <hare@suse.de>

scsi_block_host/scsi_unlock_host provides the required
functionality.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/dpt_i2o.c | 30 ++++++++++++------------------
 drivers/scsi/dpti.h    |  1 -
 2 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 19e1b42..106ff1a 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -448,15 +448,7 @@ static int adpt_queue_lck(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd
 	}
 
 	rmb();
-	/*
-	 * TODO: I need to block here if I am processing ioctl cmds
-	 * but if the outstanding cmds all finish before the ioctl,
-	 * the scsi-core will not know to start sending cmds to me again.
-	 * I need to a way to restart the scsi-cores queues or should I block
-	 * calling scsi_done on the outstanding cmds instead
-	 * for now we don't set the IOCTL state
-	 */
-	if(((pHba->state) & DPTI_STATE_IOCTL) || ((pHba->state) & DPTI_STATE_RESET)) {
+	if((pHba->state) & DPTI_STATE_RESET) {
 		pHba->host->last_reset = jiffies;
 		pHba->host->resetting = 1;
 		return 1;
@@ -1811,21 +1803,23 @@ static int adpt_i2o_passthru(adpt_hba* pHba, u32 __user *arg)
 	}
 
 	do {
-		if(pHba->host)
+		/*
+		 * Stop any new commands from enterring the
+		 * controller while processing the ioctl
+		 */
+		if(pHba->host) {
+			scsi_block_requests(pHba->host);
 			spin_lock_irqsave(pHba->host->host_lock, flags);
-		// This state stops any new commands from enterring the
-		// controller while processing the ioctl
-//		pHba->state |= DPTI_STATE_IOCTL;
-//		We can't set this now - The scsi subsystem sets host_blocked and
-//		the queue empties and stops.  We need a way to restart the queue
+		}
 		rcode = adpt_i2o_post_wait(pHba, msg, size, FOREVER);
 		if (rcode != 0)
 			printk("adpt_i2o_passthru: post wait failed %d %p\n",
 					rcode, reply);
-//		pHba->state &= ~DPTI_STATE_IOCTL;
-		if(pHba->host)
+		if(pHba->host) {
 			spin_unlock_irqrestore(pHba->host->host_lock, flags);
-	} while(rcode == -ETIMEDOUT);  
+			scsi_unblock_requests(pHba->host);
+		}
+	} while(rcode == -ETIMEDOUT);
 
 	if(rcode){
 		goto cleanup;
diff --git a/drivers/scsi/dpti.h b/drivers/scsi/dpti.h
index beded71..aeb0461 100644
--- a/drivers/scsi/dpti.h
+++ b/drivers/scsi/dpti.h
@@ -202,7 +202,6 @@ struct adpt_channel {
 
 // HBA state flags
 #define DPTI_STATE_RESET	(0x01)
-#define DPTI_STATE_IOCTL	(0x02)
 
 typedef struct _adpt_hba {
 	struct _adpt_hba *next;
-- 
1.7.12.4

