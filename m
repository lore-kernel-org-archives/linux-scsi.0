From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH 18/19]: ibmvstgt: Port from tgt to SCST
Date: Sat, 02 Oct 2010 02:04:05 +0400
Message-ID: <4CA65AD5.6010001@vlnb.net>
References: <4CA653F0.1010008@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:60060 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab0JAWGS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Oct 2010 18:06:18 -0400
In-Reply-To: <4CA653F0.1010008@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Robert Jennings <rcj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, Mike Anderson <andmike@us.ibm.com>

The current ibmvstgt and libsrp kernel modules are based on the tgt
infrastructure. Both modules need the scsi_tgt kernel module and the tgtd user
space process in order to function properly. This patch modifies the ibmvstgt
and libsrp kernel modules such that both use the SCST storage target framework
instead of tgt.

This patch introduces one backwards-incompatible change, namely that the path
of the ibmvstgt sysfs attributes is modified. This change is unavoidable
because this patch dissociates ibmvstgt SRP sessions from a SCSI host instance.

Notes:
- ibmvstgt is the only user of libsrp.
- A 2.6.35 kernel tree with this patch applied does compile cleanly on the
systems supported by the ibmvstgt kernel module, the patch itself is checkpatch
clean and does not introduce any new sparse warnings. This patch has not been
tested in any other way however. The primary purpose of this patch is to invite
feedback about the chosen approach.

<IMPORTANT>

We are looking for hardware to complete this driver. Any help will be greatly
appreciated!

</IMPORTANT>

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
 Documentation/powerpc/ibmvstgt.txt |    2 
 drivers/scsi/ibmvscsi/ibmvstgt.c   |  609 +++++++++++++++++++++++++------------
 drivers/scsi/libsrp.c              |   87 ++---
 include/scsi/libsrp.h              |   16 
 4 files changed, 474 insertions(+), 240 deletions(-)

--- orig/linux-2.6.35/drivers/scsi/ibmvscsi/ibmvstgt.c 16:47:55.220115813 +0400
+++ linux-2.6.35/drivers/scsi/ibmvscsi/ibmvstgt.c 15:50:36.616855875 +0400
@@ -5,6 +5,7 @@
  *			   Linda Xie (lxie@us.ibm.com) IBM Corp.
  *
  * Copyright (C) 2005-2006 FUJITA Tomonori <tomof@acm.org>
+ * Copyright (C) 2010 Bart Van Assche <bvanassche@acm.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -24,15 +25,13 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_host.h>
-#include <scsi/scsi_transport_srp.h>
-#include <scsi/scsi_tgt.h>
+#include <scst/scst.h>
+#include <scst/scst_debug.h>
 #include <scsi/libsrp.h>
 #include <asm/hvcall.h>
 #include <asm/iommu.h>
 #include <asm/prom.h>
 #include <asm/vio.h>
 
 #include "ibmvscsi.h"
 
@@ -71,11 +87,22 @@ struct vio_port {
 	unsigned long riobn;
 	struct srp_target *target;
 
-	struct srp_rport *rport;
+	struct scst_session *sess;
+	struct device dev;
+	bool releasing;
+	bool enabled;
 };
 
+static atomic_t ibmvstgt_device_count;
 static struct workqueue_struct *vtgtd;
-static struct scsi_transport_template *ibmvstgt_transport_template;
+
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+#define DEFAULT_IBMVSTGT_TRACE_FLAGS \
+	(TRACE_OUT_OF_MEM | TRACE_MINOR | TRACE_MGMT | TRACE_SPECIAL)
+static unsigned long trace_flag = DEFAULT_IBMVSTGT_TRACE_FLAGS;
+module_param(trace_flag, long, 0644);
+MODULE_PARM_DESC(trace_flag, "SCST trace flags.");
+#endif
 
 /*
  * These are fixed for the system and come from the Open Firmware device tree.
@@ -136,7 +163,7 @@ static int send_iu(struct iu_entry *iue,
 
 #define SRP_RSP_SENSE_DATA_LEN	18
 
-static int send_rsp(struct iu_entry *iue, struct scsi_cmnd *sc,
+static int send_rsp(struct iu_entry *iue, struct scst_cmd *sc,
 		    unsigned char status, unsigned char asc)
 {
 	union viosrp_iu *iu = vio_iu(iue);
@@ -165,9 +192,15 @@ static int send_rsp(struct iu_entry *iue
 		uint8_t *sense = iu->srp.rsp.data;
 
 		if (sc) {
+			uint8_t *sc_sense;
+			int sense_data_len;
+
+			sc_sense = scst_cmd_get_sense_buffer(sc);
+			sense_data_len = min(scst_cmd_get_sense_buffer_len(sc),
+					     SRP_RSP_SENSE_DATA_LEN);
 			iu->srp.rsp.flags |= SRP_RSP_FLAG_SNSVALID;
-			iu->srp.rsp.sense_data_len = SCSI_SENSE_BUFFERSIZE;
-			memcpy(sense, sc->sense_buffer, SCSI_SENSE_BUFFERSIZE);
+			iu->srp.rsp.sense_data_len = sense_data_len;
+			memcpy(sense, sc_sense, sense_data_len);
 		} else {
 			iu->srp.rsp.status = SAM_STAT_CHECK_CONDITION;
 			iu->srp.rsp.flags |= SRP_RSP_FLAG_SNSVALID;
@@ -192,8 +225,8 @@ static int send_rsp(struct iu_entry *iue
 
 static void handle_cmd_queue(struct srp_target *target)
 {
-	struct Scsi_Host *shost = target->shost;
-	struct srp_rport *rport = target_to_port(target)->rport;
+	struct vio_port *vport = target_to_port(target);
+	struct scst_session *sess = vport->sess;
 	struct iu_entry *iue;
 	struct srp_cmd *cmd;
 	unsigned long flags;
@@ -206,8 +239,7 @@ retry:
 		if (!test_and_set_bit(V_FLYING, &iue->flags)) {
 			spin_unlock_irqrestore(&target->lock, flags);
 			cmd = iue->sbuf->buf;
-			err = srp_cmd_queue(shost, cmd, iue,
-					    (unsigned long)rport, 0);
+			err = srp_cmd_queue(sess, cmd, iue);
 			if (err) {
 				eprintk("cannot queue cmd %p %d\n", cmd, err);
 				srp_iu_put(iue);
@@ -219,11 +251,11 @@ retry:
 	spin_unlock_irqrestore(&target->lock, flags);
 }
 
-static int ibmvstgt_rdma(struct scsi_cmnd *sc, struct scatterlist *sg, int nsg,
+static int ibmvstgt_rdma(struct scst_cmd *sc, struct scatterlist *sg, int nsg,
 			 struct srp_direct_buf *md, int nmd,
 			 enum dma_data_direction dir, unsigned int rest)
 {
-	struct iu_entry *iue = (struct iu_entry *) sc->SCp.ptr;
+	struct iu_entry *iue = scst_cmd_get_tgt_priv(sc);
 	struct srp_target *target = iue->target;
 	struct vio_port *vport = target_to_port(target);
 	dma_addr_t token;
@@ -282,42 +314,157 @@ static int ibmvstgt_rdma(struct scsi_cmn
 	return 0;
 }
 
-static int ibmvstgt_cmd_done(struct scsi_cmnd *sc,
-			     void (*done)(struct scsi_cmnd *))
+/**
+ * ibmvstgt_enable_target() - Allows to enable a target via sysfs.
+ */
+static int ibmvstgt_enable_target(struct scst_tgt *scst_tgt, bool enable)
 {
+	struct srp_target *target = scst_tgt_get_tgt_priv(scst_tgt);
+	struct vio_port *vport = target_to_port(target);
 	unsigned long flags;
-	struct iu_entry *iue = (struct iu_entry *) sc->SCp.ptr;
-	struct srp_target *target = iue->target;
-	int err = 0;
 
-	dprintk("%p %p %x %u\n", iue, target, vio_iu(iue)->srp.cmd.cdb[0],
-		scsi_sg_count(sc));
+	TRACE_DBG("%s target %d", enable ? "Enabling" : "Disabling",
+		  vport->dma_dev->unit_address);
+
+	spin_lock_irqsave(&target->lock, flags);
+	vport->enabled = enable;
+	spin_unlock_irqrestore(&target->lock, flags);
+
+	return 0;
+}
 
