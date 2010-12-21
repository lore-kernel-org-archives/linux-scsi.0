From: adam radford <aradford@gmail.com>
Subject: [PATCH 3/11]: REPOST: megaraid_sas: Add MSI-X support and
 msix_disable module parameter
Date: Tue, 21 Dec 2010 10:17:40 -0800
Message-ID: <AANLkTik8FEf+-m6PyBo26Htk2eaXigbPe7Zd8Bqi+WE-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e64ca430f30c140497efa68a
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33454 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab0LUSRl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Dec 2010 13:17:41 -0500
Received: by qwa26 with SMTP id 26so4262912qwa.19
        for <linux-scsi@vger.kernel.org>; Tue, 21 Dec 2010 10:17:40 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e64ca430f30c140497efa68a
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

REPOSTED to fix sequential compile issue.

This patch adds MSI-X support and 'msix_disable' module parameter to
the megaraid_sas driver.

Signed-off-by: Adam Radford <aradford@gmail.com>

Note: The patch has been included in-line below, and also as an
attachment in case Gmail hoses the patch.

diff -Naur linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas_base.c
linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas_base.c	2010-12-21
09:45:50.000000000 -0800
+++ linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c	2010-12-21
09:50:52.000000000 -0800
@@ -72,6 +72,10 @@
 MODULE_PARM_DESC(max_sectors,
 	"Maximum number of sectors per IO command");

+static int msix_disable;
+module_param(msix_disable, int, S_IRUGO);
+MODULE_PARM_DESC(msix_disable, "Disable MSI-X interrupt handling. Default: 0");
+
 MODULE_LICENSE("GPL");
 MODULE_VERSION(MEGASAS_VERSION);
 MODULE_AUTHOR("megaraidlinux@lsi.com");
@@ -3863,10 +3867,20 @@
 	if (megasas_init_mfi(instance))
 		goto fail_init_mfi;

+	/* Try to enable MSI-X */
+	if ((instance->pdev->device != PCI_DEVICE_ID_LSI_SAS1078R) &&
+	    (instance->pdev->device != PCI_DEVICE_ID_LSI_SAS1078DE) &&
+	    (instance->pdev->device != PCI_DEVICE_ID_LSI_VERDE_ZCR) &&
+	    !msix_disable && !pci_enable_msix(instance->pdev,
+					      &instance->msixentry, 1))
+		instance->msi_flag = 1;
+
 	/*
 	 * Register IRQ
 	 */
