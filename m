From: adam radford <aradford@gmail.com>
Subject: [PATCH 1/14] megaraid_sas: Fix failure gotos
Date: Thu, 24 Feb 2011 20:55:56 -0800
Message-ID: <AANLkTimAr9CDPDAXPkMKbK853JqK5xwmyaHLckw0ZfeB@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=000e0ce00132450bb5049d14250a
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44391 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab1BYEz6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2011 23:55:58 -0500
Received: by wyg36 with SMTP id 36so1266125wyg.19
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2011 20:55:57 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--000e0ce00132450bb5049d14250a
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

This patch fixes some failure gotos in megaraid_sas.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-24
19:12:03.583275666 -0800
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-24
19:13:14.626276093 -0800
@@ -3424,7 +3424,6 @@
 	megasas_free_cmds(instance);

 fail_alloc_cmds:
-	iounmap(instance->reg_set);
 	return 1;
 }

@@ -3494,7 +3493,7 @@

 	/* Get operational params, sge flags, send init cmd to controller */
 	if (instance->instancet->init_adapter(instance))
-		return -ENODEV;
+		goto fail_init_adapter;

 	printk(KERN_ERR "megasas: INIT adapter done\n");

@@ -3553,6 +3552,7 @@
 				MEGASAS_COMPLETION_TIMER_INTERVAL);
 	return 0;

+fail_init_adapter:
 fail_ready_state:
 	iounmap(instance->reg_set);

@@ -4105,10 +4105,13 @@
 	instance->instancet->disable_intr(instance->reg_set);
 	free_irq(instance->msi_flag ? instance->msixentry.vector :
 		 instance->pdev->irq, instance);
+fail_irq:
 	if (instance->msi_flag)
 		pci_disable_msix(instance->pdev);
-
-      fail_irq:
+	if (instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION)
+		megasas_release_fusion(instance);
+	else
+		megasas_release_mfi(instance);
       fail_init_mfi:
       fail_alloc_dma_buf:
 	if (instance->evt_detail)
@@ -4116,13 +4119,9 @@
 				    instance->evt_detail,
 				    instance->evt_detail_h);

-	if (instance->producer) {
+	if (instance->producer)
 		pci_free_consistent(pdev, sizeof(u32), instance->producer,
 				    instance->producer_h);
-		megasas_release_mfi(instance);
-	} else {
-		megasas_release_fusion(instance);
-	}
 	if (instance->consumer)
 		pci_free_consistent(pdev, sizeof(u32), instance->consumer,
 				    instance->consumer_h);
diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-02-24
19:12:03.584275547 -0800
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-02-24
19:12:52.698288446 -0800
@@ -984,13 +984,15 @@

 	return 0;

-fail_alloc_cmds:
-fail_alloc_mfi_cmds:
 fail_map_info:
 	if (i == 1)
 		dma_free_coherent(&instance->pdev->dev, fusion->map_sz,
 				  fusion->ld_map[0], fusion->ld_map_phys[0]);
 fail_ioc_init:
+	megasas_free_cmds_fusion(instance);
+fail_alloc_cmds:
+	megasas_free_cmds(instance);
+fail_alloc_mfi_cmds:
 	return 1;
 }

