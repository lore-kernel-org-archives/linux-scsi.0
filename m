From: adam radford <aradford@gmail.com>
Subject: [PATCH 2/3] megaraid_sas: Add fpRead/WriteCapable,
 fpRead/WriteAcrossStripe checks
Date: Mon, 19 Mar 2012 19:50:00 -0700
Message-ID: <CAHtARFH-y4X1CjqOwhm80gZn_81G=mhOupDBoa1KPFJ-4594iQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e6d7855022e30504bba3bb25
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48389 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab2CTCuB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Mar 2012 22:50:01 -0400
Received: by mail-wi0-f178.google.com with SMTP id hq7so4616420wib.1
        for <linux-scsi@vger.kernel.org>; Mon, 19 Mar 2012 19:50:00 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e6d7855022e30504bba3bb25
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas fixes the fastpath code decision
logic to use fpRead/WriteCapable, fpRead/WriteAcrossStripe flags
instead of the old logic.  This fixes a bug where fastpath writes
could be sent to a read only LD.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fp.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fp.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fp.c	2012-03-19
17:39:08.313986900 -0700
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fp.c	2012-03-19
17:50:22.484862892 -0700
@@ -362,15 +362,20 @@
 	/* assume this IO needs the full row - we'll adjust if not true */
 	regSize             = stripSize;

-	/* If IO spans more than 1 strip, fp is not possible
-	   FP is not possible for writes on non-0 raid levels
-	   FP is not possible if LD is not capable */
-	if (num_strips > 1 || (!isRead && raid->level != 0) ||
-	    !raid->capability.fpCapable) {
+	/* Check if we can send this I/O via FastPath */
+	if (raid->capability.fpCapable) {
+		if (isRead)
+			io_info->fpOkForIo = (raid->capability.fpReadCapable &&
+					      ((num_strips == 1) ||
+					       raid->capability.
+					       fpReadAcrossStripe));
+		else
+			io_info->fpOkForIo = (raid->capability.fpWriteCapable &&
+					      ((num_strips == 1) ||
+					       raid->capability.
+					       fpWriteAcrossStripe));
+	} else
 		io_info->fpOkForIo = FALSE;
-	} else {
-		io_info->fpOkForIo = TRUE;
-	}

 	if (numRows == 1) {
 		/* single-strip IOs can always lock only the data needed */

--0016e6d7855022e30504bba3bb25
Content-Type: application/octet-stream; name="megaraid_sas.patch2"
Content-Disposition: attachment; filename="megaraid_sas.patch2"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h00cbidb0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfZnAuYyBzY3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRf
c2FzX2ZwLmMKLS0tIHNjc2ktbWlzYy0yLjYvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlk
X3Nhc19mcC5jCTIwMTItMDMtMTkgMTc6Mzk6MDguMzEzOTg2OTAwIC0wNzAwCisrKyBzY3NpLW1p
c2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2ZwLmMJMjAxMi0w
My0xOSAxNzo1MDoyMi40ODQ4NjI4OTIgLTA3MDAKQEAgLTM2MiwxNSArMzYyLDIwIEBACiAJLyog
YXNzdW1lIHRoaXMgSU8gbmVlZHMgdGhlIGZ1bGwgcm93IC0gd2UnbGwgYWRqdXN0IGlmIG5vdCB0
cnVlICovCiAJcmVnU2l6ZSAgICAgICAgICAgICA9IHN0cmlwU2l6ZTsKIAotCS8qIElmIElPIHNw
YW5zIG1vcmUgdGhhbiAxIHN0cmlwLCBmcCBpcyBub3QgcG9zc2libGUKLQkgICBGUCBpcyBub3Qg
cG9zc2libGUgZm9yIHdyaXRlcyBvbiBub24tMCByYWlkIGxldmVscwotCSAgIEZQIGlzIG5vdCBw
b3NzaWJsZSBpZiBMRCBpcyBub3QgY2FwYWJsZSAqLwotCWlmIChudW1fc3RyaXBzID4gMSB8fCAo
IWlzUmVhZCAmJiByYWlkLT5sZXZlbCAhPSAwKSB8fAotCSAgICAhcmFpZC0+Y2FwYWJpbGl0eS5m
cENhcGFibGUpIHsKKwkvKiBDaGVjayBpZiB3ZSBjYW4gc2VuZCB0aGlzIEkvTyB2aWEgRmFzdFBh
dGggKi8KKwlpZiAocmFpZC0+Y2FwYWJpbGl0eS5mcENhcGFibGUpIHsKKwkJaWYgKGlzUmVhZCkK
KwkJCWlvX2luZm8tPmZwT2tGb3JJbyA9IChyYWlkLT5jYXBhYmlsaXR5LmZwUmVhZENhcGFibGUg
JiYKKwkJCQkJICAgICAgKChudW1fc3RyaXBzID09IDEpIHx8CisJCQkJCSAgICAgICByYWlkLT5j
YXBhYmlsaXR5LgorCQkJCQkgICAgICAgZnBSZWFkQWNyb3NzU3RyaXBlKSk7CisJCWVsc2UKKwkJ
CWlvX2luZm8tPmZwT2tGb3JJbyA9IChyYWlkLT5jYXBhYmlsaXR5LmZwV3JpdGVDYXBhYmxlICYm
CisJCQkJCSAgICAgICgobnVtX3N0cmlwcyA9PSAxKSB8fAorCQkJCQkgICAgICAgcmFpZC0+Y2Fw
YWJpbGl0eS4KKwkJCQkJICAgICAgIGZwV3JpdGVBY3Jvc3NTdHJpcGUpKTsKKwl9IGVsc2UKIAkJ
aW9faW5mby0+ZnBPa0ZvcklvID0gRkFMU0U7Ci0JfSBlbHNlIHsKLQkJaW9faW5mby0+ZnBPa0Zv
cklvID0gVFJVRTsKLQl9CiAKIAlpZiAobnVtUm93cyA9PSAxKSB7CiAJCS8qIHNpbmdsZS1zdHJp
cCBJT3MgY2FuIGFsd2F5cyBsb2NrIG9ubHkgdGhlIGRhdGEgbmVlZGVkICovCg==
--0016e6d7855022e30504bba3bb25--
