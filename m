From: adam radford <aradford@gmail.com>
Subject: [PATCH 1/15] megaraid_sas: Fix failure gotos
Date: Sat, 19 Feb 2011 18:22:13 -0800
Message-ID: <AANLkTikPZ4X_DiOHtBTHrPVP=SFjnM5Fg0WPs09xTJ+d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e65b52a64a8e72049cad6ab5
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52251 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab1BTCWP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2011 21:22:15 -0500
Received: by wwa36 with SMTP id 36so5037267wwa.1
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2011 18:22:13 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e65b52a64a8e72049cad6ab5
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

This patch fixes some failure gotos in megaraid_sas.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_base.c
linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-15
19:23:45.000000000 -0800
+++ linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-19
13:31:40.505394814 -0800
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

@@ -4107,7 +4107,10 @@
 		 instance->pdev->irq, instance);
 	if (instance->msi_flag)
 		pci_disable_msix(instance->pdev);
-
+	if (instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION)
+		megasas_release_fusion(instance);
+	else
+		megasas_release_mfi(instance);
       fail_irq:
       fail_init_mfi:
       fail_alloc_dma_buf:
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
diff -Naur linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_fusion.c
linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-02-15
19:23:45.000000000 -0800
+++ linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-02-19
13:30:04.826364313 -0800
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

