From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.12-rc2
Date: Wed, 24 May 2017 16:51:54 -0700
Message-ID: <1495669914.2741.12.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is quite a big update because it includes a rework of the lpfc
driver to separate the NVMe part from the FC part.  The reason for
doing this is because two separate trees (the nvme and scsi trees
respectively) want to update the individual components and this
separation will prevent a really nasty cross tree entanglement by the
time we reach the next merge window.  The rest of the fixes are the
usual minor sort with no significant security implications.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Damien Le Moal (2):
      scsi: sd: Write lock zone for REQ_OP_WRITE_ZEROES
      scsi: sd: Unlock zone in case of error in sd_setup_write_same_cmnd()

Derek Basehore (1):
      scsi: sd: Ignore sync cache failures when not supported

Guilherme G. Piccoli (1):
      scsi: lpfc: Fix NULL pointer dereference during PCI error recovery

Gustavo A. R. Silva (1):
      scsi: libfc: fix incorrect variable assignment

James Smart (16):
      scsi: lpfc: fix build issue if NVME_FC_TARGET is not defined
      scsi: lpfc: update version to 11.2.0.14
      scsi: lpfc: Add MDS Diagnostic support.
      scsi: lpfc: Fix NVMEI's handling of NVMET's PRLI response attributes
      scsi: lpfc: Cleanup entry_repost settings on SLI4 queues
      scsi: lpfc: Fix debugfs root inode "lpfc" not getting deleted on driver unload.
      scsi: lpfc: Fix NVME I+T not registering NVME as a supported FC4 type
      scsi: lpfc: Added recovery logic for running out of NVMET IO context resources
      scsi: lpfc: Separate NVMET RQ buffer posting from IO resources SGL/iocbq/context
      scsi: lpfc: Separate NVMET data buffer pool fir ELS/CT.
      scsi: lpfc: Fix NMI watchdog assertions when running nvmet IOPS tests
      scsi: lpfc: Fix NVMEI driver not decrementing counter causing bad rport state.
      scsi: lpfc: Fix nvmet RQ resource needs for large block writes.
      scsi: lpfc: Adding additional stats counters for nvme.
      scsi: lpfc: Fix system crash when port is reset.
      scsi: lpfc: Fix used-RPI accounting problem.

Johannes Thumshirn (1):
      scsi: sg: don't return bogus Sg_requests

Long Li (1):
      scsi: zero per-cmd private driver data for each MQ I/O

Michał Potomski (1):
      scsi: ufs: Clean up some rpm/spm level SysFS nodes upon remove

Varun Prakash (1):
      scsi: csiostor: fix use after free in csio_hw_use_fwconfig()

With diffstat:

 drivers/scsi/csiostor/csio_hw.c    |   5 +-
 drivers/scsi/libfc/fc_rport.c      |   2 +-
 drivers/scsi/lpfc/lpfc.h           |  23 ++-
 drivers/scsi/lpfc/lpfc_attr.c      |  47 +++--
 drivers/scsi/lpfc/lpfc_crtn.h      |  11 +-
 drivers/scsi/lpfc/lpfc_ct.c        |   1 +
 drivers/scsi/lpfc/lpfc_debugfs.c   |  69 ++++---
 drivers/scsi/lpfc/lpfc_disc.h      |   1 +
 drivers/scsi/lpfc/lpfc_els.c       |  26 ++-
 drivers/scsi/lpfc/lpfc_hbadisc.c   |   9 +-
 drivers/scsi/lpfc/lpfc_hw4.h       |  16 +-
 drivers/scsi/lpfc/lpfc_init.c      | 137 ++++--------
 drivers/scsi/lpfc/lpfc_mem.c       | 100 +++------
 drivers/scsi/lpfc/lpfc_nportdisc.c |   6 +
 drivers/scsi/lpfc/lpfc_nvmet.c     | 414 ++++++++++++++++++++++++++++++-------
 drivers/scsi/lpfc/lpfc_nvmet.h     |  14 +-
 drivers/scsi/lpfc/lpfc_sli.c       | 357 +++++++++++++++++++++++++-------
 drivers/scsi/lpfc/lpfc_sli4.h      |  19 +-
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 drivers/scsi/scsi_lib.c            |   2 +-
 drivers/scsi/sd.c                  |  63 ++++--
 drivers/scsi/sg.c                  |   5 +-
 drivers/scsi/ufs/ufshcd.c          |   7 +
 23 files changed, 902 insertions(+), 434 deletions(-)

With full diff below

James

---

diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
index 622bdabc8894..dab195f04da7 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -1769,7 +1769,6 @@ csio_hw_use_fwconfig(struct csio_hw *hw, int reset, u32 *fw_cfg_param)
 		goto bye;
 	}
 
-	mempool_free(mbp, hw->mb_mempool);
 	if (finicsum != cfcsum) {
 		csio_warn(hw,
 		      "Config File checksum mismatch: csum=%#x, computed=%#x\n",
@@ -1780,6 +1779,10 @@ csio_hw_use_fwconfig(struct csio_hw *hw, int reset, u32 *fw_cfg_param)
 	rv = csio_hw_validate_caps(hw, mbp);
 	if (rv != 0)
 		goto bye;
+
+	mempool_free(mbp, hw->mb_mempool);
+	mbp = NULL;
+
 	/*
 	 * Note that we're operating with parameters
 	 * not supplied by the driver, rather than from hard-wired
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index b44c3136eb51..520325867e2b 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1422,7 +1422,7 @@ static void fc_rport_recv_rtv_req(struct fc_rport_priv *rdata,
 	fp = fc_frame_alloc(lport, sizeof(*rtv));
 	if (!fp) {
 		rjt_data.reason = ELS_RJT_UNAB;
-		rjt_data.reason = ELS_EXPL_INSUF_RES;
+		rjt_data.explan = ELS_EXPL_INSUF_RES;
 		fc_seq_els_rsp_send(in_fp, ELS_LS_RJT, &rjt_data);
 		goto drop;
 	}
diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 6d7840b096e6..f2c0ba6ced78 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -141,6 +141,13 @@ struct lpfc_dmabuf {
 	uint32_t   buffer_tag;	/* used for tagged queue ring */
 };
 
+struct lpfc_nvmet_ctxbuf {
+	struct list_head list;
+	struct lpfc_nvmet_rcv_ctx *context;
+	struct lpfc_iocbq *iocbq;
+	struct lpfc_sglq *sglq;
+};
+
 struct lpfc_dma_pool {
 	struct lpfc_dmabuf   *elements;
 	uint32_t    max_count;
@@ -163,9 +170,7 @@ struct rqb_dmabuf {
 	struct lpfc_dmabuf dbuf;
 	uint16_t total_size;
 	uint16_t bytes_recv;
-	void *context;
-	struct lpfc_iocbq *iocbq;
-	struct lpfc_sglq *sglq;
+	uint16_t idx;
 	struct lpfc_queue *hrq;	  /* ptr to associated Header RQ */
 	struct lpfc_queue *drq;	  /* ptr to associated Data RQ */
 };
@@ -670,6 +675,8 @@ struct lpfc_hba {
 					/* INIT_LINK mailbox command */
 #define LS_NPIV_FAB_SUPPORTED 0x2	/* Fabric supports NPIV */
 #define LS_IGNORE_ERATT       0x4	/* intr handler should ignore ERATT */
+#define LS_MDS_LINK_DOWN      0x8	/* MDS Diagnostics Link Down */
+#define LS_MDS_LOOPBACK      0x16	/* MDS Diagnostics Link Up (Loopback) */
 
 	uint32_t hba_flag;	/* hba generic flags */
 #define HBA_ERATT_HANDLED	0x1 /* This flag is set when eratt handled */
@@ -777,7 +784,6 @@ struct lpfc_hba {
 	uint32_t cfg_nvme_oas;
 	uint32_t cfg_nvme_io_channel;
 	uint32_t cfg_nvmet_mrq;
-	uint32_t cfg_nvmet_mrq_post;
 	uint32_t cfg_enable_nvmet;
 	uint32_t cfg_nvme_enable_fb;
 	uint32_t cfg_nvmet_fb_size;
@@ -943,6 +949,7 @@ struct lpfc_hba {
 	struct pci_pool *lpfc_mbuf_pool;
 	struct pci_pool *lpfc_hrb_pool;	/* header receive buffer pool */
 	struct pci_pool *lpfc_drb_pool; /* data receive buffer pool */
+	struct pci_pool *lpfc_nvmet_drb_pool; /* data receive buffer pool */
 	struct pci_pool *lpfc_hbq_pool;	/* SLI3 hbq buffer pool */
 	struct pci_pool *txrdy_payload_pool;
 	struct lpfc_dma_pool lpfc_mbuf_safety_pool;
@@ -1228,7 +1235,11 @@ lpfc_sli_read_hs(struct lpfc_hba *phba)
 static inline struct lpfc_sli_ring *
 lpfc_phba_elsring(struct lpfc_hba *phba)
 {
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		return phba->sli4_hba.els_wq->pring;
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		if (phba->sli4_hba.els_wq)
+			return phba->sli4_hba.els_wq->pring;
+		else
+			return NULL;
+	}
 	return &phba->sli.sli3_ring[LPFC_ELS_RING];
 }
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 4830370bfab1..bb2d9e238225 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -60,9 +60,9 @@
 #define LPFC_MIN_DEVLOSS_TMO	1
 #define LPFC_MAX_DEVLOSS_TMO	255
 
-#define LPFC_DEF_MRQ_POST	256
-#define LPFC_MIN_MRQ_POST	32
-#define LPFC_MAX_MRQ_POST	512
+#define LPFC_DEF_MRQ_POST	512
+#define LPFC_MIN_MRQ_POST	512
+#define LPFC_MAX_MRQ_POST	2048
 
 /*
  * Write key size should be multiple of 4. If write key is changed
@@ -205,8 +205,9 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 				atomic_read(&tgtp->xmt_ls_rsp_error));
 
 		len += snprintf(buf+len, PAGE_SIZE-len,
-				"FCP: Rcv %08x Drop %08x\n",
+				"FCP: Rcv %08x Release %08x Drop %08x\n",
 				atomic_read(&tgtp->rcv_fcp_cmd_in),
+				atomic_read(&tgtp->xmt_fcp_release),
 				atomic_read(&tgtp->rcv_fcp_cmd_drop));
 
 		if (atomic_read(&tgtp->rcv_fcp_cmd_in) !=
@@ -218,15 +219,12 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 		}
 
 		len += snprintf(buf+len, PAGE_SIZE-len,
-				"FCP Rsp: RD %08x rsp %08x WR %08x rsp %08x\n",
+				"FCP Rsp: RD %08x rsp %08x WR %08x rsp %08x "
+				"drop %08x\n",
 				atomic_read(&tgtp->xmt_fcp_read),
 				atomic_read(&tgtp->xmt_fcp_read_rsp),
 				atomic_read(&tgtp->xmt_fcp_write),
-				atomic_read(&tgtp->xmt_fcp_rsp));
-
-		len += snprintf(buf+len, PAGE_SIZE-len,
-				"FCP Rsp: abort %08x drop %08x\n",
-				atomic_read(&tgtp->xmt_fcp_abort),
+				atomic_read(&tgtp->xmt_fcp_rsp),
 				atomic_read(&tgtp->xmt_fcp_drop));
 
 		len += snprintf(buf+len, PAGE_SIZE-len,
@@ -236,10 +234,22 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 				atomic_read(&tgtp->xmt_fcp_rsp_drop));
 
 		len += snprintf(buf+len, PAGE_SIZE-len,
-				"ABORT: Xmt %08x Err %08x Cmpl %08x",
+				"ABORT: Xmt %08x Cmpl %08x\n",
+				atomic_read(&tgtp->xmt_fcp_abort),
+				atomic_read(&tgtp->xmt_fcp_abort_cmpl));
+
+		len += snprintf(buf + len, PAGE_SIZE - len,
+				"ABORT: Sol %08x  Usol %08x Err %08x Cmpl %08x",
+				atomic_read(&tgtp->xmt_abort_sol),
+				atomic_read(&tgtp->xmt_abort_unsol),
 				atomic_read(&tgtp->xmt_abort_rsp),
-				atomic_read(&tgtp->xmt_abort_rsp_error),
-				atomic_read(&tgtp->xmt_abort_cmpl));
+				atomic_read(&tgtp->xmt_abort_rsp_error));
+
+		len += snprintf(buf + len, PAGE_SIZE - len,
+				"IO_CTX: %08x outstanding %08x total %x",
+				phba->sli4_hba.nvmet_ctx_cnt,
+				phba->sli4_hba.nvmet_io_wait_cnt,
+				phba->sli4_hba.nvmet_io_wait_total);
 
 		len +=  snprintf(buf+len, PAGE_SIZE-len, "\n");
 		return len;
@@ -3312,14 +3322,6 @@ LPFC_ATTR_R(nvmet_mrq,
 	    "Specify number of RQ pairs for processing NVMET cmds");
 
 /*
- * lpfc_nvmet_mrq_post: Specify number buffers to post on every MRQ
- *
- */
-LPFC_ATTR_R(nvmet_mrq_post, LPFC_DEF_MRQ_POST,
-	    LPFC_MIN_MRQ_POST, LPFC_MAX_MRQ_POST,
-	    "Specify number of buffers to post on every MRQ");
-
-/*
  * lpfc_enable_fc4_type: Defines what FC4 types are supported.
  * Supported Values:  1 - register just FCP
  *                    3 - register both FCP and NVME
@@ -5154,7 +5156,6 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_suppress_rsp,
 	&dev_attr_lpfc_nvme_io_channel,
 	&dev_attr_lpfc_nvmet_mrq,
-	&dev_attr_lpfc_nvmet_mrq_post,
 	&dev_attr_lpfc_nvme_enable_fb,
 	&dev_attr_lpfc_nvmet_fb_size,
 	&dev_attr_lpfc_enable_bg,
@@ -6194,7 +6195,6 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 
 	lpfc_enable_fc4_type_init(phba, lpfc_enable_fc4_type);
 	lpfc_nvmet_mrq_init(phba, lpfc_nvmet_mrq);
-	lpfc_nvmet_mrq_post_init(phba, lpfc_nvmet_mrq_post);
 
 	/* Initialize first burst. Target vs Initiator are different. */
 	lpfc_nvme_enable_fb_init(phba, lpfc_nvme_enable_fb);
@@ -6291,7 +6291,6 @@ lpfc_nvme_mod_param_dep(struct lpfc_hba *phba)
 		/* Not NVME Target mode.  Turn off Target parameters. */
 		phba->nvmet_support = 0;
 		phba->cfg_nvmet_mrq = 0;
-		phba->cfg_nvmet_mrq_post = 0;
 		phba->cfg_nvmet_fb_size = 0;
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 1c55408ac718..8912767e7bc8 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -75,6 +75,10 @@ void lpfc_init_vpi_cmpl(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_cancel_all_vport_retry_delay_timer(struct lpfc_hba *);
 void lpfc_retry_pport_discovery(struct lpfc_hba *);
 void lpfc_release_rpi(struct lpfc_hba *, struct lpfc_vport *, uint16_t);
+int lpfc_init_iocb_list(struct lpfc_hba *phba, int cnt);
+void lpfc_free_iocb_list(struct lpfc_hba *phba);
+int lpfc_post_rq_buffer(struct lpfc_hba *phba, struct lpfc_queue *hrq,
+			struct lpfc_queue *drq, int count, int idx);
 
 void lpfc_mbx_cmpl_local_config_link(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_mbx_cmpl_reg_login(struct lpfc_hba *, LPFC_MBOXQ_t *);
@@ -246,16 +250,14 @@ struct hbq_dmabuf *lpfc_sli4_rb_alloc(struct lpfc_hba *);
 void lpfc_sli4_rb_free(struct lpfc_hba *, struct hbq_dmabuf *);
 struct rqb_dmabuf *lpfc_sli4_nvmet_alloc(struct lpfc_hba *phba);
 void lpfc_sli4_nvmet_free(struct lpfc_hba *phba, struct rqb_dmabuf *dmab);
-void lpfc_nvmet_rq_post(struct lpfc_hba *phba, struct lpfc_nvmet_rcv_ctx *ctxp,
-			struct lpfc_dmabuf *mp);
+void lpfc_nvmet_ctxbuf_post(struct lpfc_hba *phba,
+			    struct lpfc_nvmet_ctxbuf *ctxp);
 int lpfc_nvmet_rcv_unsol_abort(struct lpfc_vport *vport,
 			       struct fc_frame_header *fc_hdr);
 void lpfc_sli4_build_dflt_fcf_record(struct lpfc_hba *, struct fcf_record *,
 			uint16_t);
 int lpfc_sli4_rq_put(struct lpfc_queue *hq, struct lpfc_queue *dq,
 		     struct lpfc_rqe *hrqe, struct lpfc_rqe *drqe);
-int lpfc_post_rq_buffer(struct lpfc_hba *phba, struct lpfc_queue *hq,
-			struct lpfc_queue *dq, int count);
 int lpfc_free_rq_buffer(struct lpfc_hba *phba, struct lpfc_queue *hq);
 void lpfc_unregister_fcf(struct lpfc_hba *);
 void lpfc_unregister_fcf_rescan(struct lpfc_hba *);
@@ -271,6 +273,7 @@ int lpfc_sli4_fcf_rr_next_proc(struct lpfc_vport *, uint16_t);
 void lpfc_sli4_clear_fcf_rr_bmask(struct lpfc_hba *);
 
 int lpfc_mem_alloc(struct lpfc_hba *, int align);
+int lpfc_nvmet_mem_alloc(struct lpfc_hba *phba);
 int lpfc_mem_alloc_active_rrq_pool_s4(struct lpfc_hba *);
 void lpfc_mem_free(struct lpfc_hba *);
 void lpfc_mem_free_all(struct lpfc_hba *);
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index c7962dae4dab..f2cd19c6c2df 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -2092,6 +2092,7 @@ lpfc_fdmi_port_attr_fc4type(struct lpfc_vport *vport,
 
 	ae->un.AttrTypes[3] = 0x02; /* Type 1 - ELS */
 	ae->un.AttrTypes[2] = 0x01; /* Type 8 - FCP */
+	ae->un.AttrTypes[6] = 0x01; /* Type 40 - NVME */
 	ae->un.AttrTypes[7] = 0x01; /* Type 32 - CT */
 	size = FOURBYTES + 32;
 	ad->AttrLen = cpu_to_be16(size);
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index fce549a91911..4bcb92c844ca 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -798,21 +798,22 @@ lpfc_debugfs_nvmestat_data(struct lpfc_vport *vport, char *buf, int size)
 				atomic_read(&tgtp->xmt_fcp_rsp));
 
 		len += snprintf(buf + len, size - len,
-				"FCP Rsp: abort %08x drop %08x\n",
-				atomic_read(&tgtp->xmt_fcp_abort),
-				atomic_read(&tgtp->xmt_fcp_drop));
-
-		len += snprintf(buf + len, size - len,
 				"FCP Rsp Cmpl: %08x err %08x drop %08x\n",
 				atomic_read(&tgtp->xmt_fcp_rsp_cmpl),
 				atomic_read(&tgtp->xmt_fcp_rsp_error),
 				atomic_read(&tgtp->xmt_fcp_rsp_drop));
 
 		len += snprintf(buf + len, size - len,
-				"ABORT: Xmt %08x Err %08x Cmpl %08x",
+				"ABORT: Xmt %08x Cmpl %08x\n",
+				atomic_read(&tgtp->xmt_fcp_abort),
+				atomic_read(&tgtp->xmt_fcp_abort_cmpl));
+
+		len += snprintf(buf + len, size - len,
+				"ABORT: Sol %08x  Usol %08x Err %08x Cmpl %08x",
+				atomic_read(&tgtp->xmt_abort_sol),
+				atomic_read(&tgtp->xmt_abort_unsol),
 				atomic_read(&tgtp->xmt_abort_rsp),
-				atomic_read(&tgtp->xmt_abort_rsp_error),
-				atomic_read(&tgtp->xmt_abort_cmpl));
+				atomic_read(&tgtp->xmt_abort_rsp_error));
 
 		len +=  snprintf(buf + len, size - len, "\n");
 
@@ -841,6 +842,12 @@ lpfc_debugfs_nvmestat_data(struct lpfc_vport *vport, char *buf, int size)
 			}
 			spin_unlock(&phba->sli4_hba.abts_nvme_buf_list_lock);
 		}
+
+		len += snprintf(buf + len, size - len,
+				"IO_CTX: %08x  outstanding %08x total %08x\n",
+				phba->sli4_hba.nvmet_ctx_cnt,
+				phba->sli4_hba.nvmet_io_wait_cnt,
+				phba->sli4_hba.nvmet_io_wait_total);
 	} else {
 		if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME))
 			return len;
@@ -1959,6 +1966,7 @@ lpfc_debugfs_nvmestat_write(struct file *file, const char __user *buf,
 		atomic_set(&tgtp->rcv_ls_req_out, 0);
 		atomic_set(&tgtp->rcv_ls_req_drop, 0);
 		atomic_set(&tgtp->xmt_ls_abort, 0);
+		atomic_set(&tgtp->xmt_ls_abort_cmpl, 0);
 		atomic_set(&tgtp->xmt_ls_rsp, 0);
 		atomic_set(&tgtp->xmt_ls_drop, 0);
 		atomic_set(&tgtp->xmt_ls_rsp_error, 0);
@@ -1967,19 +1975,22 @@ lpfc_debugfs_nvmestat_write(struct file *file, const char __user *buf,
 		atomic_set(&tgtp->rcv_fcp_cmd_in, 0);
 		atomic_set(&tgtp->rcv_fcp_cmd_out, 0);
 		atomic_set(&tgtp->rcv_fcp_cmd_drop, 0);
-		atomic_set(&tgtp->xmt_fcp_abort, 0);
 		atomic_set(&tgtp->xmt_fcp_drop, 0);
 		atomic_set(&tgtp->xmt_fcp_read_rsp, 0);
 		atomic_set(&tgtp->xmt_fcp_read, 0);
 		atomic_set(&tgtp->xmt_fcp_write, 0);
 		atomic_set(&tgtp->xmt_fcp_rsp, 0);
+		atomic_set(&tgtp->xmt_fcp_release, 0);
 		atomic_set(&tgtp->xmt_fcp_rsp_cmpl, 0);
 		atomic_set(&tgtp->xmt_fcp_rsp_error, 0);
 		atomic_set(&tgtp->xmt_fcp_rsp_drop, 0);
 
+		atomic_set(&tgtp->xmt_fcp_abort, 0);
+		atomic_set(&tgtp->xmt_fcp_abort_cmpl, 0);
+		atomic_set(&tgtp->xmt_abort_sol, 0);
+		atomic_set(&tgtp->xmt_abort_unsol, 0);
 		atomic_set(&tgtp->xmt_abort_rsp, 0);
 		atomic_set(&tgtp->xmt_abort_rsp_error, 0);
-		atomic_set(&tgtp->xmt_abort_cmpl, 0);
 	}
 	return nbytes;
 }
@@ -3070,11 +3081,11 @@ __lpfc_idiag_print_wq(struct lpfc_queue *qp, char *wqtype,
 			qp->assoc_qid, qp->q_cnt_1,
 			(unsigned long long)qp->q_cnt_4);
 	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
-			"\t\tWQID[%02d], QE-CNT[%04d], QE-SIZE[%04d], "
-			"HOST-IDX[%04d], PORT-IDX[%04d]",
+			"\t\tWQID[%02d], QE-CNT[%04d], QE-SZ[%04d], "
+			"HST-IDX[%04d], PRT-IDX[%04d], PST[%03d]",
 			qp->queue_id, qp->entry_count,
 			qp->entry_size, qp->host_index,
-			qp->hba_index);
+			qp->hba_index, qp->entry_repost);
 	len +=  snprintf(pbuffer + len,
 			LPFC_QUE_INFO_GET_BUF_SIZE - len, "\n");
 	return len;
