From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.12-rc3
Date: Sat, 03 Jun 2017 14:34:20 -0700
Message-ID: <1496525660.2658.7.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is nine fixes, seven of which are for the qedi driver (new in
4.10) the other two are a use after free in the cxgbi drivers and a
potential NULL dereference in the rdac device handler.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Artem Savkov (1):
      scsi: scsi_dh_rdac: Use ctlr directly in rdac_failover_get()

Arun Easi (1):
      scsi: qedi: Fix bad pte call trace when iscsiuio is stopped.

Nilesh Javali (1):
      scsi: qedi: set max_fin_rt default value

Varun Prakash (1):
      scsi: libcxgbi: fix skb use after free

manish.rangankar@cavium.com (5):
      scsi: qedi: Fix endpoint NULL panic during recovery.
      scsi: qedi: Set firmware tcp msl timer value.
      scsi: qedi: Fix endpoint NULL panic in qedi_set_path.
      scsi: qedi: Set dma_boundary to 0xfff.
      scsi: qedi: Correctly set firmware max supported BDs.

and diffstat:

 drivers/scsi/cxgbi/libcxgbi.c              | 25 ++++++++++++++++++-------
 drivers/scsi/cxgbi/libcxgbi.h              | 16 ++++++++--------
 drivers/scsi/device_handler/scsi_dh_rdac.c | 10 ++++------
 drivers/scsi/qedi/qedi.h                   |  3 ++-
 drivers/scsi/qedi/qedi_fw.c                |  2 ++
 drivers/scsi/qedi/qedi_iscsi.c             |  7 ++++++-
 drivers/scsi/qedi/qedi_main.c              | 25 +++++++++++++------------
 7 files changed, 53 insertions(+), 35 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index bd7d39ecbd24..fb06974c88c1 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1873,6 +1873,11 @@ int cxgbi_conn_alloc_pdu(struct iscsi_task *task, u8 opcode)
 	tcp_task->dd_data = tdata;
 	task->hdr = NULL;
 
+	if (tdata->skb) {
+		kfree_skb(tdata->skb);
+		tdata->skb = NULL;
+	}
+
 	if (SKB_MAX_HEAD(cdev->skb_tx_rsvd) > (512 * MAX_SKB_FRAGS) &&
 	    (opcode == ISCSI_OP_SCSI_DATA_OUT ||
 	     (opcode == ISCSI_OP_SCSI_CMD &&
@@ -1890,6 +1895,7 @@ int cxgbi_conn_alloc_pdu(struct iscsi_task *task, u8 opcode)
 		return -ENOMEM;
 	}
 
+	skb_get(tdata->skb);
 	skb_reserve(tdata->skb, cdev->skb_tx_rsvd);
 	task->hdr = (struct iscsi_hdr *)tdata->skb->data;
 	task->hdr_max = SKB_TX_ISCSI_PDU_HEADER_MAX; /* BHS + AHS */
@@ -2035,9 +2041,9 @@ int cxgbi_conn_xmit_pdu(struct iscsi_task *task)
 	unsigned int datalen;
 	int err;
 
-	if (!skb) {
+	if (!skb || cxgbi_skcb_test_flag(skb, SKCBF_TX_DONE)) {
 		log_debug(1 << CXGBI_DBG_ISCSI | 1 << CXGBI_DBG_PDU_TX,
-			"task 0x%p, skb NULL.\n", task);
+			"task 0x%p, skb 0x%p\n", task, skb);
 		return 0;
 	}
 
@@ -2050,7 +2056,6 @@ int cxgbi_conn_xmit_pdu(struct iscsi_task *task)
 	}
 
 	datalen = skb->data_len;
-	tdata->skb = NULL;
 
 	/* write ppod first if using ofldq to write ppod */
 	if (ttinfo->flags & CXGBI_PPOD_INFO_FLAG_VALID) {
@@ -2078,6 +2083,7 @@ int cxgbi_conn_xmit_pdu(struct iscsi_task *task)
 			pdulen += ISCSI_DIGEST_SIZE;
 
 		task->conn->txdata_octets += pdulen;
+		cxgbi_skcb_set_flag(skb, SKCBF_TX_DONE);
 		return 0;
 	}
 
@@ -2086,7 +2092,6 @@ int cxgbi_conn_xmit_pdu(struct iscsi_task *task)
 			"task 0x%p, skb 0x%p, len %u/%u, %d EAGAIN.\n",
 			task, skb, skb->len, skb->data_len, err);
 		/* reset skb to send when we are called again */
