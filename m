From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 3/3] nvme-fabrics: Add nvme target FC transport support to lpfc driver
Date: Fri, 22 Jul 2016 17:24:03 -0700
Message-ID: <5792b923.pApuw1ul3y5eJ/Vt%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35217 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbcGWAYH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2016 20:24:07 -0400
Received: by mail-pa0-f54.google.com with SMTP id iw10so43765181pac.2
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2016 17:24:06 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org


This patch updates the lpfc driver such that it ties into the NVME FC
transport to add target (nvme subsystem) support.
It currently is an unoptimized NVME implementation.

The patch:
-Updates the async RX path of the adapter to support reception
 of NVME commands
-Registers the local FC port with the NVME FC transport as a "targetport"
-Adds the lpfc_nvmet.c file which contains all the entrypoints to support
 the NVME FC transport target/subsystem interfaces. Handles the appropriate
 command requests with the adapter for target operation.
-Updates the revision of the driver to 11.2.0.1


Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/Makefile         |    2 +-
 drivers/scsi/lpfc/lpfc.h           |    6 +-
 drivers/scsi/lpfc/lpfc_crtn.h      |    8 +
 drivers/scsi/lpfc/lpfc_ct.c        |   10 +-
 drivers/scsi/lpfc/lpfc_debugfs.c   |  264 ++++++++
 drivers/scsi/lpfc/lpfc_els.c       |   14 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c   |    9 +
 drivers/scsi/lpfc/lpfc_init.c      |  159 ++++-
 drivers/scsi/lpfc/lpfc_mbox.c      |   10 +
 drivers/scsi/lpfc/lpfc_mem.c       |  110 +++-
 drivers/scsi/lpfc/lpfc_nportdisc.c |    4 +-
 drivers/scsi/lpfc/lpfc_nvmet.c     | 1269 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_nvmet.h     |   72 ++
 drivers/scsi/lpfc/lpfc_sli.c       |  181 ++++-
 drivers/scsi/lpfc/lpfc_sli4.h      |    3 +
 drivers/scsi/lpfc/lpfc_version.h   |    2 +-
 16 files changed, 2100 insertions(+), 23 deletions(-)
 create mode 100644 drivers/scsi/lpfc/lpfc_nvmet.c
 create mode 100644 drivers/scsi/lpfc/lpfc_nvmet.h

diff --git a/drivers/scsi/lpfc/Makefile b/drivers/scsi/lpfc/Makefile
index cd7e1fc..30a6a35 100644
--- a/drivers/scsi/lpfc/Makefile
+++ b/drivers/scsi/lpfc/Makefile
@@ -31,4 +31,4 @@ obj-$(CONFIG_SCSI_LPFC) := lpfc.o
 lpfc-objs := lpfc_mem.o lpfc_sli.o lpfc_ct.o lpfc_els.o \
 	lpfc_hbadisc.o	lpfc_init.o lpfc_mbox.o lpfc_nportdisc.o   \
 	lpfc_scsi.o lpfc_attr.o lpfc_vport.o lpfc_debugfs.o lpfc_bsg.o \
-	lpfc_nvme.o
+	lpfc_nvme.o lpfc_nvmet.o
diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 22dcb39..3f79fc1 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -444,6 +444,7 @@ struct lpfc_vport {
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	struct dentry *debug_disc_trc;
 	struct dentry *debug_nodelist;
+	struct dentry *debug_nvmestat;
 	struct dentry *vport_debugfs_root;
 	struct lpfc_debugfs_trc *disc_trc;
 	atomic_t disc_trc_cnt;
@@ -481,7 +482,8 @@ struct hbq_s {
 
 /* this matches the position in the lpfc_hbq_defs array */
 #define LPFC_ELS_HBQ	0
-#define LPFC_MAX_HBQS	1
+#define LPFC_NVMET_HBQ	1
+#define LPFC_MAX_HBQS	2
 
 enum hba_temp_state {
 	HBA_NORMAL_TEMP,
@@ -795,6 +797,7 @@ struct lpfc_hba {
 #define LPFC_ENABLE_NVME 2
 #define LPFC_ENABLE_BOTH 3
 	uint32_t io_channel;	/* max of fcp or nvme io channels */
+	struct nvmet_fc_target_port *targetport;
 	lpfc_vpd_t vpd;		/* vital product data */
 
 	struct pci_dev *pcidev;
@@ -891,6 +894,7 @@ struct lpfc_hba {
 	struct pci_pool *lpfc_hrb_pool;	/* header receive buffer pool */
 	struct pci_pool *lpfc_drb_pool; /* data receive buffer pool */
 	struct pci_pool *lpfc_hbq_pool;	/* SLI3 hbq buffer pool */
+	struct pci_pool *txrdy_payload_pool;
 	struct lpfc_dma_pool lpfc_mbuf_safety_pool;
 
 	mempool_t *mbox_mem_pool;
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index ab2b4eb..141b23f 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -234,6 +234,8 @@ struct hbq_dmabuf *lpfc_els_hbq_alloc(struct lpfc_hba *);
 void lpfc_els_hbq_free(struct lpfc_hba *, struct hbq_dmabuf *);
 struct hbq_dmabuf *lpfc_sli4_rb_alloc(struct lpfc_hba *);
 void lpfc_sli4_rb_free(struct lpfc_hba *, struct hbq_dmabuf *);
+struct hbq_dmabuf *lpfc_sli4_nvmet_alloc(struct lpfc_hba *);
+void lpfc_sli4_nvmet_free(struct lpfc_hba *, struct hbq_dmabuf *);
 void lpfc_sli4_build_dflt_fcf_record(struct lpfc_hba *, struct fcf_record *,
 			uint16_t);
 void lpfc_unregister_fcf(struct lpfc_hba *);
@@ -517,3 +519,9 @@ struct lpfc_scsi_buf *lpfc_get_scsi_buf(struct lpfc_hba *,
 /* NVME interfaces. */
 int lpfc_create_nvme_lport(struct lpfc_vport *);
 void lpfc_destroy_nvme_lport(struct lpfc_nvme *);
+int lpfc_nvmet_create_targetport(struct lpfc_hba *);
+void lpfc_nvmet_destroy_targetport(struct lpfc_hba *);
+void lpfc_nvmet_unsol_ls_event(struct lpfc_hba *, struct lpfc_sli_ring *,
+				struct lpfc_iocbq *);
+void lpfc_nvmet_unsol_fcp_event(struct lpfc_hba *, struct lpfc_sli_ring *,
+			       struct hbq_dmabuf *);
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 3a43cdf..6004d4b 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1430,10 +1430,16 @@ lpfc_ns_cmd(struct lpfc_vport *vport, int cmdcode,
 		 */
 		if (((phba->cfg_enable_fc4_type == LPFC_ENABLE_BOTH) ||
 		     (phba->cfg_enable_fc4_type == LPFC_ENABLE_NVME)) &&
-		    (context == LPFC_FC4_TYPE_NVME))
+		    (context == LPFC_FC4_TYPE_NVME)) {
+			if ((vport == phba->pport) &&
+			    (phba->cfg_enable_nvmet == phba->brd_no)) {
+				CtReq->un.rff.fbits = (FC4_FEATURE_TARGET |
+					FC4_FEATURE_NVME_DISC);
+				lpfc_nvmet_create_targetport(phba);
+			}
 			CtReq->un.rff.type_code = context;
 
-		else if (((phba->cfg_enable_fc4_type == LPFC_ENABLE_BOTH) ||
+		} else if (((phba->cfg_enable_fc4_type == LPFC_ENABLE_BOTH) ||
 			    (phba->cfg_enable_fc4_type == LPFC_ENABLE_FCP)) &&
 			   (context == FC_TYPE_FCP))
 			CtReq->un.rff.type_code = context;
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index cd226cb..811be6c 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -45,6 +45,7 @@
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
 #include "lpfc_nvme.h"
+#include "lpfc_nvmet.h"
 #include "lpfc.h"
 #include "lpfc_logmsg.h"
 #include "lpfc_crtn.h"
@@ -533,10 +534,12 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 	int len = 0;
 	int cnt;
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+	struct lpfc_hba  *phba = vport->phba;
 	struct lpfc_nodelist *ndlp;
 	unsigned char *statep;
 	struct lpfc_nvme_lport *lport;
 	struct lpfc_nvme_rport *rport;
+	struct lpfc_nvmet_tgtport *tgtp;
 	struct nvme_fc_remote_port *nrport;
 	struct lpfc_nvme *pnvme;
 
@@ -616,6 +619,34 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 	}
 	spin_unlock_irq(shost->host_lock);
 
+	if ((phba->cfg_enable_nvmet == phba->brd_no) && phba->targetport) {
+		tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
+		len += snprintf(buf+len, size-len,
+				"\nNVME Targetport Entry ...\n");
+
+		/* Port state is only one of two values for now. */
+		switch (tgtp->nvmet_state) {
+		case LPFC_NVME_INIT:
+			statep = "INIT";
+			break;
+		case LPFC_NVME_REG:
+			statep = "REGISTERED";
+			break;
+		case LPFC_NVME_ERROR:
+			statep = "ERROR";
+			break;
+		default:
+			statep = "UNKNOWN ";
+			break;
+		}
+		len += snprintf(buf+len, size-len,
+				"Targetport DID x%06x, FabricName x%llx, "
+				"PortState %s\n",
+				phba->targetport->port_id,
+				phba->targetport->fabric_name,
+				statep);
+		goto out_exit;
+	}
 	/* Now step through the NVME ports. Reset cnt to prevent infinite
 	 * loops.
 	 */
@@ -709,6 +740,66 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 	return len;
 }
 
+/**
+ * lpfc_debugfs_nvmestat_data - Dump target node list to a buffer
+ * @vport: The vport to gather target node info from.
+ * @buf: The buffer to dump log into.
+ * @size: The maximum amount of data to process.
+ *
+ * Description:
+ * This routine dumps the NVME statistics associated with @vport
+ *
+ * Return Value:
+ * This routine returns the amount of bytes that were dumped into @buf and will
+ * not exceed @size.
+ **/
+static int
+lpfc_debugfs_nvmestat_data(struct lpfc_vport *vport, char *buf, int size)
+{
+	struct lpfc_hba   *phba = vport->phba;
+	struct lpfc_nvmet_tgtport *tgtp;
+	int len = 0;
+
+	if (phba->cfg_enable_nvmet == phba->brd_no) {
+		if (!phba->targetport)
+			return len;
+		tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
+		len += snprintf(buf+len, size-len,
+				"\nNVME Targetport Statistics\n");
+		len += snprintf(buf+len, size-len,
+				"LS: Rcv %08x Drop %08x "
+				"Xmt %08x Drop %08x Cmpl %08x Err %08x\n",
+				tgtp->rcv_ls_req,
+				tgtp->rcv_ls_drop,
+				tgtp->xmt_ls_rsp,
+				tgtp->xmt_ls_drop,
+				tgtp->xmt_ls_rsp_cmpl,
+				tgtp->xmt_ls_rsp_error);
+
+		len += snprintf(buf+len, size-len,
+				"FCP: Rcv %08x Drop %08x "
+				"Xmt %08x Drop %08x Cmpl %08x Err %08x\n",
+				tgtp->rcv_fcp_cmd,
+				tgtp->rcv_fcp_drop,
+				tgtp->xmt_fcp_rsp,
+				tgtp->xmt_fcp_drop,
+				tgtp->xmt_fcp_rsp_cmpl,
+				tgtp->xmt_fcp_rsp_error);
+
+		len += snprintf(buf+len, size-len,
+				"ABORT: Xmt %08x Cmpl %08x Err %08x",
+				tgtp->xmt_abort_rsp,
+				tgtp->xmt_abort_cmpl,
+				tgtp->xmt_abort_rsp_error);
+
+		len +=  snprintf(buf+len, size-len, "\n");
+	} else
+		len += snprintf(buf+len, size-len,
+				"\nNVME Lport Statistics\n");
+
+	return len;
+}
+
 #endif
 
 /**
@@ -1326,6 +1417,76 @@ lpfc_debugfs_dumpDataDif_release(struct inode *inode, struct file *file)
 }
 
 
+static int
+lpfc_debugfs_nvmestat_open(struct inode *inode, struct file *file)
+{
+	struct lpfc_vport *vport = inode->i_private;
+	struct lpfc_debug *debug;
+	int rc = -ENOMEM;
+
+	debug = kmalloc(sizeof(*debug), GFP_KERNEL);
+	if (!debug)
+		goto out;
+
+	 /* Round to page boundary */
+	debug->buffer = kmalloc(LPFC_NVMESTAT_SIZE, GFP_KERNEL);
+	if (!debug->buffer) {
+		kfree(debug);
+		goto out;
+	}
+
+	debug->len = lpfc_debugfs_nvmestat_data(vport, debug->buffer,
+		LPFC_NVMESTAT_SIZE);
+
+	debug->i_private = inode->i_private;
+	file->private_data = debug;
+
+	rc = 0;
+out:
+	return rc;
+}
+
+static ssize_t
+lpfc_debugfs_nvmestat_write(struct file *file, const char __user *buf,
+			    size_t nbytes, loff_t *ppos)
+{
+	struct lpfc_debug *debug = file->private_data;
+	struct lpfc_vport *vport = (struct lpfc_vport *)debug->i_private;
+	struct lpfc_hba   *phba = vport->phba;
+	struct lpfc_nvmet_tgtport *tgtp;
+	char mybuf[64];
+	char *pbuf;
+
+	if (!phba->targetport)
+		return -ENXIO;
+
+	if (nbytes > 64)
+		nbytes = 64;
+
+	/* Protect copy from user */
+	if (!access_ok(VERIFY_READ, buf, nbytes))
+		return -EFAULT;
+
+	memset(mybuf, 0, sizeof(mybuf));
+
+	if (copy_from_user(mybuf, buf, nbytes))
+		return -EFAULT;
+	pbuf = &mybuf[0];
+
+	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
+	if (strncmp(pbuf, "reset", strlen("reset")) == 0) {
+		tgtp->rcv_ls_req = 0;
+		tgtp->rcv_ls_drop = 0;
+		tgtp->xmt_ls_rsp = 0;
+		tgtp->xmt_ls_drop = 0;
+		tgtp->xmt_ls_rsp_error = 0;
+		tgtp->xmt_ls_rsp_cmpl = 0;
+
+		tgtp->rcv_fcp_drop = 0;
+		tgtp->rcv_fcp_cmd = 0;
+	}
+	return nbytes;
+}
 /*
  * ---------------------------------
  * iDiag debugfs file access methods
@@ -2472,6 +2633,84 @@ proc_cq:
 				len +=  snprintf(pbuffer+len,
 					LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
 			}
+
+			/* NVMET response CQ */
+			qp = phba->sli4_hba.nvmet_cq;
+			if (qp) {
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"\tNVMET CQ info: ");
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"AssocEQID[%02d]: "
+					"CQ-STAT[max:x%x relw:x%x "
+					"xabt:x%x wq:x%llx]\n",
+					qp->assoc_qid,
+					qp->q_cnt_1, qp->q_cnt_2,
+					qp->q_cnt_3,
+					(unsigned long long)qp->q_cnt_4);
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"\tCQID [%02d], "
+					"QE-CNT[%04d], QE-SIZE[%04d], "
+					"HOST-IDX[%04d], PORT-IDX[%04d]",
+					qp->queue_id, qp->entry_count,
+					qp->entry_size, qp->host_index,
+					qp->hba_index);
+
+				/* Reset max counter */
+				qp->CQ_max_cqe = 0;
+
+				len +=  snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
+				if (len >= max_cnt)
+					goto too_big;
+			}
+
+			if (phba->sli4_hba.nvmet_hdr_rq &&
+			    phba->sli4_hba.nvmet_dat_rq) {
+				/* Slow-path RQ header */
+				qp = phba->sli4_hba.nvmet_hdr_rq;
+
+				len += snprintf(pbuffer+len,
+				LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"\t\tNVMET RQ info: ");
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"AssocCQID[%02d]: "
+					"RQ-STAT[nopost:x%x nobuf:x%x "
+					"trunc:x%x rcv:x%llx]\n",
+					qp->assoc_qid,
+					qp->q_cnt_1, qp->q_cnt_2,
+					qp->q_cnt_3,
+					(unsigned long long)qp->q_cnt_4);
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"\t\tHQID[%02d], "
+					"QE-CNT[%04d], QE-SIZE[%04d], "
+					"HOST-IDX[%04d], PORT-IDX[%04d]\n",
+					qp->queue_id,
+					qp->entry_count,
+					qp->entry_size,
+					qp->host_index,
+					qp->hba_index);
+
+				/* Slow-path RQ data */
+				qp = phba->sli4_hba.nvmet_dat_rq;
+				len += snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len,
+					"\t\tDQID[%02d], "
+					"QE-CNT[%04d], QE-SIZE[%04d], "
+					"HOST-IDX[%04d], PORT-IDX[%04d]",
+					qp->queue_id,
+					qp->entry_count,
+					qp->entry_size,
+					qp->host_index,
+					qp->hba_index);
+
+				len +=  snprintf(pbuffer+len,
+					LPFC_QUE_INFO_GET_BUF_SIZE-len, "\n");
+			}
 		}
 	}
 
