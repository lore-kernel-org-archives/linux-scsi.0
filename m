From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v2 02/12] iscsi-target: Add primary iSCSI request/response state machine logic
Date: Mon, 14 Mar 2011 04:56:59 -0700
Message-ID: <1300103829-10337-3-git-send-email-nab@linux-iscsi.org>
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

This patch adds iscsi_target.[c,h] containing the main iSCSI Request an=
d
Response PDU state machines and accompanying infrastructure code and
base iscsi_target_core.h include for iscsi_target_mod.  This includes
support for all defined iSCSI operation codes from RFC-3720 Section
10.2.1.2 and primary state machines for per struct iscsi_conn RX/TX
threads.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c      | 5844 ++++++++++++++++++++++=
++++++++
 drivers/target/iscsi/iscsi_target.h      |   49 +
 drivers/target/iscsi/iscsi_target_core.h |  962 +++++
 3 files changed, 6855 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/iscsi/iscsi_target.c
 create mode 100644 drivers/target/iscsi/iscsi_target.h
 create mode 100644 drivers/target/iscsi/iscsi_target_core.h

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi=
/iscsi_target.c
new file mode 100644
index 0000000..6642098
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -0,0 +1,5844 @@
+/*********************************************************************=
**********
+ * This file contains main functions related to the iSCSI Target Core =
Driver.
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
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/version.h>
+#include <generated/utsrelease.h>
+#include <linux/utsname.h>
+#include <linux/kmod.h>
+#include <linux/timer.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/crypto.h>
+#include <asm/unaligned.h>
+#include <net/sock.h>
+#include <net/tcp.h>
+#include <scsi/iscsi_proto.h>
+#include <target/target_core_base.h>
+#include <target/target_core_tmr.h>
+#include <target/target_core_transport.h>
+
+#include "iscsi_debug.h"
+#include "iscsi_target_core.h"
+#include "iscsi_parameters.h"
+#include "iscsi_seq_and_pdu_list.h"
+#include "iscsi_thread_queue.h"
+#include "iscsi_target_configfs.h"
+#include "iscsi_target_datain_values.h"
+#include "iscsi_target_erl0.h"
+#include "iscsi_target_erl1.h"
+#include "iscsi_target_erl2.h"
+#include "iscsi_target_login.h"
+#include "iscsi_target_tmr.h"
+#include "iscsi_target_tpg.h"
+#include "iscsi_target_util.h"
+#include "iscsi_target.h"
+#include "iscsi_target_device.h"
+#include "iscsi_target_stat.h"
+
+struct iscsi_global *iscsi_global;
+
+struct kmem_cache *lio_cmd_cache;
+struct kmem_cache *lio_sess_cache;
+struct kmem_cache *lio_conn_cache;
+struct kmem_cache *lio_qr_cache;
+struct kmem_cache *lio_dr_cache;
+struct kmem_cache *lio_ooo_cache;
+struct kmem_cache *lio_r2t_cache;
+struct kmem_cache *lio_tpg_cache;
+
+static void iscsi_rx_thread_wait_for_TCP(struct iscsi_conn *);
+
+static int iscsi_target_detect(void);
+static int iscsi_target_release(void);
+static int iscsi_handle_immediate_data(struct iscsi_cmd *,
+			unsigned char *buf, u32);
+static inline int iscsi_send_data_in(struct iscsi_cmd *, struct iscsi_=
conn *,
+			struct se_unmap_sg *, int *);
+static inline int iscsi_send_logout_response(struct iscsi_cmd *, struc=
t iscsi_conn *);
+static inline int iscsi_send_nopin_response(struct iscsi_cmd *, struct=
 iscsi_conn *);
+static inline int iscsi_send_status(struct iscsi_cmd *, struct iscsi_c=
onn *);
+static int iscsi_send_task_mgt_rsp(struct iscsi_cmd *, struct iscsi_co=
nn *);
+static int iscsi_send_text_rsp(struct iscsi_cmd *, struct iscsi_conn *=
);
+static int iscsi_send_reject(struct iscsi_cmd *, struct iscsi_conn *);
+static int iscsi_logout_post_handler(struct iscsi_cmd *, struct iscsi_=
conn *);
+
+struct iscsi_tiqn *core_get_tiqn_for_login(unsigned char *buf)
+{
+	struct iscsi_tiqn *tiqn =3D NULL;
+
+	spin_lock(&iscsi_global->tiqn_lock);
+	list_for_each_entry(tiqn, &iscsi_global->g_tiqn_list, tiqn_list) {
+		if (!(strcmp(tiqn->tiqn, buf))) {
+
+			spin_lock(&tiqn->tiqn_state_lock);
+			if (tiqn->tiqn_state =3D=3D TIQN_STATE_ACTIVE) {
+				atomic_inc(&tiqn->tiqn_access_count);
+				spin_unlock(&tiqn->tiqn_state_lock);
+				spin_unlock(&iscsi_global->tiqn_lock);
+				return tiqn;
+			}
+			spin_unlock(&tiqn->tiqn_state_lock);
+		}
+	}
+	spin_unlock(&iscsi_global->tiqn_lock);
+
+	return NULL;
+}
+
+static int core_set_tiqn_shutdown(struct iscsi_tiqn *tiqn)
+{
+	spin_lock(&tiqn->tiqn_state_lock);
+	if (tiqn->tiqn_state =3D=3D TIQN_STATE_ACTIVE) {
+		tiqn->tiqn_state =3D TIQN_STATE_SHUTDOWN;
+		spin_unlock(&tiqn->tiqn_state_lock);
+		return 0;
+	}
+	spin_unlock(&tiqn->tiqn_state_lock);
+
+	return -1;
+}
+
+void core_put_tiqn_for_login(struct iscsi_tiqn *tiqn)
+{
+	spin_lock(&tiqn->tiqn_state_lock);
+	atomic_dec(&tiqn->tiqn_access_count);
+	spin_unlock(&tiqn->tiqn_state_lock);
+	return;
+}
+
+/*
+ * Note that IQN formatting is expected to be done in userspace, and
+ * no explict IQN format checks are done here.
+ */
+struct iscsi_tiqn *core_add_tiqn(unsigned char *buf, int *ret)
+{
+	struct iscsi_tiqn *tiqn =3D NULL;
+
+	if (strlen(buf) > ISCSI_IQN_LEN) {
+		printk(KERN_ERR "Target IQN exceeds %d bytes\n",
+				ISCSI_IQN_LEN);
+		*ret =3D -1;
+		return NULL;
+	}
+
+	spin_lock(&iscsi_global->tiqn_lock);
+	list_for_each_entry(tiqn, &iscsi_global->g_tiqn_list, tiqn_list) {
+		if (!(strcmp(tiqn->tiqn, buf))) {
+			printk(KERN_ERR "Target IQN: %s already exists in Core\n",
+				tiqn->tiqn);
+			spin_unlock(&iscsi_global->tiqn_lock);
+			*ret =3D -1;
+			return NULL;
+		}
+	}
+	spin_unlock(&iscsi_global->tiqn_lock);
+
+	tiqn =3D kzalloc(sizeof(struct iscsi_tiqn), GFP_KERNEL);
+	if (!(tiqn)) {
+		printk(KERN_ERR "Unable to allocate struct iscsi_tiqn\n");
+		*ret =3D -1;
+		return NULL;
+	}
+
+	sprintf(tiqn->tiqn, "%s", buf);
+	INIT_LIST_HEAD(&tiqn->tiqn_list);
+	INIT_LIST_HEAD(&tiqn->tiqn_tpg_list);
+	spin_lock_init(&tiqn->tiqn_state_lock);
+	spin_lock_init(&tiqn->tiqn_tpg_lock);
+	spin_lock_init(&tiqn->sess_err_stats.lock);
+	spin_lock_init(&tiqn->login_stats.lock);
+	spin_lock_init(&tiqn->logout_stats.lock);
+	tiqn->tiqn_index =3D iscsi_get_new_index(ISCSI_INST_INDEX);
+	tiqn->tiqn_state =3D TIQN_STATE_ACTIVE;
+
+	spin_lock(&iscsi_global->tiqn_lock);
+	list_add_tail(&tiqn->tiqn_list, &iscsi_global->g_tiqn_list);
+	spin_unlock(&iscsi_global->tiqn_lock);
+
+	printk(KERN_INFO "CORE[0] - Added iSCSI Target IQN: %s\n", tiqn->tiqn=
);
+
+	return tiqn;
+
+}
+
+int __core_del_tiqn(struct iscsi_tiqn *tiqn)
+{
+	iscsi_disable_tpgs(tiqn);
+	iscsi_remove_tpgs(tiqn);
+
+	spin_lock(&iscsi_global->tiqn_lock);
+	list_del(&tiqn->tiqn_list);
+	spin_unlock(&iscsi_global->tiqn_lock);
+
+	printk(KERN_INFO "CORE[0] - Deleted iSCSI Target IQN: %s\n",
+			tiqn->tiqn);
+	kfree(tiqn);
+
+	return 0;
+}
+
+static void core_wait_for_tiqn(struct iscsi_tiqn *tiqn)
+{
+	/*
+	 * Wait for accesses to said struct iscsi_tiqn to end.
+	 */
+	spin_lock(&tiqn->tiqn_state_lock);
+	while (atomic_read(&tiqn->tiqn_access_count)) {
+		spin_unlock(&tiqn->tiqn_state_lock);
+		msleep(10);
+		spin_lock(&tiqn->tiqn_state_lock);
+	}
+	spin_unlock(&tiqn->tiqn_state_lock);
+}
+
+int core_del_tiqn(struct iscsi_tiqn *tiqn)
+{
+	/*
+	 * core_set_tiqn_shutdown sets tiqn->tiqn_state =3D TIQN_STATE_SHUTDO=
WN
+	 * while holding tiqn->tiqn_state_lock.  This means that all subseque=
nt
+	 * attempts to access this struct iscsi_tiqn will fail from both tran=
sport
+	 * fabric and control code paths.
+	 */
+	if (core_set_tiqn_shutdown(tiqn) < 0) {
+		printk(KERN_ERR "core_set_tiqn_shutdown() failed\n");
+		return -1;
+	}
+
+	core_wait_for_tiqn(tiqn);
+	return __core_del_tiqn(tiqn);
+}
+
+int core_release_tiqns(void)
+{
+	struct iscsi_tiqn *tiqn, *t_tiqn;
+
+	spin_lock(&iscsi_global->tiqn_lock);
+	list_for_each_entry_safe(tiqn, t_tiqn,
+			&iscsi_global->g_tiqn_list, tiqn_list) {
+
+		spin_lock(&tiqn->tiqn_state_lock);
+		if (tiqn->tiqn_state =3D=3D TIQN_STATE_ACTIVE) {
+			tiqn->tiqn_state =3D TIQN_STATE_SHUTDOWN;
+			spin_unlock(&tiqn->tiqn_state_lock);
+			spin_unlock(&iscsi_global->tiqn_lock);
+
+			core_wait_for_tiqn(tiqn);
+			__core_del_tiqn(tiqn);
+
+			spin_lock(&iscsi_global->tiqn_lock);
+			continue;
+		}
+		spin_unlock(&tiqn->tiqn_state_lock);
+
+		spin_lock(&iscsi_global->tiqn_lock);
+	}
+	spin_unlock(&iscsi_global->tiqn_lock);
+
+	return 0;
+}
+
+int core_access_np(struct iscsi_np *np, struct iscsi_portal_group *tpg=
)
+{
+	int ret;
+	/*
+	 * Determine if the network portal is accepting storage traffic.
+	 */
+	spin_lock_bh(&np->np_thread_lock);
+	if (np->np_thread_state !=3D ISCSI_NP_THREAD_ACTIVE) {
+		spin_unlock_bh(&np->np_thread_lock);
+		return -1;
+	}
+	if (np->np_login_tpg) {
+		printk(KERN_ERR "np->np_login_tpg() is not NULL!\n");
+		spin_unlock_bh(&np->np_thread_lock);
+		return -1;
+	}
+	spin_unlock_bh(&np->np_thread_lock);
+	/*
+	 * Determine if the portal group is accepting storage traffic.
+	 */
+	spin_lock_bh(&tpg->tpg_state_lock);
+	if (tpg->tpg_state !=3D TPG_STATE_ACTIVE) {
+		spin_unlock_bh(&tpg->tpg_state_lock);
+		return -1;
+	}
+	spin_unlock_bh(&tpg->tpg_state_lock);
+
+	/*
+	 * Here we serialize access across the TIQN+TPG Tuple.
+	 */
+	ret =3D down_interruptible(&tpg->np_login_sem);
+	if ((ret !=3D 0) || signal_pending(current))
+		return -1;
+
+	spin_lock_bh(&tpg->tpg_state_lock);
+	if (tpg->tpg_state !=3D TPG_STATE_ACTIVE) {
+		spin_unlock_bh(&tpg->tpg_state_lock);
+		return -1;
+	}
+	spin_unlock_bh(&tpg->tpg_state_lock);
+
+	spin_lock_bh(&np->np_thread_lock);
+	np->np_login_tpg =3D tpg;
+	spin_unlock_bh(&np->np_thread_lock);
+
+	return 0;
+}
+
+int core_deaccess_np(struct iscsi_np *np, struct iscsi_portal_group *t=
pg)
+{
+	struct iscsi_tiqn *tiqn =3D tpg->tpg_tiqn;
+
+	spin_lock_bh(&np->np_thread_lock);
+	np->np_login_tpg =3D NULL;
+	spin_unlock_bh(&np->np_thread_lock);
+
+	up(&tpg->np_login_sem);
+
+	if (tiqn)
+		core_put_tiqn_for_login(tiqn);
+
+	return 0;
+}
+
+void *core_get_np_ip(struct iscsi_np *np)
+{
+	return (np->np_flags & NPF_NET_IPV6) ?
+	       (void *)&np->np_ipv6[0] :
+	       (void *)&np->np_ipv4;
+}
+
+struct iscsi_np *core_get_np(
+	void *ip,
+	u16 port,
+	int network_transport)
+{
+	struct iscsi_np *np;
+
+	spin_lock(&iscsi_global->np_lock);
+	list_for_each_entry(np, &iscsi_global->g_np_list, np_list) {
+		spin_lock(&np->np_state_lock);
+		if (atomic_read(&np->np_shutdown)) {
+			spin_unlock(&np->np_state_lock);
+			continue;
+		}
+		spin_unlock(&np->np_state_lock);
+
+		if (!(memcmp(core_get_np_ip(np), ip, np->np_net_size)) &&
+		    (np->np_port =3D=3D port) &&
+		    (np->np_network_transport =3D=3D network_transport)) {
+			spin_unlock(&iscsi_global->np_lock);
+			return np;
+		}
+	}
+	spin_unlock(&iscsi_global->np_lock);
+
+	return NULL;
+}
+
+void *core_get_np_ex_ip(struct iscsi_np_ex *np_ex)
+{
+	return (np_ex->np_ex_net_size =3D=3D IPV6_ADDRESS_SPACE) ?
+	       (void *)&np_ex->np_ex_ipv6 :
+	       (void *)&np_ex->np_ex_ipv4;
+}
+
+int core_del_np_ex(
+	struct iscsi_np *np,
+	void *ip_ex,
+	u16 port_ex,
+	int network_transport)
+{
+	struct iscsi_np_ex *np_ex, *np_ex_t;
+
+	spin_lock(&np->np_ex_lock);
+	list_for_each_entry_safe(np_ex, np_ex_t, &np->np_nex_list, np_ex_list=
) {
+		if (!(memcmp(core_get_np_ex_ip(np_ex), ip_ex,
+				np_ex->np_ex_net_size)) &&
+				(np_ex->np_ex_port =3D=3D port_ex)) {
+			__core_del_np_ex(np, np_ex);
+			spin_unlock(&np->np_ex_lock);
+			return 0;
+		}
+	}
+	spin_unlock(&np->np_ex_lock);
+
+	return -1;
+}
+
+int core_add_np_ex(
+	struct iscsi_np *np,
+	void *ip_ex,
+	u16 port_ex,
+	int net_size)
+{
+	struct iscsi_np_ex *np_ex;
+	unsigned char *ip_buf =3D NULL, *ip_ex_buf =3D NULL;
+	unsigned char buf_ipv4[IPV4_BUF_SIZE], buf_ipv4_ex[IPV4_BUF_SIZE];
+	u32 ip_ex_ipv4;
+
+	np_ex =3D kzalloc(sizeof(struct iscsi_np_ex), GFP_KERNEL);
+	if (!(np_ex)) {
+		printk(KERN_ERR "struct iscsi_np_ex memory allocate failed!\n");
+		return -1;
+	}
+
+	if (net_size =3D=3D IPV6_ADDRESS_SPACE) {
+		ip_buf =3D (unsigned char *)&np->np_ipv6[0];
+		ip_ex_buf =3D ip_ex;
+		snprintf(np_ex->np_ex_ipv6, IPV6_ADDRESS_SPACE,
+				"%s", ip_ex_buf);
+	} else {
+		memset(buf_ipv4, 0, IPV4_BUF_SIZE);
+		memset(buf_ipv4_ex, 0, IPV4_BUF_SIZE);
+		iscsi_ntoa2(buf_ipv4, np->np_ipv4);
+		memcpy((void *)&ip_ex_ipv4, ip_ex, 4);
+		iscsi_ntoa2(buf_ipv4_ex, ip_ex_ipv4);
+		ip_buf =3D &buf_ipv4[0];
+		ip_ex_buf =3D &buf_ipv4_ex[0];
+
+		memcpy((void *)&np_ex->np_ex_ipv4, ip_ex, IPV4_ADDRESS_SPACE);
+	}
+
+	np_ex->np_ex_port =3D port_ex;
+	np_ex->np_ex_net_size =3D net_size;
+	INIT_LIST_HEAD(&np_ex->np_ex_list);
+	spin_lock_init(&np->np_ex_lock);
+
+	spin_lock(&np->np_ex_lock);
+	list_add_tail(&np_ex->np_ex_list, &np->np_nex_list);
+	spin_unlock(&np->np_ex_lock);
+
+	printk(KERN_INFO "CORE[0] - Added Network Portal: Internal %s:%hu"
+		" External %s:%hu on %s on network device: %s\n", ip_buf,
+		np->np_port, ip_ex_buf, port_ex,
+		(np->np_network_transport =3D=3D ISCSI_TCP) ?
+		"TCP" : "SCTP", strlen(np->np_net_dev) ?
+			(char *)np->np_net_dev : "None");
+
+	return 0;
+}
+
+/*
+ * Called with struct iscsi_np->np_ex_lock held.
+ */
+int __core_del_np_ex(
+	struct iscsi_np *np,
+	struct iscsi_np_ex *np_ex)
+{
+	unsigned char *ip_buf =3D NULL, *ip_ex_buf =3D NULL;
+	unsigned char buf_ipv4[IPV4_BUF_SIZE], buf_ipv4_ex[IPV4_BUF_SIZE];
+
+	if (np->np_net_size =3D=3D IPV6_ADDRESS_SPACE) {
+		ip_buf =3D (unsigned char *)&np->np_ipv6[0];
+		ip_ex_buf =3D (unsigned char *)&np_ex->np_ex_ipv6[0];
+	} else {
+		memset(buf_ipv4, 0, IPV4_BUF_SIZE);
+		memset(buf_ipv4_ex, 0, IPV4_BUF_SIZE);
+		iscsi_ntoa2(buf_ipv4, np->np_ipv4);
+		iscsi_ntoa2(buf_ipv4_ex, np_ex->np_ex_ipv4);
+		ip_buf =3D &buf_ipv4[0];
+		ip_ex_buf =3D &buf_ipv4_ex[0];
+	}
+
+	list_del(&np_ex->np_ex_list);
+
+	printk(KERN_INFO "CORE[0] - Removed Network Portal: Internal %s:%hu"
+		" External %s:%hu on %s on network device: %s\n",
+		ip_buf, np->np_port, ip_ex_buf, np_ex->np_ex_port,
+		(np->np_network_transport =3D=3D ISCSI_TCP) ?
+		"TCP" : "SCTP", strlen(np->np_net_dev) ?
+			(char *)np->np_net_dev : "None");
+	kfree(np_ex);
+
+	return 0;
+}
+
+void core_del_np_all_ex(
+	struct iscsi_np *np)
+{
+	struct iscsi_np_ex *np_ex, *np_ex_t;
+
+	spin_lock(&np->np_ex_lock);
+	list_for_each_entry_safe(np_ex, np_ex_t, &np->np_nex_list, np_ex_list=
)
+		__core_del_np_ex(np, np_ex);
+	spin_unlock(&np->np_ex_lock);
+}
+
+static struct iscsi_np *core_add_np_locate(
+	void *ip,
+	void *ip_ex,
+	unsigned char *ip_buf,
+	unsigned char *ip_ex_buf,
+	u16 port,
+	u16 port_ex,
+	int network_transport,
+	int net_size,
+	int *ret)
+{
+	struct iscsi_np *np;
+	struct iscsi_np_ex *np_ex;
+
+	spin_lock(&iscsi_global->np_lock);
+	list_for_each_entry(np, &iscsi_global->g_np_list, np_list) {
+		spin_lock(&np->np_state_lock);
+		if (atomic_read(&np->np_shutdown)) {
+			spin_unlock(&np->np_state_lock);
+			continue;
+		}
+		spin_unlock(&np->np_state_lock);
+
+		if (!(memcmp(core_get_np_ip(np), ip, np->np_net_size)) &&
+		    (np->np_port =3D=3D port) &&
+		    (np->np_network_transport =3D=3D network_transport)) {
+			if (!ip_ex && !port_ex) {
+				printk(KERN_ERR "Network Portal %s:%hu on %s"
+					" already exists, ignoring request.\n",
+					ip_buf, port,
+					(network_transport =3D=3D ISCSI_TCP) ?
+					"TCP" : "SCTP");
+				spin_unlock(&iscsi_global->np_lock);
+				*ret =3D -EEXIST;
+				return NULL;
+			}
+
+			spin_lock(&np->np_ex_lock);
+			list_for_each_entry(np_ex, &np->np_nex_list,
+					np_ex_list) {
+				if (!(memcmp(core_get_np_ex_ip(np_ex), ip_ex,
+				     np_ex->np_ex_net_size)) &&
+				    (np_ex->np_ex_port =3D=3D port_ex)) {
+					printk(KERN_ERR "Network Portal Inter"
+						"nal: %s:%hu External: %s:%hu"
+						" on %s, ignoring request.\n",
+						ip_buf, port,
+						ip_ex_buf, port_ex,
+						(network_transport =3D=3D ISCSI_TCP)
+							? "TCP" : "SCTP");
+					spin_unlock(&np->np_ex_lock);
+					spin_unlock(&iscsi_global->np_lock);
+					*ret =3D -EEXIST;
+					return NULL;
+				}
+			}
+			spin_unlock(&np->np_ex_lock);
+			spin_unlock(&iscsi_global->np_lock);
+
+			*ret =3D core_add_np_ex(np, ip_ex, port_ex,
+						net_size);
+			if (*ret < 0)
+				return NULL;
+
+			*ret =3D 0;
+			return np;
+		}
+	}
+	spin_unlock(&iscsi_global->np_lock);
+
+	*ret =3D 0;
+
+	return NULL;
+}
+
+struct iscsi_np *core_add_np(
+	struct iscsi_np_addr *np_addr,
+	int network_transport,
+	int *ret)
+{
+	struct iscsi_np *np;
+	char *ip_buf =3D NULL;
+	void *ip;
+	unsigned char buf_ipv4[IPV4_BUF_SIZE];
+	int net_size;
+
+	if (np_addr->np_flags & NPF_NET_IPV6) {
+		ip_buf =3D &np_addr->np_ipv6[0];
+		ip =3D (void *)&np_addr->np_ipv6[0];
+		net_size =3D IPV6_ADDRESS_SPACE;
+	} else {
+		ip =3D (void *)&np_addr->np_ipv4;
+		memset(buf_ipv4, 0, IPV4_BUF_SIZE);
+		iscsi_ntoa2(buf_ipv4, np_addr->np_ipv4);
+		ip_buf =3D &buf_ipv4[0];
+		net_size =3D IPV4_ADDRESS_SPACE;
+	}
+
+	np =3D core_add_np_locate(ip, NULL, ip_buf, NULL, np_addr->np_port,
+			0, network_transport, net_size, ret);
+	if ((np))
+		return np;
+
+	if (*ret !=3D 0) {
+		*ret =3D -EINVAL;
+		return NULL;
+	}
+
+	np =3D kzalloc(sizeof(struct iscsi_np), GFP_KERNEL);
+	if (!(np)) {
+		printk(KERN_ERR "Unable to allocate memory for struct iscsi_np\n");
+		*ret =3D -ENOMEM;
+		return NULL;
+	}
+
+	np->np_flags |=3D NPF_IP_NETWORK;
+	if (np_addr->np_flags & NPF_NET_IPV6) {
+		np->np_flags |=3D NPF_NET_IPV6;
+		memcpy(np->np_ipv6, np_addr->np_ipv6, IPV6_ADDRESS_SPACE);
+	} else {
+		np->np_flags |=3D NPF_NET_IPV4;
+		np->np_ipv4 =3D np_addr->np_ipv4;
+	}
+	np->np_port		=3D np_addr->np_port;
+	np->np_network_transport =3D network_transport;
+	np->np_net_size		=3D net_size;
+	np->np_index		=3D iscsi_get_new_index(ISCSI_PORTAL_INDEX);
+	atomic_set(&np->np_shutdown, 0);
+	spin_lock_init(&np->np_state_lock);
+	spin_lock_init(&np->np_thread_lock);
+	spin_lock_init(&np->np_ex_lock);
+	sema_init(&np->np_done_sem, 0);
+	sema_init(&np->np_restart_sem, 0);
+	sema_init(&np->np_shutdown_sem, 0);
+	sema_init(&np->np_start_sem, 0);
+	INIT_LIST_HEAD(&np->np_list);
+	INIT_LIST_HEAD(&np->np_nex_list);
+
+	kernel_thread(iscsi_target_login_thread, np, 0);
+
+	down(&np->np_start_sem);
+
+	spin_lock_bh(&np->np_thread_lock);
+	if (np->np_thread_state !=3D ISCSI_NP_THREAD_ACTIVE) {
+		spin_unlock_bh(&np->np_thread_lock);
+		printk(KERN_ERR "Unable to start login thread for iSCSI Network"
+			" Portal %s:%hu\n", ip_buf, np->np_port);
+		kfree(np);
+		*ret =3D -EADDRINUSE;
+		return NULL;
+	}
+	spin_unlock_bh(&np->np_thread_lock);
+
+	spin_lock(&iscsi_global->np_lock);
+	list_add_tail(&np->np_list, &iscsi_global->g_np_list);
+	spin_unlock(&iscsi_global->np_lock);
+
+	printk(KERN_INFO "CORE[0] - Added Network Portal: %s:%hu on %s on"
+		" network device: %s\n", ip_buf, np->np_port,
+		(np->np_network_transport =3D=3D ISCSI_TCP) ?
+		"TCP" : "SCTP", (strlen(np->np_net_dev)) ?
+		(char *)np->np_net_dev : "None");
+
+	*ret =3D 0;
+	return np;
+}
+
+int core_reset_np_thread(
+	struct iscsi_np *np,
+	struct iscsi_tpg_np *tpg_np,
+	struct iscsi_portal_group *tpg,
+	int shutdown)
+{
+	spin_lock_bh(&np->np_thread_lock);
+	if (tpg && tpg_np) {
+		/*
+		 * The reset operation need only be performed when the
+		 * passed struct iscsi_portal_group has a login in progress
+		 * to one of the network portals.
+		 */
+		if (tpg_np->tpg_np->np_login_tpg !=3D tpg) {
+			spin_unlock_bh(&np->np_thread_lock);
+			return 0;
+		}
+	}
+	if (np->np_thread_state =3D=3D ISCSI_NP_THREAD_INACTIVE) {
+		spin_unlock_bh(&np->np_thread_lock);
+		return 0;
+	}
+
+	np->np_thread_state =3D ISCSI_NP_THREAD_RESET;
+	if (shutdown)
+		atomic_set(&np->np_shutdown, 1);
+
+	if (np->np_thread) {
+		spin_unlock_bh(&np->np_thread_lock);
+		send_sig(SIGKILL, np->np_thread, 1);
+		down(&np->np_restart_sem);
+		spin_lock_bh(&np->np_thread_lock);
+	}
+	spin_unlock_bh(&np->np_thread_lock);
+
+	return 0;
+}
+
+int core_del_np_thread(struct iscsi_np *np)
+{
+	spin_lock_bh(&np->np_thread_lock);
+	np->np_thread_state =3D ISCSI_NP_THREAD_SHUTDOWN;
+	atomic_set(&np->np_shutdown, 1);
+	if (np->np_thread) {
+		send_sig(SIGKILL, np->np_thread, 1);
+		spin_unlock_bh(&np->np_thread_lock);
+		up(&np->np_shutdown_sem);
+		down(&np->np_done_sem);
+		return 0;
+	}
+	spin_unlock_bh(&np->np_thread_lock);
+
+	return 0;
+}
+
+int core_del_np_comm(struct iscsi_np *np)
+{
+	if (!np->np_socket)
+		return 0;
+
+	/*
+	 * Some network transports set their own FILEIO, see
+	 * if we need to free any additional allocated resources.
+	 */
+	if (np->np_flags & NPF_SCTP_STRUCT_FILE) {
+		kfree(np->np_socket->file);
+		np->np_socket->file =3D NULL;
+	}
+
+	sock_release(np->np_socket);
+	return 0;
+}
+
+int core_del_np(struct iscsi_np *np)
+{
+	unsigned char *ip =3D NULL;
+	unsigned char buf_ipv4[IPV4_BUF_SIZE];
+
+	core_del_np_thread(np);
+	core_del_np_comm(np);
+	core_del_np_all_ex(np);
+
+	spin_lock(&iscsi_global->np_lock);
+	list_del(&np->np_list);
+	spin_unlock(&iscsi_global->np_lock);
+
+	if (np->np_net_size =3D=3D IPV6_ADDRESS_SPACE) {
+		ip =3D &np->np_ipv6[0];
+	} else {
+		memset(buf_ipv4, 0, IPV4_BUF_SIZE);
+		iscsi_ntoa2(buf_ipv4, np->np_ipv4);
+		ip =3D &buf_ipv4[0];
+	}
+
+	printk(KERN_INFO "CORE[0] - Removed Network Portal: %s:%hu on %s on"
+		" network device: %s\n", ip, np->np_port,
+		(np->np_network_transport =3D=3D ISCSI_TCP) ?
+		"TCP" : "SCTP",  (strlen(np->np_net_dev)) ?
+		(char *)np->np_net_dev : "None");
+
+	kfree(np);
+	return 0;
+}
+
+void core_reset_nps(void)
+{
+	struct iscsi_np *np, *t_np;
+
+	spin_lock(&iscsi_global->np_lock);
+	list_for_each_entry_safe(np, t_np, &iscsi_global->g_np_list, np_list)=
 {
+		spin_unlock(&iscsi_global->np_lock);
+		core_reset_np_thread(np, NULL, NULL, 1);
+		spin_lock(&iscsi_global->np_lock);
+	}
+	spin_unlock(&iscsi_global->np_lock);
+}
+
+void core_release_nps(void)
+{
+	struct iscsi_np *np, *t_np;
+
+	spin_lock(&iscsi_global->np_lock);
+	list_for_each_entry_safe(np, t_np, &iscsi_global->g_np_list, np_list)=
 {
+		spin_unlock(&iscsi_global->np_lock);
+		core_del_np(np);
+		spin_lock(&iscsi_global->np_lock);
+	}
+	spin_unlock(&iscsi_global->np_lock);
+}
+
+/* iSCSI mib table index for iscsi_target_stat.c */
+struct iscsi_index_table iscsi_index_table;
+
+/*
+ * Initialize the index table for allocating unique row indexes to var=
ious mib
+ * tables
+ */
+static void init_iscsi_index_table(void)
+{
+	memset(&iscsi_index_table, 0, sizeof(iscsi_index_table));
+	spin_lock_init(&iscsi_index_table.lock);
+}
+
+/*
+ * Allocate a new row index for the entry type specified
+ */
+u32 iscsi_get_new_index(iscsi_index_t type)
+{
+	u32 new_index;
+
+	if ((type < 0) || (type >=3D INDEX_TYPE_MAX)) {
+		printk(KERN_ERR "Invalid index type %d\n", type);
+		return -1;
+	}
+
+	spin_lock(&iscsi_index_table.lock);
+	new_index =3D ++iscsi_index_table.iscsi_mib_index[type];
+	if (new_index =3D=3D 0)
+		new_index =3D ++iscsi_index_table.iscsi_mib_index[type];
+	spin_unlock(&iscsi_index_table.lock);
+
+	return new_index;
+}
+
+/* init_iscsi_target():
+ *
+ * This function is called during module initialization to setup struc=
t iscsi_global.
+ */
+static int init_iscsi_global(struct iscsi_global *global)
+{
+	memset(global, 0, sizeof(struct iscsi_global));
+	sema_init(&global->auth_sem, 1);
+	sema_init(&global->auth_id_sem, 1);
+	spin_lock_init(&global->active_ts_lock);
+	spin_lock_init(&global->check_thread_lock);
+	spin_lock_init(&global->discovery_lock);
+	spin_lock_init(&global->inactive_ts_lock);
+	spin_lock_init(&global->login_thread_lock);
+	spin_lock_init(&global->np_lock);
+	spin_lock_init(&global->tiqn_lock);
+	spin_lock_init(&global->ts_bitmap_lock);
+	spin_lock_init(&global->g_tpg_lock);
+	INIT_LIST_HEAD(&global->g_tiqn_list);
+	INIT_LIST_HEAD(&global->g_tpg_list);
+	INIT_LIST_HEAD(&global->g_np_list);
+	INIT_LIST_HEAD(&global->active_ts_list);
+	INIT_LIST_HEAD(&global->inactive_ts_list);
+
+	return 0;
+}
+
+/*	iscsi_target_detect():
+ *
+ *	This function is called upon module_init and does the following
+ *	actions in said order:
+ *
+ *	0) Allocates and initializes the struct iscsi_global structure.
+ *	1) Registers the character device for the IOCTL.
+ *	2) Registers /proc filesystem entries.
+ *	3) Creates a lookaside cache entry for the struct iscsi_cmd and
+ *	   struct iscsi_conn structures.
+ *	4) Allocates threads to handle login requests.
+ *	5) Allocates thread_sets for the thread_set queue.
+ *	6) Creates the default list of iSCSI parameters.
+ *	7) Create server socket and spawn iscsi_target_server_thread to
+ *	   accept connections.
+ *
+ *	Parameters:	Nothing.
+ *	Returns:	0 on success, -1 on error.
+ */
+/*	FIXME:  getaddrinfo for IPv6 will go here.
+ */
+static int iscsi_target_detect(void)
+{
+	int ret =3D 0;
+
+	printk(KERN_INFO "RTS Linux-iSCSI fabric module "ISCSI_VERSION" on"
+		" %s/%s on "UTS_RELEASE"\n", utsname()->sysname,
+		utsname()->machine);
+	/*
+	 * Clear out the struct kmem_cache pointers
+	 */
+	lio_cmd_cache =3D NULL;
+	lio_sess_cache =3D NULL;
+	lio_conn_cache =3D NULL;
+	lio_qr_cache =3D NULL;
+	lio_dr_cache =3D NULL;
+	lio_ooo_cache =3D NULL;
+	lio_r2t_cache =3D NULL;
+	lio_tpg_cache =3D NULL;
+
+	iscsi_global =3D kzalloc(sizeof(struct iscsi_global), GFP_KERNEL);
+	if (!(iscsi_global)) {
+		printk(KERN_ERR "Unable to allocate memory for iscsi_global\n");
+		return -1;
+	}
+	init_iscsi_index_table();
+
+	if (init_iscsi_global(iscsi_global) < 0) {
+		kfree(iscsi_global);
+		return -1;
+	}
+
+	iscsi_target_register_configfs();
+	iscsi_thread_set_init();
+
+	if (iscsi_allocate_thread_sets(TARGET_THREAD_SET_COUNT) !=3D
+			TARGET_THREAD_SET_COUNT) {
+		printk(KERN_ERR "iscsi_allocate_thread_sets() returned"
+			" unexpected value!\n");
+		ret =3D -1;
+		goto out;
+	}
+
+	lio_cmd_cache =3D kmem_cache_create("lio_cmd_cache",
+			sizeof(struct iscsi_cmd), __alignof__(struct iscsi_cmd),
+			0, NULL);
+	if (!(lio_cmd_cache)) {
+		printk(KERN_ERR "Unable to kmem_cache_create() for"
+				" lio_cmd_cache\n");
+		goto out;
+	}
+
+	lio_sess_cache =3D kmem_cache_create("lio_sess_cache",
+			sizeof(struct iscsi_session), __alignof__(struct iscsi_session),
+			0, NULL);
+	if (!(lio_sess_cache)) {
+		printk(KERN_ERR "Unable to kmem_cache_create() for"
+				" lio_sess_cache\n");
+		goto out;
+	}
+
+	lio_conn_cache =3D kmem_cache_create("lio_conn_cache",
+			sizeof(struct iscsi_conn), __alignof__(struct iscsi_conn),
+			0, NULL);
+	if (!(lio_conn_cache)) {
+		printk(KERN_ERR "Unable to kmem_cache_create() for"
+				" lio_conn_cache\n");
+		goto out;
+	}
+
+	lio_qr_cache =3D kmem_cache_create("lio_qr_cache",
+			sizeof(struct iscsi_queue_req),
+			__alignof__(struct iscsi_queue_req), 0, NULL);
+	if (!(lio_qr_cache)) {
+		printk(KERN_ERR "nable to kmem_cache_create() for"
+				" lio_qr_cache\n");
+		goto out;
+	}
+
+	lio_dr_cache =3D kmem_cache_create("lio_dr_cache",
+			sizeof(struct iscsi_datain_req),
+			__alignof__(struct iscsi_datain_req), 0, NULL);
+	if (!(lio_dr_cache)) {
+		printk(KERN_ERR "Unable to kmem_cache_create() for"
+				" lio_dr_cache\n");
+		goto out;
+	}
+
+	lio_ooo_cache =3D kmem_cache_create("lio_ooo_cache",
+			sizeof(struct iscsi_ooo_cmdsn),
+			__alignof__(struct iscsi_ooo_cmdsn), 0, NULL);
+	if (!(lio_ooo_cache)) {
+		printk(KERN_ERR "Unable to kmem_cache_create() for"
+				" lio_ooo_cache\n");
+		goto out;
+	}
+
+	lio_r2t_cache =3D kmem_cache_create("lio_r2t_cache",
+			sizeof(struct iscsi_r2t), __alignof__(struct iscsi_r2t),
+			0, NULL);
+	if (!(lio_r2t_cache)) {
+		printk(KERN_ERR "Unable to kmem_cache_create() for"
+				" lio_r2t_cache\n");
+		goto out;
+	}
+
+	lio_tpg_cache =3D kmem_cache_create("lio_tpg_cache",
+			sizeof(struct iscsi_portal_group),
+			__alignof__(struct iscsi_portal_group),
+			0, NULL);
+	if (!(lio_tpg_cache)) {
+		printk(KERN_ERR "Unable to kmem_cache_create() for"
+			" struct iscsi_portal_group\n");
+		goto out;
+	}
+
+	if (core_load_discovery_tpg() < 0)
+		goto out;
+
+	printk("Loading Complete.\n");
+
+	return ret;
+out:
+	if (lio_cmd_cache)
+		kmem_cache_destroy(lio_cmd_cache);
+	if (lio_sess_cache)
+		kmem_cache_destroy(lio_sess_cache);
+	if (lio_conn_cache)
+		kmem_cache_destroy(lio_conn_cache);
+	if (lio_qr_cache)
+		kmem_cache_destroy(lio_qr_cache);
+	if (lio_dr_cache)
+		kmem_cache_destroy(lio_dr_cache);
+	if (lio_ooo_cache)
+		kmem_cache_destroy(lio_ooo_cache);
+	if (lio_r2t_cache)
+		kmem_cache_destroy(lio_r2t_cache);
+	if (lio_tpg_cache)
+		kmem_cache_destroy(lio_tpg_cache);
+	iscsi_deallocate_thread_sets();
+	iscsi_thread_set_free();
+	iscsi_target_deregister_configfs();
+	kfree(iscsi_global);
+	iscsi_global =3D NULL;
+
+	return -1;
+}
+
+static int iscsi_target_release(void)
+{
+	int ret =3D 0;
+
+	if (!iscsi_global)
+		return ret;
+
+	core_reset_nps();
+	iscsi_disable_all_tpgs();
+	iscsi_deallocate_thread_sets();
+	iscsi_thread_set_free();
+	iscsi_remove_all_tpgs();
+	core_release_nps();
+	core_release_discovery_tpg();
+	core_release_tiqns();
+	kmem_cache_destroy(lio_cmd_cache);
+	kmem_cache_destroy(lio_sess_cache);
+	kmem_cache_destroy(lio_conn_cache);
+	kmem_cache_destroy(lio_qr_cache);
+	kmem_cache_destroy(lio_dr_cache);
+	kmem_cache_destroy(lio_ooo_cache);
+	kmem_cache_destroy(lio_r2t_cache);
+	kmem_cache_destroy(lio_tpg_cache);
+
+	iscsi_target_deregister_configfs();
+
+	kfree(iscsi_global);
+	printk(KERN_INFO "Unloading Complete.\n");
+
+	return ret;
+}
+
+char *iscsi_get_fabric_name(void)
+{
+	return "iSCSI";
+}
+
+struct iscsi_cmd *iscsi_get_cmd(struct se_cmd *se_cmd)
+{
+	struct iscsi_cmd *cmd =3D container_of(se_cmd, struct iscsi_cmd, se_c=
md);
+
+	return cmd;
+}
+
+u32 iscsi_get_task_tag(struct se_cmd *se_cmd)
+{
+	struct iscsi_cmd *cmd =3D container_of(se_cmd, struct iscsi_cmd, se_c=
md);
+
+	return cmd->init_task_tag;
+}
+
+int iscsi_get_cmd_state(struct se_cmd *se_cmd)
+{
+	struct iscsi_cmd *cmd =3D container_of(se_cmd, struct iscsi_cmd, se_c=
md);
+
+	return cmd->i_state;
+}
+
+void iscsi_new_cmd_failure(struct se_cmd *se_cmd)
+{
+	struct iscsi_cmd *cmd =3D iscsi_get_cmd(se_cmd);
+
+	if (cmd->immediate_data || cmd->unsolicited_data)
+		up(&cmd->unsolicited_data_sem);
+}
+
+int iscsi_is_state_remove(struct se_cmd *se_cmd)
+{
+	struct iscsi_cmd *cmd =3D iscsi_get_cmd(se_cmd);
+
+	return (cmd->i_state =3D=3D ISTATE_REMOVE);
+}
+
+int lio_sess_logged_in(struct se_session *se_sess)
+{
+	struct iscsi_session *sess =3D (struct iscsi_session *)se_sess->fabri=
c_sess_ptr;
+	int ret;
+
+	/*
+	 * Called with spin_lock_bh(&se_global->se_tpg_lock); and
+	 * spin_lock(&se_tpg->session_lock); held.
+	 */
+	spin_lock(&sess->conn_lock);
+	ret =3D (sess->session_state !=3D TARG_SESS_STATE_LOGGED_IN);
+	spin_unlock(&sess->conn_lock);
+
+	return ret;
+}
+
+u32 lio_sess_get_index(struct se_session *se_sess)
+{
+	struct iscsi_session *sess =3D (struct iscsi_session *)se_sess->fabri=
c_sess_ptr;
+
+	return sess->session_index;
+}
+
+u32 lio_sess_get_initiator_sid(
+	struct se_session *se_sess,
+	unsigned char *buf,
+	u32 size)
+{
+	struct iscsi_session *sess =3D (struct iscsi_session *)se_sess->fabri=
c_sess_ptr;
+	/*
+	 * iSCSI Initiator Session Identifier from RFC-3720.
+	 */
+	return snprintf(buf, size, "%02x%02x%02x%02x%02x%02x",
+		sess->isid[0], sess->isid[1], sess->isid[2],
+		sess->isid[3], sess->isid[4], sess->isid[5]);
+}
+
+/*	iscsi_add_nopin():
+ *
+ *
+ */
+int iscsi_add_nopin(
+	struct iscsi_conn *conn,
+	int want_response)
+{
+	u8 state;
+	struct iscsi_cmd *cmd;
+
+	cmd =3D iscsi_allocate_cmd(conn);
+	if (!(cmd))
+		return -1;
+
+	cmd->iscsi_opcode =3D ISCSI_OP_NOOP_IN;
+	state =3D (want_response) ? ISTATE_SEND_NOPIN_WANT_RESPONSE :
+			ISTATE_SEND_NOPIN_NO_RESPONSE;
+	cmd->init_task_tag =3D 0xFFFFFFFF;
+	spin_lock_bh(&SESS(conn)->ttt_lock);
+	cmd->targ_xfer_tag =3D (want_response) ? SESS(conn)->targ_xfer_tag++ =
:
+			0xFFFFFFFF;
+	if (want_response && (cmd->targ_xfer_tag =3D=3D 0xFFFFFFFF))
+		cmd->targ_xfer_tag =3D SESS(conn)->targ_xfer_tag++;
+	spin_unlock_bh(&SESS(conn)->ttt_lock);
+
+	iscsi_attach_cmd_to_queue(conn, cmd);
+	if (want_response)
+		iscsi_start_nopin_response_timer(conn);
+	iscsi_add_cmd_to_immediate_queue(cmd, conn, state);
+
+	return 0;
+}
+
+int iscsi_add_reject(
+	u8 reason,
+	int fail_conn,
+	unsigned char *buf,
+	struct iscsi_conn *conn)
+{
+	struct iscsi_cmd *cmd;
+	struct iscsi_reject *hdr;
+	int ret;
+
+	cmd =3D iscsi_allocate_cmd(conn);
+	if (!(cmd))
+		return -1;
+
+	cmd->iscsi_opcode =3D ISCSI_OP_REJECT;
+	if (fail_conn)
+		cmd->cmd_flags |=3D ICF_REJECT_FAIL_CONN;
+
+	hdr	=3D (struct iscsi_reject *) cmd->pdu;
+	hdr->reason =3D reason;
+
+	cmd->buf_ptr =3D kzalloc(ISCSI_HDR_LEN, GFP_ATOMIC);
+	if (!(cmd->buf_ptr)) {
+		printk(KERN_ERR "Unable to allocate memory for cmd->buf_ptr\n");
+		__iscsi_release_cmd_to_pool(cmd, SESS(conn));
+		return -1;
+	}
+	memcpy(cmd->buf_ptr, buf, ISCSI_HDR_LEN);
+
+	iscsi_attach_cmd_to_queue(conn, cmd);
+
+	cmd->i_state =3D ISTATE_SEND_REJECT;
+	iscsi_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
+
+	ret =3D down_interruptible(&cmd->reject_sem);
+	if (ret !=3D 0)
+		return -1;
+
+	return (!fail_conn) ? 0 : -1;
+}
+
+/*	iscsi_add_reject_from_cmd():
+ *
+ *
+ */
+int iscsi_add_reject_from_cmd(
+	u8 reason,
+	int fail_conn,
+	int add_to_conn,
+	unsigned char *buf,
+	struct iscsi_cmd *cmd)
+{
+	struct iscsi_conn *conn;
+	struct iscsi_reject *hdr;
+	int ret;
+
+	if (!CONN(cmd)) {
+		printk(KERN_ERR "cmd->conn is NULL for ITT: 0x%08x\n",
+				cmd->init_task_tag);
+		return -1;
+	}
+	conn =3D CONN(cmd);
+
+	cmd->iscsi_opcode =3D ISCSI_OP_REJECT;
+	if (fail_conn)
+		cmd->cmd_flags |=3D ICF_REJECT_FAIL_CONN;
+
+	hdr	=3D (struct iscsi_reject *) cmd->pdu;
+	hdr->reason =3D reason;
+
+	cmd->buf_ptr =3D kzalloc(ISCSI_HDR_LEN, GFP_ATOMIC);
+	if (!(cmd->buf_ptr)) {
+		printk(KERN_ERR "Unable to allocate memory for cmd->buf_ptr\n");
+		__iscsi_release_cmd_to_pool(cmd, SESS(conn));
+		return -1;
+	}
+	memcpy(cmd->buf_ptr, buf, ISCSI_HDR_LEN);
+
+	if (add_to_conn)
+		iscsi_attach_cmd_to_queue(conn, cmd);
+
+	cmd->i_state =3D ISTATE_SEND_REJECT;
+	iscsi_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
+
+	ret =3D down_interruptible(&cmd->reject_sem);
+	if (ret !=3D 0)
+		return -1;
+
+	return (!fail_conn) ? 0 : -1;
+}
+
+/* #define iscsi_calculate_map_segment_DEBUG */
+#ifdef iscsi_calculate_map_segment_DEBUG
+#define DEBUG_MAP_SEGMENTS(buf...) PYXPRINT(buf)
+#else
+#define DEBUG_MAP_SEGMENTS(buf...)
+#endif
+
+static inline void iscsi_calculate_map_segment(
+	u32 *data_length,
+	struct se_offset_map *lm)
+{
+	u32 sg_offset =3D 0;
+	struct se_mem *se_mem =3D lm->map_se_mem;
+
+	DEBUG_MAP_SEGMENTS(" START Mapping se_mem: %p, Length: %d"
+		"  Remaining iSCSI Data: %u\n", se_mem, se_mem->se_len,
+		*data_length);
+	/*
+	 * Still working on pages in the current struct se_mem.
+	 */
+	if (!lm->map_reset) {
+		lm->iovec_length =3D (lm->sg_length > PAGE_SIZE) ?
+					PAGE_SIZE : lm->sg_length;
+		if (*data_length < lm->iovec_length) {
+			DEBUG_MAP_SEGMENTS("LINUX_MAP: Reset lm->iovec_length"
+				" to %d\n", *data_length);
+
+			lm->iovec_length =3D *data_length;
+		}
+		lm->iovec_base =3D page_address(lm->sg_page) + sg_offset;
+
+		DEBUG_MAP_SEGMENTS("LINUX_MAP: Set lm->iovec_base to %p from"
+			" lm->sg_page: %p\n", lm->iovec_base, lm->sg_page);
+		return;
+	}
+
+	/*
+	 * First run of an iscsi_linux_map_t.
+	 *
+	 * OR:
+	 *
+	 * Mapped all of the pages in the current scatterlist, move
+	 * on to the next one.
+	 */
+	lm->map_reset =3D 0;
+	sg_offset =3D se_mem->se_off;
+	lm->sg_page =3D se_mem->se_page;
+	lm->sg_length =3D se_mem->se_len;
+
+	DEBUG_MAP_SEGMENTS("LINUX_MAP1[%p]: Starting to se_mem->se_len: %u,"
+		" se_mem->se_off: %u, se_mem->se_page: %p\n", se_mem,
+		se_mem->se_len, se_mem->se_off, se_mem->se_page);
+	/*
+	 * Get the base and length of the current page for use with the iovec=
=2E
+	 */
+recalc:
+	lm->iovec_length =3D (lm->sg_length > (PAGE_SIZE - sg_offset)) ?
+			   (PAGE_SIZE - sg_offset) : lm->sg_length;
+
+	DEBUG_MAP_SEGMENTS("LINUX_MAP: lm->iovec_length: %u, lm->sg_length: %=
u,"
+		" sg_offset: %u\n", lm->iovec_length, lm->sg_length, sg_offset);
+	/*
+	 * See if there is any iSCSI offset we need to deal with.
+	 */
+	if (!lm->current_offset) {
+		lm->iovec_base =3D page_address(lm->sg_page) + sg_offset;
+
+		if (*data_length < lm->iovec_length) {
+			DEBUG_MAP_SEGMENTS("LINUX_MAP1[%p]: Reset"
+				" lm->iovec_length to %d\n", se_mem,
+				*data_length);
+			lm->iovec_length =3D *data_length;
+		}
+
+		DEBUG_MAP_SEGMENTS("LINUX_MAP2[%p]: No current_offset,"
+			" set iovec_base to %p and set Current Page to %p\n",
+			se_mem, lm->iovec_base, lm->sg_page);
+
+		return;
+	}
+
+	/*
+	 * We know the iSCSI offset is in the next page of the current
+	 * scatterlist.  Increase the lm->sg_page pointer and try again.
+	 */
+	if (lm->current_offset >=3D lm->iovec_length) {
+		DEBUG_MAP_SEGMENTS("LINUX_MAP3[%p]: Next Page:"
+			" lm->current_offset: %u, iovec_length: %u"
+			" sg_offset: %u\n", se_mem, lm->current_offset,
+			lm->iovec_length, sg_offset);
+
+		lm->current_offset -=3D lm->iovec_length;
+		lm->sg_length -=3D lm->iovec_length;
+		lm->sg_page++;
+		sg_offset =3D 0;
+
+		DEBUG_MAP_SEGMENTS("LINUX_MAP3[%p]: ** Skipping to Next Page,"
+			" updated values: lm->current_offset: %u\n", se_mem,
+			lm->current_offset);
+
+		goto recalc;
+	}
+
+	/*
+	 * The iSCSI offset is in the current page, increment the iovec
+	 * base and reduce iovec length.
+	 */
+	lm->iovec_base =3D page_address(lm->sg_page);
+
+	DEBUG_MAP_SEGMENTS("LINUX_MAP4[%p]: Set lm->iovec_base to %p\n", se_m=
em,
+			lm->iovec_base);
+
+	lm->iovec_base +=3D sg_offset;
+	lm->iovec_base +=3D lm->current_offset;
+	DEBUG_MAP_SEGMENTS("****** the OLD lm->iovec_length: %u lm->sg_length=
:"
+		" %u\n", lm->iovec_length, lm->sg_length);
+
+	if ((lm->iovec_length - lm->current_offset) < *data_length)
+		lm->iovec_length -=3D lm->current_offset;
+	else
+		lm->iovec_length =3D *data_length;
+
+	if ((lm->sg_length - lm->current_offset) < *data_length)
+		lm->sg_length -=3D lm->current_offset;
+	else
+		lm->sg_length =3D *data_length;
+
+	lm->current_offset =3D 0;
+
+	DEBUG_MAP_SEGMENTS("****** the NEW lm->iovec_length %u lm->sg_length:=
"
+		" %u\n", lm->iovec_length, lm->sg_length);
+}
+
+/* #define iscsi_linux_get_iscsi_offset_DEBUG */
+#ifdef iscsi_linux_get_iscsi_offset_DEBUG
+#define DEBUG_GET_ISCSI_OFFSET(buf...) PYXPRINT(buf)
+#else
+#define DEBUG_GET_ISCSI_OFFSET(buf...)
+#endif
+
+static int get_iscsi_offset(
+	struct se_offset_map *lmap,
+	struct se_unmap_sg *usg)
+{
+	u32 current_length =3D 0, current_iscsi_offset =3D lmap->iscsi_offset=
;
+	u32 total_offset =3D 0;
+	struct se_cmd *cmd =3D usg->se_cmd;
+	struct se_mem *se_mem;
+
+	list_for_each_entry(se_mem, T_TASK(cmd)->t_mem_list, se_list)
+		break;
+
+	if (!se_mem) {
+		printk(KERN_ERR "Unable to locate se_mem from"
+				" T_TASK(cmd)->t_mem_list\n");
+		return -1;
+	}
+
+	/*
+	 * Locate the current offset from the passed iSCSI Offset.
+	 */
+	while (lmap->iscsi_offset !=3D current_length) {
+		/*
+		 * The iSCSI Offset is within the current struct se_mem.
+		 *
+		 * Or:
+		 *
+		 * The iSCSI Offset is outside of the current struct se_mem.
+		 * Recalculate the values and obtain the next struct se_mem pointer.
+		 */
+		total_offset +=3D se_mem->se_len;
+
+		DEBUG_GET_ISCSI_OFFSET("ISCSI_OFFSET: current_length: %u,"
+			" total_offset: %u, sg->length: %u\n",
+			current_length, total_offset, se_mem->se_len);
+
+		if (total_offset > lmap->iscsi_offset) {
+			current_length +=3D current_iscsi_offset;
+			lmap->orig_offset =3D lmap->current_offset =3D
+				usg->t_offset =3D current_iscsi_offset;
+			DEBUG_GET_ISCSI_OFFSET("ISCSI_OFFSET: Within Current"
+				" struct se_mem: %p, current_length incremented to"
+				" %u\n", se_mem, current_length);
+		} else {
+			current_length +=3D se_mem->se_len;
+			current_iscsi_offset -=3D se_mem->se_len;
+
+			DEBUG_GET_ISCSI_OFFSET("ISCSI_OFFSET: Outside of"
+				" Current se_mem: %p, current_length"
+				" incremented to %u and current_iscsi_offset"
+				" decremented to %u\n", se_mem, current_length,
+				current_iscsi_offset);
+
+			list_for_each_entry_continue(se_mem,
+					T_TASK(cmd)->t_mem_list, se_list)
+				break;
+
+			if (!se_mem) {
+				printk(KERN_ERR "Unable to locate struct se_mem\n");
+				return -1;
+			}
+		}
+	}
+	lmap->map_orig_se_mem =3D se_mem;
+	usg->cur_se_mem =3D se_mem;
+
+	return 0;
+}
+
+/* #define iscsi_OS_set_SG_iovec_ptrs_DEBUG */
+#ifdef iscsi_OS_set_SG_iovec_ptrs_DEBUG
+#define DEBUG_IOVEC_SCATTERLISTS(buf...) PYXPRINT(buf)
+
+static void iscsi_check_iovec_map(
+	u32 iovec_count,
+	u32 map_length,
+	struct se_map_sg *map_sg,
+	struct se_unmap_sg *unmap_sg)
+{
+	u32 i, iovec_map_length =3D 0;
+	struct se_cmd *cmd =3D map_sg->se_cmd;
+	struct iovec *iov =3D map_sg->iov;
+	struct se_mem *se_mem;
+
+	for (i =3D 0; i < iovec_count; i++)
+		iovec_map_length +=3D iov[i].iov_len;
+
+	if (iovec_map_length =3D=3D map_length)
+		return;
+
+	printk(KERN_INFO "Calculated iovec_map_length: %u does not match pass=
ed"
+		" map_length: %u\n", iovec_map_length, map_length);
+	printk(KERN_INFO "ITT: 0x%08x data_length: %u data_direction %d\n",
+		CMD_TFO(cmd)->get_task_tag(cmd), cmd->data_length,
+		cmd->data_direction);
+
+	iovec_map_length =3D 0;
+
+	for (i =3D 0; i < iovec_count; i++) {
+		printk(KERN_INFO "iov[%d].iov_[base,len]: %p / %u bytes------"
+			"-->\n", i, iov[i].iov_base, iov[i].iov_len);
+
+		printk(KERN_INFO "iovec_map_length from %u to %u\n",
+			iovec_map_length, iovec_map_length + iov[i].iov_len);
+		iovec_map_length +=3D iov[i].iov_len;
+
+		printk(KERN_INFO "XXXX_map_length from %u to %u\n", map_length,
+				(map_length - iov[i].iov_len));
+		map_length -=3D iov[i].iov_len;
+	}
+
+	list_for_each_entry(se_mem, T_TASK(cmd)->t_mem_list, se_list) {
+		printk(KERN_INFO "se_mem[%p]: offset: %u length: %u\n",
+			se_mem, se_mem->se_off, se_mem->se_len);
+	}
+
+	BUG();
+}
+
+#else
+#define DEBUG_IOVEC_SCATTERLISTS(buf...)
+#define iscsi_check_iovec_map(a, b, c, d)
+#endif
+
+static int iscsi_set_iovec_ptrs(
+	struct se_map_sg *map_sg,
+	struct se_unmap_sg *unmap_sg)
+{
+	u32 i =3D 0 /* For iovecs */, j =3D 0 /* For scatterlists */;
+#ifdef iscsi_OS_set_SG_iovec_ptrs_DEBUG
+	u32 orig_map_length =3D map_sg->data_length;
+#endif
+	struct se_cmd *cmd =3D map_sg->se_cmd;
+	struct iscsi_cmd *i_cmd =3D container_of(cmd, struct iscsi_cmd, se_cm=
d);
+	struct se_offset_map *lmap =3D &unmap_sg->lmap;
+	struct iovec *iov =3D map_sg->iov;
+
+	/*
+	 * Used for non scatterlist operations, assume a single iovec.
+	 */
+	if (!T_TASK(cmd)->t_tasks_se_num) {
+		DEBUG_IOVEC_SCATTERLISTS("ITT: 0x%08x No struct se_mem elements"
+			" present\n", CMD_TFO(cmd)->get_task_tag(cmd));
+		iov[0].iov_base =3D (unsigned char *) T_TASK(cmd)->t_task_buf +
+							map_sg->data_offset;
+		iov[0].iov_len  =3D map_sg->data_length;
+		return 1;
+	}
+
+	/*
+	 * Set lmap->map_reset =3D 1 so the first call to
+	 * iscsi_calculate_map_segment() sets up the initial
+	 * values for struct se_offset_map.
+	 */
+	lmap->map_reset =3D 1;
+
+	DEBUG_IOVEC_SCATTERLISTS("[-------------------] ITT: 0x%08x OS"
+		" Independent Network POSIX defined iovectors to SE Memory"
+		" [-------------------]\n\n", CMD_TFO(cmd)->get_task_tag(cmd));
+
+	/*
+	 * Get a pointer to the first used scatterlist based on the passed
+	 * offset. Also set the rest of the needed values in iscsi_linux_map_=
t.
+	 */
+	lmap->iscsi_offset =3D map_sg->data_offset;
+	if (map_sg->sg_kmap_active) {
+		unmap_sg->se_cmd =3D map_sg->se_cmd;
+		get_iscsi_offset(lmap, unmap_sg);
+		unmap_sg->data_length =3D map_sg->data_length;
+	} else {
+		lmap->current_offset =3D lmap->orig_offset;
+	}
+	lmap->map_se_mem =3D lmap->map_orig_se_mem;
+
+	DEBUG_IOVEC_SCATTERLISTS("OS_IOVEC: Total map_sg->data_length: %d,"
+		" lmap->iscsi_offset: %d, i_cmd->orig_iov_data_count: %d\n",
+		map_sg->data_length, lmap->iscsi_offset,
+		i_cmd->orig_iov_data_count);
+
+	while (map_sg->data_length) {
+		/*
+		 * Time to get the virtual address for use with iovec pointers.
+		 * This function will return the expected iovec_base address
+		 * and iovec_length.
+		 */
+		iscsi_calculate_map_segment(&map_sg->data_length, lmap);
+
+		/*
+		 * Set the iov.iov_base and iov.iov_len from the current values
+		 * in iscsi_linux_map_t.
+		 */
+		iov[i].iov_base =3D lmap->iovec_base;
+		iov[i].iov_len =3D lmap->iovec_length;
+
+		/*
+		 * Subtract the final iovec length from the total length to be
+		 * mapped, and the length of the current scatterlist.  Also
+		 * perform the paranoid check to make sure we are not going to
+		 * overflow the iovecs allocated for this command in the next
+		 * pass.
+		 */
+		map_sg->data_length -=3D iov[i].iov_len;
+		lmap->sg_length -=3D iov[i].iov_len;
+
+		DEBUG_IOVEC_SCATTERLISTS("OS_IOVEC: iov[%u].iov_len: %u\n",
+				i, iov[i].iov_len);
+		DEBUG_IOVEC_SCATTERLISTS("OS_IOVEC: lmap->sg_length: from %u"
+			" to %u\n", lmap->sg_length + iov[i].iov_len,
+				lmap->sg_length);
+		DEBUG_IOVEC_SCATTERLISTS("OS_IOVEC: Changed total"
+			" map_sg->data_length from %u to %u\n",
+			map_sg->data_length + iov[i].iov_len,
+			map_sg->data_length);
+
+		if ((++i + 1) > i_cmd->orig_iov_data_count) {
+			printk(KERN_ERR "Current iovec count %u is greater than"
+				" struct se_cmd->orig_data_iov_count %u, cannot"
+				" continue.\n", i+1, i_cmd->orig_iov_data_count);
+			return -1;
+		}
+
+		/*
+		 * All done mapping this scatterlist's pages, move on to
+		 * the next scatterlist by setting lmap.map_reset =3D 1;
+		 */
+		if (!lmap->sg_length || !map_sg->data_length) {
+			list_for_each_entry(lmap->map_se_mem,
+					&lmap->map_se_mem->se_list, se_list)
+				break;
+
+			if (!lmap->map_se_mem) {
+				printk(KERN_ERR "Unable to locate next"
+					" lmap->map_struct se_mem entry\n");
+				return -1;
+			}
+			j++;
+
+			lmap->sg_page =3D NULL;
+			lmap->map_reset =3D 1;
+
+			DEBUG_IOVEC_SCATTERLISTS("OS_IOVEC: Done with current"
+				" scatterlist, incremented Generic scatterlist"
+				" Counter to %d and reset =3D 1\n", j);
+		} else
+			lmap->sg_page++;
+	}
+
+	unmap_sg->sg_count =3D j;
+
+	iscsi_check_iovec_map(i, orig_map_length, map_sg, unmap_sg);
+
+	return i;
+}
+
+static void iscsi_map_SG_segments(struct se_unmap_sg *unmap_sg)
+{
+	u32 i =3D 0;
+	struct se_cmd *cmd =3D unmap_sg->se_cmd;
+	struct se_mem *se_mem =3D unmap_sg->cur_se_mem;
+
+	if (!(T_TASK(cmd)->t_tasks_se_num))
+		return;
+
+	list_for_each_entry_continue(se_mem, T_TASK(cmd)->t_mem_list, se_list=
) {
+		kmap(se_mem->se_page);
+
+		if (++i =3D=3D unmap_sg->sg_count)
+			break;
+	}
+}
+
+static void iscsi_unmap_SG_segments(struct se_unmap_sg *unmap_sg)
+{
+	u32 i =3D 0;
+	struct se_cmd *cmd =3D unmap_sg->se_cmd;
+	struct se_mem *se_mem =3D unmap_sg->cur_se_mem;
+
+	if (!(T_TASK(cmd)->t_tasks_se_num))
+		return;
+
+	list_for_each_entry_continue(se_mem, T_TASK(cmd)->t_mem_list, se_list=
) {
+		kunmap(se_mem->se_page);
+
+		if (++i =3D=3D unmap_sg->sg_count)
+			break;
+	}
+}
+
+static inline int iscsi_handle_scsi_cmd(
+	struct iscsi_conn *conn,
+	unsigned char *buf)
+{
+	int	data_direction, cmdsn_ret =3D 0, immed_ret, ret, transport_ret;
+	int	dump_immediate_data =3D 0, send_check_condition =3D 0, payload_le=
ngth;
+	struct iscsi_cmd	*cmd =3D NULL;
+	struct iscsi_scsi_cmd *hdr;
+
+	spin_lock_bh(&SESS(conn)->session_stats_lock);
+	SESS(conn)->cmd_pdus++;
+	if (SESS_NODE_ACL(SESS(conn))) {
+		spin_lock(&SESS_NODE_ACL(SESS(conn))->stats_lock);
+		SESS_NODE_ACL(SESS(conn))->num_cmds++;
+		spin_unlock(&SESS_NODE_ACL(SESS(conn))->stats_lock);
+	}
+	spin_unlock_bh(&SESS(conn)->session_stats_lock);
+
+	hdr			=3D (struct iscsi_scsi_cmd *) buf;
+	payload_length		=3D ntoh24(hdr->dlength);
+	hdr->itt		=3D be32_to_cpu(hdr->itt);
+	hdr->data_length	=3D be32_to_cpu(hdr->data_length);
+	hdr->cmdsn		=3D be32_to_cpu(hdr->cmdsn);
+	hdr->exp_statsn		=3D be32_to_cpu(hdr->exp_statsn);
+
+	/* FIXME; Add checks for AdditionalHeaderSegment */
+
+	if (!(hdr->flags & ISCSI_FLAG_CMD_WRITE) &&
+	    !(hdr->flags & ISCSI_FLAG_CMD_FINAL)) {
+		printk(KERN_ERR "ISCSI_FLAG_CMD_WRITE & ISCSI_FLAG_CMD_FINAL"
+				" not set. Bad iSCSI Initiator.\n");
+		return iscsi_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
+				buf, conn);
+	}
+
+	if (((hdr->flags & ISCSI_FLAG_CMD_READ) ||
+	     (hdr->flags & ISCSI_FLAG_CMD_WRITE)) && !hdr->data_length) {
+		/*
+		 * Vmware ESX v3.0 uses a modified Cisco Initiator (v3.4.2)
+		 * that adds support for RESERVE/RELEASE.  There is a bug
+		 * add with this new functionality that sets R/W bits when
+		 * neither CDB carries any READ or WRITE datapayloads.
+		 */
+		if ((hdr->cdb[0] =3D=3D 0x16) || (hdr->cdb[0] =3D=3D 0x17)) {
+			hdr->flags &=3D ~ISCSI_FLAG_CMD_READ;
+			hdr->flags &=3D ~ISCSI_FLAG_CMD_WRITE;
+			goto done;
+		}
+
+		printk(KERN_ERR "ISCSI_FLAG_CMD_READ or ISCSI_FLAG_CMD_WRITE"
+			" set when Expected Data Transfer Length is 0 for"
+			" CDB: 0x%02x. Bad iSCSI Initiator.\n", hdr->cdb[0]);
+		return iscsi_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
+				buf, conn);
+	}
+done:
+
+	if (!(hdr->flags & ISCSI_FLAG_CMD_READ) &&
+	    !(hdr->flags & ISCSI_FLAG_CMD_WRITE) && (hdr->data_length !=3D 0)=
) {
+		printk(KERN_ERR "ISCSI_FLAG_CMD_READ and/or ISCSI_FLAG_CMD_WRITE"
+			" MUST be set if Expected Data Transfer Length is not 0."
+			" Bad iSCSI Initiator\n");
+		return iscsi_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
+				buf, conn);
+	}
+
+	if ((hdr->flags & ISCSI_FLAG_CMD_READ) &&
+	    (hdr->flags & ISCSI_FLAG_CMD_WRITE)) {
+		printk(KERN_ERR "Bidirectional operations not supported!\n");
+		return iscsi_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
+				buf, conn);
+	}
+
+	if (hdr->opcode & ISCSI_OP_IMMEDIATE) {
+		printk(KERN_ERR "Illegally set Immediate Bit in iSCSI Initiator"
+				" Scsi Command PDU.\n");
+		return iscsi_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
+				buf, conn);
+	}
+
+	if (payload_length && !SESS_OPS_C(conn)->ImmediateData) {
+		printk(KERN_ERR "ImmediateData=3DNo but DataSegmentLength=3D%u,"
+			" protocol error.\n", payload_length);
+		return iscsi_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+				buf, conn);
+	}
+#if 0
+	if (!(hdr->flags & ISCSI_FLAG_CMD_FINAL) &&
+	     (hdr->flags & ISCSI_FLAG_CMD_WRITE) && SESS_OPS_C(conn)->Initial=
R2T) {
+		printk(KERN_ERR "ISCSI_FLAG_CMD_FINAL is not Set and"
+			" ISCSI_FLAG_CMD_WRITE Bit and InitialR2T=3DYes,"
+			" protocol error\n");
+		return iscsi_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+				buf, conn);
+	}
+#endif
+	if ((hdr->data_length =3D=3D payload_length) &&
+	    (!(hdr->flags & ISCSI_FLAG_CMD_FINAL))) {
+		printk(KERN_ERR "Expected Data Transfer Length and Length of"
+			" Immediate Data are the same, but ISCSI_FLAG_CMD_FINAL"
+			" bit is not set protocol error\n");
+		return iscsi_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+				buf, conn);
+	}
+
+	if (payload_length > hdr->data_length) {
+		printk(KERN_ERR "DataSegmentLength: %u is greater than"
+			" EDTL: %u, protocol error.\n", payload_length,
+				hdr->data_length);
+		return iscsi_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+				buf, conn);
+	}
+
+	if (payload_length > CONN_OPS(conn)->MaxRecvDataSegmentLength) {
+		printk(KERN_ERR "DataSegmentLength: %u is greater than"
+			" MaxRecvDataSegmentLength: %u, protocol error.\n",
+			payload_length, CONN_OPS(conn)->MaxRecvDataSegmentLength);
+		return iscsi_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+				buf, conn);
+	}
+
+	if (payload_length > SESS_OPS_C(conn)->FirstBurstLength) {
+		printk(KERN_ERR "DataSegmentLength: %u is greater than"
+			" FirstBurstLength: %u, protocol error.\n",
+			payload_length, SESS_OPS_C(conn)->FirstBurstLength);
+		return iscsi_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
+					buf, conn);
+	}
+
+	data_direction =3D (hdr->flags & ISCSI_FLAG_CMD_WRITE) ? DMA_TO_DEVIC=
E :
+			 (hdr->flags & ISCSI_FLAG_CMD_READ) ? DMA_FROM_DEVICE :
+			  DMA_NONE;
+
+	cmd =3D iscsi_allocate_se_cmd(conn, hdr->data_length, data_direction,
+				(hdr->flags & ISCSI_FLAG_CMD_ATTR_MASK));
+	if (!(cmd))
+		return iscsi_add_reject(ISCSI_REASON_BOOKMARK_NO_RESOURCES, 1,
+					buf, conn);
+
+	TRACE(TRACE_ISCSI, "Got SCSI Command, ITT: 0x%08x, CmdSN: 0x%08x,"
+		" ExpXferLen: %u, Length: %u, CID: %hu\n", hdr->itt,
+		hdr->cmdsn, hdr->data_length, payload_length, conn->cid);
+
+	cmd->iscsi_opcode	=3D ISCSI_OP_SCSI_CMD;
+	cmd->i_state		=3D ISTATE_NEW_CMD;
+	cmd->immediate_cmd	=3D ((hdr->opcode & ISCSI_OP_IMMEDIATE) ? 1 : 0);
+	cmd->immediate_data	=3D (payload_length) ? 1 : 0;
+	cmd->unsolicited_data	=3D ((!(hdr->flags & ISCSI_FLAG_CMD_FINAL) &&
+				     (hdr->flags & ISCSI_FLAG_CMD_WRITE)) ? 1 : 0);
+	if (cmd->unsolicited_data)
+		cmd->cmd_flags |=3D ICF_NON_IMMEDIATE_UNSOLICITED_DATA;
+
+	SESS(conn)->init_task_tag =3D cmd->init_task_tag =3D hdr->itt;
+	if (hdr->flags & ISCSI_FLAG_CMD_READ) {
+		spin_lock_bh(&SESS(conn)->ttt_lock);
+		cmd->targ_xfer_tag =3D SESS(conn)->targ_xfer_tag++;
+		if (cmd->targ_xfer_tag =3D=3D 0xFFFFFFFF)
+			cmd->targ_xfer_tag =3D SESS(conn)->targ_xfer_tag++;
+		spin_unlock_bh(&SESS(conn)->ttt_lock);
+	} else if (hdr->flags & ISCSI_FLAG_CMD_WRITE)
+		cmd->targ_xfer_tag =3D 0xFFFFFFFF;
+	cmd->cmd_sn		=3D hdr->cmdsn;
+	cmd->exp_stat_sn	=3D hdr->exp_statsn;
+	cmd->first_burst_len	=3D payload_length;
+
+	if (cmd->data_direction =3D=3D DMA_FROM_DEVICE) {
+		struct iscsi_datain_req *dr;
+
+		dr =3D iscsi_allocate_datain_req();
+		if (!(dr))
+			return iscsi_add_reject_from_cmd(
+					ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+					1, 1, buf, cmd);
+
+		iscsi_attach_datain_req(cmd, dr);
+	}
+
+	/*
+	 * The CDB is going to an se_device_t.
+	 */
+	ret =3D iscsi_get_lun_for_cmd(cmd, hdr->cdb,
+				get_unaligned_le64(&hdr->lun[0]));
+	if (ret < 0) {
+		if (SE_CMD(cmd)->scsi_sense_reason =3D=3D TCM_NON_EXISTENT_LUN) {
+			TRACE(TRACE_VANITY, "Responding to non-acl'ed,"
+				" non-existent or non-exported iSCSI LUN:"
+				" 0x%016Lx\n", get_unaligned_le64(&hdr->lun[0]));
+		}
+		if (ret =3D=3D PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES)
+			return iscsi_add_reject_from_cmd(
+					ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+					1, 1, buf, cmd);
+
+		send_check_condition =3D 1;
+		goto attach_cmd;
+	}
+	/*
+	 * The Initiator Node has access to the LUN (the addressing method
+	 * is handled inside of iscsi_get_lun_for_cmd()).  Now it's time to
+	 * allocate 1->N transport tasks (depending on sector count and
+	 * maximum request size the physical HBA(s) can handle.
+	 */
+	transport_ret =3D transport_generic_allocate_tasks(SE_CMD(cmd), hdr->=
cdb);
+	if (!(transport_ret))
+		goto build_list;
+
+	if (transport_ret =3D=3D -1) {
+		return iscsi_add_reject_from_cmd(
+				ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+				1, 1, buf, cmd);
+	} else if (transport_ret =3D=3D -2) {
+		/*
+		 * Unsupported SAM Opcode.  CHECK_CONDITION will be sent
+		 * in iscsi_execute_cmd() during the CmdSN OOO Execution
+		 * Mechinism.
+		 */
+		send_check_condition =3D 1;
+		goto attach_cmd;
+	}
+
+build_list:
+	if (iscsi_decide_list_to_build(cmd, payload_length) < 0)
+		return iscsi_add_reject_from_cmd(
+				ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+				1, 1, buf, cmd);
+attach_cmd:
+	iscsi_attach_cmd_to_queue(conn, cmd);
+	/*
+	 * Check if we need to delay processing because of ALUA
+	 * Active/NonOptimized primary access state..
+	 */
+	core_alua_check_nonop_delay(SE_CMD(cmd));
+	/*
+	 * Check the CmdSN against ExpCmdSN/MaxCmdSN here if
+	 * the Immediate Bit is not set, and no Immediate
+	 * Data is attached.
+	 *
+	 * A PDU/CmdSN carrying Immediate Data can only
+	 * be processed after the DataCRC has passed.
+	 * If the DataCRC fails, the CmdSN MUST NOT
+	 * be acknowledged. (See below)
+	 */
+	if (!cmd->immediate_data) {
+		cmdsn_ret =3D iscsi_check_received_cmdsn(conn,
+				cmd, hdr->cmdsn);
+		if ((cmdsn_ret =3D=3D CMDSN_NORMAL_OPERATION) ||
+		    (cmdsn_ret =3D=3D CMDSN_HIGHER_THAN_EXP))
+			do {} while (0);
+		else if (cmdsn_ret =3D=3D CMDSN_LOWER_THAN_EXP) {
+			cmd->i_state =3D ISTATE_REMOVE;
+			iscsi_add_cmd_to_immediate_queue(cmd,
+					conn, cmd->i_state);
+			return 0;
+		} else { /* (cmdsn_ret =3D=3D CMDSN_ERROR_CANNOT_RECOVER) */
+			return iscsi_add_reject_from_cmd(
+					ISCSI_REASON_PROTOCOL_ERROR,
+					1, 0, buf, cmd);
+		}
+	}
+	iscsi_ack_from_expstatsn(conn, hdr->exp_statsn);
+
+	/*
+	 * If no Immediate Data is attached, it's OK to return now.
+	 */
+	if (!cmd->immediate_data) {
+		if (send_check_condition)
+			return 0;
+
+		if (cmd->unsolicited_data) {
+			iscsi_set_dataout_sequence_values(cmd);
+
+			spin_lock_bh(&cmd->dataout_timeout_lock);
+			iscsi_start_dataout_timer(cmd, CONN(cmd));
+			spin_unlock_bh(&cmd->dataout_timeout_lock);
+		}
+
+		return 0;
+	}
+
+	/*
+	 * Early CHECK_CONDITIONs never make it to the transport processing
+	 * thread.  They are processed in CmdSN order by
+	 * iscsi_check_received_cmdsn() below.
+	 */
+	if (send_check_condition) {
+		immed_ret =3D IMMEDIDATE_DATA_NORMAL_OPERATION;
+		dump_immediate_data =3D 1;
+		goto after_immediate_data;
+	}
+
+	/*
+	 * Immediate Data is present, send to the transport and block until
+	 * the underlying transport plugin has allocated the buffer to
+	 * receive the Immediate Write Data into.
+	 */
+	transport_generic_handle_cdb(SE_CMD(cmd));
+
+	down(&cmd->unsolicited_data_sem);
+
+	if (SE_CMD(cmd)->se_cmd_flags & SCF_SE_CMD_FAILED) {
+		immed_ret =3D IMMEDIDATE_DATA_NORMAL_OPERATION;
+		dump_immediate_data =3D 1;
+		goto after_immediate_data;
+	}
+
+	immed_ret =3D iscsi_handle_immediate_data(cmd, buf, payload_length);
+after_immediate_data:
+	if (immed_ret =3D=3D IMMEDIDATE_DATA_NORMAL_OPERATION) {
+		/*
+		 * A PDU/CmdSN carrying Immediate Data passed
+		 * DataCRC, check against ExpCmdSN/MaxCmdSN if
+		 * Immediate Bit is not set.
+		 */
+		cmdsn_ret =3D iscsi_check_received_cmdsn(conn,
+				cmd, hdr->cmdsn);
+		/*
+		 * Special case for Unsupported SAM WRITE Opcodes
+		 * and ImmediateData=3DYes.
+		 */
+		if (dump_immediate_data) {
+			if (iscsi_dump_data_payload(conn, payload_length, 1) < 0)
+				return -1;
+		} else if (cmd->unsolicited_data) {
+			iscsi_set_dataout_sequence_values(cmd);
+
+			spin_lock_bh(&cmd->dataout_timeout_lock);
+			iscsi_start_dataout_timer(cmd, CONN(cmd));
+			spin_unlock_bh(&cmd->dataout_timeout_lock);
+		}
+
+		if (cmdsn_ret =3D=3D CMDSN_NORMAL_OPERATION)
+			return 0;
+		else if (cmdsn_ret =3D=3D CMDSN_HIGHER_THAN_EXP)
+			return 0;
+		else if (cmdsn_ret =3D=3D CMDSN_LOWER_THAN_EXP) {
+			cmd->i_state =3D ISTATE_REMOVE;
+			iscsi_add_cmd_to_immediate_queue(cmd,
+					conn, cmd->i_state);
+			return 0;
+		} else { /* (cmdsn_ret =3D=3D CMDSN_ERROR_CANNOT_RECOVER) */
+			return iscsi_add_reject_from_cmd(
+					ISCSI_REASON_PROTOCOL_ERROR,
+					1, 0, buf, cmd);
+		}
+	} else if (immed_ret =3D=3D IMMEDIDATE_DATA_ERL1_CRC_FAILURE) {
+		/*
+		 * Immediate Data failed DataCRC and ERL>=3D1,
+		 * silently drop this PDU and let the initiator
+		 * plug the CmdSN gap.
+		 *
+		 * FIXME: Send Unsolicited NOPIN with reserved
+		 * TTT here to help the initiator figure out
+		 * the missing CmdSN, although they should be
+		 * intelligent enough to determine the missing
+		 * CmdSN and issue a retry to plug the sequence.
+		 */
+		cmd->i_state =3D ISTATE_REMOVE;
+		iscsi_add_cmd_to_immediate_queue(cmd, conn, cmd->i_state);
+	} else /* immed_ret =3D=3D IMMEDIDATE_DATA_CANNOT_RECOVER */
+		return -1;
+
+	return 0;
+}
+
+static inline int iscsi_handle_data_out(struct iscsi_conn *conn, unsig=
ned char *buf)
+{
+	int iov_ret, ooo_cmdsn =3D 0, ret;
+	u8 data_crc_failed =3D 0, *pad_bytes[4];
+	u32 checksum, iov_count =3D 0, padding =3D 0, rx_got =3D 0;
+	u32 rx_size =3D 0, payload_length;
+	struct iscsi_cmd *cmd =3D NULL;
+	struct se_cmd *se_cmd;
+	struct se_map_sg map_sg;
+	struct se_unmap_sg unmap_sg;
+	struct iscsi_data *hdr;
+	struct iovec *iov;
+	unsigned long flags;
+
+	hdr			=3D (struct iscsi_data *) buf;
+	payload_length		=3D ntoh24(hdr->dlength);
+	hdr->itt		=3D be32_to_cpu(hdr->itt);
+	hdr->ttt		=3D be32_to_cpu(hdr->ttt);
+	hdr->exp_statsn		=3D be32_to_cpu(hdr->exp_statsn);
+	hdr->datasn		=3D be32_to_cpu(hdr->datasn);
+	hdr->offset		=3D be32_to_cpu(hdr->offset);
+
+	if (!payload_length) {
+		printk(KERN_ERR "DataOUT payload is ZERO, protocol error.\n");
+		return iscsi_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+					buf, conn);
+	}
+
+	/* iSCSI write */
+	spin_lock_bh(&SESS(conn)->session_stats_lock);
+	SESS(conn)->rx_data_octets +=3D payload_length;
+	if (SESS_NODE_ACL(SESS(conn))) {
+		spin_lock(&SESS_NODE_ACL(SESS(conn))->stats_lock);
+		SESS_NODE_ACL(SESS(conn))->write_bytes +=3D payload_length;
+		spin_unlock(&SESS_NODE_ACL(SESS(conn))->stats_lock);
+	}
+	spin_unlock_bh(&SESS(conn)->session_stats_lock);
+
+	if (payload_length > CONN_OPS(conn)->MaxRecvDataSegmentLength) {
+		printk(KERN_ERR "DataSegmentLength: %u is greater than"
+			" MaxRecvDataSegmentLength: %u\n", payload_length,
+			CONN_OPS(conn)->MaxRecvDataSegmentLength);
+		return iscsi_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+					buf, conn);
+	}
+
+	cmd =3D iscsi_find_cmd_from_itt_or_dump(conn, hdr->itt,
+			payload_length);
+	if (!(cmd))
+		return 0;
+
+	TRACE(TRACE_ISCSI, "Got DataOut ITT: 0x%08x, TTT: 0x%08x,"
+		" DataSN: 0x%08x, Offset: %u, Length: %u, CID: %hu\n",
+		hdr->itt, hdr->ttt, hdr->datasn, hdr->offset,
+		payload_length, conn->cid);
+
+	if (cmd->cmd_flags & ICF_GOT_LAST_DATAOUT) {
+		printk(KERN_ERR "Command ITT: 0x%08x received DataOUT after"
+			" last DataOUT received, dumping payload\n",
+			cmd->init_task_tag);
+		return iscsi_dump_data_payload(conn, payload_length, 1);
+	}
+
+	if (cmd->data_direction !=3D DMA_TO_DEVICE) {
+		printk(KERN_ERR "Command ITT: 0x%08x received DataOUT for a"
+			" NON-WRITE command.\n", cmd->init_task_tag);
+		return iscsi_add_reject_from_cmd(ISCSI_REASON_PROTOCOL_ERROR,
+				1, 0, buf, cmd);
+	}
+	se_cmd =3D SE_CMD(cmd);
+	iscsi_mod_dataout_timer(cmd);
+
+	if ((hdr->offset + payload_length) > cmd->data_length) {
+		printk(KERN_ERR "DataOut Offset: %u, Length %u greater than"
+			" iSCSI Command EDTL %u, protocol error.\n",
+			hdr->offset, payload_length, cmd->data_length);
+		return iscsi_add_reject_from_cmd(ISCSI_REASON_BOOKMARK_INVALID,
+				1, 0, buf, cmd);
+	}
+
+	/*
+	 * Whenever a DataOUT or DataIN PDU contains a valid TTT, the
+	 * iSCSI LUN field must be set. iSCSI v20 10.7.4.  Of course,
+	 * Cisco cannot figure this out.
+	 */
+#if 0
+	if (hdr->ttt !=3D 0xFFFFFFFF) {
+		int lun =3D iscsi_unpack_lun(get_unaligned_le64(&hdr->lun[0]));
+		if (lun !=3D SE_CMD(cmd)->orig_fe_lun) {
+			printk(KERN_ERR "Received LUN: %u does not match iSCSI"
+				" LUN: %u\n", lun, SE_CMD(cmd)->orig_fe_lun);
+			return iscsi_add_reject_from_cmd(
+					ISCSI_REASON_BOOKMARK_INVALID,
+					1, 0, buf, cmd);
+		}
+	}
+#endif
+	if (cmd->unsolicited_data) {
+		int dump_unsolicited_data =3D 0, wait_for_transport =3D 0;
+
+		if (SESS_OPS_C(conn)->InitialR2T) {
+			printk(KERN_ERR "Received unexpected unsolicited data"
+				" while InitialR2T=3DYes, protocol error.\n");
+			transport_send_check_condition_and_sense(SE_CMD(cmd),
+					TCM_UNEXPECTED_UNSOLICITED_DATA, 0);
+			return -1;
+		}
+		/*
+		 * Special case for dealing with Unsolicited DataOUT
+		 * and Unsupported SAM WRITE Opcodes and SE resource allocation
+		 * failures;
+		 */
+		spin_lock_irqsave(&T_TASK(se_cmd)->t_state_lock, flags);
+		/*
+		 * Handle cases where we do or do not want to sleep on
+		 * unsolicited_data_sem
+		 *
+		 * First, if TRANSPORT_WRITE_PENDING state has not been reached,
+		 * we need assume we need to wait and sleep..
+		 */
+		 wait_for_transport =3D
+				(se_cmd->t_state !=3D TRANSPORT_WRITE_PENDING);
+		/*
+		 * For the ImmediateData=3DYes cases, there will already be
+		 * generic target memory allocated with the original
+		 * ISCSI_OP_SCSI_CMD PDU, so do not sleep for that case.
+		 *
+		 * The last is a check for a delayed TASK_ABORTED status that
+		 * means the data payload will be dropped because
+		 * SCF_SE_CMD_FAILED has been set to indicate that an exception
+		 * condition for this struct sse_cmd has occured in generic target
+		 * code that requires us to drop payload.
+		 */
+		wait_for_transport =3D
+				(se_cmd->t_state !=3D TRANSPORT_WRITE_PENDING);
+		if ((cmd->immediate_data !=3D 0) ||
+		    (atomic_read(&T_TASK(se_cmd)->t_transport_aborted) !=3D 0))
+			wait_for_transport =3D 0;
+		spin_unlock_irqrestore(&T_TASK(se_cmd)->t_state_lock, flags);
+
+		if (wait_for_transport)
+			down(&cmd->unsolicited_data_sem);
+
+		spin_lock_irqsave(&T_TASK(se_cmd)->t_state_lock, flags);
+		if (!(se_cmd->se_cmd_flags & SCF_SUPPORTED_SAM_OPCODE) ||
+		     (se_cmd->se_cmd_flags & SCF_SE_CMD_FAILED))
+			dump_unsolicited_data =3D 1;
+		spin_unlock_irqrestore(&T_TASK(se_cmd)->t_state_lock, flags);
+
+		if (dump_unsolicited_data) {
+			/*
+			 * Check if a delayed TASK_ABORTED status needs to
+			 * be sent now if the ISCSI_FLAG_CMD_FINAL has been
+			 * received with the unsolicitied data out.
+			 */
+			if (hdr->flags & ISCSI_FLAG_CMD_FINAL)
+				iscsi_stop_dataout_timer(cmd);
+
+			transport_check_aborted_status(se_cmd,
+					(hdr->flags & ISCSI_FLAG_CMD_FINAL));
+			return iscsi_dump_data_payload(conn, payload_length, 1);
+		}
+	} else {
+		/*
+		 * For the normal solicited data path:
+		 *
+		 * Check for a delayed TASK_ABORTED status and dump any
+		 * incoming data out payload if one exists.  Also, when the
+		 * ISCSI_FLAG_CMD_FINAL is set to denote the end of the current
+		 * data out sequence, we decrement outstanding_r2ts.  Once
+		 * outstanding_r2ts reaches zero, go ahead and send the delayed
+		 * TASK_ABORTED status.
+		 */
+		if (atomic_read(&T_TASK(se_cmd)->t_transport_aborted) !=3D 0) {
+			if (hdr->flags & ISCSI_FLAG_CMD_FINAL)
+				if (--cmd->outstanding_r2ts < 1) {
+					iscsi_stop_dataout_timer(cmd);
+					transport_check_aborted_status(
+							se_cmd, 1);
+				}
+
+			return iscsi_dump_data_payload(conn, payload_length, 1);
+		}
+	}
+	/*
+	 * Preform DataSN, DataSequenceInOrder, DataPDUInOrder, and
+	 * within-command recovery checks before receiving the payload.
+	 */
+	ret =3D iscsi_check_pre_dataout(cmd, buf);
+	if (ret =3D=3D DATAOUT_WITHIN_COMMAND_RECOVERY)
+		return 0;
+	else if (ret =3D=3D DATAOUT_CANNOT_RECOVER)
+		return -1;
+
+	rx_size +=3D payload_length;
+	iov =3D &cmd->iov_data[0];
+
+	memset((void *)&map_sg, 0, sizeof(struct se_map_sg));
+	memset((void *)&unmap_sg, 0, sizeof(struct se_unmap_sg));
+	map_sg.fabric_cmd =3D (void *)cmd;
+	map_sg.se_cmd =3D SE_CMD(cmd);
+	map_sg.iov =3D iov;
+	map_sg.sg_kmap_active =3D 1;
+	map_sg.data_length =3D payload_length;
+	map_sg.data_offset =3D hdr->offset;
+	unmap_sg.fabric_cmd =3D (void *)cmd;
+	unmap_sg.se_cmd =3D SE_CMD(cmd);
+
+	iov_ret =3D iscsi_set_iovec_ptrs(&map_sg, &unmap_sg);
+	if (iov_ret < 0)
+		return -1;
+
+	iov_count +=3D iov_ret;
+
+	padding =3D ((-payload_length) & 3);
+	if (padding !=3D 0) {
+		iov[iov_count].iov_base	=3D &pad_bytes;
+		iov[iov_count++].iov_len =3D padding;
+		rx_size +=3D padding;
+		TRACE(TRACE_ISCSI, "Receiving %u padding bytes.\n", padding);
+	}
+
+	if (CONN_OPS(conn)->DataDigest) {
+		iov[iov_count].iov_base =3D &checksum;
+		iov[iov_count++].iov_len =3D CRC_LEN;
+		rx_size +=3D CRC_LEN;
+	}
+
+	iscsi_map_SG_segments(&unmap_sg);
+
+	rx_got =3D rx_data(conn, &cmd->iov_data[0], iov_count, rx_size);
+
+	iscsi_unmap_SG_segments(&unmap_sg);
+
+	if (rx_got !=3D rx_size)
+		return -1;
+
+	if (CONN_OPS(conn)->DataDigest) {
+		u32 counter =3D payload_length, data_crc =3D 0;
+		struct iovec *iov_ptr =3D &cmd->iov_data[0];
+		struct scatterlist sg;
+		/*
+		 * Thanks to the IP stack shitting on passed iovecs,  we have to
+		 * call set_iovec_data_ptrs() again in order to have a iMD/PSCSI
+		 * agnostic way of doing datadigests computations.
+		 */
+		memset((void *)&map_sg, 0, sizeof(struct se_map_sg));
+		map_sg.fabric_cmd =3D (void *)cmd;
+		map_sg.se_cmd =3D SE_CMD(cmd);
+		map_sg.iov =3D iov_ptr;
+		map_sg.data_length =3D payload_length;
+		map_sg.data_offset =3D hdr->offset;
+
+		if (iscsi_set_iovec_ptrs(&map_sg, &unmap_sg) < 0)
+			return -1;
+
+		crypto_hash_init(&conn->conn_rx_hash);
+
+		while (counter > 0) {
+			sg_init_one(&sg, iov_ptr->iov_base,
+					iov_ptr->iov_len);
+			crypto_hash_update(&conn->conn_rx_hash, &sg,
+					iov_ptr->iov_len);
+
+			TRACE(TRACE_DIGEST, "Computed CRC32C DataDigest %zu"
+				" bytes, CRC 0x%08x\n", iov_ptr->iov_len,
+				data_crc);
+			counter -=3D iov_ptr->iov_len;
+			iov_ptr++;
+		}
+
+		if (padding) {
+			sg_init_one(&sg, (u8 *)&pad_bytes, padding);
+			crypto_hash_update(&conn->conn_rx_hash, &sg,
+					padding);
+			TRACE(TRACE_DIGEST, "Computed CRC32C DataDigest %d"
+				" bytes of padding, CRC 0x%08x\n",
+				padding, data_crc);
+		}
+		crypto_hash_final(&conn->conn_rx_hash, (u8 *)&data_crc);
+
+		if (checksum !=3D data_crc) {
+			printk(KERN_ERR "ITT: 0x%08x, Offset: %u, Length: %u,"
+				" DataSN: 0x%08x, CRC32C DataDigest 0x%08x"
+				" does not match computed 0x%08x\n",
+				hdr->itt, hdr->offset, payload_length,
+				hdr->datasn, checksum, data_crc);
+			data_crc_failed =3D 1;
+		} else {
+			TRACE(TRACE_DIGEST, "Got CRC32C DataDigest 0x%08x for"
+				" %u bytes of Data Out\n", checksum,
+				payload_length);
+		}
+	}
+	/*
+	 * Increment post receive data and CRC values or perform
+	 * within-command recovery.
+	 */
+	ret =3D iscsi_check_post_dataout(cmd, buf, data_crc_failed);
+	if ((ret =3D=3D DATAOUT_NORMAL) || (ret =3D=3D DATAOUT_WITHIN_COMMAND=
_RECOVERY))
+		return 0;
+	else if (ret =3D=3D DATAOUT_SEND_R2T) {
+		iscsi_set_dataout_sequence_values(cmd);
+		iscsi_build_r2ts_for_cmd(cmd, conn, 0);
+	} else if (ret =3D=3D DATAOUT_SEND_TO_TRANSPORT) {
+		/*
+		 * Handle extra special case for out of order
+		 * Unsolicited Data Out.
+		 */
+		spin_lock_bh(&cmd->istate_lock);
+		ooo_cmdsn =3D (cmd->cmd_flags & ICF_OOO_CMDSN);
+		cmd->cmd_flags |=3D ICF_GOT_LAST_DATAOUT;
+		cmd->i_state =3D ISTATE_RECEIVED_LAST_DATAOUT;
+		spin_unlock_bh(&cmd->istate_lock);
+
+		iscsi_stop_dataout_timer(cmd);
+		return (!ooo_cmdsn) ? transport_generic_handle_data(
+					SE_CMD(cmd)) : 0;
+	} else /* DATAOUT_CANNOT_RECOVER */
+		return -1;
+
+	return 0;
+}
+
+static inline int iscsi_handle_nop_out(
+	struct iscsi_conn *conn,
+	unsigned char *buf)
+{
+	unsigned char *ping_data =3D NULL;
+	int cmdsn_ret, niov =3D 0, ret =3D 0, rx_got, rx_size;
+	u32 checksum, data_crc, padding =3D 0, payload_length;
+	u64 lun;
+	struct iscsi_cmd *cmd =3D NULL;
+	struct iovec *iov =3D NULL;
+	struct iscsi_nopout *hdr;
+	struct scatterlist sg;
+
+	hdr			=3D (struct iscsi_nopout *) buf;
+	payload_length		=3D ntoh24(hdr->dlength);
+	lun			=3D get_unaligned_le64(&hdr->lun[0]);
+	hdr->itt		=3D be32_to_cpu(hdr->itt);
+	hdr->ttt		=3D be32_to_cpu(hdr->ttt);
+	hdr->cmdsn		=3D be32_to_cpu(hdr->cmdsn);
+	hdr->exp_statsn		=3D be32_to_cpu(hdr->exp_statsn);
+
+	if ((hdr->itt =3D=3D 0xFFFFFFFF) && !(hdr->opcode & ISCSI_OP_IMMEDIAT=
E)) {
+		printk(KERN_ERR "NOPOUT ITT is reserved, but Immediate Bit is"
+			" not set, protocol error.\n");
+		return iscsi_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+					buf, conn);
+	}
+
+	if (payload_length > CONN_OPS(conn)->MaxRecvDataSegmentLength) {
+		printk(KERN_ERR "NOPOUT Ping Data DataSegmentLength: %u is"
+			" greater than MaxRecvDataSegmentLength: %u, protocol"
+			" error.\n", payload_length,
+			CONN_OPS(conn)->MaxRecvDataSegmentLength);
+		return iscsi_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+					buf, conn);
+	}
+
+	TRACE(TRACE_ISCSI, "Got NOPOUT Ping %s ITT: 0x%08x, TTT: 0x%09x,"
+		" CmdSN: 0x%08x, ExpStatSN: 0x%08x, Length: %u\n",
+		(hdr->itt =3D=3D 0xFFFFFFFF) ? "Response" : "Request",
+		hdr->itt, hdr->ttt, hdr->cmdsn, hdr->exp_statsn,
+		payload_length);
+	/*
+	 * This is not a response to a Unsolicited NopIN, which means
+	 * it can either be a NOPOUT ping request (with a valid ITT),
+	 * or a NOPOUT not requesting a NOPIN (with a reserved ITT).
+	 * Either way, make sure we allocate an struct iscsi_cmd, as both
+	 * can contain ping data.
+	 */
+	if (hdr->ttt =3D=3D 0xFFFFFFFF) {
+		cmd =3D iscsi_allocate_cmd(conn);
+		if (!(cmd))
+			return iscsi_add_reject(
+					ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+					1, buf, conn);
+
+		cmd->iscsi_opcode	=3D ISCSI_OP_NOOP_OUT;
+		cmd->i_state		=3D ISTATE_SEND_NOPIN;
+		cmd->immediate_cmd	=3D ((hdr->opcode & ISCSI_OP_IMMEDIATE) ?
+						1 : 0);
+		SESS(conn)->init_task_tag =3D cmd->init_task_tag =3D hdr->itt;
+		cmd->targ_xfer_tag	=3D 0xFFFFFFFF;
+		cmd->cmd_sn		=3D hdr->cmdsn;
+		cmd->exp_stat_sn	=3D hdr->exp_statsn;
+		cmd->data_direction	=3D DMA_NONE;
+	}
+
+	if (payload_length && (hdr->ttt =3D=3D 0xFFFFFFFF)) {
+		rx_size =3D payload_length;
+		ping_data =3D kzalloc(payload_length + 1, GFP_KERNEL);
+		if (!(ping_data)) {
+			printk(KERN_ERR "Unable to allocate memory for"
+				" NOPOUT ping data.\n");
+			ret =3D -1;
+			goto out;
+		}
+
+		iov =3D &cmd->iov_misc[0];
+		iov[niov].iov_base	=3D ping_data;
+		iov[niov++].iov_len	=3D payload_length;
+
+		padding =3D ((-payload_length) & 3);
+		if (padding !=3D 0) {
+			TRACE(TRACE_ISCSI, "Receiving %u additional bytes"
+				" for padding.\n", padding);
+			iov[niov].iov_base	=3D &cmd->pad_bytes;
+			iov[niov++].iov_len	=3D padding;
+			rx_size +=3D padding;
+		}
+		if (CONN_OPS(conn)->DataDigest) {
+			iov[niov].iov_base	=3D &checksum;
+			iov[niov++].iov_len	=3D CRC_LEN;
+			rx_size +=3D CRC_LEN;
+		}
+
+		rx_got =3D rx_data(conn, &cmd->iov_misc[0], niov, rx_size);
+		if (rx_got !=3D rx_size) {
+			ret =3D -1;
+			goto out;
+		}
+
+		if (CONN_OPS(conn)->DataDigest) {
+			crypto_hash_init(&conn->conn_rx_hash);
+
+			sg_init_one(&sg, (u8 *)ping_data, payload_length);
+			crypto_hash_update(&conn->conn_rx_hash, &sg,
+					payload_length);
+
+			if (padding) {
+				sg_init_one(&sg, (u8 *)&cmd->pad_bytes,
+					padding);
+				crypto_hash_update(&conn->conn_rx_hash, &sg,
+					padding);
+			}
+			crypto_hash_final(&conn->conn_rx_hash, (u8 *)&data_crc);
+
+			if (checksum !=3D data_crc) {
+				printk(KERN_ERR "Ping data CRC32C DataDigest"
+				" 0x%08x does not match computed 0x%08x\n",
+					checksum, data_crc);
+				if (!SESS_OPS_C(conn)->ErrorRecoveryLevel) {
+					printk(KERN_ERR "Unable to recover from"
+					" NOPOUT Ping DataCRC failure while in"
+						" ERL=3D0.\n");
+					ret =3D -1;
+					goto out;
+				} else {
+					/*
+					 * Silently drop this PDU and let the
+					 * initiator plug the CmdSN gap.
+					 */
+					TRACE(TRACE_ERL1, "Dropping NOPOUT"
+					" Command CmdSN: 0x%08x due to"
+					" DataCRC error.\n", hdr->cmdsn);
+					ret =3D 0;
+					goto out;
+				}
+			} else {
+				TRACE(TRACE_DIGEST, "Got CRC32C DataDigest"
+				" 0x%08x for %u bytes of ping data.\n",
+					checksum, payload_length);
+			}
+		}
+
+		ping_data[payload_length] =3D '\0';
+		/*
+		 * Attach ping data to struct iscsi_cmd->buf_ptr.
+		 */
+		cmd->buf_ptr =3D (void *)ping_data;
+		cmd->buf_ptr_size =3D payload_length;
+
+		TRACE(TRACE_ISCSI, "Got %u bytes of NOPOUT ping"
+			" data.\n", payload_length);
+		TRACE(TRACE_ISCSI, "Ping Data: \"%s\"\n", ping_data);
+	}
+
+	if (hdr->itt !=3D 0xFFFFFFFF) {
+		if (!cmd) {
+			printk(KERN_ERR "Checking CmdSN for NOPOUT,"
+				" but cmd is NULL!\n");
+			return -1;
+		}
+
+		/*
+		 * Initiator is expecting a NopIN ping reply,
+		 */
+		iscsi_attach_cmd_to_queue(conn, cmd);
+
+		iscsi_ack_from_expstatsn(conn, hdr->exp_statsn);
+
+		if (hdr->opcode & ISCSI_OP_IMMEDIATE) {
+			iscsi_add_cmd_to_response_queue(cmd, conn,
+					cmd->i_state);
+			return 0;
+		}
+
+		cmdsn_ret =3D iscsi_check_received_cmdsn(conn, cmd, hdr->cmdsn);
+		if ((cmdsn_ret =3D=3D CMDSN_NORMAL_OPERATION) ||
+		    (cmdsn_ret =3D=3D CMDSN_HIGHER_THAN_EXP)) {
+			return 0;
+		} else if (cmdsn_ret =3D=3D CMDSN_LOWER_THAN_EXP) {
+			cmd->i_state =3D ISTATE_REMOVE;
+			iscsi_add_cmd_to_immediate_queue(cmd, conn,
+					cmd->i_state);
+			ret =3D 0;
+			goto ping_out;
+		} else { /* (cmdsn_ret =3D=3D CMDSN_ERROR_CANNOT_RECOVER) */
+			return iscsi_add_reject_from_cmd(
+					ISCSI_REASON_PROTOCOL_ERROR,
+					1, 0, buf, cmd);
+			ret =3D -1;
+			goto ping_out;
+		}
+
+		return 0;
+	}
+
+	if (hdr->ttt !=3D 0xFFFFFFFF) {
+		/*
+		 * This was a response to a unsolicited NOPIN ping.
+		 */
+		cmd =3D iscsi_find_cmd_from_ttt(conn, hdr->ttt);
+		if (!(cmd))
+			return -1;
+
+		iscsi_stop_nopin_response_timer(conn);
+
+		cmd->i_state =3D ISTATE_REMOVE;
+		iscsi_add_cmd_to_immediate_queue(cmd, conn, cmd->i_state);
+		iscsi_start_nopin_timer(conn);
+	} else {
+		/*
+		 * Initiator is not expecting a NOPIN is response.
+		 * Just ignore for now.
+		 *
+		 * iSCSI v19-91 10.18
+		 * "A NOP-OUT may also be used to confirm a changed
+		 *  ExpStatSN if another PDU will not be available
+		 *  for a long time."
+		 */
+		ret =3D 0;
+		goto out;
+	}
+
+	return 0;
+out:
+	if (cmd)
+		__iscsi_release_cmd_to_pool(cmd, SESS(conn));
+ping_out:
+	kfree(ping_data);
+	return ret;
+}
+
+static inline int iscsi_handle_task_mgt_cmd(
+	struct iscsi_conn *conn,
+	unsigned char *buf)
+{
+	struct iscsi_cmd *cmd;
+	struct se_tmr_req *se_tmr;
+	struct iscsi_tmr_req *tmr_req;
+	struct iscsi_tm *hdr;
+	u32 payload_length;
+	int cmdsn_ret, out_of_order_cmdsn =3D 0, ret;
+	u8 function;
+
+	hdr			=3D (struct iscsi_tm *) buf;
+	payload_length		=3D ntoh24(hdr->dlength);
+	hdr->itt		=3D be32_to_cpu(hdr->itt);
+	hdr->rtt		=3D be32_to_cpu(hdr->rtt);
+	hdr->cmdsn		=3D be32_to_cpu(hdr->cmdsn);
+	hdr->exp_statsn		=3D be32_to_cpu(hdr->exp_statsn);
+	hdr->refcmdsn		=3D be32_to_cpu(hdr->refcmdsn);
+	hdr->exp_datasn		=3D be32_to_cpu(hdr->exp_datasn);
+	hdr->flags &=3D ~ISCSI_FLAG_CMD_FINAL;
+	function =3D hdr->flags;
+
+	TRACE(TRACE_ISCSI, "Got Task Management Request ITT: 0x%08x, CmdSN:"
+		" 0x%08x, Function: 0x%02x, RefTaskTag: 0x%08x, RefCmdSN:"
+		" 0x%08x, CID: %hu\n", hdr->itt, hdr->cmdsn, function,
+		hdr->rtt, hdr->refcmdsn, conn->cid);
+
+	if ((function !=3D ISCSI_TM_FUNC_ABORT_TASK) &&
+	    ((function !=3D ISCSI_TM_FUNC_TASK_REASSIGN) &&
+	     (hdr->rtt !=3D ISCSI_RESERVED_TAG))) {
+		printk(KERN_ERR "RefTaskTag should be set to 0xFFFFFFFF.\n");
+		hdr->rtt =3D ISCSI_RESERVED_TAG;
+	}
+
+	if ((function =3D=3D ISCSI_TM_FUNC_TASK_REASSIGN) &&
+			!(hdr->opcode & ISCSI_OP_IMMEDIATE)) {
+		printk(KERN_ERR "Task Management Request TASK_REASSIGN not"
+			" issued as immediate command, bad iSCSI Initiator"
+				"implementation\n");
+		return iscsi_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+					buf, conn);
+	}
+	if ((function !=3D ISCSI_TM_FUNC_ABORT_TASK) &&
+	    (hdr->refcmdsn !=3D ISCSI_RESERVED_TAG))
+		hdr->refcmdsn =3D ISCSI_RESERVED_TAG;
+
+	cmd =3D iscsi_allocate_se_cmd_for_tmr(conn, function);
+	if (!(cmd))
+		return iscsi_add_reject(ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+					1, buf, conn);
+
+	cmd->iscsi_opcode	=3D ISCSI_OP_SCSI_TMFUNC;
+	cmd->i_state		=3D ISTATE_SEND_TASKMGTRSP;
+	cmd->immediate_cmd	=3D ((hdr->opcode & ISCSI_OP_IMMEDIATE) ? 1 : 0);
+	cmd->init_task_tag	=3D hdr->itt;
+	cmd->targ_xfer_tag	=3D 0xFFFFFFFF;
+	cmd->cmd_sn		=3D hdr->cmdsn;
+	cmd->exp_stat_sn	=3D hdr->exp_statsn;
+	se_tmr			=3D SE_CMD(cmd)->se_tmr_req;
+	tmr_req			=3D cmd->tmr_req;
+	/*
+	 * Locate the struct se_lun for all TMRs not related to ERL=3D2 TASK_=
REASSIGN
+	 */
+	if (function !=3D ISCSI_TM_FUNC_TASK_REASSIGN) {
+		ret =3D iscsi_get_lun_for_tmr(cmd,
+				get_unaligned_le64(&hdr->lun[0]));
+		if (ret < 0) {
+			SE_CMD(cmd)->se_cmd_flags |=3D SCF_SCSI_CDB_EXCEPTION;
+			se_tmr->response =3D ISCSI_TMF_RSP_NO_LUN;
+			goto attach;
+		}
+	}
+
+	switch (function) {
+	case ISCSI_TM_FUNC_ABORT_TASK:
+		se_tmr->response =3D iscsi_tmr_abort_task(cmd, buf);
+		if (se_tmr->response !=3D ISCSI_TMF_RSP_COMPLETE) {
+			SE_CMD(cmd)->se_cmd_flags |=3D SCF_SCSI_CDB_EXCEPTION;
+			goto attach;
+		}
+		break;
+	case ISCSI_TM_FUNC_ABORT_TASK_SET:
+	case ISCSI_TM_FUNC_CLEAR_ACA:
+	case ISCSI_TM_FUNC_CLEAR_TASK_SET:
+	case ISCSI_TM_FUNC_LOGICAL_UNIT_RESET:
+		break;
+	case ISCSI_TM_FUNC_TARGET_WARM_RESET:
+		if (iscsi_tmr_task_warm_reset(conn, tmr_req, buf) < 0) {
+			SE_CMD(cmd)->se_cmd_flags |=3D SCF_SCSI_CDB_EXCEPTION;
+			se_tmr->response =3D ISCSI_TMF_RSP_AUTH_FAILED;
+			goto attach;
+		}
+		break;
+	case ISCSI_TM_FUNC_TARGET_COLD_RESET:
+		if (iscsi_tmr_task_cold_reset(conn, tmr_req, buf) < 0) {
+			SE_CMD(cmd)->se_cmd_flags |=3D SCF_SCSI_CDB_EXCEPTION;
+			se_tmr->response =3D ISCSI_TMF_RSP_AUTH_FAILED;
+			goto attach;
+		}
+		break;
+	case ISCSI_TM_FUNC_TASK_REASSIGN:
+		se_tmr->response =3D iscsi_tmr_task_reassign(cmd, buf);
+		/*
+		 * Perform sanity checks on the ExpDataSN only if the
+		 * TASK_REASSIGN was successful.
+		 */
+		if (se_tmr->response !=3D ISCSI_TMF_RSP_COMPLETE)
+			break;
+
+		if (iscsi_check_task_reassign_expdatasn(tmr_req, conn) < 0)
+			return iscsi_add_reject_from_cmd(
+					ISCSI_REASON_BOOKMARK_INVALID, 1, 1,
+					buf, cmd);
+		break;
+	default:
+		printk(KERN_ERR "Unknown TMR function: 0x%02x, protocol"
+			" error.\n", function);
+		SE_CMD(cmd)->se_cmd_flags |=3D SCF_SCSI_CDB_EXCEPTION;
+		se_tmr->response =3D ISCSI_TMF_RSP_NOT_SUPPORTED;
+		goto attach;
+	}
+
+	if ((function !=3D ISCSI_TM_FUNC_TASK_REASSIGN) &&
+	    (se_tmr->response =3D=3D ISCSI_TMF_RSP_COMPLETE))
+		se_tmr->call_transport =3D 1;
+attach:
+	iscsi_attach_cmd_to_queue(conn, cmd);
+
+	if (!(hdr->opcode & ISCSI_OP_IMMEDIATE)) {
+		cmdsn_ret =3D iscsi_check_received_cmdsn(conn,
+				cmd, hdr->cmdsn);
+		if (cmdsn_ret =3D=3D CMDSN_NORMAL_OPERATION)
+			do {} while (0);
+		else if (cmdsn_ret =3D=3D CMDSN_HIGHER_THAN_EXP)
+			out_of_order_cmdsn =3D 1;
+		else if (cmdsn_ret =3D=3D CMDSN_LOWER_THAN_EXP) {
+			cmd->i_state =3D ISTATE_REMOVE;
+			iscsi_add_cmd_to_immediate_queue(cmd, conn,
+					cmd->i_state);
+			return 0;
+		} else { /* (cmdsn_ret =3D=3D CMDSN_ERROR_CANNOT_RECOVER) */
+			return iscsi_add_reject_from_cmd(
+					ISCSI_REASON_PROTOCOL_ERROR,
+					1, 0, buf, cmd);
+		}
+	}
+	iscsi_ack_from_expstatsn(conn, hdr->exp_statsn);
+
+	if (out_of_order_cmdsn)
+		return 0;
+	/*
+	 * Found the referenced task, send to transport for processing.
+	 */
+	if (se_tmr->call_transport)
+		return transport_generic_handle_tmr(SE_CMD(cmd));
+
+	/*
+	 * Could not find the referenced LUN, task, or Task Management
+	 * command not authorized or supported.  Change state and
+	 * let the tx_thread send the response.
+	 *
+	 * For connection recovery, this is also the default action for
+	 * TMR TASK_REASSIGN.
+	 */
+	iscsi_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
+	return 0;
+}
+
+/* #warning FIXME: Support Text Command parameters besides SendTargets=
 */
