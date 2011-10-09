From: adam radford <aradford@gmail.com>
Subject: [PATCH 1/10] megaraid_sas: Continue booting immediately if FW in
 FAULT at driver load time
Date: Sat, 8 Oct 2011 18:14:27 -0700
Message-ID: <CAHtARFEdS2cEqe75=myD10uw0ii20j=4mgPGhSxHz0V27JFfqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e64c393a47711f04aed3656d
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62149 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1JIBO3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Oct 2011 21:14:29 -0400
Received: by wyg34 with SMTP id 34so4924347wyg.19
        for <linux-scsi@vger.kernel.org>; Sat, 08 Oct 2011 18:14:27 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e64c393a47711f04aed3656d
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

This patch for megaraid_sas will continue booting immediately if FW is
in FAULT state at driver load time.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c	2011-10-07
12:10:42.000000000 -0700
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-10-07
17:38:45.026330261 -0700
@@ -84,7 +84,7 @@
 MODULE_AUTHOR("megaraidlinux@lsi.com");
 MODULE_DESCRIPTION("LSI MegaRAID SAS Driver");

-int megasas_transition_to_ready(struct megasas_instance *instance);
+int megasas_transition_to_ready(struct megasas_instance *instance, int ocr);
 static int megasas_get_pd_list(struct megasas_instance *instance);
 static int megasas_issue_init_mfi(struct megasas_instance *instance);
 static int megasas_register_aen(struct megasas_instance *instance,
@@ -2477,7 +2477,7 @@
 			msleep(1000);
 		}

