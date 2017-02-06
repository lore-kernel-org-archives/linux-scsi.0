From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 12/18] lpfc: NVME Target: Base modifications
Date: Mon, 06 Feb 2017 15:09:01 -0800
Message-ID: <5899020d.lpWul6+nY/4L1PSm%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34033 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751372AbdBFXJI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 18:09:08 -0500
Received: by mail-wm0-f66.google.com with SMTP id c85so24972922wmi.1
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 15:09:07 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org


NVME Target: Base modifications

This set of patches adds the base modifications for NVME target support
to the lpfc driver.

The base modifications consist of:
- Additional module parameters or configuration tuning
- Enablement of configuration mode for NVME target. Ties into the
  queueing model put into place by the initiator basemods patches.
- Target-specific buffer pools, dma pools, sgl pools

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
Modifications in V2:
 Sync with max_hw_queues/io_channel/io_channel_irqs change

 drivers/scsi/lpfc/lpfc.h         |   5 +
 drivers/scsi/lpfc/lpfc_attr.c    | 120 +++++++++++++++++--
 drivers/scsi/lpfc/lpfc_crtn.h    |  10 ++
 drivers/scsi/lpfc/lpfc_debugfs.c |   7 +-
 drivers/scsi/lpfc/lpfc_init.c    | 241 +++++++++++++++++++++++++++++++++++++--
 drivers/scsi/lpfc/lpfc_mem.c     | 167 +++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_nvmet.h   | 102 +++++++++++++++++
 drivers/scsi/lpfc/lpfc_sli.c     | 107 ++++++++++++++++-
 drivers/scsi/lpfc/lpfc_sli.h     |   1 +
 drivers/scsi/lpfc/lpfc_sli4.h    |   6 +
 10 files changed, 746 insertions(+), 20 deletions(-)
 create mode 100644 drivers/scsi/lpfc/lpfc_nvmet.h

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 03e2703..c5208e2 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -741,6 +741,7 @@ struct lpfc_hba {
 	uint8_t  fcp_embed_io;
 	uint8_t  nvme_support;	/* Firmware supports NVME */
 	uint8_t  nvmet_support;	/* driver supports NVMET */
+#define LPFC_NVMET_MAX_PORTS	32
 	uint8_t  mds_diags_support;
 
 	/* HBA Config Parameters */
@@ -769,6 +770,7 @@ struct lpfc_hba {
 	uint32_t cfg_suppress_rsp;
 	uint32_t cfg_nvme_oas;
 	uint32_t cfg_nvme_io_channel;
+	uint32_t cfg_enable_nvmet;
 	uint32_t cfg_nvme_posted_buf;
 	uint32_t cfg_nvme_enable_fb;
 	uint32_t cfg_total_seg_cnt;
@@ -822,6 +824,7 @@ struct lpfc_hba {
 #define LPFC_ENABLE_NVME 2
 #define LPFC_ENABLE_BOTH 3
 	uint32_t io_channel_irqs;	/* number of irqs for io channels */
+	struct nvmet_fc_target_port *targetport;
 	lpfc_vpd_t vpd;		/* vital product data */
 
 	struct pci_dev *pcidev;
@@ -1097,6 +1100,8 @@ struct lpfc_hba {
 	uint16_t cpucheck_on;
 #define LPFC_CHECK_OFF		0
 #define LPFC_CHECK_NVME_IO	1
+#define LPFC_CHECK_NVMET_RCV	2
+#define LPFC_CHECK_NVMET_IO	4
 	uint16_t ktime_on;
 	uint64_t ktime_data_samples;
 	uint64_t ktime_status_samples;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 2fec637..8058484 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -46,6 +46,7 @@
 #include "lpfc.h"
 #include "lpfc_scsi.h"
 #include "lpfc_nvme.h"
+#include "lpfc_nvmet.h"
 #include "lpfc_logmsg.h"
 #include "lpfc_version.h"
 #include "lpfc_compat.h"
@@ -139,6 +140,7 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct lpfc_vport *vport = shost_priv(shost);
 	struct lpfc_hba   *phba = vport->phba;
+	struct lpfc_nvmet_tgtport *tgtp;
 	struct nvme_fc_local_port *localport;
 	struct lpfc_nvme_lport *lport;
 	struct lpfc_nvme_rport *rport;
@@ -150,6 +152,92 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 		len += snprintf(buf, PAGE_SIZE, "NVME Disabled\n");
 		return len;
 	}
+	if (phba->nvmet_support) {
+		if (!phba->targetport) {
+			len = snprintf(buf, PAGE_SIZE,
+					"NVME Target: x%llx is not allocated\n",
+					wwn_to_u64(vport->fc_portname.u.wwn));
+			return len;
+		}
+		/* Port state is only one of two values for now. */
+		if (phba->targetport->port_id)
+			statep = "REGISTERED";
+		else
+			statep = "INIT";
+		len += snprintf(buf + len, PAGE_SIZE - len,
+				"NVME Target: Enabled  State %s\n",
+				statep);
+		len += snprintf(buf + len, PAGE_SIZE - len,
+				"%s%d WWPN x%llx WWNN x%llx DID x%06x\n",
+				"NVME Target: lpfc",
+				phba->brd_no,
+				wwn_to_u64(vport->fc_portname.u.wwn),
+				wwn_to_u64(vport->fc_nodename.u.wwn),
+				phba->targetport->port_id);
+
+		len += snprintf(buf + len, PAGE_SIZE,
+				"\nNVME Target: Statistics\n");
+		tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
+		len += snprintf(buf+len, PAGE_SIZE-len,
+				"LS: Rcv %08x Drop %08x Abort %08x\n",
+				atomic_read(&tgtp->rcv_ls_req_in),
+				atomic_read(&tgtp->rcv_ls_req_drop),
+				atomic_read(&tgtp->xmt_ls_abort));
+		if (atomic_read(&tgtp->rcv_ls_req_in) !=
+		    atomic_read(&tgtp->rcv_ls_req_out)) {
+			len += snprintf(buf+len, PAGE_SIZE-len,
+					"Rcv LS: in %08x != out %08x\n",
+					atomic_read(&tgtp->rcv_ls_req_in),
+					atomic_read(&tgtp->rcv_ls_req_out));
+		}
+
+		len += snprintf(buf+len, PAGE_SIZE-len,
+				"LS: Xmt %08x Drop %08x Cmpl %08x Err %08x\n",
+				atomic_read(&tgtp->xmt_ls_rsp),
+				atomic_read(&tgtp->xmt_ls_drop),
+				atomic_read(&tgtp->xmt_ls_rsp_cmpl),
+				atomic_read(&tgtp->xmt_ls_rsp_error));
+
+		len += snprintf(buf+len, PAGE_SIZE-len,
+				"FCP: Rcv %08x Drop %08x\n",
+				atomic_read(&tgtp->rcv_fcp_cmd_in),
+				atomic_read(&tgtp->rcv_fcp_cmd_drop));
+
+		if (atomic_read(&tgtp->rcv_fcp_cmd_in) !=
+		    atomic_read(&tgtp->rcv_fcp_cmd_out)) {
+			len += snprintf(buf+len, PAGE_SIZE-len,
+					"Rcv FCP: in %08x != out %08x\n",
+					atomic_read(&tgtp->rcv_fcp_cmd_in),
+					atomic_read(&tgtp->rcv_fcp_cmd_out));
+		}
+
+		len += snprintf(buf+len, PAGE_SIZE-len,
+				"FCP Rsp: RD %08x rsp %08x WR %08x rsp %08x\n",
+				atomic_read(&tgtp->xmt_fcp_read),
+				atomic_read(&tgtp->xmt_fcp_read_rsp),
+				atomic_read(&tgtp->xmt_fcp_write),
+				atomic_read(&tgtp->xmt_fcp_rsp));
+
+		len += snprintf(buf+len, PAGE_SIZE-len,
+				"FCP Rsp: abort %08x drop %08x\n",
+				atomic_read(&tgtp->xmt_fcp_abort),
+				atomic_read(&tgtp->xmt_fcp_drop));
+
+		len += snprintf(buf+len, PAGE_SIZE-len,
+				"FCP Rsp Cmpl: %08x err %08x drop %08x\n",
+				atomic_read(&tgtp->xmt_fcp_rsp_cmpl),
+				atomic_read(&tgtp->xmt_fcp_rsp_error),
+				atomic_read(&tgtp->xmt_fcp_rsp_drop));
+
+		len += snprintf(buf+len, PAGE_SIZE-len,
+				"ABORT: Xmt %08x Err %08x Cmpl %08x",
+				atomic_read(&tgtp->xmt_abort_rsp),
+				atomic_read(&tgtp->xmt_abort_rsp_error),
+				atomic_read(&tgtp->xmt_abort_cmpl));
+
+		len +=  snprintf(buf+len, PAGE_SIZE-len, "\n");
+		return len;
+	}
 
 	localport = vport->localport;
 	if (!localport) {
@@ -2899,6 +2987,13 @@ lpfc_oas_lun_store(struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR(lpfc_xlane_lun, S_IRUGO | S_IWUSR,
 		   lpfc_oas_lun_show, lpfc_oas_lun_store);
 
+int lpfc_enable_nvmet_cnt;
+unsigned long long lpfc_enable_nvmet[LPFC_NVMET_MAX_PORTS] = {
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
+module_param_array(lpfc_enable_nvmet, ullong, &lpfc_enable_nvmet_cnt, 0444);
+MODULE_PARM_DESC(lpfc_enable_nvmet, "Enable HBA port(s) WWPN as a NVME Target");
+
 static int lpfc_poll = 0;
 module_param(lpfc_poll, int, S_IRUGO);
 MODULE_PARM_DESC(lpfc_poll, "FCP ring polling mode control:"
@@ -3200,7 +3295,8 @@ LPFC_ATTR_R(enable_fc4_type, LPFC_ENABLE_FCP,
 /*
  * lpfc_xri_split: Defines the division of XRI resources between SCSI and NVME
  * This parameter is only used if:
- *     lpfc_enable_fc4_type is 3 - register both FCP and NVME
+ *     lpfc_enable_fc4_type is 3 - register both FCP and NVME and
+ *     port is not configured for NVMET.
  *
  * ELS/CT always get 10% of XRIs, up to a maximum of 250
  * The remaining XRIs get split up based on lpfc_xri_split per port:
@@ -4764,7 +4860,7 @@ LPFC_ATTR_R(use_msi, 2, 0, 2, "Use Message Signaled Interrupts (1) or "
 	    "MSI-X (2), if possible");
 
 /*
- * lpfc_nvme_oas: Use the oas bit when sending NVME IOs
+ * lpfc_nvme_oas: Use the oas bit when sending NVME/NVMET IOs
  *
  *      0  = NVME OAS disabled
  *      1  = NVME OAS enabled
@@ -6054,17 +6150,17 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	}
 
 	/* A value of 0 means use the number of CPUs found in the system */
-	if (phba->cfg_nvme_io_channel == 0)
-		phba->cfg_nvme_io_channel = phba->sli4_hba.num_present_cpu;
 	if (phba->cfg_fcp_io_channel == 0)
 		phba->cfg_fcp_io_channel = phba->sli4_hba.num_present_cpu;
-
-	if (phba->cfg_enable_fc4_type == LPFC_ENABLE_FCP)
-		phba->cfg_nvme_io_channel = 0;
+	if (phba->cfg_nvme_io_channel == 0)
+		phba->cfg_nvme_io_channel = phba->sli4_hba.num_present_cpu;
 
 	if (phba->cfg_enable_fc4_type == LPFC_ENABLE_NVME)
 		phba->cfg_fcp_io_channel = 0;
 
+	if (phba->cfg_enable_fc4_type == LPFC_ENABLE_FCP)
+		phba->cfg_nvme_io_channel = 0;
+
 	if (phba->cfg_fcp_io_channel > phba->cfg_nvme_io_channel)
 		phba->io_channel_irqs = phba->cfg_fcp_io_channel;
 	else
@@ -6096,12 +6192,20 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 void
 lpfc_nvme_mod_param_dep(struct lpfc_hba *phba)
 {
-	phba->nvmet_support = 0;
 	if (phba->cfg_nvme_io_channel > phba->sli4_hba.num_present_cpu)
 		phba->cfg_nvme_io_channel = phba->sli4_hba.num_present_cpu;
+
 	if (phba->cfg_fcp_io_channel > phba->sli4_hba.num_present_cpu)
 		phba->cfg_fcp_io_channel = phba->sli4_hba.num_present_cpu;
 
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME &&
+	    phba->nvmet_support) {
+		phba->cfg_enable_fc4_type &= ~LPFC_ENABLE_FCP;
+		phba->cfg_fcp_io_channel = 0;
+	} else
+		/* Not NVME Target mode.  Turn off Target parameters. */
+		phba->nvmet_support = 0;
+
 	if (phba->cfg_fcp_io_channel > phba->cfg_nvme_io_channel)
 		phba->io_channel_irqs = phba->cfg_fcp_io_channel;
 	else
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 2750f28..9f598e2 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -240,6 +240,8 @@ struct hbq_dmabuf *lpfc_els_hbq_alloc(struct lpfc_hba *);
 void lpfc_els_hbq_free(struct lpfc_hba *, struct hbq_dmabuf *);
 struct hbq_dmabuf *lpfc_sli4_rb_alloc(struct lpfc_hba *);
 void lpfc_sli4_rb_free(struct lpfc_hba *, struct hbq_dmabuf *);
+struct rqb_dmabuf *lpfc_sli4_nvmet_alloc(struct lpfc_hba *phba);
+void lpfc_sli4_nvmet_free(struct lpfc_hba *phba, struct rqb_dmabuf *dmab);
 void lpfc_sli4_build_dflt_fcf_record(struct lpfc_hba *, struct fcf_record *,
 			uint16_t);
 int lpfc_sli4_rq_put(struct lpfc_queue *hq, struct lpfc_queue *dq,
@@ -306,6 +308,8 @@ int lpfc_sli4_issue_wqe(struct lpfc_hba *phba, uint32_t rnum,
 struct lpfc_sglq *__lpfc_clear_active_sglq(struct lpfc_hba *phba, uint16_t xri);
 struct lpfc_sglq *__lpfc_sli_get_els_sglq(struct lpfc_hba *phba,
 					   struct lpfc_iocbq *iocbq);
+struct lpfc_sglq *__lpfc_sli_get_nvmet_sglq(struct lpfc_hba *phba,
+					    struct lpfc_iocbq *piocbq);
 void lpfc_sli_pcimem_bcopy(void *, void *, uint32_t);
 void lpfc_sli_bemem_bcopy(void *, void *, uint32_t);
 void lpfc_sli_abort_iocb_ring(struct lpfc_hba *, struct lpfc_sli_ring *);
@@ -355,6 +359,9 @@ void lpfc_sli_free_hbq(struct lpfc_hba *, struct hbq_dmabuf *);
 void *lpfc_mbuf_alloc(struct lpfc_hba *, int, dma_addr_t *);
 void __lpfc_mbuf_free(struct lpfc_hba *, void *, dma_addr_t);
 void lpfc_mbuf_free(struct lpfc_hba *, void *, dma_addr_t);
+void *lpfc_nvmet_buf_alloc(struct lpfc_hba *phba, int flags,
+			dma_addr_t *handle);
+void lpfc_nvmet_buf_free(struct lpfc_hba *phba, void *virtp, dma_addr_t dma);
 
 void lpfc_in_buf_free(struct lpfc_hba *, struct lpfc_dmabuf *);
 /* Function prototypes. */
@@ -493,6 +500,7 @@ int lpfc_selective_reset(struct lpfc_hba *);
 int lpfc_sli4_read_config(struct lpfc_hba *);
 void lpfc_sli4_node_prep(struct lpfc_hba *);
 int lpfc_sli4_els_sgl_update(struct lpfc_hba *phba);
+int lpfc_sli4_nvmet_sgl_update(struct lpfc_hba *phba);
 int lpfc_sli4_scsi_sgl_update(struct lpfc_hba *phba);
 int lpfc_sli4_nvme_sgl_update(struct lpfc_hba *phba);
 void lpfc_free_sgl_list(struct lpfc_hba *, struct list_head *);
@@ -539,3 +547,5 @@ void lpfc_nvme_mod_param_dep(struct lpfc_hba *phba);
 void lpfc_nvme_abort_fcreq_cmpl(struct lpfc_hba *phba,
 				struct lpfc_iocbq *cmdiocb,
 				struct lpfc_wcqe_complete *abts_cmpl);
+extern int lpfc_enable_nvmet_cnt;
+extern unsigned long long lpfc_enable_nvmet[];
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 566c0aa..f2525b3 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -821,7 +821,6 @@ lpfc_debugfs_nvmektime_data(struct lpfc_vport *vport, char *buf, int size)
 			phba->ktime_data_samples));
 		return len;
 	}
-
 	return len;
 }
 
@@ -1707,7 +1706,11 @@ lpfc_debugfs_cpucheck_write(struct file *file, const char __user *buf,
 		return strlen(pbuf);
 	} else if ((strncmp(pbuf, "rcv",
 		   sizeof("rcv") - 1) == 0)) {
-		return -EINVAL;
+		if (phba->nvmet_support)
+			phba->cpucheck_on |= LPFC_CHECK_NVMET_RCV;
+		else
+			return -EINVAL;
+		return strlen(pbuf);
 	} else if ((strncmp(pbuf, "off",
 		   sizeof("off") - 1) == 0)) {
 		phba->cpucheck_on = LPFC_CHECK_OFF;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index ead032c..eaa10e2 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -73,6 +73,7 @@ static int lpfc_create_bootstrap_mbox(struct lpfc_hba *);
 static int lpfc_setup_endian_order(struct lpfc_hba *);
 static void lpfc_destroy_bootstrap_mbox(struct lpfc_hba *);
 static void lpfc_free_els_sgl_list(struct lpfc_hba *);
+static void lpfc_free_nvmet_sgl_list(struct lpfc_hba *);
 static void lpfc_init_sgl_list(struct lpfc_hba *);
 static int lpfc_init_active_sgl_array(struct lpfc_hba *);
 static void lpfc_free_active_sgl(struct lpfc_hba *);
@@ -88,6 +89,7 @@ static void lpfc_sli4_oas_verify(struct lpfc_hba *phba);
 static struct scsi_transport_template *lpfc_transport_template = NULL;
 static struct scsi_transport_template *lpfc_vport_transport_template = NULL;
 static DEFINE_IDR(lpfc_hba_index);
+#define LPFC_NVMET_BUF_POST 254
 
 
 /**
@@ -1024,10 +1026,17 @@ lpfc_hba_down_post_s4(struct lpfc_hba *phba)
 	list_for_each_entry(sglq_entry,
 		&phba->sli4_hba.lpfc_abts_els_sgl_list, list)
 		sglq_entry->state = SGL_FREED;
+	list_for_each_entry(sglq_entry,
+		&phba->sli4_hba.lpfc_abts_nvmet_sgl_list, list)
+		sglq_entry->state = SGL_FREED;
 
 	list_splice_init(&phba->sli4_hba.lpfc_abts_els_sgl_list,
 			&phba->sli4_hba.lpfc_els_sgl_list);
 
+	if (phba->sli4_hba.nvme_wq)
+		list_splice_init(&phba->sli4_hba.lpfc_abts_nvmet_sgl_list,
+				 &phba->sli4_hba.lpfc_nvmet_sgl_list);
+
 	spin_unlock(&phba->sli4_hba.sgl_list_lock);
 	/* abts_scsi_buf_list_lock required because worker thread uses this
 	 * list.
@@ -3323,6 +3332,128 @@ lpfc_sli4_els_sgl_update(struct lpfc_hba *phba)
 }
 
 /**
+ * lpfc_sli4_nvmet_sgl_update - update xri-sgl sizing and mapping
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine first calculates the sizes of the current els and allocated
+ * scsi sgl lists, and then goes through all sgls to updates the physical
+ * XRIs assigned due to port function reset. During port initialization, the
+ * current els and allocated scsi sgl lists are 0s.
+ *
+ * Return codes
+ *   0 - successful (for now, it always returns 0)
+ **/
+int
+lpfc_sli4_nvmet_sgl_update(struct lpfc_hba *phba)
+{
+	struct lpfc_sglq *sglq_entry = NULL, *sglq_entry_next = NULL;
+	uint16_t i, lxri, xri_cnt, els_xri_cnt;
+	uint16_t nvmet_xri_cnt, tot_cnt;
+	LIST_HEAD(nvmet_sgl_list);
+	int rc;
+
+	/*
+	 * update on pci function's nvmet xri-sgl list
+	 */
+	els_xri_cnt = lpfc_sli4_get_els_iocb_cnt(phba);
+	nvmet_xri_cnt = 0;
+	tot_cnt = phba->sli4_hba.max_cfg_param.max_xri - els_xri_cnt;
+
+	if (nvmet_xri_cnt > phba->sli4_hba.nvmet_xri_cnt) {
+		/* els xri-sgl expanded */
+		xri_cnt = nvmet_xri_cnt - phba->sli4_hba.nvmet_xri_cnt;
+		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+				"6302 NVMET xri-sgl cnt grew from %d to %d\n",
+				phba->sli4_hba.nvmet_xri_cnt, nvmet_xri_cnt);
+		/* allocate the additional nvmet sgls */
+		for (i = 0; i < xri_cnt; i++) {
+			sglq_entry = kzalloc(sizeof(struct lpfc_sglq),
+					     GFP_KERNEL);
+			if (sglq_entry == NULL) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+						"6303 Failure to allocate an "
+						"NVMET sgl entry:%d\n", i);
+				rc = -ENOMEM;
+				goto out_free_mem;
+			}
+			sglq_entry->buff_type = NVMET_BUFF_TYPE;
+			sglq_entry->virt = lpfc_nvmet_buf_alloc(phba, 0,
+							   &sglq_entry->phys);
+			if (sglq_entry->virt == NULL) {
+				kfree(sglq_entry);
+				lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+						"6304 Failure to allocate an "
+						"NVMET buf:%d\n", i);
+				rc = -ENOMEM;
+				goto out_free_mem;
+			}
+			sglq_entry->sgl = sglq_entry->virt;
+			memset(sglq_entry->sgl, 0,
+			       phba->cfg_sg_dma_buf_size);
+			sglq_entry->state = SGL_FREED;
+			list_add_tail(&sglq_entry->list, &nvmet_sgl_list);
+		}
+		spin_lock_irq(&phba->hbalock);
+		spin_lock(&phba->sli4_hba.sgl_list_lock);
+		list_splice_init(&nvmet_sgl_list,
+				 &phba->sli4_hba.lpfc_nvmet_sgl_list);
+		spin_unlock(&phba->sli4_hba.sgl_list_lock);
+		spin_unlock_irq(&phba->hbalock);
+	} else if (nvmet_xri_cnt < phba->sli4_hba.nvmet_xri_cnt) {
+		/* nvmet xri-sgl shrunk */
+		xri_cnt = phba->sli4_hba.nvmet_xri_cnt - nvmet_xri_cnt;
+		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+				"6305 NVMET xri-sgl count decreased from "
+				"%d to %d\n", phba->sli4_hba.nvmet_xri_cnt,
+				nvmet_xri_cnt);
+		spin_lock_irq(&phba->hbalock);
+		spin_lock(&phba->sli4_hba.sgl_list_lock);
+		list_splice_init(&phba->sli4_hba.lpfc_nvmet_sgl_list,
+				 &nvmet_sgl_list);
+		/* release extra nvmet sgls from list */
+		for (i = 0; i < xri_cnt; i++) {
+			list_remove_head(&nvmet_sgl_list,
+					 sglq_entry, struct lpfc_sglq, list);
+			if (sglq_entry) {
+				lpfc_nvmet_buf_free(phba, sglq_entry->virt,
+						    sglq_entry->phys);
+				kfree(sglq_entry);
+			}
+		}
+		list_splice_init(&nvmet_sgl_list,
+				 &phba->sli4_hba.lpfc_nvmet_sgl_list);
+		spin_unlock(&phba->sli4_hba.sgl_list_lock);
+		spin_unlock_irq(&phba->hbalock);
+	} else
+		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+				"6306 NVMET xri-sgl count unchanged: %d\n",
+				nvmet_xri_cnt);
+	phba->sli4_hba.nvmet_xri_cnt = nvmet_xri_cnt;
+
+	/* update xris to nvmet sgls on the list */
+	sglq_entry = NULL;
+	sglq_entry_next = NULL;
+	list_for_each_entry_safe(sglq_entry, sglq_entry_next,
+				 &phba->sli4_hba.lpfc_nvmet_sgl_list, list) {
+		lxri = lpfc_sli4_next_xritag(phba);
+		if (lxri == NO_XRI) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+					"6307 Failed to allocate xri for "
+					"NVMET sgl\n");
+			rc = -ENOMEM;
+			goto out_free_mem;
+		}
+		sglq_entry->sli4_lxritag = lxri;
+		sglq_entry->sli4_xritag = phba->sli4_hba.xri_ids[lxri];
+	}
+	return 0;
+
+out_free_mem:
+	lpfc_free_nvmet_sgl_list(phba);
+	return rc;
+}
+
+/**
  * lpfc_sli4_scsi_sgl_update - update xri-sgl sizing and mapping
  * @phba: pointer to lpfc hba data structure.
  *
@@ -5230,11 +5361,12 @@ lpfc_setup_driver_resource_phase1(struct lpfc_hba *phba)
 	init_waitqueue_head(&phba->work_waitq);
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-			"1403 Protocols supported %s %s\n",
+			"1403 Protocols supported %s %s %s\n",
 			((phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP) ?
 				"SCSI" : " "),
 			((phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) ?
-				"NVME" : " "));
+				"NVME" : " "),
+			(phba->nvmet_support ? "NVMET" : " "));
 
 	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP) {
 		/* Initialize the scsi buffer list used by driver for scsi IO */
