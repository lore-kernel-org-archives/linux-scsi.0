From: adam radford <aradford@gmail.com>
Subject: [PATCH 4/5] megaraid_sas: Move poll_aen_lock initializer
Date: Tue, 17 Jul 2012 18:20:44 -0700
Message-ID: <CAHtARFHi3xyomKhrUg0r7soQFbUtPeiLkYeZ2YgmaU3gYktuYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=e89a8f23579de0ca2504c510788b
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:60323 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab2GRBUp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2012 21:20:45 -0400
Received: by mail-gh0-f174.google.com with SMTP id r11so1077547ghr.19
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jul 2012 18:20:45 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Kashyap Desai <Kashyap.Desai@lsi.com>, stable <stable@kernel.org>

--e89a8f23579de0ca2504c510788b
Content-Type: text/plain; charset=ISO-8859-1

Cc: stable

James/linux-scsi,

The following patch from Kashyap Desai for megaraid_sas moves the
poll_aen_lock initializer from megasas_probe_one() to megasas_init().
This prevents a crash when a user loads the driver and tries to issue
a poll() system call on the ioctl interface with no adapters present.

Signed-off-by: Kashyap Desai <Kashyap.Desai@lsi.com>
Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi/drivers/scsi/megaraid/megaraid_sas_base.c
scsi.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi/drivers/scsi/megaraid/megaraid_sas_base.c	2012-07-17
14:57:32.890231627 -0700
+++ scsi.new/drivers/scsi/megaraid/megaraid_sas_base.c	2012-07-17
14:59:37.285232167 -0700
@@ -4095,7 +4095,6 @@
 	spin_lock_init(&instance->cmd_pool_lock);
 	spin_lock_init(&instance->hba_lock);
 	spin_lock_init(&instance->completion_lock);
-	spin_lock_init(&poll_aen_lock);

 	mutex_init(&instance->aen_mutex);
 	mutex_init(&instance->reset_mutex);
@@ -5421,6 +5420,8 @@
 	printk(KERN_INFO "megasas: %s %s\n", MEGASAS_VERSION,
 	       MEGASAS_EXT_VERSION);

+	spin_lock_init(&poll_aen_lock);
+
 	support_poll_for_event = 2;
 	support_device_change = 1;

--e89a8f23579de0ca2504c510788b
Content-Type: application/octet-stream; name="megaraid_sas.patch4"
Content-Disposition: attachment; filename="megaraid_sas.patch4"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

ZGlmZiAtTmF1ciBzY3NpL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5j
IHNjc2kubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCi0tLSBz
Y3NpL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTItMDctMTcg
MTQ6NTc6MzIuODkwMjMxNjI3IC0wNzAwCisrKyBzY3NpLm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJh
aWQvbWVnYXJhaWRfc2FzX2Jhc2UuYwkyMDEyLTA3LTE3IDE0OjU5OjM3LjI4NTIzMjE2NyAtMDcw
MApAQCAtNDA5NSw3ICs0MDk1LDYgQEAKIAlzcGluX2xvY2tfaW5pdCgmaW5zdGFuY2UtPmNtZF9w
b29sX2xvY2spOwogCXNwaW5fbG9ja19pbml0KCZpbnN0YW5jZS0+aGJhX2xvY2spOwogCXNwaW5f
bG9ja19pbml0KCZpbnN0YW5jZS0+Y29tcGxldGlvbl9sb2NrKTsKLQlzcGluX2xvY2tfaW5pdCgm
cG9sbF9hZW5fbG9jayk7CiAKIAltdXRleF9pbml0KCZpbnN0YW5jZS0+YWVuX211dGV4KTsKIAlt
dXRleF9pbml0KCZpbnN0YW5jZS0+cmVzZXRfbXV0ZXgpOwpAQCAtNTQyMSw2ICs1NDIwLDggQEAK
IAlwcmludGsoS0VSTl9JTkZPICJtZWdhc2FzOiAlcyAlc1xuIiwgTUVHQVNBU19WRVJTSU9OLAog
CSAgICAgICBNRUdBU0FTX0VYVF9WRVJTSU9OKTsKIAorCXNwaW5fbG9ja19pbml0KCZwb2xsX2Fl
bl9sb2NrKTsKKwogCXN1cHBvcnRfcG9sbF9mb3JfZXZlbnQgPSAyOwogCXN1cHBvcnRfZGV2aWNl
X2NoYW5nZSA9IDE7CiAK
--e89a8f23579de0ca2504c510788b--
