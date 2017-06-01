From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] target/configfs: Kill se_lun->lun_link_magic
Date: Thu,  1 Jun 2017 10:38:01 +0000
Message-ID: <1496313481-22083-2-git-send-email-nab@linux-iscsi.org>
References: <1496313481-22083-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1496313481-22083-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Instead of using a hardcoded magic value in se_lun when verifying
a target config_item symlink source during target_fabric_mappedlun_link(),
go ahead and use target_fabric_port_item_ops directly instead.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_fabric_configfs.c | 13 ++++++++-----
 drivers/target/target_core_tpg.c             |  1 -
 include/target/target_core_base.h            |  2 --
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 2cbaecd..e9e917c 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -65,6 +65,8 @@
 	pr_debug("Setup generic %s\n", __stringify(_name));		\
 }
 
+static struct configfs_item_operations target_fabric_port_item_ops;
+
 /* Start of tfc_tpg_mappedlun_cit */
 
 static int target_fabric_mappedlun_link(
@@ -72,19 +74,20 @@ static int target_fabric_mappedlun_link(
 	struct config_item *lun_ci)
 {
 	struct se_dev_entry *deve;
-	struct se_lun *lun = container_of(to_config_group(lun_ci),
-			struct se_lun, lun_group);
+	struct se_lun *lun;
 	struct se_lun_acl *lacl = container_of(to_config_group(lun_acl_ci),
 			struct se_lun_acl, se_lun_group);
 	struct se_portal_group *se_tpg;
 	struct config_item *nacl_ci, *tpg_ci, *tpg_ci_s, *wwn_ci, *wwn_ci_s;
 	bool lun_access_ro;
 
-	if (lun->lun_link_magic != SE_LUN_LINK_MAGIC) {
-		pr_err("Bad lun->lun_link_magic, not a valid lun_ci pointer:"
-			" %p to struct lun: %p\n", lun_ci, lun);
+	if (!lun_ci->ci_type ||
+	    lun_ci->ci_type->ct_item_ops != &target_fabric_port_item_ops) {
+		pr_err("Bad lun_ci, not a valid lun_ci pointer: %p\n", lun_ci);
 		return -EFAULT;
 	}
+	lun = container_of(to_config_group(lun_ci), struct se_lun, lun_group);
+
 	/*
 	 * Ensure that the source port exists
 	 */
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 74893ac..6b20b9f 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -584,7 +584,6 @@ struct se_lun *core_tpg_alloc_lun(
 		return ERR_PTR(-ENOMEM);
 	}
 	lun->unpacked_lun = unpacked_lun;
-	lun->lun_link_magic = SE_LUN_LINK_MAGIC;
 	atomic_set(&lun->lun_acl_count, 0);
 	init_completion(&lun->lun_ref_comp);
 	init_completion(&lun->lun_shutdown_comp);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index c3c14d0..47d9f38 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -701,8 +701,6 @@ struct scsi_port_stats {
 
 struct se_lun {
 	u64			unpacked_lun;
-#define SE_LUN_LINK_MAGIC			0xffff7771
-	u32			lun_link_magic;
 	bool			lun_shutdown;
 	bool			lun_access_ro;
 	u32			lun_index;
-- 
1.9.1
