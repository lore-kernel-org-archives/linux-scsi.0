From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 09/24] hpsa: hpsa factor out hpsa_find_board_params
Date: Thu, 27 May 2010 15:13:27 -0500
Message-ID: <20100527201327.3116.43162.stgit@beardog.cce.hp.com>
References: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:40584 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759203Ab0E0UIs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 16:08:48 -0400
In-Reply-To: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, dab@hp.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: hpsa factor out hpsa_find_board_params

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   46 +++++++++++++++++++++++++---------------------
 1 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3745047..b69eaad 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3356,6 +3356,30 @@ static int __devinit hpsa_find_cfgtables(struct ctlr_info *h)
 	return 0;
 }
 
+/* Interrogate the hardware for some limits:
+ * max commands, max SG elements without chaining, and with chaining,
+ * SG chain block size, etc.
+ */
+static void __devinit hpsa_find_board_params(struct ctlr_info *h)
+{
+	h->max_commands = readl(&(h->cfgtable->MaxPerformantModeCommands));
+	h->nr_cmds = h->max_commands - 4; /* Allow room for some ioctls */
+	h->maxsgentries = readl(&(h->cfgtable->MaxScatterGatherElements));
+	/*
+	 * Limit in-command s/g elements to 32 save dma'able memory.
+	 * Howvever spec says if 0, use 31
+	 */
+	h->max_cmd_sg_entries = 31;
+	if (h->maxsgentries > 512) {
+		h->max_cmd_sg_entries = 32;
+		h->chainsize = h->maxsgentries - h->max_cmd_sg_entries + 1;
+		h->maxsgentries--; /* save one for chain pointer */
+	} else {
+		h->maxsgentries = 31; /* default to traditional values */
+		h->chainsize = 0;
+	}
+}
+
 static int __devinit hpsa_pci_init(struct ctlr_info *h)
 {
 	int i, prod_index, err;
@@ -3397,27 +3421,7 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
 	err = hpsa_find_cfgtables(h);
 	if (err)
 		goto err_out_free_res;
-
-	h->max_commands = readl(&(h->cfgtable->MaxPerformantModeCommands));
-	h->maxsgentries = readl(&(h->cfgtable->MaxScatterGatherElements));
-
-	/*
-	 * Limit in-command s/g elements to 32 save dma'able memory.
-	 * Howvever spec says if 0, use 31
-	 */
-
-	h->max_cmd_sg_entries = 31;
-	if (h->maxsgentries > 512) {
-		h->max_cmd_sg_entries = 32;
-		h->chainsize = h->maxsgentries - h->max_cmd_sg_entries + 1;
-		h->maxsgentries--; /* save one for chain pointer */
-	} else {
-		h->maxsgentries = 31; /* default to traditional values */
-		h->chainsize = 0;
-	}
-
-	/* Allow room for some ioctls */
-	h->nr_cmds = h->max_commands - 4;
+	hpsa_find_board_params(h);
 
 	if ((readb(&h->cfgtable->Signature[0]) != 'C') ||
 	    (readb(&h->cfgtable->Signature[1]) != 'I') ||

