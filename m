From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [TCM]: Initial commit for tcm_mvsas module using v4 configfs fabric infrastructure
Date: Sat, 29 May 2010 18:21:55 -0700
Message-ID: <1275182515-5194-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:27652 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757272Ab0E3BVq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2010 21:21:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Smart <james.smart@emulex.com>
Cc: Richard Sharpe <realrichardsharpe@gmail.com>, Christoph Hellwig <hch@lst.de>, Joe Eykholt <jeykholt@cisco.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This commit adds initial support for a tcm_mvsas fabric module using the new
TCM v4 generic configfs fabric infrastructure and high level SCSI_PROTOCOL_SAS
fabric ops.  This includes the main struct target_core_fabric_ops API callers
mapped to the following tcm_mvsas_configfs.c code and structures:

	.fabric_make_wwn -> tcm_mvsas_make_port() with struct tcm_mvsas_port
	.fabric_drop_wwn -> tcm_mvsas_drop_port() with struct tcm_mvsas_port
	.fabric_make_tpg -> tcm_mvsas_make_tpg() with struct tcm_mvsas_tpg
	.fabric_drop_tpg -> tcm_mvsas_drop_tpg() with struct tcm_mvsas_tpg
	.fabric_make_nodeacl -> tcm_mvsas_make_nodeacl() with struct tcm_mvsas_nacl
	.fabric_drop_nodeacl -> tcm_mvsas_drop_nodeacl() with struct tcm_mvsas_nacl

All of the generic configfs fabric intrastructure is up and running.

Note that the I_T Nexus and I/O related fabric API functions have been added as NOPs
for the moment, and this code is intended to be a starting point for the bringup of MVSAS
series HBAs with TCM v4.  Eventually the patch for enabling this upstream drivers/scsi/mvsas/
will be added into lio-core-2.6.git/tcm_mvsas as community interest dictates.

Here is how is how a single LUN setup on target SAS port WWPN 20:00:12:34:56:78:90:00
using an TCM/IBLOCK backstore will look for a 20:00:00:09:87:65:43:21 Initiator SAS port WWPN
with MappedLUN=0:

target:~# mkdir -p /sys/kernel/config/target/mvsas/naa.600156789ffffffe/tpgt_1/lun/lun_0/
target:~# cd /sys/kernel/config/target/mvsas/naa.600156789ffffffe/tpgt_1/lun/lun_0/
target:/sys/kernel/config/target/mvsas/naa.600156789ffffffe/tpgt_1/lun/lun_0# ln -s /sys/kernel/config/target/core/iblock_0/lvm_test0 tcm_mvsas_port
target:/sys/kernel/config/target/mvsas/naa.600156789ffffffe/tpgt_1/lun/lun_0# mkdir -p ../../acls/naa.600234567eeeeeef/lun_0
target:/sys/kernel/config/target/mvsas/naa.600156789ffffffe/tpgt_1/lun/lun_0# cd ../../acls/naa.600234567eeeeeef/lun_0
target:/sys/kernel/config/target/mvsas/naa.600156789ffffffe/tpgt_1/acls/naa.600234567eeeeeef/lun_0# ln -s /sys/kernel/config/target/mvsas/naa.600156789ffffffe/tpgt_1/lun/lun_0/ lun_0
target:/sys/kernel/config/target/mvsas/naa.600156789ffffffe/tpgt_1/acls/naa.600234567eeeeeef/lun_0# tree /sys/kernel/config/target/mvsas/
/sys/kernel/config/target/mvsas/
|-- discovery_auth
|-- naa.600156789ffffffe
|   `-- tpgt_1
|       |-- acls
|       |   `-- naa.600234567eeeeeef
|       |       |-- attrib
|       |       |-- auth
|       |       |-- lun_0
|       |       |   |-- lun_0 -> ../../../../../../../target/mvsas/naa.600156789ffffffe/tpgt_1/lun/lun_0
|       |       |   `-- write_protect
|       |       `-- param
|       |-- attrib
|       |-- lun
|       |   `-- lun_0
|       |       |-- alua_tg_pt_gp
|       |       |-- alua_tg_pt_offline
|       |       |-- alua_tg_pt_status
|       |       |-- alua_tg_pt_write_md
|       |       `-- tcm_mvsas_port -> ../../../../../../target/core/iblock_0/lvm_test0
|       |-- np
|       `-- param
`-- version

All tcm_mvsas ports for TCM backstores using SPC-3 ALUA emulation:

target:/sys/kernel/config/target/mvsas/naa.600156789ffffffe/tpgt_1/acls/naa.600234567eeeeeef/lun_0# tcm_node --listaluatpg iblock_0/lvm_test0 default_tg_pt_gp
\------> default_tg_pt_gp  Target Port Group ID: 0
         Active ALUA Access Type(s): Implict and Explict
         Primary Access State: Active/Optimized
         Primary Access Status: Altered by Implict ALUA
         Preferred Bit: 0
         Active/NonOptimized Delay in milliseconds: 100
         Transition Delay in milliseconds: 0
         \------> TG Port Group Members
             mvsas/naa.600156789ffffffe/tpgt_1/lun_0

