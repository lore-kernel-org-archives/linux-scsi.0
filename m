From: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Subject: [PATCH] Some cosmetic changes to QlogicPTI SCSI driver
Date: Tue, 31 Jul 2007 20:10:45 +0100 (BST)
Message-ID: <Pine.LNX.4.61.0707311948370.5707@mtfhpc.demon.co.uk>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1750305931-985268402-1185909045=:5707"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from anchor-post-31.mail.demon.net ([194.217.242.89]:2441 "EHLO
	anchor-post-31.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755204AbXGaTKx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jul 2007 15:10:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: davem@davemloft.net, James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1750305931-985268402-1185909045=:5707
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

From: Mark Fortescue <mark@mtfhpc.demon.co.uk>

Change a printk sequencing issue where <6> ... was coming up in the middle
of a line when scsi_add_host was being called.
Reduce the length of some printk messages and make the messages
more consistant. All cosmetic but it makes it easier to read as it
scrolles off the screen during boot.

Signed-off-by: Mark Fortescue <mark@mtfhpc.demon.co.uk>
---
An alternative to changeing qpti%d to qlogicpti%d is the other way around:
qlogicpti%d to qpti%d. I chose qlogicpti as it maches the file name.

I must get an email client that does not mangle patches. Any 
recomendations ?

diff -ruNpd -x '.[a-z]*' linux-2.6/drivers/scsi/qlogicpti.c linux-test/drivers/scsi/qlogicpti.c
--- linux-2.6/drivers/scsi/qlogicpti.c	2007-07-28 17:12:27.000000000 +0100
+++ linux-test/drivers/scsi/qlogicpti.c	2007-07-31 19:38:25.000000000 +0100
@@ -193,7 +193,8 @@ static int qlogicpti_mbox_command(struct
  		cpu_relax();
  	}
  	if (!loop_count)
