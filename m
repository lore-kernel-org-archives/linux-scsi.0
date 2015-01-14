From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 32/48] hpsa: count passthru cmds with atomics,
 not a spin locked int
Date: Wed, 14 Jan 2015 16:02:27 -0600
Message-ID: <20150114220227.21325.45656.stgit@brunhilda>
References: <20150114215756.21325.41198.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:37806 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbbANWDN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 17:03:13 -0500
In-Reply-To: <20150114215756.21325.41198.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

Performance enhancement. Remove spin_locks from the driver.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   39 +++++----------------------------------
 drivers/scsi/hpsa.h |    3 +--
 2 files changed, 6 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 72abcf3..bae3759 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5105,35 +5105,6 @@ static void check_ioctl_unit_attention(struct ctlr_info *h,
 		(void) check_for_unit_attention(h, c);
 }
 
-static int increment_passthru_count(struct ctlr_info *h)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&h->passthru_count_lock, flags);
-	if (h->passthru_count >= HPSA_MAX_CONCURRENT_PASSTHRUS) {
-		spin_unlock_irqrestore(&h->passthru_count_lock, flags);
-		return -1;
-	}
-	h->passthru_count++;
-	spin_unlock_irqrestore(&h->passthru_count_lock, flags);
-	return 0;
-}
-
-static void decrement_passthru_count(struct ctlr_info *h)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&h->passthru_count_lock, flags);
-	if (h->passthru_count <= 0) {
-		spin_unlock_irqrestore(&h->passthru_count_lock, flags);
-		/* not expecting to get here. */
-		dev_warn(&h->pdev->dev, "Bug detected, passthru_count seems to be incorrect.\n");
-		return;
-	}
-	h->passthru_count--;
-	spin_unlock_irqrestore(&h->passthru_count_lock, flags);
-}
-
 /*
  * ioctl
  */
@@ -5156,16 +5127,16 @@ static int hpsa_ioctl(struct scsi_device *dev, int cmd, void __user *arg)
 	case CCISS_GETDRIVVER:
 		return hpsa_getdrivver_ioctl(h, argp);
 	case CCISS_PASSTHRU:
-		if (increment_passthru_count(h))
+		if (atomic_dec_if_positive(&h->passthru_cmds_avail) < 0)
 			return -EAGAIN;
 		rc = hpsa_passthru_ioctl(h, argp);
-		decrement_passthru_count(h);
+		atomic_inc(&h->passthru_cmds_avail);
 		return rc;
 	case CCISS_BIG_PASSTHRU:
-		if (increment_passthru_count(h))
+		if (atomic_dec_if_positive(&h->passthru_cmds_avail) < 0)
 			return -EAGAIN;
 		rc = hpsa_big_passthru_ioctl(h, argp);
-		decrement_passthru_count(h);
+		atomic_inc(&h->passthru_cmds_avail);
 		return rc;
 	default:
 		return -ENOTTY;
@@ -6852,7 +6823,7 @@ reinit_after_soft_reset:
 	spin_lock_init(&h->lock);
 	spin_lock_init(&h->offline_device_lock);
 	spin_lock_init(&h->scan_lock);
-	spin_lock_init(&h->passthru_count_lock);
+	atomic_set(&h->passthru_cmds_avail, HPSA_MAX_CONCURRENT_PASSTHRUS);
 
 	h->resubmit_wq = alloc_workqueue("hpsa", WQ_MEM_RECLAIM, 0);
 	if (!h->resubmit_wq) {
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 981479a..1856445 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -183,8 +183,7 @@ struct ctlr_info {
 
 	/* cap concurrent passthrus at some reasonable maximum */
 #define HPSA_MAX_CONCURRENT_PASSTHRUS (10)
-	spinlock_t passthru_count_lock; /* protects passthru_count */
-	int passthru_count;
+	atomic_t passthru_cmds_avail;
 
 	/*
 	 * Performant mode completion buffers

