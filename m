From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v4 04/14] iscsi-target: Add iSCSI fabric support for target v4
Date: Mon, 16 May 2011 23:39:24 -0700
Message-ID: <1305614374-17953-5-git-send-email-nab@linux-iscsi.org>
References: <1305614374-17953-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm6-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.158]:20225
	"HELO nm6-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752737Ab1EQGk3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 May 2011 02:40:29 -0400
In-Reply-To: <1305614374-17953-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Martin Svec <martin.svec@zoner.cz>, Nicholas Bellinger <nab@linux-iscsi.org>

=46rom: Nicholas Bellinger <nab@linux-iscsi.org>

The RisingTide Systems iSCSI target module is a full featured in-kernel
software implementation of iSCSI target mode (RFC-3720) for the mainlin=
e
target v4 infrastructure code.  More information can be found here:

http://linux-iscsi.org/wiki/ISCSI

This includes support for:

   * RFC-3720 defined request / response state machines and support for
     all defined iSCSI operation codes from Section 10.2.1.2 using libi=
scsi
     include/scsi/iscsi_proto.h PDU definitions
   * Target v4 compatible control plane using the generic layout in
     target_core_fabric_configfs.c and fabric dependent attributes
     within /sys/kernel/config/target/iscsi/ subdirectories.
   * Target v4 compatible iSCSI statistics based on RFC-4544 (iSCSI MIB=
S)
   * Support for IPv6 and IPv4 network portals in M:N mapping to TPGs
   * iSCSI Error Recovery Hierarchy support
   * Per iSCSI connection RX/TX thread pair scheduling affinity
   * crc32c + crc32c_intel SSEv4 instruction offload support using libc=
rypto
   * CHAP Authentication support using libcrypto

