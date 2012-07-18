From: adam radford <aradford@gmail.com>
Subject: [PATCH 3/5] megaraid_sas: Add resetwaittime module parameter
Date: Tue, 17 Jul 2012 18:20:24 -0700
Message-ID: <CAHtARFH2XDTos6E-tJG4yna-oT119Cn4Ks36Xdz52WqiWsg-pA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=14dae934062ba9e2d904c51077e6
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:60323 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab2GRBUZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2012 21:20:25 -0400
Received: by ghrr11 with SMTP id r11so1077547ghr.19
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jul 2012 18:20:24 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Kashyap Desai <Kashyap.Desai@lsi.com>

--14dae934062ba9e2d904c51077e6
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas adds support for a resetwaittime
module parameter.  This allows a user to adjust the wait time in
seconds after I/O timeout before resetting the adapter.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi/drivers/scsi/megaraid/megaraid_sas_base.c
scsi.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi/drivers/scsi/megaraid/megaraid_sas_base.c	2012-07-17
14:44:04.341294660 -0700
+++ scsi.new/drivers/scsi/megaraid/megaraid_sas_base.c	2012-07-17
14:50:41.503232158 -0700
@@ -76,6 +76,11 @@
 MODULE_PARM_DESC(throttlequeuedepth,
 	"Adapter queue depth when throttled due to I/O timeout. Default: 16");

+int resetwaittime = MEGASAS_RESET_WAIT_TIME;
+module_param(resetwaittime, int, S_IRUGO);
+MODULE_PARM_DESC(resetwaittime, "Wait time in seconds after I/O timeout "
+		 "before resetting adapter. Default: 180");
+
 MODULE_LICENSE("GPL");
 MODULE_VERSION(MEGASAS_VERSION);
 MODULE_AUTHOR("megaraidlinux@lsi.com");
@@ -1778,7 +1783,7 @@
 		return SUCCESS;
 	}