@@ -3121,11 +3132,11 @@ __lpfc_idiag_print_cq(struct lpfc_queue *qp, char *cqtype,
 			qp->assoc_qid, qp->q_cnt_1, qp->q_cnt_2,
 			qp->q_cnt_3, (unsigned long long)qp->q_cnt_4);
 	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
-			"\tCQID[%02d], QE-CNT[%04d], QE-SIZE[%04d], "
-			"HOST-IDX[%04d], PORT-IDX[%04d]",
+			"\tCQID[%02d], QE-CNT[%04d], QE-SZ[%04d], "
+			"HST-IDX[%04d], PRT-IDX[%04d], PST[%03d]",
 			qp->queue_id, qp->entry_count,
 			qp->entry_size, qp->host_index,
-			qp->hba_index);
+			qp->hba_index, qp->entry_repost);
 
 	len +=  snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len, "\n");
 
@@ -3143,20 +3154,20 @@ __lpfc_idiag_print_rqpair(struct lpfc_queue *qp, struct lpfc_queue *datqp,
 			"\t\t%s RQ info: ", rqtype);
 	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
 			"AssocCQID[%02d]: RQ-STAT[nopost:x%x nobuf:x%x "
-			"trunc:x%x rcv:x%llx]\n",
+			"posted:x%x rcv:x%llx]\n",
 			qp->assoc_qid, qp->q_cnt_1, qp->q_cnt_2,
 			qp->q_cnt_3, (unsigned long long)qp->q_cnt_4);
 	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
-			"\t\tHQID[%02d], QE-CNT[%04d], QE-SIZE[%04d], "
-			"HOST-IDX[%04d], PORT-IDX[%04d]\n",
+			"\t\tHQID[%02d], QE-CNT[%04d], QE-SZ[%04d], "
+			"HST-IDX[%04d], PRT-IDX[%04d], PST[%03d]\n",
 			qp->queue_id, qp->entry_count, qp->entry_size,
-			qp->host_index, qp->hba_index);
+			qp->host_index, qp->hba_index, qp->entry_repost);
 	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
-			"\t\tDQID[%02d], QE-CNT[%04d], QE-SIZE[%04d], "
-			"HOST-IDX[%04d], PORT-IDX[%04d]\n",
+			"\t\tDQID[%02d], QE-CNT[%04d], QE-SZ[%04d], "
+			"HST-IDX[%04d], PRT-IDX[%04d], PST[%03d]\n",
 			datqp->queue_id, datqp->entry_count,
 			datqp->entry_size, datqp->host_index,
-			datqp->hba_index);
+			datqp->hba_index, datqp->entry_repost);
 	return len;
 }
 
@@ -3242,10 +3253,10 @@ __lpfc_idiag_print_eq(struct lpfc_queue *qp, char *eqtype,
 			eqtype, qp->q_cnt_1, qp->q_cnt_2, qp->q_cnt_3,
 			(unsigned long long)qp->q_cnt_4);
 	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
-			"EQID[%02d], QE-CNT[%04d], QE-SIZE[%04d], "
-			"HOST-IDX[%04d], PORT-IDX[%04d]",
+			"EQID[%02d], QE-CNT[%04d], QE-SZ[%04d], "
+			"HST-IDX[%04d], PRT-IDX[%04d], PST[%03d]",
 			qp->queue_id, qp->entry_count, qp->entry_size,
-			qp->host_index, qp->hba_index);
+			qp->host_index, qp->hba_index, qp->entry_repost);
 	len +=  snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len, "\n");
 
 	return len;
@@ -5855,8 +5866,10 @@ lpfc_debugfs_terminate(struct lpfc_vport *vport)
 			atomic_dec(&lpfc_debugfs_hba_count);
 		}
 
-		debugfs_remove(lpfc_debugfs_root); /* lpfc */
-		lpfc_debugfs_root = NULL;
+		if (atomic_read(&lpfc_debugfs_hba_count) == 0) {
+			debugfs_remove(lpfc_debugfs_root); /* lpfc */
+			lpfc_debugfs_root = NULL;
+		}
 	}
 #endif
 	return;
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 9d5a379f4b15..094c97b9e5f7 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -90,6 +90,7 @@ struct lpfc_nodelist {
 #define NLP_FCP_INITIATOR  0x10			/* entry is an FCP Initiator */
 #define NLP_NVME_TARGET    0x20			/* entry is a NVME Target */
 #define NLP_NVME_INITIATOR 0x40			/* entry is a NVME Initiator */
+#define NLP_NVME_DISCOVERY 0x80                 /* entry has NVME disc srvc */
 
 	uint16_t	nlp_fc4_type;		/* FC types node supports. */
 						/* Assigned from GID_FF, only
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 67827e397431..8e532b39ae93 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1047,6 +1047,13 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 irsp->ulpStatus, irsp->un.ulpWord[4],
 				 irsp->ulpTimeout);
 
+
+		/* If this is not a loop open failure, bail out */
+		if (!(irsp->ulpStatus == IOSTAT_LOCAL_REJECT &&
+		      ((irsp->un.ulpWord[4] & IOERR_PARAM_MASK) ==
+					IOERR_LOOP_OPEN_FAILURE)))
+			goto flogifail;
+
 		/* FLOGI failed, so there is no fabric */
 		spin_lock_irq(shost->host_lock);
 		vport->fc_flag &= ~(FC_FABRIC | FC_PUBLIC_LOOP);
@@ -2077,16 +2084,19 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	if (irsp->ulpStatus) {
 		/* Check for retry */
+		ndlp->fc4_prli_sent--;
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb)) {
 			/* ELS command is being retried */
-			ndlp->fc4_prli_sent--;
 			goto out;
 		}
+
 		/* PRLI failed */
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
-				 "2754 PRLI failure DID:%06X Status:x%x/x%x\n",
+				 "2754 PRLI failure DID:%06X Status:x%x/x%x, "
+				 "data: x%x\n",
 				 ndlp->nlp_DID, irsp->ulpStatus,
-				 irsp->un.ulpWord[4]);
+				 irsp->un.ulpWord[4], ndlp->fc4_prli_sent);
+
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
 		if (lpfc_error_lost_link(irsp))
 			goto out;
@@ -7441,6 +7451,13 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 	 */
 	spin_lock_irq(&phba->hbalock);
 	pring = lpfc_phba_elsring(phba);
+
+	/* Bail out if we've no ELS wq, like in PCI error recovery case. */
+	if (unlikely(!pring)) {
+		spin_unlock_irq(&phba->hbalock);
+		return;
+	}
+
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		spin_lock(&pring->ring_lock);
 
@@ -8667,7 +8684,8 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_do_scr_ns_plogi(phba, vport);
 	goto out;
 fdisc_failed:
-	if (vport->fc_vport->vport_state != FC_VPORT_NO_FABRIC_RSCS)
+	if (vport->fc_vport &&
+	    (vport->fc_vport->vport_state != FC_VPORT_NO_FABRIC_RSCS))
 		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 	/* Cancel discovery timer */
 	lpfc_can_disctmo(vport);
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 0482c5580331..3ffcd9215ca8 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -693,15 +693,16 @@ lpfc_work_done(struct lpfc_hba *phba)
 	pring = lpfc_phba_elsring(phba);
 	status = (ha_copy & (HA_RXMASK  << (4*LPFC_ELS_RING)));
 	status >>= (4*LPFC_ELS_RING);
