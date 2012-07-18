From: adam radford <aradford@gmail.com>
Subject: [PATCH 2/5] megaraid_sas: Add throttlequeuedepth module parameter
Date: Tue, 17 Jul 2012 18:20:03 -0700
Message-ID: <CAHtARFHiZermSVza7Zcwaxr5TpE5kY-gLeDF7_E6H74N5yOy=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=14dae93412376757e004c5107693
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40679 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab2GRBUE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2012 21:20:04 -0400
Received: by mail-yw0-f46.google.com with SMTP id m54so1074195yhm.19
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jul 2012 18:20:04 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Kashyap Desai <Kashyap.Desai@lsi.com>

--14dae93412376757e004c5107693
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas adds a throttlequeuedepth module
parameter.  This allows a user to adjust the queue depth of the
adapter when throttled due to I/O timeout.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi/drivers/scsi/megaraid/megaraid_sas_base.c
scsi.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi/drivers/scsi/megaraid/megaraid_sas_base.c	2012-07-17
14:33:50.681233390 -0700
+++ scsi.new/drivers/scsi/megaraid/megaraid_sas_base.c	2012-07-17
14:40:59.507233383 -0700
@@ -71,6 +71,11 @@
 module_param(msix_disable, int, S_IRUGO);
 MODULE_PARM_DESC(msix_disable, "Disable MSI-X interrupt handling. Default: 0");

+static int throttlequeuedepth = MEGASAS_THROTTLE_QUEUE_DEPTH;
+module_param(throttlequeuedepth, int, S_IRUGO);
+MODULE_PARM_DESC(throttlequeuedepth,
+	"Adapter queue depth when throttled due to I/O timeout. Default: 16");
+
 MODULE_LICENSE("GPL");
 MODULE_VERSION(MEGASAS_VERSION);
 MODULE_AUTHOR("megaraidlinux@lsi.com");
