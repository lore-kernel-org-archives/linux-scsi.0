From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 14/24] target: Call proc_mkdir + remove_proc_entry with NULL parameter
Date: Sat, 29 Jan 2011 10:36:14 -0800
Message-ID: <1296326184-16664-15-git-send-email-nab@linux-iscsi.org>
References: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm28-vm0.bullet.mail.ac4.yahoo.com ([98.139.52.246]:30645 "HELO
	nm28-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754780Ab1A2Sgv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jan 2011 13:36:51 -0500
In-Reply-To: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch makes proc_mkdir() and remove_proc_entry() use a NULL
parameter to fix the following sparse warning:

CHECK   drivers/target/target_core_configfs.c
drivers/target/target_core_configfs.c:3131:54: warning: Using plain integer as NULL pointer
drivers/target/target_core_configfs.c:3145:50: warning: Using plain integer as NULL pointer
drivers/target/target_core_configfs.c:3212:42: warning: Using plain integer as NULL pointer

Reported-by: Fubo Chen <fubo.chen@gmail.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
(cherry picked from commit d83fca37fa4a6c2bcb2806800f221528a76fc080)
---
 drivers/target/target_core_configfs.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 96b87da..10741e3 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3158,7 +3158,7 @@ static int target_core_init_configfs(void)
 	if (core_dev_setup_virtual_lun0() < 0)
 		goto out;
 
-	scsi_target_proc = proc_mkdir("scsi_target", 0);
+	scsi_target_proc = proc_mkdir("scsi_target", NULL);
 	if (!(scsi_target_proc)) {
 		printk(KERN_ERR "proc_mkdir(scsi_target, 0) failed\n");
 		goto out;
@@ -3172,7 +3172,7 @@ static int target_core_init_configfs(void)
 out:
 	configfs_unregister_subsystem(subsys);
 	if (scsi_target_proc)
-		remove_proc_entry("scsi_target", 0);
+		remove_proc_entry("scsi_target", NULL);
 	core_dev_release_virtual_lun0();
 	rd_module_exit();
 out_global:
@@ -3239,7 +3239,7 @@ static void target_core_exit_configfs(void)
 			" Infrastructure\n");
 
 	remove_scsi_target_mib();
-	remove_proc_entry("scsi_target", 0);
+	remove_proc_entry("scsi_target", NULL);
 	core_dev_release_virtual_lun0();
 	rd_module_exit();
 	release_se_global();
-- 
1.7.3.5

