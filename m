From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 05/11] libfc: Move host_lock usage into ramp_up/down routines
Date: Fri, 01 Apr 2011 16:06:14 -0700
Message-ID: <20110401230614.15001.77059.stgit@localhost6.localdomain6>
References: <20110401230548.15001.2009.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:17623 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091Ab1DAXGP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2011 19:06:15 -0400
In-Reply-To: <20110401230548.15001.2009.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>

The host_lock is still used to protect the can_queue
value in the Scsi_Host, but it doesn't need to be held
and released by each caller. This patch moves the lock
usage into the fc_fcp_can_queue_ramp_up and
fc_fcp_can_queue_ramp_down routines.

Signed-off-by: Robert Love <robert.w.love@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index b1b03af..92ba9f0 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -335,22 +335,23 @@ static void fc_fcp_ddp_done(struct fc_fcp_pkt *fsp)
 /**
  * fc_fcp_can_queue_ramp_up() - increases can_queue
  * @lport: lport to ramp up can_queue
- *
- * Locking notes: Called with Scsi_Host lock held
  */
 static void fc_fcp_can_queue_ramp_up(struct fc_lport *lport)
 {
 	struct fc_fcp_internal *si = fc_get_scsi_internal(lport);
+	unsigned long flags;
 	int can_queue;
 
+	spin_lock_irqsave(lport->host->host_lock, flags);
+
 	if (si->last_can_queue_ramp_up_time &&
 	    (time_before(jiffies, si->last_can_queue_ramp_up_time +
 			 FC_CAN_QUEUE_PERIOD)))
-		return;
+		goto unlock;
 
 	if (time_before(jiffies, si->last_can_queue_ramp_down_time +
 			FC_CAN_QUEUE_PERIOD))
-		return;
+		goto unlock;
 
 	si->last_can_queue_ramp_up_time = jiffies;
 
@@ -362,6 +363,9 @@ static void fc_fcp_can_queue_ramp_up(struct fc_lport *lport)
 	lport->host->can_queue = can_queue;
 	shost_printk(KERN_ERR, lport->host, "libfc: increased "
 		     "can_queue to %d.\n", can_queue);
+
+unlock:
+	spin_unlock_irqrestore(lport->host->host_lock, flags);
 }
 
 /**
@@ -373,18 +377,19 @@ static void fc_fcp_can_queue_ramp_up(struct fc_lport *lport)
  * commands complete or timeout, then try again with a reduced
  * can_queue. Eventually we will hit the point where we run
  * on all reserved structs.
- *
- * Locking notes: Called with Scsi_Host lock held
  */
 static void fc_fcp_can_queue_ramp_down(struct fc_lport *lport)
 {
 	struct fc_fcp_internal *si = fc_get_scsi_internal(lport);
+	unsigned long flags;
 	int can_queue;
 
+	spin_lock_irqsave(lport->host->host_lock, flags);
+
 	if (si->last_can_queue_ramp_down_time &&
 	    (time_before(jiffies, si->last_can_queue_ramp_down_time +
 			 FC_CAN_QUEUE_PERIOD)))
-		return;
+		goto unlock;
 
 	si->last_can_queue_ramp_down_time = jiffies;
 
@@ -395,6 +400,9 @@ static void fc_fcp_can_queue_ramp_down(struct fc_lport *lport)
 	lport->host->can_queue = can_queue;
 	shost_printk(KERN_ERR, lport->host, "libfc: Could not allocate frame.\n"
 		     "Reducing can_queue to %d.\n", can_queue);
+
+unlock:
+	spin_unlock_irqrestore(lport->host->host_lock, flags);
 }
 
 /*
@@ -409,16 +417,13 @@ static inline struct fc_frame *fc_fcp_frame_alloc(struct fc_lport *lport,
 						  size_t len)
 {
 	struct fc_frame *fp;
-	unsigned long flags;
 
 	fp = fc_frame_alloc(lport, len);
 	if (likely(fp))
 		return fp;
 
 	/* error case */
-	spin_lock_irqsave(lport->host->host_lock, flags);
 	fc_fcp_can_queue_ramp_down(lport);
-	spin_unlock_irqrestore(lport->host->host_lock, flags);
 	return NULL;
 }
 

