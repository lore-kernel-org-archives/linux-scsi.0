From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [LIO-Target/ConfigFS]: Added support for iSCSI Initiator
	Node Attributes
Date: Tue, 14 Oct 2008 18:58:08 -0700
Message-ID: <1224035888.5556.111.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-034CpSzXlE2QCeF/VjP2"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:27702 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751054AbYJOB6M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Oct 2008 21:58:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>


--=-034CpSzXlE2QCeF/VjP2
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Added support for iSCSI Initiator Node attributes under
/sys/kernel/config/target/iscsi/$IQN/$TPGT/acls/$INITIATOR_IQN/attrib:

<SNIP>
    |-- iscsi
    |   |-- iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
    |   |   `-- tpgt_1
    |   |       |-- acls
    |   |       |   |-- iqn.1993-08.org.debian:01:2dadf92d0ef
    |   |       |   |   |-- attrib
    |   |       |   |   |   |-- dataout_timeout
    |   |       |   |   |   |-- dataout_timeout_retries
    |   |       |   |   |   |-- default_erl
    |   |       |   |   |   |-- nopin_response_timeout
    |   |       |   |   |   |-- nopin_timeout
    |   |       |   |   |   |-- random_datain_pdu_offsets
    |   |       |   |   |   |-- random_datain_seq_offsets
    |   |       |   |   |   `-- random_r2t_offsets
<SNIP>

These iSCSI initiator node attributes descriptions are currently defined in the
target-ctl manpage as 'setnodeattrib'.  There are upper hardcoded limits for
non-BOOLEAN values in drivers/lio-core/iscsi_target_core.h

Also, you will notice this patch is the first one that uses the CONFIGFS_ATTR_STRUCT(),
__CONFIGFS_ATTR() and CONFIGFS_ATTR_OPS() from include/linux/configfs.h for redunced
time to develop, less code, etc.  I will be converting some of the existing ones
(namely the TPG attribute patch from today) to use these provided macros.

Signed-off-by: Nicholas A. Bellinger
---
 drivers/lio-core/iscsi_target_configfs.c   |  167 ++++++++++++++++++++++++++--
 drivers/lio-core/iscsi_target_core.h       |    2 +
 drivers/lio-core/iscsi_target_ioctl.c      |    4 +
 drivers/lio-core/iscsi_target_nodeattrib.c |  118 ++++++--------------
 drivers/lio-core/iscsi_target_nodeattrib.h |    9 ++-
 drivers/lio-core/iscsi_target_tpg.c        |    3 +-
 drivers/lio-core/iscsi_target_tpg.h        |    2 +-
 7 files changed, 210 insertions(+), 95 deletions(-)

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commit;h=ceae11470d537dbaf10575f3238bb4fce81333ef


--=-034CpSzXlE2QCeF/VjP2
Content-Disposition: attachment; filename=0001-LIO-Target-ConfigFS-Added-support-for-iSCSI-Initi.patch
Content-Type: application/mbox; name=0001-LIO-Target-ConfigFS-Added-support-for-iSCSI-Initi.patch
Content-Transfer-Encoding: 7bit

>From ceae11470d537dbaf10575f3238bb4fce81333ef Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Tue, 14 Oct 2008 18:48:22 -0700
Subject: [PATCH] [LIO-Target/ConfigFS]: Added support for iSCSI Initiator Node Attributes

Added support for iSCSI Initiator Node attributes under
/sys/kernel/config/target/iscsi/$IQN/$TPGT/acls/$INITIATOR_IQN/attrib:

<SNIP>
    |-- iscsi
    |   |-- iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
    |   |   `-- tpgt_1
    |   |       |-- acls
    |   |       |   |-- iqn.1993-08.org.debian:01:2dadf92d0ef
    |   |       |   |   |-- attrib
    |   |       |   |   |   |-- dataout_timeout
    |   |       |   |   |   |-- dataout_timeout_retries
    |   |       |   |   |   |-- default_erl
    |   |       |   |   |   |-- nopin_response_timeout
    |   |       |   |   |   |-- nopin_timeout
    |   |       |   |   |   |-- random_datain_pdu_offsets
    |   |       |   |   |   |-- random_datain_seq_offsets
    |   |       |   |   |   `-- random_r2t_offsets
<SNIP>

These iSCSI initiator node attributes descriptions are currently defined in the
target-ctl manpage as 'setnodeattrib'.  There are upper hardcoded limits for
non-BOOLEAN values in drivers/lio-core/iscsi_target_core.h

