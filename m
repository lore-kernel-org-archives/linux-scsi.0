From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 09/16] lpfc: NVME Initiator: Add debugfs support
Date: Sun, 12 Feb 2017 13:52:33 -0800
Message-ID: <58a0d921.mH+KNbibgP5l6GvQ%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:33376 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751241AbdBLVwh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Feb 2017 16:52:37 -0500
Received: by mail-ot0-f194.google.com with SMTP id f9so9225257otd.0
        for <linux-scsi@vger.kernel.org>; Sun, 12 Feb 2017 13:52:37 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org


NVME Initiator: Add debugfs support

Adds debugfs snippets to cover the new NVME initiator functionality

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h         |   55 ++
 drivers/scsi/lpfc/lpfc_crtn.h    |    6 +-
 drivers/scsi/lpfc/lpfc_ct.c      |   27 +-
 drivers/scsi/lpfc/lpfc_debugfs.c | 1160 ++++++++++++++++++++++++++++++++++----
 drivers/scsi/lpfc/lpfc_debugfs.h |   21 +
 drivers/scsi/lpfc/lpfc_nvme.c    |  143 +++++
 drivers/scsi/lpfc/lpfc_nvme.h    |    7 +
 drivers/scsi/lpfc/lpfc_sli.c     |    5 +
 8 files changed, 1300 insertions(+), 124 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 9ad63a4..fdb314b 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -458,6 +458,9 @@ struct lpfc_vport {
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	struct dentry *debug_disc_trc;
 	struct dentry *debug_nodelist;
+	struct dentry *debug_nvmestat;
+	struct dentry *debug_nvmektime;
+	struct dentry *debug_cpucheck;
 	struct dentry *vport_debugfs_root;
 	struct lpfc_debugfs_trc *disc_trc;
 	atomic_t disc_trc_cnt;
@@ -984,6 +987,12 @@ struct lpfc_hba {
 	struct dentry *debug_readApp;    /* inject read app_tag errors */
 	struct dentry *debug_readRef;    /* inject read ref_tag errors */
 
+	struct dentry *debug_nvmeio_trc;
+	struct lpfc_debugfs_nvmeio_trc *nvmeio_trc;
+	atomic_t nvmeio_trc_cnt;
+	uint32_t nvmeio_trc_size;
+	uint32_t nvmeio_trc_output_idx;
+
 	/* T10 DIF error injection */
 	uint32_t lpfc_injerr_wgrd_cnt;
 	uint32_t lpfc_injerr_wapp_cnt;
@@ -1011,6 +1020,7 @@ struct lpfc_hba {
 	struct dentry *idiag_ext_acc;
 	uint8_t lpfc_idiag_last_eq;
 #endif
+	uint16_t nvmeio_trc_on;
 
 	/* Used for deferred freeing of ELS data buffers */
 	struct list_head elsbuf;
@@ -1083,6 +1093,51 @@ struct lpfc_hba {
 #define LPFC_TRANSGRESSION_LOW_RXPOWER		0x4000
 	uint16_t sfp_alarm;
 	uint16_t sfp_warning;
+
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+#define LPFC_CHECK_CPU_CNT    32
+	uint32_t cpucheck_rcv_io[LPFC_CHECK_CPU_CNT];
+	uint32_t cpucheck_xmt_io[LPFC_CHECK_CPU_CNT];
+	uint32_t cpucheck_cmpl_io[LPFC_CHECK_CPU_CNT];
+	uint32_t cpucheck_ccmpl_io[LPFC_CHECK_CPU_CNT];
+	uint16_t cpucheck_on;
+#define LPFC_CHECK_OFF		0
+#define LPFC_CHECK_NVME_IO	1
+	uint16_t ktime_on;
+	uint64_t ktime_data_samples;
+	uint64_t ktime_status_samples;
+	uint64_t ktime_last_cmd;
+	uint64_t ktime_seg1_total;
+	uint64_t ktime_seg1_min;
+	uint64_t ktime_seg1_max;
+	uint64_t ktime_seg2_total;
+	uint64_t ktime_seg2_min;
+	uint64_t ktime_seg2_max;
+	uint64_t ktime_seg3_total;
+	uint64_t ktime_seg3_min;
+	uint64_t ktime_seg3_max;
+	uint64_t ktime_seg4_total;
+	uint64_t ktime_seg4_min;
+	uint64_t ktime_seg4_max;
+	uint64_t ktime_seg5_total;
+	uint64_t ktime_seg5_min;
+	uint64_t ktime_seg5_max;
+	uint64_t ktime_seg6_total;
+	uint64_t ktime_seg6_min;
+	uint64_t ktime_seg6_max;
+	uint64_t ktime_seg7_total;
+	uint64_t ktime_seg7_min;
+	uint64_t ktime_seg7_max;
+	uint64_t ktime_seg8_total;
+	uint64_t ktime_seg8_min;
+	uint64_t ktime_seg8_max;
+	uint64_t ktime_seg9_total;
+	uint64_t ktime_seg9_min;
+	uint64_t ktime_seg9_max;
+	uint64_t ktime_seg10_total;
+	uint64_t ktime_seg10_min;
+	uint64_t ktime_seg10_max;
+#endif
 };
 
 static inline struct Scsi_Host *
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index a9c8a0a..4a0db38 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -393,9 +393,11 @@ void lpfc_host_attrib_init(struct Scsi_Host *);
 extern void lpfc_debugfs_initialize(struct lpfc_vport *);
 extern void lpfc_debugfs_terminate(struct lpfc_vport *);
 extern void lpfc_debugfs_disc_trc(struct lpfc_vport *, int, char *, uint32_t,
-	uint32_t, uint32_t);
+				  uint32_t, uint32_t);
 extern void lpfc_debugfs_slow_ring_trc(struct lpfc_hba *, char *, uint32_t,
-	uint32_t, uint32_t);
+				       uint32_t, uint32_t);
+extern void lpfc_debugfs_nvme_trc(struct lpfc_hba *phba, char *fmt,
+				uint16_t data1, uint16_t data2, uint32_t data3);
 extern struct lpfc_hbq_init *lpfc_hbq_defs[];
 
 /* SLI4 if_type 2 externs. */
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 8cfeffe..2c051369 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -465,6 +465,10 @@ lpfc_prep_node_fc4type(struct lpfc_vport *vport, uint32_t Did, uint8_t fc4_type)
 		ndlp = lpfc_setup_disc_node(vport, Did);
 
 		if (ndlp && NLP_CHK_NODE_ACT(ndlp)) {
+			lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_CT,
+				"Parse GID_FTrsp: did:x%x flg:x%x x%x",
+				Did, ndlp->nlp_flag, vport->fc_flag);
+
 			/* By default, the driver expects to support FCP FC4 */
 			if (fc4_type == FC_TYPE_FCP)
 				ndlp->nlp_fc4_type |= NLP_FC4_FCP;
@@ -478,16 +482,24 @@ lpfc_prep_node_fc4type(struct lpfc_vport *vport, uint32_t Did, uint8_t fc4_type)
 					 ndlp->nlp_flag, ndlp->nlp_fc4_type,
 					 vport->fc_flag,
 					 vport->fc_rscn_id_cnt);
-		} else
+		} else {
+			lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_CT,
+				"Skip1 GID_FTrsp: did:x%x flg:x%x cnt:%d",
+				Did, vport->fc_flag, vport->fc_rscn_id_cnt);
+
 			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 					 "0239 Skip x%06x NameServer Rsp "
 					 "Data: x%x x%x\n", Did,
 					 vport->fc_flag,
 					 vport->fc_rscn_id_cnt);
