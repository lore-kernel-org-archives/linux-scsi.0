From: "Ed Lin" <ed.lin@promise.com>
Subject: [PATCH 4/5] stex:add new controller support
Date: Tue, 31 Mar 2009 17:30:36 -0800
Message-ID: <200903311730360726094@promise.com>
Reply-To: ed.lin@promise.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.promise.com ([67.111.72.2]:21550 "EHLO
	nonamew.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751388AbZDAApi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Mar 2009 20:45:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, promise_linux <promise_linux@promise.com>

This adds the support of a new SAS 6G controller (st_yel)

Signed-off-by: Ed Lin <ed.lin@promise.com>
---

 drivers/scsi/stex.c |  382 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 351 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 75f5079..4e2b2af 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -55,6 +55,13 @@ enum {
 	OIS	= 0x30,	/* MU_OUTBOUND_INTERRUPT_STATUS */
 	OIM	= 0x3c,	/* MU_OUTBOUND_INTERRUPT_MASK */
 
+	YH2I_INT				= 0x20,
+	YINT_EN					= 0x34,
+	YI2H_INT				= 0x9c,
+	YI2H_INT_C				= 0xa0,
+	YH2I_REQ				= 0xc0,
+	YH2I_REQ_HI				= 0xc4,
+
 	/* MU register value */
 	MU_INBOUND_DOORBELL_HANDSHAKE		= 1,
 	MU_INBOUND_DOORBELL_REQHEADCHANGED	= 2,
@@ -95,9 +102,14 @@ enum {
 	TASK_ATTRIBUTE_ORDERED			= 0x2,
 	TASK_ATTRIBUTE_ACA			= 0x4,
 
+	SS_STS_NORMAL				= 0x80000000,
+	SS_STS_DONE				= 0x40000000,
+	SS_STS_HANDSHAKE			= 0x20000000,
+
+	SS_HEAD_HANDSHAKE			= 0x80,
+
 	STEX_CDB_LENGTH				= 16,
 	STATUS_VAR_LEN				= 128,
-	ST_MAX_SG				= 32,
 
 	/* sg flags */
 	SG_CF_EOT				= 0x80,	/* end of table */
@@ -111,6 +123,7 @@ enum {
 	st_vsc					= 1,
 	st_yosemite				= 2,
 	st_seq					= 3,
+	st_yel					= 4,
 
 	PASSTHRU_REQ_TYPE			= 0x00000001,
 	PASSTHRU_REQ_NO_WAKEUP			= 0x00000100,
@@ -151,12 +164,26 @@ struct st_sgitem {
 	__le64 addr;
 };
 
+struct st_ss_sgitem {
+	__le32 addr;
+	__le32 addr_hi;
+	__le32 count;
+};
+
 struct st_sgtable {
 	__le16 sg_count;
 	__le16 max_sg_count;
 	__le32 sz_in_byte;
 };
 
+struct st_msg_header {
+	__le64 handle;
+	u8 flag;
+	u8 channel;
+	__le16 timeout;
+	u32 reserved;
+};
+
 struct handshake_frame {
 	__le64 rb_phy;		/* request payload queue physical address */
 	__le16 req_sz;		/* size of each request payload */
@@ -172,7 +199,8 @@ struct handshake_frame {
 	__le32 partner_ver_build;
 	__le32 extra_offset;	/* NEW */
 	__le32 extra_size;	/* NEW */
-	u32 reserved1[2];
+	__le32 scratch_size;
+	u32 reserved1;
 };
 
 struct req_msg {
@@ -263,6 +291,10 @@ struct st_hba {
 	struct Scsi_Host *host;
 	struct pci_dev *pdev;
 
+	struct req_msg * (*alloc_rq) (struct st_hba *);
+	int (*map_sg)(struct st_hba *, struct req_msg *, struct st_ccb *);
+	void (*send) (struct st_hba *, struct req_msg *, u16);
+
 	u32 req_head;
 	u32 req_tail;
 	u32 status_head;
@@ -272,6 +304,7 @@ struct st_hba {
 	void *copy_buffer; /* temp buffer for driver-handled commands */
 	struct st_ccb *ccb;
 	struct st_ccb *wait_ccb;
+	__le32 *scratch;
 
 	unsigned int mu_status;
 	unsigned int cardtype;
@@ -284,6 +317,9 @@ struct st_hba {
 };
 
 struct st_card_info {
+	struct req_msg * (*alloc_rq) (struct st_hba *);
+	int (*map_sg)(struct st_hba *, struct req_msg *, struct st_ccb *);
+	void (*send) (struct st_hba *, struct req_msg *, u16);
 	unsigned int max_id;
 	unsigned int max_lun;
 	unsigned int max_channel;
@@ -352,6 +388,12 @@ static struct req_msg *stex_alloc_req(struct st_hba *hba)
 	return req;
 }
 
+static struct req_msg *stex_ss_alloc_req(struct st_hba *hba)
+{
+	return (struct req_msg *)(hba->dma_mem +
+		hba->req_head * hba->rq_size + sizeof(struct st_msg_header));
+}
+
 static int stex_map_sg(struct st_hba *hba,
 	struct req_msg *req, struct st_ccb *ccb)
 {
@@ -384,6 +426,39 @@ static int stex_map_sg(struct st_hba *hba,
 	return nseg;
 }
 
+static int stex_ss_map_sg(struct st_hba *hba,
+	struct req_msg *req, struct st_ccb *ccb)
+{
+	struct scsi_cmnd *cmd;
+	struct scatterlist *sg;
+	struct st_sgtable *dst;
+	struct st_ss_sgitem *table;
+	int i, nseg;
+
+	cmd = ccb->cmd;
+	nseg = scsi_dma_map(cmd);
+	BUG_ON(nseg < 0);
+	if (nseg) {
+		dst = (struct st_sgtable *)req->variable;
+
+		ccb->sg_count = nseg;
+		dst->sg_count = cpu_to_le16((u16)nseg);
+		dst->max_sg_count = cpu_to_le16(hba->host->sg_tablesize);
+		dst->sz_in_byte = cpu_to_le32(scsi_bufflen(cmd));
+
+		table = (struct st_ss_sgitem *)(dst + 1);
+		scsi_for_each_sg(cmd, sg, nseg, i) {
+			table[i].count = cpu_to_le32((u32)sg_dma_len(sg));
+			table[i].addr =
+				cpu_to_le32(sg_dma_address(sg) & 0xffffffff);
+			table[i].addr_hi =
+				cpu_to_le32((sg_dma_address(sg) >> 16) >> 16);
+		}
+	}
+
+	return nseg;
+}
+
 static void stex_controller_info(struct st_hba *hba, struct st_ccb *ccb)
 {
 	struct st_frame *p;
@@ -424,6 +499,37 @@ stex_send_cmd(struct st_hba *hba, struct req_msg *req, u16 tag)
 	readl(hba->mmio_base + IDBL); /* flush */
 }
 
+static void
+stex_ss_send_cmd(struct st_hba *hba, struct req_msg *req, u16 tag)
+{
+	struct scsi_cmnd *cmd;
+	struct st_msg_header *msg_h;
+	dma_addr_t addr;
+
+	req->tag = cpu_to_le16(tag);
+
+	hba->ccb[tag].req = req;
+	hba->out_req_cnt++;
+
+	cmd = hba->ccb[tag].cmd;
+	msg_h = (struct st_msg_header *)req - 1;
+	if (likely(cmd)) {
+		msg_h->channel = (u8)cmd->device->channel;
+		msg_h->timeout = cpu_to_le16(cmd->request->timeout/HZ);
+	}
+	addr = hba->dma_handle + hba->req_head * hba->rq_size;
+	addr += (hba->ccb[tag].sg_count+4)/11;
+	msg_h->handle = cpu_to_le64(addr);
+
+	++hba->req_head;
+	hba->req_head %= hba->rq_count+1;
+
+	writel((addr >> 16) >> 16, hba->mmio_base + YH2I_REQ_HI);
+	readl(hba->mmio_base + YH2I_REQ_HI); /* flush */
+	writel(addr, hba->mmio_base + YH2I_REQ);
+	readl(hba->mmio_base + YH2I_REQ); /* flush */
+}
+
 static int
 stex_slave_alloc(struct scsi_device *sdev)
 {
@@ -504,7 +610,8 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 	case INQUIRY:
 		if (id != host->max_id - 1)
 			break;
-		if (lun == 0 && (cmd->cmnd[1] & INQUIRY_EVPD) == 0) {
+		if (!lun && !cmd->device->channel &&
+			(cmd->cmnd[1] & INQUIRY_EVPD) == 0) {
 			scsi_sg_copy_from_buffer(cmd, (void *)console_inq_page,
 						 sizeof(console_inq_page));
 			cmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
@@ -542,7 +649,7 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 	if (unlikely(tag >= host->can_queue))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
-	req = stex_alloc_req(hba);
+	req = hba->alloc_rq(hba);
 
 	req->lun = lun;
 	req->target = id;
@@ -561,10 +668,12 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 	hba->ccb[tag].sense_bufflen = SCSI_SENSE_BUFFERSIZE;
 	hba->ccb[tag].sense_buffer = cmd->sense_buffer;
 
-	if (cmd->sc_data_direction != DMA_NONE)
-		stex_map_sg(hba, req, &hba->ccb[tag]);
+	if (!hba->map_sg(hba, req, &hba->ccb[tag])) {
+		hba->ccb[tag].sg_count = 0;
+		memset(&req->variable[0], 0, 8);
+	}
 
-	stex_send_cmd(hba, req, tag);
+	hba->send(hba, req, tag);
 	return 0;
 }
 
@@ -746,7 +855,103 @@ static irqreturn_t stex_intr(int irq, void *__hba)
 	return IRQ_RETVAL(handled);
 }
 
-static int stex_handshake(struct st_hba *hba)
+static void stex_ss_mu_intr(struct st_hba *hba)
+{
+	struct status_msg *resp;
+	struct st_ccb *ccb;
+	__le32 *scratch;
+	unsigned int size;
+	int count = 0;
+	u32 value;
+	u16 tag;
+
+	if (unlikely(hba->out_req_cnt <= 0 ||
+			hba->mu_status == MU_STATE_RESETTING))
+		return;
+
+	while (count < hba->sts_count) {
+		scratch = hba->scratch + hba->status_tail;
+		value = le32_to_cpu(*scratch);
+		if (unlikely(!(value & SS_STS_NORMAL)))
+			return;
+
+		resp = hba->status_buffer + hba->status_tail;
+		*scratch = 0;
+		++count;
+		++hba->status_tail;
+		hba->status_tail %= hba->sts_count+1;
+
+		tag = (u16)value;
+		if (unlikely(tag >= hba->host->can_queue)) {
+			printk(KERN_WARNING DRV_NAME
+					"(%s): invalid tag\n", pci_name(hba->pdev));
+			continue;
+		}
+
+		hba->out_req_cnt--;
+		ccb = &hba->ccb[tag];
+		if (unlikely(hba->wait_ccb == ccb))
+			hba->wait_ccb = NULL;
+		if (unlikely(ccb->req == NULL)) {
+			printk(KERN_WARNING DRV_NAME
+				"(%s): lagging req\n", pci_name(hba->pdev));
+			continue;
+		}
+
+		ccb->req = NULL;
+		if (likely(value & SS_STS_DONE)) { /* normal case */
+			ccb->srb_status = SRB_STATUS_SUCCESS;
+			ccb->scsi_status = SAM_STAT_GOOD;
+		} else {
+			ccb->srb_status = resp->srb_status;
+			ccb->scsi_status = resp->scsi_status;
+			size = resp->payload_sz * sizeof(u32);
+			if (unlikely(size < sizeof(*resp) - STATUS_VAR_LEN ||
+				size > sizeof(*resp))) {
+				printk(KERN_WARNING DRV_NAME
+					"(%s): bad status size\n",
+					pci_name(hba->pdev));
+			} else {
+				size -= sizeof(*resp) - STATUS_VAR_LEN;
+				if (size)
+					stex_copy_data(ccb, resp, size);
+			}
+			if (likely(ccb->cmd != NULL))
+				stex_check_cmd(hba, ccb, resp);
+		}
+
+		if (likely(ccb->cmd != NULL)) {
+			scsi_dma_unmap(ccb->cmd);
+			stex_scsi_done(ccb);
+		} else
+			ccb->req_type = 0;
+	}
+}
+
+static irqreturn_t stex_ss_intr(int irq, void *__hba)
+{
+	struct st_hba *hba = __hba;
+	void __iomem *base = hba->mmio_base;
+	u32 data;
+	unsigned long flags;
+	int handled = 0;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+
+	data = readl(base + YI2H_INT);
+	if (data && data != 0xffffffff) {
+		/* clear the interrupt */
+		writel(data, base + YI2H_INT_C);
+		stex_ss_mu_intr(hba);
+		handled = 1;
+	}
+
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	return IRQ_RETVAL(handled);
+}
+
+static int stex_common_handshake(struct st_hba *hba)
 {
 	void __iomem *base = hba->mmio_base;
 	struct handshake_frame *h;
@@ -827,10 +1032,79 @@ static int stex_handshake(struct st_hba *hba)
 	readl(base + IMR1);
 	writel(0, base + OMR1);
 	readl(base + OMR1); /* flush */
-	hba->mu_status = MU_STATE_STARTED;
 	return 0;
 }
 
+static int stex_ss_handshake(struct st_hba *hba)
+{
+	void __iomem *base = hba->mmio_base;
+	struct st_msg_header *msg_h;
+	struct handshake_frame *h;
+	__le32 *scratch = hba->scratch;
+	u32 data;
+	unsigned long before;
+	int ret = 0;
+
+	h = (struct handshake_frame *)(hba->alloc_rq(hba));
+	msg_h = (struct st_msg_header *)h - 1;
+	msg_h->handle = cpu_to_le64(hba->dma_handle);
+	msg_h->flag = SS_HEAD_HANDSHAKE;
+
+	h->rb_phy = cpu_to_le64(hba->dma_handle);
+	h->req_sz = cpu_to_le16(hba->rq_size);
+	h->req_cnt = cpu_to_le16(hba->rq_count+1);
+	h->status_sz = cpu_to_le16(sizeof(struct status_msg));
+	h->status_cnt = cpu_to_le16(hba->sts_count+1);
+	stex_gettime(&h->hosttime);
+	h->partner_type = HMU_PARTNER_TYPE;
+	h->extra_offset = h->extra_size = 0;
+	h->scratch_size = cpu_to_le32((hba->sts_count+1)*sizeof(u32));
+
+	data = readl(base + YINT_EN);
+	data &= ~4;
+	writel(data, base + YINT_EN);
+	writel((hba->dma_handle >> 16) >> 16, base + YH2I_REQ_HI);
+	writel(hba->dma_handle, base + YH2I_REQ);
+
+	scratch = hba->scratch;
+	before = jiffies;
+	while (!(le32_to_cpu(*scratch) & SS_STS_HANDSHAKE)) {
+		if (time_after(jiffies, before + MU_MAX_DELAY * HZ)) {
+			printk(KERN_ERR DRV_NAME
+				"(%s): no signature after handshake frame\n",
+				pci_name(hba->pdev));
+			ret = -1;
+			break;
+		}
+		rmb();
+		msleep(1);
+	}
+
+	*scratch = 0;
+	msg_h->flag = 0;
+	return ret;
+}
+
+static int stex_handshake(struct st_hba *hba)
+{
+	int err;
+	unsigned long flags;
+
+	err = (hba->cardtype == st_yel) ?
+		stex_ss_handshake(hba) : stex_common_handshake(hba);
+	if (err == 0) {
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		hba->req_head = 0;
+		hba->req_tail = 0;
+		hba->status_head = 0;
+		hba->status_tail = 0;
+		hba->out_req_cnt = 0;
+		hba->mu_status = MU_STATE_STARTED;
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+	}
+	return err;
+}
+
 static int stex_abort(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host = cmd->device->host;
@@ -859,15 +1133,23 @@ static int stex_abort(struct scsi_cmnd *cmd)
 			goto out;
 	}
 
-	data = readl(base + ODBL);
-	if (data == 0 || data == 0xffffffff)
-		goto fail_out;
+	if (hba->cardtype == st_yel) {
+		data = readl(base + YI2H_INT);
+		if (data == 0 || data == 0xffffffff)
+			goto fail_out;
 
-	writel(data, base + ODBL);
-	readl(base + ODBL); /* flush */
+		writel(data, base + YI2H_INT_C);
+		stex_ss_mu_intr(hba);
+	} else {
+		data = readl(base + ODBL);
+		if (data == 0 || data == 0xffffffff)
+			goto fail_out;
 
-	stex_mu_intr(hba, data);
+		writel(data, base + ODBL);
+		readl(base + ODBL); /* flush */
 
+		stex_mu_intr(hba, data);
+	}
 	if (hba->wait_ccb == NULL) {
 		printk(KERN_WARNING DRV_NAME
 			"(%s): lost interrupt\n", pci_name(hba->pdev));
@@ -947,13 +1229,6 @@ static int stex_reset(struct scsi_cmnd *cmd)
 				pci_name(hba->pdev));
 			return FAILED;
 		}
-		spin_lock_irqsave(hba->host->host_lock, flags);
-		hba->req_head = 0;
-		hba->req_tail = 0;
-		hba->status_head = 0;
-		hba->status_tail = 0;
-		hba->out_req_cnt = 0;
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
 		return SUCCESS;
 	}
 
@@ -1021,7 +1296,6 @@ static struct scsi_host_template driver_template = {
 	.eh_abort_handler		= stex_abort,
 	.eh_host_reset_handler		= stex_reset,
 	.this_id			= -1,
-	.sg_tablesize			= ST_MAX_SG,
 };
 
 static struct pci_device_id stex_pci_tbl[] = {
@@ -1039,10 +1313,14 @@ static struct pci_device_id stex_pci_tbl[] = {
 	{ 0x105a, 0x7250, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_vsc },
 
 	/* st_yosemite */
-	{ 0x105a, 0x8650, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_yosemite },
+	{ 0x105a, 0x8650, 0x105a, PCI_ANY_ID, 0, 0, st_yosemite },
 
 	/* st_seq */
 	{ 0x105a, 0x3360, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_seq },
+
+	/* st_yel */
+	{ 0x105a, 0x8650, 0x1033, PCI_ANY_ID, 0, 0, st_yel },
+	{ 0x105a, 0x8760, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_yel },
 	{ }	/* terminate list */
 };
 
@@ -1055,6 +1333,9 @@ static struct st_card_info stex_card_info[] = {
 		.rq_count	= 32,
 		.rq_size	= 1048,
 		.sts_count	= 32,
+		.alloc_rq	= stex_alloc_req,
+		.map_sg		= stex_map_sg,
+		.send		= stex_send_cmd,
 	},
 
 	/* st_vsc */
@@ -1065,6 +1346,9 @@ static struct st_card_info stex_card_info[] = {
 		.rq_count	= 32,
 		.rq_size	= 1048,
 		.sts_count	= 32,
+		.alloc_rq	= stex_alloc_req,
+		.map_sg		= stex_map_sg,
+		.send		= stex_send_cmd,
 	},
 
 	/* st_yosemite */
@@ -1075,6 +1359,9 @@ static struct st_card_info stex_card_info[] = {
 		.rq_count	= 256,
 		.rq_size	= 1048,
 		.sts_count	= 256,
+		.alloc_rq	= stex_alloc_req,
+		.map_sg		= stex_map_sg,
+		.send		= stex_send_cmd,
 	},
 
 	/* st_seq */
@@ -1085,6 +1372,22 @@ static struct st_card_info stex_card_info[] = {
 		.rq_count	= 32,
 		.rq_size	= 1048,
 		.sts_count	= 32,
+		.alloc_rq	= stex_alloc_req,
+		.map_sg		= stex_map_sg,
+		.send		= stex_send_cmd,
+	},
+
+	/* st_yel */
+	{
+		.max_id		= 129,
+		.max_lun	= 256,
+		.max_channel	= 3,
+		.rq_count	= 801,
+		.rq_size	= 512,
+		.sts_count	= 801,
+		.alloc_rq	= stex_ss_alloc_req,
+		.map_sg		= stex_ss_map_sg,
+		.send		= stex_ss_send_cmd,
 	},
 };
 
@@ -1117,7 +1420,8 @@ static int stex_request_irq(struct st_hba *hba)
 	} else
 		hba->msi_enabled = 0;
 
-	status = request_irq(pdev->irq, stex_intr, IRQF_SHARED, DRV_NAME, hba);
+	status = request_irq(pdev->irq, hba->cardtype == st_yel ?
+		stex_ss_intr : stex_intr, IRQF_SHARED, DRV_NAME, hba);
 
 	if (status != 0) {
 		if (hba->msi_enabled)
@@ -1141,7 +1445,7 @@ stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct st_hba *hba;
 	struct Scsi_Host *host;
 	const struct st_card_info *ci = NULL;
-	u32 sts_offset, cp_offset;
+	u32 sts_offset, cp_offset, scratch_offset;
 	int err;
 
 	err = pci_enable_device(pdev);
@@ -1186,7 +1490,9 @@ stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	hba->cardtype = (unsigned int) id->driver_data;
 	ci = &stex_card_info[hba->cardtype];
-	sts_offset = (ci->rq_count+1) * ci->rq_size;
+	sts_offset = scratch_offset = (ci->rq_count+1) * ci->rq_size;
+	if (hba->cardtype == st_yel)
+		sts_offset += (ci->sts_count+1) * sizeof(u32);
 	cp_offset = sts_offset + (ci->sts_count+1) * sizeof(struct status_msg);
 	hba->dma_size = cp_offset + sizeof(struct st_frame);
 	if (hba->cardtype == st_seq ||
@@ -1211,13 +1517,22 @@ stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_pci_free;
 	}
 
+	if (hba->cardtype == st_yel)
+		hba->scratch = (__le32 *)(hba->dma_mem + scratch_offset);
 	hba->status_buffer = (struct status_msg *)(hba->dma_mem + sts_offset);
 	hba->copy_buffer = hba->dma_mem + cp_offset;
 	hba->rq_count = ci->rq_count;
 	hba->rq_size = ci->rq_size;
 	hba->sts_count = ci->sts_count;
+	hba->alloc_rq = ci->alloc_rq;
+	hba->map_sg = ci->map_sg;
+	hba->send = ci->send;
 	hba->mu_status = MU_STATE_STARTING;
 
+	if (hba->cardtype == st_yel)
+		host->sg_tablesize = 38;
+	else
+		host->sg_tablesize = 32;
 	host->can_queue = ci->rq_count;
 	host->cmd_per_lun = ci->rq_count;
 	host->max_id = ci->max_id;
@@ -1282,15 +1597,20 @@ out_disable:
 static void stex_hba_stop(struct st_hba *hba)
 {
 	struct req_msg *req;
+	struct st_msg_header *msg_h;
 	unsigned long flags;
 	unsigned long before;
 	u16 tag = 0;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	req = stex_alloc_req(hba);
-	memset(req->cdb, 0, STEX_CDB_LENGTH);
+	req = hba->alloc_rq(hba);
+	if (hba->cardtype == st_yel) {
+		msg_h = (struct st_msg_header *)req - 1;
+		memset(msg_h, 0, hba->rq_size);
+	} else
+		memset(req, 0, hba->rq_size);
 
-	if (hba->cardtype == st_yosemite) {
+	if (hba->cardtype == st_yosemite || hba->cardtype == st_yel) {
 		req->cdb[0] = MGT_CMD;
 		req->cdb[1] = MGT_CMD_SIGNATURE;
 		req->cdb[2] = CTLR_CONFIG_CMD;
@@ -1307,7 +1627,7 @@ static void stex_hba_stop(struct st_hba *hba)
 	hba->ccb[tag].sense_buffer = NULL;
 	hba->ccb[tag].req_type = PASSTHRU_REQ_TYPE;
 
-	stex_send_cmd(hba, req, tag);
+	hba->send(hba, req, tag);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	before = jiffies;