-		tdata->skb = skb;
 		return err;
 	}
 
@@ -2094,7 +2099,8 @@ int cxgbi_conn_xmit_pdu(struct iscsi_task *task)
 		"itt 0x%x, skb 0x%p, len %u/%u, xmit err %d.\n",
 		task->itt, skb, skb->len, skb->data_len, err);
 
-	kfree_skb(skb);
+	__kfree_skb(tdata->skb);
+	tdata->skb = NULL;
 
 	iscsi_conn_printk(KERN_ERR, task->conn, "xmit err %d.\n", err);
 	iscsi_conn_failure(task->conn, ISCSI_ERR_XMIT_FAILED);
@@ -2113,8 +2119,10 @@ void cxgbi_cleanup_task(struct iscsi_task *task)
 
 	tcp_task->dd_data = NULL;
 	/*  never reached the xmit task callout */
-	if (tdata->skb)
-		__kfree_skb(tdata->skb);
+	if (tdata->skb) {
+		kfree_skb(tdata->skb);
+		tdata->skb = NULL;
+	}
 
 	task_release_itt(task, task->hdr_itt);
 	memset(tdata, 0, sizeof(*tdata));
@@ -2714,6 +2722,9 @@ EXPORT_SYMBOL_GPL(cxgbi_attr_is_visible);
 static int __init libcxgbi_init_module(void)
 {
 	pr_info("%s", version);
+
+	BUILD_BUG_ON(FIELD_SIZEOF(struct sk_buff, cb) <
+		     sizeof(struct cxgbi_skb_cb));
 	return 0;
 }
 
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index 18e0ea83d361..239462a75760 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -195,7 +195,8 @@ struct cxgbi_skb_rx_cb {
 };
 
 struct cxgbi_skb_tx_cb {
-	void *l2t;
+	void *handle;
+	void *arp_err_handler;
 	struct sk_buff *wr_next;
 };
 
