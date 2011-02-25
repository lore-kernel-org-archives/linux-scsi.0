From: adam radford <aradford@gmail.com>
Subject: [PATCH 10/14] megaraid_sas: Fix tasklet_init call
Date: Thu, 24 Feb 2011 20:57:00 -0800
Message-ID: <AANLkTikiFJfRcd1VHL7B6Ewtdt9wpa3=vY16EUNb596b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e6dab35508e6cb049d14295c
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43537 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab1BYE5B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2011 23:57:01 -0500
Received: by wyg36 with SMTP id 36so1266614wyg.19
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2011 20:57:00 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e6dab35508e6cb049d14295c
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch fixes an incorrect tasklet_init() call in
megasas_init_fw() to use instancet->tasklet.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-24
18:56:03.153275645 -0800
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-24
18:56:46.244338809 -0800
@@ -3545,7 +3545,7 @@
 	* Setup tasklet for cmd completion
 	*/

-	tasklet_init(&instance->isr_tasklet, megasas_complete_cmd_dpc,
+	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
 		(unsigned long)instance);

 	/* Initialize the cmd completion timer */

--0016e6dab35508e6cb049d14295c
Content-Type: application/octet-stream; name="megaraid_sas.patch10"
Content-Disposition: attachment; filename="megaraid_sas.patch10"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkkmku7r0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfYmFzZS5jIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jCi0tLSBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXNfYmFzZS5jCTIwMTEtMDItMjQgMTg6NTY6MDMuMTUzMjc1NjQ1IC0wODAwCisrKyBz
Y3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2Uu
YwkyMDExLTAyLTI0IDE4OjU2OjQ2LjI0NDMzODgwOSAtMDgwMApAQCAtMzU0NSw3ICszNTQ1LDcg
QEAKIAkqIFNldHVwIHRhc2tsZXQgZm9yIGNtZCBjb21wbGV0aW9uCiAJKi8KIAotCXRhc2tsZXRf
aW5pdCgmaW5zdGFuY2UtPmlzcl90YXNrbGV0LCBtZWdhc2FzX2NvbXBsZXRlX2NtZF9kcGMsCisJ
dGFza2xldF9pbml0KCZpbnN0YW5jZS0+aXNyX3Rhc2tsZXQsIGluc3RhbmNlLT5pbnN0YW5jZXQt
PnRhc2tsZXQsCiAJCSh1bnNpZ25lZCBsb25nKWluc3RhbmNlKTsKIAogCS8qIEluaXRpYWxpemUg
dGhlIGNtZCBjb21wbGV0aW9uIHRpbWVyICovCg==
--0016e6dab35508e6cb049d14295c--