@@ -3923,6 +4162,16 @@ static const struct file_operations lpfc_debugfs_op_dumpHostSlim = {
 	.release =      lpfc_debugfs_release,
 };
 
+#undef lpfc_debugfs_op_nvmestat
+static const struct file_operations lpfc_debugfs_op_nvmestat = {
+	.owner =        THIS_MODULE,
+	.open =         lpfc_debugfs_nvmestat_open,
+	.llseek =       lpfc_debugfs_lseek,
+	.read =         lpfc_debugfs_read,
+	.write =	lpfc_debugfs_nvmestat_write,
+	.release =      lpfc_debugfs_release,
+};
+
 #undef lpfc_debugfs_op_dumpData
 static const struct file_operations lpfc_debugfs_op_dumpData = {
 	.owner =        THIS_MODULE,
@@ -4575,6 +4824,17 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 		goto debug_failed;
 	}
 
+	snprintf(name, sizeof(name), "nvmestat");
+	vport->debug_nvmestat =
+		debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
+				    vport->vport_debugfs_root,
+				    vport, &lpfc_debugfs_op_nvmestat);
+	if (!vport->debug_nvmestat) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
+				 "0811 Cannot create debugfs nvmestat\n");
+		goto debug_failed;
+	}
+
 	/*
 	 * The following section is for additional directories/files for the
 	 * physical port.
@@ -4747,6 +5007,10 @@ lpfc_debugfs_terminate(struct lpfc_vport *vport)
 		debugfs_remove(vport->debug_nodelist); /* nodelist */
 		vport->debug_nodelist = NULL;
 	}
+	if (vport->debug_nvmestat) {
+		debugfs_remove(vport->debug_nvmestat); /* nvmestat */
+		vport->debug_nvmestat = NULL;
+	}
 	if (vport->vport_debugfs_root) {
 		debugfs_remove(vport->vport_debugfs_root); /* vportX */
 		vport->vport_debugfs_root = NULL;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 4d9ee2b..5ca8e73 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2193,7 +2193,11 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		npr_nvme = (struct lpfc_nvme_prli *)pcmd;
 		bf_set(prli_type_code, npr_nvme, PRLI_NVME_TYPE);
 		bf_set(prli_estabImagePair, npr_nvme, 0);  /* Should be 0 */
-		bf_set(prli_init, npr_nvme, 1);
+		if (phba->cfg_enable_nvmet == phba->brd_no) {
+			bf_set(prli_tgt, npr_nvme, 1);
+			bf_set(prli_disc, npr_nvme, 1);
+		} else
+			bf_set(prli_init, npr_nvme, 1);
 		npr_nvme->word1 = cpu_to_be32(npr_nvme->word1);
 		npr_nvme->word4 = cpu_to_be32(npr_nvme->word4);
 		elsiocb->iocb_flag |= LPFC_PRLI_NVME_REQ;
@@ -4367,7 +4371,11 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 		npr_nvme = (struct lpfc_nvme_prli *) pcmd;
 		bf_set(prli_type_code, npr_nvme, PRLI_NVME_TYPE);
 		bf_set(prli_estabImagePair, npr_nvme, 0);  /* Should be 0 */
-		bf_set(prli_init, npr_nvme, 1);
+		if (phba->cfg_enable_nvmet == phba->brd_no) {
+			bf_set(prli_tgt, npr_nvme, 1);
+			bf_set(prli_disc, npr_nvme, 1);
+		} else
+			bf_set(prli_init, npr_nvme, 1);
 		npr_nvme->word1 = cpu_to_be32(npr_nvme->word1);
 		npr_nvme->word4 = cpu_to_be32(npr_nvme->word4);
 	} else
@@ -5777,6 +5785,8 @@ lpfc_rscn_recovery_check(struct lpfc_vport *vport)
 		    (ndlp->nlp_state == NLP_STE_UNUSED_NODE) ||
 		    !lpfc_rscn_payload_check(vport, ndlp->nlp_DID))
 			continue;
+		if (vport->phba->cfg_enable_nvmet == vport->phba->brd_no)
+			continue;
 		lpfc_disc_state_machine(vport, ndlp, NULL,
 					NLP_EVT_DEVICE_RECOVERY);
 		lpfc_cancel_retry_delay_tmo(vport, ndlp);
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index e213cf0f7..66a6562 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5242,6 +5242,8 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 			return NULL;
 		lpfc_nlp_init(vport, ndlp, did);
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
+		if (vport->phba->cfg_enable_nvmet == vport->phba->brd_no)
+			return ndlp;
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 		spin_unlock_irq(shost->host_lock);
@@ -5250,6 +5252,8 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 		ndlp = lpfc_enable_node(vport, ndlp, NLP_STE_NPR_NODE);
 		if (!ndlp)
 			return NULL;
+		if (vport->phba->cfg_enable_nvmet == vport->phba->brd_no)
+			return ndlp;
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 		spin_unlock_irq(shost->host_lock);
@@ -5269,6 +5273,9 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 			 * delay timeout is not needed.
 			 */
 			lpfc_cancel_retry_delay_tmo(vport, ndlp);
+			if (vport->phba->cfg_enable_nvmet ==
+					vport->phba->brd_no)
+				return ndlp;
 			spin_lock_irq(shost->host_lock);
 			ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 			spin_unlock_irq(shost->host_lock);
@@ -5284,6 +5291,8 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 		    ndlp->nlp_flag & NLP_RCV_PLOGI)
 			return NULL;
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
+		if (vport->phba->cfg_enable_nvmet == vport->phba->brd_no)
+			return ndlp;
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag |= NLP_NPR_2B_DISC;
 		spin_unlock_irq(shost->host_lock);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 1b786e7..864a379 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5328,6 +5328,13 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	INIT_LIST_HEAD(&phba->hbqs[LPFC_ELS_HBQ].hbq_buffer_list);
 	phba->hbqs[LPFC_ELS_HBQ].hbq_alloc_buffer = lpfc_sli4_rb_alloc;
 	phba->hbqs[LPFC_ELS_HBQ].hbq_free_buffer = lpfc_sli4_rb_free;
+	if (phba->cfg_enable_nvmet == phba->brd_no) {
+		INIT_LIST_HEAD(&phba->hbqs[LPFC_NVMET_HBQ].hbq_buffer_list);
+		phba->hbqs[LPFC_NVMET_HBQ].hbq_alloc_buffer =
+			lpfc_sli4_nvmet_alloc;
+		phba->hbqs[LPFC_NVMET_HBQ].hbq_free_buffer =
+			lpfc_sli4_nvmet_free;
+	}
 
 	/*
 	 * Initialize the SLI Layer to run with lpfc SLI4 HBAs.
@@ -6231,7 +6238,25 @@ lpfc_create_shost(struct lpfc_hba *phba)
 	shost = lpfc_shost_from_vport(vport);
 	phba->pport = vport;
 
-	phba->cfg_enable_nvmet = NVME_TARGET_OFF;
+	if ((phba->cfg_enable_nvmet == phba->brd_no) &&
+	    (phba->sli_rev == LPFC_SLI_REV4) &&
+	    phba->nvme_support) {
+
+		/* Only 1 vport (pport) will support NVME target */
+		if (phba->txrdy_payload_pool == NULL) {
+			phba->txrdy_payload_pool = pci_pool_create(
+				"txrdy_pool", phba->pcidev,
+				TXRDY_PAYLOAD_LEN, 16, 0);
+			if (phba->txrdy_payload_pool) {
+				phba->targetport = NULL;
+				phba->cfg_enable_fc4_type = LPFC_ENABLE_NVME;
+				lpfc_printf_log(phba, KERN_INFO,
+					LOG_INIT | LOG_NVME,
+					"9999 NVME Target Idenfified\n");
+			}
+		}
+	} else
+		phba->cfg_enable_nvmet = NVME_TARGET_OFF;
 
 	lpfc_debugfs_initialize(vport);
 	/* Put reference to SCSI host to driver's device private data */
@@ -7500,6 +7525,38 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 	}
 	phba->sli4_hba.dat_rq = qdesc;
 
+	if (phba->cfg_enable_nvmet == phba->brd_no) {
+		/* Create NVMET unsol receive Completion Queue */
+		qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.cq_esize,
+					      phba->sli4_hba.cq_ecount);
+		if (!qdesc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"9999 Failed allocate NVMET Rcv CQ\n");
+			goto out_error;
+		}
+		phba->sli4_hba.nvmet_cq = qdesc;
+
+		/* Create NVMET Receive Queue for header */
+		qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.rq_esize,
+					      phba->sli4_hba.rq_ecount);
+		if (!qdesc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"9999 Failed allocate receive HRQ\n");
+			goto out_error;
+		}
+		phba->sli4_hba.nvmet_hdr_rq = qdesc;
+
+		/* Create NVMET Receive Queue for data */
+		qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.rq_esize,
+					      phba->sli4_hba.rq_ecount);
+		if (!qdesc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"9999 Failed allocate receive DRQ\n");
+			goto out_error;
+		}
+		phba->sli4_hba.nvmet_dat_rq = qdesc;
+	}
+
 	/* Create the Queues needed for Flash Optimized Fabric operations */
 	if (phba->cfg_fof)
 		lpfc_fof_queue_create(phba);
@@ -7612,6 +7669,22 @@ lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
 		phba->sli4_hba.nvmels_wq = NULL;
 	}
 
+	/* Release unsolicited NVMET receive queue */
+	if (phba->sli4_hba.nvmet_hdr_rq != NULL) {
+		lpfc_sli4_queue_free(phba->sli4_hba.nvmet_hdr_rq);
+		phba->sli4_hba.nvmet_hdr_rq = NULL;
+	}
+	if (phba->sli4_hba.nvmet_dat_rq != NULL) {
+		lpfc_sli4_queue_free(phba->sli4_hba.nvmet_dat_rq);
+		phba->sli4_hba.nvmet_dat_rq = NULL;
+	}
+
+	/* Release NVMET complete queue */
+	if (phba->sli4_hba.nvmet_cq != NULL) {
+		lpfc_sli4_queue_free(phba->sli4_hba.nvmet_cq);
+		phba->sli4_hba.nvmet_cq = NULL;
+	}
+
 	/* Release unsolicited receive queue */
 	if (phba->sli4_hba.hdr_rq != NULL) {
 		lpfc_sli4_queue_free(phba->sli4_hba.hdr_rq);
@@ -7912,12 +7985,35 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 			phba->sli4_hba.mbx_cq->queue_id,
 			phba->sli4_hba.hba_eq[0]->queue_id);
 
+	if (phba->cfg_enable_nvmet == phba->brd_no) {
+		/* Set up NVMET Receive Complete Queue */
+		if (!phba->sli4_hba.nvmet_cq) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"9999 NVMET CQ not allocated\n");
+			rc = -ENOMEM;
+			goto out_destroy_mbx_cq;
+		}
+		rc = lpfc_cq_create(phba, phba->sli4_hba.nvmet_cq,
+				phba->sli4_hba.hba_eq[0], LPFC_WCQ, LPFC_NVMET);
+		if (rc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"9999 Failed setup of NVMET CQ: "
+					"rc = 0x%x\n", (uint32_t)rc);
+			goto out_destroy_mbx_cq;
+		}
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"9999 NVMET CQ setup: cq-id=%d, "
+				"parent eq-id=%d\n",
+				phba->sli4_hba.nvmet_cq->queue_id,
+				phba->sli4_hba.hba_eq[0]->queue_id);
+	}
+
 	/* Set up slow-path ELS Complete Queue */
 	if (!phba->sli4_hba.els_cq) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0530 ELS CQ not allocated\n");
 		rc = -ENOMEM;
-		goto out_destroy_mbx_cq;
+		goto out_destroy_nvmet_cq;
 	}
 	rc = lpfc_cq_create(phba, phba->sli4_hba.els_cq,
 			phba->sli4_hba.hba_eq[0], LPFC_WCQ, LPFC_ELS);
