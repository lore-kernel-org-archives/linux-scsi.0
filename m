From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target/iblock: Fix memory leak in iblock_set_configfs_dev_params
Date: Sun, 16 Jan 2011 15:04:30 -0800
Message-ID: <1295219071-32722-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Jesper Juhl <jj@chaosbits.net>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

The match_strdup() allocation for Opt_udev_path needs to be released
after usage.

Reported-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_iblock.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 67f0c09..422187b 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -469,7 +469,7 @@ static ssize_t iblock_set_configfs_dev_params(struct se_hba *hba,
 					       const char *page, ssize_t count)
 {
 	struct iblock_dev *ib_dev = se_dev->se_dev_su_ptr;
-	char *orig, *ptr, *opts;
+	char *orig, *ptr, *arg_p, *opts;
 	substring_t args[MAX_OPT_ARGS];
 	int ret = 0, arg, token;
 
@@ -492,9 +492,14 @@ static ssize_t iblock_set_configfs_dev_params(struct se_hba *hba,
 				ret = -EEXIST;
 				goto out;
 			}
-
-			ret = snprintf(ib_dev->ibd_udev_path, SE_UDEV_PATH_LEN,
-				"%s", match_strdup(&args[0]));
+			arg_p = match_strdup(&args[0]);
+			if (!arg_p) {
+				ret = -ENOMEM;
+				break;
+			}
+			snprintf(ib_dev->ibd_udev_path, SE_UDEV_PATH_LEN,
+					"%s", arg_p);
+			kfree(arg_p);
 			printk(KERN_INFO "IBLOCK: Referencing UDEV path: %s\n",
 					ib_dev->ibd_udev_path);
 			ib_dev->ibd_flags |= IBDF_HAS_UDEV_PATH;
-- 
1.5.6.5
