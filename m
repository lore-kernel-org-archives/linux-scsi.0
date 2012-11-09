From: akpm@linux-foundation.org
Subject: [patch 2/2] drivers/scsi/hptiop: support HighPoint RR4520/RR4522 HBA
Date: Thu, 08 Nov 2012 16:12:02 -0800
Message-ID: <20121109001203.C8476200057@hpza10.eem.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:50392 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab2KIARn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Nov 2012 19:17:43 -0500
Received: by mail-la0-f74.google.com with SMTP id j13so213345lah.1
        for <linux-scsi@vger.kernel.org>; Thu, 08 Nov 2012 16:17:41 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux@highpoint-tech.com

From: HighPoint Linux Team <linux@highpoint-tech.com>
Subject: drivers/scsi/hptiop: support HighPoint RR4520/RR4522 HBA

Support IOP RR4520/RR4522 which are based on Marvell frey.

Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/scsi/hptiop.txt |   69 +++++
 drivers/scsi/hptiop.c         |  413 ++++++++++++++++++++++++++++++--
 drivers/scsi/hptiop.h         |   72 +++++
 3 files changed, 530 insertions(+), 24 deletions(-)

diff -puN Documentation/scsi/hptiop.txt~hptiop-support-highpoint-rr4520-rr4522-hba Documentation/scsi/hptiop.txt
--- a/Documentation/scsi/hptiop.txt~hptiop-support-highpoint-rr4520-rr4522-hba
+++ a/Documentation/scsi/hptiop.txt
@@ -37,7 +37,7 @@ For Intel IOP based adapters, the contro
             0x40    Inbound Queue Port
             0x44    Outbound Queue Port
 
-For Marvell IOP based adapters, the IOP is accessed via PCI BAR0 and BAR1:
+For Marvell not Frey IOP based adapters, the IOP is accessed via PCI BAR0 and BAR1:
 
      BAR0 offset    Register
          0x20400    Inbound Doorbell Register
@@ -55,9 +55,31 @@ For Marvell IOP based adapters, the IOP 
      0x40-0x1040    Inbound Queue
    0x1040-0x2040    Outbound Queue
 
+For Marvell Frey IOP based adapters, the IOP is accessed via PCI BAR0 and BAR1:
 
-I/O Request Workflow
-----------------------
+     BAR0 offset    Register
+             0x0    IOP configuration information.
+
+     BAR1 offset    Register
+          0x4000    Inbound List Base Address Low
+          0x4004    Inbound List Base Address High
+          0x4018    Inbound List Write Pointer
+          0x402C    Inbound List Configuration and Control
+          0x4050    Outbound List Base Address Low
+          0x4054    Outbound List Base Address High
+          0x4058    Outbound List Copy Pointer Shadow Base Address Low
+          0x405C    Outbound List Copy Pointer Shadow Base Address High
+          0x4088    Outbound List Interrupt Cause
+          0x408C    Outbound List Interrupt Enable
+         0x1020C    PCIe Function 0 Interrupt Enable
+         0x10400    PCIe Function 0 to CPU Message A
+         0x10420    CPU to PCIe Function 0 Message A
+         0x10480    CPU to PCIe Function 0 Doorbell
+         0x10484    CPU to PCIe Function 0 Doorbell Enable
+
+
+I/O Request Workflow of Not Marvell Frey
+------------------------------------------
 
 All queued requests are handled via inbound/outbound queue port.
 A request packet can be allocated in either IOP or host memory.
@@ -101,6 +123,45 @@ register 0. An outbound message with the
 of an inbound message.
 
 
+I/O Request Workflow of Marvell Frey
+--------------------------------------
+
+All queued requests are handled via inbound/outbound list.
+
+To send a request to the controller:
+
+    - Allocate a free request in host DMA coherent memory.
+
+      Requests allocated in host memory must be aligned on 32-bytes boundary.
+
+    - Fill the request with index of the request in the flag.
+
+      Fill a free inbound list unit with the physical address and the size of
+      the request.
+
+      Set up the inbound list write pointer with the index of previous unit,
+      round to 0 if the index reaches the supported count of requests.
+
+    - Post the inbound list writer pointer to IOP.
+
+    - The IOP process the request. When the request is completed, the flag of
+      the request with or-ed IOPMU_QUEUE_MASK_HOST_BITS will be put into a
+      free outbound list unit and the index of the outbound list unit will be
+      put into the copy pointer shadow register. An outbound interrupt will be
+      generated.
+
+    - The host read the outbound list copy pointer shadow register and compare
+      with previous saved read ponter N. If they are different, the host will
+      read the (N+1)th outbound list unit.
+
+      The host get the index of the request from the (N+1)th outbound list
+      unit and complete the request.
+
+Non-queued requests (reset communication/reset/flush etc) can be sent via PCIe
+Function 0 to CPU Message A register. The CPU to PCIe Function 0 Message register
+with the same value indicates the completion of message.
+
+
 User-level Interface
 ---------------------
 
@@ -112,7 +173,7 @@ The driver exposes following sysfs attri
 
 
 -----------------------------------------------------------------------------
