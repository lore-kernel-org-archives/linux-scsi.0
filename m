From: adam radford <aradford@gmail.com>
Subject: [PATCH 2/3] megaraid_sas: Dont load DevHandle unless FastPath enabled
Date: Sat, 9 Feb 2013 15:29:20 -0800
Message-ID: <CAHtARFF4BjJPDpdB2trT=EO2XXSSugw37eq69WUM=BH6fOqmfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b677bf49c397504d5530b17
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37593 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576Ab3BIX3V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Feb 2013 18:29:21 -0500
Received: by mail-qc0-f174.google.com with SMTP id z24so1858503qcq.33
        for <linux-scsi@vger.kernel.org>; Sat, 09 Feb 2013 15:29:20 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Kashyap Desai <Kashyap.Desai@lsi.com>

--047d7b677bf49c397504d5530b17
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas will fix an issue where the
driver should not be loading the DevHandle unless FastPath is enabled.
 If FastPath was not enabled, this means the hardware raid map
validation failed for some reason, or the map was corrupted, which
could mean the DevHandle could be invalid.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fusion.c	2013-02-09
22:44:15.625191018 -0800
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2013-02-09
22:46:14.863866082 -0800
@@ -1511,7 +1511,8 @@
 	if (scmd->device->channel < MEGASAS_MAX_PD_CHANNELS &&
 	    instance->pd_list[pd_index].driveState == MR_PD_STATE_SYSTEM) {
 		io_request->Function = 0;
-		io_request->DevHandle =
+		if (fusion->fast_path_io)
+			io_request->DevHandle =
 			local_map_ptr->raidMap.devHndlInfo[device_id].curDevHdl;
 		io_request->RaidContext.timeoutValue =
 			local_map_ptr->raidMap.fpPdIoTimeoutSec;

--047d7b677bf49c397504d5530b17
Content-Type: application/octet-stream; name="megaraid_sas.patch2"
Content-Disposition: attachment; filename="megaraid_sas.patch2"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hcze4l330

ZGlmZiAtTmF1ciBzY3NpLW1pc2Mub2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfZnVzaW9uLmMgc2NzaS1taXNjLm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRf
c2FzX2Z1c2lvbi5jCi0tLSBzY3NpLW1pc2Mub2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXNfZnVzaW9uLmMJMjAxMy0wMi0wOSAyMjo0NDoxNS42MjUxOTEwMTggLTA4MDAKKysr
IHNjc2ktbWlzYy5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24u
YwkyMDEzLTAyLTA5IDIyOjQ2OjE0Ljg2Mzg2NjA4MiAtMDgwMApAQCAtMTUxMSw3ICsxNTExLDgg
QEAKIAlpZiAoc2NtZC0+ZGV2aWNlLT5jaGFubmVsIDwgTUVHQVNBU19NQVhfUERfQ0hBTk5FTFMg
JiYKIAkgICAgaW5zdGFuY2UtPnBkX2xpc3RbcGRfaW5kZXhdLmRyaXZlU3RhdGUgPT0gTVJfUERf
U1RBVEVfU1lTVEVNKSB7CiAJCWlvX3JlcXVlc3QtPkZ1bmN0aW9uID0gMDsKLQkJaW9fcmVxdWVz
dC0+RGV2SGFuZGxlID0KKwkJaWYgKGZ1c2lvbi0+ZmFzdF9wYXRoX2lvKQorCQkJaW9fcmVxdWVz
dC0+RGV2SGFuZGxlID0KIAkJCWxvY2FsX21hcF9wdHItPnJhaWRNYXAuZGV2SG5kbEluZm9bZGV2
aWNlX2lkXS5jdXJEZXZIZGw7CiAJCWlvX3JlcXVlc3QtPlJhaWRDb250ZXh0LnRpbWVvdXRWYWx1
ZSA9CiAJCQlsb2NhbF9tYXBfcHRyLT5yYWlkTWFwLmZwUGRJb1RpbWVvdXRTZWM7Cg==
--047d7b677bf49c397504d5530b17--