--0016e65b52a64a8e72049cad6ab5
Content-Type: application/octet-stream; name="megaraid_sas.patch1"
Content-Disposition: attachment; filename="megaraid_sas.patch1"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkdalz2g0

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzgtcmM1L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jIGxpbnV4LTIuNi4zOC1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9t
ZWdhcmFpZF9zYXNfYmFzZS5jCi0tLSBsaW51eC0yLjYuMzgtcmM1L2RyaXZlcnMvc2NzaS9tZWdh
cmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTEtMDItMTUgMTk6MjM6NDUuMDAwMDAwMDAwIC0w
ODAwCisrKyBsaW51eC0yLjYuMzgtcmM1Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJh
aWRfc2FzX2Jhc2UuYwkyMDExLTAyLTE5IDEzOjMxOjQwLjUwNTM5NDgxNCAtMDgwMApAQCAtMzQy
NCw3ICszNDI0LDYgQEAKIAltZWdhc2FzX2ZyZWVfY21kcyhpbnN0YW5jZSk7CiAKIGZhaWxfYWxs
b2NfY21kczoKLQlpb3VubWFwKGluc3RhbmNlLT5yZWdfc2V0KTsKIAlyZXR1cm4gMTsKIH0KIApA
QCAtMzQ5NCw3ICszNDkzLDcgQEAKIAogCS8qIEdldCBvcGVyYXRpb25hbCBwYXJhbXMsIHNnZSBm
bGFncywgc2VuZCBpbml0IGNtZCB0byBjb250cm9sbGVyICovCiAJaWYgKGluc3RhbmNlLT5pbnN0
YW5jZXQtPmluaXRfYWRhcHRlcihpbnN0YW5jZSkpCi0JCXJldHVybiAtRU5PREVWOworCQlnb3Rv
IGZhaWxfaW5pdF9hZGFwdGVyOwogCiAJcHJpbnRrKEtFUk5fRVJSICJtZWdhc2FzOiBJTklUIGFk
YXB0ZXIgZG9uZVxuIik7CiAKQEAgLTM1NTMsNiArMzU1Miw3IEBACiAJCQkJTUVHQVNBU19DT01Q
TEVUSU9OX1RJTUVSX0lOVEVSVkFMKTsKIAlyZXR1cm4gMDsKIAorZmFpbF9pbml0X2FkYXB0ZXI6
CiBmYWlsX3JlYWR5X3N0YXRlOgogCWlvdW5tYXAoaW5zdGFuY2UtPnJlZ19zZXQpOwogCkBAIC00
MTA3LDcgKzQxMDcsMTAgQEAKIAkJIGluc3RhbmNlLT5wZGV2LT5pcnEsIGluc3RhbmNlKTsKIAlp
ZiAoaW5zdGFuY2UtPm1zaV9mbGFnKQogCQlwY2lfZGlzYWJsZV9tc2l4KGluc3RhbmNlLT5wZGV2
KTsKLQorCWlmIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09IFBDSV9ERVZJQ0VfSURfTFNJX0ZV
U0lPTikKKwkJbWVnYXNhc19yZWxlYXNlX2Z1c2lvbihpbnN0YW5jZSk7CisJZWxzZQorCQltZWdh
c2FzX3JlbGVhc2VfbWZpKGluc3RhbmNlKTsKICAgICAgIGZhaWxfaXJxOgogICAgICAgZmFpbF9p
bml0X21maToKICAgICAgIGZhaWxfYWxsb2NfZG1hX2J1ZjoKQEAgLTQxMTYsMTMgKzQxMTksOSBA
QAogCQkJCSAgICBpbnN0YW5jZS0+ZXZ0X2RldGFpbCwKIAkJCQkgICAgaW5zdGFuY2UtPmV2dF9k
ZXRhaWxfaCk7CiAKLQlpZiAoaW5zdGFuY2UtPnByb2R1Y2VyKSB7CisJaWYgKGluc3RhbmNlLT5w
cm9kdWNlcikKIAkJcGNpX2ZyZWVfY29uc2lzdGVudChwZGV2LCBzaXplb2YodTMyKSwgaW5zdGFu
Y2UtPnByb2R1Y2VyLAogCQkJCSAgICBpbnN0YW5jZS0+cHJvZHVjZXJfaCk7Ci0JCW1lZ2FzYXNf
cmVsZWFzZV9tZmkoaW5zdGFuY2UpOwotCX0gZWxzZSB7Ci0JCW1lZ2FzYXNfcmVsZWFzZV9mdXNp
b24oaW5zdGFuY2UpOwotCX0KIAlpZiAoaW5zdGFuY2UtPmNvbnN1bWVyKQogCQlwY2lfZnJlZV9j
b25zaXN0ZW50KHBkZXYsIHNpemVvZih1MzIpLCBpbnN0YW5jZS0+Y29uc3VtZXIsCiAJCQkJICAg
IGluc3RhbmNlLT5jb25zdW1lcl9oKTsKZGlmZiAtTmF1ciBsaW51eC0yLjYuMzgtcmM1L2RyaXZl
cnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmMgbGludXgtMi42LjM4LXJjNS5u
ZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24uYwotLS0gbGludXgt
Mi42LjM4LXJjNS9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Z1c2lvbi5jCTIw
MTEtMDItMTUgMTk6MjM6NDUuMDAwMDAwMDAwIC0wODAwCisrKyBsaW51eC0yLjYuMzgtcmM1Lm5l
dy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Z1c2lvbi5jCTIwMTEtMDItMTkg
MTM6MzA6MDQuODI2MzY0MzEzIC0wODAwCkBAIC05ODQsMTMgKzk4NCwxNSBAQAogCiAJcmV0dXJu
IDA7CiAKLWZhaWxfYWxsb2NfY21kczoKLWZhaWxfYWxsb2NfbWZpX2NtZHM6CiBmYWlsX21hcF9p
bmZvOgogCWlmIChpID09IDEpCiAJCWRtYV9mcmVlX2NvaGVyZW50KCZpbnN0YW5jZS0+cGRldi0+
ZGV2LCBmdXNpb24tPm1hcF9zeiwKIAkJCQkgIGZ1c2lvbi0+bGRfbWFwWzBdLCBmdXNpb24tPmxk
X21hcF9waHlzWzBdKTsKIGZhaWxfaW9jX2luaXQ6CisJbWVnYXNhc19mcmVlX2NtZHNfZnVzaW9u
KGluc3RhbmNlKTsKK2ZhaWxfYWxsb2NfY21kczoKKwltZWdhc2FzX2ZyZWVfY21kcyhpbnN0YW5j
ZSk7CitmYWlsX2FsbG9jX21maV9jbWRzOgogCXJldHVybiAxOwogfQogCg==
--0016e65b52a64a8e72049cad6ab5--
