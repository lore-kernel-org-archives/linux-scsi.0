From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 05/10] aacraid: Disable MSI mode for series 6, 7, 8 cards
Date: Mon, 25 Apr 2016 23:31:43 -0700
Message-ID: <20160426063143.28402.72576.stgit@pmcuser-System-Product-Name>
References: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0090.outbound.protection.outlook.com ([207.46.100.90]:23712
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752516AbcDZGgJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2016 02:36:09 -0400
In-Reply-To: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc: aacraid@pmc-sierra.com, gana.sridaran@microsemi.com, scott.benesh@microsemi.com, vishal.josemannanal@microsemi.com, RaghavaAditya.Renukunta@microsemi.com

As the firmware for series 6, 7, 8 cards does not support msi, remove it
in the driver

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/comminit.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 35697c1..50d521a 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -378,21 +378,8 @@ void aac_define_int_mode(struct aac_dev *dev)
 			msi_count = i;
 		} else {
 			dev->msi_enabled = 0;
-			printk(KERN_ERR "%s%d: MSIX not supported!! Will try MSI 0x%x.\n",
-					dev->name, dev->id, i);
-		}
-	}
-
-	if (!dev->msi_enabled) {
-		msi_count = 1;
-		i = pci_enable_msi(dev->pdev);
-
-		if (!i) {
-			dev->msi_enabled = 1;
-			dev->msi = 1;
-		} else {
-			printk(KERN_ERR "%s%d: MSI not supported!! Will try INTx 0x%x.\n",
-					dev->name, dev->id, i);
+			dev_err(&dev->pdev->dev,
+			"MSIX not supported!! Will try INTX 0x%x.\n", i);
 		}
 	}
 

