From: Suganath prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 1/1] mpt3sas: Fix - Remove cpumask_clear for zalloc_cpumask_var and dont free free_cpu_mask_var before reply_q
Date: Thu, 11 Feb 2016 15:02:55 +0530
Message-ID: <1455183175-7741-1-git-send-email-suganath-prabu.subramani@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

From: Suganath prabu Subramani <suganath-prabu.subramani@broadcom.com>

Removed cpumask_clear as it is not required for zalloc_cpumask_var and
free free_cpumask_var before freeing reply_q.

Signed-off-by: Suganath prabu Subramani <suganath-prabu.subramani@broadcom.com>
Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index c0a9d97..afdb13a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1855,7 +1855,6 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index, u32 vector)
 			kfree(reply_q);
 			return -ENOMEM;
 		}
-		cpumask_clear(reply_q->affinity_hint);
 	}
 
 	atomic_set(&reply_q->busy, 0);
@@ -1870,8 +1869,8 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index, u32 vector)
 	if (r) {
 		pr_err(MPT3SAS_FMT "unable to allocate interrupt %d!\n",
 		    reply_q->name, vector);
-		kfree(reply_q);
 		free_cpumask_var(reply_q->affinity_hint);
+		kfree(reply_q);
 		return -EBUSY;
 	}
 
-- 
1.8.3.1
