From: adam radford <aradford@gmail.com>
Subject: [PATCH 13/14] megaraid_sas: Fix iMR OCR support to work correctly
Date: Thu, 24 Feb 2011 20:57:15 -0800
Message-ID: <AANLkTi=YdqDjjjtX69VG5sT1BprYzsnpZe_5UJe=Xj1s@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=000e0ce00132f658fd049d142978
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49097 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab1BYE5Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2011 23:57:16 -0500
Received: by mail-ww0-f44.google.com with SMTP id 39so1696373wwb.1
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2011 20:57:15 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--000e0ce00132f658fd049d142978
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch for megaraid_sas fixes iMR OCR support to work correctly.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-24
19:01:39.700307009 -0800
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-24
19:04:00.586244253 -0800
@@ -134,7 +134,11 @@
 void
 megasas_complete_cmd(struct megasas_instance *instance, struct
megasas_cmd *cmd,
 		     u8 alt_status);
-
+static u32
+megasas_read_fw_status_reg_gen2(struct megasas_register_set __iomem *regs);
+static int
+megasas_adp_reset_gen2(struct megasas_instance *instance,
+		       struct megasas_register_set __iomem *reg_set);
 static irqreturn_t megasas_isr(int irq, void *devp);
 static u32
 megasas_init_adapter_mfi(struct megasas_instance *instance);
@@ -555,6 +559,8 @@
 megasas_clear_intr_skinny(struct megasas_register_set __iomem *regs)
 {
 	u32 status;
+	u32 mfiStatus = 0;
+
 	/*
 	 * Check if it is our interrupt
 	 */
@@ -565,6 +571,15 @@
 	}

 	/*
+	 * Check if it is our interrupt
+	 */
+	if ((megasas_read_fw_status_reg_gen2(regs) & MFI_STATE_MASK) ==
+	    MFI_STATE_FAULT) {
+		mfiStatus = MFI_INTR_FLAG_FIRMWARE_STATE_CHANGE;
+	} else
+		mfiStatus = MFI_INTR_FLAG_REPLY_MESSAGE;
+
+	/*
 	 * Clear the interrupt by writing back the same value
 	 */
 	writel(status, &regs->outbound_intr_status);
@@ -574,7 +589,7 @@
 	*/
 	readl(&regs->outbound_intr_status);

-	return 1;
+	return mfiStatus;
 }

 /**
@@ -598,17 +613,6 @@
 }

 /**
- * megasas_adp_reset_skinny -	For controller reset
- * @regs:				MFI register set
- */
-static int
-megasas_adp_reset_skinny(struct megasas_instance *instance,
-			struct megasas_register_set __iomem *regs)
-{
-	return 0;
-}
-
-/**
  * megasas_check_reset_skinny -	For controller reset check
  * @regs:				MFI register set
  */
@@ -626,7 +630,7 @@
 	.disable_intr = megasas_disable_intr_skinny,
 	.clear_intr = megasas_clear_intr_skinny,
 	.read_fw_status_reg = megasas_read_fw_status_reg_skinny,
-	.adp_reset = megasas_adp_reset_skinny,
+	.adp_reset = megasas_adp_reset_gen2,
 	.check_reset = megasas_check_reset_skinny,
 	.service_isr = megasas_isr,
 	.tasklet = megasas_complete_cmd_dpc,