-		printk(KERN_EMERG "qlogicpti: mbox_command loop timeout #1\n");
+		printk(KERN_EMERG "qlogicpti%d: mbox_command loop timeout #1\n",
+		       qpti->qpti_id);

  	/* Write mailbox command registers. */
  	switch (mbox_param[param[0]] >> 4) {
@@ -224,8 +225,8 @@ static int qlogicpti_mbox_command(struct
  	       (sbus_readw(qpti->qregs + HCCTRL) & HCCTRL_CRIRQ))
  		udelay(20);
  	if (!loop_count)
-		printk(KERN_EMERG "qlogicpti: mbox_command[%04x] loop timeout #2\n",
-		       param[0]);
+		printk(KERN_EMERG "qlogicpti%d: mbox_command[%04x] loop timeout #2\n",
+		       qpti->qpti_id, param[0]);

  	/* Wait for SBUS semaphore to get set. */
  	loop_count = DEFAULT_LOOP_COUNT;
@@ -238,16 +239,16 @@ static int qlogicpti_mbox_command(struct
  			break;
  	}
  	if (!loop_count)
-		printk(KERN_EMERG "qlogicpti: mbox_command[%04x] loop timeout #3\n",
-		       param[0]);
+		printk(KERN_EMERG "qlogicpti%d: mbox_command[%04x] loop timeout #3\n",
+		       qpti->qpti_id, param[0]);

  	/* Wait for MBOX busy condition to go away. */
  	loop_count = DEFAULT_LOOP_COUNT;
  	while (--loop_count && (sbus_readw(qpti->qregs + MBOX0) == 0x04))
  		udelay(20);
  	if (!loop_count)
-		printk(KERN_EMERG "qlogicpti: mbox_command[%04x] loop timeout #4\n",
-		       param[0]);
+		printk(KERN_EMERG "qlogicpti%d: mbox_command[%04x] loop timeout #4\n",
+		       qpti->qpti_id, param[0]);

  	/* Read back output parameters. */
  	switch (mbox_param[param[0]] & 0xf) {
@@ -342,7 +343,8 @@ static int qlogicpti_reset_hardware(stru
  	while (--loop_count && ((sbus_readw(qpti->qregs + MBOX0) & 0xff) == 0x04))
  		udelay(20);
  	if (!loop_count)
-		printk(KERN_EMERG "qlogicpti: reset_hardware loop timeout\n");
+		printk(KERN_EMERG "qlogicpti%d: reset_hardware loop timeout\n",
+		       qpti->qpti_id);

  	sbus_writew(HCCTRL_PAUSE, qpti->qregs + HCCTRL);
  	set_sbus_cfg1(qpti);
@@ -721,12 +723,12 @@ static int __init qpti_register_irq(stru
  			IRQF_SHARED, "Qlogic/PTI", qpti))
  		goto fail;

-	printk("qpti%d: IRQ %d ", qpti->qpti_id, qpti->irq);
+	printk("qlogicpti%d: IRQ %d ", qpti->qpti_id, qpti->irq);

  	return 0;

  fail:
-	printk("qpti%d: Cannot acquire irq line\n", qpti->qpti_id);
+	printk("qlogicpti%d: Cannot acquire irq line\n", qpti->qpti_id);
  	return -1;
  }

@@ -1210,7 +1212,7 @@ static int qlogicpti_return_status(struc
  		host_status = DID_OK;
  		break;
  	      default:
-		printk(KERN_EMERG "qpti%d: unknown completion status 0x%04x\n",
+		printk(KERN_EMERG "qlogicpti%d: unknown completion status 0x%04x\n",
  		       id, sts->completion_status);
  		host_status = DID_ERROR;
  		break;
@@ -1329,8 +1331,8 @@ static int qlogicpti_abort(struct scsi_c
  	u32 cmd_cookie;
  	int i;

-	printk(KERN_WARNING "qlogicpti : Aborting cmd for tgt[%d] lun[%d]\n",
-	       (int)Cmnd->device->id, (int)Cmnd->device->lun);
+	printk(KERN_WARNING "qlogicpti%d: Aborting cmd for tgt[%d] lun[%d]\n",
+	       qpti->qpti_id, (int)Cmnd->device->id, (int)Cmnd->device->lun);

  	qlogicpti_disable_irqs(qpti);

@@ -1348,7 +1350,8 @@ static int qlogicpti_abort(struct scsi_c
  	param[3] = cmd_cookie & 0xffff;
  	if (qlogicpti_mbox_command(qpti, param, 0) ||
  	    (param[0] != MBOX_COMMAND_COMPLETE)) {
-		printk(KERN_EMERG "qlogicpti : scsi abort failure: %x\n", param[0]);
+		printk(KERN_EMERG "qlogicpti%d: scsi abort failure: %x\n",
+		       qpti->qpti_id, param[0]);
  		return_status = FAILED;
  	}

@@ -1364,7 +1367,8 @@ static int qlogicpti_reset(struct scsi_c
  	struct qlogicpti *qpti = (struct qlogicpti *) host->hostdata;
  	int return_status = SUCCESS;

-	printk(KERN_WARNING "qlogicpti : Resetting SCSI bus!\n");
+	printk(KERN_WARNING "qlogicpti%d: Resetting SCSI bus!\n",
+	       qpti->qpti_id);

  	qlogicpti_disable_irqs(qpti);

@@ -1372,7 +1376,8 @@ static int qlogicpti_reset(struct scsi_c
  	param[1] = qpti->host_param.bus_reset_delay;
  	if (qlogicpti_mbox_command(qpti, param, 0) ||
  	   (param[0] != MBOX_COMMAND_COMPLETE)) {
-		printk(KERN_EMERG "qlogicisp : scsi bus reset failure: %x\n", param[0]);
+		printk(KERN_EMERG "qlogicisp%d: scsi bus reset failure: %x\n",
+		       qpti->qpti_id, param[0]);
  		return_status = FAILED;
  	}

@@ -1454,22 +1459,25 @@ static int __devinit qpti_sbus_probe(str
  	if (qlogicpti_reset_hardware(host))
  		goto fail_unmap_queues;

-	if (scsi_add_host(host, &dev->dev))
-		goto fail_unmap_queues;
-
  	printk("(Firmware v%d.%d.%d)", qpti->fware_majrev,
  	       qpti->fware_minrev, qpti->fware_micrev);

  	fcode = of_get_property(dp, "isp-fcode", NULL);
  	if (fcode && fcode[0])
-		printk("(Firmware %s)", fcode);
+		printk("(FCode %s)", fcode);
  	if (of_find_property(dp, "differential", NULL) != NULL)
  		qpti->differential = 1;

-	printk (" [%s Wide, using %s interface]\n",
+	printk("\nqlogicpti%d: [%s Wide, using %s interface]\n",
+		qpti->qpti_id,
  		(qpti->ultra ? "Ultra" : "Fast"),
  		(qpti->differential ? "differential" : "single ended"));

+	if (scsi_add_host(host, &dev->dev)) {
+		printk("qlogicpti%d: Failed scsi_add_host\n", qpti->qpti_id);
+		goto fail_unmap_queues;
+	}
+
  	dev_set_drvdata(&sdev->ofdev.dev, qpti);

  	qpti_chain_add(qpti);
--1750305931-985268402-1185909045=:5707
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="qlogicpti.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.61.0707312010430.5707@mtfhpc.demon.co.uk>
Content-Description: 
Content-Disposition: attachment; filename="qlogicpti.patch"

RnJvbTogTWFyayBGb3J0ZXNjdWUgPG1hcmtAbXRmaHBjLmRlbW9uLmNvLnVr
Pg0KDQpDaGFuZ2UgYSBwcmludGsgc2VxdWVuY2luZyBpc3N1ZSB3aGVyZSA8
Nj4gLi4uIHdhcyBjb21pbmcgdXAgaW4gdGhlIG1pZGRsZQ0Kb2YgYSBsaW5l
IHdoZW4gc2NzaV9hZGRfaG9zdCB3YXMgYmVpbmcgY2FsbGVkLg0KUmVkdWNl
IHRoZSBsZW5ndGggb2Ygc29tZSBwcmludGsgbWVzc2FnZXMgYW5kIG1ha2Ug
dGhlIG1lc3NhZ2VzDQptb3JlIGNvbnNpc3RhbnQuIEFsbCBjb3NtZXRpYyBi
dXQgaXQgbWFrZXMgaXQgZWFzaWVyIHRvIHJlYWQgYXMgaXQNCnNjcm9sbGVz
IG9mZiB0aGUgc2NyZWVuIGR1cmluZyBib290Lg0KDQpTaWduZWQtb2ZmLWJ5
OiBNYXJrIEZvcnRlc2N1ZSA8bWFya0BtdGZocGMuZGVtb24uY28udWs+DQot
LS0NCmRpZmYgLXJ1TnBkIC14ICcuW2Etel0qJyBsaW51eC0yLjYvZHJpdmVy
cy9zY3NpL3Fsb2dpY3B0aS5jIGxpbnV4LXRlc3QvZHJpdmVycy9zY3NpL3Fs
b2dpY3B0aS5jDQotLS0gbGludXgtMi42L2RyaXZlcnMvc2NzaS9xbG9naWNw
dGkuYwkyMDA3LTA3LTI4IDE3OjEyOjI3LjAwMDAwMDAwMCArMDEwMA0KKysr
IGxpbnV4LXRlc3QvZHJpdmVycy9zY3NpL3Fsb2dpY3B0aS5jCTIwMDctMDct
MzEgMTk6Mzg6MjUuMDAwMDAwMDAwICswMTAwDQpAQCAtMTkzLDcgKzE5Myw4
IEBAIHN0YXRpYyBpbnQgcWxvZ2ljcHRpX21ib3hfY29tbWFuZChzdHJ1Y3QN
CiAJCWNwdV9yZWxheCgpOw0KIAl9DQogCWlmICghbG9vcF9jb3VudCkNCi0J
CXByaW50ayhLRVJOX0VNRVJHICJxbG9naWNwdGk6IG1ib3hfY29tbWFuZCBs
b29wIHRpbWVvdXQgIzFcbiIpOw0KKwkJcHJpbnRrKEtFUk5fRU1FUkcgInFs
b2dpY3B0aSVkOiBtYm94X2NvbW1hbmQgbG9vcCB0aW1lb3V0ICMxXG4iLA0K
KwkJICAgICAgIHFwdGktPnFwdGlfaWQpOw0KIA0KIAkvKiBXcml0ZSBtYWls
Ym94IGNvbW1hbmQgcmVnaXN0ZXJzLiAqLw0KIAlzd2l0Y2ggKG1ib3hfcGFy
YW1bcGFyYW1bMF1dID4+IDQpIHsNCkBAIC0yMjQsOCArMjI1LDggQEAgc3Rh
dGljIGludCBxbG9naWNwdGlfbWJveF9jb21tYW5kKHN0cnVjdA0KIAkgICAg
ICAgKHNidXNfcmVhZHcocXB0aS0+cXJlZ3MgKyBIQ0NUUkwpICYgSENDVFJM
X0NSSVJRKSkNCiAJCXVkZWxheSgyMCk7DQogCWlmICghbG9vcF9jb3VudCkN
Ci0JCXByaW50ayhLRVJOX0VNRVJHICJxbG9naWNwdGk6IG1ib3hfY29tbWFu
ZFslMDR4XSBsb29wIHRpbWVvdXQgIzJcbiIsDQotCQkgICAgICAgcGFyYW1b
MF0pOw0KKwkJcHJpbnRrKEtFUk5fRU1FUkcgInFsb2dpY3B0aSVkOiBtYm94
X2NvbW1hbmRbJTA0eF0gbG9vcCB0aW1lb3V0ICMyXG4iLA0KKwkJICAgICAg
IHFwdGktPnFwdGlfaWQsIHBhcmFtWzBdKTsNCiANCiAJLyogV2FpdCBmb3Ig
U0JVUyBzZW1hcGhvcmUgdG8gZ2V0IHNldC4gKi8NCiAJbG9vcF9jb3VudCA9
IERFRkFVTFRfTE9PUF9DT1VOVDsNCkBAIC0yMzgsMTYgKzIzOSwxNiBAQCBz
dGF0aWMgaW50IHFsb2dpY3B0aV9tYm94X2NvbW1hbmQoc3RydWN0DQogCQkJ
YnJlYWs7DQogCX0NCiAJaWYgKCFsb29wX2NvdW50KQ0KLQkJcHJpbnRrKEtF
Uk5fRU1FUkcgInFsb2dpY3B0aTogbWJveF9jb21tYW5kWyUwNHhdIGxvb3Ag
dGltZW91dCAjM1xuIiwNCi0JCSAgICAgICBwYXJhbVswXSk7DQorCQlwcmlu
dGsoS0VSTl9FTUVSRyAicWxvZ2ljcHRpJWQ6IG1ib3hfY29tbWFuZFslMDR4
XSBsb29wIHRpbWVvdXQgIzNcbiIsDQorCQkgICAgICAgcXB0aS0+cXB0aV9p
ZCwgcGFyYW1bMF0pOw0KIA0KIAkvKiBXYWl0IGZvciBNQk9YIGJ1c3kgY29u
ZGl0aW9uIHRvIGdvIGF3YXkuICovDQogCWxvb3BfY291bnQgPSBERUZBVUxU
X0xPT1BfQ09VTlQ7DQogCXdoaWxlICgtLWxvb3BfY291bnQgJiYgKHNidXNf
cmVhZHcocXB0aS0+cXJlZ3MgKyBNQk9YMCkgPT0gMHgwNCkpDQogCQl1ZGVs
YXkoMjApOw0KIAlpZiAoIWxvb3BfY291bnQpDQotCQlwcmludGsoS0VSTl9F
TUVSRyAicWxvZ2ljcHRpOiBtYm94X2NvbW1hbmRbJTA0eF0gbG9vcCB0aW1l
b3V0ICM0XG4iLA0KLQkJICAgICAgIHBhcmFtWzBdKTsNCisJCXByaW50ayhL
RVJOX0VNRVJHICJxbG9naWNwdGklZDogbWJveF9jb21tYW5kWyUwNHhdIGxv
b3AgdGltZW91dCAjNFxuIiwNCisJCSAgICAgICBxcHRpLT5xcHRpX2lkLCBw
YXJhbVswXSk7DQogDQogCS8qIFJlYWQgYmFjayBvdXRwdXQgcGFyYW1ldGVy
cy4gKi8NCiAJc3dpdGNoIChtYm94X3BhcmFtW3BhcmFtWzBdXSAmIDB4Zikg
ew0KQEAgLTM0Miw3ICszNDMsOCBAQCBzdGF0aWMgaW50IHFsb2dpY3B0aV9y
ZXNldF9oYXJkd2FyZShzdHJ1DQogCXdoaWxlICgtLWxvb3BfY291bnQgJiYg
KChzYnVzX3JlYWR3KHFwdGktPnFyZWdzICsgTUJPWDApICYgMHhmZikgPT0g
MHgwNCkpDQogCQl1ZGVsYXkoMjApOw0KIAlpZiAoIWxvb3BfY291bnQpDQot
CQlwcmludGsoS0VSTl9FTUVSRyAicWxvZ2ljcHRpOiByZXNldF9oYXJkd2Fy
ZSBsb29wIHRpbWVvdXRcbiIpOw0KKwkJcHJpbnRrKEtFUk5fRU1FUkcgInFs
b2dpY3B0aSVkOiByZXNldF9oYXJkd2FyZSBsb29wIHRpbWVvdXRcbiIsDQor
CQkgICAgICAgcXB0aS0+cXB0aV9pZCk7DQogDQogCXNidXNfd3JpdGV3KEhD
Q1RSTF9QQVVTRSwgcXB0aS0+cXJlZ3MgKyBIQ0NUUkwpOw0KIAlzZXRfc2J1
c19jZmcxKHFwdGkpOw0KQEAgLTcyMSwxMiArNzIzLDEyIEBAIHN0YXRpYyBp
bnQgX19pbml0IHFwdGlfcmVnaXN0ZXJfaXJxKHN0cnUNCiAJCQlJUlFGX1NI
QVJFRCwgIlFsb2dpYy9QVEkiLCBxcHRpKSkNCiAJCWdvdG8gZmFpbDsNCiAN
Ci0JcHJpbnRrKCJxcHRpJWQ6IElSUSAlZCAiLCBxcHRpLT5xcHRpX2lkLCBx
cHRpLT5pcnEpOw0KKwlwcmludGsoInFsb2dpY3B0aSVkOiBJUlEgJWQgIiwg
cXB0aS0+cXB0aV9pZCwgcXB0aS0+aXJxKTsNCiANCiAJcmV0dXJuIDA7DQog
DQogZmFpbDoNCi0JcHJpbnRrKCJxcHRpJWQ6IENhbm5vdCBhY3F1aXJlIGly
cSBsaW5lXG4iLCBxcHRpLT5xcHRpX2lkKTsNCisJcHJpbnRrKCJxbG9naWNw
dGklZDogQ2Fubm90IGFjcXVpcmUgaXJxIGxpbmVcbiIsIHFwdGktPnFwdGlf
aWQpOw0KIAlyZXR1cm4gLTE7DQogfQ0KIA0KQEAgLTEyMTAsNyArMTIxMiw3
IEBAIHN0YXRpYyBpbnQgcWxvZ2ljcHRpX3JldHVybl9zdGF0dXMoc3RydWMN
CiAJCWhvc3Rfc3RhdHVzID0gRElEX09LOw0KIAkJYnJlYWs7DQogCSAgICAg
IGRlZmF1bHQ6DQotCQlwcmludGsoS0VSTl9FTUVSRyAicXB0aSVkOiB1bmtu
b3duIGNvbXBsZXRpb24gc3RhdHVzIDB4JTA0eFxuIiwNCisJCXByaW50ayhL
RVJOX0VNRVJHICJxbG9naWNwdGklZDogdW5rbm93biBjb21wbGV0aW9uIHN0
YXR1cyAweCUwNHhcbiIsDQogCQkgICAgICAgaWQsIHN0cy0+Y29tcGxldGlv
bl9zdGF0dXMpOw0KIAkJaG9zdF9zdGF0dXMgPSBESURfRVJST1I7DQogCQli
cmVhazsNCkBAIC0xMzI5LDggKzEzMzEsOCBAQCBzdGF0aWMgaW50IHFsb2dp
Y3B0aV9hYm9ydChzdHJ1Y3Qgc2NzaV9jDQogCXUzMiBjbWRfY29va2llOw0K
IAlpbnQgaTsNCiANCi0JcHJpbnRrKEtFUk5fV0FSTklORyAicWxvZ2ljcHRp
IDogQWJvcnRpbmcgY21kIGZvciB0Z3RbJWRdIGx1blslZF1cbiIsDQotCSAg
ICAgICAoaW50KUNtbmQtPmRldmljZS0+aWQsIChpbnQpQ21uZC0+ZGV2aWNl
LT5sdW4pOw0KKwlwcmludGsoS0VSTl9XQVJOSU5HICJxbG9naWNwdGklZDog
QWJvcnRpbmcgY21kIGZvciB0Z3RbJWRdIGx1blslZF1cbiIsDQorCSAgICAg
ICBxcHRpLT5xcHRpX2lkLCAoaW50KUNtbmQtPmRldmljZS0+aWQsIChpbnQp
Q21uZC0+ZGV2aWNlLT5sdW4pOw0KIA0KIAlxbG9naWNwdGlfZGlzYWJsZV9p
cnFzKHFwdGkpOw0KIA0KQEAgLTEzNDgsNyArMTM1MCw4IEBAIHN0YXRpYyBp
bnQgcWxvZ2ljcHRpX2Fib3J0KHN0cnVjdCBzY3NpX2MNCiAJcGFyYW1bM10g
PSBjbWRfY29va2llICYgMHhmZmZmOw0KIAlpZiAocWxvZ2ljcHRpX21ib3hf
Y29tbWFuZChxcHRpLCBwYXJhbSwgMCkgfHwNCiAJICAgIChwYXJhbVswXSAh
PSBNQk9YX0NPTU1BTkRfQ09NUExFVEUpKSB7DQotCQlwcmludGsoS0VSTl9F
TUVSRyAicWxvZ2ljcHRpIDogc2NzaSBhYm9ydCBmYWlsdXJlOiAleFxuIiwg
cGFyYW1bMF0pOw0KKwkJcHJpbnRrKEtFUk5fRU1FUkcgInFsb2dpY3B0aSVk
OiBzY3NpIGFib3J0IGZhaWx1cmU6ICV4XG4iLA0KKwkJICAgICAgIHFwdGkt
PnFwdGlfaWQsIHBhcmFtWzBdKTsNCiAJCXJldHVybl9zdGF0dXMgPSBGQUlM
RUQ7DQogCX0NCiANCkBAIC0xMzY0LDcgKzEzNjcsOCBAQCBzdGF0aWMgaW50
IHFsb2dpY3B0aV9yZXNldChzdHJ1Y3Qgc2NzaV9jDQogCXN0cnVjdCBxbG9n
aWNwdGkgKnFwdGkgPSAoc3RydWN0IHFsb2dpY3B0aSAqKSBob3N0LT5ob3N0
ZGF0YTsNCiAJaW50IHJldHVybl9zdGF0dXMgPSBTVUNDRVNTOw0KIA0KLQlw
cmludGsoS0VSTl9XQVJOSU5HICJxbG9naWNwdGkgOiBSZXNldHRpbmcgU0NT
SSBidXMhXG4iKTsNCisJcHJpbnRrKEtFUk5fV0FSTklORyAicWxvZ2ljcHRp
JWQ6IFJlc2V0dGluZyBTQ1NJIGJ1cyFcbiIsDQorCSAgICAgICBxcHRpLT5x
cHRpX2lkKTsNCiANCiAJcWxvZ2ljcHRpX2Rpc2FibGVfaXJxcyhxcHRpKTsN
CiANCkBAIC0xMzcyLDcgKzEzNzYsOCBAQCBzdGF0aWMgaW50IHFsb2dpY3B0
aV9yZXNldChzdHJ1Y3Qgc2NzaV9jDQogCXBhcmFtWzFdID0gcXB0aS0+aG9z
dF9wYXJhbS5idXNfcmVzZXRfZGVsYXk7DQogCWlmIChxbG9naWNwdGlfbWJv
eF9jb21tYW5kKHFwdGksIHBhcmFtLCAwKSB8fA0KIAkgICAocGFyYW1bMF0g
IT0gTUJPWF9DT01NQU5EX0NPTVBMRVRFKSkgew0KLQkJcHJpbnRrKEtFUk5f
RU1FUkcgInFsb2dpY2lzcCA6IHNjc2kgYnVzIHJlc2V0IGZhaWx1cmU6ICV4
XG4iLCBwYXJhbVswXSk7DQorCQlwcmludGsoS0VSTl9FTUVSRyAicWxvZ2lj
aXNwJWQ6IHNjc2kgYnVzIHJlc2V0IGZhaWx1cmU6ICV4XG4iLA0KKwkJICAg
ICAgIHFwdGktPnFwdGlfaWQsIHBhcmFtWzBdKTsNCiAJCXJldHVybl9zdGF0
dXMgPSBGQUlMRUQ7DQogCX0NCiANCkBAIC0xNDU0LDIyICsxNDU5LDI1IEBA
IHN0YXRpYyBpbnQgX19kZXZpbml0IHFwdGlfc2J1c19wcm9iZShzdHINCiAJ
aWYgKHFsb2dpY3B0aV9yZXNldF9oYXJkd2FyZShob3N0KSkNCiAJCWdvdG8g
ZmFpbF91bm1hcF9xdWV1ZXM7DQogDQotCWlmIChzY3NpX2FkZF9ob3N0KGhv
c3QsICZkZXYtPmRldikpDQotCQlnb3RvIGZhaWxfdW5tYXBfcXVldWVzOw0K
LQ0KIAlwcmludGsoIihGaXJtd2FyZSB2JWQuJWQuJWQpIiwgcXB0aS0+Zndh
cmVfbWFqcmV2LA0KIAkgICAgICAgcXB0aS0+ZndhcmVfbWlucmV2LCBxcHRp
LT5md2FyZV9taWNyZXYpOw0KIA0KIAlmY29kZSA9IG9mX2dldF9wcm9wZXJ0
eShkcCwgImlzcC1mY29kZSIsIE5VTEwpOw0KIAlpZiAoZmNvZGUgJiYgZmNv
ZGVbMF0pDQotCQlwcmludGsoIihGaXJtd2FyZSAlcykiLCBmY29kZSk7DQor
CQlwcmludGsoIihGQ29kZSAlcykiLCBmY29kZSk7DQogCWlmIChvZl9maW5k
X3Byb3BlcnR5KGRwLCAiZGlmZmVyZW50aWFsIiwgTlVMTCkgIT0gTlVMTCkN
CiAJCXFwdGktPmRpZmZlcmVudGlhbCA9IDE7DQogCQkJDQotCXByaW50ayAo
IiBbJXMgV2lkZSwgdXNpbmcgJXMgaW50ZXJmYWNlXVxuIiwNCisJcHJpbnRr
KCJcbnFsb2dpY3B0aSVkOiBbJXMgV2lkZSwgdXNpbmcgJXMgaW50ZXJmYWNl
XVxuIiwNCisJCXFwdGktPnFwdGlfaWQsDQogCQkocXB0aS0+dWx0cmEgPyAi
VWx0cmEiIDogIkZhc3QiKSwNCiAJCShxcHRpLT5kaWZmZXJlbnRpYWwgPyAi
ZGlmZmVyZW50aWFsIiA6ICJzaW5nbGUgZW5kZWQiKSk7DQogDQorCWlmIChz
Y3NpX2FkZF9ob3N0KGhvc3QsICZkZXYtPmRldikpIHsNCisJCXByaW50aygi
cWxvZ2ljcHRpJWQ6IEZhaWxlZCBzY3NpX2FkZF9ob3N0XG4iLCBxcHRpLT5x
cHRpX2lkKTsNCisJCWdvdG8gZmFpbF91bm1hcF9xdWV1ZXM7DQorCX0NCisN
CiAJZGV2X3NldF9kcnZkYXRhKCZzZGV2LT5vZmRldi5kZXYsIHFwdGkpOw0K
IA0KIAlxcHRpX2NoYWluX2FkZChxcHRpKTsNCg==

--1750305931-985268402-1185909045=:5707--