@@ -203,6 +204,7 @@ enum cxgbi_skcb_flags {
 	SKCBF_TX_NEED_HDR,	/* packet needs a header */
 	SKCBF_TX_MEM_WRITE,     /* memory write */
 	SKCBF_TX_FLAG_COMPL,    /* wr completion flag */
+	SKCBF_TX_DONE,		/* skb tx done */
 	SKCBF_RX_COALESCED,	/* received whole pdu */
 	SKCBF_RX_HDR,		/* received pdu header */
 	SKCBF_RX_DATA,		/* received pdu payload */
@@ -215,13 +217,13 @@ enum cxgbi_skcb_flags {
 };
 
 struct cxgbi_skb_cb {
-	unsigned char ulp_mode;
-	unsigned long flags;
-	unsigned int seq;
 	union {
 		struct cxgbi_skb_rx_cb rx;
 		struct cxgbi_skb_tx_cb tx;
 	};
+	unsigned char ulp_mode;
+	unsigned long flags;
+	unsigned int seq;
 };
 
 #define CXGBI_SKB_CB(skb)	((struct cxgbi_skb_cb *)&((skb)->cb[0]))
@@ -374,11 +376,9 @@ static inline void cxgbi_sock_enqueue_wr(struct cxgbi_sock *csk,
 	cxgbi_skcb_tx_wr_next(skb) = NULL;
 	/*
 	 * We want to take an extra reference since both us and the driver
-	 * need to free the packet before it's really freed. We know there's
-	 * just one user currently so we use atomic_set rather than skb_get
-	 * to avoid the atomic op.
+	 * need to free the packet before it's really freed.
 	 */
-	atomic_set(&skb->users, 2);
+	skb_get(skb);
 
 	if (!csk->wr_pending_head)
 		csk->wr_pending_head = skb;
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 3cbab8710e58..2ceff585f189 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -265,18 +265,16 @@ static unsigned int rdac_failover_get(struct rdac_controller *ctlr,
 				      struct list_head *list,
 				      unsigned char *cdb)
 {
-	struct scsi_device *sdev = ctlr->ms_sdev;
-	struct rdac_dh_data *h = sdev->handler_data;
 	struct rdac_mode_common *common;
 	unsigned data_size;
 	struct rdac_queue_data *qdata;
 	u8 *lun_table;
 
-	if (h->ctlr->use_ms10) {
+	if (ctlr->use_ms10) {
 		struct rdac_pg_expanded *rdac_pg;
 
 		data_size = sizeof(struct rdac_pg_expanded);
-		rdac_pg = &h->ctlr->mode_select.expanded;
+		rdac_pg = &ctlr->mode_select.expanded;
 		memset(rdac_pg, 0, data_size);
 		common = &rdac_pg->common;
 		rdac_pg->page_code = RDAC_PAGE_CODE_REDUNDANT_CONTROLLER + 0x40;
@@ -288,7 +286,7 @@ static unsigned int rdac_failover_get(struct rdac_controller *ctlr,
 		struct rdac_pg_legacy *rdac_pg;
 
 		data_size = sizeof(struct rdac_pg_legacy);
-		rdac_pg = &h->ctlr->mode_select.legacy;
+		rdac_pg = &ctlr->mode_select.legacy;
 		memset(rdac_pg, 0, data_size);
 		common = &rdac_pg->common;
 		rdac_pg->page_code = RDAC_PAGE_CODE_REDUNDANT_CONTROLLER;
@@ -304,7 +302,7 @@ static unsigned int rdac_failover_get(struct rdac_controller *ctlr,
 	}
 
 	/* Prepare the command. */
-	if (h->ctlr->use_ms10) {
+	if (ctlr->use_ms10) {
 		cdb[0] = MODE_SELECT_10;
 		cdb[7] = data_size >> 8;
 		cdb[8] = data_size & 0xff;
diff --git a/drivers/scsi/qedi/qedi.h b/drivers/scsi/qedi/qedi.h
index 5ca3e8c28a3f..32632c9b2276 100644
--- a/drivers/scsi/qedi/qedi.h
+++ b/drivers/scsi/qedi/qedi.h
@@ -38,7 +38,7 @@ struct qedi_endpoint;
 #define QEDI_MAX_ISCSI_TASK		4096
 #define QEDI_MAX_TASK_NUM		0x0FFF
 #define QEDI_MAX_ISCSI_CONNS_PER_HBA	1024
-#define QEDI_ISCSI_MAX_BDS_PER_CMD	256	/* Firmware max BDs is 256 */
+#define QEDI_ISCSI_MAX_BDS_PER_CMD	255	/* Firmware max BDs is 255 */
 #define MAX_OUSTANDING_TASKS_PER_CON	1024
 
 #define QEDI_MAX_BD_LEN		0xffff
@@ -63,6 +63,7 @@ struct qedi_endpoint;
 #define QEDI_PAGE_MASK		(~((QEDI_PAGE_SIZE) - 1))
 
 #define QEDI_PAGE_SIZE		4096
+#define QEDI_HW_DMA_BOUNDARY	0xfff
 #define QEDI_PATH_HANDLE	0xFE0000000UL
 
 struct qedi_uio_ctrl {
diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index d6978cbc56f0..8bc7ee1a8ca8 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -1494,6 +1494,8 @@ static int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn,
 	tmf_hdr = (struct iscsi_tm *)mtask->hdr;
 	qedi_cmd = (struct qedi_cmd *)mtask->dd_data;
 	ep = qedi_conn->ep;
+	if (!ep)
+		return -ENODEV;
 
 	tid = qedi_get_task_idx(qedi);
 	if (tid == -1)
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 3548d46f9b27..87f0af358b33 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -59,6 +59,7 @@ struct scsi_host_template qedi_host_template = {
 	.this_id = -1,
 	.sg_tablesize = QEDI_ISCSI_MAX_BDS_PER_CMD,
 	.max_sectors = 0xffff,
+	.dma_boundary = QEDI_HW_DMA_BOUNDARY,
 	.cmd_per_lun = 128,
 	.use_clustering = ENABLE_CLUSTERING,
 	.shost_attrs = qedi_shost_attrs,
@@ -1223,8 +1224,12 @@ static int qedi_set_path(struct Scsi_Host *shost, struct iscsi_path *path_data)
 
 	iscsi_cid = (u32)path_data->handle;
 	qedi_ep = qedi->ep_tbl[iscsi_cid];
-	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_CONN,
+	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
 		  "iscsi_cid=0x%x, qedi_ep=%p\n", iscsi_cid, qedi_ep);
+	if (!qedi_ep) {
+		ret = -EINVAL;
+		goto set_path_exit;
+	}
 
 	if (!is_valid_ether_addr(&path_data->mac_addr[0])) {
 		QEDI_NOTICE(&qedi->dbg_ctx, "dst mac NOT VALID\n");
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 92775a8b74b1..09a294634bc7 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -151,6 +151,11 @@ static int qedi_uio_close(struct uio_info *uinfo, struct inode *inode)
 
 static void __qedi_free_uio_rings(struct qedi_uio_dev *udev)
 {
+	if (udev->uctrl) {
+		free_page((unsigned long)udev->uctrl);
+		udev->uctrl = NULL;
+	}
+
 	if (udev->ll2_ring) {
 		free_page((unsigned long)udev->ll2_ring);
 		udev->ll2_ring = NULL;
@@ -169,7 +174,6 @@ static void __qedi_free_uio(struct qedi_uio_dev *udev)
 	__qedi_free_uio_rings(udev);
 
 	pci_dev_put(udev->pdev);
-	kfree(udev->uctrl);
 	kfree(udev);
 }
 
@@ -208,6 +212,11 @@ static int __qedi_alloc_uio_rings(struct qedi_uio_dev *udev)
 	if (udev->ll2_ring || udev->ll2_buf)
 		return rc;
 
+	/* Memory for control area.  */
+	udev->uctrl = (void *)get_zeroed_page(GFP_KERNEL);
+	if (!udev->uctrl)
+		return -ENOMEM;
+
 	/* Allocating memory for LL2 ring  */
 	udev->ll2_ring_size = QEDI_PAGE_SIZE;
 	udev->ll2_ring = (void *)get_zeroed_page(GFP_KERNEL | __GFP_COMP);
@@ -237,7 +246,6 @@ static int __qedi_alloc_uio_rings(struct qedi_uio_dev *udev)
 static int qedi_alloc_uio_rings(struct qedi_ctx *qedi)
 {
 	struct qedi_uio_dev *udev = NULL;
-	struct qedi_uio_ctrl *uctrl = NULL;
 	int rc = 0;
 
 	list_for_each_entry(udev, &qedi_udev_list, list) {
@@ -258,21 +266,14 @@ static int qedi_alloc_uio_rings(struct qedi_ctx *qedi)
 		goto err_udev;
 	}
 
-	uctrl = kzalloc(sizeof(*uctrl), GFP_KERNEL);
-	if (!uctrl) {
-		rc = -ENOMEM;
-		goto err_uctrl;
-	}
-
 	udev->uio_dev = -1;
 
 	udev->qedi = qedi;
 	udev->pdev = qedi->pdev;
-	udev->uctrl = uctrl;
 
 	rc = __qedi_alloc_uio_rings(udev);
 	if (rc)
-		goto err_uio_rings;
+		goto err_uctrl;
 
 	list_add(&udev->list, &qedi_udev_list);
 
@@ -283,8 +284,6 @@ static int qedi_alloc_uio_rings(struct qedi_ctx *qedi)
 	udev->rx_pkt = udev->ll2_buf + LL2_SINGLE_BUF_SIZE;
 	return 0;
 
- err_uio_rings:
-	kfree(uctrl);
  err_uctrl:
 	kfree(udev);
  err_udev:
@@ -828,6 +827,8 @@ static int qedi_set_iscsi_pf_param(struct qedi_ctx *qedi)
 	qedi->pf_params.iscsi_pf_params.num_uhq_pages_in_ring = num_sq_pages;
 	qedi->pf_params.iscsi_pf_params.num_queues = qedi->num_queues;
 	qedi->pf_params.iscsi_pf_params.debug_mode = qedi_fw_debug;
+	qedi->pf_params.iscsi_pf_params.two_msl_timer = 4000;
+	qedi->pf_params.iscsi_pf_params.max_fin_rt = 2;
 
 	for (log_page_size = 0 ; log_page_size < 32 ; log_page_size++) {
 		if ((1 << log_page_size) == PAGE_SIZE)
