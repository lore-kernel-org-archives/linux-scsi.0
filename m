From: zhong jiang <zhongjiang@huawei.com>
Subject: [RESEND PATCH v2] scsi: Use vmemdup_user to replace the open code
Date: Tue, 18 Sep 2018 23:54:41 +0800
Message-ID: <1537286081-63081-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com
Cc: don.brace@microsemi.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

vmemdup_user is better than duplicating its implementation, So just
replace the open code.

The issue is detected with the help of Coccinelle.

Tested-by: Don Brace <don.brace@microsemi.com>
Acked-by: Don Brace <don.brace@microsemi.com>
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/scsi/hpsa.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 58bb70b..666ba09e5 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6381,13 +6381,9 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		return -EINVAL;
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
-	ioc = kmalloc(sizeof(*ioc), GFP_KERNEL);
-	if (!ioc) {
-		status = -ENOMEM;
-		goto cleanup1;
-	}
-	if (copy_from_user(ioc, argp, sizeof(*ioc))) {
-		status = -EFAULT;
+	ioc = vmemdup_user(argp, sizeof(*ioc));
+	if (IS_ERR(ioc)) {
+		status = PTR_ERR(ioc);
 		goto cleanup1;
 	}
 	if ((ioc->buf_size < 1) &&
@@ -6505,7 +6501,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		kfree(buff);
 	}
 	kfree(buff_size);
-	kfree(ioc);
+	kvfree(ioc);
 	return status;
 }
 
-- 
1.7.12.4
