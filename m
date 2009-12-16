From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 4/10] mpt2sas: Set ioc->fwfault_debug to the cmd line option mpt2sas_fwfault_debug.
Date: Wed, 16 Dec 2009 18:52:39 +0530
Message-ID: <20091216132231.GE31161@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:44407 "HELO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756833AbZLPNuB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Dec 2009 08:50:01 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


(1) change the formentioned string from logging_level to fwfault_debug
(2) set ioc->fwfault_debug to the command line option mpt2sas_fwfault_debug
setting at driver load time.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Reviewed-by: Eric Moore <eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index bbd4f71..88e6eeb 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -107,8 +107,7 @@ _scsih_set_fwfault_debug(const char *val, struct kernel_param *kp)
 	if (ret)
 		return ret;
 
-	printk(KERN_INFO "setting logging_level(0x%08x)\n",
-				mpt2sas_fwfault_debug);
+	printk(KERN_INFO "setting fwfault_debug(%d)\n", mpt2sas_fwfault_debug);
 	list_for_each_entry(ioc, &mpt2sas_ioc_list, list)
 		ioc->fwfault_debug = mpt2sas_fwfault_debug;
 	return 0;
@@ -3576,6 +3575,8 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 
 	init_waitqueue_head(&ioc->reset_wq);
 
+	ioc->fwfault_debug = mpt2sas_fwfault_debug;
+
 	/* base internal command bits */
 	mutex_init(&ioc->base_cmds.mutex);
 	ioc->base_cmds.reply = kzalloc(ioc->reply_sz, GFP_KERNEL);
