From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 12/24] hpsa: factor out hpsa_p600_dma_prefetch_quirk
Date: Thu, 27 May 2010 15:13:43 -0500
Message-ID: <20100527201343.3116.82936.stgit@beardog.cce.hp.com>
References: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:30887 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab0E0UJE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 16:09:04 -0400
In-Reply-To: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, dab@hp.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: factor out hpsa_p600_dma_prefetch_quirk

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 84c0294..86da45b 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3404,6 +3404,20 @@ static inline void hpsa_enable_scsi_prefetch(struct ctlr_info *h)
 #endif
 }
 
+/* Disable DMA prefetch for the P600.  Otherwise an ASIC bug may result
+ * in a prefetch beyond physical memory.
+ */
+static inline void hpsa_p600_dma_prefetch_quirk(struct ctlr_info *h)
+{
+	u32 dma_prefetch;
+
+	if (h->board_id != 0x3225103C)
+		return;
+	dma_prefetch = readl(h->vaddr + I2O_DMA1_CFG);
+	dma_prefetch |= 0x8000;
+	writel(dma_prefetch, h->vaddr + I2O_DMA1_CFG);
+}
+
 static int __devinit hpsa_pci_init(struct ctlr_info *h)
 {
 	int i, prod_index, err;
@@ -3452,17 +3466,7 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
 		goto err_out_free_res;
 	}
 	hpsa_enable_scsi_prefetch(h);
-
-	/* Disabling DMA prefetch for the P600
-	 * An ASIC bug may result in a prefetch beyond
-	 * physical memory.
-	 */
-	if (h->board_id == 0x3225103C) {
-		u32 dma_prefetch;
-		dma_prefetch = readl(h->vaddr + I2O_DMA1_CFG);
-		dma_prefetch |= 0x8000;
-		writel(dma_prefetch, h->vaddr + I2O_DMA1_CFG);
-	}
+	hpsa_p600_dma_prefetch_quirk(h);
 
 	h->max_commands = readl(&(h->cfgtable->CmdsOutMax));
 	/* Update the field, and then ring the doorbell */

