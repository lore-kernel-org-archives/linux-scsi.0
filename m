From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [LIO-Target/ConfigFS]: Added Target Portal Group Parameter
	READ/WRITE access
Date: Thu, 23 Oct 2008 18:04:03 -0700
Message-ID: <1224810243.16558.11.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:36036 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750936AbYJXBEO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Oct 2008 21:04:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Alasdair G Kergon <agk@redhat.com>, Ming Zhang <blackmagic02881@gmail.com>, "Ross S. W. Walker" <rswwalker@gmail.com>, Arne Redlich <agr@powerkom-dd.de>

>From 579003f73d50d905626ef98c5caf349b609b8631 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 23 Oct 2008 06:04:09 -0700
Subject: [PATCH] [LIO-Target/ConfigFS]: Added Target Portal Group Parameter READ/WRITE access

Added struct config_item_type lio_target_tpg_param_cit that lives under:

/sys/kernel/config/target/iscsi/$IQN/$TPGT/param/

These are the default params for $IQN/$TPGT that are copied over when
a new iSCSI Session/Connection is created when a new Login is received
from an iSCSI Initiator.  All parameters are READ/WRITEABLE, and the
values passed are sanity checked.

Here is what is looks like:

    |   |       `-- param
    |   |           |-- AuthMethod
    |   |           |-- DataDigest
    |   |           |-- DataPDUInOrder
    |   |           |-- DataSequenceInOrder
    |   |           |-- DefaultTime2Retain
    |   |           |-- DefaultTime2Wait
    |   |           |-- ErrorRecoveryLevel
    |   |           |-- FirstBurstLength
    |   |           |-- HeaderDigest
    |   |           |-- IFMarkInt
    |   |           |-- IFMarker
    |   |           |-- ImmediateData
    |   |           |-- InitialR2T
    |   |           |-- MaxBurstLength
    |   |           |-- MaxConnections
    |   |           |-- MaxOutstandingR2T
    |   |           |-- MaxRecvDataSegmentLength
    |   |           |-- OFMarkInt
    |   |           |-- OFMarker
    |   |           `-- TargetAlias

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_configfs.c |  181 +++++++++++++++++++++++++++++-
 drivers/lio-core/iscsi_target_core.h     |    1 +
 2 files changed, 177 insertions(+), 5 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_configfs.c b/drivers/lio-core/iscsi_target_configfs.c
