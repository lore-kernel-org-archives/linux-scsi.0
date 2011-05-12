From: adam radford <aradford@gmail.com>
Subject: [PATCH 6/8] megaraid_sas: Convert 6,10,12 byte CDB's for FastPath IO
Date: Wed, 11 May 2011 18:34:40 -0700
Message-ID: <BANLkTinwLMU7S5rr-XUVhrnZywDa+Nmz7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016364ede6c638dd904a30a311d
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57992 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365Ab1ELBek (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 May 2011 21:34:40 -0400
Received: by mail-qy0-f174.google.com with SMTP id 7so2650853qyk.19
        for <linux-scsi@vger.kernel.org>; Wed, 11 May 2011 18:34:40 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016364ede6c638dd904a30a311d
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas converts 6,10,12 byte CDB's to 16
byte CDB for large LBA's for FastPath IO.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-05-11
15:00:38.730367313 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-05-11
15:36:16.087430239 -0700
@@ -1137,7 +1137,7 @@
 	u64 start_blk = io_info->pdBlock;
 	u8 *cdb = io_request->CDB.CDB32;
 	u32 num_blocks = io_info->numBlocks;
-	u8 opcode, flagvals, groupnum, control;
+	u8 opcode = 0, flagvals = 0, groupnum = 0, control = 0;

 	/* Check if T10 PI (DIF) is enabled for this LD */
 	ld = MR_TargetIdToLdGet(io_info->ldTgtId, local_map_ptr);
@@ -1219,7 +1219,46 @@
 			cdb[8] = (u8)(num_blocks & 0xff);
 			cdb[7] = (u8)((num_blocks >> 8) & 0xff);

+			io_request->IoFlags = 10; /* Specify 10-byte cdb */
 			cdb_len = 10;
+		} else if ((cdb_len < 16) && (start_blk > 0xffffffff)) {
+			/* Convert to 16 byte CDB for large LBA's */
+			switch (cdb_len) {
+			case 6:
+				opcode = cdb[0] == READ_6 ? READ_16 : WRITE_16;
+				control = cdb[5];
+				break;
+			case 10:
+				opcode =
+					cdb[0] == READ_10 ? READ_16 : WRITE_16;
+				flagvals = cdb[1];
+				groupnum = cdb[6];
+				control = cdb[9];
+				break;
+			case 12:
+				opcode =
+					cdb[0] == READ_12 ? READ_16 : WRITE_16;
+				flagvals = cdb[1];
+				groupnum = cdb[10];
+				control = cdb[11];
+				break;
+			}
+
+			memset(cdb, 0, sizeof(io_request->CDB.CDB32));
+
+			cdb[0] = opcode;
+			cdb[1] = flagvals;
+			cdb[14] = groupnum;
+			cdb[15] = control;
+
+			/* Transfer length */
+			cdb[13] = (u8)(num_blocks & 0xff);
+			cdb[12] = (u8)((num_blocks >> 8) & 0xff);
+			cdb[11] = (u8)((num_blocks >> 16) & 0xff);
+			cdb[10] = (u8)((num_blocks >> 24) & 0xff);
+
+			io_request->IoFlags = 16; /* Specify 16-byte cdb */
+			cdb_len = 16;
 		}

 		/* Normal case, just load LBA here */