Also, you will notice this patch is the first one that uses the CONFIGFS_ATTR_STRUCT(),
__CONFIGFS_ATTR() and CONFIGFS_ATTR_OPS() from include/linux/configfs.h for redunced
time to develop, less code, etc.  I will be converting some of the existing ones
(namely the TPG attribute patch from today) to use these provided macros.

Signed-off-by: Nicholas A. Bellinger
---
 drivers/lio-core/iscsi_target_configfs.c   |  167 ++++++++++++++++++++++++++--
 drivers/lio-core/iscsi_target_core.h       |    2 +
 drivers/lio-core/iscsi_target_ioctl.c      |    4 +
 drivers/lio-core/iscsi_target_nodeattrib.c |  118 ++++++--------------
 drivers/lio-core/iscsi_target_nodeattrib.h |    9 ++-
 drivers/lio-core/iscsi_target_tpg.c        |    3 +-
 drivers/lio-core/iscsi_target_tpg.h        |    2 +-
 7 files changed, 210 insertions(+), 95 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_configfs.c b/drivers/lio-core/iscsi_target_configfs.c
index 59303e2..c2b0eb6 100644
--- a/drivers/lio-core/iscsi_target_configfs.c
+++ b/drivers/lio-core/iscsi_target_configfs.c
@@ -43,6 +43,7 @@
 #include <iscsi_target_ioctl_defs.h>
 #include <iscsi_target_device.h>
 #include <iscsi_target_erl0.h>
+#include <iscsi_target_nodeattrib.h>
 #include <iscsi_target_tpg.h>
 #include <iscsi_target_util.h>
 #include <target_core_transport.h>
