From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 7/9] mpt2sas: Timeout occurred within the HANDSHAKE logic while waiting on firmware to ACK.
Date: Mon, 14 Sep 2009 11:06:21 +0530
Message-ID: <20090914053610.GI31450@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og119.obsmtp.com ([64.18.2.16]:48550 "EHLO
	exprod7og119.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbZINF7M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2009 01:59:12 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Following a diag_reset, a request to send an ioc_init is timing out.  The
timeout occurred within the HANDSHAKE logic while waiting on firmware to
acknowledge that the driver had wrote to the doorbell register.  This was
root caused to a logic timeout in the firmware code.  The proposed solution
is for the driver to call the udelay instead of msleep API in function where
its looping reading the interrupt status.  In addition to this change, there
were two additional cases where we deleted the clearing interrupt status
outside handshake context.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index f679bff..670241e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -715,7 +715,6 @@ _base_unmask_interrupts(struct MPT2SAS_ADAPTER *ioc)
 {
 	u32 him_register;
 
-	writel(0, &ioc->chip->HostInterruptStatus);
 	him_register = readl(&ioc->chip->HostInterruptMask);
 	him_register &= ~MPI2_HIM_RIM;
 	writel(him_register, &ioc->chip->HostInterruptMask);
@@ -2463,7 +2462,7 @@ _base_handshake_req_reply_wait(struct MPT2SAS_ADAPTER *ioc, int request_bytes,
 	    ((request_bytes/4)<<MPI2_DOORBELL_ADD_DWORDS_SHIFT)),
 	    &ioc->chip->Doorbell);
 
-	if ((_base_wait_for_doorbell_int(ioc, 5, sleep_flag))) {
+	if ((_base_wait_for_doorbell_int(ioc, 5, NO_SLEEP))) {
 		printk(MPT2SAS_ERR_FMT "doorbell handshake "
 		   "int failed (line=%d)\n", ioc->name, __LINE__);
 		return -EFAULT;
@@ -3169,7 +3168,6 @@ _base_diag_reset(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 
 	drsprintk(ioc, printk(MPT2SAS_DEBUG_FMT "clear interrupts\n",
 	    ioc->name));
-	writel(0, &ioc->chip->HostInterruptStatus);
 
 	count = 0;
 	do {
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
