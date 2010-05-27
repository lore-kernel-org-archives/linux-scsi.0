From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 17/24] hpsa: factor out hpsa_wait_for_mode_change_ack
Date: Thu, 27 May 2010 15:14:08 -0500
Message-ID: <20100527201408.3116.98563.stgit@beardog.cce.hp.com>
References: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:40762 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab0E0UJ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 16:09:29 -0400
In-Reply-To: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, dab@hp.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: factor out hpsa_wait_for_mode_change_ack

Signed-off-by:  Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   40 +++++++++++++++++-----------------------
 1 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a43f3cb..052f0a4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3418,19 +3418,9 @@ static inline void hpsa_p600_dma_prefetch_quirk(struct ctlr_info *h)
 	writel(dma_prefetch, h->vaddr + I2O_DMA1_CFG);
 }
 
-static int __devinit hpsa_enter_simple_mode(struct ctlr_info *h)
+static void __devinit hpsa_wait_for_mode_change_ack(struct ctlr_info *h)
 {
 	int i;
-	u32 trans_support;
-
-	trans_support = readl(&(h->cfgtable->TransportSupport));
-	if (!(trans_support & SIMPLE_MODE))
-		return -ENOTSUPP;
-
-	h->max_commands = readl(&(h->cfgtable->CmdsOutMax));
-	/* Update the field, and then ring the doorbell */
-	writel(CFGTBL_Trans_Simple, &(h->cfgtable->HostWrite.TransportRequest));
-	writel(CFGTBL_ChangeReq, h->vaddr + SA5_DOORBELL);
 
 	/* under certain very rare conditions, this can take awhile.
 	 * (e.g.: hot replace a failed 144GB drive in a RAID 5 set right
@@ -3442,6 +3432,21 @@ static int __devinit hpsa_enter_simple_mode(struct ctlr_info *h)
 		/* delay and try again */
 		msleep(10);
 	}
+}
+
+static int __devinit hpsa_enter_simple_mode(struct ctlr_info *h)
+{
+	u32 trans_support;
+
+	trans_support = readl(&(h->cfgtable->TransportSupport));
+	if (!(trans_support & SIMPLE_MODE))
+		return -ENOTSUPP;
+
+	h->max_commands = readl(&(h->cfgtable->CmdsOutMax));
+	/* Update the field, and then ring the doorbell */
+	writel(CFGTBL_Trans_Simple, &(h->cfgtable->HostWrite.TransportRequest));
+	writel(CFGTBL_ChangeReq, h->vaddr + SA5_DOORBELL);
+	hpsa_wait_for_mode_change_ack(h);
 	print_cfg_table(&h->pdev->dev, h->cfgtable);
 	if (!(readl(&(h->cfgtable->TransportActive)) & CFGTBL_Trans_Simple)) {
 		dev_warn(&h->pdev->dev,
@@ -3822,7 +3827,6 @@ static __devinit void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 	 */
 	int bft[8] = {5, 6, 8, 10, 12, 20, 28, 35}; /* for scatter/gathers */
 	int i = 0;
-	int l = 0;
 	unsigned long register_value;
 
 	trans_support = readl(&(h->cfgtable->TransportSupport));
@@ -3866,17 +3870,7 @@ static __devinit void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 	writel(CFGTBL_Trans_Performant,
 		&(h->cfgtable->HostWrite.TransportRequest));
 	writel(CFGTBL_ChangeReq, h->vaddr + SA5_DOORBELL);
-	/* under certain very rare conditions, this can take awhile.
-	 * (e.g.: hot replace a failed 144GB drive in a RAID 5 set right
-	 * as we enter this code.) */
-	for (l = 0; l < MAX_CONFIG_WAIT; l++) {
-		register_value = readl(h->vaddr + SA5_DOORBELL);
-		if (!(register_value & CFGTBL_ChangeReq))
-			break;
-		/* delay and try again */
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(10);
-	}
+	hpsa_wait_for_mode_change_ack(h);
 	register_value = readl(&(h->cfgtable->TransportActive));
 	if (!(register_value & CFGTBL_Trans_Performant)) {
 		dev_warn(&h->pdev->dev, "unable to get board into"

