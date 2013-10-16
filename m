From: "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH] drivers: scsi: Remove useless casting in hpsa.c
Date: Wed, 16 Oct 2013 13:10:10 -0300
Message-ID: <1381939810-28976-1-git-send-email-geyslan@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: scameron@beardog.cce.hp.com, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-br@googlegroups.com, "Geyslan G. Bem" <geyslan@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Casting (void *) value returned by kmalloc is useless
as mentioned in Documentation/CodingStyle, Chap 14.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 drivers/scsi/hpsa.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 891c86b..896a57d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3093,8 +3093,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		return -EINVAL;
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
-	ioc = (BIG_IOCTL_Command_struct *)
-	    kmalloc(sizeof(*ioc), GFP_KERNEL);
+	ioc = kmalloc(sizeof(*ioc), GFP_KERNEL);
 	if (!ioc) {
 		status = -ENOMEM;
 		goto cleanup1;
-- 
1.8.4