@@ -7925,7 +8021,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0531 Failed setup of slow-path ELS CQ: "
 				"rc = 0x%x\n", (uint32_t)rc);
-		goto out_destroy_mbx_cq;
+		goto out_destroy_nvmet_cq;
 	}
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 			"2586 ELS CQ setup: cq-id=%d, parent eq-id=%d\n",
@@ -8028,11 +8124,46 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 			phba->sli4_hba.nvmels_wq->queue_id,
 			phba->sli4_hba.nvmels_cq->queue_id);
 
+	/*
+	 * Create NVMET Receive Queue (RQ)
+	 */
+	if (phba->cfg_enable_nvmet == phba->brd_no) {
+		if (!phba->sli4_hba.nvmet_hdr_rq ||
+		    !phba->sli4_hba.nvmet_dat_rq) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"9999 Receive Queue not allocated\n");
+			rc = -ENOMEM;
+			goto out_destroy_nvmels_wq;
+		}
+
+		lpfc_rq_adjust_repost(phba, phba->sli4_hba.nvmet_hdr_rq,
+				      LPFC_NVMET_HBQ);
+		lpfc_rq_adjust_repost(phba, phba->sli4_hba.nvmet_dat_rq,
+				      LPFC_NVMET_HBQ);
+
+		rc = lpfc_rq_create(phba, phba->sli4_hba.nvmet_hdr_rq,
+				    phba->sli4_hba.nvmet_dat_rq,
+				    phba->sli4_hba.nvmet_cq, LPFC_NVMET);
+		if (rc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"9999 Failed setup of NVMET Receive "
+					"Queue: rc = 0x%x\n", (uint32_t)rc);
+			goto out_destroy_nvmels_wq;
+		}
+
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"9999 NVMET RQ setup: hdr-rq-id=%d, "
+				"dat-rq-id=%d parent cq-id=%d\n",
+				phba->sli4_hba.hdr_rq->queue_id,
+				phba->sli4_hba.dat_rq->queue_id,
+				phba->sli4_hba.els_cq->queue_id);
+	}
+
 	if (!phba->sli4_hba.hdr_rq || !phba->sli4_hba.dat_rq) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0540 Receive Queue not allocated\n");
 		rc = -ENOMEM;
-		goto out_destroy_nvmels_wq;
+		goto out_destroy_nvmet_rq;
 	}
 
 	lpfc_rq_adjust_repost(phba, phba->sli4_hba.hdr_rq, LPFC_ELS_HBQ);
@@ -8044,7 +8175,7 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0541 Failed setup of Receive Queue: "
 				"rc = 0x%x\n", (uint32_t)rc);
-		goto out_destroy_nvmels_wq;
+		goto out_destroy_nvmet_rq;
 	}
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
@@ -8075,6 +8206,9 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 
 out_destroy_els_rq:
 	lpfc_rq_destroy(phba, phba->sli4_hba.hdr_rq, phba->sli4_hba.dat_rq);
+out_destroy_nvmet_rq:
+	lpfc_rq_destroy(phba, phba->sli4_hba.nvmet_hdr_rq,
+			phba->sli4_hba.nvmet_dat_rq);
 out_destroy_nvmels_wq:
 	lpfc_wq_destroy(phba, phba->sli4_hba.nvmels_wq);
 out_destroy_els_wq:
@@ -8085,6 +8219,8 @@ out_destroy_nvmels_cq:
 	lpfc_cq_destroy(phba, phba->sli4_hba.nvmels_cq);
 out_destroy_els_cq:
 	lpfc_cq_destroy(phba, phba->sli4_hba.els_cq);
+out_destroy_nvmet_cq:
+	lpfc_cq_destroy(phba, phba->sli4_hba.nvmet_cq);
 out_destroy_mbx_cq:
 	lpfc_cq_destroy(phba, phba->sli4_hba.mbx_cq);
 out_destroy_hba_wq:
@@ -8133,6 +8269,9 @@ lpfc_sli4_queue_unset(struct lpfc_hba *phba)
 	lpfc_wq_destroy(phba, phba->sli4_hba.els_wq);
 	/* Unset unsolicited receive queue */
 	lpfc_rq_destroy(phba, phba->sli4_hba.hdr_rq, phba->sli4_hba.dat_rq);
