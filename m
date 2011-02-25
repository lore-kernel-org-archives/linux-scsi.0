From: adam radford <aradford@gmail.com>
Subject: [PATCH 3/14] megaraid_sas: Enable MSI-X before calling megasas_init_fw
Date: Thu, 24 Feb 2011 20:56:12 -0800
Message-ID: <AANLkTine33SqMq=zkrWHdnbUQHXQ_JGUVjkfvdXD=T01@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e64c2a3a35a379049d142606
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36827 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab1BYE6P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2011 23:58:15 -0500
Received: by wyg36 with SMTP id 36so1267156wyg.19
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2011 20:58:13 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e64c2a3a35a379049d142606
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

This patch enables MSI-X before calling megasas_init_fw() in megaraid_sas.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-24
19:23:22.402275735 -0800
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-24
19:26:15.628369493 -0800
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
@@ -4106,13 +4106,13 @@
 	free_irq(instance->msi_flag ? instance->msixentry.vector :
 		 instance->pdev->irq, instance);
 fail_irq:
-	if (instance->msi_flag)
-		pci_disable_msix(instance->pdev);
 	if (instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION)
 		megasas_release_fusion(instance);
 	else
 		megasas_release_mfi(instance);
       fail_init_mfi:
+	if (instance->msi_flag)
+		pci_disable_msix(instance->pdev);
       fail_alloc_dma_buf:
 	if (instance->evt_detail)
 		pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
@@ -4295,6 +4295,10 @@
 	if (megasas_set_dma_mask(pdev))
 		goto fail_set_dma_mask;

+	/* Now re-enable MSI-X */
+	if (instance->msi_flag)
+		pci_enable_msix(instance->pdev, &instance->msixentry, 1);
+
 	/*
 	 * Initialize MFI Firmware
 	 */
@@ -4331,10 +4335,6 @@
 	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
 		     (unsigned long)instance);

-	/* Now re-enable MSI-X */
-	if (instance->msi_flag)
-		pci_enable_msix(instance->pdev, &instance->msixentry, 1);
-
 	/*
 	 * Register IRQ
 	 */