@@ -5449,11 +5581,13 @@ static int
 lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 {
 	LPFC_MBOXQ_t *mboxq;
+	MAILBOX_t *mb;
 	int rc, i, max_buf_size;
 	uint8_t pn_page[LPFC_MAX_SUPPORTED_PAGES] = {0};
 	struct lpfc_mqe *mqe;
 	int longs;
 	int fof_vectors = 0;
+	uint64_t wwn;
 
 	phba->sli4_hba.num_online_cpu = num_online_cpus();
 	phba->sli4_hba.num_present_cpu = lpfc_present_cpu;
@@ -5599,6 +5733,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 
 	/* This abort list used by worker thread */
 	spin_lock_init(&phba->sli4_hba.sgl_list_lock);
+	spin_lock_init(&phba->sli4_hba.nvmet_io_lock);
 
 	/*
 	 * Initialize driver internal slow-path work queues
@@ -5675,7 +5810,43 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		goto out_free_bsmbx;
 	}
 
+	/* Check for NVMET being configured */
 	phba->nvmet_support = 0;
+	if (lpfc_enable_nvmet_cnt) {
+
+		/* First get WWN of HBA instance */
+		lpfc_read_nv(phba, mboxq);
+		rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+		if (rc != MBX_SUCCESS) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+					"6016 Mailbox failed , mbxCmd x%x "
+					"READ_NV, mbxStatus x%x\n",
+					bf_get(lpfc_mqe_command, &mboxq->u.mqe),
+					bf_get(lpfc_mqe_status, &mboxq->u.mqe));
+			rc = -EIO;
+			goto out_free_bsmbx;
+		}
+		mb = &mboxq->u.mb;
+		memcpy(&wwn, (char *)mb->un.varRDnvp.nodename,
+		       sizeof(uint64_t));
+		wwn = cpu_to_be64(wwn);
+		phba->sli4_hba.wwnn.u.name = wwn;
+		memcpy(&wwn, (char *)mb->un.varRDnvp.portname,
+		       sizeof(uint64_t));
+		/* wwn is WWPN of HBA instance */
+		wwn = cpu_to_be64(wwn);
+		phba->sli4_hba.wwpn.u.name = wwn;
+
+		/* Check to see if it matches any module parameter */
+		for (i = 0; i < lpfc_enable_nvmet_cnt; i++) {
+			if (wwn == lpfc_enable_nvmet[i]) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"6017 NVME Target %016llx\n",
+						wwn);
+				phba->nvmet_support = 1; /* a match */
+			}
+		}
+	}
 
 	lpfc_nvme_mod_param_dep(phba);
 