-	if (request_irq(pdev->irq, megasas_isr, IRQF_SHARED, "megasas", instance)) {
+	if (request_irq(instance->msi_flag ? instance->msixentry.vector :
+			pdev->irq, megasas_isr,
+			IRQF_SHARED, "megasas", instance)) {
 		printk(KERN_DEBUG "megasas: Failed to register IRQ\n");
 		goto fail_irq;
 	}
@@ -3911,8 +3925,10 @@

 	pci_set_drvdata(pdev, NULL);
 	instance->instancet->disable_intr(instance->reg_set);
-	free_irq(instance->pdev->irq, instance);
-
+	free_irq(instance->msi_flag ? instance->msixentry.vector :
+		 instance->pdev->irq, instance);
+	if (instance->msi_flag)
+		pci_disable_msix(instance->pdev);
 	megasas_release_mfi(instance);

       fail_irq:
@@ -4053,7 +4069,10 @@

 	pci_set_drvdata(instance->pdev, instance);
 	instance->instancet->disable_intr(instance->reg_set);
-	free_irq(instance->pdev->irq, instance);
+	free_irq(instance->msi_flag ? instance->msixentry.vector :
+		 instance->pdev->irq, instance);
+	if (instance->msi_flag)
+		pci_disable_msix(instance->pdev);

 	pci_save_state(pdev);
 	pci_disable_device(pdev);
@@ -4116,11 +4135,16 @@
 	tasklet_init(&instance->isr_tasklet, megasas_complete_cmd_dpc,
 			(unsigned long)instance);

+	/* Now re-enable MSI-X */
+	if (instance->msi_flag)
+		pci_enable_msix(instance->pdev, &instance->msixentry, 1);
+
 	/*
 	 * Register IRQ
 	 */
-	if (request_irq(pdev->irq, megasas_isr, IRQF_SHARED,
-		"megasas", instance)) {
+	if (request_irq(instance->msi_flag ? instance->msixentry.vector :
+			pdev->irq, megasas_isr,
+			IRQF_SHARED, "megasas", instance)) {
 		printk(KERN_ERR "megasas: Failed to register IRQ\n");
 		goto fail_irq;
 	}
@@ -4218,7 +4242,10 @@

 	instance->instancet->disable_intr(instance->reg_set);

-	free_irq(instance->pdev->irq, instance);
+	free_irq(instance->msi_flag ? instance->msixentry.vector :
+		 instance->pdev->irq, instance);
+	if (instance->msi_flag)
+		pci_disable_msix(instance->pdev);

 	megasas_release_mfi(instance);

diff -Naur linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas.h
linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas.h	2010-12-21
09:45:50.000000000 -0800
+++ linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas.h	2010-12-21
09:49:30.000000000 -0800
@@ -1335,6 +1335,9 @@

 	struct timer_list io_completion_timer;
 	struct list_head internal_reset_pending_q;
+
+	u8	msi_flag;
+	struct msix_entry msixentry;
 };

 enum {

--0016e64ca430f30c140497efa68a
Content-Type: application/octet-stream; name="megaraid_sas.patch3"
Content-Disposition: attachment; filename="megaraid_sas.patch3"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghz44gd40

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzctcmM1Lm9sZC9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVn
YXJhaWRfc2FzX2Jhc2UuYyBsaW51eC0yLjYuMzctcmM1Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJh
aWQvbWVnYXJhaWRfc2FzX2Jhc2UuYwotLS0gbGludXgtMi42LjM3LXJjNS5vbGQvZHJpdmVycy9z
Y3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19iYXNlLmMJMjAxMC0xMi0yMSAwOTo0NTo1MC4wMDAw
MDAwMDAgLTA4MDAKKysrIGxpbnV4LTIuNi4zNy1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFp
ZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTAtMTItMjEgMDk6NTA6NTIuMDAwMDAwMDAwIC0wODAw
CkBAIC03Miw2ICs3MiwxMCBAQAogTU9EVUxFX1BBUk1fREVTQyhtYXhfc2VjdG9ycywKIAkiTWF4
aW11bSBudW1iZXIgb2Ygc2VjdG9ycyBwZXIgSU8gY29tbWFuZCIpOwogCitzdGF0aWMgaW50IG1z
aXhfZGlzYWJsZTsKK21vZHVsZV9wYXJhbShtc2l4X2Rpc2FibGUsIGludCwgU19JUlVHTyk7CitN
T0RVTEVfUEFSTV9ERVNDKG1zaXhfZGlzYWJsZSwgIkRpc2FibGUgTVNJLVggaW50ZXJydXB0IGhh
bmRsaW5nLiBEZWZhdWx0OiAwIik7CisKIE1PRFVMRV9MSUNFTlNFKCJHUEwiKTsKIE1PRFVMRV9W
RVJTSU9OKE1FR0FTQVNfVkVSU0lPTik7CiBNT0RVTEVfQVVUSE9SKCJtZWdhcmFpZGxpbnV4QGxz
aS5jb20iKTsKQEAgLTM4NjMsMTAgKzM4NjcsMjAgQEAKIAlpZiAobWVnYXNhc19pbml0X21maShp
bnN0YW5jZSkpCiAJCWdvdG8gZmFpbF9pbml0X21maTsKIAorCS8qIFRyeSB0byBlbmFibGUgTVNJ
LVggKi8KKwlpZiAoKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgIT0gUENJX0RFVklDRV9JRF9MU0lf
U0FTMTA3OFIpICYmCisJICAgIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlICE9IFBDSV9ERVZJQ0Vf
SURfTFNJX1NBUzEwNzhERSkgJiYKKwkgICAgKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgIT0gUENJ
X0RFVklDRV9JRF9MU0lfVkVSREVfWkNSKSAmJgorCSAgICAhbXNpeF9kaXNhYmxlICYmICFwY2lf
ZW5hYmxlX21zaXgoaW5zdGFuY2UtPnBkZXYsCisJCQkJCSAgICAgICZpbnN0YW5jZS0+bXNpeGVu
dHJ5LCAxKSkKKwkJaW5zdGFuY2UtPm1zaV9mbGFnID0gMTsKKwogCS8qCiAJICogUmVnaXN0ZXIg
SVJRCiAJICovCi0JaWYgKHJlcXVlc3RfaXJxKHBkZXYtPmlycSwgbWVnYXNhc19pc3IsIElSUUZf
U0hBUkVELCAibWVnYXNhcyIsIGluc3RhbmNlKSkgeworCWlmIChyZXF1ZXN0X2lycShpbnN0YW5j
ZS0+bXNpX2ZsYWcgPyBpbnN0YW5jZS0+bXNpeGVudHJ5LnZlY3RvciA6CisJCQlwZGV2LT5pcnEs
IG1lZ2FzYXNfaXNyLAorCQkJSVJRRl9TSEFSRUQsICJtZWdhc2FzIiwgaW5zdGFuY2UpKSB7CiAJ
CXByaW50ayhLRVJOX0RFQlVHICJtZWdhc2FzOiBGYWlsZWQgdG8gcmVnaXN0ZXIgSVJRXG4iKTsK
IAkJZ290byBmYWlsX2lycTsKIAl9CkBAIC0zOTExLDggKzM5MjUsMTAgQEAKIAogCXBjaV9zZXRf
ZHJ2ZGF0YShwZGV2LCBOVUxMKTsKIAlpbnN0YW5jZS0+aW5zdGFuY2V0LT5kaXNhYmxlX2ludHIo
aW5zdGFuY2UtPnJlZ19zZXQpOwotCWZyZWVfaXJxKGluc3RhbmNlLT5wZGV2LT5pcnEsIGluc3Rh
bmNlKTsKLQorCWZyZWVfaXJxKGluc3RhbmNlLT5tc2lfZmxhZyA/IGluc3RhbmNlLT5tc2l4ZW50
cnkudmVjdG9yIDoKKwkJIGluc3RhbmNlLT5wZGV2LT5pcnEsIGluc3RhbmNlKTsKKwlpZiAoaW5z
dGFuY2UtPm1zaV9mbGFnKQorCQlwY2lfZGlzYWJsZV9tc2l4KGluc3RhbmNlLT5wZGV2KTsKIAlt
ZWdhc2FzX3JlbGVhc2VfbWZpKGluc3RhbmNlKTsKIAogICAgICAgZmFpbF9pcnE6CkBAIC00MDUz
LDcgKzQwNjksMTAgQEAKIAogCXBjaV9zZXRfZHJ2ZGF0YShpbnN0YW5jZS0+cGRldiwgaW5zdGFu
Y2UpOwogCWluc3RhbmNlLT5pbnN0YW5jZXQtPmRpc2FibGVfaW50cihpbnN0YW5jZS0+cmVnX3Nl
dCk7Ci0JZnJlZV9pcnEoaW5zdGFuY2UtPnBkZXYtPmlycSwgaW5zdGFuY2UpOworCWZyZWVfaXJx
KGluc3RhbmNlLT5tc2lfZmxhZyA/IGluc3RhbmNlLT5tc2l4ZW50cnkudmVjdG9yIDoKKwkJIGlu
c3RhbmNlLT5wZGV2LT5pcnEsIGluc3RhbmNlKTsKKwlpZiAoaW5zdGFuY2UtPm1zaV9mbGFnKQor
CQlwY2lfZGlzYWJsZV9tc2l4KGluc3RhbmNlLT5wZGV2KTsKIAogCXBjaV9zYXZlX3N0YXRlKHBk
ZXYpOwogCXBjaV9kaXNhYmxlX2RldmljZShwZGV2KTsKQEAgLTQxMTYsMTEgKzQxMzUsMTYgQEAK
IAl0YXNrbGV0X2luaXQoJmluc3RhbmNlLT5pc3JfdGFza2xldCwgbWVnYXNhc19jb21wbGV0ZV9j
bWRfZHBjLAogCQkJKHVuc2lnbmVkIGxvbmcpaW5zdGFuY2UpOwogCisJLyogTm93IHJlLWVuYWJs
ZSBNU0ktWCAqLworCWlmIChpbnN0YW5jZS0+bXNpX2ZsYWcpCisJCXBjaV9lbmFibGVfbXNpeChp
bnN0YW5jZS0+cGRldiwgJmluc3RhbmNlLT5tc2l4ZW50cnksIDEpOworCiAJLyoKIAkgKiBSZWdp
c3RlciBJUlEKIAkgKi8KLQlpZiAocmVxdWVzdF9pcnEocGRldi0+aXJxLCBtZWdhc2FzX2lzciwg
SVJRRl9TSEFSRUQsCi0JCSJtZWdhc2FzIiwgaW5zdGFuY2UpKSB7CisJaWYgKHJlcXVlc3RfaXJx
KGluc3RhbmNlLT5tc2lfZmxhZyA/IGluc3RhbmNlLT5tc2l4ZW50cnkudmVjdG9yIDoKKwkJCXBk
ZXYtPmlycSwgbWVnYXNhc19pc3IsCisJCQlJUlFGX1NIQVJFRCwgIm1lZ2FzYXMiLCBpbnN0YW5j
ZSkpIHsKIAkJcHJpbnRrKEtFUk5fRVJSICJtZWdhc2FzOiBGYWlsZWQgdG8gcmVnaXN0ZXIgSVJR
XG4iKTsKIAkJZ290byBmYWlsX2lycTsKIAl9CkBAIC00MjE4LDcgKzQyNDIsMTAgQEAKIAogCWlu
c3RhbmNlLT5pbnN0YW5jZXQtPmRpc2FibGVfaW50cihpbnN0YW5jZS0+cmVnX3NldCk7CiAKLQlm
cmVlX2lycShpbnN0YW5jZS0+cGRldi0+aXJxLCBpbnN0YW5jZSk7CisJZnJlZV9pcnEoaW5zdGFu
Y2UtPm1zaV9mbGFnID8gaW5zdGFuY2UtPm1zaXhlbnRyeS52ZWN0b3IgOgorCQkgaW5zdGFuY2Ut
PnBkZXYtPmlycSwgaW5zdGFuY2UpOworCWlmIChpbnN0YW5jZS0+bXNpX2ZsYWcpCisJCXBjaV9k
aXNhYmxlX21zaXgoaW5zdGFuY2UtPnBkZXYpOwogCiAJbWVnYXNhc19yZWxlYXNlX21maShpbnN0
YW5jZSk7CiAKZGlmZiAtTmF1ciBsaW51eC0yLjYuMzctcmM1Lm9sZC9kcml2ZXJzL3Njc2kvbWVn
YXJhaWQvbWVnYXJhaWRfc2FzLmggbGludXgtMi42LjM3LXJjNS5uZXcvZHJpdmVycy9zY3NpL21l
Z2FyYWlkL21lZ2FyYWlkX3Nhcy5oCi0tLSBsaW51eC0yLjYuMzctcmM1Lm9sZC9kcml2ZXJzL3Nj
c2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmgJMjAxMC0xMi0yMSAwOTo0NTo1MC4wMDAwMDAwMDAg
LTA4MDAKKysrIGxpbnV4LTIuNi4zNy1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXMuaAkyMDEwLTEyLTIxIDA5OjQ5OjMwLjAwMDAwMDAwMCAtMDgwMApAQCAtMTMzNSw2
ICsxMzM1LDkgQEAKIAogCXN0cnVjdCB0aW1lcl9saXN0IGlvX2NvbXBsZXRpb25fdGltZXI7CiAJ
c3RydWN0IGxpc3RfaGVhZCBpbnRlcm5hbF9yZXNldF9wZW5kaW5nX3E7CisKKwl1OAltc2lfZmxh
ZzsKKwlzdHJ1Y3QgbXNpeF9lbnRyeSBtc2l4ZW50cnk7CiB9OwogCiBlbnVtIHsK
--0016e64ca430f30c140497efa68a--
