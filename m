From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 08/11] hpsa: cap CCISS_PASSTHRU at 20 concurrent commands.
Date: Thu, 07 Nov 2013 10:46:05 -0600
Message-ID: <20131107164605.3504.51938.stgit@beardog.cce.hp.com>
References: <20131107164258.3504.5892.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:13948 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab3KGQqG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2013 11:46:06 -0500
In-Reply-To: <20131107164258.3504.5892.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Cap CCISS_BIG_PASSTHRU as well.  If an attempt is made
to exceed this, ioctl() will return -1 with errno == EAGAIN.

This is to prevent a userland program from exhausting all of
pci_alloc_consistent memory.  I've only seen this problem when
running a special test program designed to provoke it.  20
concurrent commands via the passthru ioctls (not counting SG_IO)
should be more than enough.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   44 ++++++++++++++++++++++++++++++++++++++++++--
 drivers/scsi/hpsa.h |    5 +++++
 2 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index fdc2228..ebb7144 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3218,6 +3218,36 @@ static void check_ioctl_unit_attention(struct ctlr_info *h,
 			c->err_info->ScsiStatus != SAM_STAT_CHECK_CONDITION)
 		(void) check_for_unit_attention(h, c);
 }
+
+static int increment_passthru_count(struct ctlr_info *h)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&h->passthru_count_lock, flags);
+	if (h->passthru_count >= HPSA_MAX_CONCURRENT_PASSTHRUS) {
+		spin_unlock_irqrestore(&h->passthru_count_lock, flags);
+		return -1;
+	}
+	h->passthru_count++;
+	spin_unlock_irqrestore(&h->passthru_count_lock, flags);
+	return 0;
+}
+
+static void decrement_passthru_count(struct ctlr_info *h)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&h->passthru_count_lock, flags);
+	if (h->passthru_count <= 0) {
+		spin_unlock_irqrestore(&h->passthru_count_lock, flags);
+		/* not expecting to get here. */
+		dev_warn(&h->pdev->dev, "Bug detected, passthru_count seems to be incorrect.\n");
+		return;
+	}
+	h->passthru_count--;
+	spin_unlock_irqrestore(&h->passthru_count_lock, flags);
+}
+
 /*
  * ioctl
  */
@@ -3225,6 +3255,7 @@ static int hpsa_ioctl(struct scsi_device *dev, int cmd, void *arg)
 {
 	struct ctlr_info *h;
 	void __user *argp = (void __user *)arg;
+	int rc;
 
 	h = sdev_to_hba(dev);
 
@@ -3239,9 +3270,17 @@ static int hpsa_ioctl(struct scsi_device *dev, int cmd, void *arg)
 	case CCISS_GETDRIVVER:
 		return hpsa_getdrivver_ioctl(h, argp);
 	case CCISS_PASSTHRU:
-		return hpsa_passthru_ioctl(h, argp);
+		if (increment_passthru_count(h))
+			return -EAGAIN;
+		rc = hpsa_passthru_ioctl(h, argp);
+		decrement_passthru_count(h);
+		return rc;
 	case CCISS_BIG_PASSTHRU:
-		return hpsa_big_passthru_ioctl(h, argp);
+		if (increment_passthru_count(h))
+			return -EAGAIN;
+		rc = hpsa_big_passthru_ioctl(h, argp);
+		decrement_passthru_count(h);
+		return rc;
 	default:
 		return -ENOTTY;
 	}
@@ -4772,6 +4811,7 @@ reinit_after_soft_reset:
 	INIT_LIST_HEAD(&h->reqQ);
 	spin_lock_init(&h->lock);
 	spin_lock_init(&h->scan_lock);
+	spin_lock_init(&h->passthru_count_lock);
 	rc = hpsa_pci_init(h);
 	if (rc != 0)
 		goto clean1;
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index b48f1de..fd9910a 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -114,6 +114,11 @@ struct ctlr_info {
 	struct TransTable_struct *transtable;
 	unsigned long transMethod;
 
+	/* cap concurrent passthrus at some reasonable maximum */
+#define HPSA_MAX_CONCURRENT_PASSTHRUS (20)
+	spinlock_t passthru_count_lock; /* protects passthru_count */
+	int passthru_count;
+
 	/*
 	 * Performant mode completion buffers
 	 */

