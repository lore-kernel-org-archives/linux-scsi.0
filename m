From: adam radford <aradford@gmail.com>
Subject: [PATCH 12/15] megaraid_sas: Fix fault state handling
Date: Sat, 19 Feb 2011 18:23:16 -0800
Message-ID: <AANLkTinwWh=w2TAf8yoaugEsAKMK-H3gz4k4-L6CVK9H@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e64c3e660932a0049cad6e53
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50704 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab1BTCXQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2011 21:23:16 -0500
Received: by mail-wy0-f174.google.com with SMTP id 38so105867wyb.19
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2011 18:23:16 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e64c3e660932a0049cad6e53
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch for megaraid_sas fixes fault state handling in
megasas_transition_to_ready().

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_base.c
linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-19
14:20:32.959395803 -0800
+++ linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-19
14:24:02.329426907 -0800
@@ -2614,7 +2614,9 @@
 		case MFI_STATE_FAULT:

 			printk(KERN_DEBUG "megasas: FW in FAULT state!!\n");
-			return -ENODEV;
+			max_wait = MEGASAS_RESET_WAIT_TIME;
+			cur_state = MFI_STATE_FAULT;
+			break;

 		case MFI_STATE_WAIT_HANDSHAKE:
 			/*

--0016e64c3e660932a0049cad6e53
Content-Type: application/octet-stream; name="megaraid_sas.patch12"
Content-Disposition: attachment; filename="megaraid_sas.patch12"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkdbemvy0

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzgtcmM1L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jIGxpbnV4LTIuNi4zOC1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9t
ZWdhcmFpZF9zYXNfYmFzZS5jCi0tLSBsaW51eC0yLjYuMzgtcmM1L2RyaXZlcnMvc2NzaS9tZWdh
cmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTEtMDItMTkgMTQ6MjA6MzIuOTU5Mzk1ODAzIC0w
ODAwCisrKyBsaW51eC0yLjYuMzgtcmM1Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJh
aWRfc2FzX2Jhc2UuYwkyMDExLTAyLTE5IDE0OjI0OjAyLjMyOTQyNjkwNyAtMDgwMApAQCAtMjYx
NCw3ICsyNjE0LDkgQEAKIAkJY2FzZSBNRklfU1RBVEVfRkFVTFQ6CiAKIAkJCXByaW50ayhLRVJO
X0RFQlVHICJtZWdhc2FzOiBGVyBpbiBGQVVMVCBzdGF0ZSEhXG4iKTsKLQkJCXJldHVybiAtRU5P
REVWOworCQkJbWF4X3dhaXQgPSBNRUdBU0FTX1JFU0VUX1dBSVRfVElNRTsKKwkJCWN1cl9zdGF0
ZSA9IE1GSV9TVEFURV9GQVVMVDsKKwkJCWJyZWFrOwogCiAJCWNhc2UgTUZJX1NUQVRFX1dBSVRf
SEFORFNIQUtFOgogCQkJLyoK
--0016e64c3e660932a0049cad6e53--