-	if (scsi_sg_count(sc))
-		err = srp_transfer_data(sc, &vio_iu(iue)->srp.cmd, ibmvstgt_rdma, 1, 1);
+/**
+ * ibmvstgt_is_target_enabled() - Allows to query a targets status via sysfs.
+ */
+static bool ibmvstgt_is_target_enabled(struct scst_tgt *scst_tgt)
+{
+	struct srp_target *target = scst_tgt_get_tgt_priv(scst_tgt);
+	struct vio_port *vport = target_to_port(target);
+	unsigned long flags;
+	bool res;
 
 	spin_lock_irqsave(&target->lock, flags);
-	list_del(&iue->ilist);
+	res = vport->enabled;
 	spin_unlock_irqrestore(&target->lock, flags);
+	return res;
+}
 
-	if (err|| sc->result != SAM_STAT_GOOD) {
-		eprintk("operation failed %p %d %x\n",
-			iue, sc->result, vio_iu(iue)->srp.cmd.cdb[0]);
-		send_rsp(iue, sc, HARDWARE_ERROR, 0x00);
-	} else
-		send_rsp(iue, sc, NO_SENSE, 0x00);
+/**
+ * ibmvstgt_detect() - Returns the number of target adapters.
+ *
+ * Callback function called by the SCST core.
+ */
+static int ibmvstgt_detect(struct scst_tgt_template *tp)
+{
+	return atomic_read(&ibmvstgt_device_count);
+}
+
+/**
+ * ibmvstgt_release() - Free the resources associated with an SCST target.
+ *
+ * Callback function called by the SCST core from scst_unregister_target().
+ */
+static int ibmvstgt_release(struct scst_tgt *scst_tgt)
+{
+	unsigned long flags;
+	struct srp_target *target = scst_tgt_get_tgt_priv(scst_tgt);
+	struct vio_port *vport = target_to_port(target);
+	struct scst_session *sess = vport->sess;
+
+	spin_lock_irqsave(&target->lock, flags);
+	vport->releasing = true;
+	spin_unlock_irqrestore(&target->lock, flags);
+
+	scst_unregister_session(sess, 0, NULL);
 
-	done(sc);
-	srp_iu_put(iue);
 	return 0;
 }
 
