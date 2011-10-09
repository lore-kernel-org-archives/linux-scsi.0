From: adam radford <aradford@gmail.com>
Subject: [PATCH 3/10] megaraid_sas: Fix mismatch in megasas_reset_fusion()
 mutex lock-unlock
Date: Sat, 8 Oct 2011 18:14:39 -0700
Message-ID: <CAHtARFE1Hm1mjQLcyeYNw448rASkp3kCcH84VnY7QH3hYavrpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016364d2569fd917604aed36591
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63151 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1JIBOj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Oct 2011 21:14:39 -0400
Received: by mail-ww0-f44.google.com with SMTP id 22so7565389wwf.1
        for <linux-scsi@vger.kernel.org>; Sat, 08 Oct 2011 18:14:39 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016364d2569fd917604aed36591
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas will Fix mismatch in
megasas_reset_fusion() mutex lock-unlock.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-10-07
17:40:50.180237705 -0700
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-10-07
17:43:06.140237515 -0700
@@ -2057,8 +2057,7 @@
 	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
 		printk(KERN_WARNING "megaraid_sas: Hardware critical error, "
 		       "returning FAILED.\n");
-		retval = FAILED;
-		goto out;
+		return FAILED;
 	}

 	mutex_lock(&instance->reset_mutex);

--0016364d2569fd917604aed36591
Content-Type: application/octet-stream; name="megaraid_sas.patch3"
Content-Disposition: attachment; filename="megaraid_sas.patch3"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gtjbs60h0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfZnVzaW9uLmMgc2NzaS1taXNjLTIuNi5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2Fy
YWlkX3Nhc19mdXNpb24uYwotLS0gc2NzaS1taXNjLTIuNi9kcml2ZXJzL3Njc2kvbWVnYXJhaWQv
bWVnYXJhaWRfc2FzX2Z1c2lvbi5jCTIwMTEtMTAtMDcgMTc6NDA6NTAuMTgwMjM3NzA1IC0wNzAw
CisrKyBzY3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2Fz
X2Z1c2lvbi5jCTIwMTEtMTAtMDcgMTc6NDM6MDYuMTQwMjM3NTE1IC0wNzAwCkBAIC0yMDU3LDgg
KzIwNTcsNyBAQAogCWlmIChpbnN0YW5jZS0+YWRwcmVjb3ZlcnkgPT0gTUVHQVNBU19IV19DUklU
SUNBTF9FUlJPUikgewogCQlwcmludGsoS0VSTl9XQVJOSU5HICJtZWdhcmFpZF9zYXM6IEhhcmR3
YXJlIGNyaXRpY2FsIGVycm9yLCAiCiAJCSAgICAgICAicmV0dXJuaW5nIEZBSUxFRC5cbiIpOwot
CQlyZXR2YWwgPSBGQUlMRUQ7Ci0JCWdvdG8gb3V0OworCQlyZXR1cm4gRkFJTEVEOwogCX0KIAog
CW11dGV4X2xvY2soJmluc3RhbmNlLT5yZXNldF9tdXRleCk7Cg==
--0016364d2569fd917604aed36591--
