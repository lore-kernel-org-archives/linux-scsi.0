From: adam radford <aradford@gmail.com>
Subject: [PATCH 4/7] megaraid_sas: Add array boundary check for SystemPD
Date: Mon, 1 Oct 2012 19:27:12 -0700
Message-ID: <CAHtARFFaP3YhoA1-5a6Ayn2uOzO-aMZO=nZpXpCORMxhF2=VbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=bcaec54eea8e80ffb904cb0a42c6
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48521 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757713Ab2JBC1N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Oct 2012 22:27:13 -0400
Received: by mail-vc0-f174.google.com with SMTP id fo13so6426342vcb.19
        for <linux-scsi@vger.kernel.org>; Mon, 01 Oct 2012 19:27:12 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Kashyap Desai <Kashyap.Desai@lsi.com>

--bcaec54eea8e80ffb904cb0a42c6
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas adds an array boundary check for
the SystemPD build path.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc/drivers/scsi/megaraid/megaraid_sas_fusion.c	2012-10-01
17:05:01.643925591 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2012-10-01
17:06:40.300862878 -0700
@@ -1508,7 +1508,8 @@
 	local_map_ptr = fusion->ld_map[(instance->map_id & 1)];

 	/* Check if this is a system PD I/O */
-	if (instance->pd_list[pd_index].driveState == MR_PD_STATE_SYSTEM) {
+	if (scmd->device->channel < MEGASAS_MAX_PD_CHANNELS &&
+	    instance->pd_list[pd_index].driveState == MR_PD_STATE_SYSTEM) {
 		io_request->Function = 0;
 		io_request->DevHandle =
 			local_map_ptr->raidMap.devHndlInfo[device_id].curDevHdl;

--bcaec54eea8e80ffb904cb0a42c6
Content-Type: application/octet-stream; name="megaraid_sas.patch4"
Content-Disposition: attachment; filename="megaraid_sas.patch4"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19m
dXNpb24uYyBzY3NpLW1pc2MubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNf
ZnVzaW9uLmMKLS0tIHNjc2ktbWlzYy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2Fz
X2Z1c2lvbi5jCTIwMTItMTAtMDEgMTc6MDU6MDEuNjQzOTI1NTkxIC0wNzAwCisrKyBzY3NpLW1p
c2MubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmMJMjAxMi0x
MC0wMSAxNzowNjo0MC4zMDA4NjI4NzggLTA3MDAKQEAgLTE1MDgsNyArMTUwOCw4IEBACiAJbG9j
YWxfbWFwX3B0ciA9IGZ1c2lvbi0+bGRfbWFwWyhpbnN0YW5jZS0+bWFwX2lkICYgMSldOwogCiAJ
LyogQ2hlY2sgaWYgdGhpcyBpcyBhIHN5c3RlbSBQRCBJL08gKi8KLQlpZiAoaW5zdGFuY2UtPnBk
X2xpc3RbcGRfaW5kZXhdLmRyaXZlU3RhdGUgPT0gTVJfUERfU1RBVEVfU1lTVEVNKSB7CisJaWYg
KHNjbWQtPmRldmljZS0+Y2hhbm5lbCA8IE1FR0FTQVNfTUFYX1BEX0NIQU5ORUxTICYmCisJICAg
IGluc3RhbmNlLT5wZF9saXN0W3BkX2luZGV4XS5kcml2ZVN0YXRlID09IE1SX1BEX1NUQVRFX1NZ
U1RFTSkgewogCQlpb19yZXF1ZXN0LT5GdW5jdGlvbiA9IDA7CiAJCWlvX3JlcXVlc3QtPkRldkhh
bmRsZSA9CiAJCQlsb2NhbF9tYXBfcHRyLT5yYWlkTWFwLmRldkhuZGxJbmZvW2RldmljZV9pZF0u
Y3VyRGV2SGRsOwo=
--bcaec54eea8e80ffb904cb0a42c6--
