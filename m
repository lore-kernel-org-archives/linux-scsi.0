From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC 3/3] tcm_qla2xxx: Add HW target mode I/O, control and TMR path code
Date: Wed, 15 Dec 2010 12:33:38 -0800
Message-ID: <1292445218-15005-4-git-send-email-nab@linux-iscsi.org>
References: <1292445218-15005-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1292445218-15005-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Ra
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds initial support for functioning READ and WRITE I/O into
tcm_qla2xxx fabric module code and TCM backends using new qla2x_target.c
LLD logic introduced into commit 3d21d3e3a9e2.  This includes support for
demo-mode TPG access and explict NodeACLs via configfs using
tcm_qla2xxx_setup_nacl_from_rport() from libfc struct fc_host->rports.

This patch also adds support for using tcm_qla2xxx_lport->lport_fcport_map
and ->lport_loopid_map to track struct se_node_acl pointers for individual
24-bit Port ID and 16-bit Loop ID values for qla_target_template
->find_sess_by_s_id() and ->find_sess_by_loop_id() used in a number of
locations into the primary I/O dispatch logic in qla2x_target.c LLD code.

The main piece to setup a FC Nexus is done in tcm_qla2xxx_check_initiator_node_acl(),
which calls tcm_qla2xxx_set_sess_by_[s_id,loop_id]() to setup our
lport->lport_fcport_map and lport_loopid_map pointers respectively, and register
the new nexus with TCM via __transport_register_session().  The FC nexus release and
reset path is done via a qla2x_target.c LLD callback to tcm_qla2xxx_free_session()
which calls transport_deregister_session_configfs(), then to clear the
tcm_qla2xxx_set_sess_by_[s_id,loop_id]() struct se_nacl pointer, and finally
transport_deregister_session() to release our struct se_session.

For the functioning non NPIV case in tcm_qla2xxx_configfs.c:tcm_qla2xxx_make_tpg()
we use a single lport->tpg_1 pointer, and only allow a single scsi_qla_host_t *
per struct tcm_qla2xxx_lport.  The NPIV configfs code is still a WIP and is using
NOPs for in tcm_qla2xxx_configfs.c at this point.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_qla2xxx/Kbuild                 |    6 +
 drivers/target/tcm_qla2xxx/Kconfig                |    6 +
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h     |   91 ++
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c | 1319 +++++++++++++++++++++
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c   |  766 ++++++++++++
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.h   |   48 +
 6 files changed, 2236 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/tcm_qla2xxx/Kbuild
 create mode 100644 drivers/target/tcm_qla2xxx/Kconfig
 create mode 100644 drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h
 create mode 100644 drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c
 create mode 100644 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c
 create mode 100644 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.h