@@ -741,20 +745,28 @@
 {
 	u32			retry = 0 ;
 	u32			HostDiag;
+	u32			*seq_offset = &reg_set->seq_offset;
+	u32			*hostdiag_offset = &reg_set->host_diag;
+
+	if (instance->instancet == &megasas_instance_template_skinny) {
+		seq_offset = &reg_set->fusion_seq_offset;
+		hostdiag_offset = &reg_set->fusion_host_diag;
+	}
+
+	writel(0, seq_offset);
+	writel(4, seq_offset);
+	writel(0xb, seq_offset);
+	writel(2, seq_offset);
+	writel(7, seq_offset);
+	writel(0xd, seq_offset);

-	writel(0, &reg_set->seq_offset);
-	writel(4, &reg_set->seq_offset);
-	writel(0xb, &reg_set->seq_offset);
-	writel(2, &reg_set->seq_offset);
-	writel(7, &reg_set->seq_offset);
-	writel(0xd, &reg_set->seq_offset);
 	msleep(1000);

-	HostDiag = (u32)readl(&reg_set->host_diag);
+	HostDiag = (u32)readl(hostdiag_offset);

 	while ( !( HostDiag & DIAG_WRITE_ENABLE) ) {
 		msleep(100);
-		HostDiag = (u32)readl(&reg_set->host_diag);
+		HostDiag = (u32)readl(hostdiag_offset);
 		printk(KERN_NOTICE "RESETGEN2: retry=%x, hostdiag=%x\n",
 					retry, HostDiag);

@@ -765,14 +777,14 @@

 	printk(KERN_NOTICE "ADP_RESET_GEN2: HostDiag=%x\n", HostDiag);

-	writel((HostDiag | DIAG_RESET_ADAPTER), &reg_set->host_diag);
+	writel((HostDiag | DIAG_RESET_ADAPTER), hostdiag_offset);

 	ssleep(10);

-	HostDiag = (u32)readl(&reg_set->host_diag);
+	HostDiag = (u32)readl(hostdiag_offset);
 	while ( ( HostDiag & DIAG_RESET_ADAPTER) ) {
 		msleep(100);
-		HostDiag = (u32)readl(&reg_set->host_diag);
+		HostDiag = (u32)readl(hostdiag_offset);
 		printk(KERN_NOTICE "RESET_GEN2: retry=%x, hostdiag=%x\n",
 				retry, HostDiag);

--000e0ce00132f658fd049d142978
Content-Type: application/octet-stream; name="megaraid_sas.patch13"
Content-Disposition: attachment; filename="megaraid_sas.patch13"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkkmmpre0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfYmFzZS5jIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jCi0tLSBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXNfYmFzZS5jCTIwMTEtMDItMjQgMTk6MDE6MzkuNzAwMzA3MDA5IC0wODAwCisrKyBz
Y3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2Uu
YwkyMDExLTAyLTI0IDE5OjA0OjAwLjU4NjI0NDI1MyAtMDgwMApAQCAtMTM0LDcgKzEzNCwxMSBA
QAogdm9pZAogbWVnYXNhc19jb21wbGV0ZV9jbWQoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmlu
c3RhbmNlLCBzdHJ1Y3QgbWVnYXNhc19jbWQgKmNtZCwKIAkJICAgICB1OCBhbHRfc3RhdHVzKTsK
LQorc3RhdGljIHUzMgorbWVnYXNhc19yZWFkX2Z3X3N0YXR1c19yZWdfZ2VuMihzdHJ1Y3QgbWVn
YXNhc19yZWdpc3Rlcl9zZXQgX19pb21lbSAqcmVncyk7CitzdGF0aWMgaW50CittZWdhc2FzX2Fk
cF9yZXNldF9nZW4yKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwKKwkJICAgICAg
IHN0cnVjdCBtZWdhc2FzX3JlZ2lzdGVyX3NldCBfX2lvbWVtICpyZWdfc2V0KTsKIHN0YXRpYyBp
cnFyZXR1cm5fdCBtZWdhc2FzX2lzcihpbnQgaXJxLCB2b2lkICpkZXZwKTsKIHN0YXRpYyB1MzIK
IG1lZ2FzYXNfaW5pdF9hZGFwdGVyX21maShzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFu
Y2UpOwpAQCAtNTU1LDYgKzU1OSw4IEBACiBtZWdhc2FzX2NsZWFyX2ludHJfc2tpbm55KHN0cnVj
dCBtZWdhc2FzX3JlZ2lzdGVyX3NldCBfX2lvbWVtICpyZWdzKQogewogCXUzMiBzdGF0dXM7CisJ
dTMyIG1maVN0YXR1cyA9IDA7CisKIAkvKgogCSAqIENoZWNrIGlmIGl0IGlzIG91ciBpbnRlcnJ1
cHQKIAkgKi8KQEAgLTU2NSw2ICs1NzEsMTUgQEAKIAl9CiAKIAkvKgorCSAqIENoZWNrIGlmIGl0
IGlzIG91ciBpbnRlcnJ1cHQKKwkgKi8KKwlpZiAoKG1lZ2FzYXNfcmVhZF9md19zdGF0dXNfcmVn
X2dlbjIocmVncykgJiBNRklfU1RBVEVfTUFTSykgPT0KKwkgICAgTUZJX1NUQVRFX0ZBVUxUKSB7
CisJCW1maVN0YXR1cyA9IE1GSV9JTlRSX0ZMQUdfRklSTVdBUkVfU1RBVEVfQ0hBTkdFOworCX0g
ZWxzZQorCQltZmlTdGF0dXMgPSBNRklfSU5UUl9GTEFHX1JFUExZX01FU1NBR0U7CisKKwkvKgog
CSAqIENsZWFyIHRoZSBpbnRlcnJ1cHQgYnkgd3JpdGluZyBiYWNrIHRoZSBzYW1lIHZhbHVlCiAJ
ICovCiAJd3JpdGVsKHN0YXR1cywgJnJlZ3MtPm91dGJvdW5kX2ludHJfc3RhdHVzKTsKQEAgLTU3
NCw3ICs1ODksNyBAQAogCSovCiAJcmVhZGwoJnJlZ3MtPm91dGJvdW5kX2ludHJfc3RhdHVzKTsK
IAotCXJldHVybiAxOworCXJldHVybiBtZmlTdGF0dXM7CiB9CiAKIC8qKgpAQCAtNTk4LDE3ICs2
MTMsNiBAQAogfQogCiAvKioKLSAqIG1lZ2FzYXNfYWRwX3Jlc2V0X3NraW5ueSAtCUZvciBjb250
cm9sbGVyIHJlc2V0Ci0gKiBAcmVnczoJCQkJTUZJIHJlZ2lzdGVyIHNldAotICovCi1zdGF0aWMg
aW50Ci1tZWdhc2FzX2FkcF9yZXNldF9za2lubnkoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmlu
c3RhbmNlLAotCQkJc3RydWN0IG1lZ2FzYXNfcmVnaXN0ZXJfc2V0IF9faW9tZW0gKnJlZ3MpCi17
Ci0JcmV0dXJuIDA7Ci19Ci0KLS8qKgogICogbWVnYXNhc19jaGVja19yZXNldF9za2lubnkgLQlG
b3IgY29udHJvbGxlciByZXNldCBjaGVjawogICogQHJlZ3M6CQkJCU1GSSByZWdpc3RlciBzZXQK
ICAqLwpAQCAtNjI2LDcgKzYzMCw3IEBACiAJLmRpc2FibGVfaW50ciA9IG1lZ2FzYXNfZGlzYWJs
ZV9pbnRyX3NraW5ueSwKIAkuY2xlYXJfaW50ciA9IG1lZ2FzYXNfY2xlYXJfaW50cl9za2lubnks
CiAJLnJlYWRfZndfc3RhdHVzX3JlZyA9IG1lZ2FzYXNfcmVhZF9md19zdGF0dXNfcmVnX3NraW5u
eSwKLQkuYWRwX3Jlc2V0ID0gbWVnYXNhc19hZHBfcmVzZXRfc2tpbm55LAorCS5hZHBfcmVzZXQg
PSBtZWdhc2FzX2FkcF9yZXNldF9nZW4yLAogCS5jaGVja19yZXNldCA9IG1lZ2FzYXNfY2hlY2tf
cmVzZXRfc2tpbm55LAogCS5zZXJ2aWNlX2lzciA9IG1lZ2FzYXNfaXNyLAogCS50YXNrbGV0ID0g
bWVnYXNhc19jb21wbGV0ZV9jbWRfZHBjLApAQCAtNzQxLDIwICs3NDUsMjggQEAKIHsKIAl1MzIJ
CQlyZXRyeSA9IDAgOwogCXUzMgkJCUhvc3REaWFnOworCXUzMgkJCSpzZXFfb2Zmc2V0ID0gJnJl
Z19zZXQtPnNlcV9vZmZzZXQ7CisJdTMyCQkJKmhvc3RkaWFnX29mZnNldCA9ICZyZWdfc2V0LT5o
b3N0X2RpYWc7CisKKwlpZiAoaW5zdGFuY2UtPmluc3RhbmNldCA9PSAmbWVnYXNhc19pbnN0YW5j
ZV90ZW1wbGF0ZV9za2lubnkpIHsKKwkJc2VxX29mZnNldCA9ICZyZWdfc2V0LT5mdXNpb25fc2Vx
X29mZnNldDsKKwkJaG9zdGRpYWdfb2Zmc2V0ID0gJnJlZ19zZXQtPmZ1c2lvbl9ob3N0X2RpYWc7
CisJfQorCisJd3JpdGVsKDAsIHNlcV9vZmZzZXQpOworCXdyaXRlbCg0LCBzZXFfb2Zmc2V0KTsK
Kwl3cml0ZWwoMHhiLCBzZXFfb2Zmc2V0KTsKKwl3cml0ZWwoMiwgc2VxX29mZnNldCk7CisJd3Jp
dGVsKDcsIHNlcV9vZmZzZXQpOworCXdyaXRlbCgweGQsIHNlcV9vZmZzZXQpOwogCi0Jd3JpdGVs
KDAsICZyZWdfc2V0LT5zZXFfb2Zmc2V0KTsKLQl3cml0ZWwoNCwgJnJlZ19zZXQtPnNlcV9vZmZz
ZXQpOwotCXdyaXRlbCgweGIsICZyZWdfc2V0LT5zZXFfb2Zmc2V0KTsKLQl3cml0ZWwoMiwgJnJl
Z19zZXQtPnNlcV9vZmZzZXQpOwotCXdyaXRlbCg3LCAmcmVnX3NldC0+c2VxX29mZnNldCk7Ci0J
d3JpdGVsKDB4ZCwgJnJlZ19zZXQtPnNlcV9vZmZzZXQpOwogCW1zbGVlcCgxMDAwKTsKIAotCUhv
c3REaWFnID0gKHUzMilyZWFkbCgmcmVnX3NldC0+aG9zdF9kaWFnKTsKKwlIb3N0RGlhZyA9ICh1
MzIpcmVhZGwoaG9zdGRpYWdfb2Zmc2V0KTsKIAogCXdoaWxlICggISggSG9zdERpYWcgJiBESUFH
X1dSSVRFX0VOQUJMRSkgKSB7CiAJCW1zbGVlcCgxMDApOwotCQlIb3N0RGlhZyA9ICh1MzIpcmVh
ZGwoJnJlZ19zZXQtPmhvc3RfZGlhZyk7CisJCUhvc3REaWFnID0gKHUzMilyZWFkbChob3N0ZGlh
Z19vZmZzZXQpOwogCQlwcmludGsoS0VSTl9OT1RJQ0UgIlJFU0VUR0VOMjogcmV0cnk9JXgsIGhv
c3RkaWFnPSV4XG4iLAogCQkJCQlyZXRyeSwgSG9zdERpYWcpOwogCkBAIC03NjUsMTQgKzc3Nywx
NCBAQAogCiAJcHJpbnRrKEtFUk5fTk9USUNFICJBRFBfUkVTRVRfR0VOMjogSG9zdERpYWc9JXhc
biIsIEhvc3REaWFnKTsKIAotCXdyaXRlbCgoSG9zdERpYWcgfCBESUFHX1JFU0VUX0FEQVBURVIp
LCAmcmVnX3NldC0+aG9zdF9kaWFnKTsKKwl3cml0ZWwoKEhvc3REaWFnIHwgRElBR19SRVNFVF9B
REFQVEVSKSwgaG9zdGRpYWdfb2Zmc2V0KTsKIAogCXNzbGVlcCgxMCk7CiAKLQlIb3N0RGlhZyA9
ICh1MzIpcmVhZGwoJnJlZ19zZXQtPmhvc3RfZGlhZyk7CisJSG9zdERpYWcgPSAodTMyKXJlYWRs
KGhvc3RkaWFnX29mZnNldCk7CiAJd2hpbGUgKCAoIEhvc3REaWFnICYgRElBR19SRVNFVF9BREFQ
VEVSKSApIHsKIAkJbXNsZWVwKDEwMCk7Ci0JCUhvc3REaWFnID0gKHUzMilyZWFkbCgmcmVnX3Nl
dC0+aG9zdF9kaWFnKTsKKwkJSG9zdERpYWcgPSAodTMyKXJlYWRsKGhvc3RkaWFnX29mZnNldCk7
CiAJCXByaW50ayhLRVJOX05PVElDRSAiUkVTRVRfR0VOMjogcmV0cnk9JXgsIGhvc3RkaWFnPSV4
XG4iLAogCQkJCXJldHJ5LCBIb3N0RGlhZyk7CiAK
--000e0ce00132f658fd049d142978--