Significant feedback for mainline code cleanups by Christoph Hellwig,
Mike Christie and Andy Grover.  Also bugfixes for regressions and
testing by Martin Svec.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c      | 4962 ++++++++++++++++++++++=
++++++++
 drivers/target/iscsi/iscsi_target.h      |   42 +
 drivers/target/iscsi/iscsi_target_core.h |  859 ++++++
 3 files changed, 5863 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/iscsi/iscsi_target.c
 create mode 100644 drivers/target/iscsi/iscsi_target.h
 create mode 100644 drivers/target/iscsi/iscsi_target_core.h

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi=
/iscsi_target.c
new file mode 100644
index 0000000..d7de179
--- /dev/null
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -0,0 +1,4962 @@
+/*********************************************************************=
**********
+ * This file contains main functions related to the iSCSI Target Core =
Driver.
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
+#include "iscsi_target_debug.h"
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
+static int iscsit_logout_post_handler(struct iscsi_cmd *, struct iscsi=
_conn *);
+
+struct iscsi_tiqn *iscsit_get_tiqn_for_login(unsigned char *buf)
+{
+	struct iscsi_tiqn *tiqn =3D NULL;
+
+	spin_lock(&tiqn_lock);
+	list_for_each_entry(tiqn, &g_tiqn_list, tiqn_list) {
+		if (!strcmp(tiqn->tiqn, buf)) {
+
+			spin_lock(&tiqn->tiqn_state_lock);
+			if (tiqn->tiqn_state =3D=3D TIQN_STATE_ACTIVE) {
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
+	struct iscsi_tiqn *tiqn =3D NULL;
+	int ret;
+
+	if (strlen(buf) > ISCSI_IQN_LEN) {
+		printk(KERN_ERR "Target IQN exceeds %d bytes\n",
+				ISCSI_IQN_LEN);
+		return ERR_PTR(-EINVAL);
+	}
+
+	tiqn =3D kzalloc(sizeof(struct iscsi_tiqn), GFP_KERNEL);
+	if (!tiqn) {
+		printk(KERN_ERR "Unable to allocate struct iscsi_tiqn\n");
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
+		printk(KERN_ERR "idr_pre_get() for tiqn_idr failed\n");
+		kfree(tiqn);
+		return ERR_PTR(-ENOMEM);
+	}
+	tiqn->tiqn_state =3D TIQN_STATE_ACTIVE;
+
+	spin_lock(&tiqn_lock);
+	ret =3D idr_get_new(&tiqn_idr, NULL, &tiqn->tiqn_index);
+	if (ret < 0) {
+		printk("idr_get_new() failed for tiqn->tiqn_index\n");
+		spin_unlock(&tiqn_lock);
+		kfree(tiqn);
+		return ERR_PTR(ret);
+	}
+	list_add_tail(&tiqn->tiqn_list, &g_tiqn_list);
+	spin_unlock(&tiqn_lock);
+
+	printk(KERN_INFO "CORE[0] - Added iSCSI Target IQN: %s\n", tiqn->tiqn=
);
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
+	while (tiqn->tiqn_access_count !=3D 0) {
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
+	 * iscsit_set_tiqn_shutdown sets tiqn->tiqn_state =3D TIQN_STATE_SHUT=
DOWN
+	 * while holding tiqn->tiqn_state_lock.  This means that all subseque=
nt
+	 * attempts to access this struct iscsi_tiqn will fail from both tran=
sport
+	 * fabric and control code paths.
+	 */
+	if (iscsit_set_tiqn_shutdown(tiqn) < 0) {
+		printk(KERN_ERR "iscsit_set_tiqn_shutdown() failed\n");
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
+	printk(KERN_INFO "CORE[0] - Deleted iSCSI Target IQN: %s\n",
+			tiqn->tiqn);
+	kfree(tiqn);
+}
+
+int iscsit_access_np(struct iscsi_np *np, struct iscsi_portal_group *t=
pg)
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
+	ret =3D mutex_lock_interruptible(&tpg->np_login_lock);
+	if ((ret !=3D 0) || signal_pending(current))
+		return -1;
+
+	spin_lock_bh(&np->np_thread_lock);
+	np->np_login_tpg =3D tpg;
+	spin_unlock_bh(&np->np_thread_lock);
+
+	return 0;
+}
+
+int iscsit_deaccess_np(struct iscsi_np *np, struct iscsi_portal_group =
*tpg)
+{
+	struct iscsi_tiqn *tiqn =3D tpg->tpg_tiqn;
+
+	spin_lock_bh(&np->np_thread_lock);
+	np->np_login_tpg =3D NULL;
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
+	int ip_match =3D 0;
+	u16 port;
+
+	spin_lock_bh(&np_lock);
+	list_for_each_entry(np, &g_np_list, np_list) {
+		spin_lock(&np->np_thread_lock);
+		if (np->np_thread_state !=3D ISCSI_NP_THREAD_ACTIVE) {
+			spin_unlock(&np->np_thread_lock);
+			continue;
+		}
+
+		if (sockaddr->ss_family =3D=3D AF_INET6) {
+			sock_in6 =3D (struct sockaddr_in6 *)sockaddr;
+			sock_in6_e =3D (struct sockaddr_in6 *)&np->np_sockaddr;
+
+			if (!memcmp((void *)&sock_in6->sin6_addr.in6_u,
+				    (void *)&sock_in6_e->sin6_addr.in6_u,
+				    sizeof(struct in6_addr)))
+				ip_match =3D 1;
+
+			port =3D ntohs(sock_in6->sin6_port);
+		} else {
+			sock_in =3D (struct sockaddr_in *)sockaddr;
+			sock_in_e =3D (struct sockaddr_in *)&np->np_sockaddr;
+
+			if (sock_in->sin_addr.s_addr =3D=3D
+			    sock_in_e->sin_addr.s_addr)
+				ip_match =3D 1;
+
+			port =3D ntohs(sock_in->sin_port);
+		}
+		=09
+		if ((ip_match =3D=3D 1) && (np->np_port =3D=3D port) &&
+		    (np->np_network_transport =3D=3D network_transport)) {
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
+	np =3D iscsit_get_np(sockaddr, network_transport);
+	if (np)
+		return np;
+
+	np =3D kzalloc(sizeof(struct iscsi_np), GFP_KERNEL);
+	if (!np) {
+		printk(KERN_ERR "Unable to allocate memory for struct iscsi_np\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	np->np_flags |=3D NPF_IP_NETWORK;
+	if (sockaddr->ss_family =3D=3D AF_INET6) {
+		sock_in6 =3D (struct sockaddr_in6 *)sockaddr;
+		snprintf(np->np_ip, IPV6_ADDRESS_SPACE, "%s", ip_str);
+		np->np_port =3D ntohs(sock_in6->sin6_port);
+	} else {
+		sock_in =3D (struct sockaddr_in *)sockaddr;
+		sprintf(np->np_ip, "%s", ip_str);
+		np->np_port =3D ntohs(sock_in->sin_port);
+	}
+
+	np->np_network_transport =3D network_transport;
+	spin_lock_init(&np->np_thread_lock);
+	init_completion(&np->np_restart_comp);
+	INIT_LIST_HEAD(&np->np_list);
+
+	ret =3D iscsi_target_setup_login_socket(np, sockaddr);
+	if (ret !=3D 0) {
+		kfree(np);
+		return ERR_PTR(ret);
+	}
+
+	np->np_thread =3D kthread_run(iscsi_target_login_thread, np, "iscsi_n=
p");
+	if (IS_ERR(np->np_thread)) {
+		printk(KERN_ERR "Unable to create kthread: iscsi_np\n");
+		ret =3D PTR_ERR(np->np_thread);
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
+	np->np_exports =3D 1;
+
+	spin_lock_bh(&np_lock);
+	list_add_tail(&np->np_list, &g_np_list);
+	spin_unlock_bh(&np_lock);
+
+	printk(KERN_INFO "CORE[0] - Added Network Portal: %s:%hu on %s\n",
+		np->np_ip, np->np_port, (np->np_network_transport =3D=3D ISCSI_TCP) =
?
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
+		if (tpg_np->tpg_np->np_login_tpg !=3D tpg) {
+			spin_unlock_bh(&np->np_thread_lock);
+			return 0;
+		}
+	}
+	if (np->np_thread_state =3D=3D ISCSI_NP_THREAD_INACTIVE) {
+		spin_unlock_bh(&np->np_thread_lock);
+		return 0;
+	}
+	np->np_thread_state =3D ISCSI_NP_THREAD_RESET;
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
+		np->np_socket->file =3D NULL;
+	}
+
+	sock_release(np->np_socket);
+	return 0;
+}
+
+int iscsit_del_np(struct iscsi_np *np)
+{
+	spin_lock_bh(&np->np_thread_lock);
+	if (!(--np->np_exports =3D=3D 0)) {
+		spin_unlock_bh(&np->np_thread_lock);
+		return 0;
+	}
+	np->np_thread_state =3D ISCSI_NP_THREAD_SHUTDOWN;
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
+	printk(KERN_INFO "CORE[0] - Removed Network Portal: %s:%hu on %s\n",
+		np->np_ip, np->np_port, (np->np_network_transport =3D=3D ISCSI_TCP) =
?
+		"TCP" : "SCTP");
+
+	kfree(np);
+	return 0;
+}
+
+static int __init iscsi_target_init_module(void)
+{
+	int ret =3D 0;
+
+	printk(KERN_INFO "iSCSI-Target "ISCSIT_VERSION"\n");
+
+	iscsit_global =3D kzalloc(sizeof(struct iscsit_global), GFP_KERNEL);
+	if (!iscsit_global) {
+		printk(KERN_ERR "Unable to allocate memory for iscsit_global\n");
+		return -1;
+	}
+	mutex_init(&auth_id_lock);
+	spin_lock_init(&sess_idr_lock);
+	idr_init(&tiqn_idr);
+	idr_init(&sess_idr);
+
+	ret =3D iscsi_target_register_configfs();
+	if (ret < 0)
+		goto out;
+
+	ret =3D iscsi_thread_set_init();
+	if (ret < 0)
+		goto configfs_out;
+
+	if (iscsi_allocate_thread_sets(TARGET_THREAD_SET_COUNT) !=3D
+			TARGET_THREAD_SET_COUNT) {
+		printk(KERN_ERR "iscsi_allocate_thread_sets() returned"
+			" unexpected value!\n");
+		goto ts_out1;
+	}
+
+	lio_cmd_cache =3D kmem_cache_create("lio_cmd_cache",
+			sizeof(struct iscsi_cmd), __alignof__(struct iscsi_cmd),
+			0, NULL);
+	if (!lio_cmd_cache) {
+		printk(KERN_ERR "Unable to kmem_cache_create() for"
+				" lio_cmd_cache\n");
+		goto ts_out2;
+	}
+
+	lio_qr_cache =3D kmem_cache_create("lio_qr_cache",
+			sizeof(struct iscsi_queue_req),
+			__alignof__(struct iscsi_queue_req), 0, NULL);
+	if (!lio_qr_cache) {
+		printk(KERN_ERR "nable to kmem_cache_create() for"
+				" lio_qr_cache\n");
+		goto cmd_out;
+	}
+
+	lio_dr_cache =3D kmem_cache_create("lio_dr_cache",
+			sizeof(struct iscsi_datain_req),
+			__alignof__(struct iscsi_datain_req), 0, NULL);
+	if (!lio_dr_cache) {
+		printk(KERN_ERR "Unable to kmem_cache_create() for"
+				" lio_dr_cache\n");
+		goto qr_out;
+	}
+
+	lio_ooo_cache =3D kmem_cache_create("lio_ooo_cache",
+			sizeof(struct iscsi_ooo_cmdsn),
+			__alignof__(struct iscsi_ooo_cmdsn), 0, NULL);
+	if (!lio_ooo_cache) {
+		printk(KERN_ERR "Unable to kmem_cache_create() for"
+				" lio_ooo_cache\n");
+		goto dr_out;
+	}
+
+	lio_r2t_cache =3D kmem_cache_create("lio_r2t_cache",
+			sizeof(struct iscsi_r2t), __alignof__(struct iscsi_r2t),
+			0, NULL);
+	if (!lio_r2t_cache) {
+		printk(KERN_ERR "Unable to kmem_cache_create() for"
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
+	cmd =3D iscsit_allocate_cmd(conn, GFP_KERNEL);
+	if (!cmd)
+		return -1;
+
+	cmd->iscsi_opcode =3D ISCSI_OP_REJECT;
+	if (fail_conn)
+		cmd->cmd_flags |=3D ICF_REJECT_FAIL_CONN;
+
+	hdr	=3D (struct iscsi_reject *) cmd->pdu;
+	hdr->reason =3D reason;
+
+	cmd->buf_ptr =3D kzalloc(ISCSI_HDR_LEN, GFP_KERNEL);
+	if (!cmd->buf_ptr) {
+		printk(KERN_ERR "Unable to allocate memory for cmd->buf_ptr\n");
+		iscsit_release_cmd(cmd);
+		return -1;
+	}
+	memcpy(cmd->buf_ptr, buf, ISCSI_HDR_LEN);
+
+	spin_lock_bh(&conn->cmd_lock);
+	list_add_tail(&cmd->i_list, &conn->conn_cmd_list);
+	spin_unlock_bh(&conn->cmd_lock);
+
+	cmd->i_state =3D ISTATE_SEND_REJECT;
+	iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
+
+	ret =3D wait_for_completion_interruptible(&cmd->reject_comp);
+	if (ret !=3D 0)
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
+		printk(KERN_ERR "cmd->conn is NULL for ITT: 0x%08x\n",
+				cmd->init_task_tag);
+		return -1;
+	}
+	conn =3D cmd->conn;
+
+	cmd->iscsi_opcode =3D ISCSI_OP_REJECT;
+	if (fail_conn)
+		cmd->cmd_flags |=3D ICF_REJECT_FAIL_CONN;
+
+	hdr	=3D (struct iscsi_reject *) cmd->pdu;
+	hdr->reason =3D reason;
+
+	cmd->buf_ptr =3D kzalloc(ISCSI_HDR_LEN, GFP_KERNEL);
+	if (!cmd->buf_ptr) {
+		printk(KERN_ERR "Unable to allocate memory for cmd->buf_ptr\n");
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
+	cmd->i_state =3D ISTATE_SEND_REJECT;
+	iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
+
+	ret =3D wait_for_completion_interruptible(&cmd->reject_comp);
+	if (ret !=3D 0)
+		return -1;
+
+	return (!fail_conn) ? 0 : -1;
+}
+
+static void iscsit_calculate_map_segment(
+	u32 *data_length,
+	struct se_offset_map *lm)
+{
+	u32 sg_offset =3D 0;
+	struct se_mem *se_mem =3D lm->map_se_mem;
+	/*
+	 * Still working on pages in the current struct se_mem.
+	 */
+	if (!lm->map_reset) {
+		lm->iovec_length =3D (lm->sg_length > PAGE_SIZE) ?
+					PAGE_SIZE : lm->sg_length;
+		if (*data_length < lm->iovec_length)
+			lm->iovec_length =3D *data_length;
+
+		lm->iovec_base =3D page_address(lm->sg_page) + sg_offset;
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
+	/*
+	 * Get the base and length of the current page for use with the iovec=
=2E
+	 */
+recalc:
+	lm->iovec_length =3D (lm->sg_length > (PAGE_SIZE - sg_offset)) ?
+			   (PAGE_SIZE - sg_offset) : lm->sg_length;
+	/*
+	 * See if there is any iSCSI offset we need to deal with.
+	 */
+	if (!lm->current_offset) {
+		lm->iovec_base =3D page_address(lm->sg_page) + sg_offset;
+
+		if (*data_length < lm->iovec_length)
+			lm->iovec_length =3D *data_length;
+
+		return;
+	}
+
+	/*
+	 * We know the iSCSI offset is in the next page of the current
+	 * scatterlist.  Increase the lm->sg_page pointer and try again.
+	 */
+	if (lm->current_offset >=3D lm->iovec_length) {
+		lm->current_offset -=3D lm->iovec_length;
+		lm->sg_length -=3D lm->iovec_length;
+		lm->sg_page++;
+		sg_offset =3D 0;
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
+	lm->iovec_base +=3D sg_offset;
+	lm->iovec_base +=3D lm->current_offset;
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
+}
+
+static int iscsit_get_offset(
+	struct se_offset_map *lmap,
+	struct se_unmap_sg *usg)
+{
+	u32 current_length =3D 0, current_iscsi_offset =3D lmap->iscsi_offset=
;
+	u32 total_offset =3D 0;
+	struct se_cmd *cmd =3D usg->se_cmd;
+	struct se_mem *se_mem;
+
+	list_for_each_entry(se_mem, cmd->t_task->t_mem_list, se_list)
+		break;
+
+	if (!se_mem) {
+		printk(KERN_ERR "Unable to locate se_mem from"
+				" cmd->t_task->t_mem_list\n");
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
+		if (total_offset > lmap->iscsi_offset) {
+			current_length +=3D current_iscsi_offset;
+			lmap->orig_offset =3D lmap->current_offset =3D
+				usg->t_offset =3D current_iscsi_offset;
+		} else {
+			current_length +=3D se_mem->se_len;
+			current_iscsi_offset -=3D se_mem->se_len;
+
+			list_for_each_entry_continue(se_mem,
+					cmd->t_task->t_mem_list, se_list)
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
+static int iscsit_set_iovec_ptrs(
+	struct se_map_sg *map_sg,
+	struct se_unmap_sg *unmap_sg)
+{
+	u32 i =3D 0 /* For iovecs */, j =3D 0 /* For scatterlists */;
+	struct se_cmd *cmd =3D map_sg->se_cmd;
+	struct iscsi_cmd *i_cmd =3D container_of(cmd, struct iscsi_cmd, se_cm=
d);
+	struct se_offset_map *lmap =3D &unmap_sg->lmap;
+	struct kvec *iov =3D map_sg->iov;
+
+	/*
+	 * Used for non scatterlist operations, assume a single iovec.
+	 */
+	if (!cmd->t_task->t_tasks_se_num) {
+		iov[0].iov_base =3D (unsigned char *) cmd->t_task->t_task_buf +
+							map_sg->data_offset;
+		iov[0].iov_len  =3D map_sg->data_length;
+		return 1;
+	}
+
+	/*
+	 * Set lmap->map_reset =3D 1 so the first call to
+	 * iscsit_calculate_map_segment() sets up the initial
+	 * values for struct se_offset_map.
+	 */
+	lmap->map_reset =3D 1;
+	/*
+	 * Get a pointer to the first used scatterlist based on the passed
+	 * offset. Also set the rest of the needed values in iscsi_linux_map_=
t.
+	 */
+	lmap->iscsi_offset =3D map_sg->data_offset;
+	if (map_sg->sg_kmap_active) {
+		unmap_sg->se_cmd =3D map_sg->se_cmd;
+		iscsit_get_offset(lmap, unmap_sg);
+		unmap_sg->data_length =3D map_sg->data_length;
+	} else {
+		lmap->current_offset =3D lmap->orig_offset;
+	}
+	lmap->map_se_mem =3D lmap->map_orig_se_mem;
+
+	while (map_sg->data_length) {
+		/*
+		 * Time to get the virtual address for use with iovec pointers.
+		 * This function will return the expected iovec_base address
+		 * and iovec_length.
+		 */
+		iscsit_calculate_map_segment(&map_sg->data_length, lmap);
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
+		} else
+			lmap->sg_page++;
+	}
+
+	unmap_sg->sg_count =3D j;
+
+	return i;
+}
+
+static void iscsit_map_SG_segments(struct se_unmap_sg *unmap_sg)
+{
+	u32 i =3D 0;
+	struct se_cmd *cmd =3D unmap_sg->se_cmd;
+	struct se_mem *se_mem =3D unmap_sg->cur_se_mem;
+
+	if (!cmd->t_task->t_tasks_se_num)
+		return;
+
+	list_for_each_entry_continue(se_mem, cmd->t_task->t_mem_list, se_list=
) {
+		kmap(se_mem->se_page);
+
+		if (++i =3D=3D unmap_sg->sg_count)
+			break;
+	}
+}
+
+static void iscsit_unmap_SG_segments(struct se_unmap_sg *unmap_sg)
+{
+	u32 i =3D 0;
+	struct se_cmd *cmd =3D unmap_sg->se_cmd;
+	struct se_mem *se_mem =3D unmap_sg->cur_se_mem;
+
+	if (!cmd->t_task->t_tasks_se_num)
+		return;
+
+	list_for_each_entry_continue(se_mem, cmd->t_task->t_mem_list, se_list=
) {
+		kunmap(se_mem->se_page);
+
+		if (++i =3D=3D unmap_sg->sg_count)
+			break;
+	}
+}
+
+static void iscsit_ack_from_expstatsn(struct iscsi_conn *conn, u32 exp=
_statsn)
+{
+	struct iscsi_cmd *cmd;
+
+	conn->exp_statsn =3D exp_statsn;
+
+	spin_lock_bh(&conn->cmd_lock);
+	list_for_each_entry(cmd, &conn->conn_cmd_list, i_list) {
+		spin_lock(&cmd->istate_lock);
+		if ((cmd->i_state =3D=3D ISTATE_SENT_STATUS) &&
+		    (cmd->stat_sn < exp_statsn)) {
+			cmd->i_state =3D ISTATE_REMOVE;
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
+static int iscsit_handle_scsi_cmd(
+	struct iscsi_conn *conn,
+	unsigned char *buf)
+{
+	int	data_direction, cmdsn_ret =3D 0, immed_ret, ret, transport_ret;
+	int	dump_immediate_data =3D 0, send_check_condition =3D 0, payload_le=
ngth;
+	struct iscsi_cmd	*cmd =3D NULL;
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
+	hdr			=3D (struct iscsi_scsi_req *) buf;
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
+		if ((hdr->cdb[0] =3D=3D 0x16) || (hdr->cdb[0] =3D=3D 0x17)) {
+			hdr->flags &=3D ~ISCSI_FLAG_CMD_READ;
+			hdr->flags &=3D ~ISCSI_FLAG_CMD_WRITE;
+			goto done;
+		}
+
+		printk(KERN_ERR "ISCSI_FLAG_CMD_READ or ISCSI_FLAG_CMD_WRITE"
+			" set when Expected Data Transfer Length is 0 for"
+			" CDB: 0x%02x. Bad iSCSI Initiator.\n", hdr->cdb[0]);
+		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
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
+		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
+				buf, conn);
+	}
+
+	if ((hdr->flags & ISCSI_FLAG_CMD_READ) &&
+	    (hdr->flags & ISCSI_FLAG_CMD_WRITE)) {
+		printk(KERN_ERR "Bidirectional operations not supported!\n");
+		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
+				buf, conn);
+	}
+
+	if (hdr->opcode & ISCSI_OP_IMMEDIATE) {
+		printk(KERN_ERR "Illegally set Immediate Bit in iSCSI Initiator"
+				" Scsi Command PDU.\n");
+		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
+				buf, conn);
+	}
+
+	if (payload_length && !conn->sess->sess_ops->ImmediateData) {
+		printk(KERN_ERR "ImmediateData=3DNo but DataSegmentLength=3D%u,"
+			" protocol error.\n", payload_length);
+		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+				buf, conn);
+	}
+
+	if ((hdr->data_length =3D=3D payload_length) &&
+	    (!(hdr->flags & ISCSI_FLAG_CMD_FINAL))) {
+		printk(KERN_ERR "Expected Data Transfer Length and Length of"
+			" Immediate Data are the same, but ISCSI_FLAG_CMD_FINAL"
+			" bit is not set protocol error\n");
+		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+				buf, conn);
+	}
+
+	if (payload_length > hdr->data_length) {
+		printk(KERN_ERR "DataSegmentLength: %u is greater than"
+			" EDTL: %u, protocol error.\n", payload_length,
+				hdr->data_length);
+		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+				buf, conn);
+	}
+
+	if (payload_length > conn->conn_ops->MaxRecvDataSegmentLength) {
+		printk(KERN_ERR "DataSegmentLength: %u is greater than"
+			" MaxRecvDataSegmentLength: %u, protocol error.\n",
+			payload_length, conn->conn_ops->MaxRecvDataSegmentLength);
+		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+				buf, conn);
+	}
+
+	if (payload_length > conn->sess->sess_ops->FirstBurstLength) {
+		printk(KERN_ERR "DataSegmentLength: %u is greater than"
+			" FirstBurstLength: %u, protocol error.\n",
+			payload_length, conn->sess->sess_ops->FirstBurstLength);
+		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
+					buf, conn);
+	}
+
+	data_direction =3D (hdr->flags & ISCSI_FLAG_CMD_WRITE) ? DMA_TO_DEVIC=
E :
+			 (hdr->flags & ISCSI_FLAG_CMD_READ) ? DMA_FROM_DEVICE :
+			  DMA_NONE;
+
+	cmd =3D iscsit_allocate_se_cmd(conn, hdr->data_length, data_direction=
,
+				(hdr->flags & ISCSI_FLAG_CMD_ATTR_MASK));
+	if (!cmd)
+		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_NO_RESOURCES, 1,
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
+	conn->sess->init_task_tag =3D cmd->init_task_tag =3D hdr->itt;
+	if (hdr->flags & ISCSI_FLAG_CMD_READ) {
+		spin_lock_bh(&conn->sess->ttt_lock);
+		cmd->targ_xfer_tag =3D conn->sess->targ_xfer_tag++;
+		if (cmd->targ_xfer_tag =3D=3D 0xFFFFFFFF)
+			cmd->targ_xfer_tag =3D conn->sess->targ_xfer_tag++;
+		spin_unlock_bh(&conn->sess->ttt_lock);
+	} else if (hdr->flags & ISCSI_FLAG_CMD_WRITE)
+		cmd->targ_xfer_tag =3D 0xFFFFFFFF;
+	cmd->cmd_sn		=3D hdr->cmdsn;
+	cmd->exp_stat_sn	=3D hdr->exp_statsn;
+	cmd->first_burst_len	=3D payload_length;
+
+	if (cmd->data_direction =3D=3D DMA_FROM_DEVICE) {
+		struct iscsi_datain_req *dr;
+
+		dr =3D iscsit_allocate_datain_req();
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
+	ret =3D iscsit_get_lun_for_cmd(cmd, hdr->cdb,
+				get_unaligned_le64(&hdr->lun[0]));
+	if (ret < 0) {
+		if (SE_CMD(cmd)->scsi_sense_reason =3D=3D TCM_NON_EXISTENT_LUN) {
+			TRACE(TRACE_VANITY, "Responding to non-acl'ed,"
+				" non-existent or non-exported iSCSI LUN:"
+				" 0x%016Lx\n", get_unaligned_le64(&hdr->lun[0]));
+		}
+		if (ret =3D=3D PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES)
+			return iscsit_add_reject_from_cmd(
+					ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+					1, 1, buf, cmd);
+
+		send_check_condition =3D 1;
+		goto attach_cmd;
+	}
+	/*
+	 * The Initiator Node has access to the LUN (the addressing method
+	 * is handled inside of iscsit_get_lun_for_cmd()).  Now it's time to
+	 * allocate 1->N transport tasks (depending on sector count and
+	 * maximum request size the physical HBA(s) can handle.
+	 */
+	transport_ret =3D transport_generic_allocate_tasks(SE_CMD(cmd), hdr->=
cdb);
+	if (transport_ret =3D=3D -ENOMEM) {
+		return iscsit_add_reject_from_cmd(
+				ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+				1, 1, buf, cmd);
+	} else if (transport_ret =3D=3D -EINVAL) {
+		/*
+		 * Unsupported SAM Opcode.  CHECK_CONDITION will be sent
+		 * in iscsit_execute_cmd() during the CmdSN OOO Execution
+		 * Mechinism.
+		 */
+		send_check_condition =3D 1;
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
+		cmdsn_ret =3D iscsit_check_received_cmdsn(conn,
+				cmd, hdr->cmdsn);
+		if ((cmdsn_ret =3D=3D CMDSN_NORMAL_OPERATION) ||
+		    (cmdsn_ret =3D=3D CMDSN_HIGHER_THAN_EXP))
+			do {} while (0);
+		else if (cmdsn_ret =3D=3D CMDSN_LOWER_THAN_EXP) {
+			cmd->i_state =3D ISTATE_REMOVE;
+			iscsit_add_cmd_to_immediate_queue(cmd,
+					conn, cmd->i_state);
+			return 0;
+		} else { /* (cmdsn_ret =3D=3D CMDSN_ERROR_CANNOT_RECOVER) */
+			return iscsit_add_reject_from_cmd(
+					ISCSI_REASON_PROTOCOL_ERROR,
+					1, 0, buf, cmd);
+		}
+	}
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
+	wait_for_completion(&cmd->unsolicited_data_comp);
+
+	if (SE_CMD(cmd)->se_cmd_flags & SCF_SE_CMD_FAILED) {
+		immed_ret =3D IMMEDIDATE_DATA_NORMAL_OPERATION;
+		dump_immediate_data =3D 1;
+		goto after_immediate_data;
+	}
+
+	immed_ret =3D iscsit_handle_immediate_data(cmd, buf, payload_length);
+after_immediate_data:
+	if (immed_ret =3D=3D IMMEDIDATE_DATA_NORMAL_OPERATION) {
+		/*
+		 * A PDU/CmdSN carrying Immediate Data passed
+		 * DataCRC, check against ExpCmdSN/MaxCmdSN if
+		 * Immediate Bit is not set.
+		 */
+		cmdsn_ret =3D iscsit_check_received_cmdsn(conn,
+				cmd, hdr->cmdsn);
+		/*
+		 * Special case for Unsupported SAM WRITE Opcodes
+		 * and ImmediateData=3DYes.
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
+		if (cmdsn_ret =3D=3D CMDSN_NORMAL_OPERATION)
+			return 0;
+		else if (cmdsn_ret =3D=3D CMDSN_HIGHER_THAN_EXP)
+			return 0;
+		else if (cmdsn_ret =3D=3D CMDSN_LOWER_THAN_EXP) {
+			cmd->i_state =3D ISTATE_REMOVE;
+			iscsit_add_cmd_to_immediate_queue(cmd,
+					conn, cmd->i_state);
+			return 0;
+		} else { /* (cmdsn_ret =3D=3D CMDSN_ERROR_CANNOT_RECOVER) */
+			return iscsit_add_reject_from_cmd(
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
+		iscsit_add_cmd_to_immediate_queue(cmd, conn, cmd->i_state);
+	} else /* immed_ret =3D=3D IMMEDIDATE_DATA_CANNOT_RECOVER */
+		return -1;
+
+	return 0;
+}
+
+static void iscsit_do_crypto_hash_iovec(
+	struct hash_desc *hash,
+	struct kvec *iov,
+	u32 counter,
+	u32 padding,
+	u8 *pad_bytes,
+	u8 *data_crc)
+{
+	struct scatterlist sg;
+	struct kvec *iov_ptr =3D iov;
+
+	crypto_hash_init(hash);
+
+	while (counter > 0) {
+		sg_init_one(&sg, iov_ptr->iov_base,
+				iov_ptr->iov_len);
+		crypto_hash_update(hash, &sg, iov_ptr->iov_len);
+	=09
+		counter -=3D iov_ptr->iov_len;
+		iov_ptr++;
+	}
+
+	if (padding) {
+		sg_init_one(&sg, pad_bytes, padding);
+		crypto_hash_update(hash, &sg, padding);
+	}
+	crypto_hash_final(hash, data_crc);
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
+static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned ch=
ar *buf)
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
+	struct kvec *iov;
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
+		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+					buf, conn);
+	}
+
+	/* iSCSI write */
+	spin_lock_bh(&conn->sess->session_stats_lock);
+	conn->sess->rx_data_octets +=3D payload_length;
+	if (conn->sess->se_sess->se_node_acl) {
+		spin_lock(&conn->sess->se_sess->se_node_acl->stats_lock);
+		conn->sess->se_sess->se_node_acl->write_bytes +=3D payload_length;
+		spin_unlock(&conn->sess->se_sess->se_node_acl->stats_lock);
+	}
+	spin_unlock_bh(&conn->sess->session_stats_lock);
+
+	if (payload_length > conn->conn_ops->MaxRecvDataSegmentLength) {
+		printk(KERN_ERR "DataSegmentLength: %u is greater than"
+			" MaxRecvDataSegmentLength: %u\n", payload_length,
+			conn->conn_ops->MaxRecvDataSegmentLength);
+		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+					buf, conn);
+	}
+
+	cmd =3D iscsit_find_cmd_from_itt_or_dump(conn, hdr->itt,
+			payload_length);
+	if (!cmd)
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
+		return iscsit_dump_data_payload(conn, payload_length, 1);
+	}
+
+	if (cmd->data_direction !=3D DMA_TO_DEVICE) {
+		printk(KERN_ERR "Command ITT: 0x%08x received DataOUT for a"
+			" NON-WRITE command.\n", cmd->init_task_tag);
+		return iscsit_add_reject_from_cmd(ISCSI_REASON_PROTOCOL_ERROR,
+				1, 0, buf, cmd);
+	}
+	se_cmd =3D SE_CMD(cmd);
+	iscsit_mod_dataout_timer(cmd);
+
+	if ((hdr->offset + payload_length) > cmd->data_length) {
+		printk(KERN_ERR "DataOut Offset: %u, Length %u greater than"
+			" iSCSI Command EDTL %u, protocol error.\n",
+			hdr->offset, payload_length, cmd->data_length);
+		return iscsit_add_reject_from_cmd(ISCSI_REASON_BOOKMARK_INVALID,
+				1, 0, buf, cmd);
+	}
+
+	if (cmd->unsolicited_data) {
+		int dump_unsolicited_data =3D 0, wait_for_transport =3D 0;
+
+		if (conn->sess->sess_ops->InitialR2T) {
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
+		spin_lock_irqsave(&se_cmd->t_task->t_state_lock, flags);
+		/*
+		 * Handle cases where we do or do not want to sleep on
+		 * unsolicited_data_comp
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
+		    (atomic_read(&se_cmd->t_task->t_transport_aborted) !=3D 0))
+			wait_for_transport =3D 0;
+		spin_unlock_irqrestore(&se_cmd->t_task->t_state_lock, flags);
+
+		if (wait_for_transport)
+			wait_for_completion(&cmd->unsolicited_data_comp);
+
+		spin_lock_irqsave(&se_cmd->t_task->t_state_lock, flags);
+		if (!(se_cmd->se_cmd_flags & SCF_SUPPORTED_SAM_OPCODE) ||
+		     (se_cmd->se_cmd_flags & SCF_SE_CMD_FAILED))
+			dump_unsolicited_data =3D 1;
+		spin_unlock_irqrestore(&se_cmd->t_task->t_state_lock, flags);
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
+		if (atomic_read(&se_cmd->t_task->t_transport_aborted) !=3D 0) {
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
+	ret =3D iscsit_check_pre_dataout(cmd, buf);
+	if (ret =3D=3D DATAOUT_WITHIN_COMMAND_RECOVERY)
+		return 0;
+	else if (ret =3D=3D DATAOUT_CANNOT_RECOVER)
+		return -1;
+
+	rx_size +=3D payload_length;
+	iov =3D &cmd->iov_data[0];
+
+	memset(&map_sg, 0, sizeof(struct se_map_sg));
+	memset(&unmap_sg, 0, sizeof(struct se_unmap_sg));
+	map_sg.fabric_cmd =3D (void *)cmd;
+	map_sg.se_cmd =3D SE_CMD(cmd);
+	map_sg.iov =3D iov;
+	map_sg.sg_kmap_active =3D 1;
+	map_sg.data_length =3D payload_length;
+	map_sg.data_offset =3D hdr->offset;
+	unmap_sg.fabric_cmd =3D (void *)cmd;
+	unmap_sg.se_cmd =3D SE_CMD(cmd);
+
+	iov_ret =3D iscsit_set_iovec_ptrs(&map_sg, &unmap_sg);
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
+	if (conn->conn_ops->DataDigest) {
+		iov[iov_count].iov_base =3D &checksum;
+		iov[iov_count++].iov_len =3D ISCSI_CRC_LEN;
+		rx_size +=3D ISCSI_CRC_LEN;
+	}
+
+	iscsit_map_SG_segments(&unmap_sg);
+
+	rx_got =3D rx_data(conn, &cmd->iov_data[0], iov_count, rx_size);
+
+	iscsit_unmap_SG_segments(&unmap_sg);
+
+	if (rx_got !=3D rx_size)
+		return -1;
+
+	if (conn->conn_ops->DataDigest) {
+		u32 counter =3D payload_length, data_crc =3D 0;
+		struct kvec *iov_ptr =3D &cmd->iov_data[0];
+		/*
+		 * Thanks to the IP stack shitting on passed iovecs,  we have to
+		 * call set_iovec_data_ptrs() again in order to have a iMD/PSCSI
+		 * agnostic way of doing datadigests computations.
+		 */
+		memset(&map_sg, 0, sizeof(struct se_map_sg));
+		map_sg.fabric_cmd =3D (void *)cmd;
+		map_sg.se_cmd =3D SE_CMD(cmd);
+		map_sg.iov =3D iov_ptr;
+		map_sg.data_length =3D payload_length;
+		map_sg.data_offset =3D hdr->offset;
+
+		if (iscsit_set_iovec_ptrs(&map_sg, &unmap_sg) < 0)
+			return -1;
+
+		iscsit_do_crypto_hash_iovec(&conn->conn_rx_hash,
+				iov_ptr, counter, padding,
+				(u8 *)&pad_bytes, (u8 *)&data_crc);
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
+	ret =3D iscsit_check_post_dataout(cmd, buf, data_crc_failed);
+	if ((ret =3D=3D DATAOUT_NORMAL) || (ret =3D=3D DATAOUT_WITHIN_COMMAND=
_RECOVERY))
+		return 0;
+	else if (ret =3D=3D DATAOUT_SEND_R2T) {
+		iscsit_set_dataout_sequence_values(cmd);
+		iscsit_build_r2ts_for_cmd(cmd, conn, 0);
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
+		iscsit_stop_dataout_timer(cmd);
+		return (!ooo_cmdsn) ? transport_generic_handle_data(
+					SE_CMD(cmd)) : 0;
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
+	unsigned char *ping_data =3D NULL;
+	int cmdsn_ret, niov =3D 0, ret =3D 0, rx_got, rx_size;
+	u32 checksum, data_crc, padding =3D 0, payload_length;
+	u64 lun;
+	struct iscsi_cmd *cmd =3D NULL;
+	struct kvec *iov =3D NULL;
+	struct iscsi_nopout *hdr;
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
+		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+					buf, conn);
+	}
+
+	if (payload_length > conn->conn_ops->MaxRecvDataSegmentLength) {
+		printk(KERN_ERR "NOPOUT Ping Data DataSegmentLength: %u is"
+			" greater than MaxRecvDataSegmentLength: %u, protocol"
+			" error.\n", payload_length,
+			conn->conn_ops->MaxRecvDataSegmentLength);
+		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
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
+		cmd =3D iscsit_allocate_cmd(conn, GFP_KERNEL);
+		if (!cmd)
+			return iscsit_add_reject(
+					ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+					1, buf, conn);
+
+		cmd->iscsi_opcode	=3D ISCSI_OP_NOOP_OUT;
+		cmd->i_state		=3D ISTATE_SEND_NOPIN;
+		cmd->immediate_cmd	=3D ((hdr->opcode & ISCSI_OP_IMMEDIATE) ?
+						1 : 0);
+		conn->sess->init_task_tag =3D cmd->init_task_tag =3D hdr->itt;
+		cmd->targ_xfer_tag	=3D 0xFFFFFFFF;
+		cmd->cmd_sn		=3D hdr->cmdsn;
+		cmd->exp_stat_sn	=3D hdr->exp_statsn;
+		cmd->data_direction	=3D DMA_NONE;
+	}
+
+	if (payload_length && (hdr->ttt =3D=3D 0xFFFFFFFF)) {
+		rx_size =3D payload_length;
+		ping_data =3D kzalloc(payload_length + 1, GFP_KERNEL);
+		if (!ping_data) {
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
+		if (conn->conn_ops->DataDigest) {
+			iov[niov].iov_base	=3D &checksum;
+			iov[niov++].iov_len	=3D ISCSI_CRC_LEN;
+			rx_size +=3D ISCSI_CRC_LEN;
+		}
+
+		rx_got =3D rx_data(conn, &cmd->iov_misc[0], niov, rx_size);
+		if (rx_got !=3D rx_size) {
+			ret =3D -1;
+			goto out;
+		}
+
+		if (conn->conn_ops->DataDigest) {
+			iscsit_do_crypto_hash_buf(&conn->conn_rx_hash,
+					ping_data, payload_length,
+					padding, (u8 *)&cmd->pad_bytes,
+					(u8 *)&data_crc);
+
+			if (checksum !=3D data_crc) {
+				printk(KERN_ERR "Ping data CRC32C DataDigest"
+				" 0x%08x does not match computed 0x%08x\n",
+					checksum, data_crc);
+				if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
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
+		cmdsn_ret =3D iscsit_check_received_cmdsn(conn, cmd, hdr->cmdsn);
+		if ((cmdsn_ret =3D=3D CMDSN_NORMAL_OPERATION) ||
+		    (cmdsn_ret =3D=3D CMDSN_HIGHER_THAN_EXP)) {
+			return 0;
+		} else if (cmdsn_ret =3D=3D CMDSN_LOWER_THAN_EXP) {
+			cmd->i_state =3D ISTATE_REMOVE;
+			iscsit_add_cmd_to_immediate_queue(cmd, conn,
+					cmd->i_state);
+			ret =3D 0;
+			goto ping_out;
+		} else { /* (cmdsn_ret =3D=3D CMDSN_ERROR_CANNOT_RECOVER) */
+			return iscsit_add_reject_from_cmd(
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
+		cmd =3D iscsit_find_cmd_from_ttt(conn, hdr->ttt);
+		if (!cmd)
+			return -1;
+
+		iscsit_stop_nopin_response_timer(conn);
+
+		cmd->i_state =3D ISTATE_REMOVE;
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
+		ret =3D 0;
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
+		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+					buf, conn);
+	}
+	if ((function !=3D ISCSI_TM_FUNC_ABORT_TASK) &&
+	    (hdr->refcmdsn !=3D ISCSI_RESERVED_TAG))
+		hdr->refcmdsn =3D ISCSI_RESERVED_TAG;
+
+	cmd =3D iscsit_allocate_se_cmd_for_tmr(conn, function);
+	if (!cmd)
+		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_NO_RESOURCES,
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
+		ret =3D iscsit_get_lun_for_tmr(cmd,
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
+		se_tmr->response =3D iscsit_tmr_abort_task(cmd, buf);
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
+		if (iscsit_tmr_task_warm_reset(conn, tmr_req, buf) < 0) {
+			SE_CMD(cmd)->se_cmd_flags |=3D SCF_SCSI_CDB_EXCEPTION;
+			se_tmr->response =3D ISCSI_TMF_RSP_AUTH_FAILED;
+			goto attach;
+		}
+		break;
+	case ISCSI_TM_FUNC_TARGET_COLD_RESET:
+		if (iscsit_tmr_task_cold_reset(conn, tmr_req, buf) < 0) {
+			SE_CMD(cmd)->se_cmd_flags |=3D SCF_SCSI_CDB_EXCEPTION;
+			se_tmr->response =3D ISCSI_TMF_RSP_AUTH_FAILED;
+			goto attach;
+		}
+		break;
+	case ISCSI_TM_FUNC_TASK_REASSIGN:
+		se_tmr->response =3D iscsit_tmr_task_reassign(cmd, buf);
+		/*
+		 * Perform sanity checks on the ExpDataSN only if the
+		 * TASK_REASSIGN was successful.
+		 */
+		if (se_tmr->response !=3D ISCSI_TMF_RSP_COMPLETE)
+			break;
+
+		if (iscsit_check_task_reassign_expdatasn(tmr_req, conn) < 0)
+			return iscsit_add_reject_from_cmd(
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
+	spin_lock_bh(&conn->cmd_lock);
+	list_add_tail(&cmd->i_list, &conn->conn_cmd_list);
+	spin_unlock_bh(&conn->cmd_lock);
+
+	if (!(hdr->opcode & ISCSI_OP_IMMEDIATE)) {
+		cmdsn_ret =3D iscsit_check_received_cmdsn(conn,
+				cmd, hdr->cmdsn);
+		if (cmdsn_ret =3D=3D CMDSN_NORMAL_OPERATION)
+			do {} while (0);
+		else if (cmdsn_ret =3D=3D CMDSN_HIGHER_THAN_EXP)
+			out_of_order_cmdsn =3D 1;
+		else if (cmdsn_ret =3D=3D CMDSN_LOWER_THAN_EXP) {
+			cmd->i_state =3D ISTATE_REMOVE;
+			iscsit_add_cmd_to_immediate_queue(cmd, conn,
+					cmd->i_state);
+			return 0;
+		} else { /* (cmdsn_ret =3D=3D CMDSN_ERROR_CANNOT_RECOVER) */
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
+	iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
+	return 0;
+}
+
+/* #warning FIXME: Support Text Command parameters besides SendTargets=
 */
+static int iscsit_handle_text_cmd(
+	struct iscsi_conn *conn,
+	unsigned char *buf)
+{
+	char *text_ptr, *text_in;
+	int cmdsn_ret, niov =3D 0, rx_got, rx_size;
+	u32 checksum =3D 0, data_crc =3D 0, payload_length;
+	u32 padding =3D 0, pad_bytes =3D 0, text_length =3D 0;
+	struct iscsi_cmd *cmd;
+	struct kvec iov[3];
+	struct iscsi_text *hdr;
+
+	hdr			=3D (struct iscsi_text *) buf;
+	payload_length		=3D ntoh24(hdr->dlength);
+	hdr->itt		=3D be32_to_cpu(hdr->itt);
+	hdr->ttt		=3D be32_to_cpu(hdr->ttt);
+	hdr->cmdsn		=3D be32_to_cpu(hdr->cmdsn);
+	hdr->exp_statsn		=3D be32_to_cpu(hdr->exp_statsn);
+
+	if (payload_length > conn->conn_ops->MaxRecvDataSegmentLength) {
+		printk(KERN_ERR "Unable to accept text parameter length: %u"
+			"greater than MaxRecvDataSegmentLength %u.\n",
+		       payload_length, conn->conn_ops->MaxRecvDataSegmentLength);
+		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
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
+		if (!text_in) {
+			printk(KERN_ERR "Unable to allocate memory for"
+				" incoming text parameters\n");
+			return -1;
+		}
+
+		memset(iov, 0, 3 * sizeof(struct kvec));
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
+		if (conn->conn_ops->DataDigest) {
+			iov[niov].iov_base	=3D &checksum;
+			iov[niov++].iov_len	=3D ISCSI_CRC_LEN;
+			rx_size +=3D ISCSI_CRC_LEN;
+		}
+
+		rx_got =3D rx_data(conn, &iov[0], niov, rx_size);
+		if (rx_got !=3D rx_size) {
+			kfree(text_in);
+			return -1;
+		}
+
+		if (conn->conn_ops->DataDigest) {
+			iscsit_do_crypto_hash_buf(&conn->conn_rx_hash,
+					text_in, text_length,
+					padding, (u8 *)&pad_bytes,
+					(u8 *)&data_crc);
+
+			if (checksum !=3D data_crc) {
+				printk(KERN_ERR "Text data CRC32C DataDigest"
+					" 0x%08x does not match computed"
+					" 0x%08x\n", checksum, data_crc);
+				if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
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
+		if (!text_ptr) {
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
+	cmd =3D iscsit_allocate_cmd(conn, GFP_KERNEL);
+	if (!cmd)
+		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+					1, buf, conn);
+
+	cmd->iscsi_opcode	=3D ISCSI_OP_TEXT;
+	cmd->i_state		=3D ISTATE_SEND_TEXTRSP;
+	cmd->immediate_cmd	=3D ((hdr->opcode & ISCSI_OP_IMMEDIATE) ? 1 : 0);
+	conn->sess->init_task_tag =3D cmd->init_task_tag	=3D hdr->itt;
+	cmd->targ_xfer_tag	=3D 0xFFFFFFFF;
+	cmd->cmd_sn		=3D hdr->cmdsn;
+	cmd->exp_stat_sn	=3D hdr->exp_statsn;
+	cmd->data_direction	=3D DMA_NONE;
+
+	spin_lock_bh(&conn->cmd_lock);
+	list_add_tail(&cmd->i_list, &conn->conn_cmd_list);
+	spin_unlock_bh(&conn->cmd_lock);
+
+	iscsit_ack_from_expstatsn(conn, hdr->exp_statsn);
+
+	if (!(hdr->opcode & ISCSI_OP_IMMEDIATE)) {
+		cmdsn_ret =3D iscsit_check_received_cmdsn(conn, cmd, hdr->cmdsn);
+		if ((cmdsn_ret =3D=3D CMDSN_NORMAL_OPERATION) ||
+		     (cmdsn_ret =3D=3D CMDSN_HIGHER_THAN_EXP))
+			return 0;
+		else if (cmdsn_ret =3D=3D CMDSN_LOWER_THAN_EXP) {
+			iscsit_add_cmd_to_immediate_queue(cmd, conn,
+						ISTATE_REMOVE);
+			return 0;
+		} else { /* (cmdsn_ret =3D=3D CMDSN_ERROR_CANNOT_RECOVER) */
+			return iscsit_add_reject_from_cmd(
+					ISCSI_REASON_PROTOCOL_ERROR,
+					1, 0, buf, cmd);
+		}
+
+		return 0;
+	}
+
+	return iscsit_execute_cmd(cmd, 0);
+}
+
+int iscsit_logout_closesession(struct iscsi_cmd *cmd, struct iscsi_con=
n *conn)
+{
+	struct iscsi_conn *conn_p;
+	struct iscsi_session *sess =3D conn->sess;
+
+	TRACE(TRACE_ISCSI, "Received logout request CLOSESESSION on CID: %hu"
+		" for SID: %u.\n", conn->cid, conn->sess->sid);
+
+	atomic_set(&sess->session_logout, 1);
+	atomic_set(&conn->conn_logout_remove, 1);
+	conn->conn_logout_reason =3D ISCSI_LOGOUT_REASON_CLOSE_SESSION;
+
+	iscsit_inc_conn_usage_count(conn);
+	iscsit_inc_session_usage_count(sess);
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
+	iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
+
+	return 0;
+}
+
+int iscsit_logout_closeconnection(struct iscsi_cmd *cmd, struct iscsi_=
conn *conn)
+{
+	struct iscsi_conn *l_conn;
+	struct iscsi_session *sess =3D conn->sess;
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
+		l_conn =3D iscsit_get_conn_from_cid(sess,
+				cmd->logout_cid);
+		if (!l_conn) {
+			cmd->logout_response =3D ISCSI_LOGOUT_CID_NOT_FOUND;
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
+int iscsit_logout_removeconnforrecovery(struct iscsi_cmd *cmd, struct =
iscsi_conn *conn)
+{
+	struct iscsi_session *sess =3D conn->sess;
+
+	TRACE(TRACE_ERL2, "Received explicit REMOVECONNFORRECOVERY logout for=
"
+		" CID: %hu on CID: %hu.\n", cmd->logout_cid, conn->cid);
+
+	if (sess->sess_ops->ErrorRecoveryLevel !=3D 2) {
+		printk(KERN_ERR "Received Logout Request REMOVECONNFORRECOVERY"
+			" while ERL!=3D2.\n");
+		cmd->logout_response =3D ISCSI_LOGOUT_RECOVERY_UNSUPPORTED;
+		iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
+		return 0;
+	}
+
+	if (conn->cid =3D=3D cmd->logout_cid) {
+		printk(KERN_ERR "Received Logout Request REMOVECONNFORRECOVERY"
+			" with CID: %hu on CID: %hu, implementation error.\n",
+				cmd->logout_cid, conn->cid);
+		cmd->logout_response =3D ISCSI_LOGOUT_CLEANUP_FAILED;
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
+	int cmdsn_ret, logout_remove =3D 0;
+	u8 reason_code =3D 0;
+	struct iscsi_cmd *cmd;
+	struct iscsi_logout *hdr;
+	struct iscsi_tiqn *tiqn =3D iscsit_snmp_get_tiqn(conn);
+
+	hdr			=3D (struct iscsi_logout *) buf;
+	reason_code		=3D (hdr->flags & 0x7f);
+	hdr->itt		=3D be32_to_cpu(hdr->itt);
+	hdr->cid		=3D be16_to_cpu(hdr->cid);
+	hdr->cmdsn		=3D be32_to_cpu(hdr->cmdsn);
+	hdr->exp_statsn	=3D be32_to_cpu(hdr->exp_statsn);
+
+	if (tiqn) {
+		spin_lock(&tiqn->logout_stats.lock);
+		if (reason_code =3D=3D ISCSI_LOGOUT_REASON_CLOSE_SESSION)
+			tiqn->logout_stats.normal_logouts++;
+		else
+			tiqn->logout_stats.abnormal_logouts++;
+		spin_unlock(&tiqn->logout_stats.lock);
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
+	cmd =3D iscsit_allocate_cmd(conn, GFP_KERNEL);
+	if (!cmd)
+		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_NO_RESOURCES, 1,
+					buf, conn);
+
+	cmd->iscsi_opcode       =3D ISCSI_OP_LOGOUT;
+	cmd->i_state            =3D ISTATE_SEND_LOGOUTRSP;
+	cmd->immediate_cmd      =3D ((hdr->opcode & ISCSI_OP_IMMEDIATE) ? 1 :=
 0);
+	conn->sess->init_task_tag =3D cmd->init_task_tag  =3D hdr->itt;
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
+	spin_lock_bh(&conn->cmd_lock);
+	list_add_tail(&cmd->i_list, &conn->conn_cmd_list);
+	spin_unlock_bh(&conn->cmd_lock);
+
+	if (reason_code !=3D ISCSI_LOGOUT_REASON_RECOVERY)
+		iscsit_ack_from_expstatsn(conn, hdr->exp_statsn);
+
+	/*
+	 * Non-Immediate Logout Commands are executed in CmdSN order..
+	 */
+	if (!(hdr->opcode & ISCSI_OP_IMMEDIATE)) {
+		cmdsn_ret =3D iscsit_check_received_cmdsn(conn, cmd, hdr->cmdsn);
+		if ((cmdsn_ret =3D=3D CMDSN_NORMAL_OPERATION) ||
+		    (cmdsn_ret =3D=3D CMDSN_HIGHER_THAN_EXP))
+			return logout_remove;
+		else if (cmdsn_ret =3D=3D CMDSN_LOWER_THAN_EXP) {
+			cmd->i_state =3D ISTATE_REMOVE;
+			iscsit_add_cmd_to_immediate_queue(cmd, conn,
+					cmd->i_state);
+			return 0;
+		} else { /* (cmdsn_ret =3D=3D CMDSN_ERROR_CANNOT_RECOVER) */
+			return iscsit_add_reject_from_cmd(
+					ISCSI_REASON_PROTOCOL_ERROR,
+					1, 0, buf, cmd);
+		}
+	}
+	/*
+	 * Immediate Logout Commands are executed, well, Immediately.
+	 */
+	if (iscsit_execute_cmd(cmd, 0) < 0)
+		return -1;
+
+	return logout_remove;
+}
+
+static int iscsit_handle_snack(
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
+	unpacked_lun		=3D scsilun_to_int((struct scsi_lun *)&lun);
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
+	if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
+		printk(KERN_ERR "Initiator sent SNACK request while in"
+			" ErrorRecoveryLevel=3D0.\n");
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
+		printk(KERN_ERR "R-Data SNACK Not Supported.\n");
+		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
+					buf, conn);
+	default:
+		printk(KERN_ERR "Unknown SNACK type 0x%02x, protocol"
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
+	int iov_ret, rx_got =3D 0, rx_size =3D 0;
+	u32 checksum, iov_count =3D 0, padding =3D 0, pad_bytes =3D 0;
+	struct iscsi_conn *conn =3D cmd->conn;
+	struct se_map_sg map_sg;
+	struct se_unmap_sg unmap_sg;
+	struct kvec *iov;
+
+	memset(&map_sg, 0, sizeof(struct se_map_sg));
+	memset(&unmap_sg, 0, sizeof(struct se_unmap_sg));
+	map_sg.fabric_cmd =3D (void *)cmd;
+	map_sg.se_cmd =3D SE_CMD(cmd);
+	map_sg.sg_kmap_active =3D 1;
+	map_sg.iov =3D &cmd->iov_data[0];
+	map_sg.data_length =3D length;
+	map_sg.data_offset =3D cmd->write_data_done;
+	unmap_sg.fabric_cmd =3D (void *)cmd;
+	unmap_sg.se_cmd =3D SE_CMD(cmd);
+
+	iov_ret =3D iscsit_set_iovec_ptrs(&map_sg, &unmap_sg);
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
+	if (conn->conn_ops->DataDigest) {
+		iov[iov_count].iov_base		=3D &checksum;
+		iov[iov_count++].iov_len	=3D ISCSI_CRC_LEN;
+		rx_size +=3D ISCSI_CRC_LEN;
+	}
+
+	iscsit_map_SG_segments(&unmap_sg);
+
+	rx_got =3D rx_data(conn, &cmd->iov_data[0], iov_count, rx_size);
+
+	iscsit_unmap_SG_segments(&unmap_sg);
+
+	if (rx_got !=3D rx_size) {
+		iscsit_rx_thread_wait_for_tcp(conn);
+		return IMMEDIDATE_DATA_CANNOT_RECOVER;
+	}
+
+	if (conn->conn_ops->DataDigest) {
+		u32 counter =3D length, data_crc;
+		struct kvec *iov_ptr =3D &cmd->iov_data[0];
+		/*
+		 * Thanks to the IP stack shitting on passed iovecs,  we have to
+		 * call set_iovec_data_ptrs again in order to have a iMD/PSCSI
+		 * agnostic way of doing datadigests computations.
+		 */
+		memset(&map_sg, 0, sizeof(struct se_map_sg));
+		map_sg.fabric_cmd =3D (void *)cmd;
+		map_sg.se_cmd =3D SE_CMD(cmd);
+		map_sg.iov =3D iov_ptr;
+		map_sg.data_length =3D length;
+		map_sg.data_offset =3D cmd->write_data_done;
+
+		if (iscsit_set_iovec_ptrs(&map_sg, &unmap_sg) < 0)
+			return IMMEDIDATE_DATA_CANNOT_RECOVER;
+
+		iscsit_do_crypto_hash_iovec(&conn->conn_rx_hash, iov_ptr,
+					counter, padding,
+					(u8 *)&pad_bytes, (u8 *)&data_crc);
+
+		if (checksum !=3D data_crc) {
+			printk(KERN_ERR "ImmediateData CRC32C DataDigest 0x%08x"
+				" does not match computed 0x%08x\n", checksum,
+				data_crc);
+
+			if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
+				printk(KERN_ERR "Unable to recover from"
+					" Immediate Data digest failure while"
+					" in ERL=3D0.\n");
+				iscsit_add_reject_from_cmd(
+						ISCSI_REASON_DATA_DIGEST_ERROR,
+						1, 0, buf, cmd);
+				return IMMEDIDATE_DATA_CANNOT_RECOVER;
+			} else {
+				iscsit_add_reject_from_cmd(
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
+int iscsit_send_async_msg(
+	struct iscsi_conn *conn,
+	u16 cid,
+	u8 async_event,
+	u8 async_vcode)
+{
+	u8 iscsi_hdr[ISCSI_HDR_LEN+ISCSI_CRC_LEN];
+	u32 tx_send =3D ISCSI_HDR_LEN, tx_sent =3D 0;
+	struct iscsi_async *hdr;
+	struct kvec iov;
+
+	memset(&iov, 0, sizeof(struct kvec));
+	memset(&iscsi_hdr, 0, ISCSI_HDR_LEN+ISCSI_CRC_LEN);
+
+	hdr		=3D (struct iscsi_async *)&iscsi_hdr;
+	hdr->opcode	=3D ISCSI_OP_ASYNC_EVENT;
+	hdr->flags	|=3D ISCSI_FLAG_CMD_FINAL;
+	hton24(hdr->dlength, 0);
+	put_unaligned_le64(0, &hdr->lun[0]);
+	put_unaligned_be64(0xffffffffffffffff, &hdr->rsvd4[0]);
+	hdr->statsn	=3D cpu_to_be32(conn->stat_sn++);
+	spin_lock(&conn->sess->cmdsn_lock);
+	hdr->exp_cmdsn	=3D cpu_to_be32(conn->sess->exp_cmd_sn);
+	hdr->max_cmdsn	=3D cpu_to_be32(conn->sess->max_cmd_sn);
+	spin_unlock(&conn->sess->cmdsn_lock);
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
+		hdr->param2 =3D cpu_to_be16(conn->sess->sess_ops->DefaultTime2Wait);
+		hdr->param3 =3D cpu_to_be16(conn->sess->sess_ops->DefaultTime2Retain=
);
+		break;
+	case ISCSI_ASYNC_MSG_DROPPING_ALL_CONNECTIONS:
+		hdr->param1 =3D 0;
+		hdr->param2 =3D cpu_to_be16(conn->sess->sess_ops->DefaultTime2Wait);
+		hdr->param3 =3D cpu_to_be16(conn->sess->sess_ops->DefaultTime2Retain=
);
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
+	if (conn->conn_ops->HeaderDigest) {
+		u32 *header_digest =3D (u32 *)&iscsi_hdr[ISCSI_HDR_LEN];
+
+		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				(unsigned char *)&iscsi_hdr, ISCSI_HDR_LEN,
+				0, NULL, (u8 *)header_digest);
+			=09
+		iov.iov_len +=3D ISCSI_CRC_LEN;
+		tx_send +=3D ISCSI_CRC_LEN;
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
+		wait_for_completion_timeout(&conn->sess->async_msg_comp,
+					SECONDS_FOR_ASYNC_LOGOUT * HZ);
+
+		if (conn->conn_state =3D=3D TARG_CONN_STATE_LOGOUT_REQUESTED) {
+			printk(KERN_ERR "Asynchronous message timer expired"
+				" without receiving a logout request,  dropping"
+				" iSCSI session.\n");
+			iscsit_send_async_msg(conn, 0,
+				ISCSI_ASYNC_MSG_DROPPING_ALL_CONNECTIONS, 0);
+			iscsit_free_session(conn->sess);
+		}
+	}
+	return 0;
+}
+
+/*
+ *	Called with sess->conn_lock held.
+ */
+/* #warning iscsi_build_conn_drop_async_message() only sends out on co=
nnections
+	with active network interface */
+static void iscsit_build_conn_drop_async_message(struct iscsi_conn *co=
nn)
+{
+	struct iscsi_cmd *cmd;
+	struct iscsi_conn *conn_p;
+
+	/*
+	 * Only send a Asynchronous Message on connections whos network
+	 * interface is still functional.
+	 */
+	list_for_each_entry(conn_p, &conn->sess->sess_conn_list, conn_list) {
+		if (conn_p->conn_state =3D=3D TARG_CONN_STATE_LOGGED_IN) {
+			iscsit_inc_conn_usage_count(conn_p);
+			break;
+		}
+	}
+
+	if (!conn_p)
+		return;
+
+	cmd =3D iscsit_allocate_cmd(conn_p, GFP_KERNEL);
+	if (!cmd) {
+		iscsit_dec_conn_usage_count(conn_p);
+		return;
+	}
+
+	cmd->logout_cid =3D conn->cid;
+	cmd->iscsi_opcode =3D ISCSI_OP_ASYNC_EVENT;
+	cmd->i_state =3D ISTATE_SEND_ASYNCMSG;
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
+	hdr->exp_cmdsn		=3D cpu_to_be32(conn->sess->exp_cmd_sn);
+	hdr->max_cmdsn		=3D cpu_to_be32(conn->sess->max_cmd_sn);
+	hdr->async_event	=3D ISCSI_ASYNC_MSG_DROPPING_CONNECTION;
+	hdr->param1		=3D cpu_to_be16(cmd->logout_cid);
+	hdr->param2		=3D cpu_to_be16(conn->sess->sess_ops->DefaultTime2Wait);
+	hdr->param3		=3D cpu_to_be16(conn->sess->sess_ops->DefaultTime2Retain=
);
+
+	if (conn->conn_ops->HeaderDigest) {
+		u32 *header_digest =3D (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				(unsigned char *)hdr, ISCSI_HDR_LEN,
+				0, NULL, (u8 *)header_digest);
+
+		cmd->tx_size +=3D ISCSI_CRC_LEN;
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
+static int iscsit_send_data_in(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn,
+	struct se_unmap_sg *unmap_sg,
+	int *eodr)
+{
+	int iov_ret =3D 0, set_statsn =3D 0;
+	u8 *pad_bytes;
+	u32 iov_count =3D 0, tx_size =3D 0;
+	struct iscsi_datain datain;
+	struct iscsi_datain_req *dr;
+	struct se_map_sg map_sg;
+	struct iscsi_data_rsp *hdr;
+	struct kvec *iov;
+
+	memset(&datain, 0, sizeof(struct iscsi_datain));
+	dr =3D iscsit_get_datain_values(cmd, &datain);
+	if (!dr) {
+		printk(KERN_ERR "iscsit_get_datain_values failed for ITT: 0x%08x\n",
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
+	spin_lock_bh(&conn->sess->session_stats_lock);
+	conn->sess->tx_data_octets +=3D datain.length;
+	if (conn->sess->se_sess->se_node_acl) {
+		spin_lock(&conn->sess->se_sess->se_node_acl->stats_lock);
+		conn->sess->se_sess->se_node_acl->read_bytes +=3D datain.length;
+		spin_unlock(&conn->sess->se_sess->se_node_acl->stats_lock);
+	}
+	spin_unlock_bh(&conn->sess->session_stats_lock);
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
+			iscsit_increment_maxcmdsn(cmd, conn->sess);
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
+	if (hdr->flags & ISCSI_FLAG_DATA_ACK)
+		int_to_scsilun(SE_CMD(cmd)->orig_fe_lun,
+				(struct scsi_lun *)&hdr->lun[0]);
+	else
+		put_unaligned_le64(0xFFFFFFFFFFFFFFFFULL, &hdr->lun[0]);
+
+	hdr->itt		=3D cpu_to_be32(cmd->init_task_tag);
+	hdr->ttt		=3D (hdr->flags & ISCSI_FLAG_DATA_ACK) ?
+				   cpu_to_be32(cmd->targ_xfer_tag) :
+				   0xFFFFFFFF;
+	hdr->statsn		=3D (set_statsn) ? cpu_to_be32(cmd->stat_sn) :
+						0xFFFFFFFF;
+	hdr->exp_cmdsn		=3D cpu_to_be32(conn->sess->exp_cmd_sn);
+	hdr->max_cmdsn		=3D cpu_to_be32(conn->sess->max_cmd_sn);
+	hdr->datasn		=3D cpu_to_be32(datain.data_sn);
+	hdr->offset		=3D cpu_to_be32(datain.offset);
+
+	iov =3D &cmd->iov_data[0];
+	iov[iov_count].iov_base	=3D cmd->pdu;
+	iov[iov_count++].iov_len	=3D ISCSI_HDR_LEN;
+	tx_size +=3D ISCSI_HDR_LEN;
+
+	if (conn->conn_ops->HeaderDigest) {
+		u32 *header_digest =3D (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				(unsigned char *)hdr, ISCSI_HDR_LEN,
+				0, NULL, (u8 *)header_digest);=09
+
+		iov[0].iov_len +=3D ISCSI_CRC_LEN;
+		tx_size +=3D ISCSI_CRC_LEN;
+
+		TRACE(TRACE_DIGEST, "Attaching CRC32 HeaderDigest"
+			" for DataIN PDU 0x%08x\n", *header_digest);
+	}
+
+	memset(&map_sg, 0, sizeof(struct se_map_sg));
+	map_sg.fabric_cmd =3D (void *)cmd;
+	map_sg.se_cmd =3D SE_CMD(cmd);
+	map_sg.sg_kmap_active =3D 1;
+	map_sg.iov =3D &cmd->iov_data[1];
+	map_sg.data_length =3D datain.length;
+	map_sg.data_offset =3D datain.offset;
+
+	iov_ret =3D iscsit_set_iovec_ptrs(&map_sg, unmap_sg);
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
+		if (!pad_bytes) {
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
+	if (conn->conn_ops->DataDigest) {
+		u32 counter =3D (datain.length + unmap_sg->padding);
+		struct kvec *iov_ptr =3D &cmd->iov_data[1];
+
+		iscsit_do_crypto_hash_iovec(&conn->conn_tx_hash, iov_ptr,
+				counter, 0, NULL, (u8 *)&cmd->data_crc);
+
+		iov[iov_count].iov_base	=3D &cmd->data_crc;
+		iov[iov_count++].iov_len =3D ISCSI_CRC_LEN;
+		tx_size +=3D ISCSI_CRC_LEN;
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
+	int niov =3D 0, tx_size;
+	struct iscsi_conn *logout_conn =3D NULL;
+	struct iscsi_conn_recovery *cr =3D NULL;
+	struct iscsi_session *sess =3D conn->sess;
+	struct kvec *iov;
+	struct iscsi_logout_rsp *hdr;
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
+		 * is stopped in iscsit_logout_post_handler_diffcid().
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
+		logout_conn =3D iscsit_get_conn_from_cid_rcfr(sess,
+				cmd->logout_cid);
+		if ((logout_conn)) {
+			iscsit_connection_reinstatement_rcfr(logout_conn);
+			iscsit_dec_conn_usage_count(logout_conn);
+		}
+
+		cr =3D iscsit_get_inactive_connection_recovery_entry(
+				conn->sess, cmd->logout_cid);
+		if (!cr) {
+			printk(KERN_ERR "Unable to locate CID: %hu for"
+			" REMOVECONNFORRECOVERY Logout Request.\n",
+				cmd->logout_cid);
+			cmd->logout_response =3D ISCSI_LOGOUT_CID_NOT_FOUND;
+			break;
+		}
+
+		iscsit_discard_cr_cmds_by_expstatsn(cr, cmd->exp_stat_sn);
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
+	iscsit_increment_maxcmdsn(cmd, conn->sess);
+	hdr->exp_cmdsn		=3D cpu_to_be32(conn->sess->exp_cmd_sn);
+	hdr->max_cmdsn		=3D cpu_to_be32(conn->sess->max_cmd_sn);
+
+	iov =3D &cmd->iov_misc[0];
+	iov[niov].iov_base	=3D cmd->pdu;
+	iov[niov++].iov_len	=3D ISCSI_HDR_LEN;
+
+	if (conn->conn_ops->HeaderDigest) {
+		u32 *header_digest =3D (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				(unsigned char *)hdr, ISCSI_HDR_LEN,
+				0, NULL, (u8 *)header_digest);
+
+		iov[0].iov_len +=3D ISCSI_CRC_LEN;
+		tx_size +=3D ISCSI_CRC_LEN;
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
+/*
+ *	Unsolicited NOPIN, either requesting a response or not.
+ */
+static int iscsit_send_unsolicited_nopin(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn,
+	int want_response)
+{
+	int tx_size =3D ISCSI_HDR_LEN;
+	struct iscsi_nopin *hdr;
+
+	hdr			=3D (struct iscsi_nopin *) cmd->pdu;
+	memset(hdr, 0, ISCSI_HDR_LEN);
+	hdr->opcode		=3D ISCSI_OP_NOOP_IN;
+	hdr->flags		|=3D ISCSI_FLAG_CMD_FINAL;
+	hdr->itt		=3D cpu_to_be32(cmd->init_task_tag);
+	hdr->ttt		=3D cpu_to_be32(cmd->targ_xfer_tag);
+	cmd->stat_sn		=3D conn->stat_sn;
+	hdr->statsn		=3D cpu_to_be32(cmd->stat_sn);
+	hdr->exp_cmdsn		=3D cpu_to_be32(conn->sess->exp_cmd_sn);
+	hdr->max_cmdsn		=3D cpu_to_be32(conn->sess->max_cmd_sn);
+
+	if (conn->conn_ops->HeaderDigest) {
+		u32 *header_digest =3D (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				(unsigned char *)hdr, ISCSI_HDR_LEN,
+				0, NULL, (u8 *)header_digest);
+
+		tx_size +=3D ISCSI_CRC_LEN;
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
+static int iscsit_send_nopin_response(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	int niov =3D 0, tx_size;
+	u32 padding =3D 0;
+	struct kvec *iov;
+	struct iscsi_nopin *hdr;
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
+	iscsit_increment_maxcmdsn(cmd, conn->sess);
+	hdr->exp_cmdsn		=3D cpu_to_be32(conn->sess->exp_cmd_sn);
+	hdr->max_cmdsn		=3D cpu_to_be32(conn->sess->max_cmd_sn);
+
+	iov =3D &cmd->iov_misc[0];
+	iov[niov].iov_base	=3D cmd->pdu;
+	iov[niov++].iov_len	=3D ISCSI_HDR_LEN;
+
+	if (conn->conn_ops->HeaderDigest) {
+		u32 *header_digest =3D (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				(unsigned char *)hdr, ISCSI_HDR_LEN,
+				0, NULL, (u8 *)header_digest);
+				=09
+		iov[0].iov_len +=3D ISCSI_CRC_LEN;
+		tx_size +=3D ISCSI_CRC_LEN;
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
+		if (conn->conn_ops->DataDigest) {
+			iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				cmd->buf_ptr, cmd->buf_ptr_size,
+				padding, (u8 *)&cmd->pad_bytes,
+				(u8 *)&cmd->data_crc);
+		=09
+			iov[niov].iov_base =3D &cmd->data_crc;
+			iov[niov++].iov_len =3D ISCSI_CRC_LEN;
+			tx_size +=3D ISCSI_CRC_LEN;
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
+int iscsit_send_r2t(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	int tx_size =3D 0;
+	u32 trace_type;
+	struct iscsi_r2t *r2t;
+	struct iscsi_r2t_rsp *hdr;
+
+	r2t =3D iscsit_get_r2t_from_list(cmd);
+	if (!r2t)
+		return -1;
+
+	hdr			=3D (struct iscsi_r2t_rsp *) cmd->pdu;
+	memset(hdr, 0, ISCSI_HDR_LEN);
+	hdr->opcode		=3D ISCSI_OP_R2T;
+	hdr->flags		|=3D ISCSI_FLAG_CMD_FINAL;
+	int_to_scsilun(SE_CMD(cmd)->orig_fe_lun,
+			(struct scsi_lun *)&hdr->lun[0]);
+	hdr->itt		=3D cpu_to_be32(cmd->init_task_tag);
+	spin_lock_bh(&conn->sess->ttt_lock);
+	r2t->targ_xfer_tag	=3D conn->sess->targ_xfer_tag++;
+	if (r2t->targ_xfer_tag =3D=3D 0xFFFFFFFF)
+		r2t->targ_xfer_tag =3D conn->sess->targ_xfer_tag++;
+	spin_unlock_bh(&conn->sess->ttt_lock);
+	hdr->ttt		=3D cpu_to_be32(r2t->targ_xfer_tag);
+	hdr->statsn		=3D cpu_to_be32(conn->stat_sn);
+	hdr->exp_cmdsn		=3D cpu_to_be32(conn->sess->exp_cmd_sn);
+	hdr->max_cmdsn		=3D cpu_to_be32(conn->sess->max_cmd_sn);
+	hdr->r2tsn		=3D cpu_to_be32(r2t->r2t_sn);
+	hdr->data_offset	=3D cpu_to_be32(r2t->offset);
+	hdr->data_length	=3D cpu_to_be32(r2t->xfer_len);
+
+	cmd->iov_misc[0].iov_base	=3D cmd->pdu;
+	cmd->iov_misc[0].iov_len	=3D ISCSI_HDR_LEN;
+	tx_size +=3D ISCSI_HDR_LEN;
+
+	if (conn->conn_ops->HeaderDigest) {
+		u32 *header_digest =3D (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				(unsigned char *)hdr, ISCSI_HDR_LEN,
+				0, NULL, (u8 *)header_digest);
+
+		cmd->iov_misc[0].iov_len +=3D ISCSI_CRC_LEN;
+		tx_size +=3D ISCSI_CRC_LEN;
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
+	int first_r2t =3D 1;
+	u32 offset =3D 0, xfer_len =3D 0;
+
+	spin_lock_bh(&cmd->r2t_lock);
+	if (cmd->cmd_flags & ICF_SENT_LAST_R2T) {
+		spin_unlock_bh(&cmd->r2t_lock);
+		return 0;
+	}
+
+	if (conn->sess->sess_ops->DataSequenceInOrder && (type !=3D 2))
+		if (cmd->r2t_offset < cmd->write_data_done)
+			cmd->r2t_offset =3D cmd->write_data_done;
+
+	while (cmd->outstanding_r2ts < conn->sess->sess_ops->MaxOutstandingR2=
T) {
+		if (conn->sess->sess_ops->DataSequenceInOrder) {
+			offset =3D cmd->r2t_offset;
+
+			if (first_r2t && (type =3D=3D 2)) {
+				xfer_len =3D ((offset +
+					     (conn->sess->sess_ops->MaxBurstLength -
+					     cmd->next_burst_len) >
+					     cmd->data_length) ?
+					    (cmd->data_length - offset) :
+					    (conn->sess->sess_ops->MaxBurstLength -
+					     cmd->next_burst_len));
+			} else {
+				xfer_len =3D ((offset +
+					     conn->sess->sess_ops->MaxBurstLength) >
+					     cmd->data_length) ?
+					     (cmd->data_length - offset) :
+					     conn->sess->sess_ops->MaxBurstLength;
+			}
+			cmd->r2t_offset +=3D xfer_len;
+
+			if (cmd->r2t_offset =3D=3D cmd->data_length)
+				cmd->cmd_flags |=3D ICF_SENT_LAST_R2T;
+		} else {
+			struct iscsi_seq *seq;
+
+			seq =3D iscsit_get_seq_holder_for_r2t(cmd);
+			if (!seq) {
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
+	u8 iov_count =3D 0, recovery;
+	u32 padding =3D 0, trace_type, tx_size =3D 0;
+	struct iscsi_scsi_rsp *hdr;
+	struct kvec *iov;
+
+	recovery =3D (cmd->i_state !=3D ISTATE_SEND_STATUS);
+	if (!recovery)
+		cmd->stat_sn =3D conn->stat_sn++;
+
+	spin_lock_bh(&conn->sess->session_stats_lock);
+	conn->sess->rsp_pdus++;
+	spin_unlock_bh(&conn->sess->session_stats_lock);
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
+	iscsit_increment_maxcmdsn(cmd, conn->sess);
+	hdr->exp_cmdsn		=3D cpu_to_be32(conn->sess->exp_cmd_sn);
+	hdr->max_cmdsn		=3D cpu_to_be32(conn->sess->max_cmd_sn);
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
+		if (conn->conn_ops->DataDigest) {
+			iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				SE_CMD(cmd)->sense_buffer,
+				(SE_CMD(cmd)->scsi_sense_length + padding),
+				0, NULL, (u8 *)&cmd->data_crc);
+
+			iov[iov_count].iov_base    =3D &cmd->data_crc;
+			iov[iov_count++].iov_len     =3D ISCSI_CRC_LEN;
+			tx_size +=3D ISCSI_CRC_LEN;
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
+	if (conn->conn_ops->HeaderDigest) {
+		u32 *header_digest =3D (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				(unsigned char *)hdr, ISCSI_HDR_LEN,
+				0, NULL, (u8 *)header_digest);
+
+		iov[0].iov_len +=3D ISCSI_CRC_LEN;
+		tx_size +=3D ISCSI_CRC_LEN;
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
+	struct se_tmr_req *se_tmr =3D SE_CMD(cmd)->se_tmr_req;
+	struct iscsi_tm_rsp *hdr;
+	u32 tx_size =3D 0;
+
+	hdr			=3D (struct iscsi_tm_rsp *) cmd->pdu;
+	memset(hdr, 0, ISCSI_HDR_LEN);
+	hdr->opcode		=3D ISCSI_OP_SCSI_TMFUNC_RSP;
+	hdr->response		=3D iscsit_convert_tcm_tmr_rsp(se_tmr);
+	hdr->itt		=3D cpu_to_be32(cmd->init_task_tag);
+	cmd->stat_sn		=3D conn->stat_sn++;
+	hdr->statsn		=3D cpu_to_be32(cmd->stat_sn);
+
+	iscsit_increment_maxcmdsn(cmd, conn->sess);
+	hdr->exp_cmdsn		=3D cpu_to_be32(conn->sess->exp_cmd_sn);
+	hdr->max_cmdsn		=3D cpu_to_be32(conn->sess->max_cmd_sn);
+
+	cmd->iov_misc[0].iov_base	=3D cmd->pdu;
+	cmd->iov_misc[0].iov_len	=3D ISCSI_HDR_LEN;
+	tx_size +=3D ISCSI_HDR_LEN;
+
+	if (conn->conn_ops->HeaderDigest) {
+		u32 *header_digest =3D (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				(unsigned char *)hdr, ISCSI_HDR_LEN,
+				0, NULL, (u8 *)header_digest);
+
+		cmd->iov_misc[0].iov_len +=3D ISCSI_CRC_LEN;
+		tx_size +=3D ISCSI_CRC_LEN;
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
+static int iscsit_build_sendtargets_response(struct iscsi_cmd *cmd)
+{
+	char *payload =3D NULL;
+	struct iscsi_conn *conn =3D cmd->conn;
+	struct iscsi_portal_group *tpg;
+	struct iscsi_tiqn *tiqn;
+	struct iscsi_tpg_np *tpg_np;
+	int buffer_len, end_of_buf =3D 0, len =3D 0, payload_len =3D 0;
+	unsigned char buf[256];
+
+	buffer_len =3D (conn->conn_ops->MaxRecvDataSegmentLength > 32768) ?
+			32768 : conn->conn_ops->MaxRecvDataSegmentLength;
+
+	memset(buf, 0, 256);
+
+	payload =3D kzalloc(buffer_len, GFP_KERNEL);
+	if (!payload) {
+		printk(KERN_ERR "Unable to allocate memory for sendtargets"
+				" response.\n");
+		return -ENOMEM;
+	}
+
+	spin_lock(&tiqn_lock);
+	list_for_each_entry(tiqn, &g_tiqn_list, tiqn_list) {
+		len =3D sprintf(buf, "TargetName=3D%s", tiqn->tiqn);
+		len +=3D 1;
+
+		if ((len + payload_len) > buffer_len) {
+			spin_unlock(&tiqn->tiqn_tpg_lock);
+			end_of_buf =3D 1;
+			goto eob;
+		}
+		memcpy((void *)payload + payload_len, buf, len);
+		payload_len +=3D len;
+
+		spin_lock(&tiqn->tiqn_tpg_lock);
+		list_for_each_entry(tpg, &tiqn->tiqn_tpg_list, tpg_list) {
+
+			spin_lock(&tpg->tpg_state_lock);
+			if ((tpg->tpg_state =3D=3D TPG_STATE_FREE) ||
+			    (tpg->tpg_state =3D=3D TPG_STATE_INACTIVE)) {
+				spin_unlock(&tpg->tpg_state_lock);
+				continue;
+			}
+			spin_unlock(&tpg->tpg_state_lock);
+
+			spin_lock(&tpg->tpg_np_lock);
+			list_for_each_entry(tpg_np, &tpg->tpg_gnp_list,
+						tpg_np_list) {
+				len =3D sprintf(buf, "TargetAddress=3D"
+					"%s%s%s:%hu,%hu",
+					(tpg_np->tpg_np->np_sockaddr.ss_family =3D=3D AF_INET6) ?
+					"[" : "", tpg_np->tpg_np->np_ip,
+					(tpg_np->tpg_np->np_sockaddr.ss_family =3D=3D AF_INET6) ?
+					"]" : "", tpg_np->tpg_np->np_port,
+					tpg->tpgt);
+				len +=3D 1;
+
+				if ((len + payload_len) > buffer_len) {
+					spin_unlock(&tpg->tpg_np_lock);
+					spin_unlock(&tiqn->tiqn_tpg_lock);
+					end_of_buf =3D 1;
+					goto eob;
+				}
+				memcpy((void *)payload + payload_len, buf, len);
+				payload_len +=3D len;
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
+	cmd->buf_ptr =3D payload;
+
+	return payload_len;
+}
+
+/*
+ *	FIXME: Add support for F_BIT and C_BIT when the length is longer th=
an
+ *	MaxRecvDataSegmentLength.
+ */
+static int iscsit_send_text_rsp(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	struct iscsi_text_rsp *hdr;
+	struct kvec *iov;
+	u32 padding =3D 0, tx_size =3D 0;
+	int text_length, iov_count =3D 0;
+
+	text_length =3D iscsit_build_sendtargets_response(cmd);
+	if (text_length < 0)
+		return text_length;
+
+	padding =3D ((-text_length) & 3);
+	if (padding !=3D 0) {
+		memset(cmd->buf_ptr + text_length, 0, padding);
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
+	iscsit_increment_maxcmdsn(cmd, conn->sess);
+	hdr->exp_cmdsn		=3D cpu_to_be32(conn->sess->exp_cmd_sn);
+	hdr->max_cmdsn		=3D cpu_to_be32(conn->sess->max_cmd_sn);
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
+	if (conn->conn_ops->HeaderDigest) {
+		u32 *header_digest =3D (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				(unsigned char *)hdr, ISCSI_HDR_LEN,
+				0, NULL, (u8 *)header_digest);
+
+		iov[0].iov_len +=3D ISCSI_CRC_LEN;
+		tx_size +=3D ISCSI_CRC_LEN;
+		TRACE(TRACE_DIGEST, "Attaching CRC32 HeaderDigest for"
+			" Text Response PDU 0x%08x\n", *header_digest);
+	}
+
+	if (conn->conn_ops->DataDigest) {
+		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				cmd->buf_ptr, (text_length + padding),
+				0, NULL, (u8 *)&cmd->data_crc);
+
+		iov[iov_count].iov_base	=3D &cmd->data_crc;
+		iov[iov_count++].iov_len =3D ISCSI_CRC_LEN;
+		tx_size	+=3D ISCSI_CRC_LEN;
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
+static int iscsit_send_reject(
+	struct iscsi_cmd *cmd,
+	struct iscsi_conn *conn)
+{
+	u32 iov_count =3D 0, tx_size =3D 0;
+	struct iscsi_reject *hdr;
+	struct kvec *iov;
+
+	hdr			=3D (struct iscsi_reject *) cmd->pdu;
+	hdr->opcode		=3D ISCSI_OP_REJECT;
+	hdr->flags		|=3D ISCSI_FLAG_CMD_FINAL;
+	hton24(hdr->dlength, ISCSI_HDR_LEN);
+	cmd->stat_sn		=3D conn->stat_sn++;
+	hdr->statsn		=3D cpu_to_be32(cmd->stat_sn);
+	hdr->exp_cmdsn	=3D cpu_to_be32(conn->sess->exp_cmd_sn);
+	hdr->max_cmdsn	=3D cpu_to_be32(conn->sess->max_cmd_sn);
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
+	if (conn->conn_ops->HeaderDigest) {
+		u32 *header_digest =3D (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
+
+		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				(unsigned char *)hdr, ISCSI_HDR_LEN,
+				0, NULL, (u8 *)header_digest);
+
+		iov[0].iov_len +=3D ISCSI_CRC_LEN;
+		tx_size +=3D ISCSI_CRC_LEN;
+		TRACE(TRACE_DIGEST, "Attaching CRC32 HeaderDigest for"
+			" REJECT PDU 0x%08x\n", *header_digest);
+	}
+
+	if (conn->conn_ops->DataDigest) {
+		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
+				(unsigned char *)cmd->buf_ptr, ISCSI_HDR_LEN,
+				0, NULL, (u8 *)&cmd->data_crc);
+
+		iov[iov_count].iov_base =3D &cmd->data_crc;
+		iov[iov_count++].iov_len  =3D ISCSI_CRC_LEN;
+		tx_size +=3D ISCSI_CRC_LEN;
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
+	struct iscsi_thread_set *ts =3D conn->thread_set;
+	int ord, cpu;
+	/*
+	 * thread_id is assigned from iscsit_global->ts_bitmap from
+	 * within iscsi_thread_set.c:iscsi_allocate_thread_sets()
+	 *
+	 * Here we use thread_id to determine which CPU that this
+	 * iSCSI connection's iscsi_thread_set will be scheduled to
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
+static inline void iscsit_thread_check_cpumask(
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
+		if (!conn->conn_tx_reset_cpumask)
+			return;
+		conn->conn_tx_reset_cpumask =3D 0;
+	} else {
+		if (!conn->conn_rx_reset_cpumask)
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
+#define iscsit_thread_get_cpumask(X) ({})
+#define iscsit_thread_check_cpumask(X, Y, Z) ({})
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
+	struct iscsi_thread_set *ts =3D (struct iscsi_thread_set *)arg;
+	struct se_unmap_sg unmap_sg;
+	/*
+	 * Allow ourselves to be interrupted by SIGINT so that a
+	 * connection recovery / failure event can be triggered externally.
+	 */
+	allow_signal(SIGINT);
+
+restart:
+	conn =3D iscsi_tx_thread_pre_handler(ts);
+	if (!conn)
+		goto out;
+
+	eodr =3D map_sg =3D ret =3D sent_status =3D use_misc =3D 0;
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
+		if ((ts->status =3D=3D ISCSI_THREAD_SET_RESET) ||
+		     signal_pending(current))
+			goto transport_err;
+
+get_immediate:
+		qr =3D iscsit_get_cmd_from_immediate_queue(conn);
+		if (qr) {
+			atomic_set(&conn->check_immediate_queue, 0);
+			cmd =3D qr->cmd;
+			state =3D qr->state;
+			kmem_cache_free(lio_qr_cache, qr);
+
+			spin_lock_bh(&cmd->istate_lock);
+			switch (state) {
+			case ISTATE_SEND_R2T:
+				spin_unlock_bh(&cmd->istate_lock);
+				ret =3D iscsit_send_r2t(cmd, conn);
+				break;
+			case ISTATE_REMOVE:
+				spin_unlock_bh(&cmd->istate_lock);
+
+				if (cmd->data_direction =3D=3D DMA_TO_DEVICE)
+					iscsit_stop_dataout_timer(cmd);
+
+				spin_lock_bh(&conn->cmd_lock);
+				list_del(&cmd->i_list);
+				spin_unlock_bh(&conn->cmd_lock);
+				/*
+				 * Determine if a struct se_cmd is assoicated with
+				 * this struct iscsi_cmd.
+				 */
+				if (!(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD) &&
+				    !(cmd->tmr_req))
+					iscsit_release_cmd(cmd);
+				else
+					transport_generic_free_cmd(SE_CMD(cmd),
+								1, 1, 0);
+				goto get_immediate;
+			case ISTATE_SEND_NOPIN_WANT_RESPONSE:
+				spin_unlock_bh(&cmd->istate_lock);
+				iscsit_mod_nopin_response_timer(conn);
+				ret =3D iscsit_send_unsolicited_nopin(cmd,
+						conn, 1);
+				break;
+			case ISTATE_SEND_NOPIN_NO_RESPONSE:
+				spin_unlock_bh(&cmd->istate_lock);
+				ret =3D iscsit_send_unsolicited_nopin(cmd,
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
+			if (iscsit_send_tx_data(cmd, conn, 1) < 0) {
+				conn->tx_immediate_queue =3D 0;
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
+		qr =3D iscsit_get_cmd_from_response_queue(conn);
+		if (qr) {
+			cmd =3D qr->cmd;
+			state =3D qr->state;
+			kmem_cache_free(lio_qr_cache, qr);
+
+			spin_lock_bh(&cmd->istate_lock);
+check_rsp_state:
+			switch (state) {
+			case ISTATE_SEND_DATAIN:
+				spin_unlock_bh(&cmd->istate_lock);
+				memset(&unmap_sg, 0,
+						sizeof(struct se_unmap_sg));
+				unmap_sg.fabric_cmd =3D (void *)cmd;
+				unmap_sg.se_cmd =3D SE_CMD(cmd);
+				map_sg =3D 1;
+				ret =3D iscsit_send_data_in(cmd, conn,
+						&unmap_sg, &eodr);
+				break;
+			case ISTATE_SEND_STATUS:
+			case ISTATE_SEND_STATUS_RECOVERY:
+				spin_unlock_bh(&cmd->istate_lock);
+				use_misc =3D 1;
+				ret =3D iscsit_send_status(cmd, conn);
+				break;
+			case ISTATE_SEND_LOGOUTRSP:
+				spin_unlock_bh(&cmd->istate_lock);
+				use_misc =3D 1;
+				ret =3D iscsit_send_logout_response(cmd, conn);
+				break;
+			case ISTATE_SEND_ASYNCMSG:
+				spin_unlock_bh(&cmd->istate_lock);
+				use_misc =3D 1;
+				ret =3D iscsit_send_conn_drop_async_message(
+						cmd, conn);
+				break;
+			case ISTATE_SEND_NOPIN:
+				spin_unlock_bh(&cmd->istate_lock);
+				use_misc =3D 1;
+				ret =3D iscsit_send_nopin_response(cmd, conn);
+				break;
+			case ISTATE_SEND_REJECT:
+				spin_unlock_bh(&cmd->istate_lock);
+				use_misc =3D 1;
+				ret =3D iscsit_send_reject(cmd, conn);
+				break;
+			case ISTATE_SEND_TASKMGTRSP:
+				spin_unlock_bh(&cmd->istate_lock);
+				use_misc =3D 1;
+				ret =3D iscsit_send_task_mgt_rsp(cmd, conn);
+				if (ret !=3D 0)
+					break;
+				ret =3D iscsit_tmr_post_handler(cmd, conn);
+				if (ret !=3D 0)
+					iscsit_fall_back_to_erl0(conn->sess);
+				break;
+			case ISTATE_SEND_TEXTRSP:
+				spin_unlock_bh(&cmd->istate_lock);
+				use_misc =3D 1;
+				ret =3D iscsit_send_text_rsp(cmd, conn);
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
+			if (map_sg && !conn->conn_ops->IFMarker &&
+			    se_cmd->t_task->t_tasks_se_num) {
+				iscsit_map_SG_segments(&unmap_sg);
+				if (iscsit_fe_sendpage_sg(&unmap_sg, conn) < 0) {
+					conn->tx_response_queue =3D 0;
+					iscsit_tx_thread_wait_for_tcp(conn);
+					iscsit_unmap_SG_segments(&unmap_sg);
+					goto transport_err;
+				}
+				iscsit_unmap_SG_segments(&unmap_sg);
+				map_sg =3D 0;
+			} else {
+				if (map_sg)
+					iscsit_map_SG_segments(&unmap_sg);
+				if (iscsit_send_tx_data(cmd, conn, use_misc) < 0) {
+					conn->tx_response_queue =3D 0;
+					iscsit_tx_thread_wait_for_tcp(conn);
+					if (map_sg)
+						iscsit_unmap_SG_segments(&unmap_sg);
+					goto transport_err;
+				}
+				if (map_sg) {
+					iscsit_unmap_SG_segments(&unmap_sg);
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
+					complete(&cmd->reject_comp);
+					goto transport_err;
+				}
+				complete(&cmd->reject_comp);
+				break;
+			case ISTATE_SEND_TASKMGTRSP:
+				use_misc =3D 0;
+				sent_status =3D 1;
+				break;
+			case ISTATE_SEND_LOGOUTRSP:
+				spin_unlock_bh(&cmd->istate_lock);
+				if (!(iscsit_logout_post_handler(cmd, conn)))
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
+	u32 checksum =3D 0, digest =3D 0;
+	struct iscsi_conn *conn =3D NULL;
+	struct iscsi_thread_set *ts =3D (struct iscsi_thread_set *)arg;
+	struct kvec iov;
+	/*
+	 * Allow ourselves to be interrupted by SIGINT so that a
+	 * connection recovery / failure event can be triggered externally.
+	 */
+	allow_signal(SIGINT);
+
+restart:
+	conn =3D iscsi_rx_thread_pre_handler(ts);
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
+		iov.iov_base	=3D buffer;
+		iov.iov_len	=3D ISCSI_HDR_LEN;
+
+		ret =3D rx_data(conn, &iov, 1, ISCSI_HDR_LEN);
+		if (ret !=3D ISCSI_HDR_LEN) {
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
+			iov.iov_base	=3D &digest;
+			iov.iov_len	=3D ISCSI_CRC_LEN;
+
+			ret =3D rx_data(conn, &iov, 1, ISCSI_CRC_LEN);
+			if (ret !=3D ISCSI_CRC_LEN) {
+				iscsit_rx_thread_wait_for_tcp(conn);
+				goto transport_err;
+			}
+
+			iscsit_do_crypto_hash_buf(&conn->conn_rx_hash,
+					buffer, ISCSI_HDR_LEN,
+					0, NULL, (u8 *)&checksum);
+
+			if (digest !=3D checksum) {
+				printk(KERN_ERR "HeaderDigest CRC32C failed,"
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
+		if (conn->sess->sess_ops->SessionType &&
+		   ((!(opcode & ISCSI_OP_TEXT)) ||
+		    (!(opcode & ISCSI_OP_LOGOUT)))) {
+			printk(KERN_ERR "Received illegal iSCSI Opcode: 0x%02x"
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
+			ret =3D iscsit_handle_logout_cmd(conn, buffer);
+			if (ret > 0) {
+				wait_for_completion(&conn->conn_logout_comp);
+				goto transport_err;
+			} else if (ret < 0)
+				goto transport_err;
+			break;
+		case ISCSI_OP_SNACK:
+			if (iscsit_handle_snack(conn, buffer) < 0)
+				goto transport_err;
+			break;
+		default:
+			printk(KERN_ERR "Got unknown iSCSI OpCode: 0x%02x\n",
+					opcode);
+			if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
+				printk(KERN_ERR "Cannot recover from unknown"
+				" opcode while ERL=3D0, closing iSCSI connection"
+				".\n");
+				goto transport_err;
+			}
+			if (!conn->conn_ops->OFMarker) {
+				printk(KERN_ERR "Unable to recover from unknown"
+				" opcode while OFMarker=3DNo, closing iSCSI"
+					" connection.\n");
+				goto transport_err;
+			}
+			if (iscsit_recover_from_unknown_opcode(conn) < 0) {
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
+	iscsit_take_action_for_connection_exit(conn);
+	goto restart;
+out:
+	return 0;
+}
+
+static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
+{
+	struct iscsi_cmd *cmd =3D NULL, *cmd_tmp =3D NULL;
+	struct iscsi_session *sess =3D conn->sess;
+	struct se_cmd *se_cmd;
+	/*
+	 * We expect this function to only ever be called from either RX or T=
X
+	 * thread context via iscsit_close_connection() once the other contex=
t
+	 * has been reset -> returned sleeping pre-handler state.
+	 */
+	spin_lock_bh(&conn->cmd_lock);
+	list_for_each_entry_safe(cmd, cmd_tmp, &conn->conn_cmd_list, i_list) =
{
+		if (!(SE_CMD(cmd)) ||
+		    !(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD)) {
+
+			list_del(&cmd->i_list);
+			spin_unlock_bh(&conn->cmd_lock);
+			iscsit_increment_maxcmdsn(cmd, sess);
+			se_cmd =3D SE_CMD(cmd);
+			/*
+			 * Special cases for active iSCSI TMR, and
+			 * transport_lookup_cmd_lun() failing from
+			 * iscsit_get_lun_for_cmd() in iscsit_handle_scsi_cmd().
+			 */
+			if (cmd->tmr_req && se_cmd->transport_wait_for_tasks)
+				se_cmd->transport_wait_for_tasks(se_cmd, 1, 1);
+			else if (SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD)
+				transport_release_cmd_to_pool(se_cmd);
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
+static void iscsit_stop_timers_for_cmds(
+	struct iscsi_conn *conn)
+{
+	struct iscsi_cmd *cmd;
+
+	spin_lock_bh(&conn->cmd_lock);
+	list_for_each_entry(cmd, &conn->conn_cmd_list, i_list) {
+		if (cmd->data_direction =3D=3D DMA_TO_DEVICE)
+			iscsit_stop_dataout_timer(cmd);
+	}
+	spin_unlock_bh(&conn->cmd_lock);
+}
+
+int iscsit_close_connection(
+	struct iscsi_conn *conn)
+{
+	int conn_logout =3D (conn->conn_state =3D=3D TARG_CONN_STATE_IN_LOGOU=
T);
+	struct iscsi_session	*sess =3D conn->sess;
+
+	TRACE(TRACE_ISCSI, "Closing iSCSI connection CID %hu on SID:"
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
+		if (conn->conn_logout_reason =3D=3D ISCSI_LOGOUT_REASON_CLOSE_SESSIO=
N) {
+			iscsit_dec_conn_usage_count(conn);
+			iscsit_dec_session_usage_count(sess);
+		}
+		if (conn->conn_logout_reason =3D=3D ISCSI_LOGOUT_REASON_CLOSE_CONNEC=
TION)
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
+	conn->conn_ops =3D NULL;
+
+	if (conn->sock) {
+		if (conn->conn_flags & CONNFLAG_SCTP_STRUCT_FILE) {
+			kfree(conn->sock->file);
+			conn->sock->file =3D NULL;
+		}
+		sock_release(conn->sock);
+	}
+	conn->thread_set =3D NULL;
+
+	TRACE(TRACE_STATE, "Moving to TARG_CONN_STATE_FREE.\n");
+	conn->conn_state =3D TARG_CONN_STATE_FREE;
+	kfree(conn);
+
+	spin_lock_bh(&sess->conn_lock);
+	atomic_dec(&sess->nconn);
+	printk(KERN_INFO "Decremented iSCSI connection count to %hu from node=
:"
+		" %s\n", atomic_read(&sess->nconn),
+		sess->sess_ops->InitiatorName);
+	/*
+	 * Make sure that if one connection fails in an non ERL=3D2 iSCSI
+	 * Session that they all fail.
+	 */
+	if ((sess->sess_ops->ErrorRecoveryLevel !=3D 2) && !conn_logout &&
+	     !atomic_read(&sess->session_logout))
+		atomic_set(&sess->session_fall_back_to_erl0, 1);
+
+	/*
+	 * If this was not the last connection in the session, and we are
+	 * performing session reinstatement or falling back to ERL=3D0, call
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
+	 * to ERL=3D0 call iscsit_close_session().
+	 *
+	 * Session Logout was requested.  iscsit_close_session() will be call=
ed
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
+		TRACE(TRACE_STATE, "Moving to TARG_SESS_STATE_FREE.\n");
+		sess->session_state =3D TARG_SESS_STATE_FREE;
+		spin_unlock_bh(&sess->conn_lock);
+
+		if (atomic_read(&sess->sleep_on_sess_wait_comp))
+			complete(&sess->session_wait_comp);
+
+		return 0;
+	} else {
+		TRACE(TRACE_STATE, "Moving to TARG_SESS_STATE_FAILED.\n");
+		sess->session_state =3D TARG_SESS_STATE_FAILED;
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
+	struct iscsi_portal_group *tpg =3D ISCSI_TPG_S(sess);
+	struct se_portal_group *se_tpg =3D &tpg->tpg_se_tpg;
+
+	if (atomic_read(&sess->nconn)) {
+		printk(KERN_ERR "%d connection(s) still exist for iSCSI session"
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
+	 * struct se_node_acl->nacl_sess pointer now as a iscsi_np process co=
ntext
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
+		if (iscsit_check_session_usage_count(sess) =3D=3D 1)
+			iscsit_stop_session(sess, 1, 1);
+	} else {
+		if (iscsit_check_session_usage_count(sess) =3D=3D 2) {
+			atomic_set(&sess->session_logout, 0);
+			iscsit_start_time2retain_handler(sess);
+			return 0;
+		}
+	}
+
+	transport_deregister_session(sess->se_sess);
+
+	if (sess->sess_ops->ErrorRecoveryLevel =3D=3D 2)
+		iscsit_free_connection_recovery_entires(sess);
+
+	iscsit_free_all_ooo_cmdsns(sess);
+
+	spin_lock_bh(&se_tpg->session_lock);
+	TRACE(TRACE_STATE, "Moving to TARG_SESS_STATE_FREE.\n");
+	sess->session_state =3D TARG_SESS_STATE_FREE;
+	printk(KERN_INFO "Released iSCSI session from node: %s\n",
+			sess->sess_ops->InitiatorName);
+	tpg->nsessions--;
+	if (tpg->tpg_tiqn)
+		tpg->tpg_tiqn->tiqn_nsessions--;
+
+	printk(KERN_INFO "Decremented number of active iSCSI Sessions on"
+		" iSCSI TPG: %hu to %u\n", tpg->tpgt, tpg->nsessions);
+
+	spin_lock(&sess_idr_lock);
+	idr_remove(&sess_idr, sess->session_index);
+	spin_unlock(&sess_idr_lock);
+
+	kfree(sess->sess_ops);
+	sess->sess_ops =3D NULL;
+	spin_unlock_bh(&se_tpg->session_lock);
+
+	kfree(sess);
+	return 0;
+}
+
+static void iscsit_logout_post_handler_closesession(
+	struct iscsi_conn *conn)
+{
+	struct iscsi_session *sess =3D conn->sess;
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
+	struct iscsi_session *sess =3D conn->sess;
+
+	if (!sess)
+		return;
+
+	spin_lock_bh(&sess->conn_lock);
+	list_for_each_entry(l_conn, &sess->sess_conn_list, conn_list) {
+		if (l_conn->cid =3D=3D cid) {
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
+	TRACE(TRACE_STATE, "Moving to TARG_CONN_STATE_IN_LOGOUT.\n");
+	l_conn->conn_state =3D TARG_CONN_STATE_IN_LOGOUT;
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
+	int ret =3D 0;
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
+		ret =3D 0;
+		break;
+	case ISCSI_LOGOUT_REASON_CLOSE_CONNECTION:
+		if (conn->cid =3D=3D cmd->logout_cid) {
+			switch (cmd->logout_response) {
+			case ISCSI_LOGOUT_SUCCESS:
+			case ISCSI_LOGOUT_CLEANUP_FAILED:
+			default:
+				iscsit_logout_post_handler_samecid(conn);
+				break;
+			}
+			ret =3D 0;
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
+void iscsit_fail_session(struct iscsi_session *sess)
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
+int iscsit_free_session(struct iscsi_session *sess)
+{
+	u16 conn_count =3D atomic_read(&sess->nconn);
+	struct iscsi_conn *conn, *conn_tmp =3D NULL;
+	int is_last;
+
+	spin_lock_bh(&sess->conn_lock);
+	atomic_set(&sess->sleep_on_sess_wait_comp, 1);
+
+	list_for_each_entry_safe(conn, conn_tmp, &sess->sess_conn_list,
+			conn_list) {
+		if (conn_count =3D=3D 0)
+			break;
+
+		if (list_is_last(&conn->conn_list, &sess->sess_conn_list)) {
+			is_last =3D 1;
+		} else {
+			iscsit_inc_conn_usage_count(conn_tmp);
+			is_last =3D 0;
+		}
+		iscsit_inc_conn_usage_count(conn);
+
+		spin_unlock_bh(&sess->conn_lock);
+		iscsit_cause_connection_reinstatement(conn, 1);
+		spin_lock_bh(&sess->conn_lock);
+
+		iscsit_dec_conn_usage_count(conn);
+		if (is_last =3D=3D 0)
+			iscsit_dec_conn_usage_count(conn_tmp);
+=09
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
+	u16 conn_count =3D atomic_read(&sess->nconn);
+	struct iscsi_conn *conn, *conn_tmp =3D NULL;
+	int is_last;
+
+	spin_lock_bh(&sess->conn_lock);
+	if (session_sleep)
+		atomic_set(&sess->sleep_on_sess_wait_comp, 1);
+
+	if (connection_sleep) {
+		list_for_each_entry_safe(conn, conn_tmp, &sess->sess_conn_list,
+				conn_list) {
+			if (conn_count =3D=3D 0)
+				break;
+
+			if (list_is_last(&conn->conn_list, &sess->sess_conn_list)) {
+				is_last =3D 1;
+			} else {
+				iscsit_inc_conn_usage_count(conn_tmp);
+				is_last =3D 0;
+			}
+			iscsit_inc_conn_usage_count(conn);
+
+			spin_unlock_bh(&sess->conn_lock);
+			iscsit_cause_connection_reinstatement(conn, 1);
+			spin_lock_bh(&sess->conn_lock);
+
+			iscsit_dec_conn_usage_count(conn);
+			if (is_last =3D=3D 0)
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
+int iscsit_release_sessions_for_tpg(struct iscsi_portal_group *tpg, in=
t force)
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
+		iscsit_free_session(sess);
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
+MODULE_DESCRIPTION("iSCSI-Target Driver for mainline target infrastruc=
ture");
+MODULE_VERSION("4.1.x");
+MODULE_AUTHOR("nab@Linux-iSCSI.org");
+MODULE_LICENSE("GPL");
+
+module_init(iscsi_target_init_module);
+module_exit(iscsi_target_cleanup_module);
diff --git a/drivers/target/iscsi/iscsi_target.h b/drivers/target/iscsi=
/iscsi_target.h
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
+extern int iscsit_access_np(struct iscsi_np *, struct iscsi_portal_gro=
up *);
+extern int iscsit_deaccess_np(struct iscsi_np *, struct iscsi_portal_g=
roup *);
+extern struct iscsi_np *iscsit_add_np(struct __kernel_sockaddr_storage=
 *,
+				char *, int);
+extern int iscsit_reset_np_thread(struct iscsi_np *, struct iscsi_tpg_=
np *,
+				struct iscsi_portal_group *);
+extern int iscsit_del_np(struct iscsi_np *);
+extern int iscsit_add_reject_from_cmd(u8, int, int, unsigned char *, s=
truct iscsi_cmd *);
+extern int iscsit_logout_closesession(struct iscsi_cmd *, struct iscsi=
_conn *);
+extern int iscsit_logout_closeconnection(struct iscsi_cmd *, struct is=
csi_conn *);
+extern int iscsit_logout_removeconnforrecovery(struct iscsi_cmd *, str=
uct iscsi_conn *);
+extern int iscsit_send_async_msg(struct iscsi_conn *, u16, u8, u8);
+extern int iscsit_send_r2t(struct iscsi_cmd *, struct iscsi_conn *);
+extern int iscsit_build_r2ts_for_cmd(struct iscsi_cmd *, struct iscsi_=
conn *, int);
+extern void iscsit_thread_get_cpumask(struct iscsi_conn *);
+extern int iscsi_target_tx_thread(void *);
+extern int iscsi_target_rx_thread(void *);
+extern int iscsit_close_connection(struct iscsi_conn *);
+extern int iscsit_close_session(struct iscsi_session *);
+extern void iscsit_fail_session(struct iscsi_session *);
+extern int iscsit_free_session(struct iscsi_session *);
+extern void iscsit_stop_session(struct iscsi_session *, int, int);
+extern int iscsit_release_sessions_for_tpg(struct iscsi_portal_group *=
, int);
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
diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/=
iscsi/iscsi_target_core.h
new file mode 100644
index 0000000..c7ca0a0
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
+	NPF_SCTP_STRUCT_FILE	=3D 0x01 /* Bugfix */
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
+	/* Semaphore used for allocating buffer */
+	struct completion	unsolicited_data_comp;
+	/* Timer for DataOUT */
+	struct timer_list	dataout_timer;
+	/* Iovecs for SCSI data payload RX/TX w/ kernel level sockets */
+	struct kvec		*iov_data;
+	/* Iovecs for miscellaneous purposes */
+#define ISCSI_MISC_IOVECS			5
+	struct kvec		iov_misc[ISCSI_MISC_IOVECS];
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
+	spinlock_t		cmdsn_lock;
+	spinlock_t		conn_lock;
+	spinlock_t		cr_a_lock;
+	spinlock_t		cr_i_lock;
+	spinlock_t		session_usage_lock;
+	spinlock_t		ttt_lock;
+	struct list_head	sess_ooo_cmdsn_list;
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
--=20
1.7.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