+	/* Unset NVMET unsolicited receive queue */
+	lpfc_rq_destroy(phba, phba->sli4_hba.nvmet_hdr_rq,
+			phba->sli4_hba.nvmet_dat_rq);
 	/* Unset FCP work queue */
 	if (phba->sli4_hba.hba_wq) {
 		for (fcp_qidx = 0; fcp_qidx < io_channel;
@@ -8145,6 +8284,8 @@ lpfc_sli4_queue_unset(struct lpfc_hba *phba)
 	lpfc_cq_destroy(phba, phba->sli4_hba.els_cq);
 	/* Unset NVME LS complete queue */
 	lpfc_cq_destroy(phba, phba->sli4_hba.nvmels_cq);
+	/* Unset NVMET complete queue */
+	lpfc_cq_destroy(phba, phba->sli4_hba.nvmet_cq);
 	/* Unset NVME response complete queue */
 	if (phba->sli4_hba.nvme_cq) {
 		for (fcp_qidx = 0; fcp_qidx < phba->cfg_nvme_io_channel;
@@ -10491,6 +10632,12 @@ lpfc_sli4_get_els_iocb_cnt(struct lpfc_hba *phba)
 		else
 			i = 250;
 
+		/* If this is a target port, add a few more for nvmet */
+		if (phba->cfg_enable_nvmet == phba->brd_no) {
+			i = (i << 1);  /* double it */
+			if (i > 254)   /* Max for 1 mbox command */
+				i = 254;
+		}
 		return i;
 
 	} else
@@ -10875,7 +11022,7 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
 	/* Remove FC host and then SCSI host with the physical port */
 	fc_remove_host(shost);
 	scsi_remove_host(shost);
-	/* TODO: unbind with nvmet layer */
+	lpfc_nvmet_destroy_targetport(phba);
 
 	/* Perform cleanup on the physical port */
 	lpfc_cleanup(vport);
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 8c7676b..5525e15 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -2438,6 +2438,16 @@ lpfc_reg_fcfi(struct lpfc_hba *phba, struct lpfcMboxq *mbox)
 		bf_set(lpfc_reg_fcfi_rq_id0, reg_fcfi,
 		       phba->sli4_hba.hdr_rq->queue_id);
 		bf_set(lpfc_reg_fcfi_rq_id1, reg_fcfi, REG_FCF_INVALID_QID);
+	} else {
+		bf_set(lpfc_reg_fcfi_rq_id0, reg_fcfi,
+		       phba->sli4_hba.nvmet_hdr_rq->queue_id);
+		bf_set(lpfc_reg_fcfi_rq_id1, reg_fcfi,
+		       phba->sli4_hba.hdr_rq->queue_id);
+		bf_set(lpfc_reg_fcfi_type_match0, reg_fcfi, LPFC_FC4_TYPE_FCP);
+		bf_set(lpfc_reg_fcfi_type_mask0, reg_fcfi, 0xff);
+		bf_set(lpfc_reg_fcfi_rctl_match0, reg_fcfi,
+		       FC_RCTL_DD_UNSOL_CMD);
+		bf_set(lpfc_reg_fcfi_rctl_mask0, reg_fcfi, 0xff);
 	}
 	bf_set(lpfc_reg_fcfi_rq_id2, reg_fcfi, REG_FCF_INVALID_QID);
 	bf_set(lpfc_reg_fcfi_rq_id3, reg_fcfi, REG_FCF_INVALID_QID);
diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index 7397ab6..ecc8f55 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -28,6 +28,8 @@
 #include <scsi/scsi_transport_fc.h>
 #include <scsi/scsi.h>
 
+#include <linux/nvme-fc-driver.h>
+
 #include "lpfc_hw4.h"
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
@@ -35,6 +37,8 @@
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
+#include "lpfc_nvme.h"
+#include "lpfc_nvmet.h"
 #include "lpfc.h"
 #include "lpfc_crtn.h"
 #include "lpfc_logmsg.h"
@@ -229,6 +233,9 @@ lpfc_mem_free(struct lpfc_hba *phba)
 	if (phba->lpfc_hrb_pool)
 		pci_pool_destroy(phba->lpfc_hrb_pool);
 	phba->lpfc_hrb_pool = NULL;
+	if (phba->txrdy_payload_pool)
+		pci_pool_destroy(phba->txrdy_payload_pool);
+	phba->txrdy_payload_pool = NULL;
 
 	if (phba->lpfc_hbq_pool)
 		pci_pool_destroy(phba->lpfc_hbq_pool);
@@ -542,7 +549,108 @@ lpfc_sli4_rb_free(struct lpfc_hba *phba, struct hbq_dmabuf *dmab)
 	pci_pool_free(phba->lpfc_hrb_pool, dmab->hbuf.virt, dmab->hbuf.phys);
 	pci_pool_free(phba->lpfc_drb_pool, dmab->dbuf.virt, dmab->dbuf.phys);
 	kfree(dmab);
-	return;
+}
+
+/**
+ * lpfc_sli4_nvmet_alloc - Allocate an SLI4 Receive buffer
+ * @phba: HBA to allocate a receive buffer for
+ *
+ * Description: Allocates a DMA-mapped receive buffer from the lpfc_hrb_pool PCI
+ * pool along a non-DMA-mapped container for it.
+ *
+ * Notes: Not interrupt-safe.  Must be called with no locks held.
+ *
+ * Returns:
+ *   pointer to HBQ on success
+ *   NULL on failure
+ **/
+struct hbq_dmabuf *
+lpfc_sli4_nvmet_alloc(struct lpfc_hba *phba)
+{
+	struct hbq_dmabuf *dma_buf;
+
+	dma_buf = kzalloc(sizeof(struct hbq_dmabuf), GFP_KERNEL);
+	if (!dma_buf)
+		return NULL;
+
+	dma_buf->hbuf.virt = pci_pool_alloc(phba->lpfc_hrb_pool, GFP_KERNEL,
+					    &dma_buf->hbuf.phys);
+	if (!dma_buf->hbuf.virt) {
+		kfree(dma_buf);
+		return NULL;
+	}
+	dma_buf->dbuf.virt = pci_pool_alloc(phba->lpfc_drb_pool, GFP_KERNEL,
+					    &dma_buf->dbuf.phys);
+	if (!dma_buf->dbuf.virt) {
+		pci_pool_free(phba->lpfc_hrb_pool, dma_buf->hbuf.virt,
+			      dma_buf->hbuf.phys);
+		kfree(dma_buf);
+		return NULL;
+	}
+	dma_buf->total_size = LPFC_DATA_BUF_SIZE;
+
+	dma_buf->context = kzalloc(sizeof(struct lpfc_nvmet_rcv_ctx),
+				   GFP_KERNEL);
+	if (!dma_buf->context) {
+		pci_pool_free(phba->lpfc_drb_pool, dma_buf->dbuf.virt,
+			      dma_buf->dbuf.phys);
+		pci_pool_free(phba->lpfc_hrb_pool, dma_buf->hbuf.virt,
+			      dma_buf->hbuf.phys);
+		kfree(dma_buf);
+		return NULL;
+	}
+
+	dma_buf->iocbq = lpfc_sli_get_iocbq(phba);
+	if (!dma_buf->iocbq) {
+		kfree(dma_buf->context);
+		pci_pool_free(phba->lpfc_drb_pool, dma_buf->dbuf.virt,
+			      dma_buf->dbuf.phys);
+		pci_pool_free(phba->lpfc_hrb_pool, dma_buf->hbuf.virt,
+			      dma_buf->hbuf.phys);
+		kfree(dma_buf);
+		return NULL;
+	}
+
+	dma_buf->iocbq->context1 = NULL;
+	dma_buf->sglq = __lpfc_sli_get_sglq(phba, dma_buf->iocbq);
+	if (!dma_buf->sglq) {
+		lpfc_sli_release_iocbq(phba, dma_buf->iocbq);
+		kfree(dma_buf->context);
+		pci_pool_free(phba->lpfc_drb_pool, dma_buf->dbuf.virt,
+			      dma_buf->dbuf.phys);
+		pci_pool_free(phba->lpfc_hrb_pool, dma_buf->hbuf.virt,
+			      dma_buf->hbuf.phys);
+		kfree(dma_buf);
+		return NULL;
+	}
+	return dma_buf;
+}
+
+/**
+ * lpfc_sli4_nvmet_free - Frees a receive buffer
+ * @phba: HBA buffer was allocated for
+ * @dmab: DMA Buffer container returned by lpfc_sli4_hbq_alloc
+ *
+ * Description: Frees both the container and the DMA-mapped buffers returned by
+ * lpfc_sli4_nvmet_alloc.
+ *
+ * Notes: Can be called with or without locks held.
+ *
+ * Returns: None
+ **/
+void
+lpfc_sli4_nvmet_free(struct lpfc_hba *phba, struct hbq_dmabuf *dmab)
+{
+	__lpfc_clear_active_sglq(phba, dmab->sglq->sli4_lxritag);
+	dmab->sglq->state = SGL_FREED;
+	dmab->sglq->ndlp = NULL;
+	list_add_tail(&dmab->sglq->list, &phba->sli4_hba.lpfc_sgl_list);
+
+	lpfc_sli_release_iocbq(phba, dmab->iocbq);
+	kfree(dmab->context);
+	pci_pool_free(phba->lpfc_hrb_pool, dmab->hbuf.virt, dmab->hbuf.phys);
+	pci_pool_free(phba->lpfc_drb_pool, dmab->dbuf.virt, dmab->dbuf.phys);
+	kfree(dmab);
 }
 
 /**
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index df6de54..030e1e2 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1671,7 +1671,9 @@ lpfc_cmpl_reglogin_reglogin_issue(struct lpfc_vport *vport,
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_PRLI_ISSUE);
 		lpfc_issue_els_prli(vport, ndlp, 0);
 	} else {
-		/* TODO: if pt2pt and NVME, bind with nvmet layer */
+		if ((vport->fc_flag & FC_PT2PT)  &&
+		    (phba->cfg_enable_nvmet == phba->brd_no))
+			lpfc_nvmet_create_targetport(phba);
 		ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
 	}
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
new file mode 100644
index 0000000..5eea218
--- /dev/null
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -0,0 +1,1269 @@
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
+#include <linux/pci.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <asm/unaligned.h>
+#include <linux/crc-t10dif.h>
+#include <net/checksum.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
+#include <scsi/scsi_transport_fc.h>
+#include <scsi/fc/fc_fs.h>
+
+#include <../drivers/nvme/host/nvme.h>
+#include <linux/nvme-fc-driver.h>
+
+#include "lpfc_version.h"
+#include "lpfc_hw4.h"
+#include "lpfc_hw.h"
+#include "lpfc_sli.h"
+#include "lpfc_sli4.h"
+#include "lpfc_nl.h"
+#include "lpfc_disc.h"
+#include "lpfc_nvme.h"
+#include "lpfc_nvmet.h"
+#include "lpfc.h"
+#include "lpfc_scsi.h"
+#include "lpfc_logmsg.h"
+#include "lpfc_crtn.h"
+#include "lpfc_vport.h"
+
+static struct lpfc_iocbq *lpfc_nvmet_prep_ls_wqe(struct lpfc_hba *,
+					  struct lpfc_nvmet_rcv_ctx *,
+					  dma_addr_t rspbuf,
+					  uint16_t rspsize);
+static struct lpfc_iocbq *lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *,
+					   struct lpfc_nvmet_rcv_ctx *,
+					   struct ulp_bde64 *);
+static int lpfc_nvmet_unsol_issue_abort(struct lpfc_hba *,
+				 struct lpfc_nvmet_rcv_ctx *,
+				 uint32_t, uint16_t);
+
+/* For now, this logic must change */
+#define NVMET_FC_MAX_SEGMENTS 16
+
+/**
+ * lpfc_nvmet_xmt_ls_rsp_cmp - Completion handler for LS Response
+ * @phba: Pointer to HBA context object.
+ * @cmdwqe: Pointer to driver command WQE object.
+ * @wcqe: Pointer to driver response CQE object.
+ *
+ * The function is called from SLI ring event handler with no
+ * lock held. This function is the completion handler for NVME LS commands
+ * The function frees memory resources used for the NVME commands.
+ **/
+static void
+lpfc_nvmet_xmt_ls_rsp_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
+			  struct lpfc_wcqe_complete *wcqe)
+{
+	struct lpfc_nvmet_tgtport *tgtp;
+	struct nvmefc_tgt_ls_req *rsp;
+	struct lpfc_nvmet_rcv_ctx *ctxp;
+	uint32_t status, result;
+
+	status = bf_get(lpfc_wcqe_c_status, wcqe);
+	result = wcqe->parameter;
+	if (!phba->targetport)
+		goto out;
+
+	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
+	if (status)
+		tgtp->xmt_ls_rsp_error++;
+	else
+		tgtp->xmt_ls_rsp_cmpl++;
+
+out:
+	ctxp = cmdwqe->context2;
+	rsp = &ctxp->ctx.ls_req;
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_NVME,
+			"6038 %s: Entrypoint: ctx %p status %x/%x\n", __func__,
+			ctxp, status, result);
+
+	lpfc_nlp_put(cmdwqe->context1);
+	cmdwqe->context2 = NULL;
+	cmdwqe->context3 = NULL;
+	lpfc_sli_release_iocbq(phba, cmdwqe);
+	rsp->done(rsp);
+	kfree(ctxp);
+}
+
+/**
+ * lpfc_nvmet_xmt_fcp_op_cmp - Completion handler for FCP Response
+ * @phba: Pointer to HBA context object.
+ * @cmdwqe: Pointer to driver command WQE object.
+ * @wcqe: Pointer to driver response CQE object.
+ *
+ * The function is called from SLI ring event handler with no
+ * lock held. This function is the completion handler for NVME FCP commands
+ * The function frees memory resources used for the NVME commands.
+ **/
+static void
+lpfc_nvmet_xmt_fcp_op_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
+			  struct lpfc_wcqe_complete *wcqe)
+{
+	struct lpfc_nvmet_tgtport *tgtp;
+	struct nvmefc_tgt_fcp_req *rsp;
+	struct lpfc_nvmet_rcv_ctx *ctxp;
+	uint32_t status, result, op, start_clean;
+
+	ctxp = cmdwqe->context2;
+	rsp = &ctxp->ctx.fcp_req;
+	op = rsp->op;
+
+	status = bf_get(lpfc_wcqe_c_status, wcqe);
+	result = wcqe->parameter;
+
+	if (!phba->targetport)
+		goto out;
+
+	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
+	if (status) {
+		rsp->fcp_error = NVME_SC_DATA_XFER_ERROR;
+		rsp->transferred_length = 0;
+		tgtp->xmt_fcp_rsp_error++;
+	} else {
+		rsp->fcp_error = NVME_SC_SUCCESS;
+		if (op == NVMET_FCOP_RSP)
+			rsp->transferred_length = rsp->rsplen;
+		else
+			rsp->transferred_length = rsp->transfer_length;
+		tgtp->xmt_fcp_rsp_cmpl++;
+	}
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_NVME,
+			"6054 %s: Entrypoint: ctx %p status %x/%x op %d "
+			"done %p\n",
+			__func__, ctxp, status, result, rsp->op, rsp->done);
+
+out:
+	if (ctxp->txrdy) {
+		pci_pool_free(phba->txrdy_payload_pool, ctxp->txrdy,
+			       ctxp->txrdy_phys);
+		ctxp->txrdy = NULL;
+		ctxp->txrdy_phys = 0;
+	}
+	if ((op == NVMET_FCOP_READDATA_RSP) ||
+	    (op == NVMET_FCOP_RSP)) {
+		/* Sanity check */
+		ctxp->state = LPFC_NVMET_STE_DONE;
+		ctxp->entry_cnt++;
+		rsp->done(rsp);
+		lpfc_in_buf_free(phba, &ctxp->hbq_buffer->dbuf);
+	} else {
+		/* Sanity check */
+		if (ctxp->state != LPFC_NVMET_STE_DATA) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
+					"9999 Wrong state %s: %d  cnt %d\n",
+					__func__, ctxp->state, ctxp->entry_cnt);
+			return;
+		}
+		ctxp->entry_cnt++;
+		start_clean = offsetof(struct lpfc_iocbq, wqe);
+		memset(((char *)cmdwqe) + start_clean, 0,
+		       (sizeof(struct lpfc_iocbq) - start_clean));
+		rsp->done(rsp);
+	}
+}
+
+static int
+lpfc_nvmet_xmt_ls_rsp(struct nvmet_fc_target_port *tgtport,
+		      struct nvmefc_tgt_ls_req *rsp)
+{
+	struct lpfc_nvmet_rcv_ctx *ctxp =
+		container_of(rsp, struct lpfc_nvmet_rcv_ctx, ctx.ls_req);
+	struct lpfc_hba *phba = ctxp->phba;
+	struct lpfc_iocbq *nvmewqeq;
+	struct lpfc_nvmet_tgtport *nvmep = tgtport->private;
+	struct lpfc_dmabuf dmabuf;
+	struct ulp_bde64 bpl;
+	int rc;
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_NVME,
+			"6023 %s: Entrypoint ctx %p %p\n", __func__,
+			ctxp, tgtport);
+
+	nvmewqeq = lpfc_nvmet_prep_ls_wqe(phba, ctxp, rsp->rspdma,
+				      rsp->rsplen);
+	if (nvmewqeq == NULL) {
+		nvmep->xmt_ls_drop++;
+		return -ENOMEM;
+	}
+
+	/* Save numBdes for bpl2sgl */
+	nvmewqeq->rsvd2 = 1;
+	nvmewqeq->hba_wqidx = 0;
+	nvmewqeq->context3 = &dmabuf;
+	dmabuf.virt = &bpl;
+	bpl.addrLow = nvmewqeq->wqe.xmit_sequence.bde.addrLow;
+	bpl.addrHigh = nvmewqeq->wqe.xmit_sequence.bde.addrHigh;
+	bpl.tus.f.bdeSize = rsp->rsplen;
+	bpl.tus.f.bdeFlags = 0;
+	bpl.tus.w = le32_to_cpu(bpl.tus.w);
+
+	nvmewqeq->wqe_cmpl = lpfc_nvmet_xmt_ls_rsp_cmp;
+	nvmewqeq->iocb_cmpl = NULL;
+	nvmewqeq->context2 = ctxp;
+	rc = lpfc_sli_issue_wqe(phba, LPFC_ELS_RING, nvmewqeq);
+	if (rc == WQE_SUCCESS) {
+		nvmep->xmt_ls_rsp++;
+		return 0;
+	}
+
+	/* Give back resources */
+	nvmep->xmt_ls_drop++;
+	lpfc_nlp_put(nvmewqeq->context1);
+
+	kfree(ctxp);
+	nvmewqeq->context2 = NULL;
+	nvmewqeq->context3 = NULL;
+	lpfc_sli_release_iocbq(phba, nvmewqeq);
+	return -ENXIO;
+}
+
+
+static int
+lpfc_nvmet_xmt_fcp_op(struct nvmet_fc_target_port *tgtport,
+		      struct nvmefc_tgt_fcp_req *rsp)
+{
+	struct lpfc_nvmet_tgtport *lpfc_nvmep = tgtport->private;
+	struct lpfc_nvmet_rcv_ctx *ctxp =
+		container_of(rsp, struct lpfc_nvmet_rcv_ctx, ctx.fcp_req);
+	struct lpfc_hba *phba = ctxp->phba;
+	struct lpfc_iocbq *nvmewqeq;
+	struct lpfc_dmabuf dmabuf;
+	struct ulp_bde64 bpl[NVMET_FC_MAX_SEGMENTS+2];
+	unsigned long iflags;
+	int rc;
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_NVME,
+			"6024 %s: ctx %p op %d sid %08x xri x%x: %p\n",
+			__func__, ctxp,
+			rsp->op, ctxp->sid, ctxp->oxid, tgtport);
+
+	if (rsp->op == NVMET_FCOP_ABORT) {
+		/* Sanity check */
+		if (ctxp->state != LPFC_NVMET_STE_RCV) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
+					"9999 Wrong state %s: %d  cnt %d\n",
+					__func__, ctxp->state, ctxp->entry_cnt);
+			return -ENOENT;
+		}
+		ctxp->state = LPFC_NVMET_STE_ABORT;
+		ctxp->entry_cnt++;
+		rc = lpfc_nvmet_unsol_issue_abort(phba, ctxp, ctxp->sid,
+						  ctxp->oxid);
+		return rc;
+	}
+
+	nvmewqeq = lpfc_nvmet_prep_fcp_wqe(phba, ctxp, bpl);
+	if (nvmewqeq == NULL) {
+		lpfc_nvmep->xmt_fcp_drop++;
+		return -ENOMEM;
+	}
+
+	/* Save numBdes for bpl2sgl */
+	nvmewqeq->context3 = &dmabuf;
+	dmabuf.virt = &bpl;
+
+	nvmewqeq->wqe_cmpl = lpfc_nvmet_xmt_fcp_op_cmp;
+	nvmewqeq->iocb_cmpl = NULL;
+	nvmewqeq->context2 = ctxp;
+	nvmewqeq->iocb_flag |=  LPFC_IO_NVMET;
+
+	/* For now we take hbalock */
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	rc = lpfc_sli_issue_wqe(phba, LPFC_FCP_RING, nvmewqeq);
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+	if (rc == WQE_SUCCESS) {
+		lpfc_nvmep->xmt_fcp_rsp++;
+		return 0;
+	}
+
+	/* Give back resources */
+	lpfc_nvmep->xmt_fcp_drop++;
+
+	nvmewqeq->context2 = NULL;
+	nvmewqeq->context3 = NULL;
+	return -ENXIO;
+}
+
+static struct nvmet_fc_target_template lpfc_tgttemplate = {
+	.xmt_ls_rsp     = lpfc_nvmet_xmt_ls_rsp,
+	.fcp_op         = lpfc_nvmet_xmt_fcp_op,
+
+	.max_hw_queues  = 1,
+	.max_sgl_segments = 16,
+	.max_dif_sgl_segments = 16,
+	.dma_boundary = 0xFFFFFFFF,
+
+	/* optional features */
+	.target_features = 0,
+	/* sizes of additional private data for data structures */
+	.target_priv_sz = sizeof(struct lpfc_nvmet_tgtport),
+};
+
+int
+lpfc_nvmet_create_targetport(struct lpfc_hba *phba)
+{
+	struct lpfc_vport  *vport = phba->pport;
+	struct lpfc_nvmet_tgtport *tgtp;
+	struct nvmet_fc_port_info pinfo;
+	int error = 0;
+
+	if (phba->targetport) {
+		tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
+		if (tgtp->nvmet_state == LPFC_NVME_REG) {
+			phba->targetport->port_id = vport->fc_myDID;
+			phba->targetport->fabric_name =
+				wwn_to_u64(vport->fabric_nodename.u.wwn);
+
+			lpfc_printf_log(phba, KERN_INFO, LOG_NVME,
+					"6056 Updated NVME "
+					"targetport: %p did x%06x\n",
+					phba->targetport,
+					vport->fc_myDID);
+		}
+	} else {
+		memset(&pinfo, 0, sizeof(struct nvmet_fc_port_info));
+		pinfo.node_name = wwn_to_u64(vport->fc_nodename.u.wwn);
+		pinfo.port_name = wwn_to_u64(vport->fc_portname.u.wwn);
+		pinfo.port_id = vport->fc_myDID;
+		if (vport->fc_flag & FC_PT2PT)
+			pinfo.fabric_name =
+				wwn_to_u64(vport->fc_portname.u.wwn);
+		else
+			pinfo.fabric_name =
+				wwn_to_u64(vport->fabric_nodename.u.wwn);
+
+		lpfc_tgttemplate.target_features = NVMET_FCTGTFEAT_READDATA_RSP;
+
+		error = nvmet_fc_register_targetport(&pinfo, &lpfc_tgttemplate,
+						     &phba->pcidev->dev,
+						     &phba->targetport);
+		if (error) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
+					"6025 Cannot register NVME targetport "
+					"x%x\n", error);
+			phba->targetport = NULL;
+		} else {
+			tgtp = (struct lpfc_nvmet_tgtport *)
+				phba->targetport->private;
+			tgtp->nvmet_state = LPFC_NVME_REG;
+			tgtp->phba = phba;
+
+			lpfc_printf_log(phba, KERN_INFO, LOG_NVME,
+					"6026 Registered NVME "
+					"targetport: %p fabnm %llx "
+					"portnm %llx nodenm %llx\n",
+					phba->targetport, pinfo.fabric_name,
+					pinfo.port_name, pinfo.node_name);
+		}
+	}
+	return error;
+}
+
+void
+lpfc_nvmet_destroy_targetport(struct lpfc_hba *phba)
+{
+	if (phba->cfg_enable_nvmet == NVME_TARGET_OFF)
+		return;
+	if (phba->targetport)
+		nvmet_fc_unregister_targetport(phba->targetport);
+	phba->targetport = NULL;
+}
+
+/**
+ * lpfc_nvmet_unsol_ls_buffer - Process an unsolicited event data buffer
+ * @phba: pointer to lpfc hba data structure.
+ * @pring: pointer to a SLI ring.
+ * @nvmebuf: pointer to lpfc nvme command HBQ data structure.
+ *
+ * This routine is used for processing the WQE associated with a unsolicited
+ * event. It first determines whether there is an existing ndlp that matches
+ * the DID from the unsolicited WQE. If not, it will create a new one with
+ * the DID from the unsolicited WQE. The ELS command from the unsolicited
+ * WQE is then used to invoke the proper routine and to set up proper state
+ * of the discovery state machine.
+ **/
+static void
+lpfc_nvmet_unsol_ls_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
+			   struct hbq_dmabuf *nvmebuf)
+{
+	struct lpfc_nvmet_tgtport *tgtp;
+	struct fc_frame_header *fc_hdr;
+	uint32_t *payload;
+	uint32_t size, oxid, sid, rc;
+	struct lpfc_nvmet_rcv_ctx *ctxp;
+
+	oxid = 0;
+	if (!nvmebuf || !phba->targetport)
+		goto dropit;
+
+	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
+	payload = (uint32_t *)(nvmebuf->dbuf.virt);
+	fc_hdr = (struct fc_frame_header *)(nvmebuf->hbuf.virt);
+	size = bf_get(lpfc_rcqe_length,  &nvmebuf->cq_event.cqe.rcqe_cmpl);
+	oxid = be16_to_cpu(fc_hdr->fh_ox_id);
+	sid = sli4_sid_from_fc_hdr(fc_hdr);
+
+	ctxp = kzalloc(sizeof(struct lpfc_nvmet_rcv_ctx), GFP_ATOMIC);
+	if (ctxp == NULL) {
+		tgtp->rcv_ls_drop++;
+		goto dropit;
+	}
+	ctxp->phba = phba;
+	ctxp->size = size;
+	ctxp->oxid = oxid;
+	ctxp->sid = sid;
+
+	/*
+	 * The calling sequence should be:
+	 * nvmet_fc_rcv_ls_req -> lpfc_nvmet_xmt_ls_rsp/cmp ->_req->done
+	 * lpfc_nvmet_xmt_ls_rsp_cmp should free the allocated ctxp.
+	 */
+	rc = nvmet_fc_rcv_ls_req(phba->targetport, &ctxp->ctx.ls_req,
+				 payload, size);
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_NVME,
+			"6037 %s: ctx %p sz %d rc %d: %08x %08x %08x "
+			"%08x %08x %08x\n", __func__, ctxp, size, rc,
+			*payload, *(payload+1), *(payload+2),
+			*(payload+3), *(payload+4), *(payload+5));
+	if (rc == 0) {
+		tgtp->rcv_ls_req++;
+		lpfc_in_buf_free(phba, &nvmebuf->dbuf);
+		return;
+	}
+
+	kfree(ctxp);
+	tgtp->rcv_ls_drop++;
+dropit:
+	if (nvmebuf)
+		/* We assume a rcv'ed cmd ALWAYs fits into 1 buffer */
+		lpfc_in_buf_free(phba, &nvmebuf->dbuf);
+
+	if (oxid)
+		lpfc_nvmet_unsol_issue_abort(phba, NULL, sid, oxid);
+}
+
+/**
+ * lpfc_nvmet_unsol_fcp_buffer - Process an unsolicited event data buffer
+ * @phba: pointer to lpfc hba data structure.
+ * @pring: pointer to a SLI ring.
+ * @nvmebuf: pointer to lpfc nvme command HBQ data structure.
+ *
+ * This routine is used for processing the WQE associated with a unsolicited
+ * event. It first determines whether there is an existing ndlp that matches
+ * the DID from the unsolicited WQE. If not, it will create a new one with
+ * the DID from the unsolicited WQE. The ELS command from the unsolicited
+ * WQE is then used to invoke the proper routine and to set up proper state
+ * of the discovery state machine.
+ **/
+static void
+lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
+			    struct hbq_dmabuf *nvmebuf)
+{
+	struct lpfc_nvmet_rcv_ctx *ctxp;
+	struct lpfc_nvmet_tgtport *tgtp;
+	struct fc_frame_header *fc_hdr;
+	uint32_t *payload;
+	uint32_t size, oxid, sid, rc;
+
+	oxid = 0;
+	if (!nvmebuf || !phba->targetport)
+		goto dropit;
+
+
+	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
+	payload = (uint32_t *)(nvmebuf->dbuf.virt);
+	fc_hdr = (struct fc_frame_header *)(nvmebuf->hbuf.virt);
+	size = nvmebuf->bytes_recv;
+	oxid = be16_to_cpu(fc_hdr->fh_ox_id);
+	sid = sli4_sid_from_fc_hdr(fc_hdr);
+
+	ctxp = (struct lpfc_nvmet_rcv_ctx *)nvmebuf->context;
+	if (ctxp == NULL) {
+		tgtp->rcv_fcp_drop++;
+		goto dropit;
+	}
+	memset(ctxp, 0, sizeof(ctxp->ctx));
+	ctxp->wqeq = NULL;
+	ctxp->txrdy = NULL;
+	ctxp->offset = 0;
+	ctxp->phba = phba;
+	ctxp->size = size;
+	ctxp->oxid = oxid;
+	ctxp->sid = sid;
+	ctxp->state = LPFC_NVMET_STE_RCV;
+	ctxp->hbq_buffer = nvmebuf;
+	ctxp->entry_cnt = 1;
+
+	/*
+	 * The calling sequence should be:
+	 * nvmet_fc_rcv_fcp_req -> lpfc_nvmet_xmt_fcp_op/cmp -> req->done
+	 * lpfc_nvmet_xmt_fcp_op_cmp should free the allocated ctxp.
+	 */
+	rc = nvmet_fc_rcv_fcp_req(phba->targetport, &ctxp->ctx.fcp_req,
+				  payload, size);
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_NVME,
+			"6040 %s: Entrypoint ctx %p sz %d %d: %08x %08x %08x "
+			"%08x %08x %08x\n", __func__, ctxp, size, rc,
+			*payload, *(payload+1), *(payload+2),
+			*(payload+3), *(payload+4), *(payload+5));
+
+	/* Process FCP command */
+	if (rc == 0) {
+		tgtp->rcv_fcp_cmd++;
+		return;
+	}
+
+	tgtp->rcv_fcp_drop++;
+dropit:
+	if (nvmebuf)
+		/* We assume a rcv'ed cmd ALWAYs fits into 1 buffer */
+		lpfc_in_buf_free(phba, &nvmebuf->dbuf);
+
+	if (oxid)
+		lpfc_nvmet_unsol_issue_abort(phba, NULL, sid, oxid);
+}
+
+/**
+ * lpfc_nvmet_unsol_ls_event - Process an unsolicited event from an nvme nport
+ * @phba: pointer to lpfc hba data structure.
+ * @pring: pointer to a SLI ring.
+ * @nvmebuf: pointer to received nvme data structure.
+ *
+ * This routine is used to process an unsolicited event received from a SLI
+ * (Service Level Interface) ring. The actual processing of the data buffer
+ * associated with the unsolicited event is done by invoking the routine
+ * lpfc_nvmet_unsol_ls_buffer() after properly set up the buffer from the
+ * SLI RQ on which the unsolicited event was received.
+ **/
+void
+lpfc_nvmet_unsol_ls_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
+			  struct lpfc_iocbq *piocb)
+{
+	struct lpfc_dmabuf *d_buf;
+	struct hbq_dmabuf *nvmebuf;
+
+	d_buf = piocb->context2;
+	nvmebuf = container_of(d_buf, struct hbq_dmabuf, dbuf);
+
+	if (phba->cfg_enable_nvmet == NVME_TARGET_OFF) {
+		lpfc_in_buf_free(phba, &nvmebuf->dbuf);
+		return;
+	}
+	lpfc_nvmet_unsol_ls_buffer(phba, pring, nvmebuf);
+}
+
+/**
+ * lpfc_nvmet_unsol_fcp_event - Process an unsolicited event from an nvme nport
+ * @phba: pointer to lpfc hba data structure.
+ * @pring: pointer to a SLI ring.
+ * @nvmebuf: pointer to received nvme data structure.
+ *
+ * This routine is used to process an unsolicited event received from a SLI
+ * (Service Level Interface) ring. The actual processing of the data buffer
+ * associated with the unsolicited event is done by invoking the routine
+ * lpfc_nvmet_unsol_fcp_buffer() after properly set up the buffer from the
+ * SLI RQ on which the unsolicited event was received.
+ **/
+void
+lpfc_nvmet_unsol_fcp_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
+			   struct hbq_dmabuf *nvmebuf)
+{
+	if (phba->cfg_enable_nvmet == NVME_TARGET_OFF) {
+		lpfc_in_buf_free(phba, &nvmebuf->dbuf);
+		return;
+	}
+	lpfc_nvmet_unsol_fcp_buffer(phba, pring, nvmebuf);
+}
+
+/**
+ * lpfc_nvmet_prep_ls_wqe - Allocate and prepare a lpfc wqe data structure
+ * @phba: pointer to a host N_Port data structure.
+ * @ctxp: Context info for NVME LS Request
+ * @rspbuf: DMA buffer of NVME command.
+ * @rspsize: size of the NVME command.
+ *
+ * This routine is used for allocating a lpfc-WQE data structure from
+ * the driver lpfc-WQE free-list and prepare the WQE with the parameters
+ * passed into the routine for discovery state machine to issue an Extended
+ * Link Service (NVME) commands. It is a generic lpfc-WQE allocation
+ * and preparation routine that is used by all the discovery state machine
+ * routines and the NVME command-specific fields will be later set up by
+ * the individual discovery machine routines after calling this routine
+ * allocating and preparing a generic WQE data structure. It fills in the
+ * Buffer Descriptor Entries (BDEs), allocates buffers for both command
+ * payload and response payload (if expected). The reference count on the
+ * ndlp is incremented by 1 and the reference to the ndlp is put into
+ * context1 of the WQE data structure for this WQE to hold the ndlp
+ * reference for the command's callback function to access later.
+ *
+ * Return code
+ *   Pointer to the newly allocated/prepared nvme wqe data structure
+ *   NULL - when nvme wqe data structure allocation/preparation failed
+ **/
+static struct lpfc_iocbq *
+lpfc_nvmet_prep_ls_wqe(struct lpfc_hba *phba,
+		       struct lpfc_nvmet_rcv_ctx *ctxp,
+		       dma_addr_t rspbuf, uint16_t rspsize)
+{
+	struct lpfc_nodelist *ndlp;
+	struct lpfc_iocbq *nvmewqe;
+	union lpfc_wqe *wqe;
+
+	if (!lpfc_is_link_up(phba)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
+				"9999 lpfc_nvmet_prep_ls_wqe: link err: "
+				"NPORT x%x oxid:x%x\n",
+				ctxp->sid, ctxp->oxid);
+		return NULL;
+	}
+
+	/* Allocate buffer for  command wqe */
+	nvmewqe = lpfc_sli_get_iocbq(phba);
+	if (nvmewqe == NULL) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
+				"9999 lpfc_nvmet_prep_ls_wqe: No WQE: "
+				"NPORT x%x oxid:x%x\n",
+				ctxp->sid, ctxp->oxid);
+		return NULL;
+	}
+
+	ndlp = lpfc_findnode_did(phba->pport, ctxp->sid);
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp) ||
+	    ((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
+	    (ndlp->nlp_state != NLP_STE_MAPPED_NODE))) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
+				"9999 lpfc_nvmet_prep_ls_wqe: No ndlp: "
+				"NPORT x%x oxid:x%x\n",
+				ctxp->sid, ctxp->oxid);
+		goto nvme_wqe_free_wqeq_exit;
+	}
+
+	/* prevent preparing wqe with NULL ndlp reference */
+	nvmewqe->context1 = lpfc_nlp_get(ndlp);
+	if (nvmewqe->context1 == NULL)
+		goto nvme_wqe_free_wqeq_exit;
+	nvmewqe->context2 = ctxp;
+
+	wqe = &nvmewqe->wqe;
+	memset(wqe, 0, sizeof(union lpfc_wqe));
+
+	/* Words 0 - 2 */
+	wqe->xmit_sequence.bde.tus.f.bdeFlags = BUFF_TYPE_BDE_64;
+	wqe->xmit_sequence.bde.tus.f.bdeSize = rspsize;
+	wqe->xmit_sequence.bde.addrLow = le32_to_cpu(putPaddrLow(rspbuf));
+	wqe->xmit_sequence.bde.addrHigh = le32_to_cpu(putPaddrHigh(rspbuf));
+
+	/* Word 3 */
+
+	/* Word 4 */
+
+	/* Word 5 */
+	bf_set(wqe_dfctl, &wqe->xmit_sequence.wge_ctl, 0);
+	bf_set(wqe_ls, &wqe->xmit_sequence.wge_ctl, 1);
+	bf_set(wqe_la, &wqe->xmit_sequence.wge_ctl, 0);
+	bf_set(wqe_rctl, &wqe->xmit_sequence.wge_ctl, FC_RCTL_DD_SOL_CTL);
+	bf_set(wqe_type, &wqe->xmit_sequence.wge_ctl, LPFC_FC4_TYPE_NVME);
+
+	/* Word 6 */
+	bf_set(wqe_ctxt_tag, &wqe->xmit_sequence.wqe_com,
+	       phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);
+	bf_set(wqe_xri_tag, &wqe->xmit_sequence.wqe_com, nvmewqe->sli4_xritag);
+
+	/* Word 7 */
+	bf_set(wqe_cmnd, &wqe->xmit_sequence.wqe_com,
+	       CMD_XMIT_SEQUENCE64_WQE);
+	bf_set(wqe_ct, &wqe->xmit_sequence.wqe_com, SLI4_CT_RPI);
+	bf_set(wqe_class, &wqe->xmit_sequence.wqe_com, CLASS3);
+	bf_set(wqe_pu, &wqe->xmit_sequence.wqe_com, 0);
+
+	/* Word 8 */
+	wqe->xmit_sequence.wqe_com.abort_tag = nvmewqe->iotag;
+
+	/* Word 9 */
+	bf_set(wqe_reqtag, &wqe->xmit_sequence.wqe_com, nvmewqe->iotag);
+	/* Needs to be set by caller */
+	bf_set(wqe_rcvoxid, &wqe->xmit_sequence.wqe_com, ctxp->oxid);
+
+	/* Word 10 */
+	bf_set(wqe_dbde, &wqe->xmit_sequence.wqe_com, 1);
+	bf_set(wqe_iod, &wqe->xmit_sequence.wqe_com, LPFC_WQE_IOD_WRITE);
+	bf_set(wqe_lenloc, &wqe->xmit_sequence.wqe_com,
+	       LPFC_WQE_LENLOC_WORD12);
+	bf_set(wqe_ebde_cnt, &wqe->xmit_sequence.wqe_com, 0);
+
+	/* Word 11 */
+	bf_set(wqe_cqid, &wqe->xmit_sequence.wqe_com,
+	       LPFC_WQE_CQ_ID_DEFAULT);
+	bf_set(wqe_cmd_type, &wqe->xmit_sequence.wqe_com,
+	       OTHER_COMMAND);
+
+	/* Word 12 */
+	wqe->xmit_sequence.xmit_len = rspsize;
+
+	nvmewqe->retry = 1;
+	nvmewqe->vport = phba->pport;
+	nvmewqe->drvrTimeout = (phba->fc_ratov * 3) + LPFC_DRVR_TIMEOUT;
+	nvmewqe->iocb_flag |= LPFC_IO_NVME_LS;
+
+	/* Xmit NVME response to remote NPORT <did> */
+	lpfc_printf_log(phba, KERN_INFO, LOG_NVME,
+			"6039 Xmit NVME LS response to remote "
+			"NPORT x%x iotag:x%x oxid:x%x size:x%x\n",
+			ndlp->nlp_DID, nvmewqe->iotag, ctxp->oxid,
+			rspsize);
+	return nvmewqe;
+
+nvme_wqe_free_wqeq_exit:
+	lpfc_sli_release_iocbq(phba, nvmewqe);
+	return NULL;
+}
+
+
+static struct lpfc_iocbq *
+lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
+			struct lpfc_nvmet_rcv_ctx *ctxp,
+			struct ulp_bde64 *bpl)
+{
+	struct nvmefc_tgt_fcp_req *rsp = &ctxp->ctx.fcp_req;
+	struct sli4_sge *sgl;
+	struct lpfc_nodelist *ndlp;
+	struct lpfc_iocbq *nvmewqe;
+	struct scatterlist *sgel;
+	union lpfc_wqe128 *wqe;
+	uint32_t *txrdy;
+	dma_addr_t physaddr;
+	int i, cnt;
+	int xc = 1;
+
+	if (!lpfc_is_link_up(phba)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
+				"9999 lpfc_nvmet_prep_fcp_wqe: link err: "
+				"NPORT x%x oxid:x%x\n",
+				ctxp->sid, ctxp->oxid);
+		return NULL;
+	}
+
+	ndlp = lpfc_findnode_did(phba->pport, ctxp->sid);
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp) ||
+	    ((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
+	     (ndlp->nlp_state != NLP_STE_MAPPED_NODE))) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
+				"9999 lpfc_nvmet_prep_fcp_wqe: no ndlp: "
+				"NPORT x%x oxid:x%x\n",
+				ctxp->sid, ctxp->oxid);
+		return NULL;
+	}
+
+	if (rsp->sg_cnt > NVMET_FC_MAX_SEGMENTS) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
+				"9999 lpfc_nvmet_prep_fcp_wqe: seg cnt err: "
+				"NPORT x%x oxid:x%x\n",
+				ctxp->sid, ctxp->oxid);
+		return NULL;
+	}
+
+	nvmewqe = ctxp->wqeq;
+	if (nvmewqe == NULL) {
+		/* Allocate buffer for  command wqe */
+		nvmewqe = ctxp->hbq_buffer->iocbq;
+		if (nvmewqe == NULL) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
+					"9999 lpfc_nvmet_prep_fcp_wqe: No "
+					"WQE: NPORT x%x oxid:x%x\n",
+					ctxp->sid, ctxp->oxid);
+			return NULL;
+		}
+		ctxp->wqeq = nvmewqe;
+		xc = 0; /* create new XRI */
+		nvmewqe->sli4_lxritag = NO_XRI;
+		nvmewqe->sli4_xritag = NO_XRI;
+	}
+
+	/* Sanity check */
+	if (((ctxp->state == LPFC_NVMET_STE_RCV) &&
+	    (ctxp->entry_cnt == 1)) ||
+	    ((ctxp->state == LPFC_NVMET_STE_DATA) &&
+	    (ctxp->entry_cnt > 1))) {
+		wqe = (union lpfc_wqe128 *)&nvmewqe->wqe;
+		memset(wqe, 0, sizeof(union lpfc_wqe));
+	} else {
+		lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
+				"9999 Wrong state %s: %d  cnt %d\n",
+				__func__, ctxp->state, ctxp->entry_cnt);
+		return NULL;
+	}
+
+	sgl  = (struct sli4_sge *)ctxp->hbq_buffer->sglq->sgl;
+	switch (rsp->op) {
+	case NVMET_FCOP_READDATA:
+	case NVMET_FCOP_READDATA_RSP:
+		/* Words 0 - 2 : The first sg segment */
+		sgel = &rsp->sg[0];
+		physaddr = sg_dma_address(sgel);
+		wqe->fcp_tsend.bde.tus.f.bdeFlags = BUFF_TYPE_BDE_64;
+		wqe->fcp_tsend.bde.tus.f.bdeSize = sg_dma_len(sgel);
+		wqe->fcp_tsend.bde.addrLow = cpu_to_le32(putPaddrLow(physaddr));
+		wqe->fcp_tsend.bde.addrHigh =
+			cpu_to_le32(putPaddrHigh(physaddr));
+
+		/* Word 3 */
+		wqe->fcp_tsend.payload_offset_len = 0;
+
+		/* Word 4 */
+		wqe->fcp_tsend.relative_offset = ctxp->offset;
+
+		/* Word 5 */
+
+		/* Word 6 */
+		bf_set(wqe_ctxt_tag, &wqe->fcp_tsend.wqe_com,
+		       phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);
+		bf_set(wqe_xri_tag, &wqe->fcp_tsend.wqe_com,
+		       nvmewqe->sli4_xritag);
+
+		/* Word 7 */
+		bf_set(wqe_ar, &wqe->fcp_tsend.wqe_com, 0); /* auto rsp */
+		bf_set(wqe_cmnd, &wqe->fcp_tsend.wqe_com, CMD_FCP_TSEND64_WQE);
+		bf_set(wqe_ct, &wqe->fcp_tsend.wqe_com, SLI4_CT_RPI);
+		bf_set(wqe_class, &wqe->fcp_tsend.wqe_com, CLASS3);
+		bf_set(wqe_pu, &wqe->fcp_tsend.wqe_com, 1);
+
+		/* Word 8 */
+		wqe->fcp_tsend.wqe_com.abort_tag = nvmewqe->iotag;
+
+		/* Word 9 */
+		bf_set(wqe_reqtag, &wqe->fcp_tsend.wqe_com, nvmewqe->iotag);
+		bf_set(wqe_rcvoxid, &wqe->fcp_tsend.wqe_com, ctxp->oxid);
+
+		/* Word 10 */
+		bf_set(wqe_nvme, &wqe->fcp_tsend.wqe_com, 1);
+		bf_set(wqe_dbde, &wqe->fcp_tsend.wqe_com, 1);
+		bf_set(wqe_iod, &wqe->fcp_tsend.wqe_com, LPFC_WQE_IOD_WRITE);
+		bf_set(wqe_qosd, &wqe->fcp_tsend.wqe_com, 0);
+		bf_set(wqe_lenloc, &wqe->fcp_tsend.wqe_com,
+		       LPFC_WQE_LENLOC_WORD12);
+		bf_set(wqe_ebde_cnt, &wqe->fcp_tsend.wqe_com, 0);
+		bf_set(wqe_xc, &wqe->fcp_tsend.wqe_com, xc);
+
+		/* Word 11 */
+		bf_set(wqe_cqid, &wqe->fcp_tsend.wqe_com,
+		       LPFC_WQE_CQ_ID_DEFAULT);
+		bf_set(wqe_cmd_type, &wqe->fcp_tsend.wqe_com,
+		       FCP_COMMAND_TSEND);
+
+		/* Word 12 */
+		wqe->fcp_tsend.fcp_data_len = rsp->transfer_length;
+
+		/* Setup 2 SKIP SGEs */
+		sgl->addr_hi = 0;
+		sgl->addr_lo = 0;
+		sgl->word2 = 0;
+		bf_set(lpfc_sli4_sge_type, sgl, LPFC_SGE_TYPE_SKIP);
+		sgl->word2 = cpu_to_le32(sgl->word2);
+		sgl->sge_len = 0;
+		sgl++;
+		sgl->addr_hi = 0;
+		sgl->addr_lo = 0;
+		sgl->word2 = 0;
+		bf_set(lpfc_sli4_sge_type, sgl, LPFC_SGE_TYPE_SKIP);
+		sgl->word2 = cpu_to_le32(sgl->word2);
+		sgl->sge_len = 0;
+		sgl++;
+		if (rsp->op == NVMET_FCOP_READDATA_RSP) {
+			bf_set(wqe_wqes, &wqe->fcp_tsend.wqe_com, 1);
+			bf_set(wqe_ar, &wqe->fcp_tsend.wqe_com, 1);
+			bf_set(wqe_irsp, &wqe->fcp_tsend.wqe_com, 1);
+			bf_set(wqe_irsplen, &wqe->fcp_tsend,
+				(rsp->rsplen >> 2));
+			memcpy(&wqe->words[16], rsp->rspaddr, rsp->rsplen);
+		}
+		ctxp->state = LPFC_NVMET_STE_DATA;
+		break;
+
+	case NVMET_FCOP_WRITEDATA:
+		/* Words 0 - 2 : The first sg segment */
+		txrdy = pci_pool_alloc(phba->txrdy_payload_pool,
+				       GFP_KERNEL, &physaddr);
+		if (txrdy == NULL)
+			goto nvme_wqe_free_wqeq_exit;
+		ctxp->txrdy = txrdy;
+		ctxp->txrdy_phys = physaddr;
+		wqe->fcp_treceive.bde.tus.f.bdeFlags = BUFF_TYPE_BDE_64;
+		wqe->fcp_treceive.bde.tus.f.bdeSize = TXRDY_PAYLOAD_LEN;
+		wqe->fcp_treceive.bde.addrLow =
+			cpu_to_le32(putPaddrLow(physaddr));
+		wqe->fcp_treceive.bde.addrHigh =
+			cpu_to_le32(putPaddrHigh(physaddr));
+
+		/* Word 3 */
+		wqe->fcp_treceive.payload_offset_len = TXRDY_PAYLOAD_LEN;
+
+		/* Word 4 */
+		wqe->fcp_treceive.relative_offset = ctxp->offset;
+
+		/* Word 5 */
+
+		/* Word 6 */
+		bf_set(wqe_ctxt_tag, &wqe->fcp_treceive.wqe_com,
+		       phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);
+		bf_set(wqe_xri_tag, &wqe->fcp_treceive.wqe_com,
+		       nvmewqe->sli4_xritag);
+
+		/* Word 7 */
+		bf_set(wqe_ar, &wqe->fcp_treceive.wqe_com, 0); /* auto rsp */
+		bf_set(wqe_cmnd, &wqe->fcp_treceive.wqe_com,
+		       CMD_FCP_TRECEIVE64_WQE);
+		bf_set(wqe_ct, &wqe->fcp_treceive.wqe_com, SLI4_CT_RPI);
+		bf_set(wqe_class, &wqe->fcp_treceive.wqe_com, CLASS3);
+		bf_set(wqe_pu, &wqe->fcp_treceive.wqe_com, 1);
+
+		/* Word 8 */
+		wqe->fcp_treceive.wqe_com.abort_tag = nvmewqe->iotag;
+
+		/* Word 9 */
+		bf_set(wqe_reqtag, &wqe->fcp_treceive.wqe_com, nvmewqe->iotag);
+		bf_set(wqe_rcvoxid, &wqe->fcp_treceive.wqe_com, ctxp->oxid);
+
+		/* Word 10 */
+		bf_set(wqe_dbde, &wqe->fcp_treceive.wqe_com, 1);
+		bf_set(wqe_iod, &wqe->fcp_treceive.wqe_com, LPFC_WQE_IOD_READ);
+		bf_set(wqe_qosd, &wqe->fcp_treceive.wqe_com, 0);
+		bf_set(wqe_lenloc, &wqe->fcp_treceive.wqe_com,
+		       LPFC_WQE_LENLOC_WORD12);
+		bf_set(wqe_ebde_cnt, &wqe->fcp_treceive.wqe_com, 0);
+		bf_set(wqe_xc, &wqe->fcp_treceive.wqe_com, xc);
+
+		/* Word 11 */
+		bf_set(wqe_cqid, &wqe->fcp_treceive.wqe_com,
+		       LPFC_WQE_CQ_ID_DEFAULT);
+		bf_set(wqe_cmd_type, &wqe->fcp_treceive.wqe_com,
+		       FCP_COMMAND_TRECEIVE);
+
+		/* Word 12 */
+		wqe->fcp_tsend.fcp_data_len = rsp->transfer_length;
+
+		/* Setup 1 TXRDY and 1 SKIP SGE */
+		txrdy[0] = 0;
+		txrdy[1] = cpu_to_be32(rsp->transfer_length);
+		txrdy[2] = 0;
+
+		sgl->addr_hi = putPaddrHigh(physaddr);
+		sgl->addr_lo = putPaddrLow(physaddr);
+		sgl->word2 = 0;
+		bf_set(lpfc_sli4_sge_type, sgl, LPFC_SGE_TYPE_DATA);
+		sgl->word2 = cpu_to_le32(sgl->word2);
+		sgl->sge_len = cpu_to_le32(TXRDY_PAYLOAD_LEN);
+		sgl++;
+		sgl->addr_hi = 0;
+		sgl->addr_lo = 0;
+		sgl->word2 = 0;
+		bf_set(lpfc_sli4_sge_type, sgl, LPFC_SGE_TYPE_SKIP);
+		sgl->word2 = cpu_to_le32(sgl->word2);
+		sgl->sge_len = 0;
+		sgl++;
+		ctxp->state = LPFC_NVMET_STE_DATA;
+		break;
+
+	case NVMET_FCOP_RSP:
+		/* Words 0 - 2 */
+		sgel = &rsp->sg[0];
+		physaddr = rsp->rspdma;
+		wqe->fcp_trsp.bde.tus.f.bdeFlags = BUFF_TYPE_BDE_64;
+		wqe->fcp_trsp.bde.tus.f.bdeSize = rsp->rsplen;
+		wqe->fcp_trsp.bde.addrLow =
+			cpu_to_le32(putPaddrLow(physaddr));
+		wqe->fcp_trsp.bde.addrHigh =
+			cpu_to_le32(putPaddrHigh(physaddr));
+
+		/* Word 3 */
+		wqe->fcp_trsp.response_len = rsp->rsplen;
+
+		/* Word 4 */
+
+		/* Word 5 */
+
+		/* Word 6 */
+		bf_set(wqe_ctxt_tag, &wqe->fcp_trsp.wqe_com,
+		       phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);
+		bf_set(wqe_xri_tag, &wqe->fcp_trsp.wqe_com,
+		       nvmewqe->sli4_xritag);
+
+		/* Word 7 */
+		bf_set(wqe_ag, &wqe->fcp_trsp.wqe_com, 0); /* auto rsp */
+		bf_set(wqe_cmnd, &wqe->fcp_trsp.wqe_com, CMD_FCP_TRSP64_WQE);
+		bf_set(wqe_ct, &wqe->fcp_trsp.wqe_com, SLI4_CT_RPI);
+		bf_set(wqe_class, &wqe->fcp_trsp.wqe_com, CLASS3);
+		bf_set(wqe_pu, &wqe->fcp_trsp.wqe_com, 1);
+
+		/* Word 8 */
+		wqe->fcp_trsp.wqe_com.abort_tag = nvmewqe->iotag;
+
+		/* Word 9 */
+		bf_set(wqe_reqtag, &wqe->fcp_trsp.wqe_com, nvmewqe->iotag);
+		bf_set(wqe_rcvoxid, &wqe->fcp_trsp.wqe_com, ctxp->oxid);
+
+		/* Word 10 */
+		bf_set(wqe_dbde, &wqe->fcp_trsp.wqe_com, 0);
+		bf_set(wqe_iod, &wqe->fcp_trsp.wqe_com, LPFC_WQE_IOD_WRITE);
+		bf_set(wqe_qosd, &wqe->fcp_trsp.wqe_com, 0);
+		bf_set(wqe_lenloc, &wqe->fcp_trsp.wqe_com,
+		       LPFC_WQE_LENLOC_WORD3);
+		bf_set(wqe_ebde_cnt, &wqe->fcp_trsp.wqe_com, 0);
+		bf_set(wqe_xc, &wqe->fcp_trsp.wqe_com, xc);
+
+		/* Word 11 */
+		bf_set(wqe_cqid, &wqe->fcp_trsp.wqe_com,
+		       LPFC_WQE_CQ_ID_DEFAULT);
+		bf_set(wqe_cmd_type, &wqe->fcp_trsp.wqe_com,
+		       FCP_COMMAND_TRSP);
+		ctxp->state = LPFC_NVMET_STE_RSP;
+
+		/* Use rspbuf, NOT sg list */
+		rsp->sg_cnt = 0;
+		sgl->addr_hi = putPaddrHigh(physaddr);
+		sgl->addr_lo = putPaddrLow(physaddr);
+		sgl->word2 = 0;
+		bf_set(lpfc_sli4_sge_type, sgl, LPFC_SGE_TYPE_DATA);
+		sgl->word2 = cpu_to_le32(sgl->word2);
+		sgl->sge_len = cpu_to_le32(rsp->rsplen);
+		sgl++;
+		break;
+
+	default:
+		lpfc_printf_log(phba, KERN_INFO, LOG_NVME,
+				"6064 Unknown Rsp Op %d\n",
+				rsp->op);
+		goto nvme_wqe_free_wqeq_exit;
+	}
+
+	nvmewqe->retry = 1;
+	nvmewqe->vport = phba->pport;
+	nvmewqe->drvrTimeout = (phba->fc_ratov * 3) + LPFC_DRVR_TIMEOUT;
+	nvmewqe->context1 = ndlp;
+	nvmewqe->hba_wqidx = 0;
+
+	for (i = 0; i < rsp->sg_cnt; i++) {
+		sgel = &rsp->sg[i];
+		physaddr = sg_dma_address(sgel);
+		cnt = sg_dma_len(sgel);
+		sgl->addr_hi = putPaddrHigh(physaddr);
+		sgl->addr_lo = putPaddrLow(physaddr);
+		sgl->word2 = 0;
+		bf_set(lpfc_sli4_sge_type, sgl, LPFC_SGE_TYPE_DATA);
+		bf_set(lpfc_sli4_sge_offset, sgl, ctxp->offset);
+		if ((i+1) == rsp->sg_cnt)
+			bf_set(lpfc_sli4_sge_last, sgl, 1);
+		sgl->word2 = cpu_to_le32(sgl->word2);
+		sgl->sge_len = cpu_to_le32(cnt);
+		sgl++;
+		ctxp->offset += cnt;
+	}
+
+	/* Xmit NVME response to remote NPORT <did> */
+	lpfc_printf_log(phba, KERN_INFO, LOG_NVME,
+			"6041 NVME FCP cmd to remote "
+			"NPORT x%x iotag:x%x xri:x%x size:x%x "
+			"bpls:%d/%d\n",
+			ndlp->nlp_DID, nvmewqe->iotag, ctxp->oxid,
+			rsp->transfer_length, nvmewqe->rsvd2,
+			rsp->sg_cnt);
+	return nvmewqe;
+
+nvme_wqe_free_wqeq_exit:
+	ctxp->wqeq = NULL;
+	return NULL;
+}
+
+/**
+ * lpfc_nvmet_xmt_abort_cmp - Completion handler for ABTS
+ * @phba: Pointer to HBA context object.
+ * @cmdwqe: Pointer to driver command WQE object.
+ * @wcqe: Pointer to driver response CQE object.
+ *
+ * The function is called from SLI ring event handler with no
+ * lock held. This function is the completion handler for NVME ABTS commands
+ * The function frees memory resources used for the NVME commands.
+ **/
+static void
+lpfc_nvmet_xmt_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
+			  struct lpfc_wcqe_complete *wcqe)
+{
+	struct lpfc_nvmet_rcv_ctx *ctxp;
+	struct nvmefc_tgt_fcp_req *rsp;
+	struct lpfc_nvmet_tgtport *tgtp;
+	uint32_t status, result;
+
+	ctxp = cmdwqe->context2;
+	status = bf_get(lpfc_wcqe_c_status, wcqe);
+	result = wcqe->parameter;
+
+	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
+	tgtp->xmt_abort_cmpl++;
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_NVME,
+			"6070 %s: Entrypoint: ctx %p status %x/%x\n",
+			__func__, ctxp, status, result);
+
+	if (ctxp) {
+		/* Sanity check */
+		if (ctxp->state != LPFC_NVMET_STE_ABORT) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
+					"9999 Wrong state %s: %d  cnt %d\n",
+					__func__, ctxp->state, ctxp->entry_cnt);
+			return;
+		}
+		ctxp->state = LPFC_NVMET_STE_DONE;
+		rsp = &ctxp->ctx.fcp_req;
+		rsp->fcp_error = NVME_SC_SUCCESS;
+		rsp->transferred_length = 0;
+		rsp->done(rsp);
+		if (ctxp->txrdy) {
+			pci_pool_free(phba->txrdy_payload_pool, ctxp->txrdy,
+				      ctxp->txrdy_phys);
+			ctxp->txrdy = NULL;
+			ctxp->txrdy_phys = 0;
+		}
+		kfree(ctxp);
+		cmdwqe->context2 = NULL;
+		cmdwqe->context3 = NULL;
+		lpfc_sli_release_iocbq(phba, cmdwqe);
+	} else
+		lpfc_sli_release_iocbq(phba, cmdwqe);
+}
+
+static int
+lpfc_nvmet_unsol_issue_abort(struct lpfc_hba *phba,
+			     struct lpfc_nvmet_rcv_ctx *ctxp,
+			     uint32_t sid, uint16_t xri)
+{
+	struct lpfc_nvmet_tgtport *tgtp;
+	struct lpfc_iocbq *abts_wqeq;
+	union lpfc_wqe *wqe_abts;
+	struct lpfc_nodelist *ndlp;
+	int rc, ring;
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_NVME,
+			"6067 %s: Entrypoint: sid %x xri %x\n", __func__,
+			sid, xri);
+
+	ndlp = lpfc_findnode_did(phba->pport, sid);
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp) ||
+	    ((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
+	    (ndlp->nlp_state != NLP_STE_MAPPED_NODE)))
+		return -ERANGE;
+
+	if (ctxp && ctxp->wqeq) {
+		abts_wqeq = ctxp->wqeq;
+		ring = LPFC_FCP_RING;
+	} else {
+		/* Issue ABTS for this WQE based on iotag */
+		abts_wqeq = lpfc_sli_get_iocbq(phba);
+		if (abts_wqeq == NULL) {
+			lpfc_printf_log(phba, KERN_WARNING, LOG_NVME,
+					"6068 Abort failed: No wqeqs: "
+					"xri: x%x\n", xri);
+			return -ENOMEM;
+		}
+		ring = LPFC_ELS_RING;
+	}
+	wqe_abts = &abts_wqeq->wqe;
+	memset(wqe_abts, 0, sizeof(union lpfc_wqe));
+
+	/* Word 5 */
+	bf_set(wqe_dfctl, &wqe_abts->xmit_sequence.wge_ctl, 0);
+	bf_set(wqe_ls, &wqe_abts->xmit_sequence.wge_ctl, 1);
+	bf_set(wqe_la, &wqe_abts->xmit_sequence.wge_ctl, 0);
+	bf_set(wqe_rctl, &wqe_abts->xmit_sequence.wge_ctl, LPFC_RCTL_ABTS);
+	bf_set(wqe_type, &wqe_abts->xmit_sequence.wge_ctl, LPFC_FC4_TYPE_BLS);
+
+	/* Word 6 */
+	bf_set(wqe_ctxt_tag, &wqe_abts->xmit_sequence.wqe_com,
+	       phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);
+	bf_set(wqe_xri_tag, &wqe_abts->xmit_sequence.wqe_com,
+	       abts_wqeq->sli4_xritag);
+
+	/* Word 7 */
+	bf_set(wqe_cmnd, &wqe_abts->xmit_sequence.wqe_com,
+	       CMD_XMIT_SEQUENCE64_WQE);
+	bf_set(wqe_ct, &wqe_abts->xmit_sequence.wqe_com, SLI4_CT_RPI);
+	bf_set(wqe_class, &wqe_abts->xmit_sequence.wqe_com, CLASS3);
+	bf_set(wqe_pu, &wqe_abts->xmit_sequence.wqe_com, 0);
+
+	/* Word 8 */
+	wqe_abts->xmit_sequence.wqe_com.abort_tag = abts_wqeq->iotag;
+
+	/* Word 9 */
+	bf_set(wqe_reqtag, &wqe_abts->xmit_sequence.wqe_com, abts_wqeq->iotag);
+	/* Needs to be set by caller */
+	bf_set(wqe_rcvoxid, &wqe_abts->xmit_sequence.wqe_com, xri);
+
+	/* Word 10 */
+	bf_set(wqe_dbde, &wqe_abts->xmit_sequence.wqe_com, 1);
+	bf_set(wqe_iod, &wqe_abts->xmit_sequence.wqe_com, LPFC_WQE_IOD_WRITE);
+	bf_set(wqe_lenloc, &wqe_abts->xmit_sequence.wqe_com,
+	       LPFC_WQE_LENLOC_WORD12);
+	bf_set(wqe_ebde_cnt, &wqe_abts->xmit_sequence.wqe_com, 0);
+
+	/* Word 11 */
+	bf_set(wqe_cqid, &wqe_abts->xmit_sequence.wqe_com,
+	       LPFC_WQE_CQ_ID_DEFAULT);
+	bf_set(wqe_cmd_type, &wqe_abts->xmit_sequence.wqe_com,
+	       OTHER_COMMAND);
+
+	abts_wqeq->vport = phba->pport;
+	abts_wqeq->context1 = ndlp;
+	abts_wqeq->context2 = ctxp;
+	abts_wqeq->context3 = NULL;
+	abts_wqeq->rsvd2 = 0;
+	abts_wqeq->hba_wqidx = 0;
+	abts_wqeq->iocb.ulpCommand = CMD_XMIT_SEQUENCE64_CR;
+	abts_wqeq->iocb.ulpLe = 1;
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_NVME,
+			"6069 Issue ABTS to xri x%x reqtag x%x\n",
+			xri, abts_wqeq->iotag);
+
+
+	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
+
+	abts_wqeq->wqe_cmpl = lpfc_nvmet_xmt_abort_cmp;
+	abts_wqeq->iocb_cmpl = (void *)lpfc_nvmet_xmt_abort_cmp;
+	rc = lpfc_sli_issue_wqe(phba, ring, abts_wqeq);
+	if (rc == WQE_SUCCESS) {
+		tgtp->xmt_abort_rsp++;
+		return 0;
+	}
+
+	tgtp->xmt_abort_rsp_error++;
+	lpfc_sli_release_iocbq(phba, abts_wqeq);
+	return -ENXIO;
+}
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.h b/drivers/scsi/lpfc/lpfc_nvmet.h
new file mode 100644
index 0000000..963b715
--- /dev/null
+++ b/drivers/scsi/lpfc/lpfc_nvmet.h
@@ -0,0 +1,72 @@
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
+#define LPFC_MAX_NQN_SZ	256
+
+/* Used for NVME Target */
+struct lpfc_nvmet_tgtport {
+	struct lpfc_hba *phba;
+	enum nvme_state nvmet_state;
+
+	/* Stats counters */
+	uint32_t rcv_ls_req;
+	uint32_t rcv_ls_drop;
+	uint32_t xmt_ls_rsp;
+	uint32_t xmt_ls_drop;
+	uint32_t xmt_ls_rsp_error;
+	uint32_t xmt_ls_rsp_cmpl;
+
+	uint32_t rcv_fcp_cmd;
+	uint32_t rcv_fcp_drop;
+	uint32_t xmt_fcp_rsp_cmpl;
+	uint32_t xmt_fcp_rsp;
+	uint32_t xmt_fcp_drop;
+	uint32_t xmt_fcp_rsp_error;
+
+	uint32_t xmt_abort_rsp;
+	uint32_t xmt_abort_cmpl;
+	uint32_t xmt_abort_rsp_error;
+};
+
+struct lpfc_nvmet_rcv_ctx {
+	union {
+		struct nvmefc_tgt_ls_req ls_req;
+		struct nvmefc_tgt_fcp_req fcp_req;
+	} ctx;
+	struct lpfc_hba *phba;
+	struct lpfc_iocbq *wqeq;
+	dma_addr_t txrdy_phys;
+	uint32_t *txrdy;
+	uint32_t sid;
+	uint32_t offset;
+	uint16_t oxid;
+	uint16_t size;
+	uint16_t entry_cnt;
+	uint16_t state;
+	struct hbq_dmabuf *hbq_buffer;
+/* States */
+#define LPFC_NVMET_STE_RCV		1
+#define LPFC_NVMET_STE_DATA		2
+#define LPFC_NVMET_STE_ABORT		3
+#define LPFC_NVMET_STE_RSP		4
+#define LPFC_NVMET_STE_DONE		5
+};
+
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index fb0e604..cb4f11f 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -34,6 +34,8 @@
 #include <scsi/fc/fc_fs.h>
 #include <linux/aer.h>
 
