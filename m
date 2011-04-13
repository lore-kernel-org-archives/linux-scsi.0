From: Kiran Patil <kiran.patil@intel.com>
Subject: [RFC v0 PATCH] tcm_fc: Adding FC_FC4 provider (tcm_fc) for FCoE
	target (TCM - target core) support
Date: Wed, 13 Apr 2011 13:28:53 -0700
Message-ID: <20110413202852.5370.55797.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:33646 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757552Ab1DMU1G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2011 16:27:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, devel@open-fcoe.org

From: Kiran Patil <kiran.patil@intel.com>

This is a comprehensive patch for FC-FC4 provider. tcm_fc is a FC-FC4 provider which
glues target core (TCM) with Fiber channel library (libfc). tcm_fc uses
existing FC4 provider hooks from Fiber channel library. This Fiber channel library
is used by FCoE (transport - FC over Ethernet) protocol driver as well.

Combination of modules such as Fiber channel library, tcm_fc, TCM target core,
and FCoE protocol driver enables functional FCoE target.

This patch includes initial commit for tcm_fc plus additional enhancement, bug fixes.

This tcm_fc module essentially contains 3 entry points such as "prli", "prlo", "recv".
When process login request (ELS_PRLI) request is received, Fiber channel library (libfc)
module calls passive providers (FC-FC4, tcm_fc) (if any registered) "prli" function. Likewise
when LOGO request is received, "prlo" function of passive provider is invoked by libfc.
For all other request (e.g. any read/write, task management, LUN inquiry commands), "recv"
function of passiver provider is invoked by libfc. Those passive providers
"prli, prlo, recv" functions interact with TCM target core for requested operation.

This module was primarily developed by "Joe Eykholt" and  there were significant contributions
from the people listed under signed-off.

This patch was validated for functionality and applicability against latest scsi-misc,
"git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git"

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Kiran Patil <kiran.patil@intel.com>
---

 drivers/target/Kconfig           |    1 
 drivers/target/Makefile          |    2 
 drivers/target/tcm_fc/Kconfig    |    5 
 drivers/target/tcm_fc/Makefile   |   15 +
 drivers/target/tcm_fc/tcm_fc.h   |  215 ++++++++++++
 drivers/target/tcm_fc/tfc_cmd.c  |  696 ++++++++++++++++++++++++++++++++++++++
 drivers/target/tcm_fc/tfc_conf.c |  677 +++++++++++++++++++++++++++++++++++++
 drivers/target/tcm_fc/tfc_io.c   |  374 ++++++++++++++++++++
 drivers/target/tcm_fc/tfc_sess.c |  541 ++++++++++++++++++++++++++++++
 9 files changed, 2526 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/tcm_fc/Kconfig
 create mode 100644 drivers/target/tcm_fc/Makefile
 create mode 100644 drivers/target/tcm_fc/tcm_fc.h
 create mode 100644 drivers/target/tcm_fc/tfc_cmd.c
 create mode 100644 drivers/target/tcm_fc/tfc_conf.c
 create mode 100644 drivers/target/tcm_fc/tfc_io.c
 create mode 100644 drivers/target/tcm_fc/tfc_sess.c

diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
index 9ef2dbb..5cb0f0e 100644
--- a/drivers/target/Kconfig
+++ b/drivers/target/Kconfig
@@ -30,5 +30,6 @@ config TCM_PSCSI
 	passthrough access to Linux/SCSI device
 
 source "drivers/target/loopback/Kconfig"
+source "drivers/target/tcm_fc/Kconfig"
 
 endif
diff --git a/drivers/target/Makefile b/drivers/target/Makefile
index 1178bbf..21df808 100644
--- a/drivers/target/Makefile
+++ b/drivers/target/Makefile
@@ -24,3 +24,5 @@ obj-$(CONFIG_TCM_PSCSI)		+= target_core_pscsi.o
 
 # Fabric modules
 obj-$(CONFIG_LOOPBACK_TARGET)	+= loopback/
