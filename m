From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 3/6] be2iscsi: Low Level routines
Date: Tue, 8 Sep 2009 14:09:13 +0530
Message-ID: <20090908083902.GA19586@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:39978 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751412AbZIHIjH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2009 04:39:07 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu, sfr@canb.auug.org.au

 These files contain low level routines to send Firmware Commands
 to the chip

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_cmds.c |  527 +++++++++++++++++++++++
 drivers/scsi/be2iscsi/be_cmds.h |  877 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 1404 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/be2iscsi/be_cmds.c
 create mode 100644 drivers/scsi/be2iscsi/be_cmds.h

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
new file mode 100644
index 0000000..4b92a7b
--- /dev/null
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -0,0 +1,527 @@
+/**
+ * Copyright (C) 2005 - 2009 ServerEngines
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.  The full GNU General
+ * Public License is included in this distribution in the file called COPYING.
+ *
+ * Contact Information:
+ * linux-drivers@serverengines.com
+ *
+ * ServerEngines
+ * 209 N. Fair Oaks Ave
+ * Sunnyvale, CA 94085
+ */
+
+#include "be.h"
+#include "be_mgmt.h"
+#include "be_main.h"
+
+static inline bool be_mcc_compl_is_new(struct be_mcc_compl *compl)
+{
+	if (compl->flags != 0) {
+		compl->flags = le32_to_cpu(compl->flags);
+		WARN_ON((compl->flags & CQE_FLAGS_VALID_MASK) == 0);
+		return true;
+	} else
+		return false;
+}
+
+static inline void be_mcc_compl_use(struct be_mcc_compl *compl)
+{
+	compl->flags = 0;
+}
+
+static int be_mcc_compl_process(struct be_ctrl_info *ctrl,
+				struct be_mcc_compl *compl)
+{
+	u16 compl_status, extd_status;
+
+	be_dws_le_to_cpu(compl, 4);
+
+	compl_status = (compl->status >> CQE_STATUS_COMPL_SHIFT) &
+					CQE_STATUS_COMPL_MASK;
+	if (compl_status != MCC_STATUS_SUCCESS) {
+		extd_status = (compl->status >> CQE_STATUS_EXTD_SHIFT) &
+						CQE_STATUS_EXTD_MASK;
+		dev_err(&ctrl->pdev->dev,
+			"error in cmd completion: status(compl/extd)=%d/%d\n",
+			compl_status, extd_status);
+		return -1;
+	}
+	return 0;
+}
+
+static inline bool is_link_state_evt(u32 trailer)
+{
+	return (((trailer >> ASYNC_TRAILER_EVENT_CODE_SHIFT) &
+		ASYNC_TRAILER_EVENT_CODE_MASK) == ASYNC_EVENT_CODE_LINK_STATE);
+}
+
+void beiscsi_cq_notify(struct be_ctrl_info *ctrl, u16 qid, bool arm,
+							 u16 num_popped)
+{
+	u32 val = 0;
+	val |= qid & DB_CQ_RING_ID_MASK;
+	if (arm)
+		val |= 1 << DB_CQ_REARM_SHIFT;
+	val |= num_popped << DB_CQ_NUM_POPPED_SHIFT;
+	iowrite32(val, ctrl->db + DB_CQ_OFFSET);
+}
+
+static int be_mbox_db_ready_wait(struct be_ctrl_info *ctrl)
+{
+#define long_delay 2000
+	void __iomem *db = ctrl->db + MPU_MAILBOX_DB_OFFSET;
+	int cnt = 0, wait = 5;	/* in usecs */
+	u32 ready;
+
+	do {
+		ready = ioread32(db) & MPU_MAILBOX_DB_RDY_MASK;
+		if (ready)
+			break;
+
+		if (cnt > 6000000) {
+			dev_err(&ctrl->pdev->dev, "mbox_db poll timed out\n");
+			return -1;
+		}
+
+		if (cnt > 50) {
+			wait = long_delay;
+			mdelay(long_delay / 1000);
+		} else
+			udelay(wait);
+		cnt += wait;
+	} while (true);
+	return 0;
+}
+
+int be_mbox_notify(struct be_ctrl_info *ctrl)
+{
+	int status;
+	u32 val = 0;
+	void __iomem *db = ctrl->db + MPU_MAILBOX_DB_OFFSET;
+	struct be_dma_mem *mbox_mem = &ctrl->mbox_mem;
+	struct be_mcc_mailbox *mbox = mbox_mem->va;
+	struct be_mcc_compl *compl = &mbox->compl;
+
+	val &= ~MPU_MAILBOX_DB_RDY_MASK;
+	val |= MPU_MAILBOX_DB_HI_MASK;
+	val |= (upper_32_bits(mbox_mem->dma) >> 2) << 2;
+	iowrite32(val, db);
+
+	status = be_mbox_db_ready_wait(ctrl);
+	if (status != 0) {
+		SE_DEBUG(DBG_LVL_1, " be_mbox_db_ready_wait failed 1\n");
+		return status;
+	}
+	val = 0;
+	val &= ~MPU_MAILBOX_DB_RDY_MASK;
+	val &= ~MPU_MAILBOX_DB_HI_MASK;
+	val |= (u32) (mbox_mem->dma >> 4) << 2;
+	iowrite32(val, db);
+
+	status = be_mbox_db_ready_wait(ctrl);
+	if (status != 0) {
+		SE_DEBUG(DBG_LVL_1, " be_mbox_db_ready_wait failed 2\n");
+		return status;
+	}
+	if (be_mcc_compl_is_new(compl)) {
+		status = be_mcc_compl_process(ctrl, &mbox->compl);
+		be_mcc_compl_use(compl);
+		if (status) {
+			SE_DEBUG(DBG_LVL_1, "After be_mcc_compl_process \n");
+			return status;
+		}
+	} else {
+		dev_err(&ctrl->pdev->dev, "invalid mailbox completion\n");
+		return -1;
+	}
+	return 0;
+}
+
+void be_wrb_hdr_prepare(struct be_mcc_wrb *wrb, int payload_len,
+				bool embedded, u8 sge_cnt)
+{
+	if (embedded)
+		wrb->embedded |= MCC_WRB_EMBEDDED_MASK;
+	else
+		wrb->embedded |= (sge_cnt & MCC_WRB_SGE_CNT_MASK) <<
+						MCC_WRB_SGE_CNT_SHIFT;
+	wrb->payload_length = payload_len;
+	be_dws_cpu_to_le(wrb, 8);
+}
+
+void be_cmd_hdr_prepare(struct be_cmd_req_hdr *req_hdr,
+			u8 subsystem, u8 opcode, int cmd_len)
+{
+	req_hdr->opcode = opcode;
+	req_hdr->subsystem = subsystem;
+	req_hdr->request_length = cpu_to_le32(cmd_len - sizeof(*req_hdr));
+}
+
+static void be_cmd_page_addrs_prepare(struct phys_addr *pages, u32 max_pages,
+							struct be_dma_mem *mem)
+{
+	int i, buf_pages;
+	u64 dma = (u64) mem->dma;
+
+	buf_pages = min(PAGES_4K_SPANNED(mem->va, mem->size), max_pages);
+	for (i = 0; i < buf_pages; i++) {
+		pages[i].lo = cpu_to_le32(dma & 0xFFFFFFFF);
+		pages[i].hi = cpu_to_le32(upper_32_bits(dma));
+		dma += PAGE_SIZE_4K;
+	}
+}
+
+static u32 eq_delay_to_mult(u32 usec_delay)
+{
+#define MAX_INTR_RATE 651042
+	const u32 round = 10;
+	u32 multiplier;
+
+	if (usec_delay == 0)
+		multiplier = 0;
+	else {
+		u32 interrupt_rate = 1000000 / usec_delay;
+		if (interrupt_rate == 0)
+			multiplier = 1023;
+		else {
+			multiplier = (MAX_INTR_RATE - interrupt_rate) * round;
+			multiplier /= interrupt_rate;
+			multiplier = (multiplier + round / 2) / round;
+			multiplier = min(multiplier, (u32) 1023);
+		}
+	}
+	return multiplier;
+}
+
+struct be_mcc_wrb *wrb_from_mbox(struct be_dma_mem *mbox_mem)
+{
+	return &((struct be_mcc_mailbox *)(mbox_mem->va))->wrb;
+}
+
+int beiscsi_cmd_eq_create(struct be_ctrl_info *ctrl,
+		struct be_queue_info *eq, int eq_delay)
+{
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct be_cmd_req_eq_create *req = embedded_payload(wrb);
+	struct be_cmd_resp_eq_create *resp = embedded_payload(wrb);
+	struct be_dma_mem *q_mem = &eq->dma_mem;
+	int status;
+
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_COMMON,
+			OPCODE_COMMON_EQ_CREATE, sizeof(*req));
+
+	req->num_pages = cpu_to_le16(PAGES_4K_SPANNED(q_mem->va, q_mem->size));
+
+	AMAP_SET_BITS(struct amap_eq_context, func, req->context,
+						PCI_FUNC(ctrl->pdev->devfn));
+	AMAP_SET_BITS(struct amap_eq_context, valid, req->context, 1);
+	AMAP_SET_BITS(struct amap_eq_context, size, req->context, 0);
+	AMAP_SET_BITS(struct amap_eq_context, count, req->context,
+					__ilog2_u32(eq->len / 256));
+	AMAP_SET_BITS(struct amap_eq_context, delaymult, req->context,
+					eq_delay_to_mult(eq_delay));
+	be_dws_cpu_to_le(req->context, sizeof(req->context));
+
+	be_cmd_page_addrs_prepare(req->pages, ARRAY_SIZE(req->pages), q_mem);
+
+	status = be_mbox_notify(ctrl);
+	if (!status) {
+		eq->id = le16_to_cpu(resp->eq_id);
+		eq->created = true;
+	}
+	spin_unlock(&ctrl->mbox_lock);
+	return status;
+}
+
+int be_cmd_fw_initialize(struct be_ctrl_info *ctrl)
+{
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	int status;
+	u8 *endian_check;
+
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+
+	endian_check = (u8 *) wrb;
+	*endian_check++ = 0xFF;
+	*endian_check++ = 0x12;
+	*endian_check++ = 0x34;
+	*endian_check++ = 0xFF;
+	*endian_check++ = 0xFF;
+	*endian_check++ = 0x56;
+	*endian_check++ = 0x78;
+	*endian_check++ = 0xFF;
+	be_dws_cpu_to_le(wrb, sizeof(*wrb));
+
+	status = be_mbox_notify(ctrl);
+	if (status)
+		SE_DEBUG(DBG_LVL_1, "be_cmd_fw_initialize Failed \n");
+
+	spin_unlock(&ctrl->mbox_lock);
+	return status;
+}
+
+int beiscsi_cmd_cq_create(struct be_ctrl_info *ctrl,
+		      struct be_queue_info *cq, struct be_queue_info *eq,
+		      bool sol_evts, bool no_delay, int coalesce_wm)
+{
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct be_cmd_req_cq_create *req = embedded_payload(wrb);
+	struct be_cmd_resp_cq_create *resp = embedded_payload(wrb);
+	struct be_dma_mem *q_mem = &cq->dma_mem;
+	void *ctxt = &req->context;
+	int status;
+
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_COMMON,
+			OPCODE_COMMON_CQ_CREATE, sizeof(*req));
+
+	if (q_mem->va) {
+		SE_DEBUG(DBG_LVL_8, "beiscsi_cmd_cq_create, q_mem->va =%p \n",
+								q_mem->va);
+	} else
+		SE_DEBUG(DBG_LVL_1,
+			"In beiscsi_cmd_cq_create, uninitialized q_mem->va\n");
+
+	req->num_pages = cpu_to_le16(PAGES_4K_SPANNED(q_mem->va, q_mem->size));
+
+	AMAP_SET_BITS(struct amap_cq_context, coalescwm, ctxt, coalesce_wm);
+	AMAP_SET_BITS(struct amap_cq_context, nodelay, ctxt, no_delay);
+	AMAP_SET_BITS(struct amap_cq_context, count, ctxt,
+		      __ilog2_u32(cq->len / 256));
+	AMAP_SET_BITS(struct amap_cq_context, valid, ctxt, 1);
+	AMAP_SET_BITS(struct amap_cq_context, solevent, ctxt, sol_evts);
+	AMAP_SET_BITS(struct amap_cq_context, eventable, ctxt, 1);
+	AMAP_SET_BITS(struct amap_cq_context, eqid, ctxt, eq->id);
+	AMAP_SET_BITS(struct amap_cq_context, armed, ctxt, 1);
+	AMAP_SET_BITS(struct amap_cq_context, func, ctxt,
+		      PCI_FUNC(ctrl->pdev->devfn));
+	be_dws_cpu_to_le(ctxt, sizeof(req->context));
+
+	be_cmd_page_addrs_prepare(req->pages, ARRAY_SIZE(req->pages), q_mem);
+
+	status = be_mbox_notify(ctrl);
+	if (!status) {
+		cq->id = le16_to_cpu(resp->cq_id);
+		cq->created = true;
+	} else
+		SE_DEBUG(DBG_LVL_1, "In be_cmd_cq_create, status=ox%08x \n",
+			status);
+	spin_unlock(&ctrl->mbox_lock);
+
+	return status;
+}
+
+static u32 be_encoded_q_len(int q_len)
+{
+	u32 len_encoded = fls(q_len);	/* log2(len) + 1 */
+	if (len_encoded == 16)
+		len_encoded = 0;
+	return len_encoded;
+}
+int beiscsi_cmd_q_destroy(struct be_ctrl_info *ctrl, struct be_queue_info *q,
+							int queue_type)
+{
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct be_cmd_req_q_destroy *req = embedded_payload(wrb);
+	u8 subsys = 0, opcode = 0;
+	int status;
+
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+
+	switch (queue_type) {
+	case QTYPE_EQ:
+		subsys = CMD_SUBSYSTEM_COMMON;
+		opcode = OPCODE_COMMON_EQ_DESTROY;
+		break;
+	case QTYPE_CQ:
+		subsys = CMD_SUBSYSTEM_COMMON;
+		opcode = OPCODE_COMMON_CQ_DESTROY;
+		break;
+	case QTYPE_WRBQ:
+		subsys = CMD_SUBSYSTEM_ISCSI;
+		opcode = OPCODE_COMMON_ISCSI_WRBQ_DESTROY;
+		break;
+	case QTYPE_DPDUQ:
+		subsys = CMD_SUBSYSTEM_ISCSI;
+		opcode = OPCODE_COMMON_ISCSI_DEFQ_DESTROY;
+		break;
+	case QTYPE_SGL:
+		subsys = CMD_SUBSYSTEM_ISCSI;
+		opcode = OPCODE_COMMON_ISCSI_CFG_REMOVE_SGL_PAGES;
+		break;
+	default:
+		spin_unlock(&ctrl->mbox_lock);
+		BUG();
+		return -1;
+	}
+	be_cmd_hdr_prepare(&req->hdr, subsys, opcode, sizeof(*req));
+	if (queue_type != QTYPE_SGL)
+		req->id = cpu_to_le16(q->id);
+
+	status = be_mbox_notify(ctrl);
+
+	spin_unlock(&ctrl->mbox_lock);
+	return status;
+}
+
+int be_cmd_get_mac_addr(struct be_ctrl_info *ctrl, u8 *mac_addr)
+{
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct be_cmd_req_get_mac_addr *req = embedded_payload(wrb);
+	int status;
+
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
+			   OPCODE_COMMON_ISCSI_NTWK_GET_NIC_CONFIG,
+			   sizeof(*req));
+
+	status = be_mbox_notify(ctrl);
+	if (!status) {
+		struct be_cmd_resp_get_mac_addr *resp = embedded_payload(wrb);
+
+		memcpy(mac_addr, resp->mac_address, ETH_ALEN);
+	}
+
+	spin_unlock(&ctrl->mbox_lock);
+	return status;
+}
+
+int be_cmd_create_default_pdu_queue(struct be_ctrl_info *ctrl,
+				    struct be_queue_info *cq,
+				    struct be_queue_info *dq, int length,
+				    int entry_size)
+{
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct be_defq_create_req *req = embedded_payload(wrb);
+	struct be_dma_mem *q_mem = &dq->dma_mem;
+	void *ctxt = &req->context;
+	int status;
+
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
+			   OPCODE_COMMON_ISCSI_DEFQ_CREATE, sizeof(*req));
+
+	req->num_pages = PAGES_4K_SPANNED(q_mem->va, q_mem->size);
+	AMAP_SET_BITS(struct amap_be_default_pdu_context, rx_pdid, ctxt, 0);
+	AMAP_SET_BITS(struct amap_be_default_pdu_context, rx_pdid_valid, ctxt,
+		      1);
+	AMAP_SET_BITS(struct amap_be_default_pdu_context, pci_func_id, ctxt,
+		      PCI_FUNC(ctrl->pdev->devfn));
+	AMAP_SET_BITS(struct amap_be_default_pdu_context, ring_size, ctxt,
+		      be_encoded_q_len(length / sizeof(struct phys_addr)));
+	AMAP_SET_BITS(struct amap_be_default_pdu_context, default_buffer_size,
+		      ctxt, entry_size);
+	AMAP_SET_BITS(struct amap_be_default_pdu_context, cq_id_recv, ctxt,
+		      cq->id);
+
+	be_dws_cpu_to_le(ctxt, sizeof(req->context));
+
+	be_cmd_page_addrs_prepare(req->pages, ARRAY_SIZE(req->pages), q_mem);
+
+	status = be_mbox_notify(ctrl);
+	if (!status) {
+		struct be_defq_create_resp *resp = embedded_payload(wrb);
+
+		dq->id = le16_to_cpu(resp->id);
+		dq->created = true;
+	}
+	spin_unlock(&ctrl->mbox_lock);
+
+	return status;
+}
+
+int be_cmd_wrbq_create(struct be_ctrl_info *ctrl, struct be_dma_mem *q_mem,
+		       struct be_queue_info *wrbq)
+{
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct be_wrbq_create_req *req = embedded_payload(wrb);
+	struct be_wrbq_create_resp *resp = embedded_payload(wrb);
+	int status;
+
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
+		OPCODE_COMMON_ISCSI_WRBQ_CREATE, sizeof(*req));
+	req->num_pages = PAGES_4K_SPANNED(q_mem->va, q_mem->size);
+	be_cmd_page_addrs_prepare(req->pages, ARRAY_SIZE(req->pages), q_mem);
+
+	status = be_mbox_notify(ctrl);
+	if (!status)
+		wrbq->id = le16_to_cpu(resp->cid);
+	spin_unlock(&ctrl->mbox_lock);
+	return status;
+}
+
+int be_cmd_iscsi_post_sgl_pages(struct be_ctrl_info *ctrl,
+				struct be_dma_mem *q_mem,
+				u32 page_offset, u32 num_pages)
+{
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct be_post_sgl_pages_req *req = embedded_payload(wrb);
+	int status;
+	unsigned int curr_pages;
+	u32 internal_page_offset = 0;
+	u32 temp_num_pages = num_pages;
+
+	if (num_pages == 0xff)
+		num_pages = 1;
+
+	spin_lock(&ctrl->mbox_lock);
+	do {
+		memset(wrb, 0, sizeof(*wrb));
+		be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+		be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
+				   OPCODE_COMMON_ISCSI_CFG_POST_SGL_PAGES,
+				   sizeof(*req));
+		curr_pages = BE_NUMBER_OF_FIELD(struct be_post_sgl_pages_req,
+						pages);
+		req->num_pages = min(num_pages, curr_pages);
+		req->page_offset = page_offset;
+		be_cmd_page_addrs_prepare(req->pages, req->num_pages, q_mem);
+		q_mem->dma = q_mem->dma + (req->num_pages * PAGE_SIZE);
+		internal_page_offset += req->num_pages;
+		page_offset += req->num_pages;
+		num_pages -= req->num_pages;
+
+		if (temp_num_pages == 0xff)
+			req->num_pages = temp_num_pages;
+
+		status = be_mbox_notify(ctrl);
+		if (status) {
+			SE_DEBUG(DBG_LVL_1,
+				 "FW CMD to map iscsi frags failed.\n");
+			goto error;
+		}
+	} while (num_pages > 0);
+error:
+	spin_unlock(&ctrl->mbox_lock);
+	if (status != 0)
+		beiscsi_cmd_q_destroy(ctrl, NULL, QTYPE_SGL);
+	return status;
+}
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
new file mode 100644
index 0000000..175506c
--- /dev/null
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -0,0 +1,877 @@
+/**
+ * Copyright (C) 2005 - 2009 ServerEngines
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.  The full GNU General
+ * Public License is included in this distribution in the file called COPYING.
+ *
+ * Contact Information:
+ * linux-drivers@serverengines.com
+ *
+ * ServerEngines
+ * 209 N. Fair Oaks Ave
+ * Sunnyvale, CA 94085
+ */
+
+#ifndef BEISCSI_CMDS_H
+#define BEISCSI_CMDS_H
+
+/**
+ * The driver sends configuration and managements command requests to the
+ * firmware in the BE. These requests are communicated to the processor
+ * using Work Request Blocks (WRBs) submitted to the MCC-WRB ring or via one
+ * WRB inside a MAILBOX.
+ * The commands are serviced by the ARM processor in the BladeEngine's MPU.
+ */
+struct be_sge {
+	u32 pa_lo;
+	u32 pa_hi;
+	u32 len;
+};
+
+#define MCC_WRB_SGE_CNT_SHIFT 3	/* bits 3 - 7 of dword 0 */
+#define MCC_WRB_SGE_CNT_MASK 0x1F	/* bits 3 - 7 of dword 0 */
+struct be_mcc_wrb {
+	u32 embedded;		/* dword 0 */
+	u32 payload_length;	/* dword 1 */
+	u32 tag0;		/* dword 2 */
+	u32 tag1;		/* dword 3 */
+	u32 rsvd;		/* dword 4 */
+	union {
+		u8 embedded_payload[236];	/* used by embedded cmds */
+		struct be_sge sgl[19];	/* used by non-embedded cmds */
+	} payload;
+};
+
+#define CQE_FLAGS_VALID_MASK (1 << 31)
+#define CQE_FLAGS_ASYNC_MASK (1 << 30)
+
+/* Completion Status */
+#define MCC_STATUS_SUCCESS 0x0
+
+#define CQE_STATUS_COMPL_MASK 0xFFFF
+#define CQE_STATUS_COMPL_SHIFT 0	/* bits 0 - 15 */
+#define CQE_STATUS_EXTD_MASK 0xFFFF
+#define CQE_STATUS_EXTD_SHIFT 0		/* bits 0 - 15 */
+
+struct be_mcc_compl {
+	u32 status;		/* dword 0 */
+	u32 tag0;		/* dword 1 */
+	u32 tag1;		/* dword 2 */
+	u32 flags;		/* dword 3 */
+};
+
+/********* Mailbox door bell *************/
+/**
+ * Used for driver communication with the FW.
+ * The software must write this register twice to post any command. First,
+ * it writes the register with hi=1 and the upper bits of the physical address
+ * for the MAILBOX structure. Software must poll the ready bit until this
+ * is acknowledged. Then, sotware writes the register with hi=0 with the lower
+ * bits in the address. It must poll the ready bit until the command is
+ * complete. Upon completion, the MAILBOX will contain a valid completion
+ * queue entry.
+ */
+#define MPU_MAILBOX_DB_OFFSET	0x160
+#define MPU_MAILBOX_DB_RDY_MASK	0x1	/* bit 0 */
+#define MPU_MAILBOX_DB_HI_MASK	0x2	/* bit 1 */
+
+/********** MPU semphore ******************/
+#define MPU_EP_SEMAPHORE_OFFSET 0xac
+#define EP_SEMAPHORE_POST_STAGE_MASK 0x0000FFFF
+#define EP_SEMAPHORE_POST_ERR_MASK 0x1
+#define EP_SEMAPHORE_POST_ERR_SHIFT 31
+
+/********** MCC door bell ************/
+#define DB_MCCQ_OFFSET 0x140
+#define DB_MCCQ_RING_ID_MASK 0x7FF		/* bits 0 - 10 */
+/* Number of entries posted */
+#define DB_MCCQ_NUM_POSTED_SHIFT 16		/* bits 16 - 29 */
+
+/* MPU semphore POST stage values */
+#define POST_STAGE_ARMFW_RDY		0xc000	/* FW is done with POST */
+
+/**
+ * When the async bit of mcc_compl is set, the last 4 bytes of
+ * mcc_compl is interpreted as follows:
+ */
+#define ASYNC_TRAILER_EVENT_CODE_SHIFT	8	/* bits 8 - 15 */
+#define ASYNC_TRAILER_EVENT_CODE_MASK	0xFF
+#define ASYNC_EVENT_CODE_LINK_STATE	0x1
+struct be_async_event_trailer {
+	u32 code;
+};
+
+enum {
+	ASYNC_EVENT_LINK_DOWN = 0x0,
+	ASYNC_EVENT_LINK_UP = 0x1
+};
+
+/**
+ * When the event code of an async trailer is link-state, the mcc_compl
+ * must be interpreted as follows
+ */
+struct be_async_event_link_state {
+	u8 physical_port;
+	u8 port_link_status;
+	u8 port_duplex;
+	u8 port_speed;
+	u8 port_fault;
+	u8 rsvd0[7];
+	struct be_async_event_trailer trailer;
+} __packed;
+
+struct be_mcc_mailbox {
+	struct be_mcc_wrb wrb;
+	struct be_mcc_compl compl;
+};
+
+/* Type of subsystems supported by FW */
+#define CMD_SUBSYSTEM_COMMON    0x1
+#define CMD_SUBSYSTEM_ISCSI     0x2
+#define CMD_SUBSYSTEM_ETH       0x3
+#define CMD_SUBSYSTEM_ISCSI_INI 0x6
+#define CMD_COMMON_TCP_UPLOAD   0x1
+
+/**
+ * List of common opcodes subsystem  CMD_SUBSYSTEM_COMMON
+ * These opcodes are unique for each subsystem defined above
+ */
+#define OPCODE_COMMON_CQ_CREATE				12
+#define OPCODE_COMMON_EQ_CREATE				13
+#define OPCODE_COMMON_MCC_CREATE        		21
+#define OPCODE_COMMON_GET_CNTL_ATTRIBUTES               32
+#define OPCODE_COMMON_GET_FW_VERSION			35
+#define OPCODE_COMMON_MODIFY_EQ_DELAY			41
+#define OPCODE_COMMON_FIRMWARE_CONFIG			42
+#define OPCODE_COMMON_MCC_DESTROY        		53
+#define OPCODE_COMMON_CQ_DESTROY        		54
+#define OPCODE_COMMON_EQ_DESTROY        		55
+#define OPCODE_COMMON_QUERY_FIRMWARE_CONFIG		58
+#define OPCODE_COMMON_FUNCTION_RESET			61
+
+/**
+ * LIST of opcodes that are common between Initiator and Target
+ * used by CMD_SUBSYSTEM_ISCSI
+ * These opcodes are unique for each subsystem defined above
+ */
+#define OPCODE_COMMON_ISCSI_CFG_POST_SGL_PAGES		2
+#define OPCODE_COMMON_ISCSI_CFG_REMOVE_SGL_PAGES        3
+#define OPCODE_COMMON_ISCSI_NTWK_GET_NIC_CONFIG		7
+#define OPCODE_COMMON_ISCSI_SET_FRAGNUM_BITS_FOR_SGL_CRA 61
+#define OPCODE_COMMON_ISCSI_DEFQ_CREATE                 64
+#define OPCODE_COMMON_ISCSI_DEFQ_DESTROY 		65
+#define OPCODE_COMMON_ISCSI_WRBQ_CREATE			66
+#define OPCODE_COMMON_ISCSI_WRBQ_DESTROY 		67
+
+struct be_cmd_req_hdr {
+	u8 opcode;		/* dword 0 */
+	u8 subsystem;		/* dword 0 */
+	u8 port_number;		/* dword 0 */
+	u8 domain;		/* dword 0 */
+	u32 timeout;		/* dword 1 */
+	u32 request_length;	/* dword 2 */
+	u32 rsvd;		/* dword 3 */
+};
+
+struct be_cmd_resp_hdr {
+	u32 info;		/* dword 0 */
+	u32 status;		/* dword 1 */
+	u32 response_length;	/* dword 2 */
+	u32 actual_resp_len;	/* dword 3 */
+};
+
+struct phys_addr {
+	u32 lo;
+	u32 hi;
+};
+
+/**************************
+ * BE Command definitions *
+ **************************/
+
+/**
+ * Pseudo amap definition in which each bit of the actual structure is defined
+ * as a byte - used to calculate offset/shift/mask of each field
+ */
+struct amap_eq_context {
+	u8 cidx[13];		/* dword 0 */
+	u8 rsvd0[3];		/* dword 0 */
+	u8 epidx[13];		/* dword 0 */
+	u8 valid;		/* dword 0 */
+	u8 rsvd1;		/* dword 0 */
+	u8 size;		/* dword 0 */
+	u8 pidx[13];		/* dword 1 */
+	u8 rsvd2[3];		/* dword 1 */
+	u8 pd[10];		/* dword 1 */
+	u8 count[3];		/* dword 1 */
+	u8 solevent;		/* dword 1 */
+	u8 stalled;		/* dword 1 */
+	u8 armed;		/* dword 1 */
+	u8 rsvd3[4];		/* dword 2 */
+	u8 func[8];		/* dword 2 */
+	u8 rsvd4;		/* dword 2 */
+	u8 delaymult[10];	/* dword 2 */
+	u8 rsvd5[2];		/* dword 2 */
+	u8 phase[2];		/* dword 2 */
+	u8 nodelay;		/* dword 2 */
+	u8 rsvd6[4];		/* dword 2 */
+	u8 rsvd7[32];		/* dword 3 */
+} __packed;
+
+struct be_cmd_req_eq_create {
+	struct be_cmd_req_hdr hdr;	/* dw[4] */
+	u16 num_pages;		/* sword */
+	u16 rsvd0;		/* sword */
+	u8 context[sizeof(struct amap_eq_context) / 8];	/* dw[4] */
+	struct phys_addr pages[8];
+} __packed;
+
+struct be_cmd_resp_eq_create {
+	struct be_cmd_resp_hdr resp_hdr;
+	u16 eq_id;		/* sword */
+	u16 rsvd0;		/* sword */
+} __packed;
+
+struct mac_addr {
+	u16 size_of_struct;
+	u8 addr[ETH_ALEN];
+} __packed;
+
+struct be_cmd_req_mac_query {
+	struct be_cmd_req_hdr hdr;
+	u8 type;
+	u8 permanent;
+	u16 if_id;
+} __packed;
+
+struct be_cmd_resp_mac_query {
+	struct be_cmd_resp_hdr hdr;
+	struct mac_addr mac;
+};
+
+/******************** Create CQ ***************************/
+/**
+ * Pseudo amap definition in which each bit of the actual structure is defined
+ * as a byte - used to calculate offset/shift/mask of each field
+ */
+struct amap_cq_context {
+	u8 cidx[11];		/* dword 0 */
+	u8 rsvd0;		/* dword 0 */
+	u8 coalescwm[2];	/* dword 0 */
+	u8 nodelay;		/* dword 0 */
+	u8 epidx[11];		/* dword 0 */
+	u8 rsvd1;		/* dword 0 */
+	u8 count[2];		/* dword 0 */
+	u8 valid;		/* dword 0 */
+	u8 solevent;		/* dword 0 */
+	u8 eventable;		/* dword 0 */
+	u8 pidx[11];		/* dword 1 */
+	u8 rsvd2;		/* dword 1 */
+	u8 pd[10];		/* dword 1 */
+	u8 eqid[8];		/* dword 1 */
+	u8 stalled;		/* dword 1 */
+	u8 armed;		/* dword 1 */
+	u8 rsvd3[4];		/* dword 2 */
+	u8 func[8];		/* dword 2 */
+	u8 rsvd4[20];		/* dword 2 */
+	u8 rsvd5[32];		/* dword 3 */
+} __packed;
+
+struct be_cmd_req_cq_create {
+	struct be_cmd_req_hdr hdr;
+	u16 num_pages;
+	u16 rsvd0;
+	u8 context[sizeof(struct amap_cq_context) / 8];
+	struct phys_addr pages[4];
+} __packed;
+
+struct be_cmd_resp_cq_create {
+	struct be_cmd_resp_hdr hdr;
+	u16 cq_id;
+	u16 rsvd0;
+} __packed;
+
+/******************** Create MCCQ ***************************/
+/**
+ * Pseudo amap definition in which each bit of the actual structure is defined
+ * as a byte - used to calculate offset/shift/mask of each field
+ */
+struct amap_mcc_context {
+	u8 con_index[14];
+	u8 rsvd0[2];
+	u8 ring_size[4];
+	u8 fetch_wrb;
+	u8 fetch_r2t;
+	u8 cq_id[10];
+	u8 prod_index[14];
+	u8 fid[8];
+	u8 pdid[9];
+	u8 valid;
+	u8 rsvd1[32];
+	u8 rsvd2[32];
+} __packed;
+
+struct be_cmd_req_mcc_create {
+	struct be_cmd_req_hdr hdr;
+	u16 num_pages;
+	u16 rsvd0;
+	u8 context[sizeof(struct amap_mcc_context) / 8];
+	struct phys_addr pages[8];
+} __packed;
+
+struct be_cmd_resp_mcc_create {
+	struct be_cmd_resp_hdr hdr;
+	u16 id;
+	u16 rsvd0;
+} __packed;
+
+/******************** Q Destroy  ***************************/
+/* Type of Queue to be destroyed */
+enum {
+	QTYPE_EQ = 1,
+	QTYPE_CQ,
+	QTYPE_MCCQ,
+	QTYPE_WRBQ,
+	QTYPE_DPDUQ,
+	QTYPE_SGL
+};
+
+struct be_cmd_req_q_destroy {
+	struct be_cmd_req_hdr hdr;
+	u16 id;
+	u16 bypass_flush;	/* valid only for rx q destroy */
+} __packed;
+
+struct macaddr {
+	u8 byte[ETH_ALEN];
+};
+
+struct be_cmd_req_mcast_mac_config {
+	struct be_cmd_req_hdr hdr;
+	u16 num_mac;
+	u8 promiscuous;
+	u8 interface_id;
+	struct macaddr mac[32];
+} __packed;
+
+static inline void *embedded_payload(struct be_mcc_wrb *wrb)
+{
+	return wrb->payload.embedded_payload;
+}
+
+static inline struct be_sge *nonembedded_sgl(struct be_mcc_wrb *wrb)
+{
+	return &wrb->payload.sgl[0];
+}
+
+/******************** Modify EQ Delay *******************/
+struct be_cmd_req_modify_eq_delay {
+	struct be_cmd_req_hdr hdr;
+	u32 num_eq;
+	struct {
+		u32 eq_id;
+		u32 phase;
+		u32 delay_multiplier;
+	} delay[8];
+} __packed;
+
+/******************** Get MAC ADDR *******************/
+
+#define ETH_ALEN	6
+
+
+struct be_cmd_req_get_mac_addr {
+	struct be_cmd_req_hdr hdr;
+	u32 nic_port_count;
+	u32 speed;
+	u32 max_speed;
+	u32 link_state;
+	u32 max_frame_size;
+	u16 size_of_structure;
+	u8 mac_address[ETH_ALEN];
+	u32 rsvd[23];
+};
+
+struct be_cmd_resp_get_mac_addr {
+	struct be_cmd_resp_hdr hdr;
+	u32 nic_port_count;
+	u32 speed;
+	u32 max_speed;
+	u32 link_state;
+	u32 max_frame_size;
+	u16 size_of_structure;
+	u8 mac_address[6];
+	u32 rsvd[23];
+};
+
+int beiscsi_cmd_eq_create(struct be_ctrl_info *ctrl,
+		     struct be_queue_info *eq, int eq_delay);
+
+int beiscsi_cmd_cq_create(struct be_ctrl_info *ctrl,
+		     struct be_queue_info *cq, struct be_queue_info *eq,
+		     bool sol_evts, bool no_delay,
+		     int num_cqe_dma_coalesce);
+
+int beiscsi_cmd_q_destroy(struct be_ctrl_info *ctrl, struct be_queue_info *q,
+		     int type);
+int be_poll_mcc(struct be_ctrl_info *ctrl);
+unsigned char mgmt_check_supported_fw(struct be_ctrl_info *ctrl);
+int be_cmd_get_mac_addr(struct be_ctrl_info *ctrl, u8 *mac_addr);
+
+/*ISCSI Functuions */
+int be_cmd_fw_initialize(struct be_ctrl_info *ctrl);
+
+struct be_mcc_wrb *wrb_from_mbox(struct be_dma_mem *mbox_mem);
+
+int be_mbox_notify(struct be_ctrl_info *ctrl);
+
+int be_cmd_create_default_pdu_queue(struct be_ctrl_info *ctrl,
+				    struct be_queue_info *cq,
+				    struct be_queue_info *dq, int length,
+				    int entry_size);
+
+int be_cmd_iscsi_post_sgl_pages(struct be_ctrl_info *ctrl,
+				struct be_dma_mem *q_mem, u32 page_offset,
+				u32 num_pages);
+
+int be_cmd_wrbq_create(struct be_ctrl_info *ctrl, struct be_dma_mem *q_mem,
+		       struct be_queue_info *wrbq);
+
+struct be_default_pdu_context {
+	u32 dw[4];
+} __packed;
+
+struct amap_be_default_pdu_context {
+	u8 dbuf_cindex[13];	/* dword 0 */
+	u8 rsvd0[3];		/* dword 0 */
+	u8 ring_size[4];	/* dword 0 */
+	u8 ring_state[4];	/* dword 0 */
+	u8 rsvd1[8];		/* dword 0 */
+	u8 dbuf_pindex[13];	/* dword 1 */
+	u8 rsvd2;		/* dword 1 */
+	u8 pci_func_id[8];	/* dword 1 */
+	u8 rx_pdid[9];		/* dword 1 */
+	u8 rx_pdid_valid;	/* dword 1 */
+	u8 default_buffer_size[16];	/* dword 2 */
+	u8 cq_id_recv[10];	/* dword 2 */
+	u8 rx_pdid_not_valid;	/* dword 2 */
+	u8 rsvd3[5];		/* dword 2 */
+	u8 rsvd4[32];		/* dword 3 */
+} __packed;
+
+struct be_defq_create_req {
+	struct be_cmd_req_hdr hdr;
+	u16 num_pages;
+	u8 ulp_num;
+	u8 rsvd0;
+	struct be_default_pdu_context context;
+	struct phys_addr pages[8];
+} __packed;
+
+struct be_defq_create_resp {
+	struct be_cmd_req_hdr hdr;
+	u16 id;
+	u16 rsvd0;
+} __packed;
+
+struct be_post_sgl_pages_req {
+	struct be_cmd_req_hdr hdr;
+	u16 num_pages;
+	u16 page_offset;
+	u32 rsvd0;
+	struct phys_addr pages[26];
+	u32 rsvd1;
+} __packed;
+
+struct be_wrbq_create_req {
+	struct be_cmd_req_hdr hdr;
+	u16 num_pages;
+	u8 ulp_num;
+	u8 rsvd0;
+	struct phys_addr pages[8];
+} __packed;
+
+struct be_wrbq_create_resp {
+	struct be_cmd_resp_hdr resp_hdr;
+	u16 cid;
+	u16 rsvd0;
+} __packed;
+
+#define SOL_CID_MASK		0x0000FFC0
+#define SOL_CODE_MASK		0x0000003F
+#define SOL_WRB_INDEX_MASK	0x00FF0000
+#define SOL_CMD_WND_MASK	0xFF000000
+#define SOL_RES_CNT_MASK	0x7FFFFFFF
+#define SOL_EXP_CMD_SN_MASK	0xFFFFFFFF
+#define SOL_HW_STS_MASK		0x000000FF
+#define SOL_STS_MASK		0x0000FF00
+#define SOL_RESP_MASK		0x00FF0000
+#define SOL_FLAGS_MASK		0x7F000000
+#define SOL_S_MASK		0x80000000
+
+struct sol_cqe {
+	u32 dw[4];
+};
+
+struct amap_sol_cqe {
+	u8 hw_sts[8];		/* dword 0 */
+	u8 i_sts[8];		/* dword 0 */
+	u8 i_resp[8];		/* dword 0 */
+	u8 i_flags[7];		/* dword 0 */
+	u8 s;			/* dword 0 */
+	u8 i_exp_cmd_sn[32];	/* dword 1 */
+	u8 code[6];		/* dword 2 */
+	u8 cid[10];		/* dword 2 */
+	u8 wrb_index[8];	/* dword 2 */
+	u8 i_cmd_wnd[8];	/* dword 2 */
+	u8 i_res_cnt[31];	/* dword 3 */
+	u8 valid;		/* dword 3 */
+} __packed;
+
+
+/**
+ * Post WRB Queue Doorbell Register used by the host Storage
+ * stack to notify the
+ * controller of a posted Work Request Block
+ */
+#define DB_WRB_POST_CID_MASK		0x3FF	/* bits 0 - 9 */
+#define DB_DEF_PDU_WRB_INDEX_MASK	0xFF	/* bits 0 - 9 */
+
+#define DB_DEF_PDU_WRB_INDEX_SHIFT	16
+#define DB_DEF_PDU_NUM_POSTED_SHIFT	24
+
+struct fragnum_bits_for_sgl_cra_in {
+	struct be_cmd_req_hdr hdr;
+	u32 num_bits;
+} __packed;
+
+struct iscsi_cleanup_req {
+	struct be_cmd_req_hdr hdr;
+	u16 chute;
+	u8 hdr_ring_id;
+	u8 data_ring_id;
+
+} __packed;
+
+struct eq_delay {
+	u32 eq_id;
+	u32 phase;
+	u32 delay_multiplier;
+} __packed;
+
+struct be_eq_delay_params_in {
+	struct be_cmd_req_hdr hdr;
+	u32 num_eq;
+	struct eq_delay delay[8];
+} __packed;
+
+struct ip_address_format {
+	u16 size_of_structure;
+	u8 reserved;
+	u8 ip_type;
+	u8 ip_address[16];
+	u32 rsvd0;
+} __packed;
+
+struct tcp_connect_and_offload_in {
+	struct be_cmd_req_hdr hdr;
+	struct ip_address_format ip_address;
+	u16 tcp_port;
+	u16 cid;
+	u16 cq_id;
+	u16 defq_id;
+	struct phys_addr dataout_template_pa;
+	u16 hdr_ring_id;
+	u16 data_ring_id;
+	u8 do_offload;
+	u8 rsvd0[3];
+} __packed;
+
+struct tcp_connect_and_offload_out {
+	struct be_cmd_resp_hdr hdr;
+	u32 connection_handle;
+	u16 cid;
+	u16 rsvd0;
+
+} __packed;
+
+struct be_mcc_wrb_context {
+	struct MCC_WRB *wrb;
+	int *users_final_status;
+} __packed;
+
+#define DB_DEF_PDU_RING_ID_MASK		0x3FF	/* bits 0 - 9 */
+#define DB_DEF_PDU_CQPROC_MASK		0x3FFF	/* bits 0 - 9 */
+#define DB_DEF_PDU_REARM_SHIFT		14
+#define DB_DEF_PDU_EVENT_SHIFT		15
+#define DB_DEF_PDU_CQPROC_SHIFT		16
+
+struct dmsg_cqe {
+	u32 dw[4];
+} __packed;
+
+struct tcp_upload_params_in {
+	struct be_cmd_req_hdr hdr;
+	u16 id;
+	u16 upload_type;
+	u32 reset_seq;
+} __packed;
+
+struct tcp_upload_params_out {
+	u32 dw[32];
+} __packed;
+
+union tcp_upload_params {
+	struct tcp_upload_params_in request;
+	struct tcp_upload_params_out response;
+} __packed;
+
+struct be_ulp_fw_cfg {
+	u32 ulp_mode;
+	u32 etx_base;
+	u32 etx_count;
+	u32 sq_base;
+	u32 sq_count;
+	u32 rq_base;
+	u32 rq_count;
+	u32 dq_base;
+	u32 dq_count;
+	u32 lro_base;
+	u32 lro_count;
+	u32 icd_base;
+	u32 icd_count;
+};
+
+struct be_fw_cfg {
+	struct be_cmd_req_hdr hdr;
+	u32 be_config_number;
+	u32 asic_revision;
+	u32 phys_port;
+	u32 function_mode;
+	struct be_ulp_fw_cfg ulp[2];
+	u32 function_caps;
+} __packed;
+
+#define CMD_ISCSI_COMMAND_INVALIDATE  1
+#define ISCSI_OPCODE_SCSI_DATA_OUT      5
+#define OPCODE_COMMON_ISCSI_TCP_CONNECT_AND_OFFLOAD 70
+#define OPCODE_ISCSI_INI_DRIVER_OFFLOAD_SESSION 41
+#define OPCODE_COMMON_MODIFY_EQ_DELAY	41
+#define OPCODE_COMMON_ISCSI_CLEANUP	59
+#define	OPCODE_COMMON_TCP_UPLOAD	56
+#define OPCODE_COMMON_ISCSI_ERROR_RECOVERY_INVALIDATE_COMMANDS 1
+/* --- CMD_ISCSI_INVALIDATE_CONNECTION_TYPE --- */
+#define CMD_ISCSI_CONNECTION_INVALIDATE 1
+#define CMD_ISCSI_CONNECTION_ISSUE_TCP_RST 2
+#define OPCODE_ISCSI_INI_DRIVER_INVALIDATE_CONNECTION 42
+
+#define INI_WR_CMD			1	/* Initiator write command */
+#define INI_TMF_CMD			2	/* Initiator TMF command */
+#define INI_NOPOUT_CMD			3	/* Initiator; Send a NOP-OUT */
+#define INI_RD_CMD			5	/* Initiator requesting to send
+						 * a read command
+						 */
+#define TGT_CTX_UPDT_CMD		7	/* Target context update */
+#define TGT_STS_CMD			8	/* Target R2T and other BHS
+						 * where only the status number
+						 * need to be updated
+						 */
+#define TGT_DATAIN_CMD			9	/* Target Data-Ins in response
+						 * to read command
+						 */
+#define TGT_SOS_PDU			10	/* Target:standalone status
+						 * response
+						 */
+#define TGT_DM_CMD			11	/* Indicates that the bhs
+						 *  preparedby
+						 * driver should not be touched
+						 */
+/* --- CMD_CHUTE_TYPE --- */
+#define CMD_CONNECTION_CHUTE_0		1
+#define CMD_CONNECTION_CHUTE_1		2
+#define CMD_CONNECTION_CHUTE_2		3
+
+#define EQ_MAJOR_CODE_COMPLETION	0
+
+#define CMD_ISCSI_SESSION_DEL_CFG_FROM_FLASH 0
+#define CMD_ISCSI_SESSION_SAVE_CFG_ON_FLASH 1
+
+/* --- CONNECTION_UPLOAD_PARAMS --- */
+/* These parameters are used to define the type of upload desired.  */
+#define CONNECTION_UPLOAD_GRACEFUL      1	/* Graceful upload  */
+#define CONNECTION_UPLOAD_ABORT_RESET   2	/* Abortive upload with
+						 * reset
+						 */
+#define CONNECTION_UPLOAD_ABORT		3	/* Abortive upload without
+						 * reset
+						 */
+#define CONNECTION_UPLOAD_ABORT_WITH_SEQ 4	/* Abortive upload with reset,
+						 * sequence number by driver  */
+
+/* Returns byte size of given field with a structure. */
+
+/* Returns the number of items in the field array. */
+#define BE_NUMBER_OF_FIELD(_type_, _field_)	\
+	(FIELD_SIZEOF(_type_, _field_)/sizeof((((_type_ *)0)->_field_[0])))\
+
+/**
+ * Different types of iSCSI completions to host driver for both initiator
+ * and taget mode
+ * of operation.
+ */
+#define SOL_CMD_COMPLETE		1	/* Solicited command completed
+						 * normally
+						 */
+#define SOL_CMD_KILLED_DATA_DIGEST_ERR  2	/* Solicited command got
+						 * invalidated internally due
+						 * to Data Digest error
+						 */
+#define CXN_KILLED_PDU_SIZE_EXCEEDS_DSL 3	/* Connection got invalidated
+						 * internally
+						 * due to a recieved PDU
+						 * size > DSL
+						 */
+#define CXN_KILLED_BURST_LEN_MISMATCH   4	/* Connection got invalidated
+						 * internally due ti received
+						 * PDU sequence size >
+						 * FBL/MBL.
+						 */
+#define CXN_KILLED_AHS_RCVD		5	/* Connection got invalidated
+						 * internally due to a recieved
+						 * PDU Hdr that has
+						 * AHS */
+#define CXN_KILLED_HDR_DIGEST_ERR	6	/* Connection got invalidated
+						 * internally due to Hdr Digest
+						 * error
+						 */
+#define CXN_KILLED_UNKNOWN_HDR		7	/* Connection got invalidated
+						 *  internally
+						 * due to a bad opcode in the
+						 * pdu hdr
+						 */
+#define CXN_KILLED_STALE_ITT_TTT_RCVD	8	/* Connection got invalidated
+						 * internally due to a recieved
+						 * ITT/TTT that does not belong
+						 * to this Connection
+						 */
+#define CXN_KILLED_INVALID_ITT_TTT_RCVD 9	/* Connection got invalidated
+						 * internally due to recieved
+						 * ITT/TTT value > Max
+						 * Supported ITTs/TTTs
+						 */
+#define CXN_KILLED_RST_RCVD		10	/* Connection got invalidated
+						 * internally due to an
+						 * incoming TCP RST
+						 */
+#define CXN_KILLED_TIMED_OUT		11	/* Connection got invalidated
+						 * internally due to timeout on
+						 * tcp segment 12 retransmit
+						 * attempts failed
+						 */
+#define CXN_KILLED_RST_SENT		12	/* Connection got invalidated
+						 * internally due to TCP RST
+						 * sent by the Tx side
+						 */
+#define CXN_KILLED_FIN_RCVD		13	/* Connection got invalidated
+						 * internally due to an
+						 * incoming TCP FIN.
+						 */
+#define CXN_KILLED_BAD_UNSOL_PDU_RCVD	14	/* Connection got invalidated
+						 * internally due to bad
+						 * unsolicited PDU Unsolicited
+						 * PDUs are PDUs with
+						 * ITT=0xffffffff
+						 */
+#define CXN_KILLED_BAD_WRB_INDEX_ERROR	15	/* Connection got invalidated
+						 * internally due to bad WRB
+						 * index.
+						 */
+#define CXN_KILLED_OVER_RUN_RESIDUAL	16	/* Command got invalidated
+						 * internally due to recived
+						 * command has residual
+						 * over run bytes.
+						 */
+#define CXN_KILLED_UNDER_RUN_RESIDUAL	17	/* Command got invalidated
+						 * internally due to recived
+						 * command has residual under
+						 * run bytes.
+						 */
+#define CMD_KILLED_INVALID_STATSN_RCVD	18	/* Command got invalidated
+						 * internally due to a recieved
+						 * PDU has an invalid StatusSN
+						 */
+#define CMD_KILLED_INVALID_R2T_RCVD	19	/* Command got invalidated
+						 * internally due to a recieved
+						 * an R2T with some invalid
+						 * fields in it
+						 */
+#define CMD_CXN_KILLED_LUN_INVALID	20	/* Command got invalidated
+						 * internally due to received
+						 * PDU has an invalid LUN.
+						 */
+#define CMD_CXN_KILLED_ICD_INVALID	21	/* Command got invalidated
+						 * internally due to the
+						 * corresponding ICD not in a
+						 * valid state
+						 */
+#define CMD_CXN_KILLED_ITT_INVALID	22	/* Command got invalidated due
+						 *  to received PDU has an
+						 *  invalid ITT.
+						 */
+#define CMD_CXN_KILLED_SEQ_OUTOFORDER	23	/* Command got invalidated due
+						 * to received sequence buffer
+						 * offset is out of order.
+						 */
+#define CMD_CXN_KILLED_INVALID_DATASN_RCVD 24	/* Command got invalidated
+						 * internally due to a
+						 * recieved PDU has an invalid
+						 * DataSN
+						 */
+#define CXN_INVALIDATE_NOTIFY		25	/* Connection invalidation
+						 * completion notify.
+						 */
+#define CXN_INVALIDATE_INDEX_NOTIFY	26	/* Connection invalidation
+						 * completion
+						 * with data PDU index.
+						 */
+#define CMD_INVALIDATED_NOTIFY		27	/* Command invalidation
+						 * completionnotifify.
+						 */
+#define UNSOL_HDR_NOTIFY		28	/* Unsolicited header notify.*/
+#define UNSOL_DATA_NOTIFY		29	/* Unsolicited data notify.*/
+#define UNSOL_DATA_DIGEST_ERROR_NOTIFY 	30	/* Unsolicited data digest
+						 * error notify.
+						 */
+#define DRIVERMSG_NOTIFY		31	/* TCP acknowledge based
+						 * notification.
+						 */
+#define CXN_KILLED_CMND_DATA_NOT_ON_SAME_CONN 32 /* Connection got invalidated
+						  * internally due to command
+						  * and data are not on same
+						  * connection.
+						  */
+#define SOL_CMD_KILLED_DIF_ERR		33	/* Solicited command got
+						 *  invalidated internally due
+						 *  to DIF error
+						 */
+#define CXN_KILLED_SYN_RCVD		34	/* Connection got invalidated
+						 * internally due to incoming
+						 * TCP SYN
+						 */
+#define CXN_KILLED_IMM_DATA_RCVD	35	/* Connection got invalidated
+						 * internally due to an
+						 * incoming Unsolicited PDU
+						 * that has immediate data on
+						 * the cxn
+						 */
+
+void be_wrb_hdr_prepare(struct be_mcc_wrb *wrb, int payload_len,
+			bool embedded, u8 sge_cnt);
+
+void be_cmd_hdr_prepare(struct be_cmd_req_hdr *req_hdr,
+			u8 subsystem, u8 opcode, int cmd_len);
+
+#endif /* !BEISCSI_CMDS_H */
-- 
1.6.4