and the (hopefully) now fimilar v4 initialization and configuration messages:

TCM MARVELL MVSAS fabric module v0.1 on Linux/i686 on 2.6.34
Setup generic discovery
Setup generic wwn
Setup generic tpg
Setup generic tpg_base
Setup generic tpg_port
Setup generic tpg_lun
Setup generic tpg_np
Setup generic tpg_np_base
Setup generic tpg_attrib
Setup generic tpg_param
Setup generic tpg_nacl
Setup generic tpg_nacl_base
Setup generic tpg_nacl_attrib
Setup generic tpg_nacl_auth
Setup generic tpg_nacl_param
Setup generic tpg_mappedlun
<<<<<<<<<<<<<<<<<<<<<< BEGIN FABRIC API >>>>>>>>>>>>>>>>>>>>>>
Initialized struct target_fabric_configfs: de5bb060 for mvsas
<<<<<<<<<<<<<<<<<<<<<< END FABRIC API >>>>>>>>>>>>>>>>>>>>>>
TCM_MVSAS[0] - Set fabric -> tcm_mvsas_fabric_configfs
Target_Core_ConfigFS: REGISTER -> group: e128f000 name: mvsas
Target_Core_ConfigFS: REGISTER -> Located fabric: mvsas
Target_Core_ConfigFS: REGISTER tfc_wwn_cit -> de5bb208
Target_Core_ConfigFS: REGISTER -> Allocated Fabric: mvsas
Target_Core_ConfigFS: REGISTER -> Set tf->tf_fabric for mvsas
TARGET_CORE[mvsas]: Allocated Normal se_portal_group_t for endpoint: naa.600156789ffffffe, Portal Tag: 1
iblock/mvsas: Adding to default ALUA Target Port Group: alua/default_tg_pt_gp
mvsas_TPG[1]_LUN[0] - Activated mvsas Logical Unit from CORE HBA: 4
mvsas_TPG[1] - Added ACL with TCQ Depth: 1 for mvsas Initiator Node: naa.600234567eeeeeef
mvsas_TPG[1]_LUN[0->0] - Added RW ACL for  InitiatorNode: naa.600234567eeeeeef

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/Kbuild                         |    1 +
 drivers/target/Kconfig                        |    1 +
 drivers/target/tcm_mvsas/Kbuild               |    6 +
 drivers/target/tcm_mvsas/Kconfig              |    6 +
 drivers/target/tcm_mvsas/tcm_mvsas_base.h     |   32 +++
 drivers/target/tcm_mvsas/tcm_mvsas_configfs.c |  332 +++++++++++++++++++++++
 drivers/target/tcm_mvsas/tcm_mvsas_fabric.c   |  362 +++++++++++++++++++++++++
 drivers/target/tcm_mvsas/tcm_mvsas_fabric.h   |   42 +++
 8 files changed, 782 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/tcm_mvsas/Kbuild
 create mode 100644 drivers/target/tcm_mvsas/Kconfig
 create mode 100644 drivers/target/tcm_mvsas/tcm_mvsas_base.h
 create mode 100644 drivers/target/tcm_mvsas/tcm_mvsas_configfs.c
 create mode 100644 drivers/target/tcm_mvsas/tcm_mvsas_fabric.c
 create mode 100644 drivers/target/tcm_mvsas/tcm_mvsas_fabric.h

diff --git a/drivers/target/Kbuild b/drivers/target/Kbuild
index 5298d6a..23de416 100644
--- a/drivers/target/Kbuild
+++ b/drivers/target/Kbuild
@@ -59,3 +59,4 @@ obj-$(CONFIG_LIO_TARGET)	+= lio-target/
 obj-$(CONFIG_TCM_LOOP_FABRIC)	+= tcm_loop/
 
 obj-$(CONFIG_TCM_FC)		+= tcm_fc/
+obj-$(CONFIG_TCM_MVSAS)		+= tcm_mvsas/
diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
index 95f2c2c..1562021 100644
--- a/drivers/target/Kconfig
+++ b/drivers/target/Kconfig
@@ -65,3 +65,4 @@ config TCM_DEBUG_DEV
 source "drivers/target/tcm_loop/Kconfig"
 source "drivers/target/lio-target/Kconfig"
 source "drivers/target/tcm_fc/Kconfig"