--0016e64c2a3a35a379049d142606
Content-Type: application/octet-stream; name="megaraid_sas.patch3"
Content-Disposition: attachment; filename="megaraid_sas.patch3"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkkm39mf0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfYmFzZS5jIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jCi0tLSBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXNfYmFzZS5jCTIwMTEtMDItMjQgMTk6MjM6MjIuNDAyMjc1NzM1IC0wODAwCisrKyBz
Y3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2Uu
YwkyMDExLTAyLTI0IDE5OjI2OjE1LjYyODM2OTQ5MyAtMDgwMApAQCAtNDAzOSwxMiArNDAzOSw2
IEBACiAJZWxzZQogCQlJTklUX1dPUksoJmluc3RhbmNlLT53b3JrX2luaXQsIHByb2Nlc3NfZndf
c3RhdGVfY2hhbmdlX3dxKTsKIAotCS8qCi0JICogSW5pdGlhbGl6ZSBNRkkgRmlybXdhcmUKLQkg
Ki8KLQlpZiAobWVnYXNhc19pbml0X2Z3KGluc3RhbmNlKSkKLQkJZ290byBmYWlsX2luaXRfbWZp
OwotCiAJLyogVHJ5IHRvIGVuYWJsZSBNU0ktWCAqLwogCWlmICgoaW5zdGFuY2UtPnBkZXYtPmRl
dmljZSAhPSBQQ0lfREVWSUNFX0lEX0xTSV9TQVMxMDc4UikgJiYKIAkgICAgKGluc3RhbmNlLT5w
ZGV2LT5kZXZpY2UgIT0gUENJX0RFVklDRV9JRF9MU0lfU0FTMTA3OERFKSAmJgpAQCAtNDA1NCw2
ICs0MDQ4LDEyIEBACiAJCWluc3RhbmNlLT5tc2lfZmxhZyA9IDE7CiAKIAkvKgorCSAqIEluaXRp
YWxpemUgTUZJIEZpcm13YXJlCisJICovCisJaWYgKG1lZ2FzYXNfaW5pdF9mdyhpbnN0YW5jZSkp
CisJCWdvdG8gZmFpbF9pbml0X21maTsKKworCS8qCiAJICogUmVnaXN0ZXIgSVJRCiAJICovCiAJ
aWYgKHJlcXVlc3RfaXJxKGluc3RhbmNlLT5tc2lfZmxhZyA/IGluc3RhbmNlLT5tc2l4ZW50cnku
dmVjdG9yIDoKQEAgLTQxMDYsMTMgKzQxMDYsMTMgQEAKIAlmcmVlX2lycShpbnN0YW5jZS0+bXNp
X2ZsYWcgPyBpbnN0YW5jZS0+bXNpeGVudHJ5LnZlY3RvciA6CiAJCSBpbnN0YW5jZS0+cGRldi0+
aXJxLCBpbnN0YW5jZSk7CiBmYWlsX2lycToKLQlpZiAoaW5zdGFuY2UtPm1zaV9mbGFnKQotCQlw
Y2lfZGlzYWJsZV9tc2l4KGluc3RhbmNlLT5wZGV2KTsKIAlpZiAoaW5zdGFuY2UtPnBkZXYtPmRl
dmljZSA9PSBQQ0lfREVWSUNFX0lEX0xTSV9GVVNJT04pCiAJCW1lZ2FzYXNfcmVsZWFzZV9mdXNp
b24oaW5zdGFuY2UpOwogCWVsc2UKIAkJbWVnYXNhc19yZWxlYXNlX21maShpbnN0YW5jZSk7CiAg
ICAgICBmYWlsX2luaXRfbWZpOgorCWlmIChpbnN0YW5jZS0+bXNpX2ZsYWcpCisJCXBjaV9kaXNh
YmxlX21zaXgoaW5zdGFuY2UtPnBkZXYpOwogICAgICAgZmFpbF9hbGxvY19kbWFfYnVmOgogCWlm
IChpbnN0YW5jZS0+ZXZ0X2RldGFpbCkKIAkJcGNpX2ZyZWVfY29uc2lzdGVudChwZGV2LCBzaXpl
b2Yoc3RydWN0IG1lZ2FzYXNfZXZ0X2RldGFpbCksCkBAIC00Mjk1LDYgKzQyOTUsMTAgQEAKIAlp
ZiAobWVnYXNhc19zZXRfZG1hX21hc2socGRldikpCiAJCWdvdG8gZmFpbF9zZXRfZG1hX21hc2s7
CiAKKwkvKiBOb3cgcmUtZW5hYmxlIE1TSS1YICovCisJaWYgKGluc3RhbmNlLT5tc2lfZmxhZykK
KwkJcGNpX2VuYWJsZV9tc2l4KGluc3RhbmNlLT5wZGV2LCAmaW5zdGFuY2UtPm1zaXhlbnRyeSwg
MSk7CisKIAkvKgogCSAqIEluaXRpYWxpemUgTUZJIEZpcm13YXJlCiAJICovCkBAIC00MzMxLDEw
ICs0MzM1LDYgQEAKIAl0YXNrbGV0X2luaXQoJmluc3RhbmNlLT5pc3JfdGFza2xldCwgaW5zdGFu
Y2UtPmluc3RhbmNldC0+dGFza2xldCwKIAkJICAgICAodW5zaWduZWQgbG9uZylpbnN0YW5jZSk7
CiAKLQkvKiBOb3cgcmUtZW5hYmxlIE1TSS1YICovCi0JaWYgKGluc3RhbmNlLT5tc2lfZmxhZykK
LQkJcGNpX2VuYWJsZV9tc2l4KGluc3RhbmNlLT5wZGV2LCAmaW5zdGFuY2UtPm1zaXhlbnRyeSwg
MSk7Ci0KIAkvKgogCSAqIFJlZ2lzdGVyIElSUQogCSAqLwo=
--0016e64c2a3a35a379049d142606--
