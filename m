From: adam radford <aradford@gmail.com>
Subject: [PATCH] 3w-9xxx fix bug in sgl loading
Date: Thu, 10 Dec 2009 11:53:31 -0800
Message-ID: <b1bc6a000912101153y19e9d874lef179da9d326b392@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=00504502ad10697dcc047a65298f
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:59191 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049AbZLJTxZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2009 14:53:25 -0500
Received: by pwj9 with SMTP id 9so121293pwj.21
        for <linux-scsi@vger.kernel.org>; Thu, 10 Dec 2009 11:53:32 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>

--00504502ad10697dcc047a65298f
Content-Type: text/plain; charset=ISO-8859-1

James, linux-scsi,

This small patch fixes a bug in the 3w-9xxx driver where it would load
an invalid sgl address in the ioctl path even if request length was zero.

Please apply on top of the current scsi-misc-2.6.

Thanks!

Signed-off-by: Adam Radford <aradford@gmail.com>

-Adam

Note: This patch is included in-line below and also as an attachment.

diff -Naur scsi-misc/drivers/scsi/3w-9xxx.c scsi-misc.new/drivers/scsi/3w-9xxx.c
--- scsi-misc/drivers/scsi/3w-9xxx.c	2009-12-09 15:57:44.000000000 -0800
+++ scsi-misc.new/drivers/scsi/3w-9xxx.c	2009-12-09 16:00:36.000000000 -0800
@@ -76,6 +76,7 @@
                  Fix bug in twa_get_param() on 4GB+.
                  Use pci_resource_len() for ioremap().
    2.26.02.012 - Add power management support.
+   2.26.02.013 - Fix bug in twa_load_sgl().
 */

 #include <linux/module.h>
@@ -100,7 +101,7 @@
 #include "3w-9xxx.h"

 /* Globals */
-#define TW_DRIVER_VERSION "2.26.02.012"
+#define TW_DRIVER_VERSION "2.26.02.013"
 static TW_Device_Extension *twa_device_extension_list[TW_MAX_SLOT];
 static unsigned int twa_device_extension_count;
 static int twa_major = -1;
@@ -1382,10 +1383,12 @@
 		newcommand = &full_command_packet->command.newcommand;
 		newcommand->request_id__lunl =
 			cpu_to_le16(TW_REQ_LUN_IN(TW_LUN_OUT(newcommand->request_id__lunl),
request_id));
-		newcommand->sg_list[0].address = TW_CPU_TO_SGL(dma_handle +
sizeof(TW_Ioctl_Buf_Apache) - 1);
-		newcommand->sg_list[0].length = cpu_to_le32(length);
+		if (length) {
+			newcommand->sg_list[0].address = TW_CPU_TO_SGL(dma_handle +
sizeof(TW_Ioctl_Buf_Apache) - 1);
+			newcommand->sg_list[0].length = cpu_to_le32(length);
+		}
 		newcommand->sgl_entries__lunh =
