From: Meng Xu <mengxu.gatech@gmail.com>
Subject: [PATCH] mpt3sas: downgrade full copy_from_user to access_ok check
Date: Tue, 19 Sep 2017 23:11:11 -0400
Message-ID: <1505877071-76996-1-git-send-email-mengxu.gatech@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: meng.xu@gatech.edu, sanidhya@gatech.edu, taesoo@gatech.edu, Meng Xu <mengxu.gatech@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Since right after the user copy, we are going to
memset(&karg, 0, sizeof(karg)), I guess an access_ok check is enough?

Signed-off-by: Meng Xu <mengxu.gatech@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index bdffb69..b363d2d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1065,7 +1065,7 @@ _ctl_getiocinfo(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 {
 	struct mpt3_ioctl_iocinfo karg;
 
-	if (copy_from_user(&karg, arg, sizeof(karg))) {
+	if (!access_ok(VERIFY_READ, arg, sizeof(karg))) {
 		pr_err("failure at %s:%d/%s()!\n",
 		    __FILE__, __LINE__, __func__);
 		return -EFAULT;
-- 
2.7.4