-
+		}
 	} else {
 		if (!(vport->fc_flag & FC_RSCN_MODE) ||
 		    lpfc_rscn_payload_check(vport, Did)) {
+			lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_CT,
+				"Query GID_FTrsp: did:x%x flg:x%x cnt:%d",
+				Did, vport->fc_flag, vport->fc_rscn_id_cnt);
+
 			/*
 			 * This NPortID was previously a FCP target,
 			 * Don't even bother to send GFF_ID.
@@ -509,12 +521,17 @@ lpfc_prep_node_fc4type(struct lpfc_vport *vport, uint32_t Did, uint8_t fc4_type)
 				else
 					lpfc_setup_disc_node(vport, Did);
 			}
-		} else
+		} else {
+			lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_CT,
+				"Skip2 GID_FTrsp: did:x%x flg:x%x cnt:%d",
+				Did, vport->fc_flag, vport->fc_rscn_id_cnt);
+
 			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 					 "0245 Skip x%06x NameServer Rsp "
 					 "Data: x%x x%x\n", Did,
 					 vport->fc_flag,
 					 vport->fc_rscn_id_cnt);
+		}
 	}
 }
 
@@ -892,6 +909,10 @@ lpfc_cmpl_ct_cmd_gft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	did = ((struct lpfc_sli_ct_request *)inp->virt)->un.gft.PortId;
 	did = be32_to_cpu(did);
 
+	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_CT,
+			      "GFT_ID cmpl: status:x%x/x%x did:x%x",
+			      irsp->ulpStatus, irsp->un.ulpWord[4], did);
+
 	if (irsp->ulpStatus == IOSTAT_SUCCESS) {
 		/* Good status, continue checking */
 		CTrsp = (struct lpfc_sli_ct_request *)outp->virt;
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index a0d817d..90557e4 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -34,6 +34,9 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_fc.h>
+#include <scsi/fc/fc_fs.h>
+
+#include <linux/nvme-fc-driver.h>
 
 #include "lpfc_hw4.h"
 #include "lpfc_hw.h"
@@ -41,8 +44,9 @@
 #include "lpfc_sli4.h"
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
-#include "lpfc_scsi.h"
 #include "lpfc.h"
+#include "lpfc_scsi.h"
+#include "lpfc_nvme.h"
 #include "lpfc_logmsg.h"
 #include "lpfc_crtn.h"
 #include "lpfc_vport.h"
@@ -99,6 +103,12 @@ module_param(lpfc_debugfs_max_slow_ring_trc, int, S_IRUGO);
 MODULE_PARM_DESC(lpfc_debugfs_max_slow_ring_trc,
 	"Set debugfs slow ring trace depth");
 
+/* This MUST be a power of 2 */
+static int lpfc_debugfs_max_nvmeio_trc;
+module_param(lpfc_debugfs_max_nvmeio_trc, int, 0444);
+MODULE_PARM_DESC(lpfc_debugfs_max_nvmeio_trc,
+		 "Set debugfs NVME IO trace depth");
+
 static int lpfc_debugfs_mask_disc_trc;
 module_param(lpfc_debugfs_mask_disc_trc, int, S_IRUGO);
 MODULE_PARM_DESC(lpfc_debugfs_mask_disc_trc,
@@ -535,6 +545,10 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_nodelist *ndlp;
 	unsigned char *statep;
+	struct nvme_fc_local_port *localport;
+	struct lpfc_nvme_lport *lport;
+	struct lpfc_nvme_rport *rport;
+	struct nvme_fc_remote_port *nrport;
 
 	cnt = (LPFC_NODELIST_SIZE / LPFC_NODELIST_ENTRY_SIZE);
 
@@ -612,6 +626,358 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 	}
 	spin_unlock_irq(shost->host_lock);
 
+	len += snprintf(buf + len, size - len,
+				"\nNVME Lport/Rport Entries ...\n");
+
+	localport = vport->localport;
+	if (!localport)
+		goto out_exit;
+
+	spin_lock_irq(shost->host_lock);
+	lport = (struct lpfc_nvme_lport *)localport->private;
+
+	/* Port state is only one of two values for now. */
+	if (localport->port_id)
+		statep = "ONLINE";
+	else
+		statep = "UNKNOWN ";
+
+	len += snprintf(buf + len, size - len,
+			"Lport DID x%06x PortState %s\n",
+			localport->port_id, statep);
+
+	len += snprintf(buf + len, size - len, "\tRport List:\n");
+	list_for_each_entry(rport, &lport->rport_list, list) {
+		/* local short-hand pointer. */
+		nrport = rport->remoteport;
+
+		/* Port state is only one of two values for now. */
+		switch (nrport->port_state) {
+		case FC_OBJSTATE_ONLINE:
+			statep = "ONLINE";
+			break;
+		case FC_OBJSTATE_UNKNOWN:
+			statep = "UNKNOWN ";
+			break;
+		default:
+			statep = "UNSUPPORTED";
+			break;
+		}
+
+		/* Tab in to show lport ownership. */
+		len += snprintf(buf + len, size - len,
+				"\t%s Port ID:x%06x ",
+				statep, nrport->port_id);
+		len += snprintf(buf + len, size - len, "WWPN x%llx ",
+				nrport->port_name);
+		len += snprintf(buf + len, size - len, "WWNN x%llx ",
+				nrport->node_name);
+		switch (nrport->port_role) {
+		case FC_PORT_ROLE_NVME_INITIATOR:
+			len +=  snprintf(buf + len, size - len,
+					 "NVME INITIATOR ");
+			break;
+		case FC_PORT_ROLE_NVME_TARGET:
+			len +=  snprintf(buf + len, size - len,
+					 "NVME TARGET ");
+			break;
+		case FC_PORT_ROLE_NVME_DISCOVERY:
+			len +=  snprintf(buf + len, size - len,
+					 "NVME DISCOVERY ");
+			break;
+		default:
+			len +=  snprintf(buf + len, size - len,
+					 "UNKNOWN ROLE x%x",
+					 nrport->port_role);
+			break;
+		}
+
+		/* Terminate the string. */
+		len +=  snprintf(buf + len, size - len, "\n");
+	}
+
+	spin_unlock_irq(shost->host_lock);
+ out_exit:
+	return len;
+}
+
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
+	int len = 0;
+
+	if (phba->nvmet_support == 0) {
+		if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME))
+			return len;
+
+		len += snprintf(buf + len, size - len,
+				"\nNVME Lport Statistics\n");
+
+		len += snprintf(buf + len, size - len,
+				"LS: Xmt %016llx Cmpl %016llx\n",
+				phba->fc4NvmeLsRequests,
+				phba->fc4NvmeLsCmpls);
+
+		len += snprintf(buf + len, size - len,
+				"FCP: Rd %016llx Wr %016llx IO %016llx\n",
+				phba->fc4NvmeInputRequests,
+				phba->fc4NvmeOutputRequests,
+				phba->fc4NvmeControlRequests);
+
+		len += snprintf(buf + len, size - len,
+				"    Cmpl %016llx\n", phba->fc4NvmeIoCmpls);
+	}
+
+	return len;
+}
+
+
+/**
+ * lpfc_debugfs_nvmektime_data - Dump target node list to a buffer
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
+lpfc_debugfs_nvmektime_data(struct lpfc_vport *vport, char *buf, int size)
+{
+	struct lpfc_hba   *phba = vport->phba;
+	int len = 0;
+
+	if (phba->nvmet_support == 0) {
+		/* NVME Initiator */
+		len += snprintf(buf + len, PAGE_SIZE - len,
+				"ktime %s: Total Samples: %lld\n",
+				(phba->ktime_on ?  "Enabled" : "Disabled"),
+				phba->ktime_data_samples);
+		if (phba->ktime_data_samples == 0)
+			return len;
+
+		len += snprintf(
+			buf + len, PAGE_SIZE - len,
+			"Segment 1: Last NVME Cmd cmpl "
+			"done -to- Start of next NVME cnd (in driver)\n");
+		len += snprintf(
+			buf + len, PAGE_SIZE - len,
+			"avg:%08lld min:%08lld max %08lld\n",
+			phba->ktime_seg1_total /
+			phba->ktime_data_samples,
+			phba->ktime_seg1_min,
+			phba->ktime_seg1_max);
+		len += snprintf(
+			buf + len, PAGE_SIZE - len,
+			"Segment 2: Driver start of NVME cmd "
+			"-to- Firmware WQ doorbell\n");
+		len += snprintf(
+			buf + len, PAGE_SIZE - len,
+			"avg:%08lld min:%08lld max %08lld\n",
+			phba->ktime_seg2_total /
+			phba->ktime_data_samples,
+			phba->ktime_seg2_min,
+			phba->ktime_seg2_max);
+		len += snprintf(
+			buf + len, PAGE_SIZE - len,
+			"Segment 3: Firmware WQ doorbell -to- "
+			"MSI-X ISR cmpl\n");
+		len += snprintf(
+			buf + len, PAGE_SIZE - len,
+			"avg:%08lld min:%08lld max %08lld\n",
+			phba->ktime_seg3_total /
+			phba->ktime_data_samples,
+			phba->ktime_seg3_min,
+			phba->ktime_seg3_max);
+		len += snprintf(
+			buf + len, PAGE_SIZE - len,
+			"Segment 4: MSI-X ISR cmpl -to- "
+			"NVME cmpl done\n");
+		len += snprintf(
+			buf + len, PAGE_SIZE - len,
+			"avg:%08lld min:%08lld max %08lld\n",
+			phba->ktime_seg4_total /
+			phba->ktime_data_samples,
+			phba->ktime_seg4_min,
+			phba->ktime_seg4_max);
+		len += snprintf(
+			buf + len, PAGE_SIZE - len,
+			"Total IO avg time: %08lld\n",
+			((phba->ktime_seg1_total +
+			phba->ktime_seg2_total  +
+			phba->ktime_seg3_total +
+			phba->ktime_seg4_total) /
+			phba->ktime_data_samples));
+		return len;
+	}
+
+	return len;
+}
+
+/**
+ * lpfc_debugfs_nvmeio_trc_data - Dump NVME IO trace list to a buffer
+ * @phba: The phba to gather target node info from.
+ * @buf: The buffer to dump log into.
+ * @size: The maximum amount of data to process.
+ *
+ * Description:
+ * This routine dumps the NVME IO trace associated with @phba
+ *
+ * Return Value:
+ * This routine returns the amount of bytes that were dumped into @buf and will
+ * not exceed @size.
+ **/
+static int
+lpfc_debugfs_nvmeio_trc_data(struct lpfc_hba *phba, char *buf, int size)
+{
+	struct lpfc_debugfs_nvmeio_trc *dtp;
+	int i, state, index, skip;
+	int len = 0;
+
+	state = phba->nvmeio_trc_on;
+
+	index = (atomic_read(&phba->nvmeio_trc_cnt) + 1) &
+		(phba->nvmeio_trc_size - 1);
+	skip = phba->nvmeio_trc_output_idx;
+
+	len += snprintf(buf + len, size - len,
+			"%s IO Trace %s: next_idx %d skip %d size %d\n",
+			(phba->nvmet_support ? "NVME" : "NVMET"),
+			(state ? "Enabled" : "Disabled"),
+			index, skip, phba->nvmeio_trc_size);
+
+	if (!phba->nvmeio_trc || state)
+		return len;
+
+	/* trace MUST bhe off to continue */
+
+	for (i = index; i < phba->nvmeio_trc_size; i++) {
+		if (skip) {
+			skip--;
+			continue;
+		}
+		dtp = phba->nvmeio_trc + i;
+		phba->nvmeio_trc_output_idx++;
+
+		if (!dtp->fmt)
+			continue;
+
+		len +=  snprintf(buf + len, size - len, dtp->fmt,
+			dtp->data1, dtp->data2, dtp->data3);
+
+		if (phba->nvmeio_trc_output_idx >= phba->nvmeio_trc_size) {
+			phba->nvmeio_trc_output_idx = 0;
+			len += snprintf(buf + len, size - len,
+					"Trace Complete\n");
+			goto out;
+		}
+
+		if (len >= (size - LPFC_DEBUG_OUT_LINE_SZ)) {
+			len += snprintf(buf + len, size - len,
+					"Trace Continue (%d of %d)\n",
+					phba->nvmeio_trc_output_idx,
+					phba->nvmeio_trc_size);
+			goto out;
+		}
+	}
+	for (i = 0; i < index; i++) {
+		if (skip) {
+			skip--;
+			continue;
+		}
+		dtp = phba->nvmeio_trc + i;
+		phba->nvmeio_trc_output_idx++;
+
+		if (!dtp->fmt)
+			continue;
+
+		len +=  snprintf(buf + len, size - len, dtp->fmt,
+			dtp->data1, dtp->data2, dtp->data3);
+
+		if (phba->nvmeio_trc_output_idx >= phba->nvmeio_trc_size) {
+			phba->nvmeio_trc_output_idx = 0;
+			len += snprintf(buf + len, size - len,
+					"Trace Complete\n");
+			goto out;
+		}
+
+		if (len >= (size - LPFC_DEBUG_OUT_LINE_SZ)) {
+			len += snprintf(buf + len, size - len,
+					"Trace Continue (%d of %d)\n",
+					phba->nvmeio_trc_output_idx,
+					phba->nvmeio_trc_size);
+			goto out;
+		}
+	}
+
+	len += snprintf(buf + len, size - len,
+			"Trace Done\n");
+out:
+	return len;
+}
+
+/**
+ * lpfc_debugfs_cpucheck_data - Dump target node list to a buffer
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
+lpfc_debugfs_cpucheck_data(struct lpfc_vport *vport, char *buf, int size)
+{
+	struct lpfc_hba   *phba = vport->phba;
+	int i;
+	int len = 0;
+	uint32_t tot_xmt = 0;
+	uint32_t tot_cmpl = 0;
+
+	if (phba->nvmet_support == 0) {
+		/* NVME Initiator */
+		len += snprintf(buf + len, PAGE_SIZE - len,
+				"CPUcheck %s\n",
+				(phba->cpucheck_on & LPFC_CHECK_NVME_IO ?
+					"Enabled" : "Disabled"));
+		for (i = 0; i < phba->sli4_hba.num_present_cpu; i++) {
+			if (i >= LPFC_CHECK_CPU_CNT)
+				break;
+			len += snprintf(buf + len, PAGE_SIZE - len,
+					"%02d: xmit x%08x cmpl x%08x\n",
+					i, phba->cpucheck_xmt_io[i],
+					phba->cpucheck_cmpl_io[i]);
+			tot_xmt += phba->cpucheck_xmt_io[i];
+			tot_cmpl += phba->cpucheck_cmpl_io[i];
+		}
+		len += snprintf(buf + len, PAGE_SIZE - len,
+				"tot:xmit x%08x cmpl x%08x\n",
+				tot_xmt, tot_cmpl);
+		return len;
+	}
+
 	return len;
 }
 
