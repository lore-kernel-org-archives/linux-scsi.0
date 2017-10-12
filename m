From: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] target: make config_item_type const
Date: Thu, 12 Oct 2017 11:11:20 +0200
Message-ID: <1507799480-25286-1-git-send-email-bhumirks@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: julia.lawall@lip6.fr, nab@linux-iscsi.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This is a followup patch for: https://lkml.org/lkml/2017/10/11/375 and
https://patchwork.kernel.org/patch/9999649/

Make these structures const as they are either passed to the functions
having the argument as const or stored as a reference in the "ci_type"
const field of a config_item structure.

Done using Coccinelle.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/target/target_core_configfs.c | 14 +++++++-------
 drivers/target/target_core_stat.c     | 16 ++++++++--------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 7e87d95..bd87cc2 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -307,7 +307,7 @@ static void target_core_deregister_fabric(
 /*
  * Provides Fabrics Groups and Item Attributes for /sys/kernel/config/target/
  */
-static struct config_item_type target_core_fabrics_item = {
+static const struct config_item_type target_core_fabrics_item = {
 	.ct_group_ops	= &target_core_fabric_group_ops,
 	.ct_attrs	= target_core_fabric_item_attrs,
 	.ct_owner	= THIS_MODULE,
@@ -2376,7 +2376,7 @@ static void target_core_alua_lu_gp_release(struct config_item *item)
 	.release		= target_core_alua_lu_gp_release,
 };
 
-static struct config_item_type target_core_alua_lu_gp_cit = {
+static const struct config_item_type target_core_alua_lu_gp_cit = {
 	.ct_item_ops		= &target_core_alua_lu_gp_ops,
 	.ct_attrs		= target_core_alua_lu_gp_attrs,
 	.ct_owner		= THIS_MODULE,
@@ -2434,7 +2434,7 @@ static void target_core_alua_drop_lu_gp(
 	.drop_item		= &target_core_alua_drop_lu_gp,
 };
 
-static struct config_item_type target_core_alua_lu_gps_cit = {
+static const struct config_item_type target_core_alua_lu_gps_cit = {
 	.ct_item_ops		= NULL,
 	.ct_group_ops		= &target_core_alua_lu_gps_group_ops,
 	.ct_owner		= THIS_MODULE,
@@ -2813,7 +2813,7 @@ static void target_core_alua_tg_pt_gp_release(struct config_item *item)
 	.release		= target_core_alua_tg_pt_gp_release,
 };
 
-static struct config_item_type target_core_alua_tg_pt_gp_cit = {
+static const struct config_item_type target_core_alua_tg_pt_gp_cit = {
 	.ct_item_ops		= &target_core_alua_tg_pt_gp_ops,
 	.ct_attrs		= target_core_alua_tg_pt_gp_attrs,
 	.ct_owner		= THIS_MODULE,
@@ -2884,7 +2884,7 @@ static void target_core_alua_drop_tg_pt_gp(
  * core/alua/lu_gps and core/alua/tg_pt_gps that are attached to
  * target_core_alua_cit in target_core_init_configfs() below.
  */
-static struct config_item_type target_core_alua_cit = {
+static const struct config_item_type target_core_alua_cit = {
 	.ct_item_ops		= NULL,
 	.ct_attrs		= NULL,
 	.ct_owner		= THIS_MODULE,
@@ -3105,7 +3105,7 @@ static void target_core_hba_release(struct config_item *item)
 	.release		= target_core_hba_release,
 };
 
-static struct config_item_type target_core_hba_cit = {
+static const struct config_item_type target_core_hba_cit = {
 	.ct_item_ops		= &target_core_hba_item_ops,
 	.ct_group_ops		= &target_core_hba_group_ops,
 	.ct_attrs		= target_core_hba_attrs,
@@ -3188,7 +3188,7 @@ static void target_core_call_delhbafromtarget(
 	.drop_item	= target_core_call_delhbafromtarget,
 };
 
-static struct config_item_type target_core_cit = {
+static const struct config_item_type target_core_cit = {
 	.ct_item_ops	= NULL,
 	.ct_group_ops	= &target_core_group_ops,
 	.ct_attrs	= NULL,
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 8038255..f0db91e 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -96,7 +96,7 @@ static ssize_t target_stat_ports_show(struct config_item *item, char *page)
 	NULL,
 };
 
-static struct config_item_type target_stat_scsi_dev_cit = {
+static const struct config_item_type target_stat_scsi_dev_cit = {
 	.ct_attrs		= target_stat_scsi_dev_attrs,
 	.ct_owner		= THIS_MODULE,
 };
@@ -193,7 +193,7 @@ static ssize_t target_stat_tgt_aborts_no_task_show(struct config_item *item,
 	NULL,
 };
 
-static struct config_item_type target_stat_scsi_tgt_dev_cit = {
+static const struct config_item_type target_stat_scsi_tgt_dev_cit = {
 	.ct_attrs		= target_stat_scsi_tgt_dev_attrs,
 	.ct_owner		= THIS_MODULE,
 };
@@ -414,7 +414,7 @@ static ssize_t target_stat_lu_creation_time_show(struct config_item *item,
 	NULL,
 };
 
-static struct config_item_type target_stat_scsi_lu_cit = {
+static const struct config_item_type target_stat_scsi_lu_cit = {
 	.ct_attrs		= target_stat_scsi_lu_attrs,
 	.ct_owner		= THIS_MODULE,
 };
@@ -540,7 +540,7 @@ static ssize_t target_stat_port_busy_count_show(struct config_item *item,
 	NULL,
 };
 
-static struct config_item_type target_stat_scsi_port_cit = {
+static const struct config_item_type target_stat_scsi_port_cit = {
 	.ct_attrs		= target_stat_scsi_port_attrs,
 	.ct_owner		= THIS_MODULE,
 };
@@ -724,7 +724,7 @@ static ssize_t target_stat_tgt_port_hs_in_cmds_show(struct config_item *item,
 	NULL,
 };
 
-static struct config_item_type target_stat_scsi_tgt_port_cit = {
+static const struct config_item_type target_stat_scsi_tgt_port_cit = {
 	.ct_attrs		= target_stat_scsi_tgt_port_attrs,
 	.ct_owner		= THIS_MODULE,
 };
@@ -844,7 +844,7 @@ static ssize_t target_stat_transport_proto_id_show(struct config_item *item,
 	NULL,
 };
 
-static struct config_item_type target_stat_scsi_transport_cit = {
+static const struct config_item_type target_stat_scsi_transport_cit = {
 	.ct_attrs		= target_stat_scsi_transport_attrs,
 	.ct_owner		= THIS_MODULE,
 };
@@ -1206,7 +1206,7 @@ static ssize_t target_stat_auth_row_status_show(struct config_item *item,
 	NULL,
 };
 
-static struct config_item_type target_stat_scsi_auth_intr_cit = {
+static const struct config_item_type target_stat_scsi_auth_intr_cit = {
 	.ct_attrs		= target_stat_scsi_auth_intr_attrs,
 	.ct_owner		= THIS_MODULE,
 };
@@ -1378,7 +1378,7 @@ static ssize_t target_stat_iport_port_ident_show(struct config_item *item,
 	NULL,
 };
 
-static struct config_item_type target_stat_scsi_att_intr_port_cit = {
+static const struct config_item_type target_stat_scsi_att_intr_port_cit = {
 	.ct_attrs		= target_stat_scsi_ath_intr_port_attrs,
 	.ct_owner		= THIS_MODULE,
 };
-- 
1.9.1