+#include <linux/nvme-fc-driver.h>
+
 #include "lpfc_hw4.h"
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
@@ -41,6 +43,8 @@
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
+#include "lpfc_nvme.h"
+#include "lpfc_nvmet.h"
 #include "lpfc.h"
 #include "lpfc_crtn.h"
 #include "lpfc_logmsg.h"
@@ -1819,8 +1823,20 @@ lpfc_sli_hbq_to_firmware_s4(struct lpfc_hba *phba, uint32_t hbqno,
 	struct lpfc_queue *hrq;
 	struct lpfc_queue *drq;
 
-	hrq = phba->sli4_hba.hdr_rq;
-	drq = phba->sli4_hba.dat_rq;
+	if (phba->cfg_enable_nvmet == NVME_TARGET_OFF) {
+		if (hbqno == LPFC_NVMET_HBQ)
+			return 0;
+		hrq = phba->sli4_hba.hdr_rq;
+		drq = phba->sli4_hba.dat_rq;
+	} else {
+		if (hbqno == LPFC_NVMET_HBQ) {
+			hrq = phba->sli4_hba.nvmet_hdr_rq;
+			drq = phba->sli4_hba.nvmet_dat_rq;
+		} else {
+			hrq = phba->sli4_hba.hdr_rq;
+			drq = phba->sli4_hba.dat_rq;
+		}
+	}
 
 	lockdep_assert_held(&phba->hbalock);
 	hrqe.address_lo = putPaddrLow(hbq_buf->hbuf.phys);
@@ -1847,9 +1863,22 @@ static struct lpfc_hbq_init lpfc_els_hbq = {
 	.add_count = 40,
 };
 
+/* HBQ for the NVMET ring if needed */
+static struct lpfc_hbq_init lpfc_nvmet_hbq = {
+	.rn = 1,
+	.entry_count = 128,
+	.mask_count = 0,
+	.profile = 0,
+	.ring_mask = (1 << LPFC_EXTRA_RING),
+	.buffer_count = 0,
+	.init_count = 40,
+	.add_count = 40,
+};
+
 /* Array of HBQs */
 struct lpfc_hbq_init *lpfc_hbq_defs[] = {
 	&lpfc_els_hbq,
+	&lpfc_nvmet_hbq,
 };
 
 /**
@@ -2438,8 +2467,8 @@ lpfc_complete_unsol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 	switch (fch_type) {
 	case LPFC_FC4_TYPE_NVME:
-		/* TODO: handle FC-4 LS requests */
-		/* fall-thru for failure */
+		lpfc_nvmet_unsol_ls_event(phba, pring, saveq);
+		return 1;
 	default:
 		break;
 	}