-	for (i = 0; i < wait_time; i++) {
+	for (i = 0; i < resetwaittime; i++) {

 		int outstanding = atomic_read(&instance->fw_outstanding);

diff -Naur scsi/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi/drivers/scsi/megaraid/megaraid_sas_fusion.c	2012-07-17
14:33:50.682231505 -0700
+++ scsi.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2012-07-17
14:54:56.487358768 -0700
@@ -94,6 +94,7 @@
 void megaraid_sas_kill_hba(struct megasas_instance *instance);

 extern u32 megasas_dbg_lvl;
+extern int resetwaittime;

 /**
  * megasas_enable_intr_fusion -	Enables interrupts
@@ -2063,9 +2064,9 @@
 int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance)
 {
 	int i, outstanding, retval = 0;
-	u32 fw_state, wait_time = MEGASAS_RESET_WAIT_TIME;
+	u32 fw_state;

-	for (i = 0; i < wait_time; i++) {
+	for (i = 0; i < resetwaittime; i++) {
 		/* Check if firmware is in fault state */
 		fw_state = instance->instancet->read_fw_status_reg(
 			instance->reg_set) & MFI_STATE_MASK;

--14dae934062ba9e2d904c51077e6
Content-Type: application/octet-stream; name="megaraid_sas.patch3"
Content-Disposition: attachment; filename="megaraid_sas.patch3"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

ZGlmZiAtTmF1ciBzY3NpL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5j
IHNjc2kubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCi0tLSBz
Y3NpL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTItMDctMTcg
MTQ6NDQ6MDQuMzQxMjk0NjYwIC0wNzAwCisrKyBzY3NpLm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJh
aWQvbWVnYXJhaWRfc2FzX2Jhc2UuYwkyMDEyLTA3LTE3IDE0OjUwOjQxLjUwMzIzMjE1OCAtMDcw
MApAQCAtNzYsNiArNzYsMTEgQEAKIE1PRFVMRV9QQVJNX0RFU0ModGhyb3R0bGVxdWV1ZWRlcHRo
LAogCSJBZGFwdGVyIHF1ZXVlIGRlcHRoIHdoZW4gdGhyb3R0bGVkIGR1ZSB0byBJL08gdGltZW91
dC4gRGVmYXVsdDogMTYiKTsKIAoraW50IHJlc2V0d2FpdHRpbWUgPSBNRUdBU0FTX1JFU0VUX1dB
SVRfVElNRTsKK21vZHVsZV9wYXJhbShyZXNldHdhaXR0aW1lLCBpbnQsIFNfSVJVR08pOworTU9E
VUxFX1BBUk1fREVTQyhyZXNldHdhaXR0aW1lLCAiV2FpdCB0aW1lIGluIHNlY29uZHMgYWZ0ZXIg
SS9PIHRpbWVvdXQgIgorCQkgImJlZm9yZSByZXNldHRpbmcgYWRhcHRlci4gRGVmYXVsdDogMTgw
Iik7CisKIE1PRFVMRV9MSUNFTlNFKCJHUEwiKTsKIE1PRFVMRV9WRVJTSU9OKE1FR0FTQVNfVkVS
U0lPTik7CiBNT0RVTEVfQVVUSE9SKCJtZWdhcmFpZGxpbnV4QGxzaS5jb20iKTsKQEAgLTE3Nzgs
NyArMTc4Myw3IEBACiAJCXJldHVybiBTVUNDRVNTOwogCX0KIAotCWZvciAoaSA9IDA7IGkgPCB3
YWl0X3RpbWU7IGkrKykgeworCWZvciAoaSA9IDA7IGkgPCByZXNldHdhaXR0aW1lOyBpKyspIHsK
IAogCQlpbnQgb3V0c3RhbmRpbmcgPSBhdG9taWNfcmVhZCgmaW5zdGFuY2UtPmZ3X291dHN0YW5k
aW5nKTsKIApkaWZmIC1OYXVyIHNjc2kvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nh
c19mdXNpb24uYyBzY3NpLm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Z1
c2lvbi5jCi0tLSBzY3NpL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9u
LmMJMjAxMi0wNy0xNyAxNDozMzo1MC42ODIyMzE1MDUgLTA3MDAKKysrIHNjc2kubmV3L2RyaXZl
cnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmMJMjAxMi0wNy0xNyAxNDo1NDo1
Ni40ODczNTg3NjggLTA3MDAKQEAgLTk0LDYgKzk0LDcgQEAKIHZvaWQgbWVnYXJhaWRfc2FzX2tp
bGxfaGJhKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSk7CiAKIGV4dGVybiB1MzIg
bWVnYXNhc19kYmdfbHZsOworZXh0ZXJuIGludCByZXNldHdhaXR0aW1lOwogCiAvKioKICAqIG1l
Z2FzYXNfZW5hYmxlX2ludHJfZnVzaW9uIC0JRW5hYmxlcyBpbnRlcnJ1cHRzCkBAIC0yMDYzLDkg
KzIwNjQsOSBAQAogaW50IG1lZ2FzYXNfd2FpdF9mb3Jfb3V0c3RhbmRpbmdfZnVzaW9uKHN0cnVj
dCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSkKIHsKIAlpbnQgaSwgb3V0c3RhbmRpbmcsIHJl
dHZhbCA9IDA7Ci0JdTMyIGZ3X3N0YXRlLCB3YWl0X3RpbWUgPSBNRUdBU0FTX1JFU0VUX1dBSVRf
VElNRTsKKwl1MzIgZndfc3RhdGU7CiAKLQlmb3IgKGkgPSAwOyBpIDwgd2FpdF90aW1lOyBpKysp
IHsKKwlmb3IgKGkgPSAwOyBpIDwgcmVzZXR3YWl0dGltZTsgaSsrKSB7CiAJCS8qIENoZWNrIGlm
IGZpcm13YXJlIGlzIGluIGZhdWx0IHN0YXRlICovCiAJCWZ3X3N0YXRlID0gaW5zdGFuY2UtPmlu
c3RhbmNldC0+cmVhZF9md19zdGF0dXNfcmVnKAogCQkJaW5zdGFuY2UtPnJlZ19zZXQpICYgTUZJ
X1NUQVRFX01BU0s7Cg==
--14dae934062ba9e2d904c51077e6--
