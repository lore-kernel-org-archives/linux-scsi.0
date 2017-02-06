From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 03/18] lpfc: NVME Initiator: Base modifications Part A
Date: Mon, 06 Feb 2017 15:08:52 -0800
Message-ID: <58990204.D2Hmmiwi9jL0Yo3m%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36083 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751654AbdBFXJA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 18:09:00 -0500
Received: by mail-wm0-f68.google.com with SMTP id r18so25016438wmd.3
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 15:08:59 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org


NVME Initiator: Base modifications

This is part A of parts A..F.

Part A is the bulk of the file list changed by the modifications as
most mods are small-ish. Changes may be for any aspect below.

This patch by itself will not result in a compilable driver. All parts
A..F must be applied to create a compilable driver.

*********

This set of patches (6 parts) adds base modifications for NVME initiator
support to the lpfc driver.

The base modifications consist of:
- Formal split of SLI3 rings from SLI-4 WQs (sometimes referred to as
  rings as well) as implementation now widely varies between the two.
- Addition of configuration modes:
   SCSI initiator only; NVME initiator only; NVME target only; and
   SCSI and NVME initiator.
   The configuration mode drives overall adapter configuration,
   offloads enabled, and resource splits.
   NVME support is only available on SLI-4 devices and newer fw.
- Implements the following based on configuration mode:
  - Exchange resources are split by protocol; Obviously, if only
     1 mode, then no split occurs. Default is 50/50. module attribute
     allows tuning.
  - Each protocol has it's own set of queues, but share interrupt
    vectors.
     SCSI:
       SLI3 devices have few queues and the original style of queue
         allocation remains.
       SLI4 devices piggy back on an "io-channel" concept that
         eventually needs to merge with scsi-mq/blk-mq support (it is
	 underway).  For now, the paradigm continues as it existed
	 prior. io channel allocates N msix and N WQs (N=4 default)
	 and either round robins or uses cpu # modulo N for scheduling.
	 A bunch of module parameters allow the configuration to be
	 tuned.
     NVME (initiator):
       Allocates an msix per cpu (or whatever pci_alloc_irq_vectors
         gets)
       Allocates a WQ per cpu, and maps the WQs to msix on a WQ #
         modulo msix vector count basis.
       Module parameters exist to cap/control the config if desired.
  - Each protocol has its own buffer and dma pools.

Unfortunately, it was very difficult to break out the above into
functional patches. A such, they are presented as a 6-patch set to
keep email size reasonable. All patches in the set must be applied to
create a functional unit.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
Modifications in V2:
Note: this was patch 2 in the V1 patches
Note: it was determined that the code base I created the patch set from
  missed some merges of upstream changes. As such, v1 patches reverted
  some of the prior patches. They were things such as: the spelling
  errors, checkpatch items, the rdata null checks, conversion to statics,
  and pci bar setup. V2 rectifies all this, so that patch deltas are only
  true mods.
Address review items:
  Spelling errors, indents, typecasting void pointers, unneeded parens
  Created helper function for assigning the pring pointer
  Refactored iocb dequeue routines in lpfc_no_rpi()
Reworked WQ/CQ relationship. CQs were 1:1 with EQ. Now 1:1 with WQ/MQ
  Convert phba->io_channel to phba->io_channel_irq
  Remove cfg_XXX_max_hw_queues.  WQs 1:1 with CQs, thus WQ cnt
    described by cfg_XXX_io_channel (not CQs like it used to)
  Deleted lpfc_nvme_posted_buf attribute. Unnecessary
  (note: these changes affect later patches as well)

 drivers/scsi/lpfc/lpfc.h           |  82 +++++++++++++++--
 drivers/scsi/lpfc/lpfc_bsg.c       |  29 ++++--
 drivers/scsi/lpfc/lpfc_crtn.h      |  42 ++++++++-
 drivers/scsi/lpfc/lpfc_disc.h      |   1 +
 drivers/scsi/lpfc/lpfc_els.c       |  38 ++++----
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 164 ++++++++++++++++++++-------------
 drivers/scsi/lpfc/lpfc_hw.h        |   5 +-
 drivers/scsi/lpfc/lpfc_hw4.h       | 181 +++++++++++++++++++++++++++++++++++--
 drivers/scsi/lpfc/lpfc_logmsg.h    |   4 +
 drivers/scsi/lpfc/lpfc_mbox.c      |  27 ++++--
 drivers/scsi/lpfc/lpfc_mem.c       |  62 +++++++------
 drivers/scsi/lpfc/lpfc_nportdisc.c |   7 +-
 drivers/scsi/lpfc/lpfc_nvme.h      |  88 ++++++++++++++++++
 drivers/scsi/lpfc/lpfc_scsi.c      | 110 ++++++++++++++++------
 drivers/scsi/lpfc/lpfc_scsi.h      |  18 ++--
 drivers/scsi/lpfc/lpfc_sli.h       |  37 ++++++--
 drivers/scsi/lpfc/lpfc_sli4.h      |  75 +++++++++++----
 drivers/scsi/lpfc/lpfc_vport.c     |   3 +
 18 files changed, 759 insertions(+), 214 deletions(-)
 create mode 100644 drivers/scsi/lpfc/lpfc_nvme.h

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 64022d7..e07686a 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -20,6 +20,7 @@
  *******************************************************************/
 
 #include <scsi/scsi_host.h>
+#include <linux/ktime.h>
 
 #if defined(CONFIG_DEBUG_FS) && !defined(CONFIG_SCSI_LPFC_DEBUG_FS)
 #define CONFIG_SCSI_LPFC_DEBUG_FS
@@ -53,6 +54,7 @@ struct lpfc_sli2_slim;
 #define LPFC_MAX_SG_SEG_CNT	4096	/* sg element count per scsi cmnd */
 #define LPFC_MAX_SGL_SEG_CNT	512	/* SGL element count per scsi cmnd */
 #define LPFC_MAX_BPL_SEG_CNT	4096	/* BPL element count per scsi cmnd */
+#define LPFC_MIN_NVME_SEG_CNT	254
 
 #define LPFC_MAX_SGE_SIZE       0x80000000 /* Maximum data allowed in a SGE */
 #define LPFC_IOCB_LIST_CNT	2250	/* list of IOCBs for fast-path usage. */
@@ -114,6 +116,13 @@ enum lpfc_polling_flags {
 	DISABLE_FCP_RING_INT    = 0x2
 };
 
