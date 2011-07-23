From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 03/13] iscsi-target: Add iSCSI fabric support for target v4.1
Date: Sat, 23 Jul 2011 08:45:37 +0000
Message-ID: <1311410747-29947-4-git-send-email-nab@linux-iscsi.org>
References: <1311410747-29947-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:34241 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab1GWJJU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Jul 2011 05:09:20 -0400
In-Reply-To: <1311410747-29947-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

The Linux-iSCSI.org target module is a full featured in-kernel
software implementation of iSCSI target mode (RFC-3720) for the
current WIP mainline target v4.1 infrastructure code for the v3.1
kernel.  More information can be found here:

http://linux-iscsi.org/wiki/ISCSI

This includes support for:

   * RFC-3720 defined request / response state machines and support for
     all defined iSCSI operation codes from Section 10.2.1.2 using libiscsi
     include/scsi/iscsi_proto.h PDU definitions
   * Target v4.1 compatible control plane using the generic layout in
     target_core_fabric_configfs.c and fabric dependent attributes
     within /sys/kernel/config/target/iscsi/ subdirectories.
   * Target v4.1 compatible iSCSI statistics based on RFC-4544 (iSCSI MIBS)
   * Support for IPv6 and IPv4 network portals in M:N mapping to TPGs
   * iSCSI Error Recovery Hierarchy support
   * Per iSCSI connection RX/TX thread pair scheduling affinity
   * crc32c + crc32c_intel SSEv4 instruction offload support using libcrypto
   * CHAP Authentication support using libcrypto
   * Conversion to use internal SGl allocation with iscsit_alloc_buffs() ->
     transport_generic_map_mem_to_cmd()

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Andy Grover <agrover@redhat.com>
Acked-by: Roland Dreier <roland@kernel.org>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c      | 4559 ++++++++++++++++++++++++++++++
 drivers/target/iscsi/iscsi_target.h      |   42 +
 drivers/target/iscsi/iscsi_target_core.h |  859 ++++++
 3 files changed, 5460 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/iscsi/iscsi_target.c
 create mode 100644 drivers/target/iscsi/iscsi_target.h
 create mode 100644 drivers/target/iscsi/iscsi_target_core.h

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
new file mode 100644
index 0000000..24123c5
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -0,0 +1,4559 @@
+/*******************************************************************************
+ * This file contains main functions related to the iSCSI Target Core Driver.
+ *
+ * \u00a9 Copyright 2007-2011 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
+ *
+ * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
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
+ ******************************************************************************/
+
+#include <linux/string.h>
+#include <linux/kthread.h>
+#include <linux/crypto.h>
+#include <linux/completion.h>
+#include <asm/unaligned.h>
+#include <scsi/scsi_device.h>
+#include <scsi/iscsi_proto.h>
+#include <target/target_core_base.h>
+#include <target/target_core_tmr.h>
+#include <target/target_core_transport.h>
+
+#include "iscsi_target_core.h"
+#include "iscsi_target_parameters.h"
+#include "iscsi_target_seq_pdu_list.h"
+#include "iscsi_target_tq.h"
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
+static LIST_HEAD(g_tiqn_list);
+static LIST_HEAD(g_np_list);
+static DEFINE_SPINLOCK(tiqn_lock);
+static DEFINE_SPINLOCK(np_lock);
+
+static struct idr tiqn_idr;
+struct idr sess_idr;
+struct mutex auth_id_lock;
+spinlock_t sess_idr_lock;
+
+struct iscsit_global *iscsit_global;
+
+struct kmem_cache *lio_cmd_cache;
+struct kmem_cache *lio_qr_cache;
+struct kmem_cache *lio_dr_cache;
+struct kmem_cache *lio_ooo_cache;
+struct kmem_cache *lio_r2t_cache;
+
+static int iscsit_handle_immediate_data(struct iscsi_cmd *,
+			unsigned char *buf, u32);
+static int iscsit_logout_post_handler(struct iscsi_cmd *, struct iscsi_conn *);
+
+struct iscsi_tiqn *iscsit_get_tiqn_for_login(unsigned char *buf)
+{
+	struct iscsi_tiqn *tiqn = NULL;
+
+	spin_lock(&tiqn_lock);
+	list_for_each_entry(tiqn, &g_tiqn_list, tiqn_list) {
+		if (!strcmp(tiqn->tiqn, buf)) {
+
+			spin_lock(&tiqn->tiqn_state_lock);
+			if (tiqn->tiqn_state == TIQN_STATE_ACTIVE) {
+				tiqn->tiqn_access_count++;
+				spin_unlock(&tiqn->tiqn_state_lock);
+				spin_unlock(&tiqn_lock);
+				return tiqn;
+			}
+			spin_unlock(&tiqn->tiqn_state_lock);
+		}
+	}
+	spin_unlock(&tiqn_lock);
+
+	return NULL;
+}
+
+static int iscsit_set_tiqn_shutdown(struct iscsi_tiqn *tiqn)
+{
+	spin_lock(&tiqn->tiqn_state_lock);
+	if (tiqn->tiqn_state == TIQN_STATE_ACTIVE) {
+		tiqn->tiqn_state = TIQN_STATE_SHUTDOWN;
+		spin_unlock(&tiqn->tiqn_state_lock);
+		return 0;
+	}
+	spin_unlock(&tiqn->tiqn_state_lock);
+
+	return -1;
+}
+
+void iscsit_put_tiqn_for_login(struct iscsi_tiqn *tiqn)
+{
+	spin_lock(&tiqn->tiqn_state_lock);
+	tiqn->tiqn_access_count--;
+	spin_unlock(&tiqn->tiqn_state_lock);
+}
+
+/*
+ * Note that IQN formatting is expected to be done in userspace, and
+ * no explict IQN format checks are done here.
+ */
+struct iscsi_tiqn *iscsit_add_tiqn(unsigned char *buf)
+{
+	struct iscsi_tiqn *tiqn = NULL;
+	int ret;
+
+	if (strlen(buf) > ISCSI_IQN_LEN) {
+		pr_err("Target IQN exceeds %d bytes\n",
+				ISCSI_IQN_LEN);
+		return ERR_PTR(-EINVAL);
+	}
+
+	tiqn = kzalloc(sizeof(struct iscsi_tiqn), GFP_KERNEL);
+	if (!tiqn) {
+		pr_err("Unable to allocate struct iscsi_tiqn\n");
+		return ERR_PTR(-ENOMEM);
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
+
+	if (!idr_pre_get(&tiqn_idr, GFP_KERNEL)) {
+		pr_err("idr_pre_get() for tiqn_idr failed\n");
+		kfree(tiqn);
+		return ERR_PTR(-ENOMEM);
+	}
+	tiqn->tiqn_state = TIQN_STATE_ACTIVE;
+
+	spin_lock(&tiqn_lock);
+	ret = idr_get_new(&tiqn_idr, NULL, &tiqn->tiqn_index);
+	if (ret < 0) {
+		pr_err("idr_get_new() failed for tiqn->tiqn_index\n");
+		spin_unlock(&tiqn_lock);
+		kfree(tiqn);
+		return ERR_PTR(ret);
+	}
+	list_add_tail(&tiqn->tiqn_list, &g_tiqn_list);
+	spin_unlock(&tiqn_lock);
+
+	pr_debug("CORE[0] - Added iSCSI Target IQN: %s\n", tiqn->tiqn);
+
+	return tiqn;
+
+}
+
+static void iscsit_wait_for_tiqn(struct iscsi_tiqn *tiqn)
+{
+	/*
+	 * Wait for accesses to said struct iscsi_tiqn to end.
+	 */
+	spin_lock(&tiqn->tiqn_state_lock);
+	while (tiqn->tiqn_access_count != 0) {
+		spin_unlock(&tiqn->tiqn_state_lock);
+		msleep(10);
+		spin_lock(&tiqn->tiqn_state_lock);
+	}
+	spin_unlock(&tiqn->tiqn_state_lock);
+}
+
+void iscsit_del_tiqn(struct iscsi_tiqn *tiqn)
+{
+	/*
+	 * iscsit_set_tiqn_shutdown sets tiqn->tiqn_state = TIQN_STATE_SHUTDOWN
+	 * while holding tiqn->tiqn_state_lock.  This means that all subsequent
+	 * attempts to access this struct iscsi_tiqn will fail from both transport
+	 * fabric and control code paths.
+	 */
+	if (iscsit_set_tiqn_shutdown(tiqn) < 0) {
+		pr_err("iscsit_set_tiqn_shutdown() failed\n");
+		return;
+	}
+
+	iscsit_wait_for_tiqn(tiqn);
+
+	spin_lock(&tiqn_lock);
+	list_del(&tiqn->tiqn_list);
+	idr_remove(&tiqn_idr, tiqn->tiqn_index);
+	spin_unlock(&tiqn_lock);
+
+	pr_debug("CORE[0] - Deleted iSCSI Target IQN: %s\n",
+			tiqn->tiqn);
+	kfree(tiqn);
+}
+
+int iscsit_access_np(struct iscsi_np *np, struct iscsi_portal_group *tpg)
+{
+	int ret;
+	/*
+	 * Determine if the network portal is accepting storage traffic.
+	 */
+	spin_lock_bh(&np->np_thread_lock);
+	if (np->np_thread_state != ISCSI_NP_THREAD_ACTIVE) {
+		spin_unlock_bh(&np->np_thread_lock);
+		return -1;
+	}
+	if (np->np_login_tpg) {
+		pr_err("np->np_login_tpg() is not NULL!\n");
+		spin_unlock_bh(&np->np_thread_lock);
+		return -1;
+	}
+	spin_unlock_bh(&np->np_thread_lock);
+	/*
+	 * Determine if the portal group is accepting storage traffic.
+	 */
+	spin_lock_bh(&tpg->tpg_state_lock);
+	if (tpg->tpg_state != TPG_STATE_ACTIVE) {
+		spin_unlock_bh(&tpg->tpg_state_lock);
+		return -1;
+	}
+	spin_unlock_bh(&tpg->tpg_state_lock);
+
+	/*
+	 * Here we serialize access across the TIQN+TPG Tuple.
+	 */
+	ret = mutex_lock_interruptible(&tpg->np_login_lock);
+	if ((ret != 0) || signal_pending(current))
+		return -1;
+
+	spin_lock_bh(&np->np_thread_lock);
+	np->np_login_tpg = tpg;
+	spin_unlock_bh(&np->np_thread_lock);
+
+	return 0;
+}
+
+int iscsit_deaccess_np(struct iscsi_np *np, struct iscsi_portal_group *tpg)
+{
+	struct iscsi_tiqn *tiqn = tpg->tpg_tiqn;
+
+	spin_lock_bh(&np->np_thread_lock);
+	np->np_login_tpg = NULL;
+	spin_unlock_bh(&np->np_thread_lock);
+
+	mutex_unlock(&tpg->np_login_lock);
+
+	if (tiqn)
+		iscsit_put_tiqn_for_login(tiqn);
+
+	return 0;
+}
+
+static struct iscsi_np *iscsit_get_np(
+	struct __kernel_sockaddr_storage *sockaddr,
+	int network_transport)
+{
+	struct sockaddr_in *sock_in, *sock_in_e;
+	struct sockaddr_in6 *sock_in6, *sock_in6_e;
+	struct iscsi_np *np;
+	int ip_match = 0;
+	u16 port;
+
+	spin_lock_bh(&np_lock);
+	list_for_each_entry(np, &g_np_list, np_list) {
+		spin_lock(&np->np_thread_lock);
+		if (np->np_thread_state != ISCSI_NP_THREAD_ACTIVE) {
+			spin_unlock(&np->np_thread_lock);
+			continue;
+		}
+
+		if (sockaddr->ss_family == AF_INET6) {
+			sock_in6 = (struct sockaddr_in6 *)sockaddr;
+			sock_in6_e = (struct sockaddr_in6 *)&np->np_sockaddr;
+
+			if (!memcmp((void *)&sock_in6->sin6_addr.in6_u,
+				    (void *)&sock_in6_e->sin6_addr.in6_u,
+				    sizeof(struct in6_addr)))
+				ip_match = 1;
+
+			port = ntohs(sock_in6->sin6_port);
+		} else {
+			sock_in = (struct sockaddr_in *)sockaddr;
+			sock_in_e = (struct sockaddr_in *)&np->np_sockaddr;
+
+			if (sock_in->sin_addr.s_addr ==
+			    sock_in_e->sin_addr.s_addr)
+				ip_match = 1;
+
+			port = ntohs(sock_in->sin_port);
+		}
+
+		if ((ip_match == 1) && (np->np_port == port) &&
+		    (np->np_network_transport == network_transport)) {
+			/*
+			 * Increment the np_exports reference count now to
+			 * prevent iscsit_del_np() below from being called
+			 * while iscsi_tpg_add_network_portal() is called.
+			 */
+			np->np_exports++;
+			spin_unlock(&np->np_thread_lock);
+			spin_unlock_bh(&np_lock);
+			return np;
+		}
+		spin_unlock(&np->np_thread_lock);
+	}
+	spin_unlock_bh(&np_lock);
+
+	return NULL;
+}
+
+struct iscsi_np *iscsit_add_np(
+	struct __kernel_sockaddr_storage *sockaddr,
+	char *ip_str,
+	int network_transport)
+{
+	struct sockaddr_in *sock_in;
+	struct sockaddr_in6 *sock_in6;
+	struct iscsi_np *np;
+	int ret;
+	/*
+	 * Locate the existing struct iscsi_np if already active..
+	 */
+	np = iscsit_get_np(sockaddr, network_transport);
+	if (np)
+		return np;
+
+	np = kzalloc(sizeof(struct iscsi_np), GFP_KERNEL);
+	if (!np) {
+		pr_err("Unable to allocate memory for struct iscsi_np\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	np->np_flags |= NPF_IP_NETWORK;
+	if (sockaddr->ss_family == AF_INET6) {
+		sock_in6 = (struct sockaddr_in6 *)sockaddr;
+		snprintf(np->np_ip, IPV6_ADDRESS_SPACE, "%s", ip_str);
+		np->np_port = ntohs(sock_in6->sin6_port);
+	} else {
+		sock_in = (struct sockaddr_in *)sockaddr;
+		sprintf(np->np_ip, "%s", ip_str);
+		np->np_port = ntohs(sock_in->sin_port);
+	}
+
+	np->np_network_transport = network_transport;
+	spin_lock_init(&np->np_thread_lock);
+	init_completion(&np->np_restart_comp);
+	INIT_LIST_HEAD(&np->np_list);
+
+	ret = iscsi_target_setup_login_socket(np, sockaddr);
+	if (ret != 0) {
+		kfree(np);
+		return ERR_PTR(ret);
+	}
+
+	np->np_thread = kthread_run(iscsi_target_login_thread, np, "iscsi_np");
+	if (IS_ERR(np->np_thread)) {
+		pr_err("Unable to create kthread: iscsi_np\n");
+		ret = PTR_ERR(np->np_thread);
+		kfree(np);
+		return ERR_PTR(ret);
+	}
+	/*
+	 * Increment the np_exports reference count now to prevent
+	 * iscsit_del_np() below from being run while a new call to
+	 * iscsi_tpg_add_network_portal() for a matching iscsi_np is
+	 * active.  We don't need to hold np->np_thread_lock at this
+	 * point because iscsi_np has not been added to g_np_list yet.
+	 */
+	np->np_exports = 1;
+
+	spin_lock_bh(&np_lock);
+	list_add_tail(&np->np_list, &g_np_list);
+	spin_unlock_bh(&np_lock);
+
+	pr_debug("CORE[0] - Added Network Portal: %s:%hu on %s\n",
+		np->np_ip, np->np_port, (np->np_network_transport == ISCSI_TCP) ?
+		"TCP" : "SCTP");
+
+	return np;
+}
+
+int iscsit_reset_np_thread(
+	struct iscsi_np *np,
+	struct iscsi_tpg_np *tpg_np,
+	struct iscsi_portal_group *tpg)
+{
+	spin_lock_bh(&np->np_thread_lock);
+	if (tpg && tpg_np) {
+		/*
+		 * The reset operation need only be performed when the
+		 * passed struct iscsi_portal_group has a login in progress
+		 * to one of the network portals.
+		 */
+		if (tpg_np->tpg_np->np_login_tpg != tpg) {
+			spin_unlock_bh(&np->np_thread_lock);
+			return 0;
+		}
+	}
+	if (np->np_thread_state == ISCSI_NP_THREAD_INACTIVE) {
+		spin_unlock_bh(&np->np_thread_lock);
+		return 0;
+	}
+	np->np_thread_state = ISCSI_NP_THREAD_RESET;
+
+	if (np->np_thread) {
+		spin_unlock_bh(&np->np_thread_lock);
+		send_sig(SIGINT, np->np_thread, 1);
+		wait_for_completion(&np->np_restart_comp);
+		spin_lock_bh(&np->np_thread_lock);
+	}
+	spin_unlock_bh(&np->np_thread_lock);
+
+	return 0;
+}
+
+int iscsit_del_np_comm(struct iscsi_np *np)
+{
+	if (!np->np_socket)
+		return 0;
+
+	/*
+	 * Some network transports allocate their own struct sock->file,
+	 * see  if we need to free any additional allocated resources.
+	 */
+	if (np->np_flags & NPF_SCTP_STRUCT_FILE) {
+		kfree(np->np_socket->file);
+		np->np_socket->file = NULL;
+	}
+
+	sock_release(np->np_socket);
+	return 0;
+}
+
+int iscsit_del_np(struct iscsi_np *np)
+{
+	spin_lock_bh(&np->np_thread_lock);
+	np->np_exports--;
+	if (np->np_exports) {
+		spin_unlock_bh(&np->np_thread_lock);
+		return 0;
+	}
+	np->np_thread_state = ISCSI_NP_THREAD_SHUTDOWN;
+	spin_unlock_bh(&np->np_thread_lock);
+
+	if (np->np_thread) {
+		/*
+		 * We need to send the signal to wakeup Linux/Net
+		 * which may be sleeping in sock_accept()..
+		 */
+		send_sig(SIGINT, np->np_thread, 1);
+		kthread_stop(np->np_thread);
+	}
+	iscsit_del_np_comm(np);
+
+	spin_lock_bh(&np_lock);
+	list_del(&np->np_list);
+	spin_unlock_bh(&np_lock);
+
+	pr_debug("CORE[0] - Removed Network Portal: %s:%hu on %s\n",
+		np->np_ip, np->np_port, (np->np_network_transport == ISCSI_TCP) ?
+		"TCP" : "SCTP");
+
+	kfree(np);
+	return 0;
+}
+
+static int __init iscsi_target_init_module(void)
+{
+	int ret = 0;
+
+	pr_debug("iSCSI-Target "ISCSIT_VERSION"\n");
+
+	iscsit_global = kzalloc(sizeof(struct iscsit_global), GFP_KERNEL);
+	if (!iscsit_global) {
+		pr_err("Unable to allocate memory for iscsit_global\n");
+		return -1;
+	}
+	mutex_init(&auth_id_lock);
+	spin_lock_init(&sess_idr_lock);
+	idr_init(&tiqn_idr);
+	idr_init(&sess_idr);
+
+	ret = iscsi_target_register_configfs();
+	if (ret < 0)
+		goto out;
+
+	ret = iscsi_thread_set_init();
+	if (ret < 0)
+		goto configfs_out;
+
+	if (iscsi_allocate_thread_sets(TARGET_THREAD_SET_COUNT) !=
+			TARGET_THREAD_SET_COUNT) {
+		pr_err("iscsi_allocate_thread_sets() returned"
+			" unexpected value!\n");
+		goto ts_out1;
+	}
+
+	lio_cmd_cache = kmem_cache_create("lio_cmd_cache",
+			sizeof(struct iscsi_cmd), __alignof__(struct iscsi_cmd),
+			0, NULL);
+	if (!lio_cmd_cache) {
+		pr_err("Unable to kmem_cache_create() for"
+				" lio_cmd_cache\n");
+		goto ts_out2;
+	}
+
+	lio_qr_cache = kmem_cache_create("lio_qr_cache",
+			sizeof(struct iscsi_queue_req),
+			__alignof__(struct iscsi_queue_req), 0, NULL);
+	if (!lio_qr_cache) {
+		pr_err("nable to kmem_cache_create() for"
+				" lio_qr_cache\n");
+		goto cmd_out;
+	}
+
+	lio_dr_cache = kmem_cache_create("lio_dr_cache",
+			sizeof(struct iscsi_datain_req),
+			__alignof__(struct iscsi_datain_req), 0, NULL);
+	if (!lio_dr_cache) {
+		pr_err("Unable to kmem_cache_create() for"
+				" lio_dr_cache\n");
+		goto qr_out;
+	}
+
+	lio_ooo_cache = kmem_cache_create("lio_ooo_cache",
+			sizeof(struct iscsi_ooo_cmdsn),
+			__alignof__(struct iscsi_ooo_cmdsn), 0, NULL);
+	if (!lio_ooo_cache) {
+		pr_err("Unable to kmem_cache_create() for"
+				" lio_ooo_cache\n");
+		goto dr_out;
+	}
+
+	lio_r2t_cache = kmem_cache_create("lio_r2t_cache",
+			sizeof(struct iscsi_r2t), __alignof__(struct iscsi_r2t),
+			0, NULL);
+	if (!lio_r2t_cache) {
+		pr_err("Unable to kmem_cache_create() for"
+				" lio_r2t_cache\n");
+		goto ooo_out;
+	}
+
+	if (iscsit_load_discovery_tpg() < 0)
+		goto r2t_out;
+
+	return ret;
+r2t_out:
+	kmem_cache_destroy(lio_r2t_cache);
+ooo_out:
+	kmem_cache_destroy(lio_ooo_cache);
+dr_out:
+	kmem_cache_destroy(lio_dr_cache);
+qr_out:
+	kmem_cache_destroy(lio_qr_cache);
+cmd_out:
+	kmem_cache_destroy(lio_cmd_cache);
+ts_out2:
+	iscsi_deallocate_thread_sets();
+ts_out1:
+	iscsi_thread_set_free();
+configfs_out:
+	iscsi_target_deregister_configfs();
+out:
+	kfree(iscsit_global);
+	return -ENOMEM;
+}
+
+static void __exit iscsi_target_cleanup_module(void)
+{
+	iscsi_deallocate_thread_sets();
+	iscsi_thread_set_free();
+	iscsit_release_discovery_tpg();
+	kmem_cache_destroy(lio_cmd_cache);
+	kmem_cache_destroy(lio_qr_cache);
+	kmem_cache_destroy(lio_dr_cache);
+	kmem_cache_destroy(lio_ooo_cache);
+	kmem_cache_destroy(lio_r2t_cache);
+
+	iscsi_target_deregister_configfs();
+
+	kfree(iscsit_global);
+}
+
+int iscsit_add_reject(
+	u8 reason,
+	int fail_conn,
+	unsigned char *buf,
+	struct iscsi_conn *conn)
+{
+	struct iscsi_cmd *cmd;
+	struct iscsi_reject *hdr;
+	int ret;
+
+	cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
+	if (!cmd)
+		return -1;
+
+	cmd->iscsi_opcode = ISCSI_OP_REJECT;
+	if (fail_conn)
+		cmd->cmd_flags |= ICF_REJECT_FAIL_CONN;
+
+	hdr	= (struct iscsi_reject *) cmd->pdu;
+	hdr->reason = reason;
+
+	cmd->buf_ptr = kzalloc(ISCSI_HDR_LEN, GFP_KERNEL);
+	if (!cmd->buf_ptr) {
+		pr_err("Unable to allocate memory for cmd->buf_ptr\n");
+		iscsit_release_cmd(cmd);
+		return -1;
+	}
+	memcpy(cmd->buf_ptr, buf, ISCSI_HDR_LEN);
+
+	spin_lock_bh(&conn->cmd_lock);
+	list_add_tail(&cmd->i_list, &conn->conn_cmd_list);
+	spin_unlock_bh(&conn->cmd_lock);
+
+	cmd->i_state = ISTATE_SEND_REJECT;
+	iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
+
+	ret = wait_for_completion_interruptible(&cmd->reject_comp);
+	if (ret != 0)
+		return -1;
+
+	return (!fail_conn) ? 0 : -1;
+}
+
+int iscsit_add_reject_from_cmd(
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
+	if (!cmd->conn) {
+		pr_err("cmd->conn is NULL for ITT: 0x%08x\n",
+				cmd->init_task_tag);
+		return -1;
+	}
+	conn = cmd->conn;
+
+	cmd->iscsi_opcode = ISCSI_OP_REJECT;
+	if (fail_conn)
+		cmd->cmd_flags |= ICF_REJECT_FAIL_CONN;
+
+	hdr	= (struct iscsi_reject *) cmd->pdu;
+	hdr->reason = reason;
+
+	cmd->buf_ptr = kzalloc(ISCSI_HDR_LEN, GFP_KERNEL);
+	if (!cmd->buf_ptr) {
+		pr_err("Unable to allocate memory for cmd->buf_ptr\n");
+		iscsit_release_cmd(cmd);
+		return -1;
+	}
+	memcpy(cmd->buf_ptr, buf, ISCSI_HDR_LEN);
+
+	if (add_to_conn) {
+		spin_lock_bh(&conn->cmd_lock);
+		list_add_tail(&cmd->i_list, &conn->conn_cmd_list);
+		spin_unlock_bh(&conn->cmd_lock);
+	}
+
+	cmd->i_state = ISTATE_SEND_REJECT;
+	iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
+
+	ret = wait_for_completion_interruptible(&cmd->reject_comp);
+	if (ret != 0)
+		return -1;
+
+	return (!fail_conn) ? 0 : -1;
+}
+
+/*
+ * Map some portion of the allocated scatterlist to an iovec, suitable for
+ * kernel sockets to copy data in/out. This handles both pages and slab-allocated
+ * buffers, since we have been tricky and mapped t_mem_sg to the buffer in
+ * either case (see iscsit_alloc_buffs)
+ */
+static int iscsit_map_iovec(
+	struct iscsi_cmd *cmd,
+	struct kvec *iov,
+	u32 data_offset,
+	u32 data_length)
+{
+	u32 i = 0;
+	struct scatterlist *sg;
+	unsigned int page_off;
+
+	/*
+	 * We have a private mapping of the allocated pages in t_mem_sg.
+	 * At this point, we also know each contains a page.
+	 */
+	sg = &cmd->t_mem_sg[data_offset / PAGE_SIZE];
+	page_off = (data_offset % PAGE_SIZE);
+
+	cmd->first_data_sg = sg;
+	cmd->first_data_sg_off = page_off;
+
+	while (data_length) {
+		u32 cur_len = min_t(u32, data_length, sg->length - page_off);
+
+		iov[i].iov_base = kmap(sg_page(sg)) + sg->offset + page_off;
+		iov[i].iov_len = cur_len;
+
+		data_length -= cur_len;
+		page_off = 0;
+		sg = sg_next(sg);
+		i++;
+	}
+
+	cmd->kmapped_nents = i;
+
+	return i;
+}
+
+static void iscsit_unmap_iovec(struct iscsi_cmd *cmd)
+{
+	u32 i;
+	struct scatterlist *sg;
+
+	sg = cmd->first_data_sg;
+
+	for (i = 0; i < cmd->kmapped_nents; i++)
+		kunmap(sg_page(&sg[i]));
+}
+
+static void iscsit_ack_from_expstatsn(struct iscsi_conn *conn, u32 exp_statsn)
+{
+	struct iscsi_cmd *cmd;
+
+	conn->exp_statsn = exp_statsn;
+
+	spin_lock_bh(&conn->cmd_lock);
+	list_for_each_entry(cmd, &conn->conn_cmd_list, i_list) {
+		spin_lock(&cmd->istate_lock);
+		if ((cmd->i_state == ISTATE_SENT_STATUS) &&
+		    (cmd->stat_sn < exp_statsn)) {
+			cmd->i_state = ISTATE_REMOVE;
+			spin_unlock(&cmd->istate_lock);
+			iscsit_add_cmd_to_immediate_queue(cmd, conn,
+						cmd->i_state);
+			continue;
+		}
+		spin_unlock(&cmd->istate_lock);
+	}
+	spin_unlock_bh(&conn->cmd_lock);
+}
+
+static int iscsit_allocate_iovecs(struct iscsi_cmd *cmd)
+{
+	u32 iov_count = (cmd->se_cmd.t_data_nents == 0) ? 1 :
+				cmd->se_cmd.t_data_nents;
+
+	iov_count += TRANSPORT_IOV_DATA_BUFFER;
+
+	cmd->iov_data = kzalloc(iov_count * sizeof(struct kvec), GFP_KERNEL);
+	if (!cmd->iov_data) {
+		pr_err("Unable to allocate cmd->iov_data\n");
+		return -ENOMEM;
+	}
+
+	cmd->orig_iov_data_count = iov_count;
+	return 0;
+}
+
+static int iscsit_alloc_buffs(struct iscsi_cmd *cmd)
+{
+	struct scatterlist *sgl;
+	u32 length = cmd->se_cmd.data_length;
+	int nents = DIV_ROUND_UP(length, PAGE_SIZE);
+	int i = 0, ret;
+	/*
+	 * If no SCSI payload is present, allocate the default iovecs used for
+	 * iSCSI PDU Header
+	 */
+	if (!length)
+		return iscsit_allocate_iovecs(cmd);
+
+	sgl = kzalloc(sizeof(*sgl) * nents, GFP_KERNEL);
+	if (!sgl)
+		return -ENOMEM;
+
+	sg_init_table(sgl, nents);
+
+	while (length) {
+		int buf_size = min_t(int, length, PAGE_SIZE);
+		struct page *page;
+
+		page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!page)
+			goto page_alloc_failed;
+
+		sg_set_page(&sgl[i], page, buf_size, 0);
+
+		length -= buf_size;
+		i++;
+	}
+
+	cmd->t_mem_sg = sgl;
+	cmd->t_mem_sg_nents = nents;
+
+	/* BIDI ops not supported */
+
+	/* Tell the core about our preallocated memory */
+	transport_generic_map_mem_to_cmd(&cmd->se_cmd, sgl, nents, NULL, 0);
+	/*
+	 * Allocate iovecs for SCSI payload after transport_generic_map_mem_to_cmd
+	 * so that cmd->se_cmd.t_tasks_se_num has been set.
+	 */
+        ret = iscsit_allocate_iovecs(cmd);
+        if (ret < 0)
+		goto page_alloc_failed;
+
+	return 0;
+
+page_alloc_failed:
+	while (i >= 0) {
+		__free_page(sg_page(&sgl[i]));
+		i--;
+	}
+	kfree(cmd->t_mem_sg);
+	cmd->t_mem_sg = NULL;
+	return -ENOMEM;
+}
+
+static int iscsit_handle_scsi_cmd(
+	struct iscsi_conn *conn,
+	unsigned char *buf)
+{
+	int	data_direction, cmdsn_ret = 0, immed_ret, ret, transport_ret;
+	int	dump_immediate_data = 0, send_check_condition = 0, payload_length;
+	struct iscsi_cmd	*cmd = NULL;
+	struct iscsi_scsi_req *hdr;
+
+	spin_lock_bh(&conn->sess->session_stats_lock);
+	conn->sess->cmd_pdus++;
+	if (conn->sess->se_sess->se_node_acl) {
+		spin_lock(&conn->sess->se_sess->se_node_acl->stats_lock);
+		conn->sess->se_sess->se_node_acl->num_cmds++;
+		spin_unlock(&conn->sess->se_sess->se_node_acl->stats_lock);
+	}
+	spin_unlock_bh(&conn->sess->session_stats_lock);
+
+	hdr			= (struct iscsi_scsi_req *) buf;
+	payload_length		= ntoh24(hdr->dlength);
+	hdr->itt		= be32_to_cpu(hdr->itt);
+	hdr->data_length	= be32_to_cpu(hdr->data_length);
+	hdr->cmdsn		= be32_to_cpu(hdr->cmdsn);
+	hdr->exp_statsn		= be32_to_cpu(hdr->exp_statsn);
+
+	/* FIXME; Add checks for AdditionalHeaderSegment */
+
+	if (!(hdr->flags & ISCSI_FLAG_CMD_WRITE) &&
+	    !(hdr->flags & ISCSI_FLAG_CMD_FINAL)) {
+		pr_err("ISCSI_FLAG_CMD_WRITE & ISCSI_FLAG_CMD_FINAL"
+				" not set. Bad iSCSI Initiator.\n");
+		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
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
+		if ((hdr->cdb[0] == 0x16) || (hdr->cdb[0] == 0x17)) {
+			hdr->flags &= ~ISCSI_FLAG_CMD_READ;
+			hdr->flags &= ~ISCSI_FLAG_CMD_WRITE;
+			goto done;
+		}
+
+		pr_err("ISCSI_FLAG_CMD_READ or ISCSI_FLAG_CMD_WRITE"
+			" set when Expected Data Transfer Length is 0 for"
+			" CDB: 0x%02x. Bad iSCSI Initiator.\n", hdr->cdb[0]);
+		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
+				buf, conn);
+	}
+done:
+
+	if (!(hdr->flags & ISCSI_FLAG_CMD_READ) &&
+	    !(hdr->flags & ISCSI_FLAG_CMD_WRITE) && (hdr->data_length != 0)) {
+		pr_err("ISCSI_FLAG_CMD_READ and/or ISCSI_FLAG_CMD_WRITE"
+			" MUST be set if Expected Data Transfer Length is not 0."
+			" Bad iSCSI Initiator\n");
+		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
+				buf, conn);
+	}
+
+	if ((hdr->flags & ISCSI_FLAG_CMD_READ) &&
+	    (hdr->flags & ISCSI_FLAG_CMD_WRITE)) {
+		pr_err("Bidirectional operations not supported!\n");
+		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
+				buf, conn);
+	}
+
+	if (hdr->opcode & ISCSI_OP_IMMEDIATE) {
+		pr_err("Illegally set Immediate Bit in iSCSI Initiator"
+				" Scsi Command PDU.\n");
+		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
+				buf, conn);
+	}
+
+	if (payload_length && !conn->sess->sess_ops->ImmediateData) {
+		pr_err("ImmediateData=No but DataSegmentLength=%u,"
+			" protocol error.\n", payload_length);
+		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+				buf, conn);
+	}
+
+	if ((hdr->data_length == payload_length) &&
+	    (!(hdr->flags & ISCSI_FLAG_CMD_FINAL))) {
+		pr_err("Expected Data Transfer Length and Length of"
+			" Immediate Data are the same, but ISCSI_FLAG_CMD_FINAL"
+			" bit is not set protocol error\n");
+		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+				buf, conn);
+	}
+
+	if (payload_length > hdr->data_length) {
+		pr_err("DataSegmentLength: %u is greater than"
+			" EDTL: %u, protocol error.\n", payload_length,
+				hdr->data_length);
+		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+				buf, conn);
+	}
+
+	if (payload_length > conn->conn_ops->MaxRecvDataSegmentLength) {
+		pr_err("DataSegmentLength: %u is greater than"
+			" MaxRecvDataSegmentLength: %u, protocol error.\n",
+			payload_length, conn->conn_ops->MaxRecvDataSegmentLength);
+		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+				buf, conn);
+	}
+
+	if (payload_length > conn->sess->sess_ops->FirstBurstLength) {
+		pr_err("DataSegmentLength: %u is greater than"
+			" FirstBurstLength: %u, protocol error.\n",
+			payload_length, conn->sess->sess_ops->FirstBurstLength);
+		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
+					buf, conn);
+	}
+
+	data_direction = (hdr->flags & ISCSI_FLAG_CMD_WRITE) ? DMA_TO_DEVICE :
+			 (hdr->flags & ISCSI_FLAG_CMD_READ) ? DMA_FROM_DEVICE :
+			  DMA_NONE;
+
+	cmd = iscsit_allocate_se_cmd(conn, hdr->data_length, data_direction,
+				(hdr->flags & ISCSI_FLAG_CMD_ATTR_MASK));
+	if (!cmd)
+		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_NO_RESOURCES, 1,
+					buf, conn);
+
+	pr_debug("Got SCSI Command, ITT: 0x%08x, CmdSN: 0x%08x,"
+		" ExpXferLen: %u, Length: %u, CID: %hu\n", hdr->itt,
+		hdr->cmdsn, hdr->data_length, payload_length, conn->cid);
+
+	cmd->iscsi_opcode	= ISCSI_OP_SCSI_CMD;
+	cmd->i_state		= ISTATE_NEW_CMD;
+	cmd->immediate_cmd	= ((hdr->opcode & ISCSI_OP_IMMEDIATE) ? 1 : 0);
+	cmd->immediate_data	= (payload_length) ? 1 : 0;
+	cmd->unsolicited_data	= ((!(hdr->flags & ISCSI_FLAG_CMD_FINAL) &&
+				     (hdr->flags & ISCSI_FLAG_CMD_WRITE)) ? 1 : 0);
+	if (cmd->unsolicited_data)
+		cmd->cmd_flags |= ICF_NON_IMMEDIATE_UNSOLICITED_DATA;
+
+	conn->sess->init_task_tag = cmd->init_task_tag = hdr->itt;
+	if (hdr->flags & ISCSI_FLAG_CMD_READ) {
+		spin_lock_bh(&conn->sess->ttt_lock);
+		cmd->targ_xfer_tag = conn->sess->targ_xfer_tag++;
+		if (cmd->targ_xfer_tag == 0xFFFFFFFF)
+			cmd->targ_xfer_tag = conn->sess->targ_xfer_tag++;
+		spin_unlock_bh(&conn->sess->ttt_lock);
+	} else if (hdr->flags & ISCSI_FLAG_CMD_WRITE)
+		cmd->targ_xfer_tag = 0xFFFFFFFF;
+	cmd->cmd_sn		= hdr->cmdsn;
+	cmd->exp_stat_sn	= hdr->exp_statsn;
+	cmd->first_burst_len	= payload_length;
+
+	if (cmd->data_direction == DMA_FROM_DEVICE) {
+		struct iscsi_datain_req *dr;
+
+		dr = iscsit_allocate_datain_req();
+		if (!dr)
+			return iscsit_add_reject_from_cmd(
+					ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+					1, 1, buf, cmd);
+
+		iscsit_attach_datain_req(cmd, dr);
+	}
+
+	/*
+	 * The CDB is going to an se_device_t.
+	 */
+	ret = iscsit_get_lun_for_cmd(cmd, hdr->cdb,
+				get_unaligned_le64(&hdr->lun[0]));
+	if (ret < 0) {
+		if (cmd->se_cmd.scsi_sense_reason == TCM_NON_EXISTENT_LUN) {
+			pr_debug("Responding to non-acl'ed,"
+				" non-existent or non-exported iSCSI LUN:"
+				" 0x%016Lx\n", get_unaligned_le64(&hdr->lun[0]));
+		}
+		if (ret == PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES)
+			return iscsit_add_reject_from_cmd(
+					ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+					1, 1, buf, cmd);
+
+		send_check_condition = 1;
+		goto attach_cmd;
+	}
+	/*
+	 * The Initiator Node has access to the LUN (the addressing method
+	 * is handled inside of iscsit_get_lun_for_cmd()).  Now it's time to
+	 * allocate 1->N transport tasks (depending on sector count and
+	 * maximum request size the physical HBA(s) can handle.
+	 */
+	transport_ret = transport_generic_allocate_tasks(&cmd->se_cmd, hdr->cdb);
+	if (transport_ret == -ENOMEM) {
+		return iscsit_add_reject_from_cmd(
+				ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+				1, 1, buf, cmd);
+	} else if (transport_ret == -EINVAL) {
+		/*
+		 * Unsupported SAM Opcode.  CHECK_CONDITION will be sent
+		 * in iscsit_execute_cmd() during the CmdSN OOO Execution
+		 * Mechinism.
+		 */
+		send_check_condition = 1;
+	} else {
+		if (iscsit_decide_list_to_build(cmd, payload_length) < 0)
+			return iscsit_add_reject_from_cmd(
+				ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+				1, 1, buf, cmd);
+	}
+
+attach_cmd:
+	spin_lock_bh(&conn->cmd_lock);
+	list_add_tail(&cmd->i_list, &conn->conn_cmd_list);
+	spin_unlock_bh(&conn->cmd_lock);
+	/*
+	 * Check if we need to delay processing because of ALUA
+	 * Active/NonOptimized primary access state..
+	 */
+	core_alua_check_nonop_delay(&cmd->se_cmd);
+	/*
+	 * Allocate and setup SGL used with transport_generic_map_mem_to_cmd().
+	 * also call iscsit_allocate_iovecs()
+	 */
+	ret = iscsit_alloc_buffs(cmd);
+	if (ret < 0)
+		return iscsit_add_reject_from_cmd(
+				ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+				1, 1, buf, cmd);
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
+		cmdsn_ret = iscsit_sequence_cmd(conn, cmd, hdr->cmdsn);
+		if (cmdsn_ret == CMDSN_ERROR_CANNOT_RECOVER)
+			return iscsit_add_reject_from_cmd(
+				ISCSI_REASON_PROTOCOL_ERROR,
+				1, 0, buf, cmd);
+	}
+
+	iscsit_ack_from_expstatsn(conn, hdr->exp_statsn);
+
+	/*
+	 * If no Immediate Data is attached, it's OK to return now.
+	 */
+	if (!cmd->immediate_data) {
+		if (send_check_condition)
+			return 0;
+
+		if (cmd->unsolicited_data) {
+			iscsit_set_dataout_sequence_values(cmd);
+
+			spin_lock_bh(&cmd->dataout_timeout_lock);
+			iscsit_start_dataout_timer(cmd, cmd->conn);
+			spin_unlock_bh(&cmd->dataout_timeout_lock);
+		}
+
+		return 0;
+	}
+
+	/*
+	 * Early CHECK_CONDITIONs never make it to the transport processing
+	 * thread.  They are processed in CmdSN order by
+	 * iscsit_check_received_cmdsn() below.
+	 */
+	if (send_check_condition) {
+		immed_ret = IMMEDIATE_DATA_NORMAL_OPERATION;
+		dump_immediate_data = 1;
+		goto after_immediate_data;
+	}
+	/*
+	 * Call directly into transport_generic_new_cmd() to perform
+	 * the backend memory allocation.
+	 */
+	ret = transport_generic_new_cmd(&cmd->se_cmd);
+	if ((ret < 0) || (cmd->se_cmd.se_cmd_flags & SCF_SE_CMD_FAILED)) {
+		immed_ret = IMMEDIATE_DATA_NORMAL_OPERATION;
+		dump_immediate_data = 1;
+		goto after_immediate_data;
+	}
+
+	immed_ret = iscsit_handle_immediate_data(cmd, buf, payload_length);
+after_immediate_data:
+	if (immed_ret == IMMEDIATE_DATA_NORMAL_OPERATION) {
+		/*
+		 * A PDU/CmdSN carrying Immediate Data passed
+		 * DataCRC, check against ExpCmdSN/MaxCmdSN if
+		 * Immediate Bit is not set.
+		 */
+		cmdsn_ret = iscsit_sequence_cmd(conn, cmd, hdr->cmdsn);
+		/*
+		 * Special case for Unsupported SAM WRITE Opcodes
+		 * and ImmediateData=Yes.
+		 */
+		if (dump_immediate_data) {
+			if (iscsit_dump_data_payload(conn, payload_length, 1) < 0)
+				return -1;
+		} else if (cmd->unsolicited_data) {
+			iscsit_set_dataout_sequence_values(cmd);
+
+			spin_lock_bh(&cmd->dataout_timeout_lock);
+			iscsit_start_dataout_timer(cmd, cmd->conn);
+			spin_unlock_bh(&cmd->dataout_timeout_lock);
+		}
+
+		if (cmdsn_ret == CMDSN_ERROR_CANNOT_RECOVER)
+			return iscsit_add_reject_from_cmd(
+				ISCSI_REASON_PROTOCOL_ERROR,
+				1, 0, buf, cmd);
+
+	} else if (immed_ret == IMMEDIATE_DATA_ERL1_CRC_FAILURE) {
+		/*
+		 * Immediate Data failed DataCRC and ERL>=1,
+		 * silently drop this PDU and let the initiator
+		 * plug the CmdSN gap.
+		 *
+		 * FIXME: Send Unsolicited NOPIN with reserved
+		 * TTT here to help the initiator figure out
+		 * the missing CmdSN, although they should be
+		 * intelligent enough to determine the missing
+		 * CmdSN and issue a retry to plug the sequence.
+		 */
+		cmd->i_state = ISTATE_REMOVE;
+		iscsit_add_cmd_to_immediate_queue(cmd, conn, cmd->i_state);
+	} else /* immed_ret == IMMEDIATE_DATA_CANNOT_RECOVER */
+		return -1;
+
+	return 0;
+}
+
+static u32 iscsit_do_crypto_hash_sg(
+	struct hash_desc *hash,
+	struct iscsi_cmd *cmd,
+	u32 data_offset,
+	u32 data_length,
+	u32 padding,
+	u8 *pad_bytes)
+{
+	u32 data_crc;
+	u32 i;
+	struct scatterlist *sg;
+	unsigned int page_off;
+
+	crypto_hash_init(hash);
+
+	sg = cmd->first_data_sg;
+	page_off = cmd->first_data_sg_off;
+
+	i = 0;
+	while (data_length) {
+		u32 cur_len = min_t(u32, data_length, (sg[i].length - page_off));
+
+		crypto_hash_update(hash, &sg[i], cur_len);
+
+		data_length -= cur_len;
+		page_off = 0;
+		i++;
+	}
+
+	if (padding) {
+		struct scatterlist pad_sg;
+
+		sg_init_one(&pad_sg, pad_bytes, padding);
+		crypto_hash_update(hash, &pad_sg, padding);
+	}
+	crypto_hash_final(hash, (u8 *) &data_crc);
+
+	return data_crc;
+}
+
+static void iscsit_do_crypto_hash_buf(
+	struct hash_desc *hash,
+	unsigned char *buf,
+	u32 payload_length,
+	u32 padding,
+	u8 *pad_bytes,
+	u8 *data_crc)
+{
+	struct scatterlist sg;
+
+	crypto_hash_init(hash);
+
+	sg_init_one(&sg, (u8 *)buf, payload_length);
+	crypto_hash_update(hash, &sg, payload_length);
+
+	if (padding) {
+		sg_init_one(&sg, pad_bytes, padding);
+		crypto_hash_update(hash, &sg, padding);
+	}
+	crypto_hash_final(hash, data_crc);
+}
+
+static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
+{
+	int iov_ret, ooo_cmdsn = 0, ret;
+	u8 data_crc_failed = 0;
+	u32 checksum, iov_count = 0, padding = 0, rx_got = 0;
+	u32 rx_size = 0, payload_length;
+	struct iscsi_cmd *cmd = NULL;
+	struct se_cmd *se_cmd;
+	struct iscsi_data *hdr;
+	struct kvec *iov;
+	unsigned long flags;
+
+	hdr			= (struct iscsi_data *) buf;
+	payload_length		= ntoh24(hdr->dlength);
+	hdr->itt		= be32_to_cpu(hdr->itt);
+	hdr->ttt		= be32_to_cpu(hdr->ttt);
+	hdr->exp_statsn		= be32_to_cpu(hdr->exp_statsn);
+	hdr->datasn		= be32_to_cpu(hdr->datasn);
+	hdr->offset		= be32_to_cpu(hdr->offset);
+
+	if (!payload_length) {
+		pr_err("DataOUT payload is ZERO, protocol error.\n");
+		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+					buf, conn);
+	}
+
+	/* iSCSI write */
+	spin_lock_bh(&conn->sess->session_stats_lock);
+	conn->sess->rx_data_octets += payload_length;
+	if (conn->sess->se_sess->se_node_acl) {
+		spin_lock(&conn->sess->se_sess->se_node_acl->stats_lock);
+		conn->sess->se_sess->se_node_acl->write_bytes += payload_length;
+		spin_unlock(&conn->sess->se_sess->se_node_acl->stats_lock);
+	}
+	spin_unlock_bh(&conn->sess->session_stats_lock);
+
+	if (payload_length > conn->conn_ops->MaxRecvDataSegmentLength) {
+		pr_err("DataSegmentLength: %u is greater than"
+			" MaxRecvDataSegmentLength: %u\n", payload_length,
+			conn->conn_ops->MaxRecvDataSegmentLength);
+		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+					buf, conn);
+	}
+
+	cmd = iscsit_find_cmd_from_itt_or_dump(conn, hdr->itt,
+			payload_length);
+	if (!cmd)
+		return 0;
+
+	pr_debug("Got DataOut ITT: 0x%08x, TTT: 0x%08x,"
+		" DataSN: 0x%08x, Offset: %u, Length: %u, CID: %hu\n",
+		hdr->itt, hdr->ttt, hdr->datasn, hdr->offset,
+		payload_length, conn->cid);
+
+	if (cmd->cmd_flags & ICF_GOT_LAST_DATAOUT) {
+		pr_err("Command ITT: 0x%08x received DataOUT after"
+			" last DataOUT received, dumping payload\n",
+			cmd->init_task_tag);
+		return iscsit_dump_data_payload(conn, payload_length, 1);
+	}
+
+	if (cmd->data_direction != DMA_TO_DEVICE) {
+		pr_err("Command ITT: 0x%08x received DataOUT for a"
+			" NON-WRITE command.\n", cmd->init_task_tag);
+		return iscsit_add_reject_from_cmd(ISCSI_REASON_PROTOCOL_ERROR,
+				1, 0, buf, cmd);
+	}
+	se_cmd = &cmd->se_cmd;
+	iscsit_mod_dataout_timer(cmd);
+
+	if ((hdr->offset + payload_length) > cmd->data_length) {
+		pr_err("DataOut Offset: %u, Length %u greater than"
+			" iSCSI Command EDTL %u, protocol error.\n",
+			hdr->offset, payload_length, cmd->data_length);
+		return iscsit_add_reject_from_cmd(ISCSI_REASON_BOOKMARK_INVALID,
+				1, 0, buf, cmd);
+	}
+
+	if (cmd->unsolicited_data) {
+		int dump_unsolicited_data = 0;
+
+		if (conn->sess->sess_ops->InitialR2T) {
+			pr_err("Received unexpected unsolicited data"
+				" while InitialR2T=Yes, protocol error.\n");
+			transport_send_check_condition_and_sense(&cmd->se_cmd,
+					TCM_UNEXPECTED_UNSOLICITED_DATA, 0);
+			return -1;
+		}
+		/*
+		 * Special case for dealing with Unsolicited DataOUT
+		 * and Unsupported SAM WRITE Opcodes and SE resource allocation
+		 * failures;
+		 */
+
+		/* Something's amiss if we're not in WRITE_PENDING state... */
+		spin_lock_irqsave(&se_cmd->t_state_lock, flags);
+		WARN_ON(se_cmd->t_state != TRANSPORT_WRITE_PENDING);
+		spin_unlock_irqrestore(&se_cmd->t_state_lock, flags);
+
+		spin_lock_irqsave(&se_cmd->t_state_lock, flags);
+		if (!(se_cmd->se_cmd_flags & SCF_SUPPORTED_SAM_OPCODE) ||
+		     (se_cmd->se_cmd_flags & SCF_SE_CMD_FAILED))
+			dump_unsolicited_data = 1;
+		spin_unlock_irqrestore(&se_cmd->t_state_lock, flags);
+
+		if (dump_unsolicited_data) {
+			/*
+			 * Check if a delayed TASK_ABORTED status needs to
+			 * be sent now if the ISCSI_FLAG_CMD_FINAL has been
+			 * received with the unsolicitied data out.
+			 */
+			if (hdr->flags & ISCSI_FLAG_CMD_FINAL)
+				iscsit_stop_dataout_timer(cmd);
+
+			transport_check_aborted_status(se_cmd,
+					(hdr->flags & ISCSI_FLAG_CMD_FINAL));
+			return iscsit_dump_data_payload(conn, payload_length, 1);
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
+		if (atomic_read(&se_cmd->t_transport_aborted) != 0) {
+			if (hdr->flags & ISCSI_FLAG_CMD_FINAL)
+				if (--cmd->outstanding_r2ts < 1) {
+					iscsit_stop_dataout_timer(cmd);
+					transport_check_aborted_status(
+							se_cmd, 1);
+				}
+
+			return iscsit_dump_data_payload(conn, payload_length, 1);
+		}
+	}
+	/*
+	 * Preform DataSN, DataSequenceInOrder, DataPDUInOrder, and
+	 * within-command recovery checks before receiving the payload.
+	 */
+	ret = iscsit_check_pre_dataout(cmd, buf);
+	if (ret == DATAOUT_WITHIN_COMMAND_RECOVERY)
+		return 0;
+	else if (ret == DATAOUT_CANNOT_RECOVER)
+		return -1;
+
+	rx_size += payload_length;
+	iov = &cmd->iov_data[0];
+
+	iov_ret = iscsit_map_iovec(cmd, iov, hdr->offset, payload_length);
+	if (iov_ret < 0)
+		return -1;
+
+	iov_count += iov_ret;
+
+	padding = ((-payload_length) & 3);
+	if (padding != 0) {
+		iov[iov_count].iov_base	= cmd->pad_bytes;
+		iov[iov_count++].iov_len = padding;
+		rx_size += padding;
+		pr_debug("Receiving %u padding bytes.\n", padding);
+	}
+
+	if (conn->conn_ops->DataDigest) {
+		iov[iov_count].iov_base = &checksum;
+		iov[iov_count++].iov_len = ISCSI_CRC_LEN;
+		rx_size += ISCSI_CRC_LEN;
+	}
+
+	rx_got = rx_data(conn, &cmd->iov_data[0], iov_count, rx_size);
+
+	iscsit_unmap_iovec(cmd);
+
+	if (rx_got != rx_size)
+		return -1;
+
+	if (conn->conn_ops->DataDigest) {
+		u32 data_crc;
+
+		data_crc = iscsit_do_crypto_hash_sg(&conn->conn_rx_hash, cmd,
+						    hdr->offset, payload_length, padding,
+						    cmd->pad_bytes);
+
+		if (checksum != data_crc) {
+			pr_err("ITT: 0x%08x, Offset: %u, Length: %u,"
+				" DataSN: 0x%08x, CRC32C DataDigest 0x%08x"
+				" does not match computed 0x%08x\n",
+				hdr->itt, hdr->offset, payload_length,
+				hdr->datasn, checksum, data_crc);
+			data_crc_failed = 1;
+		} else {
+			pr_debug("Got CRC32C DataDigest 0x%08x for"
+				" %u bytes of Data Out\n", checksum,
+				payload_length);
+		}
+	}
+	/*
+	 * Increment post receive data and CRC values or perform
+	 * within-command recovery.
+	 */
+	ret = iscsit_check_post_dataout(cmd, buf, data_crc_failed);
+	if ((ret == DATAOUT_NORMAL) || (ret == DATAOUT_WITHIN_COMMAND_RECOVERY))
+		return 0;
+	else if (ret == DATAOUT_SEND_R2T) {
+		iscsit_set_dataout_sequence_values(cmd);
+		iscsit_build_r2ts_for_cmd(cmd, conn, 0);
+	} else if (ret == DATAOUT_SEND_TO_TRANSPORT) {
+		/*
+		 * Handle extra special case for out of order
+		 * Unsolicited Data Out.
+		 */
+		spin_lock_bh(&cmd->istate_lock);
+		ooo_cmdsn = (cmd->cmd_flags & ICF_OOO_CMDSN);
+		cmd->cmd_flags |= ICF_GOT_LAST_DATAOUT;
+		cmd->i_state = ISTATE_RECEIVED_LAST_DATAOUT;
+		spin_unlock_bh(&cmd->istate_lock);
+
+		iscsit_stop_dataout_timer(cmd);
+		return (!ooo_cmdsn) ? transport_generic_handle_data(
+					&cmd->se_cmd) : 0;
+	} else /* DATAOUT_CANNOT_RECOVER */
+		return -1;
+
+	return 0;
+}
+
+static int iscsit_handle_nop_out(
+	struct iscsi_conn *conn,
+	unsigned char *buf)
+{
+	unsigned char *ping_data = NULL;
+	int cmdsn_ret, niov = 0, ret = 0, rx_got, rx_size;
+	u32 checksum, data_crc, padding = 0, payload_length;
+	u64 lun;
+	struct iscsi_cmd *cmd = NULL;
+	struct kvec *iov = NULL;
+	struct iscsi_nopout *hdr;
+
+	hdr			= (struct iscsi_nopout *) buf;
+	payload_length		= ntoh24(hdr->dlength);
+	lun			= get_unaligned_le64(&hdr->lun[0]);
+	hdr->itt		= be32_to_cpu(hdr->itt);
+	hdr->ttt		= be32_to_cpu(hdr->ttt);
+	hdr->cmdsn		= be32_to_cpu(hdr->cmdsn);
+	hdr->exp_statsn		= be32_to_cpu(hdr->exp_statsn);
+
+	if ((hdr->itt == 0xFFFFFFFF) && !(hdr->opcode & ISCSI_OP_IMMEDIATE)) {
+		pr_err("NOPOUT ITT is reserved, but Immediate Bit is"
+			" not set, protocol error.\n");
+		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+					buf, conn);
+	}
+
+	if (payload_length > conn->conn_ops->MaxRecvDataSegmentLength) {
+		pr_err("NOPOUT Ping Data DataSegmentLength: %u is"
+			" greater than MaxRecvDataSegmentLength: %u, protocol"
+			" error.\n", payload_length,
+			conn->conn_ops->MaxRecvDataSegmentLength);
+		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+					buf, conn);
+	}
+
+	pr_debug("Got NOPOUT Ping %s ITT: 0x%08x, TTT: 0x%09x,"
+		" CmdSN: 0x%08x, ExpStatSN: 0x%08x, Length: %u\n",
+		(hdr->itt == 0xFFFFFFFF) ? "Response" : "Request",
+		hdr->itt, hdr->ttt, hdr->cmdsn, hdr->exp_statsn,
+		payload_length);
+	/*
+	 * This is not a response to a Unsolicited NopIN, which means
+	 * it can either be a NOPOUT ping request (with a valid ITT),
+	 * or a NOPOUT not requesting a NOPIN (with a reserved ITT).
+	 * Either way, make sure we allocate an struct iscsi_cmd, as both
+	 * can contain ping data.
+	 */
+	if (hdr->ttt == 0xFFFFFFFF) {
+		cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
+		if (!cmd)
+			return iscsit_add_reject(
+					ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+					1, buf, conn);
+
+		cmd->iscsi_opcode	= ISCSI_OP_NOOP_OUT;
+		cmd->i_state		= ISTATE_SEND_NOPIN;
+		cmd->immediate_cmd	= ((hdr->opcode & ISCSI_OP_IMMEDIATE) ?
+						1 : 0);
+		conn->sess->init_task_tag = cmd->init_task_tag = hdr->itt;
+		cmd->targ_xfer_tag	= 0xFFFFFFFF;
+		cmd->cmd_sn		= hdr->cmdsn;
+		cmd->exp_stat_sn	= hdr->exp_statsn;
+		cmd->data_direction	= DMA_NONE;
+	}
+
+	if (payload_length && (hdr->ttt == 0xFFFFFFFF)) {
+		rx_size = payload_length;
+		ping_data = kzalloc(payload_length + 1, GFP_KERNEL);
+		if (!ping_data) {
+			pr_err("Unable to allocate memory for"
+				" NOPOUT ping data.\n");
+			ret = -1;
+			goto out;
+		}
+
+		iov = &cmd->iov_misc[0];
+		iov[niov].iov_base	= ping_data;
+		iov[niov++].iov_len	= payload_length;
+
+		padding = ((-payload_length) & 3);
+		if (padding != 0) {
+			pr_debug("Receiving %u additional bytes"
+				" for padding.\n", padding);
+			iov[niov].iov_base	= &cmd->pad_bytes;
+			iov[niov++].iov_len	= padding;
+			rx_size += padding;
+		}
+		if (conn->conn_ops->DataDigest) {
+			iov[niov].iov_base	= &checksum;
+			iov[niov++].iov_len	= ISCSI_CRC_LEN;
+			rx_size += ISCSI_CRC_LEN;
+		}
+
+		rx_got = rx_data(conn, &cmd->iov_misc[0], niov, rx_size);
+		if (rx_got != rx_size) {
+			ret = -1;
+			goto out;
+		}
+
+		if (conn->conn_ops->DataDigest) {
+			iscsit_do_crypto_hash_buf(&conn->conn_rx_hash,
+					ping_data, payload_length,
+					padding, cmd->pad_bytes,
+					(u8 *)&data_crc);
+
+			if (checksum != data_crc) {
+				pr_err("Ping data CRC32C DataDigest"
+				" 0x%08x does not match computed 0x%08x\n",
+					checksum, data_crc);
+				if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
+					pr_err("Unable to recover from"
+					" NOPOUT Ping DataCRC failure while in"
+						" ERL=0.\n");
+					ret = -1;
+					goto out;
+				} else {
+					/*
+					 * Silently drop this PDU and let the
+					 * initiator plug the CmdSN gap.
+					 */
+					pr_debug("Dropping NOPOUT"
+					" Command CmdSN: 0x%08x due to"
+					" DataCRC error.\n", hdr->cmdsn);
+					ret = 0;
+					goto out;
+				}
+			} else {
+				pr_debug("Got CRC32C DataDigest"
+				" 0x%08x for %u bytes of ping data.\n",
+					checksum, payload_length);
+			}
+		}
+
+		ping_data[payload_length] = '\0';
+		/*
+		 * Attach ping data to struct iscsi_cmd->buf_ptr.
+		 */
+		cmd->buf_ptr = (void *)ping_data;
+		cmd->buf_ptr_size = payload_length;
+
+		pr_debug("Got %u bytes of NOPOUT ping"
+			" data.\n", payload_length);
+		pr_debug("Ping Data: \"%s\"\n", ping_data);
+	}
+
+	if (hdr->itt != 0xFFFFFFFF) {
+		if (!cmd) {
+			pr_err("Checking CmdSN for NOPOUT,"
+				" but cmd is NULL!\n");
+			return -1;
+		}
+		/*
+		 * Initiator is expecting a NopIN ping reply,
+		 */
+		spin_lock_bh(&conn->cmd_lock);
+		list_add_tail(&cmd->i_list, &conn->conn_cmd_list);
+		spin_unlock_bh(&conn->cmd_lock);
+
+		iscsit_ack_from_expstatsn(conn, hdr->exp_statsn);
+
+		if (hdr->opcode & ISCSI_OP_IMMEDIATE) {
+			iscsit_add_cmd_to_response_queue(cmd, conn,
+					cmd->i_state);
+			return 0;
+		}
+
+		cmdsn_ret = iscsit_sequence_cmd(conn, cmd, hdr->cmdsn);
+		if (cmdsn_ret == CMDSN_LOWER_THAN_EXP) {
+			ret = 0;
+			goto ping_out;
+		}
+		if (cmdsn_ret == CMDSN_ERROR_CANNOT_RECOVER)
+			return iscsit_add_reject_from_cmd(
+					ISCSI_REASON_PROTOCOL_ERROR,
+					1, 0, buf, cmd);
+
+		return 0;
+	}
+
+	if (hdr->ttt != 0xFFFFFFFF) {
+		/*
+		 * This was a response to a unsolicited NOPIN ping.
+		 */
+		cmd = iscsit_find_cmd_from_ttt(conn, hdr->ttt);
+		if (!cmd)
+			return -1;
+
+		iscsit_stop_nopin_response_timer(conn);
+
+		cmd->i_state = ISTATE_REMOVE;
+		iscsit_add_cmd_to_immediate_queue(cmd, conn, cmd->i_state);
+		iscsit_start_nopin_timer(conn);
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
+		ret = 0;
+		goto out;
+	}
+
+	return 0;
+out:
+	if (cmd)
+		iscsit_release_cmd(cmd);
+ping_out:
+	kfree(ping_data);
+	return ret;
+}
+
+static int iscsit_handle_task_mgt_cmd(
+	struct iscsi_conn *conn,
+	unsigned char *buf)
+{
+	struct iscsi_cmd *cmd;
+	struct se_tmr_req *se_tmr;
+	struct iscsi_tmr_req *tmr_req;
+	struct iscsi_tm *hdr;
+	u32 payload_length;
+	int out_of_order_cmdsn = 0;
+	int ret;
+	u8 function;
+
+	hdr			= (struct iscsi_tm *) buf;
+	payload_length		= ntoh24(hdr->dlength);
+	hdr->itt		= be32_to_cpu(hdr->itt);
+	hdr->rtt		= be32_to_cpu(hdr->rtt);
+	hdr->cmdsn		= be32_to_cpu(hdr->cmdsn);
+	hdr->exp_statsn		= be32_to_cpu(hdr->exp_statsn);
+	hdr->refcmdsn		= be32_to_cpu(hdr->refcmdsn);
+	hdr->exp_datasn		= be32_to_cpu(hdr->exp_datasn);
+	hdr->flags &= ~ISCSI_FLAG_CMD_FINAL;
+	function = hdr->flags;
+
+	pr_debug("Got Task Management Request ITT: 0x%08x, CmdSN:"
+		" 0x%08x, Function: 0x%02x, RefTaskTag: 0x%08x, RefCmdSN:"
+		" 0x%08x, CID: %hu\n", hdr->itt, hdr->cmdsn, function,
+		hdr->rtt, hdr->refcmdsn, conn->cid);
+
+	if ((function != ISCSI_TM_FUNC_ABORT_TASK) &&
+	    ((function != ISCSI_TM_FUNC_TASK_REASSIGN) &&
+	     (hdr->rtt != ISCSI_RESERVED_TAG))) {
+		pr_err("RefTaskTag should be set to 0xFFFFFFFF.\n");
+		hdr->rtt = ISCSI_RESERVED_TAG;
+	}
+
+	if ((function == ISCSI_TM_FUNC_TASK_REASSIGN) &&
+			!(hdr->opcode & ISCSI_OP_IMMEDIATE)) {
+		pr_err("Task Management Request TASK_REASSIGN not"
+			" issued as immediate command, bad iSCSI Initiator"
+				"implementation\n");
+		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+					buf, conn);
+	}
+	if ((function != ISCSI_TM_FUNC_ABORT_TASK) &&
+	    (hdr->refcmdsn != ISCSI_RESERVED_TAG))
+		hdr->refcmdsn = ISCSI_RESERVED_TAG;
+
+	cmd = iscsit_allocate_se_cmd_for_tmr(conn, function);
+	if (!cmd)
+		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+					1, buf, conn);
+
+	cmd->iscsi_opcode	= ISCSI_OP_SCSI_TMFUNC;
+	cmd->i_state		= ISTATE_SEND_TASKMGTRSP;
+	cmd->immediate_cmd	= ((hdr->opcode & ISCSI_OP_IMMEDIATE) ? 1 : 0);
+	cmd->init_task_tag	= hdr->itt;
+	cmd->targ_xfer_tag	= 0xFFFFFFFF;
+	cmd->cmd_sn		= hdr->cmdsn;
+	cmd->exp_stat_sn	= hdr->exp_statsn;
+	se_tmr			= cmd->se_cmd.se_tmr_req;
+	tmr_req			= cmd->tmr_req;
+	/*
+	 * Locate the struct se_lun for all TMRs not related to ERL=2 TASK_REASSIGN
+	 */
+	if (function != ISCSI_TM_FUNC_TASK_REASSIGN) {
+		ret = iscsit_get_lun_for_tmr(cmd,
+				get_unaligned_le64(&hdr->lun[0]));
+		if (ret < 0) {
+			cmd->se_cmd.se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
+			se_tmr->response = ISCSI_TMF_RSP_NO_LUN;
+			goto attach;
+		}
+	}
+
+	switch (function) {
+	case ISCSI_TM_FUNC_ABORT_TASK:
+		se_tmr->response = iscsit_tmr_abort_task(cmd, buf);
+		if (se_tmr->response != ISCSI_TMF_RSP_COMPLETE) {
+			cmd->se_cmd.se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
+			goto attach;
+		}
+		break;
+	case ISCSI_TM_FUNC_ABORT_TASK_SET:
+	case ISCSI_TM_FUNC_CLEAR_ACA:
+	case ISCSI_TM_FUNC_CLEAR_TASK_SET:
+	case ISCSI_TM_FUNC_LOGICAL_UNIT_RESET:
+		break;
+	case ISCSI_TM_FUNC_TARGET_WARM_RESET:
+		if (iscsit_tmr_task_warm_reset(conn, tmr_req, buf) < 0) {
+			cmd->se_cmd.se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
+			se_tmr->response = ISCSI_TMF_RSP_AUTH_FAILED;
+			goto attach;
+		}
+		break;
+	case ISCSI_TM_FUNC_TARGET_COLD_RESET:
+		if (iscsit_tmr_task_cold_reset(conn, tmr_req, buf) < 0) {
+			cmd->se_cmd.se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
+			se_tmr->response = ISCSI_TMF_RSP_AUTH_FAILED;
+			goto attach;
+		}
+		break;
+	case ISCSI_TM_FUNC_TASK_REASSIGN:
+		se_tmr->response = iscsit_tmr_task_reassign(cmd, buf);
+		/*
+		 * Perform sanity checks on the ExpDataSN only if the
+		 * TASK_REASSIGN was successful.
+		 */
+		if (se_tmr->response != ISCSI_TMF_RSP_COMPLETE)
+			break;
+
+		if (iscsit_check_task_reassign_expdatasn(tmr_req, conn) < 0)
+			return iscsit_add_reject_from_cmd(
+					ISCSI_REASON_BOOKMARK_INVALID, 1, 1,
+					buf, cmd);
+		break;
+	default:
+		pr_err("Unknown TMR function: 0x%02x, protocol"
+			" error.\n", function);
+		cmd->se_cmd.se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
+		se_tmr->response = ISCSI_TMF_RSP_NOT_SUPPORTED;
+		goto attach;
+	}
+
+	if ((function != ISCSI_TM_FUNC_TASK_REASSIGN) &&
+	    (se_tmr->response == ISCSI_TMF_RSP_COMPLETE))
+		se_tmr->call_transport = 1;
+attach:
+	spin_lock_bh(&conn->cmd_lock);
+	list_add_tail(&cmd->i_list, &conn->conn_cmd_list);
+	spin_unlock_bh(&conn->cmd_lock);
+
+	if (!(hdr->opcode & ISCSI_OP_IMMEDIATE)) {
+		int cmdsn_ret = iscsit_sequence_cmd(conn, cmd, hdr->cmdsn);
+		if (cmdsn_ret == CMDSN_HIGHER_THAN_EXP)
+			out_of_order_cmdsn = 1;
+		else if (cmdsn_ret == CMDSN_LOWER_THAN_EXP) {
+			return 0;
+		} else { /* (cmdsn_ret == CMDSN_ERROR_CANNOT_RECOVER) */
+			return iscsit_add_reject_from_cmd(
+					ISCSI_REASON_PROTOCOL_ERROR,
+					1, 0, buf, cmd);
+		}
+	}
+	iscsit_ack_from_expstatsn(conn, hdr->exp_statsn);
+
+	if (out_of_order_cmdsn)
+		return 0;
+	/*
+	 * Found the referenced task, send to transport for processing.
+	 */
+	if (se_tmr->call_transport)
+		return transport_generic_handle_tmr(&cmd->se_cmd);
+
+	/*
+	 * Could not find the referenced LUN, task, or Task Management
+	 * command not authorized or supported.  Change state and
+	 * let the tx_thread send the response.
+	 *
+	 * For connection recovery, this is also the default action for
+	 * TMR TASK_REASSIGN.
+	 */
+	iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
+	return 0;
+}
+
+/* #warning FIXME: Support Text Command parameters besides SendTargets */
+static int iscsit_handle_text_cmd(
+	struct iscsi_conn *conn,
+	unsigned char *buf)
+{
+	char *text_ptr, *text_in;
+	int cmdsn_ret, niov = 0, rx_got, rx_size;
+	u32 checksum = 0, data_crc = 0, payload_length;
+	u32 padding = 0, text_length = 0;
+	struct iscsi_cmd *cmd;
+	struct kvec iov[3];
+	struct iscsi_text *hdr;
+
+	hdr			= (struct iscsi_text *) buf;
+	payload_length		= ntoh24(hdr->dlength);
+	hdr->itt		= be32_to_cpu(hdr->itt);
+	hdr->ttt		= be32_to_cpu(hdr->ttt);
+	hdr->cmdsn		= be32_to_cpu(hdr->cmdsn);
+	hdr->exp_statsn		= be32_to_cpu(hdr->exp_statsn);
+
+	if (payload_length > conn->conn_ops->MaxRecvDataSegmentLength) {
+		pr_err("Unable to accept text parameter length: %u"
+			"greater than MaxRecvDataSegmentLength %u.\n",
+		       payload_length, conn->conn_ops->MaxRecvDataSegmentLength);
+		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+					buf, conn);
+	}
+
+	pr_debug("Got Text Request: ITT: 0x%08x, CmdSN: 0x%08x,"
+		" ExpStatSN: 0x%08x, Length: %u\n", hdr->itt, hdr->cmdsn,
+		hdr->exp_statsn, payload_length);
+
+	rx_size = text_length = payload_length;
+	if (text_length) {
+		text_in = kzalloc(text_length, GFP_KERNEL);
+		if (!text_in) {
+			pr_err("Unable to allocate memory for"
+				" incoming text parameters\n");
+			return -1;
+		}
+
+		memset(iov, 0, 3 * sizeof(struct kvec));
+		iov[niov].iov_base	= text_in;
+		iov[niov++].iov_len	= text_length;
+
+		padding = ((-payload_length) & 3);
+		if (padding != 0) {
+			iov[niov].iov_base = cmd->pad_bytes;
+			iov[niov++].iov_len  = padding;
+			rx_size += padding;
+			pr_debug("Receiving %u additional bytes"
+					" for padding.\n", padding);
+		}
+		if (conn->conn_ops->DataDigest) {
+			iov[niov].iov_base	= &checksum;
+			iov[niov++].iov_len	= ISCSI_CRC_LEN;
+			rx_size += ISCSI_CRC_LEN;
+		}
+
+		rx_got = rx_data(conn, &iov[0], niov, rx_size);
+		if (rx_got != rx_size) {
+			kfree(text_in);
+			return -1;
+		}
+
+		if (conn->conn_ops->DataDigest) {
+			iscsit_do_crypto_hash_buf(&conn->conn_rx_hash,
+					text_in, text_length,
+					padding, cmd->pad_bytes,
+					(u8 *)&data_crc);
+
+			if (checksum != data_crc) {
+				pr_err("Text data CRC32C DataDigest"
+					" 0x%08x does not match computed"
+					" 0x%08x\n", checksum, data_crc);
+				if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
+					pr_err("Unable to recover from"
+					" Text Data digest failure while in"
+						" ERL=0.\n");
+					kfree(text_in);
+					return -1;
+				} else {
+					/*
+					 * Silently drop this PDU and let the
+					 * initiator plug the CmdSN gap.
+					 */
+					pr_debug("Dropping Text"
+					" Command CmdSN: 0x%08x due to"
+					" DataCRC error.\n", hdr->cmdsn);
+					kfree(text_in);
+					return 0;
+				}
+			} else {
+				pr_debug("Got CRC32C DataDigest"
+					" 0x%08x for %u bytes of text data.\n",
+						checksum, text_length);
+			}
+		}
+		text_in[text_length - 1] = '\0';
+		pr_debug("Successfully read %d bytes of text"
+				" data.\n", text_length);
+
+		if (strncmp("SendTargets", text_in, 11) != 0) {
+			pr_err("Received Text Data that is not"
+				" SendTargets, cannot continue.\n");
+			kfree(text_in);
+			return -1;
+		}
+		text_ptr = strchr(text_in, '=');
+		if (!text_ptr) {
+			pr_err("No \"=\" separator found in Text Data,"
+				"  cannot continue.\n");
+			kfree(text_in);
+			return -1;
+		}
+		if (strncmp("=All", text_ptr, 4) != 0) {
+			pr_err("Unable to locate All value for"
+				" SendTargets key,  cannot continue.\n");
+			kfree(text_in);
+			return -1;
+		}
+/*#warning Support SendTargets=(iSCSI Target Name/Nothing) values. */
+		kfree(text_in);
+	}
+
+	cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
+	if (!cmd)
+		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+					1, buf, conn);
+
+	cmd->iscsi_opcode	= ISCSI_OP_TEXT;
+	cmd->i_state		= ISTATE_SEND_TEXTRSP;
+	cmd->immediate_cmd	= ((hdr->opcode & ISCSI_OP_IMMEDIATE) ? 1 : 0);
+	conn->sess->init_task_tag = cmd->init_task_tag	= hdr->itt;
+	cmd->targ_xfer_tag	= 0xFFFFFFFF;
+	cmd->cmd_sn		= hdr->cmdsn;
+	cmd->exp_stat_sn	= hdr->exp_statsn;
+	cmd->data_direction	= DMA_NONE;
+
+	spin_lock_bh(&conn->cmd_lock);
+	list_add_tail(&cmd->i_list, &conn->conn_cmd_list);
+	spin_unlock_bh(&conn->cmd_lock);
+
+	iscsit_ack_from_expstatsn(conn, hdr->exp_statsn);
+
+	if (!(hdr->opcode & ISCSI_OP_IMMEDIATE)) {
+		cmdsn_ret = iscsit_sequence_cmd(conn, cmd, hdr->cmdsn);
+		if (cmdsn_ret == CMDSN_ERROR_CANNOT_RECOVER)
+			return iscsit_add_reject_from_cmd(
+					ISCSI_REASON_PROTOCOL_ERROR,
+					1, 0, buf, cmd);
+
+		return 0;
+	}
+
+	return iscsit_execute_cmd(cmd, 0);
+}
+
+int iscsit_logout_closesession(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
+{
+	struct iscsi_conn *conn_p;
+	struct iscsi_session *sess = conn->sess;
+
+	pr_debug("Received logout request CLOSESESSION on CID: %hu"
+		" for SID: %u.\n", conn->cid, conn->sess->sid);
+
+	atomic_set(&sess->session_logout, 1);
+	atomic_set(&conn->conn_logout_remove, 1);
+	conn->conn_logout_reason = ISCSI_LOGOUT_REASON_CLOSE_SESSION;
+
+	iscsit_inc_conn_usage_count(conn);
+	iscsit_inc_session_usage_count(sess);
+
+	spin_lock_bh(&sess->conn_lock);
+	list_for_each_entry(conn_p, &sess->sess_conn_list, conn_list) {
+		if (conn_p->conn_state != TARG_CONN_STATE_LOGGED_IN)
+			continue;
+
+		pr_debug("Moving to TARG_CONN_STATE_IN_LOGOUT.\n");
+		conn_p->conn_state = TARG_CONN_STATE_IN_LOGOUT;
+	}
+	spin_unlock_bh(&sess->conn_lock);
+
+	iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
+
+	return 0;
+}
+
+int iscsit_logout_closeconnection(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
+{
+	struct iscsi_conn *l_conn;
+	struct iscsi_session *sess = conn->sess;
+
+	pr_debug("Received logout request CLOSECONNECTION for CID:"
+		" %hu on CID: %hu.\n", cmd->logout_cid, conn->cid);
+
+	/*
+	 * A Logout Request with a CLOSECONNECTION reason code for a CID
+	 * can arrive on a connection with a differing CID.
+	 */
+	if (conn->cid == cmd->logout_cid) {
+		spin_lock_bh(&conn->state_lock);
+		pr_debug("Moving to TARG_CONN_STATE_IN_LOGOUT.\n");
+		conn->conn_state = TARG_CONN_STATE_IN_LOGOUT;
+
+		atomic_set(&conn->conn_logout_remove, 1);
+		conn->conn_logout_reason = ISCSI_LOGOUT_REASON_CLOSE_CONNECTION;
+		iscsit_inc_conn_usage_count(conn);
+
+		spin_unlock_bh(&conn->state_lock);
+	} else {
+		/*
+		 * Handle all different cid CLOSECONNECTION requests in
+		 * iscsit_logout_post_handler_diffcid() as to give enough
+		 * time for any non immediate command's CmdSN to be
+		 * acknowledged on the connection in question.
+		 *
+		 * Here we simply make sure the CID is still around.
+		 */
+		l_conn = iscsit_get_conn_from_cid(sess,
+				cmd->logout_cid);
+		if (!l_conn) {
+			cmd->logout_response = ISCSI_LOGOUT_CID_NOT_FOUND;
+			iscsit_add_cmd_to_response_queue(cmd, conn,
+					cmd->i_state);
+			return 0;
+		}
+
+		iscsit_dec_conn_usage_count(l_conn);
+	}
+
+	iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
+
+	return 0;
+}
+
+int iscsit_logout_removeconnforrecovery(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
+{
+	struct iscsi_session *sess = conn->sess;
+
+	pr_debug("Received explicit REMOVECONNFORRECOVERY logout for"
+		" CID: %hu on CID: %hu.\n", cmd->logout_cid, conn->cid);
+
+	if (sess->sess_ops->ErrorRecoveryLevel != 2) {
+		pr_err("Received Logout Request REMOVECONNFORRECOVERY"
+			" while ERL!=2.\n");
+		cmd->logout_response = ISCSI_LOGOUT_RECOVERY_UNSUPPORTED;
+		iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
+		return 0;
+	}
+
+	if (conn->cid == cmd->logout_cid) {
+		pr_err("Received Logout Request REMOVECONNFORRECOVERY"
+			" with CID: %hu on CID: %hu, implementation error.\n",
+				cmd->logout_cid, conn->cid);
+		cmd->logout_response = ISCSI_LOGOUT_CLEANUP_FAILED;
+		iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
+		return 0;
+	}
+
+	iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
+
+	return 0;
+}
+
+static int iscsit_handle_logout_cmd(
+	struct iscsi_conn *conn,
+	unsigned char *buf)
+{
+	int cmdsn_ret, logout_remove = 0;
+	u8 reason_code = 0;
+	struct iscsi_cmd *cmd;
+	struct iscsi_logout *hdr;
+	struct iscsi_tiqn *tiqn = iscsit_snmp_get_tiqn(conn);
+
+	hdr			= (struct iscsi_logout *) buf;
+	reason_code		= (hdr->flags & 0x7f);
+	hdr->itt		= be32_to_cpu(hdr->itt);
+	hdr->cid		= be16_to_cpu(hdr->cid);
+	hdr->cmdsn		= be32_to_cpu(hdr->cmdsn);
+	hdr->exp_statsn	= be32_to_cpu(hdr->exp_statsn);
+
+	if (tiqn) {
+		spin_lock(&tiqn->logout_stats.lock);
+		if (reason_code == ISCSI_LOGOUT_REASON_CLOSE_SESSION)
+			tiqn->logout_stats.normal_logouts++;
+		else
+			tiqn->logout_stats.abnormal_logouts++;
+		spin_unlock(&tiqn->logout_stats.lock);
+	}
+
+	pr_debug("Got Logout Request ITT: 0x%08x CmdSN: 0x%08x"
+		" ExpStatSN: 0x%08x Reason: 0x%02x CID: %hu on CID: %hu\n",
+		hdr->itt, hdr->cmdsn, hdr->exp_statsn, reason_code,
+		hdr->cid, conn->cid);
+
+	if (conn->conn_state != TARG_CONN_STATE_LOGGED_IN) {
+		pr_err("Received logout request on connection that"
+			" is not in logged in state, ignoring request.\n");
+		return 0;
+	}
+
+	cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
+	if (!cmd)
+		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_NO_RESOURCES, 1,
+					buf, conn);
+
+	cmd->iscsi_opcode       = ISCSI_OP_LOGOUT;
+	cmd->i_state            = ISTATE_SEND_LOGOUTRSP;
+	cmd->immediate_cmd      = ((hdr->opcode & ISCSI_OP_IMMEDIATE) ? 1 : 0);
+	conn->sess->init_task_tag = cmd->init_task_tag  = hdr->itt;
+	cmd->targ_xfer_tag      = 0xFFFFFFFF;
+	cmd->cmd_sn             = hdr->cmdsn;
+	cmd->exp_stat_sn        = hdr->exp_statsn;
+	cmd->logout_cid         = hdr->cid;
+	cmd->logout_reason      = reason_code;
+	cmd->data_direction     = DMA_NONE;
+
+	/*
+	 * We need to sleep in these cases (by returning 1) until the Logout
+	 * Response gets sent in the tx thread.
+	 */
+	if ((reason_code == ISCSI_LOGOUT_REASON_CLOSE_SESSION) ||
+	   ((reason_code == ISCSI_LOGOUT_REASON_CLOSE_CONNECTION) &&
+	    (hdr->cid == conn->cid)))
+		logout_remove = 1;
+
+	spin_lock_bh(&conn->cmd_lock);
+	list_add_tail(&cmd->i_list, &conn->conn_cmd_list);
+	spin_unlock_bh(&conn->cmd_lock);
+
+	if (reason_code != ISCSI_LOGOUT_REASON_RECOVERY)
+		iscsit_ack_from_expstatsn(conn, hdr->exp_statsn);
+
+	/*
+	 * Immediate commands are executed, well, immediately.
+	 * Non-Immediate Logout Commands are executed in CmdSN order.
+	 */
+	if (hdr->opcode & ISCSI_OP_IMMEDIATE) {
+		int ret = iscsit_execute_cmd(cmd, 0);
+
+		if (ret < 0)
+			return ret;
+	} else {
+		cmdsn_ret = iscsit_sequence_cmd(conn, cmd, hdr->cmdsn);
+		if (cmdsn_ret == CMDSN_LOWER_THAN_EXP) {
+			logout_remove = 0;
+		} else if (cmdsn_ret == CMDSN_ERROR_CANNOT_RECOVER) {
+			return iscsit_add_reject_from_cmd(
+				ISCSI_REASON_PROTOCOL_ERROR,
+				1, 0, buf, cmd);
+		}
+	}
+
+	return logout_remove;
+}
+
+static int iscsit_handle_snack(
+	struct iscsi_conn *conn,
+	unsigned char *buf)
+{
+	u32 unpacked_lun;
+	u64 lun;
+	struct iscsi_snack *hdr;
+
+	hdr			= (struct iscsi_snack *) buf;
+	hdr->flags		&= ~ISCSI_FLAG_CMD_FINAL;
+	lun			= get_unaligned_le64(&hdr->lun[0]);
+	unpacked_lun		= scsilun_to_int((struct scsi_lun *)&lun);
+	hdr->itt		= be32_to_cpu(hdr->itt);
+	hdr->ttt		= be32_to_cpu(hdr->ttt);
+	hdr->exp_statsn		= be32_to_cpu(hdr->exp_statsn);
+	hdr->begrun		= be32_to_cpu(hdr->begrun);
+	hdr->runlength		= be32_to_cpu(hdr->runlength);
+
+	pr_debug("Got ISCSI_INIT_SNACK, ITT: 0x%08x, ExpStatSN:"
+		" 0x%08x, Type: 0x%02x, BegRun: 0x%08x, RunLength: 0x%08x,"
+		" CID: %hu\n", hdr->itt, hdr->exp_statsn, hdr->flags,
+			hdr->begrun, hdr->runlength, conn->cid);
+
+	if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
+		pr_err("Initiator sent SNACK request while in"
+			" ErrorRecoveryLevel=0.\n");
+		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+					buf, conn);
+	}
+	/*
+	 * SNACK_DATA and SNACK_R2T are both 0,  so check which function to
+	 * call from inside iscsi_send_recovery_datain_or_r2t().
+	 */
+	switch (hdr->flags & ISCSI_FLAG_SNACK_TYPE_MASK) {
+	case 0:
+		return iscsit_handle_recovery_datain_or_r2t(conn, buf,
+			hdr->itt, hdr->ttt, hdr->begrun, hdr->runlength);
+		return 0;
+	case ISCSI_FLAG_SNACK_TYPE_STATUS:
+		return iscsit_handle_status_snack(conn, hdr->itt, hdr->ttt,
+			hdr->begrun, hdr->runlength);
+	case ISCSI_FLAG_SNACK_TYPE_DATA_ACK:
+		return iscsit_handle_data_ack(conn, hdr->ttt, hdr->begrun,
+			hdr->runlength);
+	case ISCSI_FLAG_SNACK_TYPE_RDATA:
+		/* FIXME: Support R-Data SNACK */
+		pr_err("R-Data SNACK Not Supported.\n");
+		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+					buf, conn);
+	default:
+		pr_err("Unknown SNACK type 0x%02x, protocol"
+			" error.\n", hdr->flags & 0x0f);
+		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+					buf, conn);
+	}
+
+	return 0;
+}
+
+static void iscsit_rx_thread_wait_for_tcp(struct iscsi_conn *conn)
+{
+	if ((conn->sock->sk->sk_shutdown & SEND_SHUTDOWN) ||
+	    (conn->sock->sk->sk_shutdown & RCV_SHUTDOWN)) {
+		wait_for_completion_interruptible_timeout(
+					&conn->rx_half_close_comp,
+					ISCSI_RX_THREAD_TCP_TIMEOUT * HZ);
+	}
+}
+
+static int iscsit_handle_immediate_data(
+	struct iscsi_cmd *cmd,
+	unsigned char *buf,
+	u32 length)
+{
+	int iov_ret, rx_got = 0, rx_size = 0;
+	u32 checksum, iov_count = 0, padding = 0;
+	struct iscsi_conn *conn = cmd->conn;
+	struct kvec *iov;
+
+	iov_ret = iscsit_map_iovec(cmd, cmd->iov_data, cmd->write_data_done, length);
+	if (iov_ret < 0)
+		return IMMEDIATE_DATA_CANNOT_RECOVER;
+
+	rx_size = length;
+	iov_count = iov_ret;
+	iov = &cmd->iov_data[0];
+
+	padding = ((-length) & 3);
+	if (padding != 0) {
+		iov[iov_count].iov_base	= cmd->pad_bytes;
+		iov[iov_count++].iov_len = padding;
+		rx_size += padding;
+	}
+
+	if (conn->conn_ops->DataDigest) {
+		iov[iov_count].iov_base		= &checksum;
+		iov[iov_count++].iov_len	= ISCSI_CRC_LEN;
+		rx_size += ISCSI_CRC_LEN;
+	}
+
+	rx_got = rx_data(conn, &cmd->iov_data[0], iov_count, rx_size);
+
+	iscsit_unmap_iovec(cmd);
+
+	if (rx_got != rx_size) {
+		iscsit_rx_thread_wait_for_tcp(conn);
+		return IMMEDIATE_DATA_CANNOT_RECOVER;
+	}
+
+	if (conn->conn_ops->DataDigest) {
+		u32 data_crc;
+
+		data_crc = iscsit_do_crypto_hash_sg(&conn->conn_rx_hash, cmd,
+						    cmd->write_data_done, length, padding,
+						    cmd->pad_bytes);
+
+		if (checksum != data_crc) {
+			pr_err("ImmediateData CRC32C DataDigest 0x%08x"
+				" does not match computed 0x%08x\n", checksum,
+				data_crc);
+
+			if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
+				pr_err("Unable to recover from"
+					" Immediate Data digest failure while"
+					" in ERL=0.\n");
+				iscsit_add_reject_from_cmd(
+						ISCSI_REASON_DATA_DIGEST_ERROR,
+						1, 0, buf, cmd);
+				return IMMEDIATE_DATA_CANNOT_RECOVER;
+			} else {
+				iscsit_add_reject_from_cmd(
+						ISCSI_REASON_DATA_DIGEST_ERROR,
+						0, 0, buf, cmd);
+				return IMMEDIATE_DATA_ERL1_CRC_FAILURE;
+			}
+		} else {
+			pr_debug("Got CRC32C DataDigest 0x%08x for"
+				" %u bytes of Immediate Data\n", checksum,
+				length);
+		}
+	}
+
+	cmd->write_data_done += length;
+
+	if (cmd->write_data_done == cmd->data_length) {
+		spin_lock_bh(&cmd->istate_lock);
+		cmd->cmd_flags |= ICF_GOT_LAST_DATAOUT;
+		cmd->i_state = ISTATE_RECEIVED_LAST_DATAOUT;
+		spin_unlock_bh(&cmd->istate_lock);
+	}
+
+	return IMMEDIATE_DATA_NORMAL_OPERATION;
+}
+
+/*
+ *	Called with sess->conn_lock held.
+ */
+/* #warning iscsi_build_conn_drop_async_message() only sends out on connections
+	with active network interface */
+static void iscsit_build_conn_drop_async_message(struct iscsi_conn *conn)
+{
+	struct iscsi_cmd *cmd;
+	struct iscsi_conn *conn_p;
+
+	/*
+	 * Only send a Asynchronous Message on connections whos network
+	 * interface is still functional.
+	 */
+	list_for_each_entry(conn_p, &conn->sess->sess_conn_list, conn_list) {
+		if (conn_p->conn_state == TARG_CONN_STATE_LOGGED_IN) {
+			iscsit_inc_conn_usage_count(conn_p);
+			break;
+		}
+	}
+
+	if (!conn_p)
+		return;
+
+	cmd = iscsit_allocate_cmd(conn_p, GFP_KERNEL);
+	if (!cmd) {
+		iscsit_dec_conn_usage_count(conn_p);
+		return;
+	}
+
+	cmd->logout_cid = conn->cid;
+	cmd->iscsi_opcode = ISCSI_OP_ASYNC_EVENT;
+	cmd->i_state = ISTATE_SEND_ASYNCMSG;
+
+	spin_lock_bh(&conn_p->cmd_lock);
+	list_add_tail(&cmd->i_list, &conn_p->conn_cmd_list);
+	spin_unlock_bh(&conn_p->cmd_lock);
+
+	iscsit_add_cmd_to_response_queue(cmd, conn_p, cmd->i_state);
+	iscsit_dec_conn_usage_count(conn_p);
+}
+
+static int iscsit_send_conn_drop_async_message(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	struct iscsi_async *hdr;
+
+	cmd->tx_size = ISCSI_HDR_LEN;
+	cmd->iscsi_opcode = ISCSI_OP_ASYNC_EVENT;
+
+	hdr			= (struct iscsi_async *) cmd->pdu;
+	hdr->opcode		= ISCSI_OP_ASYNC_EVENT;
+	hdr->flags		= ISCSI_FLAG_CMD_FINAL;
+	cmd->init_task_tag	= 0xFFFFFFFF;
+	cmd->targ_xfer_tag	= 0xFFFFFFFF;
+	put_unaligned_be64(0xffffffffffffffff, &hdr->rsvd4[0]);
+	cmd->stat_sn		= conn->stat_sn++;
+	hdr->statsn		= cpu_to_be32(cmd->stat_sn);
+	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
+	hdr->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
+	hdr->async_event	= ISCSI_ASYNC_MSG_DROPPING_CONNECTION;
+	hdr->param1		= cpu_to_be16(cmd->logout_cid);
+	hdr->param2		= cpu_to_be16(conn->sess->sess_ops->DefaultTime2Wait);
+	hdr->param3		= cpu_to_be16(conn->sess->sess_ops->DefaultTime2Retain);
+
+	if (conn->conn_ops->HeaderDigest) {
+		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				(unsigned char *)hdr, ISCSI_HDR_LEN,
+				0, NULL, (u8 *)header_digest);
+
+		cmd->tx_size += ISCSI_CRC_LEN;
+		pr_debug("Attaching CRC32C HeaderDigest to"
+			" Async Message 0x%08x\n", *header_digest);
+	}
+
+	cmd->iov_misc[0].iov_base	= cmd->pdu;
+	cmd->iov_misc[0].iov_len	= cmd->tx_size;
+	cmd->iov_misc_count		= 1;
+
+	pr_debug("Sending Connection Dropped Async Message StatSN:"
+		" 0x%08x, for CID: %hu on CID: %hu\n", cmd->stat_sn,
+			cmd->logout_cid, conn->cid);
+	return 0;
+}
+
+static int iscsit_send_data_in(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn,
+	int *eodr)
+{
+	int iov_ret = 0, set_statsn = 0;
+	u32 iov_count = 0, tx_size = 0;
+	struct iscsi_datain datain;
+	struct iscsi_datain_req *dr;
+	struct iscsi_data_rsp *hdr;
+	struct kvec *iov;
+
+	memset(&datain, 0, sizeof(struct iscsi_datain));
+	dr = iscsit_get_datain_values(cmd, &datain);
+	if (!dr) {
+		pr_err("iscsit_get_datain_values failed for ITT: 0x%08x\n",
+				cmd->init_task_tag);
+		return -1;
+	}
+
+	/*
+	 * Be paranoid and double check the logic for now.
+	 */
+	if ((datain.offset + datain.length) > cmd->data_length) {
+		pr_err("Command ITT: 0x%08x, datain.offset: %u and"
+			" datain.length: %u exceeds cmd->data_length: %u\n",
+			cmd->init_task_tag, datain.offset, datain.length,
+				cmd->data_length);
+		return -1;
+	}
+
+	spin_lock_bh(&conn->sess->session_stats_lock);
+	conn->sess->tx_data_octets += datain.length;
+	if (conn->sess->se_sess->se_node_acl) {
+		spin_lock(&conn->sess->se_sess->se_node_acl->stats_lock);
+		conn->sess->se_sess->se_node_acl->read_bytes += datain.length;
+		spin_unlock(&conn->sess->se_sess->se_node_acl->stats_lock);
+	}
+	spin_unlock_bh(&conn->sess->session_stats_lock);
+	/*
+	 * Special case for successfully execution w/ both DATAIN
+	 * and Sense Data.
+	 */
+	if ((datain.flags & ISCSI_FLAG_DATA_STATUS) &&
+	    (cmd->se_cmd.se_cmd_flags & SCF_TRANSPORT_TASK_SENSE))
+		datain.flags &= ~ISCSI_FLAG_DATA_STATUS;
+	else {
+		if ((dr->dr_complete == DATAIN_COMPLETE_NORMAL) ||
+		    (dr->dr_complete == DATAIN_COMPLETE_CONNECTION_RECOVERY)) {
+			iscsit_increment_maxcmdsn(cmd, conn->sess);
+			cmd->stat_sn = conn->stat_sn++;
+			set_statsn = 1;
+		} else if (dr->dr_complete ==
+				DATAIN_COMPLETE_WITHIN_COMMAND_RECOVERY)
+			set_statsn = 1;
+	}
+
+	hdr	= (struct iscsi_data_rsp *) cmd->pdu;
+	memset(hdr, 0, ISCSI_HDR_LEN);
+	hdr->opcode		= ISCSI_OP_SCSI_DATA_IN;
+	hdr->flags		= datain.flags;
+	if (hdr->flags & ISCSI_FLAG_DATA_STATUS) {
+		if (cmd->se_cmd.se_cmd_flags & SCF_OVERFLOW_BIT) {
+			hdr->flags |= ISCSI_FLAG_DATA_OVERFLOW;
+			hdr->residual_count = cpu_to_be32(cmd->residual_count);
+		} else if (cmd->se_cmd.se_cmd_flags & SCF_UNDERFLOW_BIT) {
+			hdr->flags |= ISCSI_FLAG_DATA_UNDERFLOW;
+			hdr->residual_count = cpu_to_be32(cmd->residual_count);
+		}
+	}
+	hton24(hdr->dlength, datain.length);
+	if (hdr->flags & ISCSI_FLAG_DATA_ACK)
+		int_to_scsilun(cmd->se_cmd.orig_fe_lun,
+				(struct scsi_lun *)&hdr->lun[0]);
+	else
+		put_unaligned_le64(0xFFFFFFFFFFFFFFFFULL, &hdr->lun[0]);
+
+	hdr->itt		= cpu_to_be32(cmd->init_task_tag);
+	hdr->ttt		= (hdr->flags & ISCSI_FLAG_DATA_ACK) ?
+				   cpu_to_be32(cmd->targ_xfer_tag) :
+				   0xFFFFFFFF;
+	hdr->statsn		= (set_statsn) ? cpu_to_be32(cmd->stat_sn) :
+						0xFFFFFFFF;
+	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
+	hdr->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
+	hdr->datasn		= cpu_to_be32(datain.data_sn);
+	hdr->offset		= cpu_to_be32(datain.offset);
+
+	iov = &cmd->iov_data[0];
+	iov[iov_count].iov_base	= cmd->pdu;
+	iov[iov_count++].iov_len	= ISCSI_HDR_LEN;
+	tx_size += ISCSI_HDR_LEN;
+
+	if (conn->conn_ops->HeaderDigest) {
+		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				(unsigned char *)hdr, ISCSI_HDR_LEN,
+				0, NULL, (u8 *)header_digest);
+
+		iov[0].iov_len += ISCSI_CRC_LEN;
+		tx_size += ISCSI_CRC_LEN;
+
+		pr_debug("Attaching CRC32 HeaderDigest"
+			" for DataIN PDU 0x%08x\n", *header_digest);
+	}
+
+	iov_ret = iscsit_map_iovec(cmd, &cmd->iov_data[1], datain.offset, datain.length);
+	if (iov_ret < 0)
+		return -1;
+
+	iov_count += iov_ret;
+	tx_size += datain.length;
+
+	cmd->padding = ((-datain.length) & 3);
+	if (cmd->padding) {
+		iov[iov_count].iov_base		= cmd->pad_bytes;
+		iov[iov_count++].iov_len	= cmd->padding;
+		tx_size += cmd->padding;
+
+		pr_debug("Attaching %u padding bytes\n",
+				cmd->padding);
+	}
+	if (conn->conn_ops->DataDigest) {
+		cmd->data_crc = iscsit_do_crypto_hash_sg(&conn->conn_tx_hash, cmd,
+			 datain.offset, datain.length, cmd->padding, cmd->pad_bytes);
+
+		iov[iov_count].iov_base	= &cmd->data_crc;
+		iov[iov_count++].iov_len = ISCSI_CRC_LEN;
+		tx_size += ISCSI_CRC_LEN;
+
+		pr_debug("Attached CRC32C DataDigest %d bytes, crc"
+			" 0x%08x\n", datain.length+cmd->padding, cmd->data_crc);
+	}
+
+	cmd->iov_data_count = iov_count;
+	cmd->tx_size = tx_size;
+
+	pr_debug("Built DataIN ITT: 0x%08x, StatSN: 0x%08x,"
+		" DataSN: 0x%08x, Offset: %u, Length: %u, CID: %hu\n",
+		cmd->init_task_tag, ntohl(hdr->statsn), ntohl(hdr->datasn),
+		ntohl(hdr->offset), datain.length, conn->cid);
+
+	if (dr->dr_complete) {
+		*eodr = (cmd->se_cmd.se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) ?
+				2 : 1;
+		iscsit_free_datain_req(cmd, dr);
+	}
+
+	return 0;
+}
+
+static int iscsit_send_logout_response(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	int niov = 0, tx_size;
+	struct iscsi_conn *logout_conn = NULL;
+	struct iscsi_conn_recovery *cr = NULL;
+	struct iscsi_session *sess = conn->sess;
+	struct kvec *iov;
+	struct iscsi_logout_rsp *hdr;
+	/*
+	 * The actual shutting down of Sessions and/or Connections
+	 * for CLOSESESSION and CLOSECONNECTION Logout Requests
+	 * is done in scsi_logout_post_handler().
+	 */
+	switch (cmd->logout_reason) {
+	case ISCSI_LOGOUT_REASON_CLOSE_SESSION:
+		pr_debug("iSCSI session logout successful, setting"
+			" logout response to ISCSI_LOGOUT_SUCCESS.\n");
+		cmd->logout_response = ISCSI_LOGOUT_SUCCESS;
+		break;
+	case ISCSI_LOGOUT_REASON_CLOSE_CONNECTION:
+		if (cmd->logout_response == ISCSI_LOGOUT_CID_NOT_FOUND)
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
+		 * is stopped in iscsit_logout_post_handler_diffcid().
+		 */
+
+		pr_debug("iSCSI CID: %hu logout on CID: %hu"
+			" successful.\n", cmd->logout_cid, conn->cid);
+		cmd->logout_response = ISCSI_LOGOUT_SUCCESS;
+		break;
+	case ISCSI_LOGOUT_REASON_RECOVERY:
+		if ((cmd->logout_response == ISCSI_LOGOUT_RECOVERY_UNSUPPORTED) ||
+		    (cmd->logout_response == ISCSI_LOGOUT_CLEANUP_FAILED))
+			break;
+		/*
+		 * If the connection is still active from our point of view
+		 * force connection recovery to occur.
+		 */
+		logout_conn = iscsit_get_conn_from_cid_rcfr(sess,
+				cmd->logout_cid);
+		if ((logout_conn)) {
+			iscsit_connection_reinstatement_rcfr(logout_conn);
+			iscsit_dec_conn_usage_count(logout_conn);
+		}
+
+		cr = iscsit_get_inactive_connection_recovery_entry(
+				conn->sess, cmd->logout_cid);
+		if (!cr) {
+			pr_err("Unable to locate CID: %hu for"
+			" REMOVECONNFORRECOVERY Logout Request.\n",
+				cmd->logout_cid);
+			cmd->logout_response = ISCSI_LOGOUT_CID_NOT_FOUND;
+			break;
+		}
+
+		iscsit_discard_cr_cmds_by_expstatsn(cr, cmd->exp_stat_sn);
+
+		pr_debug("iSCSI REMOVECONNFORRECOVERY logout"
+			" for recovery for CID: %hu on CID: %hu successful.\n",
+				cmd->logout_cid, conn->cid);
+		cmd->logout_response = ISCSI_LOGOUT_SUCCESS;
+		break;
+	default:
+		pr_err("Unknown cmd->logout_reason: 0x%02x\n",
+				cmd->logout_reason);
+		return -1;
+	}
+
+	tx_size = ISCSI_HDR_LEN;
+	hdr			= (struct iscsi_logout_rsp *)cmd->pdu;
+	memset(hdr, 0, ISCSI_HDR_LEN);
+	hdr->opcode		= ISCSI_OP_LOGOUT_RSP;
+	hdr->flags		|= ISCSI_FLAG_CMD_FINAL;
+	hdr->response		= cmd->logout_response;
+	hdr->itt		= cpu_to_be32(cmd->init_task_tag);
+	cmd->stat_sn		= conn->stat_sn++;
+	hdr->statsn		= cpu_to_be32(cmd->stat_sn);
+
+	iscsit_increment_maxcmdsn(cmd, conn->sess);
+	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
+	hdr->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
+
+	iov = &cmd->iov_misc[0];
+	iov[niov].iov_base	= cmd->pdu;
+	iov[niov++].iov_len	= ISCSI_HDR_LEN;
+
+	if (conn->conn_ops->HeaderDigest) {
+		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				(unsigned char *)hdr, ISCSI_HDR_LEN,
+				0, NULL, (u8 *)header_digest);
+
+		iov[0].iov_len += ISCSI_CRC_LEN;
+		tx_size += ISCSI_CRC_LEN;
+		pr_debug("Attaching CRC32C HeaderDigest to"
+			" Logout Response 0x%08x\n", *header_digest);
+	}
+	cmd->iov_misc_count = niov;
+	cmd->tx_size = tx_size;
+
+	pr_debug("Sending Logout Response ITT: 0x%08x StatSN:"
+		" 0x%08x Response: 0x%02x CID: %hu on CID: %hu\n",
+		cmd->init_task_tag, cmd->stat_sn, hdr->response,
+		cmd->logout_cid, conn->cid);
+
+	return 0;
+}
+
+/*
+ *	Unsolicited NOPIN, either requesting a response or not.
+ */
+static int iscsit_send_unsolicited_nopin(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn,
+	int want_response)
+{
+	int tx_size = ISCSI_HDR_LEN;
+	struct iscsi_nopin *hdr;
+
+	hdr			= (struct iscsi_nopin *) cmd->pdu;
+	memset(hdr, 0, ISCSI_HDR_LEN);
+	hdr->opcode		= ISCSI_OP_NOOP_IN;
+	hdr->flags		|= ISCSI_FLAG_CMD_FINAL;
+	hdr->itt		= cpu_to_be32(cmd->init_task_tag);
+	hdr->ttt		= cpu_to_be32(cmd->targ_xfer_tag);
+	cmd->stat_sn		= conn->stat_sn;
+	hdr->statsn		= cpu_to_be32(cmd->stat_sn);
+	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
+	hdr->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
+
+	if (conn->conn_ops->HeaderDigest) {
+		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				(unsigned char *)hdr, ISCSI_HDR_LEN,
+				0, NULL, (u8 *)header_digest);
+
+		tx_size += ISCSI_CRC_LEN;
+		pr_debug("Attaching CRC32C HeaderDigest to"
+			" NopIN 0x%08x\n", *header_digest);
+	}
+
+	cmd->iov_misc[0].iov_base	= cmd->pdu;
+	cmd->iov_misc[0].iov_len	= tx_size;
+	cmd->iov_misc_count	= 1;
+	cmd->tx_size		= tx_size;
+
+	pr_debug("Sending Unsolicited NOPIN TTT: 0x%08x StatSN:"
+		" 0x%08x CID: %hu\n", hdr->ttt, cmd->stat_sn, conn->cid);
+
+	return 0;
+}
+
+static int iscsit_send_nopin_response(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	int niov = 0, tx_size;
+	u32 padding = 0;
+	struct kvec *iov;
+	struct iscsi_nopin *hdr;
+
+	tx_size = ISCSI_HDR_LEN;
+	hdr			= (struct iscsi_nopin *) cmd->pdu;
+	memset(hdr, 0, ISCSI_HDR_LEN);
+	hdr->opcode		= ISCSI_OP_NOOP_IN;
+	hdr->flags		|= ISCSI_FLAG_CMD_FINAL;
+	hton24(hdr->dlength, cmd->buf_ptr_size);
+	put_unaligned_le64(0xFFFFFFFFFFFFFFFFULL, &hdr->lun[0]);
+	hdr->itt		= cpu_to_be32(cmd->init_task_tag);
+	hdr->ttt		= cpu_to_be32(cmd->targ_xfer_tag);
+	cmd->stat_sn		= conn->stat_sn++;
+	hdr->statsn		= cpu_to_be32(cmd->stat_sn);
+
+	iscsit_increment_maxcmdsn(cmd, conn->sess);
+	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
+	hdr->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
+
+	iov = &cmd->iov_misc[0];
+	iov[niov].iov_base	= cmd->pdu;
+	iov[niov++].iov_len	= ISCSI_HDR_LEN;
+
+	if (conn->conn_ops->HeaderDigest) {
+		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				(unsigned char *)hdr, ISCSI_HDR_LEN,
+				0, NULL, (u8 *)header_digest);
+
+		iov[0].iov_len += ISCSI_CRC_LEN;
+		tx_size += ISCSI_CRC_LEN;
+		pr_debug("Attaching CRC32C HeaderDigest"
+			" to NopIn 0x%08x\n", *header_digest);
+	}
+
+	/*
+	 * NOPOUT Ping Data is attached to struct iscsi_cmd->buf_ptr.
+	 * NOPOUT DataSegmentLength is at struct iscsi_cmd->buf_ptr_size.
+	 */
+	if (cmd->buf_ptr_size) {
+		iov[niov].iov_base	= cmd->buf_ptr;
+		iov[niov++].iov_len	= cmd->buf_ptr_size;
+		tx_size += cmd->buf_ptr_size;
+
+		pr_debug("Echoing back %u bytes of ping"
+			" data.\n", cmd->buf_ptr_size);
+
+		padding = ((-cmd->buf_ptr_size) & 3);
+		if (padding != 0) {
+			iov[niov].iov_base = &cmd->pad_bytes;
+			iov[niov++].iov_len = padding;
+			tx_size += padding;
+			pr_debug("Attaching %u additional"
+				" padding bytes.\n", padding);
+		}
+		if (conn->conn_ops->DataDigest) {
+			iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				cmd->buf_ptr, cmd->buf_ptr_size,
+				padding, (u8 *)&cmd->pad_bytes,
+				(u8 *)&cmd->data_crc);
+
+			iov[niov].iov_base = &cmd->data_crc;
+			iov[niov++].iov_len = ISCSI_CRC_LEN;
+			tx_size += ISCSI_CRC_LEN;
+			pr_debug("Attached DataDigest for %u"
+				" bytes of ping data, CRC 0x%08x\n",
+				cmd->buf_ptr_size, cmd->data_crc);
+		}
+	}
+
+	cmd->iov_misc_count = niov;
+	cmd->tx_size = tx_size;
+
+	pr_debug("Sending NOPIN Response ITT: 0x%08x, TTT:"
+		" 0x%08x, StatSN: 0x%08x, Length %u\n", cmd->init_task_tag,
+		cmd->targ_xfer_tag, cmd->stat_sn, cmd->buf_ptr_size);
+
+	return 0;
+}
+
+int iscsit_send_r2t(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	int tx_size = 0;
+	struct iscsi_r2t *r2t;
+	struct iscsi_r2t_rsp *hdr;
+
+	r2t = iscsit_get_r2t_from_list(cmd);
+	if (!r2t)
+		return -1;
+
+	hdr			= (struct iscsi_r2t_rsp *) cmd->pdu;
+	memset(hdr, 0, ISCSI_HDR_LEN);
+	hdr->opcode		= ISCSI_OP_R2T;
+	hdr->flags		|= ISCSI_FLAG_CMD_FINAL;
+	int_to_scsilun(cmd->se_cmd.orig_fe_lun,
+			(struct scsi_lun *)&hdr->lun[0]);
+	hdr->itt		= cpu_to_be32(cmd->init_task_tag);
+	spin_lock_bh(&conn->sess->ttt_lock);
+	r2t->targ_xfer_tag	= conn->sess->targ_xfer_tag++;
+	if (r2t->targ_xfer_tag == 0xFFFFFFFF)
+		r2t->targ_xfer_tag = conn->sess->targ_xfer_tag++;
+	spin_unlock_bh(&conn->sess->ttt_lock);
+	hdr->ttt		= cpu_to_be32(r2t->targ_xfer_tag);
+	hdr->statsn		= cpu_to_be32(conn->stat_sn);
+	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
+	hdr->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
+	hdr->r2tsn		= cpu_to_be32(r2t->r2t_sn);
+	hdr->data_offset	= cpu_to_be32(r2t->offset);
+	hdr->data_length	= cpu_to_be32(r2t->xfer_len);
+
+	cmd->iov_misc[0].iov_base	= cmd->pdu;
+	cmd->iov_misc[0].iov_len	= ISCSI_HDR_LEN;
+	tx_size += ISCSI_HDR_LEN;
+
+	if (conn->conn_ops->HeaderDigest) {
+		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				(unsigned char *)hdr, ISCSI_HDR_LEN,
+				0, NULL, (u8 *)header_digest);
+
+		cmd->iov_misc[0].iov_len += ISCSI_CRC_LEN;
+		tx_size += ISCSI_CRC_LEN;
+		pr_debug("Attaching CRC32 HeaderDigest for R2T"
+			" PDU 0x%08x\n", *header_digest);
+	}
+
+	pr_debug("Built %sR2T, ITT: 0x%08x, TTT: 0x%08x, StatSN:"
+		" 0x%08x, R2TSN: 0x%08x, Offset: %u, DDTL: %u, CID: %hu\n",
+		(!r2t->recovery_r2t) ? "" : "Recovery ", cmd->init_task_tag,
+		r2t->targ_xfer_tag, ntohl(hdr->statsn), r2t->r2t_sn,
+			r2t->offset, r2t->xfer_len, conn->cid);
+
+	cmd->iov_misc_count = 1;
+	cmd->tx_size = tx_size;
+
+	spin_lock_bh(&cmd->r2t_lock);
+	r2t->sent_r2t = 1;
+	spin_unlock_bh(&cmd->r2t_lock);
+
+	return 0;
+}
+
+/*
+ *	type 0: Normal Operation.
+ *	type 1: Called from Storage Transport.
+ *	type 2: Called from iscsi_task_reassign_complete_write() for
+ *	        connection recovery.
+ */
+int iscsit_build_r2ts_for_cmd(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn,
+	int type)
+{
+	int first_r2t = 1;
+	u32 offset = 0, xfer_len = 0;
+
+	spin_lock_bh(&cmd->r2t_lock);
+	if (cmd->cmd_flags & ICF_SENT_LAST_R2T) {
+		spin_unlock_bh(&cmd->r2t_lock);
+		return 0;
+	}
+
+	if (conn->sess->sess_ops->DataSequenceInOrder && (type != 2))
+		if (cmd->r2t_offset < cmd->write_data_done)
+			cmd->r2t_offset = cmd->write_data_done;
+
+	while (cmd->outstanding_r2ts < conn->sess->sess_ops->MaxOutstandingR2T) {
+		if (conn->sess->sess_ops->DataSequenceInOrder) {
+			offset = cmd->r2t_offset;
+
+			if (first_r2t && (type == 2)) {
+				xfer_len = ((offset +
+					     (conn->sess->sess_ops->MaxBurstLength -
+					     cmd->next_burst_len) >
+					     cmd->data_length) ?
+					    (cmd->data_length - offset) :
+					    (conn->sess->sess_ops->MaxBurstLength -
+					     cmd->next_burst_len));
+			} else {
+				xfer_len = ((offset +
+					     conn->sess->sess_ops->MaxBurstLength) >
+					     cmd->data_length) ?
+					     (cmd->data_length - offset) :
+					     conn->sess->sess_ops->MaxBurstLength;
+			}
+			cmd->r2t_offset += xfer_len;
+
+			if (cmd->r2t_offset == cmd->data_length)
+				cmd->cmd_flags |= ICF_SENT_LAST_R2T;
+		} else {
+			struct iscsi_seq *seq;
+
+			seq = iscsit_get_seq_holder_for_r2t(cmd);
+			if (!seq) {
+				spin_unlock_bh(&cmd->r2t_lock);
+				return -1;
+			}
+
+			offset = seq->offset;
+			xfer_len = seq->xfer_len;
+
+			if (cmd->seq_send_order == cmd->seq_count)
+				cmd->cmd_flags |= ICF_SENT_LAST_R2T;
+		}
+		cmd->outstanding_r2ts++;
+		first_r2t = 0;
+
+		if (iscsit_add_r2t_to_list(cmd, offset, xfer_len, 0, 0) < 0) {
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
+static int iscsit_send_status(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	u8 iov_count = 0, recovery;
+	u32 padding = 0, tx_size = 0;
+	struct iscsi_scsi_rsp *hdr;
+	struct kvec *iov;
+
+	recovery = (cmd->i_state != ISTATE_SEND_STATUS);
+	if (!recovery)
+		cmd->stat_sn = conn->stat_sn++;
+
+	spin_lock_bh(&conn->sess->session_stats_lock);
+	conn->sess->rsp_pdus++;
+	spin_unlock_bh(&conn->sess->session_stats_lock);
+
+	hdr			= (struct iscsi_scsi_rsp *) cmd->pdu;
+	memset(hdr, 0, ISCSI_HDR_LEN);
+	hdr->opcode		= ISCSI_OP_SCSI_CMD_RSP;
+	hdr->flags		|= ISCSI_FLAG_CMD_FINAL;
+	if (cmd->se_cmd.se_cmd_flags & SCF_OVERFLOW_BIT) {
+		hdr->flags |= ISCSI_FLAG_CMD_OVERFLOW;
+		hdr->residual_count = cpu_to_be32(cmd->residual_count);
+	} else if (cmd->se_cmd.se_cmd_flags & SCF_UNDERFLOW_BIT) {
+		hdr->flags |= ISCSI_FLAG_CMD_UNDERFLOW;
+		hdr->residual_count = cpu_to_be32(cmd->residual_count);
+	}
+	hdr->response		= cmd->iscsi_response;
+	hdr->cmd_status		= cmd->se_cmd.scsi_status;
+	hdr->itt		= cpu_to_be32(cmd->init_task_tag);
+	hdr->statsn		= cpu_to_be32(cmd->stat_sn);
+
+	iscsit_increment_maxcmdsn(cmd, conn->sess);
+	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
+	hdr->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
+
+	iov = &cmd->iov_misc[0];
+	iov[iov_count].iov_base	= cmd->pdu;
+	iov[iov_count++].iov_len = ISCSI_HDR_LEN;
+	tx_size += ISCSI_HDR_LEN;
+
+	/*
+	 * Attach SENSE DATA payload to iSCSI Response PDU
+	 */
+	if (cmd->se_cmd.sense_buffer &&
+	   ((cmd->se_cmd.se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) ||
+	    (cmd->se_cmd.se_cmd_flags & SCF_EMULATED_TASK_SENSE))) {
+		padding		= -(cmd->se_cmd.scsi_sense_length) & 3;
+		hton24(hdr->dlength, cmd->se_cmd.scsi_sense_length);
+		iov[iov_count].iov_base	= cmd->se_cmd.sense_buffer;
+		iov[iov_count++].iov_len =
+				(cmd->se_cmd.scsi_sense_length + padding);
+		tx_size += cmd->se_cmd.scsi_sense_length;
+
+		if (padding) {
+			memset(cmd->se_cmd.sense_buffer +
+				cmd->se_cmd.scsi_sense_length, 0, padding);
+			tx_size += padding;
+			pr_debug("Adding %u bytes of padding to"
+				" SENSE.\n", padding);
+		}
+
+		if (conn->conn_ops->DataDigest) {
+			iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				cmd->se_cmd.sense_buffer,
+				(cmd->se_cmd.scsi_sense_length + padding),
+				0, NULL, (u8 *)&cmd->data_crc);
+
+			iov[iov_count].iov_base    = &cmd->data_crc;
+			iov[iov_count++].iov_len     = ISCSI_CRC_LEN;
+			tx_size += ISCSI_CRC_LEN;
+
+			pr_debug("Attaching CRC32 DataDigest for"
+				" SENSE, %u bytes CRC 0x%08x\n",
+				(cmd->se_cmd.scsi_sense_length + padding),
+				cmd->data_crc);
+		}
+
+		pr_debug("Attaching SENSE DATA: %u bytes to iSCSI"
+				" Response PDU\n",
+				cmd->se_cmd.scsi_sense_length);
+	}
+
+	if (conn->conn_ops->HeaderDigest) {
+		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				(unsigned char *)hdr, ISCSI_HDR_LEN,
+				0, NULL, (u8 *)header_digest);
+
+		iov[0].iov_len += ISCSI_CRC_LEN;
+		tx_size += ISCSI_CRC_LEN;
+		pr_debug("Attaching CRC32 HeaderDigest for Response"
+				" PDU 0x%08x\n", *header_digest);
+	}
+
+	cmd->iov_misc_count = iov_count;
+	cmd->tx_size = tx_size;
+
+	pr_debug("Built %sSCSI Response, ITT: 0x%08x, StatSN: 0x%08x,"
+		" Response: 0x%02x, SAM Status: 0x%02x, CID: %hu\n",
+		(!recovery) ? "" : "Recovery ", cmd->init_task_tag,
+		cmd->stat_sn, 0x00, cmd->se_cmd.scsi_status, conn->cid);
+
+	return 0;
+}
+
+static u8 iscsit_convert_tcm_tmr_rsp(struct se_tmr_req *se_tmr)
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
+static int iscsit_send_task_mgt_rsp(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	struct se_tmr_req *se_tmr = cmd->se_cmd.se_tmr_req;
+	struct iscsi_tm_rsp *hdr;
+	u32 tx_size = 0;
+
+	hdr			= (struct iscsi_tm_rsp *) cmd->pdu;
+	memset(hdr, 0, ISCSI_HDR_LEN);
+	hdr->opcode		= ISCSI_OP_SCSI_TMFUNC_RSP;
+	hdr->response		= iscsit_convert_tcm_tmr_rsp(se_tmr);
+	hdr->itt		= cpu_to_be32(cmd->init_task_tag);
+	cmd->stat_sn		= conn->stat_sn++;
+	hdr->statsn		= cpu_to_be32(cmd->stat_sn);
+
+	iscsit_increment_maxcmdsn(cmd, conn->sess);
+	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
+	hdr->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
+
+	cmd->iov_misc[0].iov_base	= cmd->pdu;
+	cmd->iov_misc[0].iov_len	= ISCSI_HDR_LEN;
+	tx_size += ISCSI_HDR_LEN;
+
+	if (conn->conn_ops->HeaderDigest) {
+		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				(unsigned char *)hdr, ISCSI_HDR_LEN,
+				0, NULL, (u8 *)header_digest);
+
+		cmd->iov_misc[0].iov_len += ISCSI_CRC_LEN;
+		tx_size += ISCSI_CRC_LEN;
+		pr_debug("Attaching CRC32 HeaderDigest for Task"
+			" Mgmt Response PDU 0x%08x\n", *header_digest);
+	}
+
+	cmd->iov_misc_count = 1;
+	cmd->tx_size = tx_size;
+
+	pr_debug("Built Task Management Response ITT: 0x%08x,"
+		" StatSN: 0x%08x, Response: 0x%02x, CID: %hu\n",
+		cmd->init_task_tag, cmd->stat_sn, hdr->response, conn->cid);
+
+	return 0;
+}
+
+static int iscsit_build_sendtargets_response(struct iscsi_cmd *cmd)
+{
+	char *payload = NULL;
+	struct iscsi_conn *conn = cmd->conn;
+	struct iscsi_portal_group *tpg;
+	struct iscsi_tiqn *tiqn;
+	struct iscsi_tpg_np *tpg_np;
+	int buffer_len, end_of_buf = 0, len = 0, payload_len = 0;
+	unsigned char buf[256];
+
+	buffer_len = (conn->conn_ops->MaxRecvDataSegmentLength > 32768) ?
+			32768 : conn->conn_ops->MaxRecvDataSegmentLength;
+
+	memset(buf, 0, 256);
+
+	payload = kzalloc(buffer_len, GFP_KERNEL);
+	if (!payload) {
+		pr_err("Unable to allocate memory for sendtargets"
+				" response.\n");
+		return -ENOMEM;
+	}
+
+	spin_lock(&tiqn_lock);
+	list_for_each_entry(tiqn, &g_tiqn_list, tiqn_list) {
+		len = sprintf(buf, "TargetName=%s", tiqn->tiqn);
+		len += 1;
+
+		if ((len + payload_len) > buffer_len) {
+			spin_unlock(&tiqn->tiqn_tpg_lock);
+			end_of_buf = 1;
+			goto eob;
+		}
+		memcpy((void *)payload + payload_len, buf, len);
+		payload_len += len;
+
+		spin_lock(&tiqn->tiqn_tpg_lock);
+		list_for_each_entry(tpg, &tiqn->tiqn_tpg_list, tpg_list) {
+
+			spin_lock(&tpg->tpg_state_lock);
+			if ((tpg->tpg_state == TPG_STATE_FREE) ||
+			    (tpg->tpg_state == TPG_STATE_INACTIVE)) {
+				spin_unlock(&tpg->tpg_state_lock);
+				continue;
+			}
+			spin_unlock(&tpg->tpg_state_lock);
+
+			spin_lock(&tpg->tpg_np_lock);
+			list_for_each_entry(tpg_np, &tpg->tpg_gnp_list,
+						tpg_np_list) {
+				len = sprintf(buf, "TargetAddress="
+					"%s%s%s:%hu,%hu",
+					(tpg_np->tpg_np->np_sockaddr.ss_family == AF_INET6) ?
+					"[" : "", tpg_np->tpg_np->np_ip,
+					(tpg_np->tpg_np->np_sockaddr.ss_family == AF_INET6) ?
+					"]" : "", tpg_np->tpg_np->np_port,
+					tpg->tpgt);
+				len += 1;
+
+				if ((len + payload_len) > buffer_len) {
+					spin_unlock(&tpg->tpg_np_lock);
+					spin_unlock(&tiqn->tiqn_tpg_lock);
+					end_of_buf = 1;
+					goto eob;
+				}
+				memcpy((void *)payload + payload_len, buf, len);
+				payload_len += len;
+			}
+			spin_unlock(&tpg->tpg_np_lock);
+		}
+		spin_unlock(&tiqn->tiqn_tpg_lock);
+eob:
+		if (end_of_buf)
+			break;
+	}
+	spin_unlock(&tiqn_lock);
+
+	cmd->buf_ptr = payload;
+
+	return payload_len;
+}
+
+/*
+ *	FIXME: Add support for F_BIT and C_BIT when the length is longer than
+ *	MaxRecvDataSegmentLength.
+ */
+static int iscsit_send_text_rsp(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	struct iscsi_text_rsp *hdr;
+	struct kvec *iov;
+	u32 padding = 0, tx_size = 0;
+	int text_length, iov_count = 0;
+
+	text_length = iscsit_build_sendtargets_response(cmd);
+	if (text_length < 0)
+		return text_length;
+
+	padding = ((-text_length) & 3);
+	if (padding != 0) {
+		memset(cmd->buf_ptr + text_length, 0, padding);
+		pr_debug("Attaching %u additional bytes for"
+			" padding.\n", padding);
+	}
+
+	hdr			= (struct iscsi_text_rsp *) cmd->pdu;
+	memset(hdr, 0, ISCSI_HDR_LEN);
+	hdr->opcode		= ISCSI_OP_TEXT_RSP;
+	hdr->flags		|= ISCSI_FLAG_CMD_FINAL;
+	hton24(hdr->dlength, text_length);
+	hdr->itt		= cpu_to_be32(cmd->init_task_tag);
+	hdr->ttt		= cpu_to_be32(cmd->targ_xfer_tag);
+	cmd->stat_sn		= conn->stat_sn++;
+	hdr->statsn		= cpu_to_be32(cmd->stat_sn);
+
+	iscsit_increment_maxcmdsn(cmd, conn->sess);
+	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
+	hdr->max_cmdsn		= cpu_to_be32(conn->sess->max_cmd_sn);
+
+	iov = &cmd->iov_misc[0];
+
+	iov[iov_count].iov_base = cmd->pdu;
+	iov[iov_count++].iov_len = ISCSI_HDR_LEN;
+	iov[iov_count].iov_base	= cmd->buf_ptr;
+	iov[iov_count++].iov_len = text_length + padding;
+
+	tx_size += (ISCSI_HDR_LEN + text_length + padding);
+
+	if (conn->conn_ops->HeaderDigest) {
+		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				(unsigned char *)hdr, ISCSI_HDR_LEN,
+				0, NULL, (u8 *)header_digest);
+
+		iov[0].iov_len += ISCSI_CRC_LEN;
+		tx_size += ISCSI_CRC_LEN;
+		pr_debug("Attaching CRC32 HeaderDigest for"
+			" Text Response PDU 0x%08x\n", *header_digest);
+	}
+
+	if (conn->conn_ops->DataDigest) {
+		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				cmd->buf_ptr, (text_length + padding),
+				0, NULL, (u8 *)&cmd->data_crc);
+
+		iov[iov_count].iov_base	= &cmd->data_crc;
+		iov[iov_count++].iov_len = ISCSI_CRC_LEN;
+		tx_size	+= ISCSI_CRC_LEN;
+
+		pr_debug("Attaching DataDigest for %u bytes of text"
+			" data, CRC 0x%08x\n", (text_length + padding),
+			cmd->data_crc);
+	}
+
+	cmd->iov_misc_count = iov_count;
+	cmd->tx_size = tx_size;
+
+	pr_debug("Built Text Response: ITT: 0x%08x, StatSN: 0x%08x,"
+		" Length: %u, CID: %hu\n", cmd->init_task_tag, cmd->stat_sn,
+			text_length, conn->cid);
+	return 0;
+}
+
+static int iscsit_send_reject(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	u32 iov_count = 0, tx_size = 0;
+	struct iscsi_reject *hdr;
+	struct kvec *iov;
+
+	hdr			= (struct iscsi_reject *) cmd->pdu;
+	hdr->opcode		= ISCSI_OP_REJECT;
+	hdr->flags		|= ISCSI_FLAG_CMD_FINAL;
+	hton24(hdr->dlength, ISCSI_HDR_LEN);
+	cmd->stat_sn		= conn->stat_sn++;
+	hdr->statsn		= cpu_to_be32(cmd->stat_sn);
+	hdr->exp_cmdsn	= cpu_to_be32(conn->sess->exp_cmd_sn);
+	hdr->max_cmdsn	= cpu_to_be32(conn->sess->max_cmd_sn);
+
+	iov = &cmd->iov_misc[0];
+
+	iov[iov_count].iov_base = cmd->pdu;
+	iov[iov_count++].iov_len = ISCSI_HDR_LEN;
+	iov[iov_count].iov_base = cmd->buf_ptr;
+	iov[iov_count++].iov_len = ISCSI_HDR_LEN;
+
+	tx_size = (ISCSI_HDR_LEN + ISCSI_HDR_LEN);
+
+	if (conn->conn_ops->HeaderDigest) {
+		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				(unsigned char *)hdr, ISCSI_HDR_LEN,
+				0, NULL, (u8 *)header_digest);
+
+		iov[0].iov_len += ISCSI_CRC_LEN;
+		tx_size += ISCSI_CRC_LEN;
+		pr_debug("Attaching CRC32 HeaderDigest for"
+			" REJECT PDU 0x%08x\n", *header_digest);
+	}
+
+	if (conn->conn_ops->DataDigest) {
+		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				(unsigned char *)cmd->buf_ptr, ISCSI_HDR_LEN,
+				0, NULL, (u8 *)&cmd->data_crc);
+
+		iov[iov_count].iov_base = &cmd->data_crc;
+		iov[iov_count++].iov_len  = ISCSI_CRC_LEN;
+		tx_size += ISCSI_CRC_LEN;
+		pr_debug("Attaching CRC32 DataDigest for REJECT"
+				" PDU 0x%08x\n", cmd->data_crc);
+	}
+
+	cmd->iov_misc_count = iov_count;
+	cmd->tx_size = tx_size;
+
+	pr_debug("Built Reject PDU StatSN: 0x%08x, Reason: 0x%02x,"
+		" CID: %hu\n", ntohl(hdr->statsn), hdr->reason, conn->cid);
+
+	return 0;
+}
+
+static void iscsit_tx_thread_wait_for_tcp(struct iscsi_conn *conn)
+{
+	if ((conn->sock->sk->sk_shutdown & SEND_SHUTDOWN) ||
+	    (conn->sock->sk->sk_shutdown & RCV_SHUTDOWN)) {
+		wait_for_completion_interruptible_timeout(
+					&conn->tx_half_close_comp,
+					ISCSI_TX_THREAD_TCP_TIMEOUT * HZ);
+	}
+}
+
+#ifdef CONFIG_SMP
+
+void iscsit_thread_get_cpumask(struct iscsi_conn *conn)
+{
+	struct iscsi_thread_set *ts = conn->thread_set;
+	int ord, cpu;
+	/*
+	 * thread_id is assigned from iscsit_global->ts_bitmap from
+	 * within iscsi_thread_set.c:iscsi_allocate_thread_sets()
+	 *
+	 * Here we use thread_id to determine which CPU that this
+	 * iSCSI connection's iscsi_thread_set will be scheduled to
+	 * execute upon.
+	 */
+	ord = ts->thread_id % cpumask_weight(cpu_online_mask);
+#if 0
+	pr_debug(">>>>>>>>>>>>>>>>>>>> Generated ord: %d from"
+			" thread_id: %d\n", ord, ts->thread_id);
+#endif
+	for_each_online_cpu(cpu) {
+		if (ord-- == 0) {
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
+static inline void iscsit_thread_check_cpumask(
+	struct iscsi_conn *conn,
+	struct task_struct *p,
+	int mode)
+{
+	char buf[128];
+	/*
+	 * mode == 1 signals iscsi_target_tx_thread() usage.
+	 * mode == 0 signals iscsi_target_rx_thread() usage.
+	 */
+	if (mode == 1) {
+		if (!conn->conn_tx_reset_cpumask)
+			return;
+		conn->conn_tx_reset_cpumask = 0;
+	} else {
+		if (!conn->conn_rx_reset_cpumask)
+			return;
+		conn->conn_rx_reset_cpumask = 0;
+	}
+	/*
+	 * Update the CPU mask for this single kthread so that
+	 * both TX and RX kthreads are scheduled to run on the
+	 * same CPU.
+	 */
+	memset(buf, 0, 128);
+	cpumask_scnprintf(buf, 128, conn->conn_cpumask);
+#if 0
+	pr_debug(">>>>>>>>>>>>>> Calling set_cpus_allowed_ptr():"
+			" %s for %s\n", buf, p->comm);
+#endif
+	set_cpus_allowed_ptr(p, conn->conn_cpumask);
+}
+
+#else
+#define iscsit_thread_get_cpumask(X) ({})
+#define iscsit_thread_check_cpumask(X, Y, Z) ({})
+#endif /* CONFIG_SMP */
+
+int iscsi_target_tx_thread(void *arg)
+{
+	u8 state;
+	int eodr = 0;
+	int ret = 0;
+	int sent_status = 0;
+	int use_misc = 0;
+	int map_sg = 0;
+	struct iscsi_cmd *cmd = NULL;
+	struct iscsi_conn *conn;
+	struct iscsi_queue_req *qr = NULL;
+	struct se_cmd *se_cmd;
+	struct iscsi_thread_set *ts = (struct iscsi_thread_set *)arg;
+	/*
+	 * Allow ourselves to be interrupted by SIGINT so that a
+	 * connection recovery / failure event can be triggered externally.
+	 */
+	allow_signal(SIGINT);
+
+restart:
+	conn = iscsi_tx_thread_pre_handler(ts);
+	if (!conn)
+		goto out;
+
+	eodr = map_sg = ret = sent_status = use_misc = 0;
+
+	while (!kthread_should_stop()) {
+		/*
+		 * Ensure that both TX and RX per connection kthreads
+		 * are scheduled to run on the same CPU.
+		 */
+		iscsit_thread_check_cpumask(conn, current, 1);
+
+		schedule_timeout_interruptible(MAX_SCHEDULE_TIMEOUT);
+
+		if ((ts->status == ISCSI_THREAD_SET_RESET) ||
+		     signal_pending(current))
+			goto transport_err;
+
+get_immediate:
+		qr = iscsit_get_cmd_from_immediate_queue(conn);
+		if (qr) {
+			atomic_set(&conn->check_immediate_queue, 0);
+			cmd = qr->cmd;
+			state = qr->state;
+			kmem_cache_free(lio_qr_cache, qr);
+
+			spin_lock_bh(&cmd->istate_lock);
+			switch (state) {
+			case ISTATE_SEND_R2T:
+				spin_unlock_bh(&cmd->istate_lock);
+				ret = iscsit_send_r2t(cmd, conn);
+				break;
+			case ISTATE_REMOVE:
+				spin_unlock_bh(&cmd->istate_lock);
+
+				if (cmd->data_direction == DMA_TO_DEVICE)
+					iscsit_stop_dataout_timer(cmd);
+
+				spin_lock_bh(&conn->cmd_lock);
+				list_del(&cmd->i_list);
+				spin_unlock_bh(&conn->cmd_lock);
+				/*
+				 * Determine if a struct se_cmd is assoicated with
+				 * this struct iscsi_cmd.
+				 */
+				if (!(cmd->se_cmd.se_cmd_flags & SCF_SE_LUN_CMD) &&
+				    !(cmd->tmr_req))
+					iscsit_release_cmd(cmd);
+				else
+					transport_generic_free_cmd(&cmd->se_cmd,
+								1, 0);
+				goto get_immediate;
+			case ISTATE_SEND_NOPIN_WANT_RESPONSE:
+				spin_unlock_bh(&cmd->istate_lock);
+				iscsit_mod_nopin_response_timer(conn);
+				ret = iscsit_send_unsolicited_nopin(cmd,
+						conn, 1);
+				break;
+			case ISTATE_SEND_NOPIN_NO_RESPONSE:
+				spin_unlock_bh(&cmd->istate_lock);
+				ret = iscsit_send_unsolicited_nopin(cmd,
+						conn, 0);
+				break;
+			default:
+				pr_err("Unknown Opcode: 0x%02x ITT:"
+				" 0x%08x, i_state: %d on CID: %hu\n",
+				cmd->iscsi_opcode, cmd->init_task_tag, state,
+				conn->cid);
+				spin_unlock_bh(&cmd->istate_lock);
+				goto transport_err;
+			}
+			if (ret < 0) {
+				conn->tx_immediate_queue = 0;
+				goto transport_err;
+			}
+
+			if (iscsit_send_tx_data(cmd, conn, 1) < 0) {
+				conn->tx_immediate_queue = 0;
+				iscsit_tx_thread_wait_for_tcp(conn);
+				goto transport_err;
+			}
+
+			spin_lock_bh(&cmd->istate_lock);
+			switch (state) {
+			case ISTATE_SEND_R2T:
+				spin_unlock_bh(&cmd->istate_lock);
+				spin_lock_bh(&cmd->dataout_timeout_lock);
+				iscsit_start_dataout_timer(cmd, conn);
+				spin_unlock_bh(&cmd->dataout_timeout_lock);
+				break;
+			case ISTATE_SEND_NOPIN_WANT_RESPONSE:
+				cmd->i_state = ISTATE_SENT_NOPIN_WANT_RESPONSE;
+				spin_unlock_bh(&cmd->istate_lock);
+				break;
+			case ISTATE_SEND_NOPIN_NO_RESPONSE:
+				cmd->i_state = ISTATE_SENT_STATUS;
+				spin_unlock_bh(&cmd->istate_lock);
+				break;
+			default:
+				pr_err("Unknown Opcode: 0x%02x ITT:"
+					" 0x%08x, i_state: %d on CID: %hu\n",
+					cmd->iscsi_opcode, cmd->init_task_tag,
+					state, conn->cid);
+				spin_unlock_bh(&cmd->istate_lock);
+				goto transport_err;
+			}
+			goto get_immediate;
+		} else
+			conn->tx_immediate_queue = 0;
+
+get_response:
+		qr = iscsit_get_cmd_from_response_queue(conn);
+		if (qr) {
+			cmd = qr->cmd;
+			state = qr->state;
+			kmem_cache_free(lio_qr_cache, qr);
+
+			spin_lock_bh(&cmd->istate_lock);
+check_rsp_state:
+			switch (state) {
+			case ISTATE_SEND_DATAIN:
+				spin_unlock_bh(&cmd->istate_lock);
+				ret = iscsit_send_data_in(cmd, conn,
+							  &eodr);
+				map_sg = 1;
+				break;
+			case ISTATE_SEND_STATUS:
+			case ISTATE_SEND_STATUS_RECOVERY:
+				spin_unlock_bh(&cmd->istate_lock);
+				use_misc = 1;
+				ret = iscsit_send_status(cmd, conn);
+				break;
+			case ISTATE_SEND_LOGOUTRSP:
+				spin_unlock_bh(&cmd->istate_lock);
+				use_misc = 1;
+				ret = iscsit_send_logout_response(cmd, conn);
+				break;
+			case ISTATE_SEND_ASYNCMSG:
+				spin_unlock_bh(&cmd->istate_lock);
+				use_misc = 1;
+				ret = iscsit_send_conn_drop_async_message(
+						cmd, conn);
+				break;
+			case ISTATE_SEND_NOPIN:
+				spin_unlock_bh(&cmd->istate_lock);
+				use_misc = 1;
+				ret = iscsit_send_nopin_response(cmd, conn);
+				break;
+			case ISTATE_SEND_REJECT:
+				spin_unlock_bh(&cmd->istate_lock);
+				use_misc = 1;
+				ret = iscsit_send_reject(cmd, conn);
+				break;
+			case ISTATE_SEND_TASKMGTRSP:
+				spin_unlock_bh(&cmd->istate_lock);
+				use_misc = 1;
+				ret = iscsit_send_task_mgt_rsp(cmd, conn);
+				if (ret != 0)
+					break;
+				ret = iscsit_tmr_post_handler(cmd, conn);
+				if (ret != 0)
+					iscsit_fall_back_to_erl0(conn->sess);
+				break;
+			case ISTATE_SEND_TEXTRSP:
+				spin_unlock_bh(&cmd->istate_lock);
+				use_misc = 1;
+				ret = iscsit_send_text_rsp(cmd, conn);
+				break;
+			default:
+				pr_err("Unknown Opcode: 0x%02x ITT:"
+					" 0x%08x, i_state: %d on CID: %hu\n",
+					cmd->iscsi_opcode, cmd->init_task_tag,
+					state, conn->cid);
+				spin_unlock_bh(&cmd->istate_lock);
+				goto transport_err;
+			}
+			if (ret < 0) {
+				conn->tx_response_queue = 0;
+				goto transport_err;
+			}
+
+			se_cmd = &cmd->se_cmd;
+
+			if (map_sg && !conn->conn_ops->IFMarker) {
+				if (iscsit_fe_sendpage_sg(cmd, conn) < 0) {
+					conn->tx_response_queue = 0;
+					iscsit_tx_thread_wait_for_tcp(conn);
+					iscsit_unmap_iovec(cmd);
+					goto transport_err;
+				}
+			} else {
+				if (iscsit_send_tx_data(cmd, conn, use_misc) < 0) {
+					conn->tx_response_queue = 0;
+					iscsit_tx_thread_wait_for_tcp(conn);
+					iscsit_unmap_iovec(cmd);
+					goto transport_err;
+				}
+			}
+			map_sg = 0;
+			iscsit_unmap_iovec(cmd);
+
+			spin_lock_bh(&cmd->istate_lock);
+			switch (state) {
+			case ISTATE_SEND_DATAIN:
+				if (!eodr)
+					goto check_rsp_state;
+
+				if (eodr == 1) {
+					cmd->i_state = ISTATE_SENT_LAST_DATAIN;
+					sent_status = 1;
+					eodr = use_misc = 0;
+				} else if (eodr == 2) {
+					cmd->i_state = state =
+							ISTATE_SEND_STATUS;
+					sent_status = 0;
+					eodr = use_misc = 0;
+					goto check_rsp_state;
+				}
+				break;
+			case ISTATE_SEND_STATUS:
+				use_misc = 0;
+				sent_status = 1;
+				break;
+			case ISTATE_SEND_ASYNCMSG:
+			case ISTATE_SEND_NOPIN:
+			case ISTATE_SEND_STATUS_RECOVERY:
+			case ISTATE_SEND_TEXTRSP:
+				use_misc = 0;
+				sent_status = 1;
+				break;
+			case ISTATE_SEND_REJECT:
+				use_misc = 0;
+				if (cmd->cmd_flags & ICF_REJECT_FAIL_CONN) {
+					cmd->cmd_flags &= ~ICF_REJECT_FAIL_CONN;
+					spin_unlock_bh(&cmd->istate_lock);
+					complete(&cmd->reject_comp);
+					goto transport_err;
+				}
+				complete(&cmd->reject_comp);
+				break;
+			case ISTATE_SEND_TASKMGTRSP:
+				use_misc = 0;
+				sent_status = 1;
+				break;
+			case ISTATE_SEND_LOGOUTRSP:
+				spin_unlock_bh(&cmd->istate_lock);
+				if (!iscsit_logout_post_handler(cmd, conn))
+					goto restart;
+				spin_lock_bh(&cmd->istate_lock);
+				use_misc = 0;
+				sent_status = 1;
+				break;
+			default:
+				pr_err("Unknown Opcode: 0x%02x ITT:"
+					" 0x%08x, i_state: %d on CID: %hu\n",
+					cmd->iscsi_opcode, cmd->init_task_tag,
+					cmd->i_state, conn->cid);
+				spin_unlock_bh(&cmd->istate_lock);
+				goto transport_err;
+			}
+
+			if (sent_status) {
+				cmd->i_state = ISTATE_SENT_STATUS;
+				sent_status = 0;
+			}
+			spin_unlock_bh(&cmd->istate_lock);
+
+			if (atomic_read(&conn->check_immediate_queue))
+				goto get_immediate;
+
+			goto get_response;
+		} else
+			conn->tx_response_queue = 0;
+	}
+
+transport_err:
+	iscsit_take_action_for_connection_exit(conn);
+	goto restart;
+out:
+	return 0;
+}
+
+int iscsi_target_rx_thread(void *arg)
+{
+	int ret;
+	u8 buffer[ISCSI_HDR_LEN], opcode;
+	u32 checksum = 0, digest = 0;
+	struct iscsi_conn *conn = NULL;
+	struct iscsi_thread_set *ts = (struct iscsi_thread_set *)arg;
+	struct kvec iov;
+	/*
+	 * Allow ourselves to be interrupted by SIGINT so that a
+	 * connection recovery / failure event can be triggered externally.
+	 */
+	allow_signal(SIGINT);
+
+restart:
+	conn = iscsi_rx_thread_pre_handler(ts);
+	if (!conn)
+		goto out;
+
+	while (!kthread_should_stop()) {
+		/*
+		 * Ensure that both TX and RX per connection kthreads
+		 * are scheduled to run on the same CPU.
+		 */
+		iscsit_thread_check_cpumask(conn, current, 0);
+
+		memset(buffer, 0, ISCSI_HDR_LEN);
+		memset(&iov, 0, sizeof(struct kvec));
+
+		iov.iov_base	= buffer;
+		iov.iov_len	= ISCSI_HDR_LEN;
+
+		ret = rx_data(conn, &iov, 1, ISCSI_HDR_LEN);
+		if (ret != ISCSI_HDR_LEN) {
+			iscsit_rx_thread_wait_for_tcp(conn);
+			goto transport_err;
+		}
+
+		/*
+		 * Set conn->bad_hdr for use with REJECT PDUs.
+		 */
+		memcpy(&conn->bad_hdr, &buffer, ISCSI_HDR_LEN);
+
+		if (conn->conn_ops->HeaderDigest) {
+			iov.iov_base	= &digest;
+			iov.iov_len	= ISCSI_CRC_LEN;
+
+			ret = rx_data(conn, &iov, 1, ISCSI_CRC_LEN);
+			if (ret != ISCSI_CRC_LEN) {
+				iscsit_rx_thread_wait_for_tcp(conn);
+				goto transport_err;
+			}
+
+			iscsit_do_crypto_hash_buf(&conn->conn_rx_hash,
+					buffer, ISCSI_HDR_LEN,
+					0, NULL, (u8 *)&checksum);
+
+			if (digest != checksum) {
+				pr_err("HeaderDigest CRC32C failed,"
+					" received 0x%08x, computed 0x%08x\n",
+					digest, checksum);
+				/*
+				 * Set the PDU to 0xff so it will intentionally
+				 * hit default in the switch below.
+				 */
+				memset(buffer, 0xff, ISCSI_HDR_LEN);
+				spin_lock_bh(&conn->sess->session_stats_lock);
+				conn->sess->conn_digest_errors++;
+				spin_unlock_bh(&conn->sess->session_stats_lock);
+			} else {
+				pr_debug("Got HeaderDigest CRC32C"
+						" 0x%08x\n", checksum);
+			}
+		}
+
+		if (conn->conn_state == TARG_CONN_STATE_IN_LOGOUT)
+			goto transport_err;
+
+		opcode = buffer[0] & ISCSI_OPCODE_MASK;
+
+		if (conn->sess->sess_ops->SessionType &&
+		   ((!(opcode & ISCSI_OP_TEXT)) ||
+		    (!(opcode & ISCSI_OP_LOGOUT)))) {
+			pr_err("Received illegal iSCSI Opcode: 0x%02x"
+			" while in Discovery Session, rejecting.\n", opcode);
+			iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+					buffer, conn);
+			goto transport_err;
+		}
+
+		switch (opcode) {
+		case ISCSI_OP_SCSI_CMD:
+			if (iscsit_handle_scsi_cmd(conn, buffer) < 0)
+				goto transport_err;
+			break;
+		case ISCSI_OP_SCSI_DATA_OUT:
+			if (iscsit_handle_data_out(conn, buffer) < 0)
+				goto transport_err;
+			break;
+		case ISCSI_OP_NOOP_OUT:
+			if (iscsit_handle_nop_out(conn, buffer) < 0)
+				goto transport_err;
+			break;
+		case ISCSI_OP_SCSI_TMFUNC:
+			if (iscsit_handle_task_mgt_cmd(conn, buffer) < 0)
+				goto transport_err;
+			break;
+		case ISCSI_OP_TEXT:
+			if (iscsit_handle_text_cmd(conn, buffer) < 0)
+				goto transport_err;
+			break;
+		case ISCSI_OP_LOGOUT:
+			ret = iscsit_handle_logout_cmd(conn, buffer);
+			if (ret > 0) {
+				wait_for_completion_timeout(&conn->conn_logout_comp,
+						SECONDS_FOR_LOGOUT_COMP * HZ);
+				goto transport_err;
+			} else if (ret < 0)
+				goto transport_err;
+			break;
+		case ISCSI_OP_SNACK:
+			if (iscsit_handle_snack(conn, buffer) < 0)
+				goto transport_err;
+			break;
+		default:
+			pr_err("Got unknown iSCSI OpCode: 0x%02x\n",
+					opcode);
+			if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
+				pr_err("Cannot recover from unknown"
+				" opcode while ERL=0, closing iSCSI connection"
+				".\n");
+				goto transport_err;
+			}
+			if (!conn->conn_ops->OFMarker) {
+				pr_err("Unable to recover from unknown"
+				" opcode while OFMarker=No, closing iSCSI"
+					" connection.\n");
+				goto transport_err;
+			}
+			if (iscsit_recover_from_unknown_opcode(conn) < 0) {
+				pr_err("Unable to recover from unknown"
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
+	iscsit_take_action_for_connection_exit(conn);
+	goto restart;
+out:
+	return 0;
+}
+
+static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
+{
+	struct iscsi_cmd *cmd = NULL, *cmd_tmp = NULL;
+	struct iscsi_session *sess = conn->sess;
+	struct se_cmd *se_cmd;
+	/*
+	 * We expect this function to only ever be called from either RX or TX
+	 * thread context via iscsit_close_connection() once the other context
+	 * has been reset -> returned sleeping pre-handler state.
+	 */
+	spin_lock_bh(&conn->cmd_lock);
+	list_for_each_entry_safe(cmd, cmd_tmp, &conn->conn_cmd_list, i_list) {
+		if (!(cmd->se_cmd.se_cmd_flags & SCF_SE_LUN_CMD)) {
+
+			list_del(&cmd->i_list);
+			spin_unlock_bh(&conn->cmd_lock);
+			iscsit_increment_maxcmdsn(cmd, sess);
+			se_cmd = &cmd->se_cmd;
+			/*
+			 * Special cases for active iSCSI TMR, and
+			 * transport_lookup_cmd_lun() failing from
+			 * iscsit_get_lun_for_cmd() in iscsit_handle_scsi_cmd().
+			 */
+			if (cmd->tmr_req && se_cmd->transport_wait_for_tasks)
+				se_cmd->transport_wait_for_tasks(se_cmd, 1, 1);
+			else if (cmd->se_cmd.se_cmd_flags & SCF_SE_LUN_CMD)
+				transport_release_cmd(se_cmd);
+			else
+				iscsit_release_cmd(cmd);
+
+			spin_lock_bh(&conn->cmd_lock);
+			continue;
+		}
+		list_del(&cmd->i_list);
+		spin_unlock_bh(&conn->cmd_lock);
+
+		iscsit_increment_maxcmdsn(cmd, sess);
+		se_cmd = &cmd->se_cmd;
+
+		if (se_cmd->transport_wait_for_tasks)
+			se_cmd->transport_wait_for_tasks(se_cmd, 1, 1);
+
+		spin_lock_bh(&conn->cmd_lock);
+	}
+	spin_unlock_bh(&conn->cmd_lock);
+}
+
+static void iscsit_stop_timers_for_cmds(
+	struct iscsi_conn *conn)
+{
+	struct iscsi_cmd *cmd;
+
+	spin_lock_bh(&conn->cmd_lock);
+	list_for_each_entry(cmd, &conn->conn_cmd_list, i_list) {
+		if (cmd->data_direction == DMA_TO_DEVICE)
+			iscsit_stop_dataout_timer(cmd);
+	}
+	spin_unlock_bh(&conn->cmd_lock);
+}
+
+int iscsit_close_connection(
+	struct iscsi_conn *conn)
+{
+	int conn_logout = (conn->conn_state == TARG_CONN_STATE_IN_LOGOUT);
+	struct iscsi_session	*sess = conn->sess;
+
+	pr_debug("Closing iSCSI connection CID %hu on SID:"
+		" %u\n", conn->cid, sess->sid);
+	/*
+	 * Always up conn_logout_comp just in case the RX Thread is sleeping
+	 * and the logout response never got sent because the connection
+	 * failed.
+	 */
+	complete(&conn->conn_logout_comp);
+
+	iscsi_release_thread_set(conn);
+
+	iscsit_stop_timers_for_cmds(conn);
+	iscsit_stop_nopin_response_timer(conn);
+	iscsit_stop_nopin_timer(conn);
+	iscsit_free_queue_reqs_for_conn(conn);
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
+		iscsit_discard_unacknowledged_ooo_cmdsns_for_conn(conn);
+		iscsit_prepare_cmds_for_realligance(conn);
+	} else {
+		iscsit_clear_ooo_cmdsns_for_conn(conn);
+		iscsit_release_commands_from_conn(conn);
+	}
+
+	/*
+	 * Handle decrementing session or connection usage count if
+	 * a logout response was not able to be sent because the
+	 * connection failed.  Fall back to Session Recovery here.
+	 */
+	if (atomic_read(&conn->conn_logout_remove)) {
+		if (conn->conn_logout_reason == ISCSI_LOGOUT_REASON_CLOSE_SESSION) {
+			iscsit_dec_conn_usage_count(conn);
+			iscsit_dec_session_usage_count(sess);
+		}
+		if (conn->conn_logout_reason == ISCSI_LOGOUT_REASON_CLOSE_CONNECTION)
+			iscsit_dec_conn_usage_count(conn);
+
+		atomic_set(&conn->conn_logout_remove, 0);
+		atomic_set(&sess->session_reinstatement, 0);
+		atomic_set(&sess->session_fall_back_to_erl0, 1);
+	}
+
+	spin_lock_bh(&sess->conn_lock);
+	list_del(&conn->conn_list);
+
+	/*
+	 * Attempt to let the Initiator know this connection failed by
+	 * sending an Connection Dropped Async Message on another
+	 * active connection.
+	 */
+	if (atomic_read(&conn->connection_recovery))
+		iscsit_build_conn_drop_async_message(conn);
+
+	spin_unlock_bh(&sess->conn_lock);
+
+	/*
+	 * If connection reinstatement is being performed on this connection,
+	 * up the connection reinstatement semaphore that is being blocked on
+	 * in iscsit_cause_connection_reinstatement().
+	 */
+	spin_lock_bh(&conn->state_lock);
+	if (atomic_read(&conn->sleep_on_conn_wait_comp)) {
+		spin_unlock_bh(&conn->state_lock);
+		complete(&conn->conn_wait_comp);
+		wait_for_completion(&conn->conn_post_wait_comp);
+		spin_lock_bh(&conn->state_lock);
+	}
+
+	/*
+	 * If connection reinstatement is being performed on this connection
+	 * by receiving a REMOVECONNFORRECOVERY logout request, up the
+	 * connection wait rcfr semaphore that is being blocked on
+	 * an iscsit_connection_reinstatement_rcfr().
+	 */
+	if (atomic_read(&conn->connection_wait_rcfr)) {
+		spin_unlock_bh(&conn->state_lock);
+		complete(&conn->conn_wait_rcfr_comp);
+		wait_for_completion(&conn->conn_post_wait_comp);
+		spin_lock_bh(&conn->state_lock);
+	}
+	atomic_set(&conn->connection_reinstatement, 1);
+	spin_unlock_bh(&conn->state_lock);
+
+	/*
+	 * If any other processes are accessing this connection pointer we
+	 * must wait until they have completed.
+	 */
+	iscsit_check_conn_usage_count(conn);
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
+	conn->conn_ops = NULL;
+
+	if (conn->sock) {
+		if (conn->conn_flags & CONNFLAG_SCTP_STRUCT_FILE) {
+			kfree(conn->sock->file);
+			conn->sock->file = NULL;
+		}
+		sock_release(conn->sock);
+	}
+	conn->thread_set = NULL;
+
+	pr_debug("Moving to TARG_CONN_STATE_FREE.\n");
+	conn->conn_state = TARG_CONN_STATE_FREE;
+	kfree(conn);
+
+	spin_lock_bh(&sess->conn_lock);
+	atomic_dec(&sess->nconn);
+	pr_debug("Decremented iSCSI connection count to %hu from node:"
+		" %s\n", atomic_read(&sess->nconn),
+		sess->sess_ops->InitiatorName);
+	/*
+	 * Make sure that if one connection fails in an non ERL=2 iSCSI
+	 * Session that they all fail.
+	 */
+	if ((sess->sess_ops->ErrorRecoveryLevel != 2) && !conn_logout &&
+	     !atomic_read(&sess->session_logout))
+		atomic_set(&sess->session_fall_back_to_erl0, 1);
+
+	/*
+	 * If this was not the last connection in the session, and we are
+	 * performing session reinstatement or falling back to ERL=0, call
+	 * iscsit_stop_session() without sleeping to shutdown the other
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
+			iscsit_stop_session(sess, 0, 0);
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
+	 * to ERL=0 call iscsit_close_session().
+	 *
+	 * Session Logout was requested.  iscsit_close_session() will be called
+	 * elsewhere.
+	 *
+	 * Session Continuation is not being performed, start the Time2Retain
+	 * handler and check if sleep_on_sess_wait_sem is active.
+	 */
+	if (!atomic_read(&sess->session_reinstatement) &&
+	     atomic_read(&sess->session_fall_back_to_erl0)) {
+		spin_unlock_bh(&sess->conn_lock);
+		iscsit_close_session(sess);
+
+		return 0;
+	} else if (atomic_read(&sess->session_logout)) {
+		pr_debug("Moving to TARG_SESS_STATE_FREE.\n");
+		sess->session_state = TARG_SESS_STATE_FREE;
+		spin_unlock_bh(&sess->conn_lock);
+
+		if (atomic_read(&sess->sleep_on_sess_wait_comp))
+			complete(&sess->session_wait_comp);
+
+		return 0;
+	} else {
+		pr_debug("Moving to TARG_SESS_STATE_FAILED.\n");
+		sess->session_state = TARG_SESS_STATE_FAILED;
+
+		if (!atomic_read(&sess->session_continuation)) {
+			spin_unlock_bh(&sess->conn_lock);
+			iscsit_start_time2retain_handler(sess);
+		} else
+			spin_unlock_bh(&sess->conn_lock);
+
+		if (atomic_read(&sess->sleep_on_sess_wait_comp))
+			complete(&sess->session_wait_comp);
+
+		return 0;
+	}
+	spin_unlock_bh(&sess->conn_lock);
+
+	return 0;
+}
+
+int iscsit_close_session(struct iscsi_session *sess)
+{
+	struct iscsi_portal_group *tpg = ISCSI_TPG_S(sess);
+	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
+
+	if (atomic_read(&sess->nconn)) {
+		pr_err("%d connection(s) still exist for iSCSI session"
+			" to %s\n", atomic_read(&sess->nconn),
+			sess->sess_ops->InitiatorName);
+		BUG();
+	}
+
+	spin_lock_bh(&se_tpg->session_lock);
+	atomic_set(&sess->session_logout, 1);
+	atomic_set(&sess->session_reinstatement, 1);
+	iscsit_stop_time2retain_timer(sess);
+	spin_unlock_bh(&se_tpg->session_lock);
+
+	/*
+	 * transport_deregister_session_configfs() will clear the
+	 * struct se_node_acl->nacl_sess pointer now as a iscsi_np process context
+	 * can be setting it again with __transport_register_session() in
+	 * iscsi_post_login_handler() again after the iscsit_stop_session()
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
+		if (iscsit_check_session_usage_count(sess) == 1)
+			iscsit_stop_session(sess, 1, 1);
+	} else {
+		if (iscsit_check_session_usage_count(sess) == 2) {
+			atomic_set(&sess->session_logout, 0);
+			iscsit_start_time2retain_handler(sess);
+			return 0;
+		}
+	}
+
+	transport_deregister_session(sess->se_sess);
+
+	if (sess->sess_ops->ErrorRecoveryLevel == 2)
+		iscsit_free_connection_recovery_entires(sess);
+
+	iscsit_free_all_ooo_cmdsns(sess);
+
+	spin_lock_bh(&se_tpg->session_lock);
+	pr_debug("Moving to TARG_SESS_STATE_FREE.\n");
+	sess->session_state = TARG_SESS_STATE_FREE;
+	pr_debug("Released iSCSI session from node: %s\n",
+			sess->sess_ops->InitiatorName);
+	tpg->nsessions--;
+	if (tpg->tpg_tiqn)
+		tpg->tpg_tiqn->tiqn_nsessions--;
+
+	pr_debug("Decremented number of active iSCSI Sessions on"
+		" iSCSI TPG: %hu to %u\n", tpg->tpgt, tpg->nsessions);
+
+	spin_lock(&sess_idr_lock);
+	idr_remove(&sess_idr, sess->session_index);
+	spin_unlock(&sess_idr_lock);
+
+	kfree(sess->sess_ops);
+	sess->sess_ops = NULL;
+	spin_unlock_bh(&se_tpg->session_lock);
+
+	kfree(sess);
+	return 0;
+}
+
+static void iscsit_logout_post_handler_closesession(
+	struct iscsi_conn *conn)
+{
+	struct iscsi_session *sess = conn->sess;
+
+	iscsi_set_thread_clear(conn, ISCSI_CLEAR_TX_THREAD);
+	iscsi_set_thread_set_signal(conn, ISCSI_SIGNAL_TX_THREAD);
+
+	atomic_set(&conn->conn_logout_remove, 0);
+	complete(&conn->conn_logout_comp);
+
+	iscsit_dec_conn_usage_count(conn);
+	iscsit_stop_session(sess, 1, 1);
+	iscsit_dec_session_usage_count(sess);
+	iscsit_close_session(sess);
+}
+
+static void iscsit_logout_post_handler_samecid(
+	struct iscsi_conn *conn)
+{
+	iscsi_set_thread_clear(conn, ISCSI_CLEAR_TX_THREAD);
+	iscsi_set_thread_set_signal(conn, ISCSI_SIGNAL_TX_THREAD);
+
+	atomic_set(&conn->conn_logout_remove, 0);
+	complete(&conn->conn_logout_comp);
+
+	iscsit_cause_connection_reinstatement(conn, 1);
+	iscsit_dec_conn_usage_count(conn);
+}
+
+static void iscsit_logout_post_handler_diffcid(
+	struct iscsi_conn *conn,
+	u16 cid)
+{
+	struct iscsi_conn *l_conn;
+	struct iscsi_session *sess = conn->sess;
+
+	if (!sess)
+		return;
+
+	spin_lock_bh(&sess->conn_lock);
+	list_for_each_entry(l_conn, &sess->sess_conn_list, conn_list) {
+		if (l_conn->cid == cid) {
+			iscsit_inc_conn_usage_count(l_conn);
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
+	pr_debug("Moving to TARG_CONN_STATE_IN_LOGOUT.\n");
+	l_conn->conn_state = TARG_CONN_STATE_IN_LOGOUT;
+	spin_unlock_bh(&l_conn->state_lock);
+
+	iscsit_cause_connection_reinstatement(l_conn, 1);
+	iscsit_dec_conn_usage_count(l_conn);
+}
+
+/*
+ *	Return of 0 causes the TX thread to restart.
+ */
+static int iscsit_logout_post_handler(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	int ret = 0;
+
+	switch (cmd->logout_reason) {
+	case ISCSI_LOGOUT_REASON_CLOSE_SESSION:
+		switch (cmd->logout_response) {
+		case ISCSI_LOGOUT_SUCCESS:
+		case ISCSI_LOGOUT_CLEANUP_FAILED:
+		default:
+			iscsit_logout_post_handler_closesession(conn);
+			break;
+		}
+		ret = 0;
+		break;
+	case ISCSI_LOGOUT_REASON_CLOSE_CONNECTION:
+		if (conn->cid == cmd->logout_cid) {
+			switch (cmd->logout_response) {
+			case ISCSI_LOGOUT_SUCCESS:
+			case ISCSI_LOGOUT_CLEANUP_FAILED:
+			default:
+				iscsit_logout_post_handler_samecid(conn);
+				break;
+			}
+			ret = 0;
+		} else {
+			switch (cmd->logout_response) {
+			case ISCSI_LOGOUT_SUCCESS:
+				iscsit_logout_post_handler_diffcid(conn,
+					cmd->logout_cid);
+				break;
+			case ISCSI_LOGOUT_CID_NOT_FOUND:
+			case ISCSI_LOGOUT_CLEANUP_FAILED:
+			default:
+				break;
+			}
+			ret = 1;
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
+		ret = 1;
+		break;
+	default:
+		break;
+
+	}
+	return ret;
+}
+
+void iscsit_fail_session(struct iscsi_session *sess)
+{
+	struct iscsi_conn *conn;
+
+	spin_lock_bh(&sess->conn_lock);
+	list_for_each_entry(conn, &sess->sess_conn_list, conn_list) {
+		pr_debug("Moving to TARG_CONN_STATE_CLEANUP_WAIT.\n");
+		conn->conn_state = TARG_CONN_STATE_CLEANUP_WAIT;
+	}
+	spin_unlock_bh(&sess->conn_lock);
+
+	pr_debug("Moving to TARG_SESS_STATE_FAILED.\n");
+	sess->session_state = TARG_SESS_STATE_FAILED;
+}
+
+int iscsit_free_session(struct iscsi_session *sess)
+{
+	u16 conn_count = atomic_read(&sess->nconn);
+	struct iscsi_conn *conn, *conn_tmp = NULL;
+	int is_last;
+
+	spin_lock_bh(&sess->conn_lock);
+	atomic_set(&sess->sleep_on_sess_wait_comp, 1);
+
+	list_for_each_entry_safe(conn, conn_tmp, &sess->sess_conn_list,
+			conn_list) {
+		if (conn_count == 0)
+			break;
+
+		if (list_is_last(&conn->conn_list, &sess->sess_conn_list)) {
+			is_last = 1;
+		} else {
+			iscsit_inc_conn_usage_count(conn_tmp);
+			is_last = 0;
+		}
+		iscsit_inc_conn_usage_count(conn);
+
+		spin_unlock_bh(&sess->conn_lock);
+		iscsit_cause_connection_reinstatement(conn, 1);
+		spin_lock_bh(&sess->conn_lock);
+
+		iscsit_dec_conn_usage_count(conn);
+		if (is_last == 0)
+			iscsit_dec_conn_usage_count(conn_tmp);
+
+		conn_count--;
+	}
+
+	if (atomic_read(&sess->nconn)) {
+		spin_unlock_bh(&sess->conn_lock);
+		wait_for_completion(&sess->session_wait_comp);
+	} else
+		spin_unlock_bh(&sess->conn_lock);
+
+	iscsit_close_session(sess);
+	return 0;
+}
+
+void iscsit_stop_session(
+	struct iscsi_session *sess,
+	int session_sleep,
+	int connection_sleep)
+{
+	u16 conn_count = atomic_read(&sess->nconn);
+	struct iscsi_conn *conn, *conn_tmp = NULL;
+	int is_last;
+
+	spin_lock_bh(&sess->conn_lock);
+	if (session_sleep)
+		atomic_set(&sess->sleep_on_sess_wait_comp, 1);
+
+	if (connection_sleep) {
+		list_for_each_entry_safe(conn, conn_tmp, &sess->sess_conn_list,
+				conn_list) {
+			if (conn_count == 0)
+				break;
+
+			if (list_is_last(&conn->conn_list, &sess->sess_conn_list)) {
+				is_last = 1;
+			} else {
+				iscsit_inc_conn_usage_count(conn_tmp);
+				is_last = 0;
+			}
+			iscsit_inc_conn_usage_count(conn);
+
+			spin_unlock_bh(&sess->conn_lock);
+			iscsit_cause_connection_reinstatement(conn, 1);
+			spin_lock_bh(&sess->conn_lock);
+
+			iscsit_dec_conn_usage_count(conn);
+			if (is_last == 0)
+				iscsit_dec_conn_usage_count(conn_tmp);
+			conn_count--;
+		}
+	} else {
+		list_for_each_entry(conn, &sess->sess_conn_list, conn_list)
+			iscsit_cause_connection_reinstatement(conn, 0);
+	}
+
+	if (session_sleep && atomic_read(&sess->nconn)) {
+		spin_unlock_bh(&sess->conn_lock);
+		wait_for_completion(&sess->session_wait_comp);
+	} else
+		spin_unlock_bh(&sess->conn_lock);
+}
+
+int iscsit_release_sessions_for_tpg(struct iscsi_portal_group *tpg, int force)
+{
+	struct iscsi_session *sess;
+	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
+	struct se_session *se_sess, *se_sess_tmp;
+	int session_count = 0;
+
+	spin_lock_bh(&se_tpg->session_lock);
+	if (tpg->nsessions && !force) {
+		spin_unlock_bh(&se_tpg->session_lock);
+		return -1;
+	}
+
+	list_for_each_entry_safe(se_sess, se_sess_tmp, &se_tpg->tpg_sess_list,
+			sess_list) {
+		sess = (struct iscsi_session *)se_sess->fabric_sess_ptr;
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
+		iscsit_free_session(sess);
+		spin_lock_bh(&se_tpg->session_lock);
+
+		session_count++;
+	}
+	spin_unlock_bh(&se_tpg->session_lock);
+
+	pr_debug("Released %d iSCSI Session(s) from Target Portal"
+			" Group: %hu\n", session_count, tpg->tpgt);
+	return 0;
+}
+
+MODULE_DESCRIPTION("iSCSI-Target Driver for mainline target infrastructure");
+MODULE_VERSION("4.1.x");
+MODULE_AUTHOR("nab@Linux-iSCSI.org");
+MODULE_LICENSE("GPL");
+
+module_init(iscsi_target_init_module);
+module_exit(iscsi_target_cleanup_module);
diff --git a/drivers/target/iscsi/iscsi_target.h b/drivers/target/iscsi/iscsi_target.h
new file mode 100644
index 0000000..5db2dde
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target.h
@@ -0,0 +1,42 @@
+#ifndef ISCSI_TARGET_H
+#define ISCSI_TARGET_H
+
+extern struct iscsi_tiqn *iscsit_get_tiqn_for_login(unsigned char *);
+extern struct iscsi_tiqn *iscsit_get_tiqn(unsigned char *, int);
+extern void iscsit_put_tiqn_for_login(struct iscsi_tiqn *);
+extern struct iscsi_tiqn *iscsit_add_tiqn(unsigned char *);
+extern void iscsit_del_tiqn(struct iscsi_tiqn *);
+extern int iscsit_access_np(struct iscsi_np *, struct iscsi_portal_group *);
+extern int iscsit_deaccess_np(struct iscsi_np *, struct iscsi_portal_group *);
+extern struct iscsi_np *iscsit_add_np(struct __kernel_sockaddr_storage *,
+				char *, int);
+extern int iscsit_reset_np_thread(struct iscsi_np *, struct iscsi_tpg_np *,
+				struct iscsi_portal_group *);
+extern int iscsit_del_np(struct iscsi_np *);
+extern int iscsit_add_reject_from_cmd(u8, int, int, unsigned char *, struct iscsi_cmd *);
+extern int iscsit_logout_closesession(struct iscsi_cmd *, struct iscsi_conn *);
+extern int iscsit_logout_closeconnection(struct iscsi_cmd *, struct iscsi_conn *);
+extern int iscsit_logout_removeconnforrecovery(struct iscsi_cmd *, struct iscsi_conn *);
+extern int iscsit_send_async_msg(struct iscsi_conn *, u16, u8, u8);
+extern int iscsit_send_r2t(struct iscsi_cmd *, struct iscsi_conn *);
+extern int iscsit_build_r2ts_for_cmd(struct iscsi_cmd *, struct iscsi_conn *, int);
+extern void iscsit_thread_get_cpumask(struct iscsi_conn *);
+extern int iscsi_target_tx_thread(void *);
+extern int iscsi_target_rx_thread(void *);
+extern int iscsit_close_connection(struct iscsi_conn *);
+extern int iscsit_close_session(struct iscsi_session *);
+extern void iscsit_fail_session(struct iscsi_session *);
+extern int iscsit_free_session(struct iscsi_session *);
+extern void iscsit_stop_session(struct iscsi_session *, int, int);
+extern int iscsit_release_sessions_for_tpg(struct iscsi_portal_group *, int);
+
+extern struct iscsit_global *iscsit_global;
+extern struct target_fabric_configfs *lio_target_fabric_configfs;
+
+extern struct kmem_cache *lio_dr_cache;
+extern struct kmem_cache *lio_ooo_cache;
+extern struct kmem_cache *lio_cmd_cache;
+extern struct kmem_cache *lio_qr_cache;
+extern struct kmem_cache *lio_r2t_cache;
+
+#endif   /*** ISCSI_TARGET_H ***/
diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscsi/iscsi_target_core.h
new file mode 100644
index 0000000..470ed55
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target_core.h
@@ -0,0 +1,859 @@
+#ifndef ISCSI_TARGET_CORE_H
+#define ISCSI_TARGET_CORE_H
+
+#include <linux/in.h>
+#include <linux/configfs.h>
+#include <net/sock.h>
+#include <net/tcp.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/iscsi_proto.h>
+#include <target/target_core_base.h>
+
+#define ISCSIT_VERSION			"v4.1.0-rc1"
+#define ISCSI_MAX_DATASN_MISSING_COUNT	16
+#define ISCSI_TX_THREAD_TCP_TIMEOUT	2
+#define ISCSI_RX_THREAD_TCP_TIMEOUT	2
+#define SECONDS_FOR_ASYNC_LOGOUT	10
+#define SECONDS_FOR_ASYNC_TEXT		10
+#define SECONDS_FOR_LOGOUT_COMP		15
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
+/* Enabled by default in demo mode (generic_node_acls=1) */
+#define TA_DEMO_MODE_WRITE_PROTECT	1
+/* Disabled by default in production mode w/ explict ACLs */
+#define TA_PROD_MODE_WRITE_PROTECT	0
+#define TA_CACHE_CORE_NPS		0
+
+enum tpg_np_network_transport_table {
+	ISCSI_TCP				= 0,
+	ISCSI_SCTP_TCP				= 1,
+	ISCSI_SCTP_UDP				= 2,
+	ISCSI_IWARP_TCP				= 3,
+	ISCSI_IWARP_SCTP			= 4,
+	ISCSI_INFINIBAND			= 5,
+};
+
+/* RFC-3720 7.1.4  Standard Connection State Diagram for a Target */
+enum target_conn_state_table {
+	TARG_CONN_STATE_FREE			= 0x1,
+	TARG_CONN_STATE_XPT_UP			= 0x3,
+	TARG_CONN_STATE_IN_LOGIN		= 0x4,
+	TARG_CONN_STATE_LOGGED_IN		= 0x5,
+	TARG_CONN_STATE_IN_LOGOUT		= 0x6,
+	TARG_CONN_STATE_LOGOUT_REQUESTED	= 0x7,
+	TARG_CONN_STATE_CLEANUP_WAIT		= 0x8,
+};
+
+/* RFC-3720 7.3.2  Session State Diagram for a Target */
+enum target_sess_state_table {
+	TARG_SESS_STATE_FREE			= 0x1,
+	TARG_SESS_STATE_ACTIVE			= 0x2,
+	TARG_SESS_STATE_LOGGED_IN		= 0x3,
+	TARG_SESS_STATE_FAILED			= 0x4,
+	TARG_SESS_STATE_IN_CONTINUE		= 0x5,
+};
+
+/* struct iscsi_data_count->type */
+enum data_count_type {
+	ISCSI_RX_DATA	= 1,
+	ISCSI_TX_DATA	= 2,
+};
+
+/* struct iscsi_datain_req->dr_complete */
+enum datain_req_comp_table {
+	DATAIN_COMPLETE_NORMAL			= 1,
+	DATAIN_COMPLETE_WITHIN_COMMAND_RECOVERY = 2,
+	DATAIN_COMPLETE_CONNECTION_RECOVERY	= 3,
+};
+
+/* struct iscsi_datain_req->recovery */
+enum datain_req_rec_table {
+	DATAIN_WITHIN_COMMAND_RECOVERY		= 1,
+	DATAIN_CONNECTION_RECOVERY		= 2,
+};
+
+/* struct iscsi_portal_group->state */
+enum tpg_state_table {
+	TPG_STATE_FREE				= 0,
+	TPG_STATE_ACTIVE			= 1,
+	TPG_STATE_INACTIVE			= 2,
+	TPG_STATE_COLD_RESET			= 3,
+};
+
+/* struct iscsi_tiqn->tiqn_state */
+enum tiqn_state_table {
+	TIQN_STATE_ACTIVE			= 1,
+	TIQN_STATE_SHUTDOWN			= 2,
+};
+
+/* struct iscsi_cmd->cmd_flags */
+enum cmd_flags_table {
+	ICF_GOT_LAST_DATAOUT			= 0x00000001,
+	ICF_GOT_DATACK_SNACK			= 0x00000002,
+	ICF_NON_IMMEDIATE_UNSOLICITED_DATA	= 0x00000004,
+	ICF_SENT_LAST_R2T			= 0x00000008,
+	ICF_WITHIN_COMMAND_RECOVERY		= 0x00000010,
+	ICF_CONTIG_MEMORY			= 0x00000020,
+	ICF_ATTACHED_TO_RQUEUE			= 0x00000040,
+	ICF_OOO_CMDSN				= 0x00000080,
+	ICF_REJECT_FAIL_CONN			= 0x00000100,
+};
+
+/* struct iscsi_cmd->i_state */
+enum cmd_i_state_table {
+	ISTATE_NO_STATE			= 0,
+	ISTATE_NEW_CMD			= 1,
+	ISTATE_DEFERRED_CMD		= 2,
+	ISTATE_UNSOLICITED_DATA		= 3,
+	ISTATE_RECEIVE_DATAOUT		= 4,
+	ISTATE_RECEIVE_DATAOUT_RECOVERY	= 5,
+	ISTATE_RECEIVED_LAST_DATAOUT	= 6,
+	ISTATE_WITHIN_DATAOUT_RECOVERY	= 7,
+	ISTATE_IN_CONNECTION_RECOVERY	= 8,
+	ISTATE_RECEIVED_TASKMGT		= 9,
+	ISTATE_SEND_ASYNCMSG		= 10,
+	ISTATE_SENT_ASYNCMSG		= 11,
+	ISTATE_SEND_DATAIN		= 12,
+	ISTATE_SEND_LAST_DATAIN		= 13,
+	ISTATE_SENT_LAST_DATAIN		= 14,
+	ISTATE_SEND_LOGOUTRSP		= 15,
+	ISTATE_SENT_LOGOUTRSP		= 16,
+	ISTATE_SEND_NOPIN		= 17,
+	ISTATE_SENT_NOPIN		= 18,
+	ISTATE_SEND_REJECT		= 19,
+	ISTATE_SENT_REJECT		= 20,
+	ISTATE_SEND_R2T			= 21,
+	ISTATE_SENT_R2T			= 22,
+	ISTATE_SEND_R2T_RECOVERY	= 23,
+	ISTATE_SENT_R2T_RECOVERY	= 24,
+	ISTATE_SEND_LAST_R2T		= 25,
+	ISTATE_SENT_LAST_R2T		= 26,
+	ISTATE_SEND_LAST_R2T_RECOVERY	= 27,
+	ISTATE_SENT_LAST_R2T_RECOVERY	= 28,
+	ISTATE_SEND_STATUS		= 29,
+	ISTATE_SEND_STATUS_BROKEN_PC	= 30,
+	ISTATE_SENT_STATUS		= 31,
+	ISTATE_SEND_STATUS_RECOVERY	= 32,
+	ISTATE_SENT_STATUS_RECOVERY	= 33,
+	ISTATE_SEND_TASKMGTRSP		= 34,
+	ISTATE_SENT_TASKMGTRSP		= 35,
+	ISTATE_SEND_TEXTRSP		= 36,
+	ISTATE_SENT_TEXTRSP		= 37,
+	ISTATE_SEND_NOPIN_WANT_RESPONSE	= 38,
+	ISTATE_SENT_NOPIN_WANT_RESPONSE	= 39,
+	ISTATE_SEND_NOPIN_NO_RESPONSE	= 40,
+	ISTATE_REMOVE			= 41,
+	ISTATE_FREE			= 42,
+};
+
+/* Used for iscsi_recover_cmdsn() return values */
+enum recover_cmdsn_ret_table {
+	CMDSN_ERROR_CANNOT_RECOVER	= -1,
+	CMDSN_NORMAL_OPERATION		= 0,
+	CMDSN_LOWER_THAN_EXP		= 1,
+	CMDSN_HIGHER_THAN_EXP		= 2,
+};
+
+/* Used for iscsi_handle_immediate_data() return values */
+enum immedate_data_ret_table {
+	IMMEDIATE_DATA_CANNOT_RECOVER	= -1,
+	IMMEDIATE_DATA_NORMAL_OPERATION = 0,
+	IMMEDIATE_DATA_ERL1_CRC_FAILURE = 1,
+};
+
+/* Used for iscsi_decide_dataout_action() return values */
+enum dataout_action_ret_table {
+	DATAOUT_CANNOT_RECOVER		= -1,
+	DATAOUT_NORMAL			= 0,
+	DATAOUT_SEND_R2T		= 1,
+	DATAOUT_SEND_TO_TRANSPORT	= 2,
+	DATAOUT_WITHIN_COMMAND_RECOVERY = 3,
+};
+
+/* Used for struct iscsi_node_auth->naf_flags */
+enum naf_flags_table {
+	NAF_USERID_SET			= 0x01,
+	NAF_PASSWORD_SET		= 0x02,
+	NAF_USERID_IN_SET		= 0x04,
+	NAF_PASSWORD_IN_SET		= 0x08,
+};
+
+/* Used by various struct timer_list to manage iSCSI specific state */
+enum iscsi_timer_flags_table {
+	ISCSI_TF_RUNNING		= 0x01,
+	ISCSI_TF_STOP			= 0x02,
+	ISCSI_TF_EXPIRED		= 0x04,
+};
+
+/* Used for struct iscsi_np->np_flags */
+enum np_flags_table {
+	NPF_IP_NETWORK		= 0x00,
+	NPF_SCTP_STRUCT_FILE	= 0x01 /* Bugfix */
+};
+
+/* Used for struct iscsi_np->np_thread_state */
+enum np_thread_state_table {
+	ISCSI_NP_THREAD_ACTIVE		= 1,
+	ISCSI_NP_THREAD_INACTIVE	= 2,
+	ISCSI_NP_THREAD_RESET		= 3,
+	ISCSI_NP_THREAD_SHUTDOWN	= 4,
+	ISCSI_NP_THREAD_EXIT		= 5,
+};
+
+struct iscsi_conn_ops {
+	u8	HeaderDigest;			/* [0,1] == [None,CRC32C] */
+	u8	DataDigest;			/* [0,1] == [None,CRC32C] */
+	u32	MaxRecvDataSegmentLength;	/* [512..2**24-1] */
+	u8	OFMarker;			/* [0,1] == [No,Yes] */
+	u8	IFMarker;			/* [0,1] == [No,Yes] */
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
+	u8	InitialR2T;			/* [0,1] == [No,Yes] */
+	u8	ImmediateData;			/* [0,1] == [No,Yes] */
+	u32	MaxBurstLength;			/* [512..2**24-1] */
+	u32	FirstBurstLength;		/* [512..2**24-1] */
+	u16	DefaultTime2Wait;		/* [0..3600] */
+	u16	DefaultTime2Retain;		/* [0..3600] */
+	u16	MaxOutstandingR2T;		/* [1..65535] */
+	u8	DataPDUInOrder;			/* [0,1] == [No,Yes] */
+	u8	DataSequenceInOrder;		/* [0,1] == [No,Yes] */
+	u8	ErrorRecoveryLevel;		/* [0..2] */
+	u8	SessionType;			/* [0,1] == [Normal,Discovery]*/
+};
+
+struct iscsi_queue_req {
+	int			state;
+	struct iscsi_cmd	*cmd;
+	struct list_head	qr_list;
+};
+
+struct iscsi_data_count {
+	int			data_length;
+	int			sync_and_steering;
+	enum data_count_type	type;
+	u32			iov_count;
+	u32			ss_iov_count;
+	u32			ss_marker_count;
+	struct kvec		*iov;
+};
+
+struct iscsi_param_list {
+	struct list_head	param_list;
+	struct list_head	extra_response_list;
+};
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
+	/* Logout reason when iscsi_opcode == ISCSI_INIT_LOGOUT_CMND */
+	u8			logout_reason;
+	/* Logout response code when iscsi_opcode == ISCSI_INIT_LOGOUT_CMND */
+	u8			logout_response;
+	/* MaxCmdSN has been incremented */
+	u8			maxcmdsn_inc;
+	/* Immediate Unsolicited Dataout */
+	u8			unsolicited_data;
+	/* CID contained in logout PDU when opcode == ISCSI_INIT_LOGOUT_CMND */
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
+	/* Next R2T Offset when DataSequenceInOrder=Yes */
+	u32			r2t_offset;
+	/* Iovec current and orig count for iscsi_cmd->iov_data */
+	u32			iov_data_count;
+	u32			orig_iov_data_count;
+	/* Number of miscellaneous iovecs used for IP stack calls */
+	u32			iov_misc_count;
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
+	unsigned char		pdu[ISCSI_HDR_LEN + ISCSI_CRC_LEN];
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
+	struct completion	reject_comp;
+	/* Timer for DataOUT */
+	struct timer_list	dataout_timer;
+	/* Iovecs for SCSI data payload RX/TX w/ kernel level sockets */
+	struct kvec		*iov_data;
+	/* Iovecs for miscellaneous purposes */
+#define ISCSI_MISC_IOVECS			5
+	struct kvec		iov_misc[ISCSI_MISC_IOVECS];
+	/* Array of struct iscsi_pdu used for DataPDUInOrder=No */
+	struct iscsi_pdu	*pdu_list;
+	/* Current struct iscsi_pdu used for DataPDUInOrder=No */
+	struct iscsi_pdu	*pdu_ptr;
+	/* Array of struct iscsi_seq used for DataSequenceInOrder=No */
+	struct iscsi_seq	*seq_list;
+	/* Current struct iscsi_seq used for DataSequenceInOrder=No */
+	struct iscsi_seq	*seq_ptr;
+	/* TMR Request when iscsi_opcode == ISCSI_OP_SCSI_TMFUNC */
+	struct iscsi_tmr_req	*tmr_req;
+	/* Connection this command is alligient to */
+	struct iscsi_conn	*conn;
+	/* Pointer to connection recovery entry */
+	struct iscsi_conn_recovery *cr;
+	/* Session the command is part of,  used for connection recovery */
+	struct iscsi_session	*sess;
+	/* list_head for connection list */
+	struct list_head	i_list;
+	/* The TCM I/O descriptor that is accessed via container_of() */
+	struct se_cmd		se_cmd;
+	/* Sense buffer that will be mapped into outgoing status */
+#define ISCSI_SENSE_BUFFER_LEN          (TRANSPORT_SENSE_BUFFER + 2)
+	unsigned char		sense_buffer[ISCSI_SENSE_BUFFER_LEN];
+
+	struct scatterlist	*t_mem_sg;
+	u32			t_mem_sg_nents;
+
+	u32			padding;
+	u8			pad_bytes[4];
+
+	struct scatterlist	*first_data_sg;
+	u32			first_data_sg_off;
+	u32			kmapped_nents;
+
+}  ____cacheline_aligned;
+
+struct iscsi_tmr_req {
+	bool			task_reassign:1;
+	u32			ref_cmd_sn;
+	u32			exp_data_sn;
+	struct iscsi_conn_recovery *conn_recovery;
+	struct se_tmr_req	*se_tmr_req;
+};
+
+struct iscsi_conn {
+	/* Authentication Successful for this connection */
+	u8			auth_complete;
+	/* State connection is currently in */
+	u8			conn_state;
+	u8			conn_logout_reason;
+	u8			network_transport;
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
+	unsigned char		login_ip[IPV6_ADDRESS_SPACE];
+	int			conn_usage_count;
+	int			conn_waiting_on_uc;
+	atomic_t		check_immediate_queue;
+	atomic_t		conn_logout_remove;
+	atomic_t		connection_exit;
+	atomic_t		connection_recovery;
+	atomic_t		connection_reinstatement;
+	atomic_t		connection_wait;
+	atomic_t		connection_wait_rcfr;
+	atomic_t		sleep_on_conn_wait_comp;
+	atomic_t		transport_failed;
+	struct completion	conn_post_wait_comp;
+	struct completion	conn_wait_comp;
+	struct completion	conn_wait_rcfr_comp;
+	struct completion	conn_waiting_on_uc_comp;
+	struct completion	conn_logout_comp;
+	struct completion	tx_half_close_comp;
+	struct completion	rx_half_close_comp;
+	/* socket used by this connection */
+	struct socket		*sock;
+	struct timer_list	nopin_timer;
+	struct timer_list	nopin_response_timer;
+	struct timer_list	transport_timer;
+	/* Spinlock used for add/deleting cmd's from conn_cmd_list */
+	spinlock_t		cmd_lock;
+	spinlock_t		conn_usage_lock;
+	spinlock_t		immed_queue_lock;
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
+	struct iscsi_thread_set	*thread_set;
+	/* list_head for session connection list */
+	struct list_head	conn_list;
+} ____cacheline_aligned;
+
+struct iscsi_conn_recovery {
+	u16			cid;
+	u32			cmd_count;
+	u32			maxrecvdatasegmentlength;
+	int			ready_for_reallegiance;
+	struct list_head	conn_recovery_cmd_list;
+	spinlock_t		conn_recovery_cmd_lock;
+	struct timer_list	time2retain_timer;
+	struct iscsi_session	*sess;
+	struct list_head	cr_list;
+}  ____cacheline_aligned;
+
+struct iscsi_session {
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
+
+	/* protects cmdsn values */
+	struct mutex		cmdsn_mutex;
+	/* session wide counter: expected command sequence number */
+	u32			exp_cmd_sn;
+	/* session wide counter: maximum allowed command sequence number */
+	u32			max_cmd_sn;
+	struct list_head	sess_ooo_cmdsn_list;
+
+	/* LIO specific session ID */
+	u32			sid;
+	char			auth_type[8];
+	/* unique within the target */
+	int			session_index;
+	/* Used for session reference counting */
+	int			session_usage_count;
+	int			session_waiting_on_uc;
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
+	atomic_t		sleep_on_sess_wait_comp;
+	atomic_t		transport_wait_cmds;
+	/* connection list */
+	struct list_head	sess_conn_list;
+	struct list_head	cr_active_list;
+	struct list_head	cr_inactive_list;
+	spinlock_t		conn_lock;
+	spinlock_t		cr_a_lock;
+	spinlock_t		cr_i_lock;
+	spinlock_t		session_usage_lock;
+	spinlock_t		ttt_lock;
+	struct completion	async_msg_comp;
+	struct completion	reinstatement_comp;
+	struct completion	session_wait_comp;
+	struct completion	session_waiting_on_uc_comp;
+	struct timer_list	time2retain_timer;
+	struct iscsi_sess_ops	*sess_ops;
+	struct se_session	*se_sess;
+	struct iscsi_portal_group *tpg;
+} ____cacheline_aligned;
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
+};
+
+struct se_dev_entry_s;
+
+struct iscsi_node_auth {
+	enum naf_flags_table	naf_flags;
+	int			authenticate_target;
+	/* Used for iscsit_global->discovery_auth,
+	 * set to zero (auth disabled) by default */
+	int			enforce_discovery_auth;
+#define MAX_USER_LEN				256
+#define MAX_PASS_LEN				256
+	char			userid[MAX_USER_LEN];
+	char			password[MAX_PASS_LEN];
+	char			userid_mutual[MAX_USER_LEN];
+	char			password_mutual[MAX_PASS_LEN];
+};
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
+};
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
+	struct iscsi_portal_group *tpg;
+};
+
+struct iscsi_np {
+	int			np_network_transport;
+	int			np_ip_proto;
+	int			np_sock_type;
+	enum np_thread_state_table np_thread_state;
+	enum iscsi_timer_flags_table np_login_timer_flags;
+	u32			np_exports;
+	enum np_flags_table	np_flags;
+	unsigned char		np_ip[IPV6_ADDRESS_SPACE];
+	u16			np_port;
+	spinlock_t		np_thread_lock;
+	struct completion	np_restart_comp;
+	struct socket		*np_socket;
+	struct __kernel_sockaddr_storage np_sockaddr;
+	struct task_struct	*np_thread;
+	struct timer_list	np_login_timer;
+	struct iscsi_portal_group *np_login_tpg;
+	struct list_head	np_list;
+} ____cacheline_aligned;
+
+struct iscsi_tpg_np {
+	struct iscsi_np		*tpg_np;
+	struct iscsi_portal_group *tpg;
+	struct iscsi_tpg_np	*tpg_np_parent;
+	struct list_head	tpg_np_list;
+	struct list_head	tpg_np_child_list;
+	struct list_head	tpg_np_parent_list;
+	struct se_tpg_np	se_tpg_np;
+	spinlock_t		tpg_np_parent_lock;
+};
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
+	struct mutex		tpg_access_lock;
+	struct mutex		np_login_lock;
+	struct iscsi_tpg_attrib	tpg_attrib;
+	/* Pointer to default list of iSCSI parameters for TPG */
+	struct iscsi_param_list	*param_list;
+	struct iscsi_tiqn	*tpg_tiqn;
+	struct list_head	tpg_gnp_list;
+	struct list_head	tpg_list;
+} ____cacheline_aligned;
+
+#define ISCSI_TPG_C(c)		((struct iscsi_portal_group *)(c)->tpg)
+#define ISCSI_TPG_LUN(c, l)  ((iscsi_tpg_list_t *)(c)->tpg->tpg_lun_list_t[l])
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
+	int			tiqn_access_count;
+	u32			tiqn_active_tpgs;
+	u32			tiqn_ntpgs;
+	u32			tiqn_num_tpg_nps;
+	u32			tiqn_nsessions;
+	struct list_head	tiqn_list;
+	struct list_head	tiqn_tpg_list;
+	spinlock_t		tiqn_state_lock;
+	spinlock_t		tiqn_tpg_lock;
+	struct se_wwn		tiqn_wwn;
+	struct iscsi_wwn_stat_grps tiqn_stat_grps;
+	int			tiqn_index;
+	struct iscsi_sess_err_stats  sess_err_stats;
+	struct iscsi_login_stats     login_stats;
+	struct iscsi_logout_stats    logout_stats;
+} ____cacheline_aligned;
+
+#define WWN_STAT_GRPS(tiqn)	(&(tiqn)->tiqn_stat_grps)
+
+struct iscsit_global {
+	/* In core shutdown */
+	u32			in_shutdown;
+	u32			active_ts;
+	/* Unique identifier used for the authentication daemon */
+	u32			auth_id;
+	u32			inactive_ts;
+	/* Thread Set bitmap count */
+	int			ts_bitmap_count;
+	/* Thread Set bitmap pointer */
+	unsigned long		*ts_bitmap;
+	/* Used for iSCSI discovery session authentication */
+	struct iscsi_node_acl	discovery_acl;
+	struct iscsi_portal_group	*discovery_tpg;
+};
+
+#endif /* ISCSI_TARGET_CORE_H */
-- 
1.7.6

