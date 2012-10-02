From: adam radford <aradford@gmail.com>
Subject: [PATCH 6/7] megaraid_sas: Remove duplicate code
Date: Mon, 1 Oct 2012 19:27:27 -0700
Message-ID: <CAHtARFHjKOD6MRvjdSLivAHjMbyCc6VqOAjuPAaniffLsn3-Ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=f46d04388de96de8e704cb0a435e
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48521 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757580Ab2JBC12 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Oct 2012 22:27:28 -0400
Received: by mail-vc0-f174.google.com with SMTP id fo13so6426342vcb.19
        for <linux-scsi@vger.kernel.org>; Mon, 01 Oct 2012 19:27:28 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Kashyap Desai <Kashyap.Desai@lsi.com>

--f46d04388de96de8e704cb0a435e
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas removes some duplicate code.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc/drivers/scsi/megaraid/megaraid_sas_base.c	2012-10-01
16:59:31.089925547 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c	2012-10-01
17:12:41.059956897 -0700
@@ -5241,7 +5241,6 @@

 		case MR_EVT_PD_REMOVED:
 			if (megasas_get_pd_list(instance) == 0) {
-			megasas_get_pd_list(instance);
 			for (i = 0; i < MEGASAS_MAX_PD_CHANNELS; i++) {
 				for (j = 0;
 				j < MEGASAS_MAX_DEV_PER_CHANNEL;
diff -Naur scsi-misc/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc/drivers/scsi/megaraid/megaraid_sas_fusion.c	2012-10-01
17:11:56.060925472 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2012-10-01
17:14:21.350863085 -0700
@@ -1733,8 +1733,6 @@
 	if (reply_descript_type == MPI2_RPY_DESCRIPT_FLAGS_UNUSED)
 		return IRQ_NONE;

-	d_val.word = desc->Words;
-
 	num_completed = 0;

 	while ((d_val.u.low != UINT_MAX) && (d_val.u.high != UINT_MAX)) {

--f46d04388de96de8e704cb0a435e
Content-Type: application/octet-stream; name="megaraid_sas.patch6"
Content-Disposition: attachment; filename="megaraid_sas.patch6"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19i
YXNlLmMgc2NzaS1taXNjLm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jh
c2UuYwotLS0gc2NzaS1taXNjL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFz
ZS5jCTIwMTItMTAtMDEgMTY6NTk6MzEuMDg5OTI1NTQ3IC0wNzAwCisrKyBzY3NpLW1pc2MubmV3
L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTItMTAtMDEgMTc6
MTI6NDEuMDU5OTU2ODk3IC0wNzAwCkBAIC01MjQxLDcgKzUyNDEsNiBAQAogCiAJCWNhc2UgTVJf
RVZUX1BEX1JFTU9WRUQ6CiAJCQlpZiAobWVnYXNhc19nZXRfcGRfbGlzdChpbnN0YW5jZSkgPT0g
MCkgewotCQkJbWVnYXNhc19nZXRfcGRfbGlzdChpbnN0YW5jZSk7CiAJCQlmb3IgKGkgPSAwOyBp
IDwgTUVHQVNBU19NQVhfUERfQ0hBTk5FTFM7IGkrKykgewogCQkJCWZvciAoaiA9IDA7CiAJCQkJ
aiA8IE1FR0FTQVNfTUFYX0RFVl9QRVJfQ0hBTk5FTDsKZGlmZiAtTmF1ciBzY3NpLW1pc2MvZHJp
dmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24uYyBzY3NpLW1pc2MubmV3L2Ry
aXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmMKLS0tIHNjc2ktbWlzYy9k
cml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Z1c2lvbi5jCTIwMTItMTAtMDEgMTc6
MTE6NTYuMDYwOTI1NDcyIC0wNzAwCisrKyBzY3NpLW1pc2MubmV3L2RyaXZlcnMvc2NzaS9tZWdh
cmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmMJMjAxMi0xMC0wMSAxNzoxNDoyMS4zNTA4NjMwODUg
LTA3MDAKQEAgLTE3MzMsOCArMTczMyw2IEBACiAJaWYgKHJlcGx5X2Rlc2NyaXB0X3R5cGUgPT0g
TVBJMl9SUFlfREVTQ1JJUFRfRkxBR1NfVU5VU0VEKQogCQlyZXR1cm4gSVJRX05PTkU7CiAKLQlk
X3ZhbC53b3JkID0gZGVzYy0+V29yZHM7Ci0KIAludW1fY29tcGxldGVkID0gMDsKIAogCXdoaWxl
ICgoZF92YWwudS5sb3cgIT0gVUlOVF9NQVgpICYmIChkX3ZhbC51LmhpZ2ggIT0gVUlOVF9NQVgp
KSB7Cg==
--f46d04388de96de8e704cb0a435e--