+struct perf_prof {
+	uint16_t cmd_cpu[40];
+	uint16_t rsp_cpu[40];
+	uint16_t qh_cpu[40];
+	uint16_t wqidx[40];
+};
+
 /* Provide DMA memory definitions the driver uses per port instance. */
 struct lpfc_dmabuf {
 	struct list_head list;
@@ -131,10 +140,24 @@ struct lpfc_dma_pool {
 struct hbq_dmabuf {
 	struct lpfc_dmabuf hbuf;
 	struct lpfc_dmabuf dbuf;
-	uint32_t size;
+	uint16_t total_size;
+	uint16_t bytes_recv;
 	uint32_t tag;
 	struct lpfc_cq_event cq_event;
 	unsigned long time_stamp;
+	void *context;
+};
+
+struct rqb_dmabuf {
+	struct lpfc_dmabuf hbuf;
+	struct lpfc_dmabuf dbuf;
+	uint16_t total_size;
+	uint16_t bytes_recv;
+	void *context;
+	struct lpfc_iocbq *iocbq;
+	struct lpfc_sglq *sglq;
+	struct lpfc_queue *hrq;	  /* ptr to associated Header RQ */
+	struct lpfc_queue *drq;	  /* ptr to associated Data RQ */
 };
 
 /* Priority bit.  Set value to exceed low water mark in lpfc_mem. */
@@ -442,6 +465,11 @@ struct lpfc_vport {
 	uint16_t fdmi_num_disc;
 	uint32_t fdmi_hba_mask;
 	uint32_t fdmi_port_mask;
+
+	/* There is a single nvme instance per vport. */
+	struct nvme_fc_local_port *localport;
+	uint8_t  nvmei_support; /* driver supports NVME Initiator */
+	uint32_t last_fcp_wqidx;
 };
 
 struct hbq_s {
@@ -459,10 +487,9 @@ struct hbq_s {
 					       struct hbq_dmabuf *);
 };
 
-#define LPFC_MAX_HBQS  4
 /* this matches the position in the lpfc_hbq_defs array */
 #define LPFC_ELS_HBQ	0
-#define LPFC_EXTRA_HBQ	1
+#define LPFC_MAX_HBQS	1
 
 enum hba_temp_state {
 	HBA_NORMAL_TEMP,
@@ -652,6 +679,8 @@ struct lpfc_hba {
 					 * Firmware supports Forced Link Speed
 					 * capability
 					 */
+#define HBA_NVME_IOQ_FLUSH      0x80000 /* NVME IO queues flushed. */
+
 	uint32_t fcp_ring_in_use; /* When polling test if intr-hndlr active*/
 	struct lpfc_dmabuf slim2p;
 
@@ -700,6 +729,8 @@ struct lpfc_hba {
 	uint8_t  wwpn[8];
 	uint32_t RandomData[7];
 	uint8_t  fcp_embed_io;
+	uint8_t  nvme_support;	/* Firmware supports NVME */
+	uint8_t  nvmet_support;	/* driver supports NVMET */
 	uint8_t  mds_diags_support;
 
 	/* HBA Config Parameters */
@@ -725,6 +756,11 @@ struct lpfc_hba {
 	uint32_t cfg_fcp_imax;
 	uint32_t cfg_fcp_cpu_map;
 	uint32_t cfg_fcp_io_channel;
+	uint32_t cfg_suppress_rsp;
+	uint32_t cfg_nvme_oas;
+	uint32_t cfg_nvme_io_channel;
+	uint32_t cfg_nvme_posted_buf;
+	uint32_t cfg_nvme_enable_fb;
 	uint32_t cfg_total_seg_cnt;
 	uint32_t cfg_sg_seg_cnt;
 	uint32_t cfg_sg_dma_buf_size;
@@ -770,6 +806,12 @@ struct lpfc_hba {
 #define LPFC_FDMI_SUPPORT	1	/* FDMI supported? */
 	uint32_t cfg_enable_SmartSAN;
 	uint32_t cfg_enable_mds_diags;
+	uint32_t cfg_enable_fc4_type;
+	uint32_t cfg_xri_split;
+#define LPFC_ENABLE_FCP  1
+#define LPFC_ENABLE_NVME 2
+#define LPFC_ENABLE_BOTH 3
+	uint32_t io_channel_irqs;	/* number of irqs for io channels */
 	lpfc_vpd_t vpd;		/* vital product data */
 
 	struct pci_dev *pcidev;
@@ -784,11 +826,11 @@ struct lpfc_hba {
 	unsigned long data_flags;
 
 	uint32_t hbq_in_use;		/* HBQs in use flag */
-	struct list_head rb_pend_list;  /* Received buffers to be processed */
 	uint32_t hbq_count;	        /* Count of configured HBQs */
 	struct hbq_s hbqs[LPFC_MAX_HBQS]; /* local copy of hbq indicies  */
 
-	atomic_t fcp_qidx;		/* next work queue to post work to */
+	atomic_t fcp_qidx;         /* next FCP WQ (RR Policy) */
+	atomic_t nvme_qidx;        /* next NVME WQ (RR Policy) */
 
 	phys_addr_t pci_bar0_map;     /* Physical address for PCI BAR0 */
 	phys_addr_t pci_bar1_map;     /* Physical address for PCI BAR1 */
@@ -843,9 +885,17 @@ struct lpfc_hba {
 	/*
 	 * stat  counters
 	 */
-	uint64_t fc4InputRequests;
-	uint64_t fc4OutputRequests;
-	uint64_t fc4ControlRequests;
+	uint64_t fc4ScsiInputRequests;
+	uint64_t fc4ScsiOutputRequests;
+	uint64_t fc4ScsiControlRequests;
+	uint64_t fc4ScsiIoCmpls;
+	uint64_t fc4NvmeInputRequests;
+	uint64_t fc4NvmeOutputRequests;
+	uint64_t fc4NvmeControlRequests;
+	uint64_t fc4NvmeIoCmpls;
+	uint64_t fc4NvmeLsRequests;
+	uint64_t fc4NvmeLsCmpls;
+
 	uint64_t bg_guard_err_cnt;
 	uint64_t bg_apptag_err_cnt;
 	uint64_t bg_reftag_err_cnt;
@@ -856,17 +906,23 @@ struct lpfc_hba {
 	struct list_head lpfc_scsi_buf_list_get;
 	struct list_head lpfc_scsi_buf_list_put;
 	uint32_t total_scsi_bufs;
+	spinlock_t nvme_buf_list_get_lock;  /* NVME buf alloc list lock */
+	spinlock_t nvme_buf_list_put_lock;  /* NVME buf free list lock */
+	struct list_head lpfc_nvme_buf_list_get;
+	struct list_head lpfc_nvme_buf_list_put;
+	uint32_t total_nvme_bufs;
 	struct list_head lpfc_iocb_list;
 	uint32_t total_iocbq_bufs;
 	struct list_head active_rrq_list;
 	spinlock_t hbalock;
 
 	/* pci_mem_pools */
-	struct pci_pool *lpfc_scsi_dma_buf_pool;
+	struct pci_pool *lpfc_sg_dma_buf_pool;
 	struct pci_pool *lpfc_mbuf_pool;
 	struct pci_pool *lpfc_hrb_pool;	/* header receive buffer pool */
 	struct pci_pool *lpfc_drb_pool; /* data receive buffer pool */
 	struct pci_pool *lpfc_hbq_pool;	/* SLI3 hbq buffer pool */
+	struct pci_pool *txrdy_payload_pool;
 	struct lpfc_dma_pool lpfc_mbuf_safety_pool;
 
 	mempool_t *mbox_mem_pool;
@@ -1091,3 +1147,11 @@ lpfc_sli_read_hs(struct lpfc_hba *phba)
 
 	return 0;
 }
+
+static inline struct lpfc_sli_ring *
+lpfc_phba_elsring(struct lpfc_hba *phba)
+{
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		return phba->sli4_hba.els_wq->pring;
+	return &phba->sli.sli3_ring[LPFC_ELS_RING];
+}
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 7dca4d6..55a2270 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1704,6 +1704,7 @@ lpfc_bsg_diag_mode_enter(struct lpfc_hba *phba)
 	struct lpfc_vport **vports;
 	struct Scsi_Host *shost;
 	struct lpfc_sli *psli;
+	struct lpfc_queue *qp = NULL;
 	struct lpfc_sli_ring *pring;
 	int i = 0;
 
@@ -1711,9 +1712,6 @@ lpfc_bsg_diag_mode_enter(struct lpfc_hba *phba)
 	if (!psli)
 		return -ENODEV;
 
-	pring = &psli->ring[LPFC_FCP_RING];
-	if (!pring)
-		return -ENODEV;
 
 	if ((phba->link_state == LPFC_HBA_ERROR) ||
 	    (psli->sli_flag & LPFC_BLOCK_MGMT_IO) ||
@@ -1732,10 +1730,18 @@ lpfc_bsg_diag_mode_enter(struct lpfc_hba *phba)
 		scsi_block_requests(shost);
 	}
 
-	while (!list_empty(&pring->txcmplq)) {
-		if (i++ > 500)  /* wait up to 5 seconds */
+	if (phba->sli_rev != LPFC_SLI_REV4) {
+		pring = &psli->sli3_ring[LPFC_FCP_RING];
+		lpfc_emptyq_wait(phba, &pring->txcmplq, &phba->hbalock);
+		return 0;
+	}
+	list_for_each_entry(qp, &phba->sli4_hba.lpfc_wq_list, wq_list) {
+		pring = qp->pring;
+		if (!pring || (pring->ringno != LPFC_FCP_RING))
+			continue;
+		if (!lpfc_emptyq_wait(phba, &pring->txcmplq,
+				      &pring->ring_lock))
 			break;
-		msleep(10);
 	}
 	return 0;
 }
@@ -2703,7 +2709,7 @@ static int lpfcdiag_loop_get_xri(struct lpfc_hba *phba, uint16_t rpi,
  * lpfc_bsg_dma_page_alloc - allocate a bsg mbox page sized dma buffers
  * @phba: Pointer to HBA context object
  *
- * This function allocates BSG_MBOX_SIZE (4KB) page size dma buffer and.
+ * This function allocates BSG_MBOX_SIZE (4KB) page size dma buffer and
  * returns the pointer to the buffer.
  **/
 static struct lpfc_dmabuf *
@@ -2875,8 +2881,7 @@ diag_cmd_data_alloc(struct lpfc_hba *phba,
 static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 			     size_t len)
 {
-	struct lpfc_sli *psli = &phba->sli;
-	struct lpfc_sli_ring *pring = &psli->ring[LPFC_ELS_RING];
+	struct lpfc_sli_ring *pring;
 	struct lpfc_iocbq *cmdiocbq;
 	IOCB_t *cmd = NULL;
 	struct list_head head, *curr, *next;
@@ -2890,6 +2895,8 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 	int iocb_stat;
 	int i = 0;
 
+	pring = lpfc_phba_elsring(phba);
+
 	cmdiocbq = lpfc_sli_get_iocbq(phba);
 	rxbmp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
 	if (rxbmp != NULL) {
@@ -5403,13 +5410,15 @@ lpfc_bsg_timeout(struct bsg_job *job)
 	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_iocbq *cmdiocb;
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
+	struct lpfc_sli_ring *pring;
 	struct bsg_job_data *dd_data;
 	unsigned long flags;
 	int rc = 0;
 	LIST_HEAD(completions);
 	struct lpfc_iocbq *check_iocb, *next_iocb;
 
+	pring = lpfc_phba_elsring(phba);
+
 	/* if job's driver data is NULL, the command completed or is in the
 	 * the process of completing.  In this case, return status to request
 	 * so the timeout is retried.  This avoids double completion issues
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 309643a..8dfa4e4 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -21,6 +21,7 @@
 typedef int (*node_filter)(struct lpfc_nodelist *, void *);
 
 struct fc_rport;
+struct fc_frame_header;
 void lpfc_down_link(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_sli_read_link_ste(struct lpfc_hba *);
 void lpfc_dump_mem(struct lpfc_hba *, LPFC_MBOXQ_t *, uint16_t, uint16_t);
@@ -167,6 +168,8 @@ void lpfc_hb_timeout_handler(struct lpfc_hba *);
 void lpfc_ct_unsol_event(struct lpfc_hba *, struct lpfc_sli_ring *,
 			 struct lpfc_iocbq *);
 int lpfc_ct_handle_unsol_abort(struct lpfc_hba *, struct hbq_dmabuf *);
+int lpfc_issue_gidft(struct lpfc_vport *vport);
+int lpfc_get_gidft_type(struct lpfc_vport *vport, struct lpfc_iocbq *iocbq);
 int lpfc_ns_cmd(struct lpfc_vport *, int, uint8_t, uint32_t);
 int lpfc_fdmi_cmd(struct lpfc_vport *, struct lpfc_nodelist *, int, uint32_t);
 void lpfc_fdmi_num_disc_check(struct lpfc_vport *);
@@ -186,6 +189,8 @@ void lpfc_unblock_mgmt_io(struct lpfc_hba *);
 void lpfc_offline_prep(struct lpfc_hba *, int);
 void lpfc_offline(struct lpfc_hba *);
 void lpfc_reset_hba(struct lpfc_hba *);
+int lpfc_emptyq_wait(struct lpfc_hba *phba, struct list_head *hd,
+			spinlock_t *slock);
 
 int lpfc_fof_queue_create(struct lpfc_hba *);
 int lpfc_fof_queue_setup(struct lpfc_hba *);
@@ -193,7 +198,11 @@ int lpfc_fof_queue_destroy(struct lpfc_hba *);
 irqreturn_t lpfc_sli4_fof_intr_handler(int, void *);
 
 int lpfc_sli_setup(struct lpfc_hba *);
-int lpfc_sli_queue_setup(struct lpfc_hba *);
+int lpfc_sli4_setup(struct lpfc_hba *phba);
+void lpfc_sli_queue_init(struct lpfc_hba *phba);
+void lpfc_sli4_queue_init(struct lpfc_hba *phba);
+struct lpfc_sli_ring *lpfc_sli4_calc_ring(struct lpfc_hba *phba,
+					  struct lpfc_iocbq *iocbq);
 
 void lpfc_handle_eratt(struct lpfc_hba *);
 void lpfc_handle_latt(struct lpfc_hba *);
@@ -233,6 +242,11 @@ struct hbq_dmabuf *lpfc_sli4_rb_alloc(struct lpfc_hba *);
 void lpfc_sli4_rb_free(struct lpfc_hba *, struct hbq_dmabuf *);
 void lpfc_sli4_build_dflt_fcf_record(struct lpfc_hba *, struct fcf_record *,
 			uint16_t);
+int lpfc_sli4_rq_put(struct lpfc_queue *hq, struct lpfc_queue *dq,
+		     struct lpfc_rqe *hrqe, struct lpfc_rqe *drqe);
+int lpfc_post_rq_buffer(struct lpfc_hba *phba, struct lpfc_queue *hq,
+			struct lpfc_queue *dq, int count);
+int lpfc_free_rq_buffer(struct lpfc_hba *phba, struct lpfc_queue *hq);
 void lpfc_unregister_fcf(struct lpfc_hba *);
 void lpfc_unregister_fcf_rescan(struct lpfc_hba *);
 void lpfc_unregister_unused_fcf(struct lpfc_hba *);
@@ -287,6 +301,11 @@ void lpfc_sli_def_mbox_cmpl(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_sli4_unreg_rpi_cmpl_clr(struct lpfc_hba *, LPFC_MBOXQ_t *);
 int lpfc_sli_issue_iocb(struct lpfc_hba *, uint32_t,
 			struct lpfc_iocbq *, uint32_t);
+int lpfc_sli4_issue_wqe(struct lpfc_hba *phba, uint32_t rnum,
+			struct lpfc_iocbq *iocbq);
+struct lpfc_sglq *__lpfc_clear_active_sglq(struct lpfc_hba *phba, uint16_t xri);
+struct lpfc_sglq *__lpfc_sli_get_els_sglq(struct lpfc_hba *phba,
+					   struct lpfc_iocbq *iocbq);
 void lpfc_sli_pcimem_bcopy(void *, void *, uint32_t);
 void lpfc_sli_bemem_bcopy(void *, void *, uint32_t);
 void lpfc_sli_abort_iocb_ring(struct lpfc_hba *, struct lpfc_sli_ring *);
@@ -303,10 +322,10 @@ uint32_t lpfc_sli_get_buffer_tag(struct lpfc_hba *);
 struct lpfc_dmabuf * lpfc_sli_ring_taggedbuf_get(struct lpfc_hba *,
 			struct lpfc_sli_ring *, uint32_t );
 
-int lpfc_sli_hbq_count(void);
+int lpfc_sli_hbq_count(struct lpfc_hba *phba);
 int lpfc_sli_hbqbuf_add_hbqs(struct lpfc_hba *, uint32_t);
 void lpfc_sli_hbqbuf_free_all(struct lpfc_hba *);
-int lpfc_sli_hbq_size(void);
+int lpfc_sli_hbq_size(struct lpfc_hba *phba);
 int lpfc_sli_issue_abort_iotag(struct lpfc_hba *, struct lpfc_sli_ring *,
 			       struct lpfc_iocbq *);
 int lpfc_sli_sum_iocb(struct lpfc_vport *, uint16_t, uint64_t, lpfc_ctx_cmd);
@@ -356,9 +375,11 @@ extern struct device_attribute *lpfc_hba_attrs[];
 extern struct device_attribute *lpfc_vport_attrs[];
 extern struct scsi_host_template lpfc_template;
 extern struct scsi_host_template lpfc_template_s3;
+extern struct scsi_host_template lpfc_template_nvme;
 extern struct scsi_host_template lpfc_vport_template;
 extern struct fc_function_template lpfc_transport_functions;
 extern struct fc_function_template lpfc_vport_transport_functions;
+extern int lpfc_new_scsi_buf(struct lpfc_vport *vport, int cnt);
 
 int  lpfc_vport_symbolic_node_name(struct lpfc_vport *, char *, size_t);
 int  lpfc_vport_symbolic_port_name(struct lpfc_vport *, char *,	size_t);
@@ -471,7 +492,9 @@ int lpfc_issue_unreg_vfi(struct lpfc_vport *);
 int lpfc_selective_reset(struct lpfc_hba *);
 int lpfc_sli4_read_config(struct lpfc_hba *);
 void lpfc_sli4_node_prep(struct lpfc_hba *);
-int lpfc_sli4_xri_sgl_update(struct lpfc_hba *);
+int lpfc_sli4_els_sgl_update(struct lpfc_hba *phba);
+int lpfc_sli4_scsi_sgl_update(struct lpfc_hba *phba);
+int lpfc_sli4_nvme_sgl_update(struct lpfc_hba *phba);
 void lpfc_free_sgl_list(struct lpfc_hba *, struct list_head *);
 uint32_t lpfc_sli_port_speed_get(struct lpfc_hba *);
 int lpfc_sli4_request_firmware_update(struct lpfc_hba *, uint8_t);
@@ -496,3 +519,14 @@ bool lpfc_find_next_oas_lun(struct lpfc_hba *, struct lpfc_name *,
 			    uint32_t *, uint32_t *);
 int lpfc_sli4_dump_page_a0(struct lpfc_hba *phba, struct lpfcMboxq *mbox);
 void lpfc_mbx_cmpl_rdp_page_a0(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb);
+struct lpfc_vport *lpfc_fc_frame_to_vport(struct lpfc_hba *phba,
+					  struct fc_frame_header *hdr,
+					  uint16_t fcfi, uint32_t did);
+
+/* SCSI Interfaces. */
+void lpfc_release_scsi_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb);
+struct lpfc_scsi_buf *lpfc_get_scsi_buf(struct lpfc_hba *phba,
+					struct lpfc_nodelist *ndlp);
+
+/* NVME interfaces. */
+void lpfc_nvme_mod_param_dep(struct lpfc_hba *phba);
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 361f5b3..1d07a5f 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -133,6 +133,7 @@ struct lpfc_node_rrq {
 /* Defines for nlp_flag (uint32) */
 #define NLP_IGNR_REG_CMPL  0x00000001 /* Rcvd rscn before we cmpl reg login */
 #define NLP_REG_LOGIN_SEND 0x00000002   /* sent reglogin to adapter */
+#define NLP_SUPPRESS_RSP   0x00000010	/* Remote NPort supports suppress rsp */
 #define NLP_PLOGI_SND      0x00000020	/* sent PLOGI request for this entry */
 #define NLP_PRLI_SND       0x00000040	/* sent PRLI request for this entry */
 #define NLP_ADISC_SND      0x00000080	/* sent ADISC request for this entry */
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index ede14f1..9e4611a 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1323,7 +1323,7 @@ lpfc_els_abort_flogi(struct lpfc_hba *phba)
 			"0201 Abort outstanding I/O on NPort x%x\n",
 			Fabric_DID);
 
-	pring = &phba->sli.ring[LPFC_ELS_RING];
+	pring = lpfc_phba_elsring(phba);
 
 	/*
 	 * Check the txcmplq for an iocb that matches the nport the driver is
@@ -7153,7 +7153,8 @@ lpfc_els_timeout_handler(struct lpfc_vport *vport)
 
 	timeout = (uint32_t)(phba->fc_ratov << 1);
 
-	pring = &phba->sli.ring[LPFC_ELS_RING];
+	pring = lpfc_phba_elsring(phba);
+
 	if ((phba->pport->load_flag & FC_UNLOADING))
 		return;
 	spin_lock_irq(&phba->hbalock);
@@ -7222,7 +7223,7 @@ lpfc_els_timeout_handler(struct lpfc_vport *vport)
 		spin_unlock_irq(&phba->hbalock);
 	}
 
-	if (!list_empty(&phba->sli.ring[LPFC_ELS_RING].txcmplq))
+	if (!list_empty(&pring->txcmplq))
 		if (!(phba->pport->load_flag & FC_UNLOADING))
 			mod_timer(&vport->els_tmofunc,
 				  jiffies + msecs_to_jiffies(1000 * timeout));
@@ -7253,7 +7254,7 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 {
 	LIST_HEAD(abort_list);
 	struct lpfc_hba  *phba = vport->phba;
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
+	struct lpfc_sli_ring *pring;
 	struct lpfc_iocbq *tmp_iocb, *piocb;
 	IOCB_t *cmd = NULL;
 
@@ -7265,6 +7266,7 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 	 * a working list and release the locks before calling the abort.
 	 */
 	spin_lock_irq(&phba->hbalock);
+	pring = lpfc_phba_elsring(phba);
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		spin_lock(&pring->ring_lock);
 
@@ -9011,7 +9013,9 @@ void lpfc_fabric_abort_nport(struct lpfc_nodelist *ndlp)
 	LIST_HEAD(completions);
 	struct lpfc_hba  *phba = ndlp->phba;
 	struct lpfc_iocbq *tmp_iocb, *piocb;
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
+	struct lpfc_sli_ring *pring;
+
+	pring = lpfc_phba_elsring(phba);
 
 	spin_lock_irq(&phba->hbalock);
 	list_for_each_entry_safe(piocb, tmp_iocb, &phba->fabric_iocb_list,
@@ -9067,13 +9071,13 @@ lpfc_sli4_vport_delete_els_xri_aborted(struct lpfc_vport *vport)
 	unsigned long iflag = 0;
 
 	spin_lock_irqsave(&phba->hbalock, iflag);
-	spin_lock(&phba->sli4_hba.abts_sgl_list_lock);
+	spin_lock(&phba->sli4_hba.sgl_list_lock);
 	list_for_each_entry_safe(sglq_entry, sglq_next,
 			&phba->sli4_hba.lpfc_abts_els_sgl_list, list) {
 		if (sglq_entry->ndlp && sglq_entry->ndlp->vport == vport)
 			sglq_entry->ndlp = NULL;
 	}
-	spin_unlock(&phba->sli4_hba.abts_sgl_list_lock);
+	spin_unlock(&phba->sli4_hba.sgl_list_lock);
 	spin_unlock_irqrestore(&phba->hbalock, iflag);
 	return;
 }
@@ -9097,22 +9101,22 @@ lpfc_sli4_els_xri_aborted(struct lpfc_hba *phba,
 	struct lpfc_sglq *sglq_entry = NULL, *sglq_next = NULL;
 	unsigned long iflag = 0;
 	struct lpfc_nodelist *ndlp;
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
+	struct lpfc_sli_ring *pring;
+
+	pring = lpfc_phba_elsring(phba);
 
 	spin_lock_irqsave(&phba->hbalock, iflag);
-	spin_lock(&phba->sli4_hba.abts_sgl_list_lock);
+	spin_lock(&phba->sli4_hba.sgl_list_lock);
 	list_for_each_entry_safe(sglq_entry, sglq_next,
 			&phba->sli4_hba.lpfc_abts_els_sgl_list, list) {
 		if (sglq_entry->sli4_xritag == xri) {
 			list_del(&sglq_entry->list);
 			ndlp = sglq_entry->ndlp;
 			sglq_entry->ndlp = NULL;
-			spin_lock(&pring->ring_lock);
 			list_add_tail(&sglq_entry->list,
-				&phba->sli4_hba.lpfc_sgl_list);
+				&phba->sli4_hba.lpfc_els_sgl_list);
 			sglq_entry->state = SGL_FREED;
-			spin_unlock(&pring->ring_lock);
-			spin_unlock(&phba->sli4_hba.abts_sgl_list_lock);
+			spin_unlock(&phba->sli4_hba.sgl_list_lock);
 			spin_unlock_irqrestore(&phba->hbalock, iflag);
 			lpfc_set_rrq_active(phba, ndlp,
 				sglq_entry->sli4_lxritag,
@@ -9124,21 +9128,21 @@ lpfc_sli4_els_xri_aborted(struct lpfc_hba *phba,
 			return;
 		}
 	}
-	spin_unlock(&phba->sli4_hba.abts_sgl_list_lock);
+	spin_unlock(&phba->sli4_hba.sgl_list_lock);
 	lxri = lpfc_sli4_xri_inrange(phba, xri);
 	if (lxri == NO_XRI) {
 		spin_unlock_irqrestore(&phba->hbalock, iflag);
 		return;
 	}
-	spin_lock(&pring->ring_lock);
+	spin_lock(&phba->sli4_hba.sgl_list_lock);
 	sglq_entry = __lpfc_get_active_sglq(phba, lxri);
 	if (!sglq_entry || (sglq_entry->sli4_xritag != xri)) {
-		spin_unlock(&pring->ring_lock);
+		spin_unlock(&phba->sli4_hba.sgl_list_lock);
 		spin_unlock_irqrestore(&phba->hbalock, iflag);
 		return;
 	}
 	sglq_entry->state = SGL_XRI_ABORTED;
-	spin_unlock(&pring->ring_lock);
+	spin_unlock(&phba->sli4_hba.sgl_list_lock);
 	spin_unlock_irqrestore(&phba->hbalock, iflag);
 	return;
 }
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index ed22393..6c42715 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -93,7 +93,7 @@ lpfc_terminate_rport_io(struct fc_rport *rport)
 
 	if (ndlp->nlp_sid != NLP_NO_SID) {
 		lpfc_sli_abort_iocb(ndlp->vport,
-			&phba->sli.ring[phba->sli.fcp_ring],
+			&phba->sli.sli3_ring[LPFC_FCP_RING],
 			ndlp->nlp_sid, 0, LPFC_CTX_TGT);
 	}
 }
@@ -247,8 +247,8 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 		if (ndlp->nlp_sid != NLP_NO_SID) {
 			/* flush the target */
 			lpfc_sli_abort_iocb(vport,
-					&phba->sli.ring[phba->sli.fcp_ring],
-					ndlp->nlp_sid, 0, LPFC_CTX_TGT);
+					    &phba->sli.sli3_ring[LPFC_FCP_RING],
+					    ndlp->nlp_sid, 0, LPFC_CTX_TGT);
 		}
 		put_node = rdata->pnode != NULL;
 		rdata->pnode = NULL;
@@ -283,7 +283,7 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 
 	if (ndlp->nlp_sid != NLP_NO_SID) {
 		warn_on = 1;
-		lpfc_sli_abort_iocb(vport, &phba->sli.ring[phba->sli.fcp_ring],
+		lpfc_sli_abort_iocb(vport, &phba->sli.sli3_ring[LPFC_FCP_RING],
 				    ndlp->nlp_sid, 0, LPFC_CTX_TGT);
 	}
 
@@ -495,11 +495,12 @@ lpfc_send_fastpath_evt(struct lpfc_hba *phba,
 		return;
 	}
 
-	fc_host_post_vendor_event(shost,
-		fc_get_event_number(),
-		evt_data_size,
-		evt_data,
-		LPFC_NL_VENDOR_ID);
+	if (phba->cfg_enable_fc4_type != LPFC_ENABLE_NVME)
+		fc_host_post_vendor_event(shost,
+			fc_get_event_number(),
+			evt_data_size,
+			evt_data,
+			LPFC_NL_VENDOR_ID);
 
 	lpfc_free_fast_evt(phba, fast_evt_data);
 	return;
@@ -682,7 +683,7 @@ lpfc_work_done(struct lpfc_hba *phba)
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
 
-	pring = &phba->sli.ring[LPFC_ELS_RING];
+	pring = lpfc_phba_elsring(phba);
 	status = (ha_copy & (HA_RXMASK  << (4*LPFC_ELS_RING)));
 	status >>= (4*LPFC_ELS_RING);
 	if ((status & HA_RXMASK) ||
@@ -894,11 +895,16 @@ lpfc_linkdown(struct lpfc_hba *phba)
 		spin_unlock_irq(shost->host_lock);
 	}
 	vports = lpfc_create_vport_work_array(phba);
-	if (vports != NULL)
+	if (vports != NULL) {
 		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 			/* Issue a LINK DOWN event to all nodes */
 			lpfc_linkdown_port(vports[i]);
+
+			vports[i]->fc_myDID = 0;
+
+			/* todo: init: revise localport nvme attributes */
 		}
+	}
 	lpfc_destroy_vport_work_array(phba, vports);
 	/* Clean up any firmware default rpi's */
 	mb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
@@ -914,7 +920,6 @@ lpfc_linkdown(struct lpfc_hba *phba)
 
 	/* Setup myDID for link up if we are in pt2pt mode */
 	if (phba->pport->fc_flag & FC_PT2PT) {
-		phba->pport->fc_myDID = 0;
 		mb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 		if (mb) {
 			lpfc_config_link(phba, mb);
@@ -929,7 +934,6 @@ lpfc_linkdown(struct lpfc_hba *phba)
 		phba->pport->fc_flag &= ~(FC_PT2PT | FC_PT2PT_PLOGI);
 		spin_unlock_irq(shost->host_lock);
 	}
-
 	return 0;
 }
 
@@ -1016,7 +1020,7 @@ lpfc_linkup(struct lpfc_hba *phba)
  * This routine handles processing a CLEAR_LA mailbox
  * command upon completion. It is setup in the LPFC_MBOXQ
  * as the completion routine when the command is
- * handed off to the SLI layer.
+ * handed off to the SLI layer. SLI3 only.
  */
 static void
 lpfc_mbx_cmpl_clear_la(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
@@ -1028,9 +1032,8 @@ lpfc_mbx_cmpl_clear_la(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	uint32_t control;
 
 	/* Since we don't do discovery right now, turn these off here */
-	psli->ring[psli->extra_ring].flag &= ~LPFC_STOP_IOCB_EVENT;
-	psli->ring[psli->fcp_ring].flag &= ~LPFC_STOP_IOCB_EVENT;
-	psli->ring[psli->next_ring].flag &= ~LPFC_STOP_IOCB_EVENT;
+	psli->sli3_ring[LPFC_EXTRA_RING].flag &= ~LPFC_STOP_IOCB_EVENT;
+	psli->sli3_ring[LPFC_FCP_RING].flag &= ~LPFC_STOP_IOCB_EVENT;
 
 	/* Check for error */
 	if ((mb->mbxStatus) && (mb->mbxStatus != 0x1601)) {
@@ -3277,7 +3280,7 @@ lpfc_mbx_issue_link_down(struct lpfc_hba *phba)
  * This routine handles processing a READ_TOPOLOGY mailbox
  * command upon completion. It is setup in the LPFC_MBOXQ
  * as the completion routine when the command is
- * handed off to the SLI layer.
+ * handed off to the SLI layer. SLI4 only.
  */
 void
 lpfc_mbx_cmpl_read_topology(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
@@ -3285,11 +3288,14 @@ lpfc_mbx_cmpl_read_topology(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	struct lpfc_vport *vport = pmb->vport;
 	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_mbx_read_top *la;
+	struct lpfc_sli_ring *pring;
 	MAILBOX_t *mb = &pmb->u.mb;
 	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *) (pmb->context1);
 
 	/* Unblock ELS traffic */
-	phba->sli.ring[LPFC_ELS_RING].flag &= ~LPFC_STOP_IOCB_EVENT;
+	pring = lpfc_phba_elsring(phba);
+	pring->flag &= ~LPFC_STOP_IOCB_EVENT;
+
 	/* Check for error */
 	if (mb->mbxStatus) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_LINK_EVENT,
@@ -3458,6 +3464,14 @@ lpfc_mbx_cmpl_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag &= ~NLP_IGNR_REG_CMPL;
 		spin_unlock_irq(shost->host_lock);
+
+		/*
+		 * We cannot leave the RPI registered because
+		 * if we go thru discovery again for this ndlp
+		 * a subsequent REG_RPI will fail.
+		 */
+		ndlp->nlp_flag |= NLP_RPI_REGISTERED;
+		lpfc_unreg_rpi(vport, ndlp);
 	}
 
 	/* Call state machine */
@@ -3903,6 +3917,9 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	struct fc_rport_identifiers rport_ids;
 	struct lpfc_hba  *phba = vport->phba;
 
+	if (phba->cfg_enable_fc4_type == LPFC_ENABLE_NVME)
+		return;
+
 	/* Remote port has reappeared. Re-register w/ FC transport */
 	rport_ids.node_name = wwn_to_u64(ndlp->nlp_nodename.u.wwn);
 	rport_ids.port_name = wwn_to_u64(ndlp->nlp_portname.u.wwn);
@@ -3972,12 +3989,13 @@ static void
 lpfc_unregister_remote_port(struct lpfc_nodelist *ndlp)
 {
 	struct fc_rport *rport = ndlp->rport;
+	struct lpfc_vport *vport = ndlp->vport;
 
-	lpfc_debugfs_disc_trc(ndlp->vport, LPFC_DISC_TRC_RPORT,
+	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_RPORT,
 		"rport delete:    did:x%x flg:x%x type x%x",
 		ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_type);
 
-	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NODE,
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
 			 "3184 rport unregister x%06x, rport %p\n",
 			 ndlp->nlp_DID, rport);
 
@@ -4394,7 +4412,6 @@ lpfc_check_sli_ndlp(struct lpfc_hba *phba,
 		    struct lpfc_iocbq *iocb,
 		    struct lpfc_nodelist *ndlp)
 {
-	struct lpfc_sli *psli = &phba->sli;
 	IOCB_t *icmd = &iocb->iocb;
 	struct lpfc_vport    *vport = ndlp->vport;
 
@@ -4413,9 +4430,7 @@ lpfc_check_sli_ndlp(struct lpfc_hba *phba,
 			if (iocb->context1 == (uint8_t *) ndlp)
 				return 1;
 		}
-	} else if (pring->ringno == psli->extra_ring) {
-
-	} else if (pring->ringno == psli->fcp_ring) {
+	} else if (pring->ringno == LPFC_FCP_RING) {
 		/* Skip match check if waiting to relogin to FCP target */
 		if ((ndlp->nlp_type & NLP_FCP_TARGET) &&
 		    (ndlp->nlp_flag & NLP_DELAY_TMO)) {
@@ -4424,12 +4439,58 @@ lpfc_check_sli_ndlp(struct lpfc_hba *phba,
 		if (icmd->ulpContext == (volatile ushort)ndlp->nlp_rpi) {
 			return 1;
 		}
-	} else if (pring->ringno == psli->next_ring) {
-
 	}
 	return 0;
 }
 
+static void
+__lpfc_dequeue_nport_iocbs(struct lpfc_hba *phba,
+		struct lpfc_nodelist *ndlp, struct lpfc_sli_ring *pring,
+		struct list_head *dequeue_list)
+{
+	struct lpfc_iocbq *iocb, *next_iocb;
+
+	list_for_each_entry_safe(iocb, next_iocb, &pring->txq, list) {
+		/* Check to see if iocb matches the nport */
+		if (lpfc_check_sli_ndlp(phba, pring, iocb, ndlp))
+			/* match, dequeue */
+			list_move_tail(&iocb->list, dequeue_list);
+	}
+}
+
+static void
+lpfc_sli3_dequeue_nport_iocbs(struct lpfc_hba *phba,
+		struct lpfc_nodelist *ndlp, struct list_head *dequeue_list)
+{
+	struct lpfc_sli *psli = &phba->sli;
+	uint32_t i;
+
+	spin_lock_irq(&phba->hbalock);
+	for (i = 0; i < psli->num_rings; i++)
+		__lpfc_dequeue_nport_iocbs(phba, ndlp, &psli->sli3_ring[i],
+						dequeue_list);
+	spin_unlock_irq(&phba->hbalock);
+}
+
+static void
+lpfc_sli4_dequeue_nport_iocbs(struct lpfc_hba *phba,
+		struct lpfc_nodelist *ndlp, struct list_head *dequeue_list)
+{
+	struct lpfc_sli_ring *pring;
+	struct lpfc_queue *qp = NULL;
+
+	spin_lock_irq(&phba->hbalock);
+	list_for_each_entry(qp, &phba->sli4_hba.lpfc_wq_list, wq_list) {
+		pring = qp->pring;
+		if (!pring)
+			continue;
+		spin_lock_irq(&pring->ring_lock);
+		__lpfc_dequeue_nport_iocbs(phba, ndlp, pring, dequeue_list);
+		spin_unlock_irq(&pring->ring_lock);
+	}
+	spin_unlock_irq(&phba->hbalock);
+}
+
 /*
  * Free resources / clean up outstanding I/Os
  * associated with nlp_rpi in the LPFC_NODELIST entry.
@@ -4438,10 +4499,6 @@ static int
 lpfc_no_rpi(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 {
 	LIST_HEAD(completions);
-	struct lpfc_sli *psli;
-	struct lpfc_sli_ring *pring;
-	struct lpfc_iocbq *iocb, *next_iocb;
-	uint32_t i;
 
 	lpfc_fabric_abort_nport(ndlp);
 
@@ -4449,29 +4506,11 @@ lpfc_no_rpi(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 	 * Everything that matches on txcmplq will be returned
 	 * by firmware with a no rpi error.
 	 */
-	psli = &phba->sli;
 	if (ndlp->nlp_flag & NLP_RPI_REGISTERED) {
-		/* Now process each ring */
-		for (i = 0; i < psli->num_rings; i++) {
-			pring = &psli->ring[i];
-
-			spin_lock_irq(&phba->hbalock);
-			list_for_each_entry_safe(iocb, next_iocb, &pring->txq,
-						 list) {
-				/*
-				 * Check to see if iocb matches the nport we are
-				 * looking for
-				 */
-				if ((lpfc_check_sli_ndlp(phba, pring, iocb,
-							 ndlp))) {
-					/* It matches, so deque and call compl
-					   with an error */
-					list_move_tail(&iocb->list,
-						       &completions);
-				}
-			}
-			spin_unlock_irq(&phba->hbalock);
-		}
+		if (phba->sli_rev != LPFC_SLI_REV4)
+			lpfc_sli3_dequeue_nport_iocbs(phba, ndlp, &completions);
+		else
+			lpfc_sli4_dequeue_nport_iocbs(phba, ndlp, &completions);
 	}
 
 	/* Cancel all the IOCBs from the completions list */
@@ -5040,14 +5079,14 @@ lpfc_disc_list_loopmap(struct lpfc_vport *vport)
 	return;
 }
 
+/* SLI3 only */
 void
 lpfc_issue_clear_la(struct lpfc_hba *phba, struct lpfc_vport *vport)
 {
 	LPFC_MBOXQ_t *mbox;
 	struct lpfc_sli *psli = &phba->sli;
-	struct lpfc_sli_ring *extra_ring = &psli->ring[psli->extra_ring];
-	struct lpfc_sli_ring *fcp_ring   = &psli->ring[psli->fcp_ring];
-	struct lpfc_sli_ring *next_ring  = &psli->ring[psli->next_ring];
+	struct lpfc_sli_ring *extra_ring = &psli->sli3_ring[LPFC_EXTRA_RING];
+	struct lpfc_sli_ring *fcp_ring   = &psli->sli3_ring[LPFC_FCP_RING];
 	int  rc;
 
 	/*
@@ -5071,7 +5110,6 @@ lpfc_issue_clear_la(struct lpfc_hba *phba, struct lpfc_vport *vport)
 			lpfc_disc_flush_list(vport);
 			extra_ring->flag &= ~LPFC_STOP_IOCB_EVENT;
 			fcp_ring->flag &= ~LPFC_STOP_IOCB_EVENT;
-			next_ring->flag &= ~LPFC_STOP_IOCB_EVENT;
 			phba->link_state = LPFC_HBA_ERROR;
 		}
 	}
@@ -5207,7 +5245,7 @@ lpfc_free_tx(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 	struct lpfc_sli_ring *pring;
 
 	psli = &phba->sli;
-	pring = &psli->ring[LPFC_ELS_RING];
+	pring = lpfc_phba_elsring(phba);
 
 	/* Error matching iocb on txq or txcmplq
 	 * First check the txq.
@@ -5523,12 +5561,14 @@ lpfc_disc_timeout_handler(struct lpfc_vport *vport)
 
 	if (clrlaerr) {
 		lpfc_disc_flush_list(vport);
-		psli->ring[(psli->extra_ring)].flag &= ~LPFC_STOP_IOCB_EVENT;
-		psli->ring[(psli->fcp_ring)].flag &= ~LPFC_STOP_IOCB_EVENT;
-		psli->ring[(psli->next_ring)].flag &= ~LPFC_STOP_IOCB_EVENT;
+		if (phba->sli_rev != LPFC_SLI_REV4) {
+			psli->sli3_ring[(LPFC_EXTRA_RING)].flag &=
+				~LPFC_STOP_IOCB_EVENT;
+			psli->sli3_ring[LPFC_FCP_RING].flag &=
+				~LPFC_STOP_IOCB_EVENT;
+		}
 		vport->port_state = LPFC_VPORT_READY;
 	}
-
 	return;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 3b970d37..5d7416c 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -44,8 +44,6 @@
 #define LPFC_FCP_RING            0	/* ring 0 for FCP initiator commands */
 #define LPFC_EXTRA_RING          1	/* ring 1 for other protocols */
 #define LPFC_ELS_RING            2	/* ring 2 for ELS commands */
-#define LPFC_FCP_NEXT_RING       3
-#define LPFC_FCP_OAS_RING        3
 
 #define SLI2_IOCB_CMD_R0_ENTRIES    172	/* SLI-2 FCP command ring entries */
 #define SLI2_IOCB_RSP_R0_ENTRIES    134	/* SLI-2 FCP response ring entries */
@@ -1791,6 +1789,7 @@ typedef struct {		/* FireFly BIU registers */
 #define MBX_INIT_VFI        0xA3
 #define MBX_INIT_VPI        0xA4
 #define MBX_ACCESS_VDATA    0xA5
+#define MBX_REG_FCFI_MRQ    0xAF
 
 #define MBX_AUTH_PORT       0xF8
 #define MBX_SECURITY_MGMT   0xF9
@@ -4163,7 +4162,7 @@ typedef struct _IOCB {	/* IOCB structure */
 
 /* HBQ entries are 4 words each = 4k */
 #define LPFC_TOTAL_HBQ_SIZE (sizeof(struct lpfc_hbq_entry) *  \
-			     lpfc_sli_hbq_count())
+			     lpfc_sli_hbq_count(phba))
 
 struct lpfc_sli2_slim {
 	MAILBOX_t mbx;
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 964a1fd..7df854e 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -108,6 +108,7 @@ struct lpfc_sli_intf {
 #define LPFC_MAX_MQ_PAGE		8
 #define LPFC_MAX_WQ_PAGE_V0		4
 #define LPFC_MAX_WQ_PAGE		8
+#define LPFC_MAX_RQ_PAGE		8
 #define LPFC_MAX_CQ_PAGE		4
 #define LPFC_MAX_EQ_PAGE		8
 
@@ -198,7 +199,7 @@ struct lpfc_sli_intf {
 /* Configuration of Interrupts / sec for entire HBA port */
 #define LPFC_MIN_IMAX          5000
 #define LPFC_MAX_IMAX          5000000
-#define LPFC_DEF_IMAX          50000
+#define LPFC_DEF_IMAX          150000
 
 #define LPFC_MIN_CPU_MAP       0
 #define LPFC_MAX_CPU_MAP       2
@@ -348,6 +349,7 @@ struct lpfc_cqe {
 #define CQE_CODE_RECEIVE		0x4
 #define CQE_CODE_XRI_ABORTED		0x5
 #define CQE_CODE_RECEIVE_V1		0x9
+#define CQE_CODE_NVME_ERSP		0xd
 
 /*
  * Define mask value for xri_aborted and wcqe completed CQE extended status.
@@ -367,6 +369,9 @@ struct lpfc_wcqe_complete {
 #define lpfc_wcqe_c_hw_status_SHIFT	0
 #define lpfc_wcqe_c_hw_status_MASK	0x000000FF
 #define lpfc_wcqe_c_hw_status_WORD	word0
+#define lpfc_wcqe_c_ersp0_SHIFT		0
+#define lpfc_wcqe_c_ersp0_MASK		0x0000FFFF
+#define lpfc_wcqe_c_ersp0_WORD		word0
 	uint32_t total_data_placed;
 	uint32_t parameter;
 #define lpfc_wcqe_c_bg_edir_SHIFT	5
@@ -400,6 +405,9 @@ struct lpfc_wcqe_complete {
 #define lpfc_wcqe_c_code_SHIFT		lpfc_cqe_code_SHIFT
 #define lpfc_wcqe_c_code_MASK		lpfc_cqe_code_MASK
 #define lpfc_wcqe_c_code_WORD		lpfc_cqe_code_WORD
+#define lpfc_wcqe_c_sqhead_SHIFT	0
+#define lpfc_wcqe_c_sqhead_MASK		0x0000FFFF
+#define lpfc_wcqe_c_sqhead_WORD		word3
 };
 
 /* completion queue entry for wqe release */
@@ -1244,10 +1252,10 @@ struct rq_context {
 #define LPFC_RQ_RING_SIZE_1024		10	/* 1024 entries */
 #define LPFC_RQ_RING_SIZE_2048		11	/* 2048 entries */
 #define LPFC_RQ_RING_SIZE_4096		12	/* 4096 entries */
-#define lpfc_rq_context_rqe_count_1_SHIFT	16	/* Version 1 Only */
+#define lpfc_rq_context_rqe_count_1_SHIFT	16	/* Version 1-2 Only */
 #define lpfc_rq_context_rqe_count_1_MASK	0x0000FFFF
 #define lpfc_rq_context_rqe_count_1_WORD	word0
-#define lpfc_rq_context_rqe_size_SHIFT	8		/* Version 1 Only */
+#define lpfc_rq_context_rqe_size_SHIFT	8		/* Version 1-2 Only */
 #define lpfc_rq_context_rqe_size_MASK	0x0000000F
 #define lpfc_rq_context_rqe_size_WORD	word0
 #define LPFC_RQE_SIZE_8		2
@@ -1259,7 +1267,13 @@ struct rq_context {
 #define lpfc_rq_context_page_size_MASK	0x000000FF
 #define lpfc_rq_context_page_size_WORD	word0
 #define	LPFC_RQ_PAGE_SIZE_4096	0x1
-	uint32_t reserved1;
+	uint32_t word1;
+#define lpfc_rq_context_data_size_SHIFT	16		/* Version 2 Only */
+#define lpfc_rq_context_data_size_MASK	0x0000FFFF
+#define lpfc_rq_context_data_size_WORD	word1
+#define lpfc_rq_context_hdr_size_SHIFT	0		/* Version 2 Only */
+#define lpfc_rq_context_hdr_size_MASK	0x0000FFFF
+#define lpfc_rq_context_hdr_size_WORD	word1
 	uint32_t word2;
 #define lpfc_rq_context_cq_id_SHIFT	16
 #define lpfc_rq_context_cq_id_MASK	0x000003FF
@@ -1267,6 +1281,9 @@ struct rq_context {
 #define lpfc_rq_context_buf_size_SHIFT	0
 #define lpfc_rq_context_buf_size_MASK	0x0000FFFF
 #define lpfc_rq_context_buf_size_WORD	word2
+#define lpfc_rq_context_base_cq_SHIFT	0		/* Version 2 Only */
+#define lpfc_rq_context_base_cq_MASK	0x0000FFFF
+#define lpfc_rq_context_base_cq_WORD	word2
 	uint32_t buffer_size;				/* Version 1 Only */
 };
 
@@ -1288,10 +1305,65 @@ struct lpfc_mbx_rq_create {
 #define lpfc_mbx_rq_create_ulp_num_MASK		0x000000FF
 #define lpfc_mbx_rq_create_ulp_num_WORD		word0
 			struct rq_context context;
-			struct dma_address page[LPFC_MAX_WQ_PAGE];
+			struct dma_address page[LPFC_MAX_RQ_PAGE];
 		} request;
 		struct {
 			uint32_t word0;
+#define lpfc_mbx_rq_create_q_cnt_v2_SHIFT	16
+#define lpfc_mbx_rq_create_q_cnt_v2_MASK	0x0000FFFF
+#define lpfc_mbx_rq_create_q_cnt_v2_WORD	word0
+#define lpfc_mbx_rq_create_q_id_SHIFT		0
+#define lpfc_mbx_rq_create_q_id_MASK		0x0000FFFF
+#define lpfc_mbx_rq_create_q_id_WORD		word0
+			uint32_t doorbell_offset;
+			uint32_t word2;
+#define lpfc_mbx_rq_create_bar_set_SHIFT	0
+#define lpfc_mbx_rq_create_bar_set_MASK		0x0000FFFF
+#define lpfc_mbx_rq_create_bar_set_WORD		word2
+#define lpfc_mbx_rq_create_db_format_SHIFT	16
+#define lpfc_mbx_rq_create_db_format_MASK	0x0000FFFF
+#define lpfc_mbx_rq_create_db_format_WORD	word2
+		} response;
+	} u;
+};
+
+struct lpfc_mbx_rq_create_v2 {
+	union  lpfc_sli4_cfg_shdr cfg_shdr;
+	union {
+		struct {
+			uint32_t word0;
+#define lpfc_mbx_rq_create_num_pages_SHIFT	0
+#define lpfc_mbx_rq_create_num_pages_MASK	0x0000FFFF
+#define lpfc_mbx_rq_create_num_pages_WORD	word0
+#define lpfc_mbx_rq_create_rq_cnt_SHIFT		16
+#define lpfc_mbx_rq_create_rq_cnt_MASK		0x000000FF
+#define lpfc_mbx_rq_create_rq_cnt_WORD		word0
+#define lpfc_mbx_rq_create_dua_SHIFT		16
+#define lpfc_mbx_rq_create_dua_MASK		0x00000001
+#define lpfc_mbx_rq_create_dua_WORD		word0
+#define lpfc_mbx_rq_create_bqu_SHIFT		17
+#define lpfc_mbx_rq_create_bqu_MASK		0x00000001
+#define lpfc_mbx_rq_create_bqu_WORD		word0
+#define lpfc_mbx_rq_create_ulp_num_SHIFT	24
+#define lpfc_mbx_rq_create_ulp_num_MASK		0x000000FF
+#define lpfc_mbx_rq_create_ulp_num_WORD		word0
+#define lpfc_mbx_rq_create_dim_SHIFT		29
+#define lpfc_mbx_rq_create_dim_MASK		0x00000001
+#define lpfc_mbx_rq_create_dim_WORD		word0
+#define lpfc_mbx_rq_create_dfd_SHIFT		30
+#define lpfc_mbx_rq_create_dfd_MASK		0x00000001
+#define lpfc_mbx_rq_create_dfd_WORD		word0
+#define lpfc_mbx_rq_create_dnb_SHIFT		31
+#define lpfc_mbx_rq_create_dnb_MASK		0x00000001
+#define lpfc_mbx_rq_create_dnb_WORD		word0
+			struct rq_context context;
+			struct dma_address page[1];
+		} request;
+		struct {
+			uint32_t word0;
+#define lpfc_mbx_rq_create_q_cnt_v2_SHIFT	16
+#define lpfc_mbx_rq_create_q_cnt_v2_MASK	0x0000FFFF
+#define lpfc_mbx_rq_create_q_cnt_v2_WORD	word0
 #define lpfc_mbx_rq_create_q_id_SHIFT		0
 #define lpfc_mbx_rq_create_q_id_MASK		0x0000FFFF
 #define lpfc_mbx_rq_create_q_id_WORD		word0
@@ -2841,12 +2913,18 @@ struct lpfc_sli4_parameters {
 #define cfg_mqv_WORD				word6
 	uint32_t word7;
 	uint32_t word8;
+#define cfg_wqpcnt_SHIFT			0
+#define cfg_wqpcnt_MASK				0x0000000f
+#define cfg_wqpcnt_WORD				word8
 #define cfg_wqsize_SHIFT			8
 #define cfg_wqsize_MASK				0x0000000f
 #define cfg_wqsize_WORD				word8
 #define cfg_wqv_SHIFT				14
 #define cfg_wqv_MASK				0x00000003
 #define cfg_wqv_WORD				word8
+#define cfg_wqpsize_SHIFT			16
+#define cfg_wqpsize_MASK			0x000000ff
+#define cfg_wqpsize_WORD			word8
 	uint32_t word9;
 	uint32_t word10;
 #define cfg_rqv_SHIFT				14
@@ -2897,6 +2975,12 @@ struct lpfc_sli4_parameters {
 #define cfg_mds_diags_SHIFT			1
 #define cfg_mds_diags_MASK			0x00000001
 #define cfg_mds_diags_WORD			word19
+#define cfg_nvme_SHIFT				3
+#define cfg_nvme_MASK				0x00000001
+#define cfg_nvme_WORD				word19
+#define cfg_xib_SHIFT				4
+#define cfg_xib_MASK				0x00000001
+#define cfg_xib_WORD				word19
 };
 
 #define LPFC_SET_UE_RECOVERY		0x10
@@ -3300,6 +3384,7 @@ struct lpfc_mqe {
 		struct lpfc_mbx_cq_create cq_create;
 		struct lpfc_mbx_wq_create wq_create;
 		struct lpfc_mbx_rq_create rq_create;
+		struct lpfc_mbx_rq_create_v2 rq_create_v2;
 		struct lpfc_mbx_mq_destroy mq_destroy;
 		struct lpfc_mbx_eq_destroy eq_destroy;
 		struct lpfc_mbx_cq_destroy cq_destroy;
@@ -3659,6 +3744,9 @@ struct wqe_common {
 #define wqe_ebde_cnt_SHIFT    0
 #define wqe_ebde_cnt_MASK     0x0000000f
 #define wqe_ebde_cnt_WORD     word10
+#define wqe_nvme_SHIFT        4
+#define wqe_nvme_MASK         0x00000001
+#define wqe_nvme_WORD         word10
 #define wqe_oas_SHIFT         6
 #define wqe_oas_MASK          0x00000001
 #define wqe_oas_WORD          word10
@@ -3719,9 +3807,18 @@ struct wqe_common {
 #define LPFC_ELS_ID_FDISC	2
 #define LPFC_ELS_ID_LOGO	1
 #define LPFC_ELS_ID_DEFAULT	0
+#define wqe_irsp_SHIFT        4
+#define wqe_irsp_MASK         0x00000001
+#define wqe_irsp_WORD         word11
+#define wqe_sup_SHIFT         6
+#define wqe_sup_MASK          0x00000001
+#define wqe_sup_WORD          word11
 #define wqe_wqec_SHIFT        7
 #define wqe_wqec_MASK         0x00000001
 #define wqe_wqec_WORD         word11
+#define wqe_irsplen_SHIFT     8
+#define wqe_irsplen_MASK      0x0000000f
+#define wqe_irsplen_WORD      word11
 #define wqe_cqid_SHIFT        16
 #define wqe_cqid_MASK         0x0000ffff
 #define wqe_cqid_WORD         word11
@@ -3971,6 +4068,35 @@ struct fcp_icmnd64_wqe {
 	uint32_t rsvd_12_15[4];        /* word 12-15 */
 };
 
+struct fcp_trsp64_wqe {
+	struct ulp_bde64 bde;
+	uint32_t response_len;
+	uint32_t rsvd_4_5[2];
+	struct wqe_common wqe_com;      /* words 6-11 */
+	uint32_t rsvd_12_15[4];         /* word 12-15 */
+};
+
+struct fcp_tsend64_wqe {
+	struct ulp_bde64 bde;
+	uint32_t payload_offset_len;
+	uint32_t relative_offset;
+	uint32_t reserved;
+	struct wqe_common wqe_com;     /* words 6-11 */
+	uint32_t fcp_data_len;         /* word 12 */
+	uint32_t rsvd_13_15[3];        /* word 13-15 */
+};
+
+struct fcp_treceive64_wqe {
+	struct ulp_bde64 bde;
+	uint32_t payload_offset_len;
+	uint32_t relative_offset;
+	uint32_t reserved;
+	struct wqe_common wqe_com;     /* words 6-11 */
+	uint32_t fcp_data_len;         /* word 12 */
+	uint32_t rsvd_13_15[3];        /* word 13-15 */
+};
+#define TXRDY_PAYLOAD_LEN      12
+
 
 union lpfc_wqe {
 	uint32_t words[16];
@@ -3986,6 +4112,10 @@ union lpfc_wqe {
 	struct xmit_els_rsp64_wqe xmit_els_rsp;
 	struct els_request64_wqe els_req;
 	struct gen_req64_wqe gen_req;
+	struct fcp_trsp64_wqe fcp_trsp;
+	struct fcp_tsend64_wqe fcp_tsend;
+	struct fcp_treceive64_wqe fcp_treceive;
+
 };
 
 union lpfc_wqe128 {
@@ -3994,6 +4124,9 @@ union lpfc_wqe128 {
 	struct fcp_icmnd64_wqe fcp_icmd;
 	struct fcp_iread64_wqe fcp_iread;
 	struct fcp_iwrite64_wqe fcp_iwrite;
+	struct fcp_trsp64_wqe fcp_trsp;
+	struct fcp_tsend64_wqe fcp_tsend;
+	struct fcp_treceive64_wqe fcp_treceive;
 	struct xmit_seq64_wqe xmit_sequence;
 	struct gen_req64_wqe gen_req;
 };
@@ -4017,11 +4150,39 @@ struct lpfc_grp_hdr {
 	uint8_t revision[32];
 };
 
-#define FCP_COMMAND 0x0
-#define FCP_COMMAND_DATA_OUT 0x1
-#define ELS_COMMAND_NON_FIP 0xC
-#define ELS_COMMAND_FIP 0xD
-#define OTHER_COMMAND 0x8
+/* Defines for WQE command type */
+#define FCP_COMMAND		0x0
+#define NVME_READ_CMD		0x0
+#define FCP_COMMAND_DATA_OUT	0x1
+#define NVME_WRITE_CMD		0x1
+#define FCP_COMMAND_TRECEIVE	0x2
+#define FCP_COMMAND_TRSP	0x3
+#define FCP_COMMAND_TSEND	0x7
+#define OTHER_COMMAND		0x8
+#define ELS_COMMAND_NON_FIP	0xC
+#define ELS_COMMAND_FIP		0xD
+
+#define LPFC_NVME_EMBED_CMD	0x0
+#define LPFC_NVME_EMBED_WRITE	0x1
+#define LPFC_NVME_EMBED_READ	0x2
+
+/* WQE Commands */
+#define CMD_ABORT_XRI_WQE       0x0F
+#define CMD_XMIT_SEQUENCE64_WQE 0x82
+#define CMD_XMIT_BCAST64_WQE    0x84
+#define CMD_ELS_REQUEST64_WQE   0x8A
+#define CMD_XMIT_ELS_RSP64_WQE  0x95
+#define CMD_XMIT_BLS_RSP64_WQE  0x97
+#define CMD_FCP_IWRITE64_WQE    0x98
+#define CMD_FCP_IREAD64_WQE     0x9A
+#define CMD_FCP_ICMND64_WQE     0x9C
+#define CMD_FCP_TSEND64_WQE     0x9F
+#define CMD_FCP_TRECEIVE64_WQE  0xA1
+#define CMD_FCP_TRSP64_WQE      0xA3
+#define CMD_GEN_REQUEST64_WQE   0xC2
+
+#define CMD_WQE_MASK            0xff
+
 
 #define LPFC_FW_DUMP	1
 #define LPFC_FW_RESET	2
diff --git a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
index 2a4e5d2..3faf7a0 100644
--- a/drivers/scsi/lpfc/lpfc_logmsg.h
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h
@@ -38,6 +38,10 @@
 #define LOG_FIP		0x00020000	/* FIP events */
 #define LOG_FCP_UNDER	0x00040000	/* FCP underruns errors */
 #define LOG_SCSI_CMD	0x00080000	/* ALL SCSI commands */
+#define LOG_NVME	0x00100000	/* NVME general events. */
+#define LOG_NVME_DISC   0x00200000      /* NVME Discovery/Connect events. */
+#define LOG_NVME_ABTS   0x00400000      /* NVME ABTS events. */
+#define LOG_NVME_IOERR  0x00800000      /* NVME IO Error events. */
 #define LOG_ALL_MSG	0xffffffff	/* LOG all messages */
 
 #define lpfc_printf_vlog(vport, level, mask, fmt, arg...) \
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index b234c50..8dd5a77 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -954,7 +954,7 @@ lpfc_config_pcb_setup(struct lpfc_hba * phba)
 	pcbp->maxRing = (psli->num_rings - 1);
 
 	for (i = 0; i < psli->num_rings; i++) {
-		pring = &psli->ring[i];
+		pring = &psli->sli3_ring[i];
 
 		pring->sli.sli3.sizeCiocb =
 			phba->sli_rev == 3 ? SLI3_IOCB_CMD_SIZE :
@@ -1217,7 +1217,7 @@ lpfc_config_ring(struct lpfc_hba * phba, int ring, LPFC_MBOXQ_t * pmb)
 	mb->un.varCfgRing.recvNotify = 1;
 
 	psli = &phba->sli;
-	pring = &psli->ring[ring];
+	pring = &psli->sli3_ring[ring];
 	mb->un.varCfgRing.numMask = pring->num_mask;
 	mb->mbxCommand = MBX_CONFIG_RING;
 	mb->mbxOwner = OWN_HOST;
@@ -1291,7 +1291,7 @@ lpfc_config_port(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 			mb->un.varCfgPort.cdss = 1; /* Configure Security */
 		mb->un.varCfgPort.cerbm = 1; /* Request HBQs */
 		mb->un.varCfgPort.ccrp = 1; /* Command Ring Polling */
-		mb->un.varCfgPort.max_hbq = lpfc_sli_hbq_count();
+		mb->un.varCfgPort.max_hbq = lpfc_sli_hbq_count(phba);
 		if (phba->max_vpi && phba->cfg_enable_npiv &&
 		    phba->vpd.sli3Feat.cmv) {
 			mb->un.varCfgPort.max_vpi = LPFC_MAX_VPI;
@@ -2328,7 +2328,7 @@ lpfc_mbx_cmpl_rdp_page_a0(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
 		goto error;
 
 	lpfc_sli_bemem_bcopy(mp->virt, &rdp_context->page_a0,
-				DMP_SFF_PAGE_A0_SIZE);
+			     DMP_SFF_PAGE_A0_SIZE);
 
 	memset(mbox, 0, sizeof(*mbox));
 
@@ -2434,14 +2434,25 @@ lpfc_reg_fcfi(struct lpfc_hba *phba, struct lpfcMboxq *mbox)
 	memset(mbox, 0, sizeof(*mbox));
 	reg_fcfi = &mbox->u.mqe.un.reg_fcfi;
 	bf_set(lpfc_mqe_command, &mbox->u.mqe, MBX_REG_FCFI);
-	bf_set(lpfc_reg_fcfi_rq_id0, reg_fcfi, phba->sli4_hba.hdr_rq->queue_id);
-	bf_set(lpfc_reg_fcfi_rq_id1, reg_fcfi, REG_FCF_INVALID_QID);
+	if (phba->nvmet_support == 0) {
+		bf_set(lpfc_reg_fcfi_rq_id0, reg_fcfi,
+		       phba->sli4_hba.hdr_rq->queue_id);
+		/* Match everything - rq_id0 */
+		bf_set(lpfc_reg_fcfi_type_match0, reg_fcfi, 0);
+		bf_set(lpfc_reg_fcfi_type_mask0, reg_fcfi, 0);
+		bf_set(lpfc_reg_fcfi_rctl_match0, reg_fcfi, 0);
+		bf_set(lpfc_reg_fcfi_rctl_mask0, reg_fcfi, 0);
+
+		bf_set(lpfc_reg_fcfi_rq_id1, reg_fcfi, REG_FCF_INVALID_QID);
+
+		/* addr mode is bit wise inverted value of fcf addr_mode */
+		bf_set(lpfc_reg_fcfi_mam, reg_fcfi,
+		       (~phba->fcf.addr_mode) & 0x3);
+	}
 	bf_set(lpfc_reg_fcfi_rq_id2, reg_fcfi, REG_FCF_INVALID_QID);
 	bf_set(lpfc_reg_fcfi_rq_id3, reg_fcfi, REG_FCF_INVALID_QID);
 	bf_set(lpfc_reg_fcfi_info_index, reg_fcfi,
 	       phba->fcf.current_rec.fcf_indx);
-	/* reg_fcf addr mode is bit wise inverted value of fcf addr_mode */
-	bf_set(lpfc_reg_fcfi_mam, reg_fcfi, (~phba->fcf.addr_mode) & 0x3);
 	if (phba->fcf.current_rec.vlan_id != LPFC_FCOE_NULL_VID) {
 		bf_set(lpfc_reg_fcfi_vv, reg_fcfi, 1);
 		bf_set(lpfc_reg_fcfi_vlan_tag, reg_fcfi,
diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index 3fa6533..c65a1ec 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -24,10 +24,12 @@
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 
+#include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_transport_fc.h>
+#include <scsi/fc/fc_fs.h>
 
-#include <scsi/scsi.h>
+#include <linux/nvme-fc-driver.h>
 
 #include "lpfc_hw4.h"
 #include "lpfc_hw.h"
@@ -35,8 +37,9 @@
 #include "lpfc_sli4.h"
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
-#include "lpfc_scsi.h"
 #include "lpfc.h"
+#include "lpfc_scsi.h"
+#include "lpfc_nvme.h"
 #include "lpfc_crtn.h"
 #include "lpfc_logmsg.h"
 
@@ -66,7 +69,7 @@ lpfc_mem_alloc_active_rrq_pool_s4(struct lpfc_hba *phba) {
  * lpfc_mem_alloc - create and allocate all PCI and memory pools
  * @phba: HBA to allocate pools for
  *
- * Description: Creates and allocates PCI pools lpfc_scsi_dma_buf_pool,
+ * Description: Creates and allocates PCI pools lpfc_sg_dma_buf_pool,
  * lpfc_mbuf_pool, lpfc_hrb_pool.  Creates and allocates kmalloc-backed mempools
  * for LPFC_MBOXQ_t and lpfc_nodelist.  Also allocates the VPI bitmask.
  *
@@ -90,21 +93,23 @@ lpfc_mem_alloc(struct lpfc_hba *phba, int align)
 		else
 			i = SLI4_PAGE_SIZE;
 
-		phba->lpfc_scsi_dma_buf_pool =
-			pci_pool_create("lpfc_scsi_dma_buf_pool",
-				phba->pcidev,
-				phba->cfg_sg_dma_buf_size,
-				i,
-				0);
+		phba->lpfc_sg_dma_buf_pool =
+			pci_pool_create("lpfc_sg_dma_buf_pool",
+					phba->pcidev,
+					phba->cfg_sg_dma_buf_size,
+					i, 0);
+		if (!phba->lpfc_sg_dma_buf_pool)
+			goto fail;
+
 	} else {
-		phba->lpfc_scsi_dma_buf_pool =
-			pci_pool_create("lpfc_scsi_dma_buf_pool",
-				phba->pcidev, phba->cfg_sg_dma_buf_size,
-				align, 0);
-	}
+		phba->lpfc_sg_dma_buf_pool =
+			pci_pool_create("lpfc_sg_dma_buf_pool",
+					phba->pcidev, phba->cfg_sg_dma_buf_size,
+					align, 0);
 
-	if (!phba->lpfc_scsi_dma_buf_pool)
-		goto fail;
+		if (!phba->lpfc_sg_dma_buf_pool)
+			goto fail;
+	}
 
 	phba->lpfc_mbuf_pool = pci_pool_create("lpfc_mbuf_pool", phba->pcidev,
 							LPFC_BPL_SIZE,
@@ -170,12 +175,15 @@ lpfc_mem_alloc(struct lpfc_hba *phba, int align)
 					LPFC_DEVICE_DATA_POOL_SIZE,
 					sizeof(struct lpfc_device_data));
 		if (!phba->device_data_mem_pool)
-			goto fail_free_hrb_pool;
+			goto fail_free_drb_pool;
 	} else {
 		phba->device_data_mem_pool = NULL;
 	}
 
 	return 0;
+fail_free_drb_pool:
+	pci_pool_destroy(phba->lpfc_drb_pool);
+	phba->lpfc_drb_pool = NULL;
  fail_free_hrb_pool:
 	pci_pool_destroy(phba->lpfc_hrb_pool);
 	phba->lpfc_hrb_pool = NULL;
@@ -197,8 +205,8 @@ lpfc_mem_alloc(struct lpfc_hba *phba, int align)
 	pci_pool_destroy(phba->lpfc_mbuf_pool);
 	phba->lpfc_mbuf_pool = NULL;
  fail_free_dma_buf_pool:
-	pci_pool_destroy(phba->lpfc_scsi_dma_buf_pool);
-	phba->lpfc_scsi_dma_buf_pool = NULL;
+	pci_pool_destroy(phba->lpfc_sg_dma_buf_pool);
+	phba->lpfc_sg_dma_buf_pool = NULL;
  fail:
 	return -ENOMEM;
 }
@@ -227,6 +235,9 @@ lpfc_mem_free(struct lpfc_hba *phba)
 	if (phba->lpfc_hrb_pool)
 		pci_pool_destroy(phba->lpfc_hrb_pool);
 	phba->lpfc_hrb_pool = NULL;
+	if (phba->txrdy_payload_pool)
+		pci_pool_destroy(phba->txrdy_payload_pool);
+	phba->txrdy_payload_pool = NULL;
 
 	if (phba->lpfc_hbq_pool)
 		pci_pool_destroy(phba->lpfc_hbq_pool);
@@ -258,8 +269,8 @@ lpfc_mem_free(struct lpfc_hba *phba)
 	phba->lpfc_mbuf_pool = NULL;
 
 	/* Free DMA buffer memory pool */
-	pci_pool_destroy(phba->lpfc_scsi_dma_buf_pool);
-	phba->lpfc_scsi_dma_buf_pool = NULL;
+	pci_pool_destroy(phba->lpfc_sg_dma_buf_pool);
+	phba->lpfc_sg_dma_buf_pool = NULL;
 
 	/* Free Device Data memory pool */
 	if (phba->device_data_mem_pool) {
@@ -282,7 +293,7 @@ lpfc_mem_free(struct lpfc_hba *phba)
  * @phba: HBA to free memory for
  *
  * Description: Free memory from PCI and driver memory pools and also those
- * used : lpfc_scsi_dma_buf_pool, lpfc_mbuf_pool, lpfc_hrb_pool. Frees
+ * used : lpfc_sg_dma_buf_pool, lpfc_mbuf_pool, lpfc_hrb_pool. Frees
  * kmalloc-backed mempools for LPFC_MBOXQ_t and lpfc_nodelist. Also frees
  * the VPI bitmask.
  *
@@ -458,7 +469,7 @@ lpfc_els_hbq_alloc(struct lpfc_hba *phba)
 		kfree(hbqbp);
 		return NULL;
 	}
-	hbqbp->size = LPFC_BPL_SIZE;
+	hbqbp->total_size = LPFC_BPL_SIZE;
 	return hbqbp;
 }
 
@@ -518,7 +529,7 @@ lpfc_sli4_rb_alloc(struct lpfc_hba *phba)
 		kfree(dma_buf);
 		return NULL;
 	}
-	dma_buf->size = LPFC_BPL_SIZE;
+	dma_buf->total_size = LPFC_DATA_BUF_SIZE;
 	return dma_buf;
 }
 
@@ -540,7 +551,6 @@ lpfc_sli4_rb_free(struct lpfc_hba *phba, struct hbq_dmabuf *dmab)
 	pci_pool_free(phba->lpfc_hrb_pool, dmab->hbuf.virt, dmab->hbuf.phys);
 	pci_pool_free(phba->lpfc_drb_pool, dmab->dbuf.virt, dmab->dbuf.phys);
 	kfree(dmab);
-	return;
 }
 
 /**
@@ -565,13 +575,13 @@ lpfc_in_buf_free(struct lpfc_hba *phba, struct lpfc_dmabuf *mp)
 		return;
 
 	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
+		hbq_entry = container_of(mp, struct hbq_dmabuf, dbuf);
 		/* Check whether HBQ is still in use */
 		spin_lock_irqsave(&phba->hbalock, flags);
 		if (!phba->hbq_in_use) {
 			spin_unlock_irqrestore(&phba->hbalock, flags);
 			return;
 		}
-		hbq_entry = container_of(mp, struct hbq_dmabuf, dbuf);
 		list_del(&hbq_entry->dbuf.list);
 		if (hbq_entry->tag == -1) {
 			(phba->hbqs[LPFC_ELS_HBQ].hbq_free_buffer)
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 56a3df4..835ea9f 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -204,10 +204,11 @@ int
 lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 {
 	LIST_HEAD(abort_list);
-	struct lpfc_sli  *psli = &phba->sli;
-	struct lpfc_sli_ring *pring = &psli->ring[LPFC_ELS_RING];
+	struct lpfc_sli_ring *pring;
 	struct lpfc_iocbq *iocb, *next_iocb;
 
+	pring = lpfc_phba_elsring(phba);
+
 	/* Abort outstanding I/O on NPort <nlp_DID> */
 	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_DISCOVERY,
 			 "2819 Abort outstanding I/O on NPort x%x "
@@ -2104,7 +2105,7 @@ lpfc_rcv_prlo_mapped_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	struct lpfc_iocbq *cmdiocb = (struct lpfc_iocbq *) arg;
 
 	/* flush the target */
-	lpfc_sli_abort_iocb(vport, &phba->sli.ring[phba->sli.fcp_ring],
+	lpfc_sli_abort_iocb(vport, &phba->sli.sli3_ring[LPFC_FCP_RING],
 			    ndlp->nlp_sid, 0, LPFC_CTX_TGT);
 
 	/* Treat like rcv logo */
diff --git a/drivers/scsi/lpfc/lpfc_nvme.h b/drivers/scsi/lpfc/lpfc_nvme.h
new file mode 100644
index 0000000..2b16793
--- /dev/null
+++ b/drivers/scsi/lpfc/lpfc_nvme.h
@@ -0,0 +1,88 @@
+/*******************************************************************
+ * This file is part of the Emulex Linux Device Driver for         *
+ * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
+ * EMULEX and SLI are trademarks of Emulex.                        *
+ * www.emulex.com                                                  *
+ * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
+ *                                                                 *
+ * This program is free software; you can redistribute it and/or   *
+ * modify it under the terms of version 2 of the GNU General       *
+ * Public License as published by the Free Software Foundation.    *
+ * This program is distributed in the hope that it will be useful. *
+ * ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND          *
+ * WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,  *
+ * FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT, ARE      *
+ * DISCLAIMED, EXCEPT TO THE EXTENT THAT SUCH DISCLAIMERS ARE HELD *
+ * TO BE LEGALLY INVALID.  See the GNU General Public License for  *
+ * more details, a copy of which can be found in the file COPYING  *
+ * included with this package.                                     *
+ ********************************************************************/
+
+#define LPFC_NVME_MIN_SEGS		16
+#define LPFC_NVME_DEFAULT_SEGS		66	/* 256K IOs - 64 + 2 */
+#define LPFC_NVME_MAX_SEGS		510
+#define LPFC_NVMET_MIN_POSTBUF		16
+#define LPFC_NVMET_DEFAULT_POSTBUF	1024
+#define LPFC_NVMET_MAX_POSTBUF		4096
+#define LPFC_NVME_WQSIZE		256
+
+#define LPFC_NVME_ERSP_LEN		0x20
+
+/* Declare nvme-based local and remote port definitions. */
+struct lpfc_nvme_lport {
+	struct lpfc_vport *vport;
+	struct list_head rport_list;
+	struct completion lport_unreg_done;
+	/* Add sttats counters here */
+};
+
+struct lpfc_nvme_rport {
+	struct list_head list;
+	struct lpfc_nvme_lport *lport;
+	struct nvme_fc_remote_port *remoteport;
+	struct lpfc_nodelist *ndlp;
+	struct completion rport_unreg_done;
+};
+
+struct lpfc_nvme_buf {
+	struct list_head list;
+	struct nvmefc_fcp_req *nvmeCmd;
+	struct lpfc_nvme_rport *nrport;
+
+	uint32_t timeout;
+
+	uint16_t flags;  /* TBD convert exch_busy to flags */
+#define LPFC_SBUF_XBUSY         0x1     /* SLI4 hba reported XB on WCQE cmpl */
+	uint16_t exch_busy;     /* SLI4 hba reported XB on complete WCQE */
+	uint16_t status;	/* From IOCB Word 7- ulpStatus */
+	uint16_t cpu;
+	uint16_t qidx;
+	uint16_t sqid;
+	uint32_t result;	/* From IOCB Word 4. */
+
+	uint32_t   seg_cnt;	/* Number of scatter-gather segments returned by
+				 * dma_map_sg.  The driver needs this for calls
+				 * to dma_unmap_sg.
+				 */
+	dma_addr_t nonsg_phys;	/* Non scatter-gather physical address. */
+
+	/*
+	 * data and dma_handle are the kernel virtual and bus address of the
+	 * dma-able buffer containing the fcp_cmd, fcp_rsp and a scatter
+	 * gather bde list that supports the sg_tablesize value.
+	 */
+	void *data;
+	dma_addr_t dma_handle;
+
+	struct sli4_sge *nvme_sgl;
+	dma_addr_t dma_phys_sgl;
+
+	/* cur_iocbq has phys of the dma-able buffer.
+	 * Iotag is in here
+	 */
+	struct lpfc_iocbq cur_iocbq;
+
+	wait_queue_head_t *waitq;
+	unsigned long start_time;
+};
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 19d349f..825b5e8 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -413,7 +413,7 @@ lpfc_new_scsi_buf_s3(struct lpfc_vport *vport, int num_to_alloc)
 		 * struct fcp_cmnd, struct fcp_rsp and the number of bde's
 		 * necessary to support the sg_tablesize.
 		 */
-		psb->data = pci_pool_zalloc(phba->lpfc_scsi_dma_buf_pool,
+		psb->data = pci_pool_zalloc(phba->lpfc_sg_dma_buf_pool,
 					GFP_KERNEL, &psb->dma_handle);
 		if (!psb->data) {
 			kfree(psb);
@@ -424,8 +424,8 @@ lpfc_new_scsi_buf_s3(struct lpfc_vport *vport, int num_to_alloc)
 		/* Allocate iotag for psb->cur_iocbq. */
 		iotag = lpfc_sli_next_iotag(phba, &psb->cur_iocbq);
 		if (iotag == 0) {
-			pci_pool_free(phba->lpfc_scsi_dma_buf_pool,
-					psb->data, psb->dma_handle);
+			pci_pool_free(phba->lpfc_sg_dma_buf_pool,
+				      psb->data, psb->dma_handle);
 			kfree(psb);
 			break;
 		}
@@ -522,6 +522,8 @@ lpfc_sli4_vport_delete_fcp_xri_aborted(struct lpfc_vport *vport)
 	struct lpfc_scsi_buf *psb, *next_psb;
 	unsigned long iflag = 0;
 
+	if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP))
+		return;
 	spin_lock_irqsave(&phba->hbalock, iflag);
 	spin_lock(&phba->sli4_hba.abts_scsi_buf_list_lock);
 	list_for_each_entry_safe(psb, next_psb,
@@ -554,8 +556,10 @@ lpfc_sli4_fcp_xri_aborted(struct lpfc_hba *phba,
 	int i;
 	struct lpfc_nodelist *ndlp;
 	int rrq_empty = 0;
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
+	struct lpfc_sli_ring *pring = phba->sli4_hba.els_wq->pring;
 
+	if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP))
+		return;
 	spin_lock_irqsave(&phba->hbalock, iflag);
 	spin_lock(&phba->sli4_hba.abts_scsi_buf_list_lock);
 	list_for_each_entry_safe(psb, next_psb,
@@ -819,7 +823,7 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *vport, int num_to_alloc)
 		 * for the struct fcp_cmnd, struct fcp_rsp and the number
 		 * of bde's necessary to support the sg_tablesize.
 		 */
-		psb->data = pci_pool_zalloc(phba->lpfc_scsi_dma_buf_pool,
+		psb->data = pci_pool_zalloc(phba->lpfc_sg_dma_buf_pool,
 						GFP_KERNEL, &psb->dma_handle);
 		if (!psb->data) {
 			kfree(psb);
@@ -832,7 +836,7 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *vport, int num_to_alloc)
 		 */
 		if (phba->cfg_enable_bg  && (((unsigned long)(psb->data) &
 		    (unsigned long)(SLI4_PAGE_SIZE - 1)) != 0)) {
-			pci_pool_free(phba->lpfc_scsi_dma_buf_pool,
+			pci_pool_free(phba->lpfc_sg_dma_buf_pool,
 				      psb->data, psb->dma_handle);
 			kfree(psb);
 			break;
@@ -841,8 +845,8 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *vport, int num_to_alloc)
 
 		lxri = lpfc_sli4_next_xritag(phba);
 		if (lxri == NO_XRI) {
-			pci_pool_free(phba->lpfc_scsi_dma_buf_pool,
-			      psb->data, psb->dma_handle);
+			pci_pool_free(phba->lpfc_sg_dma_buf_pool,
+				      psb->data, psb->dma_handle);
 			kfree(psb);
 			break;
 		}
@@ -850,8 +854,8 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *vport, int num_to_alloc)
 		/* Allocate iotag for psb->cur_iocbq. */
 		iotag = lpfc_sli_next_iotag(phba, &psb->cur_iocbq);
 		if (iotag == 0) {
-			pci_pool_free(phba->lpfc_scsi_dma_buf_pool,
-				psb->data, psb->dma_handle);
+			pci_pool_free(phba->lpfc_sg_dma_buf_pool,
+				      psb->data, psb->dma_handle);
 			kfree(psb);
 			lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
 					"3368 Failed to allocate IOTAG for"
@@ -920,7 +924,7 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *vport, int num_to_alloc)
 		phba->sli4_hba.scsi_xri_cnt++;
 		spin_unlock_irq(&phba->scsi_buf_list_get_lock);
 	}
-	lpfc_printf_log(phba, KERN_INFO, LOG_BG,
+	lpfc_printf_log(phba, KERN_INFO, LOG_BG | LOG_FCP,
 			"3021 Allocate %d out of %d requested new SCSI "
 			"buffers\n", bcnt, num_to_alloc);
 
@@ -946,7 +950,7 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *vport, int num_to_alloc)
  *   int - number of scsi buffers that were allocated.
  *   0 = failure, less than num_to_alloc is a partial failure.
  **/
-static inline int
+int
 lpfc_new_scsi_buf(struct lpfc_vport *vport, int num_to_alloc)
 {
 	return vport->phba->lpfc_new_scsi_buf(vport, num_to_alloc);
@@ -1045,7 +1049,7 @@ lpfc_get_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
  *   NULL - Error
  *   Pointer to lpfc_scsi_buf - Success
  **/
-static struct lpfc_scsi_buf*
+struct lpfc_scsi_buf*
 lpfc_get_scsi_buf(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 {
 	return  phba->lpfc_get_scsi_buf(phba, ndlp);
@@ -1119,7 +1123,7 @@ lpfc_release_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
  * This routine releases @psb scsi buffer by adding it to tail of @phba
  * lpfc_scsi_buf_list list.
  **/
-static void
+void
 lpfc_release_scsi_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
 {
 
@@ -3894,7 +3898,7 @@ int lpfc_sli4_scmd_to_wqidx_distr(struct lpfc_hba *phba,
 		}
 	}
 	chann = atomic_add_return(1, &phba->fcp_qidx);
-	chann = (chann % phba->cfg_fcp_io_channel);
+	chann = chann % phba->cfg_fcp_io_channel;
 	return chann;
 }
 
@@ -3925,6 +3929,8 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	struct Scsi_Host *shost;
 	uint32_t logit = LOG_FCP;
 
+	phba->fc4ScsiIoCmpls++;
+
 	/* Sanity check on return of outstanding command */
 	cmd = lpfc_cmd->pCmd;
 	if (!cmd)
@@ -3967,6 +3973,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 		lpfc_cmd->prot_data_segment = NULL;
 	}
 #endif
+
 	if (pnode && NLP_CHK_NODE_ACT(pnode))
 		atomic_dec(&pnode->cmd_pending);
 
@@ -4241,19 +4248,19 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 						vport->cfg_first_burst_size;
 			}
 			fcp_cmnd->fcpCntl3 = WRITE_DATA;
-			phba->fc4OutputRequests++;
+			phba->fc4ScsiOutputRequests++;
 		} else {
 			iocb_cmd->ulpCommand = CMD_FCP_IREAD64_CR;
 			iocb_cmd->ulpPU = PARM_READ_CHECK;
 			fcp_cmnd->fcpCntl3 = READ_DATA;
-			phba->fc4InputRequests++;
+			phba->fc4ScsiInputRequests++;
 		}
 	} else {
 		iocb_cmd->ulpCommand = CMD_FCP_ICMND64_CR;
 		iocb_cmd->un.fcpi.fcpi_parm = 0;
 		iocb_cmd->ulpPU = 0;
 		fcp_cmnd->fcpCntl3 = 0;
-		phba->fc4ControlRequests++;
+		phba->fc4ScsiControlRequests++;
 	}
 	if (phba->sli_rev == 3 &&
 	    !(phba->sli3_options & LPFC_SLI3_BG_ENABLED))
@@ -4467,7 +4474,7 @@ static __inline__ void lpfc_poll_rearm_timer(struct lpfc_hba * phba)
 	unsigned long  poll_tmo_expires =
 		(jiffies + msecs_to_jiffies(phba->cfg_poll_tmo));
 
-	if (!list_empty(&phba->sli.ring[LPFC_FCP_RING].txcmplq))
+	if (!list_empty(&phba->sli.sli3_ring[LPFC_FCP_RING].txcmplq))
 		mod_timer(&phba->fcp_poll_timer,
 			  poll_tmo_expires);
 }
@@ -4497,7 +4504,7 @@ void lpfc_poll_timeout(unsigned long ptr)
 
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
 		lpfc_sli_handle_fast_ring_event(phba,
-			&phba->sli.ring[LPFC_FCP_RING], HA_R0RE_REQ);
+			&phba->sli.sli3_ring[LPFC_FCP_RING], HA_R0RE_REQ);
 
 		if (phba->cfg_poll & DISABLE_FCP_RING_INT)
 			lpfc_poll_rearm_timer(phba);
@@ -4561,7 +4568,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	if (lpfc_cmd == NULL) {
 		lpfc_rampdown_queue_depth(phba);
 
-		lpfc_printf_vlog(vport, KERN_INFO, LOG_MISC,
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP_ERROR,
 				 "0707 driver's buffer pool is empty, "
 				 "IO busied\n");
 		goto out_host_busy;
@@ -4636,7 +4643,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	}
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
 		lpfc_sli_handle_fast_ring_event(phba,
-			&phba->sli.ring[LPFC_FCP_RING], HA_R0RE_REQ);
+			&phba->sli.sli3_ring[LPFC_FCP_RING], HA_R0RE_REQ);
 
 		if (phba->cfg_poll & DISABLE_FCP_RING_INT)
 			lpfc_poll_rearm_timer(phba);
@@ -4681,7 +4688,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 	IOCB_t *cmd, *icmd;
 	int ret = SUCCESS, status = 0;
 	struct lpfc_sli_ring *pring_s4;
-	int ring_number, ret_val;
+	int ret_val;
 	unsigned long flags, iflags;
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
 
@@ -4769,7 +4776,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 	icmd->ulpClass = cmd->ulpClass;
 
 	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
-	abtsiocb->fcp_wqidx = iocb->fcp_wqidx;
+	abtsiocb->hba_wqidx = iocb->hba_wqidx;
 	abtsiocb->iocb_flag |= LPFC_USE_FCPWQIDX;
 	if (iocb->iocb_flag & LPFC_IO_FOF)
 		abtsiocb->iocb_flag |= LPFC_IO_FOF;
@@ -4782,8 +4789,11 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 	abtsiocb->iocb_cmpl = lpfc_sli_abort_fcp_cmpl;
 	abtsiocb->vport = vport;
 	if (phba->sli_rev == LPFC_SLI_REV4) {
-		ring_number = MAX_SLI3_CONFIGURED_RINGS + iocb->fcp_wqidx;
-		pring_s4 = &phba->sli.ring[ring_number];
+		pring_s4 = lpfc_sli4_calc_ring(phba, iocb);
+		if (pring_s4 == NULL) {
+			ret = FAILED;
+			goto out_unlock;
+		}
 		/* Note: both hbalock and ring_lock must be set here */
 		spin_lock_irqsave(&pring_s4->ring_lock, iflags);
 		ret_val = __lpfc_sli_issue_iocb(phba, pring_s4->ringno,
@@ -4805,7 +4815,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 
 	if (phba->cfg_poll & DISABLE_FCP_RING_INT)
 		lpfc_sli_handle_fast_ring_event(phba,
-			&phba->sli.ring[LPFC_FCP_RING], HA_R0RE_REQ);
+			&phba->sli.sli3_ring[LPFC_FCP_RING], HA_R0RE_REQ);
 
 wait_for_cmpl:
 	lpfc_cmd->waitq = &waitq;
@@ -5105,7 +5115,7 @@ lpfc_reset_flush_io_context(struct lpfc_vport *vport, uint16_t tgt_id,
 	cnt = lpfc_sli_sum_iocb(vport, tgt_id, lun_id, context);
 	if (cnt)
 		lpfc_sli_abort_taskmgmt(vport,
-					&phba->sli.ring[phba->sli.fcp_ring],
+					&phba->sli.sli3_ring[LPFC_FCP_RING],
 					tgt_id, lun_id, context);
 	later = msecs_to_jiffies(2 * vport->cfg_devloss_tmo * 1000) + jiffies;
 	while (time_after(later, jiffies) && cnt) {
@@ -5534,7 +5544,7 @@ lpfc_slave_configure(struct scsi_device *sdev)
 
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
 		lpfc_sli_handle_fast_ring_event(phba,
-			&phba->sli.ring[LPFC_FCP_RING], HA_R0RE_REQ);
+			&phba->sli.sli3_ring[LPFC_FCP_RING], HA_R0RE_REQ);
 		if (phba->cfg_poll & DISABLE_FCP_RING_INT)
 			lpfc_poll_rearm_timer(phba);
 	}
@@ -5898,6 +5908,48 @@ lpfc_disable_oas_lun(struct lpfc_hba *phba, struct lpfc_name *vport_wwpn,
 	return false;
 }
 
+static int
+lpfc_no_command(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
+{
+	return SCSI_MLQUEUE_HOST_BUSY;
+}
+
+static int
+lpfc_no_handler(struct scsi_cmnd *cmnd)
+{
+	return FAILED;
+}
+
+static int
+lpfc_no_slave(struct scsi_device *sdev)
+{
+	return -ENODEV;
+}
+
+struct scsi_host_template lpfc_template_nvme = {
+	.module			= THIS_MODULE,
+	.name			= LPFC_DRIVER_NAME,
+	.proc_name		= LPFC_DRIVER_NAME,
+	.info			= lpfc_info,
+	.queuecommand		= lpfc_no_command,
+	.eh_abort_handler	= lpfc_no_handler,
+	.eh_device_reset_handler = lpfc_no_handler,
+	.eh_target_reset_handler = lpfc_no_handler,
+	.eh_bus_reset_handler	= lpfc_no_handler,
+	.eh_host_reset_handler  = lpfc_no_handler,
+	.slave_alloc		= lpfc_no_slave,
+	.slave_configure	= lpfc_no_slave,
+	.scan_finished		= lpfc_scan_finished,
+	.this_id		= -1,
+	.sg_tablesize		= 1,
+	.cmd_per_lun		= 1,
+	.use_clustering		= ENABLE_CLUSTERING,
+	.shost_attrs		= lpfc_hba_attrs,
+	.max_sectors		= 0xFFFF,
+	.vendor_id		= LPFC_NL_VENDOR_ID,
+	.track_queue_depth	= 0,
+};
+
 struct scsi_host_template lpfc_template_s3 = {
 	.module			= THIS_MODULE,
 	.name			= LPFC_DRIVER_NAME,
diff --git a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
index 8cb80da..def0c0a5 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.h
+++ b/drivers/scsi/lpfc/lpfc_scsi.h
@@ -135,6 +135,8 @@ struct lpfc_scsi_buf {
 
 	uint32_t timeout;
 
+	uint16_t flags;  /* TBD convert exch_busy to flags */
+#define LPFC_SBUF_XBUSY         0x1     /* SLI4 hba reported XB on WCQE cmpl */
 	uint16_t exch_busy;     /* SLI4 hba reported XB on complete WCQE */
 	uint16_t status;	/* From IOCB Word 7- ulpStatus */
 	uint32_t result;	/* From IOCB Word 4. */
@@ -164,6 +166,8 @@ struct lpfc_scsi_buf {
 	 * Iotag is in here
 	 */
 	struct lpfc_iocbq cur_iocbq;
+	uint16_t cpu;
+
 	wait_queue_head_t *waitq;
 	unsigned long start_time;
 
@@ -178,13 +182,15 @@ struct lpfc_scsi_buf {
 #endif
 };
 
-#define LPFC_SCSI_DMA_EXT_SIZE 264
-#define LPFC_BPL_SIZE          1024
-#define MDAC_DIRECT_CMD                  0x22
+#define LPFC_SCSI_DMA_EXT_SIZE	264
+#define LPFC_BPL_SIZE		1024
+#define MDAC_DIRECT_CMD		0x22
+
+#define FIND_FIRST_OAS_LUN	0
+#define NO_MORE_OAS_LUN		-1
+#define NOT_OAS_ENABLED_LUN	NO_MORE_OAS_LUN
 
-#define FIND_FIRST_OAS_LUN		 0
-#define NO_MORE_OAS_LUN			-1
-#define NOT_OAS_ENABLED_LUN		NO_MORE_OAS_LUN
+#define TXRDY_PAYLOAD_LEN	12
 
 int lpfc_sli4_scmd_to_wqidx_distr(struct lpfc_hba *phba,
 				  struct lpfc_scsi_buf *lpfc_cmd);
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index 74227a2..acb431f 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -54,9 +54,16 @@ struct lpfc_iocbq {
 	uint16_t iotag;         /* pre-assigned IO tag */
 	uint16_t sli4_lxritag;  /* logical pre-assigned XRI. */
 	uint16_t sli4_xritag;   /* pre-assigned XRI, (OXID) tag. */
+	uint16_t hba_wqidx;     /* index to HBA work queue */
 	struct lpfc_cq_event cq_event;
+	struct lpfc_wcqe_complete wcqe_cmpl;	/* WQE cmpl */
+	uint64_t isr_timestamp;
 
-	IOCB_t iocb;		/* IOCB cmd */
+	/* Be careful here */
+	union lpfc_wqe wqe;	/* WQE cmd */
+	IOCB_t iocb;		/* For IOCB cmd or if we want 128 byte WQE */
+
+	uint8_t rsvd2;
 	uint8_t priority;	/* OAS priority */
 	uint8_t retry;		/* retry counter for IOCB cmd - if needed */
 	uint32_t iocb_flag;
@@ -82,9 +89,12 @@ struct lpfc_iocbq {
 #define LPFC_IO_OAS		0x10000 /* OAS FCP IO */
 #define LPFC_IO_FOF		0x20000 /* FOF FCP IO */
 #define LPFC_IO_LOOPBACK	0x40000 /* Loopback IO */
+#define LPFC_PRLI_NVME_REQ	0x80000 /* This is an NVME PRLI. */
+#define LPFC_PRLI_FCP_REQ	0x100000 /* This is an NVME PRLI. */
+#define LPFC_IO_NVME	        0x200000 /* NVME FCP command */
+#define LPFC_IO_NVME_LS		0x400000 /* NVME LS command */
 
 	uint32_t drvrTimeout;	/* driver timeout in seconds */
-	uint32_t fcp_wqidx;	/* index to FCP work queue */
 	struct lpfc_vport *vport;/* virtual port pointer */
 	void *context1;		/* caller context information */
 	void *context2;		/* caller context information */
@@ -97,12 +107,14 @@ struct lpfc_iocbq {
 		struct lpfc_node_rrq *rrq;
 	} context_un;
 
-	void (*fabric_iocb_cmpl) (struct lpfc_hba *, struct lpfc_iocbq *,
+	void (*fabric_iocb_cmpl)(struct lpfc_hba *, struct lpfc_iocbq *,
 			   struct lpfc_iocbq *);
-	void (*wait_iocb_cmpl) (struct lpfc_hba *, struct lpfc_iocbq *,
+	void (*wait_iocb_cmpl)(struct lpfc_hba *, struct lpfc_iocbq *,
 			   struct lpfc_iocbq *);
-	void (*iocb_cmpl) (struct lpfc_hba *, struct lpfc_iocbq *,
+	void (*iocb_cmpl)(struct lpfc_hba *, struct lpfc_iocbq *,
 			   struct lpfc_iocbq *);
+	void (*wqe_cmpl)(struct lpfc_hba *, struct lpfc_iocbq *,
+			  struct lpfc_wcqe_complete *);
 };
 
 #define SLI_IOCB_RET_IOCB      1	/* Return IOCB if cmd ring full */
@@ -112,6 +124,14 @@ struct lpfc_iocbq {
 #define IOCB_ERROR          2
 #define IOCB_TIMEDOUT       3
 
+#define SLI_WQE_RET_WQE    1    /* Return WQE if cmd ring full */
+
+#define WQE_SUCCESS        0
+#define WQE_BUSY           1
+#define WQE_ERROR          2
+#define WQE_TIMEDOUT       3
+#define WQE_ABORTED        4
+
 #define LPFC_MBX_WAKE		1
 #define LPFC_MBX_IMED_UNREG	2
 
@@ -297,12 +317,9 @@ struct lpfc_sli {
 #define LPFC_BLOCK_MGMT_IO        0x800	/* Don't allow mgmt mbx or iocb cmds */
 #define LPFC_MENLO_MAINT          0x1000 /* need for menl fw download */
 #define LPFC_SLI_ASYNC_MBX_BLK    0x2000 /* Async mailbox is blocked */
+#define LPFC_SLI_SUPPRESS_RSP     0x4000 /* Suppress RSP feature is supported */
 
-	struct lpfc_sli_ring *ring;
-	int fcp_ring;		/* ring used for FCP initiator commands */
-	int next_ring;
-
-	int extra_ring;		/* extra ring used for other protocols */
+	struct lpfc_sli_ring *sli3_ring;
 
 	struct lpfc_sli_stat slistat;	/* SLI statistical info */
 	struct list_head mboxq;
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index dfbb25e..b5b4f6b 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -35,9 +35,10 @@
 #define LPFC_NEMBED_MBOX_SGL_CNT		254
 
 /* Multi-queue arrangement for FCP EQ/CQ/WQ tuples */
-#define LPFC_FCP_IO_CHAN_DEF       4
-#define LPFC_FCP_IO_CHAN_MIN       1
-#define LPFC_FCP_IO_CHAN_MAX       16
+#define LPFC_HBA_IO_CHAN_MIN	0
+#define LPFC_HBA_IO_CHAN_MAX	32
+#define LPFC_FCP_IO_CHAN_DEF	4
+#define LPFC_NVME_IO_CHAN_DEF	0
 
 /* Number of channels used for Flash Optimized Fabric (FOF) operations */
 
@@ -107,6 +108,8 @@ enum lpfc_sli4_queue_subtype {
 	LPFC_MBOX,
 	LPFC_FCP,
 	LPFC_ELS,
+	LPFC_NVME,
+	LPFC_NVME_LS,
 	LPFC_USOL
 };
 
@@ -125,25 +128,41 @@ union sli4_qe {
 	struct lpfc_rqe *rqe;
 };
 
+/* RQ buffer list */
+struct lpfc_rqb {
+	uint16_t entry_count;	  /* Current number of RQ slots */
+	uint16_t buffer_count;	  /* Current number of buffers posted */
+	struct list_head rqb_buffer_list;  /* buffers assigned to this HBQ */
+				  /* Callback for HBQ buffer allocation */
+	struct rqb_dmabuf *(*rqb_alloc_buffer)(struct lpfc_hba *);
+				  /* Callback for HBQ buffer free */
+	void               (*rqb_free_buffer)(struct lpfc_hba *,
+					       struct rqb_dmabuf *);
+};
+
 struct lpfc_queue {
 	struct list_head list;
+	struct list_head wq_list;
 	enum lpfc_sli4_queue_type type;
 	enum lpfc_sli4_queue_subtype subtype;
 	struct lpfc_hba *phba;
 	struct list_head child_list;
+	struct list_head page_list;
+	struct list_head sgl_list;
 	uint32_t entry_count;	/* Number of entries to support on the queue */
 	uint32_t entry_size;	/* Size of each queue entry. */
 	uint32_t entry_repost;	/* Count of entries before doorbell is rung */
 #define LPFC_QUEUE_MIN_REPOST	8
 	uint32_t queue_id;	/* Queue ID assigned by the hardware */
 	uint32_t assoc_qid;     /* Queue ID associated with, for CQ/WQ/MQ */
-	struct list_head page_list;
 	uint32_t page_count;	/* Number of pages allocated for this queue */
 	uint32_t host_index;	/* The host's index for putting or getting */
 	uint32_t hba_index;	/* The last known hba index for get or put */
 
 	struct lpfc_sli_ring *pring; /* ptr to io ring associated with q */
+	struct lpfc_rqb *rqbp;	/* ptr to RQ buffers */
 
+	uint16_t sgl_list_cnt;
 	uint16_t db_format;
 #define LPFC_DB_RING_FORMAT	0x01
 #define LPFC_DB_LIST_FORMAT	0x02
@@ -176,6 +195,8 @@ struct lpfc_queue {
 #define	RQ_buf_trunc		q_cnt_3
 #define	RQ_rcv_buf		q_cnt_4
 
+	uint64_t isr_timestamp;
+	struct lpfc_queue *assoc_qp;
 	union sli4_qe qe[1];	/* array to index entries (must be last) */
 };
 
@@ -338,6 +359,7 @@ struct lpfc_bmbx {
 #define LPFC_CQE_DEF_COUNT      1024
 #define LPFC_WQE_DEF_COUNT      256
 #define LPFC_WQE128_DEF_COUNT   128
+#define LPFC_WQE128_MAX_COUNT   256
 #define LPFC_MQE_DEF_COUNT      16
 #define LPFC_RQE_DEF_COUNT	512
 
@@ -379,10 +401,14 @@ struct lpfc_max_cfg_param {
 
 struct lpfc_hba;
 /* SLI4 HBA multi-fcp queue handler struct */
-struct lpfc_fcp_eq_hdl {
+struct lpfc_hba_eq_hdl {
 	uint32_t idx;
 	struct lpfc_hba *phba;
-	atomic_t fcp_eq_in_use;
+	atomic_t hba_eq_in_use;
+	struct cpumask *cpumask;
+	/* CPU affinitsed to or 0xffffffff if multiple */
+	uint32_t cpu;
+#define LPFC_MULTI_CPU_AFFINITY 0xffffffff
 };
 
 /* Port Capabilities for SLI4 Parameters */
@@ -427,6 +453,7 @@ struct lpfc_pc_sli4_params {
 	uint8_t wqsize;
 #define LPFC_WQ_SZ64_SUPPORT	1
 #define LPFC_WQ_SZ128_SUPPORT	2
+	uint8_t wqpcnt;
 };
 
 struct lpfc_iov {
@@ -445,7 +472,7 @@ struct lpfc_sli4_lnk_info {
 	uint8_t optic_state;
 };
 
-#define LPFC_SLI4_HANDLER_CNT		(LPFC_FCP_IO_CHAN_MAX+ \
+#define LPFC_SLI4_HANDLER_CNT		(LPFC_HBA_IO_CHAN_MAX+ \
 					 LPFC_FOF_IO_CHAN_NUM)
 #define LPFC_SLI4_HANDLER_NAME_SZ	16
 
@@ -516,21 +543,30 @@ struct lpfc_sli4_hba {
 	struct lpfc_register sli_intf;
 	struct lpfc_pc_sli4_params pc_sli4_params;
 	uint8_t handler_name[LPFC_SLI4_HANDLER_CNT][LPFC_SLI4_HANDLER_NAME_SZ];
-	struct lpfc_fcp_eq_hdl *fcp_eq_hdl; /* FCP per-WQ handle */
+	struct lpfc_hba_eq_hdl *hba_eq_hdl; /* HBA per-WQ handle */
 
 	/* Pointers to the constructed SLI4 queues */
-	struct lpfc_queue **hba_eq;/* Event queues for HBA */
-	struct lpfc_queue **fcp_cq;/* Fast-path FCP compl queue */
-	struct lpfc_queue **fcp_wq;/* Fast-path FCP work queue */
+	struct lpfc_queue **hba_eq;  /* Event queues for HBA */
+	struct lpfc_queue **fcp_cq;  /* Fast-path FCP compl queue */
+	struct lpfc_queue **nvme_cq; /* Fast-path NVME compl queue */
+	struct lpfc_queue **fcp_wq;  /* Fast-path FCP work queue */
+	struct lpfc_queue **nvme_wq; /* Fast-path NVME work queue */
 	uint16_t *fcp_cq_map;
+	uint16_t *nvme_cq_map;
+	struct list_head lpfc_wq_list;
 
 	struct lpfc_queue *mbx_cq; /* Slow-path mailbox complete queue */
 	struct lpfc_queue *els_cq; /* Slow-path ELS response complete queue */
+	struct lpfc_queue *nvmels_cq; /* NVME LS complete queue */
 	struct lpfc_queue *mbx_wq; /* Slow-path MBOX work queue */
 	struct lpfc_queue *els_wq; /* Slow-path ELS work queue */
+	struct lpfc_queue *nvmels_wq; /* NVME LS work queue */
 	struct lpfc_queue *hdr_rq; /* Slow-path Header Receive queue */
 	struct lpfc_queue *dat_rq; /* Slow-path Data Receive queue */
 
+	struct lpfc_name wwnn;
+	struct lpfc_name wwpn;
+
 	uint32_t fw_func_mode;	/* FW function protocol mode */
 	uint32_t ulp0_mode;	/* ULP0 protocol mode */
 	uint32_t ulp1_mode;	/* ULP1 protocol mode */
@@ -567,14 +603,17 @@ struct lpfc_sli4_hba {
 	uint16_t rpi_hdrs_in_use; /* must post rpi hdrs if set. */
 	uint16_t next_xri; /* last_xri - max_cfg_param.xri_base = used */
 	uint16_t next_rpi;
+	uint16_t nvme_xri_max;
+	uint16_t nvme_xri_cnt;
+	uint16_t nvme_xri_start;
 	uint16_t scsi_xri_max;
 	uint16_t scsi_xri_cnt;
-	uint16_t els_xri_cnt;
 	uint16_t scsi_xri_start;
-	struct list_head lpfc_free_sgl_list;
-	struct list_head lpfc_sgl_list;
+	uint16_t els_xri_cnt;
+	struct list_head lpfc_els_sgl_list;
 	struct list_head lpfc_abts_els_sgl_list;
 	struct list_head lpfc_abts_scsi_buf_list;
+	struct list_head lpfc_abts_nvme_buf_list;
 	struct lpfc_sglq **lpfc_sglq_active_list;
 	struct list_head lpfc_rpi_hdr_list;
 	unsigned long *rpi_bmask;
@@ -601,8 +640,9 @@ struct lpfc_sli4_hba {
 #define LPFC_SLI4_PPNAME_NON	0
 #define LPFC_SLI4_PPNAME_GET	1
 	struct lpfc_iov iov;
+	spinlock_t abts_nvme_buf_list_lock; /* list of aborted SCSI IOs */
 	spinlock_t abts_scsi_buf_list_lock; /* list of aborted SCSI IOs */
-	spinlock_t abts_sgl_list_lock; /* list of aborted els IOs */
+	spinlock_t sgl_list_lock; /* list of aborted els IOs */
 	uint32_t physical_port;
 
 	/* CPU to vector mapping information */
@@ -614,7 +654,7 @@ struct lpfc_sli4_hba {
 
 enum lpfc_sge_type {
 	GEN_BUFF_TYPE,
-	SCSI_BUFF_TYPE
+	SCSI_BUFF_TYPE,
 };
 
 enum lpfc_sgl_state {
@@ -693,7 +733,7 @@ struct lpfc_queue *lpfc_sli4_queue_alloc(struct lpfc_hba *, uint32_t,
 			uint32_t);
 void lpfc_sli4_queue_free(struct lpfc_queue *);
 int lpfc_eq_create(struct lpfc_hba *, struct lpfc_queue *, uint32_t);
-int lpfc_modify_fcp_eq_delay(struct lpfc_hba *, uint32_t);
+int lpfc_modify_hba_eq_delay(struct lpfc_hba *phba, uint32_t startq);
 int lpfc_cq_create(struct lpfc_hba *, struct lpfc_queue *,
 			struct lpfc_queue *, uint32_t, uint32_t);
 int32_t lpfc_mq_create(struct lpfc_hba *, struct lpfc_queue *,
@@ -745,6 +785,7 @@ int lpfc_sli4_brdreset(struct lpfc_hba *);
 int lpfc_sli4_add_fcf_record(struct lpfc_hba *, struct fcf_record *);
 void lpfc_sli_remove_dflt_fcf(struct lpfc_hba *);
 int lpfc_sli4_get_els_iocb_cnt(struct lpfc_hba *);
+int lpfc_sli4_get_iocb_cnt(struct lpfc_hba *phba);
 int lpfc_sli4_init_vpi(struct lpfc_vport *);
 uint32_t lpfc_sli4_cq_release(struct lpfc_queue *, bool);
 uint32_t lpfc_sli4_eq_release(struct lpfc_queue *, bool);
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index e18bbc6..07c7c5f 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -33,6 +33,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_fc.h>
+
 #include "lpfc_hw4.h"
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
@@ -402,6 +403,8 @@ lpfc_vport_create(struct fc_vport *fc_vport, bool disable)
 		vport->fdmi_port_mask = phba->pport->fdmi_port_mask;
 	}
 
+	/* todo: init: register port with nvme */
+
 	/*
 	 * In SLI4, the vpi must be activated before it can be used
 	 * by the port.
-- 
2.5.0
