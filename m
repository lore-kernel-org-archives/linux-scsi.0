From: Firo Yang <firogm@gmail.com>
Subject: [PATCH] hpsa: Remove unnessary cast
Date: Thu, 23 Apr 2015 17:56:37 +0800
Message-ID: <1429782997-6794-1-git-send-email-firogm@gmail.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: don.brace@pmcs.com, JBottomley@odin.com
Cc: kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, Firo Yang <firogm@gmail.com>
List-Id: linux-scsi@vger.kernel.org

kmalloc() returns a void pointer - no need to cast it in
drivers/scsi/hpsa.c::hpsa_big_passthru_ioctl()

Signed-off-by: Firo Yang <firogm@gmail.com>
---
 drivers/scsi/hpsa.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8eab107..e7d3444b 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4992,8 +4992,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
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
2.1.0

