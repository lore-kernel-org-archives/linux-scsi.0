From: michaelc@cs.wisc.edu
Subject: [PATCH 04/17] BNX2I: Added support for the 57712(E) devices
Date: Wed, 16 Feb 2011 15:04:28 -0600
Message-ID: <1297890281-9076-5-git-send-email-michaelc@cs.wisc.edu>
References: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406Ab1BPVEd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2011 16:04:33 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1GL4Xv4021079
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:33 -0500
Received: from meanminna.corp.redhat.com (vpn-11-254.rdu.redhat.com [10.11.11.254])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1GL4Tsr004636
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:33 -0500
In-Reply-To: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Eddie Wai <eddie.wai@broadcom.com>

Moved all PCI_DEVICE_ID_NX2_57712(E) definitions to pci_ids.h

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Acked-by: Michael Chan <mchan@broadcom.com>
Acked-by: Eilon Greenstein <eilong@broadcom.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/net/bnx2x/bnx2x_main.c  |    7 -------
 drivers/scsi/bnx2i/bnx2i_init.c |   10 ++++++----
 include/linux/pci_ids.h         |    2 ++
 3 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/bnx2x/bnx2x_main.c b/drivers/net/bnx2x/bnx2x_main.c
index 8cdcf5b..9791dc5 100644
--- a/drivers/net/bnx2x/bnx2x_main.c
+++ b/drivers/net/bnx2x/bnx2x_main.c
@@ -145,13 +145,6 @@ static struct {
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
index 3adb06e..f82986b 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2078,6 +2078,8 @@
 #define PCI_DEVICE_ID_TIGON3_5723	0x165b
 #define PCI_DEVICE_ID_TIGON3_5705M	0x165d
 #define PCI_DEVICE_ID_TIGON3_5705M_2	0x165e
+#define PCI_DEVICE_ID_NX2_57712		0x1662
+#define PCI_DEVICE_ID_NX2_57712E	0x1663
 #define PCI_DEVICE_ID_TIGON3_5714	0x1668
 #define PCI_DEVICE_ID_TIGON3_5714S	0x1669
 #define PCI_DEVICE_ID_TIGON3_5780	0x166a
-- 
1.7.2.3

