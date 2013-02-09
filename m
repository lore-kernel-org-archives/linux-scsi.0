From: adam radford <aradford@gmail.com>
Subject: [PATCH 1/3] megaraid_sas: Add 4k FastPath DIF support
Date: Sat, 9 Feb 2013 15:29:15 -0800
Message-ID: <CAHtARFHk1VTDz7jbKbnU2-06CdfFp1o+z3rARYSGCGC6sd4oGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=485b397dcddb50a3fc04d5530b98
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f182.google.com ([209.85.216.182]:51929 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab3BIX3Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Feb 2013 18:29:16 -0500
Received: by mail-qc0-f182.google.com with SMTP id k19so1859483qcs.27
        for <linux-scsi@vger.kernel.org>; Sat, 09 Feb 2013 15:29:16 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Kashyap Desai <Kashyap.Desai@lsi.com>

--485b397dcddb50a3fc04d5530b98
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas will allow Fastpath T10PI/DIF
frame builds to work with 4k sector size.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fusion.c	2013-02-08
13:20:39.000000000 -0800
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2013-02-09
22:41:23.871865168 -0800
@@ -1206,7 +1206,7 @@
 				MPI2_SCSIIO_EEDPFLAGS_INSERT_OP;
 		}
 		io_request->Control |= (0x4 << 26);
-		io_request->EEDPBlockSize = MEGASAS_EEDPBLOCKSIZE;
+		io_request->EEDPBlockSize = scp->device->sector_size;
 	} else {
 		/* Some drives don't support 16/12 byte CDB's, convert to 10 */
 		if (((cdb_len == 12) || (cdb_len == 16)) &&
diff -Naur scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fusion.h
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.h
--- scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fusion.h	2013-02-08
13:20:39.000000000 -0800
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.h	2013-02-09
22:41:38.372866533 -0800
@@ -61,7 +61,6 @@
 #define MEGASAS_SCSI_ADDL_CDB_LEN                   0x18
 #define MEGASAS_RD_WR_PROTECT_CHECK_ALL		    0x20
 #define MEGASAS_RD_WR_PROTECT_CHECK_NONE	    0x60
-#define MEGASAS_EEDPBLOCKSIZE			    512

 /*
  * Raid context flags

--485b397dcddb50a3fc04d5530b98
Content-Type: application/octet-stream; name="megaraid_sas.patch1"
Content-Disposition: attachment; filename="megaraid_sas.patch1"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hcze0zbr0

ZGlmZiAtTmF1ciBzY3NpLW1pc2Mub2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfZnVzaW9uLmMgc2NzaS1taXNjLm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRf
c2FzX2Z1c2lvbi5jCi0tLSBzY3NpLW1pc2Mub2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXNfZnVzaW9uLmMJMjAxMy0wMi0wOCAxMzoyMDozOS4wMDAwMDAwMDAgLTA4MDAKKysr
IHNjc2ktbWlzYy5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24u
YwkyMDEzLTAyLTA5IDIyOjQxOjIzLjg3MTg2NTE2OCAtMDgwMApAQCAtMTIwNiw3ICsxMjA2LDcg
QEAKIAkJCQlNUEkyX1NDU0lJT19FRURQRkxBR1NfSU5TRVJUX09QOwogCQl9CiAJCWlvX3JlcXVl
c3QtPkNvbnRyb2wgfD0gKDB4NCA8PCAyNik7Ci0JCWlvX3JlcXVlc3QtPkVFRFBCbG9ja1NpemUg
PSBNRUdBU0FTX0VFRFBCTE9DS1NJWkU7CisJCWlvX3JlcXVlc3QtPkVFRFBCbG9ja1NpemUgPSBz
Y3AtPmRldmljZS0+c2VjdG9yX3NpemU7CiAJfSBlbHNlIHsKIAkJLyogU29tZSBkcml2ZXMgZG9u
J3Qgc3VwcG9ydCAxNi8xMiBieXRlIENEQidzLCBjb252ZXJ0IHRvIDEwICovCiAJCWlmICgoKGNk
Yl9sZW4gPT0gMTIpIHx8IChjZGJfbGVuID09IDE2KSkgJiYKZGlmZiAtTmF1ciBzY3NpLW1pc2Mu
b2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmggc2NzaS1taXNj
Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Z1c2lvbi5oCi0tLSBzY3Np
LW1pc2Mub2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmgJMjAx
My0wMi0wOCAxMzoyMDozOS4wMDAwMDAwMDAgLTA4MDAKKysrIHNjc2ktbWlzYy5uZXcvZHJpdmVy
cy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24uaAkyMDEzLTAyLTA5IDIyOjQxOjM4
LjM3Mjg2NjUzMyAtMDgwMApAQCAtNjEsNyArNjEsNiBAQAogI2RlZmluZSBNRUdBU0FTX1NDU0lf
QURETF9DREJfTEVOICAgICAgICAgICAgICAgICAgIDB4MTgKICNkZWZpbmUgTUVHQVNBU19SRF9X
Ul9QUk9URUNUX0NIRUNLX0FMTAkJICAgIDB4MjAKICNkZWZpbmUgTUVHQVNBU19SRF9XUl9QUk9U
RUNUX0NIRUNLX05PTkUJICAgIDB4NjAKLSNkZWZpbmUgTUVHQVNBU19FRURQQkxPQ0tTSVpFCQkJ
ICAgIDUxMgogCiAvKgogICogUmFpZCBjb250ZXh0IGZsYWdzCg==
--485b397dcddb50a3fc04d5530b98--