+static inline int iscsi_handle_text_cmd(
+	struct iscsi_conn *conn,
+	unsigned char *buf)
+{
+	char *text_ptr, *text_in;
+	int cmdsn_ret, niov =3D 0, rx_got, rx_size;
+	u32 checksum =3D 0, data_crc =3D 0, payload_length;
+	u32 padding =3D 0, pad_bytes =3D 0, text_length =3D 0;
+	struct iscsi_cmd *cmd;
+	struct iovec iov[3];
+	struct iscsi_text *hdr;
+	struct scatterlist sg;
+
+	hdr			=3D (struct iscsi_text *) buf;
+	payload_length		=3D ntoh24(hdr->dlength);
+	hdr->itt		=3D be32_to_cpu(hdr->itt);
+	hdr->ttt		=3D be32_to_cpu(hdr->ttt);
+	hdr->cmdsn		=3D be32_to_cpu(hdr->cmdsn);
+	hdr->exp_statsn		=3D be32_to_cpu(hdr->exp_statsn);
+
+	if (payload_length > CONN_OPS(conn)->MaxRecvDataSegmentLength) {
+		printk(KERN_ERR "Unable to accept text parameter length: %u"
+			"greater than MaxRecvDataSegmentLength %u.\n",
+		       payload_length, CONN_OPS(conn)->MaxRecvDataSegmentLength);
+		return iscsi_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+					buf, conn);
+	}
+
+	TRACE(TRACE_ISCSI, "Got Text Request: ITT: 0x%08x, CmdSN: 0x%08x,"
+		" ExpStatSN: 0x%08x, Length: %u\n", hdr->itt, hdr->cmdsn,
+		hdr->exp_statsn, payload_length);
+
+	rx_size =3D text_length =3D payload_length;
+	if (text_length) {
+		text_in =3D kzalloc(text_length, GFP_KERNEL);
+		if (!(text_in)) {
+			printk(KERN_ERR "Unable to allocate memory for"
+				" incoming text parameters\n");
+			return -1;
+		}
+
+		memset(iov, 0, 3 * sizeof(struct iovec));
+		iov[niov].iov_base	=3D text_in;
+		iov[niov++].iov_len	=3D text_length;
+
+		padding =3D ((-payload_length) & 3);
+		if (padding !=3D 0) {
+			iov[niov].iov_base =3D &pad_bytes;
+			iov[niov++].iov_len  =3D padding;
+			rx_size +=3D padding;
+			TRACE(TRACE_ISCSI, "Receiving %u additional bytes"
+					" for padding.\n", padding);
+		}
+		if (CONN_OPS(conn)->DataDigest) {
+			iov[niov].iov_base	=3D &checksum;
+			iov[niov++].iov_len	=3D CRC_LEN;
+			rx_size +=3D CRC_LEN;
+		}
+
+		rx_got =3D rx_data(conn, &iov[0], niov, rx_size);
+		if (rx_got !=3D rx_size) {
+			kfree(text_in);
+			return -1;
+		}
+
+		if (CONN_OPS(conn)->DataDigest) {
+			crypto_hash_init(&conn->conn_rx_hash);
+
+			sg_init_one(&sg, (u8 *)text_in, text_length);
+			crypto_hash_update(&conn->conn_rx_hash, &sg,
+					text_length);
+
+			if (padding) {
+				sg_init_one(&sg, (u8 *)&pad_bytes, padding);
+				crypto_hash_update(&conn->conn_rx_hash, &sg,
+						padding);
+			}
+			crypto_hash_final(&conn->conn_rx_hash, (u8 *)&data_crc);
+
+			if (checksum !=3D data_crc) {
+				printk(KERN_ERR "Text data CRC32C DataDigest"
+					" 0x%08x does not match computed"
+					" 0x%08x\n", checksum, data_crc);
+				if (!SESS_OPS_C(conn)->ErrorRecoveryLevel) {
+					printk(KERN_ERR "Unable to recover from"
+					" Text Data digest failure while in"
+						" ERL=3D0.\n");
+					kfree(text_in);
+					return -1;
+				} else {
+					/*
+					 * Silently drop this PDU and let the
+					 * initiator plug the CmdSN gap.
+					 */
+					TRACE(TRACE_ERL1, "Dropping Text"
+					" Command CmdSN: 0x%08x due to"
+					" DataCRC error.\n", hdr->cmdsn);
+					kfree(text_in);
+					return 0;
+				}
+			} else {
+				TRACE(TRACE_DIGEST, "Got CRC32C DataDigest"
+					" 0x%08x for %u bytes of text data.\n",
+						checksum, text_length);
+			}
+		}
+		text_in[text_length - 1] =3D '\0';
+		TRACE(TRACE_ISCSI, "Successfully read %d bytes of text"
+				" data.\n", text_length);
+
+		if (strncmp("SendTargets", text_in, 11) !=3D 0) {
+			printk(KERN_ERR "Received Text Data that is not"
+				" SendTargets, cannot continue.\n");
+			kfree(text_in);
+			return -1;
+		}
+		text_ptr =3D strchr(text_in, '=3D');
+		if (!(text_ptr)) {
+			printk(KERN_ERR "No \"=3D\" separator found in Text Data,"
+				"  cannot continue.\n");
+			kfree(text_in);
+			return -1;
+		}
+		if (strncmp("=3DAll", text_ptr, 4) !=3D 0) {
+			printk(KERN_ERR "Unable to locate All value for"
+				" SendTargets key,  cannot continue.\n");
+			kfree(text_in);
+			return -1;
+		}
+/*#warning Support SendTargets=3D(iSCSI Target Name/Nothing) values. *=
/
+		kfree(text_in);
+	}
+
+	cmd =3D iscsi_allocate_cmd(conn);
+	if (!(cmd))
+		return iscsi_add_reject(ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+					1, buf, conn);
+
+	cmd->iscsi_opcode	=3D ISCSI_OP_TEXT;
+	cmd->i_state		=3D ISTATE_SEND_TEXTRSP;
+	cmd->immediate_cmd	=3D ((hdr->opcode & ISCSI_OP_IMMEDIATE) ? 1 : 0);
+	SESS(conn)->init_task_tag =3D cmd->init_task_tag	=3D hdr->itt;
+	cmd->targ_xfer_tag	=3D 0xFFFFFFFF;
+	cmd->cmd_sn		=3D hdr->cmdsn;
+	cmd->exp_stat_sn	=3D hdr->exp_statsn;
+	cmd->data_direction	=3D DMA_NONE;
+
+	iscsi_attach_cmd_to_queue(conn, cmd);
+	iscsi_ack_from_expstatsn(conn, hdr->exp_statsn);
+
+	if (!(hdr->opcode & ISCSI_OP_IMMEDIATE)) {
+		cmdsn_ret =3D iscsi_check_received_cmdsn(conn, cmd, hdr->cmdsn);
+		if ((cmdsn_ret =3D=3D CMDSN_NORMAL_OPERATION) ||
+		     (cmdsn_ret =3D=3D CMDSN_HIGHER_THAN_EXP))
+			return 0;
+		else if (cmdsn_ret =3D=3D CMDSN_LOWER_THAN_EXP) {
+			iscsi_add_cmd_to_immediate_queue(cmd, conn,
+						ISTATE_REMOVE);
+			return 0;
+		} else { /* (cmdsn_ret =3D=3D CMDSN_ERROR_CANNOT_RECOVER) */
+			return iscsi_add_reject_from_cmd(
+					ISCSI_REASON_PROTOCOL_ERROR,
+					1, 0, buf, cmd);
+		}
+
+		return 0;
+	}
+
+	return iscsi_execute_cmd(cmd, 0);
+}
+
+/*	iscsi_logout_closesession():
+ *
+ *
+ */
+int iscsi_logout_closesession(struct iscsi_cmd *cmd, struct iscsi_conn=
 *conn)