@@ -699,6 +1065,40 @@ lpfc_debugfs_slow_ring_trc(struct lpfc_hba *phba, char *fmt,
 	return;
 }
 
+/**
+ * lpfc_debugfs_nvme_trc - Store NVME/NVMET trace log
+ * @phba: The phba to associate this trace string with for retrieval.
+ * @fmt: Format string to be displayed when dumping the log.
+ * @data1: 1st data parameter to be applied to @fmt.
+ * @data2: 2nd data parameter to be applied to @fmt.
+ * @data3: 3rd data parameter to be applied to @fmt.
+ *
+ * Description:
+ * This routine is used by the driver code to add a debugfs log entry to the
+ * nvme trace buffer associated with @phba. @fmt, @data1, @data2, and
+ * @data3 are used like printf when displaying the log.
+ **/
+inline void
+lpfc_debugfs_nvme_trc(struct lpfc_hba *phba, char *fmt,
+		      uint16_t data1, uint16_t data2, uint32_t data3)
+{
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+	struct lpfc_debugfs_nvmeio_trc *dtp;
+	int index;
+
+	if (!phba->nvmeio_trc_on || !phba->nvmeio_trc)
+		return;
+
+	index = atomic_inc_return(&phba->nvmeio_trc_cnt) &
+		(phba->nvmeio_trc_size - 1);
+	dtp = phba->nvmeio_trc + index;
+	dtp->fmt = fmt;
+	dtp->data1 = data1;
+	dtp->data2 = data2;
+	dtp->data3 = data3;
+#endif
+}
+
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 /**
  * lpfc_debugfs_disc_trc_open - Open the discovery trace log
@@ -1231,6 +1631,356 @@ lpfc_debugfs_dumpDataDif_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+
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
+static int
+lpfc_debugfs_nvmektime_open(struct inode *inode, struct file *file)
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
+	debug->buffer = kmalloc(LPFC_NVMEKTIME_SIZE, GFP_KERNEL);
+	if (!debug->buffer) {
+		kfree(debug);
+		goto out;
+	}
+
+	debug->len = lpfc_debugfs_nvmektime_data(vport, debug->buffer,
+		LPFC_NVMEKTIME_SIZE);
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
+lpfc_debugfs_nvmektime_write(struct file *file, const char __user *buf,
+			     size_t nbytes, loff_t *ppos)
+{
+	struct lpfc_debug *debug = file->private_data;
+	struct lpfc_vport *vport = (struct lpfc_vport *)debug->i_private;
+	struct lpfc_hba   *phba = vport->phba;
+	char mybuf[64];
+	char *pbuf;
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
+	if ((strncmp(pbuf, "on", sizeof("on") - 1) == 0)) {
+		phba->ktime_data_samples = 0;
+		phba->ktime_status_samples = 0;
+		phba->ktime_seg1_total = 0;
+		phba->ktime_seg1_max = 0;
+		phba->ktime_seg1_min = 0xffffffff;
+		phba->ktime_seg2_total = 0;
+		phba->ktime_seg2_max = 0;
+		phba->ktime_seg2_min = 0xffffffff;
+		phba->ktime_seg3_total = 0;
+		phba->ktime_seg3_max = 0;
+		phba->ktime_seg3_min = 0xffffffff;
+		phba->ktime_seg4_total = 0;
+		phba->ktime_seg4_max = 0;
+		phba->ktime_seg4_min = 0xffffffff;
+		phba->ktime_seg5_total = 0;
+		phba->ktime_seg5_max = 0;
+		phba->ktime_seg5_min = 0xffffffff;
+		phba->ktime_seg6_total = 0;
+		phba->ktime_seg6_max = 0;
+		phba->ktime_seg6_min = 0xffffffff;
+		phba->ktime_seg7_total = 0;
+		phba->ktime_seg7_max = 0;
+		phba->ktime_seg7_min = 0xffffffff;
+		phba->ktime_seg8_total = 0;
+		phba->ktime_seg8_max = 0;
+		phba->ktime_seg8_min = 0xffffffff;
+		phba->ktime_seg9_total = 0;
+		phba->ktime_seg9_max = 0;
+		phba->ktime_seg9_min = 0xffffffff;
+		phba->ktime_seg10_total = 0;
+		phba->ktime_seg10_max = 0;
+		phba->ktime_seg10_min = 0xffffffff;
+
+		phba->ktime_on = 1;
+		return strlen(pbuf);
+	} else if ((strncmp(pbuf, "off",
+		   sizeof("off") - 1) == 0)) {
+		phba->ktime_on = 0;
+		return strlen(pbuf);
+	} else if ((strncmp(pbuf, "zero",
+		   sizeof("zero") - 1) == 0)) {
+		phba->ktime_data_samples = 0;
+		phba->ktime_status_samples = 0;
+		phba->ktime_seg1_total = 0;
+		phba->ktime_seg1_max = 0;
+		phba->ktime_seg1_min = 0xffffffff;
+		phba->ktime_seg2_total = 0;
+		phba->ktime_seg2_max = 0;
+		phba->ktime_seg2_min = 0xffffffff;
+		phba->ktime_seg3_total = 0;
+		phba->ktime_seg3_max = 0;
+		phba->ktime_seg3_min = 0xffffffff;
+		phba->ktime_seg4_total = 0;
+		phba->ktime_seg4_max = 0;
+		phba->ktime_seg4_min = 0xffffffff;
+		phba->ktime_seg5_total = 0;
+		phba->ktime_seg5_max = 0;
+		phba->ktime_seg5_min = 0xffffffff;
+		phba->ktime_seg6_total = 0;
+		phba->ktime_seg6_max = 0;
+		phba->ktime_seg6_min = 0xffffffff;
+		phba->ktime_seg7_total = 0;
+		phba->ktime_seg7_max = 0;
+		phba->ktime_seg7_min = 0xffffffff;
+		phba->ktime_seg8_total = 0;
+		phba->ktime_seg8_max = 0;
+		phba->ktime_seg8_min = 0xffffffff;
+		phba->ktime_seg9_total = 0;
+		phba->ktime_seg9_max = 0;
+		phba->ktime_seg9_min = 0xffffffff;
+		phba->ktime_seg10_total = 0;
+		phba->ktime_seg10_max = 0;
+		phba->ktime_seg10_min = 0xffffffff;
+		return strlen(pbuf);
+	}
+	return -EINVAL;
+}
+
+static int
+lpfc_debugfs_nvmeio_trc_open(struct inode *inode, struct file *file)
+{
+	struct lpfc_hba *phba = inode->i_private;
+	struct lpfc_debug *debug;
+	int rc = -ENOMEM;
+
+	debug = kmalloc(sizeof(*debug), GFP_KERNEL);
+	if (!debug)
+		goto out;
+
+	 /* Round to page boundary */
+	debug->buffer = kmalloc(LPFC_NVMEIO_TRC_SIZE, GFP_KERNEL);
+	if (!debug->buffer) {
+		kfree(debug);
+		goto out;
+	}
+
+	debug->len = lpfc_debugfs_nvmeio_trc_data(phba, debug->buffer,
+		LPFC_NVMEIO_TRC_SIZE);
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
+lpfc_debugfs_nvmeio_trc_write(struct file *file, const char __user *buf,
+			      size_t nbytes, loff_t *ppos)
+{
+	struct lpfc_debug *debug = file->private_data;
+	struct lpfc_hba *phba = (struct lpfc_hba *)debug->i_private;
+	int i;
+	unsigned long sz;
+	char mybuf[64];
+	char *pbuf;
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
+	if ((strncmp(pbuf, "off", sizeof("off") - 1) == 0)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0570 nvmeio_trc_off\n");
+		phba->nvmeio_trc_output_idx = 0;
+		phba->nvmeio_trc_on = 0;
+		return strlen(pbuf);
+	} else if ((strncmp(pbuf, "on", sizeof("on") - 1) == 0)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0571 nvmeio_trc_on\n");
+		phba->nvmeio_trc_output_idx = 0;
+		phba->nvmeio_trc_on = 1;
+		return strlen(pbuf);
+	}
+
+	/* We must be off to allocate the trace buffer */
+	if (phba->nvmeio_trc_on != 0)
+		return -EINVAL;
+
+	/* If not on or off, the parameter is the trace buffer size */
+	i = kstrtoul(pbuf, 0, &sz);
+	if (i)
+		return -EINVAL;
+	phba->nvmeio_trc_size = (uint32_t)sz;
+
+	/* It must be a power of 2 - round down */
+	i = 0;
+	while (sz > 1) {
+		sz = sz >> 1;
+		i++;
+	}
+	sz = (1 << i);
+	if (phba->nvmeio_trc_size != sz)
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0572 nvmeio_trc_size changed to %ld\n",
+				sz);
+	phba->nvmeio_trc_size = (uint32_t)sz;
+
+	/* If one previously exists, free it */
+	kfree(phba->nvmeio_trc);
+
+	/* Allocate new trace buffer and initialize */
+	phba->nvmeio_trc = kmalloc((sizeof(struct lpfc_debugfs_nvmeio_trc) *
+				    sz), GFP_KERNEL);
+	if (!phba->nvmeio_trc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0573 Cannot create debugfs "
+				"nvmeio_trc buffer\n");
+		return -ENOMEM;
+	}
+	memset(phba->nvmeio_trc, 0,
+	       (sizeof(struct lpfc_debugfs_nvmeio_trc) * sz));
+	atomic_set(&phba->nvmeio_trc_cnt, 0);
+	phba->nvmeio_trc_on = 0;
+	phba->nvmeio_trc_output_idx = 0;
+
+	return strlen(pbuf);
+}
+
+static int
+lpfc_debugfs_cpucheck_open(struct inode *inode, struct file *file)
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
+	debug->buffer = kmalloc(LPFC_CPUCHECK_SIZE, GFP_KERNEL);
+	if (!debug->buffer) {
+		kfree(debug);
+		goto out;
+	}
+
+	debug->len = lpfc_debugfs_cpucheck_data(vport, debug->buffer,
+		LPFC_NVMEKTIME_SIZE);
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
+lpfc_debugfs_cpucheck_write(struct file *file, const char __user *buf,
+			    size_t nbytes, loff_t *ppos)
+{
+	struct lpfc_debug *debug = file->private_data;
+	struct lpfc_vport *vport = (struct lpfc_vport *)debug->i_private;
+	struct lpfc_hba   *phba = vport->phba;
+	char mybuf[64];
+	char *pbuf;
+	int i;
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
+	if ((strncmp(pbuf, "on", sizeof("on") - 1) == 0)) {
+		phba->cpucheck_on |= LPFC_CHECK_NVME_IO;
+		return strlen(pbuf);
+	} else if ((strncmp(pbuf, "rcv",
+		   sizeof("rcv") - 1) == 0)) {
+		return -EINVAL;
+	} else if ((strncmp(pbuf, "off",
+		   sizeof("off") - 1) == 0)) {
+		phba->cpucheck_on = LPFC_CHECK_OFF;
+		return strlen(pbuf);
+	} else if ((strncmp(pbuf, "zero",
+		   sizeof("zero") - 1) == 0)) {
+		for (i = 0; i < phba->sli4_hba.num_present_cpu; i++) {
+			if (i >= LPFC_CHECK_CPU_CNT)
+				break;
+			phba->cpucheck_rcv_io[i] = 0;
+			phba->cpucheck_xmt_io[i] = 0;
+			phba->cpucheck_cmpl_io[i] = 0;
+			phba->cpucheck_ccmpl_io[i] = 0;
+		}
+		return strlen(pbuf);
+	}
+	return -EINVAL;
+}
+
 /*
  * ---------------------------------
  * iDiag debugfs file access methods
@@ -2581,6 +3331,17 @@ lpfc_idiag_queacc_write(struct file *file, const char __user *buf,
 			idiag.ptr_private = phba->sli4_hba.nvmels_cq;
 			goto pass_check;
 		}
+		/* NVME LS complete queue */
+		if (phba->sli4_hba.nvmels_cq &&
+		    phba->sli4_hba.nvmels_cq->queue_id == queid) {
+			/* Sanity check */
+			rc = lpfc_idiag_que_param_check(
+					phba->sli4_hba.nvmels_cq, index, count);
+			if (rc)
+				goto error_out;
+			idiag.ptr_private = phba->sli4_hba.nvmels_cq;
+			goto pass_check;
+		}
 		/* FCP complete queue */
 		if (phba->sli4_hba.fcp_cq) {
 			for (qidx = 0; qidx < phba->cfg_fcp_io_channel;
@@ -2597,6 +3358,25 @@ lpfc_idiag_queacc_write(struct file *file, const char __user *buf,
 				}
 			}
 		}