@@ -688,6 +689,138 @@ static struct config_item_type lio_target_lun_cit = {
 
 // End items for lio_target_lun_cit
 
+// Start items for lio_target_nacl_attrib_cit
+
+#define DEF_NACL_ATTRIB(name)						\
+static ssize_t lio_target_show_nacl_attrib_##name (			\
+	struct iscsi_node_attrib_s *na,					\
+	char *page)							\
+{									\
+	iscsi_node_acl_t *nacl = na->nacl;				\
+	ssize_t rb;							\
+									\
+	rb = sprintf(page, "%u\n", ISCSI_NODE_ATTRIB(nacl)->name);	\
+	return(rb);							\
+}									\
+									\
+static ssize_t lio_target_store_nacl_attrib_##name (			\
+	struct iscsi_node_attrib_s *na,					\
+	const char *page,						\
+	size_t count)							\
+{									\
+	iscsi_node_acl_t *nacl = na->nacl;				\
+	char *endptr;							\
+	u32 val;							\
+	int ret;							\
+									\
+	val = simple_strtoul(page, &endptr, 0);				\
+	if ((ret = iscsi_na_##name(nacl, val)) < 0)			\
+		return(ret);						\
+									\
+	return(count);							\
+}
+
+static struct iscsi_node_attrib_s *to_iscsi_node_attrib_s (struct config_item *item)
+{
+	return((item) ? container_of(to_config_group(item), struct iscsi_node_attrib_s,
+		acl_attrib_group) : NULL);
+}
+
+/*
+ * Define the iSCSI Node attributes using hybrid wrappers from include/linux/configfs.h
+ */
+CONFIGFS_ATTR_STRUCT(iscsi_node_attrib_s);
+#define NACL_ATTR(_name, _mode, _show, _store)					\
+static struct iscsi_node_attrib_s_attribute iscsi_node_attrib_s_##_name =	\
+		__CONFIGFS_ATTR(_name, _mode, _show, _store)
+/*
+ * Define iscsi_node_attrib_s_dataout_timeout
+ */
+DEF_NACL_ATTRIB(dataout_timeout);
+NACL_ATTR(dataout_timeout, S_IRUGO | S_IWUSR,
+	lio_target_show_nacl_attrib_dataout_timeout,
+	lio_target_store_nacl_attrib_dataout_timeout);
+/*
+ * Define iscsi_node_attrib_s_dataout_timeout_retries
+ */
+DEF_NACL_ATTRIB(dataout_timeout_retries);
+NACL_ATTR(dataout_timeout_retries, S_IRUGO | S_IWUSR,
+	lio_target_show_nacl_attrib_dataout_timeout_retries,
+	lio_target_store_nacl_attrib_dataout_timeout_retries);
+/*
+ * Define iscsi_node_attrib_s_default_erl
+ */
+DEF_NACL_ATTRIB(default_erl);
+NACL_ATTR(default_erl, S_IRUGO | S_IWUSR,
+	lio_target_show_nacl_attrib_default_erl,
+	lio_target_store_nacl_attrib_default_erl);
+/*
+ * Define iscsi_node_attrib_s_nopin_timeout
+ */
+DEF_NACL_ATTRIB(nopin_timeout);
+NACL_ATTR(nopin_timeout, S_IRUGO | S_IWUSR,
+	lio_target_show_nacl_attrib_nopin_timeout,
+	lio_target_store_nacl_attrib_nopin_timeout);
+/*
+ * Define iscsi_node_attrib_s_nopin_response_timeout
+ */
+DEF_NACL_ATTRIB(nopin_response_timeout);
+NACL_ATTR(nopin_response_timeout, S_IRUGO | S_IWUSR,
+	lio_target_show_nacl_attrib_nopin_response_timeout,
+	lio_target_store_nacl_attrib_nopin_response_timeout);
+/*
+ * Define iscsi_node_attrib_s_random_datain_pdu_offsets
+ */
+DEF_NACL_ATTRIB(random_datain_pdu_offsets);
+NACL_ATTR(random_datain_pdu_offsets, S_IRUGO | S_IWUSR,
+	lio_target_show_nacl_attrib_random_datain_pdu_offsets,
+	lio_target_store_nacl_attrib_random_datain_pdu_offsets);
+/*
+ * Define iscsi_node_attrib_s_random_datain_seq_offsets
+ */
+DEF_NACL_ATTRIB(random_datain_seq_offsets);
+NACL_ATTR(random_datain_seq_offsets, S_IRUGO | S_IWUSR,
+	lio_target_show_nacl_attrib_random_datain_seq_offsets,
+	lio_target_store_nacl_attrib_random_datain_seq_offsets);
+/*
+ * Define iscsi_node_attrib_s_random_r2t_offsets
+ */
+DEF_NACL_ATTRIB(random_r2t_offsets);
+NACL_ATTR(random_r2t_offsets, S_IRUGO | S_IWUSR,
+	lio_target_show_nacl_attrib_random_r2t_offsets,
+	lio_target_store_nacl_attrib_random_r2t_offsets);
+
+/*
+ * Finally, define functions iscsi_node_attrib_s_attr_show() and
+ * iscsi_node_attrib_s_attr_store() for lio_target_nacl_attrib_ops below..
+ */
+CONFIGFS_ATTR_OPS(iscsi_node_attrib_s);
+
+static struct configfs_attribute *lio_target_nacl_attrib_attrs[] = {
+	&iscsi_node_attrib_s_dataout_timeout.attr,
+	&iscsi_node_attrib_s_dataout_timeout_retries.attr,
+	&iscsi_node_attrib_s_default_erl.attr,
+	&iscsi_node_attrib_s_nopin_timeout.attr,
+	&iscsi_node_attrib_s_nopin_response_timeout.attr,
+	&iscsi_node_attrib_s_random_datain_pdu_offsets.attr,
+	&iscsi_node_attrib_s_random_datain_seq_offsets.attr,
+	&iscsi_node_attrib_s_random_r2t_offsets.attr,
+	NULL,
+};
+
+static struct configfs_item_operations lio_target_nacl_attrib_ops = {
+	.show_attribute		= iscsi_node_attrib_s_attr_show,
+	.store_attribute	= iscsi_node_attrib_s_attr_store,
+};
+
+static struct config_item_type lio_target_nacl_attrib_cit = {
+	.ct_item_ops	= &lio_target_nacl_attrib_ops,
+	.ct_attrs	= lio_target_nacl_attrib_attrs,
+	.ct_owner	= THIS_MODULE,
+};
+
+// End items for lio_target_nacl_attrib_cit
+
 // Start items for lio_target_initiator_cit
 
 static int lio_target_initiator_lacl_link (struct config_item *lun_acl_ci, struct config_item *lun_ci)
@@ -1216,8 +1349,10 @@ static struct config_group *lio_target_call_addnodetotpg (
 	const char *name)
 {
 	iscsi_node_acl_t *acl;
+	iscsi_node_attrib_t *nattr;
 	iscsi_portal_group_t *tpg;
 	iscsi_tiqn_t *tiqn;
+	struct config_group *nacl_cg;
 	struct config_item *acl_ci, *tpg_ci, *tiqn_ci;
 	u32 cmdsn_depth;
 	int ret = 0;
@@ -1251,13 +1386,27 @@ static struct config_group *lio_target_call_addnodetotpg (
 				cmdsn_depth, &ret)))
 		goto out;
 
+	nacl_cg = &acl->acl_group;
+	nattr = &acl->node_attrib;
+	/*
+	 * Create the default groups for iscsi_node_acl_t
+	 */
+	if (!(nacl_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
+			GFP_KERNEL)))
+		goto node_out;
+
 	config_group_init_type_name(&acl->acl_group, name, &lio_target_initiator_cit);
