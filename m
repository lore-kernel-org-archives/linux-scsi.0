From: adam radford <aradford@gmail.com>
Subject: [PATCH 4/15] megaraid_sas: Call tasklet_schedule for MSI-X
Date: Sat, 19 Feb 2011 18:22:31 -0800
Message-ID: <AANLkTi=MGp1-GG++U0dm57wKByJU2AUsFh3bXeBJY9dZ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001485f6c5ee61d07a049cad6b33
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52251 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab1BTCWc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2011 21:22:32 -0500
Received: by mail-ww0-f44.google.com with SMTP id 36so5037267wwa.1
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2011 18:22:31 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--001485f6c5ee61d07a049cad6b33
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch for megaraid_sas calls tasklet_schedule() even if
outbount_intr_status == 0 for
MFI based boards in MSI-X mode.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_base.c
linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-19
13:56:23.161332770 -0800
+++ linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-19
13:57:43.120395558 -0800
@@ -2503,7 +2503,9 @@
 	if ((mfiStatus = instance->instancet->clear_intr(
 						instance->reg_set)
 						) == 0) {
-		return IRQ_NONE;
+		/* Hardware may not set outbound_intr_status in MSI-X mode */
+		if (!instance->msi_flag)
+			return IRQ_NONE;
 	}

 	instance->mfiStatus = mfiStatus;

--001485f6c5ee61d07a049cad6b33
Content-Type: application/octet-stream; name="megaraid_sas.patch4"
Content-Disposition: attachment; filename="megaraid_sas.patch4"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkdav9680

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzgtcmM1L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jIGxpbnV4LTIuNi4zOC1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9t
ZWdhcmFpZF9zYXNfYmFzZS5jCi0tLSBsaW51eC0yLjYuMzgtcmM1L2RyaXZlcnMvc2NzaS9tZWdh
cmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTEtMDItMTkgMTM6NTY6MjMuMTYxMzMyNzcwIC0w
ODAwCisrKyBsaW51eC0yLjYuMzgtcmM1Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJh
aWRfc2FzX2Jhc2UuYwkyMDExLTAyLTE5IDEzOjU3OjQzLjEyMDM5NTU1OCAtMDgwMApAQCAtMjUw
Myw3ICsyNTAzLDkgQEAKIAlpZiAoKG1maVN0YXR1cyA9IGluc3RhbmNlLT5pbnN0YW5jZXQtPmNs
ZWFyX2ludHIoCiAJCQkJCQlpbnN0YW5jZS0+cmVnX3NldCkKIAkJCQkJCSkgPT0gMCkgewotCQly
ZXR1cm4gSVJRX05PTkU7CisJCS8qIEhhcmR3YXJlIG1heSBub3Qgc2V0IG91dGJvdW5kX2ludHJf
c3RhdHVzIGluIE1TSS1YIG1vZGUgKi8KKwkJaWYgKCFpbnN0YW5jZS0+bXNpX2ZsYWcpCisJCQly
ZXR1cm4gSVJRX05PTkU7CiAJfQogCiAJaW5zdGFuY2UtPm1maVN0YXR1cyA9IG1maVN0YXR1czsK
--001485f6c5ee61d07a049cad6b33--
