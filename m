From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 10/24] hpsa: factor out hpsa-CISS-signature-present
Date: Thu, 27 May 2010 15:13:32 -0500
Message-ID: <20100527201332.3116.82724.stgit@beardog.cce.hp.com>
References: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:40607 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab0E0UIy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 16:08:54 -0400
In-Reply-To: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, dab@hp.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: factor out hpsa-CISS-signature-present

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b69eaad..35b47ba 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3380,6 +3380,18 @@ static void __devinit hpsa_find_board_params(struct ctlr_info *h)
 	}
 }
 
+static inline bool hpsa_CISS_signature_present(struct ctlr_info *h)
+{
+	if ((readb(&h->cfgtable->Signature[0]) != 'C') ||
+	    (readb(&h->cfgtable->Signature[1]) != 'I') ||
+	    (readb(&h->cfgtable->Signature[2]) != 'S') ||
+	    (readb(&h->cfgtable->Signature[3]) != 'S')) {
+		dev_warn(&h->pdev->dev, "not a valid CISS config table\n");
+		return false;
+	}
+	return true;
+}
+
 static int __devinit hpsa_pci_init(struct ctlr_info *h)
 {
 	int i, prod_index, err;
@@ -3423,11 +3435,7 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
 		goto err_out_free_res;
 	hpsa_find_board_params(h);
 
-	if ((readb(&h->cfgtable->Signature[0]) != 'C') ||
-	    (readb(&h->cfgtable->Signature[1]) != 'I') ||
-	    (readb(&h->cfgtable->Signature[2]) != 'S') ||
-	    (readb(&h->cfgtable->Signature[3]) != 'S')) {
-		dev_warn(&h->pdev->dev, "not a valid CISS config table\n");
+	if (!hpsa_CISS_signature_present(h)) {
 		err = -ENODEV;
 		goto err_out_free_res;
 	}

