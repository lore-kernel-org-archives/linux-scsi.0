From: adam radford <aradford@gmail.com>
Subject: [PATCH 7/15] megaraid_sas: Sanity check user supplied length in megasas_mgmt_fw_ioctl
Date: Sat, 19 Feb 2011 18:22:48 -0800
Message-ID: <AANLkTimgTBkOXV3gdvrQH0Vj7UnY6fXNECsFGc=7j2fO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e64c1e24640fad049cad6cd9
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65295 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab1BTCZ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2011 21:25:29 -0500
Received: by mail-ww0-f44.google.com with SMTP id 36so5038199wwa.1
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2011 18:25:28 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e64c1e24640fad049cad6cd9
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch from Bjorn Mork for megaraid_sas sanity checks the
user supplied length in
megasas_mgmt_fw_ioctl() to prevent a null pointer dereference in
dma_alloc_coherent() while running
smartmontools.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_base.c
linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-19
14:07:13.455395141 -0800
+++ linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-19
14:08:31.914332199 -0800
@@ -4630,6 +4630,11 @@
 	 * For each user buffer, create a mirror buffer and copy in
 	 */
 	for (i = 0; i < ioc->sge_count; i++) {
+		if (ioc->sgl[i].iov_len == 0) {
+			kbuff_arr[i] = NULL;
+			continue;
+		}
+
 		kbuff_arr[i] = dma_alloc_coherent(&instance->pdev->dev,
 						    ioc->sgl[i].iov_len,
 						    &buf_handle, GFP_KERNEL);

--0016e64c1e24640fad049cad6cd9
Content-Type: application/octet-stream; name="megaraid_sas.patch7"
Content-Disposition: attachment; filename="megaraid_sas.patch7"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkdb4nks0

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzgtcmM1L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jIGxpbnV4LTIuNi4zOC1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9t
ZWdhcmFpZF9zYXNfYmFzZS5jCi0tLSBsaW51eC0yLjYuMzgtcmM1L2RyaXZlcnMvc2NzaS9tZWdh
cmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTEtMDItMTkgMTQ6MDc6MTMuNDU1Mzk1MTQxIC0w
ODAwCisrKyBsaW51eC0yLjYuMzgtcmM1Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJh
aWRfc2FzX2Jhc2UuYwkyMDExLTAyLTE5IDE0OjA4OjMxLjkxNDMzMjE5OSAtMDgwMApAQCAtNDYz
MCw2ICs0NjMwLDExIEBACiAJICogRm9yIGVhY2ggdXNlciBidWZmZXIsIGNyZWF0ZSBhIG1pcnJv
ciBidWZmZXIgYW5kIGNvcHkgaW4KIAkgKi8KIAlmb3IgKGkgPSAwOyBpIDwgaW9jLT5zZ2VfY291
bnQ7IGkrKykgeworCQlpZiAoaW9jLT5zZ2xbaV0uaW92X2xlbiA9PSAwKSB7CisJCQlrYnVmZl9h
cnJbaV0gPSBOVUxMOworCQkJY29udGludWU7CisJCX0KKwogCQlrYnVmZl9hcnJbaV0gPSBkbWFf
YWxsb2NfY29oZXJlbnQoJmluc3RhbmNlLT5wZGV2LT5kZXYsCiAJCQkJCQkgICAgaW9jLT5zZ2xb
aV0uaW92X2xlbiwKIAkJCQkJCSAgICAmYnVmX2hhbmRsZSwgR0ZQX0tFUk5FTCk7Cg==
--0016e64c1e24640fad049cad6cd9--
