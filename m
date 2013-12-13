From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 04/32] target: Fix sizeof in kmalloc for some default_groups arrays
Date: Fri, 13 Dec 2013 15:58:52 -0800
Message-ID: <1386979160-6928-5-git-send-email-agrover@redhat.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816Ab3LMX72 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 18:59:28 -0500
In-Reply-To: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Allocating an array of pointers, not the objects themselves. These two
sites now match all the other sites.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_configfs.c        |    2 +-
 drivers/target/target_core_fabric_configfs.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 272755d..a1c23d1 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2937,7 +2937,7 @@ static int __init target_core_init_configfs(void)
 	 * and ALUA Logical Unit Group and Target Port Group infrastructure.
 	 */
 	target_cg = &subsys->su_group;
-	target_cg->default_groups = kmalloc(sizeof(struct config_group) * 2,
+	target_cg->default_groups = kmalloc(sizeof(struct config_group *) * 2,
 				GFP_KERNEL);
 	if (!target_cg->default_groups) {
 		pr_err("Unable to allocate target_cg->default_groups\n");
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index fdadc4d..7de9f04 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -906,7 +906,7 @@ static struct config_group *target_fabric_make_lun(
 	lun_cg->default_groups[1] = NULL;
 
 	port_stat_grp = &lun->port_stat_grps.stat_group;
-	port_stat_grp->default_groups =  kzalloc(sizeof(struct config_group) * 4,
+	port_stat_grp->default_groups =  kzalloc(sizeof(struct config_group *) * 4,
 				GFP_KERNEL);
 	if (!port_stat_grp->default_groups) {
 		pr_err("Unable to allocate port_stat_grp->default_groups\n");
-- 
1.7.1

