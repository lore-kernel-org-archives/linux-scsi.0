From: Vijaya Mohan Guvva <vmohan@brocade.com>
Subject: [PATCH] bfa: Chinook quad port 16G FC HBA claim issue
Date: Wed, 4 Dec 2013 05:43:58 -0800
Message-ID: <1386164638-31693-1-git-send-email-vmohan@Brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:18769 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932462Ab3LDNoC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Dec 2013 08:44:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Anil Gurumurthy <agurumur@Brocade.com>, Adapter Linux Open Src Ext Team <AdapterLinuxOpenSrcExtTeam@Brocade.com>

From: Vijaya Mohan Guvva <vmohan@brocade.com>

Bfa driver crash is observed while pushing the firmware on to chinook
quad port card due to uninitialized bfi_image_ct2 access which gets
initialized only for CT2 ASIC based cards after request_firmware().
For quard port chinook (CT2 ASIC based), bfi_image_ct2 is not getting
initialized as there is no check for chinook PCI device ID before
request_firmware and instead bfi_image_cb is initialized as it is the
default case for card type check.

This patch includes changes to read the right firmware for quad port chinook.

Signed-off-by: Vijaya Mohan Guvva <vmohan@brocade.com>
---
 drivers/scsi/bfa/bfad.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index e85926c..1392547 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1829,7 +1829,7 @@ out:
 static u32 *
 bfad_load_fwimg(struct pci_dev *pdev)
 {
-	if (pdev->device == BFA_PCI_DEVICE_ID_CT2) {
+	if (bfa_asic_id_ct2(pdev->device)) {
 		if (bfi_image_ct2_size == 0)
 			bfad_read_firmware(pdev, &bfi_image_ct2,
 				&bfi_image_ct2_size, BFAD_FW_FILE_CT2);
@@ -1839,12 +1839,14 @@ bfad_load_fwimg(struct pci_dev *pdev)
 			bfad_read_firmware(pdev, &bfi_image_ct,
 				&bfi_image_ct_size, BFAD_FW_FILE_CT);
 		return bfi_image_ct;
-	} else {
+	} else if (bfa_asic_id_cb(pdev->device)) {
 		if (bfi_image_cb_size == 0)
 			bfad_read_firmware(pdev, &bfi_image_cb,
 				&bfi_image_cb_size, BFAD_FW_FILE_CB);
 		return bfi_image_cb;
 	}
+
+	return NULL;
 }
 
 static void
-- 
1.8.2.1

