From: adam radford <aradford@gmail.com>
Subject: [PATCH 14/15] megaraid_sas: Fix iMR OCR support to work correctly
Date: Sat, 19 Feb 2011 18:23:27 -0800
Message-ID: <AANLkTindHWbf2Y-3j70GYTQu9N1ua4V8YidfxAb6gC7q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e64c0b8cb19128049cad6e33
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50704 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab1BTCX2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2011 21:23:28 -0500
Received: by mail-wy0-f174.google.com with SMTP id 38so105867wyb.19
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2011 18:23:27 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e64c0b8cb19128049cad6e33
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch for megaraid_sas fixes iMR OCR support to work correctly.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_base.c
linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-19
14:39:15.185274156 -0800
+++ linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-19
15:07:15.028428379 -0800
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

--0016e64c0b8cb19128049cad6e33
Content-Type: application/octet-stream; name="megaraid_sas.patch14"
Content-Disposition: attachment; filename="megaraid_sas.patch14"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkdbiumj0

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzgtcmM1L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jIGxpbnV4LTIuNi4zOC1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9t
ZWdhcmFpZF9zYXNfYmFzZS5jCi0tLSBsaW51eC0yLjYuMzgtcmM1L2RyaXZlcnMvc2NzaS9tZWdh
cmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTEtMDItMTkgMTQ6Mzk6MTUuMTg1Mjc0MTU2IC0w
ODAwCisrKyBsaW51eC0yLjYuMzgtcmM1Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJh
aWRfc2FzX2Jhc2UuYwkyMDExLTAyLTE5IDE1OjA3OjE1LjAyODQyODM3OSAtMDgwMApAQCAtMTM0
LDcgKzEzNCwxMSBAQAogdm9pZAogbWVnYXNhc19jb21wbGV0ZV9jbWQoc3RydWN0IG1lZ2FzYXNf
aW5zdGFuY2UgKmluc3RhbmNlLCBzdHJ1Y3QgbWVnYXNhc19jbWQgKmNtZCwKIAkJICAgICB1OCBh
bHRfc3RhdHVzKTsKLQorc3RhdGljIHUzMgorbWVnYXNhc19yZWFkX2Z3X3N0YXR1c19yZWdfZ2Vu
MihzdHJ1Y3QgbWVnYXNhc19yZWdpc3Rlcl9zZXQgX19pb21lbSAqcmVncyk7CitzdGF0aWMgaW50
CittZWdhc2FzX2FkcF9yZXNldF9nZW4yKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5j
ZSwKKwkJICAgICAgIHN0cnVjdCBtZWdhc2FzX3JlZ2lzdGVyX3NldCBfX2lvbWVtICpyZWdfc2V0
KTsKIHN0YXRpYyBpcnFyZXR1cm5fdCBtZWdhc2FzX2lzcihpbnQgaXJxLCB2b2lkICpkZXZwKTsK
IHN0YXRpYyB1MzIKIG1lZ2FzYXNfaW5pdF9hZGFwdGVyX21maShzdHJ1Y3QgbWVnYXNhc19pbnN0
YW5jZSAqaW5zdGFuY2UpOwpAQCAtNTU1LDYgKzU1OSw4IEBACiBtZWdhc2FzX2NsZWFyX2ludHJf
c2tpbm55KHN0cnVjdCBtZWdhc2FzX3JlZ2lzdGVyX3NldCBfX2lvbWVtICpyZWdzKQogewogCXUz
MiBzdGF0dXM7CisJdTMyIG1maVN0YXR1cyA9IDA7CisKIAkvKgogCSAqIENoZWNrIGlmIGl0IGlz
IG91ciBpbnRlcnJ1cHQKIAkgKi8KQEAgLTU2NSw2ICs1NzEsMTUgQEAKIAl9CiAKIAkvKgorCSAq
IENoZWNrIGlmIGl0IGlzIG91ciBpbnRlcnJ1cHQKKwkgKi8KKwlpZiAoKG1lZ2FzYXNfcmVhZF9m
d19zdGF0dXNfcmVnX2dlbjIocmVncykgJiBNRklfU1RBVEVfTUFTSykgPT0KKwkgICAgTUZJX1NU
QVRFX0ZBVUxUKSB7CisJCW1maVN0YXR1cyA9IE1GSV9JTlRSX0ZMQUdfRklSTVdBUkVfU1RBVEVf
Q0hBTkdFOworCX0gZWxzZQorCQltZmlTdGF0dXMgPSBNRklfSU5UUl9GTEFHX1JFUExZX01FU1NB
R0U7CisKKwkvKgogCSAqIENsZWFyIHRoZSBpbnRlcnJ1cHQgYnkgd3JpdGluZyBiYWNrIHRoZSBz
YW1lIHZhbHVlCiAJICovCiAJd3JpdGVsKHN0YXR1cywgJnJlZ3MtPm91dGJvdW5kX2ludHJfc3Rh
dHVzKTsKQEAgLTU3NCw3ICs1ODksNyBAQAogCSovCiAJcmVhZGwoJnJlZ3MtPm91dGJvdW5kX2lu
dHJfc3RhdHVzKTsKIAotCXJldHVybiAxOworCXJldHVybiBtZmlTdGF0dXM7CiB9CiAKIC8qKgpA
QCAtNTk4LDE3ICs2MTMsNiBAQAogfQogCiAvKioKLSAqIG1lZ2FzYXNfYWRwX3Jlc2V0X3NraW5u
eSAtCUZvciBjb250cm9sbGVyIHJlc2V0Ci0gKiBAcmVnczoJCQkJTUZJIHJlZ2lzdGVyIHNldAot
ICovCi1zdGF0aWMgaW50Ci1tZWdhc2FzX2FkcF9yZXNldF9za2lubnkoc3RydWN0IG1lZ2FzYXNf
aW5zdGFuY2UgKmluc3RhbmNlLAotCQkJc3RydWN0IG1lZ2FzYXNfcmVnaXN0ZXJfc2V0IF9faW9t
ZW0gKnJlZ3MpCi17Ci0JcmV0dXJuIDA7Ci19Ci0KLS8qKgogICogbWVnYXNhc19jaGVja19yZXNl
dF9za2lubnkgLQlGb3IgY29udHJvbGxlciByZXNldCBjaGVjawogICogQHJlZ3M6CQkJCU1GSSBy
ZWdpc3RlciBzZXQKICAqLwpAQCAtNjI2LDcgKzYzMCw3IEBACiAJLmRpc2FibGVfaW50ciA9IG1l
Z2FzYXNfZGlzYWJsZV9pbnRyX3NraW5ueSwKIAkuY2xlYXJfaW50ciA9IG1lZ2FzYXNfY2xlYXJf
aW50cl9za2lubnksCiAJLnJlYWRfZndfc3RhdHVzX3JlZyA9IG1lZ2FzYXNfcmVhZF9md19zdGF0
dXNfcmVnX3NraW5ueSwKLQkuYWRwX3Jlc2V0ID0gbWVnYXNhc19hZHBfcmVzZXRfc2tpbm55LAor
CS5hZHBfcmVzZXQgPSBtZWdhc2FzX2FkcF9yZXNldF9nZW4yLAogCS5jaGVja19yZXNldCA9IG1l
Z2FzYXNfY2hlY2tfcmVzZXRfc2tpbm55LAogCS5zZXJ2aWNlX2lzciA9IG1lZ2FzYXNfaXNyLAog
CS50YXNrbGV0ID0gbWVnYXNhc19jb21wbGV0ZV9jbWRfZHBjLApAQCAtNzQxLDIwICs3NDUsMjgg
QEAKIHsKIAl1MzIJCQlyZXRyeSA9IDAgOwogCXUzMgkJCUhvc3REaWFnOworCXUzMgkJCSpzZXFf
b2Zmc2V0ID0gJnJlZ19zZXQtPnNlcV9vZmZzZXQ7CisJdTMyCQkJKmhvc3RkaWFnX29mZnNldCA9
ICZyZWdfc2V0LT5ob3N0X2RpYWc7CisKKwlpZiAoaW5zdGFuY2UtPmluc3RhbmNldCA9PSAmbWVn
YXNhc19pbnN0YW5jZV90ZW1wbGF0ZV9za2lubnkpIHsKKwkJc2VxX29mZnNldCA9ICZyZWdfc2V0
LT5mdXNpb25fc2VxX29mZnNldDsKKwkJaG9zdGRpYWdfb2Zmc2V0ID0gJnJlZ19zZXQtPmZ1c2lv
bl9ob3N0X2RpYWc7CisJfQorCisJd3JpdGVsKDAsIHNlcV9vZmZzZXQpOworCXdyaXRlbCg0LCBz
ZXFfb2Zmc2V0KTsKKwl3cml0ZWwoMHhiLCBzZXFfb2Zmc2V0KTsKKwl3cml0ZWwoMiwgc2VxX29m
ZnNldCk7CisJd3JpdGVsKDcsIHNlcV9vZmZzZXQpOworCXdyaXRlbCgweGQsIHNlcV9vZmZzZXQp
OwogCi0Jd3JpdGVsKDAsICZyZWdfc2V0LT5zZXFfb2Zmc2V0KTsKLQl3cml0ZWwoNCwgJnJlZ19z
ZXQtPnNlcV9vZmZzZXQpOwotCXdyaXRlbCgweGIsICZyZWdfc2V0LT5zZXFfb2Zmc2V0KTsKLQl3
cml0ZWwoMiwgJnJlZ19zZXQtPnNlcV9vZmZzZXQpOwotCXdyaXRlbCg3LCAmcmVnX3NldC0+c2Vx
X29mZnNldCk7Ci0Jd3JpdGVsKDB4ZCwgJnJlZ19zZXQtPnNlcV9vZmZzZXQpOwogCW1zbGVlcCgx
MDAwKTsKIAotCUhvc3REaWFnID0gKHUzMilyZWFkbCgmcmVnX3NldC0+aG9zdF9kaWFnKTsKKwlI
b3N0RGlhZyA9ICh1MzIpcmVhZGwoaG9zdGRpYWdfb2Zmc2V0KTsKIAogCXdoaWxlICggISggSG9z
dERpYWcgJiBESUFHX1dSSVRFX0VOQUJMRSkgKSB7CiAJCW1zbGVlcCgxMDApOwotCQlIb3N0RGlh
ZyA9ICh1MzIpcmVhZGwoJnJlZ19zZXQtPmhvc3RfZGlhZyk7CisJCUhvc3REaWFnID0gKHUzMily
ZWFkbChob3N0ZGlhZ19vZmZzZXQpOwogCQlwcmludGsoS0VSTl9OT1RJQ0UgIlJFU0VUR0VOMjog
cmV0cnk9JXgsIGhvc3RkaWFnPSV4XG4iLAogCQkJCQlyZXRyeSwgSG9zdERpYWcpOwogCkBAIC03
NjUsMTQgKzc3NywxNCBAQAogCiAJcHJpbnRrKEtFUk5fTk9USUNFICJBRFBfUkVTRVRfR0VOMjog
SG9zdERpYWc9JXhcbiIsIEhvc3REaWFnKTsKIAotCXdyaXRlbCgoSG9zdERpYWcgfCBESUFHX1JF
U0VUX0FEQVBURVIpLCAmcmVnX3NldC0+aG9zdF9kaWFnKTsKKwl3cml0ZWwoKEhvc3REaWFnIHwg
RElBR19SRVNFVF9BREFQVEVSKSwgaG9zdGRpYWdfb2Zmc2V0KTsKIAogCXNzbGVlcCgxMCk7CiAK
LQlIb3N0RGlhZyA9ICh1MzIpcmVhZGwoJnJlZ19zZXQtPmhvc3RfZGlhZyk7CisJSG9zdERpYWcg
PSAodTMyKXJlYWRsKGhvc3RkaWFnX29mZnNldCk7CiAJd2hpbGUgKCAoIEhvc3REaWFnICYgRElB
R19SRVNFVF9BREFQVEVSKSApIHsKIAkJbXNsZWVwKDEwMCk7Ci0JCUhvc3REaWFnID0gKHUzMily
ZWFkbCgmcmVnX3NldC0+aG9zdF9kaWFnKTsKKwkJSG9zdERpYWcgPSAodTMyKXJlYWRsKGhvc3Rk
aWFnX29mZnNldCk7CiAJCXByaW50ayhLRVJOX05PVElDRSAiUkVTRVRfR0VOMjogcmV0cnk9JXgs
IGhvc3RkaWFnPSV4XG4iLAogCQkJCXJldHJ5LCBIb3N0RGlhZyk7CiAK
--0016e64c0b8cb19128049cad6e33--
