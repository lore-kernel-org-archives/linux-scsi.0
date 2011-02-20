From: adam radford <aradford@gmail.com>
Subject: [PATCH 9/15] megaraid_sas: Fix megasas_build_dcdb_fusion to use
 correct LUN field
Date: Sat, 19 Feb 2011 18:22:58 -0800
Message-ID: <AANLkTi=qVjqqNmbxrQA4gQgemgmC4ES35q_YSzpR-E2x@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016364ef994f3eb67049cad6c57
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52251 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab1BTCW6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2011 21:22:58 -0500
Received: by mail-ww0-f44.google.com with SMTP id 36so5037267wwa.1
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2011 18:22:58 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016364ef994f3eb67049cad6c57
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch for megaraid_sas fixes megasas_build_dcdb_fusion()
to use the correct LUN[1] field.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_fusion.c
linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-02-19
14:12:29.195394738 -0800
+++ linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-02-19
14:13:44.611364358 -0800
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

--0016364ef994f3eb67049cad6c57
Content-Type: application/octet-stream; name="megaraid_sas.patch9"
Content-Disposition: attachment; filename="megaraid_sas.patch9"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkdb88w90

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzgtcmM1L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfZnVzaW9uLmMgbGludXgtMi42LjM4LXJjNS5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlk
L21lZ2FyYWlkX3Nhc19mdXNpb24uYwotLS0gbGludXgtMi42LjM4LXJjNS9kcml2ZXJzL3Njc2kv
bWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Z1c2lvbi5jCTIwMTEtMDItMTkgMTQ6MTI6MjkuMTk1Mzk0
NzM4IC0wODAwCisrKyBsaW51eC0yLjYuMzgtcmM1Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQv
bWVnYXJhaWRfc2FzX2Z1c2lvbi5jCTIwMTEtMDItMTkgMTQ6MTM6NDQuNjExMzY0MzU4IC0wODAw
CkBAIC0xNDYxLDcgKzE0NjEsNyBAQAogCQkJIE1FR0FTQVNfUkVRX0RFU0NSSVBUX0ZMQUdTX1RZ
UEVfU0hJRlQpOwogCX0KIAlpb19yZXF1ZXN0LT5SYWlkQ29udGV4dC5WaXJ0dWFsRGlza1RndElk
ID0gZGV2aWNlX2lkOwotCWlvX3JlcXVlc3QtPkxVTlswXSA9IHNjbWQtPmRldmljZS0+bHVuOwor
CWlvX3JlcXVlc3QtPkxVTlsxXSA9IHNjbWQtPmRldmljZS0+bHVuOwogCWlvX3JlcXVlc3QtPkRh
dGFMZW5ndGggPSBzY3NpX2J1ZmZsZW4oc2NtZCk7CiB9CiAKQEAgLTE0ODUsNyArMTQ4NSw3IEBA
CiAJZGV2aWNlX2lkID0gTUVHQVNBU19ERVZfSU5ERVgoaW5zdGFuY2UsIHNjcCk7CiAKIAkvKiBa
ZXJvIG91dCBzb21lIGZpZWxkcyBzbyB0aGV5IGRvbid0IGdldCByZXVzZWQgKi8KLQlpb19yZXF1
ZXN0LT5MVU5bMF0gPSAwOworCWlvX3JlcXVlc3QtPkxVTlsxXSA9IDA7CiAJaW9fcmVxdWVzdC0+
Q0RCLkVFRFAzMi5QcmltYXJ5UmVmZXJlbmNlVGFnID0gMDsKIAlpb19yZXF1ZXN0LT5DREIuRUVE
UDMyLlByaW1hcnlBcHBsaWNhdGlvblRhZ01hc2sgPSAwOwogCWlvX3JlcXVlc3QtPkVFRFBGbGFn
cyA9IDA7Cg==
--0016364ef994f3eb67049cad6c57--
