From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 13/24] hpsa: factor out hpsa_enter_simple_mode
Date: Thu, 27 May 2010 15:13:48 -0500
Message-ID: <20100527201348.3116.28176.stgit@beardog.cce.hp.com>
References: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:7041 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757570Ab0E0UJJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 16:09:09 -0400
In-Reply-To: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, dab@hp.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: factor out hpsa_enter_simple_mode

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   62 +++++++++++++++++++++++++++++----------------------
 1 files changed, 35 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 86da45b..bb1b86e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3418,9 +3418,41 @@ static inline void hpsa_p600_dma_prefetch_quirk(struct ctlr_info *h)
 	writel(dma_prefetch, h->vaddr + I2O_DMA1_CFG);
 }
 
+static int __devinit hpsa_enter_simple_mode(struct ctlr_info *h)
+{
+	int i;
+
+	h->max_commands = readl(&(h->cfgtable->CmdsOutMax));
+	/* Update the field, and then ring the doorbell */
+	writel(CFGTBL_Trans_Simple, &(h->cfgtable->HostWrite.TransportRequest));
+	writel(CFGTBL_ChangeReq, h->vaddr + SA5_DOORBELL);
+
+	/* under certain very rare conditions, this can take awhile.
+	 * (e.g.: hot replace a failed 144GB drive in a RAID 5 set right
+	 * as we enter this code.)
+	 */
+	for (i = 0; i < MAX_CONFIG_WAIT; i++) {
+		if (!(readl(h->vaddr + SA5_DOORBELL) & CFGTBL_ChangeReq))
+			break;
+		/* delay and try again */
+		msleep(10);
+	}
+
+#ifdef HPSA_DEBUG
+	print_cfg_table(&h->pdev->dev, h->cfgtable);
+#endif				/* HPSA_DEBUG */
+
+	if (!(readl(&(h->cfgtable->TransportActive)) & CFGTBL_Trans_Simple)) {
+		dev_warn(&h->pdev->dev,
+			"unable to get board into simple mode\n");
+		return -ENODEV;
+	}
+	return 0;
+}
+
 static int __devinit hpsa_pci_init(struct ctlr_info *h)
 {
-	int i, prod_index, err;
+	int prod_index, err;
 
 	prod_index = hpsa_lookup_board_id(h->pdev, &h->board_id);
 	if (prod_index < 0)
@@ -3467,33 +3499,9 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
 	}
 	hpsa_enable_scsi_prefetch(h);
 	hpsa_p600_dma_prefetch_quirk(h);
-
-	h->max_commands = readl(&(h->cfgtable->CmdsOutMax));
-	/* Update the field, and then ring the doorbell */
-	writel(CFGTBL_Trans_Simple, &(h->cfgtable->HostWrite.TransportRequest));
-	writel(CFGTBL_ChangeReq, h->vaddr + SA5_DOORBELL);
-
-	/* under certain very rare conditions, this can take awhile.
-	 * (e.g.: hot replace a failed 144GB drive in a RAID 5 set right
-	 * as we enter this code.)
-	 */
-	for (i = 0; i < MAX_CONFIG_WAIT; i++) {
-		if (!(readl(h->vaddr + SA5_DOORBELL) & CFGTBL_ChangeReq))
-			break;
-		/* delay and try again */
-		msleep(10);
-	}
-
-#ifdef HPSA_DEBUG
-	print_cfg_table(&h->pdev->dev, h->cfgtable);
-#endif				/* HPSA_DEBUG */
-
-	if (!(readl(&(h->cfgtable->TransportActive)) & CFGTBL_Trans_Simple)) {
-		dev_warn(&h->pdev->dev,
-			"unable to get board into simple mode\n");
-		err = -ENODEV;
+	err = hpsa_enter_simple_mode(h);
+	if (err)
 		goto err_out_free_res;
-	}
 	return 0;
 
 err_out_free_res:

