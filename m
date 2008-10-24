From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [LIO-Target/ConfigFS]: Added iSCSI Initiator Node ACL
	READ-ONLY Parameters
Date: Thu, 23 Oct 2008 18:06:13 -0700
Message-ID: <1224810373.16558.13.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:36682 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751597AbYJXBGR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Oct 2008 21:06:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mike Christie <mchristie@redhat.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Alasdair G Kergon <agk@redhat.com>, Ming Zhang <blackmagic02881@gmail.com>, "Ross S. W. Walker" <rswwalker@gmail.com>, Arne Redlich <agr@powerkom-dd.de>

>From 836f7a0174727bc9d39619d01c24f0d8048f8a7d Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 23 Oct 2008 06:59:20 -0700
Subject: [PATCH] [LIO-Target/ConfigFS]: Added iSCSI Initiator Node ACL READ-ONLY Parameters

Added static struct config_item_type lio_target_nacl_param_cit that lives under

/sys/kernel/config/target/iscsi/$TIQN/$TPGT/acl/$INITIATOR_ACL/param

These configfs attributes are READ-ONLY and are the parameters defined as
having a "session wide" scope.  These parameters represent the iSCSI Nexus
(eg: Session) context's parameters.

For Traditional iSCSI (RFC-3260) there is only "TargetAlias" parameter that is
 legal to be exchanged after during iSCSI full feature phase from iSCSI Target
side's perspective in a "session wide" scope.

Sending "TargetAlias"  while the iSCSI SessionType=Normal nexus is active is
on the TODO list, and the current configfs attrib is to do with LIO-Target is:

/sys/kernel/config/target/iscsi/$IQN/$TPGT/param/TargetAlias

Signed-off-by: Nicholas A. Bellinger
---
 drivers/lio-core/iscsi_target_configfs.c |  100 +++++++++++++++++++++++++++++-
 drivers/lio-core/iscsi_target_core.h     |    1 +
 2 files changed, 98 insertions(+), 3 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_configfs.c b/drivers/lio-core/iscsi_target_configfs.c