-	if ((status & HA_RXMASK) ||
-	    (pring->flag & LPFC_DEFERRED_RING_EVENT) ||
-	    (phba->hba_flag & HBA_SP_QUEUE_EVT)) {
+	if (pring && (status & HA_RXMASK ||
+		      pring->flag & LPFC_DEFERRED_RING_EVENT ||
+		      phba->hba_flag & HBA_SP_QUEUE_EVT)) {
 		if (pring->flag & LPFC_STOP_IOCB_EVENT) {
 			pring->flag |= LPFC_DEFERRED_RING_EVENT;
 			/* Set the lpfc data pending flag */
 			set_bit(LPFC_DATA_READY, &phba->data_flags);
 		} else {
-			if (phba->link_state >= LPFC_LINK_UP) {
+			if (phba->link_state >= LPFC_LINK_UP ||
+			    phba->link_flag & LS_MDS_LOOPBACK) {
 				pring->flag &= ~LPFC_DEFERRED_RING_EVENT;
 				lpfc_sli_handle_slow_ring_event(phba, pring,
 								(status &
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 1d12f2be36bc..e0a5fce416ae 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -1356,6 +1356,7 @@ struct lpfc_mbx_wq_destroy {
 
 #define LPFC_HDR_BUF_SIZE 128
 #define LPFC_DATA_BUF_SIZE 2048
+#define LPFC_NVMET_DATA_BUF_SIZE 128
 struct rq_context {
 	uint32_t word0;
 #define lpfc_rq_context_rqe_count_SHIFT	16	/* Version 0 Only */
@@ -4420,6 +4421,19 @@ struct fcp_treceive64_wqe {
 };
 #define TXRDY_PAYLOAD_LEN      12
 
+#define CMD_SEND_FRAME	0xE1
+
+struct send_frame_wqe {
+	struct ulp_bde64 bde;          /* words 0-2 */
+	uint32_t frame_len;            /* word 3 */
+	uint32_t fc_hdr_wd0;           /* word 4 */
+	uint32_t fc_hdr_wd1;           /* word 5 */
+	struct wqe_common wqe_com;     /* words 6-11 */
+	uint32_t fc_hdr_wd2;           /* word 12 */
+	uint32_t fc_hdr_wd3;           /* word 13 */
+	uint32_t fc_hdr_wd4;           /* word 14 */
+	uint32_t fc_hdr_wd5;           /* word 15 */
+};
 
 union lpfc_wqe {
 	uint32_t words[16];
@@ -4438,7 +4452,7 @@ union lpfc_wqe {
 	struct fcp_trsp64_wqe fcp_trsp;
 	struct fcp_tsend64_wqe fcp_tsend;
 	struct fcp_treceive64_wqe fcp_treceive;
-
+	struct send_frame_wqe send_frame;
 };
 
 union lpfc_wqe128 {
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 4b1eb98c228d..9add9473cae5 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1099,7 +1099,7 @@ lpfc_hba_down_post_s4(struct lpfc_hba *phba)
 
 		list_for_each_entry_safe(ctxp, ctxp_next, &nvmet_aborts, list) {
 			ctxp->flag &= ~(LPFC_NVMET_XBUSY | LPFC_NVMET_ABORT_OP);
-			lpfc_nvmet_rq_post(phba, ctxp, &ctxp->rqb_buffer->hbuf);
+			lpfc_nvmet_ctxbuf_post(phba, ctxp->ctxbuf);
 		}
 	}
 
@@ -3381,7 +3381,7 @@ lpfc_sli4_nvmet_sgl_update(struct lpfc_hba *phba)
 {
 	struct lpfc_sglq *sglq_entry = NULL, *sglq_entry_next = NULL;
 	uint16_t i, lxri, xri_cnt, els_xri_cnt;
-	uint16_t nvmet_xri_cnt, tot_cnt;
+	uint16_t nvmet_xri_cnt;
 	LIST_HEAD(nvmet_sgl_list);
 	int rc;
 
@@ -3389,15 +3389,9 @@ lpfc_sli4_nvmet_sgl_update(struct lpfc_hba *phba)
 	 * update on pci function's nvmet xri-sgl list
 	 */
 	els_xri_cnt = lpfc_sli4_get_els_iocb_cnt(phba);
-	nvmet_xri_cnt = phba->cfg_nvmet_mrq * phba->cfg_nvmet_mrq_post;
-	tot_cnt = phba->sli4_hba.max_cfg_param.max_xri - els_xri_cnt;
-	if (nvmet_xri_cnt > tot_cnt) {
-		phba->cfg_nvmet_mrq_post = tot_cnt / phba->cfg_nvmet_mrq;
-		nvmet_xri_cnt = phba->cfg_nvmet_mrq * phba->cfg_nvmet_mrq_post;
-		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
-				"6301 NVMET post-sgl count changed to %d\n",
-				phba->cfg_nvmet_mrq_post);
-	}
+
+	/* For NVMET, ALL remaining XRIs are dedicated for IO processing */
+	nvmet_xri_cnt = phba->sli4_hba.max_cfg_param.max_xri - els_xri_cnt;
 
 	if (nvmet_xri_cnt > phba->sli4_hba.nvmet_xri_cnt) {
 		/* els xri-sgl expanded */
@@ -4546,6 +4540,19 @@ lpfc_sli4_async_fc_evt(struct lpfc_hba *phba, struct lpfc_acqe_fc_la *acqe_fc)
 	pmb->vport = phba->pport;
 
 	if (phba->sli4_hba.link_state.status != LPFC_FC_LA_TYPE_LINK_UP) {
+		phba->link_flag &= ~(LS_MDS_LINK_DOWN | LS_MDS_LOOPBACK);
+
+		switch (phba->sli4_hba.link_state.status) {
+		case LPFC_FC_LA_TYPE_MDS_LINK_DOWN:
+			phba->link_flag |= LS_MDS_LINK_DOWN;
+			break;
+		case LPFC_FC_LA_TYPE_MDS_LOOPBACK:
+			phba->link_flag |= LS_MDS_LOOPBACK;
+			break;
+		default:
+			break;
+		}
+
 		/* Parse and translate status field */
 		mb = &pmb->u.mb;
 		mb->mbxStatus = lpfc_sli4_parse_latt_fault(phba,
@@ -5830,6 +5837,9 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		spin_lock_init(&phba->sli4_hba.abts_nvme_buf_list_lock);
 		INIT_LIST_HEAD(&phba->sli4_hba.lpfc_abts_nvme_buf_list);
 		INIT_LIST_HEAD(&phba->sli4_hba.lpfc_abts_nvmet_ctx_list);
+		INIT_LIST_HEAD(&phba->sli4_hba.lpfc_nvmet_ctx_list);
+		INIT_LIST_HEAD(&phba->sli4_hba.lpfc_nvmet_io_wait_list);
+
 		/* Fast-path XRI aborted CQ Event work queue list */
 		INIT_LIST_HEAD(&phba->sli4_hba.sp_nvme_xri_aborted_work_queue);
 	}
@@ -5837,6 +5847,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	/* This abort list used by worker thread */
 	spin_lock_init(&phba->sli4_hba.sgl_list_lock);
 	spin_lock_init(&phba->sli4_hba.nvmet_io_lock);
+	spin_lock_init(&phba->sli4_hba.nvmet_io_wait_lock);
 
 	/*
 	 * Initialize driver internal slow-path work queues
@@ -5951,16 +5962,21 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		for (i = 0; i < lpfc_enable_nvmet_cnt; i++) {
 			if (wwn == lpfc_enable_nvmet[i]) {
 #if (IS_ENABLED(CONFIG_NVME_TARGET_FC))
+				if (lpfc_nvmet_mem_alloc(phba))
+					break;
+
+				phba->nvmet_support = 1; /* a match */
+
 				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 						"6017 NVME Target %016llx\n",
 						wwn);
-				phba->nvmet_support = 1; /* a match */
 #else
 				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 						"6021 Can't enable NVME Target."
 						" NVME_TARGET_FC infrastructure"
 						" is not in kernel\n");
 #endif
+				break;
 			}
 		}
 	}
@@ -6269,7 +6285,7 @@ lpfc_unset_driver_resource_phase2(struct lpfc_hba *phba)
  *
  * This routine is invoked to free the driver's IOCB list and memory.
  **/
-static void
+void
 lpfc_free_iocb_list(struct lpfc_hba *phba)
 {
 	struct lpfc_iocbq *iocbq_entry = NULL, *iocbq_next = NULL;
@@ -6297,7 +6313,7 @@ lpfc_free_iocb_list(struct lpfc_hba *phba)
  *	0 - successful
  *	other values - error
  **/
-static int
+int
 lpfc_init_iocb_list(struct lpfc_hba *phba, int iocb_count)
 {
 	struct lpfc_iocbq *iocbq_entry = NULL;
@@ -6525,7 +6541,6 @@ lpfc_sli4_create_rpi_hdr(struct lpfc_hba *phba)
 	uint16_t rpi_limit, curr_rpi_range;
 	struct lpfc_dmabuf *dmabuf;
 	struct lpfc_rpi_hdr *rpi_hdr;
-	uint32_t rpi_count;
 
 	/*
 	 * If the SLI4 port supports extents, posting the rpi header isn't
@@ -6538,8 +6553,7 @@ lpfc_sli4_create_rpi_hdr(struct lpfc_hba *phba)
 		return NULL;
 
 	/* The limit on the logical index is just the max_rpi count. */
-	rpi_limit = phba->sli4_hba.max_cfg_param.rpi_base +
-	phba->sli4_hba.max_cfg_param.max_rpi - 1;
+	rpi_limit = phba->sli4_hba.max_cfg_param.max_rpi;
 
 	spin_lock_irq(&phba->hbalock);
 	/*
@@ -6550,18 +6564,10 @@ lpfc_sli4_create_rpi_hdr(struct lpfc_hba *phba)
 	curr_rpi_range = phba->sli4_hba.next_rpi;
 	spin_unlock_irq(&phba->hbalock);
 
-	/*
-	 * The port has a limited number of rpis. The increment here
-	 * is LPFC_RPI_HDR_COUNT - 1 to account for the starting value
-	 * and to allow the full max_rpi range per port.
-	 */
-	if ((curr_rpi_range + (LPFC_RPI_HDR_COUNT - 1)) > rpi_limit)
-		rpi_count = rpi_limit - curr_rpi_range;
-	else
-		rpi_count = LPFC_RPI_HDR_COUNT;
-
-	if (!rpi_count)
+	/* Reached full RPI range */
+	if (curr_rpi_range == rpi_limit)
 		return NULL;
+
 	/*
 	 * First allocate the protocol header region for the port.  The
 	 * port expects a 4KB DMA-mapped memory region that is 4K aligned.
@@ -6595,13 +6601,9 @@ lpfc_sli4_create_rpi_hdr(struct lpfc_hba *phba)
 
 	/* The rpi_hdr stores the logical index only. */
 	rpi_hdr->start_rpi = curr_rpi_range;
+	rpi_hdr->next_rpi = phba->sli4_hba.next_rpi + LPFC_RPI_HDR_COUNT;
 	list_add_tail(&rpi_hdr->list, &phba->sli4_hba.lpfc_rpi_hdr_list);
 
-	/*
-	 * The next_rpi stores the next logical module-64 rpi value used
-	 * to post physical rpis in subsequent rpi postings.
-	 */
-	phba->sli4_hba.next_rpi += rpi_count;
 	spin_unlock_irq(&phba->hbalock);
 	return rpi_hdr;
 
@@ -8172,7 +8174,7 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 			/* Create NVMET Receive Queue for header */
 			qdesc = lpfc_sli4_queue_alloc(phba,
 						      phba->sli4_hba.rq_esize,
-						      phba->sli4_hba.rq_ecount);
+						      LPFC_NVMET_RQE_DEF_COUNT);
 			if (!qdesc) {
 				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 						"3146 Failed allocate "
@@ -8194,7 +8196,7 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 			/* Create NVMET Receive Queue for data */
 			qdesc = lpfc_sli4_queue_alloc(phba,
 						      phba->sli4_hba.rq_esize,
-						      phba->sli4_hba.rq_ecount);
+						      LPFC_NVMET_RQE_DEF_COUNT);
 			if (!qdesc) {
 				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 						"3156 Failed allocate "
@@ -8326,46 +8328,6 @@ lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
 }
 
 int
-lpfc_post_rq_buffer(struct lpfc_hba *phba, struct lpfc_queue *hrq,
-		    struct lpfc_queue *drq, int count)
-{
-	int rc, i;
-	struct lpfc_rqe hrqe;
-	struct lpfc_rqe drqe;
-	struct lpfc_rqb *rqbp;
-	struct rqb_dmabuf *rqb_buffer;
-	LIST_HEAD(rqb_buf_list);
-
-	rqbp = hrq->rqbp;
-	for (i = 0; i < count; i++) {
-		rqb_buffer = (rqbp->rqb_alloc_buffer)(phba);
-		if (!rqb_buffer)
-			break;
-		rqb_buffer->hrq = hrq;
-		rqb_buffer->drq = drq;
-		list_add_tail(&rqb_buffer->hbuf.list, &rqb_buf_list);
-	}
-	while (!list_empty(&rqb_buf_list)) {
-		list_remove_head(&rqb_buf_list, rqb_buffer, struct rqb_dmabuf,
-				 hbuf.list);
-
-		hrqe.address_lo = putPaddrLow(rqb_buffer->hbuf.phys);
-		hrqe.address_hi = putPaddrHigh(rqb_buffer->hbuf.phys);
-		drqe.address_lo = putPaddrLow(rqb_buffer->dbuf.phys);
-		drqe.address_hi = putPaddrHigh(rqb_buffer->dbuf.phys);
-		rc = lpfc_sli4_rq_put(hrq, drq, &hrqe, &drqe);
-		if (rc < 0) {
-			(rqbp->rqb_free_buffer)(phba, rqb_buffer);
-		} else {
-			list_add_tail(&rqb_buffer->hbuf.list,
-				      &rqbp->rqb_buffer_list);
-			rqbp->buffer_count++;
-		}
-	}
-	return 1;
-}
-
-int
 lpfc_free_rq_buffer(struct lpfc_hba *phba, struct lpfc_queue *rq)
 {
 	struct lpfc_rqb *rqbp;
@@ -8784,9 +8746,6 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 		goto out_destroy;
 	}
 
-	lpfc_rq_adjust_repost(phba, phba->sli4_hba.hdr_rq, LPFC_ELS_HBQ);
-	lpfc_rq_adjust_repost(phba, phba->sli4_hba.dat_rq, LPFC_ELS_HBQ);
-
 	rc = lpfc_rq_create(phba, phba->sli4_hba.hdr_rq, phba->sli4_hba.dat_rq,
 			    phba->sli4_hba.els_cq, LPFC_USOL);
 	if (rc) {
@@ -11110,7 +11069,7 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 	struct lpfc_hba   *phba;
 	struct lpfc_vport *vport = NULL;
 	struct Scsi_Host  *shost = NULL;
-	int error, cnt;
+	int error;
 	uint32_t cfg_mode, intr_mode;
 
 	/* Allocate memory for HBA structure */
@@ -11144,22 +11103,6 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 		goto out_unset_pci_mem_s4;
 	}
 
-	cnt = phba->cfg_iocb_cnt * 1024;
-	if (phba->nvmet_support)
-		cnt += phba->cfg_nvmet_mrq_post * phba->cfg_nvmet_mrq;
-
-	/* Initialize and populate the iocb list per host */
-	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-			"2821 initialize iocb list %d total %d\n",
-			phba->cfg_iocb_cnt, cnt);
-	error = lpfc_init_iocb_list(phba, cnt);
-
-	if (error) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"1413 Failed to initialize iocb list.\n");
-		goto out_unset_driver_resource_s4;
-	}
-
 	INIT_LIST_HEAD(&phba->active_rrq_list);
 	INIT_LIST_HEAD(&phba->fcf.fcf_pri_list);
 
@@ -11168,7 +11111,7 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 	if (error) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"1414 Failed to set up driver resource.\n");
-		goto out_free_iocb_list;
+		goto out_unset_driver_resource_s4;
 	}
 
 	/* Get the default values for Model Name and Description */
@@ -11268,8 +11211,6 @@ lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id *pid)
 	lpfc_destroy_shost(phba);
 out_unset_driver_resource:
 	lpfc_unset_driver_resource_phase2(phba);
-out_free_iocb_list:
-	lpfc_free_iocb_list(phba);
 out_unset_driver_resource_s4:
 	lpfc_sli4_driver_resource_unset(phba);
 out_unset_pci_mem_s4:
diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index 5986c7957199..fcc05a1517c2 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -214,6 +214,21 @@ lpfc_mem_alloc(struct lpfc_hba *phba, int align)
 	return -ENOMEM;
 }
 
+int
+lpfc_nvmet_mem_alloc(struct lpfc_hba *phba)
+{
+	phba->lpfc_nvmet_drb_pool =
+		pci_pool_create("lpfc_nvmet_drb_pool",
+				phba->pcidev, LPFC_NVMET_DATA_BUF_SIZE,
+				SGL_ALIGN_SZ, 0);
+	if (!phba->lpfc_nvmet_drb_pool) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"6024 Can't enable NVME Target - no memory\n");
+		return -ENOMEM;
+	}
+	return 0;
+}
+
 /**
  * lpfc_mem_free - Frees memory allocated by lpfc_mem_alloc
  * @phba: HBA to free memory for
@@ -232,6 +247,9 @@ lpfc_mem_free(struct lpfc_hba *phba)
 
 	/* Free HBQ pools */
 	lpfc_sli_hbqbuf_free_all(phba);
+	if (phba->lpfc_nvmet_drb_pool)
+		pci_pool_destroy(phba->lpfc_nvmet_drb_pool);
+	phba->lpfc_nvmet_drb_pool = NULL;
 	if (phba->lpfc_drb_pool)
 		pci_pool_destroy(phba->lpfc_drb_pool);
 	phba->lpfc_drb_pool = NULL;
@@ -611,8 +629,6 @@ struct rqb_dmabuf *
 lpfc_sli4_nvmet_alloc(struct lpfc_hba *phba)
 {
 	struct rqb_dmabuf *dma_buf;
-	struct lpfc_iocbq *nvmewqe;
-	union lpfc_wqe128 *wqe;
 
 	dma_buf = kzalloc(sizeof(struct rqb_dmabuf), GFP_KERNEL);
 	if (!dma_buf)
@@ -624,69 +640,15 @@ lpfc_sli4_nvmet_alloc(struct lpfc_hba *phba)
 		kfree(dma_buf);
 		return NULL;
 	}
-	dma_buf->dbuf.virt = pci_pool_alloc(phba->lpfc_drb_pool, GFP_KERNEL,
-					    &dma_buf->dbuf.phys);
+	dma_buf->dbuf.virt = pci_pool_alloc(phba->lpfc_nvmet_drb_pool,
+					    GFP_KERNEL, &dma_buf->dbuf.phys);
 	if (!dma_buf->dbuf.virt) {
 		pci_pool_free(phba->lpfc_hrb_pool, dma_buf->hbuf.virt,
 			      dma_buf->hbuf.phys);
 		kfree(dma_buf);
 		return NULL;
 	}
-	dma_buf->total_size = LPFC_DATA_BUF_SIZE;
-
-	dma_buf->context = kzalloc(sizeof(struct lpfc_nvmet_rcv_ctx),
-				   GFP_KERNEL);
-	if (!dma_buf->context) {
-		pci_pool_free(phba->lpfc_drb_pool, dma_buf->dbuf.virt,
-			      dma_buf->dbuf.phys);
-		pci_pool_free(phba->lpfc_hrb_pool, dma_buf->hbuf.virt,
-			      dma_buf->hbuf.phys);
-		kfree(dma_buf);
-		return NULL;
-	}
-
-	dma_buf->iocbq = lpfc_sli_get_iocbq(phba);
-	if (!dma_buf->iocbq) {
-		kfree(dma_buf->context);
-		pci_pool_free(phba->lpfc_drb_pool, dma_buf->dbuf.virt,
-			      dma_buf->dbuf.phys);
-		pci_pool_free(phba->lpfc_hrb_pool, dma_buf->hbuf.virt,
-			      dma_buf->hbuf.phys);
-		kfree(dma_buf);
-		lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
-				"2621 Ran out of nvmet iocb/WQEs\n");
-		return NULL;
-	}
-	dma_buf->iocbq->iocb_flag = LPFC_IO_NVMET;
-	nvmewqe = dma_buf->iocbq;
-	wqe = (union lpfc_wqe128 *)&nvmewqe->wqe;
-	/* Initialize WQE */
-	memset(wqe, 0, sizeof(union lpfc_wqe));
-	/* Word 7 */
-	bf_set(wqe_ct, &wqe->generic.wqe_com, SLI4_CT_RPI);
-	bf_set(wqe_class, &wqe->generic.wqe_com, CLASS3);
-	bf_set(wqe_pu, &wqe->generic.wqe_com, 1);
-	/* Word 10 */
-	bf_set(wqe_nvme, &wqe->fcp_tsend.wqe_com, 1);
-	bf_set(wqe_ebde_cnt, &wqe->generic.wqe_com, 0);
-	bf_set(wqe_qosd, &wqe->generic.wqe_com, 0);
-
-	dma_buf->iocbq->context1 = NULL;
-	spin_lock(&phba->sli4_hba.sgl_list_lock);
-	dma_buf->sglq = __lpfc_sli_get_nvmet_sglq(phba, dma_buf->iocbq);
-	spin_unlock(&phba->sli4_hba.sgl_list_lock);
-	if (!dma_buf->sglq) {
-		lpfc_sli_release_iocbq(phba, dma_buf->iocbq);
-		kfree(dma_buf->context);
-		pci_pool_free(phba->lpfc_drb_pool, dma_buf->dbuf.virt,
-			      dma_buf->dbuf.phys);
-		pci_pool_free(phba->lpfc_hrb_pool, dma_buf->hbuf.virt,
-			      dma_buf->hbuf.phys);
-		kfree(dma_buf);
-		lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
-				"6132 Ran out of nvmet XRIs\n");
-		return NULL;
-	}
+	dma_buf->total_size = LPFC_NVMET_DATA_BUF_SIZE;
 	return dma_buf;
 }
 
@@ -705,20 +667,9 @@ lpfc_sli4_nvmet_alloc(struct lpfc_hba *phba)
 void
 lpfc_sli4_nvmet_free(struct lpfc_hba *phba, struct rqb_dmabuf *dmab)
 {
-	unsigned long flags;
-
-	__lpfc_clear_active_sglq(phba, dmab->sglq->sli4_lxritag);
-	dmab->sglq->state = SGL_FREED;
-	dmab->sglq->ndlp = NULL;
-
-	spin_lock_irqsave(&phba->sli4_hba.sgl_list_lock, flags);
-	list_add_tail(&dmab->sglq->list, &phba->sli4_hba.lpfc_nvmet_sgl_list);
-	spin_unlock_irqrestore(&phba->sli4_hba.sgl_list_lock, flags);
-
-	lpfc_sli_release_iocbq(phba, dmab->iocbq);
-	kfree(dmab->context);
 	pci_pool_free(phba->lpfc_hrb_pool, dmab->hbuf.virt, dmab->hbuf.phys);
-	pci_pool_free(phba->lpfc_drb_pool, dmab->dbuf.virt, dmab->dbuf.phys);
+	pci_pool_free(phba->lpfc_nvmet_drb_pool,
+		      dmab->dbuf.virt, dmab->dbuf.phys);
 	kfree(dmab);
 }
 
