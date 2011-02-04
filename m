From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 02/12] target: Fix top-level configfs_subsystem default_group shutdown breakage
Date: Thu,  3 Feb 2011 22:45:02 -0800
Message-ID: <1296801912-18857-3-git-send-email-nab@linux-iscsi.org>
References: <1296801912-18857-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm24.bullet.mail.ac4.yahoo.com ([98.139.52.221]:31987 "HELO
	nm24.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752549Ab1BDGpQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Feb 2011 01:45:16 -0500
In-Reply-To: <1296801912-18857-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Joel Becker <jlbec@evilplan.org>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes two bugs uncovered during testing with slub_debug=FPUZ
during module_exit() -> target_core_exit_configfs() with release of
configfs subsystem consumer default groups, namely how this should be
working with fs/configfs/dir.c:configfs_unregister_subsystem() release
logic for struct config_group->default_group.

The first issue involves configfs_unregister_subsystem() expecting to
walk+drain the top-level subsys->su_group.default_groups directly in
unlink_group(), and not directly from the configfs subsystem consumer
for the top level struct config_group->default_groups.  This patch drops
the walk+drain of subsys->su_group.default_groups from TCM configfs
subsystem consumer code, and moves the top-level ->default_groups kfree()
after configfs_unregister_subsystem() has been called.

The second issue involves calling core_alua_free_lu_gp(se_global->default_lu_gp)
to release the default_lu_gp->lu_gp_group before configfs_unregister_subsystem()
has been called.  This patches also moves the core_alua_free_lu_gp() call to
release default_lu_group->lu_gp_group after the subsys has been unregistered.

Finally, this patch explictly clears the [lu_gp,alua,hba]_cg->default_groups
pointers after kfree() to ensure that no stale memory is picked up from
child struct config_group->default_group[] while configfs_unregister_subsystem()
is called.

Reported-by: Fubo Chen <fubo.chen@gmail.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 30ae3af..431cd2e 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3206,8 +3206,7 @@ static void target_core_exit_configfs(void)
 		config_item_put(item);
 	}
 	kfree(lu_gp_cg->default_groups);
-	core_alua_free_lu_gp(se_global->default_lu_gp);
-	se_global->default_lu_gp = NULL;
+	lu_gp_cg->default_groups = NULL;
 
 	alua_cg = &se_global->alua_group;
 	for (i = 0; alua_cg->default_groups[i]; i++) {
@@ -3216,6 +3215,7 @@ static void target_core_exit_configfs(void)
 		config_item_put(item);
 	}
 	kfree(alua_cg->default_groups);
+	alua_cg->default_groups = NULL;
 
 	hba_cg = &se_global->target_core_hbagroup;
 	for (i = 0; hba_cg->default_groups[i]; i++) {
@@ -3224,15 +3224,17 @@ static void target_core_exit_configfs(void)
 		config_item_put(item);
 	}
 	kfree(hba_cg->default_groups);
-
-	for (i = 0; subsys->su_group.default_groups[i]; i++) {
-		item = &subsys->su_group.default_groups[i]->cg_item;
-		subsys->su_group.default_groups[i] = NULL;
-		config_item_put(item);
-	}
+	hba_cg->default_groups = NULL;
+	/*
+	 * We expect subsys->su_group.default_groups to be released
+	 * by configfs subsystem provider logic..
+	 */
+	configfs_unregister_subsystem(subsys);
 	kfree(subsys->su_group.default_groups);
 
-	configfs_unregister_subsystem(subsys);
+	core_alua_free_lu_gp(se_global->default_lu_gp);
+	se_global->default_lu_gp = NULL;
+
 	printk(KERN_INFO "TARGET_CORE[0]: Released ConfigFS Fabric"
 			" Infrastructure\n");
 
-- 
1.7.4