+		/* NVME complete queue */
+		if (phba->sli4_hba.nvme_cq) {
+			qidx = 0;
+			do {
+				if (phba->sli4_hba.nvme_cq[qidx] &&
+				    phba->sli4_hba.nvme_cq[qidx]->queue_id ==
+				    queid) {
+					/* Sanity check */
+					rc = lpfc_idiag_que_param_check(
+						phba->sli4_hba.nvme_cq[qidx],
+						index, count);
+					if (rc)
+						goto error_out;
+					idiag.ptr_private =
+						phba->sli4_hba.nvme_cq[qidx];
+					goto pass_check;
+				}
+			} while (++qidx < phba->cfg_nvme_io_channel);
+		}
 		goto error_out;
 		break;
 	case LPFC_IDIAG_MQ:
@@ -2636,6 +3416,17 @@ lpfc_idiag_queacc_write(struct file *file, const char __user *buf,
 			idiag.ptr_private = phba->sli4_hba.nvmels_wq;
 			goto pass_check;
 		}
+		/* NVME LS work queue */
+		if (phba->sli4_hba.nvmels_wq &&
+		    phba->sli4_hba.nvmels_wq->queue_id == queid) {
+			/* Sanity check */
+			rc = lpfc_idiag_que_param_check(
+					phba->sli4_hba.nvmels_wq, index, count);
+			if (rc)
+				goto error_out;
+			idiag.ptr_private = phba->sli4_hba.nvmels_wq;
+			goto pass_check;
+		}
 		/* FCP work queue */
 		if (phba->sli4_hba.fcp_wq) {
 			for (qidx = 0; qidx < phba->cfg_fcp_io_channel;
@@ -2668,6 +3459,27 @@ lpfc_idiag_queacc_write(struct file *file, const char __user *buf,
 				}
 			}
 		}
