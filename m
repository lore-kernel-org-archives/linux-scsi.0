From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 06/31] target/iblock: Fix memory leak in iblock_set_configfs_dev_params
Date: Wed,  9 Feb 2011 15:34:41 -0800
Message-ID: <1297294506-23579-7-git-send-email-nab@linux-iscsi.org>
References: <1297294506-23579-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm29.bullet.mail.sp2.yahoo.com ([98.139.91.99]:44878 "HELO
	nm29.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755544Ab1BIXfJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2011 18:35:09 -0500
In-Reply-To: <1297294506-23579-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

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
1.7.4

