From: adam radford <aradford@gmail.com>
Subject: [PATCH 8/15] megaraid_sas: Fix megasas_build_dcdb_fusion to not
 filter by TYPE_DISK
Date: Sat, 19 Feb 2011 18:22:53 -0800
Message-ID: <AANLkTik+0f=vZZarQegVRz+sxa-H+QiydafQOZztv7VJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e649c770ae0de3049cad6c9f
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52251 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab1BTCWy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2011 21:22:54 -0500
Received: by mail-ww0-f44.google.com with SMTP id 36so5037267wwa.1
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2011 18:22:53 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e649c770ae0de3049cad6c9f
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch for megaraid_sas fixes megasas_build_dcdb_fusion()
to not filter by TYPE_DISK.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_fusion.c
linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-02-19
16:22:12.668333205 -0800
+++ linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-02-19
16:23:33.028364422 -0800
@@ -1438,8 +1438,7 @@
 	local_map_ptr = fusion->ld_map[(instance->map_id & 1)];

 	/* Check if this is a system PD I/O */
-	if ((instance->pd_list[pd_index].driveState == MR_PD_STATE_SYSTEM) &&
-	    (instance->pd_list[pd_index].driveType == TYPE_DISK)) {
+	if (instance->pd_list[pd_index].driveState == MR_PD_STATE_SYSTEM) {
 		io_request->Function = 0;
 		io_request->DevHandle =
 			local_map_ptr->raidMap.devHndlInfo[device_id].curDevHdl;

--0016e649c770ae0de3049cad6c9f
Content-Type: application/octet-stream; name="megaraid_sas.patch8"
Content-Disposition: attachment; filename="megaraid_sas.patch8"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkdb6ibp0

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzgtcmM1L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfZnVzaW9uLmMgbGludXgtMi42LjM4LXJjNS5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlk
L21lZ2FyYWlkX3Nhc19mdXNpb24uYwotLS0gbGludXgtMi42LjM4LXJjNS9kcml2ZXJzL3Njc2kv
bWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Z1c2lvbi5jCTIwMTEtMDItMTkgMTY6MjI6MTIuNjY4MzMz
MjA1IC0wODAwCisrKyBsaW51eC0yLjYuMzgtcmM1Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQv
bWVnYXJhaWRfc2FzX2Z1c2lvbi5jCTIwMTEtMDItMTkgMTY6MjM6MzMuMDI4MzY0NDIyIC0wODAw
CkBAIC0xNDM4LDggKzE0MzgsNyBAQAogCWxvY2FsX21hcF9wdHIgPSBmdXNpb24tPmxkX21hcFso
aW5zdGFuY2UtPm1hcF9pZCAmIDEpXTsKIAogCS8qIENoZWNrIGlmIHRoaXMgaXMgYSBzeXN0ZW0g
UEQgSS9PICovCi0JaWYgKChpbnN0YW5jZS0+cGRfbGlzdFtwZF9pbmRleF0uZHJpdmVTdGF0ZSA9
PSBNUl9QRF9TVEFURV9TWVNURU0pICYmCi0JICAgIChpbnN0YW5jZS0+cGRfbGlzdFtwZF9pbmRl
eF0uZHJpdmVUeXBlID09IFRZUEVfRElTSykpIHsKKwlpZiAoaW5zdGFuY2UtPnBkX2xpc3RbcGRf
aW5kZXhdLmRyaXZlU3RhdGUgPT0gTVJfUERfU1RBVEVfU1lTVEVNKSB7CiAJCWlvX3JlcXVlc3Qt
PkZ1bmN0aW9uID0gMDsKIAkJaW9fcmVxdWVzdC0+RGV2SGFuZGxlID0KIAkJCWxvY2FsX21hcF9w
dHItPnJhaWRNYXAuZGV2SG5kbEluZm9bZGV2aWNlX2lkXS5jdXJEZXZIZGw7Cg==
--0016e649c770ae0de3049cad6c9f--
