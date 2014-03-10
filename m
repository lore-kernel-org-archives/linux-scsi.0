From: adam radford <aradford@gmail.com>
Subject: [PATCH 1/5] megaraid_sas: Load correct raid context timeout
Date: Mon, 10 Mar 2014 02:51:28 -0700
Message-ID: <CAHtARFG=a85k_6632jmz=RKpi2=YHGTKqG=FgzZqJb0VnJZh7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf301b657329bbb504f43d8ce1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f52.google.com ([209.85.213.52]:63429 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbaCJJv3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Mar 2014 05:51:29 -0400
Received: by mail-yh0-f52.google.com with SMTP id c41so156857yho.25
        for <linux-scsi@vger.kernel.org>; Mon, 10 Mar 2014 02:51:28 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Kashyap Desai <Kashyap.Desai@lsi.com>, "Saxena, Sumit" <Sumit.Saxena@lsi.com>

--20cf301b657329bbb504f43d8ce1
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas loads the correct raid context timeout
value for multpathing and clustering.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fp.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fp.c
--- scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fp.c 2014-03-09
21:06:56.499856130 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fp.c 2014-03-09
21:20:51.303858698 -0700
@@ -975,7 +975,10 @@
  regSize += stripSize;
  }

- pRAID_Context->timeoutValue     = cpu_to_le16(map->raidMap.fpPdIoTimeoutSec);
+ pRAID_Context->timeoutValue =
+ cpu_to_le16(raid->fpIoTimeoutForLd ?
+    raid->fpIoTimeoutForLd :
+    map->raidMap.fpPdIoTimeoutSec);
  if ((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
  (instance->pdev->device == PCI_DEVICE_ID_LSI_FURY))
  pRAID_Context->regLockFlags = (isRead) ?

--20cf301b657329bbb504f43d8ce1
Content-Type: application/octet-stream; name="megaraid_sas.patch1"
Content-Disposition: attachment; filename="megaraid_sas.patch1"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hslk5m7z0

ZGlmZiAtTmF1ciBzY3NpLW1pc2Mub2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfZnAuYyBzY3NpLW1pc2MubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNf
ZnAuYwotLS0gc2NzaS1taXNjLm9sZC9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2Fz
X2ZwLmMJMjAxNC0wMy0wOSAyMTowNjo1Ni40OTk4NTYxMzAgLTA3MDAKKysrIHNjc2ktbWlzYy5u
ZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mcC5jCTIwMTQtMDMtMDkgMjE6
MjA6NTEuMzAzODU4Njk4IC0wNzAwCkBAIC05NzUsNyArOTc1LDEwIEBACiAJCQlyZWdTaXplICs9
IHN0cmlwU2l6ZTsKIAl9CiAKLQlwUkFJRF9Db250ZXh0LT50aW1lb3V0VmFsdWUgICAgID0gY3B1
X3RvX2xlMTYobWFwLT5yYWlkTWFwLmZwUGRJb1RpbWVvdXRTZWMpOworCXBSQUlEX0NvbnRleHQt
PnRpbWVvdXRWYWx1ZSA9CisJCWNwdV90b19sZTE2KHJhaWQtPmZwSW9UaW1lb3V0Rm9yTGQgPwor
CQkJICAgIHJhaWQtPmZwSW9UaW1lb3V0Rm9yTGQgOgorCQkJICAgIG1hcC0+cmFpZE1hcC5mcFBk
SW9UaW1lb3V0U2VjKTsKIAlpZiAoKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0gUENJX0RFVklD
RV9JRF9MU0lfSU5WQURFUikgfHwKIAkJKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0gUENJX0RF
VklDRV9JRF9MU0lfRlVSWSkpCiAJCXBSQUlEX0NvbnRleHQtPnJlZ0xvY2tGbGFncyA9IChpc1Jl
YWQpID8K
--20cf301b657329bbb504f43d8ce1--
