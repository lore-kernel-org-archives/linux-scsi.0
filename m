From: adam radford <aradford@gmail.com>
Subject: [PATCH 5/8] megaraid_sas: Fix bug where AENs could be lost in probe()
 and resume()
Date: Wed, 11 May 2011 18:34:29 -0700
Message-ID: <BANLkTi=Om7hfCeKnCgh4R5Sh8xYD6jfqaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001636426b6bbcece804a30a3055
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:50650 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab1ELBe3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 May 2011 21:34:29 -0400
Received: by mail-qy0-f181.google.com with SMTP id 14so618486qyg.19
        for <linux-scsi@vger.kernel.org>; Wed, 11 May 2011 18:34:29 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--001636426b6bbcece804a30a3055
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas fixes a bug where AENs could be
lost in probe() and resume().

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc/drivers/scsi/megaraid/megaraid_sas_base.c	2011-05-11
15:12:58.708429569 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-05-11
15:19:01.260428701 -0700
@@ -4115,6 +4115,14 @@
 	megasas_mgmt_info.max_index++;

 	/*
+	 * Register with SCSI mid-layer
+	 */
+	if (megasas_io_attach(instance))
+		goto fail_io_attach;
+
+	instance->unload = 0;
+
+	/*
 	 * Initiate AEN (Asynchronous Event Notification)
 	 */
 	if (megasas_start_aen(instance)) {
@@ -4122,13 +4130,6 @@
 		goto fail_start_aen;
 	}

-	/*
-	 * Register with SCSI mid-layer
-	 */
-	if (megasas_io_attach(instance))
-		goto fail_io_attach;
-
-	instance->unload = 0;
 	return 0;

       fail_start_aen:
@@ -4383,12 +4384,6 @@

 	instance->instancet->enable_intr(instance->reg_set);

-	/*
-	 * Initiate AEN (Asynchronous Event Notification)
-	 */
-	if (megasas_start_aen(instance))
-		printk(KERN_ERR "megasas: Start AEN failed\n");
-
 	/* Initialize the cmd completion timer */
 	if (poll_mode_io)
 		megasas_start_timer(instance, &instance->io_completion_timer,
@@ -4396,6 +4391,12 @@
 				MEGASAS_COMPLETION_TIMER_INTERVAL);
 	instance->unload = 0;

+	/*
+	 * Initiate AEN (Asynchronous Event Notification)
+	 */
+	if (megasas_start_aen(instance))
+		printk(KERN_ERR "megasas: Start AEN failed\n");
+
 	return 0;

 fail_irq:

--001636426b6bbcece804a30a3055
Content-Type: application/octet-stream; name="megaraid_sas.patch5"
Content-Disposition: attachment; filename="megaraid_sas.patch5"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gnl0mbhs0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19i
YXNlLmMgc2NzaS1taXNjLm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jh
c2UuYwotLS0gc2NzaS1taXNjL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFz
ZS5jCTIwMTEtMDUtMTEgMTU6MTI6NTguNzA4NDI5NTY5IC0wNzAwCisrKyBzY3NpLW1pc2MubmV3
L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTEtMDUtMTEgMTU6
MTk6MDEuMjYwNDI4NzAxIC0wNzAwCkBAIC00MTE1LDYgKzQxMTUsMTQgQEAKIAltZWdhc2FzX21n
bXRfaW5mby5tYXhfaW5kZXgrKzsKIAogCS8qCisJICogUmVnaXN0ZXIgd2l0aCBTQ1NJIG1pZC1s
YXllcgorCSAqLworCWlmIChtZWdhc2FzX2lvX2F0dGFjaChpbnN0YW5jZSkpCisJCWdvdG8gZmFp
bF9pb19hdHRhY2g7CisKKwlpbnN0YW5jZS0+dW5sb2FkID0gMDsKKworCS8qCiAJICogSW5pdGlh
dGUgQUVOIChBc3luY2hyb25vdXMgRXZlbnQgTm90aWZpY2F0aW9uKQogCSAqLwogCWlmIChtZWdh
c2FzX3N0YXJ0X2FlbihpbnN0YW5jZSkpIHsKQEAgLTQxMjIsMTMgKzQxMzAsNiBAQAogCQlnb3Rv
IGZhaWxfc3RhcnRfYWVuOwogCX0KIAotCS8qCi0JICogUmVnaXN0ZXIgd2l0aCBTQ1NJIG1pZC1s
YXllcgotCSAqLwotCWlmIChtZWdhc2FzX2lvX2F0dGFjaChpbnN0YW5jZSkpCi0JCWdvdG8gZmFp
bF9pb19hdHRhY2g7Ci0KLQlpbnN0YW5jZS0+dW5sb2FkID0gMDsKIAlyZXR1cm4gMDsKIAogICAg
ICAgZmFpbF9zdGFydF9hZW46CkBAIC00MzgzLDEyICs0Mzg0LDYgQEAKIAogCWluc3RhbmNlLT5p
bnN0YW5jZXQtPmVuYWJsZV9pbnRyKGluc3RhbmNlLT5yZWdfc2V0KTsKIAotCS8qCi0JICogSW5p
dGlhdGUgQUVOIChBc3luY2hyb25vdXMgRXZlbnQgTm90aWZpY2F0aW9uKQotCSAqLwotCWlmICht
ZWdhc2FzX3N0YXJ0X2FlbihpbnN0YW5jZSkpCi0JCXByaW50ayhLRVJOX0VSUiAibWVnYXNhczog
U3RhcnQgQUVOIGZhaWxlZFxuIik7Ci0KIAkvKiBJbml0aWFsaXplIHRoZSBjbWQgY29tcGxldGlv
biB0aW1lciAqLwogCWlmIChwb2xsX21vZGVfaW8pCiAJCW1lZ2FzYXNfc3RhcnRfdGltZXIoaW5z
dGFuY2UsICZpbnN0YW5jZS0+aW9fY29tcGxldGlvbl90aW1lciwKQEAgLTQzOTYsNiArNDM5MSwx
MiBAQAogCQkJCU1FR0FTQVNfQ09NUExFVElPTl9USU1FUl9JTlRFUlZBTCk7CiAJaW5zdGFuY2Ut
PnVubG9hZCA9IDA7CiAKKwkvKgorCSAqIEluaXRpYXRlIEFFTiAoQXN5bmNocm9ub3VzIEV2ZW50
IE5vdGlmaWNhdGlvbikKKwkgKi8KKwlpZiAobWVnYXNhc19zdGFydF9hZW4oaW5zdGFuY2UpKQor
CQlwcmludGsoS0VSTl9FUlIgIm1lZ2FzYXM6IFN0YXJ0IEFFTiBmYWlsZWRcbiIpOworCiAJcmV0
dXJuIDA7CiAKIGZhaWxfaXJxOgo=
--001636426b6bbcece804a30a3055--
