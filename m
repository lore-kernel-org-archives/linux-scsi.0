From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v3 07/14] iscsi-target: Add TPG and Device logic
Date: Thu, 12 May 2011 00:07:14 -0700
Message-ID: <1305184041-32189-8-git-send-email-nab@linux-iscsi.org>
References: <1305184041-32189-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1305184041-32189-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, Martin Svec <martin.svec@zoner.cz>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

=46rom: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds TPG and device logiced using for mapping iscsi-target
abstractions on top of TCM v4 struct se_portal_group and struct se_devi=
ce
abstractions.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_device.c |   88 ++++
 drivers/target/iscsi/iscsi_target_device.h |    9 +
 drivers/target/iscsi/iscsi_target_tpg.c    |  760 ++++++++++++++++++++=
++++++++
 drivers/target/iscsi/iscsi_target_tpg.h    |   41 ++
 4 files changed, 898 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/iscsi/iscsi_target_device.c
 create mode 100644 drivers/target/iscsi/iscsi_target_device.h
 create mode 100644 drivers/target/iscsi/iscsi_target_tpg.c
 create mode 100644 drivers/target/iscsi/iscsi_target_tpg.h

diff --git a/drivers/target/iscsi/iscsi_target_device.c b/drivers/targe=
t/iscsi/iscsi_target_device.c
new file mode 100644
index 0000000..47218c2
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_device.c
@@ -0,0 +1,88 @@
+/*********************************************************************=
**********
+ * This file contains the iSCSI Virtual Device and Disk Transport
+ * agnostic related functions.
+ *
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
+#include <scsi/scsi_device.h>
+#include <target/target_core_base.h>
+#include <target/target_core_device.h>
+#include <target/target_core_transport.h>
+
+#include "iscsi_target_debug.h"
+#include "iscsi_target_core.h"
+#include "iscsi_target_device.h"
+#include "iscsi_target_tpg.h"
+#include "iscsi_target_util.h"
+
+int iscsit_get_lun_for_tmr(
+	struct iscsi_cmd *cmd,
+	u64 lun)
+{
+	u32 unpacked_lun =3D scsilun_to_int((struct scsi_lun *)&lun);
+
+	return transport_get_lun_for_tmr(SE_CMD(cmd), unpacked_lun);
+}
+
+int iscsit_get_lun_for_cmd(
+	struct iscsi_cmd *cmd,
+	unsigned char *cdb,
+	u64 lun)
+{
+	u32 unpacked_lun =3D scsilun_to_int((struct scsi_lun *)&lun);
+
+	return transport_get_lun_for_cmd(SE_CMD(cmd), NULL, unpacked_lun);
+}
+
+void iscsit_determine_maxcmdsn(struct iscsi_session *sess)
+{
+	struct se_node_acl *se_nacl;
+
+	/*
+	 * This is a discovery session, the single queue slot was already
+	 * assigned in iscsi_login_zero_tsih().  Since only Logout and
+	 * Text Opcodes are allowed during discovery we do not have to worry
+	 * about the HBA's queue depth here.
+	 */
+	if (sess->sess_ops->SessionType)
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
+void iscsit_increment_maxcmdsn(struct iscsi_cmd *cmd, struct iscsi_ses=
sion *sess)
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
index 0000000..bef1cad
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_device.h
@@ -0,0 +1,9 @@
+#ifndef ISCSI_TARGET_DEVICE_H
+#define ISCSI_TARGET_DEVICE_H
+
+extern int iscsit_get_lun_for_tmr(struct iscsi_cmd *, u64);
+extern int iscsit_get_lun_for_cmd(struct iscsi_cmd *, unsigned char *,=
 u64);