-			cpu_to_le16(TW_REQ_LUN_IN(TW_LUN_OUT(newcommand->sgl_entries__lunh), 1));
+			cpu_to_le16(TW_REQ_LUN_IN(TW_LUN_OUT(newcommand->sgl_entries__lunh),
length ? 1 : 0));
 	} else {
 		oldcommand = &full_command_packet->command.oldcommand;
 		oldcommand->request_id = request_id;

--00504502ad10697dcc047a65298f
Content-Type: text/x-patch; charset=US-ASCII; name="3w-9xxx_2.6.33.patch"
Content-Disposition: attachment; filename="3w-9xxx_2.6.33.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g31xzyjf0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MvZHJpdmVycy9zY3NpLzN3LTl4eHguYyBzY3NpLW1pc2MubmV3
L2RyaXZlcnMvc2NzaS8zdy05eHh4LmMKLS0tIHNjc2ktbWlzYy9kcml2ZXJzL3Njc2kvM3ctOXh4
eC5jCTIwMDktMTItMDkgMTU6NTc6NDQuMDAwMDAwMDAwIC0wODAwCisrKyBzY3NpLW1pc2MubmV3
L2RyaXZlcnMvc2NzaS8zdy05eHh4LmMJMjAwOS0xMi0wOSAxNjowMDozNi4wMDAwMDAwMDAgLTA4
MDAKQEAgLTc2LDYgKzc2LDcgQEAKICAgICAgICAgICAgICAgICAgRml4IGJ1ZyBpbiB0d2FfZ2V0
X3BhcmFtKCkgb24gNEdCKy4KICAgICAgICAgICAgICAgICAgVXNlIHBjaV9yZXNvdXJjZV9sZW4o
KSBmb3IgaW9yZW1hcCgpLgogICAgMi4yNi4wMi4wMTIgLSBBZGQgcG93ZXIgbWFuYWdlbWVudCBz
dXBwb3J0LgorICAgMi4yNi4wMi4wMTMgLSBGaXggYnVnIGluIHR3YV9sb2FkX3NnbCgpLgogKi8K
IAogI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPgpAQCAtMTAwLDcgKzEwMSw3IEBACiAjaW5jbHVk
ZSAiM3ctOXh4eC5oIgogCiAvKiBHbG9iYWxzICovCi0jZGVmaW5lIFRXX0RSSVZFUl9WRVJTSU9O
ICIyLjI2LjAyLjAxMiIKKyNkZWZpbmUgVFdfRFJJVkVSX1ZFUlNJT04gIjIuMjYuMDIuMDEzIgog
c3RhdGljIFRXX0RldmljZV9FeHRlbnNpb24gKnR3YV9kZXZpY2VfZXh0ZW5zaW9uX2xpc3RbVFdf
TUFYX1NMT1RdOwogc3RhdGljIHVuc2lnbmVkIGludCB0d2FfZGV2aWNlX2V4dGVuc2lvbl9jb3Vu
dDsKIHN0YXRpYyBpbnQgdHdhX21ham9yID0gLTE7CkBAIC0xMzgyLDEwICsxMzgzLDEyIEBACiAJ
CW5ld2NvbW1hbmQgPSAmZnVsbF9jb21tYW5kX3BhY2tldC0+Y29tbWFuZC5uZXdjb21tYW5kOwog
CQluZXdjb21tYW5kLT5yZXF1ZXN0X2lkX19sdW5sID0KIAkJCWNwdV90b19sZTE2KFRXX1JFUV9M
VU5fSU4oVFdfTFVOX09VVChuZXdjb21tYW5kLT5yZXF1ZXN0X2lkX19sdW5sKSwgcmVxdWVzdF9p
ZCkpOwotCQluZXdjb21tYW5kLT5zZ19saXN0WzBdLmFkZHJlc3MgPSBUV19DUFVfVE9fU0dMKGRt
YV9oYW5kbGUgKyBzaXplb2YoVFdfSW9jdGxfQnVmX0FwYWNoZSkgLSAxKTsKLQkJbmV3Y29tbWFu
ZC0+c2dfbGlzdFswXS5sZW5ndGggPSBjcHVfdG9fbGUzMihsZW5ndGgpOworCQlpZiAobGVuZ3Ro
KSB7CisJCQluZXdjb21tYW5kLT5zZ19saXN0WzBdLmFkZHJlc3MgPSBUV19DUFVfVE9fU0dMKGRt
YV9oYW5kbGUgKyBzaXplb2YoVFdfSW9jdGxfQnVmX0FwYWNoZSkgLSAxKTsKKwkJCW5ld2NvbW1h
bmQtPnNnX2xpc3RbMF0ubGVuZ3RoID0gY3B1X3RvX2xlMzIobGVuZ3RoKTsKKwkJfQogCQluZXdj
b21tYW5kLT5zZ2xfZW50cmllc19fbHVuaCA9Ci0JCQljcHVfdG9fbGUxNihUV19SRVFfTFVOX0lO
KFRXX0xVTl9PVVQobmV3Y29tbWFuZC0+c2dsX2VudHJpZXNfX2x1bmgpLCAxKSk7CisJCQljcHVf
dG9fbGUxNihUV19SRVFfTFVOX0lOKFRXX0xVTl9PVVQobmV3Y29tbWFuZC0+c2dsX2VudHJpZXNf
X2x1bmgpLCBsZW5ndGggPyAxIDogMCkpOwogCX0gZWxzZSB7CiAJCW9sZGNvbW1hbmQgPSAmZnVs
bF9jb21tYW5kX3BhY2tldC0+Y29tbWFuZC5vbGRjb21tYW5kOwogCQlvbGRjb21tYW5kLT5yZXF1
ZXN0X2lkID0gcmVxdWVzdF9pZDsK
--00504502ad10697dcc047a65298f--
