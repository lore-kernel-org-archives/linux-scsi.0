From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: [patch 5/6] drivers/scsi/mpt2sas/mpt2sas_base.c: fix mismatch
 in mpt2sas_base_hard_reset_handler() mutex lock-unlock
Date: Wed, 18 Jan 2012 12:29:55 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A60481F52E05@inbmail02.lsi.com>
References: <20120110234242.C2D6F1E0160@wpzn4.hot.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:43713 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752059Ab2ARHAJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jan 2012 02:00:09 -0500
In-Reply-To: <20120110234242.C2D6F1E0160@wpzn4.hot.corp.google.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "khoroshilov@ispras.ru" <khoroshilov@ispras.ru>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>

James, this patch is previously acknowledged by me. Please add this to the upstream.

Regards,
Nagalakshmi


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of akpm@linux-foundation.org
Sent: Wednesday, January 11, 2012 5:13 AM
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org; akpm@linux-foundation.org; khoroshilov@ispras.ru; Desai, Kashyap
Subject: [patch 5/6] drivers/scsi/mpt2sas/mpt2sas_base.c: fix mismatch in mpt2sas_base_hard_reset_handler() mutex lock-unlock

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
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