-Copyright (C) 2006-2009 HighPoint Technologies, Inc. All Rights Reserved.
+Copyright (C) 2006-2012 HighPoint Technologies, Inc. All Rights Reserved.
 
   This file is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
diff -puN drivers/scsi/hptiop.c~hptiop-support-highpoint-rr4520-rr4522-hba drivers/scsi/hptiop.c
--- a/drivers/scsi/hptiop.c~hptiop-support-highpoint-rr4520-rr4522-hba
+++ a/drivers/scsi/hptiop.c
@@ -1,6 +1,6 @@
 /*
  * HighPoint RR3xxx/4xxx controller driver for Linux
- * Copyright (C) 2006-2009 HighPoint Technologies, Inc. All Rights Reserved.
+ * Copyright (C) 2006-2012 HighPoint Technologies, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -42,7 +42,7 @@ MODULE_DESCRIPTION("HighPoint RocketRAID
 
 static char driver_name[] = "hptiop";
 static const char driver_name_long[] = "RocketRAID 3xxx/4xxx Controller driver";
-static const char driver_ver[] = "v1.6 (091225)";
+static const char driver_ver[] = "v1.8";
 
 static int iop_send_sync_msg(struct hptiop_hba *hba, u32 msg, u32 millisec);
 static void hptiop_finish_scsi_req(struct hptiop_hba *hba, u32 tag,
@@ -77,6 +77,11 @@ static int iop_wait_ready_mv(struct hpti
 	return iop_send_sync_msg(hba, IOPMU_INBOUND_MSG0_NOP, millisec);
 }
 
+static int iop_wait_ready_mvfrey(struct hptiop_hba *hba, u32 millisec)
+{
+	return iop_send_sync_msg(hba, IOPMU_INBOUND_MSG0_NOP, millisec);
+}
+
 static void hptiop_request_callback_itl(struct hptiop_hba *hba, u32 tag)
 {
 	if (tag & IOPMU_QUEUE_ADDR_HOST_BIT)
@@ -230,6 +235,74 @@ static int iop_intr_mv(struct hptiop_hba
 	return ret;
 }
 
+static void hptiop_request_callback_mvfrey(struct hptiop_hba *hba, u32 _tag)
+{
+	u32 req_type = _tag & 0xf;
+	struct hpt_iop_request_scsi_command *req;
+
+	switch (req_type) {
+	case IOP_REQUEST_TYPE_GET_CONFIG:
+	case IOP_REQUEST_TYPE_SET_CONFIG:
+		hba->msg_done = 1;
+		break;
+
+	case IOP_REQUEST_TYPE_SCSI_COMMAND:
+		req = hba->reqs[(_tag >> 4) & 0xff].req_virt;
+		if (likely(_tag & IOPMU_QUEUE_REQUEST_RESULT_BIT))
+			req->header.result = IOP_RESULT_SUCCESS;
+		hptiop_finish_scsi_req(hba, (_tag >> 4) & 0xff, req);
+		break;
+
+	default:
+		break;
+	}
+}
+
+static int iop_intr_mvfrey(struct hptiop_hba *hba)
+{
+	u32 _tag, status, cptr, cur_rptr;
+	int ret = 0;
+
+	if (hba->initialized)
+		writel(0, &(hba->u.mvfrey.mu->pcie_f0_int_enable));
+
+	status = readl(&(hba->u.mvfrey.mu->f0_doorbell));
+	if (status) {
+		writel(status, &(hba->u.mvfrey.mu->f0_doorbell));
+		if (status & CPU_TO_F0_DRBL_MSG_BIT) {
+			u32 msg = readl(&(hba->u.mvfrey.mu->cpu_to_f0_msg_a));
+			dprintk("received outbound msg %x\n", msg);
+			hptiop_message_callback(hba, msg);
+		}
+		ret = 1;
+	}
+
+	status = readl(&(hba->u.mvfrey.mu->isr_cause));
+	if (status) {
+		writel(status, &(hba->u.mvfrey.mu->isr_cause));
+		do {
+			cptr = *hba->u.mvfrey.outlist_cptr & 0xff;
+			cur_rptr = hba->u.mvfrey.outlist_rptr;
+			while (cur_rptr != cptr) {
+				cur_rptr++;
+				if (cur_rptr ==	hba->u.mvfrey.list_count)
+					cur_rptr = 0;
+
+				_tag = hba->u.mvfrey.outlist[cur_rptr].val;
+				BUG_ON(!(_tag & IOPMU_QUEUE_MASK_HOST_BITS));
+				hptiop_request_callback_mvfrey(hba, _tag);
+				ret = 1;
+			}
+			hba->u.mvfrey.outlist_rptr = cur_rptr;
+		} while (cptr != (*hba->u.mvfrey.outlist_cptr & 0xff));
+	}
+
+	if (hba->initialized)
+		writel(0x1010, &(hba->u.mvfrey.mu->pcie_f0_int_enable));
+
+	return ret;
+}
+
 static int iop_send_sync_request_itl(struct hptiop_hba *hba,
 					void __iomem *_req, u32 millisec)
 {
@@ -272,6 +345,26 @@ static int iop_send_sync_request_mv(stru
 	return -1;
 }
 
+static int iop_send_sync_request_mvfrey(struct hptiop_hba *hba,
+					u32 size_bits, u32 millisec)
+{
+	struct hpt_iop_request_header *reqhdr =
+		hba->u.mvfrey.internal_req.req_virt;
+	u32 i;
+
+	hba->msg_done = 0;
+	reqhdr->flags |= cpu_to_le32(IOP_REQUEST_FLAG_SYNC_REQUEST);
+	hba->ops->post_req(hba, &(hba->u.mvfrey.internal_req));
+
+	for (i = 0; i < millisec; i++) {
+		iop_intr_mvfrey(hba);
+		if (hba->msg_done)
+			break;
+		msleep(1);
+	}
+	return hba->msg_done ? 0 : -1;
+}
+
 static void hptiop_post_msg_itl(struct hptiop_hba *hba, u32 msg)
 {
 	writel(msg, &hba->u.itl.iop->inbound_msgaddr0);
@@ -285,11 +378,18 @@ static void hptiop_post_msg_mv(struct hp
 	readl(&hba->u.mv.regs->inbound_doorbell);
 }
 
+static void hptiop_post_msg_mvfrey(struct hptiop_hba *hba, u32 msg)
+{
+	writel(msg, &(hba->u.mvfrey.mu->f0_to_cpu_msg_a));
+	readl(&(hba->u.mvfrey.mu->f0_to_cpu_msg_a));
+}
+
 static int iop_send_sync_msg(struct hptiop_hba *hba, u32 msg, u32 millisec)
 {
 	u32 i;
 
 	hba->msg_done = 0;
+	hba->ops->disable_intr(hba);
 	hba->ops->post_msg(hba, msg);
 
 	for (i = 0; i < millisec; i++) {
@@ -301,6 +401,7 @@ static int iop_send_sync_msg(struct hpti
 		msleep(1);
 	}
 
+	hba->ops->enable_intr(hba);
 	return hba->msg_done? 0 : -1;
 }
 
@@ -354,6 +455,28 @@ static int iop_get_config_mv(struct hpti
 	return 0;
 }
 
+static int iop_get_config_mvfrey(struct hptiop_hba *hba,
+				struct hpt_iop_request_get_config *config)
+{
+	struct hpt_iop_request_get_config *info = hba->u.mvfrey.config;
+
+	if (info->header.size != sizeof(struct hpt_iop_request_get_config) ||
+			info->header.type != IOP_REQUEST_TYPE_GET_CONFIG)
+		return -1;
+
+	config->interface_version = info->interface_version;
+	config->firmware_version = info->firmware_version;
+	config->max_requests = info->max_requests;
+	config->request_size = info->request_size;
+	config->max_sg_count = info->max_sg_count;
+	config->data_transfer_length = info->data_transfer_length;
+	config->alignment_mask = info->alignment_mask;
+	config->max_devices = info->max_devices;
+	config->sdram_size = info->sdram_size;
+
+	return 0;
+}
+
 static int iop_set_config_itl(struct hptiop_hba *hba,
 				struct hpt_iop_request_set_config *config)
 {
@@ -408,6 +531,29 @@ static int iop_set_config_mv(struct hpti
 	return 0;
 }
 
+static int iop_set_config_mvfrey(struct hptiop_hba *hba,
+				struct hpt_iop_request_set_config *config)
+{
+	struct hpt_iop_request_set_config *req =
+		hba->u.mvfrey.internal_req.req_virt;
+
+	memcpy(req, config, sizeof(struct hpt_iop_request_set_config));
+	req->header.flags = cpu_to_le32(IOP_REQUEST_FLAG_OUTPUT_CONTEXT);
+	req->header.type = cpu_to_le32(IOP_REQUEST_TYPE_SET_CONFIG);
+	req->header.size =
+		cpu_to_le32(sizeof(struct hpt_iop_request_set_config));
+	req->header.result = cpu_to_le32(IOP_RESULT_PENDING);
+	req->header.context = cpu_to_le32(IOP_REQUEST_TYPE_SET_CONFIG<<5);
+	req->header.context_hi32 = 0;
+
+	if (iop_send_sync_request_mvfrey(hba, 0, 20000)) {
+		dprintk("Set config send cmd failed\n");
+		return -1;
+	}
+
+	return 0;
+}
+
 static void hptiop_enable_intr_itl(struct hptiop_hba *hba)
 {
 	writel(~(IOPMU_OUTBOUND_INT_POSTQUEUE | IOPMU_OUTBOUND_INT_MSG0),
@@ -420,6 +566,13 @@ static void hptiop_enable_intr_mv(struct
 		&hba->u.mv.regs->outbound_intmask);
 }
 
+static void hptiop_enable_intr_mvfrey(struct hptiop_hba *hba)
+{
+	writel(CPU_TO_F0_DRBL_MSG_BIT, &(hba->u.mvfrey.mu->f0_doorbell_enable));
+	writel(0x1, &(hba->u.mvfrey.mu->isr_enable));
+	writel(0x1010, &(hba->u.mvfrey.mu->pcie_f0_int_enable));
+}
+
 static int hptiop_initialize_iop(struct hptiop_hba *hba)
 {
 	/* enable interrupts */
