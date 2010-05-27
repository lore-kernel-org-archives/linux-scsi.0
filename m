From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 11/24] hpsa: factor out hpsa_enable_scsi_prefetch
Date: Thu, 27 May 2010 15:13:38 -0500
Message-ID: <20100527201338.3116.67058.stgit@beardog.cce.hp.com>
References: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:40633 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab0E0UI7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 16:08:59 -0400
In-Reply-To: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, dab@hp.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: factor out hpsa_enable_scsi_prefetch

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 35b47ba..84c0294 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3392,6 +3392,18 @@ static inline bool hpsa_CISS_signature_present(struct ctlr_info *h)
 	return true;
 }
 
+/* Need to enable prefetch in the SCSI core for 6400 in x86 */
+static inline void hpsa_enable_scsi_prefetch(struct ctlr_info *h)
+{
+#ifdef CONFIG_X86
+	u32 prefetch;
+
+	prefetch = readl(&(h->cfgtable->SCSI_Prefetch));
+	prefetch |= 0x100;
+	writel(prefetch, &(h->cfgtable->SCSI_Prefetch));
+#endif
+}
+
 static int __devinit hpsa_pci_init(struct ctlr_info *h)
 {
 	int i, prod_index, err;
@@ -3439,15 +3451,7 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
 		err = -ENODEV;
 		goto err_out_free_res;
 	}
-#ifdef CONFIG_X86
-	{
-		/* Need to enable prefetch in the SCSI core for 6400 in x86 */
-		u32 prefetch;
-		prefetch = readl(&(h->cfgtable->SCSI_Prefetch));
-		prefetch |= 0x100;
-		writel(prefetch, &(h->cfgtable->SCSI_Prefetch));
-	}
-#endif
+	hpsa_enable_scsi_prefetch(h);
 
 	/* Disabling DMA prefetch for the P600
 	 * An ASIC bug may result in a prefetch beyond