@@ -4364,6 +4393,8 @@ lpfc_sli_hbq_count(struct lpfc_hba *phba)
 	int i;
 
 	i = ARRAY_SIZE(lpfc_hbq_defs);
+	if (phba->cfg_enable_nvmet == phba->brd_no)
+		i--;
 	return i;
 }
 
@@ -4482,8 +4513,16 @@ lpfc_sli4_rb_setup(struct lpfc_hba *phba)
 	phba->hbq_in_use = 1;
 	phba->hbqs[LPFC_ELS_HBQ].entry_count =
 		lpfc_hbq_defs[LPFC_ELS_HBQ]->entry_count;
-	phba->hbq_count = 1;
-	lpfc_sli_hbqbuf_init_hbqs(phba, LPFC_ELS_HBQ);
+	if (phba->cfg_enable_nvmet == phba->brd_no) {
+		phba->hbqs[LPFC_NVMET_HBQ].entry_count =
+			lpfc_hbq_defs[LPFC_NVMET_HBQ]->entry_count;
+		phba->hbq_count = 2;
+		lpfc_sli_hbqbuf_init_hbqs(phba, LPFC_ELS_HBQ);
+		lpfc_sli_hbqbuf_init_hbqs(phba, LPFC_NVMET_HBQ);
+	} else {
+		phba->hbq_count = 1;
+		lpfc_sli_hbqbuf_init_hbqs(phba, LPFC_ELS_HBQ);
+	}
 	/* Initially populate or replenish the HBQs */
 	return 0;
 }