@@ -502,17 +655,39 @@ static int hptiop_map_pci_bar_mv(struct 
 	return 0;
 }
 
+static int hptiop_map_pci_bar_mvfrey(struct hptiop_hba *hba)
+{
+	hba->u.mvfrey.config = hptiop_map_pci_bar(hba, 0);
+	if (hba->u.mvfrey.config == NULL)
+		return -1;
+
+	hba->u.mvfrey.mu = hptiop_map_pci_bar(hba, 2);
+	if (hba->u.mvfrey.mu == NULL) {
+		iounmap(hba->u.mvfrey.config);
+		return -1;
+	}
+
+	return 0;
+}
+
 static void hptiop_unmap_pci_bar_mv(struct hptiop_hba *hba)
 {
 	iounmap(hba->u.mv.regs);
 	iounmap(hba->u.mv.mu);
 }
 
+static void hptiop_unmap_pci_bar_mvfrey(struct hptiop_hba *hba)
+{
+	iounmap(hba->u.mvfrey.config);
+	iounmap(hba->u.mvfrey.mu);
+}
+
 static void hptiop_message_callback(struct hptiop_hba *hba, u32 msg)
 {
 	dprintk("iop message 0x%x\n", msg);
 
-	if (msg == IOPMU_INBOUND_MSG0_NOP)
+	if (msg == IOPMU_INBOUND_MSG0_NOP ||
+		msg == IOPMU_INBOUND_MSG0_RESET_COMM)
 		hba->msg_done = 1;
 
 	if (!hba->initialized)
@@ -592,6 +767,7 @@ static void hptiop_finish_scsi_req(struc
 		memcpy(scp->sense_buffer, &req->sg_list,
 				min_t(size_t, SCSI_SENSE_BUFFERSIZE,
 					le32_to_cpu(req->dataxfer_length)));
+		goto skip_resid;
 		break;
 
 	default:
@@ -599,6 +775,10 @@ static void hptiop_finish_scsi_req(struc
 		break;
 	}
 
+	scsi_set_resid(scp,
+		scsi_bufflen(scp) - le32_to_cpu(req->dataxfer_length));
+
+skip_resid:
 	dprintk("scsi_done(%p)\n", scp);
 	scp->scsi_done(scp);
 	free_req(hba, &hba->reqs[tag]);
@@ -692,7 +872,8 @@ static int hptiop_buildsgl(struct scsi_c
 	BUG_ON(HPT_SCP(scp)->sgcnt > hba->max_sg_descriptors);
 
 	scsi_for_each_sg(scp, sg, HPT_SCP(scp)->sgcnt, idx) {
-		psg[idx].pci_address = cpu_to_le64(sg_dma_address(sg));
+		psg[idx].pci_address = cpu_to_le64(sg_dma_address(sg)) |
+			hba->ops->host_phy_flag;
 		psg[idx].size = cpu_to_le32(sg_dma_len(sg));
 		psg[idx].eot = (idx == HPT_SCP(scp)->sgcnt - 1) ?
 			cpu_to_le32(1) : 0;
@@ -751,6 +932,78 @@ static void hptiop_post_req_mv(struct hp
 		MVIOP_MU_QUEUE_ADDR_HOST_BIT | size_bit, hba);
 }
 
+static void hptiop_post_req_mvfrey(struct hptiop_hba *hba,
+					struct hptiop_request *_req)
+{
+	struct hpt_iop_request_header *reqhdr = _req->req_virt;
+	u32 index;
+
+	reqhdr->flags |= cpu_to_le32(IOP_REQUEST_FLAG_OUTPUT_CONTEXT |
+			IOP_REQUEST_FLAG_ADDR_BITS |
+			((_req->req_shifted_phy >> 11) & 0xffff0000));
+	reqhdr->context = cpu_to_le32(IOPMU_QUEUE_ADDR_HOST_BIT |
+			(_req->index << 4) | reqhdr->type);
+	reqhdr->context_hi32 = cpu_to_le32((_req->req_shifted_phy << 5) &
+			0xffffffff);
+
+	hba->u.mvfrey.inlist_wptr++;
+	index = hba->u.mvfrey.inlist_wptr & 0x3fff;
+
+	if (index == hba->u.mvfrey.list_count) {
+		index = 0;
+		hba->u.mvfrey.inlist_wptr &= ~0x3fff;
+		hba->u.mvfrey.inlist_wptr ^= CL_POINTER_TOGGLE;
+	}
+
+	hba->u.mvfrey.inlist[index].addr =
+			(dma_addr_t)_req->req_shifted_phy << 5;
+	hba->u.mvfrey.inlist[index].intrfc_len = (reqhdr->size + 3) / 4;
+	writel(hba->u.mvfrey.inlist_wptr,
+		&(hba->u.mvfrey.mu->inbound_write_ptr));
+	readl(&(hba->u.mvfrey.mu->inbound_write_ptr));
+}
+
+static int hptiop_reset_comm_itl(struct hptiop_hba *hba)
+{
+	return 0;
+}
+
+static int hptiop_reset_comm_mv(struct hptiop_hba *hba)
+{
+	return 0;
+}
+
+static int hptiop_reset_comm_mvfrey(struct hptiop_hba *hba)
+{
+	u32 list_count = hba->u.mvfrey.list_count;
+
+	if (iop_send_sync_msg(hba, IOPMU_INBOUND_MSG0_RESET_COMM, 3000))
+		return -1;
+
+	/* wait 100ms for MCU ready */
+	msleep(100);
+
+	writel(cpu_to_le32(hba->u.mvfrey.inlist_phy & 0xffffffff),
+			&(hba->u.mvfrey.mu->inbound_base));
+	writel(cpu_to_le32((hba->u.mvfrey.inlist_phy >> 16) >> 16),
+			&(hba->u.mvfrey.mu->inbound_base_high));
+
+	writel(cpu_to_le32(hba->u.mvfrey.outlist_phy & 0xffffffff),
+			&(hba->u.mvfrey.mu->outbound_base));
+	writel(cpu_to_le32((hba->u.mvfrey.outlist_phy >> 16) >> 16),
+			&(hba->u.mvfrey.mu->outbound_base_high));
+
+	writel(cpu_to_le32(hba->u.mvfrey.outlist_cptr_phy & 0xffffffff),
+			&(hba->u.mvfrey.mu->outbound_shadow_base));
+	writel(cpu_to_le32((hba->u.mvfrey.outlist_cptr_phy >> 16) >> 16),
+			&(hba->u.mvfrey.mu->outbound_shadow_base_high));
+
+	hba->u.mvfrey.inlist_wptr = (list_count - 1) | CL_POINTER_TOGGLE;
+	*hba->u.mvfrey.outlist_cptr = (list_count - 1) | CL_POINTER_TOGGLE;
+	hba->u.mvfrey.outlist_rptr = list_count - 1;
+	return 0;
+}
+
 static int hptiop_queuecommand_lck(struct scsi_cmnd *scp,
 				void (*done)(struct scsi_cmnd *))
 {
@@ -771,14 +1024,15 @@ static int hptiop_queuecommand_lck(struc
 
 	_req->scp = scp;
 
-	dprintk("hptiop_queuecmd(scp=%p) %d/%d/%d/%d cdb=(%x-%x-%x) "
+	dprintk("hptiop_queuecmd(scp=%p) %d/%d/%d/%d cdb=(%08x-%08x-%08x-%08x) "
 			"req_index=%d, req=%p\n",
 			scp,
 			host->host_no, scp->device->channel,
 			scp->device->id, scp->device->lun,
-			((u32 *)scp->cmnd)[0],
-			((u32 *)scp->cmnd)[1],
-			((u32 *)scp->cmnd)[2],
+			cpu_to_be32(((u32 *)scp->cmnd)[0]),
+			cpu_to_be32(((u32 *)scp->cmnd)[1]),
+			cpu_to_be32(((u32 *)scp->cmnd)[2]),
+			cpu_to_be32(((u32 *)scp->cmnd)[3]),
 			_req->index, _req->req_virt);
 
 	scp->result = 0;
@@ -933,6 +1187,11 @@ static struct scsi_host_template driver_
 	.change_queue_depth         = hptiop_adjust_disk_queue_depth,
 };
 
+static int hptiop_internal_memalloc_itl(struct hptiop_hba *hba)
+{
+	return 0;
+}
+
 static int hptiop_internal_memalloc_mv(struct hptiop_hba *hba)
 {
 	hba->u.mv.internal_req = dma_alloc_coherent(&hba->pcidev->dev,
@@ -943,6 +1202,63 @@ static int hptiop_internal_memalloc_mv(s
 		return -1;
 }
 
+static int hptiop_internal_memalloc_mvfrey(struct hptiop_hba *hba)
+{
+	u32 list_count = readl(&hba->u.mvfrey.mu->inbound_conf_ctl);
+	char *p;
+	dma_addr_t phy;
+
+	BUG_ON(hba->max_request_size == 0);
+
+	if (list_count == 0) {
+		BUG_ON(1);
+		return -1;
+	}
+
+	list_count >>= 16;
+
+	hba->u.mvfrey.list_count = list_count;
+	hba->u.mvfrey.internal_mem_size = 0x800 +
+			list_count * sizeof(struct mvfrey_inlist_entry) +
+			list_count * sizeof(struct mvfrey_outlist_entry) +
+			sizeof(int);
+
+	p = dma_alloc_coherent(&hba->pcidev->dev,
+			hba->u.mvfrey.internal_mem_size, &phy, GFP_KERNEL);
+	if (!p)
+		return -1;
+
+	hba->u.mvfrey.internal_req.req_virt = p;
+	hba->u.mvfrey.internal_req.req_shifted_phy = phy >> 5;
+	hba->u.mvfrey.internal_req.scp = NULL;
+	hba->u.mvfrey.internal_req.next = NULL;
+
+	p += 0x800;
+	phy += 0x800;
+
+	hba->u.mvfrey.inlist = (struct mvfrey_inlist_entry *)p;
+	hba->u.mvfrey.inlist_phy = phy;
+
+	p += list_count * sizeof(struct mvfrey_inlist_entry);
+	phy += list_count * sizeof(struct mvfrey_inlist_entry);
+
+	hba->u.mvfrey.outlist = (struct mvfrey_outlist_entry *)p;
+	hba->u.mvfrey.outlist_phy = phy;
+
+	p += list_count * sizeof(struct mvfrey_outlist_entry);
+	phy += list_count * sizeof(struct mvfrey_outlist_entry);
+
+	hba->u.mvfrey.outlist_cptr = (__le32 *)p;
+	hba->u.mvfrey.outlist_cptr_phy = phy;
+
+	return 0;
+}
+
+static int hptiop_internal_memfree_itl(struct hptiop_hba *hba)
+{
+	return 0;
+}
+
 static int hptiop_internal_memfree_mv(struct hptiop_hba *hba)
 {
 	if (hba->u.mv.internal_req) {
@@ -953,6 +1269,19 @@ static int hptiop_internal_memfree_mv(st
 		return -1;
 }
 
+static int hptiop_internal_memfree_mvfrey(struct hptiop_hba *hba)
+{
+	if (hba->u.mvfrey.internal_req.req_virt) {
+		dma_free_coherent(&hba->pcidev->dev,
+			hba->u.mvfrey.internal_mem_size,
+			hba->u.mvfrey.internal_req.req_virt,
+			(dma_addr_t)
+			hba->u.mvfrey.internal_req.req_shifted_phy << 5);
+		return 0;
+	} else
+		return -1;
+}
+
 static int __devinit hptiop_probe(struct pci_dev *pcidev,
 					const struct pci_device_id *id)
 {
@@ -1027,7 +1356,7 @@ static int __devinit hptiop_probe(struct
 		goto unmap_pci_bar;
 	}
 
-	if (hba->ops->internal_memalloc) {
+	if (hba->ops->family == MV_BASED_IOP) {
 		if (hba->ops->internal_memalloc(hba)) {
 			printk(KERN_ERR "scsi%d: internal_memalloc failed\n",
 				hba->host->host_no);
@@ -1050,6 +1379,19 @@ static int __devinit hptiop_probe(struct
 	hba->interface_version = le32_to_cpu(iop_config.interface_version);
 	hba->sdram_size = le32_to_cpu(iop_config.sdram_size);
 
+	if (hba->ops->family == MVFREY_BASED_IOP) {
+		if (hba->ops->internal_memalloc(hba)) {
+			printk(KERN_ERR "scsi%d: internal_memalloc failed\n",
+				hba->host->host_no);
+			goto unmap_pci_bar;
+		}
+		if (hba->ops->reset_comm(hba)) {
+			printk(KERN_ERR "scsi%d: reset comm failed\n",
+					hba->host->host_no);
+			goto unmap_pci_bar;
+		}
+	}
+
 	if (hba->firmware_version > 0x01020000 ||
 			hba->interface_version > 0x01020000)
 		hba->iopintf_v2 = 1;
@@ -1104,14 +1446,13 @@ static int __devinit hptiop_probe(struct
 	hba->dma_coherent = start_virt;
 	hba->dma_coherent_handle = start_phy;
 
-	if ((start_phy & 0x1f) != 0)
-	{
+	if ((start_phy & 0x1f) != 0) {
 		offset = ((start_phy + 0x1f) & ~0x1f) - start_phy;
 		start_phy += offset;
 		start_virt += offset;
 	}
 
-	hba->req_list = start_virt;
+	hba->req_list = NULL;
 	for (i = 0; i < hba->max_requests; i++) {
 		hba->reqs[i].next = NULL;
 		hba->reqs[i].req_virt = start_virt;
@@ -1132,7 +1473,6 @@ static int __devinit hptiop_probe(struct
 		goto free_request_mem;
 	}
 
-
 	scsi_scan_host(host);
 
 	dprintk("scsi%d: hptiop_probe successfully\n", hba->host->host_no);
@@ -1147,8 +1487,7 @@ free_request_irq:
 	free_irq(hba->pcidev->irq, hba);
 
 unmap_pci_bar:
-	if (hba->ops->internal_memfree)
-		hba->ops->internal_memfree(hba);
+	hba->ops->internal_memfree(hba);
 
 	hba->ops->unmap_pci_bar(hba);
 
@@ -1198,6 +1537,16 @@ static void hptiop_disable_intr_mv(struc
 	readl(&hba->u.mv.regs->outbound_intmask);
 }
 
+static void hptiop_disable_intr_mvfrey(struct hptiop_hba *hba)
+{
+	writel(0, &(hba->u.mvfrey.mu->f0_doorbell_enable));
+	readl(&(hba->u.mvfrey.mu->f0_doorbell_enable));
+	writel(0, &(hba->u.mvfrey.mu->isr_enable));
+	readl(&(hba->u.mvfrey.mu->isr_enable));
+	writel(0, &(hba->u.mvfrey.mu->pcie_f0_int_enable));
+	readl(&(hba->u.mvfrey.mu->pcie_f0_int_enable));
+}
+
 static void hptiop_remove(struct pci_dev *pcidev)
 {
 	struct Scsi_Host *host = pci_get_drvdata(pcidev);
@@ -1216,8 +1565,7 @@ static void hptiop_remove(struct pci_dev
 			hba->dma_coherent,
 			hba->dma_coherent_handle);
 
-	if (hba->ops->internal_memfree)
-		hba->ops->internal_memfree(hba);
+	hba->ops->internal_memfree(hba);
 
 	hba->ops->unmap_pci_bar(hba);
 
@@ -1229,9 +1577,10 @@ static void hptiop_remove(struct pci_dev
 }
 
 static struct hptiop_adapter_ops hptiop_itl_ops = {
+	.family            = INTEL_BASED_IOP,
 	.iop_wait_ready    = iop_wait_ready_itl,
-	.internal_memalloc = NULL,
-	.internal_memfree  = NULL,
+	.internal_memalloc = hptiop_internal_memalloc_itl,
+	.internal_memfree  = hptiop_internal_memfree_itl,
 	.map_pci_bar       = hptiop_map_pci_bar_itl,
 	.unmap_pci_bar     = hptiop_unmap_pci_bar_itl,
 	.enable_intr       = hptiop_enable_intr_itl,
@@ -1242,9 +1591,12 @@ static struct hptiop_adapter_ops hptiop_
 	.post_msg          = hptiop_post_msg_itl,
 	.post_req          = hptiop_post_req_itl,
 	.hw_dma_bit_mask   = 64,
+	.reset_comm        = hptiop_reset_comm_itl,
+	.host_phy_flag     = cpu_to_le64(0),
 };
 
 static struct hptiop_adapter_ops hptiop_mv_ops = {
+	.family            = MV_BASED_IOP,
 	.iop_wait_ready    = iop_wait_ready_mv,
 	.internal_memalloc = hptiop_internal_memalloc_mv,
 	.internal_memfree  = hptiop_internal_memfree_mv,
@@ -1258,6 +1610,27 @@ static struct hptiop_adapter_ops hptiop_
 	.post_msg          = hptiop_post_msg_mv,
 	.post_req          = hptiop_post_req_mv,
 	.hw_dma_bit_mask   = 33,
+	.reset_comm        = hptiop_reset_comm_mv,
+	.host_phy_flag     = cpu_to_le64(0),
+};
+
+static struct hptiop_adapter_ops hptiop_mvfrey_ops = {
+	.family            = MVFREY_BASED_IOP,
+	.iop_wait_ready    = iop_wait_ready_mvfrey,
+	.internal_memalloc = hptiop_internal_memalloc_mvfrey,
+	.internal_memfree  = hptiop_internal_memfree_mvfrey,
+	.map_pci_bar       = hptiop_map_pci_bar_mvfrey,
+	.unmap_pci_bar     = hptiop_unmap_pci_bar_mvfrey,
+	.enable_intr       = hptiop_enable_intr_mvfrey,
+	.disable_intr      = hptiop_disable_intr_mvfrey,
+	.get_config        = iop_get_config_mvfrey,
+	.set_config        = iop_set_config_mvfrey,
+	.iop_intr          = iop_intr_mvfrey,
+	.post_msg          = hptiop_post_msg_mvfrey,
+	.post_req          = hptiop_post_req_mvfrey,
+	.hw_dma_bit_mask   = 64,
+	.reset_comm        = hptiop_reset_comm_mvfrey,
+	.host_phy_flag     = cpu_to_le64(1),
 };
 
 static struct pci_device_id hptiop_id_table[] = {
@@ -1283,6 +1656,8 @@ static struct pci_device_id hptiop_id_ta
 	{ PCI_VDEVICE(TTI, 0x3120), (kernel_ulong_t)&hptiop_mv_ops },
 	{ PCI_VDEVICE(TTI, 0x3122), (kernel_ulong_t)&hptiop_mv_ops },
 	{ PCI_VDEVICE(TTI, 0x3020), (kernel_ulong_t)&hptiop_mv_ops },
+	{ PCI_VDEVICE(TTI, 0x4520), (kernel_ulong_t)&hptiop_mvfrey_ops },
+	{ PCI_VDEVICE(TTI, 0x4522), (kernel_ulong_t)&hptiop_mvfrey_ops },
 	{},
 };
 
diff -puN drivers/scsi/hptiop.h~hptiop-support-highpoint-rr4520-rr4522-hba drivers/scsi/hptiop.h
--- a/drivers/scsi/hptiop.h~hptiop-support-highpoint-rr4520-rr4522-hba
+++ a/drivers/scsi/hptiop.h
@@ -1,6 +1,6 @@
 /*
  * HighPoint RR3xxx/4xxx controller driver for Linux
- * Copyright (C) 2006-2009 HighPoint Technologies, Inc. All Rights Reserved.
+ * Copyright (C) 2006-2012 HighPoint Technologies, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -75,6 +75,45 @@ struct hpt_iopmv_regs {
 	__le32 outbound_intmask;
 };
 
+#pragma pack(1)
+struct hpt_iopmu_mvfrey {
+	__le32 reserved0[(0x4000 - 0) / 4];
+	__le32 inbound_base;
+	__le32 inbound_base_high;
+	__le32 reserved1[(0x4018 - 0x4008) / 4];
+	__le32 inbound_write_ptr;
+	__le32 reserved2[(0x402c - 0x401c) / 4];
+	__le32 inbound_conf_ctl;
+	__le32 reserved3[(0x4050 - 0x4030) / 4];
+	__le32 outbound_base;
+	__le32 outbound_base_high;
+	__le32 outbound_shadow_base;
+	__le32 outbound_shadow_base_high;
+	__le32 reserved4[(0x4088 - 0x4060) / 4];
+	__le32 isr_cause;
+	__le32 isr_enable;
+	__le32 reserved5[(0x1020c - 0x4090) / 4];
+	__le32 pcie_f0_int_enable;
+	__le32 reserved6[(0x10400 - 0x10210) / 4];
+	__le32 f0_to_cpu_msg_a;
+	__le32 reserved7[(0x10420 - 0x10404) / 4];
+	__le32 cpu_to_f0_msg_a;
+	__le32 reserved8[(0x10480 - 0x10424) / 4];
+	__le32 f0_doorbell;
+	__le32 f0_doorbell_enable;
+};
+
+struct mvfrey_inlist_entry {
+	dma_addr_t addr;
+	__le32 intrfc_len;
+	__le32 reserved;
+};
+
+struct mvfrey_outlist_entry {
+	__le32 val;
+};
+#pragma pack()
+
 #define MVIOP_MU_QUEUE_ADDR_HOST_MASK   (~(0x1full))
 #define MVIOP_MU_QUEUE_ADDR_HOST_BIT    4
 
@@ -87,6 +126,9 @@ struct hpt_iopmv_regs {
 #define MVIOP_MU_OUTBOUND_INT_MSG       1
 #define MVIOP_MU_OUTBOUND_INT_POSTQUEUE 2
 
+#define CL_POINTER_TOGGLE        0x00004000
+#define CPU_TO_F0_DRBL_MSG_BIT   0x02000000
+
 enum hpt_iopmu_message {
 	/* host-to-iop messages */
 	IOPMU_INBOUND_MSG0_NOP = 0,
@@ -95,6 +137,7 @@ enum hpt_iopmu_message {
 	IOPMU_INBOUND_MSG0_SHUTDOWN,
 	IOPMU_INBOUND_MSG0_STOP_BACKGROUND_TASK,
 	IOPMU_INBOUND_MSG0_START_BACKGROUND_TASK,
+	IOPMU_INBOUND_MSG0_RESET_COMM,
 	IOPMU_INBOUND_MSG0_MAX = 0xff,
 	/* iop-to-host messages */
 	IOPMU_OUTBOUND_MSG0_REGISTER_DEVICE_0 = 0x100,
@@ -118,6 +161,7 @@ struct hpt_iop_request_header {
 #define IOP_REQUEST_FLAG_BIST_REQUEST 2
 #define IOP_REQUEST_FLAG_REMAPPED     4
 #define IOP_REQUEST_FLAG_OUTPUT_CONTEXT 8
+#define IOP_REQUEST_FLAG_ADDR_BITS 0x40 /* flags[31:16] is phy_addr[47:32] */
 
 enum hpt_iop_request_type {
 	IOP_REQUEST_TYPE_GET_CONFIG = 0,
@@ -223,6 +267,13 @@ struct hpt_scsi_pointer {
 
 #define HPT_SCP(scp) ((struct hpt_scsi_pointer *)&(scp)->SCp)
 
+enum hptiop_family {
+	UNKNOWN_BASED_IOP,
+	INTEL_BASED_IOP,
+	MV_BASED_IOP,
+	MVFREY_BASED_IOP
+} ;
+
 struct hptiop_hba {
 	struct hptiop_adapter_ops *ops;
 	union {
@@ -236,6 +287,22 @@ struct hptiop_hba {
 			void *internal_req;
 			dma_addr_t internal_req_phy;
 		} mv;
+		struct {
+			struct hpt_iop_request_get_config __iomem *config;
+			struct hpt_iopmu_mvfrey __iomem *mu;
+
+			int internal_mem_size;
+			struct hptiop_request internal_req;
+			int list_count;
+			struct mvfrey_inlist_entry *inlist;
+			dma_addr_t inlist_phy;
+			__le32 inlist_wptr;
+			struct mvfrey_outlist_entry *outlist;
+			dma_addr_t outlist_phy;
+			__le32 *outlist_cptr; /* copy pointer shadow */
+			dma_addr_t outlist_cptr_phy;
+			__le32 outlist_rptr;
+		} mvfrey;
 	} u;
 
 	struct Scsi_Host *host;
@@ -283,6 +350,7 @@ struct hpt_ioctl_k {
 };
 
 struct hptiop_adapter_ops {
+	enum hptiop_family family;
 	int  (*iop_wait_ready)(struct hptiop_hba *hba, u32 millisec);
 	int  (*internal_memalloc)(struct hptiop_hba *hba);
 	int  (*internal_memfree)(struct hptiop_hba *hba);
@@ -298,6 +366,8 @@ struct hptiop_adapter_ops {
 	void (*post_msg)(struct hptiop_hba *hba, u32 msg);
 	void (*post_req)(struct hptiop_hba *hba, struct hptiop_request *_req);
 	int  hw_dma_bit_mask;
+	int  (*reset_comm)(struct hptiop_hba *hba);
+	__le64  host_phy_flag;
 };
 
 #define HPT_IOCTL_RESULT_OK         0
_
