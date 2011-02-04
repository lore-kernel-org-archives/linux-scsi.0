From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [v7 PATCH 3/4] bnx2fc: SCSI IO handling and session offload
Date: Fri, 4 Feb 2011 12:14:49 -0800
Message-ID: <1296850489.268.914.camel@LTLNR-SJCE10.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2524 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab1BDUPA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Feb 2011 15:15:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Michael Chan <mchan@broadcom.com>

This patch contains code for IO and target (session) modules.
IO module interfaces with SCSI-ml and firmware to sends the
IOs on the offloaded sessions. Target module is responsbile
to listen to rport events from libfc and offload/upload the
sessions.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c  | 1833 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/bnx2fc/bnx2fc_tgt.c |  844 ++++++++++++++++++
 2 files changed, 2677 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc_io.c
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc_tgt.c

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
new file mode 100644
index 0000000..41d78fc
--- /dev/null
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -0,0 +1,1833 @@
+/* bnx2fc_io.c: Broadcom NetXtreme II Linux FCoE offload driver.
+ * IO manager and SCSI IO processing.
+ *
+ * Copyright (c) 2008 - 2010 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ *
+ * Written by: Bhanu Prakash Gollapudi (bprakash@broadcom.com)
+ */
+
+#include "bnx2fc.h"
+static int bnx2fc_split_bd(struct bnx2fc_cmd *io_req, u64 addr, int sg_len,
+			   int bd_index);
+static int bnx2fc_map_sg(struct bnx2fc_cmd *io_req);
+static void bnx2fc_build_bd_list_from_sg(struct bnx2fc_cmd *io_req);
+static int bnx2fc_post_io_req(struct bnx2fc_rport *tgt,
+			       struct bnx2fc_cmd *io_req);
+static void bnx2fc_unmap_sg_list(struct bnx2fc_cmd *io_req);
+static void bnx2fc_free_mp_resc(struct bnx2fc_cmd *io_req);
+static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd *io_req,
+				 struct fcoe_fcp_rsp_payload *fcp_rsp,
+				 u8 num_rq);
+
+void bnx2fc_cmd_timer_set(struct bnx2fc_cmd *io_req,
+			  unsigned int timer_msec)
+{
+	struct bnx2fc_hba *hba = io_req->port->priv;
+
+	if (queue_delayed_work(hba->timer_work_queue, &io_req->timeout_work,
+				  msecs_to_jiffies(timer_msec)))
+		kref_get(&io_req->refcount);
+}
+
+static void bnx2fc_cmd_timeout(struct work_struct *work)
+{
+	struct bnx2fc_cmd *io_req = container_of(work, struct bnx2fc_cmd,
+						 timeout_work.work);
+	struct fc_lport *lport;
+	struct fc_rport_priv *rdata;
+	u8 cmd_type = io_req->cmd_type;
+	struct bnx2fc_rport *tgt = io_req->tgt;
+	int logo_issued;
+	int rc;
+
+	BNX2FC_IO_DBG(io_req, "cmd_timeout, cmd_type = %d,"
+		      "req_flags = %lx\n", cmd_type, io_req->req_flags);
+
+	spin_lock_bh(&tgt->tgt_lock);
+	if (test_and_clear_bit(BNX2FC_FLAG_ISSUE_RRQ, &io_req->req_flags)) {
+		clear_bit(BNX2FC_FLAG_RETIRE_OXID, &io_req->req_flags);
+		/*
+		 * ideally we should hold the io_req until RRQ complets,
+		 * and release io_req from timeout hold.
+		 */
+		spin_unlock_bh(&tgt->tgt_lock);
+		bnx2fc_send_rrq(io_req);
+		return;
+	}
+	if (test_and_clear_bit(BNX2FC_FLAG_RETIRE_OXID, &io_req->req_flags)) {
+		BNX2FC_IO_DBG(io_req, "IO ready for reuse now\n");
+		goto done;
+	}
+
+	switch (cmd_type) {
+	case BNX2FC_SCSI_CMD:
+		if (test_and_clear_bit(BNX2FC_FLAG_EH_ABORT,
+							&io_req->req_flags)) {
+			/* Handle eh_abort timeout */
+			BNX2FC_IO_DBG(io_req, "eh_abort timed out\n");
+			complete(&io_req->tm_done);
+		} else if (test_bit(BNX2FC_FLAG_ISSUE_ABTS,
+				    &io_req->req_flags)) {
+			/* Handle internally generated ABTS timeout */
+			BNX2FC_IO_DBG(io_req, "ABTS timed out refcnt = %d\n",
+					io_req->refcount.refcount.counter);
+			if (!(test_and_set_bit(BNX2FC_FLAG_ABTS_DONE,
+					       &io_req->req_flags))) {
+
+				lport = io_req->port->lport;
+				rdata = io_req->tgt->rdata;
+				logo_issued = test_and_set_bit(
+						BNX2FC_FLAG_EXPL_LOGO,
+						&tgt->flags);
+				kref_put(&io_req->refcount, bnx2fc_cmd_release);
+				spin_unlock_bh(&tgt->tgt_lock);
+
+				/* Explicitly logo the target */
+				if (!logo_issued) {
+					BNX2FC_IO_DBG(io_req, "Explicit "
+						   "logo - tgt flags = 0x%lx\n",
+						   tgt->flags);
+
+					mutex_lock(&lport->disc.disc_mutex);
+					lport->tt.rport_logoff(rdata);
+					mutex_unlock(&lport->disc.disc_mutex);
+				}
+				return;
+			}
+		} else {
+			/* Hanlde IO timeout */
+			BNX2FC_IO_DBG(io_req, "IO timed out. issue ABTS\n");
+			if (test_and_set_bit(BNX2FC_FLAG_IO_COMPL,
+					     &io_req->req_flags)) {
+				BNX2FC_IO_DBG(io_req, "IO completed before "
+							   " timer expiry\n");
+				goto done;
+			}
+
+			if (!test_and_set_bit(BNX2FC_FLAG_ISSUE_ABTS,
+					      &io_req->req_flags)) {
+				rc = bnx2fc_initiate_abts(io_req);
+				if (rc == SUCCESS)
+					goto done;
+				/*
+				 * Explicitly logo the target if
+				 * abts initiation fails
+				 */
+				lport = io_req->port->lport;
+				rdata = io_req->tgt->rdata;
+				logo_issued = test_and_set_bit(
+						BNX2FC_FLAG_EXPL_LOGO,
+						&tgt->flags);
+				kref_put(&io_req->refcount, bnx2fc_cmd_release);
+				spin_unlock_bh(&tgt->tgt_lock);
+
+				if (!logo_issued) {
+					BNX2FC_IO_DBG(io_req, "Explicit "
+						   "logo - tgt flags = 0x%lx\n",
+						   tgt->flags);
+
+
+					mutex_lock(&lport->disc.disc_mutex);
+					lport->tt.rport_logoff(rdata);
+					mutex_unlock(&lport->disc.disc_mutex);
+				}
+				return;
+			} else {
+				BNX2FC_IO_DBG(io_req, "IO already in "
+						      "ABTS processing\n");
+			}
+		}
+		break;
+	case BNX2FC_ELS:
+
+		if (test_bit(BNX2FC_FLAG_ISSUE_ABTS, &io_req->req_flags)) {
+			BNX2FC_IO_DBG(io_req, "ABTS for ELS timed out\n");
+
+			if (!test_and_set_bit(BNX2FC_FLAG_ABTS_DONE,
+					      &io_req->req_flags)) {
+				lport = io_req->port->lport;
+				rdata = io_req->tgt->rdata;
+				logo_issued = test_and_set_bit(
+						BNX2FC_FLAG_EXPL_LOGO,
+						&tgt->flags);
+				kref_put(&io_req->refcount, bnx2fc_cmd_release);
+				spin_unlock_bh(&tgt->tgt_lock);
+
+				/* Explicitly logo the target */
+				if (!logo_issued) {
+					BNX2FC_IO_DBG(io_req, "Explicitly logo"
+						   "(els)\n");
+					mutex_lock(&lport->disc.disc_mutex);
+					lport->tt.rport_logoff(rdata);
+					mutex_unlock(&lport->disc.disc_mutex);
+				}
+				return;
+			}
+		} else {
+			/*
+			 * Handle ELS timeout.
+			 * tgt_lock is used to sync compl path and timeout
+			 * path. If els compl path is processing this IO, we
+			 * have nothing to do here, just release the timer hold
+			 */
+			BNX2FC_IO_DBG(io_req, "ELS timed out\n");
+			if (test_and_set_bit(BNX2FC_FLAG_ELS_DONE,
+					       &io_req->req_flags))
+				goto done;
+
+			/* Indicate the cb_func that this ELS is timed out */
+			set_bit(BNX2FC_FLAG_ELS_TIMEOUT, &io_req->req_flags);
+
+			if ((io_req->cb_func) && (io_req->cb_arg)) {
+				io_req->cb_func(io_req->cb_arg);
+				io_req->cb_arg = NULL;
+			}
+		}
+		break;
+	default:
+		printk(KERN_ERR PFX "cmd_timeout: invalid cmd_type %d\n",
+			cmd_type);
+		break;
+	}
+
+done:
+	/* release the cmd that was held when timer was set */
+	kref_put(&io_req->refcount, bnx2fc_cmd_release);
+	spin_unlock_bh(&tgt->tgt_lock);
+}
+
+static void bnx2fc_scsi_done(struct bnx2fc_cmd *io_req, int err_code)
+{
+	/* Called with host lock held */
+	struct scsi_cmnd *sc_cmd = io_req->sc_cmd;
+
+	/*
+	 * active_cmd_queue may have other command types as well,
+	 * and during flush operation,  we want to error back only
+	 * scsi commands.
+	 */
+	if (io_req->cmd_type != BNX2FC_SCSI_CMD)
+		return;
+
+	BNX2FC_IO_DBG(io_req, "scsi_done. err_code = 0x%x\n", err_code);
+	bnx2fc_unmap_sg_list(io_req);
+	io_req->sc_cmd = NULL;
+	if (!sc_cmd) {
+		printk(KERN_ERR PFX "scsi_done - sc_cmd NULL. "
+				    "IO(0x%x) already cleaned up\n",
+		       io_req->xid);
+		return;
+	}
+	sc_cmd->result = err_code << 16;
+
+	BNX2FC_IO_DBG(io_req, "sc=%p, result=0x%x, retries=%d, allowed=%d\n",
+		sc_cmd, host_byte(sc_cmd->result), sc_cmd->retries,
+		sc_cmd->allowed);
+	scsi_set_resid(sc_cmd, scsi_bufflen(sc_cmd));
+	sc_cmd->SCp.ptr = NULL;
+	sc_cmd->scsi_done(sc_cmd);
+}
+
+struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba,
+						u16 min_xid, u16 max_xid)
+{
+	struct bnx2fc_cmd_mgr *cmgr;
+	struct io_bdt *bdt_info;
+	struct bnx2fc_cmd *io_req;
+	size_t len;
+	u32 mem_size;
+	u16 xid;
+	int i;
+	int num_ios;
+	size_t bd_tbl_sz;
+
+	if (max_xid <= min_xid || max_xid == FC_XID_UNKNOWN) {
+		printk(KERN_ERR PFX "cmd_mgr_alloc: Invalid min_xid 0x%x \
+					and max_xid 0x%x\n", min_xid, max_xid);
+		return NULL;
+	}
+	BNX2FC_MISC_DBG("min xid 0x%x, max xid 0x%x\n", min_xid, max_xid);
+
+	num_ios = max_xid - min_xid + 1;
+	len = (num_ios * (sizeof(struct bnx2fc_cmd *)));
+	len += sizeof(struct bnx2fc_cmd_mgr);
+
+	cmgr = kzalloc(len, GFP_KERNEL);
+	if (!cmgr) {
+		printk(KERN_ERR PFX "failed to alloc cmgr\n");
+		return NULL;
+	}
+
+	cmgr->free_list = kzalloc(sizeof(*cmgr->free_list) *
+				  num_possible_cpus(), GFP_KERNEL);
+	if (!cmgr->free_list) {
+		printk(KERN_ERR PFX "failed to alloc free_list\n");
+		goto mem_err;
+	}
+
+	cmgr->free_list_lock = kzalloc(sizeof(*cmgr->free_list_lock) *
+				       num_possible_cpus(), GFP_KERNEL);
+	if (!cmgr->free_list_lock) {
+		printk(KERN_ERR PFX "failed to alloc free_list_lock\n");
+		goto mem_err;
+	}
+
+	cmgr->hba = hba;
+	cmgr->cmds = (struct bnx2fc_cmd **)(cmgr + 1);
+
+	for (i = 0; i < num_possible_cpus(); i++)  {
+		INIT_LIST_HEAD(&cmgr->free_list[i]);
+		spin_lock_init(&cmgr->free_list_lock[i]);
+	}
+
+	/* Pre-allocated pool of bnx2fc_cmds */
+	xid = BNX2FC_MIN_XID;
+	for (i = 0; i < num_ios; i++) {
+		io_req = kzalloc(sizeof(*io_req), GFP_KERNEL);
+
+		if (!io_req) {
+			printk(KERN_ERR PFX "failed to alloc io_req\n");
+			goto mem_err;
+		}
+
+		INIT_LIST_HEAD(&io_req->link);
+		INIT_DELAYED_WORK(&io_req->timeout_work, bnx2fc_cmd_timeout);
+
+		io_req->xid = xid++;
+		if (io_req->xid >= BNX2FC_MAX_OUTSTANDING_CMNDS)
+			printk(KERN_ERR PFX "ERROR allocating xids - 0x%x\n",
+				io_req->xid);
+		list_add_tail(&io_req->link,
+			&cmgr->free_list[io_req->xid % num_possible_cpus()]);
+		io_req++;
+	}
+
+	/* Allocate pool of io_bdts - one for each bnx2fc_cmd */
+	mem_size = num_ios * sizeof(struct io_bdt *);
+	cmgr->io_bdt_pool = kmalloc(mem_size, GFP_KERNEL);
+	if (!cmgr->io_bdt_pool) {
+		printk(KERN_ERR PFX "failed to alloc io_bdt_pool\n");
+		goto mem_err;
+	}
+
+	mem_size = sizeof(struct io_bdt);
+	for (i = 0; i < num_ios; i++) {
+		cmgr->io_bdt_pool[i] = kmalloc(mem_size, GFP_KERNEL);
+		if (!cmgr->io_bdt_pool[i]) {
+			printk(KERN_ERR PFX "failed to alloc "
+				"io_bdt_pool[%d]\n", i);
+			goto mem_err;
+		}
+	}
+
+	/* Allocate an map fcoe_bdt_ctx structures */
+	bd_tbl_sz = BNX2FC_MAX_BDS_PER_CMD * sizeof(struct fcoe_bd_ctx);
+	for (i = 0; i < num_ios; i++) {
+		bdt_info = cmgr->io_bdt_pool[i];
+		bdt_info->bd_tbl = dma_alloc_coherent(&hba->pcidev->dev,
+						      bd_tbl_sz,
+						      &bdt_info->bd_tbl_dma,
+						      GFP_KERNEL);
+		if (!bdt_info->bd_tbl) {
+			printk(KERN_ERR PFX "failed to alloc "
+				"bdt_tbl[%d]\n", i);
+			goto mem_err;
+		}
+	}
+
+	return cmgr;
+
+mem_err:
+	bnx2fc_cmd_mgr_free(cmgr);
+	return NULL;
+}
+
+void bnx2fc_cmd_mgr_free(struct bnx2fc_cmd_mgr *cmgr)
+{
+	struct io_bdt *bdt_info;
+	struct bnx2fc_hba *hba = cmgr->hba;
+	size_t bd_tbl_sz;
+	u16 min_xid = BNX2FC_MIN_XID;
+	u16 max_xid = BNX2FC_MAX_XID;
+	int num_ios;
+	int i;
+
+	num_ios = max_xid - min_xid + 1;
+
+	/* Free fcoe_bdt_ctx structures */
+	if (!cmgr->io_bdt_pool)
+		goto free_cmd_pool;
+
+	bd_tbl_sz = BNX2FC_MAX_BDS_PER_CMD * sizeof(struct fcoe_bd_ctx);
+	for (i = 0; i < num_ios; i++) {
+		bdt_info = cmgr->io_bdt_pool[i];
+		if (bdt_info->bd_tbl) {
+			dma_free_coherent(&hba->pcidev->dev, bd_tbl_sz,
+					    bdt_info->bd_tbl,
+					    bdt_info->bd_tbl_dma);
+			bdt_info->bd_tbl = NULL;
+		}
+	}
+
+	/* Destroy io_bdt pool */
+	for (i = 0; i < num_ios; i++) {
+		kfree(cmgr->io_bdt_pool[i]);
+		cmgr->io_bdt_pool[i] = NULL;
+	}
+
+	kfree(cmgr->io_bdt_pool);
+	cmgr->io_bdt_pool = NULL;
+
+free_cmd_pool:
+	kfree(cmgr->free_list_lock);
+
+	/* Destroy cmd pool */
+	if (!cmgr->free_list)
+		goto free_cmgr;
+
+	for (i = 0; i < num_possible_cpus(); i++)  {
+		struct list_head *list;
+		struct list_head *tmp;
+
+		list_for_each_safe(list, tmp, &cmgr->free_list[i]) {
+			struct bnx2fc_cmd *io_req = (struct bnx2fc_cmd *)list;
+			list_del(&io_req->link);
+			kfree(io_req);
+		}
+	}
+	kfree(cmgr->free_list);
+free_cmgr:
+	/* Free command manager itself */
+	kfree(cmgr);
+}
+
+struct bnx2fc_cmd *bnx2fc_elstm_alloc(struct bnx2fc_rport *tgt, int type)
+{
+	struct fcoe_port *port = tgt->port;
+	struct bnx2fc_hba *hba = port->priv;
+	struct bnx2fc_cmd_mgr *cmd_mgr = hba->cmd_mgr;
+	struct bnx2fc_cmd *io_req;
+	struct list_head *listp;
+	struct io_bdt *bd_tbl;
+	u32 max_sqes;
+	u16 xid;
+
+	max_sqes = tgt->max_sqes;
+	switch (type) {
+	case BNX2FC_TASK_MGMT_CMD:
+		max_sqes = BNX2FC_TM_MAX_SQES;
+		break;
+	case BNX2FC_ELS:
+		max_sqes = BNX2FC_ELS_MAX_SQES;
+		break;
+	default:
+		break;
+	}
+
+	/*
+	 * NOTE: Free list insertions and deletions are protected with
+	 * cmgr lock
+	 */
+	spin_lock_bh(&cmd_mgr->free_list_lock[smp_processor_id()]);
+	if ((list_empty(&(cmd_mgr->free_list[smp_processor_id()]))) ||
+	    (tgt->num_active_ios.counter  >= max_sqes)) {
+		BNX2FC_TGT_DBG(tgt, "No free els_tm cmds available "
+			"ios(%d):sqes(%d)\n",
+			tgt->num_active_ios.counter, tgt->max_sqes);
+		if (list_empty(&(cmd_mgr->free_list[smp_processor_id()])))
+			printk(KERN_ERR PFX "elstm_alloc: list_empty\n");
+		spin_unlock_bh(&cmd_mgr->free_list_lock[smp_processor_id()]);
+		return NULL;
+	}
+
+	listp = (struct list_head *)
+			cmd_mgr->free_list[smp_processor_id()].next;
+	list_del_init(listp);
+	io_req = (struct bnx2fc_cmd *) listp;
+	xid = io_req->xid;
+	cmd_mgr->cmds[xid] = io_req;
+	atomic_inc(&tgt->num_active_ios);
+	spin_unlock_bh(&cmd_mgr->free_list_lock[smp_processor_id()]);
+
+	INIT_LIST_HEAD(&io_req->link);
+
+	io_req->port = port;
+	io_req->cmd_mgr = cmd_mgr;
+	io_req->req_flags = 0;
+	io_req->cmd_type = type;
+
+	/* Bind io_bdt for this io_req */
+	/* Have a static link between io_req and io_bdt_pool */
+	bd_tbl = io_req->bd_tbl = cmd_mgr->io_bdt_pool[xid];
+	bd_tbl->io_req = io_req;
+
+	/* Hold the io_req  against deletion */
+	kref_init(&io_req->refcount);
+	return io_req;
+}
+static struct bnx2fc_cmd *bnx2fc_cmd_alloc(struct bnx2fc_rport *tgt)
+{
+	struct fcoe_port *port = tgt->port;
+	struct bnx2fc_hba *hba = port->priv;
+	struct bnx2fc_cmd_mgr *cmd_mgr = hba->cmd_mgr;
+	struct bnx2fc_cmd *io_req;
+	struct list_head *listp;
+	struct io_bdt *bd_tbl;
+	u32 max_sqes;
+	u16 xid;
+
+	max_sqes = BNX2FC_SCSI_MAX_SQES;
+	/*
+	 * NOTE: Free list insertions and deletions are protected with
+	 * cmgr lock
+	 */
+	spin_lock_bh(&cmd_mgr->free_list_lock[smp_processor_id()]);
+	if ((list_empty(&cmd_mgr->free_list[smp_processor_id()])) ||
+	    (tgt->num_active_ios.counter  >= max_sqes)) {
+		spin_unlock_bh(&cmd_mgr->free_list_lock[smp_processor_id()]);
+		return NULL;
+	}
+
+	listp = (struct list_head *)
+		cmd_mgr->free_list[smp_processor_id()].next;
+	list_del_init(listp);
+	io_req = (struct bnx2fc_cmd *) listp;
+	xid = io_req->xid;
+	cmd_mgr->cmds[xid] = io_req;
+	atomic_inc(&tgt->num_active_ios);
+	spin_unlock_bh(&cmd_mgr->free_list_lock[smp_processor_id()]);
+
+	INIT_LIST_HEAD(&io_req->link);
+
+	io_req->port = port;
+	io_req->cmd_mgr = cmd_mgr;
+	io_req->req_flags = 0;
+
+	/* Bind io_bdt for this io_req */
+	/* Have a static link between io_req and io_bdt_pool */
+	bd_tbl = io_req->bd_tbl = cmd_mgr->io_bdt_pool[xid];
+	bd_tbl->io_req = io_req;
+
+	/* Hold the io_req  against deletion */
+	kref_init(&io_req->refcount);
+	return io_req;
+}
+
+void bnx2fc_cmd_release(struct kref *ref)
+{
+	struct bnx2fc_cmd *io_req = container_of(ref,
+						struct bnx2fc_cmd, refcount);
+	struct bnx2fc_cmd_mgr *cmd_mgr = io_req->cmd_mgr;
+
+	spin_lock_bh(&cmd_mgr->free_list_lock[smp_processor_id()]);
+	if (io_req->cmd_type != BNX2FC_SCSI_CMD)
+		bnx2fc_free_mp_resc(io_req);
+	cmd_mgr->cmds[io_req->xid] = NULL;
+	/* Delete IO from retire queue */
+	list_del_init(&io_req->link);
+	/* Add it to the free list */
+	list_add(&io_req->link,
+			&cmd_mgr->free_list[smp_processor_id()]);
+	atomic_dec(&io_req->tgt->num_active_ios);
+	spin_unlock_bh(&cmd_mgr->free_list_lock[smp_processor_id()]);
+}
+
+static void bnx2fc_free_mp_resc(struct bnx2fc_cmd *io_req)
+{
+	struct bnx2fc_mp_req *mp_req = &(io_req->mp_req);
+	struct bnx2fc_hba *hba = io_req->port->priv;
+	size_t sz = sizeof(struct fcoe_bd_ctx);
+
+	/* clear tm flags */
+	mp_req->tm_flags = 0;
+	if (mp_req->mp_req_bd) {
+		dma_free_coherent(&hba->pcidev->dev, sz,
+				     mp_req->mp_req_bd,
+				     mp_req->mp_req_bd_dma);
+		mp_req->mp_req_bd = NULL;
+	}
+	if (mp_req->mp_resp_bd) {
+		dma_free_coherent(&hba->pcidev->dev, sz,
+				     mp_req->mp_resp_bd,
+				     mp_req->mp_resp_bd_dma);
+		mp_req->mp_resp_bd = NULL;
+	}
+	if (mp_req->req_buf) {
+		dma_free_coherent(&hba->pcidev->dev, PAGE_SIZE,
+				     mp_req->req_buf,
+				     mp_req->req_buf_dma);
+		mp_req->req_buf = NULL;
+	}
+	if (mp_req->resp_buf) {
+		dma_free_coherent(&hba->pcidev->dev, PAGE_SIZE,
+				     mp_req->resp_buf,
+				     mp_req->resp_buf_dma);
+		mp_req->resp_buf = NULL;
+	}
+}
+
+int bnx2fc_init_mp_req(struct bnx2fc_cmd *io_req)
+{
+	struct bnx2fc_mp_req *mp_req;
+	struct fcoe_bd_ctx *mp_req_bd;
+	struct fcoe_bd_ctx *mp_resp_bd;
+	struct bnx2fc_hba *hba = io_req->port->priv;
+	dma_addr_t addr;
+	size_t sz;
+
+	mp_req = (struct bnx2fc_mp_req *)&(io_req->mp_req);
+	memset(mp_req, 0, sizeof(struct bnx2fc_mp_req));
+
+	mp_req->req_len = sizeof(struct fcp_cmnd);
+	io_req->data_xfer_len = mp_req->req_len;
+	mp_req->req_buf = dma_alloc_coherent(&hba->pcidev->dev, PAGE_SIZE,
+					     &mp_req->req_buf_dma,
+					     GFP_ATOMIC);
+	if (!mp_req->req_buf) {
+		printk(KERN_ERR PFX "unable to alloc MP req buffer\n");
+		bnx2fc_free_mp_resc(io_req);
+		return FAILED;
+	}
+
+	mp_req->resp_buf = dma_alloc_coherent(&hba->pcidev->dev, PAGE_SIZE,
+					      &mp_req->resp_buf_dma,
+					      GFP_ATOMIC);
+	if (!mp_req->resp_buf) {
+		printk(KERN_ERR PFX "unable to alloc TM resp buffer\n");
+		bnx2fc_free_mp_resc(io_req);
+		return FAILED;
+	}
+	memset(mp_req->req_buf, 0, PAGE_SIZE);
+	memset(mp_req->resp_buf, 0, PAGE_SIZE);
+
+	/* Allocate and map mp_req_bd and mp_resp_bd */
+	sz = sizeof(struct fcoe_bd_ctx);
+	mp_req->mp_req_bd = dma_alloc_coherent(&hba->pcidev->dev, sz,
+						 &mp_req->mp_req_bd_dma,
+						 GFP_ATOMIC);
+	if (!mp_req->mp_req_bd) {
+		printk(KERN_ERR PFX "unable to alloc MP req bd\n");
+		bnx2fc_free_mp_resc(io_req);
+		return FAILED;
+	}
+	mp_req->mp_resp_bd = dma_alloc_coherent(&hba->pcidev->dev, sz,
+						 &mp_req->mp_resp_bd_dma,
+						 GFP_ATOMIC);
+	if (!mp_req->mp_req_bd) {
+		printk(KERN_ERR PFX "unable to alloc MP resp bd\n");
+		bnx2fc_free_mp_resc(io_req);
+		return FAILED;
+	}
+	/* Fill bd table */
+	addr = mp_req->req_buf_dma;
+	mp_req_bd = mp_req->mp_req_bd;
+	mp_req_bd->buf_addr_lo = (u32)addr & 0xffffffff;
+	mp_req_bd->buf_addr_hi = (u32)((u64)addr >> 32);
+	mp_req_bd->buf_len = PAGE_SIZE;
+	mp_req_bd->flags = 0;
+
+	/*
+	 * MP buffer is either a task mgmt command or an ELS.
+	 * So the assumption is that it consumes a single bd
+	 * entry in the bd table
+	 */
+	mp_resp_bd = mp_req->mp_resp_bd;
+	addr = mp_req->resp_buf_dma;
+	mp_resp_bd->buf_addr_lo = (u32)addr & 0xffffffff;
+	mp_resp_bd->buf_addr_hi = (u32)((u64)addr >> 32);
+	mp_resp_bd->buf_len = PAGE_SIZE;
+	mp_resp_bd->flags = 0;
+
+	return SUCCESS;
+}
+
+static int bnx2fc_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
+{
+	struct fc_lport *lport;
+	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
+	struct fc_rport_libfc_priv *rp = rport->dd_data;
+	struct fcoe_port *port;
+	struct bnx2fc_hba *hba;
+	struct bnx2fc_rport *tgt;
+	struct bnx2fc_cmd *io_req;
+	struct bnx2fc_mp_req *tm_req;
+	struct fcoe_task_ctx_entry *task;
+	struct fcoe_task_ctx_entry *task_page;
+	struct Scsi_Host *host = sc_cmd->device->host;
+	struct fc_frame_header *fc_hdr;
+	struct fcp_cmnd *fcp_cmnd;
+	int task_idx, index;
+	int rc = SUCCESS;
+	u16 xid;
+	u32 sid, did;
+	unsigned long start = jiffies;
+
+	lport = shost_priv(host);
+	port = lport_priv(lport);
+	hba = port->priv;
+
+	if (rport == NULL) {
+		printk(KERN_ALERT PFX "device_reset: rport is NULL\n");
+		rc = FAILED;
+		goto tmf_err;
+	}
+
+	rc = fc_block_scsi_eh(sc_cmd);
+	if (rc)
+		return rc;
+
+	if (lport->state != LPORT_ST_READY || !(lport->link_up)) {
+		printk(KERN_ERR PFX "device_reset: link is not ready\n");
+		rc = FAILED;
+		goto tmf_err;
+	}
+	/* rport and tgt are allocated together, so tgt should be non-NULL */
+	tgt = (struct bnx2fc_rport *)&rp[1];
+
+	if (!(test_bit(BNX2FC_FLAG_SESSION_READY, &tgt->flags))) {
+		printk(KERN_ERR PFX "device_reset: tgt not offloaded\n");
+		rc = FAILED;
+		goto tmf_err;
+	}
+retry_tmf:
+	io_req = bnx2fc_elstm_alloc(tgt, BNX2FC_TASK_MGMT_CMD);
+	if (!io_req) {
+		if (time_after(jiffies, start + HZ)) {
+			printk(KERN_ERR PFX "tmf: Failed TMF");
+			rc = FAILED;
+			goto tmf_err;
+		}
+		msleep(20);
+		goto retry_tmf;
+	}
+	/* Initialize rest of io_req fields */
+	io_req->sc_cmd = sc_cmd;
+	io_req->port = port;
+	io_req->tgt = tgt;
+
+	tm_req = (struct bnx2fc_mp_req *)&(io_req->mp_req);
+
+	rc = bnx2fc_init_mp_req(io_req);
+	if (rc == FAILED) {
+		printk(KERN_ERR PFX "Task mgmt MP request init failed\n");
+		kref_put(&io_req->refcount, bnx2fc_cmd_release);
+		goto tmf_err;
+	}
+
+	/* Set TM flags */
+	io_req->io_req_flags = 0;
+	tm_req->tm_flags = tm_flags;
+
+	/* Fill FCP_CMND */
+	bnx2fc_build_fcp_cmnd(io_req, (struct fcp_cmnd *)tm_req->req_buf);
+	fcp_cmnd = (struct fcp_cmnd *)tm_req->req_buf;
+	memset(fcp_cmnd->fc_cdb, 0,  sc_cmd->cmd_len);
+	fcp_cmnd->fc_dl = 0;
+
+	/* Fill FC header */
+	fc_hdr = &(tm_req->req_fc_hdr);
+	sid = tgt->sid;
+	did = rport->port_id;
+	__fc_fill_fc_hdr(fc_hdr, FC_RCTL_DD_UNSOL_CMD, did, sid,
+			   FC_TYPE_FCP, FC_FC_FIRST_SEQ | FC_FC_END_SEQ |
+			   FC_FC_SEQ_INIT, 0);
+	/* Obtain exchange id */
+	xid = io_req->xid;
+
+	BNX2FC_TGT_DBG(tgt, "Initiate TMF - xid = 0x%x\n", xid);
+	task_idx = xid/BNX2FC_TASKS_PER_PAGE;
+	index = xid % BNX2FC_TASKS_PER_PAGE;
+
+	/* Initialize task context for this IO request */
+	task_page = (struct fcoe_task_ctx_entry *) hba->task_ctx[task_idx];
+	task = &(task_page[index]);
+	bnx2fc_init_mp_task(io_req, task);
+
+	sc_cmd->SCp.ptr = (char *)io_req;
+
+	/* Obtain free SQ entry */
+	spin_lock_bh(&tgt->tgt_lock);
+	bnx2fc_add_2_sq(tgt, xid);
+
+	/* Enqueue the io_req to active_tm_queue */
+	io_req->on_tmf_queue = 1;
+	list_add_tail(&io_req->link, &tgt->active_tm_queue);
+
+	init_completion(&io_req->tm_done);
+	io_req->wait_for_comp = 1;
+
+	/* Ring doorbell */
+	bnx2fc_ring_doorbell(tgt);
+	spin_unlock_bh(&tgt->tgt_lock);
+
+	rc = wait_for_completion_timeout(&io_req->tm_done,
+					 BNX2FC_TM_TIMEOUT * HZ);
+	spin_lock_bh(&tgt->tgt_lock);
+
+	io_req->wait_for_comp = 0;
+	if (!(test_bit(BNX2FC_FLAG_TM_COMPL, &io_req->req_flags)))
+		set_bit(BNX2FC_FLAG_TM_TIMEOUT, &io_req->req_flags);
+
+	spin_unlock_bh(&tgt->tgt_lock);
+
+	if (!rc) {
+		printk(KERN_ERR PFX "task mgmt command failed...\n");
+		rc = FAILED;
+	} else {
+		printk(KERN_ERR PFX "task mgmt command success...\n");
+		rc = SUCCESS;
+	}
+tmf_err:
+	return rc;
+}
+
+int bnx2fc_initiate_abts(struct bnx2fc_cmd *io_req)
+{
+	struct fc_lport *lport;
+	struct bnx2fc_rport *tgt = io_req->tgt;
+	struct fc_rport *rport = tgt->rport;
+	struct fc_rport_priv *rdata = tgt->rdata;
+	struct bnx2fc_hba *hba;
+	struct fcoe_port *port;
+	struct bnx2fc_cmd *abts_io_req;
+	struct fcoe_task_ctx_entry *task;
+	struct fcoe_task_ctx_entry *task_page;
+	struct fc_frame_header *fc_hdr;
+	struct bnx2fc_mp_req *abts_req;
+	int task_idx, index;
+	u32 sid, did;
+	u16 xid;
+	int rc = SUCCESS;
+	u32 r_a_tov = rdata->r_a_tov;
+
+	/* called with tgt_lock held */
+	BNX2FC_IO_DBG(io_req, "Entered bnx2fc_initiate_abts\n");
+
+	port = io_req->port;
+	hba = port->priv;
+	lport = port->lport;
+
+	if (!test_bit(BNX2FC_FLAG_SESSION_READY, &tgt->flags)) {
+		printk(KERN_ERR PFX "initiate_abts: tgt not offloaded\n");
+		rc = FAILED;
+		goto abts_err;
+	}
+
+	if (rport == NULL) {
+		printk(KERN_ALERT PFX "initiate_abts: rport is NULL\n");
+		rc = FAILED;
+		goto abts_err;
+	}
+
+	if (lport->state != LPORT_ST_READY || !(lport->link_up)) {
+		printk(KERN_ERR PFX "initiate_abts: link is not ready\n");
+		rc = FAILED;
+		goto abts_err;
+	}
+
+	abts_io_req = bnx2fc_elstm_alloc(tgt, BNX2FC_ABTS);
+	if (!abts_io_req) {
+		printk(KERN_ERR PFX "abts: couldnt allocate cmd\n");
+		rc = FAILED;
+		goto abts_err;
+	}
+
+	/* Initialize rest of io_req fields */
+	abts_io_req->sc_cmd = NULL;
+	abts_io_req->port = port;
+	abts_io_req->tgt = tgt;
+	abts_io_req->data_xfer_len = 0; /* No data transfer for ABTS */
+
+	abts_req = (struct bnx2fc_mp_req *)&(abts_io_req->mp_req);
+	memset(abts_req, 0, sizeof(struct bnx2fc_mp_req));
+
+	/* Fill FC header */
+	fc_hdr = &(abts_req->req_fc_hdr);
+
+	/* Obtain oxid and rxid for the original exchange to be aborted */
+	fc_hdr->fh_ox_id = htons(io_req->xid);
+	fc_hdr->fh_rx_id = htons(io_req->task->rx_wr_tx_rd.rx_id);
+
+	sid = tgt->sid;
+	did = rport->port_id;
+
+	__fc_fill_fc_hdr(fc_hdr, FC_RCTL_BA_ABTS, did, sid,
+			   FC_TYPE_BLS, FC_FC_FIRST_SEQ | FC_FC_END_SEQ |
+			   FC_FC_SEQ_INIT, 0);
+
+	xid = abts_io_req->xid;
+	BNX2FC_IO_DBG(abts_io_req, "ABTS io_req\n");
+	task_idx = xid/BNX2FC_TASKS_PER_PAGE;
+	index = xid % BNX2FC_TASKS_PER_PAGE;
+
+	/* Initialize task context for this IO request */
+	task_page = (struct fcoe_task_ctx_entry *) hba->task_ctx[task_idx];
+	task = &(task_page[index]);
+	bnx2fc_init_mp_task(abts_io_req, task);
+
+	/*
+	 * ABTS task is a temporary task that will be cleaned up
+	 * irrespective of ABTS response. We need to start the timer
+	 * for the original exchange, as the CQE is posted for the original
+	 * IO request.
+	 *
+	 * Timer for ABTS is started only when it is originated by a
+	 * TM request. For the ABTS issued as part of ULP timeout,
+	 * scsi-ml maintains the timers.
+	 */
+
+	/* if (test_bit(BNX2FC_FLAG_ISSUE_ABTS, &io_req->req_flags))*/
+	bnx2fc_cmd_timer_set(io_req, 2 * r_a_tov);
+
+	/* Obtain free SQ entry */
+	bnx2fc_add_2_sq(tgt, xid);
+
+	/* Ring doorbell */
+	bnx2fc_ring_doorbell(tgt);
+
+abts_err:
+	return rc;
+}
+
+int bnx2fc_initiate_cleanup(struct bnx2fc_cmd *io_req)
+{
+	struct fc_lport *lport;
+	struct bnx2fc_rport *tgt = io_req->tgt;
+	struct bnx2fc_hba *hba;
+	struct fcoe_port *port;
+	struct bnx2fc_cmd *cleanup_io_req;
+	struct fcoe_task_ctx_entry *task;
+	struct fcoe_task_ctx_entry *task_page;
+	int task_idx, index;
+	u16 xid, orig_xid;
+	int rc = 0;
+
+	/* ASSUMPTION: called with tgt_lock held */
+	BNX2FC_IO_DBG(io_req, "Entered bnx2fc_initiate_cleanup\n");
+
+	port = io_req->port;
+	hba = port->priv;
+	lport = port->lport;
+
+	cleanup_io_req = bnx2fc_elstm_alloc(tgt, BNX2FC_CLEANUP);
+	if (!cleanup_io_req) {
+		printk(KERN_ERR PFX "cleanup: couldnt allocate cmd\n");
+		rc = -1;
+		goto cleanup_err;
+	}
+
+	/* Initialize rest of io_req fields */
+	cleanup_io_req->sc_cmd = NULL;
+	cleanup_io_req->port = port;
+	cleanup_io_req->tgt = tgt;
+	cleanup_io_req->data_xfer_len = 0; /* No data transfer for cleanup */
+
+	xid = cleanup_io_req->xid;
+
+	task_idx = xid/BNX2FC_TASKS_PER_PAGE;
+	index = xid % BNX2FC_TASKS_PER_PAGE;
+
+	/* Initialize task context for this IO request */
+	task_page = (struct fcoe_task_ctx_entry *) hba->task_ctx[task_idx];
+	task = &(task_page[index]);
+	orig_xid = io_req->xid;
+
+	BNX2FC_IO_DBG(io_req, "CLEANUP io_req xid = 0x%x\n", xid);
+
+	bnx2fc_init_cleanup_task(cleanup_io_req, task, orig_xid);
+
+	/* Obtain free SQ entry */
+	bnx2fc_add_2_sq(tgt, xid);
+
+	/* Ring doorbell */
+	bnx2fc_ring_doorbell(tgt);
+
+cleanup_err:
+	return rc;
+}
+
+/**
+ * bnx2fc_eh_target_reset: Reset a target
+ *
+ * @sc_cmd:	SCSI command
+ *
+ * Set from SCSI host template to send task mgmt command to the target
+ *	and wait for the response
+ */
+int bnx2fc_eh_target_reset(struct scsi_cmnd *sc_cmd)
+{
+	return bnx2fc_initiate_tmf(sc_cmd, FCP_TMF_TGT_RESET);
+}
+
+/**
+ * bnx2fc_eh_device_reset - Reset a single LUN
+ *
+ * @sc_cmd:	SCSI command
+ *
+ * Set from SCSI host template to send task mgmt command to the target
+ *	and wait for the response
+ */
+int bnx2fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
+{
+	return bnx2fc_initiate_tmf(sc_cmd, FCP_TMF_LUN_RESET);
+}
+
+/**
+ * bnx2fc_eh_abort - eh_abort_handler api to abort an outstanding
+ *			SCSI command
+ *
+ * @sc_cmd:	SCSI_ML command pointer
+ *
+ * SCSI abort request handler
+ */
+int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
+{
+	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
+	struct fc_rport_libfc_priv *rp = rport->dd_data;
+	struct bnx2fc_cmd *io_req;
+	struct fc_lport *lport;
+	struct bnx2fc_rport *tgt;
+	int rc = FAILED;
+
+
+	rc = fc_block_scsi_eh(sc_cmd);
+	if (rc)
+		return rc;
+
+	lport = shost_priv(sc_cmd->device->host);
+	if ((lport->state != LPORT_ST_READY) || !(lport->link_up)) {
+		printk(KERN_ALERT PFX "eh_abort: link not ready\n");
+		return rc;
+	}
+
+	tgt = (struct bnx2fc_rport *)&rp[1];
+
+	BNX2FC_TGT_DBG(tgt, "Entered bnx2fc_eh_abort\n");
+
+	spin_lock_bh(&tgt->tgt_lock);
+	io_req = (struct bnx2fc_cmd *)sc_cmd->SCp.ptr;
+	if (!io_req) {
+		/* Command might have just completed */
+		printk(KERN_ERR PFX "eh_abort: io_req is NULL\n");
+		spin_unlock_bh(&tgt->tgt_lock);
+		return SUCCESS;
+	}
+	BNX2FC_IO_DBG(io_req, "eh_abort - refcnt = %d\n",
+		      io_req->refcount.refcount.counter);
+
+	/* Hold IO request across abort processing */
+	kref_get(&io_req->refcount);
+
+	BUG_ON(tgt != io_req->tgt);
+
+	/* Remove the io_req from the active_q. */
+	/*
+	 * Task Mgmt functions (LUN RESET & TGT RESET) will not
+	 * issue an ABTS on this particular IO req, as the
+	 * io_req is no longer in the active_q.
+	 */
+	if (tgt->flush_in_prog) {
+		printk(KERN_ALERT PFX "eh_abort: io_req (xid = 0x%x) "
+			"flush in progress\n", io_req->xid);
+		kref_put(&io_req->refcount, bnx2fc_cmd_release);
+		spin_unlock_bh(&tgt->tgt_lock);
+		return SUCCESS;
+	}
+
+	if (io_req->on_active_queue == 0) {
+		printk(KERN_ALERT PFX "eh_abort: io_req (xid = 0x%x) "
+				"not on active_q\n", io_req->xid);
+		/*
+		 * This condition can happen only due to the FW bug,
+		 * where we do not receive cleanup response from
+		 * the FW. Handle this case gracefully by erroring
+		 * back the IO request to SCSI-ml
+		 */
+		bnx2fc_scsi_done(io_req, DID_ABORT);
+
+		kref_put(&io_req->refcount, bnx2fc_cmd_release);
+		spin_unlock_bh(&tgt->tgt_lock);
+		return SUCCESS;
+	}
+
+	/*
+	 * Only eh_abort processing will remove the IO from
+	 * active_cmd_q before processing the request. this is
+	 * done to avoid race conditions between IOs aborted
+	 * as part of task management completion and eh_abort
+	 * processing
+	 */
+	list_del_init(&io_req->link);
+	io_req->on_active_queue = 0;
+	/* Move IO req to retire queue */
+	list_add_tail(&io_req->link, &tgt->io_retire_queue);
+
+	init_completion(&io_req->tm_done);
+	io_req->wait_for_comp = 1;
+
+	if (!test_and_set_bit(BNX2FC_FLAG_ISSUE_ABTS, &io_req->req_flags)) {
+		/* Cancel the current timer running on this io_req */
+		if (cancel_delayed_work(&io_req->timeout_work))
+			kref_put(&io_req->refcount,
+				 bnx2fc_cmd_release); /* drop timer hold */
+		set_bit(BNX2FC_FLAG_EH_ABORT, &io_req->req_flags);
+		rc = bnx2fc_initiate_abts(io_req);
+	} else {
+		printk(KERN_ALERT PFX "eh_abort: io_req (xid = 0x%x) "
+				"already in abts processing\n", io_req->xid);
+		kref_put(&io_req->refcount, bnx2fc_cmd_release);
+		spin_unlock_bh(&tgt->tgt_lock);
+		return SUCCESS;
+	}
+	if (rc == FAILED) {
+		kref_put(&io_req->refcount, bnx2fc_cmd_release);
+		spin_unlock_bh(&tgt->tgt_lock);
+		return rc;
+	}
+	spin_unlock_bh(&tgt->tgt_lock);
+
+	wait_for_completion(&io_req->tm_done);
+
+	spin_lock_bh(&tgt->tgt_lock);
+	io_req->wait_for_comp = 0;
+	if (!(test_and_set_bit(BNX2FC_FLAG_ABTS_DONE,
+				    &io_req->req_flags))) {
+		/* Let the scsi-ml try to recover this command */
+		printk(KERN_ERR PFX "abort failed, xid = 0x%x\n",
+		       io_req->xid);
+		rc = FAILED;
+	} else {
+		/*
+		 * We come here even when there was a race condition
+		 * between timeout and abts completion, and abts
+		 * completion happens just in time.
+		 */
+		BNX2FC_IO_DBG(io_req, "abort succeeded\n");
+		rc = SUCCESS;
+		bnx2fc_scsi_done(io_req, DID_ABORT);
+		kref_put(&io_req->refcount, bnx2fc_cmd_release);
+	}
+
+	/* release the reference taken in eh_abort */
+	kref_put(&io_req->refcount, bnx2fc_cmd_release);
+	spin_unlock_bh(&tgt->tgt_lock);
+	return rc;
+}
+
+void bnx2fc_process_cleanup_compl(struct bnx2fc_cmd *io_req,
+				  struct fcoe_task_ctx_entry *task,
+				  u8 num_rq)
+{
+	BNX2FC_IO_DBG(io_req, "Entered process_cleanup_compl "
+			      "refcnt = %d, cmd_type = %d\n",
+		   io_req->refcount.refcount.counter, io_req->cmd_type);
+	bnx2fc_scsi_done(io_req, DID_ERROR);
+	kref_put(&io_req->refcount, bnx2fc_cmd_release);
+}
+
+void bnx2fc_process_abts_compl(struct bnx2fc_cmd *io_req,
+			       struct fcoe_task_ctx_entry *task,
+			       u8 num_rq)
+{
+	u32 r_ctl;
+	u32 r_a_tov = FC_DEF_R_A_TOV;
+	u8 issue_rrq = 0;
+	struct bnx2fc_rport *tgt = io_req->tgt;
+
+	BNX2FC_IO_DBG(io_req, "Entered process_abts_compl xid = 0x%x"
+			      "refcnt = %d, cmd_type = %d\n",
+		   io_req->xid,
+		   io_req->refcount.refcount.counter, io_req->cmd_type);
+
+	if (test_and_set_bit(BNX2FC_FLAG_ABTS_DONE,
+				       &io_req->req_flags)) {
+		BNX2FC_IO_DBG(io_req, "Timer context finished processing"
+				" this io\n");
+		return;
+	}
+
+	/* Do not issue RRQ as this IO is already cleanedup */
+	if (test_and_set_bit(BNX2FC_FLAG_IO_CLEANUP,
+				&io_req->req_flags))
+		goto io_compl;
+
+	/*
+	 * For ABTS issued due to SCSI eh_abort_handler, timeout
+	 * values are maintained by scsi-ml itself. Cancel timeout
+	 * in case ABTS issued as part of task management function
+	 * or due to FW error.
+	 */
+	if (test_bit(BNX2FC_FLAG_ISSUE_ABTS, &io_req->req_flags))
+		if (cancel_delayed_work(&io_req->timeout_work))
+			kref_put(&io_req->refcount,
+				 bnx2fc_cmd_release); /* drop timer hold */
+
+	r_ctl = task->cmn.general.rsp_info.abts_rsp.r_ctl;
+
+	switch (r_ctl) {
+	case FC_RCTL_BA_ACC:
+		/*
+		 * Dont release this cmd yet. It will be relesed
+		 * after we get RRQ response
+		 */
+		BNX2FC_IO_DBG(io_req, "ABTS response - ACC Send RRQ\n");
+		issue_rrq = 1;
+		break;
+
+	case FC_RCTL_BA_RJT:
+		BNX2FC_IO_DBG(io_req, "ABTS response - RJT\n");
+		break;
+	default:
+		printk(KERN_ERR PFX "Unknown ABTS response\n");
+		break;
+	}
+
+	if (issue_rrq) {
+		BNX2FC_IO_DBG(io_req, "Issue RRQ after R_A_TOV\n");
+		set_bit(BNX2FC_FLAG_ISSUE_RRQ, &io_req->req_flags);
+	}
+	set_bit(BNX2FC_FLAG_RETIRE_OXID, &io_req->req_flags);
+	bnx2fc_cmd_timer_set(io_req, r_a_tov);
+
+io_compl:
+	if (io_req->wait_for_comp) {
+		if (test_and_clear_bit(BNX2FC_FLAG_EH_ABORT,
+				       &io_req->req_flags))
+			complete(&io_req->tm_done);
+	} else {
+		/*
+		 * We end up here when ABTS is issued as
+		 * in asynchronous context, i.e., as part
+		 * of task management completion, or
+		 * when FW error is received or when the
+		 * ABTS is issued when the IO is timed
+		 * out.
+		 */
+
+		if (io_req->on_active_queue) {
+			list_del_init(&io_req->link);
+			io_req->on_active_queue = 0;
+			/* Move IO req to retire queue */
+			list_add_tail(&io_req->link, &tgt->io_retire_queue);
+		}
+		bnx2fc_scsi_done(io_req, DID_ERROR);
+		kref_put(&io_req->refcount, bnx2fc_cmd_release);
+	}
+}
+
+static void bnx2fc_lun_reset_cmpl(struct bnx2fc_cmd *io_req)
+{
+	struct scsi_cmnd *sc_cmd = io_req->sc_cmd;
+	struct bnx2fc_rport *tgt = io_req->tgt;
+	struct list_head *list;
+	struct list_head *tmp;
+	struct bnx2fc_cmd *cmd;
+	int tm_lun = sc_cmd->device->lun;
+	int rc = 0;
+	int lun;
+
+	/* called with tgt_lock held */
+	BNX2FC_IO_DBG(io_req, "Entered bnx2fc_lun_reset_cmpl\n");
+	/*
+	 * Walk thru the active_ios queue and ABORT the IO
+	 * that matches with the LUN that was reset
+	 */
+	list_for_each_safe(list, tmp, &tgt->active_cmd_queue) {
+		BNX2FC_TGT_DBG(tgt, "LUN RST cmpl: scan for pending IOs\n");
+		cmd = (struct bnx2fc_cmd *)list;
+		lun = cmd->sc_cmd->device->lun;
+		if (lun == tm_lun) {
+			/* Initiate ABTS on this cmd */
+			if (!test_and_set_bit(BNX2FC_FLAG_ISSUE_ABTS,
+					      &cmd->req_flags)) {
+				/* cancel the IO timeout */
+				if (cancel_delayed_work(&io_req->timeout_work))
+					kref_put(&io_req->refcount,
+						 bnx2fc_cmd_release);
+							/* timer hold */
+				rc = bnx2fc_initiate_abts(cmd);
+				/* abts shouldnt fail in this context */
+				WARN_ON(rc != SUCCESS);
+			} else
+				printk(KERN_ERR PFX "lun_rst: abts already in"
+					" progress for this IO 0x%x\n",
+					cmd->xid);
+		}
+	}
+}
+
+static void bnx2fc_tgt_reset_cmpl(struct bnx2fc_cmd *io_req)
+{
+	struct bnx2fc_rport *tgt = io_req->tgt;
+	struct list_head *list;
+	struct list_head *tmp;
+	struct bnx2fc_cmd *cmd;
+	int rc = 0;
+
+	/* called with tgt_lock held */
+	BNX2FC_IO_DBG(io_req, "Entered bnx2fc_tgt_reset_cmpl\n");
+	/*
+	 * Walk thru the active_ios queue and ABORT the IO
+	 * that matches with the LUN that was reset
+	 */
+	list_for_each_safe(list, tmp, &tgt->active_cmd_queue) {
+		BNX2FC_TGT_DBG(tgt, "TGT RST cmpl: scan for pending IOs\n");
+		cmd = (struct bnx2fc_cmd *)list;
+		/* Initiate ABTS */
+		if (!test_and_set_bit(BNX2FC_FLAG_ISSUE_ABTS,
+							&cmd->req_flags)) {
+			/* cancel the IO timeout */
+			if (cancel_delayed_work(&io_req->timeout_work))
+				kref_put(&io_req->refcount,
+					 bnx2fc_cmd_release); /* timer hold */
+			rc = bnx2fc_initiate_abts(cmd);
+			/* abts shouldnt fail in this context */
+			WARN_ON(rc != SUCCESS);
+
+		} else
+			printk(KERN_ERR PFX "tgt_rst: abts already in progress"
+				" for this IO 0x%x\n", cmd->xid);
+	}
+}
+
+void bnx2fc_process_tm_compl(struct bnx2fc_cmd *io_req,
+			     struct fcoe_task_ctx_entry *task, u8 num_rq)
+{
+	struct bnx2fc_mp_req *tm_req;
+	struct fc_frame_header *fc_hdr;
+	struct scsi_cmnd *sc_cmd = io_req->sc_cmd;
+	u64 *hdr;
+	u64 *temp_hdr;
+	void *rsp_buf;
+
+	/* Called with tgt_lock held */
+	BNX2FC_IO_DBG(io_req, "Entered process_tm_compl\n");
+
+	if (!(test_bit(BNX2FC_FLAG_TM_TIMEOUT, &io_req->req_flags)))
+		set_bit(BNX2FC_FLAG_TM_COMPL, &io_req->req_flags);
+	else {
+		/* TM has already timed out and we got
+		 * delayed completion. Ignore completion
+		 * processing.
+		 */
+		return;
+	}
+
+	tm_req = &(io_req->mp_req);
+	fc_hdr = &(tm_req->resp_fc_hdr);
+	hdr = (u64 *)fc_hdr;
+	temp_hdr = (u64 *)
+		&task->cmn.general.cmd_info.mp_fc_frame.fc_hdr;
+	hdr[0] = cpu_to_be64(temp_hdr[0]);
+	hdr[1] = cpu_to_be64(temp_hdr[1]);
+	hdr[2] = cpu_to_be64(temp_hdr[2]);
+
+	tm_req->resp_len = task->rx_wr_only.sgl_ctx.mul_sges.cur_sge_off;
+
+	rsp_buf = tm_req->resp_buf;
+
+	if (fc_hdr->fh_r_ctl == FC_RCTL_DD_CMD_STATUS) {
+		bnx2fc_parse_fcp_rsp(io_req,
+				     (struct fcoe_fcp_rsp_payload *)
+				     rsp_buf, num_rq);
+		if (io_req->fcp_rsp_code == 0) {
+			/* TM successful */
+			if (tm_req->tm_flags & FCP_TMF_LUN_RESET)
+				bnx2fc_lun_reset_cmpl(io_req);
+			else if (tm_req->tm_flags & FCP_TMF_TGT_RESET)
+				bnx2fc_tgt_reset_cmpl(io_req);
+		}
+	} else {
+		printk(KERN_ERR PFX "tmf's fc_hdr r_ctl = 0x%x\n",
+			fc_hdr->fh_r_ctl);
+	}
+	if (!sc_cmd->SCp.ptr) {
+		printk(KERN_ALERT PFX "tm_compl: SCp.ptr is NULL\n");
+		return;
+	}
+	switch (io_req->fcp_status) {
+	case FC_GOOD:
+		if (io_req->cdb_status == 0) {
+			/* Good IO completion */
+			sc_cmd->result = DID_OK << 16;
+		} else {
+			/* Transport status is good, SCSI status not good */
+			sc_cmd->result = (DID_OK << 16) | io_req->cdb_status;
+		}
+		if (io_req->fcp_resid)
+			scsi_set_resid(sc_cmd, io_req->fcp_resid);
+		break;
+
+	default:
+		BNX2FC_IO_DBG(io_req, "process_tm_compl: fcp_status = %d\n",
+			   io_req->fcp_status);
+		break;
+	}
+
+	sc_cmd = io_req->sc_cmd;
+	io_req->sc_cmd = NULL;
+
+	/* check if the io_req exists in tgt's tmf_q */
+	if (io_req->on_tmf_queue) {
+
+		list_del_init(&io_req->link);
+		io_req->on_tmf_queue = 0;
+	} else {
+
+		printk(KERN_ALERT PFX "Command not on active_cmd_queue!\n");
+		return;
+	}
+
+	sc_cmd->SCp.ptr = NULL;
+	sc_cmd->scsi_done(sc_cmd);
+
+	kref_put(&io_req->refcount, bnx2fc_cmd_release);
+	if (io_req->wait_for_comp) {
+		BNX2FC_IO_DBG(io_req, "tm_compl - wake up the waiter\n");
+		complete(&io_req->tm_done);
+	}
+}
+
+static int bnx2fc_split_bd(struct bnx2fc_cmd *io_req, u64 addr, int sg_len,
+			   int bd_index)
+{
+	struct fcoe_bd_ctx *bd = io_req->bd_tbl->bd_tbl;
+	int frag_size, sg_frags;
+
+	sg_frags = 0;
+	while (sg_len) {
+		if (sg_len >= BNX2FC_BD_SPLIT_SZ)
+			frag_size = BNX2FC_BD_SPLIT_SZ;
+		else
+			frag_size = sg_len;
+		bd[bd_index + sg_frags].buf_addr_lo = addr & 0xffffffff;
+		bd[bd_index + sg_frags].buf_addr_hi  = addr >> 32;
+		bd[bd_index + sg_frags].buf_len = (u16)frag_size;;
+		bd[bd_index + sg_frags].flags = 0;
+
+		addr += (u64) frag_size;
+		sg_frags++;
+		sg_len -= frag_size;
+	}
+	return sg_frags;
+
+}
+
+static int bnx2fc_map_sg(struct bnx2fc_cmd *io_req)
+{
+	struct scsi_cmnd *sc = io_req->sc_cmd;
+	struct fcoe_bd_ctx *bd = io_req->bd_tbl->bd_tbl;
+	struct scatterlist *sg;
+	int byte_count = 0;
+	int sg_count = 0;
+	int bd_count = 0;
+	int sg_frags;
+	unsigned int sg_len;
+	u64 addr;
+	int i;
+
+	sg_count = scsi_dma_map(sc);
+	scsi_for_each_sg(sc, sg, sg_count, i) {
+		sg_len = sg_dma_len(sg);
+		addr = sg_dma_address(sg);
+		if (sg_len > BNX2FC_MAX_BD_LEN) {
+			sg_frags = bnx2fc_split_bd(io_req, addr, sg_len,
+						   bd_count);
+		} else {
+
+			sg_frags = 1;
+			bd[bd_count].buf_addr_lo = addr & 0xffffffff;
+			bd[bd_count].buf_addr_hi  = addr >> 32;
+			bd[bd_count].buf_len = (u16)sg_len;
+			bd[bd_count].flags = 0;
+		}
+		bd_count += sg_frags;
+		byte_count += sg_len;
+	}
+	if (byte_count != scsi_bufflen(sc))
+		printk(KERN_ERR PFX "byte_count = %d != scsi_bufflen = %d, "
+			"task_id = 0x%x\n", byte_count, scsi_bufflen(sc),
+			io_req->xid);
+	return bd_count;
+}
+
+static void bnx2fc_build_bd_list_from_sg(struct bnx2fc_cmd *io_req)
+{
+	struct scsi_cmnd *sc = io_req->sc_cmd;
+	struct fcoe_bd_ctx *bd = io_req->bd_tbl->bd_tbl;
+	int bd_count;
+
+	if (scsi_sg_count(sc))
+		bd_count = bnx2fc_map_sg(io_req);
+	else {
+		bd_count = 0;
+		bd[0].buf_addr_lo = bd[0].buf_addr_hi = 0;
+		bd[0].buf_len = bd[0].flags = 0;
+	}
+	io_req->bd_tbl->bd_valid = bd_count;
+}
+
+static void bnx2fc_unmap_sg_list(struct bnx2fc_cmd *io_req)
+{
+	struct scsi_cmnd *sc = io_req->sc_cmd;
+
+	if (io_req->bd_tbl->bd_valid && sc) {
+		scsi_dma_unmap(sc);
+		io_req->bd_tbl->bd_valid = 0;
+	}
+}
+
+void bnx2fc_build_fcp_cmnd(struct bnx2fc_cmd *io_req,
+				  struct fcp_cmnd *fcp_cmnd)
+{
+	struct scsi_cmnd *sc_cmd = io_req->sc_cmd;
+	char tag[2];
+
+	memset(fcp_cmnd, 0, sizeof(struct fcp_cmnd));
+
+	int_to_scsilun(sc_cmd->device->lun,
+			(struct scsi_lun *) fcp_cmnd->fc_lun);
+
+
+	fcp_cmnd->fc_dl = htonl(io_req->data_xfer_len);
+	memcpy(fcp_cmnd->fc_cdb, sc_cmd->cmnd, sc_cmd->cmd_len);
+
+	fcp_cmnd->fc_cmdref = 0;
+	fcp_cmnd->fc_pri_ta = 0;
+	fcp_cmnd->fc_tm_flags = io_req->mp_req.tm_flags;
+	fcp_cmnd->fc_flags = io_req->io_req_flags;
+
+	if (scsi_populate_tag_msg(sc_cmd, tag)) {
+		switch (tag[0]) {
+		case HEAD_OF_QUEUE_TAG:
+			fcp_cmnd->fc_pri_ta = FCP_PTA_HEADQ;
+			break;
+		case ORDERED_QUEUE_TAG:
+			fcp_cmnd->fc_pri_ta = FCP_PTA_ORDERED;
+			break;
+		default:
+			fcp_cmnd->fc_pri_ta = FCP_PTA_SIMPLE;
+			break;
+		}
+	} else {
+		fcp_cmnd->fc_pri_ta = 0;
+	}
+}
+
+static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd *io_req,
+				 struct fcoe_fcp_rsp_payload *fcp_rsp,
+				 u8 num_rq)
+{
+	struct scsi_cmnd *sc_cmd = io_req->sc_cmd;
+	struct bnx2fc_rport *tgt = io_req->tgt;
+	u8 rsp_flags = fcp_rsp->fcp_flags.flags;
+	u32 rq_buff_len = 0;
+	int i;
+	unsigned char *rq_data;
+	unsigned char *dummy;
+	int fcp_sns_len = 0;
+	int fcp_rsp_len = 0;
+
+	io_req->fcp_status = FC_GOOD;
+	io_req->fcp_resid = fcp_rsp->fcp_resid;
+
+	io_req->scsi_comp_flags = rsp_flags;
+	CMD_SCSI_STATUS(sc_cmd) = io_req->cdb_status =
+				fcp_rsp->scsi_status_code;
+
+	/* Fetch fcp_rsp_info and fcp_sns_info if available */
+	if (num_rq) {
+
+		/*
+		 * We do not anticipate num_rq >1, as the linux defined
+		 * SCSI_SENSE_BUFFERSIZE is 96 bytes + 8 bytes of FCP_RSP_INFO
+		 * 256 bytes of single rq buffer is good enough to hold this.
+		 */
+
+		if (rsp_flags &
+		    FCOE_FCP_RSP_FLAGS_FCP_RSP_LEN_VALID) {
+			fcp_rsp_len = rq_buff_len
+					= fcp_rsp->fcp_rsp_len;
+		}
+
+		if (rsp_flags &
+		    FCOE_FCP_RSP_FLAGS_FCP_SNS_LEN_VALID) {
+			fcp_sns_len = fcp_rsp->fcp_sns_len;
+			rq_buff_len += fcp_rsp->fcp_sns_len;
+		}
+
+		io_req->fcp_rsp_len = fcp_rsp_len;
+		io_req->fcp_sns_len = fcp_sns_len;
+
+		if (rq_buff_len > num_rq * BNX2FC_RQ_BUF_SZ) {
+			/* Invalid sense sense length. */
+			printk(KERN_ALERT PFX "invalid sns length %d\n",
+				rq_buff_len);
+			/* reset rq_buff_len */
+			rq_buff_len =  num_rq * BNX2FC_RQ_BUF_SZ;
+		}
+
+		rq_data = bnx2fc_get_next_rqe(tgt, 1);
+
+		if (num_rq > 1) {
+			/* We do not need extra sense data */
+			for (i = 1; i < num_rq; i++)
+				dummy = bnx2fc_get_next_rqe(tgt, 1);
+		}
+
+		/* fetch fcp_rsp_code */
+		if ((fcp_rsp_len == 4) || (fcp_rsp_len == 8)) {
+			/* Only for task management function */
+			io_req->fcp_rsp_code = rq_data[3];
+			printk(KERN_ERR PFX "fcp_rsp_code = %d\n",
+				io_req->fcp_rsp_code);
+		}
+
+		/* fetch sense data */
+		rq_data += fcp_rsp_len;
+
+		if (fcp_sns_len > SCSI_SENSE_BUFFERSIZE) {
+			printk(KERN_ERR PFX "Truncating sense buffer\n");
+			fcp_sns_len = SCSI_SENSE_BUFFERSIZE;
+		}
+
+		memset(sc_cmd->sense_buffer, 0, sizeof(sc_cmd->sense_buffer));
+		if (fcp_sns_len)
+			memcpy(sc_cmd->sense_buffer, rq_data, fcp_sns_len);
+
+		/* return RQ entries */
+		for (i = 0; i < num_rq; i++)
+			bnx2fc_return_rqe(tgt, 1);
+	}
+}
+
+/**
+ * bnx2fc_queuecommand - Queuecommand function of the scsi template
+ *
+ * @host:	The Scsi_Host the command was issued to
+ * @sc_cmd:	struct scsi_cmnd to be executed
+ *
+ * This is the IO strategy routine, called by SCSI-ML
+ **/
+int bnx2fc_queuecommand(struct Scsi_Host *host,
+			struct scsi_cmnd *sc_cmd)
+{
+	struct fc_lport *lport = shost_priv(host);
+	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
+	struct fc_rport_libfc_priv *rp = rport->dd_data;
+	struct bnx2fc_rport *tgt;
+	struct bnx2fc_cmd *io_req;
+	int rc = 0;
+	int rval;
+
+	rval = fc_remote_port_chkready(rport);
+	if (rval) {
+		sc_cmd->result = rval;
+		sc_cmd->scsi_done(sc_cmd);
+		return 0;
+	}
+
+	if ((lport->state != LPORT_ST_READY) || !(lport->link_up)) {
+		rc = SCSI_MLQUEUE_HOST_BUSY;
+		goto exit_qcmd;
+	}
+
+	/* rport and tgt are allocated together, so tgt should be non-NULL */
+	tgt = (struct bnx2fc_rport *)&rp[1];
+
+	if (!test_bit(BNX2FC_FLAG_SESSION_READY, &tgt->flags)) {
+		/*
+		 * Session is not offloaded yet. Let SCSI-ml retry
+		 * the command.
+		 */
+		rc = SCSI_MLQUEUE_TARGET_BUSY;
+		goto exit_qcmd;
+	}
+
+	io_req = bnx2fc_cmd_alloc(tgt);
+	if (!io_req) {
+		rc = SCSI_MLQUEUE_HOST_BUSY;
+		goto exit_qcmd;
+	}
+	io_req->sc_cmd = sc_cmd;
+
+	if (bnx2fc_post_io_req(tgt, io_req)) {
+		printk(KERN_ERR PFX "Unable to post io_req\n");
+		rc = SCSI_MLQUEUE_HOST_BUSY;
+		goto exit_qcmd;
+	}
+exit_qcmd:
+	return rc;
+}
+
+void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
+				   struct fcoe_task_ctx_entry *task,
+				   u8 num_rq)
+{
+	struct fcoe_fcp_rsp_payload *fcp_rsp;
+	struct bnx2fc_rport *tgt = io_req->tgt;
+	struct scsi_cmnd *sc_cmd;
+	struct Scsi_Host *host;
+
+
+	/* scsi_cmd_cmpl is called with tgt lock held */
+
+	if (test_and_set_bit(BNX2FC_FLAG_IO_COMPL, &io_req->req_flags)) {
+		/* we will not receive ABTS response for this IO */
+		BNX2FC_IO_DBG(io_req, "Timer context finished processing "
+			   "this scsi cmd\n");
+	}
+
+	/* Cancel the timeout_work, as we received IO completion */
+	if (cancel_delayed_work(&io_req->timeout_work))
+		kref_put(&io_req->refcount,
+			 bnx2fc_cmd_release); /* drop timer hold */
+
+	sc_cmd = io_req->sc_cmd;
+	if (sc_cmd == NULL) {
+		printk(KERN_ERR PFX "scsi_cmd_compl - sc_cmd is NULL\n");
+		return;
+	}
+
+	/* Fetch fcp_rsp from task context and perform cmd completion */
+	fcp_rsp = (struct fcoe_fcp_rsp_payload *)
+		   &(task->cmn.general.rsp_info.fcp_rsp.payload);
+
+	/* parse fcp_rsp and obtain sense data from RQ if available */
+	bnx2fc_parse_fcp_rsp(io_req, fcp_rsp, num_rq);
+
+	host = sc_cmd->device->host;
+	if (!sc_cmd->SCp.ptr) {
+		printk(KERN_ERR PFX "SCp.ptr is NULL\n");
+		return;
+	}
+	io_req->sc_cmd = NULL;
+
+	if (io_req->on_active_queue) {
+		list_del_init(&io_req->link);
+		io_req->on_active_queue = 0;
+		/* Move IO req to retire queue */
+		list_add_tail(&io_req->link, &tgt->io_retire_queue);
+	} else {
+		/* This should not happen, but could have been pulled
+		 * by bnx2fc_flush_active_ios(), or during a race
+		 * between command abort and (late) completion.
+		 */
+		BNX2FC_IO_DBG(io_req, "xid not on active_cmd_queue\n");
+		if (io_req->wait_for_comp)
+			if (test_and_clear_bit(BNX2FC_FLAG_EH_ABORT,
+					       &io_req->req_flags))
+				complete(&io_req->tm_done);
+	}
+
+	bnx2fc_unmap_sg_list(io_req);
+
+	switch (io_req->fcp_status) {
+	case FC_GOOD:
+		if (io_req->cdb_status == 0) {
+			/* Good IO completion */
+			sc_cmd->result = DID_OK << 16;
+		} else {
+			/* Transport status is good, SCSI status not good */
+			BNX2FC_IO_DBG(io_req, "scsi_cmpl: cdb_status = %d"
+				 " fcp_resid = 0x%x\n",
+				io_req->cdb_status, io_req->fcp_resid);
+			sc_cmd->result = (DID_OK << 16) | io_req->cdb_status;
+		}
+		if (io_req->fcp_resid)
+			scsi_set_resid(sc_cmd, io_req->fcp_resid);
+		break;
+	default:
+		printk(KERN_ALERT PFX "scsi_cmd_compl: fcp_status = %d\n",
+			io_req->fcp_status);
+		break;
+	}
+	sc_cmd->SCp.ptr = NULL;
+	sc_cmd->scsi_done(sc_cmd);
+	kref_put(&io_req->refcount, bnx2fc_cmd_release);
+}
+
+static int bnx2fc_post_io_req(struct bnx2fc_rport *tgt,
+			       struct bnx2fc_cmd *io_req)
+{
+	struct fcoe_task_ctx_entry *task;
+	struct fcoe_task_ctx_entry *task_page;
+	struct scsi_cmnd *sc_cmd = io_req->sc_cmd;
+	struct fcoe_port *port = tgt->port;
+	struct bnx2fc_hba *hba = port->priv;
+	struct fc_lport *lport = port->lport;
+	struct fcoe_dev_stats *stats;
+	int task_idx, index;
+	u16 xid;
+
+	/* Initialize rest of io_req fields */
+	io_req->cmd_type = BNX2FC_SCSI_CMD;
+	io_req->port = port;
+	io_req->tgt = tgt;
+	io_req->data_xfer_len = scsi_bufflen(sc_cmd);
+	sc_cmd->SCp.ptr = (char *)io_req;
+
+	stats = per_cpu_ptr(lport->dev_stats, get_cpu());
+	if (sc_cmd->sc_data_direction == DMA_FROM_DEVICE) {
+		io_req->io_req_flags = BNX2FC_READ;
+		stats->InputRequests++;
+		stats->InputBytes += io_req->data_xfer_len;
+	} else if (sc_cmd->sc_data_direction == DMA_TO_DEVICE) {
+		io_req->io_req_flags = BNX2FC_WRITE;
+		stats->OutputRequests++;
+		stats->OutputBytes += io_req->data_xfer_len;
+	} else {
+		io_req->io_req_flags = 0;
+		stats->ControlRequests++;
+	}
+	put_cpu();
+
+	xid = io_req->xid;
+
+	/* Build buffer descriptor list for firmware from sg list */
+	bnx2fc_build_bd_list_from_sg(io_req);
+
+	task_idx = xid / BNX2FC_TASKS_PER_PAGE;
+	index = xid % BNX2FC_TASKS_PER_PAGE;
+
+	/* Initialize task context for this IO request */
+	task_page = (struct fcoe_task_ctx_entry *) hba->task_ctx[task_idx];
+	task = &(task_page[index]);
+	bnx2fc_init_task(io_req, task);
+
+	spin_lock_bh(&tgt->tgt_lock);
+
+	if (tgt->flush_in_prog) {
+		printk(KERN_ERR PFX "Flush in progress..Host Busy\n");
+		kref_put(&io_req->refcount, bnx2fc_cmd_release);
+		spin_unlock_bh(&tgt->tgt_lock);
+		return -EAGAIN;
+	}
+
+	if (!test_bit(BNX2FC_FLAG_SESSION_READY, &tgt->flags)) {
+		printk(KERN_ERR PFX "Session not ready...post_io\n");
+		kref_put(&io_req->refcount, bnx2fc_cmd_release);
+		spin_unlock_bh(&tgt->tgt_lock);
+		return -EAGAIN;
+	}
+
+	/* Time IO req */
+	bnx2fc_cmd_timer_set(io_req, BNX2FC_IO_TIMEOUT);
+	/* Obtain free SQ entry */
+	bnx2fc_add_2_sq(tgt, xid);
+
+	/* Enqueue the io_req to active_cmd_queue */
+
+	io_req->on_active_queue = 1;
+	/* move io_req from pending_queue to active_queue */
+	list_add_tail(&io_req->link, &tgt->active_cmd_queue);
+
+	/* Ring doorbell */
+	bnx2fc_ring_doorbell(tgt);
+	spin_unlock_bh(&tgt->tgt_lock);
+	return 0;
+}
diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
new file mode 100644
index 0000000..7ea93af
--- /dev/null
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -0,0 +1,844 @@
+/* bnx2fc_tgt.c: Broadcom NetXtreme II Linux FCoE offload driver.
+ * Handles operations such as session offload/upload etc, and manages
+ * session resources such as connection id and qp resources.
+ *
+ * Copyright (c) 2008 - 2010 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ *
+ * Written by: Bhanu Prakash Gollapudi (bprakash@broadcom.com)
+ */
+
+#include "bnx2fc.h"
+static void bnx2fc_upld_timer(unsigned long data);
+static void bnx2fc_ofld_timer(unsigned long data);
+static int bnx2fc_init_tgt(struct bnx2fc_rport *tgt,
+			   struct fcoe_port *port,
+			   struct fc_rport_priv *rdata);
+static u32 bnx2fc_alloc_conn_id(struct bnx2fc_hba *hba,
+				struct bnx2fc_rport *tgt);
+static int bnx2fc_alloc_session_resc(struct bnx2fc_hba *hba,
+			      struct bnx2fc_rport *tgt);
+static void bnx2fc_free_session_resc(struct bnx2fc_hba *hba,
+			      struct bnx2fc_rport *tgt);
+static void bnx2fc_free_conn_id(struct bnx2fc_hba *hba, u32 conn_id);
+
+static void bnx2fc_upld_timer(unsigned long data)
+{
+
+	struct bnx2fc_rport *tgt = (struct bnx2fc_rport *)data;
+
+	BNX2FC_TGT_DBG(tgt, "upld_timer - Upload compl not received!!\n");
+	/* fake upload completion */
+	clear_bit(BNX2FC_FLAG_OFFLOADED, &tgt->flags);
+	set_bit(BNX2FC_FLAG_UPLD_REQ_COMPL, &tgt->flags);
+	wake_up_interruptible(&tgt->upld_wait);
+}
+
+static void bnx2fc_ofld_timer(unsigned long data)
+{
+
+	struct bnx2fc_rport *tgt = (struct bnx2fc_rport *)data;
+
+	BNX2FC_TGT_DBG(tgt, "entered bnx2fc_ofld_timer\n");
+	/* NOTE: This function should never be called, as
+	 * offload should never timeout
+	 */
+	/*
+	 * If the timer has expired, this session is dead
+	 * Clear offloaded flag and logout of this device.
+	 * Since OFFLOADED flag is cleared, this case
+	 * will be considered as offload error and the
+	 * port will be logged off, and conn_id, session
+	 * resources are freed up in bnx2fc_offload_session
+	 */
+	clear_bit(BNX2FC_FLAG_OFFLOADED, &tgt->flags);
+	set_bit(BNX2FC_FLAG_OFLD_REQ_CMPL, &tgt->flags);
+	wake_up_interruptible(&tgt->ofld_wait);
+}
+
+static void bnx2fc_offload_session(struct fcoe_port *port,
+					struct bnx2fc_rport *tgt,
+					struct fc_rport_priv *rdata)
+{
+	struct fc_lport *lport = rdata->local_port;
+	struct fc_rport *rport = rdata->rport;
+	struct bnx2fc_hba *hba = port->priv;
+	int rval;
+	int i = 0;
+
+	/* Initialize bnx2fc_rport */
+	/* NOTE: tgt is already bzero'd */
+	rval = bnx2fc_init_tgt(tgt, port, rdata);
+	if (rval) {
+		printk(KERN_ERR PFX "Failed to allocate conn id for "
+			"port_id (%6x)\n", rport->port_id);
+		goto ofld_err;
+	}
+
+	/* Allocate session resources */
+	rval = bnx2fc_alloc_session_resc(hba, tgt);
+	if (rval) {
+		printk(KERN_ERR PFX "Failed to allocate resources\n");
+		goto ofld_err;
+	}
+
+	/*
+	 * Initialize FCoE session offload process.
+	 * Upon completion of offload process add
+	 * rport to list of rports
+	 */
+retry_ofld:
+	clear_bit(BNX2FC_FLAG_OFLD_REQ_CMPL, &tgt->flags);
+	rval = bnx2fc_send_session_ofld_req(port, tgt);
+	if (rval) {
+		printk(KERN_ERR PFX "ofld_req failed\n");
+		goto ofld_err;
+	}
+
+	/*
+	 * wait for the session is offloaded and enabled. 3 Secs
+	 * should be ample time for this process to complete.
+	 */
+	setup_timer(&tgt->ofld_timer, bnx2fc_ofld_timer, (unsigned long)tgt);
+	mod_timer(&tgt->ofld_timer, jiffies + BNX2FC_FW_TIMEOUT);
+
+	wait_event_interruptible(tgt->ofld_wait,
+				 (test_bit(
+				  BNX2FC_FLAG_OFLD_REQ_CMPL,
+				  &tgt->flags)));
+	if (signal_pending(current))
+		flush_signals(current);
+
+	del_timer_sync(&tgt->ofld_timer);
+
+	if (!(test_bit(BNX2FC_FLAG_OFFLOADED, &tgt->flags))) {
+		if (test_and_clear_bit(BNX2FC_FLAG_CTX_ALLOC_FAILURE,
+				       &tgt->flags)) {
+			BNX2FC_TGT_DBG(tgt, "ctx_alloc_failure, "
+				"retry ofld..%d\n", i++);
+			msleep_interruptible(1000);
+			if (i > 3) {
+				i = 0;
+				goto ofld_err;
+			}
+			goto retry_ofld;
+		}
+		goto ofld_err;
+	}
+	if (bnx2fc_map_doorbell(tgt)) {
+		printk(KERN_ERR PFX "map doorbell failed - no mem\n");
+		/* upload will take care of cleaning up sess resc */
+		lport->tt.rport_logoff(rdata);
+	}
+	return;
+
+ofld_err:
+	/* couldn't offload the session. log off from this rport */
+	BNX2FC_TGT_DBG(tgt, "bnx2fc_offload_session - offload error\n");
+	lport->tt.rport_logoff(rdata);
+	/* Free session resources */
+	bnx2fc_free_session_resc(hba, tgt);
+	if (tgt->fcoe_conn_id != -1)
+		bnx2fc_free_conn_id(hba, tgt->fcoe_conn_id);
+}
+
+void bnx2fc_flush_active_ios(struct bnx2fc_rport *tgt)
+{
+	struct bnx2fc_cmd *io_req;
+	struct list_head *list;
+	struct list_head *tmp;
+	int rc;
+	int i = 0;
+	BNX2FC_TGT_DBG(tgt, "Entered flush_active_ios - %d\n",
+		       tgt->num_active_ios.counter);
+
+	spin_lock_bh(&tgt->tgt_lock);
+	tgt->flush_in_prog = 1;
+
+	list_for_each_safe(list, tmp, &tgt->active_cmd_queue) {
+		i++;
+		io_req = (struct bnx2fc_cmd *)list;
+		list_del_init(&io_req->link);
+		io_req->on_active_queue = 0;
+		BNX2FC_IO_DBG(io_req, "cmd_queue cleanup\n");
+
+		if (cancel_delayed_work(&io_req->timeout_work)) {
+			if (test_and_clear_bit(BNX2FC_FLAG_EH_ABORT,
+						&io_req->req_flags)) {
+				/* Handle eh_abort timeout */
+				BNX2FC_IO_DBG(io_req, "eh_abort for IO "
+					      "cleaned up\n");
+				complete(&io_req->tm_done);
+			}
+			kref_put(&io_req->refcount,
+				 bnx2fc_cmd_release); /* drop timer hold */
+		}
+
+		set_bit(BNX2FC_FLAG_IO_COMPL, &io_req->req_flags);
+		set_bit(BNX2FC_FLAG_IO_CLEANUP, &io_req->req_flags);
+		rc = bnx2fc_initiate_cleanup(io_req);
+		BUG_ON(rc);
+	}
+
+	list_for_each_safe(list, tmp, &tgt->els_queue) {
+		i++;
+		io_req = (struct bnx2fc_cmd *)list;
+		list_del_init(&io_req->link);
+		io_req->on_active_queue = 0;
+
+		BNX2FC_IO_DBG(io_req, "els_queue cleanup\n");
+
+		if (cancel_delayed_work(&io_req->timeout_work))
+			kref_put(&io_req->refcount,
+				 bnx2fc_cmd_release); /* drop timer hold */
+
+		if ((io_req->cb_func) && (io_req->cb_arg)) {
+			io_req->cb_func(io_req->cb_arg);
+			io_req->cb_arg = NULL;
+		}
+
+		rc = bnx2fc_initiate_cleanup(io_req);
+		BUG_ON(rc);
+	}
+
+	list_for_each_safe(list, tmp, &tgt->io_retire_queue) {
+		i++;
+		io_req = (struct bnx2fc_cmd *)list;
+		list_del_init(&io_req->link);
+
+		BNX2FC_IO_DBG(io_req, "retire_queue flush\n");
+
+		if (cancel_delayed_work(&io_req->timeout_work))
+			kref_put(&io_req->refcount, bnx2fc_cmd_release);
+
+		clear_bit(BNX2FC_FLAG_ISSUE_RRQ, &io_req->req_flags);
+	}
+
+	BNX2FC_TGT_DBG(tgt, "IOs flushed = %d\n", i);
+	i = 0;
+	spin_unlock_bh(&tgt->tgt_lock);
+	/* wait for active_ios to go to 0 */
+	while ((tgt->num_active_ios.counter != 0) && (i++ < BNX2FC_WAIT_CNT))
+		msleep(25);
+	if (tgt->num_active_ios.counter != 0)
+		printk(KERN_ERR PFX "CLEANUP on port 0x%x:"
+				    " active_ios = %d\n",
+			tgt->rdata->ids.port_id, tgt->num_active_ios.counter);
+	spin_lock_bh(&tgt->tgt_lock);
+	tgt->flush_in_prog = 0;
+	spin_unlock_bh(&tgt->tgt_lock);
+}
+
+static void bnx2fc_upload_session(struct fcoe_port *port,
+					struct bnx2fc_rport *tgt)
+{
+	struct bnx2fc_hba *hba = port->priv;
+
+	BNX2FC_TGT_DBG(tgt, "upload_session: active_ios = %d\n",
+		tgt->num_active_ios.counter);
+
+	/*
+	 * Called with hba->hba_mutex held.
+	 * This is a blocking call
+	 */
+	clear_bit(BNX2FC_FLAG_UPLD_REQ_COMPL, &tgt->flags);
+	bnx2fc_send_session_disable_req(port, tgt);
+
+	/*
+	 * wait for upload to complete. 3 Secs
+	 * should be sufficient time for this process to complete.
+	 */
+	setup_timer(&tgt->upld_timer, bnx2fc_upld_timer, (unsigned long)tgt);
+	mod_timer(&tgt->upld_timer, jiffies + BNX2FC_FW_TIMEOUT);
+
+	BNX2FC_TGT_DBG(tgt, "waiting for disable compl\n");
+	wait_event_interruptible(tgt->upld_wait,
+				 (test_bit(
+				  BNX2FC_FLAG_UPLD_REQ_COMPL,
+				  &tgt->flags)));
+
+	if (signal_pending(current))
+		flush_signals(current);
+
+	del_timer_sync(&tgt->upld_timer);
+
+	/*
+	 * traverse thru the active_q and tmf_q and cleanup
+	 * IOs in these lists
+	 */
+	BNX2FC_TGT_DBG(tgt, "flush/upload - disable wait flags = 0x%lx\n",
+		       tgt->flags);
+	bnx2fc_flush_active_ios(tgt);
+
+	/* Issue destroy KWQE */
+	if (test_bit(BNX2FC_FLAG_DISABLED, &tgt->flags)) {
+		BNX2FC_TGT_DBG(tgt, "send destroy req\n");
+		clear_bit(BNX2FC_FLAG_UPLD_REQ_COMPL, &tgt->flags);
+		bnx2fc_send_session_destroy_req(hba, tgt);
+
+		/* wait for destroy to complete */
+		setup_timer(&tgt->upld_timer,
+			    bnx2fc_upld_timer, (unsigned long)tgt);
+		mod_timer(&tgt->upld_timer, jiffies + BNX2FC_FW_TIMEOUT);
+
+		wait_event_interruptible(tgt->upld_wait,
+					 (test_bit(
+					  BNX2FC_FLAG_UPLD_REQ_COMPL,
+					  &tgt->flags)));
+
+		if (!(test_bit(BNX2FC_FLAG_DESTROYED, &tgt->flags)))
+			printk(KERN_ERR PFX "ERROR!! destroy timed out\n");
+
+		BNX2FC_TGT_DBG(tgt, "destroy wait complete flags = 0x%lx\n",
+			tgt->flags);
+		if (signal_pending(current))
+			flush_signals(current);
+
+		del_timer_sync(&tgt->upld_timer);
+
+	} else
+		printk(KERN_ERR PFX "ERROR!! DISABLE req timed out, destroy"
+				" not sent to FW\n");
+
+	/* Free session resources */
+	spin_lock_bh(&tgt->cq_lock);
+	bnx2fc_free_session_resc(hba, tgt);
+	bnx2fc_free_conn_id(hba, tgt->fcoe_conn_id);
+	spin_unlock_bh(&tgt->cq_lock);
+}
+
+static int bnx2fc_init_tgt(struct bnx2fc_rport *tgt,
+			   struct fcoe_port *port,
+			   struct fc_rport_priv *rdata)
+{
+
+	struct fc_rport *rport = rdata->rport;
+	struct bnx2fc_hba *hba = port->priv;
+
+	tgt->rport = rport;
+	tgt->rdata = rdata;
+	tgt->port = port;
+
+	if (hba->num_ofld_sess >= BNX2FC_NUM_MAX_SESS) {
+		BNX2FC_TGT_DBG(tgt, "exceeded max sessions. logoff this tgt\n");
+		tgt->fcoe_conn_id = -1;
+		return -1;
+	}
+
+	tgt->fcoe_conn_id = bnx2fc_alloc_conn_id(hba, tgt);
+	if (tgt->fcoe_conn_id == -1)
+		return -1;
+
+	BNX2FC_TGT_DBG(tgt, "init_tgt - conn_id = 0x%x\n", tgt->fcoe_conn_id);
+
+	tgt->max_sqes = BNX2FC_SQ_WQES_MAX;
+	tgt->max_rqes = BNX2FC_RQ_WQES_MAX;
+	tgt->max_cqes = BNX2FC_CQ_WQES_MAX;
+
+	/* Initialize the toggle bit */
+	tgt->sq_curr_toggle_bit = 1;
+	tgt->cq_curr_toggle_bit = 1;
+	tgt->sq_prod_idx = 0;
+	tgt->cq_cons_idx = 0;
+	tgt->rq_prod_idx = 0x8000;
+	tgt->rq_cons_idx = 0;
+	atomic_set(&tgt->num_active_ios, 0);
+
+	tgt->work_time_slice = 2;
+
+	spin_lock_init(&tgt->tgt_lock);
+	spin_lock_init(&tgt->cq_lock);
+
+	/* Initialize active_cmd_queue list */
+	INIT_LIST_HEAD(&tgt->active_cmd_queue);
+
+	/* Initialize IO retire queue */
+	INIT_LIST_HEAD(&tgt->io_retire_queue);
+
+	INIT_LIST_HEAD(&tgt->els_queue);
+
+	/* Initialize active_tm_queue list */
+	INIT_LIST_HEAD(&tgt->active_tm_queue);
+
+	init_waitqueue_head(&tgt->ofld_wait);
+	init_waitqueue_head(&tgt->upld_wait);
+
+	return 0;
+}
+
+/**
+ * This event_callback is called after successful completion of libfc
+ * initiated target login. bnx2fc can proceed with initiating the session
+ * establishment.
+ */
+void bnx2fc_rport_event_handler(struct fc_lport *lport,
+				struct fc_rport_priv *rdata,
+				enum fc_rport_event event)
+{
+	struct fcoe_port *port = lport_priv(lport);
+	struct bnx2fc_hba *hba = port->priv;
+	struct fc_rport *rport = rdata->rport;
+	struct fc_rport_libfc_priv *rp;
+	struct bnx2fc_rport *tgt;
+	u32 port_id;
+
+	BNX2FC_HBA_DBG(lport, "rport_event_hdlr: event = %d, port_id = 0x%x\n",
+		event, rdata->ids.port_id);
+	switch (event) {
+	case RPORT_EV_READY:
+		if (!rport) {
+			printk(KERN_ALERT PFX "rport is NULL: ERROR!\n");
+			break;
+		}
+
+		rp = rport->dd_data;
+		if (rport->port_id == FC_FID_DIR_SERV) {
+			/*
+			 * bnx2fc_rport structure doesnt exist for
+			 * directory server.
+			 * We should not come here, as lport will
+			 * take care of fabric login
+			 */
+			printk(KERN_ALERT PFX "%x - rport_event_handler ERROR\n",
+				rdata->ids.port_id);
+			break;
+		}
+
+		if (rdata->spp_type != FC_TYPE_FCP) {
+			BNX2FC_HBA_DBG(lport, "not FCP type target."
+				   " not offloading\n");
+			break;
+		}
+		if (!(rdata->ids.roles & FC_RPORT_ROLE_FCP_TARGET)) {
+			BNX2FC_HBA_DBG(lport, "not FCP_TARGET"
+				   " not offloading\n");
+			break;
+		}
+
+		/*
+		 * Offlaod process is protected with hba mutex.
+		 * Use the same mutex_lock for upload process too
+		 */
+		mutex_lock(&hba->hba_mutex);
+		tgt = (struct bnx2fc_rport *)&rp[1];
+
+		/* This can happen when ADISC finds the same target */
+		if (test_bit(BNX2FC_FLAG_OFFLOADED, &tgt->flags)) {
+			BNX2FC_TGT_DBG(tgt, "already offloaded\n");
+			mutex_unlock(&hba->hba_mutex);
+			return;
+		}
+
+		/*
+		 * Offload the session. This is a blocking call, and will
+		 * wait until the session is offloaded.
+		 */
+		bnx2fc_offload_session(port, tgt, rdata);
+
+		BNX2FC_TGT_DBG(tgt, "OFFLOAD num_ofld_sess = %d\n",
+			hba->num_ofld_sess);
+
+		if (test_bit(BNX2FC_FLAG_OFFLOADED, &tgt->flags)) {
+			/*
+			 * Session is offloaded and enabled. Map
+			 * doorbell register for this target
+			 */
+			BNX2FC_TGT_DBG(tgt, "sess offloaded\n");
+			/* This counter is protected with hba mutex */
+			hba->num_ofld_sess++;
+
+			set_bit(BNX2FC_FLAG_SESSION_READY, &tgt->flags);
+		} else {
+			/*
+			 * Offload or enable would have failed.
+			 * In offload/enable completion path, the
+			 * rport would have already been removed
+			 */
+			BNX2FC_TGT_DBG(tgt, "Port is being logged off as "
+				   "offloaded flag not set\n");
+		}
+		mutex_unlock(&hba->hba_mutex);
+		break;
+	case RPORT_EV_LOGO:
+	case RPORT_EV_FAILED:
+	case RPORT_EV_STOP:
+		port_id = rdata->ids.port_id;
+		if (port_id == FC_FID_DIR_SERV)
+			break;
+
+		if (!rport) {
+			printk(KERN_ALERT PFX "%x - rport not created Yet!!\n",
+				port_id);
+			break;
+		}
+		rp = rport->dd_data;
+		mutex_lock(&hba->hba_mutex);
+		/*
+		 * Perform session upload. Note that rdata->peers is already
+		 * removed from disc->rports list before we get this event.
+		 */
+		tgt = (struct bnx2fc_rport *)&rp[1];
+
+		if (!(test_bit(BNX2FC_FLAG_OFFLOADED, &tgt->flags))) {
+			mutex_unlock(&hba->hba_mutex);
+			break;
+		}
+		clear_bit(BNX2FC_FLAG_SESSION_READY, &tgt->flags);
+
+		bnx2fc_upload_session(port, tgt);
+		hba->num_ofld_sess--;
+		BNX2FC_TGT_DBG(tgt, "UPLOAD num_ofld_sess = %d\n",
+			hba->num_ofld_sess);
+		/*
+		 * Try to wake up the linkdown wait thread. If num_ofld_sess
+		 * is 0, the waiting therad wakes up
+		 */
+		if ((hba->wait_for_link_down) &&
+		    (hba->num_ofld_sess == 0)) {
+			wake_up_interruptible(&hba->shutdown_wait);
+		}
+		if (test_bit(BNX2FC_FLAG_EXPL_LOGO, &tgt->flags)) {
+			printk(KERN_ERR PFX "Relogin to the tgt\n");
+			mutex_lock(&lport->disc.disc_mutex);
+			lport->tt.rport_login(rdata);
+			mutex_unlock(&lport->disc.disc_mutex);
+		}
+		mutex_unlock(&hba->hba_mutex);
+
+		break;
+
+	case RPORT_EV_NONE:
+		break;
+	}
+}
+
+/**
+ * bnx2fc_tgt_lookup() - Lookup a bnx2fc_rport by port_id
+ *
+ * @port:  fcoe_port struct to lookup the target port on
+ * @port_id: The remote port ID to look up
+ */
+struct bnx2fc_rport *bnx2fc_tgt_lookup(struct fcoe_port *port,
+					     u32 port_id)
+{
+	struct bnx2fc_hba *hba = port->priv;
+	struct bnx2fc_rport *tgt;
+	struct fc_rport_priv *rdata;
+	int i;
+
+	for (i = 0; i < BNX2FC_NUM_MAX_SESS; i++) {
+		tgt = hba->tgt_ofld_list[i];
+		if ((tgt) && (tgt->port == port)) {
+			rdata = tgt->rdata;
+			if (rdata->ids.port_id == port_id) {
+				if (rdata->rp_state != RPORT_ST_DELETE) {
+					BNX2FC_TGT_DBG(tgt, "rport "
+						"obtained\n");
+					return tgt;
+				} else {
+					printk(KERN_ERR PFX "rport 0x%x "
+						"is in DELETED state\n",
+						rdata->ids.port_id);
+					return NULL;
+				}
+			}
+		}
+	}
+	return NULL;
+}
+
+
+/**
+ * bnx2fc_alloc_conn_id - allocates FCOE Connection id
+ *
+ * @hba:	pointer to adapter structure
+ * @tgt:	pointer to bnx2fc_rport structure
+ */
+static u32 bnx2fc_alloc_conn_id(struct bnx2fc_hba *hba,
+				struct bnx2fc_rport *tgt)
+{
+	u32 conn_id, next;
+
+	/* called with hba mutex held */
+
+	/*
+	 * tgt_ofld_list access is synchronized using
+	 * both hba mutex and hba lock. Atleast hba mutex or
+	 * hba lock needs to be held for read access.
+	 */
+
+	spin_lock_bh(&hba->hba_lock);
+	next = hba->next_conn_id;
+	conn_id = hba->next_conn_id++;
+	if (hba->next_conn_id == BNX2FC_NUM_MAX_SESS)
+		hba->next_conn_id = 0;
+
+	while (hba->tgt_ofld_list[conn_id] != NULL) {
+		conn_id++;
+		if (conn_id == BNX2FC_NUM_MAX_SESS)
+			conn_id = 0;
+
+		if (conn_id == next) {
+			/* No free conn_ids are available */
+			spin_unlock_bh(&hba->hba_lock);
+			return -1;
+		}
+	}
+	hba->tgt_ofld_list[conn_id] = tgt;
+	tgt->fcoe_conn_id = conn_id;
+	spin_unlock_bh(&hba->hba_lock);
+	return conn_id;
+}
+
+static void bnx2fc_free_conn_id(struct bnx2fc_hba *hba, u32 conn_id)
+{
+	/* called with hba mutex held */
+	spin_lock_bh(&hba->hba_lock);
+	hba->tgt_ofld_list[conn_id] = NULL;
+	hba->next_conn_id = conn_id;
+	spin_unlock_bh(&hba->hba_lock);
+}
+
+/**
+ *bnx2fc_alloc_session_resc - Allocate qp resources for the session
+ *
+ */
+static int bnx2fc_alloc_session_resc(struct bnx2fc_hba *hba,
+					struct bnx2fc_rport *tgt)
+{
+	dma_addr_t page;
+	int num_pages;
+	u32 *pbl;
+
+	/* Allocate and map SQ */
+	tgt->sq_mem_size = tgt->max_sqes * BNX2FC_SQ_WQE_SIZE;
+	tgt->sq_mem_size = (tgt->sq_mem_size + (PAGE_SIZE - 1)) & PAGE_MASK;
+
+	tgt->sq = dma_alloc_coherent(&hba->pcidev->dev, tgt->sq_mem_size,
+				     &tgt->sq_dma, GFP_KERNEL);
+	if (!tgt->sq) {
+		printk(KERN_ALERT PFX "unable to allocate SQ memory %d\n",
+			tgt->sq_mem_size);
+		goto mem_alloc_failure;
+	}
+	memset(tgt->sq, 0, tgt->sq_mem_size);
+
+	/* Allocate and map CQ */
+	tgt->cq_mem_size = tgt->max_cqes * BNX2FC_CQ_WQE_SIZE;
+	tgt->cq_mem_size = (tgt->cq_mem_size + (PAGE_SIZE - 1)) & PAGE_MASK;
+
+	tgt->cq = dma_alloc_coherent(&hba->pcidev->dev, tgt->cq_mem_size,
+				     &tgt->cq_dma, GFP_KERNEL);
+	if (!tgt->cq) {
+		printk(KERN_ALERT PFX "unable to allocate CQ memory %d\n",
+			tgt->cq_mem_size);
+		goto mem_alloc_failure;
+	}
+	memset(tgt->cq, 0, tgt->cq_mem_size);
+
+	/* Allocate and map RQ and RQ PBL */
+	tgt->rq_mem_size = tgt->max_rqes * BNX2FC_RQ_WQE_SIZE;
+	tgt->rq_mem_size = (tgt->rq_mem_size + (PAGE_SIZE - 1)) & PAGE_MASK;
+
+	tgt->rq = dma_alloc_coherent(&hba->pcidev->dev, tgt->rq_mem_size,
+					&tgt->rq_dma, GFP_KERNEL);
+	if (!tgt->rq) {
+		printk(KERN_ALERT PFX "unable to allocate RQ memory %d\n",
+			tgt->rq_mem_size);
+		goto mem_alloc_failure;
+	}
+	memset(tgt->rq, 0, tgt->rq_mem_size);
+
+	tgt->rq_pbl_size = (tgt->rq_mem_size / PAGE_SIZE) * sizeof(void *);
+	tgt->rq_pbl_size = (tgt->rq_pbl_size + (PAGE_SIZE - 1)) & PAGE_MASK;
+
+	tgt->rq_pbl = dma_alloc_coherent(&hba->pcidev->dev, tgt->rq_pbl_size,
+					 &tgt->rq_pbl_dma, GFP_KERNEL);
+	if (!tgt->rq_pbl) {
+		printk(KERN_ALERT PFX "unable to allocate RQ PBL %d\n",
+			tgt->rq_pbl_size);
+		goto mem_alloc_failure;
+	}
+
+	memset(tgt->rq_pbl, 0, tgt->rq_pbl_size);
+	num_pages = tgt->rq_mem_size / PAGE_SIZE;
+	page = tgt->rq_dma;
+	pbl = (u32 *)tgt->rq_pbl;
+
+	while (num_pages--) {
+		*pbl = (u32)page;
+		pbl++;
+		*pbl = (u32)((u64)page >> 32);
+		pbl++;
+		page += PAGE_SIZE;
+	}
+
+	/* Allocate and map XFERQ */
+	tgt->xferq_mem_size = tgt->max_sqes * BNX2FC_XFERQ_WQE_SIZE;
+	tgt->xferq_mem_size = (tgt->xferq_mem_size + (PAGE_SIZE - 1)) &
+			       PAGE_MASK;
+
+	tgt->xferq = dma_alloc_coherent(&hba->pcidev->dev, tgt->xferq_mem_size,
+					&tgt->xferq_dma, GFP_KERNEL);
+	if (!tgt->xferq) {
+		printk(KERN_ALERT PFX "unable to allocate XFERQ %d\n",
+			tgt->xferq_mem_size);
+		goto mem_alloc_failure;
+	}
+	memset(tgt->xferq, 0, tgt->xferq_mem_size);
+
+	/* Allocate and map CONFQ & CONFQ PBL */
+	tgt->confq_mem_size = tgt->max_sqes * BNX2FC_CONFQ_WQE_SIZE;
+	tgt->confq_mem_size = (tgt->confq_mem_size + (PAGE_SIZE - 1)) &
+			       PAGE_MASK;
+
+	tgt->confq = dma_alloc_coherent(&hba->pcidev->dev, tgt->confq_mem_size,
+					&tgt->confq_dma, GFP_KERNEL);
+	if (!tgt->confq) {
+		printk(KERN_ALERT PFX "unable to allocate CONFQ %d\n",
+			tgt->confq_mem_size);
+		goto mem_alloc_failure;
+	}
+	memset(tgt->confq, 0, tgt->confq_mem_size);
+
+	tgt->confq_pbl_size =
+		(tgt->confq_mem_size / PAGE_SIZE) * sizeof(void *);
+	tgt->confq_pbl_size =
+		(tgt->confq_pbl_size + (PAGE_SIZE - 1)) & PAGE_MASK;
+
+	tgt->confq_pbl = dma_alloc_coherent(&hba->pcidev->dev,
+					    tgt->confq_pbl_size,
+					    &tgt->confq_pbl_dma, GFP_KERNEL);
+	if (!tgt->confq_pbl) {
+		printk(KERN_ALERT PFX "unable to allocate CONFQ PBL %d\n",
+			tgt->confq_pbl_size);
+		goto mem_alloc_failure;
+	}
+
+	memset(tgt->confq_pbl, 0, tgt->confq_pbl_size);
+	num_pages = tgt->confq_mem_size / PAGE_SIZE;
+	page = tgt->confq_dma;
+	pbl = (u32 *)tgt->confq_pbl;
+
+	while (num_pages--) {
+		*pbl = (u32)page;
+		pbl++;
+		*pbl = (u32)((u64)page >> 32);
+		pbl++;
+		page += PAGE_SIZE;
+	}
+
+	/* Allocate and map ConnDB */
+	tgt->conn_db_mem_size = sizeof(struct fcoe_conn_db);
+
+	tgt->conn_db = dma_alloc_coherent(&hba->pcidev->dev,
+					  tgt->conn_db_mem_size,
+					  &tgt->conn_db_dma, GFP_KERNEL);
+	if (!tgt->conn_db) {
+		printk(KERN_ALERT PFX "unable to allocate conn_db %d\n",
+						tgt->conn_db_mem_size);
+		goto mem_alloc_failure;
+	}
+	memset(tgt->conn_db, 0, tgt->conn_db_mem_size);
+
+
+	/* Allocate and map LCQ */
+	tgt->lcq_mem_size = (tgt->max_sqes + 8) * BNX2FC_SQ_WQE_SIZE;
+	tgt->lcq_mem_size = (tgt->lcq_mem_size + (PAGE_SIZE - 1)) &
+			     PAGE_MASK;
+
+	tgt->lcq = dma_alloc_coherent(&hba->pcidev->dev, tgt->lcq_mem_size,
+				      &tgt->lcq_dma, GFP_KERNEL);
+
+	if (!tgt->lcq) {
+		printk(KERN_ALERT PFX "unable to allocate lcq %d\n",
+		       tgt->lcq_mem_size);
+		goto mem_alloc_failure;
+	}
+	memset(tgt->lcq, 0, tgt->lcq_mem_size);
+
+	/* Arm CQ */
+	tgt->conn_db->cq_arm.lo = -1;
+	tgt->conn_db->rq_prod = 0x8000;
+
+	return 0;
+
+mem_alloc_failure:
+	bnx2fc_free_session_resc(hba, tgt);
+	bnx2fc_free_conn_id(hba, tgt->fcoe_conn_id);
+	return -ENOMEM;
+}
+
+/**
+ * bnx2i_free_session_resc - free qp resources for the session
+ *
+ * @hba:	adapter structure pointer
+ * @tgt:	bnx2fc_rport structure pointer
+ *
+ * Free QP resources - SQ/RQ/CQ/XFERQ memory and PBL
+ */
+static void bnx2fc_free_session_resc(struct bnx2fc_hba *hba,
+						struct bnx2fc_rport *tgt)
+{
+	BNX2FC_TGT_DBG(tgt, "Freeing up session resources\n");
+
+	if (tgt->ctx_base) {
+		iounmap(tgt->ctx_base);
+		tgt->ctx_base = NULL;
+	}
+	/* Free LCQ */
+	if (tgt->lcq) {
+		dma_free_coherent(&hba->pcidev->dev, tgt->lcq_mem_size,
+				    tgt->lcq, tgt->lcq_dma);
+		tgt->lcq = NULL;
+	}
+	/* Free connDB */
+	if (tgt->conn_db) {
+		dma_free_coherent(&hba->pcidev->dev, tgt->conn_db_mem_size,
+				    tgt->conn_db, tgt->conn_db_dma);
+		tgt->conn_db = NULL;
+	}
+	/* Free confq  and confq pbl */
+	if (tgt->confq_pbl) {
+		dma_free_coherent(&hba->pcidev->dev, tgt->confq_pbl_size,
+				    tgt->confq_pbl, tgt->confq_pbl_dma);
+		tgt->confq_pbl = NULL;
+	}
+	if (tgt->confq) {
+		dma_free_coherent(&hba->pcidev->dev, tgt->confq_mem_size,
+				    tgt->confq, tgt->confq_dma);
+		tgt->confq = NULL;
+	}
+	/* Free XFERQ */
+	if (tgt->xferq) {
+		dma_free_coherent(&hba->pcidev->dev, tgt->xferq_mem_size,
+				    tgt->xferq, tgt->xferq_dma);
+		tgt->xferq = NULL;
+	}
+	/* Free RQ PBL and RQ */
+	if (tgt->rq_pbl) {
+		dma_free_coherent(&hba->pcidev->dev, tgt->rq_pbl_size,
+				    tgt->rq_pbl, tgt->rq_pbl_dma);
+		tgt->rq_pbl = NULL;
+	}
+	if (tgt->rq) {
+		dma_free_coherent(&hba->pcidev->dev, tgt->rq_mem_size,
+				    tgt->rq, tgt->rq_dma);
+		tgt->rq = NULL;
+	}
+	/* Free CQ */
+	if (tgt->cq) {
+		dma_free_coherent(&hba->pcidev->dev, tgt->cq_mem_size,
+				    tgt->cq, tgt->cq_dma);
+		tgt->cq = NULL;
+	}
+	/* Free SQ */
+	if (tgt->sq) {
+		dma_free_coherent(&hba->pcidev->dev, tgt->sq_mem_size,
+				    tgt->sq, tgt->sq_dma);
+		tgt->sq = NULL;
+	}
+}
-- 
1.7.0.6