@@ -5124,6 +5163,9 @@ lpfc_sli4_arm_cqeq_intr(struct lpfc_hba *phba)
 					     LPFC_QUEUE_REARM);
 	}
 
+	if (phba->cfg_enable_nvmet == phba->brd_no)
+		lpfc_sli4_cq_release(phba->sli4_hba.nvmet_cq, LPFC_QUEUE_REARM);
+
 	if (phba->cfg_fof)
 		lpfc_sli4_eq_release(phba->sli4_hba.fof_eq, LPFC_QUEUE_REARM);
 }
@@ -12459,6 +12501,95 @@ lpfc_sli4_fp_handle_rel_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 				"miss-matched qid: wcqe-qid=x%x\n", hba_wqid);
 }
 
+/**
+ * lpfc_sli4_nvmet_handle_rcqe - Process a receive-queue completion queue entry
+ * @phba: Pointer to HBA context object.
+ * @rcqe: Pointer to receive-queue completion queue entry.
+ *
+ * This routine process a receive-queue completion queue entry.
+ *
+ * Return: true if work posted to worker thread, otherwise false.
+ **/
+static bool
+lpfc_sli4_nvmet_handle_rcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
+			    struct lpfc_rcqe *rcqe)
+{
+	bool workposted = false;
+	struct lpfc_queue *hrq = phba->sli4_hba.nvmet_hdr_rq;
+	struct lpfc_queue *drq = phba->sli4_hba.nvmet_dat_rq;
+	struct hbq_dmabuf *dma_buf;
+	struct fc_frame_header *fc_hdr;
+	uint32_t status, rq_id;
+	unsigned long iflags;
+	uint32_t fctl;
+
+	/* sanity check on queue memory */
+	if (unlikely(!hrq) || unlikely(!drq))
+		return workposted;
+
+	if (bf_get(lpfc_cqe_code, rcqe) == CQE_CODE_RECEIVE_V1)
+		rq_id = bf_get(lpfc_rcqe_rq_id_v1, rcqe);
+	else
+		rq_id = bf_get(lpfc_rcqe_rq_id, rcqe);
+
+	if ((phba->cfg_enable_nvmet == NVME_TARGET_OFF) ||
+	    (rq_id != hrq->queue_id))
+		return workposted;
+
+	status = bf_get(lpfc_rcqe_status, rcqe);
+	switch (status) {
+	case FC_STATUS_RQ_BUF_LEN_EXCEEDED:
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2537 Receive Frame Truncated!!\n");
+		hrq->RQ_buf_trunc++;
+		break;
+	case FC_STATUS_RQ_SUCCESS:
+		lpfc_sli4_rq_release(hrq, drq);
+		spin_lock_irqsave(&phba->hbalock, iflags);
+		dma_buf = lpfc_sli_hbqbuf_get(
+			&phba->hbqs[LPFC_NVMET_HBQ].hbq_buffer_list);
+		if (!dma_buf) {
+			hrq->RQ_no_buf_found++;
+			spin_unlock_irqrestore(&phba->hbalock, iflags);
+			goto out;
+		}
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+
+		hrq->RQ_rcv_buf++;
+		fc_hdr = (struct fc_frame_header *)dma_buf->hbuf.virt;
+
+		/* Just some basic sanity checks on FCP Command frame */
+		fctl = (fc_hdr->fh_f_ctl[0] << 16 |
+		fc_hdr->fh_f_ctl[1] << 8 |
+		fc_hdr->fh_f_ctl[2]);
+		if (((fctl &
+		    (FC_FC_FIRST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT)) !=
+		    (FC_FC_FIRST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT)) ||
+		    (fc_hdr->fh_seq_cnt != 0)) /* 0 byte swapped is still 0 */
+			goto drop;
+
+		if (fc_hdr->fh_type == LPFC_FC4_TYPE_FCP) {
+			dma_buf->bytes_recv = bf_get(lpfc_rcqe_length,  rcqe);
+			lpfc_nvmet_unsol_fcp_event(
+				phba, &phba->sli.ring[LPFC_ELS_RING], dma_buf);
+			return false;
+		}
+drop:
+		lpfc_in_buf_free(phba, &dma_buf->dbuf);
+		break;
+	case FC_STATUS_INSUFF_BUF_NEED_BUF:
+	case FC_STATUS_INSUFF_BUF_FRM_DISC:
+		hrq->RQ_no_posted_buf++;
+		/* Post more buffers if possible */
+		spin_lock_irqsave(&phba->hbalock, iflags);
+		phba->hba_flag |= HBA_POST_RECEIVE_BUFFER;
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+		workposted = true;
+		break;
+	}
+out:
+	return workposted;
+}
 
 /**
  * lpfc_sli4_fp_handle_cqe - Process fast-path work queue completion entry
@@ -12509,8 +12640,8 @@ lpfc_sli4_fp_handle_cqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	case CQE_CODE_RECEIVE:
 		phba->last_completion_time = jiffies;
 		if (cq->subtype == LPFC_NVMET) {
-			/* TODO: handle nvme tgt receive frames */
-			workposted = false;
+			workposted = lpfc_sli4_nvmet_handle_rcqe(
+				phba, cq, (struct lpfc_rcqe *)&wcqe);
 		}
 		break;
 	default:
