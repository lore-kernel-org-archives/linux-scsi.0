From: adam radford <aradford@gmail.com>
Subject: [PATCH 3/7] megaraid_sas: Load io_request DataLength in bytes
Date: Mon, 1 Oct 2012 19:27:07 -0700
Message-ID: <CAHtARFHdUvH1iUcmN=k=tp52cvfkB3cgH_GNvDeJHbjYCkbKkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b6d7f4230121904cb0a4293
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:48158 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931Ab2JBC1I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Oct 2012 22:27:08 -0400
Received: by vbbff1 with SMTP id ff1so6100886vbb.19
        for <linux-scsi@vger.kernel.org>; Mon, 01 Oct 2012 19:27:07 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Kashyap Desai <Kashyap.Desai@lsi.com>

--047d7b6d7f4230121904cb0a4293
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas loads io_request->DataLength in
bytes for newer firmware that supports high availability.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc/drivers/scsi/megaraid/megaraid_sas_fusion.c	2012-10-01
16:53:27.302925502 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2012-10-01
17:02:57.316863262 -0700
@@ -1184,8 +1184,6 @@
 		io_request->CDB.EEDP32.PrimaryReferenceTag =
 			cpu_to_be32(ref_tag);
 		io_request->CDB.EEDP32.PrimaryApplicationTagMask = 0xffff;
-
-		io_request->DataLength = num_blocks * 512;
 		io_request->IoFlags = 32; /* Specify 32-byte cdb */

 		/* Transfer length */
