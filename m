From: "Ed Lin" <ed.lin@promise.com>
Subject: [PATCH 1/5] stex:small code fixes and changes
Date: Tue, 31 Mar 2009 17:30:19 -0800
Message-ID: <200903311730191353099@promise.com>
Reply-To: ed.lin@promise.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.promise.com ([67.111.72.2]:21550 "EHLO
	nonamew.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752591AbZDAApk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Mar 2009 20:45:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, promise_linux <promise_linux@promise.com>

These are some small code fixes and changes, including:
- use 64 bit when possible
- remove some unnecessary code (in interrupt, queuecommand routine etc.)
- code change for reset handler

Signed-off-by: Ed Lin <ed.lin@promise.com>
---

 drivers/scsi/stex.c |  125 ++++++++++++++++++++++++--------------------------
 1 files changed, 60 insertions(+), 65 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 47b614e..de6c30e 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -160,26 +160,22 @@ struct st_sgitem {
 	u8 ctrl;	/* SG_CF_xxx */
 	u8 reserved[3];
 	__le32 count;
-	__le32 addr;
-	__le32 addr_hi;
+	__le64 addr;
 };
 
 struct st_sgtable {
 	__le16 sg_count;
 	__le16 max_sg_count;
 	__le32 sz_in_byte;
-	struct st_sgitem table[ST_MAX_SG];
 };
 
 struct handshake_frame {
-	__le32 rb_phy;		/* request payload queue physical address */
-	__le32 rb_phy_hi;
+	__le64 rb_phy;		/* request payload queue physical address */
 	__le16 req_sz;		/* size of each request payload */
 	__le16 req_cnt;		/* count of reqs the buffer can hold */
 	__le16 status_sz;	/* size of each status payload */
 	__le16 status_cnt;	/* count of status the buffer can hold */
-	__le32 hosttime;	/* seconds from Jan 1, 1970 (GMT) */
-	__le32 hosttime_hi;
+	__le64 hosttime;	/* seconds from Jan 1, 1970 (GMT) */
 	u8 partner_type;	/* who sends this frame */
 	u8 reserved0[7];
 	__le32 partner_ver_major;
@@ -273,6 +269,7 @@ struct st_ccb {
 	u32 req_type;
 	u8 srb_status;
 	u8 scsi_status;
+	u8 reserved[2];
 };
 
 struct st_hba {
@@ -293,7 +290,6 @@ struct st_hba {
 	void *copy_buffer; /* temp buffer for driver-handled commands */
 	struct st_ccb ccb[MU_MAX_REQUEST];
 	struct st_ccb *wait_ccb;
-	wait_queue_head_t waitq;
 
 	unsigned int mu_status;
 	int out_req_cnt;
@@ -318,19 +314,17 @@ MODULE_DESCRIPTION("Promise Technology SuperTrak EX Controllers");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(ST_DRIVER_VERSION);
 
-static void stex_gettime(__le32 *time)
+static void stex_gettime(__le64 *time)
 {
 	struct timeval tv;
 
 	do_gettimeofday(&tv);
-	*time = cpu_to_le32(tv.tv_sec & 0xffffffff);
-	*(time + 1) = cpu_to_le32((tv.tv_sec >> 16) >> 16);
+	*time = cpu_to_le64(tv.tv_sec);
 }
 
 static struct status_msg *stex_get_status(struct st_hba *hba)
 {
-	struct status_msg *status =
-		hba->status_buffer + hba->status_tail;
+	struct status_msg *status = hba->status_buffer + hba->status_tail;
 
 	++hba->status_tail;
 	hba->status_tail %= MU_STATUS_COUNT;
@@ -366,32 +360,30 @@ static int stex_map_sg(struct st_hba *hba,
 	struct scsi_cmnd *cmd;
 	struct scatterlist *sg;
 	struct st_sgtable *dst;
+	struct st_sgitem *table;
 	int i, nseg;
 
 	cmd = ccb->cmd;
-	dst = (struct st_sgtable *)req->variable;
-	dst->max_sg_count = cpu_to_le16(ST_MAX_SG);
-	dst->sz_in_byte = cpu_to_le32(scsi_bufflen(cmd));
-
 	nseg = scsi_dma_map(cmd);
-	if (nseg < 0)
-		return -EIO;
+	BUG_ON(nseg < 0);
 	if (nseg) {
+		dst = (struct st_sgtable *)req->variable;
+
 		ccb->sg_count = nseg;
 		dst->sg_count = cpu_to_le16((u16)nseg);
+		dst->max_sg_count = cpu_to_le16(hba->host->sg_tablesize);
+		dst->sz_in_byte = cpu_to_le32(scsi_bufflen(cmd));
 
+		table = (struct st_sgitem *)(dst + 1);
 		scsi_for_each_sg(cmd, sg, nseg, i) {
-			dst->table[i].count = cpu_to_le32((u32)sg_dma_len(sg));
-			dst->table[i].addr =
-				cpu_to_le32(sg_dma_address(sg) & 0xffffffff);
-			dst->table[i].addr_hi =
-				cpu_to_le32((sg_dma_address(sg) >> 16) >> 16);
-			dst->table[i].ctrl = SG_CF_64B | SG_CF_HOST;
+			table[i].count = cpu_to_le32((u32)sg_dma_len(sg));
+			table[i].addr = cpu_to_le64(sg_dma_address(sg));
+			table[i].ctrl = SG_CF_64B | SG_CF_HOST;
 		}
-		dst->table[--i].ctrl |= SG_CF_EOT;
+		table[--i].ctrl |= SG_CF_EOT;
 	}
 
-	return 0;
+	return nseg;
 }
 
 static void stex_controller_info(struct st_hba *hba, struct st_ccb *ccb)
@@ -400,7 +392,7 @@ static void stex_controller_info(struct st_hba *hba, struct st_ccb *ccb)
 	size_t count = sizeof(struct st_frame);
 
 	p = hba->copy_buffer;
-	count = scsi_sg_copy_to_buffer(ccb->cmd, p, count);
+	scsi_sg_copy_to_buffer(ccb->cmd, p, count);
 	memset(p->base, 0, sizeof(u32)*6);
 	*(unsigned long *)(p->base) = pci_resource_start(hba->pdev, 0);
 	p->rom_addr = 0;
@@ -418,15 +410,13 @@ static void stex_controller_info(struct st_hba *hba, struct st_ccb *ccb)
 	p->subid =
 		hba->pdev->subsystem_vendor << 16 | hba->pdev->subsystem_device;
 
-	count = scsi_sg_copy_from_buffer(ccb->cmd, p, count);
+	scsi_sg_copy_from_buffer(ccb->cmd, p, count);
 }
 
 static void
 stex_send_cmd(struct st_hba *hba, struct req_msg *req, u16 tag)
 {
 	req->tag = cpu_to_le16(tag);
-	req->task_attr = TASK_ATTRIBUTE_SIMPLE;
-	req->task_manage = 0; /* not supported yet */
 
 	hba->ccb[tag].req = req;
 	hba->out_req_cnt++;
@@ -442,7 +432,7 @@ stex_slave_alloc(struct scsi_device *sdev)
 	/* Cheat: usually extracted from Inquiry data */
 	sdev->tagged_supported = 1;
 
-	scsi_activate_tcq(sdev, ST_CMD_PER_LUN);
+	scsi_activate_tcq(sdev, sdev->host->can_queue);
 
 	return 0;
 }
@@ -469,7 +459,7 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 {
 	struct st_hba *hba;
 	struct Scsi_Host *host;
-	unsigned int id,lun;
+	unsigned int id, lun;
 	struct req_msg *req;
 	u16 tag;
 
@@ -572,7 +562,6 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 	hba->ccb[tag].cmd = cmd;
 	hba->ccb[tag].sense_bufflen = SCSI_SENSE_BUFFERSIZE;
 	hba->ccb[tag].sense_buffer = cmd->sense_buffer;
-	hba->ccb[tag].req_type = 0;
 
 	if (cmd->sc_data_direction != DMA_NONE)
 		stex_map_sg(hba, req, &hba->ccb[tag]);
@@ -586,7 +575,7 @@ static void stex_scsi_done(struct st_ccb *ccb)
 	struct scsi_cmnd *cmd = ccb->cmd;
 	int result;
 
-	if (ccb->srb_status == SRB_STATUS_SUCCESS ||  ccb->srb_status == 0) {
+	if (ccb->srb_status == SRB_STATUS_SUCCESS || ccb->srb_status == 0) {
 		result = ccb->scsi_status;
 		switch (ccb->scsi_status) {
 		case SAM_STAT_GOOD:
@@ -626,8 +615,6 @@ static void stex_scsi_done(struct st_ccb *ccb)
 static void stex_copy_data(struct st_ccb *ccb,
 	struct status_msg *resp, unsigned int variable)
 {
-	size_t count = variable;
-
 	if (resp->scsi_status != SAM_STAT_GOOD) {
 		if (ccb->sense_buffer != NULL)
 			memcpy(ccb->sense_buffer, resp->variable,
@@ -637,17 +624,16 @@ static void stex_copy_data(struct st_ccb *ccb,
 
 	if (ccb->cmd == NULL)
 		return;
-	count = scsi_sg_copy_from_buffer(ccb->cmd, resp->variable, count);
+	scsi_sg_copy_from_buffer(ccb->cmd, resp->variable, variable);
 }
 
-static void stex_ys_commands(struct st_hba *hba,
+static void stex_check_cmd(struct st_hba *hba,
 	struct st_ccb *ccb, struct status_msg *resp)
 {
 	if (ccb->cmd->cmnd[0] == MGT_CMD &&
-		resp->scsi_status != SAM_STAT_CHECK_CONDITION) {
+		resp->scsi_status != SAM_STAT_CHECK_CONDITION)
 		scsi_set_resid(ccb->cmd, scsi_bufflen(ccb->cmd) -
 			le32_to_cpu(*(__le32 *)&resp->variable[0]));
-	}
 }
 
 static void stex_mu_intr(struct st_hba *hba, u32 doorbell)
@@ -658,7 +644,7 @@ static void stex_mu_intr(struct st_hba *hba, u32 doorbell)
 	unsigned int size;
 	u16 tag;
 
-	if (!(doorbell & MU_OUTBOUND_DOORBELL_STATUSHEADCHANGED))
+	if (unlikely(!(doorbell & MU_OUTBOUND_DOORBELL_STATUSHEADCHANGED)))
 		return;
 
 	/* status payloads */
@@ -693,13 +679,13 @@ static void stex_mu_intr(struct st_hba *hba, u32 doorbell)
 			continue;
 		}
 
+		hba->out_req_cnt--;
 		ccb = &hba->ccb[tag];
-		if (hba->wait_ccb == ccb)
+		if (unlikely(hba->wait_ccb == ccb))
 			hba->wait_ccb = NULL;
 		if (unlikely(ccb->req == NULL)) {
 			printk(KERN_WARNING DRV_NAME
 				"(%s): lagging req\n", pci_name(hba->pdev));
-			hba->out_req_cnt--;
 			continue;
 		}
 
@@ -720,7 +706,7 @@ static void stex_mu_intr(struct st_hba *hba, u32 doorbell)
 
 		if (likely(ccb->cmd != NULL)) {
 			if (hba->cardtype == st_yosemite)
-				stex_ys_commands(hba, ccb, resp);
+				stex_check_cmd(hba, ccb, resp);
 
 			if (unlikely(ccb->cmd->cmnd[0] == PASSTHRU_CMD &&
 				ccb->cmd->cmnd[1] == PASSTHRU_GET_ADAPTER))
@@ -728,17 +714,8 @@ static void stex_mu_intr(struct st_hba *hba, u32 doorbell)
 
 			scsi_dma_unmap(ccb->cmd);
 			stex_scsi_done(ccb);
-			hba->out_req_cnt--;
-		} else if (ccb->req_type & PASSTHRU_REQ_TYPE) {
-			hba->out_req_cnt--;
-			if (ccb->req_type & PASSTHRU_REQ_NO_WAKEUP) {
-				ccb->req_type = 0;
-				continue;
-			}
+		} else
 			ccb->req_type = 0;
-			if (waitqueue_active(&hba->waitq))
-				wake_up(&hba->waitq);
-		}
 	}
 
 update_status:
@@ -800,13 +777,14 @@ static int stex_handshake(struct st_hba *hba)
 	data = readl(base + OMR1);
 	if ((data & 0xffff0000) == MU_HANDSHAKE_SIGNATURE_HALF) {
 		data &= 0x0000ffff;
-		if (hba->host->can_queue > data)
+		if (hba->host->can_queue > data) {
 			hba->host->can_queue = data;
+			hba->host->cmd_per_lun = data;
+		}
 	}
 
-	h = (struct handshake_frame *)(hba->dma_mem + MU_REQ_BUFFER_SIZE);
-	h->rb_phy = cpu_to_le32(hba->dma_handle);
-	h->rb_phy_hi = cpu_to_le32((hba->dma_handle >> 16) >> 16);
+	h = (struct handshake_frame *)hba->status_buffer;
+	h->rb_phy = cpu_to_le64(hba->dma_handle);
 	h->req_sz = cpu_to_le16(sizeof(struct req_msg));
 	h->req_cnt = cpu_to_le16(MU_REQ_COUNT);
 	h->status_sz = cpu_to_le16(sizeof(struct status_msg));
@@ -950,8 +928,8 @@ static void stex_hard_reset(struct st_hba *hba)
 static int stex_reset(struct scsi_cmnd *cmd)
 {
 	struct st_hba *hba;
-	unsigned long flags;
-	unsigned long before;
+	void __iomem *base;
+	unsigned long flags, before;
 
 	hba = (struct st_hba *) &cmd->device->host->hostdata[0];
 
@@ -994,7 +972,23 @@ static int stex_reset(struct scsi_cmnd *cmd)
 		msleep(1);
 	}
 
+	base = hba->mmio_base;
+	writel(0, base + IMR0);
+	readl(base + IMR0);
+	writel(0, base + OMR0);
+	readl(base + OMR0);
+	writel(0, base + IMR1);
+	readl(base + IMR1);
+	writel(0, base + OMR1);
+	readl(base + OMR1); /* flush */
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	hba->req_head = 0;
+	hba->req_tail = 0;
+	hba->status_head = 0;
+	hba->status_tail = 0;
+	hba->out_req_cnt = 0;
 	hba->mu_status = MU_STATE_STARTED;
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	return SUCCESS;
 }
 
@@ -1130,7 +1124,6 @@ stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	hba->host = host;
 	hba->pdev = pdev;
-	init_waitqueue_head(&hba->waitq);
 
 	err = request_irq(pdev->irq, stex_intr, IRQF_SHARED, DRV_NAME, hba);
 	if (err) {
@@ -1206,16 +1199,18 @@ static void stex_hba_stop(struct st_hba *hba)
 	hba->ccb[tag].sg_count = 0;
 	hba->ccb[tag].sense_bufflen = 0;
 	hba->ccb[tag].sense_buffer = NULL;
-	hba->ccb[tag].req_type |= PASSTHRU_REQ_TYPE;
+	hba->ccb[tag].req_type = PASSTHRU_REQ_TYPE;
 
 	stex_send_cmd(hba, req, tag);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	before = jiffies;
 	while (hba->ccb[tag].req_type & PASSTHRU_REQ_TYPE) {
-		if (time_after(jiffies, before + ST_INTERNAL_TIMEOUT * HZ))
+		if (time_after(jiffies, before + ST_INTERNAL_TIMEOUT * HZ)) {
+			hba->ccb[tag].req_type = 0;
 			return;
-		msleep(10);
+		}
+		msleep(1);
 	}
 }
 


