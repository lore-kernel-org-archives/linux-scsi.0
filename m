From: akpm@linux-foundation.org
Subject: [patch 2/4] drivers/scsi/mpt2sas/mpt2sas_base.c: fix mismatch in mpt2sas_base_hard_reset_handler() mutex lock-unlock
Date: Wed, 08 Feb 2012 12:52:21 -0800
Message-ID: <20120208205222.18565A04F8@akpm.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:58672 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab2BHUwY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2012 15:52:24 -0500
Received: by eekb15 with SMTP id b15so33252eek.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2012 12:52:23 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, khoroshilov@ispras.ru, kashyap.desai@lsi.com

From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: drivers/scsi/mpt2sas/mpt2sas_base.c: fix mismatch in mpt2sas_base_hard_reset_handler() mutex lock-unlock

If ioc->pci_error_recovery is set, goto out in
mpt2sas_base_hard_reset_handler() leads to unlock unheld
ioc->reset_in_progress_mutex.

Fix the issue by jumping afer mutex_unlock() call.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/mpt2sas/mpt2sas_base.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/mpt2sas/mpt2sas_base.c~mpt2sas-fix-mismatch-in-mpt2sas_base_hard_reset_handler-mutex-lock-unlock drivers/scsi/mpt2sas/mpt2sas_base.c
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c~mpt2sas-fix-mismatch-in-mpt2sas_base_hard_reset_handler-mutex-lock-unlock
+++ a/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -4548,7 +4548,7 @@ mpt2sas_base_hard_reset_handler(struct M
 		printk(MPT2SAS_ERR_FMT "%s: pci error recovery reset\n",
 		    ioc->name, __func__);
 		r = 0;
-		goto out;
+		goto out_unlocked;
 	}
 
 	if (mpt2sas_fwfault_debug)
@@ -4604,6 +4604,7 @@ mpt2sas_base_hard_reset_handler(struct M
 	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 	mutex_unlock(&ioc->reset_in_progress_mutex);
 
+ out_unlocked:
 	dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: exit\n", ioc->name,
 	    __func__));
 	return r;
_