diff --git a/drivers/target/tcm_qla2xxx/Kbuild b/drivers/target/tcm_qla2xxx/Kbuild
new file mode 100644
index 0000000..067cca1
--- /dev/null
+++ b/drivers/target/tcm_qla2xxx/Kbuild
@@ -0,0 +1,6 @@
+EXTRA_CFLAGS += -I$(srctree)/drivers/target/ -I$(srctree)/drivers/scsi/ -I$(srctree)/drivers/scsi/qla2xxx/ -I$(srctree)/include/scsi/ -I$(srctree)/drivers/target/tcm_qla2xxx/
+
+tcm_qla2xxx-objs		:= tcm_qla2xxx_fabric.o \
+				   tcm_qla2xxx_configfs.o \
+
+obj-$(CONFIG_TCM_QLA2XXX)	+= tcm_qla2xxx.o
diff --git a/drivers/target/tcm_qla2xxx/Kconfig b/drivers/target/tcm_qla2xxx/Kconfig
new file mode 100644
index 0000000..b9002fc
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
index 0000000..fbe6628
--- /dev/null
+++ b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h
@@ -0,0 +1,91 @@
+#include <target/target_core_base.h>
+
+#define TCM_QLA2XXX_VERSION	"v0.1"
+/* length of ASCII WWPNs including pad */
+#define TCM_QLA2XXX_NAMELEN	32
+/* lenth of ASCII NPIV 'WWPN+WWNN' including pad */
+#define TCM_QLA2XXX_NPIV_NAMELEN 66
+
+#include "qla2x_target.h"
+
+#if 0
+#define DEBUG_Q2T_SESS_MAP(x...)	printk(KERN_INFO x)
+#else
+#define DEBUG_Q2T_SESS_MAP(x...)
+#endif
+
+struct tcm_qla2xxx_nacl {
+	/* From libfc struct fc_rport->port_id */
+	u16 nport_id;
+	/* Binary World Wide unique Node Name for remote FC Initiator Nport */
+	u64 nport_wwnn;
+	/* ASCII formatted WWPN for FC Initiator Nport */
+	char nport_name[TCM_QLA2XXX_NAMELEN];
+	/* Pointer to q2t_sess */
+	struct q2t_sess *q2t_sess;
+	/* Pointer to TCM FC nexus */
+	struct se_session *nport_nexus;
+	/* Returned by tcm_qla2xxx_make_nodeacl() */
+	struct se_node_acl se_node_acl;
+};
+
+struct tcm_qla2xxx_tpg {
+	/* FC lport target portal group tag for TCM */
+	u16 lport_tpgt;
+	/* Atomic bit to determine TPG active status */
+	atomic_t lport_tpg_enabled;
+	/* Pointer back to tcm_qla2xxx_lport */
+	struct tcm_qla2xxx_lport *lport;
+	/* Returned by tcm_qla2xxx_make_tpg() */
+	struct se_portal_group se_tpg;
+};
+
+/*
+ * Used for the 24-bit lport->lport_fcport_map;
+ */
+struct tcm_qla2xxx_fc_al_pa {
+	struct se_node_acl *se_nacl;
+};
+
+struct tcm_qla2xxx_fc_area {
+        struct tcm_qla2xxx_fc_al_pa al_pas[256];
+};
+
+struct tcm_qla2xxx_fc_domain {
+        struct tcm_qla2xxx_fc_area areas[256];
+};
+
+struct tcm_qla2xxx_fc_loopid {
+	struct se_node_acl *se_nacl;
+};
+
+struct tcm_qla2xxx_lport {
+	/* SCSI protocol the lport is providing */
+	u8 lport_proto_id;
+	/* Binary World Wide unique Port Name for FC Target Lport */
+	u64 lport_wwpn;
+	/* Binary World Wide unique Port Name for FC NPIV Target Lport */
+	u64 lport_npiv_wwpn;
+	/* Binary World Wide unique Node Name for FC NPIV Target Lport */
+	u64 lport_npiv_wwnn;
+	/* ASCII formatted WWPN for FC Target Lport */
+	char lport_name[TCM_QLA2XXX_NAMELEN];
+	/* ASCII formatted WWPN+WWNN for NPIV FC Target Lport */
+	char lport_npiv_name[TCM_QLA2XXX_NPIV_NAMELEN];
+	/* vmalloc'ed memory for fc_port pointers in 24-bit FC Port ID space */
+	char *lport_fcport_map;
+	/* vmalloc-ed memory for fc_port pointers for 16-bit FC loop ID */
+	char *lport_loopid_map;
+	/* Pointer to struct scsi_qla_host from qla2xxx LLD */
+	struct scsi_qla_host *qla_vha;
+	/* Pointer to struct scsi_qla_host for NPIV VP from qla2xxx LLD */
+	struct scsi_qla_host *qla_npiv_vp;
+	/* Pointer to struct q2t_tgt pointer */
+	struct q2t_tgt lport_q2t_tgt;
+	/* Pointer to struct fc_vport for NPIV vport from libfc */
+	struct fc_vport *npiv_vport;
+	/* Pointer to TPG=1 for non NPIV mode */
+	struct tcm_qla2xxx_tpg *tpg_1;
+	/* Returned by tcm_qla2xxx_make_lport() */
+	struct se_wwn lport_wwn;
+};
diff --git a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c
new file mode 100644
index 0000000..9cf9018
--- /dev/null
+++ b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c
@@ -0,0 +1,1319 @@
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
+#include <target/target_core_base.h>
+#include <target/configfs_macros.h>
+
+#include <tcm_qla2xxx_base.h>
+#include <tcm_qla2xxx_fabric.h>
+
+#include <qla_def.h>
+
+#undef TCM_QLA2XXX_CONFIGFS_C
+
+/* Local pointer to allocated TCM configfs fabric module */
+struct target_fabric_configfs *tcm_qla2xxx_fabric_configfs;
+struct target_fabric_configfs *tcm_qla2xxx_npiv_fabric_configfs;
+
+static int tcm_qla2xxx_setup_nacl_from_rport(
+	struct se_portal_group *se_tpg,
+	struct se_node_acl *se_nacl,
+	struct tcm_qla2xxx_lport *lport,
+	struct tcm_qla2xxx_nacl *nacl,
+	u64 rport_wwnn)
+{
+	struct scsi_qla_host *vha = lport->qla_vha;
+	struct Scsi_Host *sh = vha->host;
+	struct fc_host_attrs *fc_host = shost_to_fc_host(sh);
+	struct fc_rport *rport;
+	struct tcm_qla2xxx_fc_domain *d;
+	struct tcm_qla2xxx_fc_area *a;
+	struct tcm_qla2xxx_fc_al_pa *p;
+	unsigned long flags;
+	unsigned char domain, area, al_pa;
+	/*
+	 * Scan the existing rports, and create a session for the
+	 * explict NodeACL is an matching rport->node_name already
+	 * exists.
+	 */
+	spin_lock_irqsave(sh->host_lock, flags);
+	list_for_each_entry(rport, &fc_host->rports, peers) {
+		if (rport_wwnn != rport->node_name)
+			continue;
+
+		DEBUG_Q2T_SESS_MAP("Located existing rport_wwpn and rport->node_name:"
+			" 0x%016LX, port_id: 0x%04x\n", rport->node_name,
+			rport->port_id);
+		domain = (rport->port_id >> 16) & 0xff;
+		area = (rport->port_id >> 8) & 0xff;
+		al_pa = rport->port_id & 0xff;
+		nacl->nport_id = rport->port_id;
+
+		DEBUG_Q2T_SESS_MAP("fc_rport domain: 0x%02x area: 0x%02x al_pa: %02x\n",
+				domain, area, al_pa);
+		spin_unlock_irqrestore(sh->host_lock, flags);
+
+		d = (struct tcm_qla2xxx_fc_domain *)&lport->lport_fcport_map[domain];
+		DEBUG_Q2T_SESS_MAP("Using d: %p for domain: 0x%02x\n", d, domain);
+		a = &d->areas[area];
+		DEBUG_Q2T_SESS_MAP("Using a: %p for area: 0x%02x\n", a, area);
+		p = &a->al_pas[al_pa];
+		DEBUG_Q2T_SESS_MAP("Using p: %p for al_pa: 0x%02x\n", p, al_pa);
+
+		p->se_nacl = se_nacl;
+		DEBUG_Q2T_SESS_MAP("Setting p->se_nacl to se_nacl: %p for WWNN: 0x%016LX,"
+			" port_id: 0x%04x\n", se_nacl, rport_wwnn,
+			nacl->nport_id);
+
+		return 1;
+	}
+	spin_unlock_irqrestore(sh->host_lock, flags);
+
+	return 0;
+}
+
+int tcm_qla2xxx_clear_nacl_from_fcport_map(
+	struct se_node_acl *se_nacl)
+{
+	struct se_portal_group *se_tpg = se_nacl->se_tpg;
+	struct se_wwn *se_wwn = se_tpg->se_tpg_wwn;
+	struct tcm_qla2xxx_lport *lport = container_of(se_wwn,
+				struct tcm_qla2xxx_lport, lport_wwn);
+	struct tcm_qla2xxx_nacl *nacl = container_of(se_nacl,
+				struct tcm_qla2xxx_nacl, se_node_acl);
+	struct tcm_qla2xxx_fc_domain *d;
+	struct tcm_qla2xxx_fc_area *a;
+	struct tcm_qla2xxx_fc_al_pa *p;
+	unsigned char domain, area, al_pa;
+
+	domain = (nacl->nport_id >> 16) & 0xff;
+	area = (nacl->nport_id >> 8) & 0xff;
+	al_pa = nacl->nport_id & 0xff;
+
+	DEBUG_Q2T_SESS_MAP("fc_rport domain: 0x%02x area: 0x%02x al_pa: %02x\n",
+			domain, area, al_pa);
+
+	d = (struct tcm_qla2xxx_fc_domain *)&lport->lport_fcport_map[domain];
+	DEBUG_Q2T_SESS_MAP("Using d: %p for domain: 0x%02x\n", d, domain);
+	a = &d->areas[area];
+	DEBUG_Q2T_SESS_MAP("Using a: %p for area: 0x%02x\n", a, area);
+	p = &a->al_pas[al_pa];
+	DEBUG_Q2T_SESS_MAP("Using p: %p for al_pa: 0x%02x\n", p, al_pa);
+
+	p->se_nacl = NULL;
+	DEBUG_Q2T_SESS_MAP("Clearing p->se_nacl to se_nacl: %p for WWNN: 0x%016LX,"
+		" port_id: 0x%04x\n", se_nacl, nacl->nport_wwnn,
+		nacl->nport_id);
+
+	return 0;
+}
+
+static struct se_node_acl *tcm_qla2xxx_make_nodeacl(
+	struct se_portal_group *se_tpg,
+	struct config_group *group,
+	const char *name)
+{
+	struct se_wwn *se_wwn = se_tpg->se_tpg_wwn;
+	struct tcm_qla2xxx_lport *lport = container_of(se_wwn,
+				struct tcm_qla2xxx_lport, lport_wwn);
+	struct se_node_acl *se_nacl, *se_nacl_new;
+	struct tcm_qla2xxx_nacl *nacl;
+	u64 wwnn;
+	u32 qla2xxx_nexus_depth;
+	int rc;
+
+	if (tcm_qla2xxx_parse_wwn(name, &wwnn, 1) < 0)
+		return ERR_PTR(-EINVAL);
+
+	se_nacl_new = tcm_qla2xxx_alloc_fabric_acl(se_tpg);
+	if (!(se_nacl_new))
+		return ERR_PTR(-ENOMEM);
+//#warning FIXME: Hardcoded qla2xxx_nexus depth in tcm_qla2xxx_make_nodeacl()
+	qla2xxx_nexus_depth = 1;
+
+	/*
+	 * se_nacl_new may be released by core_tpg_add_initiator_node_acl()
+	 * when converting a NodeACL from demo mode -> explict
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
+	nacl->nport_wwnn = wwnn;
+	tcm_qla2xxx_format_wwn(&nacl->nport_name[0], TCM_QLA2XXX_NAMELEN, wwnn);
+	/*
+	 * Setup a se_nacl handle based on an a matching struct fc_rport setup
+	 * via drivers/scsi/qla2xxx/qla_init.c:qla2x00_reg_remote_port()
+	 */
+	rc = tcm_qla2xxx_setup_nacl_from_rport(se_tpg, se_nacl, lport,
+					nacl, wwnn);
+	if (rc < 0) {
+		tcm_qla2xxx_release_fabric_acl(se_tpg, se_nacl_new);
+		return ERR_PTR(rc);
+	}
+
+	return se_nacl;;
+}
+
+static void tcm_qla2xxx_drop_nodeacl(struct se_node_acl *se_acl)
+{
+	struct se_portal_group *se_tpg = se_acl->se_tpg;
+	struct tcm_qla2xxx_nacl *nacl = container_of(se_acl,
+				struct tcm_qla2xxx_nacl, se_node_acl);
+
+	core_tpg_del_initiator_node_acl(se_tpg, se_acl, 1);
+	kfree(nacl);
+}
+
+static ssize_t tcm_qla2xxx_tpg_show_enable(
+	struct se_portal_group *se_tpg,
+	char *page)
+{
+	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
+			struct tcm_qla2xxx_tpg, se_tpg);
+
+	return snprintf(page, PAGE_SIZE, "%d\n",
+			atomic_read(&tpg->lport_tpg_enabled));
+}
+
+extern void q2t_target_stop(struct q2t_tgt *);
+
+static ssize_t tcm_qla2xxx_tpg_store_enable(
+	struct se_portal_group *se_tpg,
+	const char *page,
+	size_t count)
+{
+	struct se_wwn *se_wwn = se_tpg->se_tpg_wwn;
+	struct tcm_qla2xxx_lport *lport = container_of(se_wwn,
+			struct tcm_qla2xxx_lport, lport_wwn);
+	struct scsi_qla_host *vha = lport->qla_vha;
+	struct qla_hw_data *ha = vha->hw;
+	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
+			struct tcm_qla2xxx_tpg, se_tpg);
+	char *endptr;
+	u32 op;
+
+	op = simple_strtoul(page, &endptr, 0);
+	if ((op != 1) && (op != 0)) {
+		printk(KERN_ERR "Illegal value for tpg_enable: %u\n", op);
+		return -EINVAL;
+	}
+
+	if (op) {
+		atomic_set(&tpg->lport_tpg_enabled, 1);
+		qla2x00_enable_tgt_mode(vha);
+	} else {
+		if (!ha->q2t_tgt) {
+			printk(KERN_ERR "truct qla_hw_data *ha->q2t_tgt is NULL\n");
+			return -ENODEV;
+		}
+		atomic_set(&tpg->lport_tpg_enabled, 0);
+		q2t_target_stop(ha->q2t_tgt);
+	}
+
+	return count;
+}
+
+TF_TPG_BASE_ATTR(tcm_qla2xxx, enable, S_IRUGO | S_IWUSR);
+
+static struct configfs_attribute *tcm_qla2xxx_tpg_attrs[] = {
+	&tcm_qla2xxx_tpg_enable.attr,
+	NULL,
+};
+
+static struct se_portal_group *tcm_qla2xxx_make_tpg(
+	struct se_wwn *wwn,
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
+	if (strict_strtoul(name + 5, 10, &tpgt) || tpgt > USHRT_MAX)
+		return ERR_PTR(-EINVAL);
+
+	if ((lport->qla_npiv_vp == NULL) && (tpgt != 1)) {
+		printk(KERN_ERR "In non NPIV mode, a single TPG=1 is used for"
+			" HW port mappings\n");
+		return ERR_PTR(-ENOSYS);
+	}
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
+	/*
+	 * Setup local TPG=1 pointer for non NPIV mode.
+	 */
+	if (lport->qla_npiv_vp == NULL)
+		lport->tpg_1 = tpg;
+
+	return &tpg->se_tpg;
+}
+
+static void tcm_qla2xxx_drop_tpg(struct se_portal_group *se_tpg)
+{
+	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
+			struct tcm_qla2xxx_tpg, se_tpg);
+	struct tcm_qla2xxx_lport *lport = tpg->lport;
+
+	core_tpg_deregister(se_tpg);
+	/*
+	 * Clear local TPG=1 pointer for non NPIV mode.
+	 */
+	if (lport->qla_npiv_vp == NULL)
+		lport->tpg_1 = NULL;
+
+	kfree(tpg);
+}
+
+static struct se_portal_group *tcm_qla2xxx_npiv_make_tpg(
+	struct se_wwn *wwn,
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
+	if (strict_strtoul(name + 5, 10, &tpgt) || tpgt > USHRT_MAX)
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
+	ret = core_tpg_register(&tcm_qla2xxx_npiv_fabric_configfs->tf_ops, wwn,
+				&tpg->se_tpg, (void *)tpg,
+				TRANSPORT_TPG_TYPE_NORMAL);
+	if (ret < 0) {
+		kfree(tpg);
+		return NULL;
+	}
+	return &tpg->se_tpg;
+}
+
+static struct q2t_sess *tcm_qla2xxx_find_sess_by_s_id(
+	scsi_qla_host_t *vha,
+	const uint8_t *s_id)
+{
+	struct qla_hw_data *ha = vha->hw;
+	struct tcm_qla2xxx_lport *lport;
+	struct se_node_acl *se_nacl;
+	struct tcm_qla2xxx_nacl *nacl;
+	struct tcm_qla2xxx_fc_domain *d;
+	struct tcm_qla2xxx_fc_area *a;
+	struct tcm_qla2xxx_fc_al_pa *p;
+	unsigned char domain, area, al_pa;
+
+	lport = (struct tcm_qla2xxx_lport *)ha->target_lport_ptr;
+	if (!lport) {
+		printk(KERN_ERR "Unable to locate struct tcm_qla2xxx_lport\n");
+		dump_stack();
+		return NULL;
+	}
+
+	domain = s_id[0];
+	area = s_id[1];
+	al_pa = s_id[2];
+
+	DEBUG_Q2T_SESS_MAP("find_sess_by_s_id: 0x%02x area: 0x%02x al_pa: %02x\n",
+			domain, area, al_pa);
+
+	d = (struct tcm_qla2xxx_fc_domain *)&lport->lport_fcport_map[domain];
+	DEBUG_Q2T_SESS_MAP("Using d: %p for domain: 0x%02x\n", d, domain);
+	a = &d->areas[area];
+	DEBUG_Q2T_SESS_MAP("Using a: %p for area: 0x%02x\n", a, area);
+	p = &a->al_pas[al_pa];
+	DEBUG_Q2T_SESS_MAP("Using p: %p for al_pa: 0x%02x\n", p, al_pa);
+
+	se_nacl = p->se_nacl;
+	if (!se_nacl) {
+		printk(KERN_ERR "Unable to locate s_id: 0x%02x area: 0x%02x"
+			" al_pa: %02x\n", domain, area, al_pa);
+		return NULL;
+	}
+	DEBUG_Q2T_SESS_MAP("find_sess_by_s_id: located se_nacl: %p,"
+		" initiatorname: %s\n", se_nacl, se_nacl->initiatorname);
+
+	nacl = container_of(se_nacl, struct tcm_qla2xxx_nacl, se_node_acl);
+	if (!nacl->q2t_sess) {
+		printk(KERN_ERR "Unable to locate struct q2t_sess\n");
+		return NULL;
+	}
+
+	return nacl->q2t_sess;
+}
+
+static void tcm_qla2xxx_set_sess_by_s_id(
+	struct tcm_qla2xxx_lport *lport,
+	struct se_node_acl *new_se_nacl,
+	struct tcm_qla2xxx_nacl *nacl,
+	struct se_session *se_sess,
+	struct q2t_sess *q2t_sess,
+	uint8_t *s_id)
+{
+	struct se_node_acl *saved_nacl;
+	struct tcm_qla2xxx_fc_domain *d;
+	struct tcm_qla2xxx_fc_area *a;
+	struct tcm_qla2xxx_fc_al_pa *p;
+	unsigned char domain, area, al_pa;
+
+	domain = s_id[0];
+	area = s_id[1];
+	al_pa = s_id[2];
+	DEBUG_Q2T_SESS_MAP("set_sess_by_s_id: domain 0x%02x area: 0x%02x al_pa: %02x\n",
+			domain, area, al_pa);
+
+	d = (struct tcm_qla2xxx_fc_domain *)&lport->lport_fcport_map[domain];
+	DEBUG_Q2T_SESS_MAP("Using d: %p for domain: 0x%02x\n", d, domain);
+	a = &d->areas[area];
+	DEBUG_Q2T_SESS_MAP("Using a: %p for area: 0x%02x\n", a, area);
+	p = &a->al_pas[al_pa];
+	DEBUG_Q2T_SESS_MAP("Using p: %p for al_pa: 0x%02x\n", p, al_pa);
+
+	saved_nacl = p->se_nacl;
+	if (!saved_nacl) {
+		DEBUG_Q2T_SESS_MAP("Setting up new p->se_nacl to new_se_nacl\n");
+		p->se_nacl = new_se_nacl;
+		q2t_sess->se_sess = se_sess;
+		nacl->q2t_sess = q2t_sess;
+		return;
+	}
+
+	if (nacl->q2t_sess) {
+		if (new_se_nacl == NULL) {
+			DEBUG_Q2T_SESS_MAP("Clearing existing nacl->q2t_sess"
+					" and p->se_nacl\n");
+			p->se_nacl = NULL;
+			nacl->q2t_sess = NULL;
+			return;
+		}
+		DEBUG_Q2T_SESS_MAP("Replacing existing nacl->q2t_sess and"
+				" p->se_nacl\n");
+		p->se_nacl = new_se_nacl;
+		q2t_sess->se_sess = se_sess;
+		nacl->q2t_sess = q2t_sess;
+		return;
+	}
+
+	if (new_se_nacl == NULL) {
+		DEBUG_Q2T_SESS_MAP("Clearing existing p->se_nacl\n");
+		p->se_nacl = NULL;
+		return;
+	}
+
+	DEBUG_Q2T_SESS_MAP("Replacing existing p->se_nacl w/o active"
+				" nacl->q2t_sess\n");
+	p->se_nacl = new_se_nacl;
+	q2t_sess->se_sess = se_sess;
+	nacl->q2t_sess = q2t_sess;
+
+	DEBUG_Q2T_SESS_MAP("Setup nacl->q2t_sess %p by s_id for se_nacl: %p,"
+		" initiatorname: %s\n", nacl->q2t_sess, new_se_nacl,
+		new_se_nacl->initiatorname);
+}
+
+static struct q2t_sess *tcm_qla2xxx_find_sess_by_loop_id(
+	scsi_qla_host_t *vha,
+	const uint16_t loop_id)
+{
+	struct qla_hw_data *ha = vha->hw;
+	struct tcm_qla2xxx_lport *lport;
+	struct se_node_acl *se_nacl;
+	struct tcm_qla2xxx_nacl *nacl;
+	struct tcm_qla2xxx_fc_loopid *fc_loopid;
+
+	lport = (struct tcm_qla2xxx_lport *)ha->target_lport_ptr;
+	if (!lport) {
+		printk(KERN_ERR "Unable to locate struct tcm_qla2xxx_lport\n");
+		dump_stack();
+		return NULL;
+	}
+
+	DEBUG_Q2T_SESS_MAP("find_sess_by_loop_id: Using loop_id: 0x%04x\n", loop_id);
+
+	fc_loopid = (struct tcm_qla2xxx_fc_loopid *)&lport->lport_loopid_map[loop_id];
+
+	se_nacl = fc_loopid->se_nacl;
+	if (!se_nacl) {
+		printk(KERN_ERR "Unable to locate se_nacl by loop_id:"
+				" 0x%04x\n", loop_id);
+		return NULL;
+	}
+
+	nacl = container_of(se_nacl, struct tcm_qla2xxx_nacl, se_node_acl);
+
+	if (!nacl->q2t_sess) {
+		printk(KERN_ERR "Unable to locate struct q2t_sess\n");
+		return NULL;
+	}
+
+	return nacl->q2t_sess;
+}
+
+static void tcm_qla2xxx_set_sess_by_loop_id(
+	struct tcm_qla2xxx_lport *lport,
+	struct se_node_acl *new_se_nacl,
+	struct tcm_qla2xxx_nacl *nacl,
+	struct se_session *se_sess,
+	struct q2t_sess *q2t_sess,
+	uint16_t loop_id)
+{
+	struct se_node_acl *saved_nacl;
+	struct tcm_qla2xxx_fc_loopid *fc_loopid;
+
+	DEBUG_Q2T_SESS_MAP("set_sess_by_loop_id: Using loop_id: 0x%04x\n", loop_id);
+
+	fc_loopid = (struct tcm_qla2xxx_fc_loopid *)&lport->lport_loopid_map[loop_id];
+
+	saved_nacl = fc_loopid->se_nacl;
+	if (!saved_nacl) {
+		DEBUG_Q2T_SESS_MAP("Setting up new fc_loopid->se_nacl"
+				" to new_se_nacl\n");
+		fc_loopid->se_nacl = new_se_nacl;
+		if (q2t_sess->se_sess != se_sess)
+			q2t_sess->se_sess = se_sess;
+		if (nacl->q2t_sess != q2t_sess)
+			nacl->q2t_sess = q2t_sess;
+		return;
+	}
+
+	if (nacl->q2t_sess) {
+		if (new_se_nacl == NULL) {
+			DEBUG_Q2T_SESS_MAP("Clearing nacl->q2t_sess and"
+					" fc_loopid->se_nacl\n");
+			fc_loopid->se_nacl = NULL;
+			nacl->q2t_sess = NULL;
+			return;
+		}
+
+		DEBUG_Q2T_SESS_MAP("Replacing existing nacl->q2t_sess and"
+				" fc_loopid->se_nacl\n");
+		fc_loopid->se_nacl = new_se_nacl;
+		if (q2t_sess->se_sess != se_sess)
+			q2t_sess->se_sess = se_sess;
+		if (nacl->q2t_sess != q2t_sess)
+			nacl->q2t_sess = q2t_sess;
+		return;
+	}
+
+	if (new_se_nacl == NULL) {
+		DEBUG_Q2T_SESS_MAP("Clearing fc_loopid->se_nacl\n");
+		fc_loopid->se_nacl = NULL;
+		return;
+	}
+
+	DEBUG_Q2T_SESS_MAP("Replacing existing fc_loopid->se_nacl w/o"
+			" active nacl->q2t_sess\n");
+	fc_loopid->se_nacl = new_se_nacl;
+	if (q2t_sess->se_sess != se_sess)
+		q2t_sess->se_sess = se_sess;
+	if (nacl->q2t_sess != q2t_sess)
+		nacl->q2t_sess = q2t_sess;
+
+	DEBUG_Q2T_SESS_MAP("Setup nacl->q2t_sess %p by loop_id for se_nacl: %p,"
+		" initiatorname: %s\n", nacl->q2t_sess, new_se_nacl,
+		new_se_nacl->initiatorname);
+}
+
+static void tcm_qla2xxx_free_session(struct q2t_sess *sess)
+{
+	struct q2t_tgt *tgt = sess->tgt;
+	struct qla_hw_data *ha = tgt->ha;
+	struct se_session *se_sess;
+	struct se_node_acl *se_nacl;
+	struct tcm_qla2xxx_lport *lport;
+	struct tcm_qla2xxx_nacl *nacl;
+	unsigned char be_sid[3];
+
+	se_sess = sess->se_sess;
+	if (!se_sess) {
+		printk(KERN_ERR "struct q2t_sess->se_sess is NULL\n");
+		dump_stack();
+		return;
+	}
+	se_nacl = se_sess->se_node_acl;
+        nacl = container_of(se_nacl, struct tcm_qla2xxx_nacl, se_node_acl);
+
+	lport = (struct tcm_qla2xxx_lport *)ha->target_lport_ptr;
+	if (!lport) {
+		printk(KERN_ERR "Unable to locate struct tcm_qla2xxx_lport\n");
+		dump_stack();
+		return;
+	}
+	/*
+	 * Now clear the struct se_node_acl->nacl_sess pointer
+	 */
+	transport_deregister_session_configfs(sess->se_sess);
+
+        /*
+         * And now clear the se_nacl and session pointers from our HW lport
+         * mappings for fabric S_ID and LOOP_ID.
+         */
+	memset(&be_sid, 0, 3);
+	be_sid[0] = sess->s_id.b.domain;
+	be_sid[1] = sess->s_id.b.area;
+	be_sid[2] = sess->s_id.b.al_pa;
+
+        tcm_qla2xxx_set_sess_by_s_id(lport, NULL, nacl, se_sess,
+                        sess, be_sid);
+        tcm_qla2xxx_set_sess_by_loop_id(lport, NULL, nacl, se_sess,
+                        sess, sess->loop_id);
+	/*
+	 * Release the FC nexus -> target se_session link now.
+	 */
+	transport_deregister_session(sess->se_sess);
+}
+
+/*
+ * Called via q2t_create_sess():ha->qla2x_tmpl->check_initiator_node_acl()
+ * to locate struct se_node_acl
+ */
+static int tcm_qla2xxx_check_initiator_node_acl(
+	scsi_qla_host_t *vha,
+	void *q2t_sess,
+	uint8_t *s_id,
+	uint16_t loop_id)
+{
+	struct qla_hw_data *ha = vha->hw;
+	struct tcm_qla2xxx_lport *lport;
+	struct tcm_qla2xxx_tpg *tpg;
+	struct tcm_qla2xxx_nacl *nacl;
+	struct se_portal_group *se_tpg;
+	struct se_node_acl *se_nacl;
+	struct se_session *se_sess;
+	struct q2t_sess *sess = q2t_sess;
+	unsigned char port_name[36];
+
+	lport = (struct tcm_qla2xxx_lport *)ha->target_lport_ptr;
+	if (!lport) {
+		printk(KERN_ERR "Unable to locate struct tcm_qla2xxx_lport\n");
+		dump_stack();
+		return -EINVAL;
+	}
+	/*
+	 * Locate the TPG=1 reference..
+	 */
+	tpg = lport->tpg_1;
+	if (!tpg) {
+		printk(KERN_ERR "Unable to lcoate struct tcm_qla2xxx_lport->tpg_1\n");
+		return -EINVAL;
+	}
+	se_tpg = &tpg->se_tpg;
+
+	se_sess = transport_init_session();
+	if (!se_sess) {
+		printk(KERN_ERR "Unable to initialize struct se_session\n");
+		return -ENOMEM;
+	}
+	/*
+	 * Format the FCP Initiator port_name into colon seperated values to match
+	 * the format by tcm_qla2xxx explict ConfigFS NodeACLs.
+	 */
+	memset(&port_name, 0, 36);
+	snprintf(port_name, 36, "%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x",
+		sess->port_name[0], sess->port_name[1], sess->port_name[2],
+		sess->port_name[3], sess->port_name[4], sess->port_name[5],
+		sess->port_name[6], sess->port_name[7]);
+	/*
+	 * Locate our struct se_node_acl either from an explict NodeACL created
+	 * via ConfigFS, or via running in TPG demo mode.
+	 */
+	se_sess->se_node_acl = core_tpg_check_initiator_node_acl(se_tpg, port_name);
+	if (!se_sess->se_node_acl) {
+		transport_free_session(se_sess);
+		return -EINVAL;
+	}
+	se_nacl = se_sess->se_node_acl;
+	nacl = container_of(se_nacl, struct tcm_qla2xxx_nacl, se_node_acl);
+	/*
+	 * And now setup the new se_nacl and session pointers into our HW lport
+	 * mappings for fabric S_ID and LOOP_ID.
+	 */
+	tcm_qla2xxx_set_sess_by_s_id(lport, se_nacl, nacl, se_sess,
+			q2t_sess, s_id);
+	tcm_qla2xxx_set_sess_by_loop_id(lport, se_nacl, nacl, se_sess,
+			q2t_sess, loop_id);
+	/*
+	 * Finally register the new FC Nexus with TCM
+	 */
+	__transport_register_session(se_nacl->se_tpg, se_nacl, se_sess, nacl);
+
+	return 0;
+}
+
+/*
+ * Calls into tcm_qla2xxx used by qla2xxx LLD I/O path.
+ */
+static struct qla_target_template tcm_qla2xxx_template = {
+	.handle_cmd		= tcm_qla2xxx_handle_cmd,
+	.handle_data		= tcm_qla2xxx_handle_data,
+	.handle_tmr		= tcm_qla2xxx_handle_tmr,
+	.free_cmd		= tcm_qla2xxx_free_cmd,
+	.free_session		= tcm_qla2xxx_free_session,
+	.check_initiator_node_acl = tcm_qla2xxx_check_initiator_node_acl,
+	.find_sess_by_s_id	= tcm_qla2xxx_find_sess_by_s_id,
+	.find_sess_by_loop_id	= tcm_qla2xxx_find_sess_by_loop_id,
+};
+
+static int tcm_qla2xxx_init_lport(
+	struct tcm_qla2xxx_lport *lport,
+	struct scsi_qla_host *vha,
+	struct scsi_qla_host *npiv_vp)
+{
+	struct qla_hw_data *ha = vha->hw;
+
+	lport->lport_fcport_map = vmalloc(
+			sizeof(struct tcm_qla2xxx_fc_domain) * 256);
+	if (!(lport->lport_fcport_map)) {
+		printk(KERN_ERR "Unable to allocate lport_fcport_map of %lu"
+			" bytes\n", sizeof(struct tcm_qla2xxx_fc_domain) * 256);
+		return -ENOMEM;
+	}
+	memset(lport->lport_fcport_map, 0,
+			sizeof(struct tcm_qla2xxx_fc_domain) * 256);
+	printk(KERN_INFO "qla2xxx: Allocated lport_fcport_map of %lu bytes\n",
+			sizeof(struct tcm_qla2xxx_fc_domain) * 256);
+
+	lport->lport_loopid_map = vmalloc(sizeof(struct tcm_qla2xxx_fc_loopid) *
+				65536);
+	if (!(lport->lport_loopid_map)) {
+		printk(KERN_ERR "Unable to allocate lport->lport_loopid_map"
+			" of %lu bytes\n", sizeof(struct tcm_qla2xxx_fc_loopid)
+			* 65536);
+		vfree(lport->lport_fcport_map);
+		return -ENOMEM;
+	}
+	memset(lport->lport_loopid_map, 0, sizeof(struct tcm_qla2xxx_fc_loopid)
+			* 65536);
+	printk(KERN_INFO "qla2xxx: Allocated lport_loopid_map of %lu bytes\n",
+			sizeof(struct tcm_qla2xxx_fc_loopid) * 65536);
+	/*
+	 * Setup local pointer to vha, NPIV VP pointer (if present) and
+	 * vha->tcm_lport pointer
+	 */
+	lport->qla_vha = vha;
+	lport->qla_npiv_vp = npiv_vp;
+	/*
+	 * Setup the target_lport_ptr and qla2x_tmpl.
+	 */
+	ha->target_lport_ptr = lport;
+	ha->qla2x_tmpl = &tcm_qla2xxx_template;
+
+	return 0;
+}
+
+static struct se_wwn *tcm_qla2xxx_make_lport(
+	struct target_fabric_configfs *tf,
+	struct config_group *group,
+	const char *name)
+{
+	struct tcm_qla2xxx_lport *lport;
+	struct Scsi_Host *host = NULL;
+	struct pci_dev *dev = NULL;
+	struct scsi_qla_host *vha;
+	struct qla_hw_data *ha;
+	unsigned long flags;
+	u64 wwpn;
+	int i, ret = -ENODEV;
+	u8 b[8];
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
+	while ((dev = pci_get_device(PCI_VENDOR_ID_QLOGIC, PCI_ANY_ID,
+					dev)) != NULL) {
+
+		vha = pci_get_drvdata(dev);
+		if (!vha)
+			continue;
+		ha = vha->hw;
+		if (!ha)
+			continue;
+		host = vha->host;
+		if (!host)
+			continue;
+
+		if (!(host->hostt->supported_mode & MODE_TARGET))
+			continue;
+
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		if (host->active_mode & MODE_TARGET) {
+			printk(KERN_INFO "MODE_TARGET already active on qla2xxx"
+					"(%d)\n",  host->host_no);
+			spin_unlock_irqrestore(&ha->hardware_lock, flags);
+			continue;
+		}
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+		if (!scsi_host_get(host)) {
+			printk(KERN_ERR "Unable to scsi_host_get() for"
+				" qla2xxx scsi_host\n");
+			ret = -EINVAL;
+			goto out;
+		}
+
+		printk("qla2xxx HW vha->node_name: ");
+		for (i = 0; i < 8; i++)
+			printk("%02x ", vha->node_name[i]);
+		printk("\n");
+
+		printk("qla2xxx HW vha->port_name: ");
+		for (i = 0; i < 8; i++)
+			printk("%02x ", vha->port_name[i]);
+		printk("\n");
+
+		printk("qla2xxx passed configfs WWPN: ");
+		put_unaligned_be64(wwpn, b);
+		for (i = 0; i < 8; i++)
+			printk("%02x ", b[i]);
+		printk("\n");
+
+		if (memcmp(vha->port_name, b, 8)) {
+			scsi_host_put(host);
+			continue;
+		}
+		printk("qla2xxx: Found matching HW WWPN: %s for lport\n", name);
+		ret = tcm_qla2xxx_init_lport(lport, vha, NULL);
+		break;
+	}
+
+	if (ret != 0)
+		goto out;
+
+	return &lport->lport_wwn;
+out:
+	kfree(lport);
+	return ERR_PTR(ret);
+}
+
+extern void q2t_target_stop(struct q2t_tgt *);
+
+static void tcm_qla2xxx_drop_lport(struct se_wwn *wwn)
+{
+	struct tcm_qla2xxx_lport *lport = container_of(wwn,
+			struct tcm_qla2xxx_lport, lport_wwn);
+	struct scsi_qla_host *vha = lport->qla_vha;
+	struct qla_hw_data *ha = vha->hw;
+	struct Scsi_Host *sh = vha->host;
+	/*
+	 * Call into qla2x_target.c LLD logic to shutdown the active
+	 * FC Nexuses and disable target mode operation for this qla_hw_data
+	 */
+	if ((ha->q2t_tgt != NULL) && !ha->q2t_tgt->tgt_stopped)
+		q2t_target_stop(ha->q2t_tgt);
+	/*
+	 * Clear the target_lport_ptr qla_target_template pointer in qla_hw_data
+	 */
+	ha->target_lport_ptr = NULL;
+	ha->qla2x_tmpl = NULL;
+	/*
+	 * Release the Scsi_Host reference for the underlying qla2xxx host
+	 */
+	scsi_host_put(sh);
+
+	vfree(lport->lport_loopid_map);
+	vfree(lport->lport_fcport_map);
+	kfree(lport);
+}
+
+static struct se_wwn *tcm_qla2xxx_npiv_make_lport(
+	struct target_fabric_configfs *tf,
+	struct config_group *group,
+	const char *name)
+{
+	struct tcm_qla2xxx_lport *lport;
+	struct Scsi_Host *host = NULL;
+	struct pci_dev *dev = NULL;
+	struct scsi_qla_host *vha, *npiv_vp;
+	struct qla_hw_data *ha;
+	struct fc_vport_identifiers vid;
+	struct fc_vport *vport;
+	unsigned long flags;
+	u64 npiv_wwpn, npiv_wwnn;
+	int i, ret = -ENODEV;
+	u8 b[8], b2[8];
+
+	if (tcm_qla2xxx_npiv_parse_wwn(name, strlen(name)+1,
+				&npiv_wwpn, &npiv_wwnn) < 0)
+		return ERR_PTR(-EINVAL);
+
+	lport = kzalloc(sizeof(struct tcm_qla2xxx_lport), GFP_KERNEL);
+	if (!(lport)) {
+		printk(KERN_ERR "Unable to allocate struct tcm_qla2xxx_lport"
+				" for NPIV\n");
+		return ERR_PTR(-ENOMEM);
+	}
+	lport->lport_npiv_wwpn = npiv_wwpn;
+	lport->lport_npiv_wwnn = npiv_wwnn;
+	tcm_qla2xxx_npiv_format_wwn(&lport->lport_npiv_name[0],
+			TCM_QLA2XXX_NAMELEN, npiv_wwpn, npiv_wwnn);
+
+	while ((dev = pci_get_device(PCI_VENDOR_ID_QLOGIC, PCI_ANY_ID,
+					dev)) != NULL) {
+
+		vha = pci_get_drvdata(dev);
+		if (!vha)
+			continue;
+		ha = vha->hw;
+		if (!ha)
+			continue;
+		host = vha->host;
+		if (!host)
+			continue;
+
+		if (!(host->hostt->supported_mode & MODE_TARGET))
+			continue;
+
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		if (host->active_mode & MODE_TARGET) {
+			printk(KERN_INFO "MODE_TARGET already active on qla2xxx"
+					"(%d)\n",  host->host_no);
+			spin_unlock_irqrestore(&ha->hardware_lock, flags);
+			continue;
+		}
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+		if (!scsi_host_get(host)) {
+			printk(KERN_ERR "Unable to scsi_host_get() for"
+				" qla2xxx scsi_host\n");
+			ret = -EINVAL;
+			goto out;
+		}
+
+		printk("qla2xxx HW vha->node_name: ");
+		for (i = 0; i < 8; i++)
+			printk("%02x ", vha->node_name[i]);
+		printk("\n");
+
+		printk("qla2xxx HW vha->port_name: ");
+		for (i = 0; i < 8; i++)
+			printk("%02x ", vha->port_name[i]);
+		printk("\n");
+
+		printk("qla2xxx passed configfs NPIV WWPN: ");
+		put_unaligned_be64(npiv_wwpn, b);
+		for (i = 0; i < 8; i++)
+			printk("%02x ", b[i]);
+		printk("\n");
+
+		printk("qla2xxx passed configfs NPIV WWNN: ");
+		put_unaligned_be64(npiv_wwnn, b2);
+		for (i = 0; i < 8; i++)
+			printk("%02x ", b2[i]);
+		printk("\n");
+
+		spin_lock_irqsave(&ha->vport_slock, flags);
+		list_for_each_entry(npiv_vp, &ha->vp_list, list) {
+			if (!npiv_vp->vp_idx)
+				continue;
+
+			if (memcmp(npiv_vp->port_name, b, 8) ||
+			    memcmp(npiv_vp->node_name, b2, 8))
+				continue;
+
+#warning FIXME: Need to add atomic_inc(&npiv_vp->vref_count) before dropping ha->vport_slock..?
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
+
+			printk("qla2xxx_npiv: Found matching NPIV WWPN+WWNN: %s "
+					" for lport\n", name);
+			tcm_qla2xxx_init_lport(lport, vha, npiv_vp);
+			/*
+			 * Setup fc_vport_identifiers for NPIV containing
+			 * the passed WWPN and WWNN for the new libfc vport.
+			 */
+			memset(&vid, 0, sizeof(vid));
+			vid.roles = FC_PORT_ROLE_FCP_INITIATOR;
+			vid.vport_type = FC_PORTTYPE_NPIV;
+			vid.port_name = npiv_wwpn;
+			vid.node_name = npiv_wwnn;
+			/* vid.symbolic_name is already zero/NULL's */
+			vid.disable = false;	/* always enabled */
+
+			/* we only allow support on Channel 0 !!! */
+			vport = fc_vport_create(host, 0, &vid);
+			if (!vport) {
+				printk(KERN_ERR "fc_vport_create() failed for"
+						" NPIV tcm_qla2xxx\n");
+				scsi_host_put(host);
+				ret = -EINVAL;
+				goto out;
+			}
+			lport->npiv_vport = vport;
+			ret = 0;
+			spin_lock_irqsave(&ha->vport_slock, flags);
+			break;
+		}
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
+
+		if (!ret)
+			break;
+
+		scsi_host_put(host);
+	}
+
+	if (ret != 0)
+		goto out;
+
+	return &lport->lport_wwn;
+out:
+	kfree(lport);
+	return ERR_PTR(ret);
+}
+
+static void tcm_qla2xxx_npiv_drop_lport(struct se_wwn *wwn)
+{
+	struct tcm_qla2xxx_lport *lport = container_of(wwn,
+			struct tcm_qla2xxx_lport, lport_wwn);
+	struct scsi_qla_host *vha = lport->qla_vha;
+	struct Scsi_Host *sh = vha->host;
+	/*
+	 * Notify libfc that we want to release the lport->npiv_vport
+	 */
+	fc_vport_terminate(lport->npiv_vport);
+
+	scsi_host_put(sh);
+	kfree(lport);
+}
+
+
+static ssize_t tcm_qla2xxx_wwn_show_attr_version(
+	struct target_fabric_configfs *tf,
+	char *page)
+{
+	return sprintf(page, "TCM QLOGIC QLA2XXX NPIV capable fabric module %s on %s/%s"
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
+	.tpg_check_demo_mode		= tcm_qla2xxx_check_true,
+	.tpg_check_demo_mode_cache	= tcm_qla2xxx_check_true,
+	.tpg_check_demo_mode_write_protect = tcm_qla2xxx_check_false,
+	.tpg_check_prod_mode_write_protect = tcm_qla2xxx_check_false,
+	.tpg_alloc_fabric_acl		= tcm_qla2xxx_alloc_fabric_acl,
+	.tpg_release_fabric_acl		= tcm_qla2xxx_release_fabric_acl,
+	.tpg_get_inst_index		= tcm_qla2xxx_tpg_get_inst_index,
+	.new_cmd_map			= tcm_qla2xxx_new_cmd_map,
+	.release_cmd_to_pool		= tcm_qla2xxx_release_cmd,
+	.release_cmd_direct		= tcm_qla2xxx_release_cmd,
+	.shutdown_session		= tcm_qla2xxx_shutdown_session,
+	.close_session			= tcm_qla2xxx_close_session,
+	.stop_session			= tcm_qla2xxx_stop_session,
+	.fall_back_to_erl0		= tcm_qla2xxx_reset_nexus,
+	.sess_logged_in			= tcm_qla2xxx_sess_logged_in,
+	.sess_get_index			= tcm_qla2xxx_sess_get_index,
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
+static struct target_core_fabric_ops tcm_qla2xxx_npiv_ops = {
+	.get_fabric_name		= tcm_qla2xxx_npiv_get_fabric_name,
+	.get_fabric_proto_ident		= tcm_qla2xxx_get_fabric_proto_ident,
+	.tpg_get_wwn			= tcm_qla2xxx_npiv_get_fabric_wwn,
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
+	.tpg_get_inst_index		= tcm_qla2xxx_tpg_get_inst_index,
+	.release_cmd_to_pool		= tcm_qla2xxx_release_cmd,
+	.release_cmd_direct		= tcm_qla2xxx_release_cmd,
+	.shutdown_session		= tcm_qla2xxx_shutdown_session,
+	.close_session			= tcm_qla2xxx_close_session,
+	.stop_session			= tcm_qla2xxx_stop_session,
+	.fall_back_to_erl0		= tcm_qla2xxx_reset_nexus,
+	.sess_logged_in			= tcm_qla2xxx_sess_logged_in,
+	.sess_get_index			= tcm_qla2xxx_sess_get_index,
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
+	.fabric_make_wwn		= tcm_qla2xxx_npiv_make_lport,
+	.fabric_drop_wwn		= tcm_qla2xxx_npiv_drop_lport,
+	.fabric_make_tpg		= tcm_qla2xxx_npiv_make_tpg,
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
+	struct target_fabric_configfs *fabric, *npiv_fabric;
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
+	 * Setup the struct se_task->task_sg[] chaining bit
+	 */
+	fabric->tf_ops.task_sg_chaining = 1;
+	/*
+	 * Setup default attribute lists for various fabric->tf_cit_tmpl
+	 */
+	TF_CIT_TMPL(fabric)->tfc_wwn_cit.ct_attrs = tcm_qla2xxx_wwn_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_base_cit.ct_attrs = tcm_qla2xxx_tpg_attrs;
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
+
+	/*
+	 * Register the top level struct config_item_type for NPIV with TCM core
+	 */
+	npiv_fabric = target_fabric_configfs_init(THIS_MODULE, "qla2xxx_npiv");
+	if (!(npiv_fabric)) {
+		printk(KERN_ERR "target_fabric_configfs_init() failed\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+	/*
+	 * Setup fabric->tf_ops from our local tcm_qla2xxx_npiv_ops
+	 */
+	npiv_fabric->tf_ops = tcm_qla2xxx_npiv_ops;
+	/*
+	 * Setup default attribute lists for various npiv_fabric->tf_cit_tmpl
+	 */
+	TF_CIT_TMPL(npiv_fabric)->tfc_wwn_cit.ct_attrs = tcm_qla2xxx_wwn_attrs;
+	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_base_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_attrib_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_param_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_np_base_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_nacl_base_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_nacl_attrib_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_nacl_auth_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_nacl_param_cit.ct_attrs = NULL;
+	/*
+	 * Register the npiv_fabric for use within TCM
+	 */
+	ret = target_fabric_configfs_register(npiv_fabric);
+	if (ret < 0) {
+		printk(KERN_ERR "target_fabric_configfs_register() failed"
+				" for TCM_QLA2XXX\n");
+		goto out;;
+	}
+	/*
+	 * Setup our local pointer to *npiv_fabric
+	 */
+	tcm_qla2xxx_npiv_fabric_configfs = npiv_fabric;
+	printk(KERN_INFO "TCM_QLA2XXX[0] - Set fabric -> tcm_qla2xxx_npiv_fabric_configfs\n");
+
+	return 0;
+out:
+	if (tcm_qla2xxx_fabric_configfs != NULL)
+		target_fabric_configfs_deregister(tcm_qla2xxx_fabric_configfs);
+
+	return ret;
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
+
+	target_fabric_configfs_deregister(tcm_qla2xxx_npiv_fabric_configfs);
+	tcm_qla2xxx_npiv_fabric_configfs = NULL;
+	printk(KERN_INFO "TCM_QLA2XXX[0] - Cleared tcm_qla2xxx_npiv_fabric_configfs\n");
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
+static void __exit tcm_qla2xxx_exit(void)
+{
+	tcm_qla2xxx_deregister_configfs();
+}
+
+#ifdef MODULE
+MODULE_DESCRIPTION("TCM QLA2XXX series NPIV enabled fabric driver");
+MODULE_LICENSE("GPL");
+module_init(tcm_qla2xxx_init);
+module_exit(tcm_qla2xxx_exit);
+#endif
diff --git a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c
new file mode 100644
index 0000000..ed109de
--- /dev/null
+++ b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c
@@ -0,0 +1,766 @@
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
+
+#include <target/target_core_base.h>
+#include <target/target_core_transport.h>
+#include <target/target_core_fabric_ops.h>
+#include <target/target_core_fabric_lib.h>
+#include <target/target_core_device.h>
+#include <target/target_core_tpg.h>
+#include <target/target_core_configfs.h>
+#include <target/target_core_tmr.h>
+
+#include <qla_def.h>
+#include <qla2x_tgt_def.h>
+
+//#include <scsi/libfc.h>
+//#include <scsi/scsi_transport_fc.h>
+
+#include <qla2x_target.h>
+
+#include <tcm_qla2xxx_base.h>
+#include <tcm_qla2xxx_fabric.h>
+
+#undef TCM_QLA2XXX_FABRIC_C
+
+int tcm_qla2xxx_check_true(struct se_portal_group *se_tpg)
+{
+	return 1;
+}
+
+int tcm_qla2xxx_check_false(struct se_portal_group *se_tpg)
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
+/*
+ * From drivers/scsi/scsi_transport_fc.c:fc_parse_wwn
+ */
+static int tcm_qla2xxx_npiv_extract_wwn(const char *ns, u64 *nm)
+{
+	unsigned int i, j, value;
+	u8 wwn[8];
+
+	memset(wwn, 0, sizeof(wwn));
+
+	/* Validate and store the new name */
+	for (i = 0, j = 0; i < 16; i++) {
+		value = hex_to_bin(*ns++);
+		if (value >= 0)
+			j = (j << 4) | value;
+		else
+			return -EINVAL;
+
+		if (i % 2) {
+			wwn[i/2] = j & 0xff;
+			j = 0;
+		}
+	}
+
+	*nm = wwn_to_u64(wwn);
+	return 0;
+}
+
+/*
+ * This parsing logic follows drivers/scsi/scsi_transport_fc.c:store_fc_host_vport_create()
+ */
+int tcm_qla2xxx_npiv_parse_wwn(
+	const char *name,
+	size_t count,
+	u64 *wwpn,
+	u64 *wwnn)
+{
+	unsigned int cnt = count;
+	int rc;
+
+	*wwpn = 0;
+	*wwnn = 0;
+
+	/* count may include a LF at end of string */
+	if (name[cnt-1] == '\n')
+		cnt--;
+
+	/* validate we have enough characters for WWPN */
+	if ((cnt != (16+1+16)) || (name[16] != ':'))
+		return -EINVAL;
+
+	rc = tcm_qla2xxx_npiv_extract_wwn(&name[0], wwpn);
+	if (rc != 0)
+		return rc;
+
+	rc = tcm_qla2xxx_npiv_extract_wwn(&name[17], wwnn);
+	if (rc != 0)
+		return rc;
+
+	return 0;
+}
+
+ssize_t tcm_qla2xxx_npiv_format_wwn(char *buf, size_t len, u64 wwpn, u64 wwnn)
+{
+	u8 b[8], b2[8];
+
+	put_unaligned_be64(wwpn, b);
+	put_unaligned_be64(wwnn, b2);
+        return snprintf(buf, len,
+                "%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x,"
+		"%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x",
+                b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7],
+		b2[0], b2[1], b2[2], b2[3], b2[4], b2[5], b2[6], b2[7]);
+}
+
+char *tcm_qla2xxx_npiv_get_fabric_name(void)
+{
+	return "qla2xxx_npiv";
+}
+
+u8 tcm_qla2xxx_get_fabric_proto_ident(struct se_portal_group *se_tpg)
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
+char *tcm_qla2xxx_get_fabric_wwn(struct se_portal_group *se_tpg)
+{
+	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
+				struct tcm_qla2xxx_tpg, se_tpg);
+	struct tcm_qla2xxx_lport *lport = tpg->lport;
+
+	return &lport->lport_name[0];
+}
+
+char *tcm_qla2xxx_npiv_get_fabric_wwn(struct se_portal_group *se_tpg)
+{
+	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
+				struct tcm_qla2xxx_tpg, se_tpg);
+	struct tcm_qla2xxx_lport *lport = tpg->lport;
+
+	return &lport->lport_npiv_name[0];
+}
+
+u16 tcm_qla2xxx_get_tag(struct se_portal_group *se_tpg)
+{
+	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
+				struct tcm_qla2xxx_tpg, se_tpg);
+	return tpg->lport_tpgt;
+}
+
+u32 tcm_qla2xxx_get_default_depth(struct se_portal_group *se_tpg)
+{
+	return 1;
+}
+
+u32 tcm_qla2xxx_get_pr_transport_id(
+	struct se_portal_group *se_tpg,
+	struct se_node_acl *se_nacl,
+	struct t10_pr_registration *pr_reg,
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
+	struct se_portal_group *se_tpg,
+	struct se_node_acl *se_nacl,
+	struct t10_pr_registration *pr_reg,
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
+	struct se_portal_group *se_tpg,
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
+struct se_node_acl *tcm_qla2xxx_alloc_fabric_acl(struct se_portal_group *se_tpg)
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
+	struct se_portal_group *se_tpg,
+	struct se_node_acl *se_nacl)
+{
+	struct tcm_qla2xxx_nacl *nacl = container_of(se_nacl,
+			struct tcm_qla2xxx_nacl, se_node_acl);
+	kfree(nacl);
+}
+
+u32 tcm_qla2xxx_tpg_get_inst_index(struct se_portal_group *se_tpg)
+{
+	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
+				struct tcm_qla2xxx_tpg, se_tpg);
+
+	return tpg->lport_tpgt;
+}
+
+/*
+ * Called from qla_target_template->free_cmd(), and will call
+ * tcm_qla2xxx_release_cmd via normal struct target_core_fabric_ops
+ * release callback.
+ */
+void tcm_qla2xxx_free_cmd(struct q2t_cmd *cmd)
+{
+	transport_generic_free_cmd(&cmd->se_cmd, 0, 1, 0);
+}
+
+extern void q2t_free_cmd(struct q2t_cmd *cmd);
+/*
+ * Callback from TCM Core to release underlying fabric descriptor
+ */
+void tcm_qla2xxx_release_cmd(struct se_cmd *se_cmd)
+{
+	struct q2t_cmd *cmd = container_of(se_cmd, struct q2t_cmd, se_cmd);
+
+	if (se_cmd->se_tmr_req != NULL)
+		return;
+
+	q2t_free_cmd(cmd);
+}
+
+#warning FIXME: tcm_qla2xxx_shutdown_session
+int tcm_qla2xxx_shutdown_session(struct se_session *se_sess)
+{
+	printk("tcm_qla2xxx_shutdown_session returning TRUE\n");
+	return 1;
+}
+
+extern int tcm_qla2xxx_clear_nacl_from_fcport_map(struct se_node_acl *);
+
+void tcm_qla2xxx_close_session(struct se_session *se_sess)
+{
+	tcm_qla2xxx_clear_nacl_from_fcport_map(se_sess->se_node_acl);
+}
+
+void tcm_qla2xxx_stop_session(struct se_session *se_sess, int sess_sleep , int conn_sleep)
+{
+	tcm_qla2xxx_clear_nacl_from_fcport_map(se_sess->se_node_acl);
+}
+
+void tcm_qla2xxx_reset_nexus(struct se_session *se_sess)
+{
+	return;
+}
+
+int tcm_qla2xxx_sess_logged_in(struct se_session *se_sess)
+{
+	return 0;
+}
+
+u32 tcm_qla2xxx_sess_get_index(struct se_session *se_sess)
+{
+	return 0;
+}
+
+extern int q2t_rdy_to_xfer(struct q2t_cmd *);
+
+int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
+{
+	struct q2t_cmd *cmd = container_of(se_cmd, struct q2t_cmd, se_cmd);
+
+	cmd->bufflen = se_cmd->data_length;
+	cmd->dma_data_direction = se_cmd->data_direction;
+	/*
+	 * Setup the struct se_task->task_sg[] chained SG list
+	 */
+	if ((se_cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) ||
+	    (se_cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB)) {
+		transport_do_task_sg_chain(se_cmd);
+
+		cmd->sg_cnt = T_TASK(se_cmd)->t_tasks_sg_chained_no;
+		cmd->sg = T_TASK(se_cmd)->t_tasks_sg_chained;
+	} else if (se_cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB) {
+		/*
+		 * Use T_TASK(se_cmd)->t_tasks_sg_bounce for control CDBs
+		 * using a contigious buffer
+		 */
+		sg_init_table(&T_TASK(se_cmd)->t_tasks_sg_bounce, 1);
+		sg_set_buf(&T_TASK(se_cmd)->t_tasks_sg_bounce,
+			T_TASK(se_cmd)->t_task_buf, se_cmd->data_length);
+		cmd->sg_cnt = 1;
+		cmd->sg = &T_TASK(se_cmd)->t_tasks_sg_bounce;
+	} else {
+		printk(KERN_ERR "Unknown se_cmd_flags: 0x%08x in"
+			" tcm_qla2xxx_write_pending()\n", se_cmd->se_cmd_flags);
+		BUG();
+	}
+	/*
+	 * qla2x_target.c:q2t_rdy_to_xfer() will call pci_map_sg() to setup
+	 * the SGL mappings into PCIe memory for incoming FCP WRITE data.
+	 */
+	return q2t_rdy_to_xfer(cmd);
+}
+
+int tcm_qla2xxx_write_pending_status(struct se_cmd *se_cmd)
+{
+	return 0;
+}
+
+void tcm_qla2xxx_set_default_node_attrs(struct se_node_acl *nacl)
+{
+	return;
+}
+
+u32 tcm_qla2xxx_get_task_tag(struct se_cmd *se_cmd)
+{
+	struct q2t_cmd *cmd = container_of(se_cmd, struct q2t_cmd, se_cmd);
+
+	return cmd->tag;
+}
+
+int tcm_qla2xxx_get_cmd_state(struct se_cmd *se_cmd)
+{
+	return 0;
+}
+
+void tcm_qla2xxx_new_cmd_failure(struct se_cmd *se_cmd)
+{
+	return;
+}
+
+/*
+ * Main entry point for incoming ATIO packets from qla2x_target.c
+ * and qla2xxx LLD code.
+ */
+int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct q2t_cmd *cmd,
+			uint32_t lun, uint32_t data_length,
+			int fcp_task_attr, int data_dir, int bidi)
+{
+	struct se_cmd *se_cmd = &cmd->se_cmd;
+	struct se_session *se_sess;
+	struct se_portal_group *se_tpg;
+	struct q2t_sess *sess;
+
+	sess = cmd->sess;
+	if (!sess) {
+		printk(KERN_ERR "Unable to locate struct q2t_sess from q2t_cmd\n");
+		return -EINVAL;
+	}
+
+	se_sess = sess->se_sess;
+	if (!se_sess) {
+		printk(KERN_ERR "Unable to locate active struct se_session\n");
+		return -EINVAL;
+	}
+	se_tpg = se_sess->se_tpg;
+
+	/*
+	 * Initialize struct se_cmd descriptor from target_core_mod infrastructure
+	 */
+	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
+			data_length, data_dir,
+			fcp_task_attr, &cmd->sense_buffer[0]);
+	/*
+	 * Signal BIDI usage with T_TASK(cmd)->t_tasks_bidi
+	 */
+	if (bidi)
+		T_TASK(se_cmd)->t_tasks_bidi = 1;
+	/*
+	 * Locate the struct se_lun pointer and attach it to struct se_cmd
+	 */
+	if (transport_get_lun_for_cmd(se_cmd, NULL, lun) < 0) {
+		/* NON_EXISTENT_LUN */
+		transport_send_check_condition_and_sense(se_cmd,
+				se_cmd->scsi_sense_reason, 0);
+		return 0;
+	}
+	/*
+	 * Queue up the newly allocated to be processed in TCM thread context.
+	 */
+	transport_device_setup_cmd(se_cmd);
+	/*
+	 * Queue up the newly allocated to be processed in TCM thread context.
+	 */
+	transport_generic_handle_cdb_map(se_cmd);
+	return 0;
+}
+
+int tcm_qla2xxx_new_cmd_map(struct se_cmd *se_cmd)
+{
+	struct q2t_cmd *cmd = container_of(se_cmd, struct q2t_cmd, se_cmd);
+	scsi_qla_host_t *vha = cmd->vha;
+	struct qla_hw_data *ha = vha->hw;
+	unsigned char *cdb;
+	int ret;
+
+	if (IS_FWI2_CAPABLE(ha)) {
+		atio7_entry_t *atio = &cmd->atio.atio7;
+		cdb = &atio->fcp_cmnd.cdb[0];
+	} else {
+		atio_entry_t *atio = &cmd->atio.atio2x;
+		cdb = &atio->cdb[0];
+	}
+
+	/*
+	 * Allocate the necessary tasks to complete the received CDB+data
+	 */
+	ret = transport_generic_allocate_tasks(se_cmd, cdb);
+	if (ret == -1) {
+		/* Out of Resources */
+		transport_send_check_condition_and_sense(se_cmd,
+				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
+		return 0;
+	} else if (ret == -2) {
+		/*
+		 * Handle case for SAM_STAT_RESERVATION_CONFLICT
+		 */
+		if (se_cmd->se_cmd_flags & SCF_SCSI_RESERVATION_CONFLICT) {
+			tcm_qla2xxx_queue_status(se_cmd);
+			return 0;
+		}
+		/*
+		 * Otherwise, return SAM_STAT_CHECK_CONDITION and return
+		 * sense data.
+		 */
+		transport_send_check_condition_and_sense(se_cmd,
+				se_cmd->scsi_sense_reason, 0);
+		return 0;
+	}
+	/*
+	 * drivers/target/target_core_transport.c:transport_processing_thread()
+	 * falls through to TRANSPORT_NEW_CMD.
+	 */
+	return 0;
+}
+
+/*
+ * Called from qla2x_target.c:q2t_do_ctio_completion()
+ */
+int tcm_qla2xxx_handle_data(struct q2t_cmd *cmd)
+{
+	/*
+	 * We now tell TCM to queue this WRITE CDB with TRANSPORT_PROCESS_WRITE
+	 * status to the backstore processing thread.
+	 */
+	return transport_generic_handle_data(&cmd->se_cmd);
+}
+
+/*
+ * Called from qla2x_target.c:q2t_issue_task_mgmt()
+ */
+int tcm_qla2xxx_handle_tmr(struct q2t_mgmt_cmd *mcmd, uint32_t lun, uint8_t tmr_func)
+{
+	struct q2t_sess *sess = mcmd->sess;
+	struct se_session *se_sess = sess->se_sess;
+	struct se_portal_group *se_tpg = se_sess->se_tpg;
+	struct se_cmd *se_cmd = &mcmd->se_cmd;
+	/*
+	 * Initialize struct se_cmd descriptor from target_core_mod infrastructure
+	 */
+	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess, 0,
+				DMA_NONE, 0, NULL);
+	/*
+	 * Allocate the TCM TMR
+	 */
+	se_cmd->se_tmr_req = core_tmr_alloc_req(se_cmd, (void *)mcmd, tmr_func);
+	if (!se_cmd->se_tmr_req)
+		return -ENOMEM;
+	/*
+	 * Save the se_tmr_req for q2t_xmit_tm_rsp() callback into LLD code
+	 */
+	mcmd->se_tmr_req = se_cmd->se_tmr_req;
+	/*
+	 * Locate the underlying TCM struct se_lun from sc->device->lun
+	 */
+	if (transport_get_lun_for_tmr(se_cmd, lun) < 0) {
+		transport_generic_free_cmd(se_cmd, 1, 1, 0);
+		return -EINVAL;
+	}
+	/*
+	 * Queue the TMR associated se_cmd into TCM Core for processing
+	 */
+	return transport_generic_handle_tmr(se_cmd);
+}
+
+/*
+ * From qla2x_target.c...
+ */
+extern int q2x_xmit_response(struct q2t_cmd *, int, uint8_t);
+
+int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
+{
+	struct q2t_cmd *cmd = container_of(se_cmd, struct q2t_cmd, se_cmd);
+
+	cmd->bufflen = se_cmd->data_length;
+	cmd->dma_data_direction = se_cmd->data_direction;
+	cmd->aborted = atomic_read(&T_TASK(se_cmd)->t_transport_aborted);
+	/*
+	 * Setup the struct se_task->task_sg[] chained SG list
+	 */
+	if ((se_cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) ||
+	    (se_cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB)) {
+		transport_do_task_sg_chain(se_cmd);
+
+		cmd->sg_cnt = T_TASK(se_cmd)->t_tasks_sg_chained_no;
+		cmd->sg = T_TASK(se_cmd)->t_tasks_sg_chained;
+	} else if (se_cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB) {
+		/*
+		 * Use T_TASK(se_cmd)->t_tasks_sg_bounce for control CDBs
+		 * using a contigious buffer
+		 */
+		sg_init_table(&T_TASK(se_cmd)->t_tasks_sg_bounce, 1);
+		sg_set_buf(&T_TASK(se_cmd)->t_tasks_sg_bounce,
+			T_TASK(se_cmd)->t_task_buf, se_cmd->data_length);
+
+		cmd->sg_cnt = 1;
+		cmd->sg = &T_TASK(se_cmd)->t_tasks_sg_bounce;
+	} else {
+		cmd->sg_cnt = 0;
+		cmd->sg = NULL;
+	}
+
+	cmd->offset = 0;
+
+	/*
+	 * Now queue completed DATA_IN the qla2xxx LLD and response ring
+	 */
+	return q2x_xmit_response(cmd, Q2T_XMIT_DATA|Q2T_XMIT_STATUS,
+				se_cmd->scsi_status);
+}
+
+int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
+{
+	struct q2t_cmd *cmd = container_of(se_cmd, struct q2t_cmd, se_cmd);
+
+	cmd->bufflen = se_cmd->data_length;
+	cmd->sg = NULL;
+	cmd->sg_cnt = 0;
+	cmd->offset = 0;
+	cmd->dma_data_direction = se_cmd->data_direction;
+	cmd->aborted = atomic_read(&T_TASK(se_cmd)->t_transport_aborted);
+
+	/*
+	 * Now queue status response to qla2xxx LLD code and response ring
+	 */
+	return q2x_xmit_response(cmd, Q2T_XMIT_STATUS, se_cmd->scsi_status);
+}
+
+extern void q2t_xmit_tm_rsp(struct q2t_mgmt_cmd *);
+
+int tcm_qla2xxx_queue_tm_rsp(struct se_cmd *se_cmd)
+{
+	struct se_tmr_req *se_tmr = se_cmd->se_tmr_req;
+	struct q2t_mgmt_cmd *mcmd = container_of(se_cmd,
+				struct q2t_mgmt_cmd, se_cmd);
+
+	printk("queue_tm_rsp: mcmd: %p func: 0x%02x response: 0x%02x\n",
+			mcmd, se_tmr->function, se_tmr->response);
+	/*
+	 * Do translation between TCM TM response codes and
+	 * QLA2xxx FC TM response codes.
+	 */
+	switch (se_tmr->response) {
+	case TMR_FUNCTION_COMPLETE:
+		mcmd->fc_tm_rsp = FC_TM_SUCCESS;
+		break;
+	case TMR_TASK_DOES_NOT_EXIST:
+		mcmd->fc_tm_rsp = FC_TM_BAD_CMD;
+		break;
+	case TMR_FUNCTION_REJECTED:
+		mcmd->fc_tm_rsp = FC_TM_REJECT;
+		break;
+	case TMR_LUN_DOES_NOT_EXIST:
+	default:
+		mcmd->fc_tm_rsp = FC_TM_FAILED;
+		break;
+	}
+	/*
+	 * Queue the TM response to QLA2xxx LLD to build a
+	 * CTIO response packet.
+	 */
+	q2t_xmit_tm_rsp(mcmd);
+	/*
+	 * Release the associated se_cmd->se_tmr_req and se_cmd
+	 * TMR related state now.
+	 */
+	transport_generic_free_cmd(se_cmd, 1, 1, 0);
+	return 0;
+}
+
+u16 tcm_qla2xxx_get_fabric_sense_len(void)
+{
+	return 0;
+}
+
+u16 tcm_qla2xxx_set_fabric_sense_len(struct se_cmd *se_cmd, u32 sense_length)
+{
+	return 0;
+}
+
+int tcm_qla2xxx_is_state_remove(struct se_cmd *se_cmd)
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
index 0000000..dd65445
--- /dev/null
+++ b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.h
@@ -0,0 +1,48 @@
+extern int tcm_qla2xxx_check_true(struct se_portal_group *);
+extern int tcm_qla2xxx_check_false(struct se_portal_group *);
+extern ssize_t tcm_qla2xxx_parse_wwn(const char *, u64 *, int);
+extern ssize_t tcm_qla2xxx_format_wwn(char *, size_t, u64);
+extern char *tcm_qla2xxx_get_fabric_name(void);
+extern int tcm_qla2xxx_npiv_parse_wwn(const char *name, size_t, u64 *, u64 *);
+extern ssize_t tcm_qla2xxx_npiv_format_wwn(char *, size_t, u64, u64);
+extern char *tcm_qla2xxx_npiv_get_fabric_name(void);
+extern u8 tcm_qla2xxx_get_fabric_proto_ident(struct se_portal_group *);
+extern char *tcm_qla2xxx_get_fabric_wwn(struct se_portal_group *);
+extern char *tcm_qla2xxx_npiv_get_fabric_wwn(struct se_portal_group *);
+extern u16 tcm_qla2xxx_get_tag(struct se_portal_group *);
+extern u32 tcm_qla2xxx_get_default_depth(struct se_portal_group *);
+extern u32 tcm_qla2xxx_get_pr_transport_id(struct se_portal_group *, struct se_node_acl *,
+			struct t10_pr_registration *, int *, unsigned char *);
+extern u32 tcm_qla2xxx_get_pr_transport_id_len(struct se_portal_group *, struct se_node_acl *,
+			struct t10_pr_registration *, int *);
+extern char *tcm_qla2xxx_parse_pr_out_transport_id(struct se_portal_group *, const char *,
+				u32 *, char **);
+extern struct se_node_acl *tcm_qla2xxx_alloc_fabric_acl(struct se_portal_group *);
+extern void tcm_qla2xxx_release_fabric_acl(struct se_portal_group *, struct se_node_acl *);
+extern u32 tcm_qla2xxx_tpg_get_inst_index(struct se_portal_group *);
+extern void tcm_qla2xxx_free_cmd(struct q2t_cmd *);
+extern void tcm_qla2xxx_release_cmd(struct se_cmd *);
+extern int tcm_qla2xxx_shutdown_session(struct se_session *);
+extern void tcm_qla2xxx_close_session(struct se_session *);
+extern void tcm_qla2xxx_stop_session(struct se_session *, int, int);
+extern void tcm_qla2xxx_reset_nexus(struct se_session *);
+extern int tcm_qla2xxx_sess_logged_in(struct se_session *);
+extern u32 tcm_qla2xxx_sess_get_index(struct se_session *);
+extern int tcm_qla2xxx_write_pending(struct se_cmd *);
+extern int tcm_qla2xxx_write_pending_status(struct se_cmd *);
+extern void tcm_qla2xxx_set_default_node_attrs(struct se_node_acl *);
+extern u32 tcm_qla2xxx_get_task_tag(struct se_cmd *);
+extern int tcm_qla2xxx_get_cmd_state(struct se_cmd *);
+extern void tcm_qla2xxx_new_cmd_failure(struct se_cmd *);
+extern int tcm_qla2xxx_handle_cmd(struct scsi_qla_host *, struct q2t_cmd *,
+                        uint32_t, uint32_t, int, int, int);
+extern int tcm_qla2xxx_new_cmd_map(struct se_cmd *);
+extern int tcm_qla2xxx_handle_data(struct q2t_cmd *);
+extern int tcm_qla2xxx_handle_tmr(struct q2t_mgmt_cmd *, uint32_t, uint8_t);
+extern int tcm_qla2xxx_queue_data_in(struct se_cmd *);
+extern int tcm_qla2xxx_queue_status(struct se_cmd *);
+extern int tcm_qla2xxx_queue_tm_rsp(struct se_cmd *);
+extern u16 tcm_qla2xxx_get_fabric_sense_len(void);
+extern u16 tcm_qla2xxx_set_fabric_sense_len(struct se_cmd *, u32);
+extern int tcm_qla2xxx_is_state_remove(struct se_cmd *);
+extern u64 tcm_qla2xxx_pack_lun(unsigned int);
-- 
1.7.3.3