@@ -12556,6 +12687,13 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 	/* Get the reference to the corresponding CQ */
 	cqid = bf_get_le32(lpfc_eqe_resource_id, eqe);
 
+	if (phba->sli4_hba.nvmet_cq &&
+	    (cqid == phba->sli4_hba.nvmet_cq->queue_id)) {
+		/* Process NVMET unsol rcv */
+		cq = phba->sli4_hba.nvmet_cq;
+		goto  process_cq;
+	}
+
 	if (phba->sli4_hba.nvme_cq_map &&
 	    (cqid == phba->sli4_hba.nvme_cq_map[qidx])) {
 		/* Process NVME / NVMET command completion */
@@ -17521,6 +17659,7 @@ lpfc_sli_issue_wqe(struct lpfc_hba *phba, uint32_t ring_number,
 		    struct lpfc_iocbq *pwqe)
 {
 	union lpfc_wqe *wqe = &pwqe->wqe;
+	struct lpfc_nvmet_rcv_ctx *ctxp;
 	struct lpfc_queue *wq;
 	struct lpfc_sglq *sglq;
 	struct lpfc_sli_ring *pring;
@@ -17567,5 +17706,31 @@ lpfc_sli_issue_wqe(struct lpfc_hba *phba, uint32_t ring_number,
 		spin_unlock_irqrestore(&pring->ring_lock, iflags);
 		return 0;
 	}
+	if (pwqe->iocb_flag & LPFC_IO_NVMET) {
+		/* hard code io_channel 0 for now */
+		pwqe->hba_wqidx = 0;
+		ring_number = MAX_SLI3_CONFIGURED_RINGS + pwqe->hba_wqidx;
+		pring = &phba->sli.ring[ring_number];
+
+		spin_lock_irqsave(&pring->ring_lock, iflags);
+		ctxp = pwqe->context2;
+		sglq = ctxp->hbq_buffer->sglq;
+		if (pwqe->sli4_xritag ==  NO_XRI) {
+			pwqe->sli4_lxritag = sglq->sli4_lxritag;
+			pwqe->sli4_xritag = sglq->sli4_xritag;
+		}
+		bf_set(wqe_xri_tag, &pwqe->wqe.xmit_bls_rsp.wqe_com,
+		       pwqe->sli4_xritag);
+		wq = phba->sli4_hba.hba_wq[pwqe->hba_wqidx];
+		bf_set(wqe_cqid, &wqe->generic.wqe_com,
+		      phba->sli4_hba.nvme_cq[pwqe->hba_wqidx]->queue_id);
+		if (lpfc_sli4_wq_put(wq, wqe)) {
+			spin_unlock_irqrestore(&pring->ring_lock, iflags);
+			return WQE_ERROR;
+		}
+		lpfc_sli_ringtxcmpl_put(phba, pring, pwqe);
+		spin_unlock_irqrestore(&pring->ring_lock, iflags);
+		return 0;
+	}
 	return WQE_ERROR;
 }
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 86da988..d5eef69 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -532,12 +532,15 @@ struct lpfc_sli4_hba {
 
 	struct lpfc_queue *mbx_cq; /* Slow-path mailbox complete queue */
 	struct lpfc_queue *els_cq; /* Slow-path ELS response complete queue */
+	struct lpfc_queue *nvmet_cq; /* NVMET unsol rcv complete queue */
 	struct lpfc_queue *nvmels_cq; /* NVMET LS complete queue */
 	struct lpfc_queue *mbx_wq; /* Slow-path MBOX work queue */
 	struct lpfc_queue *els_wq; /* Slow-path ELS work queue */
 	struct lpfc_queue *nvmels_wq; /* NVME LS work queue */
 	struct lpfc_queue *hdr_rq; /* Slow-path Header Receive queue */
 	struct lpfc_queue *dat_rq; /* Slow-path Data Receive queue */
+	struct lpfc_queue *nvmet_hdr_rq; /* NVME Header Receive queue */
+	struct lpfc_queue *nvmet_dat_rq; /* NVME Data Receive queue */
 
 	uint32_t fw_func_mode;	/* FW function protocol mode */
 	uint32_t ulp0_mode;	/* ULP0 protocol mode */
diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index c9bf20e..b0b4a6f 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "11.2.0.0."
+#define LPFC_DRIVER_VERSION "11.2.0.1"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.5.0