@@ -5871,6 +6042,7 @@ lpfc_sli4_driver_resource_unset(struct lpfc_hba *phba)
 	/* Free the ELS sgl list */
 	lpfc_free_active_sgl(phba);
 	lpfc_free_els_sgl_list(phba);
+	lpfc_free_nvmet_sgl_list(phba);
 
 	/* Free the completion queue EQ event pool */
 	lpfc_sli4_cq_event_release_all(phba);
@@ -6092,6 +6264,33 @@ lpfc_free_els_sgl_list(struct lpfc_hba *phba)
 }
 
 /**
+ * lpfc_free_nvmet_sgl_list - Free nvmet sgl list.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to free the driver's nvmet sgl list and memory.
+ **/
+static void
+lpfc_free_nvmet_sgl_list(struct lpfc_hba *phba)
+{
+	struct lpfc_sglq *sglq_entry = NULL, *sglq_next = NULL;
+	LIST_HEAD(sglq_list);
+
+	/* Retrieve all nvmet sgls from driver list */
+	spin_lock_irq(&phba->hbalock);
+	spin_lock(&phba->sli4_hba.sgl_list_lock);
+	list_splice_init(&phba->sli4_hba.lpfc_nvmet_sgl_list, &sglq_list);
+	spin_unlock(&phba->sli4_hba.sgl_list_lock);
+	spin_unlock_irq(&phba->hbalock);
+
+	/* Now free the sgl list */
+	list_for_each_entry_safe(sglq_entry, sglq_next, &sglq_list, list) {
+		list_del(&sglq_entry->list);
+		lpfc_nvmet_buf_free(phba, sglq_entry->virt, sglq_entry->phys);
+		kfree(sglq_entry);
+	}
+}
+
+/**
  * lpfc_init_active_sgl_array - Allocate the buf to track active ELS XRIs.
  * @phba: pointer to lpfc hba data structure.
  *
@@ -6140,6 +6339,8 @@ lpfc_init_sgl_list(struct lpfc_hba *phba)
 	/* Initialize and populate the sglq list per host/VF. */
 	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_els_sgl_list);
 	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_abts_els_sgl_list);