+
+		/* NVME work queues */
+		if (phba->sli4_hba.nvme_wq) {
+			for (qidx = 0; qidx < phba->cfg_nvme_io_channel;
+				qidx++) {
+				if (!phba->sli4_hba.nvme_wq[qidx])
+					continue;
+				if (phba->sli4_hba.nvme_wq[qidx]->queue_id ==
+				    queid) {
+					/* Sanity check */
+					rc = lpfc_idiag_que_param_check(
+						phba->sli4_hba.nvme_wq[qidx],
+						index, count);
+					if (rc)
+						goto error_out;
+					idiag.ptr_private =
+						phba->sli4_hba.nvme_wq[qidx];
+					goto pass_check;
+				}
+			}
+		}
 		goto error_out;
 		break;
 	case LPFC_IDIAG_RQ:
@@ -3651,6 +4463,45 @@ static const struct file_operations lpfc_debugfs_op_dumpHostSlim = {
 	.release =      lpfc_debugfs_release,
 };
 
+#undef lpfc_debugfs_op_nvmestat
+static const struct file_operations lpfc_debugfs_op_nvmestat = {
+	.owner =        THIS_MODULE,
+	.open =         lpfc_debugfs_nvmestat_open,
+	.llseek =       lpfc_debugfs_lseek,
+	.read =         lpfc_debugfs_read,
+	.release =      lpfc_debugfs_release,
+};
+
+#undef lpfc_debugfs_op_nvmektime
+static const struct file_operations lpfc_debugfs_op_nvmektime = {
+	.owner =        THIS_MODULE,
+	.open =         lpfc_debugfs_nvmektime_open,
+	.llseek =       lpfc_debugfs_lseek,
+	.read =         lpfc_debugfs_read,
+	.write =	lpfc_debugfs_nvmektime_write,
+	.release =      lpfc_debugfs_release,
+};
+
+#undef lpfc_debugfs_op_nvmeio_trc
+static const struct file_operations lpfc_debugfs_op_nvmeio_trc = {
+	.owner =        THIS_MODULE,
+	.open =         lpfc_debugfs_nvmeio_trc_open,
+	.llseek =       lpfc_debugfs_lseek,
+	.read =         lpfc_debugfs_read,
+	.write =	lpfc_debugfs_nvmeio_trc_write,
+	.release =      lpfc_debugfs_release,
+};
+
+#undef lpfc_debugfs_op_cpucheck
+static const struct file_operations lpfc_debugfs_op_cpucheck = {
+	.owner =        THIS_MODULE,
+	.open =         lpfc_debugfs_cpucheck_open,
+	.llseek =       lpfc_debugfs_lseek,
+	.read =         lpfc_debugfs_read,
+	.write =	lpfc_debugfs_cpucheck_write,
+	.release =      lpfc_debugfs_release,
+};
+
 #undef lpfc_debugfs_op_dumpData
 static const struct file_operations lpfc_debugfs_op_dumpData = {
 	.owner =        THIS_MODULE,
@@ -4237,6 +5088,60 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 				lpfc_debugfs_max_slow_ring_trc));
 		}
 
+		snprintf(name, sizeof(name), "nvmeio_trc");
+		phba->debug_nvmeio_trc =
+			debugfs_create_file(name, 0644,
+					    phba->hba_debugfs_root,
+					    phba, &lpfc_debugfs_op_nvmeio_trc);
+		if (!phba->debug_nvmeio_trc) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
+					 "0574 No create debugfs nvmeio_trc\n");
+			goto debug_failed;
+		}
+
+		atomic_set(&phba->nvmeio_trc_cnt, 0);
+		if (lpfc_debugfs_max_nvmeio_trc) {
+			num = lpfc_debugfs_max_nvmeio_trc - 1;
+			if (num & lpfc_debugfs_max_disc_trc) {
+				/* Change to be a power of 2 */
+				num = lpfc_debugfs_max_nvmeio_trc;
+				i = 0;
+				while (num > 1) {
+					num = num >> 1;
+					i++;
+				}
+				lpfc_debugfs_max_nvmeio_trc = (1 << i);
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"0575 lpfc_debugfs_max_nvmeio_trc "
+						"changed to %d\n",
+						lpfc_debugfs_max_nvmeio_trc);
+			}
+			phba->nvmeio_trc_size = lpfc_debugfs_max_nvmeio_trc;
+
+			/* Allocate trace buffer and initialize */
+			phba->nvmeio_trc = kmalloc(
+				(sizeof(struct lpfc_debugfs_nvmeio_trc) *
+				phba->nvmeio_trc_size), GFP_KERNEL);
+
+			if (!phba->nvmeio_trc) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"0576 Cannot create debugfs "
+						"nvmeio_trc buffer\n");
+				goto nvmeio_off;
+			}
+			memset(phba->nvmeio_trc, 0,
+			       (sizeof(struct lpfc_debugfs_nvmeio_trc) *
+			       phba->nvmeio_trc_size));
+			phba->nvmeio_trc_on = 1;
+			phba->nvmeio_trc_output_idx = 0;
+			phba->nvmeio_trc = NULL;
+		} else {
+nvmeio_off:
+			phba->nvmeio_trc_size = 0;
+			phba->nvmeio_trc_on = 0;
+			phba->nvmeio_trc_output_idx = 0;
+			phba->nvmeio_trc = NULL;
+		}
 	}
 
 	snprintf(name, sizeof(name), "vport%d", vport->vpi);
