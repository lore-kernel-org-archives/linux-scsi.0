From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/4] [LIO-Target/ConfigFS]: Add attribute for ALUA
	secondary port access state
Date: Tue, 18 Aug 2009 16:16:05 -0700
Message-ID: <1250637365.27590.69.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp110.sbc.mail.gq1.yahoo.com ([67.195.14.95]:30112 "HELO
	smtp110.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752154AbZHRXQH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Aug 2009 19:16:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Alasdair G Kergon <agk@redhat.com>, Joel Becker <joel.becker@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Florian Haas <florian.haas@linbit.com>, Philipp Reisner <philipp.reisner@linbit.com>

Greetings,

This patch updates the LIO-Target fabric module configfs code to add
support for the SPC-4 defined ALUA secondary port access state OFFLINE.  This
new attribute is located at:

/sys/kernel/config/target/iscsi/$TARGETNAME/tpgt_$TPGT/lun/lun_0/alua_tg_pt_offline

which calls generic target_core_mod code to preform the actual OFFLINE <-> ONLINE
state transitions for this iSCSI target port/LUN.

Also, this patch does a small cleanup for lio_target_port_cit and makes it use
CONFIGFS_EATTR_*() macros to generate the default store()/show() handlers for the
struct configfs_item_operations lio_target_port_item_ops.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_configfs.c |   99 ++++++++++++++++-------------
 1 files changed, 55 insertions(+), 44 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_configfs.c b/drivers/lio-core/iscsi_target_configfs.c
index 3fd42dc..1230b74 100644
--- a/drivers/lio-core/iscsi_target_configfs.c
+++ b/drivers/lio-core/iscsi_target_configfs.c
@@ -402,67 +402,78 @@ static struct config_item_type lio_target_np_cit = {
 
 // Start items for lio_target_port_cit
 
-static ssize_t lio_target_show_port_alua_tg_pt_gp (void *p, char *page)
-{
-	se_lun_t *lun = (se_lun_t *)p;
+CONFIGFS_EATTR_STRUCT(lio_target_port, se_lun_s);
+#define LIO_PORT_ATTR(_name, _mode)					\
+static struct lio_target_port_attribute lio_target_port_##_name =	\
+	__CONFIGFS_EATTR(_name, _mode,					\
+	lio_target_port_show_attr_##_name,				\
+	lio_target_port_store_attr_##_name);
+
+#define LIO_PORT_ATTR_RO(_name, _mode)					\
+static struct lio_target_port_attribute lio_target_port_##_name =	\
+	__CONFIGFS_EATTR_RO(_name,					\
+	lio_target_port_show_attr_##_name);
 
+/*
+ * alua_tg_pt_gp
+ */
+static ssize_t lio_target_port_show_attr_alua_tg_pt_gp(
+	struct se_lun_s *lun,
+	char *page)
+{
 	if (!(lun->lun_sep))
-		return(-ENODEV);
+		return -ENODEV;
 
-	return(core_alua_show_tg_pt_gp_info(lun->lun_sep, page));
+	return core_alua_show_tg_pt_gp_info(lun->lun_sep, page);
 }
 
-static ssize_t lio_target_store_port_alua_tg_pt_gp (void *p, const char *page, size_t count)
+static ssize_t lio_target_port_store_attr_alua_tg_pt_gp(
+	struct se_lun_s *lun,
+	const char *page,
+	size_t count)
 {
-	se_lun_t *lun = (se_lun_t *)p;
-
 	if (!(lun->lun_sep))
-		return(-ENODEV);
+		return -ENODEV;
 
-	return(core_alua_store_tg_pt_gp_info(lun->lun_sep, page, count));
+	return core_alua_store_tg_pt_gp_info(lun->lun_sep, page, count);
 }
 
-static struct lio_target_configfs_attribute lio_target_attr_port_alua_tg_pt_gp = {
-	.attr	= { .ca_owner = THIS_MODULE,
-		    .ca_name = "alua_tg_pt_gp",
-		    .ca_mode = S_IRUGO | S_IWUSR },
-	.show	= lio_target_show_port_alua_tg_pt_gp,
-	.store	= lio_target_store_port_alua_tg_pt_gp,
-};
-
-static struct configfs_attribute *lio_target_port_attrs[] = {
-	&lio_target_attr_port_alua_tg_pt_gp.attr,
-	NULL,
-};
+LIO_PORT_ATTR(alua_tg_pt_gp, S_IRUGO | S_IWUSR);
 
-static ssize_t lio_target_port_show (struct config_item *item,
-				     struct configfs_attribute *attr,
-				     char *page)
+/*
+ * alua_tg_pt_offline
+ */
+static ssize_t lio_target_port_show_attr_alua_tg_pt_offline(
+	struct se_lun_s *lun,
+	char *page)
 {
-	se_lun_t *lun = container_of(to_config_group(item), se_lun_t, lun_group);
-	struct lio_target_configfs_attribute *lt_attr = container_of(
-			attr, struct lio_target_configfs_attribute, attr);
-
-	if (!(lt_attr->show))
-		return(-EINVAL);
+	if (!(lun->lun_sep))
+		return -ENODEV;
 
-	return(lt_attr->show((void *)lun, page));
+	return core_alua_show_offline_bit(lun, page);
 }
 
-static ssize_t lio_target_port_store (struct config_item *item,
-				      struct configfs_attribute *attr,
-				      const char *page, size_t count)
+static ssize_t lio_target_port_store_attr_alua_tg_pt_offline(
+	struct se_lun_s *lun,
+	const char *page,
+	size_t count)
 {
-	se_lun_t *lun = container_of(to_config_group(item), se_lun_t, lun_group);
-	struct lio_target_configfs_attribute *lt_attr = container_of(
-			attr, struct lio_target_configfs_attribute, attr);
-
-	if (!(lt_attr->store))
-		return(-EINVAL);
+	if (!(lun->lun_sep))
+		return -ENODEV;
 
-	return(lt_attr->store((void *)lun, page, count));
+	return core_alua_store_offline_bit(lun, page, count);
 }
 
+LIO_PORT_ATTR(alua_tg_pt_offline, S_IRUGO | S_IWUSR);
+
+static struct configfs_attribute *lio_target_port_attrs[] = {
+	&lio_target_port_alua_tg_pt_gp.attr,
+	&lio_target_port_alua_tg_pt_offline.attr,
+	NULL,
+};
+
+CONFIGFS_EATTR_OPS(lio_target_port, se_lun_s, lun_group);
+
 static int lio_target_port_link (struct config_item *lun_ci, struct config_item *se_dev_ci)
 {
 	iscsi_portal_group_t *tpg;
@@ -563,8 +574,8 @@ static int lio_target_port_unlink (struct config_item *lun_ci, struct config_ite
 
 static struct configfs_item_operations lio_target_port_item_ops = {
 	.release		= NULL,
-	.show_attribute		= lio_target_port_show,
-	.store_attribute	= lio_target_port_store,
+	.show_attribute		= lio_target_port_attr_show,
+	.store_attribute	= lio_target_port_attr_store,
 	.allow_link		= lio_target_port_link,
 	.check_link		= lio_target_port_check_link,
 	.drop_link		= lio_target_port_unlink,
-- 
1.5.4.1



