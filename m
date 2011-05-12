From: adam radford <aradford@gmail.com>
Subject: [PATCH 1/8] megaraid_sas: Remove MSI-X black list, use MFI_REG_STATE
Date: Wed, 11 May 2011 18:33:47 -0700
Message-ID: <BANLkTikp4cizOUH4OKcMBwUqOOyVRga-Tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001636426b6b34d0c204a30a2eab
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36593 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab1ELBdr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 May 2011 21:33:47 -0400
Received: by qwk3 with SMTP id 3so547383qwk.19
        for <linux-scsi@vger.kernel.org>; Wed, 11 May 2011 18:33:47 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--001636426b6b34d0c204a30a2eab
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

This patch for megaraid_sas removes the MSI-X black list and uses
MFI_REG_STATE.ready.msiEnable instead.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc/drivers/scsi/megaraid/megaraid_sas_base.c	2011-05-11
14:57:23.654429789 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-05-11
14:58:57.521366593 -0700
@@ -3454,7 +3454,7 @@
 {
 	u32 max_sectors_1;
 	u32 max_sectors_2;
-	u32 tmp_sectors;
+	u32 tmp_sectors, msix_enable;
 	struct megasas_register_set __iomem *reg_set;
 	struct megasas_ctrl_info *ctrl_info;
 	unsigned long bar_list;
@@ -3507,6 +3507,13 @@
 	if (megasas_transition_to_ready(instance))
 		goto fail_ready_state;

+	/* Check if MSI-X is supported while in ready state */
+	msix_enable = (instance->instancet->read_fw_status_reg(reg_set) &
+		       0x4000000) >> 0x1a;
+	if (msix_enable && !msix_disable &&
+	    !pci_enable_msix(instance->pdev, &instance->msixentry, 1))
+		instance->msi_flag = 1;
+
 	/* Get operational params, sge flags, send init cmd to controller */
 	if (instance->instancet->init_adapter(instance))
 		goto fail_init_adapter;
@@ -4076,14 +4083,6 @@
 	else
 		INIT_WORK(&instance->work_init, process_fw_state_change_wq);

-	/* Try to enable MSI-X */
-	if ((instance->pdev->device != PCI_DEVICE_ID_LSI_SAS1078R) &&
-	    (instance->pdev->device != PCI_DEVICE_ID_LSI_SAS1078DE) &&
-	    (instance->pdev->device != PCI_DEVICE_ID_LSI_VERDE_ZCR) &&
-	    !msix_disable && !pci_enable_msix(instance->pdev,
-					      &instance->msixentry, 1))
-		instance->msi_flag = 1;
-
 	/*
 	 * Initialize MFI Firmware
 	 */
@@ -4332,10 +4331,6 @@
 	if (megasas_set_dma_mask(pdev))
 		goto fail_set_dma_mask;

-	/* Now re-enable MSI-X */
-	if (instance->msi_flag)
-		pci_enable_msix(instance->pdev, &instance->msixentry, 1);
-
 	/*
 	 * Initialize MFI Firmware
 	 */
@@ -4348,6 +4343,10 @@
 	if (megasas_transition_to_ready(instance))
 		goto fail_ready_state;

+	/* Now re-enable MSI-X */
+	if (instance->msi_flag)
+		pci_enable_msix(instance->pdev, &instance->msixentry, 1);
+
 	switch (instance->pdev->device) {
 	case PCI_DEVICE_ID_LSI_FUSION:
 	{

--001636426b6b34d0c204a30a2eab
Content-Type: application/octet-stream; name="megaraid_sas.patch1"
Content-Disposition: attachment; filename="megaraid_sas.patch1"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gnl07jlz0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19i
YXNlLmMgc2NzaS1taXNjLm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jh
c2UuYwotLS0gc2NzaS1taXNjL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFz
ZS5jCTIwMTEtMDUtMTEgMTQ6NTc6MjMuNjU0NDI5Nzg5IC0wNzAwCisrKyBzY3NpLW1pc2MubmV3
L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTEtMDUtMTEgMTQ6
NTg6NTcuNTIxMzY2NTkzIC0wNzAwCkBAIC0zNDU0LDcgKzM0NTQsNyBAQAogewogCXUzMiBtYXhf
c2VjdG9yc18xOwogCXUzMiBtYXhfc2VjdG9yc18yOwotCXUzMiB0bXBfc2VjdG9yczsKKwl1MzIg
dG1wX3NlY3RvcnMsIG1zaXhfZW5hYmxlOwogCXN0cnVjdCBtZWdhc2FzX3JlZ2lzdGVyX3NldCBf
X2lvbWVtICpyZWdfc2V0OwogCXN0cnVjdCBtZWdhc2FzX2N0cmxfaW5mbyAqY3RybF9pbmZvOwog
CXVuc2lnbmVkIGxvbmcgYmFyX2xpc3Q7CkBAIC0zNTA3LDYgKzM1MDcsMTMgQEAKIAlpZiAobWVn
YXNhc190cmFuc2l0aW9uX3RvX3JlYWR5KGluc3RhbmNlKSkKIAkJZ290byBmYWlsX3JlYWR5X3N0
YXRlOwogCisJLyogQ2hlY2sgaWYgTVNJLVggaXMgc3VwcG9ydGVkIHdoaWxlIGluIHJlYWR5IHN0
YXRlICovCisJbXNpeF9lbmFibGUgPSAoaW5zdGFuY2UtPmluc3RhbmNldC0+cmVhZF9md19zdGF0
dXNfcmVnKHJlZ19zZXQpICYKKwkJICAgICAgIDB4NDAwMDAwMCkgPj4gMHgxYTsKKwlpZiAobXNp
eF9lbmFibGUgJiYgIW1zaXhfZGlzYWJsZSAmJgorCSAgICAhcGNpX2VuYWJsZV9tc2l4KGluc3Rh
bmNlLT5wZGV2LCAmaW5zdGFuY2UtPm1zaXhlbnRyeSwgMSkpCisJCWluc3RhbmNlLT5tc2lfZmxh
ZyA9IDE7CisKIAkvKiBHZXQgb3BlcmF0aW9uYWwgcGFyYW1zLCBzZ2UgZmxhZ3MsIHNlbmQgaW5p
dCBjbWQgdG8gY29udHJvbGxlciAqLwogCWlmIChpbnN0YW5jZS0+aW5zdGFuY2V0LT5pbml0X2Fk
YXB0ZXIoaW5zdGFuY2UpKQogCQlnb3RvIGZhaWxfaW5pdF9hZGFwdGVyOwpAQCAtNDA3NiwxNCAr
NDA4Myw2IEBACiAJZWxzZQogCQlJTklUX1dPUksoJmluc3RhbmNlLT53b3JrX2luaXQsIHByb2Nl
c3NfZndfc3RhdGVfY2hhbmdlX3dxKTsKIAotCS8qIFRyeSB0byBlbmFibGUgTVNJLVggKi8KLQlp
ZiAoKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgIT0gUENJX0RFVklDRV9JRF9MU0lfU0FTMTA3OFIp
ICYmCi0JICAgIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlICE9IFBDSV9ERVZJQ0VfSURfTFNJX1NB
UzEwNzhERSkgJiYKLQkgICAgKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgIT0gUENJX0RFVklDRV9J
RF9MU0lfVkVSREVfWkNSKSAmJgotCSAgICAhbXNpeF9kaXNhYmxlICYmICFwY2lfZW5hYmxlX21z
aXgoaW5zdGFuY2UtPnBkZXYsCi0JCQkJCSAgICAgICZpbnN0YW5jZS0+bXNpeGVudHJ5LCAxKSkK
LQkJaW5zdGFuY2UtPm1zaV9mbGFnID0gMTsKLQogCS8qCiAJICogSW5pdGlhbGl6ZSBNRkkgRmly
bXdhcmUKIAkgKi8KQEAgLTQzMzIsMTAgKzQzMzEsNiBAQAogCWlmIChtZWdhc2FzX3NldF9kbWFf
bWFzayhwZGV2KSkKIAkJZ290byBmYWlsX3NldF9kbWFfbWFzazsKIAotCS8qIE5vdyByZS1lbmFi
bGUgTVNJLVggKi8KLQlpZiAoaW5zdGFuY2UtPm1zaV9mbGFnKQotCQlwY2lfZW5hYmxlX21zaXgo
aW5zdGFuY2UtPnBkZXYsICZpbnN0YW5jZS0+bXNpeGVudHJ5LCAxKTsKLQogCS8qCiAJICogSW5p
dGlhbGl6ZSBNRkkgRmlybXdhcmUKIAkgKi8KQEAgLTQzNDgsNiArNDM0MywxMCBAQAogCWlmICht
ZWdhc2FzX3RyYW5zaXRpb25fdG9fcmVhZHkoaW5zdGFuY2UpKQogCQlnb3RvIGZhaWxfcmVhZHlf
c3RhdGU7CiAKKwkvKiBOb3cgcmUtZW5hYmxlIE1TSS1YICovCisJaWYgKGluc3RhbmNlLT5tc2lf
ZmxhZykKKwkJcGNpX2VuYWJsZV9tc2l4KGluc3RhbmNlLT5wZGV2LCAmaW5zdGFuY2UtPm1zaXhl
bnRyeSwgMSk7CisKIAlzd2l0Y2ggKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UpIHsKIAljYXNlIFBD
SV9ERVZJQ0VfSURfTFNJX0ZVU0lPTjoKIAl7Cg==
--001636426b6b34d0c204a30a2eab--