+	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_nvmet_sgl_list);
+	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_abts_nvmet_sgl_list);
 
 	/* els xri-sgl book keeping */
 	phba->sli4_hba.els_xri_cnt = 0;
@@ -6418,6 +6619,22 @@ lpfc_create_shost(struct lpfc_hba *phba)
 	shost = lpfc_shost_from_vport(vport);
 	phba->pport = vport;
 
+	if (phba->nvmet_support) {
+		/* Only 1 vport (pport) will support NVME target */
+		if (phba->txrdy_payload_pool == NULL) {
+			phba->txrdy_payload_pool = pci_pool_create(
+				"txrdy_pool", phba->pcidev,
+				TXRDY_PAYLOAD_LEN, 16, 0);
+			if (phba->txrdy_payload_pool) {
+				phba->targetport = NULL;
+				phba->cfg_enable_fc4_type = LPFC_ENABLE_NVME;
+				lpfc_printf_log(phba, KERN_INFO,
+						LOG_INIT | LOG_NVME_DISC,
+						"6076 NVME Target Found\n");
+			}
+		}
+	}
+
 	lpfc_debugfs_initialize(vport);
 	/* Put reference to SCSI host to driver's device private data */
 	pci_set_drvdata(phba->pcidev, shost);
@@ -7461,7 +7678,7 @@ lpfc_sli4_queue_verify(struct lpfc_hba *phba)
 		phba->cfg_nvme_io_channel = io_channel;
 
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			"2574 IRQs: %d, IO Channels: fcp %d nvme %d\n",
+			"2574 IO channels: irqs %d fcp %d nvme %d\n",
 			phba->io_channel_irqs, phba->cfg_fcp_io_channel,
 			phba->cfg_nvme_io_channel);
 
