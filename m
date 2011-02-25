From: adam radford <aradford@gmail.com>
Subject: [PATCH 5/14] megaraid_sas: Fix probe_one to clear MSI-X flags in kdump
Date: Thu, 24 Feb 2011 20:56:28 -0800
Message-ID: <AANLkTimG4HbXCNUdkcpGHbP7D2oNmvymbyKMOkCFNxJD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e6dab3552a2c43049d142782
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44391 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab1BYE43 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2011 23:56:29 -0500
Received: by mail-wy0-f174.google.com with SMTP id 36so1266125wyg.19
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2011 20:56:28 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e6dab3552a2c43049d142782
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch for megaraid_sas fixes megasas_probe_one() to
clear MSI-X flags in kdump when the 'reset_devices' kernel parameter
is passed in.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-24
18:43:13.853276151 -0800
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-24
18:47:27.480306538 -0800
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
diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.h
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas.h
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.h	2011-02-24
18:03:29.324307767 -0800
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas.h	2011-02-24
18:47:51.394307254 -0800
@@ -1477,4 +1477,7 @@
 	int max_index;
 };

+#define msi_control_reg(base) (base + PCI_MSI_FLAGS)
+#define PCI_MSIX_FLAGS_ENABLE (1 << 15)
+
 #endif				/*LSI_MEGARAID_SAS_H */

--0016e6dab3552a2c43049d142782
Content-Type: application/octet-stream; name="megaraid_sas.patch5"
Content-Disposition: attachment; filename="megaraid_sas.patch5"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkkmhxgn0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfYmFzZS5jIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jCi0tLSBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXNfYmFzZS5jCTIwMTEtMDItMjQgMTg6NDM6MTMuODUzMjc2MTUxIC0wODAwCisrKyBz
Y3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2Uu
YwkyMDExLTAyLTI0IDE4OjQ3OjI3LjQ4MDMwNjUzOCAtMDgwMApAQCAtMzkwMSw5ICszOTAxLDI2
IEBACiBzdGF0aWMgaW50IF9fZGV2aW5pdAogbWVnYXNhc19wcm9iZV9vbmUoc3RydWN0IHBjaV9k
ZXYgKnBkZXYsIGNvbnN0IHN0cnVjdCBwY2lfZGV2aWNlX2lkICppZCkKIHsKLQlpbnQgcnZhbDsK
KwlpbnQgcnZhbCwgcG9zOwogCXN0cnVjdCBTY3NpX0hvc3QgKmhvc3Q7CiAJc3RydWN0IG1lZ2Fz
YXNfaW5zdGFuY2UgKmluc3RhbmNlOworCXUxNiBjb250cm9sID0gMDsKKworCS8qIFJlc2V0IE1T
SS1YIGluIHRoZSBrZHVtcCBrZXJuZWwgKi8KKwlpZiAocmVzZXRfZGV2aWNlcykgeworCQlwb3Mg
PSBwY2lfZmluZF9jYXBhYmlsaXR5KHBkZXYsIFBDSV9DQVBfSURfTVNJWCk7CisJCWlmIChwb3Mp
IHsKKwkJCXBjaV9yZWFkX2NvbmZpZ193b3JkKHBkZXYsIG1zaV9jb250cm9sX3JlZyhwb3MpLAor
CQkJCQkgICAgICZjb250cm9sKTsKKwkJCWlmIChjb250cm9sICYgUENJX01TSVhfRkxBR1NfRU5B
QkxFKSB7CisJCQkJZGV2X2luZm8oJnBkZXYtPmRldiwgInJlc2V0dGluZyBNU0ktWFxuIik7CisJ
CQkJcGNpX3dyaXRlX2NvbmZpZ193b3JkKHBkZXYsCisJCQkJCQkgICAgICBtc2lfY29udHJvbF9y
ZWcocG9zKSwKKwkJCQkJCSAgICAgIGNvbnRyb2wgJgorCQkJCQkJICAgICAgflBDSV9NU0lYX0ZM
QUdTX0VOQUJMRSk7CisJCQl9CisJCX0KKwl9CiAKIAkvKgogCSAqIEFubm91bmNlIFBDSSBpbmZv
cm1hdGlvbgpkaWZmIC1OYXVyIHNjc2ktbWlzYy0yLjYvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21l
Z2FyYWlkX3Nhcy5oIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXMuaAotLS0gc2NzaS1taXNjLTIuNi9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJh
aWRfc2FzLmgJMjAxMS0wMi0yNCAxODowMzoyOS4zMjQzMDc3NjcgLTA4MDAKKysrIHNjc2ktbWlz
Yy0yLjYubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaAkyMDExLTAyLTI0
IDE4OjQ3OjUxLjM5NDMwNzI1NCAtMDgwMApAQCAtMTQ3Nyw0ICsxNDc3LDcgQEAKIAlpbnQgbWF4
X2luZGV4OwogfTsKIAorI2RlZmluZSBtc2lfY29udHJvbF9yZWcoYmFzZSkgKGJhc2UgKyBQQ0lf
TVNJX0ZMQUdTKQorI2RlZmluZSBQQ0lfTVNJWF9GTEFHU19FTkFCTEUgKDEgPDwgMTUpCisKICNl
bmRpZgkJCQkvKkxTSV9NRUdBUkFJRF9TQVNfSCAqLwo=
--0016e6dab3552a2c43049d142782--