+extern void iscsit_determine_maxcmdsn(struct iscsi_session *);
+extern void iscsit_increment_maxcmdsn(struct iscsi_cmd *, struct iscsi=
_session *);
+
+#endif /* ISCSI_TARGET_DEVICE_H */
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/i=
scsi/iscsi_target_tpg.c
new file mode 100644
index 0000000..b658857
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -0,0 +1,760 @@
+/*********************************************************************=
**********
+ * This file contains iSCSI Target Portal Group related functions.
+ *
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
+#include <target/target_core_base.h>
+#include <target/target_core_transport.h>
+#include <target/target_core_fabric_ops.h>
+#include <target/target_core_configfs.h>
+#include <target/target_core_tpg.h>
+
+#include "iscsi_target_debug.h"
+#include "iscsi_target_core.h"
+#include "iscsi_target_erl0.h"
+#include "iscsi_target_login.h"
+#include "iscsi_target_nodeattrib.h"
+#include "iscsi_target_tpg.h"
+#include "iscsi_target_util.h"
+#include "iscsi_target.h"
+#include "iscsi_target_parameters.h"
+
+struct iscsi_portal_group *iscsit_alloc_portal_group(struct iscsi_tiqn=
 *tiqn, u16 tpgt)
+{
+	struct iscsi_portal_group *tpg;
+
+	tpg =3D kzalloc(sizeof(struct iscsi_portal_group), GFP_KERNEL);
+	if (!tpg) {
+		printk(KERN_ERR "Unable to allocate struct iscsi_portal_group\n");
+		return NULL;
+	}
+
+	tpg->tpgt =3D tpgt;
+	tpg->tpg_state =3D TPG_STATE_FREE;
+	tpg->tpg_tiqn =3D tiqn;
+	INIT_LIST_HEAD(&tpg->tpg_gnp_list);
+	INIT_LIST_HEAD(&tpg->tpg_list);
+	mutex_init(&tpg->tpg_access_lock);
+	mutex_init(&tpg->np_login_lock);
+	spin_lock_init(&tpg->tpg_state_lock);
+	spin_lock_init(&tpg->tpg_np_lock);
+
+	return tpg;
+}
+
+static void iscsit_set_default_tpg_attribs(struct iscsi_portal_group *=
);
+
+int iscsit_load_discovery_tpg(void)
+{
+	struct iscsi_param *param;
+	struct iscsi_portal_group *tpg;
+	int ret;
+
+	tpg =3D iscsit_alloc_portal_group(NULL, 1);
+	if (!tpg) {
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
+	iscsit_set_default_tpg_attribs(tpg);
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
+	if (!param)
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
+	iscsit_global->discovery_tpg =3D tpg;
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
+void iscsit_release_discovery_tpg(void)
+{
+	struct iscsi_portal_group *tpg =3D iscsit_global->discovery_tpg;
+
+	if (!tpg)
+		return;
+
+	core_tpg_deregister(&tpg->tpg_se_tpg);
+
+	kfree(tpg);
+	iscsit_global->discovery_tpg =3D NULL;
+}
+
+struct iscsi_portal_group *iscsit_get_tpg_from_np(
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
+int iscsit_get_tpg(
+	struct iscsi_portal_group *tpg)
+{
+	int ret;
+
+	ret =3D mutex_lock_interruptible(&tpg->tpg_access_lock);
+	return ((ret !=3D 0) || signal_pending(current)) ? -1 : 0;
+}
+
+void iscsit_put_tpg(struct iscsi_portal_group *tpg)
+{
+	mutex_unlock(&tpg->tpg_access_lock);
+}
+
+static void iscsit_clear_tpg_np_login_thread(
+	struct iscsi_tpg_np *tpg_np,
+	struct iscsi_portal_group *tpg)
+{
+	if (!tpg_np->tpg_np) {
+		printk(KERN_ERR "struct iscsi_tpg_np->tpg_np is NULL!\n");
+		return;
+	}
+
+	iscsit_reset_np_thread(tpg_np->tpg_np, tpg_np, tpg);
+}
+
+void iscsit_clear_tpg_np_login_threads(
+	struct iscsi_portal_group *tpg)
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
+		iscsit_clear_tpg_np_login_thread(tpg_np, tpg);
+		spin_lock(&tpg->tpg_np_lock);
+	}
+	spin_unlock(&tpg->tpg_np_lock);
+}
+
+void iscsit_tpg_dump_params(struct iscsi_portal_group *tpg)
+{
+	iscsi_print_params(tpg->param_list);
+}
+
+static void iscsit_set_default_tpg_attribs(struct iscsi_portal_group *=
tpg)
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
+}
+
+int iscsit_tpg_add_portal_group(struct iscsi_tiqn *tiqn, struct iscsi_=
portal_group *tpg)
+{
+	if (tpg->tpg_state !=3D TPG_STATE_FREE) {
+		printk(KERN_ERR "Unable to add iSCSI Target Portal Group: %d"
+			" while not in TPG_STATE_FREE state.\n", tpg->tpgt);
+		return -EEXIST;
+	}
+	iscsit_set_default_tpg_attribs(tpg);
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
+int iscsit_tpg_del_portal_group(
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
+	if (iscsit_release_sessions_for_tpg(tpg, force) < 0) {
+		printk(KERN_ERR "Unable to delete iSCSI Target Portal Group:"
+			" %hu while active sessions exist, and force=3D0\n",
+			tpg->tpgt);
+		tpg->tpg_state =3D old_state;
+		return -EPERM;
+	}
+
+	core_tpg_clear_object_luns(&tpg->tpg_se_tpg);
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
+	kfree(tpg);
+	return 0;
+}
+
+int iscsit_tpg_enable_portal_group(struct iscsi_portal_group *tpg)
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
+	if (!param) {
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
+		if (iscsit_ta_authentication(tpg, 1) < 0) {
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
+int iscsit_tpg_disable_portal_group(struct iscsi_portal_group *tpg, in=
t force)
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
+	iscsit_clear_tpg_np_login_threads(tpg);
+
+	if (iscsit_release_sessions_for_tpg(tpg, force) < 0) {
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
+	if (!tiqn || (tpg =3D=3D iscsit_global->discovery_tpg))
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
+struct iscsi_node_attrib *iscsit_tpg_get_node_attrib(
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
+struct iscsi_tpg_np *iscsit_tpg_locate_child_np(
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
+struct iscsi_tpg_np *iscsit_tpg_add_network_portal(
+	struct iscsi_portal_group *tpg,
+	struct __kernel_sockaddr_storage *sockaddr,
+	char *ip_str,
+	struct iscsi_tpg_np *tpg_np_parent,
+	int network_transport)
+{
+	struct iscsi_np *np;
+	struct iscsi_tpg_np *tpg_np;
+
+	tpg_np =3D kzalloc(sizeof(struct iscsi_tpg_np), GFP_KERNEL);
+	if (!tpg_np) {
+		printk(KERN_ERR "Unable to allocate memory for"
+				" struct iscsi_tpg_np.\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	np =3D iscsit_add_np(sockaddr, ip_str, network_transport);
+	if (IS_ERR(np)) {
+		kfree(tpg_np);
+		return ERR_CAST(np);
+	}
+
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
+	printk(KERN_INFO "CORE[%s] - Added Network Portal: %s:%hu,%hu on %s\n=
",
+		tpg->tpg_tiqn->tiqn, np->np_ip, np->np_port, tpg->tpgt,
+		(np->np_network_transport =3D=3D ISCSI_TCP) ? "TCP" : "SCTP");
+
+	return tpg_np;
+}
+
+static int iscsit_tpg_release_np(
+	struct iscsi_tpg_np *tpg_np,
+	struct iscsi_portal_group *tpg,
+	struct iscsi_np *np)
+{
+	iscsit_clear_tpg_np_login_thread(tpg_np, tpg);
+
+	printk(KERN_INFO "CORE[%s] - Removed Network Portal: %s:%hu,%hu on %s=
\n",
+		tpg->tpg_tiqn->tiqn, np->np_ip, np->np_port, tpg->tpgt,
+		(np->np_network_transport =3D=3D ISCSI_TCP) ? "TCP" : "SCTP");
+
+	tpg_np->tpg_np =3D NULL;
+	tpg_np->tpg =3D NULL;
+	kfree(tpg_np);
+	/*
+	 * iscsit_del_np() will shutdown struct iscsi_np when last TPG refere=
nce is released.
+	 */
+	return iscsit_del_np(np);
+}
+
+int iscsit_tpg_del_network_portal(
+	struct iscsi_portal_group *tpg,
+	struct iscsi_tpg_np *tpg_np)
+{
+	struct iscsi_np *np;
+	struct iscsi_tpg_np *tpg_np_child, *tpg_np_child_tmp;
+	int ret =3D 0;
+
+	np =3D tpg_np->tpg_np;
+	if (!np) {
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
+			ret =3D iscsit_tpg_del_network_portal(tpg, tpg_np_child);
+			if (ret < 0)
+				printk(KERN_ERR "iscsit_tpg_del_network_portal()"
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
+	return iscsit_tpg_release_np(tpg_np, tpg, np);
+}
+
+int iscsit_tpg_set_initiator_node_queue_depth(
+	struct iscsi_portal_group *tpg,
+	unsigned char *initiatorname,
+	u32 queue_depth,
+	int force)
+{
+	return core_tpg_set_initiator_node_queue_depth(&tpg->tpg_se_tpg,
+		initiatorname, queue_depth, force);
+}
+
+int iscsit_ta_authentication(struct iscsi_portal_group *tpg, u32 authe=
ntication)
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
+	if (!param)
+		return -EINVAL;
+
+	if (authentication) {
+		snprintf(buf1, sizeof(buf1), "%s", param->value);
+		none =3D strstr(buf1, NONE);
+		if (!none)
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
+int iscsit_ta_login_timeout(
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
+int iscsit_ta_netif_timeout(
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
+int iscsit_ta_generate_node_acls(
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
+int iscsit_ta_default_cmdsn_depth(
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
+int iscsit_ta_cache_dynamic_acls(
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
+int iscsit_ta_demo_mode_write_protect(
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
+int iscsit_ta_prod_mode_write_protect(
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
diff --git a/drivers/target/iscsi/iscsi_target_tpg.h b/drivers/target/i=
scsi/iscsi_target_tpg.h
new file mode 100644
index 0000000..dda48c1
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_tpg.h
@@ -0,0 +1,41 @@
+#ifndef ISCSI_TARGET_TPG_H
+#define ISCSI_TARGET_TPG_H
+
+extern struct iscsi_portal_group *iscsit_alloc_portal_group(struct isc=
si_tiqn *, u16);
+extern int iscsit_load_discovery_tpg(void);
+extern void iscsit_release_discovery_tpg(void);
+extern struct iscsi_portal_group *iscsit_get_tpg_from_np(struct iscsi_=
tiqn *,
+			struct iscsi_np *);
+extern int iscsit_get_tpg(struct iscsi_portal_group *);
+extern void iscsit_put_tpg(struct iscsi_portal_group *);
+extern void iscsit_clear_tpg_np_login_threads(struct iscsi_portal_grou=
p *);
+extern void iscsit_tpg_dump_params(struct iscsi_portal_group *);
+extern int iscsit_tpg_add_portal_group(struct iscsi_tiqn *, struct isc=
si_portal_group *);
+extern int iscsit_tpg_del_portal_group(struct iscsi_tiqn *, struct isc=
si_portal_group *,
+			int);
+extern int iscsit_tpg_enable_portal_group(struct iscsi_portal_group *)=
;
+extern int iscsit_tpg_disable_portal_group(struct iscsi_portal_group *=
, int);
+extern struct iscsi_node_acl *iscsit_tpg_add_initiator_node_acl(
+			struct iscsi_portal_group *, const char *, u32);
+extern void iscsit_tpg_del_initiator_node_acl(struct iscsi_portal_grou=
p *,
+			struct se_node_acl *);
+extern struct iscsi_node_attrib *iscsit_tpg_get_node_attrib(struct isc=
si_session *);
+extern void iscsit_tpg_del_external_nps(struct iscsi_tpg_np *);
+extern struct iscsi_tpg_np *iscsit_tpg_locate_child_np(struct iscsi_tp=
g_np *, int);
+extern struct iscsi_tpg_np *iscsit_tpg_add_network_portal(struct iscsi=
_portal_group *,
+			struct __kernel_sockaddr_storage *, char *, struct iscsi_tpg_np *,
+			int);
+extern int iscsit_tpg_del_network_portal(struct iscsi_portal_group *,
+			struct iscsi_tpg_np *);
+extern int iscsit_tpg_set_initiator_node_queue_depth(struct iscsi_port=
al_group *,
+			unsigned char *, u32, int);
+extern int iscsit_ta_authentication(struct iscsi_portal_group *, u32);
+extern int iscsit_ta_login_timeout(struct iscsi_portal_group *, u32);
+extern int iscsit_ta_netif_timeout(struct iscsi_portal_group *, u32);
+extern int iscsit_ta_generate_node_acls(struct iscsi_portal_group *, u=
32);
+extern int iscsit_ta_default_cmdsn_depth(struct iscsi_portal_group *, =
u32);
+extern int iscsit_ta_cache_dynamic_acls(struct iscsi_portal_group *, u=
32);
+extern int iscsit_ta_demo_mode_write_protect(struct iscsi_portal_group=
 *, u32);
+extern int iscsit_ta_prod_mode_write_protect(struct iscsi_portal_group=
 *, u32);
+
+#endif /* ISCSI_TARGET_TPG_H */
--=20
1.7.5.1