@@ -4301,6 +5206,39 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 		goto debug_failed;
 	}
 
+	snprintf(name, sizeof(name), "nvmestat");
+	vport->debug_nvmestat =
+		debugfs_create_file(name, 0644,
+				    vport->vport_debugfs_root,
+				    vport, &lpfc_debugfs_op_nvmestat);
+	if (!vport->debug_nvmestat) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
+				 "0811 Cannot create debugfs nvmestat\n");
+		goto debug_failed;
+	}
+
+	snprintf(name, sizeof(name), "nvmektime");
+	vport->debug_nvmektime =
+		debugfs_create_file(name, 0644,
+				    vport->vport_debugfs_root,
+				    vport, &lpfc_debugfs_op_nvmektime);
+	if (!vport->debug_nvmektime) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
+				 "0815 Cannot create debugfs nvmektime\n");
+		goto debug_failed;
+	}
+
+	snprintf(name, sizeof(name), "cpucheck");
+	vport->debug_cpucheck =
+		debugfs_create_file(name, 0644,
+				    vport->vport_debugfs_root,
+				    vport, &lpfc_debugfs_op_cpucheck);
+	if (!vport->debug_cpucheck) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
+				 "0819 Cannot create debugfs cpucheck\n");
+		goto debug_failed;
+	}
+
 	/*
 	 * The following section is for additional directories/files for the
 	 * physical port.
@@ -4465,140 +5403,126 @@ lpfc_debugfs_terminate(struct lpfc_vport *vport)
 		kfree(vport->disc_trc);
 		vport->disc_trc = NULL;
 	}
-	if (vport->debug_disc_trc) {
-		debugfs_remove(vport->debug_disc_trc); /* discovery_trace */
-		vport->debug_disc_trc = NULL;
-	}
-	if (vport->debug_nodelist) {
-		debugfs_remove(vport->debug_nodelist); /* nodelist */
-		vport->debug_nodelist = NULL;
-	}
+
+	debugfs_remove(vport->debug_disc_trc); /* discovery_trace */
+	vport->debug_disc_trc = NULL;
+
+	debugfs_remove(vport->debug_nodelist); /* nodelist */
+	vport->debug_nodelist = NULL;
+
+	debugfs_remove(vport->debug_nvmestat); /* nvmestat */
+	vport->debug_nvmestat = NULL;
+
+	debugfs_remove(vport->debug_nvmektime); /* nvmektime */
+	vport->debug_nvmektime = NULL;
+
+	debugfs_remove(vport->debug_cpucheck); /* cpucheck */
+	vport->debug_cpucheck = NULL;
+
 	if (vport->vport_debugfs_root) {
 		debugfs_remove(vport->vport_debugfs_root); /* vportX */
 		vport->vport_debugfs_root = NULL;
 		atomic_dec(&phba->debugfs_vport_count);
 	}
+
 	if (atomic_read(&phba->debugfs_vport_count) == 0) {
 
-		if (phba->debug_hbqinfo) {
-			debugfs_remove(phba->debug_hbqinfo); /* hbqinfo */
-			phba->debug_hbqinfo = NULL;
-		}
-		if (phba->debug_dumpHBASlim) {
-			debugfs_remove(phba->debug_dumpHBASlim); /* HBASlim */
-			phba->debug_dumpHBASlim = NULL;
-		}
-		if (phba->debug_dumpHostSlim) {
-			debugfs_remove(phba->debug_dumpHostSlim); /* HostSlim */
-			phba->debug_dumpHostSlim = NULL;
-		}
-		if (phba->debug_dumpData) {
-			debugfs_remove(phba->debug_dumpData); /* dumpData */
-			phba->debug_dumpData = NULL;
-		}
+		debugfs_remove(phba->debug_hbqinfo); /* hbqinfo */
+		phba->debug_hbqinfo = NULL;
 
-		if (phba->debug_dumpDif) {
-			debugfs_remove(phba->debug_dumpDif); /* dumpDif */
-			phba->debug_dumpDif = NULL;
-		}
-		if (phba->debug_InjErrLBA) {
-			debugfs_remove(phba->debug_InjErrLBA); /* InjErrLBA */
-			phba->debug_InjErrLBA = NULL;
-		}
-		if (phba->debug_InjErrNPortID) {	 /* InjErrNPortID */
-			debugfs_remove(phba->debug_InjErrNPortID);
-			phba->debug_InjErrNPortID = NULL;
-		}
-		if (phba->debug_InjErrWWPN) {
-			debugfs_remove(phba->debug_InjErrWWPN); /* InjErrWWPN */
-			phba->debug_InjErrWWPN = NULL;
-		}
-		if (phba->debug_writeGuard) {
-			debugfs_remove(phba->debug_writeGuard); /* writeGuard */
-			phba->debug_writeGuard = NULL;
-		}
-		if (phba->debug_writeApp) {
-			debugfs_remove(phba->debug_writeApp); /* writeApp */
-			phba->debug_writeApp = NULL;
-		}
-		if (phba->debug_writeRef) {
-			debugfs_remove(phba->debug_writeRef); /* writeRef */
-			phba->debug_writeRef = NULL;
-		}
-		if (phba->debug_readGuard) {
-			debugfs_remove(phba->debug_readGuard); /* readGuard */
-			phba->debug_readGuard = NULL;
-		}
-		if (phba->debug_readApp) {
-			debugfs_remove(phba->debug_readApp); /* readApp */
-			phba->debug_readApp = NULL;
-		}
-		if (phba->debug_readRef) {
-			debugfs_remove(phba->debug_readRef); /* readRef */
-			phba->debug_readRef = NULL;
-		}
+		debugfs_remove(phba->debug_dumpHBASlim); /* HBASlim */
+		phba->debug_dumpHBASlim = NULL;
+
+		debugfs_remove(phba->debug_dumpHostSlim); /* HostSlim */
+		phba->debug_dumpHostSlim = NULL;
+
+		debugfs_remove(phba->debug_dumpData); /* dumpData */
+		phba->debug_dumpData = NULL;
+
+		debugfs_remove(phba->debug_dumpDif); /* dumpDif */
+		phba->debug_dumpDif = NULL;
+
+		debugfs_remove(phba->debug_InjErrLBA); /* InjErrLBA */
+		phba->debug_InjErrLBA = NULL;
+
+		debugfs_remove(phba->debug_InjErrNPortID);
+		phba->debug_InjErrNPortID = NULL;
+
+		debugfs_remove(phba->debug_InjErrWWPN); /* InjErrWWPN */
+		phba->debug_InjErrWWPN = NULL;
+
+		debugfs_remove(phba->debug_writeGuard); /* writeGuard */
+		phba->debug_writeGuard = NULL;
+
+		debugfs_remove(phba->debug_writeApp); /* writeApp */
+		phba->debug_writeApp = NULL;
+
+		debugfs_remove(phba->debug_writeRef); /* writeRef */
+		phba->debug_writeRef = NULL;
+
+		debugfs_remove(phba->debug_readGuard); /* readGuard */
+		phba->debug_readGuard = NULL;
+
+		debugfs_remove(phba->debug_readApp); /* readApp */
+		phba->debug_readApp = NULL;
+
+		debugfs_remove(phba->debug_readRef); /* readRef */
+		phba->debug_readRef = NULL;
 
 		if (phba->slow_ring_trc) {
 			kfree(phba->slow_ring_trc);
 			phba->slow_ring_trc = NULL;
 		}
-		if (phba->debug_slow_ring_trc) {
-			/* slow_ring_trace */
-			debugfs_remove(phba->debug_slow_ring_trc);
-			phba->debug_slow_ring_trc = NULL;
-		}
+
+		/* slow_ring_trace */
+		debugfs_remove(phba->debug_slow_ring_trc);
+		phba->debug_slow_ring_trc = NULL;
+
+		debugfs_remove(phba->debug_nvmeio_trc);
+		phba->debug_nvmeio_trc = NULL;
+
+		kfree(phba->nvmeio_trc);
+		phba->nvmeio_trc = NULL;
 
 		/*
 		 * iDiag release
 		 */
 		if (phba->sli_rev == LPFC_SLI_REV4) {
-			if (phba->idiag_ext_acc) {
-				/* iDiag extAcc */
-				debugfs_remove(phba->idiag_ext_acc);
-				phba->idiag_ext_acc = NULL;
-			}
-			if (phba->idiag_mbx_acc) {
-				/* iDiag mbxAcc */
-				debugfs_remove(phba->idiag_mbx_acc);
-				phba->idiag_mbx_acc = NULL;
-			}
-			if (phba->idiag_ctl_acc) {
-				/* iDiag ctlAcc */
-				debugfs_remove(phba->idiag_ctl_acc);
-				phba->idiag_ctl_acc = NULL;
-			}
-			if (phba->idiag_drb_acc) {
-				/* iDiag drbAcc */
-				debugfs_remove(phba->idiag_drb_acc);
-				phba->idiag_drb_acc = NULL;
-			}
-			if (phba->idiag_que_acc) {
-				/* iDiag queAcc */
-				debugfs_remove(phba->idiag_que_acc);
-				phba->idiag_que_acc = NULL;
-			}
-			if (phba->idiag_que_info) {
-				/* iDiag queInfo */
-				debugfs_remove(phba->idiag_que_info);
-				phba->idiag_que_info = NULL;
-			}
-			if (phba->idiag_bar_acc) {
-				/* iDiag barAcc */
-				debugfs_remove(phba->idiag_bar_acc);
-				phba->idiag_bar_acc = NULL;
-			}
-			if (phba->idiag_pci_cfg) {
-				/* iDiag pciCfg */
-				debugfs_remove(phba->idiag_pci_cfg);
-				phba->idiag_pci_cfg = NULL;
-			}
+			/* iDiag extAcc */
+			debugfs_remove(phba->idiag_ext_acc);
+			phba->idiag_ext_acc = NULL;
+
+			/* iDiag mbxAcc */
+			debugfs_remove(phba->idiag_mbx_acc);
+			phba->idiag_mbx_acc = NULL;
+
+			/* iDiag ctlAcc */
+			debugfs_remove(phba->idiag_ctl_acc);
+			phba->idiag_ctl_acc = NULL;
+
+			/* iDiag drbAcc */
+			debugfs_remove(phba->idiag_drb_acc);
+			phba->idiag_drb_acc = NULL;
+
+			/* iDiag queAcc */
+			debugfs_remove(phba->idiag_que_acc);
+			phba->idiag_que_acc = NULL;
+
+			/* iDiag queInfo */
+			debugfs_remove(phba->idiag_que_info);
+			phba->idiag_que_info = NULL;
+
+			/* iDiag barAcc */
+			debugfs_remove(phba->idiag_bar_acc);
+			phba->idiag_bar_acc = NULL;
+
+			/* iDiag pciCfg */
+			debugfs_remove(phba->idiag_pci_cfg);
+			phba->idiag_pci_cfg = NULL;
 
 			/* Finally remove the iDiag debugfs root */
-			if (phba->idiag_root) {
-				/* iDiag root */
-				debugfs_remove(phba->idiag_root);
-				phba->idiag_root = NULL;
-			}
+			debugfs_remove(phba->idiag_root);
+			phba->idiag_root = NULL;
 		}
 
 		if (phba->hba_debugfs_root) {
@@ -4607,10 +5531,8 @@ lpfc_debugfs_terminate(struct lpfc_vport *vport)
 			atomic_dec(&lpfc_debugfs_hba_count);
 		}
 
-		if (atomic_read(&lpfc_debugfs_hba_count) == 0) {
-			debugfs_remove(lpfc_debugfs_root); /* lpfc */
-			lpfc_debugfs_root = NULL;
-		}
+		debugfs_remove(lpfc_debugfs_root); /* lpfc */
+		lpfc_debugfs_root = NULL;
 	}
 #endif
 	return;
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
index 98814d6..5312e0f9 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -50,6 +50,14 @@ enum {
 	DUMP_NVMELS,
 };
 
