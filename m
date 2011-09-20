From: akpm@google.com
Subject: [patch 7/8] drivers/scsi/mpt2sas/mpt2sas_base.c: fix mismatch in mpt2sas_base_hard_reset_handler() mutex lock-unlock
Date: Tue, 20 Sep 2011 14:20:23 -0700
Message-ID: <201109202120.p8KLKOxM001329@wpaz13.hot.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:3032 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab1ITVUv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Sep 2011 17:20:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@google.com, khoroshilov@ispras.ru, kashyap.desai@lsi.com

From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: drivers/scsi/mpt2sas/mpt2sas_base.c: fix mismatch in mpt2sas_base_hard_reset_handler() mutex lock-unlock

If ioc->pci_error_recovery is set, goto out in
mpt2sas_base_hard_reset_handler() leads to unlock unheld
ioc->reset_in_progress_mutex.

Fix the issue by jumping afer mutex_unlock() call.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/scsi/mpt2sas/mpt2sas_base.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/mpt2sas/mpt2sas_base.c~mpt2sas-fix-mismatch-in-mpt2sas_base_hard_reset_handler-mutex-lock-unlock drivers/scsi/mpt2sas/mpt2sas_base.c
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c~mpt2sas-fix-mismatch-in-mpt2sas_base_hard_reset_handler-mutex-lock-unlock
+++ a/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -4129,7 +4129,7 @@ mpt2sas_base_hard_reset_handler(struct M
 		printk(MPT2SAS_ERR_FMT "%s: pci error recovery reset\n",
 		    ioc->name, __func__);
 		r = 0;
-		goto out;
+		goto out_unlocked;
 	}
 
 	if (mpt2sas_fwfault_debug)
@@ -4185,6 +4185,7 @@ mpt2sas_base_hard_reset_handler(struct M
 	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 	mutex_unlock(&ioc->reset_in_progress_mutex);
 
+ out_unlocked:
 	dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: exit\n", ioc->name,
 	    __func__));
 	return r;
_
