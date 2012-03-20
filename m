From: adam radford <aradford@gmail.com>
Subject: [PATCH 1/3] megaraid_sas: Optimize HostMSIxVectors setting
Date: Mon, 19 Mar 2012 19:49:53 -0700
Message-ID: <CAHtARFFTR2ka6iL-y43D+=L9MudGVFY1HbJs9ehUqyWWmsi0zQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e6d45fbeb59be304bba3bac3
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35113 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab2CTCty (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Mar 2012 22:49:54 -0400
Received: by wgbdr13 with SMTP id dr13so1150635wgb.1
        for <linux-scsi@vger.kernel.org>; Mon, 19 Mar 2012 19:49:53 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e6d45fbeb59be304bba3bac3
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas removes an incorrect comment and
optimizes the setting of HostMSIxVectors.  This was found during a
code review by Tomas Henzl @ RedHat.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.c	2012-03-19
17:39:08.313986900 -0700
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2012-03-19
17:44:14.901863036 -0700
@@ -634,9 +634,7 @@
 		fusion->reply_frames_desc_phys;
 	IOCInitMessage->SystemRequestFrameBaseAddress =
 		fusion->io_request_frames_phys;
-	/* Set to 0 for none or 1 MSI-X vectors */
-	IOCInitMessage->HostMSIxVectors = (instance->msix_vectors > 0 ?
-					   instance->msix_vectors : 0);
+	IOCInitMessage->HostMSIxVectors = instance->msix_vectors;
 	init_frame = (struct megasas_init_frame *)cmd->frame;
 	memset(init_frame, 0, MEGAMFI_FRAME_SIZE);

--0016e6d45fbeb59be304bba3bac3
Content-Type: application/octet-stream; name="megaraid_sas.patch1"
Content-Disposition: attachment; filename="megaraid_sas.patch1"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h00c4f1d0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfZnVzaW9uLmMgc2NzaS1taXNjLTIuNi5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2Fy
YWlkX3Nhc19mdXNpb24uYwotLS0gc2NzaS1taXNjLTIuNi9kcml2ZXJzL3Njc2kvbWVnYXJhaWQv
bWVnYXJhaWRfc2FzX2Z1c2lvbi5jCTIwMTItMDMtMTkgMTc6Mzk6MDguMzEzOTg2OTAwIC0wNzAw
CisrKyBzY3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2Fz
X2Z1c2lvbi5jCTIwMTItMDMtMTkgMTc6NDQ6MTQuOTAxODYzMDM2IC0wNzAwCkBAIC02MzQsOSAr
NjM0LDcgQEAKIAkJZnVzaW9uLT5yZXBseV9mcmFtZXNfZGVzY19waHlzOwogCUlPQ0luaXRNZXNz
YWdlLT5TeXN0ZW1SZXF1ZXN0RnJhbWVCYXNlQWRkcmVzcyA9CiAJCWZ1c2lvbi0+aW9fcmVxdWVz
dF9mcmFtZXNfcGh5czsKLQkvKiBTZXQgdG8gMCBmb3Igbm9uZSBvciAxIE1TSS1YIHZlY3RvcnMg
Ki8KLQlJT0NJbml0TWVzc2FnZS0+SG9zdE1TSXhWZWN0b3JzID0gKGluc3RhbmNlLT5tc2l4X3Zl
Y3RvcnMgPiAwID8KLQkJCQkJICAgaW5zdGFuY2UtPm1zaXhfdmVjdG9ycyA6IDApOworCUlPQ0lu
aXRNZXNzYWdlLT5Ib3N0TVNJeFZlY3RvcnMgPSBpbnN0YW5jZS0+bXNpeF92ZWN0b3JzOwogCWlu
aXRfZnJhbWUgPSAoc3RydWN0IG1lZ2FzYXNfaW5pdF9mcmFtZSAqKWNtZC0+ZnJhbWU7CiAJbWVt
c2V0KGluaXRfZnJhbWUsIDAsIE1FR0FNRklfRlJBTUVfU0laRSk7CiAK
--0016e6d45fbeb59be304bba3bac3--
