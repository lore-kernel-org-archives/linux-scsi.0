From: "Ed Lin" <ed.lin@promise.com>
Subject: [PATCH 3/5] stex:use config struct for parameters of different controllers
Date: Tue, 31 Mar 2009 17:30:31 -0800
Message-ID: <200903311730306346008@promise.com>
Reply-To: ed.lin@promise.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.promise.com ([67.111.72.2]:21550 "EHLO
	nonamew.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751246AbZDAApg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Mar 2009 20:45:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, promise_linux <promise_linux@promise.com>

Use config struct (st_card_info) for parameters of different controllers

Signed-off-by: Ed Lin <ed.lin@promise.com>
---

 drivers/scsi/stex.c |  201 ++++++++++++++++++++++++++++++++-------------------
 1 files changed, 125 insertions(+), 76 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index c4eb5c1..75f5079 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -95,19 +95,8 @@ enum {
 	TASK_ATTRIBUTE_ORDERED			= 0x2,
 	TASK_ATTRIBUTE_ACA			= 0x4,
 
-	/* request count, etc. */
-	MU_MAX_REQUEST				= 32,
-
-	/* one message wasted, use MU_MAX_REQUEST+1
-		to handle MU_MAX_REQUEST messages */
-	MU_REQ_COUNT				= (MU_MAX_REQUEST + 1),
-	MU_STATUS_COUNT				= (MU_MAX_REQUEST + 1),
-
 	STEX_CDB_LENGTH				= 16,
-	REQ_VARIABLE_LEN			= 1024,
 	STATUS_VAR_LEN				= 128,
-	ST_CAN_QUEUE				= MU_MAX_REQUEST,
-	ST_CMD_PER_LUN				= MU_MAX_REQUEST,
 	ST_MAX_SG				= 32,
 
 	/* sg flags */
@@ -120,9 +109,8 @@ enum {
 
 	st_shasta				= 0,
 	st_vsc					= 1,
-	st_vsc1					= 2,
-	st_yosemite				= 3,
-	st_seq					= 4,
+	st_yosemite				= 2,
+	st_seq					= 3,
 
 	PASSTHRU_REQ_TYPE			= 0x00000001,
 	PASSTHRU_REQ_NO_WAKEUP			= 0x00000100,
@@ -196,7 +184,7 @@ struct req_msg {
 	u8 data_dir;
 	u8 payload_sz;		/* payload size in 4-byte, not used */
 	u8 cdb[STEX_CDB_LENGTH];
-	u8 variable[REQ_VARIABLE_LEN];
+	u32 variable[0];
 };
 
 struct status_msg {
@@ -252,12 +240,6 @@ struct st_drvver {
 	u32 reserved[3];
 };
 
-#define MU_REQ_BUFFER_SIZE	(MU_REQ_COUNT * sizeof(struct req_msg))
-#define MU_STATUS_BUFFER_SIZE	(MU_STATUS_COUNT * sizeof(struct status_msg))
-#define MU_BUFFER_SIZE		(MU_REQ_BUFFER_SIZE + MU_STATUS_BUFFER_SIZE)
-#define STEX_EXTRA_SIZE		sizeof(struct st_frame)
-#define STEX_BUFFER_SIZE	(MU_BUFFER_SIZE + STEX_EXTRA_SIZE)
-
 struct st_ccb {
 	struct req_msg *req;
 	struct scsi_cmnd *cmd;
@@ -288,13 +270,26 @@ struct st_hba {
 
 	struct status_msg *status_buffer;
 	void *copy_buffer; /* temp buffer for driver-handled commands */
-	struct st_ccb ccb[MU_MAX_REQUEST];
+	struct st_ccb *ccb;
 	struct st_ccb *wait_ccb;
 
 	unsigned int mu_status;
 	unsigned int cardtype;
 	int msi_enabled;
 	int out_req_cnt;
+	u32 extra_offset;
+	u16 rq_count;
+	u16 rq_size;
+	u16 sts_count;
+};
+
+struct st_card_info {
+	unsigned int max_id;
+	unsigned int max_lun;
+	unsigned int max_channel;
+	u16 rq_count;
+	u16 rq_size;
+	u16 sts_count;
 };
 
 static int msi;
@@ -331,7 +326,7 @@ static struct status_msg *stex_get_status(struct st_hba *hba)
 	struct status_msg *status = hba->status_buffer + hba->status_tail;
 
 	++hba->status_tail;
-	hba->status_tail %= MU_STATUS_COUNT;
+	hba->status_tail %= hba->sts_count+1;
 
 	return status;
 }
@@ -349,11 +344,10 @@ static void stex_invalid_field(struct scsi_cmnd *cmd,
 
 static struct req_msg *stex_alloc_req(struct st_hba *hba)
 {
-	struct req_msg *req = ((struct req_msg *)hba->dma_mem) +
-		hba->req_head;
+	struct req_msg *req = hba->dma_mem + hba->req_head * hba->rq_size;
 
 	++hba->req_head;
-	hba->req_head %= MU_REQ_COUNT;
+	hba->req_head %= hba->rq_count+1;
 
 	return req;
 }
@@ -653,7 +647,7 @@ static void stex_mu_intr(struct st_hba *hba, u32 doorbell)
 
 	/* status payloads */
 	hba->status_head = readl(base + OMR1);
-	if (unlikely(hba->status_head >= MU_STATUS_COUNT)) {
+	if (unlikely(hba->status_head > hba->sts_count)) {
 		printk(KERN_WARNING DRV_NAME "(%s): invalid status head\n",
 			pci_name(hba->pdev));
 		return;
@@ -789,19 +783,19 @@ static int stex_handshake(struct st_hba *hba)
 
 	h = (struct handshake_frame *)hba->status_buffer;
 	h->rb_phy = cpu_to_le64(hba->dma_handle);
-	h->req_sz = cpu_to_le16(sizeof(struct req_msg));
-	h->req_cnt = cpu_to_le16(MU_REQ_COUNT);
+	h->req_sz = cpu_to_le16(hba->rq_size);
+	h->req_cnt = cpu_to_le16(hba->rq_count+1);
 	h->status_sz = cpu_to_le16(sizeof(struct status_msg));
-	h->status_cnt = cpu_to_le16(MU_STATUS_COUNT);
+	h->status_cnt = cpu_to_le16(hba->sts_count+1);
 	stex_gettime(&h->hosttime);
 	h->partner_type = HMU_PARTNER_TYPE;
-	if (hba->dma_size > STEX_BUFFER_SIZE) {
-		h->extra_offset = cpu_to_le32(STEX_BUFFER_SIZE);
+	if (hba->extra_offset) {
+		h->extra_offset = cpu_to_le32(hba->extra_offset);
 		h->extra_size = cpu_to_le32(ST_ADDITIONAL_MEM);
 	} else
 		h->extra_offset = h->extra_size = 0;
 
-	status_phys = hba->dma_handle + MU_REQ_BUFFER_SIZE;
+	status_phys = hba->dma_handle + (hba->rq_count+1) * hba->rq_size;
 	writel(status_phys, base + IMR0);
 	readl(base + IMR0);
 	writel((status_phys >> 16) >> 16, base + IMR1);
@@ -1026,10 +1020,72 @@ static struct scsi_host_template driver_template = {
 	.slave_destroy			= stex_slave_destroy,
 	.eh_abort_handler		= stex_abort,
 	.eh_host_reset_handler		= stex_reset,
-	.can_queue			= ST_CAN_QUEUE,
 	.this_id			= -1,
 	.sg_tablesize			= ST_MAX_SG,
-	.cmd_per_lun			= ST_CMD_PER_LUN,
+};
+
+static struct pci_device_id stex_pci_tbl[] = {
+	/* st_shasta */
+	{ 0x105a, 0x8350, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		st_shasta }, /* SuperTrak EX8350/8300/16350/16300 */
+	{ 0x105a, 0xc350, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		st_shasta }, /* SuperTrak EX12350 */
+	{ 0x105a, 0x4302, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		st_shasta }, /* SuperTrak EX4350 */
+	{ 0x105a, 0xe350, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		st_shasta }, /* SuperTrak EX24350 */
+
+	/* st_vsc */
+	{ 0x105a, 0x7250, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_vsc },
+
+	/* st_yosemite */
+	{ 0x105a, 0x8650, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_yosemite },
+
+	/* st_seq */
+	{ 0x105a, 0x3360, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_seq },
+	{ }	/* terminate list */
+};
+
+static struct st_card_info stex_card_info[] = {
+	/* st_shasta */
+	{
+		.max_id		= 17,
+		.max_lun	= 8,
+		.max_channel	= 0,
+		.rq_count	= 32,
+		.rq_size	= 1048,
+		.sts_count	= 32,
+	},
+
+	/* st_vsc */
+	{
+		.max_id		= 129,
+		.max_lun	= 1,
+		.max_channel	= 0,
+		.rq_count	= 32,
+		.rq_size	= 1048,
+		.sts_count	= 32,
+	},
+
+	/* st_yosemite */
+	{
+		.max_id		= 2,
+		.max_lun	= 256,
+		.max_channel	= 0,
+		.rq_count	= 256,
+		.rq_size	= 1048,
+		.sts_count	= 256,
+	},
+
+	/* st_seq */
+	{
+		.max_id		= 129,
+		.max_lun	= 1,
+		.max_channel	= 0,
+		.rq_count	= 32,
+		.rq_size	= 1048,
+		.sts_count	= 32,
+	},
 };
 
 static int stex_set_dma_mask(struct pci_dev * pdev)
@@ -1084,6 +1140,8 @@ stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct st_hba *hba;
 	struct Scsi_Host *host;
+	const struct st_card_info *ci = NULL;
+	u32 sts_offset, cp_offset;
 	int err;
 
 	err = pci_enable_device(pdev);
@@ -1127,10 +1185,15 @@ stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	hba->cardtype = (unsigned int) id->driver_data;
-	if (hba->cardtype == st_vsc && (pdev->subsystem_device & 1))
-		hba->cardtype = st_vsc1;
-	hba->dma_size = (hba->cardtype == st_vsc1 || hba->cardtype == st_seq) ?
-		(STEX_BUFFER_SIZE + ST_ADDITIONAL_MEM) : (STEX_BUFFER_SIZE);
+	ci = &stex_card_info[hba->cardtype];
+	sts_offset = (ci->rq_count+1) * ci->rq_size;
+	cp_offset = sts_offset + (ci->sts_count+1) * sizeof(struct status_msg);
+	hba->dma_size = cp_offset + sizeof(struct st_frame);
+	if (hba->cardtype == st_seq ||
+		(hba->cardtype == st_vsc && (pdev->subsystem_device & 1))) {
+		hba->extra_offset = hba->dma_size;
+		hba->dma_size += ST_ADDITIONAL_MEM;
+	}
 	hba->dma_mem = dma_alloc_coherent(&pdev->dev,
 		hba->dma_size, &hba->dma_handle, GFP_KERNEL);
 	if (!hba->dma_mem) {
@@ -1140,23 +1203,26 @@ stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_iounmap;
 	}
 
-	hba->status_buffer =
-		(struct status_msg *)(hba->dma_mem + MU_REQ_BUFFER_SIZE);
-	hba->copy_buffer = hba->dma_mem + MU_BUFFER_SIZE;
+	hba->ccb = kcalloc(ci->rq_count, sizeof(struct st_ccb), GFP_KERNEL);
+	if (!hba->ccb) {
+		err = -ENOMEM;
+		printk(KERN_ERR DRV_NAME "(%s): ccb alloc failed\n",
+			pci_name(pdev));
+		goto out_pci_free;
+	}
+
+	hba->status_buffer = (struct status_msg *)(hba->dma_mem + sts_offset);
+	hba->copy_buffer = hba->dma_mem + cp_offset;
+	hba->rq_count = ci->rq_count;
+	hba->rq_size = ci->rq_size;
+	hba->sts_count = ci->sts_count;
 	hba->mu_status = MU_STATE_STARTING;
 
-	if (hba->cardtype == st_shasta) {
-		host->max_lun = 8;
-		host->max_id = 16 + 1;
-	} else if (hba->cardtype == st_yosemite) {
-		host->max_lun = 256;
-		host->max_id = 1 + 1;
-	} else {
-		/* st_vsc , st_vsc1 and st_seq */
-		host->max_lun = 1;
-		host->max_id = 128 + 1;
-	}
-	host->max_channel = 0;
+	host->can_queue = ci->rq_count;
+	host->cmd_per_lun = ci->rq_count;
+	host->max_id = ci->max_id;
+	host->max_lun = ci->max_lun;
+	host->max_channel = ci->max_channel;
 	host->unique_id = host->host_no;
 	host->max_cmd_len = STEX_CDB_LENGTH;
 
@@ -1167,7 +1233,7 @@ stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err) {
 		printk(KERN_ERR DRV_NAME "(%s): request irq failed\n",
 			pci_name(pdev));
-		goto out_pci_free;
+		goto out_ccb_free;
 	}
 
 	err = stex_handshake(hba);
@@ -1196,6 +1262,8 @@ stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 out_free_irq:
 	stex_free_irq(hba);
+out_ccb_free:
+	kfree(hba->ccb);
 out_pci_free:
 	dma_free_coherent(&pdev->dev, hba->dma_size,
 			  hba->dma_mem, hba->dma_handle);
@@ -1260,6 +1328,8 @@ static void stex_hba_free(struct st_hba *hba)
 
 	pci_release_regions(hba->pdev);
 
+	kfree(hba->ccb);
+
 	dma_free_coherent(&hba->pdev->dev, hba->dma_size,
 			  hba->dma_mem, hba->dma_handle);
 }
@@ -1288,27 +1358,6 @@ static void stex_shutdown(struct pci_dev *pdev)
 	stex_hba_stop(hba);
 }
 
-static struct pci_device_id stex_pci_tbl[] = {
-	/* st_shasta */
-	{ 0x105a, 0x8350, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		st_shasta }, /* SuperTrak EX8350/8300/16350/16300 */
-	{ 0x105a, 0xc350, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		st_shasta }, /* SuperTrak EX12350 */
-	{ 0x105a, 0x4302, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		st_shasta }, /* SuperTrak EX4350 */
-	{ 0x105a, 0xe350, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		st_shasta }, /* SuperTrak EX24350 */
-
-	/* st_vsc */
-	{ 0x105a, 0x7250, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_vsc },
-
-	/* st_yosemite */
-	{ 0x105a, 0x8650, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_yosemite },
-
-	/* st_seq */
-	{ 0x105a, 0x3360, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_seq },
-	{ }	/* terminate list */
-};
 MODULE_DEVICE_TABLE(pci, stex_pci_tbl);
 
 static struct pci_driver stex_pci_driver = {


