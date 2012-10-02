From: adam radford <aradford@gmail.com>
Subject: [PATCH 2/7] megaraid_sas: Add module param for configurable MSI-X
 vector count
Date: Mon, 1 Oct 2012 19:26:59 -0700
Message-ID: <CAHtARFFb6hkxFsdRxOe4f7kbstegyjBrTRdMQEpBGo4ED8qf-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf3071ccc0b79c6d04cb0a41f7
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48521 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547Ab2JBC07 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Oct 2012 22:26:59 -0400
Received: by mail-vc0-f174.google.com with SMTP id fo13so6426342vcb.19
        for <linux-scsi@vger.kernel.org>; Mon, 01 Oct 2012 19:26:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Kashyap Desai <Kashyap.Desai@lsi.com>

--20cf3071ccc0b79c6d04cb0a41f7
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas adds a module parameter for
configurable MSI-X vector count.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc/drivers/scsi/megaraid/megaraid_sas_base.c	2012-10-01
18:03:42.000000000 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c	2012-10-01
18:05:20.831864155 -0700
@@ -71,6 +71,10 @@
 module_param(msix_disable, int, S_IRUGO);
 MODULE_PARM_DESC(msix_disable, "Disable MSI-X interrupt handling. Default: 0");

+static unsigned int msix_vectors;
+module_param(msix_vectors, int, S_IRUGO);
+MODULE_PARM_DESC(msix_vectors, "MSI-X max vector count. Default: Set by FW");
+
 static int throttlequeuedepth = MEGASAS_THROTTLE_QUEUE_DEPTH;
 module_param(throttlequeuedepth, int, S_IRUGO);
 MODULE_PARM_DESC(throttlequeuedepth,
@@ -3520,6 +3524,10 @@
 			instance->msix_vectors = (readl(&instance->reg_set->
 							outbound_scratch_pad_2
 							  ) & 0x1F) + 1;
+			if (msix_vectors)
+				instance->msix_vectors =
+					min(msix_vectors,
+					    instance->msix_vectors);
 		} else
 			instance->msix_vectors = 1;
 		/* Don't bother allocating more MSI-X vectors than cpus */

--20cf3071ccc0b79c6d04cb0a41f7
Content-Type: application/octet-stream; name="megaraid_sas.patch2"
Content-Disposition: attachment; filename="megaraid_sas.patch2"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19i
YXNlLmMgc2NzaS1taXNjLm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jh
c2UuYwotLS0gc2NzaS1taXNjL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFz
ZS5jCTIwMTItMTAtMDEgMTg6MDM6NDIuMDAwMDAwMDAwIC0wNzAwCisrKyBzY3NpLW1pc2MubmV3
L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTItMTAtMDEgMTg6
MDU6MjAuODMxODY0MTU1IC0wNzAwCkBAIC03MSw2ICs3MSwxMCBAQAogbW9kdWxlX3BhcmFtKG1z
aXhfZGlzYWJsZSwgaW50LCBTX0lSVUdPKTsKIE1PRFVMRV9QQVJNX0RFU0MobXNpeF9kaXNhYmxl
LCAiRGlzYWJsZSBNU0ktWCBpbnRlcnJ1cHQgaGFuZGxpbmcuIERlZmF1bHQ6IDAiKTsKIAorc3Rh
dGljIHVuc2lnbmVkIGludCBtc2l4X3ZlY3RvcnM7Cittb2R1bGVfcGFyYW0obXNpeF92ZWN0b3Jz
LCBpbnQsIFNfSVJVR08pOworTU9EVUxFX1BBUk1fREVTQyhtc2l4X3ZlY3RvcnMsICJNU0ktWCBt
YXggdmVjdG9yIGNvdW50LiBEZWZhdWx0OiBTZXQgYnkgRlciKTsKKwogc3RhdGljIGludCB0aHJv
dHRsZXF1ZXVlZGVwdGggPSBNRUdBU0FTX1RIUk9UVExFX1FVRVVFX0RFUFRIOwogbW9kdWxlX3Bh
cmFtKHRocm90dGxlcXVldWVkZXB0aCwgaW50LCBTX0lSVUdPKTsKIE1PRFVMRV9QQVJNX0RFU0Mo
dGhyb3R0bGVxdWV1ZWRlcHRoLApAQCAtMzUyMCw2ICszNTI0LDEwIEBACiAJCQlpbnN0YW5jZS0+
bXNpeF92ZWN0b3JzID0gKHJlYWRsKCZpbnN0YW5jZS0+cmVnX3NldC0+CiAJCQkJCQkJb3V0Ym91
bmRfc2NyYXRjaF9wYWRfMgogCQkJCQkJCSAgKSAmIDB4MUYpICsgMTsKKwkJCWlmIChtc2l4X3Zl
Y3RvcnMpCisJCQkJaW5zdGFuY2UtPm1zaXhfdmVjdG9ycyA9CisJCQkJCW1pbihtc2l4X3ZlY3Rv
cnMsCisJCQkJCSAgICBpbnN0YW5jZS0+bXNpeF92ZWN0b3JzKTsKIAkJfSBlbHNlCiAJCQlpbnN0
YW5jZS0+bXNpeF92ZWN0b3JzID0gMTsKIAkJLyogRG9uJ3QgYm90aGVyIGFsbG9jYXRpbmcgbW9y
ZSBNU0ktWCB2ZWN0b3JzIHRoYW4gY3B1cyAqLwo=
--20cf3071ccc0b79c6d04cb0a41f7--
