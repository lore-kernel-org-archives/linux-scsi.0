From: adam radford <aradford@gmail.com>
Subject: [PATCH 3/8] megaraid_sas: Check MFI_REG_STATE.fault.resetAdapter
Date: Wed, 11 May 2011 18:34:08 -0700
Message-ID: <BANLkTi=HUGQBV8JP5yPs5gnGRVy2-tFQJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf30363f3d765b1204a30a2fbb
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:50650 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab1ELBeI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 May 2011 21:34:08 -0400
Received: by mail-qy0-f181.google.com with SMTP id 14so618486qyg.19
        for <linux-scsi@vger.kernel.org>; Wed, 11 May 2011 18:34:08 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--20cf30363f3d765b1204a30a2fbb
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas fixes the function
megasas_reset_fusion() and makes the reset code check
MFI_REG_STATE.fault.resetAdapter.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-05-11
14:45:07.478429879 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-05-11
14:52:13.820367858 -0700
@@ -2010,17 +2010,11 @@
 	struct fusion_context *fusion;
 	struct megasas_cmd *cmd_mfi;
 	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
-	u32 host_diag, abs_state;
+	u32 host_diag, abs_state, status_reg, reset_adapter;

 	instance = (struct megasas_instance *)shost->hostdata;
 	fusion = instance->ctrl_context;

-	mutex_lock(&instance->reset_mutex);
-	set_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);
-	instance->adprecovery = MEGASAS_ADPRESET_SM_INFAULT;
-	instance->instancet->disable_intr(instance->reg_set);
-	msleep(1000);
-
 	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
 		printk(KERN_WARNING "megaraid_sas: Hardware critical error, "
 		       "returning FAILED.\n");
@@ -2028,6 +2022,12 @@
 		goto out;
 	}

+	mutex_lock(&instance->reset_mutex);
+	set_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);
+	instance->adprecovery = MEGASAS_ADPRESET_SM_INFAULT;
+	instance->instancet->disable_intr(instance->reg_set);
+	msleep(1000);
+
 	/* First try waiting for commands to complete */
 	if (megasas_wait_for_outstanding_fusion(instance)) {
 		printk(KERN_WARNING "megaraid_sas: resetting fusion "
@@ -2044,7 +2044,12 @@
 			}
 		}

