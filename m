From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 2/5] bnx2fc: Include chip number in the symbolic name
Date: Fri, 8 Mar 2013 13:28:51 -0800
Message-ID: <1362778134-21045-3-git-send-email-bprakash@broadcom.com>
References: <1362778134-21045-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1918 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264Ab3CHV2u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Mar 2013 16:28:50 -0500
In-Reply-To: <1362778134-21045-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h      |   53 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   51 +++++++++++++++++++++++++++++++----
 2 files changed, 98 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 50fcd01..2f118e3 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -68,6 +68,57 @@
 
 #define PFX			"bnx2fc: "
 
+#define BCM_CHIP_LEN		16
+
+#ifndef PCI_DEVICE_ID_NX2_57710
+#define PCI_DEVICE_ID_NX2_57710		0x164e
+#endif
+#ifndef PCI_DEVICE_ID_NX2_57711
+#define PCI_DEVICE_ID_NX2_57711		0x164f
+#endif
+#ifndef PCI_DEVICE_ID_NX2_57712
+#define PCI_DEVICE_ID_NX2_57712		0x1662
+#endif
+#ifndef PCI_DEVICE_ID_NX2_57712_MF
+#define PCI_DEVICE_ID_NX2_57712_MF	0x1663
+#endif
+#ifndef PCI_DEVICE_ID_NX2_57712_VF
+#define PCI_DEVICE_ID_NX2_57712_VF	0x166f
+#endif
+#ifndef PCI_DEVICE_ID_NX2_57800
+#define PCI_DEVICE_ID_NX2_57800		0x168a
+#endif
+#ifndef PCI_DEVICE_ID_NX2_57800_MF
+#define PCI_DEVICE_ID_NX2_57800_MF	0x16a5
+#endif
+#ifndef PCI_DEVICE_ID_NX2_57800_VF
+#define PCI_DEVICE_ID_NX2_57800_VF	0x16a9
+#endif
+#ifndef PCI_DEVICE_ID_NX2_57810
+#define PCI_DEVICE_ID_NX2_57810		0x168e
+#endif
+#ifndef PCI_DEVICE_ID_NX2_57810_MF
+#define PCI_DEVICE_ID_NX2_57810_MF	0x16ae
+#endif
+#ifndef PCI_DEVICE_ID_NX2_57810_VF
+#define PCI_DEVICE_ID_NX2_57810_VF	0x16af
+#endif
+#ifndef PCI_DEVICE_ID_NX2_57840
+#define PCI_DEVICE_ID_NX2_57840		0x168d
+#endif
+#ifndef PCI_DEVICE_ID_NX2_57840_MF
+#define PCI_DEVICE_ID_NX2_57840_MF	0x16a4
+#endif
+#ifndef PCI_DEVICE_ID_NX2_57840_VF
+#define PCI_DEVICE_ID_NX2_57840_VF	0x16ad
+#endif
+#ifndef PCI_DEVICE_ID_NX2_57840_2_20
+#define PCI_DEVICE_ID_NX2_57840_2_20	0x16a2
+#endif
+#ifndef PCI_DEVICE_ID_NX2_57840_4_10
+#define PCI_DEVICE_ID_NX2_57840_4_10	0x16a1
+#endif
+
 #define BNX2X_DOORBELL_PCI_BAR		2
 
 #define BNX2FC_MAX_BD_LEN		0xffff
@@ -243,6 +294,8 @@ struct bnx2fc_hba {
 	int wait_for_link_down;
 	int num_ofld_sess;
 	struct list_head vports;
+
+	char chip_num[BCM_CHIP_LEN];
 };
 
 struct bnx2fc_interface {
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 2daf4b0..dd2c5c9 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -679,6 +679,7 @@ static int bnx2fc_shost_config(struct fc_lport *lport, struct device *dev)
 {
 	struct fcoe_port *port = lport_priv(lport);
 	struct bnx2fc_interface *interface = port->priv;
+	struct bnx2fc_hba *hba = interface->hba;
 	struct Scsi_Host *shost = lport->host;
 	int rc = 0;
 
@@ -699,8 +700,9 @@ static int bnx2fc_shost_config(struct fc_lport *lport, struct device *dev)
 	}
 	if (!lport->vport)
 		fc_host_max_npiv_vports(lport->host) = USHRT_MAX;
-	sprintf(fc_host_symbolic_name(lport->host), "%s v%s over %s",
-		BNX2FC_NAME, BNX2FC_VERSION,
+	snprintf(fc_host_symbolic_name(lport->host), 256,
+		 "%s (Broadcom %s) v%s over %s",
+		BNX2FC_NAME, hba->chip_num, BNX2FC_VERSION,
 		interface->netdev->name);
 
 	return 0;
@@ -1649,23 +1651,60 @@ mem_err:
 static int bnx2fc_bind_pcidev(struct bnx2fc_hba *hba)
 {
 	struct cnic_dev *cnic;
+	struct pci_dev *pdev;
 
 	if (!hba->cnic) {
 		printk(KERN_ERR PFX "cnic is NULL\n");
 		return -ENODEV;
 	}
 	cnic = hba->cnic;
-	hba->pcidev = cnic->pcidev;
-	if (hba->pcidev)
-		pci_dev_get(hba->pcidev);
+	pdev = hba->pcidev = cnic->pcidev;
+	if (!hba->pcidev)
+		return -ENODEV;
 
+	switch (pdev->device) {
+	case PCI_DEVICE_ID_NX2_57710:
+		strncpy(hba->chip_num, "BCM57710", BCM_CHIP_LEN);
+		break;
+	case PCI_DEVICE_ID_NX2_57711:
+		strncpy(hba->chip_num, "BCM57711", BCM_CHIP_LEN);
+		break;
+	case PCI_DEVICE_ID_NX2_57712:
+	case PCI_DEVICE_ID_NX2_57712_MF:
+	case PCI_DEVICE_ID_NX2_57712_VF:
+		strncpy(hba->chip_num, "BCM57712", BCM_CHIP_LEN);
+		break;
+	case PCI_DEVICE_ID_NX2_57800:
+	case PCI_DEVICE_ID_NX2_57800_MF:
+	case PCI_DEVICE_ID_NX2_57800_VF:
+		strncpy(hba->chip_num, "BCM57800", BCM_CHIP_LEN);
+		break;
+	case PCI_DEVICE_ID_NX2_57810:
+	case PCI_DEVICE_ID_NX2_57810_MF:
+	case PCI_DEVICE_ID_NX2_57810_VF:
+		strncpy(hba->chip_num, "BCM57810", BCM_CHIP_LEN);
+		break;
+	case PCI_DEVICE_ID_NX2_57840:
+	case PCI_DEVICE_ID_NX2_57840_MF:
+	case PCI_DEVICE_ID_NX2_57840_VF:
+	case PCI_DEVICE_ID_NX2_57840_2_20:
+	case PCI_DEVICE_ID_NX2_57840_4_10:
+		strncpy(hba->chip_num, "BCM57840", BCM_CHIP_LEN);
+		break;
+	default:
+		pr_err(PFX "Unknown device id 0x%x\n", pdev->device);
+		break;
+	}
+	pci_dev_get(hba->pcidev);
 	return 0;
 }
 
 static void bnx2fc_unbind_pcidev(struct bnx2fc_hba *hba)
 {
-	if (hba->pcidev)
+	if (hba->pcidev) {
+		hba->chip_num[0] = '\0';
 		pci_dev_put(hba->pcidev);
+	}
 	hba->pcidev = NULL;
 }
 
-- 
1.7.1