+	config_group_init_type_name(&nattr->acl_attrib_group, "attrib", &lio_target_nacl_attrib_cit);
+	nacl_cg->default_groups[0] = &nattr->acl_attrib_group;
+	nacl_cg->default_groups[1] = NULL;
 
 	printk("LIO_Target_ConfigFS: REGISTER -> %s TPGT: %hu Initiator: %s CmdSN Depth: %u\n",
 		config_item_name(tiqn_ci), tpgt, name, acl->queue_depth);
 
 	iscsi_put_tpg(tpg);
 	return(&acl->acl_group);
+node_out:
+	iscsi_tpg_del_initiator_node_acl(tpg, name, 1);
 out:
 	iscsi_put_tpg(tpg);
 	return(NULL);
@@ -1370,25 +1519,25 @@ out:									\
 	return(ret);							\
 }
 
-#define DEF_TPG_ATTRIB(name, string_name)						\
+#define DEF_TPG_ATTRIB(name)						\
 	SHOW_TPG_ATTRIB(name)						\
 	STORE_TPG_ATTRIB(name)						\
 									\
 static struct lio_target_configfs_attribute lio_target_attr_tpg_##name = { \
 	.attr	= { .ca_owner = THIS_MODULE,				\
-		    .ca_name = string_name,				\
+		    .ca_name = __stringify(name),			\
 		    .ca_mode =  S_IRUGO | S_IWUSR },			\
 	.show	= lio_target_show_tpg_attrib_##name,			\
 	.store	= lio_target_store_tpg_attrib_##name,			\
 };
 