@@ -9166,8 +9383,9 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 	if (phba->cfg_fof)
 		vectors++;
 
-	rc = pci_alloc_irq_vectors(phba->pcidev, 2, vectors,
-				PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
+	rc = pci_alloc_irq_vectors(phba->pcidev,
+				(phba->nvmet_support) ? 1 : 2,
+				vectors, PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
 	if (rc < 0) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0484 PCI enable MSI-X failed (%d)\n", rc);
@@ -9449,6 +9667,8 @@ lpfc_sli4_xri_exchange_busy_wait(struct lpfc_hba *phba)
 	int nvme_xri_cmpl = 1;
 	int fcp_xri_cmpl = 1;
 	int els_xri_cmpl = list_empty(&phba->sli4_hba.lpfc_abts_els_sgl_list);
+	int nvmet_xri_cmpl =
+			list_empty(&phba->sli4_hba.lpfc_abts_nvmet_sgl_list);
 
 	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP)
 		fcp_xri_cmpl =
@@ -9457,7 +9677,8 @@ lpfc_sli4_xri_exchange_busy_wait(struct lpfc_hba *phba)
 		nvme_xri_cmpl =
 			list_empty(&phba->sli4_hba.lpfc_abts_nvme_buf_list);
 
-	while (!fcp_xri_cmpl || !els_xri_cmpl || !nvme_xri_cmpl) {
+	while (!fcp_xri_cmpl || !els_xri_cmpl || !nvme_xri_cmpl ||
+	       !nvmet_xri_cmpl) {
 		if (wait_time > LPFC_XRI_EXCH_BUSY_WAIT_TMO) {
 			if (!nvme_xri_cmpl)
 				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
@@ -9490,6 +9711,9 @@ lpfc_sli4_xri_exchange_busy_wait(struct lpfc_hba *phba)
 
 		els_xri_cmpl =
 			list_empty(&phba->sli4_hba.lpfc_abts_els_sgl_list);
+
+		nvmet_xri_cmpl =
+			list_empty(&phba->sli4_hba.lpfc_abts_nvmet_sgl_list);
 	}
 }
 
@@ -10385,13 +10609,15 @@ lpfc_sli4_get_els_iocb_cnt(struct lpfc_hba *phba)
  * lpfc_sli4_get_iocb_cnt - Calculate the # of total IOCBs to reserve
  * @phba: pointer to lpfc hba data structure.
  *
- * returns the number of ELS/CT
+ * returns the number of ELS/CT + NVMET IOCBs to reserve
  **/
 int
 lpfc_sli4_get_iocb_cnt(struct lpfc_hba *phba)
 {
 	int max_xri = lpfc_sli4_get_els_iocb_cnt(phba);
 
+	if (phba->nvmet_support)
+		max_xri += LPFC_NVMET_BUF_POST;
 	return max_xri;
 }
 
@@ -10763,6 +10989,7 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
 	/* Remove FC host and then SCSI host with the physical port */
 	fc_remove_host(shost);
 	scsi_remove_host(shost);
+	/* todo: tgt: remove targetport */
 
 	/* Perform ndlp cleanup on the physical port.  The nvme localport
 	 * is destroyed after to ensure all rports are io-disabled.
diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index c65a1ec..32db255 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -40,6 +40,7 @@
 #include "lpfc.h"
 #include "lpfc_scsi.h"
 #include "lpfc_nvme.h"
+#include "lpfc_nvmet.h"
 #include "lpfc_crtn.h"
 #include "lpfc_logmsg.h"
 
@@ -442,6 +443,44 @@ lpfc_mbuf_free(struct lpfc_hba * phba, void *virt, dma_addr_t dma)
 }
 
 /**
+ * lpfc_nvmet_buf_alloc - Allocate an nvmet_buf from the
+ * lpfc_sg_dma_buf_pool PCI pool
+ * @phba: HBA which owns the pool to allocate from
+ * @mem_flags: indicates if this is a priority (MEM_PRI) allocation
+ * @handle: used to return the DMA-mapped address of the nvmet_buf
+ *
+ * Description: Allocates a DMA-mapped buffer from the lpfc_sg_dma_buf_pool
+ * PCI pool.  Allocates from generic pci_pool_alloc function.
+ *
+ * Returns:
+ *   pointer to the allocated nvmet_buf on success
+ *   NULL on failure
+ **/
+void *
+lpfc_nvmet_buf_alloc(struct lpfc_hba *phba, int mem_flags, dma_addr_t *handle)
+{
+	void *ret;
+
+	ret = pci_pool_alloc(phba->lpfc_sg_dma_buf_pool, GFP_KERNEL, handle);
+	return ret;
+}
+
+/**
+ * lpfc_nvmet_buf_free - Free an nvmet_buf from the lpfc_sg_dma_buf_pool
+ * PCI pool
+ * @phba: HBA which owns the pool to return to
+ * @virt: nvmet_buf to free
+ * @dma: the DMA-mapped address of the lpfc_sg_dma_buf_pool to be freed
+ *
+ * Returns: None
+ **/
+void
+lpfc_nvmet_buf_free(struct lpfc_hba *phba, void *virt, dma_addr_t dma)
+{
+	pci_pool_free(phba->lpfc_sg_dma_buf_pool, virt, dma);
+}
+
+/**
  * lpfc_els_hbq_alloc - Allocate an HBQ buffer
  * @phba: HBA to allocate HBQ buffer for
  *
@@ -554,6 +593,134 @@ lpfc_sli4_rb_free(struct lpfc_hba *phba, struct hbq_dmabuf *dmab)
 }
 
 /**
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
+struct rqb_dmabuf *
+lpfc_sli4_nvmet_alloc(struct lpfc_hba *phba)
+{
+	struct rqb_dmabuf *dma_buf;
+	struct lpfc_iocbq *nvmewqe;
+	union lpfc_wqe128 *wqe;
+
+	dma_buf = kzalloc(sizeof(struct rqb_dmabuf), GFP_KERNEL);
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
+	dma_buf->iocbq->iocb_flag = LPFC_IO_NVMET;
+	if (!dma_buf->iocbq) {
+		kfree(dma_buf->context);
+		pci_pool_free(phba->lpfc_drb_pool, dma_buf->dbuf.virt,
+			      dma_buf->dbuf.phys);
+		pci_pool_free(phba->lpfc_hrb_pool, dma_buf->hbuf.virt,
+			      dma_buf->hbuf.phys);
+		kfree(dma_buf);
+		lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
+				"2621 Ran out of nvmet iocb/WQEs\n");
+		return NULL;
+	}
+	nvmewqe = dma_buf->iocbq;
+	wqe = (union lpfc_wqe128 *)&nvmewqe->wqe;
+	/* Initialize WQE */
+	memset(wqe, 0, sizeof(union lpfc_wqe));
+	/* Word 7 */
+	bf_set(wqe_ct, &wqe->generic.wqe_com, SLI4_CT_RPI);
+	bf_set(wqe_class, &wqe->generic.wqe_com, CLASS3);
+	bf_set(wqe_pu, &wqe->generic.wqe_com, 1);
+	/* Word 10 */
+	bf_set(wqe_nvme, &wqe->fcp_tsend.wqe_com, 1);
+	bf_set(wqe_ebde_cnt, &wqe->generic.wqe_com, 0);
+	bf_set(wqe_qosd, &wqe->generic.wqe_com, 0);
+
+	dma_buf->iocbq->context1 = NULL;
+	spin_lock(&phba->sli4_hba.sgl_list_lock);
+	dma_buf->sglq = __lpfc_sli_get_nvmet_sglq(phba, dma_buf->iocbq);
+	spin_unlock(&phba->sli4_hba.sgl_list_lock);
+	if (!dma_buf->sglq) {
+		lpfc_sli_release_iocbq(phba, dma_buf->iocbq);
+		kfree(dma_buf->context);
+		pci_pool_free(phba->lpfc_drb_pool, dma_buf->dbuf.virt,
+			      dma_buf->dbuf.phys);
+		pci_pool_free(phba->lpfc_hrb_pool, dma_buf->hbuf.virt,
+			      dma_buf->hbuf.phys);
+		kfree(dma_buf);
+		lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
+				"6132 Ran out of nvmet XRIs\n");
+		return NULL;
+	}
+	return dma_buf;
+}
+
+/**
+ * lpfc_sli4_nvmet_free - Frees a receive buffer
+ * @phba: HBA buffer was allocated for
+ * @dmab: DMA Buffer container returned by lpfc_sli4_rbq_alloc
+ *
+ * Description: Frees both the container and the DMA-mapped buffers returned by
+ * lpfc_sli4_nvmet_alloc.
+ *
+ * Notes: Can be called with or without locks held.
+ *
+ * Returns: None
+ **/
+void
+lpfc_sli4_nvmet_free(struct lpfc_hba *phba, struct rqb_dmabuf *dmab)
+{
+	unsigned long flags;
+
+	__lpfc_clear_active_sglq(phba, dmab->sglq->sli4_lxritag);
+	dmab->sglq->state = SGL_FREED;
+	dmab->sglq->ndlp = NULL;
+
+	spin_lock_irqsave(&phba->sli4_hba.sgl_list_lock, flags);
+	list_add_tail(&dmab->sglq->list, &phba->sli4_hba.lpfc_nvmet_sgl_list);
+	spin_unlock_irqrestore(&phba->sli4_hba.sgl_list_lock, flags);
+
+	lpfc_sli_release_iocbq(phba, dmab->iocbq);
+	kfree(dmab->context);
+	pci_pool_free(phba->lpfc_hrb_pool, dmab->hbuf.virt, dmab->hbuf.phys);
+	pci_pool_free(phba->lpfc_drb_pool, dmab->dbuf.virt, dmab->dbuf.phys);
+	kfree(dmab);
+}
+
+/**
  * lpfc_in_buf_free - Free a DMA buffer
  * @phba: HBA buffer is associated with
  * @mp: Buffer to free
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.h b/drivers/scsi/lpfc/lpfc_nvmet.h
new file mode 100644
index 0000000..7e19992
--- /dev/null
+++ b/drivers/scsi/lpfc/lpfc_nvmet.h
@@ -0,0 +1,102 @@
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
+#define LPFC_NVMET_MIN_SEGS		16
+#define LPFC_NVMET_DEFAULT_SEGS		64	/* 256K IOs */
+#define LPFC_NVMET_MAX_SEGS		510
+#define LPFC_NVMET_SUCCESS_LEN	12
+
+/* Used for NVME Target */
+struct lpfc_nvmet_tgtport {
+	struct lpfc_hba *phba;
+	struct completion tport_unreg_done;
+
+	/* Stats counters - lpfc_nvmet_unsol_ls_buffer */
+	atomic_t rcv_ls_req_in;
+	atomic_t rcv_ls_req_out;
+	atomic_t rcv_ls_req_drop;
+	atomic_t xmt_ls_abort;
+
+	/* Stats counters - lpfc_nvmet_xmt_ls_rsp */
+	atomic_t xmt_ls_rsp;
+	atomic_t xmt_ls_drop;
+
+	/* Stats counters - lpfc_nvmet_xmt_ls_rsp_cmp */
+	atomic_t xmt_ls_rsp_error;
+	atomic_t xmt_ls_rsp_cmpl;
+
+	/* Stats counters - lpfc_nvmet_unsol_fcp_buffer */
+	atomic_t rcv_fcp_cmd_in;
+	atomic_t rcv_fcp_cmd_out;
+	atomic_t rcv_fcp_cmd_drop;
+
+	/* Stats counters - lpfc_nvmet_xmt_fcp_op */
+	atomic_t xmt_fcp_abort;
+	atomic_t xmt_fcp_drop;
+	atomic_t xmt_fcp_read_rsp;
+	atomic_t xmt_fcp_read;
+	atomic_t xmt_fcp_write;
+	atomic_t xmt_fcp_rsp;
+
+	/* Stats counters - lpfc_nvmet_xmt_fcp_op_cmp */
+	atomic_t xmt_fcp_rsp_cmpl;
+	atomic_t xmt_fcp_rsp_error;
+	atomic_t xmt_fcp_rsp_drop;
+
+
+	/* Stats counters - lpfc_nvmet_unsol_issue_abort */
+	atomic_t xmt_abort_rsp;
+	atomic_t xmt_abort_rsp_error;
+
+	/* Stats counters - lpfc_nvmet_xmt_abort_cmp */
+	atomic_t xmt_abort_cmpl;
+};
+
+struct lpfc_nvmet_rcv_ctx {
+	union {
+		struct nvmefc_tgt_ls_req ls_req;
+		struct nvmefc_tgt_fcp_req fcp_req;
+	} ctx;
+	struct lpfc_hba *phba;
+	struct lpfc_iocbq *wqeq;
+	struct lpfc_iocbq *abort_wqeq;
+	dma_addr_t txrdy_phys;
+	uint32_t *txrdy;
+	uint32_t sid;
+	uint32_t offset;
+	uint16_t oxid;
+	uint16_t size;
+	uint16_t entry_cnt;
+	uint16_t cpu;
+	uint16_t state;
+	/* States */
+#define LPFC_NVMET_STE_FREE		0
+#define LPFC_NVMET_STE_RCV		1
+#define LPFC_NVMET_STE_DATA		2
+#define LPFC_NVMET_STE_ABORT		3
+#define LPFC_NVMET_STE_RSP		4
+#define LPFC_NVMET_STE_DONE		5
+	uint16_t flag;
+#define LPFC_NVMET_IO_INP		1
+#define LPFC_NVMET_ABORT_OP		2
+	struct rqb_dmabuf *rqb_buffer;
+};
+
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c7a71c6..99dbfdf 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -45,6 +45,7 @@
 #include "lpfc.h"
 #include "lpfc_scsi.h"
 #include "lpfc_nvme.h"