--0016364ede6c638dd904a30a311d
Content-Type: application/octet-stream; name="megaraid_sas.patch6"
Content-Disposition: attachment; filename="megaraid_sas.patch6"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gnl0osoh0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19m
dXNpb24uYyBzY3NpLW1pc2MubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNf
ZnVzaW9uLmMKLS0tIHNjc2ktbWlzYy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2Fz
X2Z1c2lvbi5jCTIwMTEtMDUtMTEgMTU6MDA6MzguNzMwMzY3MzEzIC0wNzAwCisrKyBzY3NpLW1p
c2MubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmMJMjAxMS0w
NS0xMSAxNTozNjoxNi4wODc0MzAyMzkgLTA3MDAKQEAgLTExMzcsNyArMTEzNyw3IEBACiAJdTY0
IHN0YXJ0X2JsayA9IGlvX2luZm8tPnBkQmxvY2s7CiAJdTggKmNkYiA9IGlvX3JlcXVlc3QtPkNE
Qi5DREIzMjsKIAl1MzIgbnVtX2Jsb2NrcyA9IGlvX2luZm8tPm51bUJsb2NrczsKLQl1OCBvcGNv
ZGUsIGZsYWd2YWxzLCBncm91cG51bSwgY29udHJvbDsKKwl1OCBvcGNvZGUgPSAwLCBmbGFndmFs
cyA9IDAsIGdyb3VwbnVtID0gMCwgY29udHJvbCA9IDA7CiAKIAkvKiBDaGVjayBpZiBUMTAgUEkg
KERJRikgaXMgZW5hYmxlZCBmb3IgdGhpcyBMRCAqLwogCWxkID0gTVJfVGFyZ2V0SWRUb0xkR2V0
KGlvX2luZm8tPmxkVGd0SWQsIGxvY2FsX21hcF9wdHIpOwpAQCAtMTIxOSw3ICsxMjE5LDQ2IEBA
CiAJCQljZGJbOF0gPSAodTgpKG51bV9ibG9ja3MgJiAweGZmKTsKIAkJCWNkYls3XSA9ICh1OCko
KG51bV9ibG9ja3MgPj4gOCkgJiAweGZmKTsKIAorCQkJaW9fcmVxdWVzdC0+SW9GbGFncyA9IDEw
OyAvKiBTcGVjaWZ5IDEwLWJ5dGUgY2RiICovCiAJCQljZGJfbGVuID0gMTA7CisJCX0gZWxzZSBp
ZiAoKGNkYl9sZW4gPCAxNikgJiYgKHN0YXJ0X2JsayA+IDB4ZmZmZmZmZmYpKSB7CisJCQkvKiBD
b252ZXJ0IHRvIDE2IGJ5dGUgQ0RCIGZvciBsYXJnZSBMQkEncyAqLworCQkJc3dpdGNoIChjZGJf
bGVuKSB7CisJCQljYXNlIDY6CisJCQkJb3Bjb2RlID0gY2RiWzBdID09IFJFQURfNiA/IFJFQURf
MTYgOiBXUklURV8xNjsKKwkJCQljb250cm9sID0gY2RiWzVdOworCQkJCWJyZWFrOworCQkJY2Fz
ZSAxMDoKKwkJCQlvcGNvZGUgPQorCQkJCQljZGJbMF0gPT0gUkVBRF8xMCA/IFJFQURfMTYgOiBX
UklURV8xNjsKKwkJCQlmbGFndmFscyA9IGNkYlsxXTsKKwkJCQlncm91cG51bSA9IGNkYls2XTsK
KwkJCQljb250cm9sID0gY2RiWzldOworCQkJCWJyZWFrOworCQkJY2FzZSAxMjoKKwkJCQlvcGNv
ZGUgPQorCQkJCQljZGJbMF0gPT0gUkVBRF8xMiA/IFJFQURfMTYgOiBXUklURV8xNjsKKwkJCQlm
bGFndmFscyA9IGNkYlsxXTsKKwkJCQlncm91cG51bSA9IGNkYlsxMF07CisJCQkJY29udHJvbCA9
IGNkYlsxMV07CisJCQkJYnJlYWs7CisJCQl9CisKKwkJCW1lbXNldChjZGIsIDAsIHNpemVvZihp
b19yZXF1ZXN0LT5DREIuQ0RCMzIpKTsKKworCQkJY2RiWzBdID0gb3Bjb2RlOworCQkJY2RiWzFd
ID0gZmxhZ3ZhbHM7CisJCQljZGJbMTRdID0gZ3JvdXBudW07CisJCQljZGJbMTVdID0gY29udHJv
bDsKKworCQkJLyogVHJhbnNmZXIgbGVuZ3RoICovCisJCQljZGJbMTNdID0gKHU4KShudW1fYmxv
Y2tzICYgMHhmZik7CisJCQljZGJbMTJdID0gKHU4KSgobnVtX2Jsb2NrcyA+PiA4KSAmIDB4ZmYp
OworCQkJY2RiWzExXSA9ICh1OCkoKG51bV9ibG9ja3MgPj4gMTYpICYgMHhmZik7CisJCQljZGJb
MTBdID0gKHU4KSgobnVtX2Jsb2NrcyA+PiAyNCkgJiAweGZmKTsKKworCQkJaW9fcmVxdWVzdC0+
SW9GbGFncyA9IDE2OyAvKiBTcGVjaWZ5IDE2LWJ5dGUgY2RiICovCisJCQljZGJfbGVuID0gMTY7
CiAJCX0KIAogCQkvKiBOb3JtYWwgY2FzZSwganVzdCBsb2FkIExCQSBoZXJlICovCg==
--0016364ede6c638dd904a30a311d--
