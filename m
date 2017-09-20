From: Meng Xu <mengxu.gatech@gmail.com>
Subject: [PATCH] mpt3sas: remove redundant copy_from_user in _ctl_getiocinfo
Date: Wed, 20 Sep 2017 11:13:51 -0400
Message-ID: <1505920431-13173-1-git-send-email-mengxu.gatech@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hch@infradead.org, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: meng.xu@gatech.edu, sanidhya@gatech.edu, taesoo@gatech.edu, Meng Xu <mengxu.gatech@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Since right after the user copy, we are going to
memset(&karg, 0, sizeof(karg)), the copy_from_user is redundant

Signed-off-by: Meng Xu <mengxu.gatech@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index bdffb69..d448fed 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1065,12 +1065,6 @@ _ctl_getiocinfo(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 {
 	struct mpt3_ioctl_iocinfo karg;
 
-	if (copy_from_user(&karg, arg, sizeof(karg))) {
-		pr_err("failure at %s:%d/%s()!\n",
-		    __FILE__, __LINE__, __func__);
-		return -EFAULT;
-	}
-
 	dctlprintk(ioc, pr_info(MPT3SAS_FMT "%s: enter\n", ioc->name,
 	    __func__));
 
-- 
2.7.4
