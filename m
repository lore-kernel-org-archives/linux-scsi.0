From: adam radford <aradford@gmail.com>
Subject: [PATCH 8/14] megaraid_sas: Fix megasas_build_dcdb_fusion to use
 correct LUN field
Date: Thu, 24 Feb 2011 20:56:49 -0800
Message-ID: <AANLkTik_mKJO=Z2hi8T=k1tCQpxTi4wiT+kVsaDSew2U@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016364d205f6087a3049d1428b3
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49097 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab1BYE4t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2011 23:56:49 -0500
Received: by mail-ww0-f44.google.com with SMTP id 39so1696373wwb.1
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2011 20:56:49 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016364d205f6087a3049d1428b3
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch for megaraid_sas fixes megasas_build_dcdb_fusion()
to use the correct LUN[1] field.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-02-24
18:52:16.561275638 -0800
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-02-24
18:53:20.455307627 -0800
@@ -1461,7 +1461,7 @@
 			 MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
 	}
 	io_request->RaidContext.VirtualDiskTgtId = device_id;
-	io_request->LUN[0] = scmd->device->lun;
+	io_request->LUN[1] = scmd->device->lun;
 	io_request->DataLength = scsi_bufflen(scmd);
 }

@@ -1485,7 +1485,7 @@
 	device_id = MEGASAS_DEV_INDEX(instance, scp);

 	/* Zero out some fields so they don't get reused */
-	io_request->LUN[0] = 0;
+	io_request->LUN[1] = 0;
 	io_request->CDB.EEDP32.PrimaryReferenceTag = 0;
 	io_request->CDB.EEDP32.PrimaryApplicationTagMask = 0;
 	io_request->EEDPFlags = 0;

--0016364d205f6087a3049d1428b3
Content-Type: application/octet-stream; name="megaraid_sas.patch8"
Content-Disposition: attachment; filename="megaraid_sas.patch8"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkkmjnl50

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfZnVzaW9uLmMgc2NzaS1taXNjLTIuNi5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2Fy
YWlkX3Nhc19mdXNpb24uYwotLS0gc2NzaS1taXNjLTIuNi9kcml2ZXJzL3Njc2kvbWVnYXJhaWQv
bWVnYXJhaWRfc2FzX2Z1c2lvbi5jCTIwMTEtMDItMjQgMTg6NTI6MTYuNTYxMjc1NjM4IC0wODAw
CisrKyBzY3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2Fz
X2Z1c2lvbi5jCTIwMTEtMDItMjQgMTg6NTM6MjAuNDU1MzA3NjI3IC0wODAwCkBAIC0xNDYxLDcg
KzE0NjEsNyBAQAogCQkJIE1FR0FTQVNfUkVRX0RFU0NSSVBUX0ZMQUdTX1RZUEVfU0hJRlQpOwog
CX0KIAlpb19yZXF1ZXN0LT5SYWlkQ29udGV4dC5WaXJ0dWFsRGlza1RndElkID0gZGV2aWNlX2lk
OwotCWlvX3JlcXVlc3QtPkxVTlswXSA9IHNjbWQtPmRldmljZS0+bHVuOworCWlvX3JlcXVlc3Qt
PkxVTlsxXSA9IHNjbWQtPmRldmljZS0+bHVuOwogCWlvX3JlcXVlc3QtPkRhdGFMZW5ndGggPSBz
Y3NpX2J1ZmZsZW4oc2NtZCk7CiB9CiAKQEAgLTE0ODUsNyArMTQ4NSw3IEBACiAJZGV2aWNlX2lk
ID0gTUVHQVNBU19ERVZfSU5ERVgoaW5zdGFuY2UsIHNjcCk7CiAKIAkvKiBaZXJvIG91dCBzb21l
IGZpZWxkcyBzbyB0aGV5IGRvbid0IGdldCByZXVzZWQgKi8KLQlpb19yZXF1ZXN0LT5MVU5bMF0g
PSAwOworCWlvX3JlcXVlc3QtPkxVTlsxXSA9IDA7CiAJaW9fcmVxdWVzdC0+Q0RCLkVFRFAzMi5Q
cmltYXJ5UmVmZXJlbmNlVGFnID0gMDsKIAlpb19yZXF1ZXN0LT5DREIuRUVEUDMyLlByaW1hcnlB
cHBsaWNhdGlvblRhZ01hc2sgPSAwOwogCWlvX3JlcXVlc3QtPkVFRFBGbGFncyA9IDA7Cg==
--0016364d205f6087a3049d1428b3--
