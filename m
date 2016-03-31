From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 1/2] target: Make target db location configurable
Date: Thu, 31 Mar 2016 11:05:29 -0700
Message-ID: <553cc68ded2c5fcc51bffa1cf0033a7a9c88144f.1459278305.git.lduncan@suse.com>
References: <cover.1459278305.git.lduncan@suse.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <cover.1459278305.git.lduncan@suse.com>
In-Reply-To: <cover.1459278305.git.lduncan@suse.com>
References: <cover.1459278305.git.lduncan@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: nab@linux-iscsi.org, hch@infradead.org, lkml@vger.kernel.org, hare@suse.com, Lee Duncan <lduncan@suse.com>
List-Id: linux-scsi@vger.kernel.org

This commit adds the read-write attribute "dbroot", in
the top-level CONFIGFS (core) target directory,
normally /sys/kernel/config/target. This attribute
defaults to "/var/target" but can be changed by
writing a new pathname string to it.

Target modules that care about the target database
root directory will be modified to use this
attribute in a future commit.
---
 drivers/target/target_core_configfs.c | 31 +++++++++++++++++++++++++++++++
 drivers/target/target_core_internal.h |  6 ++++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 713c63d9681b..bfc5a8bb5778 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -99,6 +99,36 @@ static ssize_t target_core_item_version_show(struct config_item *item,
 
 CONFIGFS_ATTR_RO(target_core_item_, version);
 
+char db_root[DB_ROOT_LEN] = DB_ROOT_DEFAULT;
+
+static ssize_t target_core_item_dbroot_show(struct config_item *item,
+					    char *page)
+{
+	return sprintf(page, "%s\n", db_root);
+}
+
+static ssize_t target_core_item_dbroot_store(struct config_item *item,
+					const char *page, size_t count)
+{
+	ssize_t read_bytes;
+
+	if (count > (DB_ROOT_LEN - 1)) {
+		pr_err("db_root count: %d exceeds DB_ROOT_LEN-1: %u\n",
+		       (int)count, DB_ROOT_LEN - 1);
+		return -EINVAL;
+	}
+
+	read_bytes = snprintf(db_root, DB_ROOT_LEN, "%s", page);
+	if (!read_bytes)
+		return -EINVAL;
+	if (db_root[read_bytes - 1] == '\n')
+		db_root[read_bytes - 1] = '\0';
+
+	return read_bytes;
+}
+
+CONFIGFS_ATTR(target_core_item_, dbroot);
+
 static struct target_fabric_configfs *target_core_get_fabric(
 	const char *name)
 {
@@ -249,6 +279,7 @@ static struct configfs_group_operations target_core_fabric_group_ops = {
  */
 static struct configfs_attribute *target_core_fabric_item_attrs[] = {
 	&target_core_item_attr_version,
+	&target_core_item_attr_dbroot,
 	NULL,
 };
 
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 040cf5202e54..c2a18b960c5d 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -156,4 +156,10 @@ void	target_stat_setup_mappedlun_default_groups(struct se_lun_acl *);
 /* target_core_xcopy.c */
 extern struct se_portal_group xcopy_pt_tpg;
 
+/* target_core_configfs.c */
+#define DB_ROOT_LEN		4096
+#define	DB_ROOT_DEFAULT		"/var/target"
+
+extern char db_root[];
+
 #endif /* TARGET_CORE_INTERNAL_H */
-- 
2.1.4
