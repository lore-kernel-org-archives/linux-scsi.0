From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 21/32] target: Remove lun_link and device magic
Date: Fri, 13 Dec 2013 15:59:09 -0800
Message-ID: <1386979160-6928-22-git-send-email-agrover@redhat.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab3LMX7e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 18:59:34 -0500
In-Reply-To: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Not needed.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_device.c          |    1 -
 drivers/target/target_core_fabric_configfs.c |   11 -----------
 drivers/target/target_core_tpg.c             |    2 --
 include/target/target_core_base.h            |    4 ----
 4 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index f2e1415..e85a647 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1350,7 +1350,6 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	if (!dev)
 		return NULL;
 
-	dev->dev_link_magic = SE_DEV_LINK_MAGIC;
 	dev->se_hba = hba;
 	dev->transport = hba->transport;
 
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 1a31b46..4715836 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -71,11 +71,6 @@ static int target_fabric_mappedlun_link(
 	struct config_item *nacl_ci, *tpg_ci, *tpg_ci_s, *wwn_ci, *wwn_ci_s;
 	int ret = 0, lun_access;
 
-	if (lun->lun_link_magic != SE_LUN_LINK_MAGIC) {
-		pr_err("Bad lun->lun_link_magic, not a valid lun_ci pointer:"
-			" %p to struct lun: %p\n", lun_ci, lun);
-		return -EFAULT;
-	}
 	/*
 	 * Ensure that the source port exists
 	 */
@@ -762,12 +757,6 @@ static int target_fabric_port_link(
 	struct target_fabric_configfs *tf;
 	int ret;
 
-	if (dev->dev_link_magic != SE_DEV_LINK_MAGIC) {
-		pr_err("Bad dev->dev_link_magic, not a valid se_dev_ci pointer:"
-			" %p to struct se_device: %p\n", se_dev_ci, dev);
-		return -EFAULT;
-	}
-
 	if (!(dev->dev_flags & DF_CONFIGURED)) {
 		pr_err("se_device not configured yet, cannot port link\n");
 		return -ENODEV;
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 0467ad8..977b05c 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -617,7 +617,6 @@ static int core_tpg_setup_virtual_lun0(struct se_portal_group *se_tpg)
 	int ret;
 
 	lun->unpacked_lun = 0;
-	lun->lun_link_magic = SE_LUN_LINK_MAGIC;
 	atomic_set(&lun->lun_acl_count, 0);
 	init_completion(&lun->lun_shutdown_comp);
 	INIT_LIST_HEAD(&lun->lun_acl_list);
@@ -749,7 +748,6 @@ struct se_lun *core_tpg_alloc_lun(
 		return ERR_PTR(-ENOMEM);
 
 	lun->unpacked_lun = unpacked_lun;
-	lun->lun_link_magic = SE_LUN_LINK_MAGIC;
 	atomic_set(&lun->lun_acl_count, 0);
 	init_completion(&lun->lun_shutdown_comp);
 	INIT_LIST_HEAD(&lun->lun_acl_list);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 06f9bea..2c0a595 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -629,8 +629,6 @@ struct se_port_stat_grps {
 
 struct se_lun {
 	struct rb_node		rb_node;
-#define SE_LUN_LINK_MAGIC			0xffff7771
-	u32			lun_link_magic;
 	u32			lun_access;
 	u32			lun_flags;
 	u32			unpacked_lun;
@@ -655,8 +653,6 @@ struct se_dev_stat_grps {
 };
 
 struct se_device {
-#define SE_DEV_LINK_MAGIC			0xfeeddeef
-	u32			dev_link_magic;
 	/* RELATIVE TARGET PORT IDENTIFER Counter */
 	u16			dev_rpti_counter;
 	/* Used for SAM Task Attribute ordering */
-- 
1.7.1

