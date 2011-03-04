From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v2 3/3] tcm_qla2xxx: Add HW target mode I/O, control and TMR path code
Date: Thu,  3 Mar 2011 19:25:21 -0800
Message-ID: <1299209121-32174-4-git-send-email-nab@linux-iscsi.org>
References: <1299209121-32174-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp104.sbc.mail.re3.yahoo.com ([66.196.96.80]:32930 "HELO
	smtp104.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932309Ab1CDDc1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Mar 2011 22:32:27 -0500
In-Reply-To: <1299209121-32174-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Madhu Iyengar <madhu.iyengar@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Ruediger Oertel <ro@suse.de>, Nicholas Bellinger <nab@risingtidesystems.com>

=46rom: Nicholas Bellinger <nab@risingtidesystems.com>

This patch adds initial support for functioning READ and WRITE I/O into
tcm_qla2xxx fabric module code and TCM backends using new qla_target.c
LLD logic introduced into commit 8981ac5d and commit 59e989480.  This i=
ncludes
support for demo-mode TPG access and explict NodeACLs via configfs usin=
g
tcm_qla2xxx_setup_nacl_from_rport() from libfc struct fc_host->rports.

This patch also adds support for using tcm_qla2xxx_lport->lport_fcport_=
map
and ->lport_loopid_map to track struct se_node_acl pointers for individ=
ual
24-bit Port ID and 16-bit Loop ID values for qla_target_template
->find_sess_by_s_id() and ->find_sess_by_loop_id() used in a number of
locations into the primary I/O dispatch logic in qla_target.c LLD code.

The main piece to setup a FC Nexus is done in tcm_qla2xxx_check_initiat=
or_node_acl(),
which calls tcm_qla2xxx_set_sess_by_[s_id,loop_id]() to setup our
lport->lport_fcport_map and lport_loopid_map pointers respectively, and=
 register
the new nexus with TCM via __transport_register_session().  The FC nexu=
s release and
reset path is done via a qla_target.c LLD callback to tcm_qla2xxx_free_=
session()
which calls transport_deregister_session_configfs(), then to clear the
tcm_qla2xxx_set_sess_by_[s_id,loop_id]() struct se_nacl pointer, and fi=
nally
transport_deregister_session() to release our struct se_session.

=46or the functioning non NPIV case in tcm_qla2xxx_configfs.c:tcm_qla2x=
xx_make_tpg()
we use a single lport->tpg_1 pointer, and only allow a single scsi_qla_=
host_t *
per struct tcm_qla2xxx_lport.  The NPIV configfs code is still a WIP an=
d is using
NOPs for in tcm_qla2xxx_configfs.c at this point.

Signed-off-by: Nicholas A. Bellinger <nab@risingtidesystems.com>
---
 drivers/target/Kconfig                            |    1 +
 drivers/target/Makefile                           |    2 +
 drivers/target/tcm_qla2xxx/Kconfig                |    7 +
 drivers/target/tcm_qla2xxx/Makefile               |    6 +
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h     |  102 ++
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c | 1439 +++++++++++++=
++++++++
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c   |  853 ++++++++++++
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.h   |   53 +
 8 files changed, 2463 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/tcm_qla2xxx/Kconfig
 create mode 100644 drivers/target/tcm_qla2xxx/Makefile
 create mode 100644 drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h
 create mode 100644 drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c
 create mode 100644 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c
 create mode 100644 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.h

diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
index 437069f..dc860aa 100644
--- a/drivers/target/Kconfig
+++ b/drivers/target/Kconfig
@@ -39,5 +39,6 @@ config TCM_STGT
 source "drivers/target/tcm_loop/Kconfig"
 source "drivers/target/lio-target/Kconfig"
 source "drivers/target/tcm_fc/Kconfig"
+source "drivers/target/tcm_qla2xxx/Kconfig"
=20
 endif
diff --git a/drivers/target/Makefile b/drivers/target/Makefile
index 12c6090..d0ef2fa 100644
--- a/drivers/target/Makefile
+++ b/drivers/target/Makefile
@@ -28,3 +28,5 @@ obj-$(CONFIG_LIO_TARGET)	+=3D lio-target/
 obj-$(CONFIG_TCM_LOOP_FABRIC)	+=3D tcm_loop/
=20
 obj-$(CONFIG_TCM_FC)		+=3D tcm_fc/
+obj-$(CONFIG_TCM_QLA2XXX)	+=3D tcm_qla2xxx/
+
diff --git a/drivers/target/tcm_qla2xxx/Kconfig b/drivers/target/tcm_ql=
a2xxx/Kconfig
new file mode 100644
index 0000000..3f6d8c8
--- /dev/null
+++ b/drivers/target/tcm_qla2xxx/Kconfig
@@ -0,0 +1,7 @@
+config TCM_QLA2XXX
+	tristate "TCM_QLA2XXX fabric module for Qlogic 2xxx series target mod=
e HBAs"
+	select LIBFC
+	select SCSI_QLA_FC
+	default n
+	---help---
+	Say Y here to enable the TCM_QLA2XXX fabric module for Qlogic 2xxx se=
ries target mode HBAs=20
diff --git a/drivers/target/tcm_qla2xxx/Makefile b/drivers/target/tcm_q=
la2xxx/Makefile
new file mode 100644
index 0000000..2b8120f
--- /dev/null
+++ b/drivers/target/tcm_qla2xxx/Makefile
@@ -0,0 +1,6 @@
+EXTRA_CFLAGS +=3D -I$(srctree)/drivers/scsi/qla2xxx/=20
+
+tcm_qla2xxx-objs		:=3D tcm_qla2xxx_fabric.o \
+				   tcm_qla2xxx_configfs.o \
+
+obj-$(CONFIG_TCM_QLA2XXX)	+=3D tcm_qla2xxx.o
diff --git a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h b/drivers/ta=
rget/tcm_qla2xxx/tcm_qla2xxx_base.h
new file mode 100644
index 0000000..a89a567
--- /dev/null
+++ b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h
@@ -0,0 +1,102 @@
+#include <target/target_core_base.h>
+
+#define TCM_QLA2XXX_VERSION	"v0.1"
+/* length of ASCII WWPNs including pad */
+#define TCM_QLA2XXX_NAMELEN	32
+/* lenth of ASCII NPIV 'WWPN+WWNN' including pad */
+#define TCM_QLA2XXX_NPIV_NAMELEN 66
+
+#include "qla_target.h"
+
+#if 0
+#define DEBUG_QLA_TGT_SESS_MAP(x...)	printk(KERN_INFO x)
+#else
+#define DEBUG_QLA_TGT_SESS_MAP(x...)
+#endif
+
+struct tcm_qla2xxx_nacl {
+	/* From libfc struct fc_rport->port_id */
+	u16 nport_id;
+	/* Binary World Wide unique Node Name for remote FC Initiator Nport *=
/
+	u64 nport_wwnn;
+	/* ASCII formatted WWPN for FC Initiator Nport */
+	char nport_name[TCM_QLA2XXX_NAMELEN];
+	/* Pointer to qla_tgt_sess */
+	struct qla_tgt_sess *qla_tgt_sess;
+	/* Pointer to TCM FC nexus */
+	struct se_session *nport_nexus;
+	/* Returned by tcm_qla2xxx_make_nodeacl() */
+	struct se_node_acl se_node_acl;
+};
+
+struct tcm_qla2xxx_tpg_attrib {
+	int generate_node_acls;
+	int cache_dynamic_acls;
+	int demo_mode_write_protect;
+	int prod_mode_write_protect;
+};
+
+struct tcm_qla2xxx_tpg {
+	/* FC lport target portal group tag for TCM */
+	u16 lport_tpgt;
+	/* Atomic bit to determine TPG active status */
+	atomic_t lport_tpg_enabled;
+	/* Pointer back to tcm_qla2xxx_lport */
+	struct tcm_qla2xxx_lport *lport;
+	/* Used by tcm_qla2xxx_tpg_attrib_cit */
+	struct tcm_qla2xxx_tpg_attrib tpg_attrib;
+	/* Returned by tcm_qla2xxx_make_tpg() */
+	struct se_portal_group se_tpg;
+};
+
+#define QLA_TPG_ATTRIB(tpg)	(&(tpg)->tpg_attrib)
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
+	/* vmalloc'ed memory for fc_port pointers in 24-bit FC Port ID space =
*/
+	char *lport_fcport_map;
+	/* vmalloc-ed memory for fc_port pointers for 16-bit FC loop ID */
+	char *lport_loopid_map;
+	/* Pointer to struct scsi_qla_host from qla2xxx LLD */
+	struct scsi_qla_host *qla_vha;
+	/* Pointer to struct scsi_qla_host for NPIV VP from qla2xxx LLD */
+	struct scsi_qla_host *qla_npiv_vp;
+	/* Pointer to struct qla_tgt pointer */
+	struct qla_tgt lport_qla_tgt;
+	/* Pointer to struct fc_vport for NPIV vport from libfc */
+	struct fc_vport *npiv_vport;
+	/* Pointer to TPG=3D1 for non NPIV mode */
+	struct tcm_qla2xxx_tpg *tpg_1;
+	/* Returned by tcm_qla2xxx_make_lport() */
+	struct se_wwn lport_wwn;
+};
diff --git a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c b/driver=
s/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c
new file mode 100644
index 0000000..88a361cf
--- /dev/null
+++ b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c
@@ -0,0 +1,1439 @@
+/*********************************************************************=
**********
+ * This file contains TCM QLA2XXX fabric module implementation using
+ * v4 configfs fabric infrastructure for QLogic target mode HBAs
+ *
+ * =C2=A9 Copyright 2010-2011 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (=
GPL) version 2.
+ *
+ * Author: Nicholas A. Bellinger <nab@risingtidesystems.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *********************************************************************=
*******/
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
+#include "tcm_qla2xxx_base.h"
+#include "tcm_qla2xxx_fabric.h"
+
+#include <qla_def.h>
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
+	struct scsi_qla_host *vha =3D lport->qla_vha;
+	struct Scsi_Host *sh =3D vha->host;
+	struct fc_host_attrs *fc_host =3D shost_to_fc_host(sh);
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
+		if (rport_wwnn !=3D rport->node_name)
+			continue;
+
+		DEBUG_QLA_TGT_SESS_MAP("Located existing rport_wwpn and rport->node_=
name:"
+			" 0x%016LX, port_id: 0x%04x\n", rport->node_name,
+			rport->port_id);
+		domain =3D (rport->port_id >> 16) & 0xff;
+		area =3D (rport->port_id >> 8) & 0xff;
+		al_pa =3D rport->port_id & 0xff;
+		nacl->nport_id =3D rport->port_id;
+
+		DEBUG_QLA_TGT_SESS_MAP("fc_rport domain: 0x%02x area: 0x%02x al_pa: =
%02x\n",
+				domain, area, al_pa);
+		spin_unlock_irqrestore(sh->host_lock, flags);
+
+
+		spin_lock_irqsave(&vha->hw->hardware_lock, flags);
+		d =3D (struct tcm_qla2xxx_fc_domain *)&lport->lport_fcport_map[domai=
n];
+		DEBUG_QLA_TGT_SESS_MAP("Using d: %p for domain: 0x%02x\n", d, domain=
);
+		a =3D &d->areas[area];
+		DEBUG_QLA_TGT_SESS_MAP("Using a: %p for area: 0x%02x\n", a, area);
+		p =3D &a->al_pas[al_pa];
+		DEBUG_QLA_TGT_SESS_MAP("Using p: %p for al_pa: 0x%02x\n", p, al_pa);
+
+		p->se_nacl =3D se_nacl;
+		DEBUG_QLA_TGT_SESS_MAP("Setting p->se_nacl to se_nacl: %p for WWNN: =
0x%016LX,"
+			" port_id: 0x%04x\n", se_nacl, rport_wwnn,
+			nacl->nport_id);
+		spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
+
+		return 1;
+	}
+	spin_unlock_irqrestore(sh->host_lock, flags);
+
+	return 0;
+}
+
+/*
+ * Expected to be called with struct qla_hw_data->hardware_lock held
+ */
+int tcm_qla2xxx_clear_nacl_from_fcport_map(
+	struct se_node_acl *se_nacl)
+{
+	struct se_portal_group *se_tpg =3D se_nacl->se_tpg;
+	struct se_wwn *se_wwn =3D se_tpg->se_tpg_wwn;
+	struct tcm_qla2xxx_lport *lport =3D container_of(se_wwn,
+				struct tcm_qla2xxx_lport, lport_wwn);
+	struct tcm_qla2xxx_nacl *nacl =3D container_of(se_nacl,
+				struct tcm_qla2xxx_nacl, se_node_acl);
+	struct tcm_qla2xxx_fc_domain *d;
+	struct tcm_qla2xxx_fc_area *a;
+	struct tcm_qla2xxx_fc_al_pa *p;
+	unsigned char domain, area, al_pa;
+
+	domain =3D (nacl->nport_id >> 16) & 0xff;
+	area =3D (nacl->nport_id >> 8) & 0xff;
+	al_pa =3D nacl->nport_id & 0xff;
+
+	DEBUG_QLA_TGT_SESS_MAP("fc_rport domain: 0x%02x area: 0x%02x al_pa: %=
02x\n",
+			domain, area, al_pa);
+
+	d =3D (struct tcm_qla2xxx_fc_domain *)&lport->lport_fcport_map[domain=
];
+	DEBUG_QLA_TGT_SESS_MAP("Using d: %p for domain: 0x%02x\n", d, domain)=
;
+	a =3D &d->areas[area];
+	DEBUG_QLA_TGT_SESS_MAP("Using a: %p for area: 0x%02x\n", a, area);
+	p =3D &a->al_pas[al_pa];
+	DEBUG_QLA_TGT_SESS_MAP("Using p: %p for al_pa: 0x%02x\n", p, al_pa);
+
+	p->se_nacl =3D NULL;
+	DEBUG_QLA_TGT_SESS_MAP("Clearing p->se_nacl to se_nacl: %p for WWNN: =
0x%016LX,"
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
+	struct se_wwn *se_wwn =3D se_tpg->se_tpg_wwn;
+	struct tcm_qla2xxx_lport *lport =3D container_of(se_wwn,
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
+	se_nacl_new =3D tcm_qla2xxx_alloc_fabric_acl(se_tpg);
+	if (!(se_nacl_new))
+		return ERR_PTR(-ENOMEM);
+//#warning FIXME: Hardcoded qla2xxx_nexus depth in tcm_qla2xxx_make_no=
deacl()
+	qla2xxx_nexus_depth =3D 1;
+
+	/*
+	 * se_nacl_new may be released by core_tpg_add_initiator_node_acl()
+	 * when converting a NodeACL from demo mode -> explict
+	 */
+	se_nacl =3D core_tpg_add_initiator_node_acl(se_tpg, se_nacl_new,
+				name, qla2xxx_nexus_depth);
+	if (IS_ERR(se_nacl)) {
+		tcm_qla2xxx_release_fabric_acl(se_tpg, se_nacl_new);
+		return se_nacl;
+	}
+	/*
+	 * Locate our struct tcm_qla2xxx_nacl and set the FC Nport WWPN
+	 */
+	nacl =3D container_of(se_nacl, struct tcm_qla2xxx_nacl, se_node_acl);
+	nacl->nport_wwnn =3D wwnn;
+	tcm_qla2xxx_format_wwn(&nacl->nport_name[0], TCM_QLA2XXX_NAMELEN, wwn=
n);
+	/*
+	 * Setup a se_nacl handle based on an a matching struct fc_rport setu=
p
+	 * via drivers/scsi/qla2xxx/qla_init.c:qla2x00_reg_remote_port()
+	 */
+	rc =3D tcm_qla2xxx_setup_nacl_from_rport(se_tpg, se_nacl, lport,
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
+	struct se_portal_group *se_tpg =3D se_acl->se_tpg;
+	struct tcm_qla2xxx_nacl *nacl =3D container_of(se_acl,
+				struct tcm_qla2xxx_nacl, se_node_acl);=09
+
+	core_tpg_del_initiator_node_acl(se_tpg, se_acl, 1);
+	kfree(nacl);
+}
+
+/* Start items for tcm_qla2xxx_tpg_attrib_cit */
+
+#define DEF_QLA_TPG_ATTRIB(name)					\
+									\
+static ssize_t tcm_qla2xxx_tpg_attrib_show_##name(			\
+	struct se_portal_group *se_tpg,					\
+	char *page)							\
+{									\
+	struct tcm_qla2xxx_tpg *tpg =3D container_of(se_tpg,		\
+			struct tcm_qla2xxx_tpg, se_tpg);		\
+									\
+	return sprintf(page, "%u\n", QLA_TPG_ATTRIB(tpg)->name);	\
+}									\
+									\
+static ssize_t tcm_qla2xxx_tpg_attrib_store_##name(			\
+	struct se_portal_group *se_tpg,					\
+	const char *page,						\
+	size_t count)							\
+{									\
+	struct tcm_qla2xxx_tpg *tpg =3D container_of(se_tpg,		\
+			struct tcm_qla2xxx_tpg, se_tpg);		\
+	unsigned long val;						\
+	int ret;							\
+									\
+	ret =3D strict_strtoul(page, 0, &val);				\
+	if (ret < 0) {							\
+		printk(KERN_ERR "strict_strtoul() failed with"		\
+				" ret: %d\n", ret);			\
+		return -EINVAL;						\
+	}								\
+	ret =3D tcm_qla2xxx_set_attrib_##name(tpg, val);			\
+									\
+	return (!ret) ? count : -EINVAL;				\
+}
+
+#define DEF_QLA_TPG_ATTR_BOOL(_name)					\
+									\
+static int tcm_qla2xxx_set_attrib_##_name(				\
+	struct tcm_qla2xxx_tpg *tpg,					\
+	unsigned long val)						\
+{									\
+	struct tcm_qla2xxx_tpg_attrib *a =3D &tpg->tpg_attrib;		\
+									\
+	if ((val !=3D 0) && (val !=3D 1)) {					\
+		printk(KERN_ERR "Illegal boolean value %lu\n", val);	\
+                return -EINVAL;						\
+	}								\
+									\
+	a->_name =3D val;							\
+	return 0;							\
+}
+
+#define QLA_TPG_ATTR(_name, _mode)	TF_TPG_ATTRIB_ATTR(tcm_qla2xxx, _na=
me, _mode);
+
+/*
+ * Define tcm_qla2xxx_tpg_attrib_s_generate_node_acls
+ */
+DEF_QLA_TPG_ATTR_BOOL(generate_node_acls);
+DEF_QLA_TPG_ATTRIB(generate_node_acls);
+QLA_TPG_ATTR(generate_node_acls, S_IRUGO | S_IWUSR);
+
+/*
+ Define tcm_qla2xxx_attrib_s_cache_dynamic_acls
+ */
+DEF_QLA_TPG_ATTR_BOOL(cache_dynamic_acls);
+DEF_QLA_TPG_ATTRIB(cache_dynamic_acls);
+QLA_TPG_ATTR(cache_dynamic_acls, S_IRUGO | S_IWUSR);
+
+/*
+ * Define tcm_qla2xxx_tpg_attrib_s_demo_mode_write_protect
+ */
+DEF_QLA_TPG_ATTR_BOOL(demo_mode_write_protect);
+DEF_QLA_TPG_ATTRIB(demo_mode_write_protect);
+QLA_TPG_ATTR(demo_mode_write_protect, S_IRUGO | S_IWUSR);
+
+/*
+ * Define tcm_qla2xxx_tpg_attrib_s_prod_mode_write_protect
+ */
+DEF_QLA_TPG_ATTR_BOOL(prod_mode_write_protect);
+DEF_QLA_TPG_ATTRIB(prod_mode_write_protect);
+QLA_TPG_ATTR(prod_mode_write_protect, S_IRUGO | S_IWUSR);
+
+static struct configfs_attribute *tcm_qla2xxx_tpg_attrib_attrs[] =3D {
+	&tcm_qla2xxx_tpg_attrib_generate_node_acls.attr,
+	&tcm_qla2xxx_tpg_attrib_cache_dynamic_acls.attr,
+	&tcm_qla2xxx_tpg_attrib_demo_mode_write_protect.attr,
+	&tcm_qla2xxx_tpg_attrib_prod_mode_write_protect.attr,
+	NULL,
+};
+
+/* End items for tcm_qla2xxx_tpg_attrib_cit */
+
+static ssize_t tcm_qla2xxx_tpg_show_enable(
+	struct se_portal_group *se_tpg,
+	char *page)
+{
+	struct tcm_qla2xxx_tpg *tpg =3D container_of(se_tpg,
+			struct tcm_qla2xxx_tpg, se_tpg);
+
+	return snprintf(page, PAGE_SIZE, "%d\n",
+			atomic_read(&tpg->lport_tpg_enabled));
+}
+
+static ssize_t tcm_qla2xxx_tpg_store_enable(
+	struct se_portal_group *se_tpg,
+	const char *page,
+	size_t count)
+{
+	struct se_wwn *se_wwn =3D se_tpg->se_tpg_wwn;
+	struct tcm_qla2xxx_lport *lport =3D container_of(se_wwn,
+			struct tcm_qla2xxx_lport, lport_wwn);
+	struct scsi_qla_host *vha =3D lport->qla_vha;
+	struct qla_hw_data *ha =3D vha->hw;
+	struct tcm_qla2xxx_tpg *tpg =3D container_of(se_tpg,
+			struct tcm_qla2xxx_tpg, se_tpg);
+	char *endptr;
+	u32 op;
+
+	op =3D simple_strtoul(page, &endptr, 0);
+	if ((op !=3D 1) && (op !=3D 0)) {
+		printk(KERN_ERR "Illegal value for tpg_enable: %u\n", op);
+		return -EINVAL;
+	}
+
+	if (op) {
+		atomic_set(&tpg->lport_tpg_enabled, 1);
+		qla_tgt_enable_vha(vha);
+	} else {
+		if (!ha->qla_tgt) {
+			printk(KERN_ERR "truct qla_hw_data *ha->qla_tgt is NULL\n");
+			return -ENODEV;
+		}
+		atomic_set(&tpg->lport_tpg_enabled, 0);
+		qla_tgt_stop_phase1(ha->qla_tgt);
+	}
+
+	return count;
+}
+
+TF_TPG_BASE_ATTR(tcm_qla2xxx, enable, S_IRUGO | S_IWUSR);
+
+static struct configfs_attribute *tcm_qla2xxx_tpg_attrs[] =3D {
+	&tcm_qla2xxx_tpg_enable.attr,
+	NULL,
+};
+
+static struct se_portal_group *tcm_qla2xxx_make_tpg(
+	struct se_wwn *wwn,
+	struct config_group *group,
+	const char *name)
+{
+	struct tcm_qla2xxx_lport *lport =3D container_of(wwn,
+			struct tcm_qla2xxx_lport, lport_wwn);
+	struct tcm_qla2xxx_tpg *tpg;
+	unsigned long tpgt;
+	int ret;
+
+	if (strstr(name, "tpgt_") !=3D name)
+		return ERR_PTR(-EINVAL);
+	if (strict_strtoul(name + 5, 10, &tpgt) || tpgt > USHRT_MAX)
+		return ERR_PTR(-EINVAL);
+=09
+	if ((lport->qla_npiv_vp =3D=3D NULL) && (tpgt !=3D 1)) {
+		printk(KERN_ERR "In non NPIV mode, a single TPG=3D1 is used for"
+			" HW port mappings\n");
+		return ERR_PTR(-ENOSYS);
+	}
+
+	tpg =3D kzalloc(sizeof(struct tcm_qla2xxx_tpg), GFP_KERNEL);
+	if (!(tpg)) {
+		printk(KERN_ERR "Unable to allocate struct tcm_qla2xxx_tpg\n");
+		return ERR_PTR(-ENOMEM);
+	}
+	tpg->lport =3D lport;
+	tpg->lport_tpgt =3D tpgt;
+	/*
+	 * By default allow READ-ONLY TPG demo-mode access w/ cached dynamic =
NodeACLs
+	 */
+	QLA_TPG_ATTRIB(tpg)->generate_node_acls =3D 1;
+	QLA_TPG_ATTRIB(tpg)->demo_mode_write_protect =3D 1;
+	QLA_TPG_ATTRIB(tpg)->cache_dynamic_acls =3D 1;
+
+	ret =3D core_tpg_register(&tcm_qla2xxx_fabric_configfs->tf_ops, wwn,
+				&tpg->se_tpg, (void *)tpg,
+				TRANSPORT_TPG_TYPE_NORMAL);
+	if (ret < 0) {
+		kfree(tpg);
+		return NULL;
+	}
+	/*
+	 * Setup local TPG=3D1 pointer for non NPIV mode.
+	 */
+	if (lport->qla_npiv_vp =3D=3D NULL)
+		lport->tpg_1 =3D tpg;
+
+	return &tpg->se_tpg;
+}
+
+static void tcm_qla2xxx_drop_tpg(struct se_portal_group *se_tpg)
+{
+	struct tcm_qla2xxx_tpg *tpg =3D container_of(se_tpg,
+			struct tcm_qla2xxx_tpg, se_tpg);
+	struct tcm_qla2xxx_lport *lport =3D tpg->lport;
+	struct scsi_qla_host *vha =3D lport->qla_vha;
+	struct qla_hw_data *ha =3D vha->hw;
+	/*
+	 * Call into qla2x_target.c LLD logic to shutdown the active
+	 * FC Nexuses and disable target mode operation for this qla_hw_data
+	 */
+	if ((ha->qla_tgt !=3D NULL) && !ha->qla_tgt->tgt_stopped)
+		qla_tgt_stop_phase1(ha->qla_tgt);
+
+	core_tpg_deregister(se_tpg);
+	/*
+	 * Clear local TPG=3D1 pointer for non NPIV mode.
+	 */
+	if (lport->qla_npiv_vp =3D=3D NULL)
+		lport->tpg_1 =3D NULL;
+
+	kfree(tpg);
+}
+
+static struct se_portal_group *tcm_qla2xxx_npiv_make_tpg(
+	struct se_wwn *wwn,
+	struct config_group *group,
+	const char *name)
+{
+	struct tcm_qla2xxx_lport *lport =3D container_of(wwn,
+			struct tcm_qla2xxx_lport, lport_wwn);
+	struct tcm_qla2xxx_tpg *tpg;
+	unsigned long tpgt;
+	int ret;
+
+	if (strstr(name, "tpgt_") !=3D name)
+		return ERR_PTR(-EINVAL);
+	if (strict_strtoul(name + 5, 10, &tpgt) || tpgt > USHRT_MAX)
+		return ERR_PTR(-EINVAL);
+
+	tpg =3D kzalloc(sizeof(struct tcm_qla2xxx_tpg), GFP_KERNEL);
+	if (!(tpg)) {
+		printk(KERN_ERR "Unable to allocate struct tcm_qla2xxx_tpg\n");
+		return ERR_PTR(-ENOMEM);
+	}
+	tpg->lport =3D lport;
+	tpg->lport_tpgt =3D tpgt;
+
+	ret =3D core_tpg_register(&tcm_qla2xxx_npiv_fabric_configfs->tf_ops, =
wwn,
+				&tpg->se_tpg, (void *)tpg,
+				TRANSPORT_TPG_TYPE_NORMAL);
+	if (ret < 0) {
+		kfree(tpg);
+		return NULL;
+	}
+	return &tpg->se_tpg;
+}
+
+/*
+ * Expected to be called with struct qla_hw_data->hardware_lock held
+ */
+static struct qla_tgt_sess *tcm_qla2xxx_find_sess_by_s_id(
+	scsi_qla_host_t *vha,
+	const uint8_t *s_id)
+{
+	struct qla_hw_data *ha =3D vha->hw;
+	struct tcm_qla2xxx_lport *lport;
+	struct se_node_acl *se_nacl;
+	struct tcm_qla2xxx_nacl *nacl;
+	struct tcm_qla2xxx_fc_domain *d;
+	struct tcm_qla2xxx_fc_area *a;
+	struct tcm_qla2xxx_fc_al_pa *p;
+	unsigned char domain, area, al_pa;
+
+	lport =3D (struct tcm_qla2xxx_lport *)ha->target_lport_ptr;
+	if (!lport) {
+		printk(KERN_ERR "Unable to locate struct tcm_qla2xxx_lport\n");
+		dump_stack();
+		return NULL;
+	}
+
+	domain =3D s_id[0];
+	area =3D s_id[1];
+	al_pa =3D s_id[2];
+
+	DEBUG_QLA_TGT_SESS_MAP("find_sess_by_s_id: 0x%02x area: 0x%02x al_pa:=
 %02x\n",
+			domain, area, al_pa);
+
+	d =3D (struct tcm_qla2xxx_fc_domain *)&lport->lport_fcport_map[domain=
];
+	DEBUG_QLA_TGT_SESS_MAP("Using d: %p for domain: 0x%02x\n", d, domain)=
;
+	a =3D &d->areas[area];
+	DEBUG_QLA_TGT_SESS_MAP("Using a: %p for area: 0x%02x\n", a, area);
+	p =3D &a->al_pas[al_pa];
+	DEBUG_QLA_TGT_SESS_MAP("Using p: %p for al_pa: 0x%02x\n", p, al_pa);
+
+	se_nacl =3D p->se_nacl;
+	if (!se_nacl) {
+		printk(KERN_ERR "Unable to locate s_id: 0x%02x area: 0x%02x"
+			" al_pa: %02x\n", domain, area, al_pa);
+		return NULL;
+	}
+	DEBUG_QLA_TGT_SESS_MAP("find_sess_by_s_id: located se_nacl: %p,"
+		" initiatorname: %s\n", se_nacl, se_nacl->initiatorname);
+
+	nacl =3D container_of(se_nacl, struct tcm_qla2xxx_nacl, se_node_acl);
+	if (!nacl->qla_tgt_sess) {
+		printk(KERN_ERR "Unable to locate struct qla_tgt_sess\n");
+		return NULL;
+	}
+
+	return nacl->qla_tgt_sess;
+}
+
+/*
+ * Expected to be called with struct qla_hw_data->hardware_lock held
+ */
+static void tcm_qla2xxx_set_sess_by_s_id(
+	struct tcm_qla2xxx_lport *lport,
+	struct se_node_acl *new_se_nacl,
+	struct tcm_qla2xxx_nacl *nacl,
+	struct se_session *se_sess,
+	struct qla_tgt_sess *qla_tgt_sess,
+	uint8_t *s_id)
+{
+	struct se_node_acl *saved_nacl;
+	struct tcm_qla2xxx_fc_domain *d;
+	struct tcm_qla2xxx_fc_area *a;
+	struct tcm_qla2xxx_fc_al_pa *p;
+	unsigned char domain, area, al_pa;
+
+	domain =3D s_id[0];
+	area =3D s_id[1];
+	al_pa =3D s_id[2];
+	DEBUG_QLA_TGT_SESS_MAP("set_sess_by_s_id: domain 0x%02x area: 0x%02x =
al_pa: %02x\n",
+			domain, area, al_pa);
+
+	d =3D (struct tcm_qla2xxx_fc_domain *)&lport->lport_fcport_map[domain=
];
+	DEBUG_QLA_TGT_SESS_MAP("Using d: %p for domain: 0x%02x\n", d, domain)=
;
+	a =3D &d->areas[area];
+	DEBUG_QLA_TGT_SESS_MAP("Using a: %p for area: 0x%02x\n", a, area);
+	p =3D &a->al_pas[al_pa];
+	DEBUG_QLA_TGT_SESS_MAP("Using p: %p for al_pa: 0x%02x\n", p, al_pa);
+
+	saved_nacl =3D p->se_nacl;
+	if (!saved_nacl) {
+		DEBUG_QLA_TGT_SESS_MAP("Setting up new p->se_nacl to new_se_nacl\n")=
;
+		p->se_nacl =3D new_se_nacl;
+		qla_tgt_sess->se_sess =3D se_sess;
+		nacl->qla_tgt_sess =3D qla_tgt_sess;
+		return;
+	}
+
+	if (nacl->qla_tgt_sess) {
+		if (new_se_nacl =3D=3D NULL) {
+			DEBUG_QLA_TGT_SESS_MAP("Clearing existing nacl->qla_tgt_sess"
+					" and p->se_nacl\n");
+			p->se_nacl =3D NULL;
+			nacl->qla_tgt_sess =3D NULL;
+			return;
+		}
+		DEBUG_QLA_TGT_SESS_MAP("Replacing existing nacl->qla_tgt_sess and"
+				" p->se_nacl\n");
+		p->se_nacl =3D new_se_nacl;
+		qla_tgt_sess->se_sess =3D se_sess;
+		nacl->qla_tgt_sess =3D qla_tgt_sess;
+		return;
+	}
+
+	if (new_se_nacl =3D=3D NULL) {
+		DEBUG_QLA_TGT_SESS_MAP("Clearing existing p->se_nacl\n");
+		p->se_nacl =3D NULL;
+		return;
+	}
+
+	DEBUG_QLA_TGT_SESS_MAP("Replacing existing p->se_nacl w/o active"
+				" nacl->qla_tgt_sess\n");
+	p->se_nacl =3D new_se_nacl;
+	qla_tgt_sess->se_sess =3D se_sess;
+	nacl->qla_tgt_sess =3D qla_tgt_sess;
+
+	DEBUG_QLA_TGT_SESS_MAP("Setup nacl->qla_tgt_sess %p by s_id for se_na=
cl: %p,"
+		" initiatorname: %s\n", nacl->qla_tgt_sess, new_se_nacl,
+		new_se_nacl->initiatorname);
+}
+
+/*
+ * Expected to be called with struct qla_hw_data->hardware_lock held
+ */
+static struct qla_tgt_sess *tcm_qla2xxx_find_sess_by_loop_id(
+	scsi_qla_host_t *vha,
+	const uint16_t loop_id)
+{
+	struct qla_hw_data *ha =3D vha->hw;
+	struct tcm_qla2xxx_lport *lport;
+	struct se_node_acl *se_nacl;
+	struct tcm_qla2xxx_nacl *nacl;
+	struct tcm_qla2xxx_fc_loopid *fc_loopid;
+
+	lport =3D (struct tcm_qla2xxx_lport *)ha->target_lport_ptr;
+	if (!lport) {
+		printk(KERN_ERR "Unable to locate struct tcm_qla2xxx_lport\n");
+		dump_stack();
+		return NULL;
+	}
+
+	DEBUG_QLA_TGT_SESS_MAP("find_sess_by_loop_id: Using loop_id: 0x%04x\n=
", loop_id);
+
+	fc_loopid =3D (struct tcm_qla2xxx_fc_loopid *)&lport->lport_loopid_ma=
p[loop_id];
+
+	se_nacl =3D fc_loopid->se_nacl;
+	if (!se_nacl) {
+		printk(KERN_ERR "Unable to locate se_nacl by loop_id:"
+				" 0x%04x\n", loop_id);
+		return NULL;
+	}
+
+	nacl =3D container_of(se_nacl, struct tcm_qla2xxx_nacl, se_node_acl);
+
+	if (!nacl->qla_tgt_sess) {
+		printk(KERN_ERR "Unable to locate struct qla_tgt_sess\n");
+		return NULL;
+	}
+
+	return nacl->qla_tgt_sess;
+}
+
+/*
+ * Expected to be called with struct qla_hw_data->hardware_lock held
+ */
+static void tcm_qla2xxx_set_sess_by_loop_id(
+	struct tcm_qla2xxx_lport *lport,
+	struct se_node_acl *new_se_nacl,
+	struct tcm_qla2xxx_nacl *nacl,
+	struct se_session *se_sess,
+	struct qla_tgt_sess *qla_tgt_sess,
+	uint16_t loop_id)
+{
+	struct se_node_acl *saved_nacl;
+	struct tcm_qla2xxx_fc_loopid *fc_loopid;
+
+	DEBUG_QLA_TGT_SESS_MAP("set_sess_by_loop_id: Using loop_id: 0x%04x\n"=
, loop_id);
+
+	fc_loopid =3D (struct tcm_qla2xxx_fc_loopid *)&lport->lport_loopid_ma=
p[loop_id];
+
+	saved_nacl =3D fc_loopid->se_nacl;
+	if (!saved_nacl) {
+		DEBUG_QLA_TGT_SESS_MAP("Setting up new fc_loopid->se_nacl"
+				" to new_se_nacl\n");
+		fc_loopid->se_nacl =3D new_se_nacl;
+		if (qla_tgt_sess->se_sess !=3D se_sess)
+			qla_tgt_sess->se_sess =3D se_sess;
+		if (nacl->qla_tgt_sess !=3D qla_tgt_sess)
+			nacl->qla_tgt_sess =3D qla_tgt_sess;
+		return;
+	}
+
+	if (nacl->qla_tgt_sess) {
+		if (new_se_nacl =3D=3D NULL) {
+			DEBUG_QLA_TGT_SESS_MAP("Clearing nacl->qla_tgt_sess and"
+					" fc_loopid->se_nacl\n");
+			fc_loopid->se_nacl =3D NULL;
+			nacl->qla_tgt_sess =3D NULL;
+			return;
+		}
+
+		DEBUG_QLA_TGT_SESS_MAP("Replacing existing nacl->qla_tgt_sess and"
+				" fc_loopid->se_nacl\n");
+		fc_loopid->se_nacl =3D new_se_nacl;
+		if (qla_tgt_sess->se_sess !=3D se_sess)
+			qla_tgt_sess->se_sess =3D se_sess;
+		if (nacl->qla_tgt_sess !=3D qla_tgt_sess)
+			nacl->qla_tgt_sess =3D qla_tgt_sess;
+		return;
+	}
+
+	if (new_se_nacl =3D=3D NULL) {
+		DEBUG_QLA_TGT_SESS_MAP("Clearing fc_loopid->se_nacl\n");
+		fc_loopid->se_nacl =3D NULL;
+		return;
+	}
+
+	DEBUG_QLA_TGT_SESS_MAP("Replacing existing fc_loopid->se_nacl w/o"
+			" active nacl->qla_tgt_sess\n");
+	fc_loopid->se_nacl =3D new_se_nacl;
+	if (qla_tgt_sess->se_sess !=3D se_sess)
+		qla_tgt_sess->se_sess =3D se_sess;
+	if (nacl->qla_tgt_sess !=3D qla_tgt_sess)
+		nacl->qla_tgt_sess =3D qla_tgt_sess;
+
+	DEBUG_QLA_TGT_SESS_MAP("Setup nacl->qla_tgt_sess %p by loop_id for se=
_nacl: %p,"
+		" initiatorname: %s\n", nacl->qla_tgt_sess, new_se_nacl,
+		new_se_nacl->initiatorname);
+}
+
+static void tcm_qla2xxx_free_session(struct qla_tgt_sess *sess)
+{
+	struct qla_tgt *tgt =3D sess->tgt;
+	struct qla_hw_data *ha =3D tgt->ha;
+	struct se_session *se_sess;
+	struct se_node_acl *se_nacl;
+	struct tcm_qla2xxx_lport *lport;
+	struct tcm_qla2xxx_nacl *nacl;
+	unsigned char be_sid[3];
+
+	se_sess =3D sess->se_sess;
+	if (!se_sess) {
+		printk(KERN_ERR "struct qla_tgt_sess->se_sess is NULL\n");
+		dump_stack();
+		return;
+	}
+	se_nacl =3D se_sess->se_node_acl;
+        nacl =3D container_of(se_nacl, struct tcm_qla2xxx_nacl, se_nod=
e_acl);
+
+	lport =3D (struct tcm_qla2xxx_lport *)ha->target_lport_ptr;
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
+         * And now clear the se_nacl and session pointers from our HW =
lport
+         * mappings for fabric S_ID and LOOP_ID.
+         */
+	memset(&be_sid, 0, 3);
+	be_sid[0] =3D sess->s_id.b.domain;
+	be_sid[1] =3D sess->s_id.b.area;
+	be_sid[2] =3D sess->s_id.b.al_pa;
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
+ * Called via qla_tgt_create_sess():ha->qla2x_tmpl->check_initiator_no=
de_acl()
+ * to locate struct se_node_acl
+ */
+static int tcm_qla2xxx_check_initiator_node_acl(
+	scsi_qla_host_t *vha,
+	unsigned char *fc_wwpn,
+	void *qla_tgt_sess,
+	uint8_t *s_id,
+	uint16_t loop_id)
+{
+	struct qla_hw_data *ha =3D vha->hw;
+	struct tcm_qla2xxx_lport *lport;
+	struct tcm_qla2xxx_tpg *tpg;
+	struct tcm_qla2xxx_nacl *nacl;
+	struct se_portal_group *se_tpg;
+	struct se_node_acl *se_nacl;
+	struct se_session *se_sess;
+	struct qla_tgt_sess *sess =3D qla_tgt_sess;
+	unsigned char port_name[36];
+	unsigned long flags;
+
+	lport =3D (struct tcm_qla2xxx_lport *)ha->target_lport_ptr;
+	if (!lport) {
+		printk(KERN_ERR "Unable to locate struct tcm_qla2xxx_lport\n");
+		dump_stack();
+		return -EINVAL;
+	}
+	/*
+	 * Locate the TPG=3D1 reference..
+	 */
+	tpg =3D lport->tpg_1;
+	if (!tpg) {
+		printk(KERN_ERR "Unable to lcoate struct tcm_qla2xxx_lport->tpg_1\n"=
);
+		return -EINVAL;
+	}
+	se_tpg =3D &tpg->se_tpg;
+
+	se_sess =3D transport_init_session();
+	if (!se_sess) {
+		printk(KERN_ERR "Unable to initialize struct se_session\n");
+		return -ENOMEM;
+	}
+	/*
+	 * Format the FCP Initiator port_name into colon seperated values to =
match
+	 * the format by tcm_qla2xxx explict ConfigFS NodeACLs.
+	 */
+	memset(&port_name, 0, 36);
+	snprintf(port_name, 36, "%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x",
+		fc_wwpn[0], fc_wwpn[1], fc_wwpn[2], fc_wwpn[3], fc_wwpn[4],
+		fc_wwpn[5], fc_wwpn[6], fc_wwpn[7]);
+	/*
+	 * Locate our struct se_node_acl either from an explict NodeACL creat=
ed
+	 * via ConfigFS, or via running in TPG demo mode.
+	 */
+	se_sess->se_node_acl =3D core_tpg_check_initiator_node_acl(se_tpg, po=
rt_name);
+	if (!se_sess->se_node_acl) {
+		transport_free_session(se_sess);
+		return -EINVAL;
+	}
+	se_nacl =3D se_sess->se_node_acl;
+	nacl =3D container_of(se_nacl, struct tcm_qla2xxx_nacl, se_node_acl);
+	/*
+	 * And now setup the new se_nacl and session pointers into our HW lpo=
rt
+	 * mappings for fabric S_ID and LOOP_ID.
+	 */
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	tcm_qla2xxx_set_sess_by_s_id(lport, se_nacl, nacl, se_sess,
+			qla_tgt_sess, s_id);
+	tcm_qla2xxx_set_sess_by_loop_id(lport, se_nacl, nacl, se_sess,
+			qla_tgt_sess, loop_id);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	/*
+	 * Finally register the new FC Nexus with TCM
+	 */
+	__transport_register_session(se_nacl->se_tpg, se_nacl, se_sess, sess)=
;
+
+	return 0;
+}
+
+/*
+ * Calls into tcm_qla2xxx used by qla2xxx LLD I/O path.
+ */
+static struct qla_target_template tcm_qla2xxx_template =3D {
+	.handle_cmd		=3D tcm_qla2xxx_handle_cmd,
+	.handle_data		=3D tcm_qla2xxx_handle_data,
+	.handle_tmr		=3D tcm_qla2xxx_handle_tmr,
+	.free_cmd		=3D tcm_qla2xxx_free_cmd,
+	.free_session		=3D tcm_qla2xxx_free_session,
+	.check_initiator_node_acl =3D tcm_qla2xxx_check_initiator_node_acl,
+	.find_sess_by_s_id	=3D tcm_qla2xxx_find_sess_by_s_id,
+	.find_sess_by_loop_id	=3D tcm_qla2xxx_find_sess_by_loop_id,
+};
+
+static int tcm_qla2xxx_init_lport(
+	struct tcm_qla2xxx_lport *lport,
+	struct scsi_qla_host *vha,
+	struct scsi_qla_host *npiv_vp)
+{
+	struct qla_hw_data *ha =3D vha->hw;
+
+	lport->lport_fcport_map =3D vmalloc(
+			sizeof(struct tcm_qla2xxx_fc_domain) * 256);
+	if (!(lport->lport_fcport_map)) {
+		printk(KERN_ERR "Unable to allocate lport_fcport_map of %lu"
+			" bytes\n", sizeof(struct tcm_qla2xxx_fc_domain) * 256);
+		return -ENOMEM;
+	}
+	memset(lport->lport_fcport_map, 0,
+			sizeof(struct tcm_qla2xxx_fc_domain) * 256);
+	printk(KERN_INFO "qla2xxx: Allocated lport_fcport_map of %lu bytes\n"=
,
+			sizeof(struct tcm_qla2xxx_fc_domain) * 256);
+
+	lport->lport_loopid_map =3D vmalloc(sizeof(struct tcm_qla2xxx_fc_loop=
id) *
+				65536);
+	if (!(lport->lport_loopid_map)) {
+		printk(KERN_ERR "Unable to allocate lport->lport_loopid_map"
+			" of %lu bytes\n", sizeof(struct tcm_qla2xxx_fc_loopid)
+			* 65536);
+		vfree(lport->lport_fcport_map);
+		return -ENOMEM;
+	}
+	memset(lport->lport_loopid_map, 0, sizeof(struct tcm_qla2xxx_fc_loopi=
d)
+			* 65536);
+	printk(KERN_INFO "qla2xxx: Allocated lport_loopid_map of %lu bytes\n"=
,
+			sizeof(struct tcm_qla2xxx_fc_loopid) * 65536);
+	/*
+	 * Setup local pointer to vha, NPIV VP pointer (if present) and
+	 * vha->tcm_lport pointer
+	 */
+	lport->qla_vha =3D vha;
+	lport->qla_npiv_vp =3D npiv_vp;
+	/*
+	 * Setup the target_lport_ptr and qla2x_tmpl.
+	 */
+	ha->target_lport_ptr =3D lport;
+	ha->qla2x_tmpl =3D &tcm_qla2xxx_template;
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
+	struct Scsi_Host *host =3D NULL;
+	struct pci_dev *dev =3D NULL;
+	struct scsi_qla_host *vha;
+	struct qla_hw_data *ha;
+	unsigned long flags;
+	u64 wwpn;
+	int i, ret =3D -ENODEV;
+	u8 b[8];
+
+	if (tcm_qla2xxx_parse_wwn(name, &wwpn, 1) < 0)
+		return ERR_PTR(-EINVAL);
+
+	lport =3D kzalloc(sizeof(struct tcm_qla2xxx_lport), GFP_KERNEL);
+	if (!(lport)) {
+		printk(KERN_ERR "Unable to allocate struct tcm_qla2xxx_lport\n");
+		return ERR_PTR(-ENOMEM);
+	}
+	lport->lport_wwpn =3D wwpn;
+	tcm_qla2xxx_format_wwn(&lport->lport_name[0], TCM_QLA2XXX_NAMELEN, ww=
pn);
+
+	while ((dev =3D pci_get_device(PCI_VENDOR_ID_QLOGIC, PCI_ANY_ID,
+					dev)) !=3D NULL) {
+
+		vha =3D pci_get_drvdata(dev);
+		if (!vha)
+			continue;
+		ha =3D vha->hw;
+		if (!ha)
+			continue;
+		host =3D vha->host;
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
+			ret =3D -EINVAL;
+			goto out;
+		}
+
+		printk("qla2xxx HW vha->node_name: ");
+		for (i =3D 0; i < 8; i++)
+			printk("%02x ", vha->node_name[i]);
+		printk("\n");
+
+		printk("qla2xxx HW vha->port_name: ");
+		for (i =3D 0; i < 8; i++)
+			printk("%02x ", vha->port_name[i]);
+		printk("\n");
+
+		printk("qla2xxx passed configfs WWPN: ");
+		put_unaligned_be64(wwpn, b);
+		for (i =3D 0; i < 8; i++)
+			printk("%02x ", b[i]);
+		printk("\n");
+
+		if (memcmp(vha->port_name, b, 8)) {
+			scsi_host_put(host);
+			continue;
+		}
+		printk("qla2xxx: Found matching HW WWPN: %s for lport\n", name);
+		ret =3D tcm_qla2xxx_init_lport(lport, vha, NULL);
+		break;
+	}
+
+	if (ret !=3D 0)
+		goto out;
+
+	return &lport->lport_wwn;
+out:
+	kfree(lport);
+	return ERR_PTR(ret);
+}
+
+static void tcm_qla2xxx_drop_lport(struct se_wwn *wwn)
+{
+	struct tcm_qla2xxx_lport *lport =3D container_of(wwn,
+			struct tcm_qla2xxx_lport, lport_wwn);
+	struct scsi_qla_host *vha =3D lport->qla_vha;
+	struct qla_hw_data *ha =3D vha->hw;
+	struct Scsi_Host *sh =3D vha->host;
+	/*
+	 * Call into qla2x_target.c LLD logic to complete the
+	 * shutdown of struct qla_tgt after the call to
+	 * qla_tgt_stop_phase1() from tcm_qla2xxx_drop_tpg() above..
+	 */
+	if ((ha->qla_tgt !=3D NULL) && !ha->qla_tgt->tgt_stopped)
+		qla_tgt_stop_phase2(ha->qla_tgt);
+	/*
+	 * Clear the target_lport_ptr qla_target_template pointer in qla_hw_d=
ata
+	 */
+	ha->target_lport_ptr =3D NULL;
+	ha->qla2x_tmpl =3D NULL;
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
+	struct Scsi_Host *host =3D NULL;
+	struct pci_dev *dev =3D NULL;
+	struct scsi_qla_host *vha, *npiv_vp;
+	struct qla_hw_data *ha;
+	struct fc_vport_identifiers vid;
+	struct fc_vport *vport;
+	unsigned long flags;
+	u64 npiv_wwpn, npiv_wwnn;
+	int i, ret =3D -ENODEV;
+	u8 b[8], b2[8];
+
+	if (tcm_qla2xxx_npiv_parse_wwn(name, strlen(name)+1,
+				&npiv_wwpn, &npiv_wwnn) < 0)
+		return ERR_PTR(-EINVAL);
+
+	lport =3D kzalloc(sizeof(struct tcm_qla2xxx_lport), GFP_KERNEL);
+	if (!(lport)) {
+		printk(KERN_ERR "Unable to allocate struct tcm_qla2xxx_lport"
+				" for NPIV\n");
+		return ERR_PTR(-ENOMEM);
+	}
+	lport->lport_npiv_wwpn =3D npiv_wwpn;
+	lport->lport_npiv_wwnn =3D npiv_wwnn;
+	tcm_qla2xxx_npiv_format_wwn(&lport->lport_npiv_name[0],
+			TCM_QLA2XXX_NAMELEN, npiv_wwpn, npiv_wwnn);
+
+	while ((dev =3D pci_get_device(PCI_VENDOR_ID_QLOGIC, PCI_ANY_ID,
+					dev)) !=3D NULL) {
+
+		vha =3D pci_get_drvdata(dev);
+		if (!vha)
+			continue;
+		ha =3D vha->hw;
+		if (!ha)
+			continue;
+		host =3D vha->host;
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
+			ret =3D -EINVAL;
+			goto out;
+		}
+
+		printk("qla2xxx HW vha->node_name: ");
+		for (i =3D 0; i < 8; i++)
+			printk("%02x ", vha->node_name[i]);
+		printk("\n");
+
+		printk("qla2xxx HW vha->port_name: ");
+		for (i =3D 0; i < 8; i++)
+			printk("%02x ", vha->port_name[i]);
+		printk("\n");
+
+		printk("qla2xxx passed configfs NPIV WWPN: ");
+		put_unaligned_be64(npiv_wwpn, b);
+		for (i =3D 0; i < 8; i++)
+			printk("%02x ", b[i]);
+		printk("\n");
+
+		printk("qla2xxx passed configfs NPIV WWNN: ");
+		put_unaligned_be64(npiv_wwnn, b2);
+		for (i =3D 0; i < 8; i++)
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
+#warning FIXME: Need to add atomic_inc(&npiv_vp->vref_count) before dr=
opping ha->vport_slock..?
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
+			vid.roles =3D FC_PORT_ROLE_FCP_INITIATOR;
+			vid.vport_type =3D FC_PORTTYPE_NPIV;
+			vid.port_name =3D npiv_wwpn;
+			vid.node_name =3D npiv_wwnn;
+			/* vid.symbolic_name is already zero/NULL's */
+			vid.disable =3D false;	/* always enabled */
+
+			/* we only allow support on Channel 0 !!! */
+			vport =3D fc_vport_create(host, 0, &vid);
+			if (!vport) {
+				printk(KERN_ERR "fc_vport_create() failed for"
+						" NPIV tcm_qla2xxx\n");
+				scsi_host_put(host);
+				ret =3D -EINVAL;
+				goto out;
+			}
+			lport->npiv_vport =3D vport;
+			ret =3D 0;
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
+	if (ret !=3D 0)
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
+	struct tcm_qla2xxx_lport *lport =3D container_of(wwn,
+			struct tcm_qla2xxx_lport, lport_wwn);
+	struct scsi_qla_host *vha =3D lport->qla_vha;
+	struct Scsi_Host *sh =3D vha->host;
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
+	return sprintf(page, "TCM QLOGIC QLA2XXX NPIV capable fabric module %=
s on %s/%s"
+		" on "UTS_RELEASE"\n", TCM_QLA2XXX_VERSION, utsname()->sysname,
+		utsname()->machine);
+}
+
+TF_WWN_ATTR_RO(tcm_qla2xxx, version);
+
+static struct configfs_attribute *tcm_qla2xxx_wwn_attrs[] =3D {
+	&tcm_qla2xxx_wwn_version.attr,
+	NULL,
+};
+
+static struct target_core_fabric_ops tcm_qla2xxx_ops =3D {
+	.get_fabric_name		=3D tcm_qla2xxx_get_fabric_name,
+	.get_fabric_proto_ident		=3D tcm_qla2xxx_get_fabric_proto_ident,
+	.tpg_get_wwn			=3D tcm_qla2xxx_get_fabric_wwn,
+	.tpg_get_tag			=3D tcm_qla2xxx_get_tag,
+	.tpg_get_default_depth		=3D tcm_qla2xxx_get_default_depth,
+	.tpg_get_pr_transport_id	=3D tcm_qla2xxx_get_pr_transport_id,
+	.tpg_get_pr_transport_id_len	=3D tcm_qla2xxx_get_pr_transport_id_len,
+	.tpg_parse_pr_out_transport_id	=3D tcm_qla2xxx_parse_pr_out_transport=
_id,
+	.tpg_check_demo_mode		=3D tcm_qla2xxx_check_demo_mode,
+	.tpg_check_demo_mode_cache	=3D tcm_qla2xxx_check_demo_mode_cache,
+	.tpg_check_demo_mode_write_protect =3D tcm_qla2xxx_check_demo_write_p=
rotect,
+	.tpg_check_prod_mode_write_protect =3D tcm_qla2xxx_check_prod_write_p=
rotect,
+	.tpg_alloc_fabric_acl		=3D tcm_qla2xxx_alloc_fabric_acl,
+	.tpg_release_fabric_acl		=3D tcm_qla2xxx_release_fabric_acl,
+	.tpg_get_inst_index		=3D tcm_qla2xxx_tpg_get_inst_index,
+	.new_cmd_map			=3D tcm_qla2xxx_new_cmd_map,
+	.check_stop_free		=3D tcm_qla2xxx_check_stop_free,
+	.release_cmd_to_pool		=3D tcm_qla2xxx_release_cmd,
+	.release_cmd_direct		=3D tcm_qla2xxx_release_cmd,
+	.shutdown_session		=3D tcm_qla2xxx_shutdown_session,
+	.close_session			=3D tcm_qla2xxx_close_session,
+	.stop_session			=3D tcm_qla2xxx_stop_session,
+	.fall_back_to_erl0		=3D tcm_qla2xxx_reset_nexus,
+	.sess_logged_in			=3D tcm_qla2xxx_sess_logged_in,
+	.sess_get_index			=3D tcm_qla2xxx_sess_get_index,
+	.sess_get_initiator_sid		=3D NULL,
+	.write_pending			=3D tcm_qla2xxx_write_pending,
+	.write_pending_status		=3D tcm_qla2xxx_write_pending_status,
+	.set_default_node_attributes	=3D tcm_qla2xxx_set_default_node_attrs,
+	.get_task_tag			=3D tcm_qla2xxx_get_task_tag,
+	.get_cmd_state			=3D tcm_qla2xxx_get_cmd_state,
+	.new_cmd_failure		=3D tcm_qla2xxx_new_cmd_failure,
+	.queue_data_in			=3D tcm_qla2xxx_queue_data_in,
+	.queue_status			=3D tcm_qla2xxx_queue_status,
+	.queue_tm_rsp			=3D tcm_qla2xxx_queue_tm_rsp,
+	.get_fabric_sense_len		=3D tcm_qla2xxx_get_fabric_sense_len,
+	.set_fabric_sense_len		=3D tcm_qla2xxx_set_fabric_sense_len,
+	.is_state_remove		=3D tcm_qla2xxx_is_state_remove,
+	.pack_lun			=3D tcm_qla2xxx_pack_lun,
+	/*
+	 * Setup function pointers for generic logic in target_core_fabric_co=
nfigfs.c
+	 */
+	.fabric_make_wwn		=3D tcm_qla2xxx_make_lport,
+	.fabric_drop_wwn		=3D tcm_qla2xxx_drop_lport,
+	.fabric_make_tpg		=3D tcm_qla2xxx_make_tpg,
+	.fabric_drop_tpg		=3D tcm_qla2xxx_drop_tpg,
+	.fabric_post_link		=3D NULL,
+	.fabric_pre_unlink		=3D NULL,
+	.fabric_make_np			=3D NULL,
+	.fabric_drop_np			=3D NULL,
+	.fabric_make_nodeacl		=3D tcm_qla2xxx_make_nodeacl,
+	.fabric_drop_nodeacl		=3D tcm_qla2xxx_drop_nodeacl,
+};
+
+static struct target_core_fabric_ops tcm_qla2xxx_npiv_ops =3D {
+	.get_fabric_name		=3D tcm_qla2xxx_npiv_get_fabric_name,
+	.get_fabric_proto_ident		=3D tcm_qla2xxx_get_fabric_proto_ident,
+	.tpg_get_wwn			=3D tcm_qla2xxx_npiv_get_fabric_wwn,
+	.tpg_get_tag			=3D tcm_qla2xxx_get_tag,
+	.tpg_get_default_depth		=3D tcm_qla2xxx_get_default_depth,
+	.tpg_get_pr_transport_id	=3D tcm_qla2xxx_get_pr_transport_id,
+	.tpg_get_pr_transport_id_len	=3D tcm_qla2xxx_get_pr_transport_id_len,
+	.tpg_parse_pr_out_transport_id	=3D tcm_qla2xxx_parse_pr_out_transport=
_id,
+	.tpg_check_demo_mode		=3D tcm_qla2xxx_check_false,
+	.tpg_check_demo_mode_cache	=3D tcm_qla2xxx_check_true,
+	.tpg_check_demo_mode_write_protect =3D tcm_qla2xxx_check_true,
+	.tpg_check_prod_mode_write_protect =3D tcm_qla2xxx_check_false,
+	.tpg_alloc_fabric_acl		=3D tcm_qla2xxx_alloc_fabric_acl,
+	.tpg_release_fabric_acl		=3D tcm_qla2xxx_release_fabric_acl,
+	.tpg_get_inst_index		=3D tcm_qla2xxx_tpg_get_inst_index,
+	.release_cmd_to_pool		=3D tcm_qla2xxx_release_cmd,
+	.release_cmd_direct		=3D tcm_qla2xxx_release_cmd,
+	.shutdown_session		=3D tcm_qla2xxx_shutdown_session,
+	.close_session			=3D tcm_qla2xxx_close_session,
+	.stop_session			=3D tcm_qla2xxx_stop_session,
+	.fall_back_to_erl0		=3D tcm_qla2xxx_reset_nexus,
+	.sess_logged_in			=3D tcm_qla2xxx_sess_logged_in,
+	.sess_get_index			=3D tcm_qla2xxx_sess_get_index,
+	.sess_get_initiator_sid		=3D NULL,
+	.write_pending			=3D tcm_qla2xxx_write_pending,
+	.write_pending_status		=3D tcm_qla2xxx_write_pending_status,
+	.set_default_node_attributes	=3D tcm_qla2xxx_set_default_node_attrs,
+	.get_task_tag			=3D tcm_qla2xxx_get_task_tag,
+	.get_cmd_state			=3D tcm_qla2xxx_get_cmd_state,
+	.new_cmd_failure		=3D tcm_qla2xxx_new_cmd_failure,
+	.queue_data_in			=3D tcm_qla2xxx_queue_data_in,
+	.queue_status			=3D tcm_qla2xxx_queue_status,
+	.queue_tm_rsp			=3D tcm_qla2xxx_queue_tm_rsp,
+	.get_fabric_sense_len		=3D tcm_qla2xxx_get_fabric_sense_len,
+	.set_fabric_sense_len		=3D tcm_qla2xxx_set_fabric_sense_len,
+	.is_state_remove		=3D tcm_qla2xxx_is_state_remove,
+	.pack_lun			=3D tcm_qla2xxx_pack_lun,
+	/*
+	 * Setup function pointers for generic logic in target_core_fabric_co=
nfigfs.c
+	 */
+	.fabric_make_wwn		=3D tcm_qla2xxx_npiv_make_lport,
+	.fabric_drop_wwn		=3D tcm_qla2xxx_npiv_drop_lport,
+	.fabric_make_tpg		=3D tcm_qla2xxx_npiv_make_tpg,
+	.fabric_drop_tpg		=3D tcm_qla2xxx_drop_tpg,
+	.fabric_post_link		=3D NULL,
+	.fabric_pre_unlink		=3D NULL,
+	.fabric_make_np			=3D NULL,
+	.fabric_drop_np			=3D NULL,
+	.fabric_make_nodeacl		=3D tcm_qla2xxx_make_nodeacl,
+	.fabric_drop_nodeacl		=3D tcm_qla2xxx_drop_nodeacl,
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
+	fabric =3D target_fabric_configfs_init(THIS_MODULE, "qla2xxx");
+	if (!(fabric)) {
+		printk(KERN_ERR "target_fabric_configfs_init() failed\n");
+		return -ENOMEM;
+	}
+	/*
+	 * Setup fabric->tf_ops from our local tcm_qla2xxx_ops
+	 */
+	fabric->tf_ops =3D tcm_qla2xxx_ops;
+	/*
+	 * Setup the struct se_task->task_sg[] chaining bit
+	 */
+	fabric->tf_ops.task_sg_chaining =3D 1;
+	/*
+	 * Setup default attribute lists for various fabric->tf_cit_tmpl
+	 */
+	TF_CIT_TMPL(fabric)->tfc_wwn_cit.ct_attrs =3D tcm_qla2xxx_wwn_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_base_cit.ct_attrs =3D tcm_qla2xxx_tpg_at=
trs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_attrib_cit.ct_attrs =3D tcm_qla2xxx_tpg_=
attrib_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_param_cit.ct_attrs =3D NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_np_base_cit.ct_attrs =3D NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_base_cit.ct_attrs =3D NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_attrib_cit.ct_attrs =3D NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_auth_cit.ct_attrs =3D NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_param_cit.ct_attrs =3D NULL;
+	/*
+	 * Register the fabric for use within TCM
+	 */
+	ret =3D target_fabric_configfs_register(fabric);
+	if (ret < 0) {
+		printk(KERN_ERR "target_fabric_configfs_register() failed"
+				" for TCM_QLA2XXX\n");
+		return ret;
+	}
+	/*
+	 * Setup our local pointer to *fabric
+	 */
+	tcm_qla2xxx_fabric_configfs =3D fabric;=09
+	printk(KERN_INFO "TCM_QLA2XXX[0] - Set fabric -> tcm_qla2xxx_fabric_c=
onfigfs\n");
+
+	/*
+	 * Register the top level struct config_item_type for NPIV with TCM c=
ore
+	 */
+	npiv_fabric =3D target_fabric_configfs_init(THIS_MODULE, "qla2xxx_npi=
v");
+	if (!(npiv_fabric)) {
+		printk(KERN_ERR "target_fabric_configfs_init() failed\n");
+		ret =3D -ENOMEM;
+		goto out;
+	}
+	/*
+	 * Setup fabric->tf_ops from our local tcm_qla2xxx_npiv_ops
+	 */
+	npiv_fabric->tf_ops =3D tcm_qla2xxx_npiv_ops;
+	/*
+	 * Setup default attribute lists for various npiv_fabric->tf_cit_tmpl
+	 */
+	TF_CIT_TMPL(npiv_fabric)->tfc_wwn_cit.ct_attrs =3D tcm_qla2xxx_wwn_at=
trs;
+	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_base_cit.ct_attrs =3D NULL;
+	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_attrib_cit.ct_attrs =3D NULL;
+	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_param_cit.ct_attrs =3D NULL;
+	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_np_base_cit.ct_attrs =3D NULL;
+	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_nacl_base_cit.ct_attrs =3D NULL;
+	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_nacl_attrib_cit.ct_attrs =3D NULL;
+	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_nacl_auth_cit.ct_attrs =3D NULL;
+	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_nacl_param_cit.ct_attrs =3D NULL;
+	/*
+	 * Register the npiv_fabric for use within TCM
+	 */
+	ret =3D target_fabric_configfs_register(npiv_fabric);
+	if (ret < 0) {
+		printk(KERN_ERR "target_fabric_configfs_register() failed"
+				" for TCM_QLA2XXX\n");
+		goto out;;
+	}
+	/*
+	 * Setup our local pointer to *npiv_fabric
+	 */
+	tcm_qla2xxx_npiv_fabric_configfs =3D npiv_fabric;
+	printk(KERN_INFO "TCM_QLA2XXX[0] - Set fabric -> tcm_qla2xxx_npiv_fab=
ric_configfs\n");
+
+	return 0;
+out:
+	if (tcm_qla2xxx_fabric_configfs !=3D NULL)
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
+	tcm_qla2xxx_fabric_configfs =3D NULL;
+	printk(KERN_INFO "TCM_QLA2XXX[0] - Cleared tcm_qla2xxx_fabric_configf=
s\n");
+
+	target_fabric_configfs_deregister(tcm_qla2xxx_npiv_fabric_configfs);
+	tcm_qla2xxx_npiv_fabric_configfs =3D NULL;
+	printk(KERN_INFO "TCM_QLA2XXX[0] - Cleared tcm_qla2xxx_npiv_fabric_co=
nfigfs\n");
+}
+
+static int __init tcm_qla2xxx_init(void)
+{
+	int ret;
+
+	ret =3D tcm_qla2xxx_register_configfs();
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
diff --git a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c b/drivers/=
target/tcm_qla2xxx/tcm_qla2xxx_fabric.c
new file mode 100644
index 0000000..a79c957
--- /dev/null
+++ b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c
@@ -0,0 +1,853 @@
+/*********************************************************************=
**********
+ * This file contains TCM_QLA2XXX functions for struct target_core_fab=
rib_ops
+ * for Qlogic 2xxx series target mode HBAs
+ *
+ * =C2=A9 Copyright 2010-2011 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (=
GPL) version 2.
+ *
+ * Author: Nicholas A. Bellinger <nab@risingtidesystems.com>
+ *
+ * tcm_qla2xxx_parse_wwn() and tcm_qla2xxx_format_wwn() contains code =
from
+ * the TCM_FC / Open-FCoE.org fabric module.
+ *
+ * Copyright (c) 2010 Cisco Systems, Inc
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *********************************************************************=
*******/
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
+#include <qla_target.h>
+
+#include "tcm_qla2xxx_base.h"
+#include "tcm_qla2xxx_fabric.h"
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
+ * If strict, we require lower-case hex and colon separators to be sur=
e
+ * the name is the same as what would be generated by ft_format_wwn()
+ * so the name and wwn are mapped one-to-one.
+ */
+ssize_t tcm_qla2xxx_parse_wwn(const char *name, u64 *wwn, int strict)
+{
+	const char *cp;
+	char c;
+	u32 nibble;
+	u32 byte =3D 0;
+	u32 pos =3D 0;
+	u32 err;
+
+	*wwn =3D 0;
+	for (cp =3D name; cp < &name[TCM_QLA2XXX_NAMELEN - 1]; cp++) {
+		c =3D *cp;
+		if (c =3D=3D '\n' && cp[1] =3D=3D '\0')
+			continue;
+		if (strict && pos++ =3D=3D 2 && byte++ < 7) {
+			pos =3D 0;
+			if (c =3D=3D ':')
+				continue;
+			err =3D 1;
+			goto fail;
+		}
+		if (c =3D=3D '\0') {
+			err =3D 2;
+			if (strict && byte !=3D 8)
+				goto fail;
+			return cp - name;
+		}
+		err =3D 3;
+		if (isdigit(c))
+			nibble =3D c - '0';
+		else if (isxdigit(c) && (islower(c) || !strict))
+			nibble =3D tolower(c) - 'a' + 10;
+		else
+			goto fail;
+		*wwn =3D (*wwn << 4) | nibble;
+	}
+	err =3D 4;
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
+	for (i =3D 0, j =3D 0; i < 16; i++) {
+		value =3D hex_to_bin(*ns++);
+		if (value >=3D 0)
+			j =3D (j << 4) | value;
+		else
+			return -EINVAL;
+
+		if (i % 2) {
+			wwn[i/2] =3D j & 0xff;
+			j =3D 0;
+		}
+	}
+
+	*nm =3D wwn_to_u64(wwn);
+	return 0;
+}
+
+/*
+ * This parsing logic follows drivers/scsi/scsi_transport_fc.c:store_f=
c_host_vport_create()
+ */
+int tcm_qla2xxx_npiv_parse_wwn(
+	const char *name,
+	size_t count,
+	u64 *wwpn,
+	u64 *wwnn)
+{
+	unsigned int cnt =3D count;
+	int rc;
+
+	*wwpn =3D 0;
+	*wwnn =3D 0;
+
+	/* count may include a LF at end of string */
+	if (name[cnt-1] =3D=3D '\n')
+		cnt--;
+
+	/* validate we have enough characters for WWPN */
+	if ((cnt !=3D (16+1+16)) || (name[16] !=3D ':'))
+		return -EINVAL;
+
+	rc =3D tcm_qla2xxx_npiv_extract_wwn(&name[0], wwpn);
+	if (rc !=3D 0)
+		return rc;
+
+	rc =3D tcm_qla2xxx_npiv_extract_wwn(&name[17], wwnn);
+	if (rc !=3D 0)
+		return rc;
+
+	return 0;
+}
+
+ssize_t tcm_qla2xxx_npiv_format_wwn(char *buf, size_t len, u64 wwpn, u=
64 wwnn)
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
+	struct tcm_qla2xxx_tpg *tpg =3D container_of(se_tpg,
+				struct tcm_qla2xxx_tpg, se_tpg);
+	struct tcm_qla2xxx_lport *lport =3D tpg->lport;
+	u8 proto_id;
+
+	switch (lport->lport_proto_id) {
+	case SCSI_PROTOCOL_FCP:
+	default:
+		proto_id =3D fc_get_fabric_proto_ident(se_tpg);
+		break;
+	}
+
+	return proto_id;
+}
+
+char *tcm_qla2xxx_get_fabric_wwn(struct se_portal_group *se_tpg)
+{
+	struct tcm_qla2xxx_tpg *tpg =3D container_of(se_tpg,
+				struct tcm_qla2xxx_tpg, se_tpg);
+	struct tcm_qla2xxx_lport *lport =3D tpg->lport;
+
+	return &lport->lport_name[0];
+}
+
+char *tcm_qla2xxx_npiv_get_fabric_wwn(struct se_portal_group *se_tpg)
+{
+	struct tcm_qla2xxx_tpg *tpg =3D container_of(se_tpg,
+				struct tcm_qla2xxx_tpg, se_tpg);
+	struct tcm_qla2xxx_lport *lport =3D tpg->lport;
+
+	return &lport->lport_npiv_name[0];
+}
+
+u16 tcm_qla2xxx_get_tag(struct se_portal_group *se_tpg)
+{
+	struct tcm_qla2xxx_tpg *tpg =3D container_of(se_tpg,
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
+	struct tcm_qla2xxx_tpg *tpg =3D container_of(se_tpg,
+				struct tcm_qla2xxx_tpg, se_tpg);
+	struct tcm_qla2xxx_lport *lport =3D tpg->lport;
+	int ret =3D 0;
+
+	switch (lport->lport_proto_id) {
+	case SCSI_PROTOCOL_FCP:
+	default:
+		ret =3D fc_get_pr_transport_id(se_tpg, se_nacl, pr_reg,
+					format_code, buf);
+		break;
+	}
+
+	return ret;
+}	=09
+
+u32 tcm_qla2xxx_get_pr_transport_id_len(
+	struct se_portal_group *se_tpg,
+	struct se_node_acl *se_nacl,
+	struct t10_pr_registration *pr_reg,
+	int *format_code)
+{
+	struct tcm_qla2xxx_tpg *tpg =3D container_of(se_tpg,
+				struct tcm_qla2xxx_tpg, se_tpg);
+	struct tcm_qla2xxx_lport *lport =3D tpg->lport;
+	int ret =3D 0;
+
+	switch (lport->lport_proto_id) {
+	case SCSI_PROTOCOL_FCP:
+	default:
+		ret =3D fc_get_pr_transport_id_len(se_tpg, se_nacl, pr_reg,
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
+	struct tcm_qla2xxx_tpg *tpg =3D container_of(se_tpg,
+				struct tcm_qla2xxx_tpg, se_tpg);
+	struct tcm_qla2xxx_lport *lport =3D tpg->lport;
+	char *tid =3D NULL;
+
+	switch (lport->lport_proto_id) {
+	case SCSI_PROTOCOL_FCP:
+	default:
+		tid =3D fc_parse_pr_out_transport_id(se_tpg, buf, out_tid_len,
+					port_nexus_ptr);
+		break;
+	}
+
+	return tid;
+}
+
+int tcm_qla2xxx_check_demo_mode(struct se_portal_group *se_tpg)
+{
+	struct tcm_qla2xxx_tpg *tpg =3D container_of(se_tpg,
+				struct tcm_qla2xxx_tpg, se_tpg);
+
+	return QLA_TPG_ATTRIB(tpg)->generate_node_acls;
+}
+
+int tcm_qla2xxx_check_demo_mode_cache(struct se_portal_group *se_tpg)
+{
+	struct tcm_qla2xxx_tpg *tpg =3D container_of(se_tpg,
+				struct tcm_qla2xxx_tpg, se_tpg);
+
+	return QLA_TPG_ATTRIB(tpg)->cache_dynamic_acls;
+}
+
+int tcm_qla2xxx_check_demo_write_protect(struct se_portal_group *se_tp=
g)
+{
+	struct tcm_qla2xxx_tpg *tpg =3D container_of(se_tpg,
+				struct tcm_qla2xxx_tpg, se_tpg);
+
+	return QLA_TPG_ATTRIB(tpg)->demo_mode_write_protect;
+}
+
+int tcm_qla2xxx_check_prod_write_protect(struct se_portal_group *se_tp=
g)
+{
+	struct tcm_qla2xxx_tpg *tpg =3D container_of(se_tpg,
+				struct tcm_qla2xxx_tpg, se_tpg);
+
+	return QLA_TPG_ATTRIB(tpg)->prod_mode_write_protect;
+}
+
+struct se_node_acl *tcm_qla2xxx_alloc_fabric_acl(struct se_portal_grou=
p *se_tpg)
+{
+	struct tcm_qla2xxx_nacl *nacl;
+
+	nacl =3D kzalloc(sizeof(struct tcm_qla2xxx_nacl), GFP_KERNEL);
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
+	struct tcm_qla2xxx_nacl *nacl =3D container_of(se_nacl,
+			struct tcm_qla2xxx_nacl, se_node_acl);
+	kfree(nacl);
+}
+
+u32 tcm_qla2xxx_tpg_get_inst_index(struct se_portal_group *se_tpg)
+{
+	struct tcm_qla2xxx_tpg *tpg =3D container_of(se_tpg,
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
+void tcm_qla2xxx_free_cmd(struct qla_tgt_cmd *cmd)
+{
+	atomic_set(&cmd->cmd_done, 1);
+	/*
+	 * If tcm_qla2xxx_check_stop_free() has already been called, we
+	 * are safe to go ahead and call transport_generic_free_cmd()
+	 * to release the descriptor.
+	 */
+	if (atomic_read(&cmd->cmd_stop_free) !=3D 0)
+		transport_generic_free_cmd(&cmd->se_cmd, 1, 1, 0);
+}
+
+/*
+ * Called from struct target_core_fabric_ops->check_stop_free() contex=
t
+ */
+void tcm_qla2xxx_check_stop_free(struct se_cmd *se_cmd)
+{
+	struct qla_tgt_cmd *cmd;
+	struct qla_tgt_mgmt_cmd *mcmd;
+
+	if (se_cmd->se_tmr_req) {
+		mcmd =3D container_of(se_cmd, struct qla_tgt_mgmt_cmd, se_cmd);
+		/*
+		 * Release the associated se_cmd->se_tmr_req and se_cmd
+		 * TMR related state now.
+		 */
+		transport_generic_free_cmd(se_cmd, 1, 1, 0);
+		qla_tgt_free_mcmd(mcmd);
+		return;
+	}
+
+	cmd =3D container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
+	/*
+	 * If tcm_qla2xxx_free_cmd() has already been called from the LLD,
+	 * it's safe to call transport_generic_free_cmd() to release the
+	 * descriptor.  Otherwise set cmd->cmd_stop_free=3D1 and let
+	 * tcm_qla2xxx_free_cmd() call transport_generic_free_cmd().
+	 */
+	if (atomic_read(&cmd->cmd_done) !=3D 0)
+		transport_generic_free_cmd(se_cmd, 0, 1, 0);
+	else
+		atomic_set(&cmd->cmd_stop_free, 1);
+}
+
+/*
+ * Callback from TCM Core to release underlying fabric descriptor
+ */
+void tcm_qla2xxx_release_cmd(struct se_cmd *se_cmd)
+{
+	struct qla_tgt_cmd *cmd =3D container_of(se_cmd, struct qla_tgt_cmd, =
se_cmd);
+
+	if (se_cmd->se_tmr_req !=3D NULL)
+		return;
+
+	qla_tgt_free_cmd(cmd);
+}
+
+int tcm_qla2xxx_shutdown_session(struct se_session *se_sess)
+{
+	struct qla_tgt_sess *sess =3D se_sess->fabric_sess_ptr;
+
+	if (!sess) {
+		printk("se_sess->fabric_sess_ptr is NULL\n");
+		dump_stack();
+		return 0;
+	}
+	return 1;
+}
+
+extern int tcm_qla2xxx_clear_nacl_from_fcport_map(struct se_node_acl *=
);
+
+void tcm_qla2xxx_close_session(struct se_session *se_sess)
+{
+	struct se_node_acl *se_nacl =3D se_sess->se_node_acl;
+	struct qla_tgt_sess *sess =3D se_sess->fabric_sess_ptr;
+	struct scsi_qla_host *vha;
+	unsigned long flags;
+
+	if (!sess) {
+		printk(KERN_ERR "se_sess->fabric_sess_ptr is NULL\n");
+		dump_stack();
+		return;
+	}
+	vha =3D sess->vha;
+
+	spin_lock_irqsave(&vha->hw->hardware_lock, flags);
+	tcm_qla2xxx_clear_nacl_from_fcport_map(se_nacl);
+	qla_tgt_sess_put(sess);
+	spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
+}
+
+void tcm_qla2xxx_stop_session(struct se_session *se_sess, int sess_sle=
ep , int conn_sleep)
+{
+	struct qla_tgt_sess *sess =3D se_sess->fabric_sess_ptr;
+	struct scsi_qla_host *vha;
+	unsigned long flags;
+
+	if (!sess) {
+		printk(KERN_ERR "se_sess->fabric_sess_ptr is NULL\n");
+		dump_stack();
+		return;
+	}
+	vha =3D sess->vha;
+
+	spin_lock_irqsave(&vha->hw->hardware_lock, flags);
+	tcm_qla2xxx_clear_nacl_from_fcport_map(se_sess->se_node_acl);
+	spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
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
+int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
+{
+	struct qla_tgt_cmd *cmd =3D container_of(se_cmd, struct qla_tgt_cmd, =
se_cmd);
+
+	cmd->bufflen =3D se_cmd->data_length;
+	cmd->dma_data_direction =3D se_cmd->data_direction;
+	/*
+	 * Setup the struct se_task->task_sg[] chained SG list
+	 */
+	if ((se_cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) ||
+	    (se_cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB)) {
+		transport_do_task_sg_chain(se_cmd);
+
+		cmd->sg_cnt =3D T_TASK(se_cmd)->t_tasks_sg_chained_no;
+		cmd->sg =3D T_TASK(se_cmd)->t_tasks_sg_chained;
+	} else if (se_cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB) {
+		/*
+		 * Use T_TASK(se_cmd)->t_tasks_sg_bounce for control CDBs
+		 * using a contigious buffer
+		 */
+		sg_init_table(&T_TASK(se_cmd)->t_tasks_sg_bounce, 1);
+		sg_set_buf(&T_TASK(se_cmd)->t_tasks_sg_bounce,
+			T_TASK(se_cmd)->t_task_buf, se_cmd->data_length);
+		cmd->sg_cnt =3D 1;
+		cmd->sg =3D &T_TASK(se_cmd)->t_tasks_sg_bounce;
+	} else {
+		printk(KERN_ERR "Unknown se_cmd_flags: 0x%08x in"
+			" tcm_qla2xxx_write_pending()\n", se_cmd->se_cmd_flags);
+		BUG();
+	}
+	/*
+	 * qla_target.c:qla_tgt_rdy_to_xfer() will call pci_map_sg() to setup
+	 * the SGL mappings into PCIe memory for incoming FCP WRITE data.
+	 */
+	return qla_tgt_rdy_to_xfer(cmd);
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
+	struct qla_tgt_cmd *cmd =3D container_of(se_cmd, struct qla_tgt_cmd, =
se_cmd);
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
+ * Main entry point for incoming ATIO packets from qla_target.c
+ * and qla2xxx LLD code.
+ */
+int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *c=
md,
+			uint32_t lun, uint32_t data_length,
+			int fcp_task_attr, int data_dir, int bidi)
+{
+	struct se_cmd *se_cmd =3D &cmd->se_cmd;
+	struct se_session *se_sess;
+	struct se_portal_group *se_tpg;
+	struct qla_tgt_sess *sess;
+
+	sess =3D cmd->sess;
+	if (!sess) {
+		printk(KERN_ERR "Unable to locate struct qla_tgt_sess from qla_tgt_c=
md\n");
+		return -EINVAL;
+	}
+
+	se_sess =3D sess->se_sess;
+	if (!se_sess) {
+		printk(KERN_ERR "Unable to locate active struct se_session\n");
+		return -EINVAL;
+	}
+	se_tpg =3D se_sess->se_tpg;
+
+	/*
+	 * Initialize struct se_cmd descriptor from target_core_mod infrastru=
cture
+	 */
+	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
+			data_length, data_dir,
+			fcp_task_attr, &cmd->sense_buffer[0]);
+	/*
+	 * Signal BIDI usage with T_TASK(cmd)->t_tasks_bidi
+	 */
+	if (bidi)
+		T_TASK(se_cmd)->t_tasks_bidi =3D 1;
+	/*
+	 * Locate the struct se_lun pointer and attach it to struct se_cmd
+	 */
+	if (transport_get_lun_for_cmd(se_cmd, NULL, lun) < 0) {
+		/*
+		 * Clear qla_tgt_cmd->locked_rsp as ha->hardware_lock
+		 * is already held here..
+		 */
+		if (spin_is_locked(&cmd->vha->hw->hardware_lock))
+			cmd->locked_rsp =3D 0;
+
+		/* NON_EXISTENT_LUN */
+		transport_send_check_condition_and_sense(se_cmd,
+				se_cmd->scsi_sense_reason, 0);
+		return 0;
+	}
+	/*
+	 * Queue up the newly allocated to be processed in TCM thread context=
=2E
+	 */
+	transport_device_setup_cmd(se_cmd);
+	/*
+	 * Queue up the newly allocated to be processed in TCM thread context=
=2E
+	 */
+	transport_generic_handle_cdb_map(se_cmd);
+	return 0;
+}
+
+int tcm_qla2xxx_new_cmd_map(struct se_cmd *se_cmd)
+{
+	struct qla_tgt_cmd *cmd =3D container_of(se_cmd, struct qla_tgt_cmd, =
se_cmd);
+	scsi_qla_host_t *vha =3D cmd->vha;
+	struct qla_hw_data *ha =3D vha->hw;
+	unsigned char *cdb;
+	int ret;
+
+	if (IS_FWI2_CAPABLE(ha)) {
+		atio7_entry_t *atio =3D &cmd->atio.atio7;
+		cdb =3D &atio->fcp_cmnd.cdb[0];
+	} else {
+		atio_entry_t *atio =3D &cmd->atio.atio2x;
+		cdb =3D &atio->cdb[0];
+	}
+
+	/*
+	 * Allocate the necessary tasks to complete the received CDB+data
+	 */
+	ret =3D transport_generic_allocate_tasks(se_cmd, cdb);
+	if (ret =3D=3D -1) {
+		/* Out of Resources */
+		transport_send_check_condition_and_sense(se_cmd,
+				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
+		return 0;
+	} else if (ret =3D=3D -2) {
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
+	 * drivers/target/target_core_transport.c:transport_processing_thread=
()
+	 * falls through to TRANSPORT_NEW_CMD.
+	 */
+	return 0;
+}
+
+/*
+ * Called from qla_target.c:qla_tgt_do_ctio_completion()
+ */
+int tcm_qla2xxx_handle_data(struct qla_tgt_cmd *cmd)
+{
+	/*
+	 * We now tell TCM to queue this WRITE CDB with TRANSPORT_PROCESS_WRI=
TE
+	 * status to the backstore processing thread.
+	 */
+	return transport_generic_handle_data(&cmd->se_cmd);
+}
+
+/*
+ * Called from qla_target.c:qla_tgt_issue_task_mgmt()
+ */
+int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, uint32_t lun=
, uint8_t tmr_func)
+{
+	struct qla_tgt_sess *sess =3D mcmd->sess;
+	struct se_session *se_sess =3D sess->se_sess;
+	struct se_portal_group *se_tpg =3D se_sess->se_tpg;
+	struct se_cmd *se_cmd =3D &mcmd->se_cmd;
+	/*
+	 * Initialize struct se_cmd descriptor from target_core_mod infrastru=
cture
+	 */
+	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess, 0,
+				DMA_NONE, 0, NULL);
+	/*
+	 * Allocate the TCM TMR
+	 */
+	se_cmd->se_tmr_req =3D core_tmr_alloc_req(se_cmd, (void *)mcmd, tmr_f=
unc);
+	if (!se_cmd->se_tmr_req)
+		return -ENOMEM;
+	/*
+	 * Save the se_tmr_req for qla_tgt_xmit_tm_rsp() callback into LLD co=
de
+	 */
+	mcmd->se_tmr_req =3D se_cmd->se_tmr_req;
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
+int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
+{
+	struct qla_tgt_cmd *cmd =3D container_of(se_cmd, struct qla_tgt_cmd, =
se_cmd);
+
+	cmd->bufflen =3D se_cmd->data_length;
+	cmd->dma_data_direction =3D se_cmd->data_direction;
+	cmd->aborted =3D atomic_read(&T_TASK(se_cmd)->t_transport_aborted);
+	/*
+	 * Setup the struct se_task->task_sg[] chained SG list
+	 */
+	if ((se_cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) ||
+	    (se_cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB)) {
+		transport_do_task_sg_chain(se_cmd);
+
+		cmd->sg_cnt =3D T_TASK(se_cmd)->t_tasks_sg_chained_no;
+		cmd->sg =3D T_TASK(se_cmd)->t_tasks_sg_chained;
+	} else if (se_cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB) {
+		/*
+		 * Use T_TASK(se_cmd)->t_tasks_sg_bounce for control CDBs
+		 * using a contigious buffer
+		 */
+		sg_init_table(&T_TASK(se_cmd)->t_tasks_sg_bounce, 1);
+		sg_set_buf(&T_TASK(se_cmd)->t_tasks_sg_bounce,
+			T_TASK(se_cmd)->t_task_buf, se_cmd->data_length);
+
+		cmd->sg_cnt =3D 1;
+		cmd->sg =3D &T_TASK(se_cmd)->t_tasks_sg_bounce;
+	} else {
+		cmd->sg_cnt =3D 0;
+		cmd->sg =3D NULL;
+	}
+
+	cmd->offset =3D 0;
+
+	/*
+	 * Now queue completed DATA_IN the qla2xxx LLD and response ring
+	 */
+	return qla2xxx_xmit_response(cmd, QLA_TGT_XMIT_DATA|QLA_TGT_XMIT_STAT=
US,
+				se_cmd->scsi_status);
+}
+
+int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
+{
+	struct qla_tgt_cmd *cmd =3D container_of(se_cmd, struct qla_tgt_cmd, =
se_cmd);
+
+	cmd->bufflen =3D se_cmd->data_length;
+	cmd->sg =3D NULL;
+	cmd->sg_cnt =3D 0;
+	cmd->offset =3D 0;
+	cmd->dma_data_direction =3D se_cmd->data_direction;
+	cmd->aborted =3D atomic_read(&T_TASK(se_cmd)->t_transport_aborted);
+
+	/*
+	 * Now queue status response to qla2xxx LLD code and response ring
+	 */
+	return qla2xxx_xmit_response(cmd, QLA_TGT_XMIT_STATUS, se_cmd->scsi_s=
tatus);
+}
+
+int tcm_qla2xxx_queue_tm_rsp(struct se_cmd *se_cmd)
+{
+	struct se_tmr_req *se_tmr =3D se_cmd->se_tmr_req;
+	struct qla_tgt_mgmt_cmd *mcmd =3D container_of(se_cmd,
+				struct qla_tgt_mgmt_cmd, se_cmd);
+
+	printk("queue_tm_rsp: mcmd: %p func: 0x%02x response: 0x%02x\n",
+			mcmd, se_tmr->function, se_tmr->response);
+	/*
+	 * Do translation between TCM TM response codes and
+	 * QLA2xxx FC TM response codes.
+	 */
+	switch (se_tmr->response) {
+	case TMR_FUNCTION_COMPLETE:
+		mcmd->fc_tm_rsp =3D FC_TM_SUCCESS;
+		break;
+	case TMR_TASK_DOES_NOT_EXIST:
+		mcmd->fc_tm_rsp =3D FC_TM_BAD_CMD;
+		break;
+	case TMR_FUNCTION_REJECTED:
+		mcmd->fc_tm_rsp =3D FC_TM_REJECT;
+		break;
+	case TMR_LUN_DOES_NOT_EXIST:
+	default:
+		mcmd->fc_tm_rsp =3D FC_TM_FAILED;
+		break;
+	}
+	/*
+	 * Queue the TM response to QLA2xxx LLD to build a
+	 * CTIO response packet.
+	 */
+	qla_tgt_xmit_tm_rsp(mcmd);
+
+	return 0;
+}
+
+u16 tcm_qla2xxx_get_fabric_sense_len(void)
+{
+	return 0;
+}
+
+u16 tcm_qla2xxx_set_fabric_sense_len(struct se_cmd *se_cmd, u32 sense_=
length)
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
+	WARN_ON(lun >=3D 256);
+	/* Caller wants this byte-swapped */
+	return cpu_to_le64((lun & 0xff) << 8);
+}
diff --git a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.h b/drivers/=
target/tcm_qla2xxx/tcm_qla2xxx_fabric.h
new file mode 100644
index 0000000..6de2277
--- /dev/null
+++ b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.h
@@ -0,0 +1,53 @@
+extern int tcm_qla2xxx_check_true(struct se_portal_group *);
+extern int tcm_qla2xxx_check_false(struct se_portal_group *);
+extern ssize_t tcm_qla2xxx_parse_wwn(const char *, u64 *, int);
+extern ssize_t tcm_qla2xxx_format_wwn(char *, size_t, u64);
+extern char *tcm_qla2xxx_get_fabric_name(void);
+extern int tcm_qla2xxx_npiv_parse_wwn(const char *name, size_t, u64 *,=
 u64 *);
+extern ssize_t tcm_qla2xxx_npiv_format_wwn(char *, size_t, u64, u64);
+extern char *tcm_qla2xxx_npiv_get_fabric_name(void);
+extern u8 tcm_qla2xxx_get_fabric_proto_ident(struct se_portal_group *)=
;
+extern char *tcm_qla2xxx_get_fabric_wwn(struct se_portal_group *);
+extern char *tcm_qla2xxx_npiv_get_fabric_wwn(struct se_portal_group *)=
;
+extern u16 tcm_qla2xxx_get_tag(struct se_portal_group *);
+extern u32 tcm_qla2xxx_get_default_depth(struct se_portal_group *);
+extern u32 tcm_qla2xxx_get_pr_transport_id(struct se_portal_group *, s=
truct se_node_acl *,
+			struct t10_pr_registration *, int *, unsigned char *);
+extern u32 tcm_qla2xxx_get_pr_transport_id_len(struct se_portal_group =
*, struct se_node_acl *,
+			struct t10_pr_registration *, int *);
+extern char *tcm_qla2xxx_parse_pr_out_transport_id(struct se_portal_gr=
oup *, const char *,
+				u32 *, char **);
+extern int tcm_qla2xxx_check_demo_mode(struct se_portal_group *);
+extern int tcm_qla2xxx_check_demo_mode_cache(struct se_portal_group *)=
;
+extern int tcm_qla2xxx_check_demo_write_protect(struct se_portal_group=
 *);
+extern int tcm_qla2xxx_check_prod_write_protect(struct se_portal_group=
 *);
+extern struct se_node_acl *tcm_qla2xxx_alloc_fabric_acl(struct se_port=
al_group *);
+extern void tcm_qla2xxx_release_fabric_acl(struct se_portal_group *, s=
truct se_node_acl *);
+extern u32 tcm_qla2xxx_tpg_get_inst_index(struct se_portal_group *);
+extern void tcm_qla2xxx_free_cmd(struct qla_tgt_cmd *);
+extern void tcm_qla2xxx_check_stop_free(struct se_cmd *);
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
+extern int tcm_qla2xxx_handle_cmd(struct scsi_qla_host *, struct qla_t=
gt_cmd *,
+                        uint32_t, uint32_t, int, int, int);
+extern int tcm_qla2xxx_new_cmd_map(struct se_cmd *);
+extern int tcm_qla2xxx_handle_data(struct qla_tgt_cmd *);
+extern int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *, uint32_t,=
 uint8_t);
+extern int tcm_qla2xxx_queue_data_in(struct se_cmd *);
+extern int tcm_qla2xxx_queue_status(struct se_cmd *);
+extern int tcm_qla2xxx_queue_tm_rsp(struct se_cmd *);
+extern u16 tcm_qla2xxx_get_fabric_sense_len(void);
+extern u16 tcm_qla2xxx_set_fabric_sense_len(struct se_cmd *, u32);
+extern int tcm_qla2xxx_is_state_remove(struct se_cmd *);
+extern u64 tcm_qla2xxx_pack_lun(unsigned int);
--=20
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
