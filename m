From: adam radford <aradford@gmail.com>
Subject: [PATCH 3/15] megaraid_sas: Enable MSI-X before calling megasas_init_fw
Date: Sat, 19 Feb 2011 18:22:27 -0800
Message-ID: <AANLkTimQECveVo3-P2aZmT4ZZYVXUvPy3OiW-5yUFKA0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e64c0b8c1c6cd3049cad6bb5
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50704 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab1BTCW2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2011 21:22:28 -0500
Received: by wyb38 with SMTP id 38so105867wyb.19
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2011 18:22:27 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e64c0b8c1c6cd3049cad6bb5
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

This patch enables MSI-X before calling megasas_init_fw() in megaraid_sas.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_base.c
linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-19
13:48:26.542364077 -0800
+++ linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-19
13:52:30.727362759 -0800
@@ -4039,12 +4039,6 @@
 	else
 		INIT_WORK(&instance->work_init, process_fw_state_change_wq);

-	/*
-	 * Initialize MFI Firmware
-	 */
-	if (megasas_init_fw(instance))
-		goto fail_init_mfi;
-
 	/* Try to enable MSI-X */
 	if ((instance->pdev->device != PCI_DEVICE_ID_LSI_SAS1078R) &&
 	    (instance->pdev->device != PCI_DEVICE_ID_LSI_SAS1078DE) &&
@@ -4054,6 +4048,12 @@
 		instance->msi_flag = 1;

 	/*
+	 * Initialize MFI Firmware
+	 */
+	if (megasas_init_fw(instance))
+		goto fail_init_mfi;
+
+	/*
 	 * Register IRQ
 	 */
 	if (request_irq(instance->msi_flag ? instance->msixentry.vector :
@@ -4105,14 +4105,14 @@
 	instance->instancet->disable_intr(instance->reg_set);
 	free_irq(instance->msi_flag ? instance->msixentry.vector :
 		 instance->pdev->irq, instance);
+fail_irq:
+fail_init_mfi:
 	if (instance->msi_flag)
 		pci_disable_msix(instance->pdev);
 	if (instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION)
 		megasas_release_fusion(instance);
 	else
 		megasas_release_mfi(instance);
-      fail_irq:
-      fail_init_mfi:
       fail_alloc_dma_buf:
 	if (instance->evt_detail)
 		pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
@@ -4296,6 +4296,10 @@
 	if (megasas_set_dma_mask(pdev))
 		goto fail_set_dma_mask;

+	/* Now re-enable MSI-X */
+	if (instance->msi_flag)
+		pci_enable_msix(instance->pdev, &instance->msixentry, 1);
+
 	/*
 	 * Initialize MFI Firmware
 	 */
@@ -4332,10 +4336,6 @@
 	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
 		     (unsigned long)instance);

-	/* Now re-enable MSI-X */
-	if (instance->msi_flag)
-		pci_enable_msix(instance->pdev, &instance->msixentry, 1);
-
 	/*
 	 * Register IRQ
 	 */

--0016e64c0b8c1c6cd3049cad6bb5
Content-Type: application/octet-stream; name="megaraid_sas.patch3"
Content-Disposition: attachment; filename="megaraid_sas.patch3"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkdasowk0

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzgtcmM1L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jIGxpbnV4LTIuNi4zOC1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9t
ZWdhcmFpZF9zYXNfYmFzZS5jCi0tLSBsaW51eC0yLjYuMzgtcmM1L2RyaXZlcnMvc2NzaS9tZWdh
cmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTEtMDItMTkgMTM6NDg6MjYuNTQyMzY0MDc3IC0w
ODAwCisrKyBsaW51eC0yLjYuMzgtcmM1Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJh
aWRfc2FzX2Jhc2UuYwkyMDExLTAyLTE5IDEzOjUyOjMwLjcyNzM2Mjc1OSAtMDgwMApAQCAtNDAz
OSwxMiArNDAzOSw2IEBACiAJZWxzZQogCQlJTklUX1dPUksoJmluc3RhbmNlLT53b3JrX2luaXQs
IHByb2Nlc3NfZndfc3RhdGVfY2hhbmdlX3dxKTsKIAotCS8qCi0JICogSW5pdGlhbGl6ZSBNRkkg
RmlybXdhcmUKLQkgKi8KLQlpZiAobWVnYXNhc19pbml0X2Z3KGluc3RhbmNlKSkKLQkJZ290byBm
YWlsX2luaXRfbWZpOwotCiAJLyogVHJ5IHRvIGVuYWJsZSBNU0ktWCAqLwogCWlmICgoaW5zdGFu
Y2UtPnBkZXYtPmRldmljZSAhPSBQQ0lfREVWSUNFX0lEX0xTSV9TQVMxMDc4UikgJiYKIAkgICAg
KGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgIT0gUENJX0RFVklDRV9JRF9MU0lfU0FTMTA3OERFKSAm
JgpAQCAtNDA1NCw2ICs0MDQ4LDEyIEBACiAJCWluc3RhbmNlLT5tc2lfZmxhZyA9IDE7CiAKIAkv
KgorCSAqIEluaXRpYWxpemUgTUZJIEZpcm13YXJlCisJICovCisJaWYgKG1lZ2FzYXNfaW5pdF9m
dyhpbnN0YW5jZSkpCisJCWdvdG8gZmFpbF9pbml0X21maTsKKworCS8qCiAJICogUmVnaXN0ZXIg
SVJRCiAJICovCiAJaWYgKHJlcXVlc3RfaXJxKGluc3RhbmNlLT5tc2lfZmxhZyA/IGluc3RhbmNl
LT5tc2l4ZW50cnkudmVjdG9yIDoKQEAgLTQxMDUsMTQgKzQxMDUsMTQgQEAKIAlpbnN0YW5jZS0+
aW5zdGFuY2V0LT5kaXNhYmxlX2ludHIoaW5zdGFuY2UtPnJlZ19zZXQpOwogCWZyZWVfaXJxKGlu
c3RhbmNlLT5tc2lfZmxhZyA/IGluc3RhbmNlLT5tc2l4ZW50cnkudmVjdG9yIDoKIAkJIGluc3Rh
bmNlLT5wZGV2LT5pcnEsIGluc3RhbmNlKTsKK2ZhaWxfaXJxOgorZmFpbF9pbml0X21maToKIAlp
ZiAoaW5zdGFuY2UtPm1zaV9mbGFnKQogCQlwY2lfZGlzYWJsZV9tc2l4KGluc3RhbmNlLT5wZGV2
KTsKIAlpZiAoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PSBQQ0lfREVWSUNFX0lEX0xTSV9GVVNJ
T04pCiAJCW1lZ2FzYXNfcmVsZWFzZV9mdXNpb24oaW5zdGFuY2UpOwogCWVsc2UKIAkJbWVnYXNh
c19yZWxlYXNlX21maShpbnN0YW5jZSk7Ci0gICAgICBmYWlsX2lycToKLSAgICAgIGZhaWxfaW5p
dF9tZmk6CiAgICAgICBmYWlsX2FsbG9jX2RtYV9idWY6CiAJaWYgKGluc3RhbmNlLT5ldnRfZGV0
YWlsKQogCQlwY2lfZnJlZV9jb25zaXN0ZW50KHBkZXYsIHNpemVvZihzdHJ1Y3QgbWVnYXNhc19l
dnRfZGV0YWlsKSwKQEAgLTQyOTYsNiArNDI5NiwxMCBAQAogCWlmIChtZWdhc2FzX3NldF9kbWFf
bWFzayhwZGV2KSkKIAkJZ290byBmYWlsX3NldF9kbWFfbWFzazsKIAorCS8qIE5vdyByZS1lbmFi
bGUgTVNJLVggKi8KKwlpZiAoaW5zdGFuY2UtPm1zaV9mbGFnKQorCQlwY2lfZW5hYmxlX21zaXgo
aW5zdGFuY2UtPnBkZXYsICZpbnN0YW5jZS0+bXNpeGVudHJ5LCAxKTsKKwogCS8qCiAJICogSW5p
dGlhbGl6ZSBNRkkgRmlybXdhcmUKIAkgKi8KQEAgLTQzMzIsMTAgKzQzMzYsNiBAQAogCXRhc2ts
ZXRfaW5pdCgmaW5zdGFuY2UtPmlzcl90YXNrbGV0LCBpbnN0YW5jZS0+aW5zdGFuY2V0LT50YXNr
bGV0LAogCQkgICAgICh1bnNpZ25lZCBsb25nKWluc3RhbmNlKTsKIAotCS8qIE5vdyByZS1lbmFi
bGUgTVNJLVggKi8KLQlpZiAoaW5zdGFuY2UtPm1zaV9mbGFnKQotCQlwY2lfZW5hYmxlX21zaXgo
aW5zdGFuY2UtPnBkZXYsICZpbnN0YW5jZS0+bXNpeGVudHJ5LCAxKTsKLQogCS8qCiAJICogUmVn
aXN0ZXIgSVJRCiAJICovCg==
--0016e64c0b8c1c6cd3049cad6bb5--
