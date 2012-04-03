From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] hpsa: use check_signature
Date: Tue,  3 Apr 2012 14:38:54 +0900
Message-ID: <1333431534-4595-4-git-send-email-akinobu.mita@gmail.com>
References: <1333431534-4595-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59525 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab2DCFie (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Apr 2012 01:38:34 -0400
In-Reply-To: <1333431534-4595-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Mike Miller <mike.miller@hp.com>, iss_storagedev@hp.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

Use check_signature to find a signature in the mmio address.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mike Miller <mike.miller@hp.com>
Cc: iss_storagedev@hp.com
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/hpsa.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ddbf5fe..c867eeb 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3839,10 +3839,7 @@ static void __devinit hpsa_find_board_params(struct ctlr_info *h)
 
 static inline bool hpsa_CISS_signature_present(struct ctlr_info *h)
 {
-	if ((readb(&h->cfgtable->Signature[0]) != 'C') ||
-	    (readb(&h->cfgtable->Signature[1]) != 'I') ||
-	    (readb(&h->cfgtable->Signature[2]) != 'S') ||
-	    (readb(&h->cfgtable->Signature[3]) != 'S')) {
+	if (!check_signature(h->cfgtable->Signature, "CISS", 4)) {
 		dev_warn(&h->pdev->dev, "not a valid CISS config table\n");
 		return false;
 	}
-- 
1.7.4.4

