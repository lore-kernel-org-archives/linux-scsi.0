From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [TCM]: Initial code for tcm_qla2xxx module using v4 configfs fabric infrastructure
Date: Sat, 29 May 2010 18:20:13 -0700
Message-ID: <1275182413-5168-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp108.sbc.mail.gq1.yahoo.com ([67.195.14.111]:34535 "HELO
	smtp108.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757272Ab0E3BUQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2010 21:20:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Smart <james.smart@emulex.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Christoph Hellwig <hch@lst.de>, Joe Eykholt <jeykholt@cisco.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

This commit adds initial support for a tcm_qla2xx fabric module using the new
TCM v4 generic configfs fabric infrastructure and high level fabric ops.  This includes
the main struct target_core_fabric_ops API callers mapped to the following tcm_qla2xxx_configfs.c
code and structures:

        .fabric_make_wwn -> tcm_qla2xxx_make_lport() with struct tcm_qla2xxx_lport
        .fabric_drop_wwn -> tcm_qla2xxx_drop_lport() with struct tcm_qla2xxx_lport
        .fabric_make_tpg -> tcm_qla2xxx_make_tpg() with struct tcm_qla2xxx_tpg
        .fabric_drop_tpg -> tcm_qla2xxx_drop_tpg() with struct tcm_qla2xxx_tpg
        .fabric_make_nodeacl -> tcm_qla2xxx_make_nodeacl() with struct tcm_qla2xxx_nacl
        .fabric_drop_nodeacl -> tcm_qla2xxx_drop_nodeacl() with struct tcm_qla2xxx_nacl

All of the generic configfs fabric intrastructure is up and running.

Note that the I_T Nexus and I/O related fabric API functions have been added as NOPs
for the moment, and this code is intended to be a starting point for the bringup of QLA2xxx
series HBAs with TCM v4.  Eventually the patch for enabling this upstream drivers/scsi/qla2xxx/
will be added into lio-core-2.6.git/tcm_qla2xxx as community interest dictates.

Also note that the Open-FCoE.org lport and nport WWPN formatting and parsing routines
have been added from tcm_fc.  Eventually these need to become part of libfc.

Best,

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/Kbuild                             |    1 +
 drivers/target/Kconfig                            |    1 +
 drivers/target/tcm_qla2xxx/Kbuild                 |    6 +
 drivers/target/tcm_qla2xxx/Kconfig                |    6 +
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h     |   32 ++
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c |  330 ++++++++++++++++++
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c   |  368 +++++++++++++++++++++
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.h   |   42 +++
 8 files changed, 786 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/tcm_qla2xxx/Kbuild
 create mode 100644 drivers/target/tcm_qla2xxx/Kconfig
 create mode 100644 drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h
 create mode 100644 drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c
 create mode 100644 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c
 create mode 100644 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.h

diff --git a/drivers/target/Kbuild b/drivers/target/Kbuild
index 5298d6a..373f61c 100644
--- a/drivers/target/Kbuild
+++ b/drivers/target/Kbuild
@@ -59,3 +59,4 @@ obj-$(CONFIG_LIO_TARGET)	+= lio-target/
 obj-$(CONFIG_TCM_LOOP_FABRIC)	+= tcm_loop/
 
 obj-$(CONFIG_TCM_FC)		+= tcm_fc/
+obj-$(CONFIG_TCM_QLA2XXX)	+= tcm_qla2xxx/
diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
index 95f2c2c..6d69e57 100644
--- a/drivers/target/Kconfig
+++ b/drivers/target/Kconfig
@@ -65,3 +65,4 @@ config TCM_DEBUG_DEV
 source "drivers/target/tcm_loop/Kconfig"
 source "drivers/target/lio-target/Kconfig"
 source "drivers/target/tcm_fc/Kconfig"
+source "drivers/target/tcm_qla2xxx/Kconfig"
diff --git a/drivers/target/tcm_qla2xxx/Kbuild b/drivers/target/tcm_qla2xxx/Kbuild
new file mode 100644
index 0000000..a527461
--- /dev/null
+++ b/drivers/target/tcm_qla2xxx/Kbuild
@@ -0,0 +1,6 @@
+EXTRA_CFLAGS += -I$(srctree)/drivers/target/ -I$(srctree)/drivers/scsi/ -I$(srctree)/include/scsi/ -I$(srctree)/drivers/target/tcm_qla2xxx
+
+tcm_qla2xxx-objs		:= tcm_qla2xxx_fabric.o \
+				   tcm_qla2xxx_configfs.o \
+
+obj-$(CONFIG_TCM_QLA2XXX)	+= tcm_qla2xxx.o
diff --git a/drivers/target/tcm_qla2xxx/Kconfig b/drivers/target/tcm_qla2xxx/Kconfig
new file mode 100644
index 0000000..027cb8f
--- /dev/null
+++ b/drivers/target/tcm_qla2xxx/Kconfig
@@ -0,0 +1,6 @@
+config TCM_QLA2XXX
+	tristate "TCM_QLA2XXX fabric module for Qlogic 2xxx series target mode HBAs"
+	depends on TARGET_CORE && CONFIGFS_FS
+	default n
+	---help---
+	Say Y here to enable the TCM_QLA2XXX fabric module for Qlogic 2xxx series target mode HBAs 
diff --git a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h
new file mode 100644
index 0000000..55a1267
--- /dev/null
+++ b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h
@@ -0,0 +1,32 @@
+#define TCM_QLA2XXX_VERSION	"v0.1"
+/* length of ASCII WWPNs including pad */
+#define TCM_QLA2XXX_NAMELEN	32
+
+struct tcm_qla2xxx_nacl {
+	/* Binary World Wide unique Port Name for FC Initiator Nport */
+	u64 nport_wwpn;
+	/* ASCII formatted WWPN for FC Initiator Nport */
+	char nport_name[TCM_QLA2XXX_NAMELEN];
+	/* Returned by tcm_qla2xxx_make_nodeacl() */
+	struct se_node_acl_s se_node_acl;
+};
+
+struct tcm_qla2xxx_tpg {
+	/* FC lport target portal group tag for TCM */
+	u16 lport_tpgt;
+	/* Pointer back to tcm_qla2xxx_lport */
+	struct tcm_qla2xxx_lport *lport;
+	/* Returned by tcm_qla2xxx_make_tpg() */
+	struct se_portal_group_s se_tpg;
+};
+
+struct tcm_qla2xxx_lport {
+	/* SCSI protocol the lport is providing */
+	u8 lport_proto_id;
+	/* Binary World Wide unique Port Name for FC Target Lport */
+	u64 lport_wwpn;
+	/* ASCII formatted WWPN for FC Target Lport */
+	char lport_name[TCM_QLA2XXX_NAMELEN];
+	/* Returned by tcm_qla2xxx_make_lport() */
+	struct se_wwn_s lport_wwn;
+};
diff --git a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c
new file mode 100644
index 0000000..366f3b2
--- /dev/null
+++ b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c
@@ -0,0 +1,330 @@
+/*******************************************************************************
+ * Filename:  tcm_qla2xxx_configfs.c
+ *
+ * This file contains TCM QLA2XXX fabric module implementation using
+ * v4 configfs fabric infrastructure for QLogic target mode HBAs
+ *
+ * Copyright (c) 2010 Rising Tide, Inc.
+ * Copyright (c) 2010 Linux-iSCSI.org
+ *
+ * Copyright (c) 2010 Nicholas A. Bellinger <nab@linux-iscsi.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ ****************************************************************************/
+
+#define TCM_QLA2XXX_CONFIGFS_C
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/version.h>
+#include <generated/utsrelease.h>
+#include <linux/utsname.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/kthread.h>
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/configfs.h>
+#include <linux/ctype.h>
+#include <asm/unaligned.h>
+
+#include <target/target_core_base.h>
+#include <target/target_core_transport.h>
+#include <target/target_core_fabric_ops.h>
+#include <target/target_core_fabric_configfs.h>
+#include <target/target_core_fabric_lib.h>
+#include <target/target_core_device.h>
+#include <target/target_core_tpg.h>
+#include <target/target_core_configfs.h>
+#include <target/target_core_alua.h>
+#include <target/target_core_base.h>
+#include <target/configfs_macros.h>
+
+#include <tcm_qla2xxx_base.h>
+#include <tcm_qla2xxx_fabric.h>
+
+#undef TCM_QLA2XXX_CONFIGFS_C
+
+/* Local pointer to allocated TCM configfs fabric module */
+struct target_fabric_configfs *tcm_qla2xxx_fabric_configfs;
+
+static struct se_node_acl_s *tcm_qla2xxx_make_nodeacl(
+	struct se_portal_group_s *se_tpg,
+	struct config_group *group,
+	const char *name)
+{
+	se_node_acl_t *se_nacl, *se_nacl_new;
+	struct tcm_qla2xxx_nacl *nacl;
+	u64 wwpn;
+	u32 qla2xxx_nexus_depth;
+
+	if (tcm_qla2xxx_parse_wwn(name, &wwpn, 1) < 0)
+		return ERR_PTR(-EINVAL);
+
+	se_nacl_new = tcm_qla2xxx_alloc_fabric_acl(se_tpg);
+	if (!(se_nacl_new))
+		return ERR_PTR(-ENOMEM);
+//#warning FIXME: Hardcoded qla2xxx_nexus depth in tcm_qla2xxx_make_nodeacl()
+	qla2xxx_nexus_depth = 1;
+	/*
+	 * se_nacl_new may be released by core_tpg_add_initiator_node_acl()
+	 * when converting a NdoeACL from demo mode -> explict
+	 */
+	se_nacl = core_tpg_add_initiator_node_acl(se_tpg, se_nacl_new,
+				name, qla2xxx_nexus_depth);
+	if (IS_ERR(se_nacl)) {
+		tcm_qla2xxx_release_fabric_acl(se_tpg, se_nacl_new);
+		return se_nacl;
+	}
+	/*
+	 * Locate our struct tcm_qla2xxx_nacl and set the FC Nport WWPN
+	 */
+	nacl = container_of(se_nacl, struct tcm_qla2xxx_nacl, se_node_acl);
+	nacl->nport_wwpn = wwpn;
+	tcm_qla2xxx_format_wwn(&nacl->nport_name[0], TCM_QLA2XXX_NAMELEN, wwpn);
+
+	return se_nacl;
+}
+
+static void tcm_qla2xxx_drop_nodeacl(struct se_node_acl_s *se_acl)
+{
+	struct tcm_qla2xxx_nacl *nacl = container_of(se_acl,
+				struct tcm_qla2xxx_nacl, se_node_acl);	
+	kfree(nacl);
+}
+
+static struct se_portal_group_s *tcm_qla2xxx_make_tpg(
+	struct se_wwn_s *wwn,
+	struct config_group *group,
+	const char *name)
+{
+	struct tcm_qla2xxx_lport *lport = container_of(wwn,
+			struct tcm_qla2xxx_lport, lport_wwn);
+	struct tcm_qla2xxx_tpg *tpg;
+	unsigned long tpgt;
+	int ret;
+
+	if (strstr(name, "tpgt_") != name)
+		return ERR_PTR(-EINVAL);
+	if (strict_strtoul(name + 5, 10, &tpgt) || tpgt > USHORT_MAX)
+		return ERR_PTR(-EINVAL);
+	
+	tpg = kzalloc(sizeof(struct tcm_qla2xxx_tpg), GFP_KERNEL);
+	if (!(tpg)) {
+		printk(KERN_ERR "Unable to allocate struct tcm_qla2xxx_tpg\n");
+		return ERR_PTR(-ENOMEM);
+	}
+	tpg->lport = lport;
+	tpg->lport_tpgt = tpgt;
+
+	ret = core_tpg_register(&tcm_qla2xxx_fabric_configfs->tf_ops, wwn,
+				&tpg->se_tpg, (void *)tpg,
+				TRANSPORT_TPG_TYPE_NORMAL);
+	if (ret < 0) {
+		kfree(tpg);
+		return NULL;
+	}
+	return &tpg->se_tpg;
+}
+
+static void tcm_qla2xxx_drop_tpg(struct se_portal_group_s *se_tpg)
+{
+	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
+				struct tcm_qla2xxx_tpg, se_tpg);
+
+	core_tpg_deregister(se_tpg);
+	kfree(tpg);
+}
+
+
+static struct se_wwn_s *tcm_qla2xxx_make_lport(
+	struct target_fabric_configfs *tf,
+	struct config_group *group,
+	const char *name)
+{
+	struct tcm_qla2xxx_lport *lport;
+	u64 wwpn;
+
+	if (tcm_qla2xxx_parse_wwn(name, &wwpn, 1) < 0)
+		return ERR_PTR(-EINVAL);
+
+	lport = kzalloc(sizeof(struct tcm_qla2xxx_lport), GFP_KERNEL);
+	if (!(lport)) {
+		printk(KERN_ERR "Unable to allocate struct tcm_qla2xxx_lport\n");
+		return ERR_PTR(-ENOMEM);
+	}
+	lport->lport_wwpn = wwpn;
+	tcm_qla2xxx_format_wwn(&lport->lport_name[0], TCM_QLA2XXX_NAMELEN, wwpn);
+
+	return &lport->lport_wwn;
+}
+
+static void tcm_qla2xxx_drop_lport(struct se_wwn_s *wwn)
+{
+	struct tcm_qla2xxx_lport *lport = container_of(wwn,
+			struct tcm_qla2xxx_lport, lport_wwn);
+	kfree(lport);
+}
+
+static ssize_t tcm_qla2xxx_wwn_show_attr_version(
+	struct target_fabric_configfs *tf,
+	char *page)
+{
+	return sprintf(page, "TCM QLOGIC QLA2XXX fabric module %s on %s/%s"
+		" on "UTS_RELEASE"\n", TCM_QLA2XXX_VERSION, utsname()->sysname,
+		utsname()->machine);
+}
+
+TF_WWN_ATTR_RO(tcm_qla2xxx, version);
+
+static struct configfs_attribute *tcm_qla2xxx_wwn_attrs[] = {
+	&tcm_qla2xxx_wwn_version.attr,
+	NULL,
+};
+
+static struct target_core_fabric_ops tcm_qla2xxx_ops = {
+	.get_fabric_name		= tcm_qla2xxx_get_fabric_name,
+	.get_fabric_proto_ident		= tcm_qla2xxx_get_fabric_proto_ident,
+	.tpg_get_wwn			= tcm_qla2xxx_get_fabric_wwn,
+	.tpg_get_tag			= tcm_qla2xxx_get_tag,
+	.tpg_get_default_depth		= tcm_qla2xxx_get_default_depth,
+	.tpg_get_pr_transport_id	= tcm_qla2xxx_get_pr_transport_id,
+	.tpg_get_pr_transport_id_len	= tcm_qla2xxx_get_pr_transport_id_len,
+	.tpg_parse_pr_out_transport_id	= tcm_qla2xxx_parse_pr_out_transport_id,
+	.tpg_check_demo_mode		= tcm_qla2xxx_check_false,
+	.tpg_check_demo_mode_cache	= tcm_qla2xxx_check_true,
+	.tpg_check_demo_mode_write_protect = tcm_qla2xxx_check_true,
+	.tpg_check_prod_mode_write_protect = tcm_qla2xxx_check_false,
+	.tpg_alloc_fabric_acl		= tcm_qla2xxx_alloc_fabric_acl,
+	.tpg_release_fabric_acl		= tcm_qla2xxx_release_fabric_acl,
+#ifdef SNMP_SUPPORT
+	.tpg_get_inst_index		= tcm_qla2xxx_tpg_get_inst_index,
+#endif /* SNMP_SUPPORT */
+	.release_cmd_to_pool		= tcm_qla2xxx_release_cmd,
+	.release_cmd_direct		= tcm_qla2xxx_release_cmd,
+	.shutdown_session		= tcm_qla2xxx_shutdown_session,
+	.close_session			= tcm_qla2xxx_close_session,
+	.stop_session			= tcm_qla2xxx_stop_session,
+	.fall_back_to_erl0		= tcm_qla2xxx_reset_nexus,
+	.sess_logged_in			= tcm_qla2xxx_sess_logged_in,
+#ifdef SNMP_SUPPORT
+	.sess_get_index			= tcm_qla2xxx_sess_get_index,
+#endif /* SNMP_SUPPORT */
+	.sess_get_initiator_sid		= NULL,
+	.write_pending			= tcm_qla2xxx_write_pending,
+	.write_pending_status		= tcm_qla2xxx_write_pending_status,
+	.set_default_node_attributes	= tcm_qla2xxx_set_default_node_attrs,
+	.get_task_tag			= tcm_qla2xxx_get_task_tag,
+	.get_cmd_state			= tcm_qla2xxx_get_cmd_state,
+	.new_cmd_failure		= tcm_qla2xxx_new_cmd_failure,
+	.queue_data_in			= tcm_qla2xxx_queue_data_in,
+	.queue_status			= tcm_qla2xxx_queue_status,
+	.queue_tm_rsp			= tcm_qla2xxx_queue_tm_rsp,
+	.get_fabric_sense_len		= tcm_qla2xxx_get_fabric_sense_len,
+	.set_fabric_sense_len		= tcm_qla2xxx_set_fabric_sense_len,
+	.is_state_remove		= tcm_qla2xxx_is_state_remove,
+	.pack_lun			= tcm_qla2xxx_pack_lun,
+	/*
+	 * Setup function pointers for generic logic in target_core_fabric_configfs.c
+	 */
+	.fabric_make_wwn		= tcm_qla2xxx_make_lport,
+	.fabric_drop_wwn		= tcm_qla2xxx_drop_lport,
+	.fabric_make_tpg		= tcm_qla2xxx_make_tpg,
+	.fabric_drop_tpg		= tcm_qla2xxx_drop_tpg,
+	.fabric_post_link		= NULL,
+	.fabric_pre_unlink		= NULL,
+	.fabric_make_np			= NULL,
+	.fabric_drop_np			= NULL,
+	.fabric_make_nodeacl		= tcm_qla2xxx_make_nodeacl,
+	.fabric_drop_nodeacl		= tcm_qla2xxx_drop_nodeacl,
+};
+
+static int tcm_qla2xxx_register_configfs(void)
+{
+	struct target_fabric_configfs *fabric;
+	int ret;
+
+	printk(KERN_INFO "TCM QLOGIC QLA2XXX fabric module %s on %s/%s"
+		" on "UTS_RELEASE"\n", TCM_QLA2XXX_VERSION, utsname()->sysname,
+		utsname()->machine);
+	/*
+	 * Register the top level struct config_item_type with TCM core
+	 */
+	fabric = target_fabric_configfs_init(THIS_MODULE, "qla2xxx");
+	if (!(fabric)) {
+		printk(KERN_ERR "target_fabric_configfs_init() failed\n");
+		return -ENOMEM;
+	}
+	/*
+	 * Setup fabric->tf_ops from our local tcm_qla2xxx_ops
+	 */
+	fabric->tf_ops = tcm_qla2xxx_ops;
+	/*
+	 * Setup default attribute lists for various fabric->tf_cit_tmpl
+	 */
+	TF_CIT_TMPL(fabric)->tfc_wwn_cit.ct_attrs = tcm_qla2xxx_wwn_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_base_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_attrib_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_param_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_np_base_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_base_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_attrib_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_auth_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_param_cit.ct_attrs = NULL;
+	/*
+	 * Register the fabric for use within TCM
+	 */
+	ret = target_fabric_configfs_register(fabric);
+	if (ret < 0) {
+		printk(KERN_ERR "target_fabric_configfs_register() failed"
+				" for TCM_QLA2XXX\n");
+		return ret;
+	}
+	/*
+	 * Setup our local pointer to *fabric
+	 */
+	tcm_qla2xxx_fabric_configfs = fabric;	
+	printk(KERN_INFO "TCM_QLA2XXX[0] - Set fabric -> tcm_qla2xxx_fabric_configfs\n");
+	return 0;
+}
+
+static void tcm_qla2xxx_deregister_configfs(void)
+{
+	if (!(tcm_qla2xxx_fabric_configfs))
+		return;
+
+	target_fabric_configfs_deregister(tcm_qla2xxx_fabric_configfs);
+	tcm_qla2xxx_fabric_configfs = NULL;
+	printk(KERN_INFO "TCM_QLA2XXX[0] - Cleared tcm_qla2xxx_fabric_configfs\n");
+}
+
+static int __init tcm_qla2xxx_init(void)
+{
+	int ret;
+
+	ret = tcm_qla2xxx_register_configfs();
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static void __init tcm_qla2xxx_exit(void)
+{
+	tcm_qla2xxx_deregister_configfs();
+}
+
+#ifdef MODULE
+MODULE_DESCRIPTION("TCM QLA2XXX series fabric driver");
+MODULE_LICENSE("GPL");
+module_init(tcm_qla2xxx_init);
+module_exit(tcm_qla2xxx_exit);
+#endif
diff --git a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c
new file mode 100644
index 0000000..bb80138
--- /dev/null
+++ b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c
@@ -0,0 +1,368 @@
+/*******************************************************************************
+ * Filename:  tcm_qla2xxx_fabric.c
+ *
+ * This file contains TCM_QLA2XXX functions for struct target_core_fabrib_ops
+ * for Qlogic 2xxx series target mode HBAs
+ *
+ * Copyright (c) 2010 Rising Tide Systems, Inc
+ * Copyright (c) 2010 Linux-iSCSI.org
+ *
+ * Copyright (c) 2010 Nicholas A. Bellinger <nab@linux-iscsi.org>
+ *
+ * tcm_qla2xxx_parse_wwn() and tcm_qla2xxx_format_wwn() contains code from
+ * the TCM_FC / Open-FCoE.org fabric module.
+ *
+ * Copyright (c) 2010 Cisco Systems, Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ ****************************************************************************/
+
+#define TCM_QLA2XXX_FABRIC_C
+
+#include <linux/slab.h>
+#include <linux/kthread.h>
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <asm/unaligned.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/libfc.h>
+
+#include <target/target_core_base.h>
+#include <target/target_core_transport.h>
+#include <target/target_core_fabric_ops.h>
+#include <target/target_core_fabric_lib.h>
+#include <target/target_core_device.h>
+#include <target/target_core_tpg.h>
+#include <target/target_core_configfs.h>
+#include <target/target_core_alua.h>
+
+#include <tcm_qla2xxx_base.h>
+#include <tcm_qla2xxx_fabric.h>
+
+#undef TCM_QLA2XXX_FABRIC_C
+
+int tcm_qla2xxx_check_true(se_portal_group_t *se_tpg)
+{
+	return 1;
+}
+
+int tcm_qla2xxx_check_false(se_portal_group_t *se_tpg)
+{
+	return 0;
+}
+
+/*
+ * Parse WWN.
+ * If strict, we require lower-case hex and colon separators to be sure
+ * the name is the same as what would be generated by ft_format_wwn()
+ * so the name and wwn are mapped one-to-one.
+ */
+ssize_t tcm_qla2xxx_parse_wwn(const char *name, u64 *wwn, int strict)
+{
+	const char *cp;
+	char c;
+	u32 nibble;
+	u32 byte = 0;
+	u32 pos = 0;
+	u32 err;
+
+	*wwn = 0;
+	for (cp = name; cp < &name[TCM_QLA2XXX_NAMELEN - 1]; cp++) {
+		c = *cp;
+		if (c == '\n' && cp[1] == '\0')
+			continue;
+		if (strict && pos++ == 2 && byte++ < 7) {
+			pos = 0;
+			if (c == ':')
+				continue;
+			err = 1;
+			goto fail;
+		}
+		if (c == '\0') {
+			err = 2;
+			if (strict && byte != 8)
+				goto fail;
+			return cp - name;
+		}
+		err = 3;
+		if (isdigit(c))
+			nibble = c - '0';
+		else if (isxdigit(c) && (islower(c) || !strict))
+			nibble = tolower(c) - 'a' + 10;
+		else
+			goto fail;
+		*wwn = (*wwn << 4) | nibble;
+	}
+	err = 4;
+fail:
+	printk(KERN_INFO "err %u len %zu pos %u byte %u\n",
+			err, cp - name, pos, byte);
+	return -1;
+}
+
+ssize_t tcm_qla2xxx_format_wwn(char *buf, size_t len, u64 wwn)
+{
+	u8 b[8];
+
+	put_unaligned_be64(wwn, b);
+	return snprintf(buf, len,
+		"%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x",
+		b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7]);
+}
+
+char *tcm_qla2xxx_get_fabric_name(void)
+{
+	return "qla2xxx";
+}
+
+u8 tcm_qla2xxx_get_fabric_proto_ident(se_portal_group_t *se_tpg)
+{
+	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
+				struct tcm_qla2xxx_tpg, se_tpg);
+	struct tcm_qla2xxx_lport *lport = tpg->lport;
+	u8 proto_id;
+
+	switch (lport->lport_proto_id) {
+	case SCSI_PROTOCOL_FCP:
+	default:
+		proto_id = fc_get_fabric_proto_ident(se_tpg);
+		break;
+	}
+
+	return proto_id;
+}
+
+char *tcm_qla2xxx_get_fabric_wwn(se_portal_group_t *se_tpg)
+{
+	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
+				struct tcm_qla2xxx_tpg, se_tpg);
+	struct tcm_qla2xxx_lport *lport = tpg->lport;
+
+	return &lport->lport_name[0];
+}
+
+u16 tcm_qla2xxx_get_tag(se_portal_group_t *se_tpg)
+{
+	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
+				struct tcm_qla2xxx_tpg, se_tpg);
+	return tpg->lport_tpgt;
+}
+
+u32 tcm_qla2xxx_get_default_depth(se_portal_group_t *se_tpg)
+{
+	return 1;
+}
+
+u32 tcm_qla2xxx_get_pr_transport_id(
+	se_portal_group_t *se_tpg,
+	se_node_acl_t *se_nacl,
+	t10_pr_registration_t *pr_reg,
+	int *format_code,
+	unsigned char *buf)
+{
+	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
+				struct tcm_qla2xxx_tpg, se_tpg);
+	struct tcm_qla2xxx_lport *lport = tpg->lport;
+	int ret = 0;
+
+	switch (lport->lport_proto_id) {
+	case SCSI_PROTOCOL_FCP:
+	default:
+		ret = fc_get_pr_transport_id(se_tpg, se_nacl, pr_reg,
+					format_code, buf);
+		break;
+	}
+
+	return ret;
+}		
+
+u32 tcm_qla2xxx_get_pr_transport_id_len(
+	se_portal_group_t *se_tpg,
+	se_node_acl_t *se_nacl,
+	t10_pr_registration_t *pr_reg,
+	int *format_code)
+{
+	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
+				struct tcm_qla2xxx_tpg, se_tpg);
+	struct tcm_qla2xxx_lport *lport = tpg->lport;
+	int ret = 0;
+
+	switch (lport->lport_proto_id) {
+	case SCSI_PROTOCOL_FCP:
+	default:
+		ret = fc_get_pr_transport_id_len(se_tpg, se_nacl, pr_reg,
+					format_code);
+		break;
+	}
+
+	return ret;
+}
+
+char *tcm_qla2xxx_parse_pr_out_transport_id(
+	se_portal_group_t *se_tpg,
+	const char *buf,
+	u32 *out_tid_len,
+	char **port_nexus_ptr)
+{
+	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
+				struct tcm_qla2xxx_tpg, se_tpg);
+	struct tcm_qla2xxx_lport *lport = tpg->lport;
+	char *tid = NULL;
+
+	switch (lport->lport_proto_id) {
+	case SCSI_PROTOCOL_FCP:
+	default:
+		tid = fc_parse_pr_out_transport_id(se_tpg, buf, out_tid_len,
+					port_nexus_ptr);
+		break;
+	}
+
+	return tid;
+}
+
+se_node_acl_t *tcm_qla2xxx_alloc_fabric_acl(se_portal_group_t *se_tpg)
+{
+	struct tcm_qla2xxx_nacl *nacl;
+
+	nacl = kzalloc(sizeof(struct tcm_qla2xxx_nacl), GFP_KERNEL);
+	if (!(nacl)) {
+		printk(KERN_ERR "Unable to alocate struct tcm_qla2xxx_nacl\n");
+		return NULL;
+	}
+
+	return &nacl->se_node_acl;
+}
+
+void tcm_qla2xxx_release_fabric_acl(
+	se_portal_group_t *se_tpg,
+	se_node_acl_t *se_nacl)
+{
+	struct tcm_qla2xxx_nacl *nacl = container_of(se_nacl,
+			struct tcm_qla2xxx_nacl, se_node_acl);
+	kfree(nacl);
+}
+
+#ifdef SNMP_SUPPORT
+u32 tcm_qla2xxx_tpg_get_inst_index(se_portal_group_t *se_tpg)
+{
+	return 1;
+}
+#endif /* SNMP_SUPPORT */
+
+void tcm_qla2xxx_release_cmd(se_cmd_t *se_cmd)
+{
+	return;
+}
+
+int tcm_qla2xxx_shutdown_session(se_session_t *se_sess)
+{
+	return 0;
+}
+
+void tcm_qla2xxx_close_session(se_session_t *se_sess)
+{
+	return;
+}
+
+void tcm_qla2xxx_stop_session(se_session_t *se_sess, int sess_sleep , int conn_sleep)
+{
+	return;
+}
+
+void tcm_qla2xxx_reset_nexus(se_session_t *se_sess)
+{
+	return;
+}
+
+int tcm_qla2xxx_sess_logged_in(se_session_t *se_sess)
+{
+	return 0;
+}
+
+#ifdef SNMP_SUPPORT
+u32 tcm_qla2xxx_sess_get_index(se_session_t *se_sess)
+{
+	return 0;
+}
+#endif /* SNMP_SUPPORT */
+
+int tcm_qla2xxx_write_pending(se_cmd_t *se_cmd)
+{
+	return 0;
+}
+
+int tcm_qla2xxx_write_pending_status(se_cmd_t *se_cmd)
+{
+	return 0;
+}
+
+void tcm_qla2xxx_set_default_node_attrs(se_node_acl_t *nacl)
+{
+	return;
+}
+
+u32 tcm_qla2xxx_get_task_tag(se_cmd_t *se_cmd)
+{
+	return 0;
+}
+
+int tcm_qla2xxx_get_cmd_state(se_cmd_t *se_cmd)
+{
+	return 0;
+}
+
+void tcm_qla2xxx_new_cmd_failure(se_cmd_t *se_cmd)
+{
+	return;
+}
+
+int tcm_qla2xxx_queue_data_in(se_cmd_t *se_cmd)
+{
+	return 0;
+}
+
+int tcm_qla2xxx_queue_status(se_cmd_t *se_cmd)
+{
+	return 0;
+}
+
+int tcm_qla2xxx_queue_tm_rsp(se_cmd_t *se_cmd)
+{
+	return 0;
+}
+
+u16 tcm_qla2xxx_get_fabric_sense_len(void)
+{
+	return 0;
+}
+
+u16 tcm_qla2xxx_set_fabric_sense_len(se_cmd_t *se_cmd, u32 sense_length)
+{
+	return 0;
+}
+
+int tcm_qla2xxx_is_state_remove(se_cmd_t *se_cmd)
+{
+	return 0;
+}
+
+u64 tcm_qla2xxx_pack_lun(unsigned int lun)
+{
+	WARN_ON(lun >= 256);
+	/* Caller wants this byte-swapped */
+	return cpu_to_le64((lun & 0xff) << 8);
+}
diff --git a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.h b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.h
new file mode 100644
index 0000000..9a876e4
--- /dev/null
+++ b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.h
@@ -0,0 +1,42 @@
+extern int tcm_qla2xxx_check_true(se_portal_group_t *);
+extern int tcm_qla2xxx_check_false(se_portal_group_t *);
+extern ssize_t tcm_qla2xxx_parse_wwn(const char *, u64 *, int);
+extern ssize_t tcm_qla2xxx_format_wwn(char *, size_t, u64);
+extern char *tcm_qla2xxx_get_fabric_name(void);
+extern u8 tcm_qla2xxx_get_fabric_proto_ident(se_portal_group_t *);
+extern char *tcm_qla2xxx_get_fabric_wwn(se_portal_group_t *);
+extern u16 tcm_qla2xxx_get_tag(se_portal_group_t *);
+extern u32 tcm_qla2xxx_get_default_depth(se_portal_group_t *);
+extern u32 tcm_qla2xxx_get_pr_transport_id(se_portal_group_t *, se_node_acl_t *,
+				t10_pr_registration_t *, int *, unsigned char *);
+extern u32 tcm_qla2xxx_get_pr_transport_id_len(se_portal_group_t *, se_node_acl_t *,
+				t10_pr_registration_t *, int *);
+extern char *tcm_qla2xxx_parse_pr_out_transport_id(se_portal_group_t *, const char *,
+				u32 *, char **);
+extern se_node_acl_t *tcm_qla2xxx_alloc_fabric_acl(se_portal_group_t *);
+extern void tcm_qla2xxx_release_fabric_acl(se_portal_group_t *, se_node_acl_t *);
+#ifdef SNMP_SUPPORT
+extern u32 tcm_qla2xxx_tpg_get_inst_index(se_portal_group_t *);
+#endif /* SNMP_SUPPORT */
+extern void tcm_qla2xxx_release_cmd(se_cmd_t *);
+extern int tcm_qla2xxx_shutdown_session(se_session_t *);
+extern void tcm_qla2xxx_close_session(se_session_t *);
+extern void tcm_qla2xxx_stop_session(se_session_t *, int, int);
+extern void tcm_qla2xxx_reset_nexus(se_session_t *);
+extern int tcm_qla2xxx_sess_logged_in(se_session_t *);
+#ifdef SNMP_SUPPORT
+u32 tcm_qla2xxx_sess_get_index(se_session_t *);
+#endif /* SNMP_SUPPORT */
+extern int tcm_qla2xxx_write_pending(se_cmd_t *);
+extern int tcm_qla2xxx_write_pending_status(se_cmd_t *);
+extern void tcm_qla2xxx_set_default_node_attrs(se_node_acl_t *);
+extern u32 tcm_qla2xxx_get_task_tag(se_cmd_t *);
+extern int tcm_qla2xxx_get_cmd_state(se_cmd_t *);
+extern void tcm_qla2xxx_new_cmd_failure(se_cmd_t *);
+extern int tcm_qla2xxx_queue_data_in(se_cmd_t *);
+extern int tcm_qla2xxx_queue_status(se_cmd_t *);
+extern int tcm_qla2xxx_queue_tm_rsp(se_cmd_t *);
+extern u16 tcm_qla2xxx_get_fabric_sense_len(void);
+extern u16 tcm_qla2xxx_set_fabric_sense_len(se_cmd_t *, u32);
+extern int tcm_qla2xxx_is_state_remove(se_cmd_t *);
+extern u64 tcm_qla2xxx_pack_lun(unsigned int);
-- 
1.5.6.5

