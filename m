From: adam radford <aradford@gmail.com>
Subject: [PATCH 1/4] megaraid_sas: Fix reset_mutex leak
Date: Thu, 19 Jun 2014 17:31:30 -0700
Message-ID: <CAHtARFHPrfWho2k5xu8dbXiKtFC4RQsp=MrpgNbhaii33aDGSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf303ea59a5f3a4004fc399d64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f43.google.com ([209.85.213.43]:60002 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666AbaFTAbb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jun 2014 20:31:31 -0400
Received: by mail-yh0-f43.google.com with SMTP id a41so2322859yho.16
        for <linux-scsi@vger.kernel.org>; Thu, 19 Jun 2014 17:31:30 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com

--20cf303ea59a5f3a4004fc399d64
Content-Type: text/plain; charset=UTF-8

James/linux-scsi,

The following patch for megaraid_sas fixes a reset_mutex leak in
megasas_reset_fusion().

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-for-next.old/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-for-next.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-for-next.old/drivers/scsi/megaraid/megaraid_sas_fusion.c
2014-06-19 15:03:05.000000000 -0700
+++ scsi-for-next.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
2014-06-19 15:24:19.982075881 -0700
@@ -2355,6 +2355,7 @@
  printk(KERN_WARNING "megaraid_sas: Hardware critical error, "
        "returning FAILED for scsi%d.\n",
  instance->host->host_no);
+ mutex_unlock(&instance->reset_mutex);
  return FAILED;
  }

--20cf303ea59a5f3a4004fc399d64
Content-Type: application/octet-stream; name="megaraid_sas.patch1"
Content-Disposition: attachment; filename="megaraid_sas.patch1"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hwmr742l0

ZGlmZiAtTmF1ciBzY3NpLWZvci1uZXh0Lm9sZC9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJh
aWRfc2FzX2Z1c2lvbi5jIHNjc2ktZm9yLW5leHQubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9t
ZWdhcmFpZF9zYXNfZnVzaW9uLmMKLS0tIHNjc2ktZm9yLW5leHQub2xkL2RyaXZlcnMvc2NzaS9t
ZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmMJMjAxNC0wNi0xOSAxNTowMzowNS4wMDAwMDAw
MDAgLTA3MDAKKysrIHNjc2ktZm9yLW5leHQubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXNfZnVzaW9uLmMJMjAxNC0wNi0xOSAxNToyNDoxOS45ODIwNzU4ODEgLTA3MDAKQEAg
LTIzNTUsNiArMjM1NSw3IEBACiAJCXByaW50ayhLRVJOX1dBUk5JTkcgIm1lZ2FyYWlkX3Nhczog
SGFyZHdhcmUgY3JpdGljYWwgZXJyb3IsICIKIAkJICAgICAgICJyZXR1cm5pbmcgRkFJTEVEIGZv
ciBzY3NpJWQuXG4iLAogCQkJaW5zdGFuY2UtPmhvc3QtPmhvc3Rfbm8pOworCQltdXRleF91bmxv
Y2soJmluc3RhbmNlLT5yZXNldF9tdXRleCk7CiAJCXJldHVybiBGQUlMRUQ7CiAJfQogCg==
--20cf303ea59a5f3a4004fc399d64--