-		if (instance->disableOnlineCtrlReset == 1) {
+		status_reg = instance->instancet->read_fw_status_reg(
+			instance->reg_set);
+		abs_state = status_reg & MFI_STATE_MASK;
+		reset_adapter = status_reg & MFI_RESET_ADAPTER;
+		if (instance->disableOnlineCtrlReset ||
+		    (abs_state == MFI_STATE_FAULT && !reset_adapter)) {
 			/* Reset not supported, kill adapter */
 			printk(KERN_WARNING "megaraid_sas: Reset not supported"
 			       ", killing adapter.\n");
@@ -2073,6 +2078,7 @@

 			/* Check that the diag write enable (DRWE) bit is on */
 			host_diag = readl(&instance->reg_set->fusion_host_diag);
+			retry = 0;
 			while (!(host_diag & HOST_DIAG_WRITE_ENABLE)) {
 				msleep(100);
 				host_diag =
@@ -2110,7 +2116,7 @@

 			abs_state =
 				instance->instancet->read_fw_status_reg(
-					instance->reg_set);
+					instance->reg_set) & MFI_STATE_MASK;
 			retry = 0;

 			while ((abs_state <= MFI_STATE_FW_INIT) &&
@@ -2118,7 +2124,7 @@
 				msleep(100);
 				abs_state =
 				instance->instancet->read_fw_status_reg(
-					instance->reg_set);
+					instance->reg_set) & MFI_STATE_MASK;
 			}
 			if (abs_state <= MFI_STATE_FW_INIT) {
 				printk(KERN_WARNING "megaraid_sas: firmware "
diff -Naur scsi-misc/drivers/scsi/megaraid/megaraid_sas.h
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas.h
--- scsi-misc/drivers/scsi/megaraid/megaraid_sas.h	2011-05-09
19:33:54.000000000 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas.h	2011-05-11
14:53:20.491368525 -0700
@@ -76,8 +76,8 @@
 #define MFI_STATE_READY				0xB0000000
 #define MFI_STATE_OPERATIONAL			0xC0000000
 #define MFI_STATE_FAULT				0xF0000000
-#define  MFI_RESET_REQUIRED			0x00000001
-
+#define MFI_RESET_REQUIRED			0x00000001
+#define MFI_RESET_ADAPTER			0x00000002
 #define MEGAMFI_FRAME_SIZE			64

 /*

--20cf30363f3d765b1204a30a2fbb
Content-Type: application/octet-stream; name="megaraid_sas.patch3"
Content-Disposition: attachment; filename="megaraid_sas.patch3"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gnl0hto10

ZGlmZiAtTmF1ciBzY3NpLW1pc2MvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19m
dXNpb24uYyBzY3NpLW1pc2MubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNf
ZnVzaW9uLmMKLS0tIHNjc2ktbWlzYy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2Fz
X2Z1c2lvbi5jCTIwMTEtMDUtMTEgMTQ6NDU6MDcuNDc4NDI5ODc5IC0wNzAwCisrKyBzY3NpLW1p
c2MubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmMJMjAxMS0w
NS0xMSAxNDo1MjoxMy44MjAzNjc4NTggLTA3MDAKQEAgLTIwMTAsMTcgKzIwMTAsMTEgQEAKIAlz
dHJ1Y3QgZnVzaW9uX2NvbnRleHQgKmZ1c2lvbjsKIAlzdHJ1Y3QgbWVnYXNhc19jbWQgKmNtZF9t
Zmk7CiAJdW5pb24gTUVHQVNBU19SRVFVRVNUX0RFU0NSSVBUT1JfVU5JT04gKnJlcV9kZXNjOwot
CXUzMiBob3N0X2RpYWcsIGFic19zdGF0ZTsKKwl1MzIgaG9zdF9kaWFnLCBhYnNfc3RhdGUsIHN0
YXR1c19yZWcsIHJlc2V0X2FkYXB0ZXI7CiAKIAlpbnN0YW5jZSA9IChzdHJ1Y3QgbWVnYXNhc19p
bnN0YW5jZSAqKXNob3N0LT5ob3N0ZGF0YTsKIAlmdXNpb24gPSBpbnN0YW5jZS0+Y3RybF9jb250
ZXh0OwogCi0JbXV0ZXhfbG9jaygmaW5zdGFuY2UtPnJlc2V0X211dGV4KTsKLQlzZXRfYml0KE1F
R0FTQVNfRlVTSU9OX0lOX1JFU0VULCAmaW5zdGFuY2UtPnJlc2V0X2ZsYWdzKTsKLQlpbnN0YW5j
ZS0+YWRwcmVjb3ZlcnkgPSBNRUdBU0FTX0FEUFJFU0VUX1NNX0lORkFVTFQ7Ci0JaW5zdGFuY2Ut
Pmluc3RhbmNldC0+ZGlzYWJsZV9pbnRyKGluc3RhbmNlLT5yZWdfc2V0KTsKLQltc2xlZXAoMTAw
MCk7Ci0KIAlpZiAoaW5zdGFuY2UtPmFkcHJlY292ZXJ5ID09IE1FR0FTQVNfSFdfQ1JJVElDQUxf
RVJST1IpIHsKIAkJcHJpbnRrKEtFUk5fV0FSTklORyAibWVnYXJhaWRfc2FzOiBIYXJkd2FyZSBj
cml0aWNhbCBlcnJvciwgIgogCQkgICAgICAgInJldHVybmluZyBGQUlMRUQuXG4iKTsKQEAgLTIw
MjgsNiArMjAyMiwxMiBAQAogCQlnb3RvIG91dDsKIAl9CiAKKwltdXRleF9sb2NrKCZpbnN0YW5j
ZS0+cmVzZXRfbXV0ZXgpOworCXNldF9iaXQoTUVHQVNBU19GVVNJT05fSU5fUkVTRVQsICZpbnN0
YW5jZS0+cmVzZXRfZmxhZ3MpOworCWluc3RhbmNlLT5hZHByZWNvdmVyeSA9IE1FR0FTQVNfQURQ
UkVTRVRfU01fSU5GQVVMVDsKKwlpbnN0YW5jZS0+aW5zdGFuY2V0LT5kaXNhYmxlX2ludHIoaW5z
dGFuY2UtPnJlZ19zZXQpOworCW1zbGVlcCgxMDAwKTsKKwogCS8qIEZpcnN0IHRyeSB3YWl0aW5n
IGZvciBjb21tYW5kcyB0byBjb21wbGV0ZSAqLwogCWlmIChtZWdhc2FzX3dhaXRfZm9yX291dHN0
YW5kaW5nX2Z1c2lvbihpbnN0YW5jZSkpIHsKIAkJcHJpbnRrKEtFUk5fV0FSTklORyAibWVnYXJh
aWRfc2FzOiByZXNldHRpbmcgZnVzaW9uICIKQEAgLTIwNDQsNyArMjA0NCwxMiBAQAogCQkJfQog
CQl9CiAKLQkJaWYgKGluc3RhbmNlLT5kaXNhYmxlT25saW5lQ3RybFJlc2V0ID09IDEpIHsKKwkJ
c3RhdHVzX3JlZyA9IGluc3RhbmNlLT5pbnN0YW5jZXQtPnJlYWRfZndfc3RhdHVzX3JlZygKKwkJ
CWluc3RhbmNlLT5yZWdfc2V0KTsKKwkJYWJzX3N0YXRlID0gc3RhdHVzX3JlZyAmIE1GSV9TVEFU
RV9NQVNLOworCQlyZXNldF9hZGFwdGVyID0gc3RhdHVzX3JlZyAmIE1GSV9SRVNFVF9BREFQVEVS
OworCQlpZiAoaW5zdGFuY2UtPmRpc2FibGVPbmxpbmVDdHJsUmVzZXQgfHwKKwkJICAgIChhYnNf
c3RhdGUgPT0gTUZJX1NUQVRFX0ZBVUxUICYmICFyZXNldF9hZGFwdGVyKSkgewogCQkJLyogUmVz
ZXQgbm90IHN1cHBvcnRlZCwga2lsbCBhZGFwdGVyICovCiAJCQlwcmludGsoS0VSTl9XQVJOSU5H
ICJtZWdhcmFpZF9zYXM6IFJlc2V0IG5vdCBzdXBwb3J0ZWQiCiAJCQkgICAgICAgIiwga2lsbGlu
ZyBhZGFwdGVyLlxuIik7CkBAIC0yMDczLDYgKzIwNzgsNyBAQAogCiAJCQkvKiBDaGVjayB0aGF0
IHRoZSBkaWFnIHdyaXRlIGVuYWJsZSAoRFJXRSkgYml0IGlzIG9uICovCiAJCQlob3N0X2RpYWcg
PSByZWFkbCgmaW5zdGFuY2UtPnJlZ19zZXQtPmZ1c2lvbl9ob3N0X2RpYWcpOworCQkJcmV0cnkg
PSAwOwogCQkJd2hpbGUgKCEoaG9zdF9kaWFnICYgSE9TVF9ESUFHX1dSSVRFX0VOQUJMRSkpIHsK
IAkJCQltc2xlZXAoMTAwKTsKIAkJCQlob3N0X2RpYWcgPQpAQCAtMjExMCw3ICsyMTE2LDcgQEAK
IAogCQkJYWJzX3N0YXRlID0KIAkJCQlpbnN0YW5jZS0+aW5zdGFuY2V0LT5yZWFkX2Z3X3N0YXR1
c19yZWcoCi0JCQkJCWluc3RhbmNlLT5yZWdfc2V0KTsKKwkJCQkJaW5zdGFuY2UtPnJlZ19zZXQp
ICYgTUZJX1NUQVRFX01BU0s7CiAJCQlyZXRyeSA9IDA7CiAKIAkJCXdoaWxlICgoYWJzX3N0YXRl
IDw9IE1GSV9TVEFURV9GV19JTklUKSAmJgpAQCAtMjExOCw3ICsyMTI0LDcgQEAKIAkJCQltc2xl
ZXAoMTAwKTsKIAkJCQlhYnNfc3RhdGUgPQogCQkJCWluc3RhbmNlLT5pbnN0YW5jZXQtPnJlYWRf
Zndfc3RhdHVzX3JlZygKLQkJCQkJaW5zdGFuY2UtPnJlZ19zZXQpOworCQkJCQlpbnN0YW5jZS0+
cmVnX3NldCkgJiBNRklfU1RBVEVfTUFTSzsKIAkJCX0KIAkJCWlmIChhYnNfc3RhdGUgPD0gTUZJ
X1NUQVRFX0ZXX0lOSVQpIHsKIAkJCQlwcmludGsoS0VSTl9XQVJOSU5HICJtZWdhcmFpZF9zYXM6
IGZpcm13YXJlICIKZGlmZiAtTmF1ciBzY3NpLW1pc2MvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21l
Z2FyYWlkX3Nhcy5oIHNjc2ktbWlzYy5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlk
X3Nhcy5oCi0tLSBzY3NpLW1pc2MvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5o
CTIwMTEtMDUtMDkgMTk6MzM6NTQuMDAwMDAwMDAwIC0wNzAwCisrKyBzY3NpLW1pc2MubmV3L2Ry
aXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaAkyMDExLTA1LTExIDE0OjUzOjIwLjQ5
MTM2ODUyNSAtMDcwMApAQCAtNzYsOCArNzYsOCBAQAogI2RlZmluZSBNRklfU1RBVEVfUkVBRFkJ
CQkJMHhCMDAwMDAwMAogI2RlZmluZSBNRklfU1RBVEVfT1BFUkFUSU9OQUwJCQkweEMwMDAwMDAw
CiAjZGVmaW5lIE1GSV9TVEFURV9GQVVMVAkJCQkweEYwMDAwMDAwCi0jZGVmaW5lICBNRklfUkVT
RVRfUkVRVUlSRUQJCQkweDAwMDAwMDAxCi0KKyNkZWZpbmUgTUZJX1JFU0VUX1JFUVVJUkVECQkJ
MHgwMDAwMDAwMQorI2RlZmluZSBNRklfUkVTRVRfQURBUFRFUgkJCTB4MDAwMDAwMDIKICNkZWZp
bmUgTUVHQU1GSV9GUkFNRV9TSVpFCQkJNjQKIAogLyoK
--20cf30363f3d765b1204a30a2fbb--