@@ -803,6 +754,11 @@ lpfc_rq_buf_free(struct lpfc_hba *phba, struct lpfc_dmabuf *mp)
 	rc = lpfc_sli4_rq_put(rqb_entry->hrq, rqb_entry->drq, &hrqe, &drqe);
 	if (rc < 0) {
 		(rqbp->rqb_free_buffer)(phba, rqb_entry);
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"6409 Cannot post to RQ %d: %x %x\n",
+				rqb_entry->hrq->queue_id,
+				rqb_entry->hrq->host_index,
+				rqb_entry->hrq->hba_index);
 	} else {
 		list_add_tail(&rqb_entry->hbuf.list, &rqbp->rqb_buffer_list);
 		rqbp->buffer_count++;
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 8777c2d5f50d..bff3de053df4 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1944,7 +1944,13 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 		/* Target driver cannot solicit NVME FB. */
 		if (bf_get_be32(prli_tgt, nvpr)) {
+			/* Complete the nvme target roles.  The transport
+			 * needs to know if the rport is capable of
+			 * discovery in addition to its role.
+			 */
 			ndlp->nlp_type |= NLP_NVME_TARGET;
+			if (bf_get_be32(prli_disc, nvpr))
+				ndlp->nlp_type |= NLP_NVME_DISCOVERY;
 			if ((bf_get_be32(prli_fba, nvpr) == 1) &&
 			    (bf_get_be32(prli_fb_sz, nvpr) > 0) &&
 			    (phba->cfg_nvme_enable_fb) &&
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 94434e621c33..f94294b77b7b 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -142,7 +142,7 @@ lpfc_nvmet_xmt_ls_rsp_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 }
 
 /**
- * lpfc_nvmet_rq_post - Repost a NVMET RQ DMA buffer and clean up context
+ * lpfc_nvmet_ctxbuf_post - Repost a NVMET RQ DMA buffer and clean up context
  * @phba: HBA buffer is associated with
  * @ctxp: context to clean up
  * @mp: Buffer to free
@@ -155,24 +155,113 @@ lpfc_nvmet_xmt_ls_rsp_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
  * Returns: None
  **/
 void
-lpfc_nvmet_rq_post(struct lpfc_hba *phba, struct lpfc_nvmet_rcv_ctx *ctxp,
-		   struct lpfc_dmabuf *mp)
+lpfc_nvmet_ctxbuf_post(struct lpfc_hba *phba, struct lpfc_nvmet_ctxbuf *ctx_buf)
 {
-	if (ctxp) {
-		if (ctxp->flag)
-			lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
-				"6314 rq_post ctx xri x%x flag x%x\n",
-				ctxp->oxid, ctxp->flag);
-
-		if (ctxp->txrdy) {
-			pci_pool_free(phba->txrdy_payload_pool, ctxp->txrdy,
-				      ctxp->txrdy_phys);
-			ctxp->txrdy = NULL;
-			ctxp->txrdy_phys = 0;
+#if (IS_ENABLED(CONFIG_NVME_TARGET_FC))
+	struct lpfc_nvmet_rcv_ctx *ctxp = ctx_buf->context;
+	struct lpfc_nvmet_tgtport *tgtp;
+	struct fc_frame_header *fc_hdr;
+	struct rqb_dmabuf *nvmebuf;
+	struct lpfc_dmabuf *hbufp;
+	uint32_t *payload;
+	uint32_t size, oxid, sid, rc;
+	unsigned long iflag;
+
+	if (ctxp->txrdy) {
+		pci_pool_free(phba->txrdy_payload_pool, ctxp->txrdy,
+			      ctxp->txrdy_phys);
+		ctxp->txrdy = NULL;
+		ctxp->txrdy_phys = 0;
+	}
+	ctxp->state = LPFC_NVMET_STE_FREE;
+
+	spin_lock_irqsave(&phba->sli4_hba.nvmet_io_wait_lock, iflag);
+	if (phba->sli4_hba.nvmet_io_wait_cnt) {
+		hbufp = &nvmebuf->hbuf;
+		list_remove_head(&phba->sli4_hba.lpfc_nvmet_io_wait_list,
+				 nvmebuf, struct rqb_dmabuf,
+				 hbuf.list);
+		phba->sli4_hba.nvmet_io_wait_cnt--;
+		spin_unlock_irqrestore(&phba->sli4_hba.nvmet_io_wait_lock,
+				       iflag);
+
+		fc_hdr = (struct fc_frame_header *)(nvmebuf->hbuf.virt);
+		oxid = be16_to_cpu(fc_hdr->fh_ox_id);
+		tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
+		payload = (uint32_t *)(nvmebuf->dbuf.virt);
+		size = nvmebuf->bytes_recv;
+		sid = sli4_sid_from_fc_hdr(fc_hdr);
+
+		ctxp = (struct lpfc_nvmet_rcv_ctx *)ctx_buf->context;
+		memset(ctxp, 0, sizeof(ctxp->ctx));
+		ctxp->wqeq = NULL;
+		ctxp->txrdy = NULL;
+		ctxp->offset = 0;
+		ctxp->phba = phba;
+		ctxp->size = size;
+		ctxp->oxid = oxid;
+		ctxp->sid = sid;
+		ctxp->state = LPFC_NVMET_STE_RCV;
+		ctxp->entry_cnt = 1;
+		ctxp->flag = 0;
+		ctxp->ctxbuf = ctx_buf;
+		spin_lock_init(&ctxp->ctxlock);
+
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+		if (phba->ktime_on) {
+			ctxp->ts_cmd_nvme = ktime_get_ns();
+			ctxp->ts_isr_cmd = ctxp->ts_cmd_nvme;
+			ctxp->ts_nvme_data = 0;
+			ctxp->ts_data_wqput = 0;
+			ctxp->ts_isr_data = 0;
+			ctxp->ts_data_nvme = 0;
+			ctxp->ts_nvme_status = 0;
+			ctxp->ts_status_wqput = 0;
+			ctxp->ts_isr_status = 0;
+			ctxp->ts_status_nvme = 0;
 		}
-		ctxp->state = LPFC_NVMET_STE_FREE;
+#endif
+		atomic_inc(&tgtp->rcv_fcp_cmd_in);
+		/*
+		 * The calling sequence should be:
+		 * nvmet_fc_rcv_fcp_req->lpfc_nvmet_xmt_fcp_op/cmp- req->done
+		 * lpfc_nvmet_xmt_fcp_op_cmp should free the allocated ctxp.
+		 * When we return from nvmet_fc_rcv_fcp_req, all relevant info
+		 * the NVME command / FC header is stored.
+		 * A buffer has already been reposted for this IO, so just free
+		 * the nvmebuf.
+		 */
+		rc = nvmet_fc_rcv_fcp_req(phba->targetport, &ctxp->ctx.fcp_req,
+					  payload, size);
+
+		/* Process FCP command */
+		if (rc == 0) {
+			atomic_inc(&tgtp->rcv_fcp_cmd_out);
+			nvmebuf->hrq->rqbp->rqb_free_buffer(phba, nvmebuf);
+			return;
+		}
+
+		atomic_inc(&tgtp->rcv_fcp_cmd_drop);
+		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
+				"2582 FCP Drop IO x%x: err x%x: x%x x%x x%x\n",
+				ctxp->oxid, rc,
+				atomic_read(&tgtp->rcv_fcp_cmd_in),
+				atomic_read(&tgtp->rcv_fcp_cmd_out),
+				atomic_read(&tgtp->xmt_fcp_release));
+
+		lpfc_nvmet_defer_release(phba, ctxp);
+		lpfc_nvmet_unsol_fcp_issue_abort(phba, ctxp, sid, oxid);
+		nvmebuf->hrq->rqbp->rqb_free_buffer(phba, nvmebuf);
+		return;
 	}
-	lpfc_rq_buf_free(phba, mp);
+	spin_unlock_irqrestore(&phba->sli4_hba.nvmet_io_wait_lock, iflag);
+
+	spin_lock_irqsave(&phba->sli4_hba.nvmet_io_lock, iflag);
+	list_add_tail(&ctx_buf->list,
+		      &phba->sli4_hba.lpfc_nvmet_ctx_list);
+	phba->sli4_hba.nvmet_ctx_cnt++;
+	spin_unlock_irqrestore(&phba->sli4_hba.nvmet_io_lock, iflag);
+#endif
 }
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
@@ -502,6 +591,7 @@ lpfc_nvmet_xmt_ls_rsp(struct nvmet_fc_target_port *tgtport,
 				"6150 LS Drop IO x%x: Prep\n",
 				ctxp->oxid);
 		lpfc_in_buf_free(phba, &nvmebuf->dbuf);
+		atomic_inc(&nvmep->xmt_ls_abort);
 		lpfc_nvmet_unsol_ls_issue_abort(phba, ctxp,
 						ctxp->sid, ctxp->oxid);
 		return -ENOMEM;
@@ -545,6 +635,7 @@ lpfc_nvmet_xmt_ls_rsp(struct nvmet_fc_target_port *tgtport,
 	lpfc_nlp_put(nvmewqeq->context1);
 
 	lpfc_in_buf_free(phba, &nvmebuf->dbuf);
+	atomic_inc(&nvmep->xmt_ls_abort);
 	lpfc_nvmet_unsol_ls_issue_abort(phba, ctxp, ctxp->sid, ctxp->oxid);
 	return -ENXIO;
 }
@@ -612,9 +703,9 @@ lpfc_nvmet_xmt_fcp_op(struct nvmet_fc_target_port *tgtport,
 	lpfc_nvmeio_data(phba, "NVMET FCP CMND: xri x%x op x%x len x%x\n",
 			 ctxp->oxid, rsp->op, rsp->rsplen);
 
+	ctxp->flag |= LPFC_NVMET_IO_INP;
 	rc = lpfc_sli4_issue_wqe(phba, LPFC_FCP_RING, nvmewqeq);
 	if (rc == WQE_SUCCESS) {
-		ctxp->flag |= LPFC_NVMET_IO_INP;
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 		if (!phba->ktime_on)
 			return 0;
@@ -692,6 +783,7 @@ static void
 lpfc_nvmet_xmt_fcp_release(struct nvmet_fc_target_port *tgtport,
 			   struct nvmefc_tgt_fcp_req *rsp)
 {
+	struct lpfc_nvmet_tgtport *lpfc_nvmep = tgtport->private;
 	struct lpfc_nvmet_rcv_ctx *ctxp =
 		container_of(rsp, struct lpfc_nvmet_rcv_ctx, ctx.fcp_req);
 	struct lpfc_hba *phba = ctxp->phba;
@@ -710,10 +802,12 @@ lpfc_nvmet_xmt_fcp_release(struct nvmet_fc_target_port *tgtport,
 	lpfc_nvmeio_data(phba, "NVMET FCP FREE: xri x%x ste %d\n", ctxp->oxid,
 			 ctxp->state, 0);
 
+	atomic_inc(&lpfc_nvmep->xmt_fcp_release);
+
 	if (aborting)
 		return;
 
-	lpfc_nvmet_rq_post(phba, ctxp, &ctxp->rqb_buffer->hbuf);
+	lpfc_nvmet_ctxbuf_post(phba, ctxp->ctxbuf);
 }
 
 static struct nvmet_fc_target_template lpfc_tgttemplate = {
@@ -734,17 +828,128 @@ static struct nvmet_fc_target_template lpfc_tgttemplate = {
 	.target_priv_sz = sizeof(struct lpfc_nvmet_tgtport),
 };
 
+void
+lpfc_nvmet_cleanup_io_context(struct lpfc_hba *phba)
+{
+	struct lpfc_nvmet_ctxbuf *ctx_buf, *next_ctx_buf;
+	unsigned long flags;
+
+	list_for_each_entry_safe(
+		ctx_buf, next_ctx_buf,
+		&phba->sli4_hba.lpfc_nvmet_ctx_list, list) {
+		spin_lock_irqsave(
+			&phba->sli4_hba.abts_nvme_buf_list_lock, flags);
+		list_del_init(&ctx_buf->list);
+		spin_unlock_irqrestore(
+			&phba->sli4_hba.abts_nvme_buf_list_lock, flags);
+		__lpfc_clear_active_sglq(phba,
+					 ctx_buf->sglq->sli4_lxritag);
+		ctx_buf->sglq->state = SGL_FREED;
+		ctx_buf->sglq->ndlp = NULL;
+
+		spin_lock_irqsave(&phba->sli4_hba.sgl_list_lock, flags);
+		list_add_tail(&ctx_buf->sglq->list,
+			      &phba->sli4_hba.lpfc_nvmet_sgl_list);
+		spin_unlock_irqrestore(&phba->sli4_hba.sgl_list_lock,
+				       flags);
+
+		lpfc_sli_release_iocbq(phba, ctx_buf->iocbq);
+		kfree(ctx_buf->context);
+	}
+}
+
+int
+lpfc_nvmet_setup_io_context(struct lpfc_hba *phba)
+{
+	struct lpfc_nvmet_ctxbuf *ctx_buf;
+	struct lpfc_iocbq *nvmewqe;
+	union lpfc_wqe128 *wqe;
+	int i;
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_NVME,
+			"6403 Allocate NVMET resources for %d XRIs\n",
+			phba->sli4_hba.nvmet_xri_cnt);
+
+	/* For all nvmet xris, allocate resources needed to process a
+	 * received command on a per xri basis.
+	 */
+	for (i = 0; i < phba->sli4_hba.nvmet_xri_cnt; i++) {
+		ctx_buf = kzalloc(sizeof(*ctx_buf), GFP_KERNEL);
+		if (!ctx_buf) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
+					"6404 Ran out of memory for NVMET\n");
+			return -ENOMEM;
+		}
+
+		ctx_buf->context = kzalloc(sizeof(*ctx_buf->context),
+					   GFP_KERNEL);
+		if (!ctx_buf->context) {
+			kfree(ctx_buf);
+			lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
+					"6405 Ran out of NVMET "
+					"context memory\n");
+			return -ENOMEM;
+		}
+		ctx_buf->context->ctxbuf = ctx_buf;
+
+		ctx_buf->iocbq = lpfc_sli_get_iocbq(phba);
+		if (!ctx_buf->iocbq) {
+			kfree(ctx_buf->context);
+			kfree(ctx_buf);
+			lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
+					"6406 Ran out of NVMET iocb/WQEs\n");
+			return -ENOMEM;
+		}
+		ctx_buf->iocbq->iocb_flag = LPFC_IO_NVMET;
+		nvmewqe = ctx_buf->iocbq;
+		wqe = (union lpfc_wqe128 *)&nvmewqe->wqe;
+		/* Initialize WQE */
+		memset(wqe, 0, sizeof(union lpfc_wqe));
+		/* Word 7 */
+		bf_set(wqe_ct, &wqe->generic.wqe_com, SLI4_CT_RPI);
+		bf_set(wqe_class, &wqe->generic.wqe_com, CLASS3);
+		bf_set(wqe_pu, &wqe->generic.wqe_com, 1);
+		/* Word 10 */
+		bf_set(wqe_nvme, &wqe->fcp_tsend.wqe_com, 1);
+		bf_set(wqe_ebde_cnt, &wqe->generic.wqe_com, 0);
+		bf_set(wqe_qosd, &wqe->generic.wqe_com, 0);
+
+		ctx_buf->iocbq->context1 = NULL;
+		spin_lock(&phba->sli4_hba.sgl_list_lock);
+		ctx_buf->sglq = __lpfc_sli_get_nvmet_sglq(phba, ctx_buf->iocbq);
+		spin_unlock(&phba->sli4_hba.sgl_list_lock);
+		if (!ctx_buf->sglq) {
+			lpfc_sli_release_iocbq(phba, ctx_buf->iocbq);
+			kfree(ctx_buf->context);
+			kfree(ctx_buf);
+			lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
+					"6407 Ran out of NVMET XRIs\n");
+			return -ENOMEM;
+		}
+		spin_lock(&phba->sli4_hba.nvmet_io_lock);
+		list_add_tail(&ctx_buf->list,
+			      &phba->sli4_hba.lpfc_nvmet_ctx_list);
+		spin_unlock(&phba->sli4_hba.nvmet_io_lock);
+	}
+	phba->sli4_hba.nvmet_ctx_cnt = phba->sli4_hba.nvmet_xri_cnt;
+	return 0;
+}
+
 int
 lpfc_nvmet_create_targetport(struct lpfc_hba *phba)
 {
 	struct lpfc_vport  *vport = phba->pport;
 	struct lpfc_nvmet_tgtport *tgtp;
 	struct nvmet_fc_port_info pinfo;
-	int error = 0;
+	int error;
 
 	if (phba->targetport)
 		return 0;
 
+	error = lpfc_nvmet_setup_io_context(phba);
+	if (error)
+		return error;
+
 	memset(&pinfo, 0, sizeof(struct nvmet_fc_port_info));
 	pinfo.node_name = wwn_to_u64(vport->fc_nodename.u.wwn);
 	pinfo.port_name = wwn_to_u64(vport->fc_portname.u.wwn);
@@ -773,13 +978,16 @@ lpfc_nvmet_create_targetport(struct lpfc_hba *phba)
 					     &phba->pcidev->dev,
 					     &phba->targetport);
 #else
-	error = -ENOMEM;
+	error = -ENOENT;
 #endif
 	if (error) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_DISC,
 				"6025 Cannot register NVME targetport "
 				"x%x\n", error);
 		phba->targetport = NULL;