+/* nvmestat output buffer size */
+#define LPFC_NVMESTAT_SIZE 8192
+#define LPFC_NVMEKTIME_SIZE 8192
+#define LPFC_CPUCHECK_SIZE 8192
+#define LPFC_NVMEIO_TRC_SIZE 8192
+
+#define LPFC_DEBUG_OUT_LINE_SZ	80
+
 /*
  * For SLI4 iDiag debugfs diagnostics tool
  */
@@ -196,6 +204,12 @@ enum {
 #define SIZE_U16 sizeof(uint16_t)
 #define SIZE_U32 sizeof(uint32_t)
 
+#define lpfc_nvmeio_data(phba, fmt, arg...) \
+	{ \
+	if (phba->nvmeio_trc_on) \
+		lpfc_debugfs_nvme_trc(phba, fmt, ##arg); \
+	}
+
 struct lpfc_debug {
 	char *i_private;
 	char op;
@@ -214,6 +228,13 @@ struct lpfc_debugfs_trc {
 	unsigned long jif;
 };
 
+struct lpfc_debugfs_nvmeio_trc {
+	char *fmt;
+	uint16_t data1;
+	uint16_t data2;
+	uint32_t data3;
+};
+
 struct lpfc_idiag_offset {
 	uint32_t last_rd;
 };
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 729803d..56b4b94 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -50,6 +50,7 @@
 #include "lpfc_logmsg.h"
 #include "lpfc_crtn.h"
 #include "lpfc_vport.h"
+#include "lpfc_debugfs.h"
 
 /* NVME initiator-based functions */
 
@@ -222,6 +223,9 @@ lpfc_nvme_cmpl_gen_req(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 			 cmdwqe->sli4_xritag, status,
 			 cmdwqe, pnvme_lsreq, cmdwqe->context3, ndlp);
 
+	lpfc_nvmeio_data(phba, "NVME LS  CMPL: xri x%x stat x%x parm x%x\n",
+			 cmdwqe->sli4_xritag, status, wcqe->parameter);
+
 	if (cmdwqe->context3) {
 		buf_ptr = (struct lpfc_dmabuf *)cmdwqe->context3;
 		lpfc_mbuf_free(phba, buf_ptr->virt, buf_ptr->phys);
@@ -355,6 +359,9 @@ lpfc_nvme_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 	genwqe->vport = vport;
 	genwqe->retry = retry;
 
+	lpfc_nvmeio_data(phba, "NVME LS  XMIT: xri x%x iotag x%x to x%06x\n",
+			 genwqe->sli4_xritag, genwqe->iotag, ndlp->nlp_DID);
+
 	rc = lpfc_sli4_issue_wqe(phba, LPFC_ELS_RING, genwqe);
 	if (rc == WQE_ERROR) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
@@ -637,6 +644,79 @@ lpfc_nvme_adj_fcp_sgls(struct lpfc_vport *vport,
 	*wptr   = *dptr;	/* Word 23 */
 }
 
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+static void
+lpfc_nvme_ktime(struct lpfc_hba *phba,
+		struct lpfc_nvme_buf *lpfc_ncmd)
+{
+	uint64_t seg1, seg2, seg3, seg4;
+
+	if (!phba->ktime_on)
+		return;
+	if (!lpfc_ncmd->ts_last_cmd ||
+	    !lpfc_ncmd->ts_cmd_start ||
+	    !lpfc_ncmd->ts_cmd_wqput ||
+	    !lpfc_ncmd->ts_isr_cmpl ||
+	    !lpfc_ncmd->ts_data_nvme)
+		return;
+	if (lpfc_ncmd->ts_cmd_start < lpfc_ncmd->ts_last_cmd)
+		return;
+	if (lpfc_ncmd->ts_cmd_wqput < lpfc_ncmd->ts_cmd_start)
+		return;
+	if (lpfc_ncmd->ts_isr_cmpl < lpfc_ncmd->ts_cmd_wqput)
+		return;
+	if (lpfc_ncmd->ts_data_nvme < lpfc_ncmd->ts_isr_cmpl)
+		return;
+	/*
+	 * Segment 1 - Time from Last FCP command cmpl is handed
+	 * off to NVME Layer to start of next command.
+	 * Segment 2 - Time from Driver receives a IO cmd start
+	 * from NVME Layer to WQ put is done on IO cmd.
+	 * Segment 3 - Time from Driver WQ put is done on IO cmd
+	 * to MSI-X ISR for IO cmpl.
+	 * Segment 4 - Time from MSI-X ISR for IO cmpl to when
+	 * cmpl is handled off to the NVME Layer.
+	 */
+	seg1 = lpfc_ncmd->ts_cmd_start - lpfc_ncmd->ts_last_cmd;
+	if (seg1 > 5000000)  /* 5 ms - for sequential IOs */
+		return;
+
+	/* Calculate times relative to start of IO */
+	seg2 = (lpfc_ncmd->ts_cmd_wqput - lpfc_ncmd->ts_cmd_start);
+	seg3 = (lpfc_ncmd->ts_isr_cmpl -
+		lpfc_ncmd->ts_cmd_start) - seg2;
+	seg4 = (lpfc_ncmd->ts_data_nvme -
+		lpfc_ncmd->ts_cmd_start) - seg2 - seg3;
+	phba->ktime_data_samples++;
+	phba->ktime_seg1_total += seg1;
+	if (seg1 < phba->ktime_seg1_min)
+		phba->ktime_seg1_min = seg1;
+	else if (seg1 > phba->ktime_seg1_max)
+		phba->ktime_seg1_max = seg1;
+	phba->ktime_seg2_total += seg2;
+	if (seg2 < phba->ktime_seg2_min)
+		phba->ktime_seg2_min = seg2;
+	else if (seg2 > phba->ktime_seg2_max)
+		phba->ktime_seg2_max = seg2;
+	phba->ktime_seg3_total += seg3;
+	if (seg3 < phba->ktime_seg3_min)
+		phba->ktime_seg3_min = seg3;
+	else if (seg3 > phba->ktime_seg3_max)
+		phba->ktime_seg3_max = seg3;
+	phba->ktime_seg4_total += seg4;
+	if (seg4 < phba->ktime_seg4_min)
+		phba->ktime_seg4_min = seg4;
+	else if (seg4 > phba->ktime_seg4_max)
+		phba->ktime_seg4_max = seg4;
+
+	lpfc_ncmd->ts_last_cmd = 0;
+	lpfc_ncmd->ts_cmd_start = 0;
+	lpfc_ncmd->ts_cmd_wqput  = 0;
+	lpfc_ncmd->ts_isr_cmpl = 0;
+	lpfc_ncmd->ts_data_nvme = 0;
+}
+#endif
+
 /**
  * lpfc_nvme_io_cmd_wqe_cmpl - Complete an NVME-over-FCP IO
  * @lpfc_pnvme: Pointer to the driver's nvme instance data
@@ -680,6 +760,9 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	nCmd = lpfc_ncmd->nvmeCmd;
 	rport = lpfc_ncmd->nrport;
 
+	lpfc_nvmeio_data(phba, "NVME FCP CMPL: xri x%x stat x%x parm x%x\n",
+			 lpfc_ncmd->cur_iocbq.sli4_xritag,
+			 bf_get(lpfc_wcqe_c_status, wcqe), wcqe->parameter);
 	/*
 	 * Catch race where our node has transitioned, but the
 	 * transport is still transitioning.
@@ -798,6 +881,23 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	 * no need for dma unprep because the nvme_transport
 	 * owns the dma address.
 	 */
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+	if (phba->ktime_on) {
+		lpfc_ncmd->ts_isr_cmpl = pwqeIn->isr_timestamp;
+		lpfc_ncmd->ts_data_nvme = ktime_get_ns();
+		phba->ktime_last_cmd = lpfc_ncmd->ts_data_nvme;
+		lpfc_nvme_ktime(phba, lpfc_ncmd);
+	}
+	if (phba->cpucheck_on & LPFC_CHECK_NVME_IO) {
+		if (lpfc_ncmd->cpu != smp_processor_id())
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_IOERR,
+					 "6701 CPU Check cmpl: "
+					 "cpu %d expect %d\n",
+					 smp_processor_id(), lpfc_ncmd->cpu);
+		if (lpfc_ncmd->cpu < LPFC_CHECK_CPU_CNT)
+			phba->cpucheck_cmpl_io[lpfc_ncmd->cpu]++;
+	}
+#endif
 	nCmd->done(nCmd);
 
 	spin_lock_irqsave(&phba->hbalock, flags);
@@ -1103,11 +1203,18 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 	struct lpfc_nvme_buf *lpfc_ncmd;
 	struct lpfc_nvme_rport *rport;
 	struct lpfc_nvme_qhandle *lpfc_queue_info;
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+	uint64_t start = 0;
+#endif
 
 	lport = (struct lpfc_nvme_lport *)pnvme_lport->private;
 	vport = lport->vport;
 	phba = vport->phba;
 
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+	if (phba->ktime_on)
+		start = ktime_get_ns();
+#endif
 	rport = (struct lpfc_nvme_rport *)pnvme_rport->private;
 	lpfc_queue_info = (struct lpfc_nvme_qhandle *)hw_queue_handle;
 
@@ -1161,6 +1268,12 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 		ret = -ENOMEM;
 		goto out_fail;
 	}
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+	if (phba->ktime_on) {
+		lpfc_ncmd->ts_cmd_start = start;
+		lpfc_ncmd->ts_last_cmd = phba->ktime_last_cmd;
+	}
+#endif
 
 	/*
 	 * Store the data needed by the driver to issue, abort, and complete
@@ -1192,6 +1305,10 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 	 */
 	lpfc_ncmd->cur_iocbq.hba_wqidx = lpfc_queue_info->index;
 
+	lpfc_nvmeio_data(phba, "NVME FCP XMIT: xri x%x idx %d to %06x\n",
+			 lpfc_ncmd->cur_iocbq.sli4_xritag,
+			 lpfc_queue_info->index, ndlp->nlp_DID);
+
 	ret = lpfc_sli4_issue_wqe(phba, LPFC_FCP_RING, &lpfc_ncmd->cur_iocbq);
 	if (ret) {
 		atomic_dec(&ndlp->cmd_pending);
@@ -1204,6 +1321,28 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 		goto out_free_nvme_buf;
 	}
 
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+	if (phba->ktime_on)
+		lpfc_ncmd->ts_cmd_wqput = ktime_get_ns();
+
+	if (phba->cpucheck_on & LPFC_CHECK_NVME_IO) {
+		lpfc_ncmd->cpu = smp_processor_id();
+		if (lpfc_ncmd->cpu != lpfc_queue_info->index) {
+			/* Check for admin queue */
+			if (lpfc_queue_info->qidx) {
+				lpfc_printf_vlog(vport,
+						 KERN_ERR, LOG_NVME_IOERR,
+						"6702 CPU Check cmd: "
+						"cpu %d wq %d\n",
+						lpfc_ncmd->cpu,
+						lpfc_queue_info->index);
+			}
+			lpfc_ncmd->cpu = lpfc_queue_info->index;
+		}
+		if (lpfc_ncmd->cpu < LPFC_CHECK_CPU_CNT)
+			phba->cpucheck_xmt_io[lpfc_ncmd->cpu]++;
+	}
+#endif
 	return 0;
 
  out_free_nvme_buf:
@@ -1377,6 +1516,10 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 		return;
 	}
 
+	lpfc_nvmeio_data(phba, "NVME FCP ABORT: xri x%x idx %d to %06x\n",
+			 nvmereq_wqe->sli4_xritag,
+			 nvmereq_wqe->hba_wqidx, ndlp->nlp_DID);
+
 	/* Outstanding abort is in progress */
 	if (nvmereq_wqe->iocb_flag & LPFC_DRIVER_ABORTED) {
 		spin_unlock_irqrestore(&phba->hbalock, flags);
diff --git a/drivers/scsi/lpfc/lpfc_nvme.h b/drivers/scsi/lpfc/lpfc_nvme.h
index 4cc5108..85961c1 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.h
+++ b/drivers/scsi/lpfc/lpfc_nvme.h
@@ -91,4 +91,11 @@ struct lpfc_nvme_buf {
 
 	wait_queue_head_t *waitq;
 	unsigned long start_time;
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+	uint64_t ts_cmd_start;
+	uint64_t ts_last_cmd;
+	uint64_t ts_cmd_wqput;
+	uint64_t ts_isr_cmpl;
+	uint64_t ts_data_nvme;
+#endif
 };
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 67510c5..35a6e4d 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -13292,6 +13292,11 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 	if (unlikely(!fpeq))
 		return IRQ_NONE;
 
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+	if (phba->ktime_on)
+		fpeq->isr_timestamp = ktime_get_ns();
+#endif
+
 	if (lpfc_fcp_look_ahead) {
 		if (atomic_dec_and_test(&hba_eq_hdl->hba_eq_in_use))
 			lpfc_sli4_eq_clr_intr(fpeq);
-- 
2.5.0
