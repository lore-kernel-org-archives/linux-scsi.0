From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 05/31] target/file: Fix memory leak in fd_set_configfs_dev_params().
Date: Wed,  9 Feb 2011 15:34:40 -0800
Message-ID: <1297294506-23579-6-git-send-email-nab@linux-iscsi.org>
References: <1297294506-23579-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm30-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.238]:25718 "HELO
	nm30-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755755Ab1BIXfG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2011 18:35:06 -0500
In-Reply-To: <1297294506-23579-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jesper Juhl <jj@chaosbits.net>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Jesper Juhl <jj@chaosbits.net>

match_strdup() dynamically allocates memory and it is the responsabillity
of the caller to free that memory. In
drivers/target/target_core_file.c::fd_set_configfs_dev_params() two calls
are made to match_strdup() and in neither case is the allocated memory
freed, but instead it is leaked.

This patch should take care of the problem by kfree()'ing the allocated
memory once it is no longer needed. It also makes sure to return -ENOMEM
if the memory allocation in match_strdup() should fail.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 0aaca88..676a010 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -537,15 +537,26 @@ static ssize_t fd_set_configfs_dev_params(
 		token = match_token(ptr, tokens, args);
 		switch (token) {
 		case Opt_fd_dev_name:
+			arg_p = match_strdup(&args[0]);
+			if (!arg_p) {
+				ret = -ENOMEM;
+				break;
+			}
 			snprintf(fd_dev->fd_dev_name, FD_MAX_DEV_NAME,
-					"%s", match_strdup(&args[0]));
+					"%s", arg_p);
+			kfree(arg_p);
 			printk(KERN_INFO "FILEIO: Referencing Path: %s\n",
 					fd_dev->fd_dev_name);
 			fd_dev->fbd_flags |= FBDF_HAS_PATH;
 			break;
 		case Opt_fd_dev_size:
 			arg_p = match_strdup(&args[0]);
+			if (!arg_p) {
+				ret = -ENOMEM;
+				break;
+			}
 			ret = strict_strtoull(arg_p, 0, &fd_dev->fd_dev_size);
+			kfree(arg_p);
 			if (ret < 0) {
 				printk(KERN_ERR "strict_strtoull() failed for"
 						" fd_dev_size=\n");
-- 
1.7.4