+
+		lpfc_nvmet_cleanup_io_context(phba);
+
 	} else {
 		tgtp = (struct lpfc_nvmet_tgtport *)
 			phba->targetport->private;
@@ -796,6 +1004,7 @@ lpfc_nvmet_create_targetport(struct lpfc_hba *phba)
 		atomic_set(&tgtp->rcv_ls_req_out, 0);
 		atomic_set(&tgtp->rcv_ls_req_drop, 0);
 		atomic_set(&tgtp->xmt_ls_abort, 0);
+		atomic_set(&tgtp->xmt_ls_abort_cmpl, 0);
 		atomic_set(&tgtp->xmt_ls_rsp, 0);
 		atomic_set(&tgtp->xmt_ls_drop, 0);
 		atomic_set(&tgtp->xmt_ls_rsp_error, 0);
@@ -803,18 +1012,21 @@ lpfc_nvmet_create_targetport(struct lpfc_hba *phba)
 		atomic_set(&tgtp->rcv_fcp_cmd_in, 0);
 		atomic_set(&tgtp->rcv_fcp_cmd_out, 0);
 		atomic_set(&tgtp->rcv_fcp_cmd_drop, 0);
-		atomic_set(&tgtp->xmt_fcp_abort, 0);
 		atomic_set(&tgtp->xmt_fcp_drop, 0);
 		atomic_set(&tgtp->xmt_fcp_read_rsp, 0);
 		atomic_set(&tgtp->xmt_fcp_read, 0);
 		atomic_set(&tgtp->xmt_fcp_write, 0);
 		atomic_set(&tgtp->xmt_fcp_rsp, 0);
+		atomic_set(&tgtp->xmt_fcp_release, 0);
 		atomic_set(&tgtp->xmt_fcp_rsp_cmpl, 0);
 		atomic_set(&tgtp->xmt_fcp_rsp_error, 0);
 		atomic_set(&tgtp->xmt_fcp_rsp_drop, 0);
+		atomic_set(&tgtp->xmt_fcp_abort, 0);
+		atomic_set(&tgtp->xmt_fcp_abort_cmpl, 0);
+		atomic_set(&tgtp->xmt_abort_unsol, 0);
+		atomic_set(&tgtp->xmt_abort_sol, 0);
 		atomic_set(&tgtp->xmt_abort_rsp, 0);
 		atomic_set(&tgtp->xmt_abort_rsp_error, 0);
-		atomic_set(&tgtp->xmt_abort_cmpl, 0);
 	}
 	return error;
 }
@@ -865,7 +1077,7 @@ lpfc_sli4_nvmet_xri_aborted(struct lpfc_hba *phba,
 	list_for_each_entry_safe(ctxp, next_ctxp,
 				 &phba->sli4_hba.lpfc_abts_nvmet_ctx_list,
 				 list) {
-		if (ctxp->rqb_buffer->sglq->sli4_xritag != xri)
+		if (ctxp->ctxbuf->sglq->sli4_xritag != xri)
 			continue;
 
 		/* Check if we already received a free context call
@@ -886,7 +1098,7 @@ lpfc_sli4_nvmet_xri_aborted(struct lpfc_hba *phba,
 		    (ndlp->nlp_state == NLP_STE_UNMAPPED_NODE ||
 		     ndlp->nlp_state == NLP_STE_MAPPED_NODE)) {
 			lpfc_set_rrq_active(phba, ndlp,
-				ctxp->rqb_buffer->sglq->sli4_lxritag,
+				ctxp->ctxbuf->sglq->sli4_lxritag,
 				rxid, 1);
 			lpfc_sli4_abts_err_handler(phba, ndlp, axri);
 		}
@@ -895,8 +1107,8 @@ lpfc_sli4_nvmet_xri_aborted(struct lpfc_hba *phba,
 				"6318 XB aborted %x flg x%x (%x)\n",
 				ctxp->oxid, ctxp->flag, released);
 		if (released)
-			lpfc_nvmet_rq_post(phba, ctxp,
-					   &ctxp->rqb_buffer->hbuf);
+			lpfc_nvmet_ctxbuf_post(phba, ctxp->ctxbuf);
+
 		if (rrq_empty)
 			lpfc_worker_wake_up(phba);
 		return;
@@ -924,7 +1136,7 @@ lpfc_nvmet_rcv_unsol_abort(struct lpfc_vport *vport,
 	list_for_each_entry_safe(ctxp, next_ctxp,
 				 &phba->sli4_hba.lpfc_abts_nvmet_ctx_list,
 				 list) {
-		if (ctxp->rqb_buffer->sglq->sli4_xritag != xri)
+		if (ctxp->ctxbuf->sglq->sli4_xritag != xri)
 			continue;
 
 		spin_unlock(&phba->sli4_hba.abts_nvme_buf_list_lock);
@@ -976,6 +1188,7 @@ lpfc_nvmet_destroy_targetport(struct lpfc_hba *phba)
 		init_completion(&tgtp->tport_unreg_done);
 		nvmet_fc_unregister_targetport(phba->targetport);
 		wait_for_completion_timeout(&tgtp->tport_unreg_done, 5);
+		lpfc_nvmet_cleanup_io_context(phba);
 	}
 	phba->targetport = NULL;
 #endif
@@ -1011,6 +1224,7 @@ lpfc_nvmet_unsol_ls_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		oxid = 0;
 		size = 0;
 		sid = 0;
+		ctxp = NULL;
 		goto dropit;
 	}
 
@@ -1105,39 +1319,71 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
 	struct lpfc_nvmet_rcv_ctx *ctxp;
 	struct lpfc_nvmet_tgtport *tgtp;
 	struct fc_frame_header *fc_hdr;
+	struct lpfc_nvmet_ctxbuf *ctx_buf;
 	uint32_t *payload;
-	uint32_t size, oxid, sid, rc;
+	uint32_t size, oxid, sid, rc, qno;
+	unsigned long iflag;
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	uint32_t id;
 #endif
 
+	ctx_buf = NULL;
 	if (!nvmebuf || !phba->targetport) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
-				"6157 FCP Drop IO\n");
+				"6157 NVMET FCP Drop IO\n");
 		oxid = 0;
 		size = 0;
 		sid = 0;
+		ctxp = NULL;
 		goto dropit;
 	}
 
+	spin_lock_irqsave(&phba->sli4_hba.nvmet_io_lock, iflag);
+	if (phba->sli4_hba.nvmet_ctx_cnt) {
+		list_remove_head(&phba->sli4_hba.lpfc_nvmet_ctx_list,
+				 ctx_buf, struct lpfc_nvmet_ctxbuf, list);
+		phba->sli4_hba.nvmet_ctx_cnt--;
+	}
+	spin_unlock_irqrestore(&phba->sli4_hba.nvmet_io_lock, iflag);
 
-	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
-	payload = (uint32_t *)(nvmebuf->dbuf.virt);
 	fc_hdr = (struct fc_frame_header *)(nvmebuf->hbuf.virt);
-	size = nvmebuf->bytes_recv;
 	oxid = be16_to_cpu(fc_hdr->fh_ox_id);
-	sid = sli4_sid_from_fc_hdr(fc_hdr);
+	size = nvmebuf->bytes_recv;
 
-	ctxp = (struct lpfc_nvmet_rcv_ctx *)nvmebuf->context;
-	if (ctxp == NULL) {
-		atomic_inc(&tgtp->rcv_fcp_cmd_drop);
-		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
-				"6158 FCP Drop IO x%x: Alloc\n",
-				oxid);
-		lpfc_nvmet_rq_post(phba, NULL, &nvmebuf->hbuf);
-		/* Cannot send ABTS without context */
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+	if (phba->cpucheck_on & LPFC_CHECK_NVMET_RCV) {
+		id = smp_processor_id();
+		if (id < LPFC_CHECK_CPU_CNT)
+			phba->cpucheck_rcv_io[id]++;
+	}
+#endif
+
+	lpfc_nvmeio_data(phba, "NVMET FCP  RCV: xri x%x sz %d CPU %02x\n",
+			 oxid, size, smp_processor_id());
+
+	if (!ctx_buf) {
+		/* Queue this NVME IO to process later */
+		spin_lock_irqsave(&phba->sli4_hba.nvmet_io_wait_lock, iflag);
+		list_add_tail(&nvmebuf->hbuf.list,
+			      &phba->sli4_hba.lpfc_nvmet_io_wait_list);
+		phba->sli4_hba.nvmet_io_wait_cnt++;
+		phba->sli4_hba.nvmet_io_wait_total++;
+		spin_unlock_irqrestore(&phba->sli4_hba.nvmet_io_wait_lock,
+				       iflag);
+
+		/* Post a brand new DMA buffer to RQ */
+		qno = nvmebuf->idx;
+		lpfc_post_rq_buffer(
+			phba, phba->sli4_hba.nvmet_mrq_hdr[qno],
+			phba->sli4_hba.nvmet_mrq_data[qno], 1, qno);
 		return;
 	}
+
+	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
+	payload = (uint32_t *)(nvmebuf->dbuf.virt);
+	sid = sli4_sid_from_fc_hdr(fc_hdr);
+
+	ctxp = (struct lpfc_nvmet_rcv_ctx *)ctx_buf->context;
 	memset(ctxp, 0, sizeof(ctxp->ctx));
 	ctxp->wqeq = NULL;
 	ctxp->txrdy = NULL;
@@ -1147,9 +1393,9 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
 	ctxp->oxid = oxid;
 	ctxp->sid = sid;
 	ctxp->state = LPFC_NVMET_STE_RCV;
-	ctxp->rqb_buffer = nvmebuf;
 	ctxp->entry_cnt = 1;
 	ctxp->flag = 0;
+	ctxp->ctxbuf = ctx_buf;
 	spin_lock_init(&ctxp->ctxlock);
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
@@ -1165,22 +1411,16 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
 		ctxp->ts_isr_status = 0;
 		ctxp->ts_status_nvme = 0;
 	}
-
-	if (phba->cpucheck_on & LPFC_CHECK_NVMET_RCV) {
-		id = smp_processor_id();
-		if (id < LPFC_CHECK_CPU_CNT)
-			phba->cpucheck_rcv_io[id]++;
-	}
 #endif
 
-	lpfc_nvmeio_data(phba, "NVMET FCP  RCV: xri x%x sz %d CPU %02x\n",
-			 oxid, size, smp_processor_id());
-
 	atomic_inc(&tgtp->rcv_fcp_cmd_in);
 	/*
 	 * The calling sequence should be:
 	 * nvmet_fc_rcv_fcp_req -> lpfc_nvmet_xmt_fcp_op/cmp -> req->done
 	 * lpfc_nvmet_xmt_fcp_op_cmp should free the allocated ctxp.
+	 * When we return from nvmet_fc_rcv_fcp_req, all relevant info in
+	 * the NVME command / FC header is stored, so we are free to repost
+	 * the buffer.
 	 */
 	rc = nvmet_fc_rcv_fcp_req(phba->targetport, &ctxp->ctx.fcp_req,
 				  payload, size);
@@ -1188,26 +1428,32 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
 	/* Process FCP command */
 	if (rc == 0) {
 		atomic_inc(&tgtp->rcv_fcp_cmd_out);
+		lpfc_rq_buf_free(phba, &nvmebuf->hbuf); /* repost */
 		return;
 	}
 
 	atomic_inc(&tgtp->rcv_fcp_cmd_drop);
 	lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
-			"6159 FCP Drop IO x%x: err x%x\n",
-			ctxp->oxid, rc);
+			"6159 FCP Drop IO x%x: err x%x: x%x x%x x%x\n",
+			ctxp->oxid, rc,
+			atomic_read(&tgtp->rcv_fcp_cmd_in),
+			atomic_read(&tgtp->rcv_fcp_cmd_out),
+			atomic_read(&tgtp->xmt_fcp_release));
 dropit:
 	lpfc_nvmeio_data(phba, "NVMET FCP DROP: xri x%x sz %d from %06x\n",
 			 oxid, size, sid);
 	if (oxid) {
+		lpfc_nvmet_defer_release(phba, ctxp);
 		lpfc_nvmet_unsol_fcp_issue_abort(phba, ctxp, sid, oxid);
+		lpfc_rq_buf_free(phba, &nvmebuf->hbuf); /* repost */
 		return;
 	}
 
-	if (nvmebuf) {
-		nvmebuf->iocbq->hba_wqidx = 0;
-		/* We assume a rcv'ed cmd ALWAYs fits into 1 buffer */
-		lpfc_nvmet_rq_post(phba, NULL, &nvmebuf->hbuf);
-	}
+	if (ctx_buf)
+		lpfc_nvmet_ctxbuf_post(phba, ctx_buf);
+
+	if (nvmebuf)
+		lpfc_rq_buf_free(phba, &nvmebuf->hbuf); /* repost */
 #endif
 }
 
@@ -1259,7 +1505,7 @@ lpfc_nvmet_unsol_fcp_event(struct lpfc_hba *phba,
 			   uint64_t isr_timestamp)
 {
 	if (phba->nvmet_support == 0) {
-		lpfc_nvmet_rq_post(phba, NULL, &nvmebuf->hbuf);
+		lpfc_rq_buf_free(phba, &nvmebuf->hbuf);
 		return;
 	}
 	lpfc_nvmet_unsol_fcp_buffer(phba, pring, nvmebuf,
@@ -1460,7 +1706,7 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 	nvmewqe = ctxp->wqeq;
 	if (nvmewqe == NULL) {
 		/* Allocate buffer for  command wqe */
-		nvmewqe = ctxp->rqb_buffer->iocbq;
+		nvmewqe = ctxp->ctxbuf->iocbq;
 		if (nvmewqe == NULL) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
 					"6110 lpfc_nvmet_prep_fcp_wqe: No "
@@ -1487,7 +1733,7 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
 		return NULL;
 	}
 
-	sgl  = (struct sli4_sge *)ctxp->rqb_buffer->sglq->sgl;
+	sgl  = (struct sli4_sge *)ctxp->ctxbuf->sglq->sgl;
 	switch (rsp->op) {
 	case NVMET_FCOP_READDATA:
 	case NVMET_FCOP_READDATA_RSP:
@@ -1812,7 +2058,8 @@ lpfc_nvmet_sol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 	result = wcqe->parameter;
 
 	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
-	atomic_inc(&tgtp->xmt_abort_cmpl);
+	if (ctxp->flag & LPFC_NVMET_ABORT_OP)
+		atomic_inc(&tgtp->xmt_fcp_abort_cmpl);
 
 	ctxp->state = LPFC_NVMET_STE_DONE;
 
@@ -1827,6 +2074,7 @@ lpfc_nvmet_sol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 	}
 	ctxp->flag &= ~LPFC_NVMET_ABORT_OP;
 	spin_unlock_irqrestore(&ctxp->ctxlock, flags);
+	atomic_inc(&tgtp->xmt_abort_rsp);
 
 	lpfc_printf_log(phba, KERN_ERR, LOG_NVME_ABTS,
 			"6165 ABORT cmpl: xri x%x flg x%x (%d) "
@@ -1835,15 +2083,16 @@ lpfc_nvmet_sol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 			wcqe->word0, wcqe->total_data_placed,
 			result, wcqe->word3);
 
+	cmdwqe->context2 = NULL;
+	cmdwqe->context3 = NULL;
 	/*
 	 * if transport has released ctx, then can reuse it. Otherwise,
 	 * will be recycled by transport release call.
 	 */
 	if (released)
-		lpfc_nvmet_rq_post(phba, ctxp, &ctxp->rqb_buffer->hbuf);
+		lpfc_nvmet_ctxbuf_post(phba, ctxp->ctxbuf);
 
-	cmdwqe->context2 = NULL;
-	cmdwqe->context3 = NULL;
+	/* This is the iocbq for the abort, not the command */
 	lpfc_sli_release_iocbq(phba, cmdwqe);
 
 	/* Since iaab/iaar are NOT set, there is no work left.
@@ -1877,7 +2126,8 @@ lpfc_nvmet_unsol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 	result = wcqe->parameter;
 
 	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
-	atomic_inc(&tgtp->xmt_abort_cmpl);
+	if (ctxp->flag & LPFC_NVMET_ABORT_OP)
+		atomic_inc(&tgtp->xmt_fcp_abort_cmpl);
 
 	if (!ctxp) {
 		/* if context is clear, related io alrady complete */
@@ -1907,6 +2157,7 @@ lpfc_nvmet_unsol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 	}
 	ctxp->flag &= ~LPFC_NVMET_ABORT_OP;
 	spin_unlock_irqrestore(&ctxp->ctxlock, flags);
+	atomic_inc(&tgtp->xmt_abort_rsp);
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
 			"6316 ABTS cmpl xri x%x flg x%x (%x) "
@@ -1914,15 +2165,15 @@ lpfc_nvmet_unsol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 			ctxp->oxid, ctxp->flag, released,
 			wcqe->word0, wcqe->total_data_placed,
 			result, wcqe->word3);
+
+	cmdwqe->context2 = NULL;
+	cmdwqe->context3 = NULL;
 	/*
 	 * if transport has released ctx, then can reuse it. Otherwise,
 	 * will be recycled by transport release call.
 	 */
 	if (released)