index 016ebad..fa3b6a0 100644
--- a/drivers/lio-core/iscsi_target_configfs.c
+++ b/drivers/lio-core/iscsi_target_configfs.c
@@ -818,6 +818,98 @@ static struct config_item_type lio_target_nacl_attrib_cit = {
 
 // End items for lio_target_nacl_attrib_cit
 
+// Start items for lio_target_nacl_param_cit
+
+#define DEF_NACL_PARAM(name)						\
+static ssize_t lio_target_show_nacl_param_##name (			\
+	struct iscsi_node_acl_s *nacl,					\
+	char *page)							\
+{									\
+	iscsi_session_t *sess;						\
+	ssize_t rb;							\
+									\
+	spin_lock_bh(&nacl->nacl_sess_lock);				\
+	if (!(sess = nacl->nacl_sess)) {				\
+		rb = snprintf(page, PAGE_SIZE,				\
+			"No Active iSCSI Session\n");			\
+	} else {							\
+		rb = snprintf(page, PAGE_SIZE, "%u\n",			\
+			(u32)SESS_OPS(sess)->name);			\
+	}								\
+	spin_unlock_bh(&nacl->nacl_sess_lock);				\
+									\
+	return(rb);							\
+}
+
+CONFIGFS_EATTR_STRUCT(iscsi_nacl_param, iscsi_node_acl_s);
+#define NACL_PARAM_ATTR(_name)						\
+static struct iscsi_nacl_param_attribute iscsi_nacl_param_##_name =	\
+                __CONFIGFS_EATTR_RO(_name,				\
+		lio_target_show_nacl_param_##_name);			\
+
+DEF_NACL_PARAM(MaxConnections);
+NACL_PARAM_ATTR(MaxConnections);
+
+DEF_NACL_PARAM(InitialR2T);
+NACL_PARAM_ATTR(InitialR2T);
+
+DEF_NACL_PARAM(ImmediateData);
+NACL_PARAM_ATTR(ImmediateData);
+
+DEF_NACL_PARAM(MaxBurstLength);
+NACL_PARAM_ATTR(MaxBurstLength);
+
+DEF_NACL_PARAM(FirstBurstLength);
+NACL_PARAM_ATTR(FirstBurstLength);
+
+DEF_NACL_PARAM(DefaultTime2Wait);
+NACL_PARAM_ATTR(DefaultTime2Wait);
+
+DEF_NACL_PARAM(DefaultTime2Retain);
+NACL_PARAM_ATTR(DefaultTime2Retain);
+
+DEF_NACL_PARAM(MaxOutstandingR2T);
+NACL_PARAM_ATTR(MaxOutstandingR2T);
+
+DEF_NACL_PARAM(DataPDUInOrder);
+NACL_PARAM_ATTR(DataPDUInOrder);
+
+DEF_NACL_PARAM(DataSequenceInOrder);
+NACL_PARAM_ATTR(DataSequenceInOrder);
+
+DEF_NACL_PARAM(ErrorRecoveryLevel);
+NACL_PARAM_ATTR(ErrorRecoveryLevel);
+
+CONFIGFS_EATTR_OPS_RO(iscsi_nacl_param, iscsi_node_acl_s, acl_param_group);
+
+static struct configfs_attribute *lio_target_nacl_param_attrs[] = {
+	&iscsi_nacl_param_MaxConnections.attr,
+	&iscsi_nacl_param_InitialR2T.attr,
+	&iscsi_nacl_param_ImmediateData.attr,
+	&iscsi_nacl_param_MaxBurstLength.attr,
+	&iscsi_nacl_param_FirstBurstLength.attr,
+	&iscsi_nacl_param_DefaultTime2Wait.attr,
+	&iscsi_nacl_param_DefaultTime2Retain.attr,
+	&iscsi_nacl_param_MaxOutstandingR2T.attr,
+	&iscsi_nacl_param_DataPDUInOrder.attr,
+	&iscsi_nacl_param_DataSequenceInOrder.attr,
+	&iscsi_nacl_param_ErrorRecoveryLevel.attr,
+	NULL,
+};
+
+static struct configfs_item_operations lio_target_nacl_param_ops = {
+	.show_attribute		= iscsi_nacl_param_attr_show,
+	.store_attribute	= NULL,
+};
+
+static struct config_item_type lio_target_nacl_param_cit = {
+	.ct_item_ops	= &lio_target_nacl_param_ops,
+	.ct_attrs	= lio_target_nacl_param_attrs,
+	.ct_owner	= THIS_MODULE,
+};
+
+// End items for lio_target_nacl_param_cit
+
 // Start items for lio_target_initiator_cit
 
 static int lio_target_initiator_lacl_link (struct config_item *lun_acl_ci, struct config_item *lun_ci)
@@ -1391,14 +1483,16 @@ static struct config_group *lio_target_call_addnodetotpg (
 	/*
 	 * Create the default groups for iscsi_node_acl_t
 	 */
-	if (!(nacl_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
+	if (!(nacl_cg->default_groups = kzalloc(sizeof(struct config_group) * 3,
 			GFP_KERNEL)))
 		goto node_out;
 
 	config_group_init_type_name(&acl->acl_group, name, &lio_target_initiator_cit);
+	config_group_init_type_name(&acl->acl_param_group, "param", &lio_target_nacl_param_cit);
 	config_group_init_type_name(&nattr->acl_attrib_group, "attrib", &lio_target_nacl_attrib_cit);
-	nacl_cg->default_groups[0] = &nattr->acl_attrib_group;
-	nacl_cg->default_groups[1] = NULL;
+	nacl_cg->default_groups[0] = &acl->acl_param_group;
+	nacl_cg->default_groups[1] = &nattr->acl_attrib_group;
+	nacl_cg->default_groups[2] = NULL;
 
 	printk("LIO_Target_ConfigFS: REGISTER -> %s TPGT: %hu Initiator: %s CmdSN Depth: %u\n",
 		config_item_name(tiqn_ci), tpgt, name, acl->queue_depth);
diff --git a/drivers/lio-core/iscsi_target_core.h b/drivers/lio-core/iscsi_target_core.h
index fea0597..1324de7 100644
--- a/drivers/lio-core/iscsi_target_core.h
+++ b/drivers/lio-core/iscsi_target_core.h
@@ -1209,6 +1209,7 @@ typedef struct iscsi_node_acl_s {
 	iscsi_node_attrib_t	node_attrib;
 	iscsi_session_t		*nacl_sess;
 	struct config_group	acl_group;
+	struct config_group	acl_param_group;
 	struct iscsi_portal_group_s *tpg;
 	struct iscsi_node_acl_s	*next;
 	struct iscsi_node_acl_s	*prev;
-- 
1.5.4.1



