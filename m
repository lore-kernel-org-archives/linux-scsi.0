From: James Smart <james.smart@emulex.com>
Subject: [PATCH 02/21] lpfc 8.3.33: Enable attachment to OCe14000 adapters
Date: Fri, 3 Aug 2012 12:42:51 -0400
Message-ID: <1344012171.7080.0.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:41383 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab2HCQm6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2012 12:42:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Enable attachment to OCe14000 adapters 


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hw.h   |    2 ++
 lpfc_init.c |    9 +++++++++
 2 files changed, 11 insertions(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2012-07-22 10:46:05.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2012-07-22 11:35:19.813631891 -0400
@@ -1251,6 +1251,8 @@ typedef struct {
 #define PCI_VENDOR_ID_SERVERENGINE  0x19a2
 #define PCI_DEVICE_ID_TIGERSHARK    0x0704
 #define PCI_DEVICE_ID_TOMCAT        0x0714
+#define PCI_DEVICE_ID_SKYHAWK       0x0724
+#define PCI_DEVICE_ID_SKYHAWK_VF    0x072c
 
 #define JEDEC_ID_ADDRESS            0x0080001c
 #define FIREFLY_JEDEC_ID            0x1ACC
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-07-22 11:18:36.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-07-22 11:35:19.830631891 -0400
@@ -2059,6 +2059,11 @@ lpfc_get_hba_model_desc(struct lpfc_hba
 		oneConnect = 1;
 		m = (typeof(m)){"OCe15100", "PCIe", "FCoE"};
 		break;
+	case PCI_DEVICE_ID_SKYHAWK:
+	case PCI_DEVICE_ID_SKYHAWK_VF:
+		oneConnect = 1;
+		m = (typeof(m)){"OCe14000", "PCIe", "FCoE"};
+		break;
 	default:
 		m = (typeof(m)){"Unknown", "", ""};
 		break;
@@ -10420,6 +10425,10 @@ static struct pci_device_id lpfc_id_tabl
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_FCOE_VF,
 		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SKYHAWK,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SKYHAWK_VF,
+		PCI_ANY_ID, PCI_ANY_ID, },
 	{ 0 }
 };
 