-		lpfc_nvmet_rq_post(phba, ctxp, &ctxp->rqb_buffer->hbuf);
-
-	cmdwqe->context2 = NULL;
-	cmdwqe->context3 = NULL;
+		lpfc_nvmet_ctxbuf_post(phba, ctxp->ctxbuf);
 
 	/* Since iaab/iaar are NOT set, there is no work left.
 	 * For LPFC_NVMET_XBUSY, lpfc_sli4_nvmet_xri_aborted
@@ -1953,7 +2204,7 @@ lpfc_nvmet_xmt_ls_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 	result = wcqe->parameter;
 
 	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
-	atomic_inc(&tgtp->xmt_abort_cmpl);
+	atomic_inc(&tgtp->xmt_ls_abort_cmpl);
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
 			"6083 Abort cmpl: ctx %p WCQE: %08x %08x %08x %08x\n",
@@ -1984,10 +2235,6 @@ lpfc_nvmet_unsol_issue_abort(struct lpfc_hba *phba,
 			sid, xri, ctxp->wqeq->sli4_xritag);
 
 	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
-	if (!ctxp->wqeq) {
-		ctxp->wqeq = ctxp->rqb_buffer->iocbq;
-		ctxp->wqeq->hba_wqidx = 0;
-	}
 
 	ndlp = lpfc_findnode_did(phba->pport, sid);
 	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp) ||
@@ -2083,7 +2330,7 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 
 	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
 	if (!ctxp->wqeq) {
-		ctxp->wqeq = ctxp->rqb_buffer->iocbq;
+		ctxp->wqeq = ctxp->ctxbuf->iocbq;
 		ctxp->wqeq->hba_wqidx = 0;
 	}
 
@@ -2104,6 +2351,7 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 	/* Issue ABTS for this WQE based on iotag */
 	ctxp->abort_wqeq = lpfc_sli_get_iocbq(phba);
 	if (!ctxp->abort_wqeq) {
+		atomic_inc(&tgtp->xmt_abort_rsp_error);
 		lpfc_printf_log(phba, KERN_WARNING, LOG_NVME_ABTS,
 				"6161 ABORT failed: No wqeqs: "
 				"xri: x%x\n", ctxp->oxid);
@@ -2128,6 +2376,7 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 	/* driver queued commands are in process of being flushed */
 	if (phba->hba_flag & HBA_NVME_IOQ_FLUSH) {
 		spin_unlock_irqrestore(&phba->hbalock, flags);
+		atomic_inc(&tgtp->xmt_abort_rsp_error);
 		lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
 				"6163 Driver in reset cleanup - flushing "
 				"NVME Req now. hba_flag x%x oxid x%x\n",
@@ -2140,6 +2389,7 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 	/* Outstanding abort is in progress */
 	if (abts_wqeq->iocb_flag & LPFC_DRIVER_ABORTED) {
 		spin_unlock_irqrestore(&phba->hbalock, flags);
+		atomic_inc(&tgtp->xmt_abort_rsp_error);
 		lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
 				"6164 Outstanding NVME I/O Abort Request "
 				"still pending on oxid x%x\n",
@@ -2190,9 +2440,12 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 	abts_wqeq->context2 = ctxp;
 	rc = lpfc_sli4_issue_wqe(phba, LPFC_FCP_RING, abts_wqeq);
 	spin_unlock_irqrestore(&phba->hbalock, flags);
-	if (rc == WQE_SUCCESS)
+	if (rc == WQE_SUCCESS) {
+		atomic_inc(&tgtp->xmt_abort_sol);
 		return 0;
+	}
 
+	atomic_inc(&tgtp->xmt_abort_rsp_error);
 	ctxp->flag &= ~LPFC_NVMET_ABORT_OP;
 	lpfc_sli_release_iocbq(phba, abts_wqeq);
 	lpfc_printf_log(phba, KERN_ERR, LOG_NVME_ABTS,
@@ -2215,7 +2468,7 @@ lpfc_nvmet_unsol_fcp_issue_abort(struct lpfc_hba *phba,
 
 	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
 	if (!ctxp->wqeq) {
-		ctxp->wqeq = ctxp->rqb_buffer->iocbq;
+		ctxp->wqeq = ctxp->ctxbuf->iocbq;
 		ctxp->wqeq->hba_wqidx = 0;
 	}
 
@@ -2231,11 +2484,11 @@ lpfc_nvmet_unsol_fcp_issue_abort(struct lpfc_hba *phba,
 	rc = lpfc_sli4_issue_wqe(phba, LPFC_FCP_RING, abts_wqeq);
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 	if (rc == WQE_SUCCESS) {
-		atomic_inc(&tgtp->xmt_abort_rsp);
 		return 0;
 	}
 
 aerr:
+	atomic_inc(&tgtp->xmt_abort_rsp_error);
 	ctxp->flag &= ~LPFC_NVMET_ABORT_OP;
 	atomic_inc(&tgtp->xmt_abort_rsp_error);
 	lpfc_printf_log(phba, KERN_WARNING, LOG_NVME_ABTS,
@@ -2270,6 +2523,7 @@ lpfc_nvmet_unsol_ls_issue_abort(struct lpfc_hba *phba,
 	}
 	abts_wqeq = ctxp->wqeq;
 	wqe_abts = &abts_wqeq->wqe;
+
 	lpfc_nvmet_unsol_issue_abort(phba, ctxp, sid, xri);
 
 	spin_lock_irqsave(&phba->hbalock, flags);
@@ -2279,7 +2533,7 @@ lpfc_nvmet_unsol_ls_issue_abort(struct lpfc_hba *phba,
 	rc = lpfc_sli4_issue_wqe(phba, LPFC_ELS_RING, abts_wqeq);
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 	if (rc == WQE_SUCCESS) {
-		atomic_inc(&tgtp->xmt_abort_rsp);
+		atomic_inc(&tgtp->xmt_abort_unsol);
 		return 0;
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.h b/drivers/scsi/lpfc/lpfc_nvmet.h
index 128759fe6650..6eb2f5d8d4ed 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.h
+++ b/drivers/scsi/lpfc/lpfc_nvmet.h
@@ -22,6 +22,7 @@
  ********************************************************************/
 
 #define LPFC_NVMET_DEFAULT_SEGS		(64 + 1)	/* 256K IOs */
+#define LPFC_NVMET_RQE_DEF_COUNT	512
 #define LPFC_NVMET_SUCCESS_LEN	12
 
 /* Used for NVME Target */
@@ -34,6 +35,7 @@ struct lpfc_nvmet_tgtport {
 	atomic_t rcv_ls_req_out;
 	atomic_t rcv_ls_req_drop;
 	atomic_t xmt_ls_abort;
+	atomic_t xmt_ls_abort_cmpl;
 
 	/* Stats counters - lpfc_nvmet_xmt_ls_rsp */
 	atomic_t xmt_ls_rsp;
@@ -47,9 +49,9 @@ struct lpfc_nvmet_tgtport {
 	atomic_t rcv_fcp_cmd_in;
 	atomic_t rcv_fcp_cmd_out;
 	atomic_t rcv_fcp_cmd_drop;
+	atomic_t xmt_fcp_release;
 
 	/* Stats counters - lpfc_nvmet_xmt_fcp_op */
-	atomic_t xmt_fcp_abort;
 	atomic_t xmt_fcp_drop;
 	atomic_t xmt_fcp_read_rsp;
 	atomic_t xmt_fcp_read;
@@ -62,12 +64,13 @@ struct lpfc_nvmet_tgtport {
 	atomic_t xmt_fcp_rsp_drop;
 
 
-	/* Stats counters - lpfc_nvmet_unsol_issue_abort */
+	/* Stats counters - lpfc_nvmet_xmt_fcp_abort */
+	atomic_t xmt_fcp_abort;
+	atomic_t xmt_fcp_abort_cmpl;
+	atomic_t xmt_abort_sol;
+	atomic_t xmt_abort_unsol;
 	atomic_t xmt_abort_rsp;
 	atomic_t xmt_abort_rsp_error;
-
-	/* Stats counters - lpfc_nvmet_xmt_abort_cmp */
-	atomic_t xmt_abort_cmpl;
 };
 
 struct lpfc_nvmet_rcv_ctx {
@@ -103,6 +106,7 @@ struct lpfc_nvmet_rcv_ctx {
 #define LPFC_NVMET_CTX_RLS		0x8  /* ctx free requested */
 #define LPFC_NVMET_ABTS_RCV		0x10  /* ABTS received on exchange */
 	struct rqb_dmabuf *rqb_buffer;
+	struct lpfc_nvmet_ctxbuf *ctxbuf;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	uint64_t ts_isr_cmd;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 2a4fc00dfa9b..d6b184839bc2 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -74,6 +74,8 @@ static struct lpfc_iocbq *lpfc_sli4_els_wcqe_to_rspiocbq(struct lpfc_hba *,
 							 struct lpfc_iocbq *);
 static void lpfc_sli4_send_seq_to_ulp(struct lpfc_vport *,
 				      struct hbq_dmabuf *);
+static void lpfc_sli4_handle_mds_loopback(struct lpfc_vport *vport,
+					  struct hbq_dmabuf *dmabuf);
 static int lpfc_sli4_fp_handle_cqe(struct lpfc_hba *, struct lpfc_queue *,
 				    struct lpfc_cqe *);
 static int lpfc_sli4_post_sgl_list(struct lpfc_hba *, struct list_head *,
@@ -479,22 +481,23 @@ lpfc_sli4_rq_put(struct lpfc_queue *hq, struct lpfc_queue *dq,
 	if (unlikely(!hq) || unlikely(!dq))
 		return -ENOMEM;
 	put_index = hq->host_index;
-	temp_hrqe = hq->qe[hq->host_index].rqe;
+	temp_hrqe = hq->qe[put_index].rqe;
 	temp_drqe = dq->qe[dq->host_index].rqe;
 
 	if (hq->type != LPFC_HRQ || dq->type != LPFC_DRQ)
 		return -EINVAL;
-	if (hq->host_index != dq->host_index)
+	if (put_index != dq->host_index)
 		return -EINVAL;
 	/* If the host has not yet processed the next entry then we are done */
-	if (((hq->host_index + 1) % hq->entry_count) == hq->hba_index)
+	if (((put_index + 1) % hq->entry_count) == hq->hba_index)
 		return -EBUSY;
 	lpfc_sli_pcimem_bcopy(hrqe, temp_hrqe, hq->entry_size);
 	lpfc_sli_pcimem_bcopy(drqe, temp_drqe, dq->entry_size);
 
 	/* Update the host index to point to the next slot */
-	hq->host_index = ((hq->host_index + 1) % hq->entry_count);
+	hq->host_index = ((put_index + 1) % hq->entry_count);
 	dq->host_index = ((dq->host_index + 1) % dq->entry_count);
+	hq->RQ_buf_posted++;
 
 	/* Ring The Header Receive Queue Doorbell */
 	if (!(hq->host_index % hq->entry_repost)) {
@@ -5906,7 +5909,7 @@ lpfc_set_features(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox,
 		bf_set(lpfc_mbx_set_feature_mds,
 		       &mbox->u.mqe.un.set_feature, 1);
 		bf_set(lpfc_mbx_set_feature_mds_deep_loopbk,
-		       &mbox->u.mqe.un.set_feature, 0);
+		       &mbox->u.mqe.un.set_feature, 1);
 		mbox->u.mqe.un.set_feature.feature = LPFC_SET_MDS_DIAGS;
 		mbox->u.mqe.un.set_feature.param_len = 8;
 		break;
@@ -6512,6 +6515,50 @@ lpfc_set_host_data(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
 		 (phba->hba_flag & HBA_FCOE_MODE) ? "FCoE" : "FC");
 }
 
+int
+lpfc_post_rq_buffer(struct lpfc_hba *phba, struct lpfc_queue *hrq,
+		    struct lpfc_queue *drq, int count, int idx)
+{
+	int rc, i;
+	struct lpfc_rqe hrqe;
+	struct lpfc_rqe drqe;
+	struct lpfc_rqb *rqbp;
+	struct rqb_dmabuf *rqb_buffer;
+	LIST_HEAD(rqb_buf_list);
+
+	rqbp = hrq->rqbp;
+	for (i = 0; i < count; i++) {
+		/* IF RQ is already full, don't bother */
+		if (rqbp->buffer_count + i >= rqbp->entry_count - 1)
+			break;
+		rqb_buffer = rqbp->rqb_alloc_buffer(phba);
+		if (!rqb_buffer)
+			break;
+		rqb_buffer->hrq = hrq;
+		rqb_buffer->drq = drq;
+		rqb_buffer->idx = idx;
+		list_add_tail(&rqb_buffer->hbuf.list, &rqb_buf_list);
+	}
+	while (!list_empty(&rqb_buf_list)) {
+		list_remove_head(&rqb_buf_list, rqb_buffer, struct rqb_dmabuf,
+				 hbuf.list);
+
+		hrqe.address_lo = putPaddrLow(rqb_buffer->hbuf.phys);
+		hrqe.address_hi = putPaddrHigh(rqb_buffer->hbuf.phys);
+		drqe.address_lo = putPaddrLow(rqb_buffer->dbuf.phys);
+		drqe.address_hi = putPaddrHigh(rqb_buffer->dbuf.phys);
+		rc = lpfc_sli4_rq_put(hrq, drq, &hrqe, &drqe);
+		if (rc < 0) {
+			rqbp->rqb_free_buffer(phba, rqb_buffer);
+		} else {
+			list_add_tail(&rqb_buffer->hbuf.list,
+				      &rqbp->rqb_buffer_list);
+			rqbp->buffer_count++;
+		}
+	}
+	return 1;
+}
+
 /**
  * lpfc_sli4_hba_setup - SLI4 device initialization PCI function
  * @phba: Pointer to HBA context object.
@@ -6524,7 +6571,7 @@ lpfc_set_host_data(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
 int
 lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 {
-	int rc, i;
+	int rc, i, cnt;
 	LPFC_MBOXQ_t *mboxq;
 	struct lpfc_mqe *mqe;
 	uint8_t *vpd;
@@ -6875,6 +6922,21 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 			goto out_destroy_queue;
 		}
 		phba->sli4_hba.nvmet_xri_cnt = rc;
+
+		cnt = phba->cfg_iocb_cnt * 1024;
+		/* We need 1 iocbq for every SGL, for IO processing */
+		cnt += phba->sli4_hba.nvmet_xri_cnt;
+		/* Initialize and populate the iocb list per host */
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"2821 initialize iocb list %d total %d\n",
+				phba->cfg_iocb_cnt, cnt);
+		rc = lpfc_init_iocb_list(phba, cnt);
+		if (rc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"1413 Failed to init iocb list.\n");
+			goto out_destroy_queue;
+		}
+
 		lpfc_nvmet_create_targetport(phba);
 	} else {
 		/* update host scsi xri-sgl sizes and mappings */
@@ -6894,28 +6956,34 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 					"and mapping: %d\n", rc);
 			goto out_destroy_queue;
 		}
+
+		cnt = phba->cfg_iocb_cnt * 1024;
+		/* Initialize and populate the iocb list per host */
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"2820 initialize iocb list %d total %d\n",
+				phba->cfg_iocb_cnt, cnt);
+		rc = lpfc_init_iocb_list(phba, cnt);
+		if (rc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"6301 Failed to init iocb list.\n");
+			goto out_destroy_queue;
+		}
 	}
 
 	if (phba->nvmet_support && phba->cfg_nvmet_mrq) {
-
 		/* Post initial buffers to all RQs created */
 		for (i = 0; i < phba->cfg_nvmet_mrq; i++) {
 			rqbp = phba->sli4_hba.nvmet_mrq_hdr[i]->rqbp;
 			INIT_LIST_HEAD(&rqbp->rqb_buffer_list);
 			rqbp->rqb_alloc_buffer = lpfc_sli4_nvmet_alloc;
 			rqbp->rqb_free_buffer = lpfc_sli4_nvmet_free;
-			rqbp->entry_count = 256;
+			rqbp->entry_count = LPFC_NVMET_RQE_DEF_COUNT;
 			rqbp->buffer_count = 0;
 
-			/* Divide by 4 and round down to multiple of 16 */
-			rc = (phba->cfg_nvmet_mrq_post >> 2) & 0xfff8;
-			phba->sli4_hba.nvmet_mrq_hdr[i]->entry_repost = rc;
-			phba->sli4_hba.nvmet_mrq_data[i]->entry_repost = rc;
-
 			lpfc_post_rq_buffer(
 				phba, phba->sli4_hba.nvmet_mrq_hdr[i],
 				phba->sli4_hba.nvmet_mrq_data[i],
-				phba->cfg_nvmet_mrq_post);
+				LPFC_NVMET_RQE_DEF_COUNT, i);
 		}
 	}
 
@@ -7082,6 +7150,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	/* Unset all the queues set up in this routine when error out */
 	lpfc_sli4_queue_unset(phba);
 out_destroy_queue:
+	lpfc_free_iocb_list(phba);
 	lpfc_sli4_queue_destroy(phba);
 out_stop_timers:
 	lpfc_stop_hba_timers(phba);
@@ -8621,8 +8690,11 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		memset(wqe, 0, sizeof(union lpfc_wqe128));
 	/* Some of the fields are in the right position already */
 	memcpy(wqe, &iocbq->iocb, sizeof(union lpfc_wqe));
-	wqe->generic.wqe_com.word7 = 0; /* The ct field has moved so reset */
-	wqe->generic.wqe_com.word10 = 0;
+	if (iocbq->iocb.ulpCommand != CMD_SEND_FRAME) {
+		/* The ct field has moved so reset */
+		wqe->generic.wqe_com.word7 = 0;
+		wqe->generic.wqe_com.word10 = 0;
+	}
 
 	abort_tag = (uint32_t) iocbq->iotag;
 	xritag = iocbq->sli4_xritag;
@@ -9116,6 +9188,10 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		}
 
 		break;
+	case CMD_SEND_FRAME:
+		bf_set(wqe_xri_tag, &wqe->generic.wqe_com, xritag);
+		bf_set(wqe_reqtag, &wqe->generic.wqe_com, iocbq->iotag);
+		return 0;
 	case CMD_XRI_ABORTED_CX:
 	case CMD_CREATE_XRI_CR: /* Do we expect to use this? */
 	case CMD_IOCB_FCP_IBIDIR64_CR: /* bidirectional xfer */
@@ -12788,6 +12864,7 @@ lpfc_sli4_sp_handle_rcqe(struct lpfc_hba *phba, struct lpfc_rcqe *rcqe)
 	struct fc_frame_header *fc_hdr;
 	struct lpfc_queue *hrq = phba->sli4_hba.hdr_rq;
 	struct lpfc_queue *drq = phba->sli4_hba.dat_rq;
+	struct lpfc_nvmet_tgtport *tgtp;
 	struct hbq_dmabuf *dma_buf;
 	uint32_t status, rq_id;
 	unsigned long iflags;
@@ -12808,7 +12885,6 @@ lpfc_sli4_sp_handle_rcqe(struct lpfc_hba *phba, struct lpfc_rcqe *rcqe)
 	case FC_STATUS_RQ_BUF_LEN_EXCEEDED:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"2537 Receive Frame Truncated!!\n");
-		hrq->RQ_buf_trunc++;
 	case FC_STATUS_RQ_SUCCESS:
 		lpfc_sli4_rq_release(hrq, drq);
 		spin_lock_irqsave(&phba->hbalock, iflags);
@@ -12819,6 +12895,7 @@ lpfc_sli4_sp_handle_rcqe(struct lpfc_hba *phba, struct lpfc_rcqe *rcqe)
 			goto out;
 		}
 		hrq->RQ_rcv_buf++;
+		hrq->RQ_buf_posted--;
 		memcpy(&dma_buf->cq_event.cqe.rcqe_cmpl, rcqe, sizeof(*rcqe));
 
 		/* If a NVME LS event (type 0x28), treat it as Fast path */
@@ -12832,8 +12909,21 @@ lpfc_sli4_sp_handle_rcqe(struct lpfc_hba *phba, struct lpfc_rcqe *rcqe)
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 		workposted = true;
 		break;
-	case FC_STATUS_INSUFF_BUF_NEED_BUF:
 	case FC_STATUS_INSUFF_BUF_FRM_DISC:
+		if (phba->nvmet_support) {
+			tgtp = phba->targetport->private;
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI | LOG_NVME,
+					"6402 RQE Error x%x, posted %d err_cnt "
+					"%d: %x %x %x\n",
+					status, hrq->RQ_buf_posted,
+					hrq->RQ_no_posted_buf,
+					atomic_read(&tgtp->rcv_fcp_cmd_in),
+					atomic_read(&tgtp->rcv_fcp_cmd_out),
+					atomic_read(&tgtp->xmt_fcp_release));
+		}
+		/* fallthrough */
+
+	case FC_STATUS_INSUFF_BUF_NEED_BUF:
 		hrq->RQ_no_posted_buf++;
 		/* Post more buffers if possible */
 		spin_lock_irqsave(&phba->hbalock, iflags);
@@ -12951,7 +13041,7 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 		while ((cqe = lpfc_sli4_cq_get(cq))) {
 			workposted |= lpfc_sli4_sp_handle_mcqe(phba, cqe);
 			if (!(++ecount % cq->entry_repost))
-				lpfc_sli4_cq_release(cq, LPFC_QUEUE_NOARM);
+				break;
 			cq->CQ_mbox++;
 		}
 		break;
@@ -12965,7 +13055,7 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 				workposted |= lpfc_sli4_sp_handle_cqe(phba, cq,
 								      cqe);
 			if (!(++ecount % cq->entry_repost))
-				lpfc_sli4_cq_release(cq, LPFC_QUEUE_NOARM);
+				break;
 		}
 
 		/* Track the max number of CQEs processed in 1 EQ */
@@ -13135,6 +13225,7 @@ lpfc_sli4_nvmet_handle_rcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	struct lpfc_queue *drq;
 	struct rqb_dmabuf *dma_buf;
 	struct fc_frame_header *fc_hdr;
+	struct lpfc_nvmet_tgtport *tgtp;
 	uint32_t status, rq_id;
 	unsigned long iflags;
 	uint32_t fctl, idx;
@@ -13165,8 +13256,6 @@ lpfc_sli4_nvmet_handle_rcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	case FC_STATUS_RQ_BUF_LEN_EXCEEDED:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"6126 Receive Frame Truncated!!\n");
-		hrq->RQ_buf_trunc++;
-		break;
 	case FC_STATUS_RQ_SUCCESS:
 		lpfc_sli4_rq_release(hrq, drq);
 		spin_lock_irqsave(&phba->hbalock, iflags);
@@ -13178,6 +13267,7 @@ lpfc_sli4_nvmet_handle_rcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 		}
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 		hrq->RQ_rcv_buf++;
+		hrq->RQ_buf_posted--;
 		fc_hdr = (struct fc_frame_header *)dma_buf->hbuf.virt;
 
 		/* Just some basic sanity checks on FCP Command frame */
