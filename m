From: adam radford <aradford@gmail.com>
Subject: [PATCH 11/14] megaraid_sas: Fix fault state handling
Date: Thu, 24 Feb 2011 20:57:04 -0800
Message-ID: <AANLkTin3+ym3Zt++foNWHg4XpxJmqiD9i-E65WCtrNdU@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e64c2a3a4f09c6049d14291f
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37349 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab1BYE7e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2011 23:59:34 -0500
Received: by wwb39 with SMTP id 39so1698558wwb.1
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2011 20:59:33 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e64c2a3a4f09c6049d14291f
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch for megaraid_sas fixes fault state handling in
megasas_transition_to_ready().

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-24
18:57:24.908150771 -0800
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-24
18:58:29.756368351 -0800
@@ -2614,7 +2614,9 @@
 		case MFI_STATE_FAULT:

 			printk(KERN_DEBUG "megasas: FW in FAULT state!!\n");
-			return -ENODEV;
+			max_wait = MEGASAS_RESET_WAIT_TIME;
+			cur_state = MFI_STATE_FAULT;
+			break;

 		case MFI_STATE_WAIT_HANDSHAKE:
 			/*

--0016e64c2a3a4f09c6049d14291f
Content-Type: application/octet-stream; name="megaraid_sas.patch11"
Content-Disposition: attachment; filename="megaraid_sas.patch11"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkkmlg4b0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfYmFzZS5jIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jCi0tLSBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXNfYmFzZS5jCTIwMTEtMDItMjQgMTg6NTc6MjQuOTA4MTUwNzcxIC0wODAwCisrKyBz
Y3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2Uu
YwkyMDExLTAyLTI0IDE4OjU4OjI5Ljc1NjM2ODM1MSAtMDgwMApAQCAtMjYxNCw3ICsyNjE0LDkg
QEAKIAkJY2FzZSBNRklfU1RBVEVfRkFVTFQ6CiAKIAkJCXByaW50ayhLRVJOX0RFQlVHICJtZWdh
c2FzOiBGVyBpbiBGQVVMVCBzdGF0ZSEhXG4iKTsKLQkJCXJldHVybiAtRU5PREVWOworCQkJbWF4
X3dhaXQgPSBNRUdBU0FTX1JFU0VUX1dBSVRfVElNRTsKKwkJCWN1cl9zdGF0ZSA9IE1GSV9TVEFU
RV9GQVVMVDsKKwkJCWJyZWFrOwogCiAJCWNhc2UgTUZJX1NUQVRFX1dBSVRfSEFORFNIQUtFOgog
CQkJLyoK
--0016e64c2a3a4f09c6049d14291f--