@@ -1595,8 +1600,9 @@
 {
 	unsigned long flags;
 	if (instance->flag & MEGASAS_FW_BUSY
-		&& time_after(jiffies, instance->last_time + 5 * HZ)
-		&& atomic_read(&instance->fw_outstanding) < 17) {
+	    && time_after(jiffies, instance->last_time + 5 * HZ)
+	    && atomic_read(&instance->fw_outstanding) <
+	    instance->throttlequeuedepth + 1) {

 		spin_lock_irqsave(instance->host->host_lock, flags);
 		instance->flag &= ~MEGASAS_FW_BUSY;
@@ -1914,7 +1920,7 @@
 		/* FW is busy, throttle IO */
 		spin_lock_irqsave(instance->host->host_lock, flags);

-		instance->host->can_queue = 16;
+		instance->host->can_queue = instance->throttlequeuedepth;
 		instance->last_time = jiffies;
 		instance->flag |= MEGASAS_FW_BUSY;

@@ -3577,6 +3583,24 @@

 	kfree(ctrl_info);

+	/* Check for valid throttlequeuedepth module parameter */
+	if (instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY ||
+	    instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY) {
+		if (throttlequeuedepth > (instance->max_fw_cmds -
+					  MEGASAS_SKINNY_INT_CMDS))
+			instance->throttlequeuedepth =
+				MEGASAS_THROTTLE_QUEUE_DEPTH;
+		else
+			instance->throttlequeuedepth = throttlequeuedepth;
+	} else {
+		if (throttlequeuedepth > (instance->max_fw_cmds -
+					  MEGASAS_INT_CMDS))
+			instance->throttlequeuedepth =
+				MEGASAS_THROTTLE_QUEUE_DEPTH;
+		else
+			instance->throttlequeuedepth = throttlequeuedepth;
+	}
+
         /*
 	* Setup tasklet for cmd completion
 	*/
diff -Naur scsi/drivers/scsi/megaraid/megaraid_sas.h
scsi.new/drivers/scsi/megaraid/megaraid_sas.h
--- scsi/drivers/scsi/megaraid/megaraid_sas.h	2012-07-17
14:33:50.683231556 -0700
+++ scsi.new/drivers/scsi/megaraid/megaraid_sas.h	2012-07-17
14:42:44.066172702 -0700
@@ -747,6 +747,7 @@
 #define	MEGASAS_RESET_NOTICE_INTERVAL		5
 #define MEGASAS_IOCTL_CMD			0
 #define MEGASAS_DEFAULT_CMD_TIMEOUT		90
+#define MEGASAS_THROTTLE_QUEUE_DEPTH		16

 /*
  * FW reports the maximum of number of commands that it can accept (maximum
@@ -1364,6 +1365,7 @@
 	unsigned long bar;
 	long reset_flags;
 	struct mutex reset_mutex;
+	int throttlequeuedepth;
 };

 enum {

--14dae93412376757e004c5107693
Content-Type: application/octet-stream; name="megaraid_sas.patch2"
Content-Disposition: attachment; filename="megaraid_sas.patch2"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

ZGlmZiAtTmF1ciBzY3NpL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5j
IHNjc2kubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCi0tLSBz
Y3NpL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTItMDctMTcg
MTQ6MzM6NTAuNjgxMjMzMzkwIC0wNzAwCisrKyBzY3NpLm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJh
aWQvbWVnYXJhaWRfc2FzX2Jhc2UuYwkyMDEyLTA3LTE3IDE0OjQwOjU5LjUwNzIzMzM4MyAtMDcw
MApAQCAtNzEsNiArNzEsMTEgQEAKIG1vZHVsZV9wYXJhbShtc2l4X2Rpc2FibGUsIGludCwgU19J
UlVHTyk7CiBNT0RVTEVfUEFSTV9ERVNDKG1zaXhfZGlzYWJsZSwgIkRpc2FibGUgTVNJLVggaW50
ZXJydXB0IGhhbmRsaW5nLiBEZWZhdWx0OiAwIik7CiAKK3N0YXRpYyBpbnQgdGhyb3R0bGVxdWV1
ZWRlcHRoID0gTUVHQVNBU19USFJPVFRMRV9RVUVVRV9ERVBUSDsKK21vZHVsZV9wYXJhbSh0aHJv
dHRsZXF1ZXVlZGVwdGgsIGludCwgU19JUlVHTyk7CitNT0RVTEVfUEFSTV9ERVNDKHRocm90dGxl
cXVldWVkZXB0aCwKKwkiQWRhcHRlciBxdWV1ZSBkZXB0aCB3aGVuIHRocm90dGxlZCBkdWUgdG8g
SS9PIHRpbWVvdXQuIERlZmF1bHQ6IDE2Iik7CisKIE1PRFVMRV9MSUNFTlNFKCJHUEwiKTsKIE1P
RFVMRV9WRVJTSU9OKE1FR0FTQVNfVkVSU0lPTik7CiBNT0RVTEVfQVVUSE9SKCJtZWdhcmFpZGxp
bnV4QGxzaS5jb20iKTsKQEAgLTE1OTUsOCArMTYwMCw5IEBACiB7CiAJdW5zaWduZWQgbG9uZyBm
bGFnczsKIAlpZiAoaW5zdGFuY2UtPmZsYWcgJiBNRUdBU0FTX0ZXX0JVU1kKLQkJJiYgdGltZV9h
ZnRlcihqaWZmaWVzLCBpbnN0YW5jZS0+bGFzdF90aW1lICsgNSAqIEhaKQotCQkmJiBhdG9taWNf
cmVhZCgmaW5zdGFuY2UtPmZ3X291dHN0YW5kaW5nKSA8IDE3KSB7CisJICAgICYmIHRpbWVfYWZ0
ZXIoamlmZmllcywgaW5zdGFuY2UtPmxhc3RfdGltZSArIDUgKiBIWikKKwkgICAgJiYgYXRvbWlj
X3JlYWQoJmluc3RhbmNlLT5md19vdXRzdGFuZGluZykgPAorCSAgICBpbnN0YW5jZS0+dGhyb3R0
bGVxdWV1ZWRlcHRoICsgMSkgewogCiAJCXNwaW5fbG9ja19pcnFzYXZlKGluc3RhbmNlLT5ob3N0
LT5ob3N0X2xvY2ssIGZsYWdzKTsKIAkJaW5zdGFuY2UtPmZsYWcgJj0gfk1FR0FTQVNfRldfQlVT
WTsKQEAgLTE5MTQsNyArMTkyMCw3IEBACiAJCS8qIEZXIGlzIGJ1c3ksIHRocm90dGxlIElPICov
CiAJCXNwaW5fbG9ja19pcnFzYXZlKGluc3RhbmNlLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsK
IAotCQlpbnN0YW5jZS0+aG9zdC0+Y2FuX3F1ZXVlID0gMTY7CisJCWluc3RhbmNlLT5ob3N0LT5j
YW5fcXVldWUgPSBpbnN0YW5jZS0+dGhyb3R0bGVxdWV1ZWRlcHRoOwogCQlpbnN0YW5jZS0+bGFz
dF90aW1lID0gamlmZmllczsKIAkJaW5zdGFuY2UtPmZsYWcgfD0gTUVHQVNBU19GV19CVVNZOwog
CkBAIC0zNTc3LDYgKzM1ODMsMjQgQEAKIAogCWtmcmVlKGN0cmxfaW5mbyk7CiAKKwkvKiBDaGVj
ayBmb3IgdmFsaWQgdGhyb3R0bGVxdWV1ZWRlcHRoIG1vZHVsZSBwYXJhbWV0ZXIgKi8KKwlpZiAo
aW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PSBQQ0lfREVWSUNFX0lEX0xTSV9TQVMwMDczU0tJTk5Z
IHx8CisJICAgIGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0gUENJX0RFVklDRV9JRF9MU0lfU0FT
MDA3MVNLSU5OWSkgeworCQlpZiAodGhyb3R0bGVxdWV1ZWRlcHRoID4gKGluc3RhbmNlLT5tYXhf
ZndfY21kcyAtCisJCQkJCSAgTUVHQVNBU19TS0lOTllfSU5UX0NNRFMpKQorCQkJaW5zdGFuY2Ut
PnRocm90dGxlcXVldWVkZXB0aCA9CisJCQkJTUVHQVNBU19USFJPVFRMRV9RVUVVRV9ERVBUSDsK
KwkJZWxzZQorCQkJaW5zdGFuY2UtPnRocm90dGxlcXVldWVkZXB0aCA9IHRocm90dGxlcXVldWVk
ZXB0aDsKKwl9IGVsc2UgeworCQlpZiAodGhyb3R0bGVxdWV1ZWRlcHRoID4gKGluc3RhbmNlLT5t
YXhfZndfY21kcyAtCisJCQkJCSAgTUVHQVNBU19JTlRfQ01EUykpCisJCQlpbnN0YW5jZS0+dGhy
b3R0bGVxdWV1ZWRlcHRoID0KKwkJCQlNRUdBU0FTX1RIUk9UVExFX1FVRVVFX0RFUFRIOworCQll
bHNlCisJCQlpbnN0YW5jZS0+dGhyb3R0bGVxdWV1ZWRlcHRoID0gdGhyb3R0bGVxdWV1ZWRlcHRo
OworCX0KKwogICAgICAgICAvKgogCSogU2V0dXAgdGFza2xldCBmb3IgY21kIGNvbXBsZXRpb24K
IAkqLwpkaWZmIC1OYXVyIHNjc2kvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5o
IHNjc2kubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaAotLS0gc2NzaS9k
cml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmgJMjAxMi0wNy0xNyAxNDozMzo1MC42
ODMyMzE1NTYgLTA3MDAKKysrIHNjc2kubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXMuaAkyMDEyLTA3LTE3IDE0OjQyOjQ0LjA2NjE3MjcwMiAtMDcwMApAQCAtNzQ3LDYgKzc0
Nyw3IEBACiAjZGVmaW5lCU1FR0FTQVNfUkVTRVRfTk9USUNFX0lOVEVSVkFMCQk1CiAjZGVmaW5l
IE1FR0FTQVNfSU9DVExfQ01ECQkJMAogI2RlZmluZSBNRUdBU0FTX0RFRkFVTFRfQ01EX1RJTUVP
VVQJCTkwCisjZGVmaW5lIE1FR0FTQVNfVEhST1RUTEVfUVVFVUVfREVQVEgJCTE2CiAKIC8qCiAg
KiBGVyByZXBvcnRzIHRoZSBtYXhpbXVtIG9mIG51bWJlciBvZiBjb21tYW5kcyB0aGF0IGl0IGNh
biBhY2NlcHQgKG1heGltdW0KQEAgLTEzNjQsNiArMTM2NSw3IEBACiAJdW5zaWduZWQgbG9uZyBi
YXI7CiAJbG9uZyByZXNldF9mbGFnczsKIAlzdHJ1Y3QgbXV0ZXggcmVzZXRfbXV0ZXg7CisJaW50
IHRocm90dGxlcXVldWVkZXB0aDsKIH07CiAKIGVudW0gewo=
--14dae93412376757e004c5107693--