@@ -13200,14 +13290,23 @@ lpfc_sli4_nvmet_handle_rcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 drop:
 		lpfc_in_buf_free(phba, &dma_buf->dbuf);
 		break;
-	case FC_STATUS_INSUFF_BUF_NEED_BUF:
 	case FC_STATUS_INSUFF_BUF_FRM_DISC:
+		if (phba->nvmet_support) {
+			tgtp = phba->targetport->private;
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI | LOG_NVME,
+					"6401 RQE Error x%x, posted %d err_cnt "
+					"%d: %x %x %x\n",
+					status, hrq->RQ_buf_posted,
+					hrq->RQ_no_posted_buf,
+					atomic_read(&tgtp->rcv_fcp_cmd_in),
+					atomic_read(&tgtp->rcv_fcp_cmd_out),
+					atomic_read(&tgtp->xmt_fcp_release));
+		}
+		/* fallthrough */
+
+	case FC_STATUS_INSUFF_BUF_NEED_BUF:
 		hrq->RQ_no_posted_buf++;
 		/* Post more buffers if possible */
-		spin_lock_irqsave(&phba->hbalock, iflags);
-		phba->hba_flag |= HBA_POST_RECEIVE_BUFFER;
-		spin_unlock_irqrestore(&phba->hbalock, iflags);
-		workposted = true;
 		break;
 	}
 out:
@@ -13361,7 +13460,7 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 	while ((cqe = lpfc_sli4_cq_get(cq))) {
 		workposted |= lpfc_sli4_fp_handle_cqe(phba, cq, cqe);
 		if (!(++ecount % cq->entry_repost))
-			lpfc_sli4_cq_release(cq, LPFC_QUEUE_NOARM);
+			break;
 	}
 
 	/* Track the max number of CQEs processed in 1 EQ */
@@ -13452,7 +13551,7 @@ lpfc_sli4_fof_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe)
 	while ((cqe = lpfc_sli4_cq_get(cq))) {
 		workposted |= lpfc_sli4_fp_handle_cqe(phba, cq, cqe);
 		if (!(++ecount % cq->entry_repost))
-			lpfc_sli4_cq_release(cq, LPFC_QUEUE_NOARM);
+			break;
 	}
 
 	/* Track the max number of CQEs processed in 1 EQ */
@@ -13534,7 +13633,7 @@ lpfc_sli4_fof_intr_handler(int irq, void *dev_id)
 	while ((eqe = lpfc_sli4_eq_get(eq))) {
 		lpfc_sli4_fof_handle_eqe(phba, eqe);
 		if (!(++ecount % eq->entry_repost))
-			lpfc_sli4_eq_release(eq, LPFC_QUEUE_NOARM);
+			break;
 		eq->EQ_processed++;
 	}
 
@@ -13651,7 +13750,7 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 
 		lpfc_sli4_hba_handle_eqe(phba, eqe, hba_eqidx);
 		if (!(++ecount % fpeq->entry_repost))
-			lpfc_sli4_eq_release(fpeq, LPFC_QUEUE_NOARM);
+			break;
 		fpeq->EQ_processed++;
 	}
 
@@ -13832,17 +13931,10 @@ lpfc_sli4_queue_alloc(struct lpfc_hba *phba, uint32_t entry_size,
 	}
 	queue->entry_size = entry_size;
 	queue->entry_count = entry_count;
-
-	/*
-	 * entry_repost is calculated based on the number of entries in the
-	 * queue. This works out except for RQs. If buffers are NOT initially
-	 * posted for every RQE, entry_repost should be adjusted accordingly.
-	 */
-	queue->entry_repost = (entry_count >> 3);
-	if (queue->entry_repost < LPFC_QUEUE_MIN_REPOST)
-		queue->entry_repost = LPFC_QUEUE_MIN_REPOST;
 	queue->phba = phba;
 
+	/* entry_repost will be set during q creation */
+
 	return queue;
 out_fail:
 	lpfc_sli4_queue_free(queue);
@@ -14073,6 +14165,7 @@ lpfc_eq_create(struct lpfc_hba *phba, struct lpfc_queue *eq, uint32_t imax)
 		status = -ENXIO;
 	eq->host_index = 0;
 	eq->hba_index = 0;
+	eq->entry_repost = LPFC_EQ_REPOST;
 
 	mempool_free(mbox, phba->mbox_mem_pool);
 	return status;
@@ -14146,9 +14239,9 @@ lpfc_cq_create(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"0361 Unsupported CQ count: "
-				"entry cnt %d sz %d pg cnt %d repost %d\n",
+				"entry cnt %d sz %d pg cnt %d\n",
 				cq->entry_count, cq->entry_size,
-				cq->page_count, cq->entry_repost);
+				cq->page_count);
 		if (cq->entry_count < 256) {
 			status = -EINVAL;
 			goto out;
@@ -14201,6 +14294,7 @@ lpfc_cq_create(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	cq->assoc_qid = eq->queue_id;
 	cq->host_index = 0;
 	cq->hba_index = 0;
+	cq->entry_repost = LPFC_CQ_REPOST;
 
 out:
 	mempool_free(mbox, phba->mbox_mem_pool);
@@ -14392,6 +14486,7 @@ lpfc_cq_create_set(struct lpfc_hba *phba, struct lpfc_queue **cqp,
 		cq->assoc_qid = eq->queue_id;
 		cq->host_index = 0;
 		cq->hba_index = 0;
+		cq->entry_repost = LPFC_CQ_REPOST;
 
 		rc = 0;
 		list_for_each_entry(dmabuf, &cq->page_list, list) {
@@ -14640,6 +14735,7 @@ lpfc_mq_create(struct lpfc_hba *phba, struct lpfc_queue *mq,
 	mq->subtype = subtype;
 	mq->host_index = 0;
 	mq->hba_index = 0;
+	mq->entry_repost = LPFC_MQ_REPOST;
 
 	/* link the mq onto the parent cq child list */
 	list_add_tail(&mq->list, &cq->child_list);
@@ -14865,34 +14961,6 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 }
 
 /**
- * lpfc_rq_adjust_repost - Adjust entry_repost for an RQ
- * @phba: HBA structure that indicates port to create a queue on.
- * @rq:   The queue structure to use for the receive queue.
- * @qno:  The associated HBQ number
- *
- *
- * For SLI4 we need to adjust the RQ repost value based on
- * the number of buffers that are initially posted to the RQ.
- */
-void
-lpfc_rq_adjust_repost(struct lpfc_hba *phba, struct lpfc_queue *rq, int qno)
-{
-	uint32_t cnt;
-
-	/* sanity check on queue memory */
-	if (!rq)
-		return;
-	cnt = lpfc_hbq_defs[qno]->entry_count;
-
-	/* Recalc repost for RQs based on buffers initially posted */
-	cnt = (cnt >> 3);
-	if (cnt < LPFC_QUEUE_MIN_REPOST)
-		cnt = LPFC_QUEUE_MIN_REPOST;
-
-	rq->entry_repost = cnt;
-}
-
-/**
  * lpfc_rq_create - Create a Receive Queue on the HBA
  * @phba: HBA structure that indicates port to create a queue on.
  * @hrq: The queue structure to use to create the header receive queue.
@@ -15077,6 +15145,7 @@ lpfc_rq_create(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 	hrq->subtype = subtype;
 	hrq->host_index = 0;
 	hrq->hba_index = 0;
+	hrq->entry_repost = LPFC_RQ_REPOST;
 
 	/* now create the data queue */
 	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
@@ -15087,7 +15156,12 @@ lpfc_rq_create(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 	if (phba->sli4_hba.pc_sli4_params.rqv == LPFC_Q_CREATE_VERSION_1) {
 		bf_set(lpfc_rq_context_rqe_count_1,
 		       &rq_create->u.request.context, hrq->entry_count);
-		rq_create->u.request.context.buffer_size = LPFC_DATA_BUF_SIZE;
+		if (subtype == LPFC_NVMET)
+			rq_create->u.request.context.buffer_size =
+				LPFC_NVMET_DATA_BUF_SIZE;
+		else
+			rq_create->u.request.context.buffer_size =
+				LPFC_DATA_BUF_SIZE;
 		bf_set(lpfc_rq_context_rqe_size, &rq_create->u.request.context,
 		       LPFC_RQE_SIZE_8);
 		bf_set(lpfc_rq_context_page_size, &rq_create->u.request.context,
@@ -15124,8 +15198,14 @@ lpfc_rq_create(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 			       LPFC_RQ_RING_SIZE_4096);
 			break;
 		}
-		bf_set(lpfc_rq_context_buf_size, &rq_create->u.request.context,
-		       LPFC_DATA_BUF_SIZE);
+		if (subtype == LPFC_NVMET)
+			bf_set(lpfc_rq_context_buf_size,
+			       &rq_create->u.request.context,
+			       LPFC_NVMET_DATA_BUF_SIZE);
+		else
+			bf_set(lpfc_rq_context_buf_size,
+			       &rq_create->u.request.context,
+			       LPFC_DATA_BUF_SIZE);
 	}
 	bf_set(lpfc_rq_context_cq_id, &rq_create->u.request.context,
 	       cq->queue_id);
@@ -15158,6 +15238,7 @@ lpfc_rq_create(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 	drq->subtype = subtype;
 	drq->host_index = 0;
 	drq->hba_index = 0;
+	drq->entry_repost = LPFC_RQ_REPOST;
 
 	/* link the header and data RQs onto the parent cq child list */
 	list_add_tail(&hrq->list, &cq->child_list);
@@ -15270,7 +15351,7 @@ lpfc_mrq_create(struct lpfc_hba *phba, struct lpfc_queue **hrqp,
 			       cq->queue_id);
 			bf_set(lpfc_rq_context_data_size,
 			       &rq_create->u.request.context,
-			       LPFC_DATA_BUF_SIZE);
+			       LPFC_NVMET_DATA_BUF_SIZE);
 			bf_set(lpfc_rq_context_hdr_size,
 			       &rq_create->u.request.context,
 			       LPFC_HDR_BUF_SIZE);
@@ -15315,6 +15396,7 @@ lpfc_mrq_create(struct lpfc_hba *phba, struct lpfc_queue **hrqp,
 		hrq->subtype = subtype;
 		hrq->host_index = 0;
 		hrq->hba_index = 0;
+		hrq->entry_repost = LPFC_RQ_REPOST;
 
 		drq->db_format = LPFC_DB_RING_FORMAT;
 		drq->db_regaddr = phba->sli4_hba.RQDBregaddr;
@@ -15323,6 +15405,7 @@ lpfc_mrq_create(struct lpfc_hba *phba, struct lpfc_queue **hrqp,
 		drq->subtype = subtype;
 		drq->host_index = 0;
 		drq->hba_index = 0;
+		drq->entry_repost = LPFC_RQ_REPOST;
 
 		list_add_tail(&hrq->list, &cq->child_list);
 		list_add_tail(&drq->list, &cq->child_list);
@@ -16063,6 +16146,8 @@ lpfc_fc_frame_check(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr)
 	struct fc_vft_header *fc_vft_hdr;
 	uint32_t *header = (uint32_t *) fc_hdr;
 
+#define FC_RCTL_MDS_DIAGS	0xF4
+
 	switch (fc_hdr->fh_r_ctl) {
 	case FC_RCTL_DD_UNCAT:		/* uncategorized information */
 	case FC_RCTL_DD_SOL_DATA:	/* solicited data */
@@ -16090,6 +16175,7 @@ lpfc_fc_frame_check(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr)
 	case FC_RCTL_F_BSY:	/* fabric busy to data frame */
 	case FC_RCTL_F_BSYL:	/* fabric busy to link control frame */
 	case FC_RCTL_LCR:	/* link credit reset */
+	case FC_RCTL_MDS_DIAGS: /* MDS Diagnostics */
 	case FC_RCTL_END:	/* end */
 		break;
 	case FC_RCTL_VFTH:	/* Virtual Fabric tagging Header */
@@ -16099,12 +16185,16 @@ lpfc_fc_frame_check(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr)
 	default:
 		goto drop;
 	}
+
+#define FC_TYPE_VENDOR_UNIQUE	0xFF
+
 	switch (fc_hdr->fh_type) {
 	case FC_TYPE_BLS:
 	case FC_TYPE_ELS:
 	case FC_TYPE_FCP:
 	case FC_TYPE_CT:
 	case FC_TYPE_NVME:
+	case FC_TYPE_VENDOR_UNIQUE:
 		break;
 	case FC_TYPE_IP:
 	case FC_TYPE_ILS:
@@ -16115,12 +16205,14 @@ lpfc_fc_frame_check(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr)
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
 			"2538 Received frame rctl:%s (x%x), type:%s (x%x), "
 			"frame Data:%08x %08x %08x %08x %08x %08x %08x\n",
+			(fc_hdr->fh_r_ctl == FC_RCTL_MDS_DIAGS) ? "MDS Diags" :
 			lpfc_rctl_names[fc_hdr->fh_r_ctl], fc_hdr->fh_r_ctl,
-			lpfc_type_names[fc_hdr->fh_type], fc_hdr->fh_type,
-			be32_to_cpu(header[0]), be32_to_cpu(header[1]),
-			be32_to_cpu(header[2]), be32_to_cpu(header[3]),
-			be32_to_cpu(header[4]), be32_to_cpu(header[5]),
-			be32_to_cpu(header[6]));
+			(fc_hdr->fh_type == FC_TYPE_VENDOR_UNIQUE) ?
+			"Vendor Unique" : lpfc_type_names[fc_hdr->fh_type],
+			fc_hdr->fh_type, be32_to_cpu(header[0]),
+			be32_to_cpu(header[1]), be32_to_cpu(header[2]),
+			be32_to_cpu(header[3]), be32_to_cpu(header[4]),
+			be32_to_cpu(header[5]), be32_to_cpu(header[6]));
 	return 0;
 drop:
 	lpfc_printf_log(phba, KERN_WARNING, LOG_ELS,
@@ -16926,6 +17018,96 @@ lpfc_sli4_send_seq_to_ulp(struct lpfc_vport *vport,
 	lpfc_sli_release_iocbq(phba, iocbq);
 }
 
+static void
+lpfc_sli4_mds_loopback_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
+			    struct lpfc_iocbq *rspiocb)
+{
+	struct lpfc_dmabuf *pcmd = cmdiocb->context2;
+
+	if (pcmd && pcmd->virt)
+		pci_pool_free(phba->lpfc_drb_pool, pcmd->virt, pcmd->phys);
+	kfree(pcmd);
+	lpfc_sli_release_iocbq(phba, cmdiocb);
+}
+
+static void
+lpfc_sli4_handle_mds_loopback(struct lpfc_vport *vport,
+			      struct hbq_dmabuf *dmabuf)
+{
+	struct fc_frame_header *fc_hdr;
+	struct lpfc_hba *phba = vport->phba;
+	struct lpfc_iocbq *iocbq = NULL;
+	union  lpfc_wqe *wqe;
+	struct lpfc_dmabuf *pcmd = NULL;
+	uint32_t frame_len;
+	int rc;
+
+	fc_hdr = (struct fc_frame_header *)dmabuf->hbuf.virt;
+	frame_len = bf_get(lpfc_rcqe_length, &dmabuf->cq_event.cqe.rcqe_cmpl);
+
+	/* Send the received frame back */
+	iocbq = lpfc_sli_get_iocbq(phba);
+	if (!iocbq)
+		goto exit;
+
+	/* Allocate buffer for command payload */
+	pcmd = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+	if (pcmd)
+		pcmd->virt = pci_pool_alloc(phba->lpfc_drb_pool, GFP_KERNEL,
+					    &pcmd->phys);
+	if (!pcmd || !pcmd->virt)
+		goto exit;
+
+	INIT_LIST_HEAD(&pcmd->list);
+
+	/* copyin the payload */
+	memcpy(pcmd->virt, dmabuf->dbuf.virt, frame_len);
+
+	/* fill in BDE's for command */
+	iocbq->iocb.un.xseq64.bdl.addrHigh = putPaddrHigh(pcmd->phys);
+	iocbq->iocb.un.xseq64.bdl.addrLow = putPaddrLow(pcmd->phys);
+	iocbq->iocb.un.xseq64.bdl.bdeFlags = BUFF_TYPE_BDE_64;
+	iocbq->iocb.un.xseq64.bdl.bdeSize = frame_len;
+
+	iocbq->context2 = pcmd;
+	iocbq->vport = vport;
+	iocbq->iocb_flag &= ~LPFC_FIP_ELS_ID_MASK;
+	iocbq->iocb_flag |= LPFC_USE_FCPWQIDX;
+
+	/*
+	 * Setup rest of the iocb as though it were a WQE
+	 * Build the SEND_FRAME WQE
+	 */
+	wqe = (union lpfc_wqe *)&iocbq->iocb;
+
+	wqe->send_frame.frame_len = frame_len;
+	wqe->send_frame.fc_hdr_wd0 = be32_to_cpu(*((uint32_t *)fc_hdr));
+	wqe->send_frame.fc_hdr_wd1 = be32_to_cpu(*((uint32_t *)fc_hdr + 1));
+	wqe->send_frame.fc_hdr_wd2 = be32_to_cpu(*((uint32_t *)fc_hdr + 2));
+	wqe->send_frame.fc_hdr_wd3 = be32_to_cpu(*((uint32_t *)fc_hdr + 3));
+	wqe->send_frame.fc_hdr_wd4 = be32_to_cpu(*((uint32_t *)fc_hdr + 4));
+	wqe->send_frame.fc_hdr_wd5 = be32_to_cpu(*((uint32_t *)fc_hdr + 5));
+
+	iocbq->iocb.ulpCommand = CMD_SEND_FRAME;
+	iocbq->iocb.ulpLe = 1;
+	iocbq->iocb_cmpl = lpfc_sli4_mds_loopback_cmpl;
+	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, iocbq, 0);
+	if (rc == IOCB_ERROR)
+		goto exit;
+
+	lpfc_in_buf_free(phba, &dmabuf->dbuf);
+	return;
+
+exit:
+	lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+			"2023 Unable to process MDS loopback frame\n");
+	if (pcmd && pcmd->virt)
+		pci_pool_free(phba->lpfc_drb_pool, pcmd->virt, pcmd->phys);
+	kfree(pcmd);
+	lpfc_sli_release_iocbq(phba, iocbq);
+	lpfc_in_buf_free(phba, &dmabuf->dbuf);
+}
+
 /**
  * lpfc_sli4_handle_received_buffer - Handle received buffers from firmware
  * @phba: Pointer to HBA context object.
@@ -16964,6 +17146,13 @@ lpfc_sli4_handle_received_buffer(struct lpfc_hba *phba,
 		fcfi = bf_get(lpfc_rcqe_fcf_id,
 			      &dmabuf->cq_event.cqe.rcqe_cmpl);
 
+	if (fc_hdr->fh_r_ctl == 0xF4 && fc_hdr->fh_type == 0xFF) {
+		vport = phba->pport;
+		/* Handle MDS Loopback frames */
+		lpfc_sli4_handle_mds_loopback(vport, dmabuf);
+		return;
+	}
+
 	/* d_id this frame is directed to */
 	did = sli4_did_from_fc_hdr(fc_hdr);
 
@@ -17137,6 +17326,14 @@ lpfc_sli4_post_rpi_hdr(struct lpfc_hba *phba, struct lpfc_rpi_hdr *rpi_page)
 				"status x%x add_status x%x, mbx status x%x\n",
 				shdr_status, shdr_add_status, rc);
 		rc = -ENXIO;
+	} else {
+		/*
+		 * The next_rpi stores the next logical module-64 rpi value used
+		 * to post physical rpis in subsequent rpi postings.
+		 */
+		spin_lock_irq(&phba->hbalock);
+		phba->sli4_hba.next_rpi = rpi_page->next_rpi;
+		spin_unlock_irq(&phba->hbalock);
 	}
 	return rc;
 }