+
+obj-$(CONFIG_TCM_FC)		+= tcm_fc/
diff --git a/drivers/target/tcm_fc/Kconfig b/drivers/target/tcm_fc/Kconfig
new file mode 100644
index 0000000..40caf45
--- /dev/null
+++ b/drivers/target/tcm_fc/Kconfig
@@ -0,0 +1,5 @@
+config TCM_FC
+	tristate "TCM_FC fabric Plugin"
+	depends on LIBFC
+	help
+	Say Y here to enable the TCM FC plugin for accessing FC fabrics in TCM
diff --git a/drivers/target/tcm_fc/Makefile b/drivers/target/tcm_fc/Makefile
new file mode 100644
index 0000000..7a5c2b6
--- /dev/null
+++ b/drivers/target/tcm_fc/Makefile
@@ -0,0 +1,15 @@
+EXTRA_CFLAGS += -I$(srctree)/drivers/target/ \
+		-I$(srctree)/drivers/scsi/ \
+		-I$(srctree)/include/scsi/ \
+		-I$(srctree)/drivers/target/tcm_fc/
+
+tcm_fc-y +=	tfc_cmd.o \
+		tfc_conf.o \
+		tfc_io.o \
+		tfc_sess.o
+
+obj-$(CONFIG_TCM_FC)	+= tcm_fc.o
+
+ifdef CONFIGFS_TCM_FC_DEBUG
+EXTRA_CFLAGS	+= -DTCM_FC_DEBUG
+endif
diff --git a/drivers/target/tcm_fc/tcm_fc.h b/drivers/target/tcm_fc/tcm_fc.h
new file mode 100644
index 0000000..defff32
--- /dev/null
+++ b/drivers/target/tcm_fc/tcm_fc.h
@@ -0,0 +1,215 @@
+/*
+ * Copyright (c) 2010 Cisco Systems, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+#ifndef __TCM_FC_H__
+#define __TCM_FC_H__
+
+#define FT_VERSION "0.3"
+
+#define FT_NAMELEN 32		/* length of ASCII WWPNs including pad */
+#define FT_TPG_NAMELEN 32	/* max length of TPG name */
+#define FT_LUN_NAMELEN 32	/* max length of LUN name */
+
+/*
+ * Debug options.
+ */
+#define FT_DEBUG_CONF	0x01	/* configuration messages */
+#define	FT_DEBUG_SESS	0x02	/* session messages */
+#define	FT_DEBUG_TM	0x04	/* TM operations */
+#define	FT_DEBUG_IO	0x08	/* I/O commands */
+#define	FT_DEBUG_DATA	0x10	/* Data transfer */
+
+extern unsigned int ft_debug_logging;	/* debug options */
+
+#define FT_DEBUG(mask, fmt, args...)					\
+	do {								\
+		if (ft_debug_logging & (mask))				\
+			printk(KERN_INFO "tcm_fc: %s: " fmt,		\
+				__func__, ##args);			\
+	} while (0)
+
+#define	FT_CONF_DBG(fmt, args...)	FT_DEBUG(FT_DEBUG_CONF, fmt, ##args)
+#define	FT_SESS_DBG(fmt, args...)	FT_DEBUG(FT_DEBUG_SESS, fmt, ##args)
+#define	FT_TM_DBG(fmt, args...)		FT_DEBUG(FT_DEBUG_TM, fmt, ##args)
+#define	FT_IO_DBG(fmt, args...)		FT_DEBUG(FT_DEBUG_IO, fmt, ##args)
+#define	FT_DATA_DBG(fmt, args...)	FT_DEBUG(FT_DEBUG_DATA, fmt, ##args)
+
+struct ft_transport_id {
+	__u8	format;
+	__u8	__resvd1[7];
+	__u8	wwpn[8];
+	__u8	__resvd2[8];
+} __attribute__((__packed__));
+
+/*
+ * Session (remote port).
+ */
+struct ft_sess {
+	u32 port_id;			/* for hash lookup use only */
+	u32 params;
+	u16 max_frame;			/* maximum frame size */
+	u64 port_name;			/* port name for transport ID */
+	struct ft_tport *tport;
+	struct se_session *se_sess;
+	struct hlist_node hash;		/* linkage in ft_sess_hash table */
+	struct rcu_head rcu;
+	struct kref kref;		/* ref for hash and outstanding I/Os */
+};
+
+/*
+ * Hash table of sessions per local port.
+ * Hash lookup by remote port FC_ID.
+ */
+#define	FT_SESS_HASH_BITS	6
+#define	FT_SESS_HASH_SIZE	(1 << FT_SESS_HASH_BITS)
+
+/*
+ * Per local port data.
+ * This is created only after a TPG exists that allows target function
+ * for the local port.  If the TPG exists, this is allocated when
+ * we're notified that the local port has been created, or when
+ * the first PRLI provider callback is received.
+ */
+struct ft_tport {
+	struct fc_lport *lport;
+	struct ft_tpg *tpg;		/* NULL if TPG deleted before tport */
+	u32	sess_count;		/* number of sessions in hash */
+	struct rcu_head rcu;
+	struct hlist_head hash[FT_SESS_HASH_SIZE];	/* list of sessions */
+};
+
+/*
+ * Node ID and authentication.
+ */
+struct ft_node_auth {
+	u64	port_name;
+	u64	node_name;
+};
+
+/*
+ * Node ACL for FC remote port session.
+ */
+struct ft_node_acl {
+	struct ft_node_auth node_auth;
+	struct se_node_acl se_node_acl;
+};
+
+struct ft_lun {
+	u32 index;
+	char name[FT_LUN_NAMELEN];
+};
+
+/*
+ * Target portal group (local port).
+ */
+struct ft_tpg {
+	u32 index;
+	struct ft_lport_acl *lport_acl;
+	struct ft_tport *tport;		/* active tport or NULL */
+	struct list_head list;		/* linkage in ft_lport_acl tpg_list */
+	struct list_head lun_list;	/* head of LUNs */
+	struct se_portal_group se_tpg;
+	struct task_struct *thread;	/* processing thread */
+	struct se_queue_obj qobj;	/* queue for processing thread */
+};
+
+struct ft_lport_acl {
+	u64 wwpn;
+	char name[FT_NAMELEN];
+	struct list_head list;
+	struct list_head tpg_list;
+	struct se_wwn fc_lport_wwn;
+};
+
+enum ft_cmd_state {
+	FC_CMD_ST_NEW = 0,
+	FC_CMD_ST_REJ
+};
+
+/*
+ * Commands
+ */
+struct ft_cmd {
+	enum ft_cmd_state state;
+	u16 lun;			/* LUN from request */
+	struct ft_sess *sess;		/* session held for cmd */
+	struct fc_seq *seq;		/* sequence in exchange mgr */
+	struct se_cmd se_cmd;		/* Local TCM I/O descriptor */
+	struct fc_frame *req_frame;
+	unsigned char *cdb;		/* pointer to CDB inside frame */
+	u32 write_data_len;		/* data received on writes */
+	struct se_queue_req se_req;
+	/* Local sense buffer */
+	unsigned char ft_sense_buffer[TRANSPORT_SENSE_BUFFER];
+	u32 was_ddp_setup:1;		/* Set only if ddp is setup */
+	struct scatterlist *sg;		/* Set only if DDP is setup */
+	u32 sg_cnt;			/* No. of item in scatterlist */
+};
+
+extern struct list_head ft_lport_list;
+extern struct mutex ft_lport_lock;
+extern struct fc4_prov ft_prov;
+extern struct target_fabric_configfs *ft_configfs;
+
+/*
+ * Fabric methods.
+ */
+
+/*
+ * Session ops.
+ */
+void ft_sess_put(struct ft_sess *);
+int ft_sess_shutdown(struct se_session *);
+void ft_sess_close(struct se_session *);
+void ft_sess_stop(struct se_session *, int, int);
+int ft_sess_logged_in(struct se_session *);
+u32 ft_sess_get_index(struct se_session *);
+u32 ft_sess_get_port_name(struct se_session *, unsigned char *, u32);
+void ft_sess_set_erl0(struct se_session *);
+
+void ft_lport_add(struct fc_lport *, void *);
+void ft_lport_del(struct fc_lport *, void *);
+int ft_lport_notify(struct notifier_block *, unsigned long, void *);
+
+/*
+ * IO methods.
+ */
+void ft_check_stop_free(struct se_cmd *);
+void ft_release_cmd(struct se_cmd *);
+int ft_queue_status(struct se_cmd *);
+int ft_queue_data_in(struct se_cmd *);
+int ft_write_pending(struct se_cmd *);
+int ft_write_pending_status(struct se_cmd *);
+u32 ft_get_task_tag(struct se_cmd *);
+int ft_get_cmd_state(struct se_cmd *);
+void ft_new_cmd_failure(struct se_cmd *);
+int ft_queue_tm_resp(struct se_cmd *);
+int ft_is_state_remove(struct se_cmd *);
+
+/*
+ * other internal functions.
+ */
+int ft_thread(void *);
+void ft_recv_req(struct ft_sess *, struct fc_frame *);
+struct ft_tpg *ft_lport_find_tpg(struct fc_lport *);
+struct ft_node_acl *ft_acl_get(struct ft_tpg *, struct fc_rport_priv *);
+
+void ft_recv_write_data(struct ft_cmd *, struct fc_frame *);
+void ft_dump_cmd(struct ft_cmd *, const char *caller);
+
+ssize_t ft_format_wwn(char *, size_t, u64);
+
+#endif /* __TCM_FC_H__ */
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
new file mode 100644
index 0000000..49e5177
--- /dev/null
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -0,0 +1,696 @@
+/*
+ * Copyright (c) 2010 Cisco Systems, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+/* XXX TBD some includes may be extraneous */
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
+#include <linux/hash.h>
+#include <asm/unaligned.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/libfc.h>
+#include <scsi/fc_encode.h>
+
+#include <target/target_core_base.h>
+#include <target/target_core_transport.h>
+#include <target/target_core_fabric_ops.h>
+#include <target/target_core_device.h>
+#include <target/target_core_tpg.h>
+#include <target/target_core_configfs.h>
+#include <target/target_core_base.h>
+#include <target/target_core_tmr.h>
+#include <target/configfs_macros.h>
+
+#include "tcm_fc.h"
+
+/*
+ * Dump cmd state for debugging.
+ */
+void ft_dump_cmd(struct ft_cmd *cmd, const char *caller)
+{
+	struct fc_exch *ep;
+	struct fc_seq *sp;
+	struct se_cmd *se_cmd;
+	struct se_mem *mem;
+	struct se_transport_task *task;
+
+	if (!(ft_debug_logging & FT_DEBUG_IO))
+		return;
+
+	se_cmd = &cmd->se_cmd;
+	printk(KERN_INFO "%s: cmd %p state %d sess %p seq %p se_cmd %p\n",
+		caller, cmd, cmd->state, cmd->sess, cmd->seq, se_cmd);
+	printk(KERN_INFO "%s: cmd %p cdb %p\n",
+		caller, cmd, cmd->cdb);
+	printk(KERN_INFO "%s: cmd %p lun %d\n", caller, cmd, cmd->lun);
+
+	task = T_TASK(se_cmd);
+	printk(KERN_INFO "%s: cmd %p task %p se_num %u buf %p len %u se_cmd_flags <0x%x>\n",
+	       caller, cmd, task, task->t_tasks_se_num,
+	       task->t_task_buf, se_cmd->data_length, se_cmd->se_cmd_flags);
+	if (task->t_mem_list)
+		list_for_each_entry(mem, task->t_mem_list, se_list)
+			printk(KERN_INFO "%s: cmd %p mem %p page %p "
+			       "len 0x%x off 0x%x\n",
+			       caller, cmd, mem,
+			       mem->se_page, mem->se_len, mem->se_off);
+	sp = cmd->seq;
+	if (sp) {
+		ep = fc_seq_exch(sp);
+		printk(KERN_INFO "%s: cmd %p sid %x did %x "
+			"ox_id %x rx_id %x seq_id %x e_stat %x\n",
+			caller, cmd, ep->sid, ep->did, ep->oxid, ep->rxid,
+			sp->id, ep->esb_stat);
+	}
+	print_hex_dump(KERN_INFO, "ft_dump_cmd ", DUMP_PREFIX_NONE,
+		16, 4, cmd->cdb, MAX_COMMAND_SIZE, 0);
+}
+
+/*
+ * Get LUN from CDB.
+ */
+static int ft_get_lun_for_cmd(struct ft_cmd *cmd, u8 *lunp)
+{
+	u64 lun;
+
+	lun = lunp[1];
+	switch (lunp[0] >> 6) {
+	case 0:
+		break;
+	case 1:
+		lun |= (lunp[0] & 0x3f) << 8;
+		break;
+	default:
+		return -1;
+	}
+	if (lun >= TRANSPORT_MAX_LUNS_PER_TPG)
+		return -1;
+	cmd->lun = lun;
+	return transport_get_lun_for_cmd(&cmd->se_cmd, NULL, lun);
+}
+
+static void ft_queue_cmd(struct ft_sess *sess, struct ft_cmd *cmd)
+{
+	struct se_queue_obj *qobj;
+	unsigned long flags;
+
+	qobj = &sess->tport->tpg->qobj;
+	spin_lock_irqsave(&qobj->cmd_queue_lock, flags);
+	list_add_tail(&cmd->se_req.qr_list, &qobj->qobj_list);
+	spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
+	atomic_inc(&qobj->queue_cnt);
+	wake_up_interruptible(&qobj->thread_wq);
+}
+
+static struct ft_cmd *ft_dequeue_cmd(struct se_queue_obj *qobj)
+{
+	unsigned long flags;
+	struct se_queue_req *qr;
+
+	spin_lock_irqsave(&qobj->cmd_queue_lock, flags);
+	if (list_empty(&qobj->qobj_list)) {
+		spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
+		return NULL;
+	}
+	qr = list_first_entry(&qobj->qobj_list, struct se_queue_req, qr_list);
+	list_del(&qr->qr_list);
+	atomic_dec(&qobj->queue_cnt);
+	spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
+	return container_of(qr, struct ft_cmd, se_req);
+}
+
+static void ft_free_cmd(struct ft_cmd *cmd)
+{
+	struct fc_frame *fp;
+	struct fc_lport *lport;
+
+	if (!cmd)
+		return;
+	fp = cmd->req_frame;
+	lport = fr_dev(fp);
+	if (fr_seq(fp))
+		lport->tt.seq_release(fr_seq(fp));
+	fc_frame_free(fp);
+	ft_sess_put(cmd->sess);	/* undo get from lookup at recv */
+	kfree(cmd);
+}
+
+void ft_release_cmd(struct se_cmd *se_cmd)
+{
+	struct ft_cmd *cmd = container_of(se_cmd, struct ft_cmd, se_cmd);
+
+	ft_free_cmd(cmd);
+}
+
+void ft_check_stop_free(struct se_cmd *se_cmd)
+{
+	transport_generic_free_cmd(se_cmd, 0, 1, 0);
+}
+
+/*
+ * Send response.
+ */
+int ft_queue_status(struct se_cmd *se_cmd)
+{
+	struct ft_cmd *cmd = container_of(se_cmd, struct ft_cmd, se_cmd);
+	struct fc_frame *fp;
+	struct fcp_resp_with_ext *fcp;
+	struct fc_lport *lport;
+	struct fc_exch *ep;
+	size_t len;
+
+	ft_dump_cmd(cmd, __func__);
+	ep = fc_seq_exch(cmd->seq);
+	lport = ep->lp;
+	len = sizeof(*fcp) + se_cmd->scsi_sense_length;
+	fp = fc_frame_alloc(lport, len);
+	if (!fp) {
+		/* XXX shouldn't just drop it - requeue and retry? */
+		return 0;
+	}
+	fcp = fc_frame_payload_get(fp, len);
+	memset(fcp, 0, len);
+	fcp->resp.fr_status = se_cmd->scsi_status;
+
+	len = se_cmd->scsi_sense_length;
+	if (len) {
+		fcp->resp.fr_flags |= FCP_SNS_LEN_VAL;
+		fcp->ext.fr_sns_len = htonl(len);
+		memcpy((fcp + 1), se_cmd->sense_buffer, len);
+	}
+
+	/*
+	 * Test underflow and overflow with one mask.  Usually both are off.
+	 * Bidirectional commands are not handled yet.
+	 */
+	if (se_cmd->se_cmd_flags & (SCF_OVERFLOW_BIT | SCF_UNDERFLOW_BIT)) {
+		if (se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT)
+			fcp->resp.fr_flags |= FCP_RESID_OVER;
+		else
+			fcp->resp.fr_flags |= FCP_RESID_UNDER;
+		fcp->ext.fr_resid = cpu_to_be32(se_cmd->residual_count);
+	}
+
+	/*
+	 * Send response.
+	 */
+	cmd->seq = lport->tt.seq_start_next(cmd->seq);
+	fc_fill_fc_hdr(fp, FC_RCTL_DD_CMD_STATUS, ep->did, ep->sid, FC_TYPE_FCP,
+		       FC_FC_EX_CTX | FC_FC_LAST_SEQ | FC_FC_END_SEQ, 0);
+
+	lport->tt.seq_send(lport, cmd->seq, fp);
+	lport->tt.exch_done(cmd->seq);
+	return 0;
+}
+
+int ft_write_pending_status(struct se_cmd *se_cmd)
+{
+	struct ft_cmd *cmd = container_of(se_cmd, struct ft_cmd, se_cmd);
+
+	return cmd->write_data_len != se_cmd->data_length;
+}
+
+/*
+ * Send TX_RDY (transfer ready).
+ */
+int ft_write_pending(struct se_cmd *se_cmd)
+{
+	struct ft_cmd *cmd = container_of(se_cmd, struct ft_cmd, se_cmd);
+	struct fc_frame *fp;
+	struct fcp_txrdy *txrdy;
+	struct fc_lport *lport;
+	struct fc_exch *ep;
+	struct fc_frame_header *fh;
+	u32 f_ctl;
+
+	ft_dump_cmd(cmd, __func__);
+
+	ep = fc_seq_exch(cmd->seq);
+	lport = ep->lp;
+	fp = fc_frame_alloc(lport, sizeof(*txrdy));
+	if (!fp)
+		return PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
+
+	txrdy = fc_frame_payload_get(fp, sizeof(*txrdy));
+	memset(txrdy, 0, sizeof(*txrdy));
+	txrdy->ft_burst_len = htonl(se_cmd->data_length);
+
+	cmd->seq = lport->tt.seq_start_next(cmd->seq);
+	fc_fill_fc_hdr(fp, FC_RCTL_DD_DATA_DESC, ep->did, ep->sid, FC_TYPE_FCP,
+		       FC_FC_EX_CTX | FC_FC_END_SEQ | FC_FC_SEQ_INIT, 0);
+
+	fh = fc_frame_header_get(fp);
+	f_ctl = ntoh24(fh->fh_f_ctl);
+
+	/* Only if it is 'Exchange Responder' */
+	if (f_ctl & FC_FC_EX_CTX) {
+		/* Target is 'exchange responder' and sending XFER_READY
+		 * to 'exchange initiator (initiator)'
+		 */
+		if ((ep->xid <= lport->lro_xid) &&
+		    (fh->fh_r_ctl == FC_RCTL_DD_DATA_DESC)) {
+			if (se_cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) {
+				/*
+				 * Map se_mem list to scatterlist, so that
+				 * DDP can be setup. DDP setup function require
+				 * scatterlist. se_mem_list is internal to
+				 * TCM/LIO target
+				 */
+				transport_do_task_sg_chain(se_cmd);
+				cmd->sg = T_TASK(se_cmd)->t_tasks_sg_chained;
+				cmd->sg_cnt =
+					T_TASK(se_cmd)->t_tasks_sg_chained_no;
+			}
+			if (cmd->sg && lport->tt.ddp_setup(lport, ep->xid,
+						    cmd->sg, cmd->sg_cnt))
+				cmd->was_ddp_setup = 1;
+		}
+	}
+	lport->tt.seq_send(lport, cmd->seq, fp);
+	return 0;
+}
+
+u32 ft_get_task_tag(struct se_cmd *se_cmd)
+{
+	struct ft_cmd *cmd = container_of(se_cmd, struct ft_cmd, se_cmd);
+
+	return fc_seq_exch(cmd->seq)->rxid;
+}
+
+int ft_get_cmd_state(struct se_cmd *se_cmd)
+{
+	struct ft_cmd *cmd = container_of(se_cmd, struct ft_cmd, se_cmd);
+
+	return cmd->state;
+}
+
+int ft_is_state_remove(struct se_cmd *se_cmd)
+{
+	return 0;	/* XXX TBD */
+}
+
+void ft_new_cmd_failure(struct se_cmd *se_cmd)
+{
+	/* XXX TBD */
+	printk(KERN_INFO "%s: se_cmd %p\n", __func__, se_cmd);
+}
+
+/*
+ * FC sequence response handler for follow-on sequences (data) and aborts.
+ */
+static void ft_recv_seq(struct fc_seq *sp, struct fc_frame *fp, void *arg)
+{
+	struct ft_cmd *cmd = arg;
+	struct fc_frame_header *fh;
+
+	if (IS_ERR(fp)) {
+		/* XXX need to find cmd if queued */
+		cmd->se_cmd.t_state = TRANSPORT_REMOVE;
+		cmd->seq = NULL;
+		transport_generic_free_cmd(&cmd->se_cmd, 0, 1, 0);
+		return;
+	}
+
+	fh = fc_frame_header_get(fp);
+
+	switch (fh->fh_r_ctl) {
+	case FC_RCTL_DD_SOL_DATA:	/* write data */
+		ft_recv_write_data(cmd, fp);
+		break;
+	case FC_RCTL_DD_UNSOL_CTL:	/* command */
+	case FC_RCTL_DD_SOL_CTL:	/* transfer ready */
+	case FC_RCTL_DD_DATA_DESC:	/* transfer ready */
+	default:
+		printk(KERN_INFO "%s: unhandled frame r_ctl %x\n",
+		       __func__, fh->fh_r_ctl);
+		fc_frame_free(fp);
+		transport_generic_free_cmd(&cmd->se_cmd, 0, 1, 0);
+		break;
+	}
+}
+
+/*
+ * Send a FCP response including SCSI status and optional FCP rsp_code.
+ * status is SAM_STAT_GOOD (zero) iff code is valid.
+ * This is used in error cases, such as allocation failures.
+ */
+static void ft_send_resp_status(struct fc_lport *lport,
+				const struct fc_frame *rx_fp,
+				u32 status, enum fcp_resp_rsp_codes code)
+{
+	struct fc_frame *fp;
+	struct fc_seq *sp;
+	const struct fc_frame_header *fh;
+	size_t len;
+	struct fcp_resp_with_ext *fcp;
+	struct fcp_resp_rsp_info *info;
+
+	fh = fc_frame_header_get(rx_fp);
+	FT_IO_DBG("FCP error response: did %x oxid %x status %x code %x\n",
+		  ntoh24(fh->fh_s_id), ntohs(fh->fh_ox_id), status, code);
+	len = sizeof(*fcp);
+	if (status == SAM_STAT_GOOD)
+		len += sizeof(*info);
+	fp = fc_frame_alloc(lport, len);
+	if (!fp)
+		return;
+	fcp = fc_frame_payload_get(fp, len);
+	memset(fcp, 0, len);
+	fcp->resp.fr_status = status;
+	if (status == SAM_STAT_GOOD) {
+		fcp->ext.fr_rsp_len = htonl(sizeof(*info));
+		fcp->resp.fr_flags |= FCP_RSP_LEN_VAL;
+		info = (struct fcp_resp_rsp_info *)(fcp + 1);
+		info->rsp_code = code;
+	}
+
+	fc_fill_reply_hdr(fp, rx_fp, FC_RCTL_DD_CMD_STATUS, 0);
+	sp = fr_seq(fp);
+	if (sp)
+		lport->tt.seq_send(lport, sp, fp);
+	else
+		lport->tt.frame_send(lport, fp);
+}
+
+/*
+ * Send error or task management response.
+ * Always frees the cmd and associated state.
+ */
+static void ft_send_resp_code(struct ft_cmd *cmd, enum fcp_resp_rsp_codes code)
+{
+	ft_send_resp_status(cmd->sess->tport->lport,
+			    cmd->req_frame, SAM_STAT_GOOD, code);
+	ft_free_cmd(cmd);
+}
+
+/*
+ * Handle Task Management Request.
+ */
+static void ft_send_tm(struct ft_cmd *cmd)
+{
+	struct se_tmr_req *tmr;
+	struct fcp_cmnd *fcp;
+	u8 tm_func;
+
+	fcp = fc_frame_payload_get(cmd->req_frame, sizeof(*fcp));
+
+	switch (fcp->fc_tm_flags) {
+	case FCP_TMF_LUN_RESET:
+		tm_func = TMR_LUN_RESET;
+		if (ft_get_lun_for_cmd(cmd, fcp->fc_lun) < 0) {
+			ft_dump_cmd(cmd, __func__);
+			transport_send_check_condition_and_sense(&cmd->se_cmd,
+				cmd->se_cmd.scsi_sense_reason, 0);
+			ft_sess_put(cmd->sess);
+			return;
+		}
+		break;
+	case FCP_TMF_TGT_RESET:
+		tm_func = TMR_TARGET_WARM_RESET;
+		break;
+	case FCP_TMF_CLR_TASK_SET:
+		tm_func = TMR_CLEAR_TASK_SET;
+		break;
+	case FCP_TMF_ABT_TASK_SET:
+		tm_func = TMR_ABORT_TASK_SET;
+		break;
+	case FCP_TMF_CLR_ACA:
+		tm_func = TMR_CLEAR_ACA;
+		break;
+	default:
+		/*
+		 * FCP4r01 indicates having a combination of
+		 * tm_flags set is invalid.
+		 */
+		FT_TM_DBG("invalid FCP tm_flags %x\n", fcp->fc_tm_flags);
+		ft_send_resp_code(cmd, FCP_CMND_FIELDS_INVALID);
+		return;
+	}
+
+	FT_TM_DBG("alloc tm cmd fn %d\n", tm_func);
+	tmr = core_tmr_alloc_req(&cmd->se_cmd, cmd, tm_func);
+	if (!tmr) {
+		FT_TM_DBG("alloc failed\n");
+		ft_send_resp_code(cmd, FCP_TMF_FAILED);
+		return;
+	}
+	cmd->se_cmd.se_tmr_req = tmr;
+	transport_generic_handle_tmr(&cmd->se_cmd);
+}
+
+/*
+ * Send status from completed task management request.
+ */
+int ft_queue_tm_resp(struct se_cmd *se_cmd)
+{
+	struct ft_cmd *cmd = container_of(se_cmd, struct ft_cmd, se_cmd);
+	struct se_tmr_req *tmr = se_cmd->se_tmr_req;
+	enum fcp_resp_rsp_codes code;
+
+	switch (tmr->response) {
+	case TMR_FUNCTION_COMPLETE:
+		code = FCP_TMF_CMPL;
+		break;
+	case TMR_LUN_DOES_NOT_EXIST:
+		code = FCP_TMF_INVALID_LUN;
+		break;
+	case TMR_FUNCTION_REJECTED:
+		code = FCP_TMF_REJECTED;
+		break;
+	case TMR_TASK_DOES_NOT_EXIST:
+	case TMR_TASK_STILL_ALLEGIANT:
+	case TMR_TASK_FAILOVER_NOT_SUPPORTED:
+	case TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED:
+	case TMR_FUNCTION_AUTHORIZATION_FAILED:
+	default:
+		code = FCP_TMF_FAILED;
+		break;
+	}
+	FT_TM_DBG("tmr fn %d resp %d fcp code %d\n",
+		  tmr->function, tmr->response, code);
+	ft_send_resp_code(cmd, code);
+	return 0;
+}
+
+/*
+ * Handle incoming FCP command.
+ */
+static void ft_recv_cmd(struct ft_sess *sess, struct fc_frame *fp)
+{
+	struct ft_cmd *cmd;
+	struct fc_lport *lport = sess->tport->lport;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC);
+	if (!cmd)
+		goto busy;
+	cmd->sess = sess;
+	cmd->seq = lport->tt.seq_assign(lport, fp);
+	if (!cmd->seq) {
+		kfree(cmd);
+		goto busy;
+	}
+	cmd->req_frame = fp;		/* hold frame during cmd */
+	ft_queue_cmd(sess, cmd);
+	return;
+
+busy:
+	FT_IO_DBG("cmd or seq allocation failure - sending BUSY\n");
+	ft_send_resp_status(lport, fp, SAM_STAT_BUSY, 0);
+	fc_frame_free(fp);
+	ft_sess_put(sess);		/* undo get from lookup */
+}
+
+
+/*
+ * Handle incoming FCP frame.
+ * Caller has verified that the frame is type FCP.
+ */
+void ft_recv_req(struct ft_sess *sess, struct fc_frame *fp)
+{
+	struct fc_frame_header *fh = fc_frame_header_get(fp);
+
+	switch (fh->fh_r_ctl) {
+	case FC_RCTL_DD_UNSOL_CMD:	/* command */
+		ft_recv_cmd(sess, fp);
+		break;
+	case FC_RCTL_DD_SOL_DATA:	/* write data */
+	case FC_RCTL_DD_UNSOL_CTL:
+	case FC_RCTL_DD_SOL_CTL:
+	case FC_RCTL_DD_DATA_DESC:	/* transfer ready */
+	case FC_RCTL_ELS4_REQ:		/* SRR, perhaps */
+	default:
+		printk(KERN_INFO "%s: unhandled frame r_ctl %x\n",
+		       __func__, fh->fh_r_ctl);
+		fc_frame_free(fp);
+		ft_sess_put(sess);	/* undo get from lookup */
+		break;
+	}
+}
+
+/*
+ * Send new command to target.
+ */
+static void ft_send_cmd(struct ft_cmd *cmd)
+{
+	struct fc_frame_header *fh = fc_frame_header_get(cmd->req_frame);
+	struct se_cmd *se_cmd;
+	struct fcp_cmnd *fcp;
+	int data_dir;
+	u32 data_len;
+	int task_attr;
+	int ret;
+
+	fcp = fc_frame_payload_get(cmd->req_frame, sizeof(*fcp));
+	if (!fcp)
+		goto err;
+
+	if (fcp->fc_flags & FCP_CFL_LEN_MASK)
+		goto err;		/* not handling longer CDBs yet */
+
+	if (fcp->fc_tm_flags) {
+		task_attr = FCP_PTA_SIMPLE;
+		data_dir = DMA_NONE;
+		data_len = 0;
+	} else {
+		switch (fcp->fc_flags & (FCP_CFL_RDDATA | FCP_CFL_WRDATA)) {
+		case 0:
+			data_dir = DMA_NONE;
+			break;
+		case FCP_CFL_RDDATA:
+			data_dir = DMA_FROM_DEVICE;
+			break;
+		case FCP_CFL_WRDATA:
+			data_dir = DMA_TO_DEVICE;
+			break;
+		case FCP_CFL_WRDATA | FCP_CFL_RDDATA:
+			goto err;	/* TBD not supported by tcm_fc yet */
+		}
+
+		/* FCP_PTA_ maps 1:1 to TASK_ATTR_ */
+		task_attr = fcp->fc_pri_ta & FCP_PTA_MASK;
+		data_len = ntohl(fcp->fc_dl);
+		cmd->cdb = fcp->fc_cdb;
+	}
+
+	se_cmd = &cmd->se_cmd;
+	/*
+	 * Initialize struct se_cmd descriptor from target_core_mod
+	 * infrastructure
+	 */
+	transport_init_se_cmd(se_cmd, &ft_configfs->tf_ops, cmd->sess->se_sess,
+			      data_len, data_dir, task_attr,
+			      &cmd->ft_sense_buffer[0]);
+	/*
+	 * Check for FCP task management flags
+	 */
+	if (fcp->fc_tm_flags) {
+		ft_send_tm(cmd);
+		return;
+	}
+
+	fc_seq_exch(cmd->seq)->lp->tt.seq_set_resp(cmd->seq, ft_recv_seq, cmd);
+
+	ret = ft_get_lun_for_cmd(cmd, fcp->fc_lun);
+	if (ret < 0) {
+		ft_dump_cmd(cmd, __func__);
+		transport_send_check_condition_and_sense(&cmd->se_cmd,
+			cmd->se_cmd.scsi_sense_reason, 0);
+		return;
+	}
+
+	ret = transport_generic_allocate_tasks(se_cmd, cmd->cdb);
+
+	FT_IO_DBG("r_ctl %x alloc task ret %d\n", fh->fh_r_ctl, ret);
+	ft_dump_cmd(cmd, __func__);
+
+	if (ret == -1) {
+		transport_send_check_condition_and_sense(se_cmd,
+				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
+		transport_generic_free_cmd(se_cmd, 0, 1, 0);
+		return;
+	}
+	if (ret == -2) {
+		if (se_cmd->se_cmd_flags & SCF_SCSI_RESERVATION_CONFLICT)
+			ft_queue_status(se_cmd);
+		else
+			transport_send_check_condition_and_sense(se_cmd,
+					se_cmd->scsi_sense_reason, 0);
+		transport_generic_free_cmd(se_cmd, 0, 1, 0);
+		return;
+	}
+	transport_generic_handle_cdb(se_cmd);
+	return;
+
+err:
+	ft_send_resp_code(cmd, FCP_CMND_FIELDS_INVALID);
+	return;
+}
+
+/*
+ * Handle request in the command thread.
+ */
+static void ft_exec_req(struct ft_cmd *cmd)
+{
+	FT_IO_DBG("cmd state %x\n", cmd->state);
+	switch (cmd->state) {
+	case FC_CMD_ST_NEW:
+		ft_send_cmd(cmd);
+		break;
+	default:
+		break;
+	}
+}
+
+/*
+ * Processing thread.
+ * Currently one thread per tpg.
+ */
+int ft_thread(void *arg)
+{
+	struct ft_tpg *tpg = arg;
+	struct se_queue_obj *qobj = &tpg->qobj;
+	struct ft_cmd *cmd;
+	int ret;
+
+	set_user_nice(current, -20);
+
+	while (!kthread_should_stop()) {
+		ret = wait_event_interruptible(qobj->thread_wq,
+			atomic_read(&qobj->queue_cnt) || kthread_should_stop());
+		if (ret < 0 || kthread_should_stop())
+			goto out;
+		cmd = ft_dequeue_cmd(qobj);
+		if (cmd)
+			ft_exec_req(cmd);
+	}
+
+out:
+	return 0;
+}
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
new file mode 100644
index 0000000..fcdbbff
--- /dev/null
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -0,0 +1,677 @@
+/*******************************************************************************
+ * Filename:  tcm_fc.c
+ *
+ * This file contains the configfs implementation for TCM_fc fabric node.
+ * Based on tcm_loop_configfs.c
+ *
+ * Copyright (c) 2010 Cisco Systems, Inc.
+ * Copyright (c) 2009,2010 Rising Tide, Inc.
+ * Copyright (c) 2009,2010 Linux-iSCSI.org
+ *
+ * Copyright (c) 2009,2010 Nicholas A. Bellinger <nab@linux-iscsi.org>
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
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/libfc.h>
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
+#include "tcm_fc.h"
+
+struct target_fabric_configfs *ft_configfs;
+
+LIST_HEAD(ft_lport_list);
+DEFINE_MUTEX(ft_lport_lock);
+
+unsigned int ft_debug_logging;
+module_param_named(debug_logging, ft_debug_logging, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(debug_logging, "a bit mask of logging levels");
+
+/*
+ * Parse WWN.
+ * If strict, we require lower-case hex and colon separators to be sure
+ * the name is the same as what would be generated by ft_format_wwn()
+ * so the name and wwn are mapped one-to-one.
+ */
+static ssize_t ft_parse_wwn(const char *name, u64 *wwn, int strict)
+{
+	const char *cp;
+	char c;
+	u32 nibble;
+	u32 byte = 0;
+	u32 pos = 0;
+	u32 err;
+
+	*wwn = 0;
+	for (cp = name; cp < &name[FT_NAMELEN - 1]; cp++) {
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
+	FT_CONF_DBG("err %u len %zu pos %u byte %u\n",
+		    err, cp - name, pos, byte);
+	return -1;
+}
+
+ssize_t ft_format_wwn(char *buf, size_t len, u64 wwn)
+{
+	u8 b[8];
+
+	put_unaligned_be64(wwn, b);
+	return snprintf(buf, len,
+		 "%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x",
+		 b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7]);
+}
+
+static ssize_t ft_wwn_show(void *arg, char *buf)
+{
+	u64 *wwn = arg;
+	ssize_t len;
+
+	len = ft_format_wwn(buf, PAGE_SIZE - 2, *wwn);
+	buf[len++] = '\n';
+	return len;
+}
+
+static ssize_t ft_wwn_store(void *arg, const char *buf, size_t len)
+{
+	ssize_t ret;
+	u64 wwn;
+
+	ret = ft_parse_wwn(buf, &wwn, 0);
+	if (ret > 0)
+		*(u64 *)arg = wwn;
+	return ret;
+}
+
+/*
+ * ACL auth ops.
+ */
+
+static ssize_t ft_nacl_show_port_name(
+	struct se_node_acl *se_nacl,
+	char *page)
+{
+	struct ft_node_acl *acl = container_of(se_nacl,
+			struct ft_node_acl, se_node_acl);
+
+	return ft_wwn_show(&acl->node_auth.port_name, page);
+}
+
+static ssize_t ft_nacl_store_port_name(
+	struct se_node_acl *se_nacl,
+	const char *page,
+	size_t count)
+{
+	struct ft_node_acl *acl = container_of(se_nacl,
+			struct ft_node_acl, se_node_acl);
+
+	return ft_wwn_store(&acl->node_auth.port_name, page, count);
+}
+
+TF_NACL_BASE_ATTR(ft, port_name, S_IRUGO | S_IWUSR);
+
+static ssize_t ft_nacl_show_node_name(
+	struct se_node_acl *se_nacl,
+	char *page)
+{
+	struct ft_node_acl *acl = container_of(se_nacl,
+			struct ft_node_acl, se_node_acl);
+
+	return ft_wwn_show(&acl->node_auth.node_name, page);
+}
+
+static ssize_t ft_nacl_store_node_name(
+	struct se_node_acl *se_nacl,
+	const char *page,
+	size_t count)
+{
+	struct ft_node_acl *acl = container_of(se_nacl,
+			struct ft_node_acl, se_node_acl);
+
+	return ft_wwn_store(&acl->node_auth.node_name, page, count);
+}
+
+TF_NACL_BASE_ATTR(ft, node_name, S_IRUGO | S_IWUSR);
+
+static struct configfs_attribute *ft_nacl_base_attrs[] = {
+	&ft_nacl_port_name.attr,
+	&ft_nacl_node_name.attr,
+	NULL,
+};
+
+/*
+ * ACL ops.
+ */
+
+/*
+ * Add ACL for an initiator.  The ACL is named arbitrarily.
+ * The port_name and/or node_name are attributes.
+ */
+static struct se_node_acl *ft_add_acl(
+	struct se_portal_group *se_tpg,
+	struct config_group *group,
+	const char *name)
+{
+	struct ft_node_acl *acl;
+	struct ft_tpg *tpg;
+	u64 wwpn;
+	u32 q_depth;
+
+	FT_CONF_DBG("add acl %s\n", name);
+	tpg = container_of(se_tpg, struct ft_tpg, se_tpg);
+
+	if (ft_parse_wwn(name, &wwpn, 1) < 0)
+		return ERR_PTR(-EINVAL);
+
+	acl = kzalloc(sizeof(struct ft_node_acl), GFP_KERNEL);
+	if (!(acl))
+		return ERR_PTR(-ENOMEM);
+	acl->node_auth.port_name = wwpn;
+
+	q_depth = 32;		/* XXX bogus default - get from tpg? */
+	return core_tpg_add_initiator_node_acl(&tpg->se_tpg,
+				&acl->se_node_acl, name, q_depth);
+}
+
+static void ft_del_acl(struct se_node_acl *se_acl)
+{
+	struct se_portal_group *se_tpg = se_acl->se_tpg;
+	struct ft_tpg *tpg;
+	struct ft_node_acl *acl = container_of(se_acl,
+				struct ft_node_acl, se_node_acl);
+
+	FT_CONF_DBG("del acl %s\n",
+		config_item_name(&se_acl->acl_group.cg_item));
+
+	tpg = container_of(se_tpg, struct ft_tpg, se_tpg);
+	FT_CONF_DBG("del acl %p se_acl %p tpg %p se_tpg %p\n",
+		    acl, se_acl, tpg, &tpg->se_tpg);
+
+	core_tpg_del_initiator_node_acl(&tpg->se_tpg, se_acl, 1);
+	kfree(acl);
+}
+
+struct ft_node_acl *ft_acl_get(struct ft_tpg *tpg, struct fc_rport_priv *rdata)
+{
+	struct ft_node_acl *found = NULL;
+	struct ft_node_acl *acl;
+	struct se_portal_group *se_tpg = &tpg->se_tpg;
+	struct se_node_acl *se_acl;
+
+	spin_lock_bh(&se_tpg->acl_node_lock);
+	list_for_each_entry(se_acl, &se_tpg->acl_node_list, acl_list) {
+		acl = container_of(se_acl, struct ft_node_acl, se_node_acl);
+		FT_CONF_DBG("acl %p port_name %llx\n",
+			acl, (unsigned long long)acl->node_auth.port_name);
+		if (acl->node_auth.port_name == rdata->ids.port_name ||
+		    acl->node_auth.node_name == rdata->ids.node_name) {
+			FT_CONF_DBG("acl %p port_name %llx matched\n", acl,
+				    (unsigned long long)rdata->ids.port_name);
+			found = acl;
+			/* XXX need to hold onto ACL */
+			break;
+		}
+	}
+	spin_unlock_bh(&se_tpg->acl_node_lock);
+	return found;
+}
+
+struct se_node_acl *ft_tpg_alloc_fabric_acl(struct se_portal_group *se_tpg)
+{
+	struct ft_node_acl *acl;
+
+	acl = kzalloc(sizeof(*acl), GFP_KERNEL);
+	if (!(acl)) {
+		printk(KERN_ERR "Unable to allocate struct ft_node_acl\n");
+		return NULL;
+	}
+	FT_CONF_DBG("acl %p\n", acl);
+	return &acl->se_node_acl;
+}
+
+static void ft_tpg_release_fabric_acl(struct se_portal_group *se_tpg,
+				      struct se_node_acl *se_acl)
+{
+	struct ft_node_acl *acl = container_of(se_acl,
+				struct ft_node_acl, se_node_acl);
+
+	FT_CONF_DBG(KERN_INFO "acl %p\n", acl);
+	kfree(acl);
+}
+
+/*
+ * local_port port_group (tpg) ops.
+ */
+static struct se_portal_group *ft_add_tpg(
+	struct se_wwn *wwn,
+	struct config_group *group,
+	const char *name)
+{
+	struct ft_lport_acl *lacl;
+	struct ft_tpg *tpg;
+	unsigned long index;
+	int ret;
+
+	FT_CONF_DBG("tcm_fc: add tpg %s\n", name);
+
+	/*
+	 * Name must be "tpgt_" followed by the index.
+	 */
+	if (strstr(name, "tpgt_") != name)
+		return NULL;
+	if (strict_strtoul(name + 5, 10, &index) || index > UINT_MAX)
+		return NULL;
+
+	lacl = container_of(wwn, struct ft_lport_acl, fc_lport_wwn);
+	tpg = kzalloc(sizeof(*tpg), GFP_KERNEL);
+	if (!tpg)
+		return NULL;
+	tpg->index = index;
+	tpg->lport_acl = lacl;
+	INIT_LIST_HEAD(&tpg->lun_list);
+	transport_init_queue_obj(&tpg->qobj);
+
+	ret = core_tpg_register(&ft_configfs->tf_ops, wwn, &tpg->se_tpg,
+				(void *)tpg, TRANSPORT_TPG_TYPE_NORMAL);
+	if (ret < 0) {
+		kfree(tpg);
+		return NULL;
+	}
+
+	tpg->thread = kthread_run(ft_thread, tpg, "ft_tpg%lu", index);
+	if (IS_ERR(tpg->thread)) {
+		kfree(tpg);
+		return NULL;
+	}
+
+	mutex_lock(&ft_lport_lock);
+	list_add_tail(&tpg->list, &lacl->tpg_list);
+	mutex_unlock(&ft_lport_lock);
+
+	return &tpg->se_tpg;
+}
+
+static void ft_del_tpg(struct se_portal_group *se_tpg)
+{
+	struct ft_tpg *tpg = container_of(se_tpg, struct ft_tpg, se_tpg);
+
+	FT_CONF_DBG("del tpg %s\n",
+		    config_item_name(&tpg->se_tpg.tpg_group.cg_item));
+
+	kthread_stop(tpg->thread);
+
+	/* Wait for sessions to be freed thru RCU, for BUG_ON below */
+	synchronize_rcu();
+
+	mutex_lock(&ft_lport_lock);
+	list_del(&tpg->list);
+	if (tpg->tport) {
+		tpg->tport->tpg = NULL;
+		tpg->tport = NULL;
+	}
+	mutex_unlock(&ft_lport_lock);
+
+	core_tpg_deregister(se_tpg);
+	kfree(tpg);
+}
+
+/*
+ * Verify that an lport is configured to use the tcm_fc module, and return
+ * the target port group that should be used.
+ *
+ * The caller holds ft_lport_lock.
+ */
+struct ft_tpg *ft_lport_find_tpg(struct fc_lport *lport)
+{
+	struct ft_lport_acl *lacl;
+	struct ft_tpg *tpg;
+
+	list_for_each_entry(lacl, &ft_lport_list, list) {
+		if (lacl->wwpn == lport->wwpn) {
+			list_for_each_entry(tpg, &lacl->tpg_list, list)
+				return tpg; /* XXX for now return first entry */
+			return NULL;
+		}
+	}
+	return NULL;
+}
+
+/*
+ * target config instance ops.
+ */
+
+/*
+ * Add lport to allowed config.
+ * The name is the WWPN in lower-case ASCII, colon-separated bytes.
+ */
+static struct se_wwn *ft_add_lport(
+	struct target_fabric_configfs *tf,
+	struct config_group *group,
+	const char *name)
+{
+	struct ft_lport_acl *lacl;
+	struct ft_lport_acl *old_lacl;
+	u64 wwpn;
+
+	FT_CONF_DBG("add lport %s\n", name);
+	if (ft_parse_wwn(name, &wwpn, 1) < 0)
+		return NULL;
+	lacl = kzalloc(sizeof(*lacl), GFP_KERNEL);
+	if (!lacl)
+		return NULL;
+	lacl->wwpn = wwpn;
+	INIT_LIST_HEAD(&lacl->tpg_list);
+
+	mutex_lock(&ft_lport_lock);
+	list_for_each_entry(old_lacl, &ft_lport_list, list) {
+		if (old_lacl->wwpn == wwpn) {
+			mutex_unlock(&ft_lport_lock);
+			kfree(lacl);
+			return NULL;
+		}
+	}
+	list_add_tail(&lacl->list, &ft_lport_list);
+	ft_format_wwn(lacl->name, sizeof(lacl->name), wwpn);
+	mutex_unlock(&ft_lport_lock);
+
+	return &lacl->fc_lport_wwn;
+}
+
+static void ft_del_lport(struct se_wwn *wwn)
+{
+	struct ft_lport_acl *lacl = container_of(wwn,
+				struct ft_lport_acl, fc_lport_wwn);
+
+	FT_CONF_DBG("del lport %s\n",
+			config_item_name(&wwn->wwn_group.cg_item));
+	mutex_lock(&ft_lport_lock);
+	list_del(&lacl->list);
+	mutex_unlock(&ft_lport_lock);
+
+	kfree(lacl);
+}
+
+static ssize_t ft_wwn_show_attr_version(
+	struct target_fabric_configfs *tf,
+	char *page)
+{
+	return sprintf(page, "TCM FC " FT_VERSION " on %s/%s on "
+		""UTS_RELEASE"\n",  utsname()->sysname, utsname()->machine);
+}
+
+TF_WWN_ATTR_RO(ft, version);
+
+static struct configfs_attribute *ft_wwn_attrs[] = {
+	&ft_wwn_version.attr,
+	NULL,
+};
+
+static char *ft_get_fabric_name(void)
+{
+	return "fc";
+}
+
+static char *ft_get_fabric_wwn(struct se_portal_group *se_tpg)
+{
+	struct ft_tpg *tpg = se_tpg->se_tpg_fabric_ptr;
+
+	return tpg->lport_acl->name;
+}
+
+static u16 ft_get_tag(struct se_portal_group *se_tpg)
+{
+	struct ft_tpg *tpg = se_tpg->se_tpg_fabric_ptr;
+
+	/*
+	 * This tag is used when forming SCSI Name identifier in EVPD=1 0x83
+	 * to represent the SCSI Target Port.
+	 */
+	return tpg->index;
+}
+
+static u32 ft_get_default_depth(struct se_portal_group *se_tpg)
+{
+	return 1;
+}
+
+static int ft_check_false(struct se_portal_group *se_tpg)
+{
+	return 0;
+}
+
+static void ft_set_default_node_attr(struct se_node_acl *se_nacl)
+{
+}
+
+static u16 ft_get_fabric_sense_len(void)
+{
+	return 0;
+}
+
+static u16 ft_set_fabric_sense_len(struct se_cmd *se_cmd, u32 sense_len)
+{
+	return 0;
+}
+
+static u32 ft_tpg_get_inst_index(struct se_portal_group *se_tpg)
+{
+	struct ft_tpg *tpg = se_tpg->se_tpg_fabric_ptr;
+
+	return tpg->index;
+}
+
+static u64 ft_pack_lun(unsigned int index)
+{
+	WARN_ON(index >= 256);
+	/* Caller wants this byte-swapped */
+	return cpu_to_le64((index & 0xff) << 8);
+}
+
+static struct target_core_fabric_ops ft_fabric_ops = {
+	.get_fabric_name =		ft_get_fabric_name,
+	.get_fabric_proto_ident =	fc_get_fabric_proto_ident,
+	.tpg_get_wwn =			ft_get_fabric_wwn,
+	.tpg_get_tag =			ft_get_tag,
+	.tpg_get_default_depth =	ft_get_default_depth,
+	.tpg_get_pr_transport_id =	fc_get_pr_transport_id,
+	.tpg_get_pr_transport_id_len =	fc_get_pr_transport_id_len,
+	.tpg_parse_pr_out_transport_id = fc_parse_pr_out_transport_id,
+	.tpg_check_demo_mode =		ft_check_false,
+	.tpg_check_demo_mode_cache =	ft_check_false,
+	.tpg_check_demo_mode_write_protect = ft_check_false,
+	.tpg_check_prod_mode_write_protect = ft_check_false,
+	.tpg_alloc_fabric_acl =		ft_tpg_alloc_fabric_acl,
+	.tpg_release_fabric_acl =	ft_tpg_release_fabric_acl,
+	.tpg_get_inst_index =		ft_tpg_get_inst_index,
+	.check_stop_free =		ft_check_stop_free,
+	.release_cmd_to_pool =		ft_release_cmd,
+	.release_cmd_direct =		ft_release_cmd,
+	.shutdown_session =		ft_sess_shutdown,
+	.close_session =		ft_sess_close,
+	.stop_session =			ft_sess_stop,
+	.fall_back_to_erl0 =		ft_sess_set_erl0,
+	.sess_logged_in =		ft_sess_logged_in,
+	.sess_get_index =		ft_sess_get_index,
+	.sess_get_initiator_sid =	NULL,
+	.write_pending =		ft_write_pending,
+	.write_pending_status =		ft_write_pending_status,
+	.set_default_node_attributes =	ft_set_default_node_attr,
+	.get_task_tag =			ft_get_task_tag,
+	.get_cmd_state =		ft_get_cmd_state,
+	.new_cmd_failure =		ft_new_cmd_failure,
+	.queue_data_in =		ft_queue_data_in,
+	.queue_status =			ft_queue_status,
+	.queue_tm_rsp =			ft_queue_tm_resp,
+	.get_fabric_sense_len =		ft_get_fabric_sense_len,
+	.set_fabric_sense_len =		ft_set_fabric_sense_len,
+	.is_state_remove =		ft_is_state_remove,
+	.pack_lun =			ft_pack_lun,
+	/*
+	 * Setup function pointers for generic logic in
+	 * target_core_fabric_configfs.c
+	 */
+	.fabric_make_wwn =		&ft_add_lport,
+	.fabric_drop_wwn =		&ft_del_lport,
+	.fabric_make_tpg =		&ft_add_tpg,
+	.fabric_drop_tpg =		&ft_del_tpg,
+	.fabric_post_link =		NULL,
+	.fabric_pre_unlink =		NULL,
+	.fabric_make_np =		NULL,
+	.fabric_drop_np =		NULL,
+	.fabric_make_nodeacl =		&ft_add_acl,
+	.fabric_drop_nodeacl =		&ft_del_acl,
+};
+
+int ft_register_configfs(void)
+{
+	struct target_fabric_configfs *fabric;
+	int ret;
+
+	/*
+	 * Register the top level struct config_item_type with TCM core
+	 */
+	fabric = target_fabric_configfs_init(THIS_MODULE, "fc");
+	if (!fabric) {
+		printk(KERN_INFO "%s: target_fabric_configfs_init() failed!\n",
+		       __func__);
+		return -1;
+	}
+	fabric->tf_ops = ft_fabric_ops;
+
+	/* Allowing support for task_sg_chaining */
+	fabric->tf_ops.task_sg_chaining = 1;
+
+	/*
+	 * Setup default attribute lists for various fabric->tf_cit_tmpl
+	 */
+	TF_CIT_TMPL(fabric)->tfc_wwn_cit.ct_attrs = ft_wwn_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_base_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_attrib_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_param_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_np_base_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_base_cit.ct_attrs =
+						    ft_nacl_base_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_attrib_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_auth_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_param_cit.ct_attrs = NULL;
+	/*
+	 * register the fabric for use within TCM
+	 */
+	ret = target_fabric_configfs_register(fabric);
+	if (ret < 0) {
+		FT_CONF_DBG("target_fabric_configfs_register() for"
+			    " FC Target failed!\n");
+		printk(KERN_INFO
+		       "%s: target_fabric_configfs_register() failed!\n",
+		       __func__);
+		target_fabric_configfs_free(fabric);
+		return -1;
+	}
+
+	/*
+	 * Setup our local pointer to *fabric.
+	 */
+	ft_configfs = fabric;
+	return 0;
+}
+
+void ft_deregister_configfs(void)
+{
+	if (!ft_configfs)
+		return;
+	target_fabric_configfs_deregister(ft_configfs);
+	ft_configfs = NULL;
+}
+
+static struct notifier_block ft_notifier = {
+	.notifier_call = ft_lport_notify
+};
+
+static int __init ft_init(void)
+{
+	if (ft_register_configfs())
+		return -1;
+	if (fc_fc4_register_provider(FC_TYPE_FCP, &ft_prov)) {
+		ft_deregister_configfs();
+		return -1;
+	}
+	blocking_notifier_chain_register(&fc_lport_notifier_head, &ft_notifier);
+	fc_lport_iterate(ft_lport_add, NULL);
+	return 0;
+}
+
+static void __exit ft_exit(void)
+{
+	blocking_notifier_chain_unregister(&fc_lport_notifier_head,
+					   &ft_notifier);
+	fc_fc4_deregister_provider(FC_TYPE_FCP, &ft_prov);
+	fc_lport_iterate(ft_lport_del, NULL);
+	ft_deregister_configfs();
+	synchronize_rcu();
+}
+
+#ifdef MODULE
+MODULE_DESCRIPTION("FC TCM fabric driver " FT_VERSION);
+MODULE_LICENSE("GPL");
+module_init(ft_init);
+module_exit(ft_exit);
+#endif /* MODULE */
diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
new file mode 100644
index 0000000..4c3c0ef
--- /dev/null
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -0,0 +1,374 @@
+/*
+ * Copyright (c) 2010 Cisco Systems, Inc.
+ *
+ * Portions based on tcm_loop_fabric_scsi.c and libfc/fc_fcp.c
+ *
+ * Copyright (c) 2007 Intel Corporation. All rights reserved.
+ * Copyright (c) 2008 Red Hat, Inc.  All rights reserved.
+ * Copyright (c) 2008 Mike Christie
+ * Copyright (c) 2009 Rising Tide, Inc.
+ * Copyright (c) 2009 Linux-iSCSI.org
+ * Copyright (c) 2009 Nicholas A. Bellinger <nab@linux-iscsi.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+/* XXX TBD some includes may be extraneous */
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
+#include <linux/hash.h>
+#include <asm/unaligned.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/libfc.h>
+#include <scsi/fc_encode.h>
+
+#include <target/target_core_base.h>
+#include <target/target_core_transport.h>
+#include <target/target_core_fabric_ops.h>
+#include <target/target_core_device.h>
+#include <target/target_core_tpg.h>
+#include <target/target_core_configfs.h>
+#include <target/target_core_base.h>
+#include <target/configfs_macros.h>
+
+#include "tcm_fc.h"
+
+/*
+ * Deliver read data back to initiator.
+ * XXX TBD handle resource problems later.
+ */
+int ft_queue_data_in(struct se_cmd *se_cmd)
+{
+	struct ft_cmd *cmd = container_of(se_cmd, struct ft_cmd, se_cmd);
+	struct se_transport_task *task;
+	struct fc_frame *fp = NULL;
+	struct fc_exch *ep;
+	struct fc_lport *lport;
+	struct se_mem *mem;
+	size_t remaining;
+	u32 f_ctl = FC_FC_EX_CTX | FC_FC_REL_OFF;
+	u32 mem_off;
+	u32 fh_off = 0;
+	u32 frame_off = 0;
+	size_t frame_len = 0;
+	size_t mem_len;
+	size_t tlen;
+	size_t off_in_page;
+	struct page *page;
+	int use_sg;
+	int error;
+	void *page_addr;
+	void *from;
+	void *to = NULL;
+
+	ep = fc_seq_exch(cmd->seq);
+	lport = ep->lp;
+	cmd->seq = lport->tt.seq_start_next(cmd->seq);
+
+	task = T_TASK(se_cmd);
+	BUG_ON(!task);
+	remaining = se_cmd->data_length;
+
+	/*
+	 * Setup to use first mem list entry if any.
+	 */
+	if (task->t_tasks_se_num) {
+		mem = list_first_entry(task->t_mem_list,
+			 struct se_mem, se_list);
+		mem_len = mem->se_len;
+		mem_off = mem->se_off;
+		page = mem->se_page;
+	} else {
+		mem = NULL;
+		mem_len = remaining;
+		mem_off = 0;
+		page = NULL;
+	}
+
+	/* no scatter/gather in skb for odd word length due to fc_seq_send() */
+	use_sg = !(remaining % 4);
+
+	while (remaining) {
+		if (!mem_len) {
+			BUG_ON(!mem);
+			mem = list_entry(mem->se_list.next,
+				struct se_mem, se_list);
+			mem_len = min((size_t)mem->se_len, remaining);
+			mem_off = mem->se_off;
+			page = mem->se_page;
+		}
+		if (!frame_len) {
+			/*
+			 * If lport's has capability of Large Send Offload LSO)
+			 * , then allow 'frame_len' to be as big as 'lso_max'
+			 * if indicated transfer length is >= lport->lso_max
+			 */
+			frame_len = (lport->seq_offload) ? lport->lso_max :
+							  cmd->sess->max_frame;
+			frame_len = min(frame_len, remaining);
+			fp = fc_frame_alloc(lport, use_sg ? 0 : frame_len);
+			if (!fp)
+				return -ENOMEM;
+			to = fc_frame_payload_get(fp, 0);
+			fh_off = frame_off;
+			frame_off += frame_len;
+			/*
+			 * Setup the frame's max payload which is used by base
+			 * driver to indicate HW about max frame size, so that
+			 * HW can do fragmentation appropriately based on
+			 * "gso_max_size" of underline netdev.
+			 */
+			fr_max_payload(fp) = cmd->sess->max_frame;
+		}
+		tlen = min(mem_len, frame_len);
+
+		if (use_sg) {
+			if (!mem) {
+				BUG_ON(!task->t_task_buf);
+				page_addr = task->t_task_buf + mem_off;
+				/*
+				 * In this case, offset is 'offset_in_page' of
+				 * (t_task_buf + mem_off) instead of 'mem_off'.
+				 */
+				off_in_page = offset_in_page(page_addr);
+				page = virt_to_page(page_addr);
+				tlen = min(tlen, PAGE_SIZE - off_in_page);
+			} else
+				off_in_page = mem_off;
+			BUG_ON(!page);
+			get_page(page);
+			skb_fill_page_desc(fp_skb(fp),
+					   skb_shinfo(fp_skb(fp))->nr_frags,
+					   page, off_in_page, tlen);
+			fr_len(fp) += tlen;
+			fp_skb(fp)->data_len += tlen;
+			fp_skb(fp)->truesize +=
+					PAGE_SIZE << compound_order(page);
+		} else if (mem) {
+			BUG_ON(!page);
+			from = kmap_atomic(page + (mem_off >> PAGE_SHIFT),
+					   KM_SOFTIRQ0);
+			page_addr = from;
+			from += mem_off & ~PAGE_MASK;
+			tlen = min(tlen, (size_t)(PAGE_SIZE -
+						(mem_off & ~PAGE_MASK)));
+			memcpy(to, from, tlen);
+			kunmap_atomic(page_addr, KM_SOFTIRQ0);
+			to += tlen;
+		} else {
+			from = task->t_task_buf + mem_off;
+			memcpy(to, from, tlen);
+			to += tlen;
+		}
+
+		mem_off += tlen;
+		mem_len -= tlen;
+		frame_len -= tlen;
+		remaining -= tlen;
+
+		if (frame_len &&
+		    (skb_shinfo(fp_skb(fp))->nr_frags < FC_FRAME_SG_LEN))
+			continue;
+		if (!remaining)
+			f_ctl |= FC_FC_END_SEQ;
+		fc_fill_fc_hdr(fp, FC_RCTL_DD_SOL_DATA, ep->did, ep->sid,
+			       FC_TYPE_FCP, f_ctl, fh_off);
+		error = lport->tt.seq_send(lport, cmd->seq, fp);
+		if (error) {
+			/* XXX For now, initiator will retry */
+			if (printk_ratelimit())
+				printk(KERN_ERR "%s: Failed to send frame %p, "
+						"xid <0x%x>, remaining <0x%x>, "
+						"lso_max <0x%x>\n",
+						__func__, fp, ep->xid,
+						remaining, lport->lso_max);
+		}
+	}
+	return ft_queue_status(se_cmd);
+}
+
+/*
+ * Receive write data frame.
+ */
+void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
+{
+	struct se_cmd *se_cmd = &cmd->se_cmd;
+	struct fc_seq *seq = cmd->seq;
+	struct fc_exch *ep;
+	struct fc_lport *lport;
+	struct se_transport_task *task;
+	struct fc_frame_header *fh;
+	struct se_mem *mem;
+	u32 mem_off;
+	u32 rel_off;
+	size_t frame_len;
+	size_t mem_len;
+	size_t tlen;
+	struct page *page;
+	void *page_addr;
+	void *from;
+	void *to;
+	u32 f_ctl;
+	void *buf;
+
+	task = T_TASK(se_cmd);
+	BUG_ON(!task);
+
+	fh = fc_frame_header_get(fp);
+	if (!(ntoh24(fh->fh_f_ctl) & FC_FC_REL_OFF))
+		goto drop;
+
+	/*
+	 * Doesn't expect even single byte of payload. Payload
+	 * is expected to be copied directly to user buffers
+	 * due to DDP (Large Rx offload) feature, hence
+	 * BUG_ON if BUF is non-NULL
+	 */
+	buf = fc_frame_payload_get(fp, 1);
+	if (cmd->was_ddp_setup && buf) {
+		printk(KERN_INFO "%s: When DDP was setup, not expected to"
+				 "receive frame with payload, Payload shall be"
+				 "copied directly to buffer instead of coming "
+				 "via. legacy receive queues\n", __func__);
+		BUG_ON(buf);
+	}
+
+	/*
+	 * If ft_cmd indicated 'ddp_setup', in that case only the last frame
+	 * should come with 'TSI bit being set'. If 'TSI bit is not set and if
+	 * data frame appears here, means error condition. In both the cases
+	 * release the DDP context (ddp_put) and in error case, as well
+	 * initiate error recovery mechanism.
+	 */
+	ep = fc_seq_exch(seq);
+	if (cmd->was_ddp_setup) {
+		BUG_ON(!ep);
+		lport = ep->lp;
+		BUG_ON(!lport);
+	}
+	if (cmd->was_ddp_setup && ep->xid != FC_XID_UNKNOWN) {
+		f_ctl = ntoh24(fh->fh_f_ctl);
+		/*
+		 * If TSI bit set in f_ctl, means last write data frame is
+		 * received successfully where payload is posted directly
+		 * to user buffer and only the last frame's header is posted
+		 * in legacy receive queue
+		 */
+		if (f_ctl & FC_FC_SEQ_INIT) { /* TSI bit set in FC frame */
+			cmd->write_data_len = lport->tt.ddp_done(lport,
+								ep->xid);
+			goto last_frame;
+		} else {
+			/*
+			 * Updating the write_data_len may be meaningless at
+			 * this point, but just in case if required in future
+			 * for debugging or any other purpose
+			 */
+			printk(KERN_ERR "%s: Received frame with TSI bit not"
+					" being SET, dropping the frame, "
+					"cmd->sg <%p>, cmd->sg_cnt <0x%x>\n",
+					__func__, cmd->sg, cmd->sg_cnt);
+			cmd->write_data_len = lport->tt.ddp_done(lport,
+							      ep->xid);
+			lport->tt.seq_exch_abort(cmd->seq, 0);
+			goto drop;
+		}
+	}
+
+	rel_off = ntohl(fh->fh_parm_offset);
+	frame_len = fr_len(fp);
+	if (frame_len <= sizeof(*fh))
+		goto drop;
+	frame_len -= sizeof(*fh);
+	from = fc_frame_payload_get(fp, 0);
+	if (rel_off >= se_cmd->data_length)
+		goto drop;
+	if (frame_len + rel_off > se_cmd->data_length)
+		frame_len = se_cmd->data_length - rel_off;
+
+	/*
+	 * Setup to use first mem list entry if any.
+	 */
+	if (task->t_tasks_se_num) {
+		mem = list_first_entry(task->t_mem_list,
+				       struct se_mem, se_list);
+		mem_len = mem->se_len;
+		mem_off = mem->se_off;
+		page = mem->se_page;
+	} else {
+		mem = NULL;
+		page = NULL;
+		mem_off = 0;
+		mem_len = frame_len;
+	}
+
+	while (frame_len) {
+		if (!mem_len) {
+			BUG_ON(!mem);
+			mem = list_entry(mem->se_list.next,
+					 struct se_mem, se_list);
+			mem_len = mem->se_len;
+			mem_off = mem->se_off;
+			page = mem->se_page;
+		}
+		if (rel_off >= mem_len) {
+			rel_off -= mem_len;
+			mem_len = 0;
+			continue;
+		}
+		mem_off += rel_off;
+		mem_len -= rel_off;
+		rel_off = 0;
+
+		tlen = min(mem_len, frame_len);
+
+		if (mem) {
+			to = kmap_atomic(page + (mem_off >> PAGE_SHIFT),
+					 KM_SOFTIRQ0);
+			page_addr = to;
+			to += mem_off & ~PAGE_MASK;
+			tlen = min(tlen, (size_t)(PAGE_SIZE -
+						(mem_off & ~PAGE_MASK)));
+			memcpy(to, from, tlen);
+			kunmap_atomic(page_addr, KM_SOFTIRQ0);
+		} else {
+			to = task->t_task_buf + mem_off;
+			memcpy(to, from, tlen);
+		}
+		from += tlen;
+		frame_len -= tlen;
+		mem_off += tlen;
+		mem_len -= tlen;
+		cmd->write_data_len += tlen;
+	}
+last_frame:
+	if (cmd->write_data_len == se_cmd->data_length)
+		transport_generic_handle_data(se_cmd);
+drop:
+	fc_frame_free(fp);
+}
diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
new file mode 100644
index 0000000..a3bd57f
--- /dev/null
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -0,0 +1,541 @@
+/*
+ * Copyright (c) 2010 Cisco Systems, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+/* XXX TBD some includes may be extraneous */
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
+#include <linux/hash.h>
+#include <linux/rcupdate.h>
+#include <linux/rculist.h>
+#include <linux/kref.h>
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
+#include <target/target_core_device.h>
+#include <target/target_core_tpg.h>
+#include <target/target_core_configfs.h>
+#include <target/target_core_base.h>
+#include <target/configfs_macros.h>
+
+#include <scsi/libfc.h>
+#include "tcm_fc.h"
+
+static void ft_sess_delete_all(struct ft_tport *);
+
+/*
+ * Lookup or allocate target local port.
+ * Caller holds ft_lport_lock.
+ */
+static struct ft_tport *ft_tport_create(struct fc_lport *lport)
+{
+	struct ft_tpg *tpg;
+	struct ft_tport *tport;
+	int i;
+
+	tport = rcu_dereference(lport->prov[FC_TYPE_FCP]);
+	if (tport && tport->tpg)
+		return tport;
+
+	tpg = ft_lport_find_tpg(lport);
+	if (!tpg)
+		return NULL;
+
+	if (tport) {
+		tport->tpg = tpg;
+		return tport;
+	}
+
+	tport = kzalloc(sizeof(*tport), GFP_KERNEL);
+	if (!tport)
+		return NULL;
+
+	tport->lport = lport;
+	tport->tpg = tpg;
+	tpg->tport = tport;
+	for (i = 0; i < FT_SESS_HASH_SIZE; i++)
+		INIT_HLIST_HEAD(&tport->hash[i]);
+
+	rcu_assign_pointer(lport->prov[FC_TYPE_FCP], tport);
+	return tport;
+}
+
+/*
+ * Free tport via RCU.
+ */
+static void ft_tport_rcu_free(struct rcu_head *rcu)
+{
+	struct ft_tport *tport = container_of(rcu, struct ft_tport, rcu);
+
+	kfree(tport);
+}
+
+/*
+ * Delete a target local port.
+ * Caller holds ft_lport_lock.
+ */
+static void ft_tport_delete(struct ft_tport *tport)
+{
+	struct fc_lport *lport;
+	struct ft_tpg *tpg;
+
+	ft_sess_delete_all(tport);
+	lport = tport->lport;
+	BUG_ON(tport != lport->prov[FC_TYPE_FCP]);
+	rcu_assign_pointer(lport->prov[FC_TYPE_FCP], NULL);
+
+	tpg = tport->tpg;
+	if (tpg) {
+		tpg->tport = NULL;
+		tport->tpg = NULL;
+	}
+	call_rcu(&tport->rcu, ft_tport_rcu_free);
+}
+
+/*
+ * Add local port.
+ * Called thru fc_lport_iterate().
+ */
+void ft_lport_add(struct fc_lport *lport, void *arg)
+{
+	mutex_lock(&ft_lport_lock);
+	ft_tport_create(lport);
+	mutex_unlock(&ft_lport_lock);
+}
+
+/*
+ * Delete local port.
+ * Called thru fc_lport_iterate().
+ */
+void ft_lport_del(struct fc_lport *lport, void *arg)
+{
+	struct ft_tport *tport;
+
+	mutex_lock(&ft_lport_lock);
+	tport = lport->prov[FC_TYPE_FCP];
+	if (tport)
+		ft_tport_delete(tport);
+	mutex_unlock(&ft_lport_lock);
+}
+
+/*
+ * Notification of local port change from libfc.
+ * Create or delete local port and associated tport.
+ */
+int ft_lport_notify(struct notifier_block *nb, unsigned long event, void *arg)
+{
+	struct fc_lport *lport = arg;
+
+	switch (event) {
+	case FC_LPORT_EV_ADD:
+		ft_lport_add(lport, NULL);
+		break;
+	case FC_LPORT_EV_DEL:
+		ft_lport_del(lport, NULL);
+		break;
+	}
+	return NOTIFY_DONE;
+}
+
+/*
+ * Hash function for FC_IDs.
+ */
+static u32 ft_sess_hash(u32 port_id)
+{
+	return hash_32(port_id, FT_SESS_HASH_BITS);
+}
+
+/*
+ * Find session in local port.
+ * Sessions and hash lists are RCU-protected.
+ * A reference is taken which must be eventually freed.
+ */
+static struct ft_sess *ft_sess_get(struct fc_lport *lport, u32 port_id)
+{
+	struct ft_tport *tport;
+	struct hlist_head *head;
+	struct hlist_node *pos;
+	struct ft_sess *sess;
+
+	rcu_read_lock();
+	tport = rcu_dereference(lport->prov[FC_TYPE_FCP]);
+	if (!tport)
+		goto out;
+
+	head = &tport->hash[ft_sess_hash(port_id)];
+	hlist_for_each_entry_rcu(sess, pos, head, hash) {
+		if (sess->port_id == port_id) {
+			kref_get(&sess->kref);
+			rcu_read_unlock();
+			FT_SESS_DBG("port_id %x found %p\n", port_id, sess);
+			return sess;
+		}
+	}
+out:
+	rcu_read_unlock();
+	FT_SESS_DBG("port_id %x not found\n", port_id);
+	return NULL;
+}
+
+/*
+ * Allocate session and enter it in the hash for the local port.
+ * Caller holds ft_lport_lock.
+ */
+static struct ft_sess *ft_sess_create(struct ft_tport *tport, u32 port_id,
+				      struct ft_node_acl *acl)
+{
+	struct ft_sess *sess;
+	struct hlist_head *head;
+	struct hlist_node *pos;
+
+	head = &tport->hash[ft_sess_hash(port_id)];
+	hlist_for_each_entry_rcu(sess, pos, head, hash)
+		if (sess->port_id == port_id)
+			return sess;
+
+	sess = kzalloc(sizeof(*sess), GFP_KERNEL);
+	if (!sess)
+		return NULL;
+
+	sess->se_sess = transport_init_session();
+	if (!sess->se_sess) {
+		kfree(sess);
+		return NULL;
+	}
+	sess->se_sess->se_node_acl = &acl->se_node_acl;
+	sess->tport = tport;
+	sess->port_id = port_id;
+	kref_init(&sess->kref);	/* ref for table entry */
+	hlist_add_head_rcu(&sess->hash, head);
+	tport->sess_count++;
+
+	FT_SESS_DBG("port_id %x sess %p\n", port_id, sess);
+
+	transport_register_session(&tport->tpg->se_tpg, &acl->se_node_acl,
+				   sess->se_sess, sess);
+	return sess;
+}
+
+/*
+ * Unhash the session.
+ * Caller holds ft_lport_lock.
+ */
+static void ft_sess_unhash(struct ft_sess *sess)
+{
+	struct ft_tport *tport = sess->tport;
+
+	hlist_del_rcu(&sess->hash);
+	BUG_ON(!tport->sess_count);
+	tport->sess_count--;
+	sess->port_id = -1;
+	sess->params = 0;
+}
+
+/*
+ * Delete session from hash.
+ * Caller holds ft_lport_lock.
+ */
+static struct ft_sess *ft_sess_delete(struct ft_tport *tport, u32 port_id)
+{
+	struct hlist_head *head;
+	struct hlist_node *pos;
+	struct ft_sess *sess;
+
+	head = &tport->hash[ft_sess_hash(port_id)];
+	hlist_for_each_entry_rcu(sess, pos, head, hash) {
+		if (sess->port_id == port_id) {
+			ft_sess_unhash(sess);
+			return sess;
+		}
+	}
+	return NULL;
+}
+
+/*
+ * Delete all sessions from tport.
+ * Caller holds ft_lport_lock.
+ */
+static void ft_sess_delete_all(struct ft_tport *tport)
+{
+	struct hlist_head *head;
+	struct hlist_node *pos;
+	struct ft_sess *sess;
+
+	for (head = tport->hash;
+	     head < &tport->hash[FT_SESS_HASH_SIZE]; head++) {
+		hlist_for_each_entry_rcu(sess, pos, head, hash) {
+			ft_sess_unhash(sess);
+			transport_deregister_session_configfs(sess->se_sess);
+			ft_sess_put(sess);	/* release from table */
+		}
+	}
+}
+
+/*
+ * TCM ops for sessions.
+ */
+
+/*
+ * Determine whether session is allowed to be shutdown in the current context.
+ * Returns non-zero if the session should be shutdown.
+ */
+int ft_sess_shutdown(struct se_session *se_sess)
+{
+	struct ft_sess *sess = se_sess->fabric_sess_ptr;
+
+	FT_SESS_DBG("port_id %x\n", sess->port_id);
+	return 1;
+}
+
+/*
+ * Remove session and send PRLO.
+ * This is called when the ACL is being deleted or queue depth is changing.
+ */
+void ft_sess_close(struct se_session *se_sess)
+{
+	struct ft_sess *sess = se_sess->fabric_sess_ptr;
+	struct fc_lport *lport;
+	u32 port_id;
+
+	mutex_lock(&ft_lport_lock);
+	lport = sess->tport->lport;
+	port_id = sess->port_id;
+	if (port_id == -1) {
+		mutex_lock(&ft_lport_lock);
+		return;
+	}
+	FT_SESS_DBG("port_id %x\n", port_id);
+	ft_sess_unhash(sess);
+	mutex_unlock(&ft_lport_lock);
+	transport_deregister_session_configfs(se_sess);
+	ft_sess_put(sess);
+	/* XXX Send LOGO or PRLO */
+	synchronize_rcu();		/* let transport deregister happen */
+}
+
+void ft_sess_stop(struct se_session *se_sess, int sess_sleep, int conn_sleep)
+{
+	struct ft_sess *sess = se_sess->fabric_sess_ptr;
+
+	FT_SESS_DBG("port_id %x\n", sess->port_id);
+}
+
+int ft_sess_logged_in(struct se_session *se_sess)
+{
+	struct ft_sess *sess = se_sess->fabric_sess_ptr;
+
+	return sess->port_id != -1;
+}
+
+u32 ft_sess_get_index(struct se_session *se_sess)
+{
+	struct ft_sess *sess = se_sess->fabric_sess_ptr;
+
+	return sess->port_id;	/* XXX TBD probably not what is needed */
+}
+
+u32 ft_sess_get_port_name(struct se_session *se_sess,
+			  unsigned char *buf, u32 len)
+{
+	struct ft_sess *sess = se_sess->fabric_sess_ptr;
+
+	return ft_format_wwn(buf, len, sess->port_name);
+}
+
+void ft_sess_set_erl0(struct se_session *se_sess)
+{
+	/* XXX TBD called when out of memory */
+}
+
+/*
+ * libfc ops involving sessions.
+ */
+
+static int ft_prli_locked(struct fc_rport_priv *rdata, u32 spp_len,
+			  const struct fc_els_spp *rspp, struct fc_els_spp *spp)
+{
+	struct ft_tport *tport;
+	struct ft_sess *sess;
+	struct ft_node_acl *acl;
+	u32 fcp_parm;
+
+	tport = ft_tport_create(rdata->local_port);
+	if (!tport)
+		return 0;	/* not a target for this local port */
+
+	acl = ft_acl_get(tport->tpg, rdata);
+	if (!acl)
+		return 0;
+
+	if (!rspp)
+		goto fill;
+
+	if (rspp->spp_flags & (FC_SPP_OPA_VAL | FC_SPP_RPA_VAL))
+		return FC_SPP_RESP_NO_PA;
+
+	/*
+	 * If both target and initiator bits are off, the SPP is invalid.
+	 */
+	fcp_parm = ntohl(rspp->spp_params);
+	if (!(fcp_parm & (FCP_SPPF_INIT_FCN | FCP_SPPF_TARG_FCN)))
+		return FC_SPP_RESP_INVL;
+
+	/*
+	 * Create session (image pair) only if requested by
+	 * EST_IMG_PAIR flag and if the requestor is an initiator.
+	 */
+	if (rspp->spp_flags & FC_SPP_EST_IMG_PAIR) {
+		spp->spp_flags |= FC_SPP_EST_IMG_PAIR;
+		if (!(fcp_parm & FCP_SPPF_INIT_FCN))
+			return FC_SPP_RESP_CONF;
+		sess = ft_sess_create(tport, rdata->ids.port_id, acl);
+		if (!sess)
+			return FC_SPP_RESP_RES;
+		if (!sess->params)
+			rdata->prli_count++;
+		sess->params = fcp_parm;
+		sess->port_name = rdata->ids.port_name;
+		sess->max_frame = rdata->maxframe_size;
+
+		/* XXX TBD - clearing actions.  unit attn, see 4.10 */
+	}
+
+	/*
+	 * OR in our service parameters with other provider (initiator), if any.
+	 * TBD XXX - indicate RETRY capability?
+	 */
+fill:
+	fcp_parm = ntohl(spp->spp_params);
+	spp->spp_params = htonl(fcp_parm | FCP_SPPF_TARG_FCN);
+	return FC_SPP_RESP_ACK;
+}
+
+/**
+ * tcm_fcp_prli() - Handle incoming or outgoing PRLI for the FCP target
+ * @rdata: remote port private
+ * @spp_len: service parameter page length
+ * @rspp: received service parameter page (NULL for outgoing PRLI)
+ * @spp: response service parameter page
+ *
+ * Returns spp response code.
+ */
+static int ft_prli(struct fc_rport_priv *rdata, u32 spp_len,
+		   const struct fc_els_spp *rspp, struct fc_els_spp *spp)
+{
+	int ret;
+
+	mutex_lock(&ft_lport_lock);
+	ret = ft_prli_locked(rdata, spp_len, rspp, spp);
+	mutex_unlock(&ft_lport_lock);
+	FT_SESS_DBG("port_id %x flags %x ret %x\n",
+	       rdata->ids.port_id, rspp ? rspp->spp_flags : 0, ret);
+	return ret;
+}
+
+static void ft_sess_rcu_free(struct rcu_head *rcu)
+{
+	struct ft_sess *sess = container_of(rcu, struct ft_sess, rcu);
+
+	transport_deregister_session(sess->se_sess);
+	kfree(sess);
+}
+
+static void ft_sess_free(struct kref *kref)
+{
+	struct ft_sess *sess = container_of(kref, struct ft_sess, kref);
+
+	call_rcu(&sess->rcu, ft_sess_rcu_free);
+}
+
+void ft_sess_put(struct ft_sess *sess)
+{
+	int sess_held = atomic_read(&sess->kref.refcount);
+
+	BUG_ON(!sess_held);
+	kref_put(&sess->kref, ft_sess_free);
+}
+
+static void ft_prlo(struct fc_rport_priv *rdata)
+{
+	struct ft_sess *sess;
+	struct ft_tport *tport;
+
+	mutex_lock(&ft_lport_lock);
+	tport = rcu_dereference(rdata->local_port->prov[FC_TYPE_FCP]);
+	if (!tport) {
+		mutex_unlock(&ft_lport_lock);
+		return;
+	}
+	sess = ft_sess_delete(tport, rdata->ids.port_id);
+	if (!sess) {
+		mutex_unlock(&ft_lport_lock);
+		return;
+	}
+	mutex_unlock(&ft_lport_lock);
+	transport_deregister_session_configfs(sess->se_sess);
+	ft_sess_put(sess);		/* release from table */
+	rdata->prli_count--;
+	/* XXX TBD - clearing actions.  unit attn, see 4.10 */
+}
+
+/*
+ * Handle incoming FCP request.
+ * Caller has verified that the frame is type FCP.
+ */
+static void ft_recv(struct fc_lport *lport, struct fc_frame *fp)
+{
+	struct ft_sess *sess;
+	u32 sid = fc_frame_sid(fp);
+
+	FT_SESS_DBG("sid %x\n", sid);
+
+	sess = ft_sess_get(lport, sid);
+	if (!sess) {
+		FT_SESS_DBG("sid %x sess lookup failed\n", sid);
+		/* TBD XXX - if FCP_CMND, send PRLO */
+		fc_frame_free(fp);
+		return;
+	}
+	ft_recv_req(sess, fp);	/* must do ft_sess_put() */
+}
+
+/*
+ * Provider ops for libfc.
+ */
+struct fc4_prov ft_prov = {
+	.prli = ft_prli,
+	.prlo = ft_prlo,
+	.recv = ft_recv,
+	.module = THIS_MODULE,
+};

