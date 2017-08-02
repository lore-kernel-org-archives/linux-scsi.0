From: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] scsi: add const to bin_attribute structures
Date: Wed,  2 Aug 2017 13:51:50 +0530
Message-ID: <1501662110-12388-1-git-send-email-bhumirks@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: julia.lawall@lip6.fr, aradford@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, brking@us.ibm.com, james.smart@broadcom.com, dick.kennedy@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Add const to bin_attribute structures as they are only passed to the
functions sysfs_{remove/create}_bin_file. The arguments passed are of
type const, so declare the structures to be const.

Done using Coccinelle.

@m disable optional_qualifier@
identifier s;
position p;
@@
static struct bin_attribute s@p={...};

@okay1@
position p;
identifier m.s;
@@
(
sysfs_create_bin_file(...,&s@p,...)
|
sysfs_remove_bin_file(...,&s@p,...)
)

@bad@
position p!={m.p,okay1.p};
identifier m.s;
@@
s@p

@change depends on !bad disable optional_qualifier@
identifier m.s;
@@
static
+const
struct bin_attribute s={...};

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/scsi/3w-sas.c         | 4 ++--
 drivers/scsi/ipr.c            | 2 +-
 drivers/scsi/lpfc/lpfc_attr.c | 6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index b150e13..5328a03 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -116,7 +116,7 @@ static ssize_t twl_sysfs_aen_read(struct file *filp, struct kobject *kobj,
 } /* End twl_sysfs_aen_read() */
 
 /* aen_read sysfs attribute initializer */
-static struct bin_attribute twl_sysfs_aen_read_attr = {
+static const struct bin_attribute twl_sysfs_aen_read_attr = {
 	.attr = {
 		.name = "3ware_aen_read",
 		.mode = S_IRUSR,
@@ -147,7 +147,7 @@ static ssize_t twl_sysfs_compat_info(struct file *filp, struct kobject *kobj,
 } /* End twl_sysfs_compat_info() */
 
 /* compat_info sysfs attribute initializer */
-static struct bin_attribute twl_sysfs_compat_info_attr = {
+static const struct bin_attribute twl_sysfs_compat_info_attr = {
 	.attr = {
 		.name = "3ware_compat_info",
 		.mode = S_IRUSR,
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index b0c68d2..8f04f66 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4206,7 +4206,7 @@ static ssize_t ipr_next_async_err_log(struct file *filep, struct kobject *kobj,
 	return count;
 }
 
-static struct bin_attribute ipr_ioa_async_err_log = {
+static const struct bin_attribute ipr_ioa_async_err_log = {
 	.attr = {
 		.name =		"async_err_log",
 		.mode =		S_IRUGO | S_IWUSR,
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 4ed48ed..be04408 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3974,7 +3974,7 @@ static DEVICE_ATTR(lpfc_stat_data_ctrl, S_IRUGO | S_IWUSR,
 	return index;
 }
 
-static struct bin_attribute sysfs_drvr_stat_data_attr = {
+static const struct bin_attribute sysfs_drvr_stat_data_attr = {
 	.attr = {
 		.name = "lpfc_drvr_stat_data",
 		.mode = S_IRUSR,
@@ -5368,7 +5368,7 @@ struct device_attribute *lpfc_vport_attrs[] = {
 	return count;
 }
 
-static struct bin_attribute sysfs_ctlreg_attr = {
+static const struct bin_attribute sysfs_ctlreg_attr = {
 	.attr = {
 		.name = "ctlreg",
 		.mode = S_IRUSR | S_IWUSR,
@@ -5426,7 +5426,7 @@ struct device_attribute *lpfc_vport_attrs[] = {
 	return -EPERM;
 }
 
-static struct bin_attribute sysfs_mbox_attr = {
+static const struct bin_attribute sysfs_mbox_attr = {
 	.attr = {
 		.name = "mbox",
 		.mode = S_IRUSR | S_IWUSR,
-- 
1.9.1
