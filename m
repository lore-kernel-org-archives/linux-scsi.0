From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 2/2] target: use new "dbroot" target attribute
Date: Wed, 13 Apr 2016 13:25:56 -0700
Message-ID: <4deb4b5219c4b30e18569380b82359f242f2a25b.1460577841.git.lduncan@suse.com>
References: <cover.1460577841.git.lduncan@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1460577841.git.lduncan@suse.com>
In-Reply-To: <cover.1460577841.git.lduncan@suse.com>
References: <cover.1460577841.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, nab@linux-iscsi.org, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, hare@suse.de, agrover@redhat.com, jxm@netiant.com, Lee Duncan <lduncan@suse.com>
List-Id: linux-scsi@vger.kernel.org

This commit updates the target core ALUA and PR
modules to use the new "dbroot" attribute instead
of assuming the target database is in "/var/target".

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/target/target_core_alua.c | 6 +++---
 drivers/target/target_core_pr.c   | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 49aba4a31747..4c82bbe19003 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -932,7 +932,7 @@ static int core_alua_update_tpg_primary_metadata(
 			tg_pt_gp->tg_pt_gp_alua_access_status);
 
 	snprintf(path, ALUA_METADATA_PATH_LEN,
-		"/var/target/alua/tpgs_%s/%s", &wwn->unit_serial[0],
+		"%s/alua/tpgs_%s/%s", db_root, &wwn->unit_serial[0],
 		config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item));
 
 	rc = core_alua_write_tpg_metadata(path, md_buf, len);
@@ -1275,8 +1275,8 @@ static int core_alua_update_tpg_secondary_metadata(struct se_lun *lun)
 			atomic_read(&lun->lun_tg_pt_secondary_offline),
 			lun->lun_tg_pt_secondary_stat);
 
-	snprintf(path, ALUA_METADATA_PATH_LEN, "/var/target/alua/%s/%s/lun_%llu",
-			se_tpg->se_tpg_tfo->get_fabric_name(), wwn,
+	snprintf(path, ALUA_METADATA_PATH_LEN, "%s/alua/%s/%s/lun_%llu",
+			db_root, se_tpg->se_tpg_tfo->get_fabric_name(), wwn,
 			lun->unpacked_lun);
 
 	rc = core_alua_write_tpg_metadata(path, md_buf, len);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index b1795735eafc..47463c99c318 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1985,7 +1985,7 @@ static int __core_scsi3_write_aptpl_to_file(
 		return -EMSGSIZE;
 	}
 
-	snprintf(path, 512, "/var/target/pr/aptpl_%s", &wwn->unit_serial[0]);
+	snprintf(path, 512, "%s/pr/aptpl_%s", db_root, &wwn->unit_serial[0]);
 	file = filp_open(path, flags, 0600);
 	if (IS_ERR(file)) {
 		pr_err("filp_open(%s) for APTPL metadata"
-- 
2.1.4