index 7f89a49..016ebad 100644
--- a/drivers/lio-core/iscsi_target_configfs.c
+++ b/drivers/lio-core/iscsi_target_configfs.c
@@ -1375,8 +1375,11 @@ static struct config_group *lio_target_call_addnodetotpg (
 	if (!(tpg = core_get_tpg_from_iqn(config_item_name(tiqn_ci),
 				&tiqn, tpgt, 0)))
                 return(NULL);
-	
-#warning FIXME: cmdsn_depth set to ISCSI_TPG_ATTRIB(tpg)->default_cmdsn_depth
+	/*
+	 * ISCSI_TPG_ATTRIB(tpg)->default_cmdsn is used for the default.
+	 * This can be changed in either with or without an active session.
+	 * $FABRIC/$IQN/$TPGT/acl/$INITIATOR_IQN/cmdsn_depth
+	 */
 	cmdsn_depth = ISCSI_TPG_ATTRIB(tpg)->default_cmdsn_depth;
 
 	if (!(acl = iscsi_tpg_add_initiator_node_acl(tpg, name,
@@ -1586,6 +1589,7 @@ static struct configfs_attribute *lio_target_tpg_attrib_attrs[] = {
 	&iscsi_tpg_attrib_default_cmdsn_depth.attr,
 	&iscsi_tpg_attrib_cache_dynamic_acls.attr,
 	&iscsi_tpg_attrib_demo_mode_lun_access.attr,
+	NULL,
 };
 
 static struct configfs_item_operations lio_target_tpg_attrib_ops = {
@@ -1601,6 +1605,171 @@ static struct config_item_type lio_target_tpg_attrib_cit = {
 
 // End items for lio_target_tpg_attrib_cit
 
+// Start items for lio_target_tpg_param_cit
+
+#define DEF_TPG_PARAM(name)						\
+static ssize_t lio_target_show_tpg_param_##name (			\
+	struct iscsi_portal_group_s *tpg_p,				\
+	char *page)							\
+{									\
+	iscsi_portal_group_t *tpg;					\
+	iscsi_tiqn_t *tiqn;						\
+	iscsi_param_t *param;						\
+	ssize_t rb;							\
+									\
+	if (!(tpg = core_get_tpg_from_iqn(tpg_p->tpg_tiqn->tiqn,	\
+				&tiqn, tpg_p->tpgt, 0)))		\
+		return(-EINVAL);					\
+									\
+	if (!(param = iscsi_find_param_from_key(__stringify(name),	\
+				tpg->param_list))) {			\
+		iscsi_put_tpg(tpg);					\
+		return(-EINVAL);					\
+	}								\
+	rb = snprintf(page, PAGE_SIZE, "%s\n", param->value);		\ 
+									\
+	iscsi_put_tpg(tpg);						\
+	return(rb);							\
+}									\
+static ssize_t lio_target_store_tpg_param_##name (			\
+	struct iscsi_portal_group_s *tpg_p,				\
+	const char *page,						\
+	size_t count)							\
+{									\
+	iscsi_portal_group_t *tpg;					\
+	iscsi_tiqn_t *tiqn;						\
+	char *buf;							\
+	int ret;							\
+									\
+	if (!(buf = kzalloc(PAGE_SIZE, GFP_KERNEL)))			\
+		return(-ENOMEM);					\
+	snprintf(buf, PAGE_SIZE, "%s=%s", __stringify(name), page);	\
+	buf[strlen(buf)-1] = '\0'; /* Kill newline */			\
+									\
+	if (!(tpg = core_get_tpg_from_iqn(tpg_p->tpg_tiqn->tiqn,	\
+				&tiqn, tpg_p->tpgt, 0))) {		\
+		kfree(buf);						\
+		return(-EINVAL);					\
+	}								\
+	if ((ret = iscsi_change_param_value(buf, SENDER_TARGET,		\
+				tpg->param_list, 1)) < 0)		\
+		goto out;						\
+									\
+	kfree(buf);							\
+	iscsi_put_tpg(tpg);						\
+	return(count);							\
+out:									\
+	kfree(buf);							\
+	iscsi_put_tpg(tpg);						\
+	return(-EINVAL);						\
+}
+
+CONFIGFS_EATTR_STRUCT(iscsi_tpg_param, iscsi_portal_group_s);
+#define TPG_PARAM_ATTR(_name, _mode)					\
+static struct iscsi_tpg_param_attribute iscsi_tpg_param_##_name =	\
+	__CONFIGFS_EATTR(_name, _mode,					\
+		lio_target_show_tpg_param_##_name,			\
+		lio_target_store_tpg_param_##_name)
+
+DEF_TPG_PARAM(AuthMethod);
+TPG_PARAM_ATTR(AuthMethod, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(HeaderDigest);
+TPG_PARAM_ATTR(HeaderDigest, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(DataDigest);
+TPG_PARAM_ATTR(DataDigest, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(MaxConnections);
+TPG_PARAM_ATTR(MaxConnections, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(TargetAlias);
+TPG_PARAM_ATTR(TargetAlias, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(InitialR2T);
+TPG_PARAM_ATTR(InitialR2T, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(ImmediateData);
+TPG_PARAM_ATTR(ImmediateData, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(MaxRecvDataSegmentLength);
+TPG_PARAM_ATTR(MaxRecvDataSegmentLength, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(MaxBurstLength);
+TPG_PARAM_ATTR(MaxBurstLength, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(FirstBurstLength);
+TPG_PARAM_ATTR(FirstBurstLength, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(DefaultTime2Wait);
+TPG_PARAM_ATTR(DefaultTime2Wait, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(DefaultTime2Retain);
+TPG_PARAM_ATTR(DefaultTime2Retain, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(MaxOutstandingR2T);
+TPG_PARAM_ATTR(MaxOutstandingR2T, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(DataPDUInOrder);
+TPG_PARAM_ATTR(DataPDUInOrder, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(DataSequenceInOrder);
+TPG_PARAM_ATTR(DataSequenceInOrder, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(ErrorRecoveryLevel);
+TPG_PARAM_ATTR(ErrorRecoveryLevel, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(IFMarker);
+TPG_PARAM_ATTR(IFMarker, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(OFMarker);
+TPG_PARAM_ATTR(OFMarker, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(IFMarkInt);
+TPG_PARAM_ATTR(IFMarkInt, S_IRUGO | S_IWUSR);
+
+DEF_TPG_PARAM(OFMarkInt);
+TPG_PARAM_ATTR(OFMarkInt, S_IRUGO | S_IWUSR);
+
+CONFIGFS_EATTR_OPS(iscsi_tpg_param, iscsi_portal_group_s, tpg_param_group);
+
+static struct configfs_attribute *lio_target_tpg_param_attrs[] = {
+	&iscsi_tpg_param_AuthMethod.attr,
+	&iscsi_tpg_param_HeaderDigest.attr,
+	&iscsi_tpg_param_DataDigest.attr,
+	&iscsi_tpg_param_MaxConnections.attr,
+	&iscsi_tpg_param_TargetAlias.attr,
+	&iscsi_tpg_param_InitialR2T.attr,
+	&iscsi_tpg_param_ImmediateData.attr,
+	&iscsi_tpg_param_MaxRecvDataSegmentLength.attr,
+	&iscsi_tpg_param_MaxBurstLength.attr,
+	&iscsi_tpg_param_FirstBurstLength.attr,
+	&iscsi_tpg_param_DefaultTime2Wait.attr,
+	&iscsi_tpg_param_DefaultTime2Retain.attr,
+	&iscsi_tpg_param_MaxOutstandingR2T.attr,
+	&iscsi_tpg_param_DataPDUInOrder.attr,
+	&iscsi_tpg_param_DataSequenceInOrder.attr,
+	&iscsi_tpg_param_ErrorRecoveryLevel.attr,
+	&iscsi_tpg_param_IFMarker.attr,
+	&iscsi_tpg_param_OFMarker.attr,
+	&iscsi_tpg_param_IFMarkInt.attr,
+	&iscsi_tpg_param_OFMarkInt.attr,
+	NULL,
+};
+
+static struct configfs_item_operations lio_target_tpg_param_ops = {
+	.show_attribute		= iscsi_tpg_param_attr_show,
+	.store_attribute	= iscsi_tpg_param_attr_store,
+};
+
+static struct config_item_type lio_target_tpg_param_cit = {
+	.ct_item_ops	= &lio_target_tpg_param_ops,
+	.ct_attrs	= lio_target_tpg_param_attrs,
+	.ct_owner	= THIS_MODULE,
+};
+
+// End items for lio_target_tpg_param_cit
+
 // Start items for lio_target_tpg_cit
 
 static ssize_t lio_target_store_tpg_control (void *p, const char *page, size_t count)
@@ -1770,7 +1939,7 @@ static struct config_group *lio_target_tiqn_addtpg (
 	/*
 	 * Create default configfs groups for iscsi_portal_group_t..
 	 */
-	if (!(tpg_cg->default_groups = kzalloc(sizeof(struct config_group) * 5,
+	if (!(tpg_cg->default_groups = kzalloc(sizeof(struct config_group) * 6,
 			GFP_KERNEL)))
 		goto out;
 
@@ -1779,12 +1948,14 @@ static struct config_group *lio_target_tiqn_addtpg (
 	config_group_init_type_name(&tpg->tpg_np_group, "np", &lio_target_np_cit);
 	config_group_init_type_name(&tpg->tpg_lun_group, "lun", &lio_target_lun_cit);
 	config_group_init_type_name(&tpg->tpg_acl_group, "acls", &lio_target_acl_cit);
+	config_group_init_type_name(&tpg->tpg_param_group, "param", &lio_target_tpg_param_cit);
 	config_group_init_type_name(&tattr->tpg_attrib_group, "attrib", &lio_target_tpg_attrib_cit);
 	tpg_cg->default_groups[0] = &tpg->tpg_np_group;
 	tpg_cg->default_groups[1] = &tpg->tpg_lun_group;
 	tpg_cg->default_groups[2] = &tpg->tpg_acl_group;
-	tpg_cg->default_groups[3] = &tattr->tpg_attrib_group;	
-	tpg_cg->default_groups[4] = NULL;
+	tpg_cg->default_groups[3] = &tpg->tpg_param_group;
+	tpg_cg->default_groups[4] = &tattr->tpg_attrib_group;	
+	tpg_cg->default_groups[5] = NULL;
 
 	if ((ret = iscsi_tpg_add_portal_group(tiqn, tpg)) < 0)
 		goto out;
diff --git a/drivers/lio-core/iscsi_target_core.h b/drivers/lio-core/iscsi_target_core.h
index 2df1972..fea0597 100644
--- a/drivers/lio-core/iscsi_target_core.h
+++ b/drivers/lio-core/iscsi_target_core.h
@@ -1337,6 +1337,7 @@ typedef struct iscsi_portal_group_s {
 	struct config_group	tpg_np_group;
 	struct config_group	tpg_lun_group;
 	struct config_group	tpg_acl_group;
+	struct config_group	tpg_param_group;
 	struct config_group	tpg_group;
 	struct semaphore		tpg_access_sem;
 	struct semaphore		np_login_sem;
-- 
1.5.4.1