--000e0ce00132450bb5049d14250a
Content-Type: application/octet-stream; name="megaraid_sas.patch1"
Content-Disposition: attachment; filename="megaraid_sas.patch1"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkkm1eat0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfYmFzZS5jIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jCi0tLSBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXNfYmFzZS5jCTIwMTEtMDItMjQgMTk6MTI6MDMuNTgzMjc1NjY2IC0wODAwCisrKyBz
Y3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2Uu
YwkyMDExLTAyLTI0IDE5OjEzOjE0LjYyNjI3NjA5MyAtMDgwMApAQCAtMzQyNCw3ICszNDI0LDYg
QEAKIAltZWdhc2FzX2ZyZWVfY21kcyhpbnN0YW5jZSk7CiAKIGZhaWxfYWxsb2NfY21kczoKLQlp
b3VubWFwKGluc3RhbmNlLT5yZWdfc2V0KTsKIAlyZXR1cm4gMTsKIH0KIApAQCAtMzQ5NCw3ICsz
NDkzLDcgQEAKIAogCS8qIEdldCBvcGVyYXRpb25hbCBwYXJhbXMsIHNnZSBmbGFncywgc2VuZCBp
bml0IGNtZCB0byBjb250cm9sbGVyICovCiAJaWYgKGluc3RhbmNlLT5pbnN0YW5jZXQtPmluaXRf
YWRhcHRlcihpbnN0YW5jZSkpCi0JCXJldHVybiAtRU5PREVWOworCQlnb3RvIGZhaWxfaW5pdF9h
ZGFwdGVyOwogCiAJcHJpbnRrKEtFUk5fRVJSICJtZWdhc2FzOiBJTklUIGFkYXB0ZXIgZG9uZVxu
Iik7CiAKQEAgLTM1NTMsNiArMzU1Miw3IEBACiAJCQkJTUVHQVNBU19DT01QTEVUSU9OX1RJTUVS
X0lOVEVSVkFMKTsKIAlyZXR1cm4gMDsKIAorZmFpbF9pbml0X2FkYXB0ZXI6CiBmYWlsX3JlYWR5
X3N0YXRlOgogCWlvdW5tYXAoaW5zdGFuY2UtPnJlZ19zZXQpOwogCkBAIC00MTA1LDEwICs0MTA1
LDEzIEBACiAJaW5zdGFuY2UtPmluc3RhbmNldC0+ZGlzYWJsZV9pbnRyKGluc3RhbmNlLT5yZWdf
c2V0KTsKIAlmcmVlX2lycShpbnN0YW5jZS0+bXNpX2ZsYWcgPyBpbnN0YW5jZS0+bXNpeGVudHJ5
LnZlY3RvciA6CiAJCSBpbnN0YW5jZS0+cGRldi0+aXJxLCBpbnN0YW5jZSk7CitmYWlsX2lycToK
IAlpZiAoaW5zdGFuY2UtPm1zaV9mbGFnKQogCQlwY2lfZGlzYWJsZV9tc2l4KGluc3RhbmNlLT5w
ZGV2KTsKLQotICAgICAgZmFpbF9pcnE6CisJaWYgKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0g
UENJX0RFVklDRV9JRF9MU0lfRlVTSU9OKQorCQltZWdhc2FzX3JlbGVhc2VfZnVzaW9uKGluc3Rh
bmNlKTsKKwllbHNlCisJCW1lZ2FzYXNfcmVsZWFzZV9tZmkoaW5zdGFuY2UpOwogICAgICAgZmFp
bF9pbml0X21maToKICAgICAgIGZhaWxfYWxsb2NfZG1hX2J1ZjoKIAlpZiAoaW5zdGFuY2UtPmV2
dF9kZXRhaWwpCkBAIC00MTE2LDEzICs0MTE5LDkgQEAKIAkJCQkgICAgaW5zdGFuY2UtPmV2dF9k
ZXRhaWwsCiAJCQkJICAgIGluc3RhbmNlLT5ldnRfZGV0YWlsX2gpOwogCi0JaWYgKGluc3RhbmNl
LT5wcm9kdWNlcikgeworCWlmIChpbnN0YW5jZS0+cHJvZHVjZXIpCiAJCXBjaV9mcmVlX2NvbnNp
c3RlbnQocGRldiwgc2l6ZW9mKHUzMiksIGluc3RhbmNlLT5wcm9kdWNlciwKIAkJCQkgICAgaW5z
dGFuY2UtPnByb2R1Y2VyX2gpOwotCQltZWdhc2FzX3JlbGVhc2VfbWZpKGluc3RhbmNlKTsKLQl9
IGVsc2UgewotCQltZWdhc2FzX3JlbGVhc2VfZnVzaW9uKGluc3RhbmNlKTsKLQl9CiAJaWYgKGlu
c3RhbmNlLT5jb25zdW1lcikKIAkJcGNpX2ZyZWVfY29uc2lzdGVudChwZGV2LCBzaXplb2YodTMy
KSwgaW5zdGFuY2UtPmNvbnN1bWVyLAogCQkJCSAgICBpbnN0YW5jZS0+Y29uc3VtZXJfaCk7CmRp
ZmYgLU5hdXIgc2NzaS1taXNjLTIuNi9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2Fz
X2Z1c2lvbi5jIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfZnVzaW9uLmMKLS0tIHNjc2ktbWlzYy0yLjYvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21l
Z2FyYWlkX3Nhc19mdXNpb24uYwkyMDExLTAyLTI0IDE5OjEyOjAzLjU4NDI3NTU0NyAtMDgwMAor
Kysgc2NzaS1taXNjLTIuNi5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19m
dXNpb24uYwkyMDExLTAyLTI0IDE5OjEyOjUyLjY5ODI4ODQ0NiAtMDgwMApAQCAtOTg0LDEzICs5
ODQsMTUgQEAKIAogCXJldHVybiAwOwogCi1mYWlsX2FsbG9jX2NtZHM6Ci1mYWlsX2FsbG9jX21m
aV9jbWRzOgogZmFpbF9tYXBfaW5mbzoKIAlpZiAoaSA9PSAxKQogCQlkbWFfZnJlZV9jb2hlcmVu
dCgmaW5zdGFuY2UtPnBkZXYtPmRldiwgZnVzaW9uLT5tYXBfc3osCiAJCQkJICBmdXNpb24tPmxk
X21hcFswXSwgZnVzaW9uLT5sZF9tYXBfcGh5c1swXSk7CiBmYWlsX2lvY19pbml0OgorCW1lZ2Fz
YXNfZnJlZV9jbWRzX2Z1c2lvbihpbnN0YW5jZSk7CitmYWlsX2FsbG9jX2NtZHM6CisJbWVnYXNh
c19mcmVlX2NtZHMoaW5zdGFuY2UpOworZmFpbF9hbGxvY19tZmlfY21kczoKIAlyZXR1cm4gMTsK
IH0KIAo=
--000e0ce00132450bb5049d14250a--
