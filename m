From: adam radford <aradford@gmail.com>
Subject: [PATCH 4/14] megaraid_sas: Call tasklet_schedule for MSI-X
Date: Thu, 24 Feb 2011 20:56:21 -0800
Message-ID: <AANLkTin0iFsdi-m7B_XSqEsvTTEq6ydb-22NvJqb6BYo@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=000e0ce00132b838b9049d142691
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44391 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab1BYE4V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2011 23:56:21 -0500
Received: by mail-wy0-f174.google.com with SMTP id 36so1266125wyg.19
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2011 20:56:21 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--000e0ce00132b838b9049d142691
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch for megaraid_sas calls tasklet_schedule() even if
outbound_intr_status == 0 for MFI based boards in MSI-X mode.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-24
18:40:57.489181971 -0800
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-24
18:42:34.277276308 -0800
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

--000e0ce00132b838b9049d142691
Content-Type: application/octet-stream; name="megaraid_sas.patch4"
Content-Disposition: attachment; filename="megaraid_sas.patch4"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkkm46dm0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfYmFzZS5jIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jCi0tLSBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXNfYmFzZS5jCTIwMTEtMDItMjQgMTg6NDA6NTcuNDg5MTgxOTcxIC0wODAwCisrKyBz
Y3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2Uu
YwkyMDExLTAyLTI0IDE4OjQyOjM0LjI3NzI3NjMwOCAtMDgwMApAQCAtMjUwMyw3ICsyNTAzLDkg
QEAKIAlpZiAoKG1maVN0YXR1cyA9IGluc3RhbmNlLT5pbnN0YW5jZXQtPmNsZWFyX2ludHIoCiAJ
CQkJCQlpbnN0YW5jZS0+cmVnX3NldCkKIAkJCQkJCSkgPT0gMCkgewotCQlyZXR1cm4gSVJRX05P
TkU7CisJCS8qIEhhcmR3YXJlIG1heSBub3Qgc2V0IG91dGJvdW5kX2ludHJfc3RhdHVzIGluIE1T
SS1YIG1vZGUgKi8KKwkJaWYgKCFpbnN0YW5jZS0+bXNpX2ZsYWcpCisJCQlyZXR1cm4gSVJRX05P
TkU7CiAJfQogCiAJaW5zdGFuY2UtPm1maVN0YXR1cyA9IG1maVN0YXR1czsK
--000e0ce00132b838b9049d142691--
