From: adam radford <aradford@gmail.com>
Subject: [PATCH 7/8] megaraid_sas: Add 1078 OCR support
Date: Wed, 11 May 2011 18:34:52 -0700
Message-ID: <BANLkTi=sb_PY7iV=VbCAeQCFGtvQWg5nmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e6513a1c15981a04a30a32da
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59656 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527Ab1ELBew (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 May 2011 21:34:52 -0400
Received: by qwk3 with SMTP id 3so547658qwk.19
        for <linux-scsi@vger.kernel.org>; Wed, 11 May 2011 18:34:52 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e6513a1c15981a04a30a32da
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas adds 1078 OCR support.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc/drivers/scsi/megaraid/megaraid_sas_base.c	2011-05-11
15:30:11.901336369 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-05-11
16:07:47.077366265 -0700
@@ -437,15 +437,18 @@
 static int
 megasas_clear_intr_ppc(struct megasas_register_set __iomem * regs)
 {
-	u32 status;
+	u32 status, mfiStatus = 0;
+
 	/*
 	 * Check if it is our interrupt
 	 */
 	status = readl(&regs->outbound_intr_status);

-	if (!(status & MFI_REPLY_1078_MESSAGE_INTERRUPT)) {
-		return 0;
-	}
+	if (status & MFI_REPLY_1078_MESSAGE_INTERRUPT)
+		mfiStatus = MFI_INTR_FLAG_REPLY_MESSAGE;
+
+	if (status & MFI_G2_OUTBOUND_DOORBELL_CHANGE_INTERRUPT)
+		mfiStatus |= MFI_INTR_FLAG_FIRMWARE_STATE_CHANGE;

 	/*
 	 * Clear the interrupt by writing back the same value
@@ -455,8 +458,9 @@
 	/* Dummy readl to force pci flush */
 	readl(&regs->outbound_doorbell_clear);

-	return 1;
+	return mfiStatus;
 }
+
 /**
  * megasas_fire_cmd_ppc -	Sends command to the FW
  * @frame_phys_addr :		Physical address of cmd
@@ -477,17 +481,6 @@
 }

 /**
- * megasas_adp_reset_ppc -	For controller reset
- * @regs:				MFI register set
- */
-static int
-megasas_adp_reset_ppc(struct megasas_instance *instance,
-			struct megasas_register_set __iomem *regs)
-{
-	return 0;
-}
-
-/**
  * megasas_check_reset_ppc -	For controller reset check
  * @regs:				MFI register set
  */
@@ -495,8 +488,12 @@
 megasas_check_reset_ppc(struct megasas_instance *instance,
 			struct megasas_register_set __iomem *regs)
 {
+	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL)
+		return 1;
+
 	return 0;
 }
+
 static struct megasas_instance_template megasas_instance_template_ppc = {

 	.fire_cmd = megasas_fire_cmd_ppc,
@@ -504,7 +501,7 @@
 	.disable_intr = megasas_disable_intr_ppc,
 	.clear_intr = megasas_clear_intr_ppc,
 	.read_fw_status_reg = megasas_read_fw_status_reg_ppc,
-	.adp_reset = megasas_adp_reset_ppc,
+	.adp_reset = megasas_adp_reset_xscale,
 	.check_reset = megasas_check_reset_ppc,
 	.service_isr = megasas_isr,
 	.tasklet = megasas_complete_cmd_dpc,
@@ -620,6 +617,9 @@
 megasas_check_reset_skinny(struct megasas_instance *instance,
 				struct megasas_register_set __iomem *regs)
 {
+	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL)
+		return 1;
+
 	return 0;
 }

--0016e6513a1c15981a04a30a32da
Content-Type: application/octet-stream; name="megaraid_sas.patch7"
Content-Disposition: attachment; filename="megaraid_sas.patch7"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gnl0qxm40

