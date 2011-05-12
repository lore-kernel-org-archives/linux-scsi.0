From: adam radford <aradford@gmail.com>
Subject: [PATCH 4/8] megaraid_sas: Disable interrupts/free_irq() in megasas_shutdown()
Date: Wed, 11 May 2011 18:34:17 -0700
Message-ID: <BANLkTinuHhbhaaOHMTO7v1wV1dKxU3K+rw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=00163646cede08a47a04a30a302a
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57992 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab1ELBeS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 May 2011 21:34:18 -0400
Received: by qyk7 with SMTP id 7so2650853qyk.19
        for <linux-scsi@vger.kernel.org>; Wed, 11 May 2011 18:34:17 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--00163646cede08a47a04a30a302a
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas disables interrupts and
free_irq() in megasas_shutdown().

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc/drivers/scsi/megaraid/megaraid_sas_base.c	2011-05-11
15:00:35.611429804 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-05-11
15:11:39.991367267 -0700
@@ -4526,6 +4526,11 @@
 	instance->unload = 1;
 	megasas_flush_cache(instance);
 	megasas_shutdown_controller(instance, MR_DCMD_CTRL_SHUTDOWN);
+	instance->instancet->disable_intr(instance->reg_set);
+	free_irq(instance->msi_flag ? instance->msixentry.vector :
+		 instance->pdev->irq, instance);
+	if (instance->msi_flag)
+		pci_disable_msix(instance->pdev);
 }

 /**

--00163646cede08a47a04a30a302a
Content-Type: application/octet-stream; name="megaraid_sas.patch4"
Content-Disposition: attachment; filename="megaraid_sas.patch4"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gnl0ka8r0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19i
YXNlLmMgc2NzaS1taXNjLm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jh
c2UuYwotLS0gc2NzaS1taXNjL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFz
ZS5jCTIwMTEtMDUtMTEgMTU6MDA6MzUuNjExNDI5ODA0IC0wNzAwCisrKyBzY3NpLW1pc2MubmV3
L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTEtMDUtMTEgMTU6
MTE6MzkuOTkxMzY3MjY3IC0wNzAwCkBAIC00NTI2LDYgKzQ1MjYsMTEgQEAKIAlpbnN0YW5jZS0+
dW5sb2FkID0gMTsKIAltZWdhc2FzX2ZsdXNoX2NhY2hlKGluc3RhbmNlKTsKIAltZWdhc2FzX3No
dXRkb3duX2NvbnRyb2xsZXIoaW5zdGFuY2UsIE1SX0RDTURfQ1RSTF9TSFVURE9XTik7CisJaW5z
dGFuY2UtPmluc3RhbmNldC0+ZGlzYWJsZV9pbnRyKGluc3RhbmNlLT5yZWdfc2V0KTsKKwlmcmVl
X2lycShpbnN0YW5jZS0+bXNpX2ZsYWcgPyBpbnN0YW5jZS0+bXNpeGVudHJ5LnZlY3RvciA6CisJ
CSBpbnN0YW5jZS0+cGRldi0+aXJxLCBpbnN0YW5jZSk7CisJaWYgKGluc3RhbmNlLT5tc2lfZmxh
ZykKKwkJcGNpX2Rpc2FibGVfbXNpeChpbnN0YW5jZS0+cGRldik7CiB9CiAKIC8qKgo=
--00163646cede08a47a04a30a302a--