+#include "lpfc_nvmet.h"
 #include "lpfc_crtn.h"
 #include "lpfc_logmsg.h"
 #include "lpfc_compat.h"
@@ -976,6 +977,34 @@ __lpfc_sli_get_els_sglq(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq)
 }
 
 /**
+ * __lpfc_sli_get_nvmet_sglq - Allocates an iocb object from sgl pool
+ * @phba: Pointer to HBA context object.
+ * @piocb: Pointer to the iocbq.
+ *
+ * This function is called with the sgl_list lock held. This function
+ * gets a new driver sglq object from the sglq list. If the
+ * list is not empty then it is successful, it returns pointer to the newly
+ * allocated sglq object else it returns NULL.
+ **/
+struct lpfc_sglq *
+__lpfc_sli_get_nvmet_sglq(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq)
+{
+	struct list_head *lpfc_nvmet_sgl_list;
+	struct lpfc_sglq *sglq = NULL;
+
+	lpfc_nvmet_sgl_list = &phba->sli4_hba.lpfc_nvmet_sgl_list;
+
+	lockdep_assert_held(&phba->sli4_hba.sgl_list_lock);
+
+	list_remove_head(lpfc_nvmet_sgl_list, sglq, struct lpfc_sglq, list);
+	if (!sglq)
+		return NULL;
+	phba->sli4_hba.lpfc_sglq_active_list[sglq->sli4_lxritag] = sglq;
+	sglq->state = SGL_ALLOCATED;
+	return sglq;
+}
+
+/**
  * lpfc_sli_get_iocbq - Allocates an iocb object from iocb pool
  * @phba: Pointer to HBA context object.
  *
@@ -1031,6 +1060,18 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 
 
 	if (sglq)  {
+		if (iocbq->iocb_flag & LPFC_IO_NVMET) {
+			spin_lock_irqsave(&phba->sli4_hba.sgl_list_lock,
+					  iflag);
+			sglq->state = SGL_FREED;
+			sglq->ndlp = NULL;
+			list_add_tail(&sglq->list,
+				      &phba->sli4_hba.lpfc_nvmet_sgl_list);
+			spin_unlock_irqrestore(
+				&phba->sli4_hba.sgl_list_lock, iflag);
+			goto out;
+		}
+
 		pring = phba->sli4_hba.els_wq->pring;
 		if ((iocbq->iocb_flag & LPFC_EXCHANGE_BUSY) &&
 			(sglq->state != SGL_XRI_ABORTED)) {
@@ -1056,13 +1097,15 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 		}
 	}
 
+out:
 	/*
 	 * Clean all volatile data fields, preserve iotag and node struct.
 	 */
 	memset((char *)iocbq + start_clean, 0, sizeof(*iocbq) - start_clean);
 	iocbq->sli4_lxritag = NO_XRI;
 	iocbq->sli4_xritag = NO_XRI;