+source "drivers/target/tcm_mvsas/Kconfig"
diff --git a/drivers/target/tcm_mvsas/Kbuild b/drivers/target/tcm_mvsas/Kbuild
new file mode 100644
index 0000000..7029a5d
--- /dev/null
+++ b/drivers/target/tcm_mvsas/Kbuild
@@ -0,0 +1,6 @@
+EXTRA_CFLAGS += -I$(srctree)/drivers/target/ -I$(srctree)/drivers/scsi/ -I$(srctree)/include/scsi/ -I$(srctree)/drivers/target/tcm_mvsas
+
+tcm_mvsas-objs			:= tcm_mvsas_fabric.o \
+				   tcm_mvsas_configfs.o \
+
+obj-$(CONFIG_TCM_MVSAS)		+= tcm_mvsas.o
diff --git a/drivers/target/tcm_mvsas/Kconfig b/drivers/target/tcm_mvsas/Kconfig
new file mode 100644
index 0000000..712fea9
--- /dev/null
+++ b/drivers/target/tcm_mvsas/Kconfig
@@ -0,0 +1,6 @@
+config TCM_MVSAS
+	tristate "TCM MVSAS fabric module for Marvell SAS target mode HBAs"
+	depends on TARGET_CORE && CONFIGFS_FS
+	default n
+	---help---
+	Say Y here to enable the TCM MVSAS fabric module for Marvell SAS target mode HBAs
diff --git a/drivers/target/tcm_mvsas/tcm_mvsas_base.h b/drivers/target/tcm_mvsas/tcm_mvsas_base.h
new file mode 100644
index 0000000..51d4347
--- /dev/null
+++ b/drivers/target/tcm_mvsas/tcm_mvsas_base.h
@@ -0,0 +1,32 @@
+#define TCM_MVSAS_VERSION	"v0.1"
+/* length of ASCII WWPNs including pad */
+#define TCM_MVSAS_NAMELEN	32
+
+struct tcm_mvsas_nacl {
+	/* Binary World Wide unique Port Name for FC Initiator Nport */
+	u64 nport_wwpn;
+	/* ASCII formatted WWPN for FC Initiator Nport */
+	char nport_name[TCM_MVSAS_NAMELEN];
+	/* Returned by tcm_mvsas_make_nodeacl() */
+	struct se_node_acl_s se_node_acl;
+};
+
+struct tcm_mvsas_tpg {
+	/* SAS port target portal group tag for TCM */
+	u16 port_tpgt;
+	/* Pointer back to tcm_mvsas_port */
+	struct tcm_mvsas_port *port;
+	/* Returned by tcm_mvsas_make_tpg() */
+	struct se_portal_group_s se_tpg;
+};
+
+struct tcm_mvsas_port {
+	/* SCSI protocol the port is providing */
+	u8 port_proto_id;
+	/* Binary World Wide unique Port Name for FC Target Lport */
+	u64 port_wwpn;
+	/* ASCII formatted WWPN for FC Target Lport */
+	char port_name[TCM_MVSAS_NAMELEN];
+	/* Returned by tcm_mvsas_make_port() */
+	struct se_wwn_s port_wwn;
+};
diff --git a/drivers/target/tcm_mvsas/tcm_mvsas_configfs.c b/drivers/target/tcm_mvsas/tcm_mvsas_configfs.c
new file mode 100644
index 0000000..0060b56
--- /dev/null
+++ b/drivers/target/tcm_mvsas/tcm_mvsas_configfs.c
@@ -0,0 +1,332 @@
+/*******************************************************************************
+ * Filename:  tcm_mvsas_configfs.c
+ *
+ * This file contains TCM  fabric module implementation using
+ * v4 configfs fabric infrastructure for Emulex target mode HBAs
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
+#define TCM_MVSAS_CONFIGFS_C
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
+#include <scsi/scsi.h> /* For SCSI_PROTOCOL_SAS */
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
+#include <tcm_mvsas_base.h>
+#include <tcm_mvsas_fabric.h>
+
+#undef TCM_MVSAS_CONFIGFS_C
+
+/* Local pointer to allocated TCM configfs fabric module */
+struct target_fabric_configfs *tcm_mvsas_fabric_configfs;
+
+static struct se_node_acl_s *tcm_mvsas_make_nodeacl(
+	struct se_portal_group_s *se_tpg,
+	struct config_group *group,
+	const char *name)
+{
+	se_node_acl_t *se_nacl, *se_nacl_new;
+	struct tcm_mvsas_nacl *nacl;
+	u64 wwpn;
+	u32 sas_nexus_depth;
+
+	if (tcm_mvsas_parse_wwn(name, &wwpn, 1) < 0)
+		return ERR_PTR(-EINVAL);
+
+	se_nacl_new = tcm_mvsas_alloc_fabric_acl(se_tpg);
+	if (!(se_nacl_new))
+		return ERR_PTR(-ENOMEM);
+//#warning FIXME: Hardcoded sas_nexus depth in tcm_mvsas_make_nodeacl()
+	sas_nexus_depth = 1;
+	/*
+	 * se_nacl_new may be released by core_tpg_add_initiator_node_acl()
+	 * when converting a NdoeACL from demo mode -> explict
+	 */
+	se_nacl = core_tpg_add_initiator_node_acl(se_tpg, se_nacl_new,
+				name, sas_nexus_depth);
+	if (IS_ERR(se_nacl)) {
+		tcm_mvsas_release_fabric_acl(se_tpg, se_nacl_new);
+		return se_nacl;
+	}
+	/*
+	 * Locate our struct tcm_mvsas_nacl and set the FC Nport WWPN
+	 */
+	nacl = container_of(se_nacl, struct tcm_mvsas_nacl, se_node_acl);
+	nacl->nport_wwpn = wwpn;
+	tcm_mvsas_format_wwn(&nacl->nport_name[0], TCM_MVSAS_NAMELEN, wwpn);
+
+	return se_nacl;
+}
+
+static void tcm_mvsas_drop_nodeacl(struct se_node_acl_s *se_acl)
+{
+	struct tcm_mvsas_nacl *nacl = container_of(se_acl,
+				struct tcm_mvsas_nacl, se_node_acl);	
+	kfree(nacl);
+}
+
+static struct se_portal_group_s *tcm_mvsas_make_tpg(
+	struct se_wwn_s *wwn,
+	struct config_group *group,
+	const char *name)
+{
+	struct tcm_mvsas_port *port = container_of(wwn,
+			struct tcm_mvsas_port, port_wwn);
+	struct tcm_mvsas_tpg *tpg;
+	unsigned long tpgt;
+	int ret;
+
+	if (strstr(name, "tpgt_") != name)
+		return ERR_PTR(-EINVAL);
+	if (strict_strtoul(name + 5, 10, &tpgt) || tpgt > USHORT_MAX)
+		return ERR_PTR(-EINVAL);
+	
+	tpg = kzalloc(sizeof(struct tcm_mvsas_tpg), GFP_KERNEL);
+	if (!(tpg)) {
+		printk(KERN_ERR "Unable to allocate struct tcm_mvsas_tpg\n");
+		return ERR_PTR(-ENOMEM);
+	}
+	tpg->port = port;
+	tpg->port_tpgt = tpgt;
+
+	ret = core_tpg_register(&tcm_mvsas_fabric_configfs->tf_ops, wwn,
+				&tpg->se_tpg, (void *)tpg,
+				TRANSPORT_TPG_TYPE_NORMAL);
+	if (ret < 0) {
+		kfree(tpg);
+		return NULL;
+	}
+	return &tpg->se_tpg;
+}
+
+static void tcm_mvsas_drop_tpg(struct se_portal_group_s *se_tpg)
+{
+	struct tcm_mvsas_tpg *tpg = container_of(se_tpg,
+				struct tcm_mvsas_tpg, se_tpg);
+
+	core_tpg_deregister(se_tpg);
+	kfree(tpg);
+}
+
+
+static struct se_wwn_s *tcm_mvsas_make_port(
+	struct target_fabric_configfs *tf,
+	struct config_group *group,
+	const char *name)
+{
+	struct tcm_mvsas_port *port;
+	u64 wwpn;
+
+	if (tcm_mvsas_parse_wwn(name, &wwpn, 1) < 0)
+		return ERR_PTR(-EINVAL);
+
+	port = kzalloc(sizeof(struct tcm_mvsas_port), GFP_KERNEL);
+	if (!(port)) {
+		printk(KERN_ERR "Unable to allocate struct tcm_mvsas_port\n");
+		return ERR_PTR(-ENOMEM);
+	}
+	port->port_proto_id = SCSI_PROTOCOL_SAS;
+	port->port_wwpn = wwpn;
+	tcm_mvsas_format_wwn(&port->port_name[0], TCM_MVSAS_NAMELEN, wwpn);
+
+	return &port->port_wwn;
+}
+
+static void tcm_mvsas_drop_port(struct se_wwn_s *wwn)
+{
+	struct tcm_mvsas_port *port = container_of(wwn,
+			struct tcm_mvsas_port, port_wwn);
+	kfree(port);
+}
+
+static ssize_t tcm_mvsas_wwn_show_attr_version(
+	struct target_fabric_configfs *tf,
+	char *page)
+{
+	return sprintf(page, "TCM MARVELL MVSAS fabric module %s on %s/%s"
+		" on "UTS_RELEASE"\n", TCM_MVSAS_VERSION, utsname()->sysname,
+		utsname()->machine);
+}
+
+TF_WWN_ATTR_RO(tcm_mvsas, version);
+
+static struct configfs_attribute *tcm_mvsas_wwn_attrs[] = {
+	&tcm_mvsas_wwn_version.attr,
+	NULL,
+};
+
+static struct target_core_fabric_ops tcm_mvsas_ops = {
+	.get_fabric_name		= tcm_mvsas_get_fabric_name,
+	.get_fabric_proto_ident		= tcm_mvsas_get_fabric_proto_ident,
+	.tpg_get_wwn			= tcm_mvsas_get_fabric_wwn,
+	.tpg_get_tag			= tcm_mvsas_get_tag,
+	.tpg_get_default_depth		= tcm_mvsas_get_default_depth,
+	.tpg_get_pr_transport_id	= tcm_mvsas_get_pr_transport_id,
+	.tpg_get_pr_transport_id_len	= tcm_mvsas_get_pr_transport_id_len,
+	.tpg_parse_pr_out_transport_id	= tcm_mvsas_parse_pr_out_transport_id,
+	.tpg_check_demo_mode		= tcm_mvsas_check_false,
+	.tpg_check_demo_mode_cache	= tcm_mvsas_check_true,
+	.tpg_check_demo_mode_write_protect = tcm_mvsas_check_true,
+	.tpg_check_prod_mode_write_protect = tcm_mvsas_check_false,
+	.tpg_alloc_fabric_acl		= tcm_mvsas_alloc_fabric_acl,
+	.tpg_release_fabric_acl		= tcm_mvsas_release_fabric_acl,
+#ifdef SNMP_SUPPORT
+	.tpg_get_inst_index		= tcm_mvsas_tpg_get_inst_index,
+#endif /* SNMP_SUPPORT */
+	.release_cmd_to_pool		= tcm_mvsas_release_cmd,
+	.release_cmd_direct		= tcm_mvsas_release_cmd,
+	.shutdown_session		= tcm_mvsas_shutdown_session,
+	.close_session			= tcm_mvsas_close_session,
+	.stop_session			= tcm_mvsas_stop_session,
+	.fall_back_to_erl0		= tcm_mvsas_reset_nexus,
+	.sess_logged_in			= tcm_mvsas_sess_logged_in,
+#ifdef SNMP_SUPPORT
+	.sess_get_index			= tcm_mvsas_sess_get_index,
+#endif /* SNMP_SUPPORT */
+	.sess_get_initiator_sid		= NULL,
+	.write_pending			= tcm_mvsas_write_pending,
+	.write_pending_status		= tcm_mvsas_write_pending_status,
+	.set_default_node_attributes	= tcm_mvsas_set_default_node_attrs,
+	.get_task_tag			= tcm_mvsas_get_task_tag,
+	.get_cmd_state			= tcm_mvsas_get_cmd_state,
+	.new_cmd_failure		= tcm_mvsas_new_cmd_failure,
+	.queue_data_in			= tcm_mvsas_queue_data_in,
+	.queue_status			= tcm_mvsas_queue_status,
+	.queue_tm_rsp			= tcm_mvsas_queue_tm_rsp,
+	.get_fabric_sense_len		= tcm_mvsas_get_fabric_sense_len,
+	.set_fabric_sense_len		= tcm_mvsas_set_fabric_sense_len,
+	.is_state_remove		= tcm_mvsas_is_state_remove,
+	.pack_lun			= tcm_mvsas_pack_lun,
+	/*
+	 * Setup function pointers for generic logic in target_core_fabric_configfs.c
+	 */
+	.fabric_make_wwn		= tcm_mvsas_make_port,
+	.fabric_drop_wwn		= tcm_mvsas_drop_port,
+	.fabric_make_tpg		= tcm_mvsas_make_tpg,
+	.fabric_drop_tpg		= tcm_mvsas_drop_tpg,
+	.fabric_post_link		= NULL,
+	.fabric_pre_unlink		= NULL,
+	.fabric_make_np			= NULL,
+	.fabric_drop_np			= NULL,
+	.fabric_make_nodeacl		= tcm_mvsas_make_nodeacl,
+	.fabric_drop_nodeacl		= tcm_mvsas_drop_nodeacl,
+};
+
+static int tcm_mvsas_register_configfs(void)
+{
+	struct target_fabric_configfs *fabric;
+	int ret;
+
+	printk(KERN_INFO "TCM MARVELL MVSAS fabric module %s on %s/%s"
+		" on "UTS_RELEASE"\n", TCM_MVSAS_VERSION, utsname()->sysname,
+		utsname()->machine);
+	/*
+	 * Register the top level struct config_item_type with TCM core
+	 */
+	fabric = target_fabric_configfs_init(THIS_MODULE, "mvsas");
+	if (!(fabric)) {
+		printk(KERN_ERR "target_fabric_configfs_init() failed\n");
+		return -ENOMEM;
+	}
+	/*
+	 * Setup fabric->tf_ops from our local tcm_mvsas_ops
+	 */
+	fabric->tf_ops = tcm_mvsas_ops;
+	/*
+	 * Setup default attribute lists for various fabric->tf_cit_tmpl
+	 */
+	TF_CIT_TMPL(fabric)->tfc_wwn_cit.ct_attrs = tcm_mvsas_wwn_attrs;
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
+				" for TCM_MVSAS\n");
+		return ret;
+	}
+	/*
+	 * Setup our local pointer to *fabric
+	 */
+	tcm_mvsas_fabric_configfs = fabric;	
+	printk(KERN_INFO "TCM_MVSAS[0] - Set fabric -> tcm_mvsas_fabric_configfs\n");
+	return 0;
+}
+
+static void tcm_mvsas_deregister_configfs(void)
+{
+	if (!(tcm_mvsas_fabric_configfs))
+		return;
+
+	target_fabric_configfs_deregister(tcm_mvsas_fabric_configfs);
+	tcm_mvsas_fabric_configfs = NULL;
+	printk(KERN_INFO "TCM_MVSAS[0] - Cleared tcm_mvsas_fabric_configfs\n");
+}
+
+static int __init tcm_mvsas_init(void)
+{
+	int ret;
+
+	ret = tcm_mvsas_register_configfs();
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static void __init tcm_mvsas_exit(void)
+{
+	tcm_mvsas_deregister_configfs();
+}
+
+#ifdef MODULE
+MODULE_DESCRIPTION("TCM MVSAS fabric driver");
+MODULE_LICENSE("GPL");
+module_init(tcm_mvsas_init);
+module_exit(tcm_mvsas_exit);
+#endif
diff --git a/drivers/target/tcm_mvsas/tcm_mvsas_fabric.c b/drivers/target/tcm_mvsas/tcm_mvsas_fabric.c
new file mode 100644
index 0000000..d75fa6e
--- /dev/null
+++ b/drivers/target/tcm_mvsas/tcm_mvsas_fabric.c
@@ -0,0 +1,362 @@
+/*******************************************************************************
+ * Filename:  tcm_mvsas_fabric.c
+ *
+ * This file contains TCM_MVSAS functions for struct target_core_fabrib_ops
+ * for Marvell SAS target mode HBAs
+ *
+ * Copyright (c) 2010 Rising Tide Systems, Inc
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
+#define TCM_MVSAS_FABRIC_C
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
+#include <tcm_mvsas_base.h>
+#include <tcm_mvsas_fabric.h>
+
+#undef TCM_MVSAS_FABRIC_C
+
+int tcm_mvsas_check_true(se_portal_group_t *se_tpg)
+{
+	return 1;
+}
+
+int tcm_mvsas_check_false(se_portal_group_t *se_tpg)
+{
+	return 0;
+}
+
+/*
+ * Parse SAS Address from ASCII -> binary
+ */
+ssize_t tcm_mvsas_parse_wwn(const char *name, u64 *wwn, int strict)
+{
+	const char *cp;
+	char c, *name_ptr;
+	u32 nibble;
+	u32 byte = 0;
+	u32 pos = 0;
+	u32 err;
+
+	if (strict) {
+		if (strstr(name, "naa.") != name) {
+			printk(KERN_ERR "Missing .naa prefix from SAS"
+				" Address: %s\n", name);
+			return -EINVAL;
+		}
+		name_ptr = (char *)&name[4]; /* Skip over naa. prefix */
+	} else
+		name_ptr = (char *)&name[0];
+
+	*wwn = 0;
+	for (cp = name_ptr; cp < &name[TCM_MVSAS_NAMELEN - 1]; cp++) {
+		c = *cp;
+		if (c == '\n' && cp[1] == '\0')
+			continue;
+		if (c == '\0')
+			return cp - name_ptr;
+
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
+			err, cp - name_ptr, pos, byte);
+	return -1;
+}
+/*
+ * Format a SAS address from binary -> ASCII
+ */
+ssize_t tcm_mvsas_format_wwn(char *buf, size_t len, u64 wwn)
+{
+	u8 b[8];
+
+	put_unaligned_be64(wwn, b);
+	return snprintf(buf, len,
+		"naa.%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x",
+		b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7]);
+}
+
+char *tcm_mvsas_get_fabric_name(void)
+{
+	return "mvsas";
+}
+
+u8 tcm_mvsas_get_fabric_proto_ident(se_portal_group_t *se_tpg)
+{
+	struct tcm_mvsas_tpg *tpg = container_of(se_tpg,
+				struct tcm_mvsas_tpg, se_tpg);
+	struct tcm_mvsas_port *port = tpg->port;
+	u8 proto_id;
+
+	switch (port->port_proto_id) {
+	case SCSI_PROTOCOL_SAS:
+	default:
+		proto_id = sas_get_fabric_proto_ident(se_tpg);
+		break;
+	}
+
+	return proto_id;
+}
+
+char *tcm_mvsas_get_fabric_wwn(se_portal_group_t *se_tpg)
+{
+	struct tcm_mvsas_tpg *tpg = container_of(se_tpg,
+				struct tcm_mvsas_tpg, se_tpg);
+	struct tcm_mvsas_port *port = tpg->port;
+
+	return &port->port_name[0];
+}
+
+u16 tcm_mvsas_get_tag(se_portal_group_t *se_tpg)
+{
+	struct tcm_mvsas_tpg *tpg = container_of(se_tpg,
+				struct tcm_mvsas_tpg, se_tpg);
+	return tpg->port_tpgt;
+}
+
+u32 tcm_mvsas_get_default_depth(se_portal_group_t *se_tpg)
+{
+	return 1;
+}
+
+u32 tcm_mvsas_get_pr_transport_id(
+	se_portal_group_t *se_tpg,
+	se_node_acl_t *se_nacl,
+	t10_pr_registration_t *pr_reg,
+	int *format_code,
+	unsigned char *buf)
+{
+	struct tcm_mvsas_tpg *tpg = container_of(se_tpg,
+				struct tcm_mvsas_tpg, se_tpg);
+	struct tcm_mvsas_port *port = tpg->port;
+	int ret = 0;
+
+	switch (port->port_proto_id) {
+	case SCSI_PROTOCOL_SAS:
+	default:
+		ret = sas_get_pr_transport_id(se_tpg, se_nacl, pr_reg,
+					format_code, buf);
+		break;
+	}
+
+	return ret;
+}		
+
+u32 tcm_mvsas_get_pr_transport_id_len(
+	se_portal_group_t *se_tpg,
+	se_node_acl_t *se_nacl,
+	t10_pr_registration_t *pr_reg,
+	int *format_code)
+{
+	struct tcm_mvsas_tpg *tpg = container_of(se_tpg,
+				struct tcm_mvsas_tpg, se_tpg);
+	struct tcm_mvsas_port *port = tpg->port;
+	int ret = 0;
+
+	switch (port->port_proto_id) {
+	case SCSI_PROTOCOL_SAS:
+	default:
+		ret = sas_get_pr_transport_id_len(se_tpg, se_nacl, pr_reg,
+					format_code);
+		break;
+	}
+
+	return ret;
+}
+
+char *tcm_mvsas_parse_pr_out_transport_id(
+	se_portal_group_t *se_tpg,
+	const char *buf,
+	u32 *out_tid_len,
+	char **port_nexus_ptr)
+{
+	struct tcm_mvsas_tpg *tpg = container_of(se_tpg,
+				struct tcm_mvsas_tpg, se_tpg);
+	struct tcm_mvsas_port *port = tpg->port;
+	char *tid = NULL;
+
+	switch (port->port_proto_id) {
+	case SCSI_PROTOCOL_SAS:
+	default:
+		tid = sas_parse_pr_out_transport_id(se_tpg, buf, out_tid_len,
+					port_nexus_ptr);
+		break;
+	}
+
+	return tid;
+}
+
+se_node_acl_t *tcm_mvsas_alloc_fabric_acl(se_portal_group_t *se_tpg)
+{
+	struct tcm_mvsas_nacl *nacl;
+
+	nacl = kzalloc(sizeof(struct tcm_mvsas_nacl), GFP_KERNEL);
+	if (!(nacl)) {
+		printk(KERN_ERR "Unable to alocate struct tcm_mvsas_nacl\n");
+		return NULL;
+	}
+
+	return &nacl->se_node_acl;
+}
+
+void tcm_mvsas_release_fabric_acl(
+	se_portal_group_t *se_tpg,
+	se_node_acl_t *se_nacl)
+{
+	struct tcm_mvsas_nacl *nacl = container_of(se_nacl,
+			struct tcm_mvsas_nacl, se_node_acl);
+	kfree(nacl);
+}
+
+#ifdef SNMP_SUPPORT
+u32 tcm_mvsas_tpg_get_inst_index(se_portal_group_t *se_tpg)
+{
+	return 1;
+}
+#endif /* SNMP_SUPPORT */
+
+void tcm_mvsas_release_cmd(se_cmd_t *se_cmd)
+{
+	return;
+}
+
+int tcm_mvsas_shutdown_session(se_session_t *se_sess)
+{
+	return 0;
+}
+
+void tcm_mvsas_close_session(se_session_t *se_sess)
+{
+	return;
+}
+
+void tcm_mvsas_stop_session(se_session_t *se_sess, int sess_sleep , int conn_sleep)
+{
+	return;
+}
+
+void tcm_mvsas_reset_nexus(se_session_t *se_sess)
+{
+	return;
+}
+
+int tcm_mvsas_sess_logged_in(se_session_t *se_sess)
+{
+	return 0;
+}
+
+#ifdef SNMP_SUPPORT
+u32 tcm_mvsas_sess_get_index(se_session_t *se_sess)
+{
+	return 0;
+}
+#endif /* SNMP_SUPPORT */
+
+int tcm_mvsas_write_pending(se_cmd_t *se_cmd)
+{
+	return 0;
+}
+
+int tcm_mvsas_write_pending_status(se_cmd_t *se_cmd)
+{
+	return 0;
+}
+
+void tcm_mvsas_set_default_node_attrs(se_node_acl_t *nacl)
+{
+	return;
+}
+
+u32 tcm_mvsas_get_task_tag(se_cmd_t *se_cmd)
+{
+	return 0;
+}
+
+int tcm_mvsas_get_cmd_state(se_cmd_t *se_cmd)
+{
+	return 0;
+}
+
+void tcm_mvsas_new_cmd_failure(se_cmd_t *se_cmd)
+{
+	return;
+}
+
+int tcm_mvsas_queue_data_in(se_cmd_t *se_cmd)
+{
+	return 0;
+}
+
+int tcm_mvsas_queue_status(se_cmd_t *se_cmd)
+{
+	return 0;
+}
+
+int tcm_mvsas_queue_tm_rsp(se_cmd_t *se_cmd)
+{
+	return 0;
+}
+
+u16 tcm_mvsas_get_fabric_sense_len(void)
+{
+	return 0;
+}
+
+u16 tcm_mvsas_set_fabric_sense_len(se_cmd_t *se_cmd, u32 sense_length)
+{
+	return 0;
+}
+
+int tcm_mvsas_is_state_remove(se_cmd_t *se_cmd)
+{
+	return 0;
+}
+
+u64 tcm_mvsas_pack_lun(unsigned int lun)
+{
+	WARN_ON(lun >= 256);
+	/* Caller wants this byte-swapped */
+	return cpu_to_le64((lun & 0xff) << 8);
+}
diff --git a/drivers/target/tcm_mvsas/tcm_mvsas_fabric.h b/drivers/target/tcm_mvsas/tcm_mvsas_fabric.h
new file mode 100644
index 0000000..94886df
--- /dev/null
+++ b/drivers/target/tcm_mvsas/tcm_mvsas_fabric.h
@@ -0,0 +1,42 @@
+extern int tcm_mvsas_check_true(se_portal_group_t *);
+extern int tcm_mvsas_check_false(se_portal_group_t *);
+extern ssize_t tcm_mvsas_parse_wwn(const char *, u64 *, int);
+extern ssize_t tcm_mvsas_format_wwn(char *, size_t, u64);
+extern char *tcm_mvsas_get_fabric_name(void);
+extern u8 tcm_mvsas_get_fabric_proto_ident(se_portal_group_t *);
+extern char *tcm_mvsas_get_fabric_wwn(se_portal_group_t *);
+extern u16 tcm_mvsas_get_tag(se_portal_group_t *);
+extern u32 tcm_mvsas_get_default_depth(se_portal_group_t *);
+extern u32 tcm_mvsas_get_pr_transport_id(se_portal_group_t *, se_node_acl_t *,
+				t10_pr_registration_t *, int *, unsigned char *);
+extern u32 tcm_mvsas_get_pr_transport_id_len(se_portal_group_t *, se_node_acl_t *,
+				t10_pr_registration_t *, int *);
+extern char *tcm_mvsas_parse_pr_out_transport_id(se_portal_group_t *, const char *,
+				u32 *, char **);
+extern se_node_acl_t *tcm_mvsas_alloc_fabric_acl(se_portal_group_t *);
+extern void tcm_mvsas_release_fabric_acl(se_portal_group_t *, se_node_acl_t *);
+#ifdef SNMP_SUPPORT
+extern u32 tcm_mvsas_tpg_get_inst_index(se_portal_group_t *);
+#endif /* SNMP_SUPPORT */
+extern void tcm_mvsas_release_cmd(se_cmd_t *);
+extern int tcm_mvsas_shutdown_session(se_session_t *);
+extern void tcm_mvsas_close_session(se_session_t *);
+extern void tcm_mvsas_stop_session(se_session_t *, int, int);
+extern void tcm_mvsas_reset_nexus(se_session_t *);
+extern int tcm_mvsas_sess_logged_in(se_session_t *);
+#ifdef SNMP_SUPPORT
+u32 tcm_mvsas_sess_get_index(se_session_t *);
+#endif /* SNMP_SUPPORT */
+extern int tcm_mvsas_write_pending(se_cmd_t *);
+extern int tcm_mvsas_write_pending_status(se_cmd_t *);
+extern void tcm_mvsas_set_default_node_attrs(se_node_acl_t *);
+extern u32 tcm_mvsas_get_task_tag(se_cmd_t *);
+extern int tcm_mvsas_get_cmd_state(se_cmd_t *);
+extern void tcm_mvsas_new_cmd_failure(se_cmd_t *);
+extern int tcm_mvsas_queue_data_in(se_cmd_t *);
+extern int tcm_mvsas_queue_status(se_cmd_t *);
+extern int tcm_mvsas_queue_tm_rsp(se_cmd_t *);
+extern u16 tcm_mvsas_get_fabric_sense_len(void);
+extern u16 tcm_mvsas_set_fabric_sense_len(se_cmd_t *, u32);
+extern int tcm_mvsas_is_state_remove(se_cmd_t *);
+extern u64 tcm_mvsas_pack_lun(unsigned int);
-- 
1.5.6.5