@@ -18717,7 +18914,7 @@ lpfc_sli4_issue_wqe(struct lpfc_hba *phba, uint32_t ring_number,
 
 		spin_lock_irqsave(&pring->ring_lock, iflags);
 		ctxp = pwqe->context2;
-		sglq = ctxp->rqb_buffer->sglq;
+		sglq = ctxp->ctxbuf->sglq;
 		if (pwqe->sli4_xritag ==  NO_XRI) {
 			pwqe->sli4_lxritag = sglq->sli4_lxritag;
 			pwqe->sli4_xritag = sglq->sli4_xritag;
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index da46471337c8..cf863db27700 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -24,7 +24,6 @@
 #define LPFC_XRI_EXCH_BUSY_WAIT_TMO		10000
 #define LPFC_XRI_EXCH_BUSY_WAIT_T1   		10
 #define LPFC_XRI_EXCH_BUSY_WAIT_T2              30000
-#define LPFC_RELEASE_NOTIFICATION_INTERVAL	32
 #define LPFC_RPI_LOW_WATER_MARK			10
 
 #define LPFC_UNREG_FCF                          1
@@ -155,7 +154,11 @@ struct lpfc_queue {
 	uint32_t entry_count;	/* Number of entries to support on the queue */
 	uint32_t entry_size;	/* Size of each queue entry. */
 	uint32_t entry_repost;	/* Count of entries before doorbell is rung */
-#define LPFC_QUEUE_MIN_REPOST	8
+#define LPFC_EQ_REPOST		8
+#define LPFC_MQ_REPOST		8
+#define LPFC_CQ_REPOST		64
+#define LPFC_RQ_REPOST		64
+#define LPFC_RELEASE_NOTIFICATION_INTERVAL	32  /* For WQs */
 	uint32_t queue_id;	/* Queue ID assigned by the hardware */
 	uint32_t assoc_qid;     /* Queue ID associated with, for CQ/WQ/MQ */
 	uint32_t page_count;	/* Number of pages allocated for this queue */
@@ -195,7 +198,7 @@ struct lpfc_queue {
 /* defines for RQ stats */
 #define	RQ_no_posted_buf	q_cnt_1
 #define	RQ_no_buf_found		q_cnt_2
-#define	RQ_buf_trunc		q_cnt_3
+#define	RQ_buf_posted		q_cnt_3
 #define	RQ_rcv_buf		q_cnt_4
 
 	uint64_t isr_timestamp;
@@ -617,12 +620,17 @@ struct lpfc_sli4_hba {
 	uint16_t scsi_xri_start;
 	uint16_t els_xri_cnt;
 	uint16_t nvmet_xri_cnt;
+	uint16_t nvmet_ctx_cnt;
+	uint16_t nvmet_io_wait_cnt;
+	uint16_t nvmet_io_wait_total;
 	struct list_head lpfc_els_sgl_list;
 	struct list_head lpfc_abts_els_sgl_list;
 	struct list_head lpfc_nvmet_sgl_list;
 	struct list_head lpfc_abts_nvmet_ctx_list;
 	struct list_head lpfc_abts_scsi_buf_list;
 	struct list_head lpfc_abts_nvme_buf_list;
+	struct list_head lpfc_nvmet_ctx_list;
+	struct list_head lpfc_nvmet_io_wait_list;
 	struct lpfc_sglq **lpfc_sglq_active_list;
 	struct list_head lpfc_rpi_hdr_list;
 	unsigned long *rpi_bmask;
@@ -654,6 +662,7 @@ struct lpfc_sli4_hba {
 	spinlock_t abts_scsi_buf_list_lock; /* list of aborted SCSI IOs */
 	spinlock_t sgl_list_lock; /* list of aborted els IOs */
 	spinlock_t nvmet_io_lock;
+	spinlock_t nvmet_io_wait_lock; /* IOs waiting for ctx resources */
 	uint32_t physical_port;
 
 	/* CPU to vector mapping information */
@@ -661,8 +670,6 @@ struct lpfc_sli4_hba {
 	uint16_t num_online_cpu;
 	uint16_t num_present_cpu;
 	uint16_t curr_disp_cpu;
-
-	uint16_t nvmet_mrq_post_idx;
 };
 
 enum lpfc_sge_type {
@@ -698,6 +705,7 @@ struct lpfc_rpi_hdr {
 	struct lpfc_dmabuf *dmabuf;
 	uint32_t page_count;
 	uint32_t start_rpi;
+	uint16_t next_rpi;
 };
 
 struct lpfc_rsrc_blks {
@@ -762,7 +770,6 @@ int lpfc_rq_create(struct lpfc_hba *, struct lpfc_queue *,
 int lpfc_mrq_create(struct lpfc_hba *phba, struct lpfc_queue **hrqp,
 			struct lpfc_queue **drqp, struct lpfc_queue **cqp,
 			uint32_t subtype);
-void lpfc_rq_adjust_repost(struct lpfc_hba *, struct lpfc_queue *, int);
 int lpfc_eq_destroy(struct lpfc_hba *, struct lpfc_queue *);
 int lpfc_cq_destroy(struct lpfc_hba *, struct lpfc_queue *);
 int lpfc_mq_destroy(struct lpfc_hba *, struct lpfc_queue *);
diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 1c26dc67151b..c2653244221c 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "11.2.0.12"
+#define LPFC_DRIVER_VERSION "11.2.0.14"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e31f1cc90b81..99e16ac479e3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1851,7 +1851,7 @@ static int scsi_mq_prep_fn(struct request *req)
 
 	/* zero out the cmd, except for the embedded scsi_request */
 	memset((char *)cmd + sizeof(cmd->req), 0,
-		sizeof(*cmd) - sizeof(cmd->req));
+		sizeof(*cmd) - sizeof(cmd->req) + shost->hostt->cmd_size);
 
 	req->special = cmd;
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f9d1432d7cc5..b6bb4e0ce0e3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -827,21 +827,32 @@ static int sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	u64 sector = blk_rq_pos(rq) >> (ilog2(sdp->sector_size) - 9);
 	u32 nr_sectors = blk_rq_sectors(rq) >> (ilog2(sdp->sector_size) - 9);
+	int ret;
 
 	if (!(rq->cmd_flags & REQ_NOUNMAP)) {
 		switch (sdkp->zeroing_mode) {
 		case SD_ZERO_WS16_UNMAP:
-			return sd_setup_write_same16_cmnd(cmd, true);
+			ret = sd_setup_write_same16_cmnd(cmd, true);
+			goto out;
 		case SD_ZERO_WS10_UNMAP:
-			return sd_setup_write_same10_cmnd(cmd, true);
+			ret = sd_setup_write_same10_cmnd(cmd, true);
+			goto out;
 		}
 	}
 
 	if (sdp->no_write_same)
 		return BLKPREP_INVALID;
+
 	if (sdkp->ws16 || sector > 0xffffffff || nr_sectors > 0xffff)
-		return sd_setup_write_same16_cmnd(cmd, false);
-	return sd_setup_write_same10_cmnd(cmd, false);
+		ret = sd_setup_write_same16_cmnd(cmd, false);
+	else
+		ret = sd_setup_write_same10_cmnd(cmd, false);
+
+out:
+	if (sd_is_zoned(sdkp) && ret == BLKPREP_OK)
+		return sd_zbc_write_lock_zone(cmd);
+
+	return ret;
 }
 
 static void sd_config_write_same(struct scsi_disk *sdkp)
@@ -948,6 +959,10 @@ static int sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 	rq->__data_len = sdp->sector_size;
 	ret = scsi_init_io(cmd);
 	rq->__data_len = nr_bytes;
+
+	if (sd_is_zoned(sdkp) && ret != BLKPREP_OK)
+		sd_zbc_write_unlock_zone(cmd);
+
 	return ret;
 }
 
@@ -1567,17 +1582,21 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 	return retval;
 }
 
-static int sd_sync_cache(struct scsi_disk *sdkp)
+static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 {
 	int retries, res;
 	struct scsi_device *sdp = sdkp->device;
 	const int timeout = sdp->request_queue->rq_timeout
 		* SD_FLUSH_TIMEOUT_MULTIPLIER;
-	struct scsi_sense_hdr sshdr;
+	struct scsi_sense_hdr my_sshdr;
 
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
+	/* caller might not be interested in sense, but we need it */
+	if (!sshdr)
+		sshdr = &my_sshdr;
+
 	for (retries = 3; retries > 0; --retries) {
 		unsigned char cmd[10] = { 0 };
 
@@ -1586,7 +1605,7 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 		 * Leave the rest of the command zero to indicate
 		 * flush everything.
 		 */
-		res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
+		res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, sshdr,
 				timeout, SD_MAX_RETRIES, 0, RQF_PM, NULL);
 		if (res == 0)
 			break;
@@ -1596,11 +1615,12 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 		sd_print_result(sdkp, "Synchronize Cache(10) failed", res);
 
 		if (driver_byte(res) & DRIVER_SENSE)
-			sd_print_sense_hdr(sdkp, &sshdr);
+			sd_print_sense_hdr(sdkp, sshdr);
+
 		/* we need to evaluate the error return  */
-		if (scsi_sense_valid(&sshdr) &&
-			(sshdr.asc == 0x3a ||	/* medium not present */
-			 sshdr.asc == 0x20))	/* invalid command */
+		if (scsi_sense_valid(sshdr) &&
+			(sshdr->asc == 0x3a ||	/* medium not present */
+			 sshdr->asc == 0x20))	/* invalid command */
 				/* this is no error here */
 				return 0;
 
@@ -3444,7 +3464,7 @@ static void sd_shutdown(struct device *dev)
 
 	if (sdkp->WCE && sdkp->media_present) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
-		sd_sync_cache(sdkp);
+		sd_sync_cache(sdkp, NULL);
 	}
 
 	if (system_state != SYSTEM_RESTART && sdkp->device->manage_start_stop) {
@@ -3456,6 +3476,7 @@ static void sd_shutdown(struct device *dev)
 static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+	struct scsi_sense_hdr sshdr;
 	int ret = 0;
 
 	if (!sdkp)	/* E.g.: runtime suspend following sd_remove() */
@@ -3463,12 +3484,23 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 
 	if (sdkp->WCE && sdkp->media_present) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
-		ret = sd_sync_cache(sdkp);
+		ret = sd_sync_cache(sdkp, &sshdr);
+
 		if (ret) {
 			/* ignore OFFLINE device */
 			if (ret == -ENODEV)
-				ret = 0;
-			goto done;
+				return 0;
+
+			if (!scsi_sense_valid(&sshdr) ||
+			    sshdr.sense_key != ILLEGAL_REQUEST)
+				return ret;
+
+			/*
+			 * sshdr.sense_key == ILLEGAL_REQUEST means this drive
+			 * doesn't support sync. There's not much to do and
+			 * suspend shouldn't fail.
+			 */
+			 ret = 0;
 		}
 	}
 
@@ -3480,7 +3512,6 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 			ret = 0;
 	}
 
-done:
 	return ret;
 }
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 0a38ba01b7b4..82c33a6edbea 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2074,11 +2074,12 @@ sg_get_rq_mark(Sg_fd * sfp, int pack_id)
 		if ((1 == resp->done) && (!resp->sg_io_owned) &&
 		    ((-1 == pack_id) || (resp->header.pack_id == pack_id))) {
 			resp->done = 2;	/* guard against other readers */
-			break;
+			write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+			return resp;
 		}
 	}
 	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-	return resp;
+	return NULL;
 }
 
 /* always adds to end of list */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index abc7e87937cc..ffe8d8608818 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7698,6 +7698,12 @@ static inline void ufshcd_add_sysfs_nodes(struct ufs_hba *hba)
 	ufshcd_add_spm_lvl_sysfs_nodes(hba);
 }
 
+static inline void ufshcd_remove_sysfs_nodes(struct ufs_hba *hba)
+{
+	device_remove_file(hba->dev, &hba->rpm_lvl_attr);
+	device_remove_file(hba->dev, &hba->spm_lvl_attr);
+}
+
 /**
  * ufshcd_shutdown - shutdown routine
  * @hba: per adapter instance
@@ -7735,6 +7741,7 @@ EXPORT_SYMBOL(ufshcd_shutdown);
  */
 void ufshcd_remove(struct ufs_hba *hba)
 {
+	ufshcd_remove_sysfs_nodes(hba);
 	scsi_remove_host(hba->host);
 	/* disable interrupts */
 	ufshcd_disable_intr(hba, hba->intr_mask);