-DEF_TPG_ATTRIB(authentication, "authentication");
-DEF_TPG_ATTRIB(login_timeout, "login_timeout");
-DEF_TPG_ATTRIB(netif_timeout, "netif_timeout");
-DEF_TPG_ATTRIB(generate_node_acls, "generate_node_acls");
-DEF_TPG_ATTRIB(default_cmdsn_depth, "default_cmdsn_depth");
-DEF_TPG_ATTRIB(cache_dynamic_acls, "cache_dynamic_acls");
-DEF_TPG_ATTRIB(demo_mode_lun_access, "demo_mode_lun_access");
+DEF_TPG_ATTRIB(authentication);
+DEF_TPG_ATTRIB(login_timeout);
+DEF_TPG_ATTRIB(netif_timeout);
+DEF_TPG_ATTRIB(generate_node_acls);
+DEF_TPG_ATTRIB(default_cmdsn_depth);
+DEF_TPG_ATTRIB(cache_dynamic_acls);
+DEF_TPG_ATTRIB(demo_mode_lun_access);
 
 static struct configfs_attribute *lio_target_tpg_attrib_attrs[] = {
 	&lio_target_attr_tpg_authentication.attr,
diff --git a/drivers/lio-core/iscsi_target_core.h b/drivers/lio-core/iscsi_target_core.h
index fd9af36..623f023 100644
--- a/drivers/lio-core/iscsi_target_core.h
+++ b/drivers/lio-core/iscsi_target_core.h
@@ -1188,6 +1188,8 @@ typedef struct iscsi_node_attrib_s {
 	__u32			random_r2t_offsets;
 	__u32			tmr_cold_reset;
 	__u32			tmr_warm_reset;
+	struct iscsi_node_acl_s *nacl;
+	struct config_group	acl_attrib_group;
 } ____cacheline_aligned iscsi_node_attrib_t;
 
 typedef struct iscsi_node_acl_s {
diff --git a/drivers/lio-core/iscsi_target_ioctl.c b/drivers/lio-core/iscsi_target_ioctl.c
index 8b9c452..51b82a1 100644
--- a/drivers/lio-core/iscsi_target_ioctl.c
+++ b/drivers/lio-core/iscsi_target_ioctl.c
@@ -719,6 +719,7 @@ extern int iscsi_ioctl (
 #else
 	goto dumpout;
 #endif
+#if 0
 	case ISCSI_TARGET_SETNODEATTRIB:
 	  if (!(tpg = core_get_tpg_from_iqn(t->targetname, &tiqn, t->tpgt, 0))) {
 		  ret = ERR_TPG_DOES_NOT_EXIST;
@@ -730,6 +731,9 @@ extern int iscsi_ioctl (
 		  goto dumpout;
 	  }
 	  iscsi_put_tpg(tpg);
+#else
+	goto dumpout;
+#endif
 	  break;
 	case ISCSI_TARGET_DEBUG_ERL:
 #ifdef DEBUG_ERL
diff --git a/drivers/lio-core/iscsi_target_nodeattrib.c b/drivers/lio-core/iscsi_target_nodeattrib.c
index cce3f74..db275da 100644
--- a/drivers/lio-core/iscsi_target_nodeattrib.c
+++ b/drivers/lio-core/iscsi_target_nodeattrib.c
@@ -75,13 +75,13 @@ extern void iscsi_set_default_node_attribues (
 	return;
 }
 
-/*	iscsi_na_set_dataout_timeout():
+/*	iscsi_na_dataout_timeout():
  *
  *
  */
-static int iscsi_na_set_dataout_timeout (
+extern int iscsi_na_dataout_timeout (
 	iscsi_node_acl_t *acl,
-	__u32 dataout_timeout)
+	u32 dataout_timeout)
 {
 	iscsi_node_attrib_t *a = &acl->node_attrib;
 	
@@ -90,11 +90,11 @@ static int iscsi_na_set_dataout_timeout (
 	if (dataout_timeout > NA_DATAOUT_TIMEOUT_MAX) {
 		TRACE_ERROR("Requested DataOut Timeout %u larger than maximum"
 			" %u\n", dataout_timeout, NA_DATAOUT_TIMEOUT_MAX);
-		return(ERR_NODEATTRIB_TOO_LARGE);
+		return(-EINVAL);
 	} else if (dataout_timeout < NA_DATAOUT_TIMEOUT_MIX) {
 		TRACE_ERROR("Requested DataOut Timeout %u smaller than minimum"
 			" %u\n", dataout_timeout, NA_DATAOUT_TIMEOUT_MIX);
-		return(ERR_NODEATTRIB_TOO_SMALL);
+		return(-EINVAL);
 	}
 
 	a->dataout_timeout = dataout_timeout;
@@ -105,13 +105,13 @@ static int iscsi_na_set_dataout_timeout (
 	return(0);
 }
 
-/*	iscsi_na_set_dataout_timeout_retries():
+/*	iscsi_na_dataout_timeout_retries():
  *
  *
  */
-static int iscsi_na_set_dataout_timeout_retries (
+extern int iscsi_na_dataout_timeout_retries (
 	iscsi_node_acl_t *acl,
-	__u32 dataout_timeout_retries)
+	u32 dataout_timeout_retries)
 {
 	iscsi_node_attrib_t *a = &acl->node_attrib;
 	
@@ -121,12 +121,12 @@ static int iscsi_na_set_dataout_timeout_retries (
 		TRACE_ERROR("Requested DataOut Timeout Retries %u larger than"
 			" maximum %u", dataout_timeout_retries,
 				NA_DATAOUT_TIMEOUT_RETRIES_MAX);
-		return(ERR_NODEATTRIB_TOO_LARGE);
+		return(-EINVAL);
 	} else if (dataout_timeout_retries < NA_DATAOUT_TIMEOUT_RETRIES_MIN) {
 		TRACE_ERROR("Requested DataOut Timeout Retries %u smaller than"
 			" minimum %u", dataout_timeout_retries,
 				NA_DATAOUT_TIMEOUT_RETRIES_MIN);
-		return(ERR_NODEATTRIB_TOO_SMALL);
+		return(-EINVAL);
 	}
 
 	a->dataout_timeout_retries = dataout_timeout_retries;
@@ -137,13 +137,13 @@ static int iscsi_na_set_dataout_timeout_retries (
 	return(0);
 }
 
-/*	iscsi_na_set_nopin_timeout():
+/*	iscsi_na_nopin_timeout():
  *
  *
  */
-static int iscsi_na_set_nopin_timeout (
+extern int iscsi_na_nopin_timeout (
 	iscsi_node_acl_t *acl,
-	__u32 nopin_timeout)
+	u32 nopin_timeout)
 {
 	iscsi_node_attrib_t *a = &acl->node_attrib;
 
@@ -152,11 +152,11 @@ static int iscsi_na_set_nopin_timeout (
 	if (nopin_timeout > NA_NOPIN_TIMEOUT_MAX) {
 		TRACE_ERROR("Requested NopIn Timeout %u larger than maximum"
 			" %u\n", nopin_timeout, NA_NOPIN_TIMEOUT_MAX);
-		return(ERR_NODEATTRIB_TOO_LARGE);
+		return(-EINVAL);
 	} else if (nopin_timeout < NA_NOPIN_TIMEOUT_MIN) {
 		TRACE_ERROR("Requested NopIn Timeout %u smaller than minimum"
 			" %u\n", nopin_timeout, NA_NOPIN_TIMEOUT_MIN);
-		return(ERR_NODEATTRIB_TOO_SMALL);
+		return(-EINVAL);
 	}
 
 	a->nopin_timeout = nopin_timeout;
@@ -167,13 +167,13 @@ static int iscsi_na_set_nopin_timeout (
 	return(0);
 }
 
-/*	iscsi_na_set_nopin_response_timeout():
+/*	iscsi_na_nopin_response_timeout():
  *
  *
  */
-static int iscsi_na_set_nopin_response_timeout (
+extern int iscsi_na_nopin_response_timeout (
 	iscsi_node_acl_t *acl,
-	__u32 nopin_response_timeout)
+	u32 nopin_response_timeout)
 {
 	iscsi_node_attrib_t *a = &acl->node_attrib;
 
@@ -183,12 +183,12 @@ static int iscsi_na_set_nopin_response_timeout (
 		TRACE_ERROR("Requested NopIn Response Timeout %u larger than"
 			" maximum %u\n", nopin_response_timeout,
 				NA_NOPIN_RESPONSE_TIMEOUT_MAX);
-		return(ERR_NODEATTRIB_TOO_LARGE);
+		return(-EINVAL);
 	} else if (nopin_response_timeout < NA_NOPIN_RESPONSE_TIMEOUT_MIN) {
 		TRACE_ERROR("Requested NopIn Response Timeout %u smaller than"
 			" minimum %u\n", nopin_response_timeout,
 				NA_NOPIN_RESPONSE_TIMEOUT_MIN);
-		return(ERR_NODEATTRIB_TOO_SMALL);
+		return(-EINVAL);
 	}
 
 	a->nopin_response_timeout = nopin_response_timeout;
@@ -199,13 +199,13 @@ static int iscsi_na_set_nopin_response_timeout (
 	return(0);
 }
 
-/*	iscsi_na_set_random_datain_pdu_offsets():
+/*	iscsi_na_random_datain_pdu_offsets():
  *
  *
  */
-static int iscsi_na_set_random_datain_pdu_offsets (
+extern int iscsi_na_random_datain_pdu_offsets (
 	iscsi_node_acl_t *acl,
-	__u32 random_datain_pdu_offsets)
+	u32 random_datain_pdu_offsets)
 {
 	iscsi_node_attrib_t *a = &acl->node_attrib;
 
@@ -214,7 +214,7 @@ static int iscsi_na_set_random_datain_pdu_offsets (
 	if (random_datain_pdu_offsets != 0 && random_datain_pdu_offsets != 1) {
 		TRACE_ERROR("Requested Random DataIN PDU Offsets: %u not"
 			" 0 or 1\n", random_datain_pdu_offsets);
-		return(ERR_NODEATTRIB_BOOLEAN_ONLY);
+		return(-EINVAL);
 	}
 
 	a->random_datain_pdu_offsets = random_datain_pdu_offsets;
@@ -226,13 +226,13 @@ static int iscsi_na_set_random_datain_pdu_offsets (
 	return(0);
 }
 
-/*	iscsi_na_set_random_datain_seq_offsets():
+/*	iscsi_na_random_datain_seq_offsets():
  *
  *
  */
-static int iscsi_na_set_random_datain_seq_offsets (
+extern int iscsi_na_random_datain_seq_offsets (
 	iscsi_node_acl_t *acl,
-	__u32 random_datain_seq_offsets)
+	u32 random_datain_seq_offsets)
 {
 	iscsi_node_attrib_t *a = &acl->node_attrib;
 
@@ -241,7 +241,7 @@ static int iscsi_na_set_random_datain_seq_offsets (
 	if (random_datain_seq_offsets != 0 && random_datain_seq_offsets != 1) {
 		TRACE_ERROR("Requested Random DataIN Sequence Offsets: %u not"
 			" 0 or 1\n", random_datain_seq_offsets);
-		return(ERR_NODEATTRIB_BOOLEAN_ONLY);
+		return(-EINVAL);
 	}
 
 	a->random_datain_seq_offsets = random_datain_seq_offsets;
@@ -253,13 +253,13 @@ static int iscsi_na_set_random_datain_seq_offsets (
 	return(0);
 }
 
-/*	iscsi_na_set_random_r2t_offsets():
+/*	iscsi_na_random_r2t_offsets():
  *
  *
  */
-static int iscsi_na_set_random_r2t_offsets (
+extern int iscsi_na_random_r2t_offsets (
 	iscsi_node_acl_t *acl,
-	__u32 random_r2t_offsets)
+	u32 random_r2t_offsets)
 {
 	iscsi_node_attrib_t *a = &acl->node_attrib;
 
@@ -268,7 +268,7 @@ static int iscsi_na_set_random_r2t_offsets (
 	if (random_r2t_offsets != 0 && random_r2t_offsets != 1) {
 		TRACE_ERROR("Requested Random R2T Offsets: %u not"
 			" 0 or 1\n", random_r2t_offsets);
-		return(ERR_NODEATTRIB_BOOLEAN_ONLY);
+		return(-EINVAL);
 	}
 
 	a->random_r2t_offsets = random_r2t_offsets;
@@ -280,16 +280,16 @@ static int iscsi_na_set_random_r2t_offsets (
 	return(0);
 }
 
-static int iscsi_na_set_default_erl (
+extern int iscsi_na_default_erl (
 	iscsi_node_acl_t *acl,
-	__u32 default_erl)
+	u32 default_erl)
 {
 	iscsi_node_attrib_t *a = &acl->node_attrib;
 	
 	if (default_erl != 0 && default_erl != 1 && default_erl != 2) {
 		TRACE_ERROR("Requested default ERL: %u not 0, 1, or 2\n",
 				default_erl);
-		return(ERR_NODEATTRIB_BOOLEAN_ONLY);
+		return(-EINVAL);
 	}
 
 	a->default_erl = default_erl;
@@ -298,51 +298,3 @@ static int iscsi_na_set_default_erl (
 	
 	return(0);
 }
-
-/*	iscsi_set_initiator_node_attribute():
- *
- *
- */
-extern int iscsi_set_initiator_node_attribute (
-	iscsi_portal_group_t *tpg,
-	unsigned char *initiatorname,
-	__u32 nattrib,
-	__u32 nattrib_value)
-{
-	iscsi_node_acl_t *acl;
-	
-	TRACE_ENTER
-
-	if (!(acl = iscsi_tpg_get_initiator_node_acl(tpg, initiatorname))) {
-		TRACE_ERROR("Access Control List Entry for iSCSI Initiator"
-			" Node %s does not exists for TPG %hu, ignoring"
-			" request.\n", initiatorname, tpg->tpgt);
-		return(ERR_NODEATTRIB_INITIATOR_DOES_NOT_EXIST);
-	}
-		
-	switch (nattrib) {
-	case NA_SET_DATAOUT_TIMEOUT:
-		return(iscsi_na_set_dataout_timeout(acl, nattrib_value));
-	case NA_SET_DATAOUT_TIMEOUT_RETRIES:
-		return(iscsi_na_set_dataout_timeout_retries(acl, nattrib_value));
-	case NA_SET_NOPIN_TIMEOUT:
-		return(iscsi_na_set_nopin_timeout(acl, nattrib_value));
-	case NA_SET_NOPIN_RESPONSE_TIMEOUT:
-		return(iscsi_na_set_nopin_response_timeout(acl, nattrib_value));
-	case NA_SET_RANDOM_DATAIN_PDU_OFFSETS:
-		return(iscsi_na_set_random_datain_pdu_offsets(acl, nattrib_value));
-	case NA_SET_RANDOM_DATAIN_SEQ_OFFSETS:
-		return(iscsi_na_set_random_datain_seq_offsets(acl, nattrib_value));
-	case NA_SET_RANDOM_R2T_OFFSETS:
-		return(iscsi_na_set_random_r2t_offsets(acl, nattrib_value));
-	case NA_SET_DEFAULT_ERL:
-		return(iscsi_na_set_default_erl(acl, nattrib_value));
-	default:
-		TRACE_ERROR("Unknown Initiator Node Attribute: %u\n",
-				nattrib_value);
-		return(ERR_NODEATTRIB_UNKNOWN_ATTRIB);
-	}
-
-	TRACE_LEAVE
-	return(0);
-}
diff --git a/drivers/lio-core/iscsi_target_nodeattrib.h b/drivers/lio-core/iscsi_target_nodeattrib.h
index 556e598..4f21ce4 100644
--- a/drivers/lio-core/iscsi_target_nodeattrib.h
+++ b/drivers/lio-core/iscsi_target_nodeattrib.h
@@ -30,6 +30,13 @@
 #define ISCSI_TARGET_NODEATTRIB_H
 
 extern void iscsi_set_default_node_attribues (iscsi_node_acl_t *);
-extern int iscsi_set_initiator_node_attribute (iscsi_portal_group_t *, unsigned char *, __u32, __u32);
+extern int iscsi_na_dataout_timeout (iscsi_node_acl_t *, u32);
+extern int iscsi_na_dataout_timeout_retries (iscsi_node_acl_t *, u32);
+extern int iscsi_na_nopin_timeout (iscsi_node_acl_t *, u32);
+extern int iscsi_na_nopin_response_timeout (iscsi_node_acl_t *, u32);
+extern int iscsi_na_random_datain_pdu_offsets (iscsi_node_acl_t *, u32);
+extern int iscsi_na_random_datain_seq_offsets (iscsi_node_acl_t *, u32);
+extern int iscsi_na_random_r2t_offsets (iscsi_node_acl_t *, u32);
+extern int iscsi_na_default_erl (iscsi_node_acl_t *, u32);
 
 #endif /* ISCSI_TARGET_NODEATTRIB_H */
diff --git a/drivers/lio-core/iscsi_target_tpg.c b/drivers/lio-core/iscsi_target_tpg.c
index 9d13547..598825d 100644
--- a/drivers/lio-core/iscsi_target_tpg.c
+++ b/drivers/lio-core/iscsi_target_tpg.c
@@ -883,6 +883,7 @@ extern iscsi_node_acl_t *iscsi_tpg_add_initiator_node_acl (
 	acl->queue_depth = queue_depth;
 	snprintf(acl->initiatorname, ISCSI_IQN_LEN, "%s", initiatorname);
 	acl->tpg = tpg;
+	ISCSI_NODE_ATTRIB(acl)->nacl = acl;
 #ifdef SNMP_SUPPORT
 	acl->acl_index = scsi_get_new_index(SCSI_AUTH_INTR_INDEX);
 	spin_lock_init(&acl->stats_lock);
@@ -921,7 +922,7 @@ done:
  */
 extern int iscsi_tpg_del_initiator_node_acl (
 	iscsi_portal_group_t *tpg,
-	unsigned char *initiatorname,
+	const char *initiatorname,
 	int force)
 {
 	int dynamic_acl = 0;
diff --git a/drivers/lio-core/iscsi_target_tpg.h b/drivers/lio-core/iscsi_target_tpg.h
index 5cc43bb..fe93538 100644
--- a/drivers/lio-core/iscsi_target_tpg.h
+++ b/drivers/lio-core/iscsi_target_tpg.h
@@ -46,7 +46,7 @@ extern int iscsi_tpg_del_portal_group (iscsi_tiqn_t *, iscsi_portal_group_t *, i
 extern int iscsi_tpg_enable_portal_group (iscsi_portal_group_t *);
 extern int iscsi_tpg_disable_portal_group (iscsi_portal_group_t *, int);
 extern iscsi_node_acl_t *iscsi_tpg_add_initiator_node_acl (iscsi_portal_group_t *, const char *, __u32, int *);
-extern int iscsi_tpg_del_initiator_node_acl (iscsi_portal_group_t *, unsigned char *, int);
+extern int iscsi_tpg_del_initiator_node_acl (iscsi_portal_group_t *, const char *, int);
 extern void iscsi_tpg_del_external_nps (iscsi_tpg_np_t *);
 extern iscsi_tpg_np_t *iscsi_tpg_locate_child_np (iscsi_tpg_np_t *, int);
 extern iscsi_tpg_np_t *iscsi_tpg_add_network_portal (iscsi_portal_group_t *, iscsi_np_addr_t *, iscsi_tpg_np_t *, int);
-- 
1.5.4.1


--=-034CpSzXlE2QCeF/VjP2--

