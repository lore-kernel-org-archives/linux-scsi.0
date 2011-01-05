From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 4/8] BNX2I: Added support for the 57712(E) devices
Date: Wed, 5 Jan 2011 12:44:23 -0800
Message-ID: <1294260267-17413-5-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1862 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916Ab1AEUl6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2011 15:41:58 -0500
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Moved all PCI_DEVICE_ID_NX2_57712(E) definitions to pci_ids.h

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Acked-by: Michael Chan <mchan@broadcom.com>
Acked-by: Eilon Greenstein <eilong@broadcom.com>
---
 drivers/net/bnx2x/bnx2x_main.c  |    7 -------
 drivers/scsi/bnx2i/bnx2i_init.c |   10 ++++++----
 include/linux/pci_ids.h         |    2 ++
 3 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/bnx2x/bnx2x_main.c b/drivers/net/bnx2x/bnx2x_main.c
index ff99a2f..3efacfa 100644
--- a/drivers/net/bnx2x/bnx2x_main.c
+++ b/drivers/net/bnx2x/bnx2x_main.c
@@ -140,13 +140,6 @@ static struct {
 	{ "Broadcom NetXtreme II BCM57712E XGb" }
 };
 
-#ifndef PCI_DEVICE_ID_NX2_57712
-#define PCI_DEVICE_ID_NX2_57712		0x1662
-#endif
-#ifndef PCI_DEVICE_ID_NX2_57712E
-#define PCI_DEVICE_ID_NX2_57712E	0x1663
-#endif
-
 static DEFINE_PCI_DEVICE_TABLE(bnx2x_pci_tbl) = {
 	{ PCI_VDEVICE(BROADCOM, PCI_DEVICE_ID_NX2_57710), BCM57710 },
 	{ PCI_VDEVICE(BROADCOM, PCI_DEVICE_ID_NX2_57711), BCM57711 },
diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 6afaa34..5ef01c9 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -29,7 +29,7 @@ static char version[] __devinitdata =
 MODULE_AUTHOR("Anil Veerabhadrappa <anilgv@broadcom.com> and "
 	      "Eddie Wai <eddie.wai@broadcom.com>");
 
-MODULE_DESCRIPTION("Broadcom NetXtreme II BCM5706/5708/5709/57710/57711"
+MODULE_DESCRIPTION("Broadcom NetXtreme II BCM5706/5708/5709/57710/57711/57712"
 		   " iSCSI Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_MODULE_VERSION);
@@ -88,9 +88,11 @@ void bnx2i_identify_device(struct bnx2i_hba *hba)
 	    (hba->pci_did == PCI_DEVICE_ID_NX2_5709S)) {
 		set_bit(BNX2I_NX2_DEV_5709, &hba->cnic_dev_type);
 		hba->mail_queue_access = BNX2I_MQ_BIN_MODE;
-	} else if (hba->pci_did == PCI_DEVICE_ID_NX2_57710 ||
-		   hba->pci_did == PCI_DEVICE_ID_NX2_57711 ||
-		   hba->pci_did == PCI_DEVICE_ID_NX2_57711E)
+	} else if (hba->pci_did == PCI_DEVICE_ID_NX2_57710  ||
+		   hba->pci_did == PCI_DEVICE_ID_NX2_57711  ||
+		   hba->pci_did == PCI_DEVICE_ID_NX2_57711E ||
+		   hba->pci_did == PCI_DEVICE_ID_NX2_57712  ||
+		   hba->pci_did == PCI_DEVICE_ID_NX2_57712E)
 		set_bit(BNX2I_NX2_DEV_57710, &hba->cnic_dev_type);
 	else
 		printk(KERN_ALERT "bnx2i: unknown device, 0x%x\n",
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index d278dd9..6487382 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2067,6 +2067,8 @@
 #define PCI_DEVICE_ID_TIGON3_5723	0x165b
 #define PCI_DEVICE_ID_TIGON3_5705M	0x165d
 #define PCI_DEVICE_ID_TIGON3_5705M_2	0x165e
+#define PCI_DEVICE_ID_NX2_57712		0x1662
+#define PCI_DEVICE_ID_NX2_57712E	0x1663
 #define PCI_DEVICE_ID_TIGON3_5714	0x1668
 #define PCI_DEVICE_ID_TIGON3_5714S	0x1669
 #define PCI_DEVICE_ID_TIGON3_5780	0x166a
-- 
1.7.0.5