@@ -1329,7 +1327,7 @@
 			  struct megasas_cmd_fusion *cmd)
 {
 	u8 fp_possible;
-	u32 start_lba_lo, start_lba_hi, device_id;
+	u32 start_lba_lo, start_lba_hi, device_id, datalength = 0;
 	struct MPI2_RAID_SCSI_IO_REQUEST *io_request;
 	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
 	struct IO_REQUEST_INFO io_info;
@@ -1355,7 +1353,7 @@
 	 * 6-byte READ(0x08) or WRITE(0x0A) cdb
 	 */
 	if (scp->cmd_len == 6) {
-		io_request->DataLength = (u32) scp->cmnd[4];
+		datalength = (u32) scp->cmnd[4];
 		start_lba_lo = ((u32) scp->cmnd[1] << 16) |
 			((u32) scp->cmnd[2] << 8) | (u32) scp->cmnd[3];

@@ -1366,7 +1364,7 @@
 	 * 10-byte READ(0x28) or WRITE(0x2A) cdb
 	 */
 	else if (scp->cmd_len == 10) {
-		io_request->DataLength = (u32) scp->cmnd[8] |
+		datalength = (u32) scp->cmnd[8] |
 			((u32) scp->cmnd[7] << 8);
 		start_lba_lo = ((u32) scp->cmnd[2] << 24) |
 			((u32) scp->cmnd[3] << 16) |
@@ -1377,7 +1375,7 @@
 	 * 12-byte READ(0xA8) or WRITE(0xAA) cdb
 	 */
 	else if (scp->cmd_len == 12) {
-		io_request->DataLength = ((u32) scp->cmnd[6] << 24) |
+		datalength = ((u32) scp->cmnd[6] << 24) |
 			((u32) scp->cmnd[7] << 16) |
 			((u32) scp->cmnd[8] << 8) | (u32) scp->cmnd[9];
 		start_lba_lo = ((u32) scp->cmnd[2] << 24) |
@@ -1389,7 +1387,7 @@
 	 * 16-byte READ(0x88) or WRITE(0x8A) cdb
 	 */
 	else if (scp->cmd_len == 16) {
-		io_request->DataLength = ((u32) scp->cmnd[10] << 24) |
+		datalength = ((u32) scp->cmnd[10] << 24) |
 			((u32) scp->cmnd[11] << 16) |
 			((u32) scp->cmnd[12] << 8) | (u32) scp->cmnd[13];
 		start_lba_lo = ((u32) scp->cmnd[6] << 24) |
@@ -1403,8 +1401,9 @@

 	memset(&io_info, 0, sizeof(struct IO_REQUEST_INFO));
 	io_info.ldStartBlock = ((u64)start_lba_hi << 32) | start_lba_lo;
-	io_info.numBlocks = io_request->DataLength;
+	io_info.numBlocks = datalength;
 	io_info.ldTgtId = device_id;
+	io_request->DataLength = scsi_bufflen(scp);

 	if (scp->sc_data_direction == PCI_DMA_FROMDEVICE)
 		io_info.isRead = 1;
@@ -1431,7 +1430,6 @@
 	if (fp_possible) {
 		megasas_set_pd_lba(io_request, scp->cmd_len, &io_info, scp,
 				   local_map_ptr, start_lba_lo);
-		io_request->DataLength = scsi_bufflen(scp);
 		io_request->Function = MPI2_FUNCTION_SCSI_IO_REQUEST;
 		cmd->request_desc->SCSIIO.RequestFlags =
 			(MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY

--047d7b6d7f4230121904cb0a4293
Content-Type: application/octet-stream; name="megaraid_sas.patch3"
Content-Disposition: attachment; filename="megaraid_sas.patch3"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19m
dXNpb24uYyBzY3NpLW1pc2MubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNf
ZnVzaW9uLmMKLS0tIHNjc2ktbWlzYy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2Fz
X2Z1c2lvbi5jCTIwMTItMTAtMDEgMTY6NTM6MjcuMzAyOTI1NTAyIC0wNzAwCisrKyBzY3NpLW1p
c2MubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmMJMjAxMi0x
MC0wMSAxNzowMjo1Ny4zMTY4NjMyNjIgLTA3MDAKQEAgLTExODQsOCArMTE4NCw2IEBACiAJCWlv
X3JlcXVlc3QtPkNEQi5FRURQMzIuUHJpbWFyeVJlZmVyZW5jZVRhZyA9CiAJCQljcHVfdG9fYmUz
MihyZWZfdGFnKTsKIAkJaW9fcmVxdWVzdC0+Q0RCLkVFRFAzMi5QcmltYXJ5QXBwbGljYXRpb25U
YWdNYXNrID0gMHhmZmZmOwotCi0JCWlvX3JlcXVlc3QtPkRhdGFMZW5ndGggPSBudW1fYmxvY2tz
ICogNTEyOwogCQlpb19yZXF1ZXN0LT5Jb0ZsYWdzID0gMzI7IC8qIFNwZWNpZnkgMzItYnl0ZSBj
ZGIgKi8KIAogCQkvKiBUcmFuc2ZlciBsZW5ndGggKi8KQEAgLTEzMjksNyArMTMyNyw3IEBACiAJ
CQkgIHN0cnVjdCBtZWdhc2FzX2NtZF9mdXNpb24gKmNtZCkKIHsKIAl1OCBmcF9wb3NzaWJsZTsK
LQl1MzIgc3RhcnRfbGJhX2xvLCBzdGFydF9sYmFfaGksIGRldmljZV9pZDsKKwl1MzIgc3RhcnRf
bGJhX2xvLCBzdGFydF9sYmFfaGksIGRldmljZV9pZCwgZGF0YWxlbmd0aCA9IDA7CiAJc3RydWN0
IE1QSTJfUkFJRF9TQ1NJX0lPX1JFUVVFU1QgKmlvX3JlcXVlc3Q7CiAJdW5pb24gTUVHQVNBU19S
RVFVRVNUX0RFU0NSSVBUT1JfVU5JT04gKnJlcV9kZXNjOwogCXN0cnVjdCBJT19SRVFVRVNUX0lO
Rk8gaW9faW5mbzsKQEAgLTEzNTUsNyArMTM1Myw3IEBACiAJICogNi1ieXRlIFJFQUQoMHgwOCkg
b3IgV1JJVEUoMHgwQSkgY2RiCiAJICovCiAJaWYgKHNjcC0+Y21kX2xlbiA9PSA2KSB7Ci0JCWlv
X3JlcXVlc3QtPkRhdGFMZW5ndGggPSAodTMyKSBzY3AtPmNtbmRbNF07CisJCWRhdGFsZW5ndGgg
PSAodTMyKSBzY3AtPmNtbmRbNF07CiAJCXN0YXJ0X2xiYV9sbyA9ICgodTMyKSBzY3AtPmNtbmRb
MV0gPDwgMTYpIHwKIAkJCSgodTMyKSBzY3AtPmNtbmRbMl0gPDwgOCkgfCAodTMyKSBzY3AtPmNt
bmRbM107CiAKQEAgLTEzNjYsNyArMTM2NCw3IEBACiAJICogMTAtYnl0ZSBSRUFEKDB4MjgpIG9y
IFdSSVRFKDB4MkEpIGNkYgogCSAqLwogCWVsc2UgaWYgKHNjcC0+Y21kX2xlbiA9PSAxMCkgewot
CQlpb19yZXF1ZXN0LT5EYXRhTGVuZ3RoID0gKHUzMikgc2NwLT5jbW5kWzhdIHwKKwkJZGF0YWxl
bmd0aCA9ICh1MzIpIHNjcC0+Y21uZFs4XSB8CiAJCQkoKHUzMikgc2NwLT5jbW5kWzddIDw8IDgp
OwogCQlzdGFydF9sYmFfbG8gPSAoKHUzMikgc2NwLT5jbW5kWzJdIDw8IDI0KSB8CiAJCQkoKHUz
Mikgc2NwLT5jbW5kWzNdIDw8IDE2KSB8CkBAIC0xMzc3LDcgKzEzNzUsNyBAQAogCSAqIDEyLWJ5
dGUgUkVBRCgweEE4KSBvciBXUklURSgweEFBKSBjZGIKIAkgKi8KIAllbHNlIGlmIChzY3AtPmNt
ZF9sZW4gPT0gMTIpIHsKLQkJaW9fcmVxdWVzdC0+RGF0YUxlbmd0aCA9ICgodTMyKSBzY3AtPmNt
bmRbNl0gPDwgMjQpIHwKKwkJZGF0YWxlbmd0aCA9ICgodTMyKSBzY3AtPmNtbmRbNl0gPDwgMjQp
IHwKIAkJCSgodTMyKSBzY3AtPmNtbmRbN10gPDwgMTYpIHwKIAkJCSgodTMyKSBzY3AtPmNtbmRb
OF0gPDwgOCkgfCAodTMyKSBzY3AtPmNtbmRbOV07CiAJCXN0YXJ0X2xiYV9sbyA9ICgodTMyKSBz
Y3AtPmNtbmRbMl0gPDwgMjQpIHwKQEAgLTEzODksNyArMTM4Nyw3IEBACiAJICogMTYtYnl0ZSBS
RUFEKDB4ODgpIG9yIFdSSVRFKDB4OEEpIGNkYgogCSAqLwogCWVsc2UgaWYgKHNjcC0+Y21kX2xl
biA9PSAxNikgewotCQlpb19yZXF1ZXN0LT5EYXRhTGVuZ3RoID0gKCh1MzIpIHNjcC0+Y21uZFsx
MF0gPDwgMjQpIHwKKwkJZGF0YWxlbmd0aCA9ICgodTMyKSBzY3AtPmNtbmRbMTBdIDw8IDI0KSB8
CiAJCQkoKHUzMikgc2NwLT5jbW5kWzExXSA8PCAxNikgfAogCQkJKCh1MzIpIHNjcC0+Y21uZFsx
Ml0gPDwgOCkgfCAodTMyKSBzY3AtPmNtbmRbMTNdOwogCQlzdGFydF9sYmFfbG8gPSAoKHUzMikg
c2NwLT5jbW5kWzZdIDw8IDI0KSB8CkBAIC0xNDAzLDggKzE0MDEsOSBAQAogCiAJbWVtc2V0KCZp
b19pbmZvLCAwLCBzaXplb2Yoc3RydWN0IElPX1JFUVVFU1RfSU5GTykpOwogCWlvX2luZm8ubGRT
dGFydEJsb2NrID0gKCh1NjQpc3RhcnRfbGJhX2hpIDw8IDMyKSB8IHN0YXJ0X2xiYV9sbzsKLQlp
b19pbmZvLm51bUJsb2NrcyA9IGlvX3JlcXVlc3QtPkRhdGFMZW5ndGg7CisJaW9faW5mby5udW1C
bG9ja3MgPSBkYXRhbGVuZ3RoOwogCWlvX2luZm8ubGRUZ3RJZCA9IGRldmljZV9pZDsKKwlpb19y
ZXF1ZXN0LT5EYXRhTGVuZ3RoID0gc2NzaV9idWZmbGVuKHNjcCk7CiAKIAlpZiAoc2NwLT5zY19k
YXRhX2RpcmVjdGlvbiA9PSBQQ0lfRE1BX0ZST01ERVZJQ0UpCiAJCWlvX2luZm8uaXNSZWFkID0g
MTsKQEAgLTE0MzEsNyArMTQzMCw2IEBACiAJaWYgKGZwX3Bvc3NpYmxlKSB7CiAJCW1lZ2FzYXNf
c2V0X3BkX2xiYShpb19yZXF1ZXN0LCBzY3AtPmNtZF9sZW4sICZpb19pbmZvLCBzY3AsCiAJCQkJ
ICAgbG9jYWxfbWFwX3B0ciwgc3RhcnRfbGJhX2xvKTsKLQkJaW9fcmVxdWVzdC0+RGF0YUxlbmd0
aCA9IHNjc2lfYnVmZmxlbihzY3ApOwogCQlpb19yZXF1ZXN0LT5GdW5jdGlvbiA9IE1QSTJfRlVO
Q1RJT05fU0NTSV9JT19SRVFVRVNUOwogCQljbWQtPnJlcXVlc3RfZGVzYy0+U0NTSUlPLlJlcXVl
c3RGbGFncyA9CiAJCQkoTVBJMl9SRVFfREVTQ1JJUFRfRkxBR1NfSElHSF9QUklPUklUWQo=
--047d7b6d7f4230121904cb0a4293--