-		if (megasas_transition_to_ready(instance)) {
+		if (megasas_transition_to_ready(instance, 1)) {
 			printk(KERN_NOTICE "megaraid_sas:adapter not ready\n");

 			megaraid_sas_kill_hba(instance);
@@ -2617,7 +2617,7 @@
  * has to wait for the ready state.
  */
 int
-megasas_transition_to_ready(struct megasas_instance* instance)
+megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 {
 	int i;
 	u8 max_wait;
@@ -2639,11 +2639,13 @@
 		switch (fw_state) {

 		case MFI_STATE_FAULT:
-
 			printk(KERN_DEBUG "megasas: FW in FAULT state!!\n");
-			max_wait = MEGASAS_RESET_WAIT_TIME;
-			cur_state = MFI_STATE_FAULT;
-			break;
+			if (ocr) {
+				max_wait = MEGASAS_RESET_WAIT_TIME;
+				cur_state = MFI_STATE_FAULT;
+				break;
+			} else
+				return -ENODEV;

 		case MFI_STATE_WAIT_HANDSHAKE:
 			/*
@@ -3520,7 +3522,7 @@
 	/*
 	 * We expect the FW state to be READY
 	 */
-	if (megasas_transition_to_ready(instance))
+	if (megasas_transition_to_ready(instance, 0))
 		goto fail_ready_state;

 	/* Check if MSI-X is supported while in ready state */
@@ -4357,7 +4359,7 @@
 	/*
 	 * We expect the FW state to be READY
 	 */
-	if (megasas_transition_to_ready(instance))
+	if (megasas_transition_to_ready(instance, 0))
 		goto fail_ready_state;

 	/* Now re-enable MSI-X */
diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-10-07
12:10:42.000000000 -0700
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-10-07
17:33:25.854175220 -0700
@@ -89,7 +89,7 @@
 		      struct LD_LOAD_BALANCE_INFO *lbInfo);
 u16 get_updated_dev_handle(struct LD_LOAD_BALANCE_INFO *lbInfo,
 			   struct IO_REQUEST_INFO *in_info);
-int megasas_transition_to_ready(struct megasas_instance *instance);
+int megasas_transition_to_ready(struct megasas_instance *instance, int ocr);
 void megaraid_sas_kill_hba(struct megasas_instance *instance);

 extern u32 megasas_dbg_lvl;
@@ -2173,7 +2173,7 @@
 			}

 			/* Wait for FW to become ready */
-			if (megasas_transition_to_ready(instance)) {
+			if (megasas_transition_to_ready(instance, 1)) {
 				printk(KERN_WARNING "megaraid_sas: Failed to "
 				       "transition controller to ready.\n");
 				continue;

--0016e64c393a47711f04aed3656d
Content-Type: application/octet-stream; name="megaraid_sas.patch1"
Content-Disposition: attachment; filename="megaraid_sas.patch1"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gtjbnou40

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfYmFzZS5jIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jCi0tLSBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXNfYmFzZS5jCTIwMTEtMTAtMDcgMTI6MTA6NDIuMDAwMDAwMDAwIC0wNzAwCisrKyBz
Y3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2Uu
YwkyMDExLTEwLTA3IDE3OjM4OjQ1LjAyNjMzMDI2MSAtMDcwMApAQCAtODQsNyArODQsNyBAQAog
TU9EVUxFX0FVVEhPUigibWVnYXJhaWRsaW51eEBsc2kuY29tIik7CiBNT0RVTEVfREVTQ1JJUFRJ
T04oIkxTSSBNZWdhUkFJRCBTQVMgRHJpdmVyIik7CiAKLWludCBtZWdhc2FzX3RyYW5zaXRpb25f
dG9fcmVhZHkoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKTsKK2ludCBtZWdhc2Fz
X3RyYW5zaXRpb25fdG9fcmVhZHkoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLCBp
bnQgb2NyKTsKIHN0YXRpYyBpbnQgbWVnYXNhc19nZXRfcGRfbGlzdChzdHJ1Y3QgbWVnYXNhc19p
bnN0YW5jZSAqaW5zdGFuY2UpOwogc3RhdGljIGludCBtZWdhc2FzX2lzc3VlX2luaXRfbWZpKHN0
cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSk7CiBzdGF0aWMgaW50IG1lZ2FzYXNfcmVn
aXN0ZXJfYWVuKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwKQEAgLTI0NzcsNyAr
MjQ3Nyw3IEBACiAJCQltc2xlZXAoMTAwMCk7CiAJCX0KIAotCQlpZiAobWVnYXNhc190cmFuc2l0
aW9uX3RvX3JlYWR5KGluc3RhbmNlKSkgeworCQlpZiAobWVnYXNhc190cmFuc2l0aW9uX3RvX3Jl
YWR5KGluc3RhbmNlLCAxKSkgewogCQkJcHJpbnRrKEtFUk5fTk9USUNFICJtZWdhcmFpZF9zYXM6
YWRhcHRlciBub3QgcmVhZHlcbiIpOwogCiAJCQltZWdhcmFpZF9zYXNfa2lsbF9oYmEoaW5zdGFu
Y2UpOwpAQCAtMjYxNyw3ICsyNjE3LDcgQEAKICAqIGhhcyB0byB3YWl0IGZvciB0aGUgcmVhZHkg
c3RhdGUuCiAgKi8KIGludAotbWVnYXNhc190cmFuc2l0aW9uX3RvX3JlYWR5KHN0cnVjdCBtZWdh
c2FzX2luc3RhbmNlKiBpbnN0YW5jZSkKK21lZ2FzYXNfdHJhbnNpdGlvbl90b19yZWFkeShzdHJ1
Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsIGludCBvY3IpCiB7CiAJaW50IGk7CiAJdTgg
bWF4X3dhaXQ7CkBAIC0yNjM5LDExICsyNjM5LDEzIEBACiAJCXN3aXRjaCAoZndfc3RhdGUpIHsK
IAogCQljYXNlIE1GSV9TVEFURV9GQVVMVDoKLQogCQkJcHJpbnRrKEtFUk5fREVCVUcgIm1lZ2Fz
YXM6IEZXIGluIEZBVUxUIHN0YXRlISFcbiIpOwotCQkJbWF4X3dhaXQgPSBNRUdBU0FTX1JFU0VU
X1dBSVRfVElNRTsKLQkJCWN1cl9zdGF0ZSA9IE1GSV9TVEFURV9GQVVMVDsKLQkJCWJyZWFrOwor
CQkJaWYgKG9jcikgeworCQkJCW1heF93YWl0ID0gTUVHQVNBU19SRVNFVF9XQUlUX1RJTUU7CisJ
CQkJY3VyX3N0YXRlID0gTUZJX1NUQVRFX0ZBVUxUOworCQkJCWJyZWFrOworCQkJfSBlbHNlCisJ
CQkJcmV0dXJuIC1FTk9ERVY7CiAKIAkJY2FzZSBNRklfU1RBVEVfV0FJVF9IQU5EU0hBS0U6CiAJ
CQkvKgpAQCAtMzUyMCw3ICszNTIyLDcgQEAKIAkvKgogCSAqIFdlIGV4cGVjdCB0aGUgRlcgc3Rh
dGUgdG8gYmUgUkVBRFkKIAkgKi8KLQlpZiAobWVnYXNhc190cmFuc2l0aW9uX3RvX3JlYWR5KGlu
c3RhbmNlKSkKKwlpZiAobWVnYXNhc190cmFuc2l0aW9uX3RvX3JlYWR5KGluc3RhbmNlLCAwKSkK
IAkJZ290byBmYWlsX3JlYWR5X3N0YXRlOwogCiAJLyogQ2hlY2sgaWYgTVNJLVggaXMgc3VwcG9y
dGVkIHdoaWxlIGluIHJlYWR5IHN0YXRlICovCkBAIC00MzU3LDcgKzQzNTksNyBAQAogCS8qCiAJ
ICogV2UgZXhwZWN0IHRoZSBGVyBzdGF0ZSB0byBiZSBSRUFEWQogCSAqLwotCWlmIChtZWdhc2Fz
X3RyYW5zaXRpb25fdG9fcmVhZHkoaW5zdGFuY2UpKQorCWlmIChtZWdhc2FzX3RyYW5zaXRpb25f
dG9fcmVhZHkoaW5zdGFuY2UsIDApKQogCQlnb3RvIGZhaWxfcmVhZHlfc3RhdGU7CiAKIAkvKiBO
b3cgcmUtZW5hYmxlIE1TSS1YICovCmRpZmYgLU5hdXIgc2NzaS1taXNjLTIuNi9kcml2ZXJzL3Nj
c2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Z1c2lvbi5jIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZl
cnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmMKLS0tIHNjc2ktbWlzYy0yLjYv
ZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24uYwkyMDExLTEwLTA3IDEy
OjEwOjQyLjAwMDAwMDAwMCAtMDcwMAorKysgc2NzaS1taXNjLTIuNi5uZXcvZHJpdmVycy9zY3Np
L21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24uYwkyMDExLTEwLTA3IDE3OjMzOjI1Ljg1NDE3
NTIyMCAtMDcwMApAQCAtODksNyArODksNyBAQAogCQkgICAgICBzdHJ1Y3QgTERfTE9BRF9CQUxB
TkNFX0lORk8gKmxiSW5mbyk7CiB1MTYgZ2V0X3VwZGF0ZWRfZGV2X2hhbmRsZShzdHJ1Y3QgTERf
TE9BRF9CQUxBTkNFX0lORk8gKmxiSW5mbywKIAkJCSAgIHN0cnVjdCBJT19SRVFVRVNUX0lORk8g
KmluX2luZm8pOwotaW50IG1lZ2FzYXNfdHJhbnNpdGlvbl90b19yZWFkeShzdHJ1Y3QgbWVnYXNh
c19pbnN0YW5jZSAqaW5zdGFuY2UpOworaW50IG1lZ2FzYXNfdHJhbnNpdGlvbl90b19yZWFkeShz
dHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsIGludCBvY3IpOwogdm9pZCBtZWdhcmFp
ZF9zYXNfa2lsbF9oYmEoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKTsKIAogZXh0
ZXJuIHUzMiBtZWdhc2FzX2RiZ19sdmw7CkBAIC0yMTczLDcgKzIxNzMsNyBAQAogCQkJfQogCiAJ
CQkvKiBXYWl0IGZvciBGVyB0byBiZWNvbWUgcmVhZHkgKi8KLQkJCWlmIChtZWdhc2FzX3RyYW5z
aXRpb25fdG9fcmVhZHkoaW5zdGFuY2UpKSB7CisJCQlpZiAobWVnYXNhc190cmFuc2l0aW9uX3Rv
X3JlYWR5KGluc3RhbmNlLCAxKSkgewogCQkJCXByaW50ayhLRVJOX1dBUk5JTkcgIm1lZ2FyYWlk
X3NhczogRmFpbGVkIHRvICIKIAkJCQkgICAgICAgInRyYW5zaXRpb24gY29udHJvbGxlciB0byBy
ZWFkeS5cbiIpOwogCQkJCWNvbnRpbnVlOwo=
--0016e64c393a47711f04aed3656d--
