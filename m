From: adam radford <aradford@gmail.com>
Subject: [PATCH 5/15] megaraid_sas: Fix probe_one to clear MSI-X flags in kdump
Date: Sat, 19 Feb 2011 18:22:36 -0800
Message-ID: <AANLkTinMo1nnUhiYi=Rfnnts9zqqSf_UuaYUt_gyJW3B@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e65a0d30b29ea9049cad6b13
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50704 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab1BTCWh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2011 21:22:37 -0500
Received: by mail-wy0-f174.google.com with SMTP id 38so105867wyb.19
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2011 18:22:37 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e65a0d30b29ea9049cad6b13
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch for megaraid_sas fixes megasas_probe_one() to
clear MSI-X flags in kdump when the 'reset_devices' kernel parameter
is passed in.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_base.c
linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-19
13:58:52.649363761 -0800
+++ linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-19
14:01:52.407362948 -0800
@@ -3901,9 +3901,26 @@
 static int __devinit
 megasas_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	int rval;
+	int rval, pos;
 	struct Scsi_Host *host;
 	struct megasas_instance *instance;
+	u16 control = 0;
+
+	/* Reset MSI-X in the kdump kernel */
+	if (reset_devices) {
+		pos = pci_find_capability(pdev, PCI_CAP_ID_MSIX);
+		if (pos) {
+			pci_read_config_word(pdev, msi_control_reg(pos),
+					     &control);
+			if (control & PCI_MSIX_FLAGS_ENABLE) {
+				dev_info(&pdev->dev, "resetting MSI-X\n");
+				pci_write_config_word(pdev,
+						      msi_control_reg(pos),
+						      control &
+						      ~PCI_MSIX_FLAGS_ENABLE);
+			}
+		}
+	}

 	/*
 	 * Announce PCI information
diff -Naur linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas.h
linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas.h	2011-02-15
19:23:45.000000000 -0800
+++ linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas.h	2011-02-19
14:04:00.565333377 -0800
@@ -1477,4 +1477,7 @@
 	int max_index;
 };

+#define msi_control_reg(base) (base + PCI_MSI_FLAGS)
+#define PCI_MSIX_FLAGS_ENABLE (1 << 15)
+
 #endif				/*LSI_MEGARAID_SAS_H */

--0016e65a0d30b29ea9049cad6b13
Content-Type: application/octet-stream; name="megaraid_sas.patch5"
Content-Disposition: attachment; filename="megaraid_sas.patch5"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkday3t50

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzgtcmM1L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jIGxpbnV4LTIuNi4zOC1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9t
ZWdhcmFpZF9zYXNfYmFzZS5jCi0tLSBsaW51eC0yLjYuMzgtcmM1L2RyaXZlcnMvc2NzaS9tZWdh
cmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTEtMDItMTkgMTM6NTg6NTIuNjQ5MzYzNzYxIC0w
ODAwCisrKyBsaW51eC0yLjYuMzgtcmM1Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJh
aWRfc2FzX2Jhc2UuYwkyMDExLTAyLTE5IDE0OjAxOjUyLjQwNzM2Mjk0OCAtMDgwMApAQCAtMzkw
MSw5ICszOTAxLDI2IEBACiBzdGF0aWMgaW50IF9fZGV2aW5pdAogbWVnYXNhc19wcm9iZV9vbmUo
c3RydWN0IHBjaV9kZXYgKnBkZXYsIGNvbnN0IHN0cnVjdCBwY2lfZGV2aWNlX2lkICppZCkKIHsK
LQlpbnQgcnZhbDsKKwlpbnQgcnZhbCwgcG9zOwogCXN0cnVjdCBTY3NpX0hvc3QgKmhvc3Q7CiAJ
c3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlOworCXUxNiBjb250cm9sID0gMDsKKwor
CS8qIFJlc2V0IE1TSS1YIGluIHRoZSBrZHVtcCBrZXJuZWwgKi8KKwlpZiAocmVzZXRfZGV2aWNl
cykgeworCQlwb3MgPSBwY2lfZmluZF9jYXBhYmlsaXR5KHBkZXYsIFBDSV9DQVBfSURfTVNJWCk7
CisJCWlmIChwb3MpIHsKKwkJCXBjaV9yZWFkX2NvbmZpZ193b3JkKHBkZXYsIG1zaV9jb250cm9s
X3JlZyhwb3MpLAorCQkJCQkgICAgICZjb250cm9sKTsKKwkJCWlmIChjb250cm9sICYgUENJX01T
SVhfRkxBR1NfRU5BQkxFKSB7CisJCQkJZGV2X2luZm8oJnBkZXYtPmRldiwgInJlc2V0dGluZyBN
U0ktWFxuIik7CisJCQkJcGNpX3dyaXRlX2NvbmZpZ193b3JkKHBkZXYsCisJCQkJCQkgICAgICBt
c2lfY29udHJvbF9yZWcocG9zKSwKKwkJCQkJCSAgICAgIGNvbnRyb2wgJgorCQkJCQkJICAgICAg
flBDSV9NU0lYX0ZMQUdTX0VOQUJMRSk7CisJCQl9CisJCX0KKwl9CiAKIAkvKgogCSAqIEFubm91
bmNlIFBDSSBpbmZvcm1hdGlvbgpkaWZmIC1OYXVyIGxpbnV4LTIuNi4zOC1yYzUvZHJpdmVycy9z
Y3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5oIGxpbnV4LTIuNi4zOC1yYzUubmV3L2RyaXZlcnMv
c2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaAotLS0gbGludXgtMi42LjM4LXJjNS9kcml2ZXJz
L3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmgJMjAxMS0wMi0xNSAxOToyMzo0NS4wMDAwMDAw
MDAgLTA4MDAKKysrIGxpbnV4LTIuNi4zOC1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9t
ZWdhcmFpZF9zYXMuaAkyMDExLTAyLTE5IDE0OjA0OjAwLjU2NTMzMzM3NyAtMDgwMApAQCAtMTQ3
Nyw0ICsxNDc3LDcgQEAKIAlpbnQgbWF4X2luZGV4OwogfTsKIAorI2RlZmluZSBtc2lfY29udHJv
bF9yZWcoYmFzZSkgKGJhc2UgKyBQQ0lfTVNJX0ZMQUdTKQorI2RlZmluZSBQQ0lfTVNJWF9GTEFH
U19FTkFCTEUgKDEgPDwgMTUpCisKICNlbmRpZgkJCQkvKkxTSV9NRUdBUkFJRF9TQVNfSCAqLwo=
--0016e65a0d30b29ea9049cad6b13--