+{
+	struct iscsi_conn *conn_p;
+	struct iscsi_session *sess =3D SESS(conn);
+
+	TRACE(TRACE_ISCSI, "Received logout request CLOSESESSION on CID: %hu"
+		" for SID: %u.\n", conn->cid, SESS(conn)->sid);
+
+	atomic_set(&sess->session_logout, 1);
+	atomic_set(&conn->conn_logout_remove, 1);
+	conn->conn_logout_reason =3D ISCSI_LOGOUT_REASON_CLOSE_SESSION;
+
+	iscsi_inc_conn_usage_count(conn);
+	iscsi_inc_session_usage_count(sess);
+
+	spin_lock_bh(&sess->conn_lock);
+	list_for_each_entry(conn_p, &sess->sess_conn_list, conn_list) {
+		if (conn_p->conn_state !=3D TARG_CONN_STATE_LOGGED_IN)
+			continue;
+
+		TRACE(TRACE_STATE, "Moving to TARG_CONN_STATE_IN_LOGOUT.\n");
+		conn_p->conn_state =3D TARG_CONN_STATE_IN_LOGOUT;
+	}
+	spin_unlock_bh(&sess->conn_lock);
+
+	iscsi_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
+
+	return 0;
+}
+
+int iscsi_logout_closeconnection(struct iscsi_cmd *cmd, struct iscsi_c=
onn *conn)
+{
+	struct iscsi_conn *l_conn;
+	struct iscsi_session *sess =3D SESS(conn);
+
+	TRACE(TRACE_ISCSI, "Received logout request CLOSECONNECTION for CID:"
+		" %hu on CID: %hu.\n", cmd->logout_cid, conn->cid);
+
+	/*
+	 * A Logout Request with a CLOSECONNECTION reason code for a CID
+	 * can arrive on a connection with a differing CID.
+	 */
+	if (conn->cid =3D=3D cmd->logout_cid) {
+		spin_lock_bh(&conn->state_lock);
+		TRACE(TRACE_STATE, "Moving to TARG_CONN_STATE_IN_LOGOUT.\n");
+		conn->conn_state =3D TARG_CONN_STATE_IN_LOGOUT;
+
+		atomic_set(&conn->conn_logout_remove, 1);
+		conn->conn_logout_reason =3D ISCSI_LOGOUT_REASON_CLOSE_CONNECTION;
+		iscsi_inc_conn_usage_count(conn);
+
+		spin_unlock_bh(&conn->state_lock);
+	} else {
+		/*
+		 * Handle all different cid CLOSECONNECTION requests in
+		 * iscsi_logout_post_handler_diffcid() as to give enough
+		 * time for any non immediate command's CmdSN to be
+		 * acknowledged on the connection in question.
+		 *
+		 * Here we simply make sure the CID is still around.
+		 */
+		l_conn =3D iscsi_get_conn_from_cid(sess,
+				cmd->logout_cid);
+		if (!(l_conn)) {
+			cmd->logout_response =3D ISCSI_LOGOUT_CID_NOT_FOUND;
+			iscsi_add_cmd_to_response_queue(cmd, conn,
+					cmd->i_state);
+			return 0;
+		}
+
+		iscsi_dec_conn_usage_count(l_conn);
+	}
+
+	iscsi_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
+
+	return 0;
+}
+
+int iscsi_logout_removeconnforrecovery(struct iscsi_cmd *cmd, struct i=
scsi_conn *conn)
+{
+	struct iscsi_session *sess =3D SESS(conn);
+
+	TRACE(TRACE_ERL2, "Received explicit REMOVECONNFORRECOVERY logout for=
"
+		" CID: %hu on CID: %hu.\n", cmd->logout_cid, conn->cid);
+
+	if (SESS_OPS(sess)->ErrorRecoveryLevel !=3D 2) {
+		printk(KERN_ERR "Received Logout Request REMOVECONNFORRECOVERY"
+			" while ERL!=3D2.\n");
+		cmd->logout_response =3D ISCSI_LOGOUT_RECOVERY_UNSUPPORTED;
+		iscsi_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
+		return 0;
+	}
+
+	if (conn->cid =3D=3D cmd->logout_cid) {
+		printk(KERN_ERR "Received Logout Request REMOVECONNFORRECOVERY"
+			" with CID: %hu on CID: %hu, implementation error.\n",
+				cmd->logout_cid, conn->cid);
+		cmd->logout_response =3D ISCSI_LOGOUT_CLEANUP_FAILED;
+		iscsi_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
+		return 0;
+	}
+
+	iscsi_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
+
+	return 0;
+}
+
+static inline int iscsi_handle_logout_cmd(
+	struct iscsi_conn *conn,
+	unsigned char *buf)
+{
+	int cmdsn_ret, logout_remove =3D 0;
+	u8 reason_code =3D 0;
+	struct iscsi_cmd *cmd;
+	struct iscsi_logout *hdr;
+
+	hdr			=3D (struct iscsi_logout *) buf;
+	reason_code		=3D (hdr->flags & 0x7f);
+	hdr->itt		=3D be32_to_cpu(hdr->itt);
+	hdr->cid		=3D be16_to_cpu(hdr->cid);
+	hdr->cmdsn		=3D be32_to_cpu(hdr->cmdsn);
+	hdr->exp_statsn	=3D be32_to_cpu(hdr->exp_statsn);
+
+	{
+	struct iscsi_tiqn *tiqn =3D iscsi_snmp_get_tiqn(conn);
+
+	if (tiqn) {
+		spin_lock(&tiqn->logout_stats.lock);
+		if (reason_code =3D=3D ISCSI_LOGOUT_REASON_CLOSE_SESSION)
+			tiqn->logout_stats.normal_logouts++;
+		else
+			tiqn->logout_stats.abnormal_logouts++;
+		spin_unlock(&tiqn->logout_stats.lock);
+		}
+	}
+
+	TRACE(TRACE_ISCSI, "Got Logout Request ITT: 0x%08x CmdSN: 0x%08x"
+		" ExpStatSN: 0x%08x Reason: 0x%02x CID: %hu on CID: %hu\n",
+		hdr->itt, hdr->cmdsn, hdr->exp_statsn, reason_code,
+		hdr->cid, conn->cid);
+
+	if (conn->conn_state !=3D TARG_CONN_STATE_LOGGED_IN) {
+		printk(KERN_ERR "Received logout request on connection that"
+			" is not in logged in state, ignoring request.\n");
+		return 0;
+	}
+
+	cmd =3D iscsi_allocate_cmd(conn);
+	if (!(cmd))
+		return iscsi_add_reject(ISCSI_REASON_BOOKMARK_NO_RESOURCES, 1,
+					buf, conn);
+
+	cmd->iscsi_opcode       =3D ISCSI_OP_LOGOUT;
+	cmd->i_state            =3D ISTATE_SEND_LOGOUTRSP;
+	cmd->immediate_cmd      =3D ((hdr->opcode & ISCSI_OP_IMMEDIATE) ? 1 :=
 0);
+	SESS(conn)->init_task_tag =3D cmd->init_task_tag  =3D hdr->itt;
+	cmd->targ_xfer_tag      =3D 0xFFFFFFFF;
+	cmd->cmd_sn             =3D hdr->cmdsn;
+	cmd->exp_stat_sn        =3D hdr->exp_statsn;
+	cmd->logout_cid         =3D hdr->cid;
+	cmd->logout_reason      =3D reason_code;
+	cmd->data_direction     =3D DMA_NONE;
+
+	/*
+	 * We need to sleep in these cases (by returning 1) until the Logout
+	 * Response gets sent in the tx thread.
+	 */
+	if ((reason_code =3D=3D ISCSI_LOGOUT_REASON_CLOSE_SESSION) ||
+	   ((reason_code =3D=3D ISCSI_LOGOUT_REASON_CLOSE_CONNECTION) &&
+	    (hdr->cid =3D=3D conn->cid)))
+		logout_remove =3D 1;
+
+	iscsi_attach_cmd_to_queue(conn, cmd);
+
+	if (reason_code !=3D ISCSI_LOGOUT_REASON_RECOVERY)
+		iscsi_ack_from_expstatsn(conn, hdr->exp_statsn);
+
+	/*
+	 * Non-Immediate Logout Commands are executed in CmdSN order..
+	 */
+	if (!(hdr->opcode & ISCSI_OP_IMMEDIATE)) {
+		cmdsn_ret =3D iscsi_check_received_cmdsn(conn, cmd, hdr->cmdsn);
+		if ((cmdsn_ret =3D=3D CMDSN_NORMAL_OPERATION) ||
+		    (cmdsn_ret =3D=3D CMDSN_HIGHER_THAN_EXP))
+			return logout_remove;
+		else if (cmdsn_ret =3D=3D CMDSN_LOWER_THAN_EXP) {
+			cmd->i_state =3D ISTATE_REMOVE;
+			iscsi_add_cmd_to_immediate_queue(cmd, conn,
+					cmd->i_state);
+			return 0;
+		} else { /* (cmdsn_ret =3D=3D CMDSN_ERROR_CANNOT_RECOVER) */
+			return iscsi_add_reject_from_cmd(
+					ISCSI_REASON_PROTOCOL_ERROR,
+					1, 0, buf, cmd);
+		}
+	}
+	/*
+	 * Immediate Logout Commands are executed, well, Immediately.
+	 */
+	if (iscsi_execute_cmd(cmd, 0) < 0)
+		return -1;
+
+	return logout_remove;
+}
+
+static inline int iscsi_handle_snack(
+	struct iscsi_conn *conn,
+	unsigned char *buf)
+{
+	u32 debug_type, unpacked_lun;
+	u64 lun;
+	struct iscsi_snack *hdr;
+
+	hdr			=3D (struct iscsi_snack *) buf;
+	hdr->flags		&=3D ~ISCSI_FLAG_CMD_FINAL;
+	lun			=3D get_unaligned_le64(&hdr->lun[0]);
+	unpacked_lun		=3D iscsi_unpack_lun((unsigned char *)&lun);
+	hdr->itt		=3D be32_to_cpu(hdr->itt);
+	hdr->ttt		=3D be32_to_cpu(hdr->ttt);
+	hdr->exp_statsn		=3D be32_to_cpu(hdr->exp_statsn);
+	hdr->begrun		=3D be32_to_cpu(hdr->begrun);
+	hdr->runlength		=3D be32_to_cpu(hdr->runlength);
+
+	debug_type =3D (hdr->flags & 0x02) ? TRACE_ISCSI : TRACE_ERL1;
+	TRACE(debug_type, "Got ISCSI_INIT_SNACK, ITT: 0x%08x, ExpStatSN:"
+		" 0x%08x, Type: 0x%02x, BegRun: 0x%08x, RunLength: 0x%08x,"
+		" CID: %hu\n", hdr->itt, hdr->exp_statsn, hdr->flags,
+			hdr->begrun, hdr->runlength, conn->cid);
+
+	if (!SESS_OPS_C(conn)->ErrorRecoveryLevel) {
+		printk(KERN_ERR "Initiator sent SNACK request while in"
+			" ErrorRecoveryLevel=3D0.\n");
+		return iscsi_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+					buf, conn);
+	}
+	/*
+	 * SNACK_DATA and SNACK_R2T are both 0,  so check which function to
+	 * call from inside iscsi_send_recovery_datain_or_r2t().
+	 */
+	switch (hdr->flags & ISCSI_FLAG_SNACK_TYPE_MASK) {
+	case 0:
+		return iscsi_handle_recovery_datain_or_r2t(conn, buf,
+			hdr->itt, hdr->ttt, hdr->begrun, hdr->runlength);
+		return 0;
+	case ISCSI_FLAG_SNACK_TYPE_STATUS:
+		return iscsi_handle_status_snack(conn, hdr->itt, hdr->ttt,
+			hdr->begrun, hdr->runlength);
+	case ISCSI_FLAG_SNACK_TYPE_DATA_ACK:
+		return iscsi_handle_data_ack(conn, hdr->ttt, hdr->begrun,
+			hdr->runlength);
+	case ISCSI_FLAG_SNACK_TYPE_RDATA:
+		/* FIXME: Support R-Data SNACK */
+		printk(KERN_ERR "R-Data SNACK Not Supported.\n");
+		return iscsi_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+					buf, conn);
+	default:
+		printk(KERN_ERR "Unknown SNACK type 0x%02x, protocol"
+			" error.\n", hdr->flags & 0x0f);
+		return iscsi_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+					buf, conn);
+	}
+
+	return 0;
+}
+
+static int iscsi_handle_immediate_data(
+	struct iscsi_cmd *cmd,
+	unsigned char *buf,
+	u32 length)
+{
+	int iov_ret, rx_got =3D 0, rx_size =3D 0;
+	u32 checksum, iov_count =3D 0, padding =3D 0, pad_bytes =3D 0;
+	struct iscsi_conn *conn =3D cmd->conn;
+	struct se_map_sg map_sg;
+	struct se_unmap_sg unmap_sg;
+	struct iovec *iov;
+
+	memset((void *)&map_sg, 0, sizeof(struct se_map_sg));
+	memset((void *)&unmap_sg, 0, sizeof(struct se_unmap_sg));
+	map_sg.fabric_cmd =3D (void *)cmd;
+	map_sg.se_cmd =3D SE_CMD(cmd);
+	map_sg.sg_kmap_active =3D 1;
+	map_sg.iov =3D &cmd->iov_data[0];
+	map_sg.data_length =3D length;
+	map_sg.data_offset =3D cmd->write_data_done;
+	unmap_sg.fabric_cmd =3D (void *)cmd;
+	unmap_sg.se_cmd =3D SE_CMD(cmd);
+
+	iov_ret =3D iscsi_set_iovec_ptrs(&map_sg, &unmap_sg);
+	if (iov_ret < 0)
+		return IMMEDIDATE_DATA_CANNOT_RECOVER;
+
+	rx_size =3D length;
+	iov_count =3D iov_ret;
+	iov =3D &cmd->iov_data[0];
+
+	padding =3D ((-length) & 3);
+	if (padding !=3D 0) {
+		iov[iov_count].iov_base	=3D &pad_bytes;
+		iov[iov_count++].iov_len =3D padding;
+		rx_size +=3D padding;
+	}
+
+	if (CONN_OPS(conn)->DataDigest) {
+		iov[iov_count].iov_base		=3D &checksum;
+		iov[iov_count++].iov_len	=3D CRC_LEN;
+		rx_size +=3D CRC_LEN;
+	}
+
+	iscsi_map_SG_segments(&unmap_sg);
+
+	rx_got =3D rx_data(conn, &cmd->iov_data[0], iov_count, rx_size);
+
+	iscsi_unmap_SG_segments(&unmap_sg);
+
+	if (rx_got !=3D rx_size) {
+		iscsi_rx_thread_wait_for_TCP(conn);
+		return IMMEDIDATE_DATA_CANNOT_RECOVER;
+	}
+
+	if (CONN_OPS(conn)->DataDigest) {
+		u32 counter =3D length, data_crc;
+		struct iovec *iov_ptr =3D &cmd->iov_data[0];
+		struct scatterlist sg;
+		/*
+		 * Thanks to the IP stack shitting on passed iovecs,  we have to
+		 * call set_iovec_data_ptrs again in order to have a iMD/PSCSI
+		 * agnostic way of doing datadigests computations.
+		 */
+		memset((void *)&map_sg, 0, sizeof(struct se_map_sg));
+		map_sg.fabric_cmd =3D (void *)cmd;
+		map_sg.se_cmd =3D SE_CMD(cmd);
+		map_sg.iov =3D iov_ptr;
+		map_sg.data_length =3D length;
+		map_sg.data_offset =3D cmd->write_data_done;
+
+		if (iscsi_set_iovec_ptrs(&map_sg, &unmap_sg) < 0)
+			return IMMEDIDATE_DATA_CANNOT_RECOVER;
+
+		crypto_hash_init(&conn->conn_rx_hash);
+
+		while (counter > 0) {
+			sg_init_one(&sg, iov_ptr->iov_base,
+					iov_ptr->iov_len);
+			crypto_hash_update(&conn->conn_rx_hash, &sg,
+					iov_ptr->iov_len);
+
+			TRACE(TRACE_DIGEST, "Computed CRC32C DataDigest %zu"
+			" bytes, CRC 0x%08x\n", iov_ptr->iov_len, data_crc);
+			counter -=3D iov_ptr->iov_len;
+			iov_ptr++;
+		}
+
+		if (padding) {
+			sg_init_one(&sg, (u8 *)&pad_bytes, padding);
+			crypto_hash_update(&conn->conn_rx_hash, &sg,
+					padding);
+			TRACE(TRACE_DIGEST, "Computed CRC32C DataDigest %d"
+			" bytes of padding, CRC 0x%08x\n", padding, data_crc);
+		}
+		crypto_hash_final(&conn->conn_rx_hash, (u8 *)&data_crc);
+
+		if (checksum !=3D data_crc) {
+			printk(KERN_ERR "ImmediateData CRC32C DataDigest 0x%08x"
+				" does not match computed 0x%08x\n", checksum,
+				data_crc);
+
+			if (!SESS_OPS_C(conn)->ErrorRecoveryLevel) {
+				printk(KERN_ERR "Unable to recover from"
+					" Immediate Data digest failure while"
+					" in ERL=3D0.\n");
+				iscsi_add_reject_from_cmd(
+						ISCSI_REASON_DATA_DIGEST_ERROR,
+						1, 0, buf, cmd);
+				return IMMEDIDATE_DATA_CANNOT_RECOVER;
+			} else {
+				iscsi_add_reject_from_cmd(
+						ISCSI_REASON_DATA_DIGEST_ERROR,
+						0, 0, buf, cmd);
+				return IMMEDIDATE_DATA_ERL1_CRC_FAILURE;
+			}
+		} else {
+			TRACE(TRACE_DIGEST, "Got CRC32C DataDigest 0x%08x for"
+				" %u bytes of Immediate Data\n", checksum,
+				length);
+		}
+	}
+
+	cmd->write_data_done +=3D length;
+
+	if (cmd->write_data_done =3D=3D cmd->data_length) {
+		spin_lock_bh(&cmd->istate_lock);
+		cmd->cmd_flags |=3D ICF_GOT_LAST_DATAOUT;
+		cmd->i_state =3D ISTATE_RECEIVED_LAST_DATAOUT;
+		spin_unlock_bh(&cmd->istate_lock);
+	}
+
+	return IMMEDIDATE_DATA_NORMAL_OPERATION;
+}
+
+/*	iscsi_send_async_msg():
+ *
+ *	FIXME: Support SCSI AEN.
+ */
+int iscsi_send_async_msg(
+	struct iscsi_conn *conn,
+	u16 cid,
+	u8 async_event,
+	u8 async_vcode)
+{
+	u8 iscsi_hdr[ISCSI_HDR_LEN+CRC_LEN];
+	u32 tx_send =3D ISCSI_HDR_LEN, tx_sent =3D 0;
+	struct timer_list async_msg_timer;
+	struct iscsi_async *hdr;
+	struct iovec iov;
+	struct scatterlist sg;
+
+	memset((void *)&iov, 0, sizeof(struct iovec));
+	memset((void *)&iscsi_hdr, 0, ISCSI_HDR_LEN+CRC_LEN);
+
+	hdr		=3D (struct iscsi_async *)&iscsi_hdr;
+	hdr->opcode	=3D ISCSI_OP_ASYNC_EVENT;
+	hdr->flags	|=3D ISCSI_FLAG_CMD_FINAL;
+	hton24(hdr->dlength, 0);
+	put_unaligned_le64(0, &hdr->lun[0]);
+	put_unaligned_be64(0xffffffffffffffff, &hdr->rsvd4[0]);
+	hdr->statsn	=3D cpu_to_be32(conn->stat_sn++);
+	spin_lock(&SESS(conn)->cmdsn_lock);
+	hdr->exp_cmdsn	=3D cpu_to_be32(SESS(conn)->exp_cmd_sn);
+	hdr->max_cmdsn	=3D cpu_to_be32(SESS(conn)->max_cmd_sn);
+	spin_unlock(&SESS(conn)->cmdsn_lock);
+	hdr->async_event =3D async_event;
+	hdr->async_vcode =3D async_vcode;
+
+	switch (async_event) {
+	case ISCSI_ASYNC_MSG_SCSI_EVENT:
+		printk(KERN_ERR "ISCSI_ASYNC_MSG_SCSI_EVENT: not supported yet.\n");
+		return -1;
+	case ISCSI_ASYNC_MSG_REQUEST_LOGOUT:
+		TRACE(TRACE_STATE, "Moving to"
+				" TARG_CONN_STATE_LOGOUT_REQUESTED.\n");
+		conn->conn_state =3D TARG_CONN_STATE_LOGOUT_REQUESTED;
+		hdr->param1 =3D 0;
+		hdr->param2 =3D 0;
+		hdr->param3 =3D cpu_to_be16(SECONDS_FOR_ASYNC_LOGOUT);
+		break;
+	case ISCSI_ASYNC_MSG_DROPPING_CONNECTION:
+		hdr->param1 =3D cpu_to_be16(cid);
+		hdr->param2 =3D cpu_to_be16(SESS_OPS_C(conn)->DefaultTime2Wait);
+		hdr->param3 =3D cpu_to_be16(SESS_OPS_C(conn)->DefaultTime2Retain);
+		break;
+	case ISCSI_ASYNC_MSG_DROPPING_ALL_CONNECTIONS:
+		hdr->param1 =3D 0;
+		hdr->param2 =3D cpu_to_be16(SESS_OPS_C(conn)->DefaultTime2Wait);
+		hdr->param3 =3D cpu_to_be16(SESS_OPS_C(conn)->DefaultTime2Retain);
+		break;
+	case ISCSI_ASYNC_MSG_PARAM_NEGOTIATION:
+		hdr->param1 =3D 0;
+		hdr->param2 =3D 0;
+		hdr->param3 =3D cpu_to_be16(SECONDS_FOR_ASYNC_TEXT);
+		break;
+	case ISCSI_ASYNC_MSG_VENDOR_SPECIFIC:
+		printk(KERN_ERR "ISCSI_ASYNC_MSG_VENDOR_SPECIFIC not"
+			" supported yet.\n");
+		return -1;
+	default:
+		printk(KERN_ERR "Unknown AsycnEvent 0x%02x, protocol"
+			" error.\n", async_event);
+		return -1;
+	}
+
+	iov.iov_base	=3D &iscsi_hdr;
+	iov.iov_len	=3D ISCSI_HDR_LEN;
+
+	if (CONN_OPS(conn)->HeaderDigest) {
+		u32 *header_digest =3D (u32 *)&iscsi_hdr[ISCSI_HDR_LEN];
+
+		crypto_hash_init(&conn->conn_tx_hash);
+
+		sg_init_one(&sg, (u8 *)&iscsi_hdr, ISCSI_HDR_LEN);
+		crypto_hash_update(&conn->conn_tx_hash, &sg, ISCSI_HDR_LEN);
+
+		crypto_hash_final(&conn->conn_tx_hash, (u8 *)header_digest);
+
+		iov.iov_len +=3D CRC_LEN;
+		tx_send +=3D CRC_LEN;
+		TRACE(TRACE_DIGEST, "Attaching CRC32 HeaderDigest for Async"
+			" Msg PDU 0x%08x\n", *header_digest);
+	}
+
+	TRACE(TRACE_ISCSI, "Built Async Message StatSN: 0x%08x, AsyncEvent:"
+		" 0x%02x, P1: 0x%04x, P2: 0x%04x, P3: 0x%04x\n",
+		ntohl(hdr->statsn), hdr->async_event, ntohs(hdr->param1),
+		ntohs(hdr->param2), ntohs(hdr->param3));
+
+	tx_sent =3D tx_data(conn, &iov, 1, tx_send);
+	if (tx_sent !=3D tx_send) {
+		printk(KERN_ERR "tx_data returned %d expecting %d\n",
+				tx_sent, tx_send);
+		return -1;
+	}
+
+	if (async_event =3D=3D ISCSI_ASYNC_MSG_REQUEST_LOGOUT) {
+		init_timer(&async_msg_timer);
+		SETUP_TIMER(async_msg_timer, SECONDS_FOR_ASYNC_LOGOUT,
+				&SESS(conn)->async_msg_sem,
+				iscsi_async_msg_timer_function);
+		add_timer(&async_msg_timer);
+		down(&SESS(conn)->async_msg_sem);
+		del_timer_sync(&async_msg_timer);
+
+		if (conn->conn_state =3D=3D TARG_CONN_STATE_LOGOUT_REQUESTED) {
+			printk(KERN_ERR "Asynchronous message timer expired"
+				" without receiving a logout request,  dropping"
+				" iSCSI session.\n");
+			iscsi_send_async_msg(conn, 0,
+				ISCSI_ASYNC_MSG_DROPPING_ALL_CONNECTIONS, 0);
+			iscsi_free_session(SESS(conn));
+		}
+	}
+	return 0;
+}
+
+/*	iscsi_build_conn_drop_async_message():
+ *
+ *	Called with sess->conn_lock held.
+ */
+/* #warning iscsi_build_conn_drop_async_message() only sends out on co=
nnections
+	with active network interface */
+static void iscsi_build_conn_drop_async_message(struct iscsi_conn *con=
n)
+{
+	struct iscsi_cmd *cmd;
+	struct iscsi_conn *conn_p;
+
+	/*
+	 * Only send a Asynchronous Message on connections whos network
+	 * interface is still functional.
+	 */
+	list_for_each_entry(conn_p, &SESS(conn)->sess_conn_list, conn_list) {
+		if ((conn_p->conn_state =3D=3D TARG_CONN_STATE_LOGGED_IN) &&
+		    (iscsi_check_for_active_network_device(conn_p))) {
+			iscsi_inc_conn_usage_count(conn_p);
+			break;
+		}
+	}
+
+	if (!conn_p)
+		return;
+
+	cmd =3D iscsi_allocate_cmd(conn_p);
+	if (!(cmd)) {
+		iscsi_dec_conn_usage_count(conn_p);
+		return;
+	}
+
+	cmd->logout_cid =3D conn->cid;
+	cmd->iscsi_opcode =3D ISCSI_OP_ASYNC_EVENT;
+	cmd->i_state =3D ISTATE_SEND_ASYNCMSG;
+
+	iscsi_attach_cmd_to_queue(conn_p, cmd);
+	iscsi_add_cmd_to_response_queue(cmd, conn_p, cmd->i_state);
+
+	iscsi_dec_conn_usage_count(conn_p);
+}
+
+static int iscsi_send_conn_drop_async_message(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	struct iscsi_async *hdr;
+	struct scatterlist sg;
+
+	cmd->tx_size =3D ISCSI_HDR_LEN;
+	cmd->iscsi_opcode =3D ISCSI_OP_ASYNC_EVENT;
+
+	hdr			=3D (struct iscsi_async *) cmd->pdu;
+	hdr->opcode		=3D ISCSI_OP_ASYNC_EVENT;
+	hdr->flags		=3D ISCSI_FLAG_CMD_FINAL;
+	cmd->init_task_tag	=3D 0xFFFFFFFF;
+	cmd->targ_xfer_tag	=3D 0xFFFFFFFF;
+	put_unaligned_be64(0xffffffffffffffff, &hdr->rsvd4[0]);
+	cmd->stat_sn		=3D conn->stat_sn++;
+	hdr->statsn		=3D cpu_to_be32(cmd->stat_sn);
+	hdr->exp_cmdsn		=3D cpu_to_be32(SESS(conn)->exp_cmd_sn);
+	hdr->max_cmdsn		=3D cpu_to_be32(SESS(conn)->max_cmd_sn);
+	hdr->async_event	=3D ISCSI_ASYNC_MSG_DROPPING_CONNECTION;
+	hdr->param1		=3D cpu_to_be16(cmd->logout_cid);
+	hdr->param2		=3D cpu_to_be16(SESS_OPS_C(conn)->DefaultTime2Wait);
+	hdr->param3		=3D cpu_to_be16(SESS_OPS_C(conn)->DefaultTime2Retain);
+
+	if (CONN_OPS(conn)->HeaderDigest) {
+		u32 *header_digest =3D (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		crypto_hash_init(&conn->conn_tx_hash);
+
+		sg_init_one(&sg, (u8 *)hdr, ISCSI_HDR_LEN);
+		crypto_hash_update(&conn->conn_tx_hash, &sg, ISCSI_HDR_LEN);
+
+		crypto_hash_final(&conn->conn_tx_hash, (u8 *)header_digest);
+
+		cmd->tx_size +=3D CRC_LEN;
+		TRACE(TRACE_DIGEST, "Attaching CRC32C HeaderDigest to"
+			" Async Message 0x%08x\n", *header_digest);
+	}
+
+	cmd->iov_misc[0].iov_base	=3D cmd->pdu;
+	cmd->iov_misc[0].iov_len	=3D cmd->tx_size;
+	cmd->iov_misc_count		=3D 1;
+
+	TRACE(TRACE_ERL2, "Sending Connection Dropped Async Message StatSN:"
+		" 0x%08x, for CID: %hu on CID: %hu\n", cmd->stat_sn,
+			cmd->logout_cid, conn->cid);
+	return 0;
+}
+
+int lio_queue_data_in(struct se_cmd *se_cmd)
+{
+	struct iscsi_cmd *cmd =3D iscsi_get_cmd(se_cmd);
+
+	cmd->i_state =3D ISTATE_SEND_DATAIN;
+	iscsi_add_cmd_to_response_queue(cmd, CONN(cmd), cmd->i_state);
+	return 0;
+}
+
+static inline int iscsi_send_data_in(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn,
+	struct se_unmap_sg *unmap_sg,
+	int *eodr)
+{
+	int iov_ret =3D 0, set_statsn =3D 0;
+	u8 *pad_bytes;
+	u32 iov_count =3D 0, tx_size =3D 0;
+	u64 lun;
+	struct iscsi_datain datain;
+	struct iscsi_datain_req *dr;
+	struct se_map_sg map_sg;
+	struct iscsi_data_rsp *hdr;
+	struct iovec *iov;
+	struct scatterlist sg;
+
+	memset(&datain, 0, sizeof(struct iscsi_datain));
+	dr =3D iscsi_get_datain_values(cmd, &datain);
+	if (!(dr)) {
+		printk(KERN_ERR "iscsi_get_datain_values failed for ITT: 0x%08x\n",
+				cmd->init_task_tag);
+		return -1;
+	}
+
+	/*
+	 * Be paranoid and double check the logic for now.
+	 */
+	if ((datain.offset + datain.length) > cmd->data_length) {
+		printk(KERN_ERR "Command ITT: 0x%08x, datain.offset: %u and"
+			" datain.length: %u exceeds cmd->data_length: %u\n",
+			cmd->init_task_tag, datain.offset, datain.length,
+				cmd->data_length);
+		return -1;
+	}
+
+	spin_lock_bh(&SESS(conn)->session_stats_lock);
+	SESS(conn)->tx_data_octets +=3D datain.length;
+	if (SESS_NODE_ACL(SESS(conn))) {
+		spin_lock(&SESS_NODE_ACL(SESS(conn))->stats_lock);
+		SESS_NODE_ACL(SESS(conn))->read_bytes +=3D datain.length;
+		spin_unlock(&SESS_NODE_ACL(SESS(conn))->stats_lock);
+	}
+	spin_unlock_bh(&SESS(conn)->session_stats_lock);
+	/*
+	 * Special case for successfully execution w/ both DATAIN
+	 * and Sense Data.
+	 */
+	if ((datain.flags & ISCSI_FLAG_DATA_STATUS) &&
+	    (SE_CMD(cmd)->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE))
+		datain.flags &=3D ~ISCSI_FLAG_DATA_STATUS;
+	else {
+		if ((dr->dr_complete =3D=3D DATAIN_COMPLETE_NORMAL) ||
+		    (dr->dr_complete =3D=3D DATAIN_COMPLETE_CONNECTION_RECOVERY)) {
+			iscsi_increment_maxcmdsn(cmd, SESS(conn));
+			cmd->stat_sn =3D conn->stat_sn++;
+			set_statsn =3D 1;
+		} else if (dr->dr_complete =3D=3D
+				DATAIN_COMPLETE_WITHIN_COMMAND_RECOVERY)
+			set_statsn =3D 1;
+	}
+
+	hdr	=3D (struct iscsi_data_rsp *) cmd->pdu;
+	memset(hdr, 0, ISCSI_HDR_LEN);
+	hdr->opcode		=3D ISCSI_OP_SCSI_DATA_IN;
+	hdr->flags		=3D datain.flags;
+	if (hdr->flags & ISCSI_FLAG_DATA_STATUS) {
+		if (SE_CMD(cmd)->se_cmd_flags & SCF_OVERFLOW_BIT) {
+			hdr->flags |=3D ISCSI_FLAG_DATA_OVERFLOW;
+			hdr->residual_count =3D cpu_to_be32(cmd->residual_count);
+		} else if (SE_CMD(cmd)->se_cmd_flags & SCF_UNDERFLOW_BIT) {
+			hdr->flags |=3D ISCSI_FLAG_DATA_UNDERFLOW;
+			hdr->residual_count =3D cpu_to_be32(cmd->residual_count);
+		}
+	}
+	hton24(hdr->dlength, datain.length);
+	lun			=3D (hdr->flags & ISCSI_FLAG_DATA_ACK) ?
+				   iscsi_pack_lun(SE_CMD(cmd)->orig_fe_lun) :
+				   0xFFFFFFFFFFFFFFFFULL;
+	put_unaligned_le64(lun, &hdr->lun[0]);
+	hdr->itt		=3D cpu_to_be32(cmd->init_task_tag);
+	hdr->ttt		=3D (hdr->flags & ISCSI_FLAG_DATA_ACK) ?
+				   cpu_to_be32(cmd->targ_xfer_tag) :
+				   0xFFFFFFFF;
+	hdr->statsn		=3D (set_statsn) ? cpu_to_be32(cmd->stat_sn) :
+						0xFFFFFFFF;
+	hdr->exp_cmdsn		=3D cpu_to_be32(SESS(conn)->exp_cmd_sn);
+	hdr->max_cmdsn		=3D cpu_to_be32(SESS(conn)->max_cmd_sn);
+	hdr->datasn		=3D cpu_to_be32(datain.data_sn);
+	hdr->offset		=3D cpu_to_be32(datain.offset);
+
+	iov =3D &cmd->iov_data[0];
+	iov[iov_count].iov_base	=3D cmd->pdu;
+	iov[iov_count++].iov_len	=3D ISCSI_HDR_LEN;
+	tx_size +=3D ISCSI_HDR_LEN;
+
+	if (CONN_OPS(conn)->HeaderDigest) {
+		u32 *header_digest =3D (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		crypto_hash_init(&conn->conn_tx_hash);
+
+		sg_init_one(&sg, (u8 *)hdr, ISCSI_HDR_LEN);
+		crypto_hash_update(&conn->conn_tx_hash, &sg, ISCSI_HDR_LEN);
+
+		crypto_hash_final(&conn->conn_tx_hash, (u8 *)header_digest);
+
+		iov[0].iov_len +=3D CRC_LEN;
+		tx_size +=3D CRC_LEN;
+
+		TRACE(TRACE_DIGEST, "Attaching CRC32 HeaderDigest"
+			" for DataIN PDU 0x%08x\n", *header_digest);
+	}
+
+	memset((void *)&map_sg, 0, sizeof(struct se_map_sg));
+	map_sg.fabric_cmd =3D (void *)cmd;
+	map_sg.se_cmd =3D SE_CMD(cmd);
+	map_sg.sg_kmap_active =3D 1;
+	map_sg.iov =3D &cmd->iov_data[1];
+	map_sg.data_length =3D datain.length;
+	map_sg.data_offset =3D datain.offset;
+
+	iov_ret =3D iscsi_set_iovec_ptrs(&map_sg, unmap_sg);
+	if (iov_ret < 0)
+		return -1;
+
+	iov_count +=3D iov_ret;
+	tx_size +=3D datain.length;
+
+	unmap_sg->padding =3D ((-datain.length) & 3);
+	if (unmap_sg->padding !=3D 0) {
+		pad_bytes =3D kzalloc(unmap_sg->padding * sizeof(u8),
+					GFP_KERNEL);
+		if (!(pad_bytes)) {
+			printk(KERN_ERR "Unable to allocate memory for"
+					" pad_bytes.\n");
+			return -1;
+		}
+		cmd->buf_ptr =3D pad_bytes;
+		iov[iov_count].iov_base		=3D pad_bytes;
+		iov[iov_count++].iov_len	=3D unmap_sg->padding;
+		tx_size +=3D unmap_sg->padding;
+
+		TRACE(TRACE_ISCSI, "Attaching %u padding bytes\n",
+				unmap_sg->padding);
+	}
+	if (CONN_OPS(conn)->DataDigest) {
+		u32 counter =3D (datain.length + unmap_sg->padding);
+		struct iovec *iov_ptr =3D &cmd->iov_data[1];
+
+		crypto_hash_init(&conn->conn_tx_hash);
+
+		while (counter > 0) {
+			sg_init_one(&sg, iov_ptr->iov_base,
+					iov_ptr->iov_len);
+			crypto_hash_update(&conn->conn_tx_hash, &sg,
+					iov_ptr->iov_len);
+
+			TRACE(TRACE_DIGEST, "Computed CRC32C DataDigest %zu"
+				" bytes, crc 0x%08x\n", iov_ptr->iov_len,
+					cmd->data_crc);
+			counter -=3D iov_ptr->iov_len;
+			iov_ptr++;
+		}
+		crypto_hash_final(&conn->conn_tx_hash, (u8 *)&cmd->data_crc);
+
+		iov[iov_count].iov_base	=3D &cmd->data_crc;
+		iov[iov_count++].iov_len =3D CRC_LEN;
+		tx_size +=3D CRC_LEN;
+
+		TRACE(TRACE_DIGEST, "Attached CRC32C DataDigest %d bytes, crc"
+			" 0x%08x\n", datain.length+unmap_sg->padding,
+			cmd->data_crc);
+	}
+
+	cmd->iov_data_count =3D iov_count;
+	cmd->tx_size =3D tx_size;
+
+	TRACE(TRACE_ISCSI, "Built DataIN ITT: 0x%08x, StatSN: 0x%08x,"
+		" DataSN: 0x%08x, Offset: %u, Length: %u, CID: %hu\n",
+		cmd->init_task_tag, ntohl(hdr->statsn), ntohl(hdr->datasn),
+		ntohl(hdr->offset), datain.length, conn->cid);
+
+	if (dr->dr_complete) {
+		*eodr =3D (SE_CMD(cmd)->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) ?
+				2 : 1;
+		iscsi_free_datain_req(cmd, dr);
+	}
+
+	return 0;
+}
+
+static inline int iscsi_send_logout_response(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	int niov =3D 0, tx_size;
+	struct iscsi_conn *logout_conn =3D NULL;
+	struct iscsi_conn_recovery *cr =3D NULL;
+	struct iscsi_session *sess =3D SESS(conn);
+	struct iovec *iov;
+	struct iscsi_logout_rsp *hdr;
+	struct scatterlist sg;
+	/*
+	 * The actual shutting down of Sessions and/or Connections
+	 * for CLOSESESSION and CLOSECONNECTION Logout Requests
+	 * is done in scsi_logout_post_handler().
+	 */
+	switch (cmd->logout_reason) {
+	case ISCSI_LOGOUT_REASON_CLOSE_SESSION:
+		TRACE(TRACE_ISCSI, "iSCSI session logout successful, setting"
+			" logout response to ISCSI_LOGOUT_SUCCESS.\n");
+		cmd->logout_response =3D ISCSI_LOGOUT_SUCCESS;
+		break;
+	case ISCSI_LOGOUT_REASON_CLOSE_CONNECTION:
+		if (cmd->logout_response =3D=3D ISCSI_LOGOUT_CID_NOT_FOUND)
+			break;
+		/*
+		 * For CLOSECONNECTION logout requests carrying
+		 * a matching logout CID -> local CID, the reference
+		 * for the local CID will have been incremented in
+		 * iscsi_logout_closeconnection().
+		 *
+		 * For CLOSECONNECTION logout requests carrying
+		 * a different CID than the connection it arrived
+		 * on, the connection responding to cmd->logout_cid
+		 * is stopped in iscsi_logout_post_handler_diffcid().
+		 */
+
+		TRACE(TRACE_ISCSI, "iSCSI CID: %hu logout on CID: %hu"
+			" successful.\n", cmd->logout_cid, conn->cid);
+		cmd->logout_response =3D ISCSI_LOGOUT_SUCCESS;
+		break;
+	case ISCSI_LOGOUT_REASON_RECOVERY:
+		if ((cmd->logout_response =3D=3D ISCSI_LOGOUT_RECOVERY_UNSUPPORTED) =
||
+		    (cmd->logout_response =3D=3D ISCSI_LOGOUT_CLEANUP_FAILED))
+			break;
+		/*
+		 * If the connection is still active from our point of view
+		 * force connection recovery to occur.
+		 */
+		logout_conn =3D iscsi_get_conn_from_cid_rcfr(sess,
+				cmd->logout_cid);
+		if ((logout_conn)) {
+			iscsi_connection_reinstatement_rcfr(logout_conn);
+			iscsi_dec_conn_usage_count(logout_conn);
+		}
+
+		cr =3D iscsi_get_inactive_connection_recovery_entry(
+				SESS(conn), cmd->logout_cid);
+		if (!(cr)) {
+			printk(KERN_ERR "Unable to locate CID: %hu for"
+			" REMOVECONNFORRECOVERY Logout Request.\n",
+				cmd->logout_cid);
+			cmd->logout_response =3D ISCSI_LOGOUT_CID_NOT_FOUND;
+			break;
+		}
+
+		iscsi_discard_cr_cmds_by_expstatsn(cr, cmd->exp_stat_sn);
+
+		TRACE(TRACE_ERL2, "iSCSI REMOVECONNFORRECOVERY logout"
+			" for recovery for CID: %hu on CID: %hu successful.\n",
+				cmd->logout_cid, conn->cid);
+		cmd->logout_response =3D ISCSI_LOGOUT_SUCCESS;
+		break;
+	default:
+		printk(KERN_ERR "Unknown cmd->logout_reason: 0x%02x\n",
+				cmd->logout_reason);
+		return -1;
+	}
+
+	tx_size =3D ISCSI_HDR_LEN;
+	hdr			=3D (struct iscsi_logout_rsp *)cmd->pdu;
+	memset(hdr, 0, ISCSI_HDR_LEN);
+	hdr->opcode		=3D ISCSI_OP_LOGOUT_RSP;
+	hdr->flags		|=3D ISCSI_FLAG_CMD_FINAL;
+	hdr->response		=3D cmd->logout_response;
+	hdr->itt		=3D cpu_to_be32(cmd->init_task_tag);
+	cmd->stat_sn		=3D conn->stat_sn++;
+	hdr->statsn		=3D cpu_to_be32(cmd->stat_sn);
+
+	iscsi_increment_maxcmdsn(cmd, SESS(conn));
+	hdr->exp_cmdsn		=3D cpu_to_be32(SESS(conn)->exp_cmd_sn);
+	hdr->max_cmdsn		=3D cpu_to_be32(SESS(conn)->max_cmd_sn);
+
+	iov =3D &cmd->iov_misc[0];
+	iov[niov].iov_base	=3D cmd->pdu;
+	iov[niov++].iov_len	=3D ISCSI_HDR_LEN;
+
+	if (CONN_OPS(conn)->HeaderDigest) {
+		u32 *header_digest =3D (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		crypto_hash_init(&conn->conn_tx_hash);
+
+		sg_init_one(&sg, (u8 *)hdr, ISCSI_HDR_LEN);
+		crypto_hash_update(&conn->conn_tx_hash, &sg, ISCSI_HDR_LEN);
+
+		crypto_hash_final(&conn->conn_tx_hash, (u8 *)header_digest);
+
+		iov[0].iov_len +=3D CRC_LEN;
+		tx_size +=3D CRC_LEN;
+		TRACE(TRACE_DIGEST, "Attaching CRC32C HeaderDigest to"
+			" Logout Response 0x%08x\n", *header_digest);
+	}
+	cmd->iov_misc_count =3D niov;
+	cmd->tx_size =3D tx_size;
+
+	TRACE(TRACE_ISCSI, "Sending Logout Response ITT: 0x%08x StatSN:"
+		" 0x%08x Response: 0x%02x CID: %hu on CID: %hu\n",
+		cmd->init_task_tag, cmd->stat_sn, hdr->response,
+		cmd->logout_cid, conn->cid);
+
+	return 0;
+}
+
+/*	iscsi_send_nopin():
+ *
+ *	Unsolicited NOPIN, either requesting a response or not.
+ */
+static inline int iscsi_send_unsolicited_nopin(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn,
+	int want_response)
+{
+	int tx_size =3D ISCSI_HDR_LEN;
+	struct iscsi_nopin *hdr;
+	struct scatterlist sg;
+
+	hdr			=3D (struct iscsi_nopin *) cmd->pdu;
+	memset(hdr, 0, ISCSI_HDR_LEN);
+	hdr->opcode		=3D ISCSI_OP_NOOP_IN;
+	hdr->flags		|=3D ISCSI_FLAG_CMD_FINAL;
+	hdr->itt		=3D cpu_to_be32(cmd->init_task_tag);
+	hdr->ttt		=3D cpu_to_be32(cmd->targ_xfer_tag);
+	cmd->stat_sn		=3D conn->stat_sn;
+	hdr->statsn		=3D cpu_to_be32(cmd->stat_sn);
+	hdr->exp_cmdsn		=3D cpu_to_be32(SESS(conn)->exp_cmd_sn);
+	hdr->max_cmdsn		=3D cpu_to_be32(SESS(conn)->max_cmd_sn);
+
+	if (CONN_OPS(conn)->HeaderDigest) {
+		u32 *header_digest =3D (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		crypto_hash_init(&conn->conn_tx_hash);
+
+		sg_init_one(&sg, (u8 *)hdr, ISCSI_HDR_LEN);
+		crypto_hash_update(&conn->conn_tx_hash, &sg, ISCSI_HDR_LEN);
+
+		crypto_hash_final(&conn->conn_tx_hash, (u8 *)header_digest);
+
+		tx_size +=3D CRC_LEN;
+		TRACE(TRACE_DIGEST, "Attaching CRC32C HeaderDigest to"
+			" NopIN 0x%08x\n", *header_digest);
+	}
+
+	cmd->iov_misc[0].iov_base	=3D cmd->pdu;
+	cmd->iov_misc[0].iov_len	=3D tx_size;
+	cmd->iov_misc_count	=3D 1;
+	cmd->tx_size		=3D tx_size;
+
+	TRACE(TRACE_ISCSI, "Sending Unsolicited NOPIN TTT: 0x%08x StatSN:"
+		" 0x%08x CID: %hu\n", hdr->ttt, cmd->stat_sn, conn->cid);
+
+	return 0;
+}
+
+static inline int iscsi_send_nopin_response(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	int niov =3D 0, tx_size;
+	u32 padding =3D 0;
+	struct iovec *iov;
+	struct iscsi_nopin *hdr;
+	struct scatterlist sg;
+
+	tx_size =3D ISCSI_HDR_LEN;
+	hdr			=3D (struct iscsi_nopin *) cmd->pdu;
+	memset(hdr, 0, ISCSI_HDR_LEN);
+	hdr->opcode		=3D ISCSI_OP_NOOP_IN;
+	hdr->flags		|=3D ISCSI_FLAG_CMD_FINAL;
+	hton24(hdr->dlength, cmd->buf_ptr_size);
+	put_unaligned_le64(0xFFFFFFFFFFFFFFFFULL, &hdr->lun[0]);
+	hdr->itt		=3D cpu_to_be32(cmd->init_task_tag);
+	hdr->ttt		=3D cpu_to_be32(cmd->targ_xfer_tag);
+	cmd->stat_sn		=3D conn->stat_sn++;
+	hdr->statsn		=3D cpu_to_be32(cmd->stat_sn);
+
+	iscsi_increment_maxcmdsn(cmd, SESS(conn));
+	hdr->exp_cmdsn		=3D cpu_to_be32(SESS(conn)->exp_cmd_sn);
+	hdr->max_cmdsn		=3D cpu_to_be32(SESS(conn)->max_cmd_sn);
+
+	iov =3D &cmd->iov_misc[0];
+	iov[niov].iov_base	=3D cmd->pdu;
+	iov[niov++].iov_len	=3D ISCSI_HDR_LEN;
+
+	if (CONN_OPS(conn)->HeaderDigest) {
+		u32 *header_digest =3D (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		crypto_hash_init(&conn->conn_tx_hash);
+
+		sg_init_one(&sg, (u8 *)hdr, ISCSI_HDR_LEN);
+		crypto_hash_update(&conn->conn_tx_hash, &sg, ISCSI_HDR_LEN);
+
+		crypto_hash_final(&conn->conn_tx_hash, (u8 *)header_digest);
+
+		iov[0].iov_len +=3D CRC_LEN;
+		tx_size +=3D CRC_LEN;
+		TRACE(TRACE_DIGEST, "Attaching CRC32C HeaderDigest"
+			" to NopIn 0x%08x\n", *header_digest);
+	}
+
+	/*
+	 * NOPOUT Ping Data is attached to struct iscsi_cmd->buf_ptr.
+	 * NOPOUT DataSegmentLength is at struct iscsi_cmd->buf_ptr_size.
+	 */
+	if (cmd->buf_ptr_size) {
+		iov[niov].iov_base	=3D cmd->buf_ptr;
+		iov[niov++].iov_len	=3D cmd->buf_ptr_size;
+		tx_size +=3D cmd->buf_ptr_size;
+
+		TRACE(TRACE_ISCSI, "Echoing back %u bytes of ping"
+			" data.\n", cmd->buf_ptr_size);
+
+		padding =3D ((-cmd->buf_ptr_size) & 3);
+		if (padding !=3D 0) {
+			iov[niov].iov_base =3D &cmd->pad_bytes;
+			iov[niov++].iov_len =3D padding;
+			tx_size +=3D padding;
+			TRACE(TRACE_ISCSI, "Attaching %u additional"
+				" padding bytes.\n", padding);
+		}
+		if (CONN_OPS(conn)->DataDigest) {
+			crypto_hash_init(&conn->conn_tx_hash);
+
+			sg_init_one(&sg, (u8 *)cmd->buf_ptr,
+					cmd->buf_ptr_size);
+			crypto_hash_update(&conn->conn_tx_hash, &sg,
+					cmd->buf_ptr_size);
+
+			if (padding) {
+				sg_init_one(&sg, (u8 *)&cmd->pad_bytes, padding);
+				crypto_hash_update(&conn->conn_tx_hash, &sg,
+						padding);
+			}
+
+			crypto_hash_final(&conn->conn_tx_hash,
+					(u8 *)&cmd->data_crc);
+
+			iov[niov].iov_base =3D &cmd->data_crc;
+			iov[niov++].iov_len =3D CRC_LEN;
+			tx_size +=3D CRC_LEN;
+			TRACE(TRACE_DIGEST, "Attached DataDigest for %u"
+				" bytes of ping data, CRC 0x%08x\n",
+				cmd->buf_ptr_size, cmd->data_crc);
+		}
+	}
+
+	cmd->iov_misc_count =3D niov;
+	cmd->tx_size =3D tx_size;
+
+	TRACE(TRACE_ISCSI, "Sending NOPIN Response ITT: 0x%08x, TTT:"
+		" 0x%08x, StatSN: 0x%08x, Length %u\n", cmd->init_task_tag,
+		cmd->targ_xfer_tag, cmd->stat_sn, cmd->buf_ptr_size);
+
+	return 0;
+}
+
+int iscsi_send_r2t(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	int tx_size =3D 0;
+	u32 trace_type;
+	u64 lun;
+	struct iscsi_r2t *r2t;
+	struct iscsi_r2t_rsp *hdr;
+	struct scatterlist sg;
+
+	r2t =3D iscsi_get_r2t_from_list(cmd);
+	if (!(r2t))
+		return -1;
+
+	hdr			=3D (struct iscsi_r2t_rsp *) cmd->pdu;
+	memset(hdr, 0, ISCSI_HDR_LEN);
+	hdr->opcode		=3D ISCSI_OP_R2T;
+	hdr->flags		|=3D ISCSI_FLAG_CMD_FINAL;
+	lun			=3D iscsi_pack_lun(SE_CMD(cmd)->orig_fe_lun);
+	put_unaligned_le64(lun, &hdr->lun[0]);
+	hdr->itt		=3D cpu_to_be32(cmd->init_task_tag);
+	spin_lock_bh(&SESS(conn)->ttt_lock);
+	r2t->targ_xfer_tag	=3D SESS(conn)->targ_xfer_tag++;
+	if (r2t->targ_xfer_tag =3D=3D 0xFFFFFFFF)
+		r2t->targ_xfer_tag =3D SESS(conn)->targ_xfer_tag++;
+	spin_unlock_bh(&SESS(conn)->ttt_lock);
+	hdr->ttt		=3D cpu_to_be32(r2t->targ_xfer_tag);
+	hdr->statsn		=3D cpu_to_be32(conn->stat_sn);
+	hdr->exp_cmdsn		=3D cpu_to_be32(SESS(conn)->exp_cmd_sn);
+	hdr->max_cmdsn		=3D cpu_to_be32(SESS(conn)->max_cmd_sn);
+	hdr->r2tsn		=3D cpu_to_be32(r2t->r2t_sn);
+	hdr->data_offset	=3D cpu_to_be32(r2t->offset);
+	hdr->data_length	=3D cpu_to_be32(r2t->xfer_len);
+
+	cmd->iov_misc[0].iov_base	=3D cmd->pdu;
+	cmd->iov_misc[0].iov_len	=3D ISCSI_HDR_LEN;
+	tx_size +=3D ISCSI_HDR_LEN;
+
+	if (CONN_OPS(conn)->HeaderDigest) {
+		u32 *header_digest =3D (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		crypto_hash_init(&conn->conn_tx_hash);
+
+		sg_init_one(&sg, (u8 *)hdr, ISCSI_HDR_LEN);
+		crypto_hash_update(&conn->conn_tx_hash, &sg, ISCSI_HDR_LEN);
+
+		crypto_hash_final(&conn->conn_tx_hash, (u8 *)header_digest);
+
+		cmd->iov_misc[0].iov_len +=3D CRC_LEN;
+		tx_size +=3D CRC_LEN;
+		TRACE(TRACE_DIGEST, "Attaching CRC32 HeaderDigest for R2T"
+			" PDU 0x%08x\n", *header_digest);
+	}
+
+	trace_type =3D (!r2t->recovery_r2t) ? TRACE_ISCSI : TRACE_ERL1;
+	TRACE(trace_type, "Built %sR2T, ITT: 0x%08x, TTT: 0x%08x, StatSN:"
+		" 0x%08x, R2TSN: 0x%08x, Offset: %u, DDTL: %u, CID: %hu\n",
+		(!r2t->recovery_r2t) ? "" : "Recovery ", cmd->init_task_tag,
+		r2t->targ_xfer_tag, ntohl(hdr->statsn), r2t->r2t_sn,
+			r2t->offset, r2t->xfer_len, conn->cid);
+
+	cmd->iov_misc_count =3D 1;
+	cmd->tx_size =3D tx_size;
+
+	spin_lock_bh(&cmd->r2t_lock);
+	r2t->sent_r2t =3D 1;
+	spin_unlock_bh(&cmd->r2t_lock);
+
+	return 0;
+}
+
+/*	iscsi_build_r2ts_for_cmd():
+ *
+ *	type 0: Normal Operation.
+ *	type 1: Called from Storage Transport.
+ *	type 2: Called from iscsi_task_reassign_complete_write() for
+ *	        connection recovery.
+ */
+int iscsi_build_r2ts_for_cmd(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn,
+	int type)
+{
+	int first_r2t =3D 1;
+	u32 offset =3D 0, xfer_len =3D 0;
+
+	spin_lock_bh(&cmd->r2t_lock);
+	if (cmd->cmd_flags & ICF_SENT_LAST_R2T) {
+		spin_unlock_bh(&cmd->r2t_lock);
+		return 0;
+	}
+
+	if (SESS_OPS_C(conn)->DataSequenceInOrder && (type !=3D 2))
+		if (cmd->r2t_offset < cmd->write_data_done)
+			cmd->r2t_offset =3D cmd->write_data_done;
+
+	while (cmd->outstanding_r2ts < SESS_OPS_C(conn)->MaxOutstandingR2T) {
+		if (SESS_OPS_C(conn)->DataSequenceInOrder) {
+			offset =3D cmd->r2t_offset;
+
+			if (first_r2t && (type =3D=3D 2)) {
+				xfer_len =3D ((offset +
+					     (SESS_OPS_C(conn)->MaxBurstLength -
+					     cmd->next_burst_len) >
+					     cmd->data_length) ?
+					    (cmd->data_length - offset) :
+					    (SESS_OPS_C(conn)->MaxBurstLength -
+					     cmd->next_burst_len));
+			} else {
+				xfer_len =3D ((offset +
+					     SESS_OPS_C(conn)->MaxBurstLength) >
+					     cmd->data_length) ?
+					     (cmd->data_length - offset) :
+					     SESS_OPS_C(conn)->MaxBurstLength;
+			}
+			cmd->r2t_offset +=3D xfer_len;
+
+			if (cmd->r2t_offset =3D=3D cmd->data_length)
+				cmd->cmd_flags |=3D ICF_SENT_LAST_R2T;
+		} else {
+			struct iscsi_seq *seq;
+
+			seq =3D iscsi_get_seq_holder_for_r2t(cmd);
+			if (!(seq)) {
+				spin_unlock_bh(&cmd->r2t_lock);
+				return -1;
+			}
+
+			offset =3D seq->offset;
+			xfer_len =3D seq->xfer_len;
+
+			if (cmd->seq_send_order =3D=3D cmd->seq_count)
+				cmd->cmd_flags |=3D ICF_SENT_LAST_R2T;
+		}
+		cmd->outstanding_r2ts++;
+		first_r2t =3D 0;
+
+		if (iscsi_add_r2t_to_list(cmd, offset, xfer_len, 0, 0) < 0) {
+			spin_unlock_bh(&cmd->r2t_lock);
+			return -1;
+		}
+
+		if (cmd->cmd_flags & ICF_SENT_LAST_R2T)
+			break;
+	}
+	spin_unlock_bh(&cmd->r2t_lock);
+
+	return 0;
+}
+
+int lio_write_pending(
+	struct se_cmd *se_cmd)
+{
+	struct iscsi_cmd *cmd =3D iscsi_get_cmd(se_cmd);
+
+	if (cmd->immediate_data || cmd->unsolicited_data)
+		up(&cmd->unsolicited_data_sem);
+	else {
+		if (iscsi_build_r2ts_for_cmd(cmd, CONN(cmd), 1) < 0)
+			return PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
+	}
+
+	return 0;
+}
+
+int lio_write_pending_status(
+	struct se_cmd *se_cmd)
+{
+	struct iscsi_cmd *cmd =3D iscsi_get_cmd(se_cmd);
+	int ret;
+
+	spin_lock_bh(&cmd->istate_lock);
+	ret =3D !(cmd->cmd_flags & ICF_GOT_LAST_DATAOUT);
+	spin_unlock_bh(&cmd->istate_lock);
+
+	return ret;
+}
+
+int lio_queue_status(struct se_cmd *se_cmd)
+{
+	struct iscsi_cmd *cmd =3D iscsi_get_cmd(se_cmd);
+
+	cmd->i_state =3D ISTATE_SEND_STATUS;
+	iscsi_add_cmd_to_response_queue(cmd, CONN(cmd), cmd->i_state);
+
+	return 0;
+}
+
+u16 lio_set_fabric_sense_len(struct se_cmd *se_cmd, u32 sense_length)
+{
+	unsigned char *buffer =3D se_cmd->sense_buffer;
+	/*
+	 * From RFC-3720 10.4.7.  Data Segment - Sense and Response Data Segm=
ent
+	 * 16-bit SenseLength.
+	 */
+	buffer[0] =3D ((sense_length >> 8) & 0xff);
+	buffer[1] =3D (sense_length & 0xff);
+	/*
+	 * Return two byte offset into allocated sense_buffer.
+	 */
+	return 2;
+}
+
+u16 lio_get_fabric_sense_len(void)
+{
+	/*
+	 * Return two byte offset into allocated sense_buffer.
+	 */
+	return 2;
+}
+
+static inline int iscsi_send_status(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	u8 iov_count =3D 0, recovery;
+	u32 padding =3D 0, trace_type, tx_size =3D 0;
+	struct iscsi_scsi_rsp *hdr;
+	struct iovec *iov;
+	struct scatterlist sg;
+
+	recovery =3D (cmd->i_state !=3D ISTATE_SEND_STATUS);
+	if (!recovery)
+		cmd->stat_sn =3D conn->stat_sn++;
+
+	spin_lock_bh(&SESS(conn)->session_stats_lock);
+	SESS(conn)->rsp_pdus++;
+	spin_unlock_bh(&SESS(conn)->session_stats_lock);
+
+	hdr			=3D (struct iscsi_scsi_rsp *) cmd->pdu;
+	memset(hdr, 0, ISCSI_HDR_LEN);
+	hdr->opcode		=3D ISCSI_OP_SCSI_CMD_RSP;
+	hdr->flags		|=3D ISCSI_FLAG_CMD_FINAL;
+	if (SE_CMD(cmd)->se_cmd_flags & SCF_OVERFLOW_BIT) {
+		hdr->flags |=3D ISCSI_FLAG_CMD_OVERFLOW;
+		hdr->residual_count =3D cpu_to_be32(cmd->residual_count);
+	} else if (SE_CMD(cmd)->se_cmd_flags & SCF_UNDERFLOW_BIT) {
+		hdr->flags |=3D ISCSI_FLAG_CMD_UNDERFLOW;
+		hdr->residual_count =3D cpu_to_be32(cmd->residual_count);
+	}
+	hdr->response		=3D cmd->iscsi_response;
+	hdr->cmd_status		=3D SE_CMD(cmd)->scsi_status;
+	hdr->itt		=3D cpu_to_be32(cmd->init_task_tag);
+	hdr->statsn		=3D cpu_to_be32(cmd->stat_sn);
+
+	iscsi_increment_maxcmdsn(cmd, SESS(conn));
+	hdr->exp_cmdsn		=3D cpu_to_be32(SESS(conn)->exp_cmd_sn);
+	hdr->max_cmdsn		=3D cpu_to_be32(SESS(conn)->max_cmd_sn);
+
+	iov =3D &cmd->iov_misc[0];
+	iov[iov_count].iov_base	=3D cmd->pdu;
+	iov[iov_count++].iov_len =3D ISCSI_HDR_LEN;
+	tx_size +=3D ISCSI_HDR_LEN;
+
+	/*
+	 * Attach SENSE DATA payload to iSCSI Response PDU
+	 */
+	if (SE_CMD(cmd)->sense_buffer &&
+	   ((SE_CMD(cmd)->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) ||
+	    (SE_CMD(cmd)->se_cmd_flags & SCF_EMULATED_TASK_SENSE))) {
+		padding		=3D -(SE_CMD(cmd)->scsi_sense_length) & 3;
+		hton24(hdr->dlength, SE_CMD(cmd)->scsi_sense_length);
+		iov[iov_count].iov_base	=3D SE_CMD(cmd)->sense_buffer;
+		iov[iov_count++].iov_len =3D
+				(SE_CMD(cmd)->scsi_sense_length + padding);
+		tx_size +=3D SE_CMD(cmd)->scsi_sense_length;
+
+		if (padding) {
+			memset(SE_CMD(cmd)->sense_buffer +
+				SE_CMD(cmd)->scsi_sense_length, 0, padding);
+			tx_size +=3D padding;
+			TRACE(TRACE_ISCSI, "Adding %u bytes of padding to"
+				" SENSE.\n", padding);
+		}
+
+		if (CONN_OPS(conn)->DataDigest) {
+			crypto_hash_init(&conn->conn_tx_hash);
+
+			sg_init_one(&sg, (u8 *)SE_CMD(cmd)->sense_buffer,
+				(SE_CMD(cmd)->scsi_sense_length + padding));
+			crypto_hash_update(&conn->conn_tx_hash, &sg,
+				(SE_CMD(cmd)->scsi_sense_length + padding));
+
+			crypto_hash_final(&conn->conn_tx_hash,
+					(u8 *)&cmd->data_crc);
+
+			iov[iov_count].iov_base    =3D &cmd->data_crc;
+			iov[iov_count++].iov_len     =3D CRC_LEN;
+			tx_size +=3D CRC_LEN;
+
+			TRACE(TRACE_DIGEST, "Attaching CRC32 DataDigest for"
+				" SENSE, %u bytes CRC 0x%08x\n",
+				(SE_CMD(cmd)->scsi_sense_length + padding),
+				cmd->data_crc);
+		}
+
+		TRACE(TRACE_ISCSI, "Attaching SENSE DATA: %u bytes to iSCSI"
+				" Response PDU\n",
+				SE_CMD(cmd)->scsi_sense_length);
+	}
+
+	if (CONN_OPS(conn)->HeaderDigest) {
+		u32 *header_digest =3D (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		crypto_hash_init(&conn->conn_tx_hash);
+
+		sg_init_one(&sg, (u8 *)hdr, ISCSI_HDR_LEN);
+		crypto_hash_update(&conn->conn_tx_hash, &sg, ISCSI_HDR_LEN);
+
+		crypto_hash_final(&conn->conn_tx_hash, (u8 *)header_digest);
+
+		iov[0].iov_len +=3D CRC_LEN;
+		tx_size +=3D CRC_LEN;
+		TRACE(TRACE_DIGEST, "Attaching CRC32 HeaderDigest for Response"
+				" PDU 0x%08x\n", *header_digest);
+	}
+
+	cmd->iov_misc_count =3D iov_count;
+	cmd->tx_size =3D tx_size;
+
+	trace_type =3D (!recovery) ? TRACE_ISCSI : TRACE_ERL1;
+	TRACE(trace_type, "Built %sSCSI Response, ITT: 0x%08x, StatSN: 0x%08x=
,"
+		" Response: 0x%02x, SAM Status: 0x%02x, CID: %hu\n",
+		(!recovery) ? "" : "Recovery ", cmd->init_task_tag,
+		cmd->stat_sn, 0x00, cmd->se_cmd.scsi_status, conn->cid);
+
+	return 0;
+}
+
+int lio_queue_tm_rsp(struct se_cmd *se_cmd)
+{
+	struct iscsi_cmd *cmd =3D iscsi_get_cmd(se_cmd);
+
+	cmd->i_state =3D ISTATE_SEND_TASKMGTRSP;
+	iscsi_add_cmd_to_response_queue(cmd, CONN(cmd), cmd->i_state);
+
+	return 0;
+}
+
+static inline u8 iscsi_convert_tcm_tmr_rsp(struct se_tmr_req *se_tmr)
+{
+	switch (se_tmr->response) {
+	case TMR_FUNCTION_COMPLETE:
+		return ISCSI_TMF_RSP_COMPLETE;
+	case TMR_TASK_DOES_NOT_EXIST:
+		return ISCSI_TMF_RSP_NO_TASK;
+	case TMR_LUN_DOES_NOT_EXIST:
+		return ISCSI_TMF_RSP_NO_LUN;
+	case TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED:
+		return ISCSI_TMF_RSP_NOT_SUPPORTED;
+	case TMR_FUNCTION_AUTHORIZATION_FAILED:
+		return ISCSI_TMF_RSP_AUTH_FAILED;
+	case TMR_FUNCTION_REJECTED:
+	default:
+		return ISCSI_TMF_RSP_REJECTED;
+	}
+}
+
+static int iscsi_send_task_mgt_rsp(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	struct se_tmr_req *se_tmr =3D SE_CMD(cmd)->se_tmr_req;
+	struct iscsi_tm_rsp *hdr;
+	struct scatterlist sg;
+	u32 tx_size =3D 0;
+
+	hdr			=3D (struct iscsi_tm_rsp *) cmd->pdu;
+	memset(hdr, 0, ISCSI_HDR_LEN);
+	hdr->opcode		=3D ISCSI_OP_SCSI_TMFUNC_RSP;
+	hdr->response		=3D iscsi_convert_tcm_tmr_rsp(se_tmr);
+	hdr->itt		=3D cpu_to_be32(cmd->init_task_tag);
+	cmd->stat_sn		=3D conn->stat_sn++;
+	hdr->statsn		=3D cpu_to_be32(cmd->stat_sn);
+
+	iscsi_increment_maxcmdsn(cmd, SESS(conn));
+	hdr->exp_cmdsn		=3D cpu_to_be32(SESS(conn)->exp_cmd_sn);
+	hdr->max_cmdsn		=3D cpu_to_be32(SESS(conn)->max_cmd_sn);
+
+	cmd->iov_misc[0].iov_base	=3D cmd->pdu;
+	cmd->iov_misc[0].iov_len	=3D ISCSI_HDR_LEN;
+	tx_size +=3D ISCSI_HDR_LEN;
+
+	if (CONN_OPS(conn)->HeaderDigest) {
+		u32 *header_digest =3D (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		crypto_hash_init(&conn->conn_tx_hash);
+
+		sg_init_one(&sg, (u8 *)hdr, ISCSI_HDR_LEN);
+		crypto_hash_update(&conn->conn_tx_hash, &sg, ISCSI_HDR_LEN);
+
+		crypto_hash_final(&conn->conn_tx_hash, (u8 *)header_digest);
+
+		cmd->iov_misc[0].iov_len +=3D CRC_LEN;
+		tx_size +=3D CRC_LEN;
+		TRACE(TRACE_DIGEST, "Attaching CRC32 HeaderDigest for Task"
+			" Mgmt Response PDU 0x%08x\n", *header_digest);
+	}
+
+	cmd->iov_misc_count =3D 1;
+	cmd->tx_size =3D tx_size;
+
+	TRACE(TRACE_ERL2, "Built Task Management Response ITT: 0x%08x,"
+		" StatSN: 0x%08x, Response: 0x%02x, CID: %hu\n",
+		cmd->init_task_tag, cmd->stat_sn, hdr->response, conn->cid);
+
+	return 0;
+}
+
+/*	iscsi_send_text_rsp():
+ *
+ *	FIXME: Add support for F_BIT and C_BIT when the length is longer th=
an
+ *	MaxRecvDataSegmentLength.
+ */
+static int iscsi_send_text_rsp(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	u8 iov_count =3D 0;
+	u32 padding =3D 0, text_length =3D 0, tx_size =3D 0;
+	struct iscsi_text_rsp *hdr;
+	struct iovec *iov;
+	struct scatterlist sg;
+
+	text_length =3D iscsi_build_sendtargets_response(cmd);
+
+	padding =3D ((-text_length) & 3);
+	if (padding !=3D 0) {
+		memset((void *) (cmd->buf_ptr + text_length), 0, padding);
+		TRACE(TRACE_ISCSI, "Attaching %u additional bytes for"
+			" padding.\n", padding);
+	}
+
+	hdr			=3D (struct iscsi_text_rsp *) cmd->pdu;
+	memset(hdr, 0, ISCSI_HDR_LEN);
+	hdr->opcode		=3D ISCSI_OP_TEXT_RSP;
+	hdr->flags		|=3D ISCSI_FLAG_CMD_FINAL;
+	hton24(hdr->dlength, text_length);
+	hdr->itt		=3D cpu_to_be32(cmd->init_task_tag);
+	hdr->ttt		=3D cpu_to_be32(cmd->targ_xfer_tag);
+	cmd->stat_sn		=3D conn->stat_sn++;
+	hdr->statsn		=3D cpu_to_be32(cmd->stat_sn);
+
+	iscsi_increment_maxcmdsn(cmd, SESS(conn));
+	hdr->exp_cmdsn		=3D cpu_to_be32(SESS(conn)->exp_cmd_sn);
+	hdr->max_cmdsn		=3D cpu_to_be32(SESS(conn)->max_cmd_sn);
+
+	iov =3D &cmd->iov_misc[0];
+
+	iov[iov_count].iov_base =3D cmd->pdu;
+	iov[iov_count++].iov_len =3D ISCSI_HDR_LEN;
+	iov[iov_count].iov_base	=3D cmd->buf_ptr;
+	iov[iov_count++].iov_len =3D text_length + padding;
+
+	tx_size +=3D (ISCSI_HDR_LEN + text_length + padding);
+
+	if (CONN_OPS(conn)->HeaderDigest) {
+		u32 *header_digest =3D (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		crypto_hash_init(&conn->conn_tx_hash);
+
+		sg_init_one(&sg, (u8 *)hdr, ISCSI_HDR_LEN);
+		crypto_hash_update(&conn->conn_tx_hash, &sg, ISCSI_HDR_LEN);
+
+		crypto_hash_final(&conn->conn_tx_hash, (u8 *)header_digest);
+
+		iov[0].iov_len +=3D CRC_LEN;
+		tx_size +=3D CRC_LEN;
+		TRACE(TRACE_DIGEST, "Attaching CRC32 HeaderDigest for"
+			" Text Response PDU 0x%08x\n", *header_digest);
+	}
+
+	if (CONN_OPS(conn)->DataDigest) {
+		crypto_hash_init(&conn->conn_tx_hash);
+
+		sg_init_one(&sg, (u8 *)cmd->buf_ptr, (text_length + padding));
+		crypto_hash_update(&conn->conn_tx_hash, &sg,
+				(text_length + padding));
+
+		crypto_hash_final(&conn->conn_tx_hash,
+				(u8 *)&cmd->data_crc);
+
+		iov[iov_count].iov_base	=3D &cmd->data_crc;
+		iov[iov_count++].iov_len =3D CRC_LEN;
+		tx_size	+=3D CRC_LEN;
+
+		TRACE(TRACE_DIGEST, "Attaching DataDigest for %u bytes of text"
+			" data, CRC 0x%08x\n", (text_length + padding),
+			cmd->data_crc);
+	}
+
+	cmd->iov_misc_count =3D iov_count;
+	cmd->tx_size =3D tx_size;
+
+	TRACE(TRACE_ISCSI, "Built Text Response: ITT: 0x%08x, StatSN: 0x%08x,=
"
+		" Length: %u, CID: %hu\n", cmd->init_task_tag, cmd->stat_sn,
+			text_length, conn->cid);
+	return 0;
+}
+
+/*	iscsi_send_reject():
+ *
+ *
+ */
+static int iscsi_send_reject(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	u32 iov_count =3D 0, tx_size =3D 0;
+	struct iscsi_reject *hdr;
+	struct iovec *iov;
+	struct scatterlist sg;
+
+	hdr			=3D (struct iscsi_reject *) cmd->pdu;
+	hdr->opcode		=3D ISCSI_OP_REJECT;
+	hdr->flags		|=3D ISCSI_FLAG_CMD_FINAL;
+	hton24(hdr->dlength, ISCSI_HDR_LEN);
+	cmd->stat_sn		=3D conn->stat_sn++;
+	hdr->statsn		=3D cpu_to_be32(cmd->stat_sn);
+	hdr->exp_cmdsn	=3D cpu_to_be32(SESS(conn)->exp_cmd_sn);
+	hdr->max_cmdsn	=3D cpu_to_be32(SESS(conn)->max_cmd_sn);
+
+	iov =3D &cmd->iov_misc[0];
+
+	iov[iov_count].iov_base =3D cmd->pdu;
+	iov[iov_count++].iov_len =3D ISCSI_HDR_LEN;
+	iov[iov_count].iov_base =3D cmd->buf_ptr;
+	iov[iov_count++].iov_len =3D ISCSI_HDR_LEN;
+
+	tx_size =3D (ISCSI_HDR_LEN + ISCSI_HDR_LEN);
+
+	if (CONN_OPS(conn)->HeaderDigest) {
+		u32 *header_digest =3D (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		crypto_hash_init(&conn->conn_tx_hash);
+
+		sg_init_one(&sg, (u8 *)hdr, ISCSI_HDR_LEN);
+		crypto_hash_update(&conn->conn_tx_hash, &sg, ISCSI_HDR_LEN);
+
+		crypto_hash_final(&conn->conn_tx_hash, (u8 *)header_digest);
+
+		iov[0].iov_len +=3D CRC_LEN;
+		tx_size +=3D CRC_LEN;
+		TRACE(TRACE_DIGEST, "Attaching CRC32 HeaderDigest for"
+			" REJECT PDU 0x%08x\n", *header_digest);
+	}
+
+	if (CONN_OPS(conn)->DataDigest) {
+		crypto_hash_init(&conn->conn_tx_hash);
+
+		sg_init_one(&sg, (u8 *)cmd->buf_ptr, ISCSI_HDR_LEN);
+		crypto_hash_update(&conn->conn_tx_hash, &sg,
+				ISCSI_HDR_LEN);
+
+		crypto_hash_final(&conn->conn_tx_hash,
+				(u8 *)&cmd->data_crc);
+
+		iov[iov_count].iov_base =3D &cmd->data_crc;
+		iov[iov_count++].iov_len  =3D CRC_LEN;
+		tx_size +=3D CRC_LEN;
+		TRACE(TRACE_DIGEST, "Attaching CRC32 DataDigest for REJECT"
+				" PDU 0x%08x\n", cmd->data_crc);
+	}
+
+	cmd->iov_misc_count =3D iov_count;
+	cmd->tx_size =3D tx_size;
+
+	TRACE(TRACE_ISCSI, "Built Reject PDU StatSN: 0x%08x, Reason: 0x%02x,"
+		" CID: %hu\n", ntohl(hdr->statsn), hdr->reason, conn->cid);
+
+	return 0;
+}
+
+/*	iscsi_tx_thread_TCP_timeout():
+ *
+ *
+ */
+static void iscsi_tx_thread_TCP_timeout(unsigned long data)
+{
+	up((struct semaphore *)data);
+}
+
+/*	iscsi_tx_thread_wait_for_TCP():
+ *
+ *
+ */
+static void iscsi_tx_thread_wait_for_TCP(struct iscsi_conn *conn)
+{
+	struct timer_list tx_TCP_timer;
+	int ret;
+
+	if ((conn->sock->sk->sk_shutdown & SEND_SHUTDOWN) ||
+	    (conn->sock->sk->sk_shutdown & RCV_SHUTDOWN)) {
+		init_timer(&tx_TCP_timer);
+		SETUP_TIMER(tx_TCP_timer, ISCSI_TX_THREAD_TCP_TIMEOUT,
+			&conn->tx_half_close_sem, iscsi_tx_thread_TCP_timeout);
+		add_timer(&tx_TCP_timer);
+
+		ret =3D down_interruptible(&conn->tx_half_close_sem);
+
+		del_timer_sync(&tx_TCP_timer);
+	}
+}
+
+#ifdef CONFIG_SMP
+
+void iscsi_thread_get_cpumask(struct iscsi_conn *conn)
+{
+	struct se_thread_set *ts =3D conn->thread_set;
+	int ord, cpu;
+	/*
+	 * thread_id is assigned from iscsi_global->ts_bitmap from
+	 * within iscsi_thread_set.c:iscsi_allocate_thread_sets()
+	 *
+	 * Here we use thread_id to determine which CPU that this
+	 * iSCSI connection's se_thread_set will be scheduled to
+	 * execute upon.
+	 */
+	ord =3D ts->thread_id % cpumask_weight(cpu_online_mask);
+#if 0
+	printk(KERN_INFO ">>>>>>>>>>>>>>>>>>>> Generated ord: %d from"
+			" thread_id: %d\n", ord, ts->thread_id);
+#endif
+	for_each_online_cpu(cpu) {
+		if (ord-- =3D=3D 0) {
+			cpumask_set_cpu(cpu, conn->conn_cpumask);
+			return;
+		}
+	}
+	/*
+	 * This should never be reached..
+	 */
+	dump_stack();
+	cpumask_setall(conn->conn_cpumask);
+}
+
+static inline void iscsi_thread_check_cpumask(
+	struct iscsi_conn *conn,
+	struct task_struct *p,
+	int mode)
+{
+	char buf[128];
+	/*
+	 * mode =3D=3D 1 signals iscsi_target_tx_thread() usage.
+	 * mode =3D=3D 0 signals iscsi_target_rx_thread() usage.
+	 */
+	if (mode =3D=3D 1) {
+		if (!(conn->conn_tx_reset_cpumask))
+			return;
+		conn->conn_tx_reset_cpumask =3D 0;
+	} else {
+		if (!(conn->conn_rx_reset_cpumask))
+			return;
+		conn->conn_rx_reset_cpumask =3D 0;
+	}
+	/*
+	 * Update the CPU mask for this single kthread so that
+	 * both TX and RX kthreads are scheduled to run on the
+	 * same CPU.
+	 */
+	memset(buf, 0, 128);
+	cpumask_scnprintf(buf, 128, conn->conn_cpumask);
+#if 0
+	printk(KERN_INFO ">>>>>>>>>>>>>> Calling set_cpus_allowed_ptr():"
+			" %s for %s\n", buf, p->comm);
+#endif
+	set_cpus_allowed_ptr(p, conn->conn_cpumask);
+}
+
+#else
+#define iscsi_thread_get_cpumask(X) ({})
+#define iscsi_thread_check_cpumask(X, Y, Z) ({})
+#endif /* CONFIG_SMP */
+
+int iscsi_target_tx_thread(void *arg)
+{
+	u8 state;
+	int eodr =3D 0, map_sg =3D 0, ret =3D 0, sent_status =3D 0, use_misc =
=3D 0;
+	struct iscsi_cmd *cmd =3D NULL;
+	struct iscsi_conn *conn;
+	struct iscsi_queue_req *qr =3D NULL;
+	struct se_cmd *se_cmd;
+	struct se_thread_set *ts =3D (struct se_thread_set *) arg;
+	struct se_unmap_sg unmap_sg;
+
+	{
+	    char name[20];
+
+	    memset(name, 0, 20);
+	    sprintf(name, "%s/%u", ISCSI_TX_THREAD_NAME, ts->thread_id);
+	    iscsi_daemon(ts->tx_thread, name, SHUTDOWN_SIGS);
+	}
+
+restart:
+	conn =3D iscsi_tx_thread_pre_handler(ts);
+	if (!(conn))
+		goto out;
+
+	eodr =3D map_sg =3D ret =3D sent_status =3D use_misc =3D 0;
+
+	while (1) {
+		/*
+		 * Ensure that both TX and RX per connection kthreads
+		 * are scheduled to run on the same CPU.
+		 */
+		iscsi_thread_check_cpumask(conn, current, 1);
+
+		ret =3D down_interruptible(&conn->tx_sem);
+
+		if ((ts->status =3D=3D ISCSI_THREAD_SET_RESET) ||
+		     (ret !=3D 0) || signal_pending(current))
+			goto transport_err;
+
+get_immediate:
+		qr =3D iscsi_get_cmd_from_immediate_queue(conn);
+		if ((qr)) {
+			atomic_set(&conn->check_immediate_queue, 0);
+			cmd =3D qr->cmd;
+			state =3D qr->state;
+			kmem_cache_free(lio_qr_cache, qr);
+
+			spin_lock_bh(&cmd->istate_lock);
+			switch (state) {
+			case ISTATE_SEND_R2T:
+				spin_unlock_bh(&cmd->istate_lock);
+				ret =3D iscsi_send_r2t(cmd, conn);
+				break;
+			case ISTATE_REMOVE:
+				spin_unlock_bh(&cmd->istate_lock);
+
+				if (cmd->data_direction =3D=3D DMA_TO_DEVICE)
+					iscsi_stop_dataout_timer(cmd);
+
+				spin_lock_bh(&conn->cmd_lock);
+				iscsi_remove_cmd_from_conn_list(cmd, conn);
+				spin_unlock_bh(&conn->cmd_lock);
+				/*
+				 * Determine if a struct se_cmd is assoicated with
+				 * this struct iscsi_cmd.
+				 */
+				if (!(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD) &&
+				    !(cmd->tmr_req))
+					iscsi_release_cmd_to_pool(cmd);
+				else
+					transport_generic_free_cmd(SE_CMD(cmd),
+								1, 1, 0);
+				goto get_immediate;
+			case ISTATE_SEND_NOPIN_WANT_RESPONSE:
+				spin_unlock_bh(&cmd->istate_lock);
+				iscsi_mod_nopin_response_timer(conn);
+				ret =3D iscsi_send_unsolicited_nopin(cmd,
+						conn, 1);
+				break;
+			case ISTATE_SEND_NOPIN_NO_RESPONSE:
+				spin_unlock_bh(&cmd->istate_lock);
+				ret =3D iscsi_send_unsolicited_nopin(cmd,
+						conn, 0);
+				break;
+			default:
+				printk(KERN_ERR "Unknown Opcode: 0x%02x ITT:"
+				" 0x%08x, i_state: %d on CID: %hu\n",
+				cmd->iscsi_opcode, cmd->init_task_tag, state,
+				conn->cid);
+				spin_unlock_bh(&cmd->istate_lock);
+				goto transport_err;
+			}
+			if (ret < 0) {
+				conn->tx_immediate_queue =3D 0;
+				goto transport_err;
+			}
+
+			if (iscsi_send_tx_data(cmd, conn, 1) < 0) {
+				conn->tx_immediate_queue =3D 0;
+				iscsi_tx_thread_wait_for_TCP(conn);
+				goto transport_err;
+			}
+
+			spin_lock_bh(&cmd->istate_lock);
+			switch (state) {
+			case ISTATE_SEND_R2T:
+				spin_unlock_bh(&cmd->istate_lock);
+				spin_lock_bh(&cmd->dataout_timeout_lock);
+				iscsi_start_dataout_timer(cmd, conn);
+				spin_unlock_bh(&cmd->dataout_timeout_lock);
+				break;
+			case ISTATE_SEND_NOPIN_WANT_RESPONSE:
+				cmd->i_state =3D ISTATE_SENT_NOPIN_WANT_RESPONSE;
+				spin_unlock_bh(&cmd->istate_lock);
+				break;
+			case ISTATE_SEND_NOPIN_NO_RESPONSE:
+				cmd->i_state =3D ISTATE_SENT_STATUS;
+				spin_unlock_bh(&cmd->istate_lock);
+				break;
+			default:
+				printk(KERN_ERR "Unknown Opcode: 0x%02x ITT:"
+					" 0x%08x, i_state: %d on CID: %hu\n",
+					cmd->iscsi_opcode, cmd->init_task_tag,
+					state, conn->cid);
+				spin_unlock_bh(&cmd->istate_lock);
+				goto transport_err;
+			}
+			goto get_immediate;
+		} else
+			conn->tx_immediate_queue =3D 0;
+
+get_response:
+		qr =3D iscsi_get_cmd_from_response_queue(conn);
+		if ((qr)) {
+			cmd =3D qr->cmd;
+			state =3D qr->state;
+			kmem_cache_free(lio_qr_cache, qr);
+
+			spin_lock_bh(&cmd->istate_lock);
+check_rsp_state:
+			switch (state) {
+			case ISTATE_SEND_DATAIN:
+				spin_unlock_bh(&cmd->istate_lock);
+				memset((void *)&unmap_sg, 0,
+						sizeof(struct se_unmap_sg));
+				unmap_sg.fabric_cmd =3D (void *)cmd;
+				unmap_sg.se_cmd =3D SE_CMD(cmd);
+				map_sg =3D 1;
+				ret =3D iscsi_send_data_in(cmd, conn,
+						&unmap_sg, &eodr);
+				break;
+			case ISTATE_SEND_STATUS:
+			case ISTATE_SEND_STATUS_RECOVERY:
+				spin_unlock_bh(&cmd->istate_lock);
+				use_misc =3D 1;
+				ret =3D iscsi_send_status(cmd, conn);
+				break;
+			case ISTATE_SEND_LOGOUTRSP:
+				spin_unlock_bh(&cmd->istate_lock);
+				use_misc =3D 1;
+				ret =3D iscsi_send_logout_response(cmd, conn);
+				break;
+			case ISTATE_SEND_ASYNCMSG:
+				spin_unlock_bh(&cmd->istate_lock);
+				use_misc =3D 1;
+				ret =3D iscsi_send_conn_drop_async_message(
+						cmd, conn);
+				break;
+			case ISTATE_SEND_NOPIN:
+				spin_unlock_bh(&cmd->istate_lock);
+				use_misc =3D 1;
+				ret =3D iscsi_send_nopin_response(cmd, conn);
+				break;
+			case ISTATE_SEND_REJECT:
+				spin_unlock_bh(&cmd->istate_lock);
+				use_misc =3D 1;
+				ret =3D iscsi_send_reject(cmd, conn);
+				break;
+			case ISTATE_SEND_TASKMGTRSP:
+				spin_unlock_bh(&cmd->istate_lock);
+				use_misc =3D 1;
+				ret =3D iscsi_send_task_mgt_rsp(cmd, conn);
+				if (ret !=3D 0)
+					break;
+				ret =3D iscsi_tmr_post_handler(cmd, conn);
+				if (ret !=3D 0)
+					iscsi_fall_back_to_erl0(SESS(conn));
+				break;
+			case ISTATE_SEND_TEXTRSP:
+				spin_unlock_bh(&cmd->istate_lock);
+				use_misc =3D 1;
+				ret =3D iscsi_send_text_rsp(cmd, conn);
+				break;
+			default:
+				printk(KERN_ERR "Unknown Opcode: 0x%02x ITT:"
+					" 0x%08x, i_state: %d on CID: %hu\n",
+					cmd->iscsi_opcode, cmd->init_task_tag,
+					state, conn->cid);
+				spin_unlock_bh(&cmd->istate_lock);
+				goto transport_err;
+			}
+			if (ret < 0) {
+				conn->tx_response_queue =3D 0;
+				goto transport_err;
+			}
+
+			se_cmd =3D &cmd->se_cmd;
+
+			if (map_sg && !CONN_OPS(conn)->IFMarker &&
+			    T_TASK(se_cmd)->t_tasks_se_num) {
+				iscsi_map_SG_segments(&unmap_sg);
+				if (iscsi_fe_sendpage_sg(&unmap_sg, conn) < 0) {
+					conn->tx_response_queue =3D 0;
+					iscsi_tx_thread_wait_for_TCP(conn);
+					iscsi_unmap_SG_segments(&unmap_sg);
+					goto transport_err;
+				}
+				iscsi_unmap_SG_segments(&unmap_sg);
+				map_sg =3D 0;
+			} else {
+				if (map_sg)
+					iscsi_map_SG_segments(&unmap_sg);
+				if (iscsi_send_tx_data(cmd, conn, use_misc) < 0) {
+					conn->tx_response_queue =3D 0;
+					iscsi_tx_thread_wait_for_TCP(conn);
+					if (map_sg)
+						iscsi_unmap_SG_segments(&unmap_sg);
+					goto transport_err;
+				}
+				if (map_sg) {
+					iscsi_unmap_SG_segments(&unmap_sg);
+					map_sg =3D 0;
+				}
+			}
+
+			spin_lock_bh(&cmd->istate_lock);
+			switch (state) {
+			case ISTATE_SEND_DATAIN:
+				if (!eodr)
+					goto check_rsp_state;
+
+				if (eodr =3D=3D 1) {
+					cmd->i_state =3D ISTATE_SENT_LAST_DATAIN;
+					sent_status =3D 1;
+					eodr =3D use_misc =3D 0;
+				} else if (eodr =3D=3D 2) {
+					cmd->i_state =3D state =3D
+							ISTATE_SEND_STATUS;
+					sent_status =3D 0;
+					eodr =3D use_misc =3D 0;
+					goto check_rsp_state;
+				}
+				break;
+			case ISTATE_SEND_STATUS:
+				use_misc =3D 0;
+				sent_status =3D 1;
+				break;
+			case ISTATE_SEND_ASYNCMSG:
+			case ISTATE_SEND_NOPIN:
+			case ISTATE_SEND_STATUS_RECOVERY:
+			case ISTATE_SEND_TEXTRSP:
+				use_misc =3D 0;
+				sent_status =3D 1;
+				break;
+			case ISTATE_SEND_REJECT:
+				use_misc =3D 0;
+				if (cmd->cmd_flags & ICF_REJECT_FAIL_CONN) {
+					cmd->cmd_flags &=3D ~ICF_REJECT_FAIL_CONN;
+					spin_unlock_bh(&cmd->istate_lock);
+					up(&cmd->reject_sem);
+					goto transport_err;
+				}
+				up(&cmd->reject_sem);
+				break;
+			case ISTATE_SEND_TASKMGTRSP:
+				use_misc =3D 0;
+				sent_status =3D 1;
+				break;
+			case ISTATE_SEND_LOGOUTRSP:
+				spin_unlock_bh(&cmd->istate_lock);
+				if (!(iscsi_logout_post_handler(cmd, conn)))
+					goto restart;
+				spin_lock_bh(&cmd->istate_lock);
+				use_misc =3D 0;
+				sent_status =3D 1;
+				break;
+			default:
+				printk(KERN_ERR "Unknown Opcode: 0x%02x ITT:"
+					" 0x%08x, i_state: %d on CID: %hu\n",
+					cmd->iscsi_opcode, cmd->init_task_tag,
+					cmd->i_state, conn->cid);
+				spin_unlock_bh(&cmd->istate_lock);
+				goto transport_err;
+			}
+
+			if (sent_status) {
+				cmd->i_state =3D ISTATE_SENT_STATUS;
+				sent_status =3D 0;
+			}
+			spin_unlock_bh(&cmd->istate_lock);
+
+			if (atomic_read(&conn->check_immediate_queue))
+				goto get_immediate;
+
+			goto get_response;
+		} else
+			conn->tx_response_queue =3D 0;
+	}
+
+transport_err:
+	iscsi_take_action_for_connection_exit(conn);
+	goto restart;
+out:
+	ts->tx_thread =3D NULL;
+	up(&ts->tx_done_sem);
+	return 0;
+}
+
+static void iscsi_rx_thread_TCP_timeout(unsigned long data)
+{
+	up((struct semaphore *)data);
+}
+
+/*	iscsi_rx_thread_wait_for_TCP():
+ *
+ *
+ */
+static void iscsi_rx_thread_wait_for_TCP(struct iscsi_conn *conn)
+{
+	struct timer_list rx_TCP_timer;
+	int ret;
+
+	if ((conn->sock->sk->sk_shutdown & SEND_SHUTDOWN) ||
+	    (conn->sock->sk->sk_shutdown & RCV_SHUTDOWN)) {
+		init_timer(&rx_TCP_timer);
+		SETUP_TIMER(rx_TCP_timer, ISCSI_RX_THREAD_TCP_TIMEOUT,
+			&conn->rx_half_close_sem, iscsi_rx_thread_TCP_timeout);
+		add_timer(&rx_TCP_timer);
+
+		ret =3D down_interruptible(&conn->rx_half_close_sem);
+
+		del_timer_sync(&rx_TCP_timer);
+	}
+}
+
+int iscsi_target_rx_thread(void *arg)
+{
+	int ret;
+	u8 buffer[ISCSI_HDR_LEN], opcode;
+	u32 checksum =3D 0, digest =3D 0;
+	struct iscsi_conn *conn =3D NULL;
+	struct se_thread_set *ts =3D (struct se_thread_set *) arg;
+	struct iovec iov;
+	struct scatterlist sg;
+
+	{
+	    char name[20];
+
+	    memset(name, 0, 20);
+	    sprintf(name, "%s/%u", ISCSI_RX_THREAD_NAME, ts->thread_id);
+	    iscsi_daemon(ts->rx_thread, name, SHUTDOWN_SIGS);
+	}
+
+restart:
+	conn =3D iscsi_rx_thread_pre_handler(ts);
+	if (!(conn))
+		goto out;
+
+	while (1) {
+		/*
+		 * Ensure that both TX and RX per connection kthreads
+		 * are scheduled to run on the same CPU.
+		 */
+		iscsi_thread_check_cpumask(conn, current, 0);
+
+		memset((void *)buffer, 0, ISCSI_HDR_LEN);
+		memset((void *)&iov, 0, sizeof(struct iovec));
+
+		iov.iov_base	=3D buffer;
+		iov.iov_len	=3D ISCSI_HDR_LEN;
+
+		ret =3D rx_data(conn, &iov, 1, ISCSI_HDR_LEN);
+		if (ret !=3D ISCSI_HDR_LEN) {
+			iscsi_rx_thread_wait_for_TCP(conn);
+			goto transport_err;
+		}
+
+		/*
+		 * Set conn->bad_hdr for use with REJECT PDUs.
+		 */
+		memcpy(&conn->bad_hdr, &buffer, ISCSI_HDR_LEN);
+
+		if (CONN_OPS(conn)->HeaderDigest) {
+			iov.iov_base	=3D &digest;
+			iov.iov_len	=3D CRC_LEN;
+
+			ret =3D rx_data(conn, &iov, 1, CRC_LEN);
+			if (ret !=3D CRC_LEN) {
+				iscsi_rx_thread_wait_for_TCP(conn);
+				goto transport_err;
+			}
+			crypto_hash_init(&conn->conn_rx_hash);
+
+			sg_init_one(&sg, (u8 *)buffer, ISCSI_HDR_LEN);
+			crypto_hash_update(&conn->conn_rx_hash, &sg,
+					ISCSI_HDR_LEN);
+
+			crypto_hash_final(&conn->conn_rx_hash, (u8 *)&checksum);
+
+			if (digest !=3D checksum) {
+				printk(KERN_ERR "HeaderDigest CRC32C failed,"
+					" received 0x%08x, computed 0x%08x\n",
+					digest, checksum);
+				/*
+				 * Set the PDU to 0xff so it will intentionally
+				 * hit default in the switch below.
+				 */
+				memset((void *)buffer, 0xff, ISCSI_HDR_LEN);
+				spin_lock_bh(&SESS(conn)->session_stats_lock);
+				SESS(conn)->conn_digest_errors++;
+				spin_unlock_bh(&SESS(conn)->session_stats_lock);
+			} else {
+				TRACE(TRACE_DIGEST, "Got HeaderDigest CRC32C"
+						" 0x%08x\n", checksum);
+			}
+		}
+
+		if (conn->conn_state =3D=3D TARG_CONN_STATE_IN_LOGOUT)
+			goto transport_err;
+
+		opcode =3D buffer[0] & ISCSI_OPCODE_MASK;
+
+		if (SESS_OPS_C(conn)->SessionType &&
+		   ((!(opcode & ISCSI_OP_TEXT)) ||
+		    (!(opcode & ISCSI_OP_LOGOUT)))) {
+			printk(KERN_ERR "Received illegal iSCSI Opcode: 0x%02x"
+			" while in Discovery Session, rejecting.\n", opcode);
+			iscsi_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+					buffer, conn);
+			goto transport_err;
+		}
+
+		switch (opcode) {
+		case ISCSI_OP_SCSI_CMD:
+			if (iscsi_handle_scsi_cmd(conn, buffer) < 0)
+				goto transport_err;
+			break;
+		case ISCSI_OP_SCSI_DATA_OUT:
+			if (iscsi_handle_data_out(conn, buffer) < 0)
+				goto transport_err;
+			break;
+		case ISCSI_OP_NOOP_OUT:
+			if (iscsi_handle_nop_out(conn, buffer) < 0)
+				goto transport_err;
+			break;
+		case ISCSI_OP_SCSI_TMFUNC:
+			if (iscsi_handle_task_mgt_cmd(conn, buffer) < 0)
+				goto transport_err;
+			break;
+		case ISCSI_OP_TEXT:
+			if (iscsi_handle_text_cmd(conn, buffer) < 0)
+				goto transport_err;
+			break;
+		case ISCSI_OP_LOGOUT:
+			ret =3D iscsi_handle_logout_cmd(conn, buffer);
+			if (ret > 0) {
+				down(&conn->conn_logout_sem);
+				goto transport_err;
+			} else if (ret < 0)
+				goto transport_err;
+			break;
+		case ISCSI_OP_SNACK:
+			if (iscsi_handle_snack(conn, buffer) < 0)
+				goto transport_err;
+			break;
+		default:
+			printk(KERN_ERR "Got unknown iSCSI OpCode: 0x%02x\n",
+					opcode);
+			if (!SESS_OPS_C(conn)->ErrorRecoveryLevel) {
+				printk(KERN_ERR "Cannot recover from unknown"
+				" opcode while ERL=3D0, closing iSCSI connection"
+				".\n");
+				goto transport_err;
+			}
+			if (!CONN_OPS(conn)->OFMarker) {
+				printk(KERN_ERR "Unable to recover from unknown"
+				" opcode while OFMarker=3DNo, closing iSCSI"
+					" connection.\n");
+				goto transport_err;
+			}
+			if (iscsi_recover_from_unknown_opcode(conn) < 0) {
+				printk(KERN_ERR "Unable to recover from unknown"
+					" opcode, closing iSCSI connection.\n");
+				goto transport_err;
+			}
+			break;
+		}
+	}
+
+transport_err:
+	if (!signal_pending(current))
+		atomic_set(&conn->transport_failed, 1);
+	iscsi_take_action_for_connection_exit(conn);
+	goto restart;
+out:
+	ts->rx_thread =3D NULL;
+	up(&ts->rx_done_sem);
+	return 0;
+}
+
+/*	iscsi_release_commands_from_conn():
+ *
+ *
+ */
+static void iscsi_release_commands_from_conn(struct iscsi_conn *conn)
+{
+	struct iscsi_cmd *cmd =3D NULL, *cmd_tmp =3D NULL;
+	struct iscsi_session *sess =3D SESS(conn);
+	struct se_cmd *se_cmd;
+
+	spin_lock_bh(&conn->cmd_lock);
+	list_for_each_entry_safe(cmd, cmd_tmp, &conn->conn_cmd_list, i_list) =
{
+		if (!(SE_CMD(cmd)) ||
+		    !(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD)) {
+
+			list_del(&cmd->i_list);
+			spin_unlock_bh(&conn->cmd_lock);
+			iscsi_increment_maxcmdsn(cmd, sess);
+			se_cmd =3D SE_CMD(cmd);
+			/*
+			 * Special cases for active iSCSI TMR, and
+			 * transport_get_lun_for_cmd() failing from
+			 * iscsi_get_lun_for_cmd() in iscsi_handle_scsi_cmd().
+			 */
+			if (cmd->tmr_req && se_cmd->transport_wait_for_tasks)
+				se_cmd->transport_wait_for_tasks(se_cmd, 1, 1);
+			else if (SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD)
+				transport_release_cmd_to_pool(se_cmd);
+			else
+				__iscsi_release_cmd_to_pool(cmd, sess);
+
+			spin_lock_bh(&conn->cmd_lock);
+			continue;
+		}
+		list_del(&cmd->i_list);
+		spin_unlock_bh(&conn->cmd_lock);
+
+		iscsi_increment_maxcmdsn(cmd, sess);
+		se_cmd =3D SE_CMD(cmd);
+
+		if (se_cmd->transport_wait_for_tasks)
+			se_cmd->transport_wait_for_tasks(se_cmd, 1, 1);
+
+		spin_lock_bh(&conn->cmd_lock);
+	}
+	spin_unlock_bh(&conn->cmd_lock);
+}
+
+/*	iscsi_stop_timers_for_cmds():
+ *
+ *
+ */
+static void iscsi_stop_timers_for_cmds(
+	struct iscsi_conn *conn)
+{
+	struct iscsi_cmd *cmd;
+
+	spin_lock_bh(&conn->cmd_lock);
+	list_for_each_entry(cmd, &conn->conn_cmd_list, i_list) {
+		if (cmd->data_direction =3D=3D DMA_TO_DEVICE)
+			iscsi_stop_dataout_timer(cmd);
+	}
+	spin_unlock_bh(&conn->cmd_lock);
+}
+
+int iscsi_close_connection(
+	struct iscsi_conn *conn)
+{
+	int conn_logout =3D (conn->conn_state =3D=3D TARG_CONN_STATE_IN_LOGOU=
T);
+	struct iscsi_session	*sess =3D SESS(conn);
+
+	TRACE(TRACE_ISCSI, "Closing iSCSI connection CID %hu on SID:"
+		" %u\n", conn->cid, sess->sid);
+
+	iscsi_stop_netif_timer(conn);
+
+	/*
+	 * Always up conn_logout_sem just in case the RX Thread is sleeping
+	 * and the logout response never got sent because the connection
+	 * failed.
+	 */
+	up(&conn->conn_logout_sem);
+
+	iscsi_release_thread_set(conn);
+
+	iscsi_stop_timers_for_cmds(conn);
+	iscsi_stop_nopin_response_timer(conn);
+	iscsi_stop_nopin_timer(conn);
+	iscsi_free_queue_reqs_for_conn(conn);
+
+	/*
+	 * During Connection recovery drop unacknowledged out of order
+	 * commands for this connection, and prepare the other commands
+	 * for realligence.
+	 *
+	 * During normal operation clear the out of order commands (but
+	 * do not free the struct iscsi_ooo_cmdsn's) and release all
+	 * struct iscsi_cmds.
+	 */
+	if (atomic_read(&conn->connection_recovery)) {
+		iscsi_discard_unacknowledged_ooo_cmdsns_for_conn(conn);
+		iscsi_prepare_cmds_for_realligance(conn);
+	} else {
+		iscsi_clear_ooo_cmdsns_for_conn(conn);
+		iscsi_release_commands_from_conn(conn);
+	}
+
+	/*
+	 * Handle decrementing session or connection usage count if
+	 * a logout response was not able to be sent because the
+	 * connection failed.  Fall back to Session Recovery here.
+	 */
+	if (atomic_read(&conn->conn_logout_remove)) {
+		if (conn->conn_logout_reason =3D=3D ISCSI_LOGOUT_REASON_CLOSE_SESSIO=
N) {
+			iscsi_dec_conn_usage_count(conn);
+			iscsi_dec_session_usage_count(sess);
+		}
+		if (conn->conn_logout_reason =3D=3D ISCSI_LOGOUT_REASON_CLOSE_CONNEC=
TION)
+			iscsi_dec_conn_usage_count(conn);
+
+		atomic_set(&conn->conn_logout_remove, 0);
+		atomic_set(&sess->session_reinstatement, 0);
+		atomic_set(&sess->session_fall_back_to_erl0, 1);
+	}
+
+	spin_lock_bh(&sess->conn_lock);
+	iscsi_remove_conn_from_list(sess, conn);
+
+	/*
+	 * Attempt to let the Initiator know this connection failed by
+	 * sending an Connection Dropped Async Message on another
+	 * active connection.
+	 */
+	if (atomic_read(&conn->connection_recovery))
+		iscsi_build_conn_drop_async_message(conn);
+
+	spin_unlock_bh(&sess->conn_lock);
+
+	/*
+	 * If connection reinstatement is being performed on this connection,
+	 * up the connection reinstatement semaphore that is being blocked on
+	 * in iscsi_cause_connection_reinstatement().
+	 */
+	spin_lock_bh(&conn->state_lock);
+	if (atomic_read(&conn->sleep_on_conn_wait_sem)) {
+		spin_unlock_bh(&conn->state_lock);
+		up(&conn->conn_wait_sem);
+		down(&conn->conn_post_wait_sem);
+		spin_lock_bh(&conn->state_lock);
+	}
+
+	/*
+	 * If connection reinstatement is being performed on this connection
+	 * by receiving a REMOVECONNFORRECOVERY logout request, up the
+	 * connection wait rcfr semaphore that is being blocked on
+	 * an iscsi_connection_reinstatement_rcfr().
+	 */
+	if (atomic_read(&conn->connection_wait_rcfr)) {
+		spin_unlock_bh(&conn->state_lock);
+		up(&conn->conn_wait_rcfr_sem);
+		down(&conn->conn_post_wait_sem);
+		spin_lock_bh(&conn->state_lock);
+	}
+	atomic_set(&conn->connection_reinstatement, 1);
+	spin_unlock_bh(&conn->state_lock);
+
+	/*
+	 * If any other processes are accessing this connection pointer we
+	 * must wait until they have completed.
+	 */
+	iscsi_check_conn_usage_count(conn);
+
+	if (conn->conn_rx_hash.tfm)
+		crypto_free_hash(conn->conn_rx_hash.tfm);
+	if (conn->conn_tx_hash.tfm)
+		crypto_free_hash(conn->conn_tx_hash.tfm);
+
+	if (conn->conn_cpumask)
+		free_cpumask_var(conn->conn_cpumask);
+
+	kfree(conn->conn_ops);
+	conn->conn_ops =3D NULL;
+
+	if (conn->sock) {
+		if (conn->conn_flags & CONNFLAG_SCTP_STRUCT_FILE) {
+			kfree(conn->sock->file);
+			conn->sock->file =3D NULL;
+		}
+		sock_release(conn->sock);
+	}
+
+	TRACE(TRACE_STATE, "Moving to TARG_CONN_STATE_FREE.\n");
+	conn->conn_state =3D TARG_CONN_STATE_FREE;
+	kmem_cache_free(lio_conn_cache, conn);
+	conn =3D NULL;
+
+	spin_lock_bh(&sess->conn_lock);
+	atomic_dec(&sess->nconn);
+	printk(KERN_INFO "Decremented iSCSI connection count to %hu from node=
:"
+		" %s\n", atomic_read(&sess->nconn),
+		SESS_OPS(sess)->InitiatorName);
+	/*
+	 * Make sure that if one connection fails in an non ERL=3D2 iSCSI
+	 * Session that they all fail.
+	 */
+	if ((SESS_OPS(sess)->ErrorRecoveryLevel !=3D 2) && !conn_logout &&
+	     !atomic_read(&sess->session_logout))
+		atomic_set(&sess->session_fall_back_to_erl0, 1);
+
+	/*
+	 * If this was not the last connection in the session, and we are
+	 * performing session reinstatement or falling back to ERL=3D0, call
+	 * iscsi_stop_session() without sleeping to shutdown the other
+	 * active connections.
+	 */
+	if (atomic_read(&sess->nconn)) {
+		if (!atomic_read(&sess->session_reinstatement) &&
+		    !atomic_read(&sess->session_fall_back_to_erl0)) {
+			spin_unlock_bh(&sess->conn_lock);
+			return 0;
+		}
+		if (!atomic_read(&sess->session_stop_active)) {
+			atomic_set(&sess->session_stop_active, 1);
+			spin_unlock_bh(&sess->conn_lock);
+			iscsi_stop_session(sess, 0, 0);
+			return 0;
+		}
+		spin_unlock_bh(&sess->conn_lock);
+		return 0;
+	}
+
+	/*
+	 * If this was the last connection in the session and one of the
+	 * following is occurring:
+	 *
+	 * Session Reinstatement is not being performed, and are falling back
+	 * to ERL=3D0 call iscsi_close_session().
+	 *
+	 * Session Logout was requested.  iscsi_close_session() will be calle=
d
+	 * elsewhere.
+	 *
+	 * Session Continuation is not being performed, start the Time2Retain
+	 * handler and check if sleep_on_sess_wait_sem is active.
+	 */
+	if (!atomic_read(&sess->session_reinstatement) &&
+	     atomic_read(&sess->session_fall_back_to_erl0)) {
+		spin_unlock_bh(&sess->conn_lock);
+		iscsi_close_session(sess);
+
+		return 0;
+	} else if (atomic_read(&sess->session_logout)) {
+		TRACE(TRACE_STATE, "Moving to TARG_SESS_STATE_FREE.\n");
+		sess->session_state =3D TARG_SESS_STATE_FREE;
+		spin_unlock_bh(&sess->conn_lock);
+
+		if (atomic_read(&sess->sleep_on_sess_wait_sem))
+			up(&sess->session_wait_sem);
+
+		return 0;
+	} else {
+		TRACE(TRACE_STATE, "Moving to TARG_SESS_STATE_FAILED.\n");
+		sess->session_state =3D TARG_SESS_STATE_FAILED;
+
+		if (!atomic_read(&sess->session_continuation)) {
+			spin_unlock_bh(&sess->conn_lock);
+			iscsi_start_time2retain_handler(sess);
+		} else
+			spin_unlock_bh(&sess->conn_lock);
+
+		if (atomic_read(&sess->sleep_on_sess_wait_sem))
+			up(&sess->session_wait_sem);
+
+		return 0;
+	}
+	spin_unlock_bh(&sess->conn_lock);
+
+	return 0;
+}
+
+int iscsi_close_session(struct iscsi_session *sess)
+{
+	struct iscsi_portal_group *tpg =3D ISCSI_TPG_S(sess);
+	struct se_portal_group *se_tpg =3D &tpg->tpg_se_tpg;
+
+	if (atomic_read(&sess->nconn)) {
+		printk(KERN_ERR "%d connection(s) still exist for iSCSI session"
+			" to %s\n", atomic_read(&sess->nconn),
+			SESS_OPS(sess)->InitiatorName);
+		BUG();
+	}
+
+	spin_lock_bh(&se_tpg->session_lock);
+	atomic_set(&sess->session_logout, 1);
+	atomic_set(&sess->session_reinstatement, 1);
+	iscsi_stop_time2retain_timer(sess);
+	spin_unlock_bh(&se_tpg->session_lock);
+
+	/*
+	 * transport_deregister_session_configfs() will clear the
+	 * struct se_node_acl->nacl_sess pointer now as a iscsi_np process co=
ntext
+	 * can be setting it again with __transport_register_session() in
+	 * iscsi_post_login_handler() again after the iscsi_stop_session()
+	 * completes in iscsi_np context.
+	 */
+	transport_deregister_session_configfs(sess->se_sess);
+
+	/*
+	 * If any other processes are accessing this session pointer we must
+	 * wait until they have completed.  If we are in an interrupt (the
+	 * time2retain handler) and contain and active session usage count we
+	 * restart the timer and exit.
+	 */
+	if (!in_interrupt()) {
+		if (iscsi_check_session_usage_count(sess) =3D=3D 1)
+			iscsi_stop_session(sess, 1, 1);
+	} else {
+		if (iscsi_check_session_usage_count(sess) =3D=3D 2) {
+			atomic_set(&sess->session_logout, 0);
+			iscsi_start_time2retain_handler(sess);
+			return 0;
+		}
+	}
+
+	transport_deregister_session(sess->se_sess);
+
+	if (SESS_OPS(sess)->ErrorRecoveryLevel =3D=3D 2)
+		iscsi_free_connection_recovery_entires(sess);
+
+	iscsi_free_all_ooo_cmdsns(sess);
+
+	spin_lock_bh(&se_tpg->session_lock);
+	TRACE(TRACE_STATE, "Moving to TARG_SESS_STATE_FREE.\n");
+	sess->session_state =3D TARG_SESS_STATE_FREE;
+	printk(KERN_INFO "Released iSCSI session from node: %s\n",
+			SESS_OPS(sess)->InitiatorName);
+	tpg->nsessions--;
+	if (tpg->tpg_tiqn)
+		tpg->tpg_tiqn->tiqn_nsessions--;
+
+	printk(KERN_INFO "Decremented number of active iSCSI Sessions on"
+		" iSCSI TPG: %hu to %u\n", tpg->tpgt, tpg->nsessions);
+
+	kfree(sess->sess_ops);
+	sess->sess_ops =3D NULL;
+	spin_unlock_bh(&se_tpg->session_lock);
+
+	kmem_cache_free(lio_sess_cache, sess);
+	sess =3D NULL;
+	return 0;
+}
+
+static void iscsi_logout_post_handler_closesession(
+	struct iscsi_conn *conn)
+{
+	struct iscsi_session *sess =3D SESS(conn);
+
+	iscsi_set_thread_clear(conn, ISCSI_CLEAR_TX_THREAD);
+	iscsi_set_thread_set_signal(conn, ISCSI_SIGNAL_TX_THREAD);
+
+	atomic_set(&conn->conn_logout_remove, 0);
+	up(&conn->conn_logout_sem);
+
+	iscsi_dec_conn_usage_count(conn);
+	iscsi_stop_session(sess, 1, 1);
+	iscsi_dec_session_usage_count(sess);
+	iscsi_close_session(sess);
+}
+
+static void iscsi_logout_post_handler_samecid(
+	struct iscsi_conn *conn)
+{
+	iscsi_set_thread_clear(conn, ISCSI_CLEAR_TX_THREAD);
+	iscsi_set_thread_set_signal(conn, ISCSI_SIGNAL_TX_THREAD);
+
+	atomic_set(&conn->conn_logout_remove, 0);
+	up(&conn->conn_logout_sem);
+
+	iscsi_cause_connection_reinstatement(conn, 1);
+	iscsi_dec_conn_usage_count(conn);
+}
+
+static void iscsi_logout_post_handler_diffcid(
+	struct iscsi_conn *conn,
+	u16 cid)
+{
+	struct iscsi_conn *l_conn;
+	struct iscsi_session *sess =3D SESS(conn);
+
+	if (!sess)
+		return;
+
+	spin_lock_bh(&sess->conn_lock);
+	list_for_each_entry(l_conn, &sess->sess_conn_list, conn_list) {
+		if (l_conn->cid =3D=3D cid) {
+			iscsi_inc_conn_usage_count(l_conn);
+			break;
+		}
+	}
+	spin_unlock_bh(&sess->conn_lock);
+
+	if (!l_conn)
+		return;
+
+	if (l_conn->sock)
+		l_conn->sock->ops->shutdown(l_conn->sock, RCV_SHUTDOWN);
+
+	spin_lock_bh(&l_conn->state_lock);
+	TRACE(TRACE_STATE, "Moving to TARG_CONN_STATE_IN_LOGOUT.\n");
+	l_conn->conn_state =3D TARG_CONN_STATE_IN_LOGOUT;
+	spin_unlock_bh(&l_conn->state_lock);
+
+	iscsi_cause_connection_reinstatement(l_conn, 1);
+	iscsi_dec_conn_usage_count(l_conn);
+}
+
+/*	iscsi_logout_post_handler():
+ *
+ *	Return of 0 causes the TX thread to restart.
+ */
+static int iscsi_logout_post_handler(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	int ret =3D 0;
+
+	switch (cmd->logout_reason) {
+	case ISCSI_LOGOUT_REASON_CLOSE_SESSION:
+		switch (cmd->logout_response) {
+		case ISCSI_LOGOUT_SUCCESS:
+		case ISCSI_LOGOUT_CLEANUP_FAILED:
+		default:
+			iscsi_logout_post_handler_closesession(conn);
+			break;
+		}
+		ret =3D 0;
+		break;
+	case ISCSI_LOGOUT_REASON_CLOSE_CONNECTION:
+		if (conn->cid =3D=3D cmd->logout_cid) {
+			switch (cmd->logout_response) {
+			case ISCSI_LOGOUT_SUCCESS:
+			case ISCSI_LOGOUT_CLEANUP_FAILED:
+			default:
+				iscsi_logout_post_handler_samecid(conn);
+				break;
+			}
+			ret =3D 0;
+		} else {
+			switch (cmd->logout_response) {
+			case ISCSI_LOGOUT_SUCCESS:
+				iscsi_logout_post_handler_diffcid(conn,
+					cmd->logout_cid);
+				break;
+			case ISCSI_LOGOUT_CID_NOT_FOUND:
+			case ISCSI_LOGOUT_CLEANUP_FAILED:
+			default:
+				break;
+			}
+			ret =3D 1;
+		}
+		break;
+	case ISCSI_LOGOUT_REASON_RECOVERY:
+		switch (cmd->logout_response) {
+		case ISCSI_LOGOUT_SUCCESS:
+		case ISCSI_LOGOUT_CID_NOT_FOUND:
+		case ISCSI_LOGOUT_RECOVERY_UNSUPPORTED:
+		case ISCSI_LOGOUT_CLEANUP_FAILED:
+		default:
+			break;
+		}
+		ret =3D 1;
+		break;
+	default:
+		break;
+
+	}
+	return ret;
+}
+
+void iscsi_fail_session(struct iscsi_session *sess)
+{
+	struct iscsi_conn *conn;
+
+	spin_lock_bh(&sess->conn_lock);
+	list_for_each_entry(conn, &sess->sess_conn_list, conn_list) {
+		TRACE(TRACE_STATE, "Moving to TARG_CONN_STATE_CLEANUP_WAIT.\n");
+		conn->conn_state =3D TARG_CONN_STATE_CLEANUP_WAIT;
+	}
+	spin_unlock_bh(&sess->conn_lock);
+
+	TRACE(TRACE_STATE, "Moving to TARG_SESS_STATE_FAILED.\n");
+	sess->session_state =3D TARG_SESS_STATE_FAILED;
+}
+
+int iscsi_free_session(struct iscsi_session *sess)
+{
+	u16 conn_count =3D atomic_read(&sess->nconn);
+	struct iscsi_conn *conn, *conn_tmp;
+
+	spin_lock_bh(&sess->conn_lock);
+	atomic_set(&sess->sleep_on_sess_wait_sem, 1);
+
+	list_for_each_entry_safe(conn, conn_tmp, &sess->sess_conn_list,
+			conn_list) {
+		if (conn_count =3D=3D 0)
+			break;
+
+		iscsi_inc_conn_usage_count(conn);
+		spin_unlock_bh(&sess->conn_lock);
+		iscsi_cause_connection_reinstatement(conn, 1);
+		spin_lock_bh(&sess->conn_lock);
+
+		iscsi_dec_conn_usage_count(conn);
+		conn_count--;
+	}
+
+	if (atomic_read(&sess->nconn)) {
+		spin_unlock_bh(&sess->conn_lock);
+		down(&sess->session_wait_sem);
+	} else
+		spin_unlock_bh(&sess->conn_lock);
+
+	iscsi_close_session(sess);
+	return 0;
+}
+
+void iscsi_stop_session(
+	struct iscsi_session *sess,
+	int session_sleep,
+	int connection_sleep)
+{
+	u16 conn_count =3D atomic_read(&sess->nconn);
+	struct iscsi_conn *conn, *conn_tmp =3D NULL;
+
+	spin_lock_bh(&sess->conn_lock);
+	if (session_sleep)
+		atomic_set(&sess->sleep_on_sess_wait_sem, 1);
+
+	if (connection_sleep) {
+		list_for_each_entry_safe(conn, conn_tmp, &sess->sess_conn_list,
+				conn_list) {
+			if (conn_count =3D=3D 0)
+				break;
+
+			iscsi_inc_conn_usage_count(conn);
+			spin_unlock_bh(&sess->conn_lock);
+			iscsi_cause_connection_reinstatement(conn, 1);
+			spin_lock_bh(&sess->conn_lock);
+
+			iscsi_dec_conn_usage_count(conn);
+			conn_count--;
+		}
+	} else {
+		list_for_each_entry(conn, &sess->sess_conn_list, conn_list)
+			iscsi_cause_connection_reinstatement(conn, 0);
+	}
+
+	if (session_sleep && atomic_read(&sess->nconn)) {
+		spin_unlock_bh(&sess->conn_lock);
+		down(&sess->session_wait_sem);
+	} else
+		spin_unlock_bh(&sess->conn_lock);
+}
+
+/*	iscsi_release_sessions_for_tpg():
+ *
+ *
+ */
+int iscsi_release_sessions_for_tpg(struct iscsi_portal_group *tpg, int=
 force)
+{
+	struct iscsi_session *sess;
+	struct se_portal_group *se_tpg =3D &tpg->tpg_se_tpg;
+	struct se_session *se_sess, *se_sess_tmp;
+	int session_count =3D 0;
+
+	spin_lock_bh(&se_tpg->session_lock);
+	if (tpg->nsessions && !force) {
+		spin_unlock_bh(&se_tpg->session_lock);
+		return -1;
+	}
+
+	list_for_each_entry_safe(se_sess, se_sess_tmp, &se_tpg->tpg_sess_list=
,
+			sess_list) {
+		sess =3D (struct iscsi_session *)se_sess->fabric_sess_ptr;
+
+		spin_lock(&sess->conn_lock);
+		if (atomic_read(&sess->session_fall_back_to_erl0) ||
+		    atomic_read(&sess->session_logout) ||
+		    (sess->time2retain_timer_flags & ISCSI_TF_EXPIRED)) {
+			spin_unlock(&sess->conn_lock);
+			continue;
+		}
+		atomic_set(&sess->session_reinstatement, 1);
+		spin_unlock(&sess->conn_lock);
+		spin_unlock_bh(&se_tpg->session_lock);
+
+		iscsi_free_session(sess);
+		spin_lock_bh(&se_tpg->session_lock);
+
+		session_count++;
+	}
+	spin_unlock_bh(&se_tpg->session_lock);
+
+	TRACE(TRACE_ISCSI, "Released %d iSCSI Session(s) from Target Portal"
+			" Group: %hu\n", session_count, tpg->tpgt);
+	return 0;
+}
+
+static int __init iscsi_target_init_module(void)
+{
+	if (!(iscsi_target_detect()))
+		return 0;
+
+	return -1;
+}
+
+static void __exit iscsi_target_cleanup_module(void)
+{
+	iscsi_target_release();
+}
+
+#ifdef MODULE
+MODULE_DESCRIPTION("LIO Target Driver Core 4.x.x Release");
+MODULE_LICENSE("GPL");
+module_init(iscsi_target_init_module);
+module_exit(iscsi_target_cleanup_module);
+#endif /* MODULE */
diff --git a/drivers/target/iscsi/iscsi_target.h b/drivers/target/iscsi=
/iscsi_target.h
new file mode 100644
index 0000000..25d56c1
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target.h
@@ -0,0 +1,49 @@
+#ifndef ISCSI_TARGET_H
+#define ISCSI_TARGET_H
+
+extern struct iscsi_tiqn *core_get_tiqn_for_login(unsigned char *);
+extern struct iscsi_tiqn *core_get_tiqn(unsigned char *, int);
+extern void core_put_tiqn_for_login(struct iscsi_tiqn *);
+extern struct iscsi_tiqn *core_add_tiqn(unsigned char *, int *);
+extern int core_del_tiqn(struct iscsi_tiqn *);
+extern int core_access_np(struct iscsi_np *, struct iscsi_portal_group=
 *);
+extern int core_deaccess_np(struct iscsi_np *, struct iscsi_portal_gro=
up *);
+extern void *core_get_np_ip(struct iscsi_np *np);
+extern struct iscsi_np *core_get_np(void *, u16, int);
+extern int __core_del_np_ex(struct iscsi_np *, struct iscsi_np_ex *);
+extern struct iscsi_np *core_add_np(struct iscsi_np_addr *, int, int *=
);
+extern int core_reset_np_thread(struct iscsi_np *, struct iscsi_tpg_np=
 *,
+				struct iscsi_portal_group *, int);
+extern int core_del_np(struct iscsi_np *);
+extern u32 iscsi_get_new_index(iscsi_index_t);
+extern char *iscsi_get_fabric_name(void);
+extern struct iscsi_cmd *iscsi_get_cmd(struct se_cmd *);
+extern u32 iscsi_get_task_tag(struct se_cmd *);
+extern int iscsi_get_cmd_state(struct se_cmd *);
+extern void iscsi_new_cmd_failure(struct se_cmd *);
+extern int iscsi_is_state_remove(struct se_cmd *);
+extern int lio_sess_logged_in(struct se_session *);
+extern u32 lio_sess_get_index(struct se_session *);
+extern u32 lio_sess_get_initiator_sid(struct se_session *,
+				unsigned char *, u32);
+extern int iscsi_send_async_msg(struct iscsi_conn *, u16, u8, u8);
+extern int lio_queue_data_in(struct se_cmd *);
+extern int iscsi_send_r2t(struct iscsi_cmd *, struct iscsi_conn *);
+extern int iscsi_build_r2ts_for_cmd(struct iscsi_cmd *, struct iscsi_c=
onn *, int);
+extern int lio_write_pending(struct se_cmd *);
+extern int lio_write_pending_status(struct se_cmd *);
+extern int lio_queue_status(struct se_cmd *);
+extern u16 lio_set_fabric_sense_len(struct se_cmd *, u32);
+extern u16 lio_get_fabric_sense_len(void);
+extern int lio_queue_tm_rsp(struct se_cmd *);
+extern void iscsi_thread_get_cpumask(struct iscsi_conn *);
+extern int iscsi_target_tx_thread(void *);
+extern int iscsi_target_rx_thread(void *);
+extern int iscsi_close_connection(struct iscsi_conn *);
+extern int iscsi_close_session(struct iscsi_session *);
+extern void iscsi_fail_session(struct iscsi_session *);
+extern int iscsi_free_session(struct iscsi_session *);
+extern void iscsi_stop_session(struct iscsi_session *, int, int);
+extern int iscsi_release_sessions_for_tpg(struct iscsi_portal_group *,=
 int);
+
+#endif   /*** ISCSI_TARGET_H ***/
diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/=
iscsi/iscsi_target_core.h
new file mode 100644
index 0000000..def20a3
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_core.h
@@ -0,0 +1,962 @@
+#ifndef ISCSI_TARGET_CORE_H
+#define ISCSI_TARGET_CORE_H
+
+#include <linux/in.h>
+#include <linux/configfs.h>
+#include <net/sock.h>
+#include <net/tcp.h>
+#include <scsi/scsi_cmnd.h>
+#include <target/target_core_base.h>
+
+#define ISCSI_VERSION			"v4.1.0-rc1"
+#define SHUTDOWN_SIGS	(sigmask(SIGKILL)|sigmask(SIGINT)|sigmask(SIGABR=
T))
+#define ISCSI_MAX_DATASN_MISSING_COUNT	16
+#define ISCSI_TX_THREAD_TCP_TIMEOUT	2
+#define ISCSI_RX_THREAD_TCP_TIMEOUT	2
+#define SECONDS_FOR_ASYNC_LOGOUT	10
+#define SECONDS_FOR_ASYNC_TEXT		10
+#define IPV4_ADDRESS_SPACE		4
+#define IPV4_BUF_SIZE			18
+#define ISCSI_HDR_LEN			48
+#define CRC_LEN				4
+#define MAX_KEY_NAME_LENGTH		63
+#define MAX_KEY_VALUE_LENGTH		255
+#define WHITE_SPACE			" \t\v\f\n\r"
+
+/* struct iscsi_node_attrib sanity values */
+#define NA_DATAOUT_TIMEOUT		3
+#define NA_DATAOUT_TIMEOUT_MAX		60
+#define NA_DATAOUT_TIMEOUT_MIX		2
+#define NA_DATAOUT_TIMEOUT_RETRIES	5
+#define NA_DATAOUT_TIMEOUT_RETRIES_MAX	15
+#define NA_DATAOUT_TIMEOUT_RETRIES_MIN	1
+#define NA_NOPIN_TIMEOUT		5
+#define NA_NOPIN_TIMEOUT_MAX		60
+#define NA_NOPIN_TIMEOUT_MIN		3
+#define NA_NOPIN_RESPONSE_TIMEOUT	5
+#define NA_NOPIN_RESPONSE_TIMEOUT_MAX	60
+#define NA_NOPIN_RESPONSE_TIMEOUT_MIN	3
+#define NA_RANDOM_DATAIN_PDU_OFFSETS	0
+#define NA_RANDOM_DATAIN_SEQ_OFFSETS	0
+#define NA_RANDOM_R2T_OFFSETS		0
+#define NA_DEFAULT_ERL			0
+#define NA_DEFAULT_ERL_MAX		2
+#define NA_DEFAULT_ERL_MIN		0
+
+/* struct iscsi_tpg_attrib sanity values */
+#define TA_AUTHENTICATION		1
+#define TA_LOGIN_TIMEOUT		15
+#define TA_LOGIN_TIMEOUT_MAX		30
+#define TA_LOGIN_TIMEOUT_MIN		5
+#define TA_NETIF_TIMEOUT		2
+#define TA_NETIF_TIMEOUT_MAX		15
+#define TA_NETIF_TIMEOUT_MIN		2
+#define TA_GENERATE_NODE_ACLS		0
+#define TA_DEFAULT_CMDSN_DEPTH		16
+#define TA_DEFAULT_CMDSN_DEPTH_MAX	512
+#define TA_DEFAULT_CMDSN_DEPTH_MIN	1
+#define TA_CACHE_DYNAMIC_ACLS		0
+/* Enabled by default in demo mode (generic_node_acls=3D1) */
+#define TA_DEMO_MODE_WRITE_PROTECT	1
+/* Disabled by default in production mode w/ explict ACLs */
+#define TA_PROD_MODE_WRITE_PROTECT	0
+#define TA_CACHE_CORE_NPS		0
+/*
+ * Handy macros for threads and timers
+ */
+#define iscsi_daemon(thread, name, sigs)		\
+do {							\
+	daemonize(name);				\
+	current->policy =3D SCHED_NORMAL;			\
+	set_user_nice(current, -20);			\
+	spin_lock_irq(&current->sighand->siglock);	\
+	siginitsetinv(&current->blocked, (sigs));	\
+	recalc_sigpending();				\
+	(thread) =3D current;				\
+	spin_unlock_irq(&current->sighand->siglock);	\
+} while (0);
+
+#define MOD_TIMER(t, exp) mod_timer(t, (get_jiffies_64() + exp * HZ))
+#define SETUP_TIMER(timer, t, d, func)			\
+	timer.expires	=3D (get_jiffies_64() + t * HZ);	\
+	timer.data	=3D (unsigned long) d;		\
+	timer.function	=3D func;
+
+enum tpg_np_network_transport_table {
+	ISCSI_TCP				=3D 0,
+	ISCSI_SCTP_TCP				=3D 1,
+	ISCSI_SCTP_UDP				=3D 2,
+	ISCSI_IWARP_TCP				=3D 3,
+	ISCSI_IWARP_SCTP			=3D 4,
+	ISCSI_INFINIBAND			=3D 5,
+};
+
+/* RFC-3720 7.1.4  Standard Connection State Diagram for a Target */
+enum target_conn_state_table {
+	TARG_CONN_STATE_FREE			=3D 0x1,
+	TARG_CONN_STATE_XPT_UP			=3D 0x3,
+	TARG_CONN_STATE_IN_LOGIN		=3D 0x4,
+	TARG_CONN_STATE_LOGGED_IN		=3D 0x5,
+	TARG_CONN_STATE_IN_LOGOUT		=3D 0x6,
+	TARG_CONN_STATE_LOGOUT_REQUESTED	=3D 0x7,
+	TARG_CONN_STATE_CLEANUP_WAIT		=3D 0x8,
+};
+
+/* RFC-3720 7.3.2  Session State Diagram for a Target */
+enum target_sess_state_table {
+	TARG_SESS_STATE_FREE			=3D 0x1,
+	TARG_SESS_STATE_ACTIVE			=3D 0x2,
+	TARG_SESS_STATE_LOGGED_IN		=3D 0x3,
+	TARG_SESS_STATE_FAILED			=3D 0x4,
+	TARG_SESS_STATE_IN_CONTINUE		=3D 0x5,
+};
+
+/* struct iscsi_data_count->type */
+enum data_count_type {
+	ISCSI_RX_DATA	=3D 1,
+	ISCSI_TX_DATA	=3D 2,
+};
+
+/* struct iscsi_datain_req->dr_complete */
+enum datain_req_comp_table {
+	DATAIN_COMPLETE_NORMAL			=3D 1,
+	DATAIN_COMPLETE_WITHIN_COMMAND_RECOVERY =3D 2,
+	DATAIN_COMPLETE_CONNECTION_RECOVERY	=3D 3,
+};
+
+/* struct iscsi_datain_req->recovery */
+enum datain_req_rec_table {
+	DATAIN_WITHIN_COMMAND_RECOVERY		=3D 1,
+	DATAIN_CONNECTION_RECOVERY		=3D 2,
+};
+
+/* struct iscsi_portal_group->state */
+enum tpg_state_table {
+	TPG_STATE_FREE				=3D 0,
+	TPG_STATE_ACTIVE			=3D 1,
+	TPG_STATE_INACTIVE			=3D 2,
+	TPG_STATE_COLD_RESET			=3D 3,
+};
+
+/* struct iscsi_tiqn->tiqn_state */
+enum tiqn_state_table {
+	TIQN_STATE_ACTIVE			=3D 1,
+	TIQN_STATE_SHUTDOWN			=3D 2,
+};
+
+/* struct iscsi_cmd->cmd_flags */
+enum cmd_flags_table {
+	ICF_GOT_LAST_DATAOUT			=3D 0x00000001,
+	ICF_GOT_DATACK_SNACK			=3D 0x00000002,
+	ICF_NON_IMMEDIATE_UNSOLICITED_DATA	=3D 0x00000004,
+	ICF_SENT_LAST_R2T			=3D 0x00000008,
+	ICF_WITHIN_COMMAND_RECOVERY		=3D 0x00000010,
+	ICF_CONTIG_MEMORY			=3D 0x00000020,
+	ICF_ATTACHED_TO_RQUEUE			=3D 0x00000040,
+	ICF_OOO_CMDSN				=3D 0x00000080,
+	ICF_REJECT_FAIL_CONN			=3D 0x00000100,
+};
+
+/* struct iscsi_cmd->i_state */
+enum cmd_i_state_table {
+	ISTATE_NO_STATE			=3D 0,
+	ISTATE_NEW_CMD			=3D 1,
+	ISTATE_DEFERRED_CMD		=3D 2,
+	ISTATE_UNSOLICITED_DATA		=3D 3,
+	ISTATE_RECEIVE_DATAOUT		=3D 4,
+	ISTATE_RECEIVE_DATAOUT_RECOVERY	=3D 5,
+	ISTATE_RECEIVED_LAST_DATAOUT	=3D 6,
+	ISTATE_WITHIN_DATAOUT_RECOVERY	=3D 7,
+	ISTATE_IN_CONNECTION_RECOVERY	=3D 8,
+	ISTATE_RECEIVED_TASKMGT		=3D 9,
+	ISTATE_SEND_ASYNCMSG		=3D 10,
+	ISTATE_SENT_ASYNCMSG		=3D 11,
+	ISTATE_SEND_DATAIN		=3D 12,
+	ISTATE_SEND_LAST_DATAIN		=3D 13,
+	ISTATE_SENT_LAST_DATAIN		=3D 14,
+	ISTATE_SEND_LOGOUTRSP		=3D 15,
+	ISTATE_SENT_LOGOUTRSP		=3D 16,
+	ISTATE_SEND_NOPIN		=3D 17,
+	ISTATE_SENT_NOPIN		=3D 18,
+	ISTATE_SEND_REJECT		=3D 19,
+	ISTATE_SENT_REJECT		=3D 20,
+	ISTATE_SEND_R2T			=3D 21,
+	ISTATE_SENT_R2T			=3D 22,
+	ISTATE_SEND_R2T_RECOVERY	=3D 23,
+	ISTATE_SENT_R2T_RECOVERY	=3D 24,
+	ISTATE_SEND_LAST_R2T		=3D 25,
+	ISTATE_SENT_LAST_R2T		=3D 26,
+	ISTATE_SEND_LAST_R2T_RECOVERY	=3D 27,
+	ISTATE_SENT_LAST_R2T_RECOVERY	=3D 28,
+	ISTATE_SEND_STATUS		=3D 29,
+	ISTATE_SEND_STATUS_BROKEN_PC	=3D 30,
+	ISTATE_SENT_STATUS		=3D 31,
+	ISTATE_SEND_STATUS_RECOVERY	=3D 32,
+	ISTATE_SENT_STATUS_RECOVERY	=3D 33,
+	ISTATE_SEND_TASKMGTRSP		=3D 34,
+	ISTATE_SENT_TASKMGTRSP		=3D 35,
+	ISTATE_SEND_TEXTRSP		=3D 36,
+	ISTATE_SENT_TEXTRSP		=3D 37,
+	ISTATE_SEND_NOPIN_WANT_RESPONSE	=3D 38,
+	ISTATE_SENT_NOPIN_WANT_RESPONSE	=3D 39,
+	ISTATE_SEND_NOPIN_NO_RESPONSE	=3D 40,
+	ISTATE_REMOVE			=3D 41,
+	ISTATE_FREE			=3D 42,
+};
+
+/* Used for iscsi_recover_cmdsn() return values */
+enum recover_cmdsn_ret_table {
+	CMDSN_ERROR_CANNOT_RECOVER	=3D -1,
+	CMDSN_NORMAL_OPERATION		=3D 0,
+	CMDSN_LOWER_THAN_EXP		=3D 1,
+	CMDSN_HIGHER_THAN_EXP		=3D 2,
+};
+
+/* Used for iscsi_handle_immediate_data() return values */
+enum immedate_data_ret_table {
+	IMMEDIDATE_DATA_CANNOT_RECOVER	=3D -1,
+	IMMEDIDATE_DATA_NORMAL_OPERATION =3D 0,
+	IMMEDIDATE_DATA_ERL1_CRC_FAILURE =3D 1,
+};
+
+/* Used for iscsi_decide_dataout_action() return values */
+enum dataout_action_ret_table {
+	DATAOUT_CANNOT_RECOVER		=3D -1,
+	DATAOUT_NORMAL			=3D 0,
+	DATAOUT_SEND_R2T		=3D 1,
+	DATAOUT_SEND_TO_TRANSPORT	=3D 2,
+	DATAOUT_WITHIN_COMMAND_RECOVERY =3D 3,
+};
+
+/* Used for struct iscsi_node_auth->naf_flags */
+enum naf_flags_table {
+	NAF_USERID_SET			=3D 0x01,
+	NAF_PASSWORD_SET		=3D 0x02,
+	NAF_USERID_IN_SET		=3D 0x04,
+	NAF_PASSWORD_IN_SET		=3D 0x08,
+};
+
+/* Used by various struct timer_list to manage iSCSI specific state */
+enum iscsi_timer_flags_table {
+	ISCSI_TF_RUNNING		=3D 0x01,
+	ISCSI_TF_STOP			=3D 0x02,
+	ISCSI_TF_EXPIRED		=3D 0x04,
+};
+
+/* Used for struct iscsi_np->np_flags */
+enum np_flags_table {
+	NPF_IP_NETWORK		=3D 0x00,
+	NPF_NET_IPV4		=3D 0x01,
+	NPF_NET_IPV6		=3D 0x02,
+	NPF_SCTP_STRUCT_FILE	=3D 0x20 /* Bugfix */
+};
+
+/* Used for struct iscsi_np->np_thread_state */
+enum np_thread_state_table {
+	ISCSI_NP_THREAD_ACTIVE		=3D 1,
+	ISCSI_NP_THREAD_INACTIVE	=3D 2,
+	ISCSI_NP_THREAD_RESET		=3D 3,
+	ISCSI_NP_THREAD_SHUTDOWN	=3D 4,
+	ISCSI_NP_THREAD_EXIT		=3D 5,
+};
+
+struct iscsi_conn_ops {
+	u8	HeaderDigest;			/* [0,1] =3D=3D [None,CRC32C] */
+	u8	DataDigest;			/* [0,1] =3D=3D [None,CRC32C] */
+	u32	MaxRecvDataSegmentLength;	/* [512..2**24-1] */
+	u8	OFMarker;			/* [0,1] =3D=3D [No,Yes] */
+	u8	IFMarker;			/* [0,1] =3D=3D [No,Yes] */
+	u32	OFMarkInt;			/* [1..65535] */
+	u32	IFMarkInt;			/* [1..65535] */
+};
+
+struct iscsi_sess_ops {
+	char	InitiatorName[224];
+	char	InitiatorAlias[256];
+	char	TargetName[224];
+	char	TargetAlias[256];
+	char	TargetAddress[256];
+	u16	TargetPortalGroupTag;		/* [0..65535] */
+	u16	MaxConnections;			/* [1..65535] */
+	u8	InitialR2T;			/* [0,1] =3D=3D [No,Yes] */
+	u8	ImmediateData;			/* [0,1] =3D=3D [No,Yes] */
+	u32	MaxBurstLength;			/* [512..2**24-1] */
+	u32	FirstBurstLength;		/* [512..2**24-1] */
+	u16	DefaultTime2Wait;		/* [0..3600] */
+	u16	DefaultTime2Retain;		/* [0..3600] */
+	u16	MaxOutstandingR2T;		/* [1..65535] */
+	u8	DataPDUInOrder;			/* [0,1] =3D=3D [No,Yes] */
+	u8	DataSequenceInOrder;		/* [0,1] =3D=3D [No,Yes] */
+	u8	ErrorRecoveryLevel;		/* [0..2] */
+	u8	SessionType;			/* [0,1] =3D=3D [Normal,Discovery]*/
+};
+
+struct iscsi_queue_req {
+	int			state;
+	struct se_obj_lun_type_s *queue_se_obj_api;
+	struct iscsi_cmd	*cmd;
+	struct list_head	qr_list;
+} ____cacheline_aligned;
+
+struct iscsi_data_count {
+	int			data_length;
+	int			sync_and_steering;
+	enum data_count_type	type;
+	u32			iov_count;
+	u32			ss_iov_count;
+	u32			ss_marker_count;
+	struct iovec		*iov;
+} ____cacheline_aligned;
+
+struct iscsi_param_list {
+	struct list_head	param_list;
+	struct list_head	extra_response_list;
+} ____cacheline_aligned;
+
+struct iscsi_datain_req {
+	enum datain_req_comp_table dr_complete;
+	int			generate_recovery_values;
+	enum datain_req_rec_table recovery;
+	u32			begrun;
+	u32			runlength;
+	u32			data_length;
+	u32			data_offset;
+	u32			data_offset_end;
+	u32			data_sn;
+	u32			next_burst_len;
+	u32			read_data_done;
+	u32			seq_send_order;
+	struct list_head	dr_list;
+} ____cacheline_aligned;
+
+struct iscsi_ooo_cmdsn {
+	u16			cid;
+	u32			batch_count;
+	u32			cmdsn;
+	u32			exp_cmdsn;
+	struct iscsi_cmd	*cmd;
+	struct list_head	ooo_list;
+} ____cacheline_aligned;
+
+struct iscsi_datain {
+	u8			flags;
+	u32			data_sn;
+	u32			length;
+	u32			offset;
+} ____cacheline_aligned;
+
+struct iscsi_r2t {
+	int			seq_complete;
+	int			recovery_r2t;
+	int			sent_r2t;
+	u32			r2t_sn;
+	u32			offset;
+	u32			targ_xfer_tag;
+	u32			xfer_len;
+	struct list_head	r2t_list;
+} ____cacheline_aligned;
+
+struct iscsi_cmd {
+	enum iscsi_timer_flags_table dataout_timer_flags;
+	/* DataOUT timeout retries */
+	u8			dataout_timeout_retries;
+	/* Within command recovery count */
+	u8			error_recovery_count;
+	/* iSCSI dependent state for out or order CmdSNs */
+	enum cmd_i_state_table	deferred_i_state;
+	/* iSCSI dependent state */
+	enum cmd_i_state_table	i_state;
+	/* Command is an immediate command (ISCSI_OP_IMMEDIATE set) */
+	u8			immediate_cmd;
+	/* Immediate data present */
+	u8			immediate_data;
+	/* iSCSI Opcode */
+	u8			iscsi_opcode;
+	/* iSCSI Response Code */
+	u8			iscsi_response;
+	/* Logout reason when iscsi_opcode =3D=3D ISCSI_INIT_LOGOUT_CMND */
+	u8			logout_reason;
+	/* Logout response code when iscsi_opcode =3D=3D ISCSI_INIT_LOGOUT_CM=
ND */
+	u8			logout_response;
+	/* MaxCmdSN has been incremented */
+	u8			maxcmdsn_inc;
+	/* Immediate Unsolicited Dataout */
+	u8			unsolicited_data;
+	/* CID contained in logout PDU when opcode =3D=3D ISCSI_INIT_LOGOUT_C=
MND */
+	u16			logout_cid;
+	/* Command flags */
+	enum cmd_flags_table	cmd_flags;
+	/* Initiator Task Tag assigned from Initiator */
+	u32			init_task_tag;
+	/* Target Transfer Tag assigned from Target */
+	u32			targ_xfer_tag;
+	/* CmdSN assigned from Initiator */
+	u32			cmd_sn;
+	/* ExpStatSN assigned from Initiator */
+	u32			exp_stat_sn;
+	/* StatSN assigned to this ITT */
+	u32			stat_sn;
+	/* DataSN Counter */
+	u32			data_sn;
+	/* R2TSN Counter */
+	u32			r2t_sn;
+	/* Last DataSN acknowledged via DataAck SNACK */
+	u32			acked_data_sn;
+	/* Used for echoing NOPOUT ping data */
+	u32			buf_ptr_size;
+	/* Used to store DataDigest */
+	u32			data_crc;
+	/* Total size in bytes associated with command */
+	u32			data_length;
+	/* Counter for MaxOutstandingR2T */
+	u32			outstanding_r2ts;
+	/* Next R2T Offset when DataSequenceInOrder=3DYes */
+	u32			r2t_offset;
+	/* Iovec current and orig count for iscsi_cmd->iov_data */
+	u32			iov_data_count;
+	u32			orig_iov_data_count;
+	/* Number of miscellaneous iovecs used for IP stack calls */
+	u32			iov_misc_count;
+	/* Bytes used for 32-bit word padding */
+	u32			pad_bytes;
+	/* Number of struct iscsi_pdu in struct iscsi_cmd->pdu_list */
+	u32			pdu_count;
+	/* Next struct iscsi_pdu to send in struct iscsi_cmd->pdu_list */
+	u32			pdu_send_order;
+	/* Current struct iscsi_pdu in struct iscsi_cmd->pdu_list */
+	u32			pdu_start;
+	u32			residual_count;
+	/* Next struct iscsi_seq to send in struct iscsi_cmd->seq_list */
+	u32			seq_send_order;
+	/* Number of struct iscsi_seq in struct iscsi_cmd->seq_list */
+	u32			seq_count;
+	/* Current struct iscsi_seq in struct iscsi_cmd->seq_list */
+	u32			seq_no;
+	/* Lowest offset in current DataOUT sequence */
+	u32			seq_start_offset;
+	/* Highest offset in current DataOUT sequence */
+	u32			seq_end_offset;
+	/* Total size in bytes received so far of READ data */
+	u32			read_data_done;
+	/* Total size in bytes received so far of WRITE data */
+	u32			write_data_done;
+	/* Counter for FirstBurstLength key */
+	u32			first_burst_len;
+	/* Counter for MaxBurstLength key */
+	u32			next_burst_len;
+	/* Transfer size used for IP stack calls */
+	u32			tx_size;
+	/* Buffer used for various purposes */
+	void			*buf_ptr;
+	/* See include/linux/dma-mapping.h */
+	enum dma_data_direction	data_direction;
+	/* iSCSI PDU Header + CRC */
+	unsigned char		pdu[ISCSI_HDR_LEN + CRC_LEN];
+	/* Number of times struct iscsi_cmd is present in immediate queue */
+	atomic_t		immed_queue_count;
+	atomic_t		response_queue_count;
+	atomic_t		transport_sent;
+	spinlock_t		datain_lock;
+	spinlock_t		dataout_timeout_lock;
+	/* spinlock for protecting struct iscsi_cmd->i_state */
+	spinlock_t		istate_lock;
+	/* spinlock for adding within command recovery entries */
+	spinlock_t		error_lock;
+	/* spinlock for adding R2Ts */
+	spinlock_t		r2t_lock;
+	/* DataIN List */
+	struct list_head	datain_list;
+	/* R2T List */
+	struct list_head	cmd_r2t_list;
+	struct semaphore	reject_sem;
+	/* Semaphore used for allocating buffer */
+	struct semaphore	unsolicited_data_sem;
+	/* Timer for DataOUT */
+	struct timer_list	dataout_timer;
+	/* Iovecs for SCSI data payload RX/TX w/ kernel level sockets */
+	struct iovec		*iov_data;
+	/* Iovecs for miscellaneous purposes */
+#define ISCSI_MISC_IOVECS			5
+	struct iovec		iov_misc[ISCSI_MISC_IOVECS];
+	/* Array of struct iscsi_pdu used for DataPDUInOrder=3DNo */
+	struct iscsi_pdu	*pdu_list;
+	/* Current struct iscsi_pdu used for DataPDUInOrder=3DNo */
+	struct iscsi_pdu	*pdu_ptr;
+	/* Array of struct iscsi_seq used for DataSequenceInOrder=3DNo */
+	struct iscsi_seq	*seq_list;
+	/* Current struct iscsi_seq used for DataSequenceInOrder=3DNo */
+	struct iscsi_seq	*seq_ptr;
+	/* TMR Request when iscsi_opcode =3D=3D ISCSI_OP_SCSI_TMFUNC */
+	struct iscsi_tmr_req	*tmr_req;
+	/* Connection this command is alligient to */
+	struct iscsi_conn	*conn;
+	/* Pointer to connection recovery entry */
+	struct iscsi_conn_recovery *cr;
+	/* Session the command is part of,  used for connection recovery */
+	struct iscsi_session	*sess;
+	/* Next command in the session pool */
+	struct iscsi_cmd	*next;
+	/* list_head for connection list */
+	struct list_head	i_list;
+	/* Next command in DAS transport list */
+	struct iscsi_cmd	*t_next;
+	/* Previous command in DAS transport list */
+	struct iscsi_cmd	*t_prev;
+	/* The TCM I/O descriptor that is accessed via container_of() */
+	struct se_cmd		se_cmd;
+	/* Sense buffer that will be mapped into outgoing status */
+#define ISCSI_SENSE_BUFFER_LEN          (TRANSPORT_SENSE_BUFFER + 2)
+	unsigned char		sense_buffer[ISCSI_SENSE_BUFFER_LEN];
+}  ____cacheline_aligned;
+
+#define SE_CMD(cmd)		(&(cmd)->se_cmd)
+
+struct iscsi_tmr_req {
+	bool			task_reassign:1;
+	u32			ref_cmd_sn;
+	u32			exp_data_sn;
+	struct iscsi_conn_recovery *conn_recovery;
+	struct se_tmr_req	*se_tmr_req;
+} ____cacheline_aligned;
+
+struct iscsi_conn {
+#define ISCSI_NETDEV_NAME_SIZE				12
+	char			net_dev[ISCSI_NETDEV_NAME_SIZE];
+	/* Authentication Successful for this connection */
+	u8			auth_complete;
+	/* State connection is currently in */
+	u8			conn_state;
+	u8			conn_logout_reason;
+	u8			network_transport;
+	enum iscsi_timer_flags_table netif_timer_flags;
+	enum iscsi_timer_flags_table nopin_timer_flags;
+	enum iscsi_timer_flags_table nopin_response_timer_flags;
+	u8			tx_immediate_queue;
+	u8			tx_response_queue;
+	/* Used to know what thread encountered a transport failure */
+	u8			which_thread;
+	/* connection id assigned by the Initiator */
+	u16			cid;
+	/* Remote TCP Port */
+	u16			login_port;
+	int			net_size;
+	u32			auth_id;
+#define CONNFLAG_SCTP_STRUCT_FILE			0x01
+	u32			conn_flags;
+	/* Remote TCP IP address */
+	u32			login_ip;
+	/* Used for iscsi_tx_login_rsp() */
+	u32			login_itt;
+	u32			exp_statsn;
+	/* Per connection status sequence number */
+	u32			stat_sn;
+	/* IFMarkInt's Current Value */
+	u32			if_marker;
+	/* OFMarkInt's Current Value */
+	u32			of_marker;
+	/* Used for calculating OFMarker offset to next PDU */
+	u32			of_marker_offset;
+	/* Complete Bad PDU for sending reject */
+	unsigned char		bad_hdr[ISCSI_HDR_LEN];
+#define IPV6_ADDRESS_SPACE				48
+	unsigned char		ipv6_login_ip[IPV6_ADDRESS_SPACE];
+	u16			local_port;
+	u32			local_ip;
+	u32			conn_index;
+	atomic_t		active_cmds;
+	atomic_t		check_immediate_queue;
+	atomic_t		conn_logout_remove;
+	atomic_t		conn_usage_count;
+	atomic_t		conn_waiting_on_uc;
+	atomic_t		connection_exit;
+	atomic_t		connection_recovery;
+	atomic_t		connection_reinstatement;
+	atomic_t		connection_wait;
+	atomic_t		connection_wait_rcfr;
+	atomic_t		sleep_on_conn_wait_sem;
+	atomic_t		transport_failed;
+	struct net_device	*net_if;
+	struct semaphore	conn_post_wait_sem;
+	struct semaphore	conn_wait_sem;
+	struct semaphore	conn_wait_rcfr_sem;
+	struct semaphore	conn_waiting_on_uc_sem;
+	struct semaphore	conn_logout_sem;
+	struct semaphore	rx_half_close_sem;
+	struct semaphore	tx_half_close_sem;
+	/* Semaphore for conn's tx_thread to sleep on */
+	struct semaphore	tx_sem;
+	/* socket used by this connection */
+	struct socket		*sock;
+	struct timer_list	nopin_timer;
+	struct timer_list	nopin_response_timer;
+	struct timer_list	transport_timer;
+	/* Spinlock used for add/deleting cmd's from conn_cmd_list */
+	spinlock_t		cmd_lock;
+	spinlock_t		conn_usage_lock;
+	spinlock_t		immed_queue_lock;
+	spinlock_t		netif_lock;
+	spinlock_t		nopin_timer_lock;
+	spinlock_t		response_queue_lock;
+	spinlock_t		state_lock;
+	/* libcrypto RX and TX contexts for crc32c */
+	struct hash_desc	conn_rx_hash;
+	struct hash_desc	conn_tx_hash;
+	/* Used for scheduling TX and RX connection kthreads */
+	cpumask_var_t		conn_cpumask;
+	int			conn_rx_reset_cpumask:1;
+	int			conn_tx_reset_cpumask:1;
+	/* list_head of struct iscsi_cmd for this connection */
+	struct list_head	conn_cmd_list;
+	struct list_head	immed_queue_list;
+	struct list_head	response_queue_list;
+	struct iscsi_conn_ops	*conn_ops;
+	struct iscsi_param_list	*param_list;
+	/* Used for per connection auth state machine */
+	void			*auth_protocol;
+	struct iscsi_login_thread_s *login_thread;
+	struct iscsi_portal_group *tpg;
+	/* Pointer to parent session */
+	struct iscsi_session	*sess;
+	/* Pointer to thread_set in use for this conn's threads */
+	struct se_thread_set	*thread_set;
+	/* list_head for session connection list */
+	struct list_head	conn_list;
+} ____cacheline_aligned;
+
+#define CONN(cmd)		((struct iscsi_conn *)(cmd)->conn)
+#define CONN_OPS(conn)		((struct iscsi_conn_ops *)(conn)->conn_ops)
+
+struct iscsi_conn_recovery {
+	u16			cid;
+	u32			cmd_count;
+	u32			maxrecvdatasegmentlength;
+	int			ready_for_reallegiance;
+	struct list_head	conn_recovery_cmd_list;
+	spinlock_t		conn_recovery_cmd_lock;
+	struct semaphore		time2wait_sem;
+	struct timer_list		time2retain_timer;
+	struct iscsi_session	*sess;
+	struct list_head	cr_list;
+}  ____cacheline_aligned;
+
+struct iscsi_session {
+	u8			cmdsn_outoforder;
+	u8			initiator_vendor;
+	u8			isid[6];
+	enum iscsi_timer_flags_table time2retain_timer_flags;
+	u8			version_active;
+	u16			cid_called;
+	u16			conn_recovery_count;
+	u16			tsih;
+	/* state session is currently in */
+	u32			session_state;
+	/* session wide counter: initiator assigned task tag */
+	u32			init_task_tag;
+	/* session wide counter: target assigned task tag */
+	u32			targ_xfer_tag;
+	u32			cmdsn_window;
+	/* session wide counter: expected command sequence number */
+	u32			exp_cmd_sn;
+	/* session wide counter: maximum allowed command sequence number */
+	u32			max_cmd_sn;
+	u32			ooo_cmdsn_count;
+	/* LIO specific session ID */
+	u32			sid;
+	char			auth_type[8];
+	/* unique within the target */
+	u32			session_index;
+	u32			cmd_pdus;
+	u32			rsp_pdus;
+	u64			tx_data_octets;
+	u64			rx_data_octets;
+	u32			conn_digest_errors;
+	u32			conn_timeout_errors;
+	u64			creation_time;
+	spinlock_t		session_stats_lock;
+	/* Number of active connections */
+	atomic_t		nconn;
+	atomic_t		session_continuation;
+	atomic_t		session_fall_back_to_erl0;
+	atomic_t		session_logout;
+	atomic_t		session_reinstatement;
+	atomic_t		session_stop_active;
+	atomic_t		session_usage_count;
+	atomic_t		session_waiting_on_uc;
+	atomic_t		sleep_on_sess_wait_sem;
+	atomic_t		transport_wait_cmds;
+	/* connection list */
+	struct list_head	sess_conn_list;
+	struct list_head	cr_active_list;
+	struct list_head	cr_inactive_list;
+	spinlock_t		cmdsn_lock;
+	spinlock_t		conn_lock;
+	spinlock_t		cr_a_lock;
+	spinlock_t		cr_i_lock;
+	spinlock_t		session_usage_lock;
+	spinlock_t		ttt_lock;
+	struct list_head	sess_ooo_cmdsn_list;
+	struct semaphore	async_msg_sem;
+	struct semaphore	reinstatement_sem;
+	struct semaphore	session_wait_sem;
+	struct semaphore	session_waiting_on_uc_sem;
+	struct timer_list	time2retain_timer;
+	struct iscsi_sess_ops	*sess_ops;
+	struct se_session	*se_sess;
+	struct iscsi_portal_group *tpg;
+} ____cacheline_aligned;
+
+#define SESS(conn)		((struct iscsi_session *)(conn)->sess)
+#define SESS_OPS(sess)		((struct iscsi_sess_ops *)(sess)->sess_ops)
+#define SESS_OPS_C(conn)	((struct iscsi_sess_ops *)(conn)->sess->sess_=
ops)
+#define SESS_NODE_ACL(sess)	((struct se_node_acl *)(sess)->se_sess->se=
_node_acl)
+
+struct iscsi_login {
+	u8 auth_complete;
+	u8 checked_for_existing;
+	u8 current_stage;
+	u8 leading_connection;
+	u8 first_request;
+	u8 version_min;
+	u8 version_max;
+	char isid[6];
+	u32 cmd_sn;
+	u32 init_task_tag;
+	u32 initial_exp_statsn;
+	u32 rsp_length;
+	u16 cid;
+	u16 tsih;
+	char *req;
+	char *rsp;
+	char *req_buf;
+	char *rsp_buf;
+} ____cacheline_aligned;
+
+struct iscsi_node_attrib {
+	u32			dataout_timeout;
+	u32			dataout_timeout_retries;
+	u32			default_erl;
+	u32			nopin_timeout;
+	u32			nopin_response_timeout;
+	u32			random_datain_pdu_offsets;
+	u32			random_datain_seq_offsets;
+	u32			random_r2t_offsets;
+	u32			tmr_cold_reset;
+	u32			tmr_warm_reset;
+	struct iscsi_node_acl *nacl;
+} ____cacheline_aligned;
+
+struct se_dev_entry_s;
+
+struct iscsi_node_auth {
+	enum naf_flags_table	naf_flags;
+	int			authenticate_target;
+	/* Used for iscsi_global->discovery_auth,
+	 * set to zero (auth disabled) by default */
+	int			enforce_discovery_auth;
+#define MAX_USER_LEN				256
+#define MAX_PASS_LEN				256
+	char			userid[MAX_USER_LEN];
+	char			password[MAX_PASS_LEN];
+	char			userid_mutual[MAX_USER_LEN];
+	char			password_mutual[MAX_PASS_LEN];
+} ____cacheline_aligned;
+
+#include "iscsi_target_stat.h"
+
+struct iscsi_node_stat_grps {
+	struct config_group	iscsi_sess_stats_group;
+	struct config_group	iscsi_conn_stats_group;
+};
+
+struct iscsi_node_acl {
+	struct iscsi_node_attrib node_attrib;
+	struct iscsi_node_auth	node_auth;
+	struct iscsi_node_stat_grps node_stat_grps;
+	struct se_node_acl	se_node_acl;
+} ____cacheline_aligned;
+
+#define NODE_STAT_GRPS(nacl)	(&(nacl)->node_stat_grps)
+
+#define ISCSI_NODE_ATTRIB(t)	(&(t)->node_attrib)
+#define ISCSI_NODE_AUTH(t)	(&(t)->node_auth)
+
+struct iscsi_tpg_attrib {
+	u32			authentication;
+	u32			login_timeout;
+	u32			netif_timeout;
+	u32			generate_node_acls;
+	u32			cache_dynamic_acls;
+	u32			default_cmdsn_depth;
+	u32			demo_mode_write_protect;
+	u32			prod_mode_write_protect;
+	u32			cache_core_nps;
+	struct iscsi_portal_group *tpg;
+}  ____cacheline_aligned;
+
+struct iscsi_np_ex {
+	int			np_ex_net_size;
+	u16			np_ex_port;
+	u32			np_ex_ipv4;
+	unsigned char		np_ex_ipv6[IPV6_ADDRESS_SPACE];
+	struct list_head	np_ex_list;
+} ____cacheline_aligned;
+
+struct iscsi_np {
+	unsigned char		np_net_dev[ISCSI_NETDEV_NAME_SIZE];
+	int			np_network_transport;
+	enum np_thread_state_table np_thread_state;
+	enum iscsi_timer_flags_table np_login_timer_flags;
+	int			np_net_size;
+	u32			np_exports;
+	enum np_flags_table	np_flags;
+	u32			np_ipv4;
+	unsigned char		np_ipv6[IPV6_ADDRESS_SPACE];
+	u32			np_index;
+	u16			np_port;
+	atomic_t		np_shutdown;
+	spinlock_t		np_ex_lock;
+	spinlock_t		np_state_lock;
+	spinlock_t		np_thread_lock;
+	struct semaphore		np_done_sem;
+	struct semaphore		np_restart_sem;
+	struct semaphore		np_shutdown_sem;
+	struct semaphore		np_start_sem;
+	struct socket		*np_socket;
+	struct task_struct		*np_thread;
+	struct timer_list		np_login_timer;
+	struct iscsi_portal_group *np_login_tpg;
+	struct list_head	np_list;
+	struct list_head	np_nex_list;
+} ____cacheline_aligned;
+
+struct iscsi_tpg_np {
+	u32			tpg_np_index;
+	struct iscsi_np		*tpg_np;
+	struct iscsi_portal_group *tpg;
+	struct iscsi_tpg_np	*tpg_np_parent;
+	struct list_head	tpg_np_list;
+	struct list_head	tpg_np_child_list;
+	struct list_head	tpg_np_parent_list;
+	struct se_tpg_np	se_tpg_np;
+	spinlock_t		tpg_np_parent_lock;
+} ____cacheline_aligned;
+
+struct iscsi_np_addr {
+	u16		np_port;
+	u32		np_flags;
+	u32		np_ipv4;
+	unsigned char	np_ipv6[IPV6_ADDRESS_SPACE];
+} ____cacheline_aligned;
+
+struct iscsi_portal_group {
+	unsigned char		tpg_chap_id;
+	/* TPG State */
+	enum tpg_state_table	tpg_state;
+	/* Target Portal Group Tag */
+	u16			tpgt;
+	/* Id assigned to target sessions */
+	u16			ntsih;
+	/* Number of active sessions */
+	u32			nsessions;
+	/* Number of Network Portals available for this TPG */
+	u32			num_tpg_nps;
+	/* Per TPG LIO specific session ID. */
+	u32			sid;
+	/* Spinlock for adding/removing Network Portals */
+	spinlock_t		tpg_np_lock;
+	spinlock_t		tpg_state_lock;
+	struct se_portal_group tpg_se_tpg;
+	struct semaphore	tpg_access_sem;
+	struct semaphore	np_login_sem;
+	struct iscsi_tpg_attrib	tpg_attrib;
+	/* Pointer to default list of iSCSI parameters for TPG */
+	struct iscsi_param_list	*param_list;
+	struct iscsi_tiqn	*tpg_tiqn;
+	struct list_head	tpg_gnp_list;
+	struct list_head	tpg_list;
+	struct list_head	g_tpg_list;
+} ____cacheline_aligned;
+
+#define ISCSI_TPG_C(c)		((struct iscsi_portal_group *)(c)->tpg)
+#define ISCSI_TPG_LUN(c, l)  ((iscsi_tpg_list_t *)(c)->tpg->tpg_lun_li=
st_t[l])
+#define ISCSI_TPG_S(s)		((struct iscsi_portal_group *)(s)->tpg)
+#define ISCSI_TPG_ATTRIB(t)	(&(t)->tpg_attrib)
+#define SE_TPG(tpg)		(&(tpg)->tpg_se_tpg)
+
+struct iscsi_wwn_stat_grps {
+	struct config_group	iscsi_stat_group;
+	struct config_group	iscsi_instance_group;
+	struct config_group	iscsi_sess_err_group;
+	struct config_group	iscsi_tgt_attr_group;
+	struct config_group	iscsi_login_stats_group;
+	struct config_group	iscsi_logout_stats_group;
+};
+
+struct iscsi_tiqn {
+#define ISCSI_IQN_LEN				224
+	unsigned char		tiqn[ISCSI_IQN_LEN];
+	enum tiqn_state_table	tiqn_state;
+	u32			tiqn_active_tpgs;
+	u32			tiqn_ntpgs;
+	u32			tiqn_num_tpg_nps;
+	u32			tiqn_nsessions;
+	struct list_head	tiqn_list;
+	struct list_head	tiqn_tpg_list;
+	atomic_t		tiqn_access_count;
+	spinlock_t		tiqn_state_lock;
+	spinlock_t		tiqn_tpg_lock;
+	struct se_wwn		tiqn_wwn;
+	struct iscsi_wwn_stat_grps tiqn_stat_grps;
+	u32			tiqn_index;
+	struct iscsi_sess_err_stats  sess_err_stats;
+	struct iscsi_login_stats     login_stats;
+	struct iscsi_logout_stats    logout_stats;
+} ____cacheline_aligned;
+
+#define WWN_STAT_GRPS(tiqn)	(&(tiqn)->tiqn_stat_grps)
+
+struct iscsi_global {
+	/* In core shutdown */
+	u32			in_shutdown;
+	/* Is the iSCSI Node name set? */
+	u32			targetname_set;
+	u32			active_ts;
+	/* Unique identifier used for the authentication daemon */
+	u32			auth_id;
+	u32			inactive_ts;
+	/* Thread Set bitmap count */
+	int			ts_bitmap_count;
+	/* Thread Set bitmap pointer */
+	unsigned long		*ts_bitmap;
+	struct list_head	g_tiqn_list;
+	struct list_head	g_tpg_list;
+	struct list_head	tpg_list;
+	struct list_head	g_np_list;
+	spinlock_t		active_ts_lock;
+	spinlock_t		check_thread_lock;
+	/* Spinlock for adding/removing discovery entries */
+	spinlock_t		discovery_lock;
+	spinlock_t		inactive_ts_lock;
+	/* Spinlock for adding/removing login threads */
+	spinlock_t		login_thread_lock;
+	/* Spinlock for adding/removing thread sets */
+	spinlock_t		thread_set_lock;
+	/* Spinlock for iscsi_global->ts_bitmap */
+	spinlock_t		ts_bitmap_lock;
+	/* Spinlock for struct iscsi_tiqn */
+	spinlock_t		tiqn_lock;
+	spinlock_t		g_tpg_lock;
+	/* Spinlock g_np_list */
+	spinlock_t		np_lock;
+	/* Semaphore used for communication to authentication daemon */
+	struct semaphore	auth_sem;
+	/* Semaphore used for allocate of struct iscsi_conn->auth_id */
+	struct semaphore	auth_id_sem;
+	/* Used for iSCSI discovery session authentication */
+	struct iscsi_node_acl	discovery_acl;
+	struct iscsi_portal_group	*discovery_tpg;
+	struct list_head	active_ts_list;
+	struct list_head	inactive_ts_list;
+} ____cacheline_aligned;
+
+#endif /* ISCSI_TARGET_CORE_H */
--=20
1.7.4.1