-int send_adapter_info(struct iu_entry *iue,
+/**
+ * ibmvstgt_xmit_response() - Transmits the response to a SCSI command.
+ *
+ * Callback function called by the SCST core. Must not block. Must ensure that
+ * scst_tgt_cmd_done() will get invoked when returning SCST_TGT_RES_SUCCESS.
+ */
+static int ibmvstgt_xmit_response(struct scst_cmd *sc)
+{
+	struct iu_entry *iue = scst_cmd_get_tgt_priv(sc);
+	int ret;
+	enum dma_data_direction dir;
+
+	if (unlikely(scst_cmd_aborted(sc))) {
+		scst_set_delivery_status(sc, SCST_CMD_DELIVERY_ABORTED);
+		goto out;
+	}
+
+	dir = srp_cmd_direction(&vio_iu(iue)->srp.cmd);
+	WARN_ON(dir != DMA_FROM_DEVICE && dir != DMA_TO_DEVICE);
+
+	/* For read commands, transfer the data to the initiator. */
+	if (dir == DMA_FROM_DEVICE && scst_cmd_get_adjusted_resp_data_len(sc)) {
+		ret = srp_transfer_data(sc, &vio_iu(iue)->srp.cmd,
+					ibmvstgt_rdma, 1, 1);
+		if (ret)
+			scst_set_delivery_status(sc, SCST_CMD_DELIVERY_FAILED);
+	}
+
+	send_rsp(iue, sc, scst_cmd_get_status(sc), 0);
+
+out:
+	scst_tgt_cmd_done(sc, SCST_CONTEXT_SAME);
+
+	return SCST_TGT_RES_SUCCESS;
+}
+
+/**
+ * ibmvstgt_rdy_to_xfer() - Transfers data from initiator to target.
+ *
+ * Called by the SCST core to transfer data from the initiator to the target
+ * (SCST_DATA_WRITE / DMA_TO_DEVICE). Must not block.
+ */
+static int ibmvstgt_rdy_to_xfer(struct scst_cmd *sc)
+{
+	struct iu_entry *iue = scst_cmd_get_tgt_priv(sc);
+	int ret = SCST_TGT_RES_SUCCESS;
+
+	WARN_ON(srp_cmd_direction(&vio_iu(iue)->srp.cmd) != DMA_TO_DEVICE);
+
+	/* Transfer the data from the initiator to the target. */
+	ret = srp_transfer_data(sc, &vio_iu(iue)->srp.cmd, ibmvstgt_rdma, 1, 1);
+	if (ret == 0) {
+		scst_rx_data(sc, SCST_RX_STATUS_SUCCESS, SCST_CONTEXT_SAME);
+	} else {
+		PRINT_ERROR("%s: tag= %llu xfer_data failed", __func__,
+			(long long unsigned)be64_to_cpu(scst_cmd_get_tag(sc)));
+		scst_rx_data(sc, SCST_RX_STATUS_ERROR, SCST_CONTEXT_SAME);
+	}
+
+	return SCST_TGT_RES_SUCCESS;
+}
+
+/**
+ * ibmvstgt_on_free_cmd() - Free command-private data.
+ *
+ * Called by the SCST core. May be called in IRQ context.
+ */
+static void ibmvstgt_on_free_cmd(struct scst_cmd *sc)
+{
+	unsigned long flags;
+	struct iu_entry *iue = scst_cmd_get_tgt_priv(sc);
+	struct srp_target *target = iue->target;
+
+	spin_lock_irqsave(&target->lock, flags);
+	list_del(&iue->ilist);
+	spin_unlock_irqrestore(&target->lock, flags);
+
+	srp_iu_put(iue);
+}
+
+static int send_adapter_info(struct iu_entry *iue,
 		      dma_addr_t remote_buffer, uint16_t length)
 {
 	struct srp_target *target = iue->target;
 	struct vio_port *vport = target_to_port(target);
-	struct Scsi_Host *shost = target->shost;
 	dma_addr_t data_token;
 	struct mad_adapter_info_data *info;
 	int err;
@@ -345,7 +499,7 @@ int send_adapter_info(struct iu_entry *i
 	info->partition_number = partition_number;
 	info->mad_version = 1;
 	info->os_type = 2;
-	info->port_max_txu[0] = shost->hostt->max_sectors << 9;
+	info->port_max_txu[0] = DEFAULT_MAX_SECTORS << 9;
 
 	/* Send our info to remote */
 	err = h_copy_rdma(sizeof(*info), vport->liobn, data_token,
@@ -365,31 +519,61 @@ static void process_login(struct iu_entr
 {
 	union viosrp_iu *iu = vio_iu(iue);
 	struct srp_login_rsp *rsp = &iu->srp.login_rsp;
+	struct srp_login_rej *rej = &iu->srp.login_rej;
 	uint64_t tag = iu->srp.rsp.tag;
-	struct Scsi_Host *shost = iue->target->shost;
-	struct srp_target *target = host_to_srp_target(shost);
+	struct scst_session *sess;
+	struct srp_target *target = iue->target;
 	struct vio_port *vport = target_to_port(target);
-	struct srp_rport_identifiers ids;
+	char name[16];
+
+	BUG_ON(vport->sess);
+
+	memset(iu, 0, max(sizeof *rsp, sizeof *rej));
 
-	memset(&ids, 0, sizeof(ids));
-	sprintf(ids.port_id, "%x", vport->dma_dev->unit_address);
-	ids.roles = SRP_RPORT_ROLE_INITIATOR;
-	if (!vport->rport)
-		vport->rport = srp_rport_add(shost, &ids);
+	snprintf(name, sizeof(name), "%x", vport->dma_dev->unit_address);
+
+	if (!ibmvstgt_is_target_enabled(target->tgt)) {
+		rej->reason =
+		  __constant_cpu_to_be32(SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
+		PRINT_ERROR("rejected SRP_LOGIN_REQ because the target %s"
+			    " has not yet been enabled", name);
+		goto reject;
+	}
+
+	BUG_ON(!target);
+	sess = scst_register_session(target->tgt, 0, name, target, NULL, NULL);
+	if (!sess) {
+		rej->reason =
+		  __constant_cpu_to_be32(SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
+		TRACE_DBG("%s", "Failed to create SCST session");
+		goto reject;
+	}
+
+	vport->sess = sess;
 
 	/* TODO handle case that requested size is wrong and
 	 * buffer format is wrong
 	 */
-	memset(iu, 0, sizeof(struct srp_login_rsp));
 	rsp->opcode = SRP_LOGIN_RSP;
 	rsp->req_lim_delta = INITIAL_SRP_LIMIT;
 	rsp->tag = tag;
 	rsp->max_it_iu_len = sizeof(union srp_iu);
 	rsp->max_ti_iu_len = sizeof(union srp_iu);
 	/* direct and indirect */
-	rsp->buf_fmt = SRP_BUF_FORMAT_DIRECT | SRP_BUF_FORMAT_INDIRECT;
+	rsp->buf_fmt = __constant_cpu_to_be16(SRP_BUF_FORMAT_DIRECT
+					      | SRP_BUF_FORMAT_INDIRECT);
 
 	send_iu(iue, sizeof(*rsp), VIOSRP_SRP_FORMAT);
+
+	return;
+
+reject:
+	rej->opcode = SRP_LOGIN_REJ;
+	rej->tag = tag;
+	rej->buf_fmt = __constant_cpu_to_be16(SRP_BUF_FORMAT_DIRECT
+					      | SRP_BUF_FORMAT_INDIRECT);
+
+	send_iu(iue, sizeof *rsp, VIOSRP_SRP_FORMAT);
 }
 
 static inline void queue_cmd(struct iu_entry *iue)
@@ -402,43 +586,134 @@ static inline void queue_cmd(struct iu_e
 	spin_unlock_irqrestore(&target->lock, flags);
 }
 
+/**
+ * struct mgmt_ctx - management command context information.
+ * @iue:  VIO SRP information unit associated with the management command.
+ * @sess: SCST session via which the management command has been received.
+ * @tag:  SCSI tag of the management command.
+ */
+struct mgmt_ctx {
+	struct iu_entry *iue;
+	struct scst_session *sess;
+};
+
 static int process_tsk_mgmt(struct iu_entry *iue)
 {
 	union viosrp_iu *iu = vio_iu(iue);
-	int fn;
+	struct srp_target *target = iue->target;
+	struct vio_port *vport = target_to_port(target);
+	struct scst_session *sess = vport->sess;
+	struct srp_tsk_mgmt *srp_tsk;
+	struct mgmt_ctx *mgmt_ctx;
+	int ret = 0;
+
+	srp_tsk = &iu->srp.tsk_mgmt;
+
+	dprintk("%p %u\n", iue, srp_tsk->tsk_mgmt_func);
+
+	ret = SCST_MGMT_STATUS_FAILED;
+	mgmt_ctx = kmalloc(sizeof *mgmt_ctx, GFP_ATOMIC);
+	if (!mgmt_ctx)
+		goto err;
 
-	dprintk("%p %u\n", iue, iu->srp.tsk_mgmt.tsk_mgmt_func);
+	mgmt_ctx->iue = iue;
+	mgmt_ctx->sess = sess;
+	iu->srp.rsp.tag = srp_tsk->tag;
 
-	switch (iu->srp.tsk_mgmt.tsk_mgmt_func) {
+	switch (srp_tsk->tsk_mgmt_func) {
 	case SRP_TSK_ABORT_TASK:
-		fn = ABORT_TASK;
+		ret = scst_rx_mgmt_fn_tag(sess, SCST_ABORT_TASK,
+					  srp_tsk->task_tag,
+					  SCST_ATOMIC, mgmt_ctx);
 		break;
 	case SRP_TSK_ABORT_TASK_SET:
-		fn = ABORT_TASK_SET;
+		ret = scst_rx_mgmt_fn_lun(sess, SCST_ABORT_TASK_SET,
+					  (u8 *) &srp_tsk->lun,
+					  sizeof srp_tsk->lun,
+					  SCST_ATOMIC, mgmt_ctx);
 		break;
 	case SRP_TSK_CLEAR_TASK_SET:
-		fn = CLEAR_TASK_SET;
+		ret = scst_rx_mgmt_fn_lun(sess, SCST_CLEAR_TASK_SET,
+					  (u8 *) &srp_tsk->lun,
+					  sizeof srp_tsk->lun,
+					  SCST_ATOMIC, mgmt_ctx);
 		break;
 	case SRP_TSK_LUN_RESET:
-		fn = LOGICAL_UNIT_RESET;
+		ret = scst_rx_mgmt_fn_lun(sess, SCST_LUN_RESET,
+					  (u8 *) &srp_tsk->lun,
+					  sizeof srp_tsk->lun,
+					  SCST_ATOMIC, mgmt_ctx);
 		break;
 	case SRP_TSK_CLEAR_ACA:
-		fn = CLEAR_ACA;
+		ret = scst_rx_mgmt_fn_lun(sess, SCST_CLEAR_ACA,
+					  (u8 *) &srp_tsk->lun,
+					  sizeof srp_tsk->lun,
+					  SCST_ATOMIC, mgmt_ctx);
 		break;
 	default:
-		fn = 0;
+		ret = SCST_MGMT_STATUS_FN_NOT_SUPPORTED;
 	}
-	if (fn)
-		scsi_tgt_tsk_mgmt_request(iue->target->shost,
-					  (unsigned long)iue->target->shost,
-					  fn,
-					  iu->srp.tsk_mgmt.task_tag,
-					  (struct scsi_lun *) &iu->srp.tsk_mgmt.lun,
-					  iue);
-	else
-		send_rsp(iue, NULL, ILLEGAL_REQUEST, 0x20);
 
-	return !fn;
+	if (ret != SCST_MGMT_STATUS_SUCCESS)
+		goto err;
+	return ret;
+
+err:
+	kfree(mgmt_ctx);
+	return ret;
+}
+
+enum {
+	/* See also table 24 in the T10 r16a document. */
+	SRP_TSK_MGMT_SUCCESS = 0x00,
+	SRP_TSK_MGMT_FUNC_NOT_SUPP = 0x04,
+	SRP_TSK_MGMT_FAILED = 0x05,
+};
+
+static u8 scst_to_srp_tsk_mgmt_status(const int scst_mgmt_status)
+{
+	switch (scst_mgmt_status) {
+	case SCST_MGMT_STATUS_SUCCESS:
+		return SRP_TSK_MGMT_SUCCESS;
+	case SCST_MGMT_STATUS_FN_NOT_SUPPORTED:
+		return SRP_TSK_MGMT_FUNC_NOT_SUPP;
+	case SCST_MGMT_STATUS_TASK_NOT_EXIST:
+	case SCST_MGMT_STATUS_LUN_NOT_EXIST:
+	case SCST_MGMT_STATUS_REJECTED:
+	case SCST_MGMT_STATUS_FAILED:
+	default:
+		break;
+	}
+	return SRP_TSK_MGMT_FAILED;
+}
+
+static void ibmvstgt_tsk_mgmt_done(struct scst_mgmt_cmd *mcmnd)
+{
+	struct mgmt_ctx *mgmt_ctx;
+	struct scst_session *sess;
+	struct iu_entry *iue;
+	union viosrp_iu *iu;
+
+	mgmt_ctx = scst_mgmt_cmd_get_tgt_priv(mcmnd);
+	BUG_ON(!mgmt_ctx);
+
+	sess = mgmt_ctx->sess;
+	BUG_ON(!sess);
+
+	iue = mgmt_ctx->iue;
+	BUG_ON(!iue);
+
+	iu = vio_iu(iue);
+
+	TRACE_DBG("%s: tag %lld status %d",
+		  __func__, (long long unsigned)be64_to_cpu(iu->srp.rsp.tag),
+		  scst_mgmt_cmd_get_status(mcmnd));
+
+	send_rsp(iue, NULL,
+		 scst_to_srp_tsk_mgmt_status(scst_mgmt_cmd_get_status(mcmnd)),
+		 0/*asc*/);
+
+	kfree(mgmt_ctx);
 }
 
 static int process_mad_iu(struct iu_entry *iue)
@@ -476,16 +751,26 @@ static int process_mad_iu(struct iu_entr
 
 static int process_srp_iu(struct iu_entry *iue)
 {
+	unsigned long flags;
 	union viosrp_iu *iu = vio_iu(iue);
+	struct srp_target *target = iue->target;
+	struct vio_port *vport = target_to_port(target);
 	int done = 1;
 	u8 opcode = iu->srp.rsp.opcode;
 
+	spin_lock_irqsave(&target->lock, flags);
+	if (vport->releasing) {
+		spin_unlock_irqrestore(&target->lock, flags);
+		return done;
+	}
+	spin_unlock_irqrestore(&target->lock, flags);
+
 	switch (opcode) {
 	case SRP_LOGIN_REQ:
 		process_login(iue);
 		break;
 	case SRP_TSK_MGMT:
-		done = process_tsk_mgmt(iue);
+		done = process_tsk_mgmt(iue) != SCST_MGMT_STATUS_SUCCESS;
 		break;
 	case SRP_CMD:
 		queue_cmd(iue);
@@ -722,65 +1007,6 @@ static void handle_crq(struct work_struc
 	handle_cmd_queue(target);
 }
 
-
-static int ibmvstgt_eh_abort_handler(struct scsi_cmnd *sc)
-{
-	unsigned long flags;
-	struct iu_entry *iue = (struct iu_entry *) sc->SCp.ptr;
-	struct srp_target *target = iue->target;
-
-	dprintk("%p %p %x\n", iue, target, vio_iu(iue)->srp.cmd.cdb[0]);
-
-	spin_lock_irqsave(&target->lock, flags);
-	list_del(&iue->ilist);
-	spin_unlock_irqrestore(&target->lock, flags);
-
-	srp_iu_put(iue);
-
-	return 0;
-}
-
-static int ibmvstgt_tsk_mgmt_response(struct Scsi_Host *shost,
-				      u64 itn_id, u64 mid, int result)
-{
-	struct iu_entry *iue = (struct iu_entry *) ((void *) mid);
-	union viosrp_iu *iu = vio_iu(iue);
-	unsigned char status, asc;
-
-	eprintk("%p %d\n", iue, result);
-	status = NO_SENSE;
-	asc = 0;
-
-	switch (iu->srp.tsk_mgmt.tsk_mgmt_func) {
-	case SRP_TSK_ABORT_TASK:
-		asc = 0x14;
-		if (result)
-			status = ABORTED_COMMAND;
-		break;
-	default:
-		break;
-	}
-
-	send_rsp(iue, NULL, status, asc);
-	srp_iu_put(iue);
-
-	return 0;
-}
-
-static int ibmvstgt_it_nexus_response(struct Scsi_Host *shost, u64 itn_id,
-				      int result)
-{
-	struct srp_target *target = host_to_srp_target(shost);
-	struct vio_port *vport = target_to_port(target);
-
-	if (result) {
-		eprintk("%p %d\n", shost, result);
-		srp_rport_del(vport->rport);
-		vport->rport = NULL;
-	}
-	return 0;
-}
-
 static ssize_t system_id_show(struct device *dev,
 			      struct device_attribute *attr, char *buf)
 {
@@ -796,40 +1022,51 @@ static ssize_t partition_number_show(str
 static ssize_t unit_address_show(struct device *dev,
 				  struct device_attribute *attr, char *buf)
 {
-	struct Scsi_Host *shost = class_to_shost(dev);
-	struct srp_target *target = host_to_srp_target(shost);
-	struct vio_port *vport = target_to_port(target);
+	struct vio_port *vport = container_of(dev, struct vio_port, dev);
 	return snprintf(buf, PAGE_SIZE, "%x\n", vport->dma_dev->unit_address);
 }
 
-static DEVICE_ATTR(system_id, S_IRUGO, system_id_show, NULL);
-static DEVICE_ATTR(partition_number, S_IRUGO, partition_number_show, NULL);
-static DEVICE_ATTR(unit_address, S_IRUGO, unit_address_show, NULL);
-
-static struct device_attribute *ibmvstgt_attrs[] = {
-	&dev_attr_system_id,
-	&dev_attr_partition_number,
-	&dev_attr_unit_address,
-	NULL,
+static struct class_attribute ibmvstgt_class_attrs[] = {
+	__ATTR_NULL,
+};
+
+static struct device_attribute ibmvstgt_attrs[] = {
+	__ATTR(system_id, S_IRUGO, system_id_show, NULL),
+	__ATTR(partition_number, S_IRUGO, partition_number_show, NULL),
+	__ATTR(unit_address, S_IRUGO, unit_address_show, NULL),
+	__ATTR_NULL,
+};
+
+static void ibmvstgt_dev_release(struct device *dev)
+{ }
+
+static struct class ibmvstgt_class = {
+	.name		= "ibmvstgt",
+	.dev_release	= ibmvstgt_dev_release,
+	.class_attrs	= ibmvstgt_class_attrs,
+	.dev_attrs	= ibmvstgt_attrs,
 };
 
-static struct scsi_host_template ibmvstgt_sht = {
+static struct scst_tgt_template ibmvstgt_template = {
 	.name			= TGT_NAME,
-	.module			= THIS_MODULE,
-	.can_queue		= INITIAL_SRP_LIMIT,
-	.sg_tablesize		= SG_ALL,
-	.use_clustering		= DISABLE_CLUSTERING,
-	.max_sectors		= DEFAULT_MAX_SECTORS,
-	.transfer_response	= ibmvstgt_cmd_done,
-	.eh_abort_handler	= ibmvstgt_eh_abort_handler,
-	.shost_attrs		= ibmvstgt_attrs,
-	.proc_name		= TGT_NAME,
-	.supported_mode		= MODE_TARGET,
+	.sg_tablesize		= SCSI_MAX_SG_SEGMENTS,
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+	.default_trace_flags	= DEFAULT_IBMVSTGT_TRACE_FLAGS,
+	.trace_flags		= &trace_flag,
+#endif
+	.enable_target		= ibmvstgt_enable_target,
+	.is_target_enabled	= ibmvstgt_is_target_enabled,
+	.detect			= ibmvstgt_detect,
+	.release		= ibmvstgt_release,
+	.xmit_response		= ibmvstgt_xmit_response,
+	.rdy_to_xfer		= ibmvstgt_rdy_to_xfer,
+	.on_free_cmd		= ibmvstgt_on_free_cmd,
+	.task_mgmt_fn_done	= ibmvstgt_tsk_mgmt_done,
 };
 
 static int ibmvstgt_probe(struct vio_dev *dev, const struct vio_device_id *id)
 {
-	struct Scsi_Host *shost;
+	struct scst_tgt *scst_tgt;
 	struct srp_target *target;
 	struct vio_port *vport;
 	unsigned int *dma, dma_size;
@@ -838,20 +1077,24 @@ static int ibmvstgt_probe(struct vio_dev
 	vport = kzalloc(sizeof(struct vio_port), GFP_KERNEL);
 	if (!vport)
 		return err;
-	shost = scsi_host_alloc(&ibmvstgt_sht, sizeof(struct srp_target));
-	if (!shost)
+
+	target = kzalloc(sizeof(struct srp_target), GFP_KERNEL);
+	if (!target)
 		goto free_vport;
-	shost->transportt = ibmvstgt_transport_template;
 
-	target = host_to_srp_target(shost);
-	target->shost = shost;
+	scst_tgt = scst_register_target(&ibmvstgt_template, NULL);
+	if (!scst_tgt)
+		goto free_target;
+
+	scst_tgt_set_tgt_priv(scst_tgt, target);
+	target->tgt = scst_tgt;
 	vport->dma_dev = dev;
 	target->ldata = vport;
 	vport->target = target;
 	err = srp_target_alloc(target, &dev->dev, INITIAL_SRP_LIMIT,
 			       SRP_MAX_IU_LEN);
 	if (err)
-		goto put_host;
+		goto unregister_target;
 
 	dma = (unsigned int *) vio_get_attribute(dev, "ibm,my-dma-window",
 						 &dma_size);
@@ -865,27 +1108,29 @@ static int ibmvstgt_probe(struct vio_dev
 
 	INIT_WORK(&vport->crq_work, handle_crq);
 
-	err = scsi_add_host(shost, target->dev);
+	err = crq_queue_create(&vport->crq_queue, target);
 	if (err)
 		goto free_srp_target;
 
-	err = scsi_tgt_alloc_queue(shost);
-	if (err)
-		goto remove_host;
+	vport->dev.class = &ibmvstgt_class;
+	vport->dev.parent = &dev->dev;
+	dev_set_name(&vport->dev, "ibmvstgt-%d",
+		     vport->dma_dev->unit_address);
+	if (device_register(&vport->dev))
+		goto destroy_crq_queue;
 
-	err = crq_queue_create(&vport->crq_queue, target);
-	if (err)
-		goto free_queue;
+	atomic_inc(&ibmvstgt_device_count);
 
 	return 0;
-free_queue:
-	scsi_tgt_free_queue(shost);
-remove_host:
-	scsi_remove_host(shost);
+
+destroy_crq_queue:
+	crq_queue_destroy(target);
 free_srp_target:
 	srp_target_free(target);
-put_host:
-	scsi_host_put(shost);
+unregister_target:
+	scst_unregister_target(scst_tgt);
+free_target:
+	kfree(target);
 free_vport:
 	kfree(vport);
 	return err;
@@ -894,16 +1139,15 @@ free_vport:
 static int ibmvstgt_remove(struct vio_dev *dev)
 {
 	struct srp_target *target = dev_get_drvdata(&dev->dev);
-	struct Scsi_Host *shost = target->shost;
 	struct vio_port *vport = target->ldata;
 
+	atomic_dec(&ibmvstgt_device_count);
+
 	crq_queue_destroy(target);
-	srp_remove_host(shost);
-	scsi_remove_host(shost);
-	scsi_tgt_free_queue(shost);
 	srp_target_free(target);
+	scst_unregister_target(target->tgt);
+	kfree(target);
 	kfree(vport);
-	scsi_host_put(shost);
 	return 0;
 }
 
@@ -915,9 +1159,9 @@ static struct vio_device_id ibmvstgt_dev
 MODULE_DEVICE_TABLE(vio, ibmvstgt_device_table);
 
 static struct vio_driver ibmvstgt_driver = {
-	.id_table = ibmvstgt_device_table,
-	.probe = ibmvstgt_probe,
-	.remove = ibmvstgt_remove,
+	.id_table	= ibmvstgt_device_table,
+	.probe		= ibmvstgt_probe,
+	.remove		= ibmvstgt_remove,
 	.driver = {
 		.name = "ibmvscsis",
 		.owner = THIS_MODULE,
@@ -951,25 +1195,31 @@ static int get_system_info(void)
 	return 0;
 }
 
-static struct srp_function_template ibmvstgt_transport_functions = {
-	.tsk_mgmt_response = ibmvstgt_tsk_mgmt_response,
-	.it_nexus_response = ibmvstgt_it_nexus_response,
-};
-
+/**
+ * ibmvstgt_init() - Kernel module initialization.
+ *
+ * Note: Since vio_register_driver() registers callback functions, and since
+ * at least one of these callback functions (ibmvstgt_probe()) calls SCST
+ * functions, the SCST target template must be registered before
+ * vio_register_driver() is called.
+ */
 static int ibmvstgt_init(void)
 {
 	int err = -ENOMEM;
 
 	printk("IBM eServer i/pSeries Virtual SCSI Target Driver\n");
 
-	ibmvstgt_transport_template =
-		srp_attach_transport(&ibmvstgt_transport_functions);
-	if (!ibmvstgt_transport_template)
-		return err;
+	err = class_register(&ibmvstgt_class);
+	if (err)
+		goto out;
+
+	err = scst_register_target_template(&ibmvstgt_template);
+	if (err)
+		goto unregister_class;
 
 	vtgtd = create_workqueue("ibmvtgtd");
 	if (!vtgtd)
-		goto release_transport;
+		goto unregister_tgt;
 
 	err = get_system_info();
 	if (err)
@@ -980,10 +1230,14 @@ static int ibmvstgt_init(void)
 		goto destroy_wq;
 
 	return 0;
+
 destroy_wq:
 	destroy_workqueue(vtgtd);
-release_transport:
-	srp_release_transport(ibmvstgt_transport_template);
+unregister_tgt:
+	scst_unregister_target_template(&ibmvstgt_template);
+unregister_class:
+	class_unregister(&ibmvstgt_class);
+out:
 	return err;
 }
 
@@ -991,9 +1245,10 @@ static void ibmvstgt_exit(void)
 {
 	printk("Unregister IBM virtual SCSI driver\n");
 
-	destroy_workqueue(vtgtd);
 	vio_unregister_driver(&ibmvstgt_driver);
-	srp_release_transport(ibmvstgt_transport_template);
+	destroy_workqueue(vtgtd);
+	scst_unregister_target_template(&ibmvstgt_template);
+	class_unregister(&ibmvstgt_class);
 }
 
 MODULE_DESCRIPTION("IBM Virtual SCSI Target");
--- orig/linux-2.6.35/drivers/scsi/libsrp.c 16:47:55.220115813 +0400
+++ linux-2.6.35/drivers/scsi/libsrp.c 22:43:50.105800350 +0400
@@ -2,6 +2,7 @@
  * SCSI RDMA Protocol lib functions
  *
  * Copyright (C) 2006 FUJITA Tomonori <tomof@acm.org>
+ * Copyright (C) 2010 Bart Van Assche <bvanassche@acm.org>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
@@ -23,12 +24,8 @@
 #include <linux/kfifo.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_tcq.h>
-#include <scsi/scsi_tgt.h>
 #include <scsi/srp.h>
 #include <scsi/libsrp.h>
 
 enum srp_task_attributes {
 	SRP_SIMPLE_TASK = 0,
@@ -185,28 +186,34 @@ void srp_iu_put(struct iu_entry *iue)
 }
 EXPORT_SYMBOL_GPL(srp_iu_put);
 
-static int srp_direct_data(struct scsi_cmnd *sc, struct srp_direct_buf *md,
+static int srp_direct_data(struct scst_cmd *sc, struct srp_direct_buf *md,
 			   enum dma_data_direction dir, srp_rdma_t rdma_io,
 			   int dma_map, int ext_desc)
 {
 	struct iu_entry *iue = NULL;
 	struct scatterlist *sg = NULL;
-	int err, nsg = 0, len;
+	int err, nsg = 0, len, sg_cnt;
 
 	if (dma_map) {
-		iue = (struct iu_entry *) sc->SCp.ptr;
-		sg = scsi_sglist(sc);
+		iue = scst_cmd_get_tgt_priv(sc);
+		if (dir == DMA_TO_DEVICE) {
+			scst_cmd_get_write_fields(sc, &sg, &sg_cnt);
+		} else {
+			sg = scst_cmd_get_sg(sc);
+			sg_cnt = scst_cmd_get_sg_cnt(sc);
+		}
 
 		dprintk("%p %u %u %d\n", iue, scsi_bufflen(sc),
-			md->len, scsi_sg_count(sc));
+			md->len, sg_cnt);
 
-		nsg = dma_map_sg(iue->target->dev, sg, scsi_sg_count(sc),
+		nsg = dma_map_sg(iue->target->dev, sg, sg_cnt,
 				 DMA_BIDIRECTIONAL);
 		if (!nsg) {
-			printk("fail to map %p %d\n", iue, scsi_sg_count(sc));
+			printk(KERN_ERR "fail to map %p %d\n", iue, sg_cnt);
 			return 0;
 		}
-		len = min(scsi_bufflen(sc), md->len);
+		len = min_t(unsigned, scst_cmd_get_expected_transfer_len(sc),
+			    md->len);
 	} else
 		len = md->len;
 
@@ -218,7 +225,7 @@ static int srp_direct_data(struct scsi_c
 	return err;
 }
 
-static int srp_indirect_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
+static int srp_indirect_data(struct scst_cmd *sc, struct srp_cmd *cmd,
 			     struct srp_indirect_buf *id,
 			     enum dma_data_direction dir, srp_rdma_t rdma_io,
 			     int dma_map, int ext_desc)
@@ -228,11 +235,16 @@ static int srp_indirect_data(struct scsi
 	struct scatterlist dummy, *sg = NULL;
 	dma_addr_t token = 0;
 	int err = 0;
-	int nmd, nsg = 0, len;
+	int nmd, nsg = 0, len, sg_cnt;
 
 	if (dma_map || ext_desc) {
-		iue = (struct iu_entry *) sc->SCp.ptr;
-		sg = scsi_sglist(sc);
+		iue = scst_cmd_get_tgt_priv(sc);
+		if (dir == DMA_TO_DEVICE) {
+			scst_cmd_get_write_fields(sc, &sg, &sg_cnt);
+		} else {
+			sg = scst_cmd_get_sg(sc);
+			sg_cnt = scst_cmd_get_sg_cnt(sc);
+		}
 
 		dprintk("%p %u %u %d %d\n",
 			iue, scsi_bufflen(sc), id->len,
@@ -271,14 +283,15 @@ static int srp_indirect_data(struct scsi
 
 rdma:
 	if (dma_map) {
-		nsg = dma_map_sg(iue->target->dev, sg, scsi_sg_count(sc),
+		nsg = dma_map_sg(iue->target->dev, sg, sg_cnt,
 				 DMA_BIDIRECTIONAL);
 		if (!nsg) {
-			eprintk("fail to map %p %d\n", iue, scsi_sg_count(sc));
+			eprintk("fail to map %p %d\n", iue, sg_cnt);
 			err = -EIO;
 			goto free_mem;
 		}
-		len = min(scsi_bufflen(sc), id->len);
+		len = min_t(unsigned, scst_cmd_get_expected_transfer_len(sc),
+			    id->len);
 	} else
 		len = id->len;
 
@@ -320,7 +333,7 @@ static int data_out_desc_size(struct srp
  * TODO: this can be called multiple times for a single command if it
  * has very long data.
  */
-int srp_transfer_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
+int srp_transfer_data(struct scst_cmd *sc, struct srp_cmd *cmd,
 		      srp_rdma_t rdma_io, int dma_map, int ext_desc)
 {
 	struct srp_direct_buf *md;
@@ -395,26 +408,28 @@ static int vscsis_data_length(struct srp
 	return len;
 }
 
-int srp_cmd_queue(struct Scsi_Host *shost, struct srp_cmd *cmd, void *info,
-		  u64 itn_id, u64 addr)
+int srp_cmd_queue(struct scst_session *sess, struct srp_cmd *cmd, void *info)
 {
 	enum dma_data_direction dir;
-	struct scsi_cmnd *sc;
-	int tag, len, err;
+	struct scst_cmd *sc;
+	int tag, len;
 
 	switch (cmd->task_attr) {
 	case SRP_SIMPLE_TASK:
-		tag = MSG_SIMPLE_TAG;
+		tag = SCST_CMD_QUEUE_SIMPLE;
 		break;
 	case SRP_ORDERED_TASK:
-		tag = MSG_ORDERED_TAG;
+		tag = SCST_CMD_QUEUE_ORDERED;
 		break;
 	case SRP_HEAD_TASK:
-		tag = MSG_HEAD_TAG;
+		tag = SCST_CMD_QUEUE_HEAD_OF_QUEUE;
+		break;
+	case SRP_ACA_TASK:
+		tag = SCST_CMD_QUEUE_ACA;
 		break;
 	default:
 		eprintk("Task attribute %d not supported\n", cmd->task_attr);
-		tag = MSG_ORDERED_TAG;
+		tag = SCST_CMD_QUEUE_ORDERED;
 	}
 
 	dir = srp_cmd_direction(cmd);
@@ -423,21 +438,19 @@ int srp_cmd_queue(struct Scsi_Host *shos
 	dprintk("%p %x %lx %d %d %d %llx\n", info, cmd->cdb[0],
 		cmd->lun, dir, len, tag, (unsigned long long) cmd->tag);
 
-	sc = scsi_host_get_command(shost, dir, GFP_KERNEL);
+	sc = scst_rx_cmd(sess, (u8 *) &cmd->lun, sizeof(cmd->lun),
+			 cmd->cdb, sizeof(cmd->cdb), SCST_CONTEXT_THREAD);
 	if (!sc)
 		return -ENOMEM;
 
-	sc->SCp.ptr = info;
-	memcpy(sc->cmnd, cmd->cdb, MAX_COMMAND_SIZE);
-	sc->sdb.length = len;
-	sc->sdb.table.sgl = (void *) (unsigned long) addr;
-	sc->tag = tag;
-	err = scsi_tgt_queue_command(sc, itn_id, (struct scsi_lun *)&cmd->lun,
-				     cmd->tag);
-	if (err)
-		scsi_host_put_command(shost, sc);
+	scst_cmd_set_queue_type(sc, tag);
+	scst_cmd_set_tag(sc, cmd->tag);
+	scst_cmd_set_tgt_priv(sc, info);
+	scst_cmd_set_expected(sc, dir == DMA_TO_DEVICE
+			      ? SCST_DATA_WRITE : SCST_DATA_READ, len);
+	scst_cmd_init_done(sc, SCST_CONTEXT_THREAD);
 
-	return err;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(srp_cmd_queue);
 
--- orig/linux-2.6.35/include/scsi/libsrp.h 16:47:55.220115813 +0400
+++ linux-2.6.35/include/scsi/libsrp.h 16:47:55.240117096 +0400
@@ -3,8 +3,7 @@
 
 #include <linux/list.h>
 #include <linux/kfifo.h>
-#include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_host.h>
+#include <scst/scst.h>
 #include <scsi/srp.h>
 
 enum iue_flags {
@@ -27,7 +30,7 @@ struct srp_queue {
 };
 
 struct srp_target {
-	struct Scsi_Host *shost;
+	struct scst_tgt *tgt;
 	struct device *dev;
 
 	spinlock_t lock;
@@ -51,7 +54,7 @@ struct iu_entry {
 	struct srp_buf *sbuf;
 };
 
-typedef int (srp_rdma_t)(struct scsi_cmnd *, struct scatterlist *, int,
+typedef int (srp_rdma_t)(struct scst_cmd *, struct scatterlist *, int,
 			 struct srp_direct_buf *, int,
 			 enum dma_data_direction, unsigned int);
 extern int srp_target_alloc(struct srp_target *, struct device *, size_t, size_t);
@@ -60,16 +63,11 @@ extern void srp_target_free(struct srp_t
 extern struct iu_entry *srp_iu_get(struct srp_target *);
 extern void srp_iu_put(struct iu_entry *);
 
-extern int srp_cmd_queue(struct Scsi_Host *, struct srp_cmd *, void *, u64, u64);
-extern int srp_transfer_data(struct scsi_cmnd *, struct srp_cmd *,
+extern int srp_cmd_queue(struct scst_session *, struct srp_cmd *, void *);
+extern int srp_transfer_data(struct scst_cmd *, struct srp_cmd *,
 			     srp_rdma_t, int, int);
 
 
-static inline struct srp_target *host_to_srp_target(struct Scsi_Host *host)
-{
-	return (struct srp_target *) host->hostdata;
-}
-
 static inline int srp_cmd_direction(struct srp_cmd *cmd)
 {
 	return (cmd->buf_fmt >> 4) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
diff -uprN orig/linux-2.6.35/Documentation/powerpc/ibmvstgt.txt linux-2.6.35/Documentation/powerpc/ibmvstgt.txt
--- orig/linux-2.6.35/Documentation/powerpc/ibmvstgt.txt
+++ linux-2.6.35/Documentation/powerpc/ibmvstgt.txt
@@ -0,0 +1,2 @@
+Documentation about IBM System p Virtual I/O (VIO) can be found here:
+http://www.ibm.com/developerworks/wikis/display/virtualization/VIO


