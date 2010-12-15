From: adam radford <aradford@gmail.com>
Subject: [PATCH 4/11]: megaraid_sas: Use lowest memory bar for SR-IOV VF support
Date: Tue, 14 Dec 2010 18:56:07 -0800
Message-ID: <AANLkTikh6QctVEJGqWGmCY1Cda-je0YWTGaf4oXrzkFP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001636831cda29532804976a14a4
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64298 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab0LOC4I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Dec 2010 21:56:08 -0500
Received: by qwa26 with SMTP id 26so1484617qwa.19
        for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2010 18:56:07 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--001636831cda29532804976a14a4
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch modifies the megaraid_sas driver to select the
lowest memory bar available so
the driver will work in SR-IOV VF environments where the memory bar
mapping changes.

Signed-off-by: Adam Radford <aradford@gmail.com>

Note: The patch has been included in-line below, and also as an
attachment in case Gmail hoses the patch.

diff -Naur linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas_base.c
linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas_base.c	2010-12-14
16:15:22.000000000 -0800
+++ linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c	2010-12-14
16:18:40.000000000 -0800
@@ -3236,21 +3236,14 @@
 	u32 tmp_sectors;
 	struct megasas_register_set __iomem *reg_set;
 	struct megasas_ctrl_info *ctrl_info;
-	/*
-	 * Map the message registers
-	 */
-	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS1078GEN2) ||
-		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY) ||
-		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
-		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0079GEN2)) {
-		instance->base_addr = pci_resource_start(instance->pdev, 1);
-	} else {
-		instance->base_addr = pci_resource_start(instance->pdev, 0);
-	}
+	unsigned long bar_list;

-	if (pci_request_selected_regions(instance->pdev,
-		pci_select_bars(instance->pdev, IORESOURCE_MEM),
-		"megasas: LSI")) {
+	/* Find first memory bar */
+	bar_list = pci_select_bars(instance->pdev, IORESOURCE_MEM);
+	instance->bar = find_first_bit(&bar_list, sizeof(unsigned long));
+	instance->base_addr = pci_resource_start(instance->pdev, instance->bar);
+	if (pci_request_selected_regions(instance->pdev, instance->bar,
+					 "megasas: LSI")) {
 		printk(KERN_DEBUG "megasas: IO memory region busy!\n");
 		return -EBUSY;
 	}
@@ -3411,8 +3404,7 @@
 	iounmap(instance->reg_set);

       fail_ioremap:
-	pci_release_selected_regions(instance->pdev,
-		pci_select_bars(instance->pdev, IORESOURCE_MEM));
+	pci_release_selected_regions(instance->pdev, instance->bar);

 	return -EINVAL;
 }
@@ -3432,8 +3424,7 @@

 	iounmap(instance->reg_set);

