From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 006/103] target: Remove unused su_group usage in fabric register/dergister
Date: Thu, 21 Jul 2011 00:04:42 -0700
Message-ID: <1311231979-6631-7-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm9.bullet.mail.bf1.yahoo.com ([98.139.212.168]:35057 "HELO
	nm9.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751003Ab1GUHAF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:00:05 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes two instances of left over v3.x code performing local
scope access to struct target_core_fabric_ops->tf_subsys->su_group in
target_fabric_configfs_register() and target_fabric_configfs_deregister().

Reported-by: Christophe Fergeau <cfergeau@gmail.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 25c1f49..c614000 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -533,7 +533,6 @@ static int target_fabric_tf_ops_check(
 int target_fabric_configfs_register(
 	struct target_fabric_configfs *tf)
 {
-	struct config_group *su_group;
 	int ret;
 
 	if (!(tf)) {
@@ -546,12 +545,6 @@ int target_fabric_configfs_register(
 			" pointer\n");
 		return -EINVAL;
 	}
-	su_group = &tf->tf_subsys->su_group;
-	if (!(su_group)) {
-		printk(KERN_ERR "Unable to locate target struct config_group"
-			" pointer\n");
-		return -EINVAL;
-	}
 	ret = target_fabric_tf_ops_check(tf);
 	if (ret < 0)
 		return ret;
@@ -565,7 +558,6 @@ EXPORT_SYMBOL(target_fabric_configfs_register);
 void target_fabric_configfs_deregister(
 	struct target_fabric_configfs *tf)
 {
-	struct config_group *su_group;
 	struct configfs_subsystem *su;
 
 	if (!(tf)) {
@@ -579,13 +571,6 @@ void target_fabric_configfs_deregister(
 			" pointer\n");
 		return;
 	}
-	su_group = &tf->tf_subsys->su_group;
-	if (!(su_group)) {
-		printk(KERN_ERR "Unable to locate target struct config_group"
-			" pointer\n");
-		return;
-	}
-
 	printk(KERN_INFO "<<<<<<<<<<<<<<<<<<<<<< BEGIN FABRIC API >>>>>>>>>>"
 			">>>>>>>>>>>>\n");
 	mutex_lock(&g_tf_lock);
-- 
1.7.6

