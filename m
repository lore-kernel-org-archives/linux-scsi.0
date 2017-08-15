From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 6/6] hpsa: Remove 'hpsa_allow_any' module option
Date: Tue, 15 Aug 2017 08:58:09 +0200
Message-ID: <1502780289-127133-7-git-send-email-hare@suse.de>
References: <1502780289-127133-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60911 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752494AbdHOG6O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Aug 2017 02:58:14 -0400
In-Reply-To: <1502780289-127133-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

As the cciss driver has been removed there are no overlapping
PCI IDs anymore, and the 'hpsa_allow_any' flag can be removed.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hpsa.c | 26 +++++++-------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c633b35..2773dd7 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -83,10 +83,6 @@
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("cciss");
 
-static int hpsa_allow_any;
-module_param(hpsa_allow_any, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(hpsa_allow_any,
-		"Allow hpsa driver to access unknown HP Smart Array hardware");
 static int hpsa_simple_mode;
 module_param(hpsa_simple_mode, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(hpsa_simple_mode,
@@ -7299,23 +7295,15 @@ static int hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id,
 			if (products[i].access != &SA5A_access &&
 			    products[i].access != &SA5B_access)
 				return i;
-			if (hpsa_allow_any) {
-				dev_warn(&pdev->dev,
-					 "legacy board ID: 0x%08x\n",
-					 *board_id);
-				if (legacy_board)
-					*legacy_board = true;
-				return i;
-			}
+			dev_warn(&pdev->dev,
+				 "legacy board ID: 0x%08x\n",
+				 *board_id);
+			if (legacy_board)
+			    *legacy_board = true;
+			return i;
 		}
 
-	if ((subsystem_vendor_id != PCI_VENDOR_ID_HP &&
-		subsystem_vendor_id != PCI_VENDOR_ID_COMPAQ) ||
-		!hpsa_allow_any) {
-		dev_warn(&pdev->dev, "unrecognized board ID: "
-			"0x%08x, ignoring.\n", *board_id);
-			return -ENODEV;
-	}
+	dev_warn(&pdev->dev, "unrecognized board ID: 0x%08x\n", *board_id);
 	if (legacy_board)
 		*legacy_board = true;
 	return ARRAY_SIZE(products) - 1; /* generic unknown smart array */
-- 
1.8.5.6