-	iocbq->iocb_flag &= ~(LPFC_IO_NVME | LPFC_IO_NVME_LS);
+	iocbq->iocb_flag &= ~(LPFC_IO_NVME | LPFC_IO_NVMET |
+			      LPFC_IO_NVME_LS);
 	list_add_tail(&iocbq->list, &phba->lpfc_iocb_list);
 }
 
@@ -2450,6 +2493,14 @@ lpfc_complete_unsol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 {
 	int i;
 
+	switch (fch_type) {
+	case FC_TYPE_NVME:
+		/* todo: tgt: forward NVME LS to transport */
+		return 1;
+	default:
+		break;
+	}
+
 	/* unSolicited Responses */
 	if (pring->prt[0].profile) {
 		if (pring->prt[0].lpfc_sli_rcv_unsol_event)
@@ -6754,7 +6805,31 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	}
 	phba->sli4_hba.els_xri_cnt = rc;
 
-	if (phba->nvmet_support == 0) {
+	if (phba->nvmet_support) {
+		/* update host nvmet xri-sgl sizes and mappings */
+		rc = lpfc_sli4_nvmet_sgl_update(phba);
+		if (unlikely(rc)) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+					"6308 Failed to update nvmet-sgl size "
+					"and mapping: %d\n", rc);
+			goto out_destroy_queue;
+		}
+
+		/* register the nvmet sgl pool to the port */
+		rc = lpfc_sli4_repost_sgl_list(
+			phba,
+			&phba->sli4_hba.lpfc_nvmet_sgl_list,
+			phba->sli4_hba.nvmet_xri_cnt);
+		if (unlikely(rc < 0)) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+					"3117 Error %d during nvmet "
+					"sgl post\n", rc);
+			rc = -ENODEV;
+			goto out_destroy_queue;
+		}
+		phba->sli4_hba.nvmet_xri_cnt = rc;
+		/* todo: tgt: create targetport */
+	} else {
 		/* update host scsi xri-sgl sizes and mappings */
 		rc = lpfc_sli4_scsi_sgl_update(phba);
 		if (unlikely(rc)) {
@@ -12999,7 +13074,7 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 
 	if (phba->sli4_hba.nvme_cq_map &&
 	    (cqid == phba->sli4_hba.nvme_cq_map[qidx])) {
-		/* Process NVME command completion */
+		/* Process NVME / NVMET command completion */
 		cq = phba->sli4_hba.nvme_cq[qidx];
 		goto  process_cq;
 	}
@@ -17904,6 +17979,7 @@ lpfc_sli4_issue_wqe(struct lpfc_hba *phba, uint32_t ring_number,
 		    struct lpfc_iocbq *pwqe)
 {
 	union lpfc_wqe *wqe = &pwqe->wqe;
+	struct lpfc_nvmet_rcv_ctx *ctxp;
 	struct lpfc_queue *wq;
 	struct lpfc_sglq *sglq;
 	struct lpfc_sli_ring *pring;
@@ -17953,5 +18029,30 @@ lpfc_sli4_issue_wqe(struct lpfc_hba *phba, uint32_t ring_number,
 		return 0;
 	}
 
+	/* NVMET requests */
+	if (pwqe->iocb_flag & LPFC_IO_NVMET) {
+		/* Get the IO distribution (hba_wqidx) for WQ assignment. */
+		pring = phba->sli4_hba.nvme_wq[pwqe->hba_wqidx]->pring;
+
+		spin_lock_irqsave(&pring->ring_lock, iflags);
+		ctxp = pwqe->context2;
+		sglq = ctxp->rqb_buffer->sglq;
+		if (pwqe->sli4_xritag ==  NO_XRI) {
+			pwqe->sli4_lxritag = sglq->sli4_lxritag;
+			pwqe->sli4_xritag = sglq->sli4_xritag;
+		}
+		bf_set(wqe_xri_tag, &pwqe->wqe.xmit_bls_rsp.wqe_com,
+		       pwqe->sli4_xritag);
+		wq = phba->sli4_hba.nvme_wq[pwqe->hba_wqidx];
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
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index acb431f..f6cea02 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -93,6 +93,7 @@ struct lpfc_iocbq {
 #define LPFC_PRLI_FCP_REQ	0x100000 /* This is an NVME PRLI. */
 #define LPFC_IO_NVME	        0x200000 /* NVME FCP command */
 #define LPFC_IO_NVME_LS		0x400000 /* NVME LS command */
+#define LPFC_IO_NVMET		0x800000 /* NVMET command */
 
 	uint32_t drvrTimeout;	/* driver timeout in seconds */
 	struct lpfc_vport *vport;/* virtual port pointer */
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 9cb8508..99546ea 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -109,6 +109,7 @@ enum lpfc_sli4_queue_subtype {
 	LPFC_FCP,
 	LPFC_ELS,
 	LPFC_NVME,
+	LPFC_NVMET,
 	LPFC_NVME_LS,
 	LPFC_USOL
 };
@@ -610,8 +611,11 @@ struct lpfc_sli4_hba {
 	uint16_t scsi_xri_cnt;
 	uint16_t scsi_xri_start;
 	uint16_t els_xri_cnt;
+	uint16_t nvmet_xri_cnt;
 	struct list_head lpfc_els_sgl_list;
 	struct list_head lpfc_abts_els_sgl_list;
+	struct list_head lpfc_nvmet_sgl_list;
+	struct list_head lpfc_abts_nvmet_sgl_list;
 	struct list_head lpfc_abts_scsi_buf_list;
 	struct list_head lpfc_abts_nvme_buf_list;
 	struct lpfc_sglq **lpfc_sglq_active_list;
@@ -643,6 +647,7 @@ struct lpfc_sli4_hba {
 	spinlock_t abts_nvme_buf_list_lock; /* list of aborted SCSI IOs */
 	spinlock_t abts_scsi_buf_list_lock; /* list of aborted SCSI IOs */
 	spinlock_t sgl_list_lock; /* list of aborted els IOs */
+	spinlock_t nvmet_io_lock;
 	uint32_t physical_port;
 
 	/* CPU to vector mapping information */
@@ -655,6 +660,7 @@ struct lpfc_sli4_hba {
 enum lpfc_sge_type {
 	GEN_BUFF_TYPE,
 	SCSI_BUFF_TYPE,
+	NVMET_BUFF_TYPE
 };
 
 enum lpfc_sgl_state {
-- 
2.5.0