ZGlmZiAtTmF1ciBzY3NpLW1pc2MvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19i
YXNlLmMgc2NzaS1taXNjLm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jh
c2UuYwotLS0gc2NzaS1taXNjL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFz
ZS5jCTIwMTEtMDUtMTEgMTU6MzA6MTEuOTAxMzM2MzY5IC0wNzAwCisrKyBzY3NpLW1pc2MubmV3
L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTEtMDUtMTEgMTY6
MDc6NDcuMDc3MzY2MjY1IC0wNzAwCkBAIC00MzcsMTUgKzQzNywxOCBAQAogc3RhdGljIGludAog
bWVnYXNhc19jbGVhcl9pbnRyX3BwYyhzdHJ1Y3QgbWVnYXNhc19yZWdpc3Rlcl9zZXQgX19pb21l
bSAqIHJlZ3MpCiB7Ci0JdTMyIHN0YXR1czsKKwl1MzIgc3RhdHVzLCBtZmlTdGF0dXMgPSAwOwor
CiAJLyoKIAkgKiBDaGVjayBpZiBpdCBpcyBvdXIgaW50ZXJydXB0CiAJICovCiAJc3RhdHVzID0g
cmVhZGwoJnJlZ3MtPm91dGJvdW5kX2ludHJfc3RhdHVzKTsKIAotCWlmICghKHN0YXR1cyAmIE1G
SV9SRVBMWV8xMDc4X01FU1NBR0VfSU5URVJSVVBUKSkgewotCQlyZXR1cm4gMDsKLQl9CisJaWYg
KHN0YXR1cyAmIE1GSV9SRVBMWV8xMDc4X01FU1NBR0VfSU5URVJSVVBUKQorCQltZmlTdGF0dXMg
PSBNRklfSU5UUl9GTEFHX1JFUExZX01FU1NBR0U7CisKKwlpZiAoc3RhdHVzICYgTUZJX0cyX09V
VEJPVU5EX0RPT1JCRUxMX0NIQU5HRV9JTlRFUlJVUFQpCisJCW1maVN0YXR1cyB8PSBNRklfSU5U
Ul9GTEFHX0ZJUk1XQVJFX1NUQVRFX0NIQU5HRTsKIAogCS8qCiAJICogQ2xlYXIgdGhlIGludGVy
cnVwdCBieSB3cml0aW5nIGJhY2sgdGhlIHNhbWUgdmFsdWUKQEAgLTQ1NSw4ICs0NTgsOSBAQAog
CS8qIER1bW15IHJlYWRsIHRvIGZvcmNlIHBjaSBmbHVzaCAqLwogCXJlYWRsKCZyZWdzLT5vdXRi
b3VuZF9kb29yYmVsbF9jbGVhcik7CiAKLQlyZXR1cm4gMTsKKwlyZXR1cm4gbWZpU3RhdHVzOwog
fQorCiAvKioKICAqIG1lZ2FzYXNfZmlyZV9jbWRfcHBjIC0JU2VuZHMgY29tbWFuZCB0byB0aGUg
RlcKICAqIEBmcmFtZV9waHlzX2FkZHIgOgkJUGh5c2ljYWwgYWRkcmVzcyBvZiBjbWQKQEAgLTQ3
NywxNyArNDgxLDYgQEAKIH0KIAogLyoqCi0gKiBtZWdhc2FzX2FkcF9yZXNldF9wcGMgLQlGb3Ig
Y29udHJvbGxlciByZXNldAotICogQHJlZ3M6CQkJCU1GSSByZWdpc3RlciBzZXQKLSAqLwotc3Rh
dGljIGludAotbWVnYXNhc19hZHBfcmVzZXRfcHBjKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICpp
bnN0YW5jZSwKLQkJCXN0cnVjdCBtZWdhc2FzX3JlZ2lzdGVyX3NldCBfX2lvbWVtICpyZWdzKQot
ewotCXJldHVybiAwOwotfQotCi0vKioKICAqIG1lZ2FzYXNfY2hlY2tfcmVzZXRfcHBjIC0JRm9y
IGNvbnRyb2xsZXIgcmVzZXQgY2hlY2sKICAqIEByZWdzOgkJCQlNRkkgcmVnaXN0ZXIgc2V0CiAg
Ki8KQEAgLTQ5NSw4ICs0ODgsMTIgQEAKIG1lZ2FzYXNfY2hlY2tfcmVzZXRfcHBjKHN0cnVjdCBt
ZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwKIAkJCXN0cnVjdCBtZWdhc2FzX3JlZ2lzdGVyX3Nl
dCBfX2lvbWVtICpyZWdzKQogeworCWlmIChpbnN0YW5jZS0+YWRwcmVjb3ZlcnkgIT0gTUVHQVNB
U19IQkFfT1BFUkFUSU9OQUwpCisJCXJldHVybiAxOworCiAJcmV0dXJuIDA7CiB9CisKIHN0YXRp
YyBzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZV90ZW1wbGF0ZSBtZWdhc2FzX2luc3RhbmNlX3RlbXBs
YXRlX3BwYyA9IHsKIAogCS5maXJlX2NtZCA9IG1lZ2FzYXNfZmlyZV9jbWRfcHBjLApAQCAtNTA0
LDcgKzUwMSw3IEBACiAJLmRpc2FibGVfaW50ciA9IG1lZ2FzYXNfZGlzYWJsZV9pbnRyX3BwYywK
IAkuY2xlYXJfaW50ciA9IG1lZ2FzYXNfY2xlYXJfaW50cl9wcGMsCiAJLnJlYWRfZndfc3RhdHVz
X3JlZyA9IG1lZ2FzYXNfcmVhZF9md19zdGF0dXNfcmVnX3BwYywKLQkuYWRwX3Jlc2V0ID0gbWVn
YXNhc19hZHBfcmVzZXRfcHBjLAorCS5hZHBfcmVzZXQgPSBtZWdhc2FzX2FkcF9yZXNldF94c2Nh
bGUsCiAJLmNoZWNrX3Jlc2V0ID0gbWVnYXNhc19jaGVja19yZXNldF9wcGMsCiAJLnNlcnZpY2Vf
aXNyID0gbWVnYXNhc19pc3IsCiAJLnRhc2tsZXQgPSBtZWdhc2FzX2NvbXBsZXRlX2NtZF9kcGMs
CkBAIC02MjAsNiArNjE3LDkgQEAKIG1lZ2FzYXNfY2hlY2tfcmVzZXRfc2tpbm55KHN0cnVjdCBt
ZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwKIAkJCQlzdHJ1Y3QgbWVnYXNhc19yZWdpc3Rlcl9z
ZXQgX19pb21lbSAqcmVncykKIHsKKwlpZiAoaW5zdGFuY2UtPmFkcHJlY292ZXJ5ICE9IE1FR0FT
QVNfSEJBX09QRVJBVElPTkFMKQorCQlyZXR1cm4gMTsKKwogCXJldHVybiAwOwogfQogCg==
--0016e6513a1c15981a04a30a32da--