-	pci_release_selected_regions(instance->pdev,
-		pci_select_bars(instance->pdev, IORESOURCE_MEM));
+	pci_release_selected_regions(instance->pdev, instance->bar);
 }

 /**
diff -Naur linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas.h
linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas.h	2010-12-14
16:15:22.000000000 -0800
+++ linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas.h	2010-12-14
16:19:23.000000000 -0800
@@ -1338,6 +1338,7 @@

 	u8	msi_flag;
 	struct msix_entry msixentry;
+	unsigned long bar;
 };

 enum {

--001636831cda29532804976a14a4
Content-Type: application/octet-stream; name="megaraid_sas.patch4"
Content-Disposition: attachment; filename="megaraid_sas.patch4"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghpml6sx0

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzctcmM1Lm9sZC9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVn
YXJhaWRfc2FzX2Jhc2UuYyBsaW51eC0yLjYuMzctcmM1Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJh
aWQvbWVnYXJhaWRfc2FzX2Jhc2UuYwotLS0gbGludXgtMi42LjM3LXJjNS5vbGQvZHJpdmVycy9z
Y3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19iYXNlLmMJMjAxMC0xMi0xNCAxNjoxNToyMi4wMDAw
MDAwMDAgLTA4MDAKKysrIGxpbnV4LTIuNi4zNy1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFp
ZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTAtMTItMTQgMTY6MTg6NDAuMDAwMDAwMDAwIC0wODAw
CkBAIC0zMjM2LDIxICszMjM2LDE0IEBACiAJdTMyIHRtcF9zZWN0b3JzOwogCXN0cnVjdCBtZWdh
c2FzX3JlZ2lzdGVyX3NldCBfX2lvbWVtICpyZWdfc2V0OwogCXN0cnVjdCBtZWdhc2FzX2N0cmxf
aW5mbyAqY3RybF9pbmZvOwotCS8qCi0JICogTWFwIHRoZSBtZXNzYWdlIHJlZ2lzdGVycwotCSAq
LwotCWlmICgoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PSBQQ0lfREVWSUNFX0lEX0xTSV9TQVMx
MDc4R0VOMikgfHwKLQkJKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0gUENJX0RFVklDRV9JRF9M
U0lfU0FTMDA3MVNLSU5OWSkgfHwKLQkJKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0gUENJX0RF
VklDRV9JRF9MU0lfU0FTMDA3M1NLSU5OWSkgfHwKLQkJKGluc3RhbmNlLT5wZGV2LT5kZXZpY2Ug
PT0gUENJX0RFVklDRV9JRF9MU0lfU0FTMDA3OUdFTjIpKSB7Ci0JCWluc3RhbmNlLT5iYXNlX2Fk
ZHIgPSBwY2lfcmVzb3VyY2Vfc3RhcnQoaW5zdGFuY2UtPnBkZXYsIDEpOwotCX0gZWxzZSB7Ci0J
CWluc3RhbmNlLT5iYXNlX2FkZHIgPSBwY2lfcmVzb3VyY2Vfc3RhcnQoaW5zdGFuY2UtPnBkZXYs
IDApOwotCX0KKwl1bnNpZ25lZCBsb25nIGJhcl9saXN0OwogCi0JaWYgKHBjaV9yZXF1ZXN0X3Nl
bGVjdGVkX3JlZ2lvbnMoaW5zdGFuY2UtPnBkZXYsCi0JCXBjaV9zZWxlY3RfYmFycyhpbnN0YW5j
ZS0+cGRldiwgSU9SRVNPVVJDRV9NRU0pLAotCQkibWVnYXNhczogTFNJIikpIHsKKwkvKiBGaW5k
IGZpcnN0IG1lbW9yeSBiYXIgKi8KKwliYXJfbGlzdCA9IHBjaV9zZWxlY3RfYmFycyhpbnN0YW5j
ZS0+cGRldiwgSU9SRVNPVVJDRV9NRU0pOworCWluc3RhbmNlLT5iYXIgPSBmaW5kX2ZpcnN0X2Jp
dCgmYmFyX2xpc3QsIHNpemVvZih1bnNpZ25lZCBsb25nKSk7CisJaW5zdGFuY2UtPmJhc2VfYWRk
ciA9IHBjaV9yZXNvdXJjZV9zdGFydChpbnN0YW5jZS0+cGRldiwgaW5zdGFuY2UtPmJhcik7CisJ
aWYgKHBjaV9yZXF1ZXN0X3NlbGVjdGVkX3JlZ2lvbnMoaW5zdGFuY2UtPnBkZXYsIGluc3RhbmNl
LT5iYXIsCisJCQkJCSAibWVnYXNhczogTFNJIikpIHsKIAkJcHJpbnRrKEtFUk5fREVCVUcgIm1l
Z2FzYXM6IElPIG1lbW9yeSByZWdpb24gYnVzeSFcbiIpOwogCQlyZXR1cm4gLUVCVVNZOwogCX0K
QEAgLTM0MTEsOCArMzQwNCw3IEBACiAJaW91bm1hcChpbnN0YW5jZS0+cmVnX3NldCk7CiAKICAg
ICAgIGZhaWxfaW9yZW1hcDoKLQlwY2lfcmVsZWFzZV9zZWxlY3RlZF9yZWdpb25zKGluc3RhbmNl
LT5wZGV2LAotCQlwY2lfc2VsZWN0X2JhcnMoaW5zdGFuY2UtPnBkZXYsIElPUkVTT1VSQ0VfTUVN
KSk7CisJcGNpX3JlbGVhc2Vfc2VsZWN0ZWRfcmVnaW9ucyhpbnN0YW5jZS0+cGRldiwgaW5zdGFu
Y2UtPmJhcik7CiAKIAlyZXR1cm4gLUVJTlZBTDsKIH0KQEAgLTM0MzIsOCArMzQyNCw3IEBACiAK
IAlpb3VubWFwKGluc3RhbmNlLT5yZWdfc2V0KTsKIAotCXBjaV9yZWxlYXNlX3NlbGVjdGVkX3Jl
Z2lvbnMoaW5zdGFuY2UtPnBkZXYsCi0JCXBjaV9zZWxlY3RfYmFycyhpbnN0YW5jZS0+cGRldiwg
SU9SRVNPVVJDRV9NRU0pKTsKKwlwY2lfcmVsZWFzZV9zZWxlY3RlZF9yZWdpb25zKGluc3RhbmNl
LT5wZGV2LCBpbnN0YW5jZS0+YmFyKTsKIH0KIAogLyoqCmRpZmYgLU5hdXIgbGludXgtMi42LjM3
LXJjNS5vbGQvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5oIGxpbnV4LTIuNi4z
Ny1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaAotLS0gbGludXgt
Mi42LjM3LXJjNS5vbGQvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5oCTIwMTAt
MTItMTQgMTY6MTU6MjIuMDAwMDAwMDAwIC0wODAwCisrKyBsaW51eC0yLjYuMzctcmM1Lm5ldy9k
cml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmgJMjAxMC0xMi0xNCAxNjoxOToyMy4w
MDAwMDAwMDAgLTA4MDAKQEAgLTEzMzgsNiArMTMzOCw3IEBACiAKIAl1OAltc2lfZmxhZzsKIAlz
dHJ1Y3QgbXNpeF9lbnRyeSBtc2l4ZW50cnk7CisJdW5zaWduZWQgbG9uZyBiYXI7CiB9OwogCiBl
bnVtIHsK
--001636831cda29532804976a14a4--
