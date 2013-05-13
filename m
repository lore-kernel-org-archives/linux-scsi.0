From: Vijaya Mohan Guvva <vmohan@brocade.com>
Subject: [PATCH V1 15/17] bfa: Support for chinook-quad port card
Date: Mon, 13 May 2013 02:33:33 -0700
Message-ID: <1368437615-9867-16-git-send-email-vmohan@brocade.com>
References: <1368437615-9867-1-git-send-email-vmohan@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:50283 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752200Ab3EMJtK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 May 2013 05:49:10 -0400
In-Reply-To: <1368437615-9867-1-git-send-email-vmohan@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, adapter_linux_open_src_team@Brocade.COM, Vijaya Mohan Guvva <vmohan@Brocade.COM>

This patch enables support for chinook quad port 16G FC card (falcon)

Signed-off-by: Vijaya Mohan Guvva <vmohan@brocade.com>
---
 drivers/scsi/bfa/bfa_defs.h | 5 ++++-
 drivers/scsi/bfa/bfa_ioc.c  | 1 +
 drivers/scsi/bfa/bfad.c     | 8 ++++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_defs.h b/drivers/scsi/bfa/bfa_defs.h
index bef16d2..d40a79f 100644
--- a/drivers/scsi/bfa/bfa_defs.h
+++ b/drivers/scsi/bfa/bfa_defs.h
@@ -637,6 +637,7 @@ enum {
 	BFA_PCI_DEVICE_ID_CT		= 0x14,
 	BFA_PCI_DEVICE_ID_CT_FC		= 0x21,
 	BFA_PCI_DEVICE_ID_CT2		= 0x22,
+	BFA_PCI_DEVICE_ID_CT2_QUAD	= 0x23,
 };
 
 #define bfa_asic_id_cb(__d)			\
@@ -645,7 +646,9 @@ enum {
 #define bfa_asic_id_ct(__d)			\
 	((__d) == BFA_PCI_DEVICE_ID_CT ||	\
 	 (__d) == BFA_PCI_DEVICE_ID_CT_FC)
-#define bfa_asic_id_ct2(__d)	((__d) == BFA_PCI_DEVICE_ID_CT2)
+#define bfa_asic_id_ct2(__d)			\
+	((__d) == BFA_PCI_DEVICE_ID_CT2 ||	\
+	(__d) == BFA_PCI_DEVICE_ID_CT2_QUAD)
 #define bfa_asic_id_ctc(__d)	\
 	(bfa_asic_id_ct(__d) || bfa_asic_id_ct2(__d))
 
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index a4f3741..f78bcb6 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -2196,6 +2196,7 @@ bfa_ioc_pci_init(struct bfa_ioc_s *ioc, struct bfa_pcidev_s *pcidev,
 		break;
 
 	case BFA_PCI_DEVICE_ID_CT2:
+	case BFA_PCI_DEVICE_ID_CT2_QUAD:
 		ioc->asic_gen = BFI_ASIC_GEN_CT2;
 		if (clscode == BFI_PCIFN_CLASS_FC &&
 		    pcidev->ssid == BFA_PCI_CT2_SSID_FC) {
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index a5f7690..bf5c5d3 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1720,6 +1720,14 @@ struct pci_device_id bfad_id_table[] = {
 		.class_mask = ~0,
 	},
 
+	{
+		.vendor = BFA_PCI_VENDOR_ID_BROCADE,
+		.device = BFA_PCI_DEVICE_ID_CT2_QUAD,
+		.subvendor = PCI_ANY_ID,
+		.subdevice = PCI_ANY_ID,
+		.class = (PCI_CLASS_SERIAL_FIBER << 8),
+		.class_mask = ~0,
+	},
 	{0, 0},
 };
 
-- 
1.7.12

