From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 07/10] mpt2sas: Prevent access to freed memory from port enable process
Date: Tue, 4 Jan 2011 11:38:39 +0530
Message-ID: <20110104060830.GH5751@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:51759 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751529Ab1ADHEe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jan 2011 02:04:34 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Issue : Kernel Panic during Large Topology discovery
Fix:
There was a configuration page timing out during the initial port
enable at driver load time. The port enable would fail, and this would
result in the driver unloading itself, meanwhile the driver was accessing
freed memory in another context resulting in the panic.  The fix is to
prevent access to freed memory once the driver had issued the diag reset
which woke up the sleeping port enable process.  The routine
_base_reset_handler was reorganized so the last sleeping process woken up was
the port_enable.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 4f1f3f2..51d50a1 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3967,6 +3967,8 @@ mpt2sas_base_detach(struct MPT2SAS_ADAPTER *ioc)
 static void
 _base_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
 {
+	mpt2sas_scsih_reset_handler(ioc, reset_phase);
+	mpt2sas_ctl_reset_handler(ioc, reset_phase);
 	switch (reset_phase) {
 	case MPT2_IOC_PRE_RESET:
 		dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: "
@@ -3997,8 +3999,6 @@ _base_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
 		    "MPT2_IOC_DONE_RESET\n", ioc->name, __func__));
 		break;
 	}
-	mpt2sas_scsih_reset_handler(ioc, reset_phase);
-	mpt2sas_ctl_reset_handler(ioc, reset_phase);
 }
 
 /**
@@ -4052,6 +4052,7 @@ mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 {
 	int r;
 	unsigned long flags;
+	u8 pe_complete = ioc->wait_for_port_enable_to_complete;
 
 	dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: enter\n", ioc->name,
 	    __func__));
@@ -4094,6 +4095,14 @@ mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 	if (r)
 		goto out;
 	_base_reset_handler(ioc, MPT2_IOC_AFTER_RESET);
+
+	/* If this hard reset is called while port enable is active, then
+	 * there is no reason to call make_ioc_operational
+	 */
+	if (pe_complete) {
+		r = -EFAULT;
+		goto out;
+	}
 	r = _base_make_ioc_operational(ioc, sleep_flag);
 	if (!r)
 		_base_reset_handler(ioc, MPT2_IOC_DONE_RESET);
