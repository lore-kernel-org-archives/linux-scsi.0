From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: [PATCH] [SCSI] mpt2sas: Fix mismatch in
 mpt2sas_base_hard_reset_handler() mutex lock-unlock
Date: Tue, 30 Aug 2011 16:14:35 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A6042AD54393@inbmail02.lsi.com>
References: <1314304583-19856-1-git-send-email-khoroshilov@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1314304583-19856-1-git-send-email-khoroshilov@ispras.ru>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Khoroshilov <khoroshilov@ispras.ru>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ldv-project@ispras.ru" <ldv-project@ispras.ru>
List-Id: linux-scsi@vger.kernel.org

The patch seem to be fine. Please consider this patch as Acked-by: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>


Regards,
Nagalakshmi


-----Original Message-----
From: Alexey Khoroshilov [mailto:khoroshilov@ispras.ru] 
Sent: Friday, August 26, 2011 2:06 AM
To: Desai, Kashyap
Cc: Alexey Khoroshilov; DL-MPT Fusion Linux; James E.J. Bottomley; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; ldv-project@ispras.ru
Subject: [PATCH] [SCSI] mpt2sas: Fix mismatch in mpt2sas_base_hard_reset_handler() mutex lock-unlock

If ioc->pci_error_recovery is set, goto out in mpt2sas_base_hard_reset_handler()
leads to unlock unheld ioc->reset_in_progress_mutex.

The patch fixes the issue by jumping afer mutex_unlock() call.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 83035bd..906c63a 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -4130,7 +4130,7 @@ mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 		printk(MPT2SAS_ERR_FMT "%s: pci error recovery reset\n",
 		    ioc->name, __func__);
 		r = 0;
-		goto out;
+		goto out_unlocked;
 	}
 
 	if (mpt2sas_fwfault_debug)
@@ -4186,6 +4186,7 @@ mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 	mutex_unlock(&ioc->reset_in_progress_mutex);
 
+ out_unlocked:
 	dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: exit\n", ioc->name,
 	    __func__));
 	return r;
-- 
1.7.4.1
