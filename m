From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 2/4] scsi: iscsi_boot_sysfs: constify attribute_group structures.
Date: Fri, 14 Jul 2017 13:53:28 +0530
Message-ID: <1500020610-15973-3-git-send-email-arvind.yadav.cs@gmail.com>
References: <1500020610-15973-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1500020610-15973-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: lduncan@suse.com, cleech@redhat.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

attribute_groups are not supposed to change at runtime. All functions
working with attribute_groups provided by <linux/sysfs.h> work
with const attribute_group. So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
   2548	   1768	      0	   4316	   10dc	drivers/scsi/iscsi_boot_sysfs.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
   2804	   1512	      0	   4316	   10dc	drivers/scsi/iscsi_boot_sysfs.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/scsi/iscsi_boot_sysfs.c  | 10 +++++-----
 include/linux/iscsi_boot_sysfs.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/iscsi_boot_sysfs.c b/drivers/scsi/iscsi_boot_sysfs.c
index d453667..9670a04 100644
--- a/drivers/scsi/iscsi_boot_sysfs.c
+++ b/drivers/scsi/iscsi_boot_sysfs.c
@@ -157,7 +157,7 @@ static umode_t iscsi_boot_tgt_attr_is_visible(struct kobject *kobj,
 	return 0;
 }
 
-static struct attribute_group iscsi_boot_target_attr_group = {
+static const struct attribute_group iscsi_boot_target_attr_group = {
 	.attrs = target_attrs,
 	.is_visible = iscsi_boot_tgt_attr_is_visible,
 };
@@ -243,7 +243,7 @@ static umode_t iscsi_boot_eth_attr_is_visible(struct kobject *kobj,
 	return 0;
 }
 
-static struct attribute_group iscsi_boot_ethernet_attr_group = {
+static const struct attribute_group iscsi_boot_ethernet_attr_group = {
 	.attrs = ethernet_attrs,
 	.is_visible = iscsi_boot_eth_attr_is_visible,
 };
@@ -301,7 +301,7 @@ static umode_t iscsi_boot_ini_attr_is_visible(struct kobject *kobj,
 	return 0;
 }
 
-static struct attribute_group iscsi_boot_initiator_attr_group = {
+static const struct attribute_group iscsi_boot_initiator_attr_group = {
 	.attrs = initiator_attrs,
 	.is_visible = iscsi_boot_ini_attr_is_visible,
 };
@@ -337,14 +337,14 @@ static umode_t iscsi_boot_acpitbl_attr_is_visible(struct kobject *kobj,
 	return 0;
 }
 
-static struct attribute_group iscsi_boot_acpitbl_attr_group = {
+static const struct attribute_group iscsi_boot_acpitbl_attr_group = {
 	.attrs = acpitbl_attrs,
 	.is_visible = iscsi_boot_acpitbl_attr_is_visible,
 };
 
 static struct iscsi_boot_kobj *
 iscsi_boot_create_kobj(struct iscsi_boot_kset *boot_kset,
-		       struct attribute_group *attr_group,
+		       const struct attribute_group *attr_group,
 		       const char *name, int index, void *data,
 		       ssize_t (*show) (void *data, int type, char *buf),
 		       umode_t (*is_visible) (void *data, int type),
diff --git a/include/linux/iscsi_boot_sysfs.h b/include/linux/iscsi_boot_sysfs.h
index 10923d7..3fb07e0 100644
--- a/include/linux/iscsi_boot_sysfs.h
+++ b/include/linux/iscsi_boot_sysfs.h
@@ -74,7 +74,7 @@ enum iscsi_boot_acpitbl_properties_enum {
 
 struct iscsi_boot_kobj {
 	struct kobject kobj;
-	struct attribute_group *attr_group;
+	const struct attribute_group *attr_group;
 	struct list_head list;
 
 	/*
-- 
1.9.1
