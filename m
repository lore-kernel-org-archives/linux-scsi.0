From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v2 05/12] iscsi-target: Add TPG and Device logic
Date: Mon, 14 Mar 2011 04:57:02 -0700
Message-ID: <1300103829-10337-6-git-send-email-nab@linux-iscsi.org>
References: <1300103829-10337-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1300103829-10337-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

=46rom: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds TPG and device logiced using for mapping iscsi-target
abstractions on top of TCM v4 struct se_portal_group and struct se_devi=
ce
abstractions.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_device.c |  128 +++
 drivers/target/iscsi/iscsi_target_device.h |    9 +
 drivers/target/iscsi/iscsi_target_tpg.c    | 1165 ++++++++++++++++++++=
++++++++
 drivers/target/iscsi/iscsi_target_tpg.h    |   70 ++
 4 files changed, 1372 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/iscsi/iscsi_target_device.c
 create mode 100644 drivers/target/iscsi/iscsi_target_device.h
 create mode 100644 drivers/target/iscsi/iscsi_target_tpg.c
 create mode 100644 drivers/target/iscsi/iscsi_target_tpg.h

diff --git a/drivers/target/iscsi/iscsi_target_device.c b/drivers/targe=
t/iscsi/iscsi_target_device.c
new file mode 100644
index 0000000..07020fe
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_device.c
@@ -0,0 +1,128 @@
+/*********************************************************************=
**********
+ * This file contains the iSCSI Virtual Device and Disk Transport
+ * agnostic related functions.
+ *
+ * Copyright (c) 2003, 2004, 2005 PyX Technologies, Inc.
+ * Copyright (c) 2005-2006 SBE, Inc.  All Rights Reserved.
+ =C2=A9 Copyright 2007-2011 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (=
GPL) version 2.
+ *
+ * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
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
*********/
+
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <target/target_core_base.h>
+#include <target/target_core_device.h>
+#include <target/target_core_transport.h>
+
+#include "iscsi_debug.h"
+#include "iscsi_target_core.h"
+#include "iscsi_target_device.h"
+#include "iscsi_target_tpg.h"
+#include "iscsi_target_util.h"
+
+/*	iscsi_get_lun():
+ *
+ *
+ */
+int iscsi_get_lun_for_tmr(
+	struct iscsi_cmd *cmd,
+	u64 lun)
+{
+	struct iscsi_conn *conn =3D CONN(cmd);
+	struct iscsi_portal_group *tpg =3D ISCSI_TPG_C(conn);
+	u32 unpacked_lun;
+
+	unpacked_lun =3D iscsi_unpack_lun((unsigned char *)&lun);
+	if (unpacked_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
+		printk(KERN_ERR "iSCSI LUN: %u exceeds TRANSPORT_MAX_LUNS_PER_TPG"
+			"-1: %u for Target Portal Group: %hu\n", unpacked_lun,
+			TRANSPORT_MAX_LUNS_PER_TPG-1, tpg->tpgt);
+		return -1;
+	}
+
+	return transport_get_lun_for_tmr(SE_CMD(cmd), unpacked_lun);
+}
+
+/*	iscsi_get_lun_for_cmd():
+ *
+ *	Returns (0) on success
+ * 	Returns (< 0) on failure
+ */
+int iscsi_get_lun_for_cmd(
+	struct iscsi_cmd *cmd,
+	unsigned char *cdb,
+	u64 lun)
+{
+	struct iscsi_conn *conn =3D CONN(cmd);
+	struct iscsi_portal_group *tpg =3D ISCSI_TPG_C(conn);
+	u32 unpacked_lun;
+
+	unpacked_lun =3D iscsi_unpack_lun((unsigned char *)&lun);
+	if (unpacked_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
+		printk(KERN_ERR "iSCSI LUN: %u exceeds TRANSPORT_MAX_LUNS_PER_TPG"
+			"-1: %u for Target Portal Group: %hu\n", unpacked_lun,
+			TRANSPORT_MAX_LUNS_PER_TPG-1, tpg->tpgt);
+		return -1;
+	}
+
+	return transport_get_lun_for_cmd(SE_CMD(cmd), cdb, unpacked_lun);
+}
+
+/*	iscsi_determine_maxcmdsn():
+ *
+ *
+ */
+void iscsi_determine_maxcmdsn(struct iscsi_session *sess)
+{
+	struct se_node_acl *se_nacl;
+
+	/*
+	 * This is a discovery session, the single queue slot was already
+	 * assigned in iscsi_login_zero_tsih().  Since only Logout and
+	 * Text Opcodes are allowed during discovery we do not have to worry
+	 * about the HBA's queue depth here.
+	 */
+	if (SESS_OPS(sess)->SessionType)
+		return;
+
+	se_nacl =3D sess->se_sess->se_node_acl;
+
+	/*
+	 * This is a normal session, set the Session's CmdSN window to the
+	 * struct se_node_acl->queue_depth.  The value in struct se_node_acl-=
>queue_depth
+	 * has already been validated as a legal value in
+	 * core_set_queue_depth_for_node().
+	 */
+	sess->cmdsn_window =3D se_nacl->queue_depth;
+	sess->max_cmd_sn =3D (sess->max_cmd_sn + se_nacl->queue_depth) - 1;
+}
+
+/*	iscsi_increment_maxcmdsn();
+ *
+ *
+ */
+void iscsi_increment_maxcmdsn(struct iscsi_cmd *cmd, struct iscsi_sess=
ion *sess)
+{
+	if (cmd->immediate_cmd || cmd->maxcmdsn_inc)
+		return;
+
+	cmd->maxcmdsn_inc =3D 1;
+
+	spin_lock(&sess->cmdsn_lock);
+	sess->max_cmd_sn +=3D 1;
+	TRACE(TRACE_ISCSI, "Updated MaxCmdSN to 0x%08x\n", sess->max_cmd_sn);
+	spin_unlock(&sess->cmdsn_lock);
+}
diff --git a/drivers/target/iscsi/iscsi_target_device.h b/drivers/targe=
t/iscsi/iscsi_target_device.h
new file mode 100644
index 0000000..f69cf52
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_device.h
@@ -0,0 +1,9 @@
+#ifndef ISCSI_TARGET_DEVICE_H
+#define ISCSI_TARGET_DEVICE_H
+
+extern int iscsi_get_lun_for_tmr(struct iscsi_cmd *, u64);
+extern int iscsi_get_lun_for_cmd(struct iscsi_cmd *, unsigned char *, =
u64);
+extern void iscsi_determine_maxcmdsn(struct iscsi_session *);
+extern void iscsi_increment_maxcmdsn(struct iscsi_cmd *, struct iscsi_=
session *);
+
+#endif /* ISCSI_TARGET_DEVICE_H */
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/i=
scsi/iscsi_target_tpg.c
new file mode 100644
index 0000000..0cba462
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -0,0 +1,1165 @@
+/*********************************************************************=
**********
+ * This file contains iSCSI Target Portal Group related functions.
+ *
+ * Copyright (c) 2002, 2003, 2004, 2005 PyX Technologies, Inc.
+ * Copyright (c) 2005, 2006, 2007 SBE, Inc.
+ * =C2=A9 Copyright 2007-2011 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (=
GPL) version 2.
+ *
+ * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
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
*********/
+
+#include <linux/timer.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/ctype.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <target/target_core_base.h>
+#include <target/target_core_transport.h>
+#include <target/target_core_fabric_ops.h>
+#include <target/target_core_configfs.h>
+#include <target/target_core_tpg.h>
+
+#include "iscsi_debug.h"
+#include "iscsi_target_core.h"
+#include "iscsi_target_erl0.h"
+#include "iscsi_target_login.h"
+#include "iscsi_target_nodeattrib.h"
+#include "iscsi_target_tpg.h"
+#include "iscsi_target_util.h"
+#include "iscsi_target.h"
+#include "iscsi_parameters.h"
+
+char *lio_tpg_get_endpoint_wwn(struct se_portal_group *se_tpg)
+{
+	struct iscsi_portal_group *tpg =3D
+			(struct iscsi_portal_group *)se_tpg->se_tpg_fabric_ptr;
+
+	return &tpg->tpg_tiqn->tiqn[0];
+}
+
+u16 lio_tpg_get_tag(struct se_portal_group *se_tpg)
+{
+	struct iscsi_portal_group *tpg =3D
+			(struct iscsi_portal_group *)se_tpg->se_tpg_fabric_ptr;
+
+	return tpg->tpgt;
+}
+
+u32 lio_tpg_get_default_depth(struct se_portal_group *se_tpg)
+{
+	struct iscsi_portal_group *tpg =3D
+			(struct iscsi_portal_group *)se_tpg->se_tpg_fabric_ptr;
+
+	return ISCSI_TPG_ATTRIB(tpg)->default_cmdsn_depth;
+}
+
+int lio_tpg_check_demo_mode(struct se_portal_group *se_tpg)
+{
+	struct iscsi_portal_group *tpg =3D
+			 (struct iscsi_portal_group *)se_tpg->se_tpg_fabric_ptr;
+
+	return ISCSI_TPG_ATTRIB(tpg)->generate_node_acls;
+}
+
+int lio_tpg_check_demo_mode_cache(struct se_portal_group *se_tpg)
+{
+	struct iscsi_portal_group *tpg =3D
+			(struct iscsi_portal_group *)se_tpg->se_tpg_fabric_ptr;
+
+	return ISCSI_TPG_ATTRIB(tpg)->cache_dynamic_acls;
+}
+
+int lio_tpg_check_demo_mode_write_protect(struct se_portal_group *se_t=
pg)
+{
+	struct iscsi_portal_group *tpg =3D
+			(struct iscsi_portal_group *)se_tpg->se_tpg_fabric_ptr;
+
+	return ISCSI_TPG_ATTRIB(tpg)->demo_mode_write_protect;
+}
+
+int lio_tpg_check_prod_mode_write_protect(struct se_portal_group *se_t=
pg)
+{
+	struct iscsi_portal_group *tpg =3D
+			(struct iscsi_portal_group *)se_tpg->se_tpg_fabric_ptr;
+
+	return ISCSI_TPG_ATTRIB(tpg)->prod_mode_write_protect;
+}
+
+struct se_node_acl *lio_tpg_alloc_fabric_acl(
+	struct se_portal_group *se_tpg)
+{
+	struct iscsi_node_acl *acl;
+
+	acl =3D kzalloc(sizeof(struct iscsi_node_acl), GFP_KERNEL);
+	if (!(acl)) {
+		printk(KERN_ERR "Unable to allocate memory for struct iscsi_node_acl=
\n");
+		return NULL;
+	}
+
+	return &acl->se_node_acl;
+}
+
+void lio_tpg_release_fabric_acl(
+	struct se_portal_group *se_tpg,
+	struct se_node_acl *se_acl)
+{
+	struct iscsi_node_acl *acl =3D container_of(se_acl,
+			struct iscsi_node_acl, se_node_acl);
+	kfree(acl);
+}
+
+/*
+ * Called with spin_lock_bh(struct se_portal_group->session_lock) held=
=2E.
+ *
+ * Also, this function calls iscsi_inc_session_usage_count() on the
+ * struct iscsi_session in question.
+ */
+int lio_tpg_shutdown_session(struct se_session *se_sess)
+{
+	struct iscsi_session *sess =3D (struct iscsi_session *)se_sess->fabri=
c_sess_ptr;
+
+	spin_lock(&sess->conn_lock);
+	if (atomic_read(&sess->session_fall_back_to_erl0) ||
+	    atomic_read(&sess->session_logout) ||
+	    (sess->time2retain_timer_flags & ISCSI_TF_EXPIRED)) {
+		spin_unlock(&sess->conn_lock);
+		return 0;
+	}
+	atomic_set(&sess->session_reinstatement, 1);
+	spin_unlock(&sess->conn_lock);
+
+	iscsi_inc_session_usage_count(sess);
+	iscsi_stop_time2retain_timer(sess);
+
+	return 1;
+}
+
+/*
+ * Calls iscsi_dec_session_usage_count() as inverse of
+ * lio_tpg_shutdown_session()
+ */
+void lio_tpg_close_session(struct se_session *se_sess)
+{
+	struct iscsi_session *sess =3D (struct iscsi_session *)se_sess->fabri=
c_sess_ptr;
+	/*
+	 * If the iSCSI Session for the iSCSI Initiator Node exists,
+	 * forcefully shutdown the iSCSI NEXUS.
+	 */
+	iscsi_stop_session(sess, 1, 1);
+	iscsi_dec_session_usage_count(sess);
+	iscsi_close_session(sess);
+}
+
+void lio_tpg_stop_session(struct se_session *se_sess, int sess_sleep, =
int conn_sleep)
+{
+	struct iscsi_session *sess =3D (struct iscsi_session *)se_sess->fabri=
c_sess_ptr;
+
+	iscsi_stop_session(sess, sess_sleep, conn_sleep);
+}
+
+void lio_tpg_fall_back_to_erl0(struct se_session *se_sess)
+{
+	struct iscsi_session *sess =3D (struct iscsi_session *)se_sess->fabri=
c_sess_ptr;
+
+	iscsi_fall_back_to_erl0(sess);
+}
+
+u32 lio_tpg_get_inst_index(struct se_portal_group *se_tpg)
+{
+	struct iscsi_portal_group *tpg =3D
+			(struct iscsi_portal_group *)se_tpg->se_tpg_fabric_ptr;
+
+	return tpg->tpg_tiqn->tiqn_index;
+}
+
+void lio_set_default_node_attributes(struct se_node_acl *se_acl)
+{
+	struct iscsi_node_acl *acl =3D container_of(se_acl, struct iscsi_node=
_acl,
+				se_node_acl);
+
+	ISCSI_NODE_ATTRIB(acl)->nacl =3D acl;
+	iscsi_set_default_node_attribues(acl);
+}
+
+struct iscsi_portal_group *core_alloc_portal_group(struct iscsi_tiqn *=
tiqn, u16 tpgt)
+{
+	struct iscsi_portal_group *tpg;
+
+	tpg =3D kmem_cache_zalloc(lio_tpg_cache, GFP_KERNEL);
+	if (!(tpg)) {
+		printk(KERN_ERR "Unable to get tpg from lio_tpg_cache\n");
+		return NULL;
+	}
+
+	tpg->tpgt =3D tpgt;
+	tpg->tpg_state =3D TPG_STATE_FREE;
+	tpg->tpg_tiqn =3D tiqn;
+	INIT_LIST_HEAD(&tpg->tpg_gnp_list);
+	INIT_LIST_HEAD(&tpg->g_tpg_list);
+	INIT_LIST_HEAD(&tpg->tpg_list);
+	sema_init(&tpg->tpg_access_sem, 1);
+	sema_init(&tpg->np_login_sem, 1);
+	spin_lock_init(&tpg->tpg_state_lock);
+	spin_lock_init(&tpg->tpg_np_lock);
+
+	return tpg;
+}
+
+static void iscsi_set_default_tpg_attribs(struct iscsi_portal_group *)=
;
+
+int core_load_discovery_tpg(void)
+{
+	struct iscsi_param *param;
+	struct iscsi_portal_group *tpg;
+	int ret;
+
+	tpg =3D core_alloc_portal_group(NULL, 1);
+	if (!(tpg)) {
+		printk(KERN_ERR "Unable to allocate struct iscsi_portal_group\n");
+		return -1;
+	}
+
+	ret =3D core_tpg_register(
+			&lio_target_fabric_configfs->tf_ops,
+			NULL, &tpg->tpg_se_tpg, (void *)tpg,
+			TRANSPORT_TPG_TYPE_DISCOVERY);
+	if (ret < 0) {
+		kfree(tpg);
+		return -1;
+	}
+
+	tpg->sid =3D 1; /* First Assigned LIO Session ID */
+	iscsi_set_default_tpg_attribs(tpg);
+
+	if (iscsi_create_default_params(&tpg->param_list) < 0)
+		goto out;
+	/*
+	 * By default we disable authentication for discovery sessions,
+	 * this can be changed with:
+	 *
+	 * /sys/kernel/config/target/iscsi/discovery_auth/enforce_discovery_a=
uth
+	 */
+	param =3D iscsi_find_param_from_key(AUTHMETHOD, tpg->param_list);
+	if (!(param))
+		goto out;
+
+	if (iscsi_update_param_value(param, "CHAP,None") < 0)
+		goto out;
+
+	tpg->tpg_attrib.authentication =3D 0;
+
+	spin_lock(&tpg->tpg_state_lock);
+	tpg->tpg_state  =3D TPG_STATE_ACTIVE;
+	spin_unlock(&tpg->tpg_state_lock);
+
+	iscsi_global->discovery_tpg =3D tpg;
+	printk(KERN_INFO "CORE[0] - Allocated Discovery TPG\n");
+
+	return 0;
+out:
+	if (tpg->sid =3D=3D 1)
+		core_tpg_deregister(&tpg->tpg_se_tpg);
+	kfree(tpg);
+	return -1;
+}
+
+void core_release_discovery_tpg(void)
+{
+	struct iscsi_portal_group *tpg =3D iscsi_global->discovery_tpg;
+
+	if (!(tpg))
+		return;
+
+	core_tpg_deregister(&tpg->tpg_se_tpg);
+
+	kmem_cache_free(lio_tpg_cache, tpg);
+	iscsi_global->discovery_tpg =3D NULL;
+}
+
+struct iscsi_portal_group *core_get_tpg_from_np(
+	struct iscsi_tiqn *tiqn,
+	struct iscsi_np *np)
+{
+	struct iscsi_portal_group *tpg =3D NULL;
+	struct iscsi_tpg_np *tpg_np;
+
+	spin_lock(&tiqn->tiqn_tpg_lock);
+	list_for_each_entry(tpg, &tiqn->tiqn_tpg_list, tpg_list) {
+
+		spin_lock(&tpg->tpg_state_lock);
+		if (tpg->tpg_state =3D=3D TPG_STATE_FREE) {
+			spin_unlock(&tpg->tpg_state_lock);
+			continue;
+		}
+		spin_unlock(&tpg->tpg_state_lock);
+
+		spin_lock(&tpg->tpg_np_lock);
+		list_for_each_entry(tpg_np, &tpg->tpg_gnp_list, tpg_np_list) {
+			if (tpg_np->tpg_np =3D=3D np) {
+				spin_unlock(&tpg->tpg_np_lock);
+				spin_unlock(&tiqn->tiqn_tpg_lock);
+				return tpg;
+			}
+		}
+		spin_unlock(&tpg->tpg_np_lock);
+	}
+	spin_unlock(&tiqn->tiqn_tpg_lock);
+
+	return NULL;
+}
+
+int iscsi_get_tpg(
+	struct iscsi_portal_group *tpg)
+{
+	int ret;
+
+	ret =3D down_interruptible(&tpg->tpg_access_sem);
+	return ((ret !=3D 0) || signal_pending(current)) ? -1 : 0;
+}
+
+/*	iscsi_put_tpg():
+ *
+ *
+ */
+void iscsi_put_tpg(struct iscsi_portal_group *tpg)
+{
+	up(&tpg->tpg_access_sem);
+}
+
+static void iscsi_clear_tpg_np_login_thread(
+	struct iscsi_tpg_np *tpg_np,
+	struct iscsi_portal_group *tpg,
+	int shutdown)
+{
+	if (!tpg_np->tpg_np) {
+		printk(KERN_ERR "struct iscsi_tpg_np->tpg_np is NULL!\n");
+		return;
+	}
+
+	core_reset_np_thread(tpg_np->tpg_np, tpg_np, tpg, shutdown);
+	return;
+}
+
+/*	iscsi_clear_tpg_np_login_threads():
+ *
+ *
+ */
+void iscsi_clear_tpg_np_login_threads(
+	struct iscsi_portal_group *tpg,
+	int shutdown)
+{
+	struct iscsi_tpg_np *tpg_np;
+
+	spin_lock(&tpg->tpg_np_lock);
+	list_for_each_entry(tpg_np, &tpg->tpg_gnp_list, tpg_np_list) {
+		if (!tpg_np->tpg_np) {
+			printk(KERN_ERR "struct iscsi_tpg_np->tpg_np is NULL!\n");
+			continue;
+		}
+		spin_unlock(&tpg->tpg_np_lock);
+		iscsi_clear_tpg_np_login_thread(tpg_np, tpg, shutdown);
+		spin_lock(&tpg->tpg_np_lock);
+	}
+	spin_unlock(&tpg->tpg_np_lock);
+}
+
+/*	iscsi_tpg_dump_params():
+ *
+ *
+ */
+void iscsi_tpg_dump_params(struct iscsi_portal_group *tpg)
+{
+	iscsi_print_params(tpg->param_list);
+}
+
+/*	iscsi_tpg_free_network_portals():
+ *
+ *
+ */
+static void iscsi_tpg_free_network_portals(struct iscsi_portal_group *=
tpg)
+{
+	struct iscsi_np *np;
+	struct iscsi_tpg_np *tpg_np, *tpg_np_t;
+	unsigned char buf_ipv4[IPV4_BUF_SIZE], *ip;
+
+	spin_lock(&tpg->tpg_np_lock);
+	list_for_each_entry_safe(tpg_np, tpg_np_t, &tpg->tpg_gnp_list,
+				tpg_np_list) {
+		np =3D tpg_np->tpg_np;
+		list_del(&tpg_np->tpg_np_list);
+		tpg->num_tpg_nps--;
+		tpg->tpg_tiqn->tiqn_num_tpg_nps--;
+
+		if (np->np_net_size =3D=3D IPV6_ADDRESS_SPACE)
+			ip =3D &np->np_ipv6[0];
+		else {
+			memset(buf_ipv4, 0, IPV4_BUF_SIZE);
+			iscsi_ntoa2(buf_ipv4, np->np_ipv4);
+			ip =3D &buf_ipv4[0];
+		}
+
+		printk(KERN_INFO "CORE[%s] - Removed Network Portal: %s:%hu,%hu"
+			" on %s on network device: %s\n", tpg->tpg_tiqn->tiqn,
+			ip, np->np_port, tpg->tpgt,
+			(np->np_network_transport =3D=3D ISCSI_TCP) ?
+			"TCP" : "SCTP",  (strlen(np->np_net_dev)) ?
+			(char *)np->np_net_dev : "None");
+
+		tpg_np->tpg_np =3D NULL;
+		kfree(tpg_np);
+		spin_unlock(&tpg->tpg_np_lock);
+
+		spin_lock(&np->np_state_lock);
+		np->np_exports--;
+		printk(KERN_INFO "CORE[%s]_TPG[%hu] - Decremented np_exports to %u\n=
",
+			tpg->tpg_tiqn->tiqn, tpg->tpgt, np->np_exports);
+		spin_unlock(&np->np_state_lock);
+
+		spin_lock(&tpg->tpg_np_lock);
+	}
+	spin_unlock(&tpg->tpg_np_lock);
+}
+
+/*	iscsi_set_default_tpg_attribs():
+ *
+ *
+ */
+static void iscsi_set_default_tpg_attribs(struct iscsi_portal_group *t=
pg)
+{
+	struct iscsi_tpg_attrib *a =3D &tpg->tpg_attrib;
+
+	a->authentication =3D TA_AUTHENTICATION;
+	a->login_timeout =3D TA_LOGIN_TIMEOUT;
+	a->netif_timeout =3D TA_NETIF_TIMEOUT;
+	a->default_cmdsn_depth =3D TA_DEFAULT_CMDSN_DEPTH;
+	a->generate_node_acls =3D TA_GENERATE_NODE_ACLS;
+	a->cache_dynamic_acls =3D TA_CACHE_DYNAMIC_ACLS;
+	a->demo_mode_write_protect =3D TA_DEMO_MODE_WRITE_PROTECT;
+	a->prod_mode_write_protect =3D TA_PROD_MODE_WRITE_PROTECT;
+	a->cache_core_nps =3D TA_CACHE_CORE_NPS;
+}
+
+/*	iscsi_tpg_add_portal_group():
+ *
+ *
+ */
+int iscsi_tpg_add_portal_group(struct iscsi_tiqn *tiqn, struct iscsi_p=
ortal_group *tpg)
+{
+	if (tpg->tpg_state !=3D TPG_STATE_FREE) {
+		printk(KERN_ERR "Unable to add iSCSI Target Portal Group: %d"
+			" while not in TPG_STATE_FREE state.\n", tpg->tpgt);
+		return -EEXIST;
+	}
+	iscsi_set_default_tpg_attribs(tpg);
+
+	if (iscsi_create_default_params(&tpg->param_list) < 0)
+		goto err_out;
+
+	ISCSI_TPG_ATTRIB(tpg)->tpg =3D tpg;
+
+	spin_lock(&tpg->tpg_state_lock);
+	tpg->tpg_state	=3D TPG_STATE_INACTIVE;
+	spin_unlock(&tpg->tpg_state_lock);
+
+	spin_lock(&tiqn->tiqn_tpg_lock);
+	list_add_tail(&tpg->tpg_list, &tiqn->tiqn_tpg_list);
+	tiqn->tiqn_ntpgs++;
+	printk(KERN_INFO "CORE[%s]_TPG[%hu] - Added iSCSI Target Portal Group=
\n",
+			tiqn->tiqn, tpg->tpgt);
+	spin_unlock(&tiqn->tiqn_tpg_lock);
+
+	spin_lock_bh(&iscsi_global->g_tpg_lock);
+	list_add_tail(&tpg->g_tpg_list, &iscsi_global->g_tpg_list);
+	spin_unlock_bh(&iscsi_global->g_tpg_lock);
+
+	return 0;
+err_out:
+	if (tpg->param_list) {
+		iscsi_release_param_list(tpg->param_list);
+		tpg->param_list =3D NULL;
+	}
+	kfree(tpg);
+	return -ENOMEM;
+}
+
+int iscsi_tpg_del_portal_group(
+	struct iscsi_tiqn *tiqn,
+	struct iscsi_portal_group *tpg,
+	int force)
+{
+	u8 old_state =3D tpg->tpg_state;
+
+	spin_lock(&tpg->tpg_state_lock);
+	tpg->tpg_state =3D TPG_STATE_INACTIVE;
+	spin_unlock(&tpg->tpg_state_lock);
+
+	iscsi_clear_tpg_np_login_threads(tpg, 1);
+
+	if (iscsi_release_sessions_for_tpg(tpg, force) < 0) {
+		printk(KERN_ERR "Unable to delete iSCSI Target Portal Group:"
+			" %hu while active sessions exist, and force=3D0\n",
+			tpg->tpgt);
+		tpg->tpg_state =3D old_state;
+		return -EPERM;
+	}
+
+	core_tpg_clear_object_luns(&tpg->tpg_se_tpg);
+	iscsi_tpg_free_network_portals(tpg);
+
+	spin_lock_bh(&iscsi_global->g_tpg_lock);
+	list_del(&tpg->g_tpg_list);
+	spin_unlock_bh(&iscsi_global->g_tpg_lock);
+
+	if (tpg->param_list) {
+		iscsi_release_param_list(tpg->param_list);
+		tpg->param_list =3D NULL;
+	}
+
+	core_tpg_deregister(&tpg->tpg_se_tpg);
+
+	spin_lock(&tpg->tpg_state_lock);
+	tpg->tpg_state =3D TPG_STATE_FREE;
+	spin_unlock(&tpg->tpg_state_lock);
+
+	spin_lock(&tiqn->tiqn_tpg_lock);
+	tiqn->tiqn_ntpgs--;
+	list_del(&tpg->tpg_list);
+	spin_unlock(&tiqn->tiqn_tpg_lock);
+
+	printk(KERN_INFO "CORE[%s]_TPG[%hu] - Deleted iSCSI Target Portal Gro=
up\n",
+			tiqn->tiqn, tpg->tpgt);
+
+	kmem_cache_free(lio_tpg_cache, tpg);
+	return 0;
+}
+
+/*	iscsi_tpg_enable_portal_group():
+ *
+ *
+ */
+int iscsi_tpg_enable_portal_group(struct iscsi_portal_group *tpg)
+{
+	struct iscsi_param *param;
+	struct iscsi_tiqn *tiqn =3D tpg->tpg_tiqn;
+
+	spin_lock(&tpg->tpg_state_lock);
+	if (tpg->tpg_state =3D=3D TPG_STATE_ACTIVE) {
+		printk(KERN_ERR "iSCSI target portal group: %hu is already"
+			" active, ignoring request.\n", tpg->tpgt);
+		spin_unlock(&tpg->tpg_state_lock);
+		return -EINVAL;
+	}
+	/*
+	 * Make sure that AuthMethod does not contain None as an option
+	 * unless explictly disabled.  Set the default to CHAP if authenticat=
ion
+	 * is enforced (as per default), and remove the NONE option.
+	 */
+	param =3D iscsi_find_param_from_key(AUTHMETHOD, tpg->param_list);
+	if (!(param)) {
+		spin_unlock(&tpg->tpg_state_lock);
+		return -ENOMEM;
+	}
+
+	if (ISCSI_TPG_ATTRIB(tpg)->authentication) {
+		if (!strcmp(param->value, NONE))
+			if (iscsi_update_param_value(param, CHAP) < 0) {
+				spin_unlock(&tpg->tpg_state_lock);
+				return -ENOMEM;
+			}
+		if (iscsi_ta_authentication(tpg, 1) < 0) {
+			spin_unlock(&tpg->tpg_state_lock);
+			return -ENOMEM;
+		}
+	}
+
+	tpg->tpg_state =3D TPG_STATE_ACTIVE;
+	spin_unlock(&tpg->tpg_state_lock);
+
+	spin_lock(&tiqn->tiqn_tpg_lock);
+	tiqn->tiqn_active_tpgs++;
+	printk(KERN_INFO "iSCSI_TPG[%hu] - Enabled iSCSI Target Portal Group\=
n",
+			tpg->tpgt);
+	spin_unlock(&tiqn->tiqn_tpg_lock);
+
+	return 0;
+}
+
+/*	iscsi_tpg_disable_portal_group():
+ *
+ *
+ */
+int iscsi_tpg_disable_portal_group(struct iscsi_portal_group *tpg, int=
 force)
+{
+	struct iscsi_tiqn *tiqn;
+	u8 old_state =3D tpg->tpg_state;
+
+	spin_lock(&tpg->tpg_state_lock);
+	if (tpg->tpg_state =3D=3D TPG_STATE_INACTIVE) {
+		printk(KERN_ERR "iSCSI Target Portal Group: %hu is already"
+			" inactive, ignoring request.\n", tpg->tpgt);
+		spin_unlock(&tpg->tpg_state_lock);
+		return -EINVAL;
+	}
+	tpg->tpg_state =3D TPG_STATE_INACTIVE;
+	spin_unlock(&tpg->tpg_state_lock);
+
+	iscsi_clear_tpg_np_login_threads(tpg, 0);
+
+	if (iscsi_release_sessions_for_tpg(tpg, force) < 0) {
+		spin_lock(&tpg->tpg_state_lock);
+		tpg->tpg_state =3D old_state;
+		spin_unlock(&tpg->tpg_state_lock);
+		printk(KERN_ERR "Unable to disable iSCSI Target Portal Group:"
+			" %hu while active sessions exist, and force=3D0\n",
+			tpg->tpgt);
+		return -EPERM;
+	}
+
+	tiqn =3D tpg->tpg_tiqn;
+	if (!(tiqn) || (tpg =3D=3D iscsi_global->discovery_tpg))
+		return 0;
+
+	spin_lock(&tiqn->tiqn_tpg_lock);
+	tiqn->tiqn_active_tpgs--;
+	printk(KERN_INFO "iSCSI_TPG[%hu] - Disabled iSCSI Target Portal Group=
\n",
+			tpg->tpgt);
+	spin_unlock(&tiqn->tiqn_tpg_lock);
+
+	return 0;
+}
+
+struct iscsi_node_attrib *iscsi_tpg_get_node_attrib(
+	struct iscsi_session *sess)
+{
+	struct se_session *se_sess =3D sess->se_sess;
+	struct se_node_acl *se_nacl =3D se_sess->se_node_acl;
+	struct iscsi_node_acl *acl =3D container_of(se_nacl, struct iscsi_nod=
e_acl,
+					se_node_acl);
+
+	return &acl->node_attrib;
+}
+
+struct iscsi_tpg_np *iscsi_tpg_locate_child_np(
+	struct iscsi_tpg_np *tpg_np,
+	int network_transport)
+{
+	struct iscsi_tpg_np *tpg_np_child, *tpg_np_child_tmp;
+
+	spin_lock(&tpg_np->tpg_np_parent_lock);
+	list_for_each_entry_safe(tpg_np_child, tpg_np_child_tmp,
+			&tpg_np->tpg_np_parent_list, tpg_np_child_list) {
+		if (tpg_np_child->tpg_np->np_network_transport =3D=3D
+				network_transport) {
+			spin_unlock(&tpg_np->tpg_np_parent_lock);
+			return tpg_np_child;
+		}
+	}
+	spin_unlock(&tpg_np->tpg_np_parent_lock);
+
+	return NULL;
+}
+
+/*	iscsi_tpg_add_network_portal():
+ *
+ *
+ */
+struct iscsi_tpg_np *iscsi_tpg_add_network_portal(
+	struct iscsi_portal_group *tpg,
+	struct iscsi_np_addr *np_addr,
+	struct iscsi_tpg_np *tpg_np_parent,
+	int network_transport)
+{
+	struct iscsi_np *np;
+	struct iscsi_tpg_np *tpg_np;
+	char *ip_buf;
+	void *ip;
+	int ret =3D 0;
+	unsigned char buf_ipv4[IPV4_BUF_SIZE];
+
+	if (np_addr->np_flags & NPF_NET_IPV6) {
+		ip_buf =3D (char *)&np_addr->np_ipv6[0];
+		ip =3D (void *)&np_addr->np_ipv6[0];
+	} else {
+		memset(buf_ipv4, 0, IPV4_BUF_SIZE);
+		iscsi_ntoa2(buf_ipv4, np_addr->np_ipv4);
+		ip_buf =3D &buf_ipv4[0];
+		ip =3D (void *)&np_addr->np_ipv4;
+	}
+	/*
+	 * If the Network Portal does not currently exist, start it up now.
+	 */
+	np =3D core_get_np(ip, np_addr->np_port, network_transport);
+	if (!(np)) {
+		np =3D core_add_np(np_addr, network_transport, &ret);
+		if (!(np))
+			return ERR_PTR(ret);
+	}
+
+	tpg_np =3D kzalloc(sizeof(struct iscsi_tpg_np), GFP_KERNEL);
+	if (!(tpg_np)) {
+		printk(KERN_ERR "Unable to allocate memory for"
+				" struct iscsi_tpg_np.\n");
+		return ERR_PTR(-ENOMEM);
+	}
+	tpg_np->tpg_np_index	=3D iscsi_get_new_index(ISCSI_PORTAL_INDEX);
+	INIT_LIST_HEAD(&tpg_np->tpg_np_list);
+	INIT_LIST_HEAD(&tpg_np->tpg_np_child_list);
+	INIT_LIST_HEAD(&tpg_np->tpg_np_parent_list);
+	spin_lock_init(&tpg_np->tpg_np_parent_lock);
+	tpg_np->tpg_np		=3D np;
+	tpg_np->tpg		=3D tpg;
+
+	spin_lock(&tpg->tpg_np_lock);
+	list_add_tail(&tpg_np->tpg_np_list, &tpg->tpg_gnp_list);
+	tpg->num_tpg_nps++;
+	if (tpg->tpg_tiqn)
+		tpg->tpg_tiqn->tiqn_num_tpg_nps++;
+	spin_unlock(&tpg->tpg_np_lock);
+
+	if (tpg_np_parent) {
+		tpg_np->tpg_np_parent =3D tpg_np_parent;
+		spin_lock(&tpg_np_parent->tpg_np_parent_lock);
+		list_add_tail(&tpg_np->tpg_np_child_list,
+			&tpg_np_parent->tpg_np_parent_list);
+		spin_unlock(&tpg_np_parent->tpg_np_parent_lock);
+	}
+
+	printk(KERN_INFO "CORE[%s] - Added Network Portal: %s:%hu,%hu on %s o=
n"
+		" network device: %s\n", tpg->tpg_tiqn->tiqn, ip_buf,
+		np->np_port, tpg->tpgt,
+		(np->np_network_transport =3D=3D ISCSI_TCP) ?
+		"TCP" : "SCTP", (strlen(np->np_net_dev)) ?
+		(char *)np->np_net_dev : "None");
+
+	spin_lock(&np->np_state_lock);
+	np->np_exports++;
+	printk(KERN_INFO "CORE[%s]_TPG[%hu] - Incremented np_exports to %u\n"=
,
+		tpg->tpg_tiqn->tiqn, tpg->tpgt, np->np_exports);
+	spin_unlock(&np->np_state_lock);
+
+	return tpg_np;
+}
+
+static int iscsi_tpg_release_np(
+	struct iscsi_tpg_np *tpg_np,
+	struct iscsi_portal_group *tpg,
+	struct iscsi_np *np)
+{
+	char *ip;
+	char buf_ipv4[IPV4_BUF_SIZE];
+
+	if (np->np_net_size =3D=3D IPV6_ADDRESS_SPACE)
+		ip =3D &np->np_ipv6[0];
+	else {
+		memset(buf_ipv4, 0, IPV4_BUF_SIZE);
+		iscsi_ntoa2(buf_ipv4, np->np_ipv4);
+		ip =3D &buf_ipv4[0];
+	}
+
+	iscsi_clear_tpg_np_login_thread(tpg_np, tpg, 1);
+
+	printk(KERN_INFO "CORE[%s] - Removed Network Portal: %s:%hu,%hu on %s=
"
+		" on network device: %s\n", tpg->tpg_tiqn->tiqn, ip,
+		np->np_port, tpg->tpgt,
+		(np->np_network_transport =3D=3D ISCSI_TCP) ?
+		"TCP" : "SCTP",  (strlen(np->np_net_dev)) ?
+		(char *)np->np_net_dev : "None");
+
+	tpg_np->tpg_np =3D NULL;
+	tpg_np->tpg =3D NULL;
+	kfree(tpg_np);
+
+	/*
+	 * Shutdown Network Portal when last TPG reference is released.
+	 */
+	spin_lock(&np->np_state_lock);
+	if ((--np->np_exports =3D=3D 0) && !(ISCSI_TPG_ATTRIB(tpg)->cache_cor=
e_nps))
+		atomic_set(&np->np_shutdown, 1);
+	printk(KERN_INFO "CORE[%s]_TPG[%hu] - Decremented np_exports to %u\n"=
,
+		tpg->tpg_tiqn->tiqn, tpg->tpgt, np->np_exports);
+	spin_unlock(&np->np_state_lock);
+
+	if (atomic_read(&np->np_shutdown))
+		core_del_np(np);
+
+	return 0;
+}
+
+/*	iscsi_tpg_del_network_portal():
+ *
+ *
+ */
+int iscsi_tpg_del_network_portal(
+	struct iscsi_portal_group *tpg,
+	struct iscsi_tpg_np *tpg_np)
+{
+	struct iscsi_np *np;
+	struct iscsi_tpg_np *tpg_np_child, *tpg_np_child_tmp;
+	int ret =3D 0;
+
+	np =3D tpg_np->tpg_np;
+	if (!(np)) {
+		printk(KERN_ERR "Unable to locate struct iscsi_np from"
+				" struct iscsi_tpg_np\n");
+		return -EINVAL;
+	}
+
+	if (!tpg_np->tpg_np_parent) {
+		/*
+		 * We are the parent tpg network portal.  Release all of the
+		 * child tpg_np's (eg: the non ISCSI_TCP ones) on our parent
+		 * list first.
+		 */
+		list_for_each_entry_safe(tpg_np_child, tpg_np_child_tmp,
+				&tpg_np->tpg_np_parent_list,
+				tpg_np_child_list) {
+			ret =3D iscsi_tpg_del_network_portal(tpg, tpg_np_child);
+			if (ret < 0)
+				printk(KERN_ERR "iscsi_tpg_del_network_portal()"
+					" failed: %d\n", ret);
+		}
+	} else {
+		/*
+		 * We are not the parent ISCSI_TCP tpg network portal.  Release
+		 * our own network portals from the child list.
+		 */
+		spin_lock(&tpg_np->tpg_np_parent->tpg_np_parent_lock);
+		list_del(&tpg_np->tpg_np_child_list);
+		spin_unlock(&tpg_np->tpg_np_parent->tpg_np_parent_lock);
+	}
+
+	spin_lock(&tpg->tpg_np_lock);
+	list_del(&tpg_np->tpg_np_list);
+	tpg->num_tpg_nps--;
+	if (tpg->tpg_tiqn)
+		tpg->tpg_tiqn->tiqn_num_tpg_nps--;
+	spin_unlock(&tpg->tpg_np_lock);
+
+	return iscsi_tpg_release_np(tpg_np, tpg, np);
+}
+
+/*	iscsi_tpg_set_initiator_node_queue_depth():
+ *
+ *
+ */
+int iscsi_tpg_set_initiator_node_queue_depth(
+	struct iscsi_portal_group *tpg,
+	unsigned char *initiatorname,
+	u32 queue_depth,
+	int force)
+{
+	return core_tpg_set_initiator_node_queue_depth(&tpg->tpg_se_tpg,
+		initiatorname, queue_depth, force);
+}
+
+/*	iscsi_ta_authentication():
+ *
+ *
+ */
+int iscsi_ta_authentication(struct iscsi_portal_group *tpg, u32 authen=
tication)
+{
+	unsigned char buf1[256], buf2[256], *none =3D NULL;
+	int len;
+	struct iscsi_param *param;
+	struct iscsi_tpg_attrib *a =3D &tpg->tpg_attrib;
+
+	if ((authentication !=3D 1) && (authentication !=3D 0)) {
+		printk(KERN_ERR "Illegal value for authentication parameter:"
+			" %u, ignoring request.\n", authentication);
+		return -1;
+	}
+
+	memset(buf1, 0, sizeof(buf1));
+	memset(buf2, 0, sizeof(buf2));
+
+	param =3D iscsi_find_param_from_key(AUTHMETHOD, tpg->param_list);
+	if (!(param))
+		return -EINVAL;
+
+	if (authentication) {
+		snprintf(buf1, sizeof(buf1), "%s", param->value);
+		none =3D strstr(buf1, NONE);
+		if (!(none))
+			goto out;
+		if (!strncmp(none + 4, ",", 1)) {
+			if (!strcmp(buf1, none))
+				sprintf(buf2, "%s", none+5);
+			else {
+				none--;
+				*none =3D '\0';
+				len =3D sprintf(buf2, "%s", buf1);
+				none +=3D 5;
+				sprintf(buf2 + len, "%s", none);
+			}
+		} else {
+			none--;
+			*none =3D '\0';
+			sprintf(buf2, "%s", buf1);
+		}
+		if (iscsi_update_param_value(param, buf2) < 0)
+			return -EINVAL;
+	} else {
+		snprintf(buf1, sizeof(buf1), "%s", param->value);
+		none =3D strstr(buf1, NONE);
+		if ((none))
+			goto out;
+		strncat(buf1, ",", strlen(","));
+		strncat(buf1, NONE, strlen(NONE));
+		if (iscsi_update_param_value(param, buf1) < 0)
+			return -EINVAL;
+	}
+
+out:
+	a->authentication =3D authentication;
+	printk(KERN_INFO "%s iSCSI Authentication Methods for TPG: %hu.\n",
+		a->authentication ? "Enforcing" : "Disabling", tpg->tpgt);
+
+	return 0;
+}
+
+/*	iscsi_ta_login_timeout():
+ *
+ *
+ */
+int iscsi_ta_login_timeout(
+	struct iscsi_portal_group *tpg,
+	u32 login_timeout)
+{
+	struct iscsi_tpg_attrib *a =3D &tpg->tpg_attrib;
+
+	if (login_timeout > TA_LOGIN_TIMEOUT_MAX) {
+		printk(KERN_ERR "Requested Login Timeout %u larger than maximum"
+			" %u\n", login_timeout, TA_LOGIN_TIMEOUT_MAX);
+		return -EINVAL;
+	} else if (login_timeout < TA_LOGIN_TIMEOUT_MIN) {
+		printk(KERN_ERR "Requested Logout Timeout %u smaller than"
+			" minimum %u\n", login_timeout, TA_LOGIN_TIMEOUT_MIN);
+		return -EINVAL;
+	}
+
+	a->login_timeout =3D login_timeout;
+	printk(KERN_INFO "Set Logout Timeout to %u for Target Portal Group"
+		" %hu\n", a->login_timeout, tpg->tpgt);
+
+	return 0;
+}
+
+/*	iscsi_ta_netif_timeout():
+ *
+ *
+ */
+int iscsi_ta_netif_timeout(
+	struct iscsi_portal_group *tpg,
+	u32 netif_timeout)
+{
+	struct iscsi_tpg_attrib *a =3D &tpg->tpg_attrib;
+
+	if (netif_timeout > TA_NETIF_TIMEOUT_MAX) {
+		printk(KERN_ERR "Requested Network Interface Timeout %u larger"
+			" than maximum %u\n", netif_timeout,
+				TA_NETIF_TIMEOUT_MAX);
+		return -EINVAL;
+	} else if (netif_timeout < TA_NETIF_TIMEOUT_MIN) {
+		printk(KERN_ERR "Requested Network Interface Timeout %u smaller"
+			" than minimum %u\n", netif_timeout,
+				TA_NETIF_TIMEOUT_MIN);
+		return -EINVAL;
+	}
+
+	a->netif_timeout =3D netif_timeout;
+	printk(KERN_INFO "Set Network Interface Timeout to %u for"
+		" Target Portal Group %hu\n", a->netif_timeout, tpg->tpgt);
+
+	return 0;
+}
+
+int iscsi_ta_generate_node_acls(
+	struct iscsi_portal_group *tpg,
+	u32 flag)
+{
+	struct iscsi_tpg_attrib *a =3D &tpg->tpg_attrib;
+
+	if ((flag !=3D 0) && (flag !=3D 1)) {
+		printk(KERN_ERR "Illegal value %d\n", flag);
+		return -EINVAL;
+	}
+
+	a->generate_node_acls =3D flag;
+	printk(KERN_INFO "iSCSI_TPG[%hu] - Generate Initiator Portal Group AC=
Ls: %s\n",
+		tpg->tpgt, (a->generate_node_acls) ? "Enabled" : "Disabled");
+
+	return 0;
+}
+
+int iscsi_ta_default_cmdsn_depth(
+	struct iscsi_portal_group *tpg,
+	u32 tcq_depth)
+{
+	struct iscsi_tpg_attrib *a =3D &tpg->tpg_attrib;
+
+	if (tcq_depth > TA_DEFAULT_CMDSN_DEPTH_MAX) {
+		printk(KERN_ERR "Requested Default Queue Depth: %u larger"
+			" than maximum %u\n", tcq_depth,
+				TA_DEFAULT_CMDSN_DEPTH_MAX);
+		return -EINVAL;
+	} else if (tcq_depth < TA_DEFAULT_CMDSN_DEPTH_MIN) {
+		printk(KERN_ERR "Requested Default Queue Depth: %u smaller"
+			" than minimum %u\n", tcq_depth,
+				TA_DEFAULT_CMDSN_DEPTH_MIN);
+		return -EINVAL;
+	}
+
+	a->default_cmdsn_depth =3D tcq_depth;
+	printk(KERN_INFO "iSCSI_TPG[%hu] - Set Default CmdSN TCQ Depth to %u\=
n",
+		tpg->tpgt, a->default_cmdsn_depth);
+
+	return 0;
+}
+
+int iscsi_ta_cache_dynamic_acls(
+	struct iscsi_portal_group *tpg,
+	u32 flag)
+{
+	struct iscsi_tpg_attrib *a =3D &tpg->tpg_attrib;
+
+	if ((flag !=3D 0) && (flag !=3D 1)) {
+		printk(KERN_ERR "Illegal value %d\n", flag);
+		return -EINVAL;
+	}
+
+	a->cache_dynamic_acls =3D flag;
+	printk(KERN_INFO "iSCSI_TPG[%hu] - Cache Dynamic Initiator Portal Gro=
up"
+		" ACLs %s\n", tpg->tpgt, (a->cache_dynamic_acls) ?
+		"Enabled" : "Disabled");
+
+	return 0;
+}
+
+int iscsi_ta_demo_mode_write_protect(
+	struct iscsi_portal_group *tpg,
+	u32 flag)
+{
+	struct iscsi_tpg_attrib *a =3D &tpg->tpg_attrib;
+
+	if ((flag !=3D 0) && (flag !=3D 1)) {
+		printk(KERN_ERR "Illegal value %d\n", flag);
+		return -EINVAL;
+	}
+
+	a->demo_mode_write_protect =3D flag;
+	printk(KERN_INFO "iSCSI_TPG[%hu] - Demo Mode Write Protect bit: %s\n"=
,
+		tpg->tpgt, (a->demo_mode_write_protect) ? "ON" : "OFF");
+
+	return 0;
+}
+
+int iscsi_ta_prod_mode_write_protect(
+	struct iscsi_portal_group *tpg,
+	u32 flag)
+{
+	struct iscsi_tpg_attrib *a =3D &tpg->tpg_attrib;
+
+	if ((flag !=3D 0) && (flag !=3D 1)) {
+		printk(KERN_ERR "Illegal value %d\n", flag);
+		return -EINVAL;
+	}
+
+	a->prod_mode_write_protect =3D flag;
+	printk(KERN_INFO "iSCSI_TPG[%hu] - Production Mode Write Protect bit:=
"
+		" %s\n", tpg->tpgt, (a->prod_mode_write_protect) ?
+		"ON" : "OFF");
+
+	return 0;
+}
+
+void iscsi_disable_tpgs(struct iscsi_tiqn *tiqn)
+{
+	struct iscsi_portal_group *tpg;
+
+	spin_lock(&tiqn->tiqn_tpg_lock);
+	list_for_each_entry(tpg, &tiqn->tiqn_tpg_list, tpg_list) {
+
+		spin_lock(&tpg->tpg_state_lock);
+		if ((tpg->tpg_state =3D=3D TPG_STATE_FREE) ||
+		    (tpg->tpg_state =3D=3D TPG_STATE_INACTIVE)) {
+			spin_unlock(&tpg->tpg_state_lock);
+			continue;
+		}
+		spin_unlock(&tpg->tpg_state_lock);
+		spin_unlock(&tiqn->tiqn_tpg_lock);
+
+		iscsi_tpg_disable_portal_group(tpg, 1);
+
+		spin_lock(&tiqn->tiqn_tpg_lock);
+	}
+	spin_unlock(&tiqn->tiqn_tpg_lock);
+}
+
+/*	iscsi_disable_all_tpgs():
+ *
+ *
+ */
+void iscsi_disable_all_tpgs(void)
+{
+	struct iscsi_tiqn *tiqn;
+
+	spin_lock(&iscsi_global->tiqn_lock);
+	list_for_each_entry(tiqn, &iscsi_global->g_tiqn_list, tiqn_list) {
+		spin_unlock(&iscsi_global->tiqn_lock);
+		iscsi_disable_tpgs(tiqn);
+		spin_lock(&iscsi_global->tiqn_lock);
+	}
+	spin_unlock(&iscsi_global->tiqn_lock);
+}
+
+void iscsi_remove_tpgs(struct iscsi_tiqn *tiqn)
+{
+	struct iscsi_portal_group *tpg, *tpg_tmp;
+
+	spin_lock(&tiqn->tiqn_tpg_lock);
+	list_for_each_entry_safe(tpg, tpg_tmp, &tiqn->tiqn_tpg_list, tpg_list=
) {
+
+		spin_lock(&tpg->tpg_state_lock);
+		if (tpg->tpg_state =3D=3D TPG_STATE_FREE) {
+			spin_unlock(&tpg->tpg_state_lock);
+			continue;
+		}
+		spin_unlock(&tpg->tpg_state_lock);
+		spin_unlock(&tiqn->tiqn_tpg_lock);
+
+		iscsi_tpg_del_portal_group(tiqn, tpg, 1);
+
+		spin_lock(&tiqn->tiqn_tpg_lock);
+	}
+	spin_unlock(&tiqn->tiqn_tpg_lock);
+}
+
+/*	iscsi_remove_all_tpgs():
+ *
+ *
+ */
+void iscsi_remove_all_tpgs(void)
+{
+	struct iscsi_tiqn *tiqn;
+
+	spin_lock(&iscsi_global->tiqn_lock);
+	list_for_each_entry(tiqn, &iscsi_global->g_tiqn_list, tiqn_list) {
+		spin_unlock(&iscsi_global->tiqn_lock);
+		iscsi_remove_tpgs(tiqn);
+		spin_lock(&iscsi_global->tiqn_lock);
+	}
+	spin_unlock(&iscsi_global->tiqn_lock);
+}
diff --git a/drivers/target/iscsi/iscsi_target_tpg.h b/drivers/target/i=
scsi/iscsi_target_tpg.h
new file mode 100644
index 0000000..088fcd7
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_tpg.h
@@ -0,0 +1,70 @@
+#ifndef ISCSI_TARGET_TPG_H
+#define ISCSI_TARGET_TPG_H
+
+extern char *lio_tpg_get_endpoint_wwn(struct se_portal_group *);
+extern u16 lio_tpg_get_tag(struct se_portal_group *);
+extern u32 lio_tpg_get_default_depth(struct se_portal_group *);
+extern int lio_tpg_check_demo_mode(struct se_portal_group *);
+extern int lio_tpg_check_demo_mode_cache(struct se_portal_group *);
+extern int lio_tpg_check_demo_mode_write_protect(struct se_portal_grou=
p *);
+extern int lio_tpg_check_prod_mode_write_protect(struct se_portal_grou=
p *);
+extern struct se_node_acl *lio_tpg_alloc_fabric_acl(struct se_portal_g=
roup *);
+extern void lio_tpg_release_fabric_acl(struct se_portal_group *,
+			struct se_node_acl *);
+extern int lio_tpg_shutdown_session(struct se_session *);
+extern void lio_tpg_close_session(struct se_session *);
+extern void lio_tpg_stop_session(struct se_session *, int, int);
+extern void lio_tpg_fall_back_to_erl0(struct se_session *);
+extern u32 lio_tpg_get_inst_index(struct se_portal_group *);
+extern void lio_set_default_node_attributes(struct se_node_acl *);
+
+extern struct iscsi_portal_group *core_alloc_portal_group(struct iscsi=
_tiqn *, u16);
+extern int core_load_discovery_tpg(void);
+extern void core_release_discovery_tpg(void);
+extern struct iscsi_portal_group *core_get_tpg_from_np(struct iscsi_ti=
qn *,
+			struct iscsi_np *);
+extern int iscsi_get_tpg(struct iscsi_portal_group *);
+extern void iscsi_put_tpg(struct iscsi_portal_group *);
+extern void iscsi_clear_tpg_np_login_threads(struct iscsi_portal_group=
 *, int);
+extern void iscsi_tpg_dump_params(struct iscsi_portal_group *);
+extern int iscsi_tpg_add_portal_group(struct iscsi_tiqn *, struct iscs=
i_portal_group *);
+extern int iscsi_tpg_del_portal_group(struct iscsi_tiqn *, struct iscs=
i_portal_group *,
+			int);
+extern int iscsi_tpg_enable_portal_group(struct iscsi_portal_group *);
+extern int iscsi_tpg_disable_portal_group(struct iscsi_portal_group *,=
 int);
+extern struct iscsi_node_acl *iscsi_tpg_add_initiator_node_acl(
+			struct iscsi_portal_group *, const char *, u32);
+extern void iscsi_tpg_del_initiator_node_acl(struct iscsi_portal_group=
 *,
+			struct se_node_acl *);
+extern struct iscsi_node_attrib *iscsi_tpg_get_node_attrib(struct iscs=
i_session *);
+extern void iscsi_tpg_del_external_nps(struct iscsi_tpg_np *);
+extern struct iscsi_tpg_np *iscsi_tpg_locate_child_np(struct iscsi_tpg=
_np *, int);
+extern struct iscsi_tpg_np *iscsi_tpg_add_network_portal(struct iscsi_=
portal_group *,
+			struct iscsi_np_addr *, struct iscsi_tpg_np *, int);
+extern int iscsi_tpg_del_network_portal(struct iscsi_portal_group *,
+			struct iscsi_tpg_np *);
+extern int iscsi_tpg_set_initiator_node_queue_depth(struct iscsi_porta=
l_group *,
+			unsigned char *, u32, int);
+extern int iscsi_ta_authentication(struct iscsi_portal_group *, u32);
+extern int iscsi_ta_login_timeout(struct iscsi_portal_group *, u32);
+extern int iscsi_ta_netif_timeout(struct iscsi_portal_group *, u32);
+extern int iscsi_ta_generate_node_acls(struct iscsi_portal_group *, u3=
2);
+extern int iscsi_ta_default_cmdsn_depth(struct iscsi_portal_group *, u=
32);
+extern int iscsi_ta_cache_dynamic_acls(struct iscsi_portal_group *, u3=
2);
+extern int iscsi_ta_demo_mode_write_protect(struct iscsi_portal_group =
*, u32);
+extern int iscsi_ta_prod_mode_write_protect(struct iscsi_portal_group =
*, u32);
+extern void iscsi_disable_tpgs(struct iscsi_tiqn *);
+extern void iscsi_disable_all_tpgs(void);
+extern void iscsi_remove_tpgs(struct iscsi_tiqn *);
+extern void iscsi_remove_all_tpgs(void);
+
+extern struct iscsi_global *iscsi_global;
+extern struct target_fabric_configfs *lio_target_fabric_configfs;
+extern struct kmem_cache *lio_tpg_cache;
+
+extern int iscsi_close_session(struct iscsi_session *);
+extern int iscsi_free_session(struct iscsi_session *);
+extern int iscsi_release_sessions_for_tpg(struct iscsi_portal_group *,=
 int);
+extern int iscsi_ta_authentication(struct iscsi_portal_group *, u32);
+
+#endif /* ISCSI_TARGET_TPG_H */
--=20
1.7.4.1
