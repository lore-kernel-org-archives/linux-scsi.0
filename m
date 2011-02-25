From: adam radford <aradford@gmail.com>
Subject: [PATCH 7/14] megaraid_sas: Fix megasas_build_dcdb_fusion to not
 filter by TYPE_DISK
Date: Thu, 24 Feb 2011 20:56:43 -0800
Message-ID: <AANLkTi=Zjhei2Mji+ojFDU2BOypoW7UgdkxU5KHWNPF4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e64c18ac05ac95049d1428a8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49097 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab1BYE4n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2011 23:56:43 -0500
Received: by mail-ww0-f44.google.com with SMTP id 39so1696373wwb.1
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2011 20:56:43 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e64c18ac05ac95049d1428a8
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch for megaraid_sas fixes megasas_build_dcdb_fusion()
to not filter by TYPE_DISK.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-02-24
18:35:30.484151432 -0800
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-02-24
18:51:17.011276050 -0800
@@ -1438,8 +1438,7 @@
 	local_map_ptr = fusion->ld_map[(instance->map_id & 1)];

 	/* Check if this is a system PD I/O */
-	if ((instance->pd_list[pd_index].driveState == MR_PD_STATE_SYSTEM) &&
-	    (instance->pd_list[pd_index].driveType == TYPE_DISK)) {
+	if (instance->pd_list[pd_index].driveState == MR_PD_STATE_SYSTEM) {
 		io_request->Function = 0;
 		io_request->DevHandle =
 			local_map_ptr->raidMap.devHndlInfo[device_id].curDevHdl;

--0016e64c18ac05ac95049d1428a8
Content-Type: application/octet-stream; name="megaraid_sas.patch7"
Content-Disposition: attachment; filename="megaraid_sas.patch7"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkkmj0zk0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfZnVzaW9uLmMgc2NzaS1taXNjLTIuNi5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2Fy
YWlkX3Nhc19mdXNpb24uYwotLS0gc2NzaS1taXNjLTIuNi9kcml2ZXJzL3Njc2kvbWVnYXJhaWQv
bWVnYXJhaWRfc2FzX2Z1c2lvbi5jCTIwMTEtMDItMjQgMTg6MzU6MzAuNDg0MTUxNDMyIC0wODAw
CisrKyBzY3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2Fz
X2Z1c2lvbi5jCTIwMTEtMDItMjQgMTg6NTE6MTcuMDExMjc2MDUwIC0wODAwCkBAIC0xNDM4LDgg
KzE0MzgsNyBAQAogCWxvY2FsX21hcF9wdHIgPSBmdXNpb24tPmxkX21hcFsoaW5zdGFuY2UtPm1h
cF9pZCAmIDEpXTsKIAogCS8qIENoZWNrIGlmIHRoaXMgaXMgYSBzeXN0ZW0gUEQgSS9PICovCi0J
aWYgKChpbnN0YW5jZS0+cGRfbGlzdFtwZF9pbmRleF0uZHJpdmVTdGF0ZSA9PSBNUl9QRF9TVEFU
RV9TWVNURU0pICYmCi0JICAgIChpbnN0YW5jZS0+cGRfbGlzdFtwZF9pbmRleF0uZHJpdmVUeXBl
ID09IFRZUEVfRElTSykpIHsKKwlpZiAoaW5zdGFuY2UtPnBkX2xpc3RbcGRfaW5kZXhdLmRyaXZl
U3RhdGUgPT0gTVJfUERfU1RBVEVfU1lTVEVNKSB7CiAJCWlvX3JlcXVlc3QtPkZ1bmN0aW9uID0g
MDsKIAkJaW9fcmVxdWVzdC0+RGV2SGFuZGxlID0KIAkJCWxvY2FsX21hcF9wdHItPnJhaWRNYXAu
ZGV2SG5kbEluZm9bZGV2aWNlX2lkXS5jdXJEZXZIZGw7Cg==
--0016e64c18ac05ac95049d1428a8--
