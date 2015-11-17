From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 42/52] atp870u: Improve unsupported chip detection
Date: Tue, 17 Nov 2015 19:24:18 +0100
Message-ID: <1447784668-23713-43-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56523 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611AbbKQSgq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:36:46 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index d0119f1..128613e 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1252,6 +1252,11 @@ static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	unsigned char setupdata[2][16];
 	int err;
 
+	if (ent->device == PCI_DEVICE_ID_ARTOP_AEC7610 && pdev->revision < 2) {
+		dev_err(&pdev->dev, "ATP850S chips (AEC6710L/F cards) are not supported.\n");
+		return -ENODEV;
+	}
+
 	err = pci_enable_device(pdev);
 	if (err)
 		goto fail;
@@ -1273,19 +1278,10 @@ static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	atpdev->pdev = pdev;
 	pci_set_drvdata(pdev, atpdev);
 
-	/*
-	 * It's probably easier to weed out some revisions like
-	 * this than via the PCI device table
-	 */
-	if (ent->device == PCI_DEVICE_ID_ARTOP_AEC7610) {
-		atpdev->chip_ver = pdev->revision;
-		if (atpdev->chip_ver < 2) {
-			err = -ENODEV;
-			goto unregister;
-		}
-	}
-
 	switch (ent->device) {
+	case PCI_DEVICE_ID_ARTOP_AEC7610:
+		atpdev->chip_ver = pdev->revision;
+		break;
 	case PCI_DEVICE_ID_ARTOP_AEC7612UW:
 	case PCI_DEVICE_ID_ARTOP_AEC7612SUW:
 	case ATP880_DEVID1:	
-- 
Ondrej Zary

