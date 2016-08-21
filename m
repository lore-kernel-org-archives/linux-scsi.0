From: Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH] scsi: not need to alloc zero buffer for local_atto_ioctl
Date: Sun, 21 Aug 2016 10:33:29 +0800
Message-ID: <1471746809-31218-1-git-send-email-shawn.lin@rock-chips.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bradley Grove <linuxdrivers@attotech.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Shawn Lin <shawn.lin@rock-chips.com>
List-Id: linux-scsi@vger.kernel.org

We don't need to use kzalloc as we will always memset the
local_atto_ioctl later.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
---

 drivers/scsi/esas2r/esas2r_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 2aca4d1..5092c82 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -194,7 +194,7 @@ static ssize_t write_hw(struct file *file, struct kobject *kobj,
 	int length = min(sizeof(struct atto_ioctl), count);
 
 	if (!a->local_atto_ioctl) {
-		a->local_atto_ioctl = kzalloc(sizeof(struct atto_ioctl),
+		a->local_atto_ioctl = kmalloc(sizeof(struct atto_ioctl),
 					      GFP_KERNEL);
 		if (a->local_atto_ioctl == NULL) {
 			esas2r_log(ESAS2R_LOG_WARN,
-- 
2.3.7
