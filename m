From: adam radford <aradford@gmail.com>
Subject: [PATCH 11/15] megaraid_sas: Fix tasklet_init call
Date: Sat, 19 Feb 2011 18:23:09 -0800
Message-ID: <AANLkTim90PkTs04vsxgeum2Upk6fjZv9xkbgRREqPfA8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e65a0d30aaa5cf049cad6ddc
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50704 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab1BTCXK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2011 21:23:10 -0500
Received: by mail-wy0-f174.google.com with SMTP id 38so105867wyb.19
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2011 18:23:10 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e65a0d30aaa5cf049cad6ddc
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch fixes an incorrect tasklet_init() call in
megasas_init_fw() to use instancet->tasklet.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_base.c
linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-19
14:18:21.672207602 -0800
+++ linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-19
14:19:28.434238510 -0800
@@ -3545,7 +3545,7 @@
 	* Setup tasklet for cmd completion
 	*/

-	tasklet_init(&instance->isr_tasklet, megasas_complete_cmd_dpc,
+	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
 		(unsigned long)instance);

 	/* Initialize the cmd completion timer */

--0016e65a0d30aaa5cf049cad6ddc
Content-Type: application/octet-stream; name="megaraid_sas.patch11"
Content-Disposition: attachment; filename="megaraid_sas.patch11"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkdbcj990

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzgtcmM1L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jIGxpbnV4LTIuNi4zOC1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9t
ZWdhcmFpZF9zYXNfYmFzZS5jCi0tLSBsaW51eC0yLjYuMzgtcmM1L2RyaXZlcnMvc2NzaS9tZWdh
cmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTEtMDItMTkgMTQ6MTg6MjEuNjcyMjA3NjAyIC0w
ODAwCisrKyBsaW51eC0yLjYuMzgtcmM1Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJh
aWRfc2FzX2Jhc2UuYwkyMDExLTAyLTE5IDE0OjE5OjI4LjQzNDIzODUxMCAtMDgwMApAQCAtMzU0
NSw3ICszNTQ1LDcgQEAKIAkqIFNldHVwIHRhc2tsZXQgZm9yIGNtZCBjb21wbGV0aW9uCiAJKi8K
IAotCXRhc2tsZXRfaW5pdCgmaW5zdGFuY2UtPmlzcl90YXNrbGV0LCBtZWdhc2FzX2NvbXBsZXRl
X2NtZF9kcGMsCisJdGFza2xldF9pbml0KCZpbnN0YW5jZS0+aXNyX3Rhc2tsZXQsIGluc3RhbmNl
LT5pbnN0YW5jZXQtPnRhc2tsZXQsCiAJCSh1bnNpZ25lZCBsb25nKWluc3RhbmNlKTsKIAogCS8q
IEluaXRpYWxpemUgdGhlIGNtZCBjb21wbGV0aW9uIHRpbWVyICovCg==
--0016e65a0d30aaa5cf049cad6ddc--
