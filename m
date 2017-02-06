From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 16/18] lpfc: NVME Target: Add debugfs support
Date: Mon, 06 Feb 2017 15:09:06 -0800
Message-ID: <58990212.dH51HYt87zkdyavQ%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33332 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752264AbdBFXJM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 18:09:12 -0500
Received: by mail-wm0-f66.google.com with SMTP id v77so24904343wmv.0
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 15:09:11 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org


NVME Target: Add debugfs support

Adds debugfs snippets to cover the new NVME target functionality

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
Modifications in V2:
 Sync with max_hw_queues/io_channel/io_channel_irqs change
 Sync with refactoring

 drivers/scsi/lpfc/lpfc_debugfs.c | 331 ++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_nvmet.c   | 276 +++++++++++++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_nvmet.h   |  13 ++
 3 files changed, 613 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index f2525b3..5b820ec 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -47,6 +47,7 @@
 #include "lpfc.h"
 #include "lpfc_scsi.h"
 #include "lpfc_nvme.h"
+#include "lpfc_nvmet.h"
 #include "lpfc_logmsg.h"
 #include "lpfc_crtn.h"
 #include "lpfc_vport.h"
@@ -537,11 +538,13 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 	int len = 0;
 	int cnt;
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+	struct lpfc_hba  *phba = vport->phba;
 	struct lpfc_nodelist *ndlp;
 	unsigned char *statep;
 	struct nvme_fc_local_port *localport;
 	struct lpfc_nvme_lport *lport;
 	struct lpfc_nvme_rport *rport;
+	struct lpfc_nvmet_tgtport *tgtp;
 	struct nvme_fc_remote_port *nrport;
 
 	cnt = (LPFC_NODELIST_SIZE / LPFC_NODELIST_ENTRY_SIZE);
@@ -620,6 +623,26 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 	}
 	spin_unlock_irq(shost->host_lock);
 
+	if (phba->nvmet_support && phba->targetport && (vport == phba->pport)) {
+		tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
+		len += snprintf(buf+len, size-len,
+				"\nNVME Targetport Entry ...\n");
+
+		/* Port state is only one of two values for now. */
+		if (phba->targetport->port_id)
+			statep = "REGISTERED";
+		else
+			statep = "INIT";
+		len += snprintf(buf+len, size-len,
+				"TGT WWNN x%llx WWPN x%llx State %s\n",
+				wwn_to_u64(vport->fc_nodename.u.wwn),
+				wwn_to_u64(vport->fc_portname.u.wwn),
+				statep);
+		len += snprintf(buf+len, size-len,
+				"    Targetport DID x%06x\n",
+				phba->targetport->port_id);
+		goto out_exit;
+	}
 	len += snprintf(buf+len, size-len, "\nNVME Lport/Rport Entries ...\n");
 
 	localport = vport->localport;
@@ -711,9 +734,75 @@ static int
 lpfc_debugfs_nvmestat_data(struct lpfc_vport *vport, char *buf, int size)
 {
 	struct lpfc_hba   *phba = vport->phba;
+	struct lpfc_nvmet_tgtport *tgtp;
 	int len = 0;
 
-	if (phba->nvmet_support == 0) {
+	if (phba->nvmet_support) {
+		if (!phba->targetport)
+			return len;
+		tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
+		len += snprintf(buf+len, size-len,
+				"\nNVME Targetport Statistics\n");
+
+		len += snprintf(buf+len, size-len,
+				"LS: Rcv %08x Drop %08x Abort %08x\n",
+				atomic_read(&tgtp->rcv_ls_req_in),
+				atomic_read(&tgtp->rcv_ls_req_drop),
+				atomic_read(&tgtp->xmt_ls_abort));
+		if (atomic_read(&tgtp->rcv_ls_req_in) !=
+		    atomic_read(&tgtp->rcv_ls_req_out)) {
+			len += snprintf(buf+len, size-len,
+					"Rcv LS: in %08x != out %08x\n",
+					atomic_read(&tgtp->rcv_ls_req_in),
+					atomic_read(&tgtp->rcv_ls_req_out));
+		}
+
+		len += snprintf(buf+len, size-len,
+				"LS: Xmt %08x Drop %08x Cmpl %08x Err %08x\n",
+				atomic_read(&tgtp->xmt_ls_rsp),
+				atomic_read(&tgtp->xmt_ls_drop),
+				atomic_read(&tgtp->xmt_ls_rsp_cmpl),
+				atomic_read(&tgtp->xmt_ls_rsp_error));
+
+		len += snprintf(buf+len, size-len,
+				"FCP: Rcv %08x Drop %08x\n",
+				atomic_read(&tgtp->rcv_fcp_cmd_in),
+				atomic_read(&tgtp->rcv_fcp_cmd_drop));
+
+		if (atomic_read(&tgtp->rcv_fcp_cmd_in) !=
+		    atomic_read(&tgtp->rcv_fcp_cmd_out)) {
+			len += snprintf(buf+len, size-len,
+					"Rcv FCP: in %08x != out %08x\n",
+					atomic_read(&tgtp->rcv_fcp_cmd_in),
+					atomic_read(&tgtp->rcv_fcp_cmd_out));
+		}
+
+		len += snprintf(buf+len, size-len,
+				"FCP Rsp: read %08x readrsp %08x write %08x rsp %08x\n",
+				atomic_read(&tgtp->xmt_fcp_read),
+				atomic_read(&tgtp->xmt_fcp_read_rsp),
+				atomic_read(&tgtp->xmt_fcp_write),
+				atomic_read(&tgtp->xmt_fcp_rsp));
+
+		len += snprintf(buf+len, size-len,
+				"FCP Rsp: abort %08x drop %08x\n",
+				atomic_read(&tgtp->xmt_fcp_abort),
+				atomic_read(&tgtp->xmt_fcp_drop));
+
+		len += snprintf(buf+len, size-len,
+				"FCP Rsp Cmpl: %08x err %08x drop %08x\n",
+				atomic_read(&tgtp->xmt_fcp_rsp_cmpl),
+				atomic_read(&tgtp->xmt_fcp_rsp_error),
+				atomic_read(&tgtp->xmt_fcp_rsp_drop));
+
+		len += snprintf(buf+len, size-len,
+				"ABORT: Xmt %08x Err %08x Cmpl %08x",
+				atomic_read(&tgtp->xmt_abort_rsp),
+				atomic_read(&tgtp->xmt_abort_rsp_error),
+				atomic_read(&tgtp->xmt_abort_cmpl));
+
+		len +=  snprintf(buf+len, size-len, "\n");
+	} else {
 		if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME))
 			return len;
 
@@ -821,6 +910,121 @@ lpfc_debugfs_nvmektime_data(struct lpfc_vport *vport, char *buf, int size)
 			phba->ktime_data_samples));
 		return len;
 	}
+
+	/* NVME Target */
+	len += snprintf(buf + len, PAGE_SIZE-len,
+			"ktime %s: Total Samples: %lld %lld\n",
+			(phba->ktime_on ? "Enabled" : "Disabled"),
+			phba->ktime_data_samples,
+			phba->ktime_status_samples);
+	if (phba->ktime_data_samples == 0)
+		return len;
+
+	len += snprintf(buf + len, PAGE_SIZE-len,
+			"Segment 1: MSI-X ISR Rcv cmd -to- "
+			"cmd pass to NVME Layer\n");
+	len += snprintf(buf + len, PAGE_SIZE-len,
+			"avg:%08lld min:%08lld max %08lld\n",
+			phba->ktime_seg1_total /
+			phba->ktime_data_samples,
+			phba->ktime_seg1_min,
+			phba->ktime_seg1_max);
+	len += snprintf(buf + len, PAGE_SIZE-len,
+			"Segment 2: cmd pass to NVME Layer- "
+			"-to- Driver rcv cmd OP (action)\n");
+	len += snprintf(buf + len, PAGE_SIZE-len,
+			"avg:%08lld min:%08lld max %08lld\n",
+			phba->ktime_seg2_total /
+			phba->ktime_data_samples,
+			phba->ktime_seg2_min,
+			phba->ktime_seg2_max);
+	len += snprintf(buf + len, PAGE_SIZE-len,
+			"Segment 3: Driver rcv cmd OP -to- "
+			"Firmware WQ doorbell: cmd\n");
+	len += snprintf(buf + len, PAGE_SIZE-len,
+			"avg:%08lld min:%08lld max %08lld\n",
+			phba->ktime_seg3_total /
+			phba->ktime_data_samples,
+			phba->ktime_seg3_min,
+			phba->ktime_seg3_max);
+	len += snprintf(buf + len, PAGE_SIZE-len,
+			"Segment 4: Firmware WQ doorbell: cmd "
+			"-to- MSI-X ISR for cmd cmpl\n");
+	len += snprintf(buf + len, PAGE_SIZE-len,
+			"avg:%08lld min:%08lld max %08lld\n",
+			phba->ktime_seg4_total /
+			phba->ktime_data_samples,
+			phba->ktime_seg4_min,
+			phba->ktime_seg4_max);
+	len += snprintf(buf + len, PAGE_SIZE-len,
+			"Segment 5: MSI-X ISR for cmd cmpl "
+			"-to- NVME layer passed cmd done\n");
+	len += snprintf(buf + len, PAGE_SIZE-len,
+			"avg:%08lld min:%08lld max %08lld\n",
+			phba->ktime_seg5_total /
+			phba->ktime_data_samples,
+			phba->ktime_seg5_min,
+			phba->ktime_seg5_max);
+
+	if (phba->ktime_status_samples == 0) {
+		len += snprintf(buf + len, PAGE_SIZE-len,
+				"Total: cmd received by MSI-X ISR "
+				"-to- cmd completed on wire\n");
+		len += snprintf(buf + len, PAGE_SIZE-len,
+				"avg:%08lld min:%08lld "
+				"max %08lld\n",
+				phba->ktime_seg10_total /
+				phba->ktime_data_samples,
+				phba->ktime_seg10_min,
+				phba->ktime_seg10_max);
+		return len;
+	}
+
+	len += snprintf(buf + len, PAGE_SIZE-len,
+			"Segment 6: NVME layer passed cmd done "
+			"-to- Driver rcv rsp status OP\n");
+	len += snprintf(buf + len, PAGE_SIZE-len,
+			"avg:%08lld min:%08lld max %08lld\n",
+			phba->ktime_seg6_total /
+			phba->ktime_status_samples,
+			phba->ktime_seg6_min,
+			phba->ktime_seg6_max);
+	len += snprintf(buf + len, PAGE_SIZE-len,
+			"Segment 7: Driver rcv rsp status OP "
+			"-to- Firmware WQ doorbell: status\n");
+	len += snprintf(buf + len, PAGE_SIZE-len,
+			"avg:%08lld min:%08lld max %08lld\n",
+			phba->ktime_seg7_total /
+			phba->ktime_status_samples,
+			phba->ktime_seg7_min,
+			phba->ktime_seg7_max);
+	len += snprintf(buf + len, PAGE_SIZE-len,
+			"Segment 8: Firmware WQ doorbell: status"
+			" -to- MSI-X ISR for status cmpl\n");
+	len += snprintf(buf + len, PAGE_SIZE-len,
+			"avg:%08lld min:%08lld max %08lld\n",
+			phba->ktime_seg8_total /
+			phba->ktime_status_samples,
+			phba->ktime_seg8_min,
+			phba->ktime_seg8_max);
+	len += snprintf(buf + len, PAGE_SIZE-len,
+			"Segment 9: MSI-X ISR for status cmpl  "
+			"-to- NVME layer passed status done\n");
+	len += snprintf(buf + len, PAGE_SIZE-len,
+			"avg:%08lld min:%08lld max %08lld\n",
+			phba->ktime_seg9_total /
+			phba->ktime_status_samples,
+			phba->ktime_seg9_min,
+			phba->ktime_seg9_max);
+	len += snprintf(buf + len, PAGE_SIZE-len,
+			"Total: cmd received by MSI-X ISR -to- "
+			"cmd completed on wire\n");
+	len += snprintf(buf + len, PAGE_SIZE-len,
+			"avg:%08lld min:%08lld max %08lld\n",
+			phba->ktime_seg10_total /
+			phba->ktime_status_samples,
+			phba->ktime_seg10_min,
+			phba->ktime_seg10_max);
 	return len;
 }
 
@@ -844,7 +1048,9 @@ lpfc_debugfs_cpucheck_data(struct lpfc_vport *vport, char *buf, int size)
 	int i;
 	int len = 0;
 	uint32_t tot_xmt = 0;
+	uint32_t tot_rcv = 0;
 	uint32_t tot_cmpl = 0;
+	uint32_t tot_ccmpl = 0;
 
 	if (phba->nvmet_support == 0) {
 		/* NVME Initiator */
@@ -868,6 +1074,33 @@ lpfc_debugfs_cpucheck_data(struct lpfc_vport *vport, char *buf, int size)
 		return len;
 	}
 
+	/* NVME Target */
+	len += snprintf(buf + len, PAGE_SIZE - len,
+			"CPUcheck %s ",
+			(phba->cpucheck_on & LPFC_CHECK_NVMET_IO ?
+				"IO Enabled - " : "IO Disabled - "));
+	len += snprintf(buf + len, PAGE_SIZE - len,
+			"%s\n",
+			(phba->cpucheck_on & LPFC_CHECK_NVMET_RCV ?
+				"Rcv Enabled\n" : "Rcv Disabled\n"));
+	for (i = 0; i < phba->sli4_hba.num_present_cpu; i++) {
+		if (i >= LPFC_CHECK_CPU_CNT)
+			break;
+		len += snprintf(buf + len, PAGE_SIZE - len,
+				"%02d: xmit x%08x ccmpl x%08x "
+				"cmpl x%08x rcv x%08x\n",
+				i, phba->cpucheck_xmt_io[i],
+				phba->cpucheck_ccmpl_io[i],
+				phba->cpucheck_cmpl_io[i],
+				phba->cpucheck_rcv_io[i]);
+		tot_xmt += phba->cpucheck_xmt_io[i];
+		tot_rcv += phba->cpucheck_rcv_io[i];
+		tot_cmpl += phba->cpucheck_cmpl_io[i];
+		tot_ccmpl += phba->cpucheck_ccmpl_io[i];
+	}
+	len += snprintf(buf + len, PAGE_SIZE - len,
+			"tot:xmit x%08x ccmpl x%08x cmpl x%08x rcv x%08x\n",
+			tot_xmt, tot_ccmpl, tot_cmpl, tot_rcv);
 	return len;
 }
 
@@ -1517,6 +1750,65 @@ lpfc_debugfs_nvmestat_open(struct inode *inode, struct file *file)
 	return rc;
 }
 
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
+	if ((strncmp(pbuf, "reset", strlen("reset")) == 0) ||
+	    (strncmp(pbuf, "zero", strlen("zero")) == 0)) {
+		atomic_set(&tgtp->rcv_ls_req_in, 0);
+		atomic_set(&tgtp->rcv_ls_req_out, 0);
+		atomic_set(&tgtp->rcv_ls_req_drop, 0);
+		atomic_set(&tgtp->xmt_ls_abort, 0);
+		atomic_set(&tgtp->xmt_ls_rsp, 0);
+		atomic_set(&tgtp->xmt_ls_drop, 0);
+		atomic_set(&tgtp->xmt_ls_rsp_error, 0);
+		atomic_set(&tgtp->xmt_ls_rsp_cmpl, 0);
+
+		atomic_set(&tgtp->rcv_fcp_cmd_in, 0);
+		atomic_set(&tgtp->rcv_fcp_cmd_out, 0);
+		atomic_set(&tgtp->rcv_fcp_cmd_drop, 0);
+		atomic_set(&tgtp->xmt_fcp_abort, 0);
+		atomic_set(&tgtp->xmt_fcp_drop, 0);
+		atomic_set(&tgtp->xmt_fcp_read_rsp, 0);
+		atomic_set(&tgtp->xmt_fcp_read, 0);
+		atomic_set(&tgtp->xmt_fcp_write, 0);
+		atomic_set(&tgtp->xmt_fcp_rsp, 0);
+		atomic_set(&tgtp->xmt_fcp_rsp_cmpl, 0);
+		atomic_set(&tgtp->xmt_fcp_rsp_error, 0);
+		atomic_set(&tgtp->xmt_fcp_rsp_drop, 0);
+
+		atomic_set(&tgtp->xmt_abort_rsp, 0);
+		atomic_set(&tgtp->xmt_abort_rsp_error, 0);
+		atomic_set(&tgtp->xmt_abort_cmpl, 0);
+	}
+	return nbytes;
+}
+
 static int
 lpfc_debugfs_nvmektime_open(struct inode *inode, struct file *file)
 {
@@ -1702,7 +1994,10 @@ lpfc_debugfs_cpucheck_write(struct file *file, const char __user *buf,
 	pbuf = &mybuf[0];
 
 	if ((strncmp(pbuf, "on", sizeof("on") - 1) == 0)) {
-		phba->cpucheck_on |= LPFC_CHECK_NVME_IO;
+		if (phba->nvmet_support)
+			phba->cpucheck_on |= LPFC_CHECK_NVMET_IO;
+		else
+			phba->cpucheck_on |= LPFC_CHECK_NVME_IO;
 		return strlen(pbuf);
 	} else if ((strncmp(pbuf, "rcv",
 		   sizeof("rcv") - 1) == 0)) {
@@ -2621,14 +2916,14 @@ __lpfc_idiag_print_eq(struct lpfc_queue *qp, char *eqtype,
 }
 
 static int
-__lpfc_idiag_print_rqpair(struct lpfc_queue *qp, struct lpfc_queue *datqp,
-			char *pbuffer, int len)
+__lpfc_idiag_print_rqpair(struct lpfc_queue *qp, char *rqtype,
+			struct lpfc_queue *datqp, char *pbuffer, int len)
 {
 	if (!qp || !datqp)
 		return len;
 
 	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
-			"\t\tRQ info: ");
+			"\t\t%s RQ info: ", rqtype);
 	len += snprintf(pbuffer+len, LPFC_QUE_INFO_GET_BUF_SIZE-len,
 			"AssocCQID[%02d]: RQ-STAT[nopost:x%x nobuf:x%x "
 			"trunc:x%x rcv:x%llx]\n",
@@ -2763,11 +3058,34 @@ lpfc_idiag_queinfo_read(struct file *file, char __user *buf, size_t nbytes,
 				goto too_big;
 
 			qp = phba->sli4_hba.hdr_rq;
-			len = __lpfc_idiag_print_rqpair(qp,
+			len = __lpfc_idiag_print_rqpair(qp, "RQpair",
 					phba->sli4_hba.dat_rq, pbuffer, len);
 			if (len >= max_cnt)
 				goto too_big;
 		}
+
+	}
+
+	for (x = 0; x < phba->cfg_nvmet_mrq; x++) {
+
+		/* NVMET CQset */
+		qp = phba->sli4_hba.nvmet_cqset[x];
+		len = __lpfc_idiag_print_cq(qp, "NVMET CQset", pbuffer, len);
+
+		/* Reset max counter */
+		qp->CQ_max_cqe = 0;
+
+		if (len >= max_cnt)
+			goto too_big;
+
+		/* RQ header */
+		qp = phba->sli4_hba.nvmet_mrq_hdr[x];
+		len = __lpfc_idiag_print_rqpair(qp, "NVMET MRQ",
+				phba->sli4_hba.nvmet_mrq_data[x],
+				pbuffer, len);
+
+		if (len >= max_cnt)
+			goto too_big;
 	}
 
 	if (phba->cfg_fof) {
@@ -4202,6 +4520,7 @@ static const struct file_operations lpfc_debugfs_op_nvmestat = {
 	.open =         lpfc_debugfs_nvmestat_open,
 	.llseek =       lpfc_debugfs_lseek,
 	.read =         lpfc_debugfs_read,
+	.write =	lpfc_debugfs_nvmestat_write,
 	.release =      lpfc_debugfs_release,
 };
 
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 046a924..a6d509f 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -144,6 +144,170 @@ lpfc_nvmet_rq_post(struct lpfc_hba *phba, struct lpfc_nvmet_rcv_ctx *ctxp,
 	lpfc_rq_buf_free(phba, mp);
 }
 
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+static void
+lpfc_nvmet_ktime(struct lpfc_hba *phba,
+		 struct lpfc_nvmet_rcv_ctx *ctxp)
+{
+	uint64_t seg1, seg2, seg3, seg4, seg5;
+	uint64_t seg6, seg7, seg8, seg9, seg10;
+
+	if (!phba->ktime_on)
+		return;
+
+	if (!ctxp->ts_isr_cmd || !ctxp->ts_cmd_nvme ||
+	    !ctxp->ts_nvme_data || !ctxp->ts_data_wqput ||
+	    !ctxp->ts_isr_data || !ctxp->ts_data_nvme ||
+	    !ctxp->ts_nvme_status || !ctxp->ts_status_wqput ||
+	    !ctxp->ts_isr_status || !ctxp->ts_status_nvme)
+		return;
+
+	if (ctxp->ts_isr_cmd  > ctxp->ts_cmd_nvme)
+		return;
+	if (ctxp->ts_cmd_nvme > ctxp->ts_nvme_data)
+		return;
+	if (ctxp->ts_nvme_data > ctxp->ts_data_wqput)
+		return;
+	if (ctxp->ts_data_wqput > ctxp->ts_isr_data)
+		return;
+	if (ctxp->ts_isr_data > ctxp->ts_data_nvme)
+		return;
+	if (ctxp->ts_data_nvme > ctxp->ts_nvme_status)
+		return;
+	if (ctxp->ts_nvme_status > ctxp->ts_status_wqput)
+		return;
+	if (ctxp->ts_status_wqput > ctxp->ts_isr_status)
+		return;
+	if (ctxp->ts_isr_status > ctxp->ts_status_nvme)
+		return;
+	/*
+	 * Segment 1 - Time from FCP command received by MSI-X ISR
+	 * to FCP command is passed to NVME Layer.
+	 * Segment 2 - Time from FCP command payload handed
+	 * off to NVME Layer to Driver receives a Command op
+	 * from NVME Layer.
+	 * Segment 3 - Time from Driver receives a Command op
+	 * from NVME Layer to Command is put on WQ.
+	 * Segment 4 - Time from Driver WQ put is done
+	 * to MSI-X ISR for Command cmpl.
+	 * Segment 5 - Time from MSI-X ISR for Command cmpl to
+	 * Command cmpl is passed to NVME Layer.
+	 * Segment 6 - Time from Command cmpl is passed to NVME
+	 * Layer to Driver receives a RSP op from NVME Layer.
+	 * Segment 7 - Time from Driver receives a RSP op from
+	 * NVME Layer to WQ put is done on TRSP FCP Status.
+	 * Segment 8 - Time from Driver WQ put is done on TRSP
+	 * FCP Status to MSI-X ISR for TRSP cmpl.
+	 * Segment 9 - Time from MSI-X ISR for TRSP cmpl to
+	 * TRSP cmpl is passed to NVME Layer.
+	 * Segment 10 - Time from FCP command received by
+	 * MSI-X ISR to command is completed on wire.
+	 * (Segments 1 thru 8) for READDATA / WRITEDATA
+	 * (Segments 1 thru 4) for READDATA_RSP
+	 */
+	seg1 = ctxp->ts_cmd_nvme - ctxp->ts_isr_cmd;
+	seg2 = (ctxp->ts_nvme_data - ctxp->ts_isr_cmd) - seg1;
+	seg3 = (ctxp->ts_data_wqput - ctxp->ts_isr_cmd) -
+		seg1 - seg2;
+	seg4 = (ctxp->ts_isr_data - ctxp->ts_isr_cmd) -
+		seg1 - seg2 - seg3;
+	seg5 = (ctxp->ts_data_nvme - ctxp->ts_isr_cmd) -
+		seg1 - seg2 - seg3 - seg4;
+
+	/* For auto rsp commands seg6 thru seg10 will be 0 */
+	if (ctxp->ts_nvme_status > ctxp->ts_data_nvme) {
+		seg6 = (ctxp->ts_nvme_status -
+			ctxp->ts_isr_cmd) -
+			seg1 - seg2 - seg3 - seg4 - seg5;
+		seg7 = (ctxp->ts_status_wqput -
+			ctxp->ts_isr_cmd) -
+			seg1 - seg2 - seg3 -
+			seg4 - seg5 - seg6;
+		seg8 = (ctxp->ts_isr_status -
+			ctxp->ts_isr_cmd) -
+			seg1 - seg2 - seg3 - seg4 -
+			seg5 - seg6 - seg7;
+		seg9 = (ctxp->ts_status_nvme -
+			ctxp->ts_isr_cmd) -
+			seg1 - seg2 - seg3 - seg4 -
+			seg5 - seg6 - seg7 - seg8;
+		seg10 = (ctxp->ts_isr_status -
+			ctxp->ts_isr_cmd);
+	} else {
+		seg6 =  0;
+		seg7 =  0;
+		seg8 =  0;
+		seg9 =  0;
+		seg10 = (ctxp->ts_isr_data - ctxp->ts_isr_cmd);
+	}
+
+	phba->ktime_seg1_total += seg1;
+	if (seg1 < phba->ktime_seg1_min)
+		phba->ktime_seg1_min = seg1;
+	else if (seg1 > phba->ktime_seg1_max)
+		phba->ktime_seg1_max = seg1;
+
+	phba->ktime_seg2_total += seg2;
+	if (seg2 < phba->ktime_seg2_min)
+		phba->ktime_seg2_min = seg2;
+	else if (seg2 > phba->ktime_seg2_max)
+		phba->ktime_seg2_max = seg2;
+
+	phba->ktime_seg3_total += seg3;
+	if (seg3 < phba->ktime_seg3_min)
+		phba->ktime_seg3_min = seg3;
+	else if (seg3 > phba->ktime_seg3_max)
+		phba->ktime_seg3_max = seg3;
+
+	phba->ktime_seg4_total += seg4;
+	if (seg4 < phba->ktime_seg4_min)
+		phba->ktime_seg4_min = seg4;
+	else if (seg4 > phba->ktime_seg4_max)
+		phba->ktime_seg4_max = seg4;
+
+	phba->ktime_seg5_total += seg5;
+	if (seg5 < phba->ktime_seg5_min)
+		phba->ktime_seg5_min = seg5;
+	else if (seg5 > phba->ktime_seg5_max)
+		phba->ktime_seg5_max = seg5;
+
+	phba->ktime_data_samples++;
+	if (!seg6)
+		goto out;
+
+	phba->ktime_seg6_total += seg6;
+	if (seg6 < phba->ktime_seg6_min)
+		phba->ktime_seg6_min = seg6;
+	else if (seg6 > phba->ktime_seg6_max)
+		phba->ktime_seg6_max = seg6;
+
+	phba->ktime_seg7_total += seg7;
+	if (seg7 < phba->ktime_seg7_min)
+		phba->ktime_seg7_min = seg7;
+	else if (seg7 > phba->ktime_seg7_max)
+		phba->ktime_seg7_max = seg7;
+
+	phba->ktime_seg8_total += seg8;
+	if (seg8 < phba->ktime_seg8_min)
+		phba->ktime_seg8_min = seg8;
+	else if (seg8 > phba->ktime_seg8_max)
+		phba->ktime_seg8_max = seg8;
+
+	phba->ktime_seg9_total += seg9;
+	if (seg9 < phba->ktime_seg9_min)
+		phba->ktime_seg9_min = seg9;
+	else if (seg9 > phba->ktime_seg9_max)
+		phba->ktime_seg9_max = seg9;
+out:
+	phba->ktime_seg10_total += seg10;
+	if (seg10 < phba->ktime_seg10_min)
+		phba->ktime_seg10_min = seg10;
+	else if (seg10 > phba->ktime_seg10_max)
+		phba->ktime_seg10_max = seg10;
+	phba->ktime_status_samples++;
+}
+#endif
+
 /**
  * lpfc_nvmet_xmt_fcp_op_cmp - Completion handler for FCP Response
  * @phba: Pointer to HBA context object.
@@ -162,6 +326,9 @@ lpfc_nvmet_xmt_fcp_op_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 	struct nvmefc_tgt_fcp_req *rsp;
 	struct lpfc_nvmet_rcv_ctx *ctxp;
 	uint32_t status, result, op, start_clean;
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+	uint32_t id;
+#endif
 
 	ctxp = cmdwqe->context2;
 	rsp = &ctxp->ctx.fcp_req;
@@ -194,7 +361,44 @@ lpfc_nvmet_xmt_fcp_op_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 		/* Sanity check */
 		ctxp->state = LPFC_NVMET_STE_DONE;
 		ctxp->entry_cnt++;
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+		if (phba->ktime_on) {
+			if (rsp->op == NVMET_FCOP_READDATA_RSP) {
+				ctxp->ts_isr_data =
+					cmdwqe->isr_timestamp;
+				ctxp->ts_data_nvme =
+					ktime_get_ns();
+				ctxp->ts_nvme_status =
+					ctxp->ts_data_nvme;
+				ctxp->ts_status_wqput =
+					ctxp->ts_data_nvme;
+				ctxp->ts_isr_status =
+					ctxp->ts_data_nvme;
+				ctxp->ts_status_nvme =
+					ctxp->ts_data_nvme;
+			} else {
+				ctxp->ts_isr_status =
+					cmdwqe->isr_timestamp;
+				ctxp->ts_status_nvme =
+					ktime_get_ns();
+			}
+		}
+		if (phba->cpucheck_on & LPFC_CHECK_NVMET_IO) {
+			id = smp_processor_id();
+			if (ctxp->cpu != id)
+				lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
+						"6703 CPU Check cmpl: "
+						"cpu %d expect %d\n",
+						id, ctxp->cpu);
+			if (ctxp->cpu < LPFC_CHECK_CPU_CNT)
+				phba->cpucheck_cmpl_io[id]++;
+		}
+#endif
 		rsp->done(rsp);
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+		if (phba->ktime_on)
+			lpfc_nvmet_ktime(phba, ctxp);
+#endif
 		/* Let Abort cmpl repost the context */
 		if (!(ctxp->flag & LPFC_NVMET_ABORT_OP))
 			lpfc_nvmet_rq_post(phba, ctxp, &ctxp->rqb_buffer->hbuf);
@@ -203,6 +407,22 @@ lpfc_nvmet_xmt_fcp_op_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 		start_clean = offsetof(struct lpfc_iocbq, wqe);
 		memset(((char *)cmdwqe) + start_clean, 0,
 		       (sizeof(struct lpfc_iocbq) - start_clean));
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+		if (phba->ktime_on) {
+			ctxp->ts_isr_data = cmdwqe->isr_timestamp;
+			ctxp->ts_data_nvme = ktime_get_ns();
+		}
+		if (phba->cpucheck_on & LPFC_CHECK_NVMET_IO) {
+			id = smp_processor_id();
+			if (ctxp->cpu != id)
+				lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
+						"6704 CPU Check cmdcmpl: "
+						"cpu %d expect %d\n",
+						id, ctxp->cpu);
+			if (ctxp->cpu < LPFC_CHECK_CPU_CNT)
+				phba->cpucheck_ccmpl_io[id]++;
+		}
+#endif
 		rsp->done(rsp);
 	}
 }
@@ -288,7 +508,29 @@ lpfc_nvmet_xmt_fcp_op(struct nvmet_fc_target_port *tgtport,
 	struct lpfc_hba *phba = ctxp->phba;
 	struct lpfc_iocbq *nvmewqeq;
 	unsigned long iflags;
-	int rc;
+	int rc, id;
+
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+	if (phba->ktime_on) {
+		if (rsp->op == NVMET_FCOP_RSP)
+			ctxp->ts_nvme_status = ktime_get_ns();
+		else
+			ctxp->ts_nvme_data = ktime_get_ns();
+	}
+	if (phba->cpucheck_on & LPFC_CHECK_NVMET_IO) {
+		id = smp_processor_id();
+		ctxp->cpu = id;
+		if (id < LPFC_CHECK_CPU_CNT)
+			phba->cpucheck_xmt_io[id]++;
+		if (rsp->hwqid != id) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
+					"6705 CPU Check OP: "
+					"cpu %d expect %d\n",
+					id, rsp->hwqid);
+			ctxp->cpu = rsp->hwqid;
+		}
+	}
+#endif
 
 	if (rsp->op == NVMET_FCOP_ABORT) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
@@ -336,6 +578,14 @@ lpfc_nvmet_xmt_fcp_op(struct nvmet_fc_target_port *tgtport,
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
 	if (rc == WQE_SUCCESS) {
 		ctxp->flag |= LPFC_NVMET_IO_INP;
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+		if (!phba->ktime_on)
+			return 0;
+		if (rsp->op == NVMET_FCOP_RSP)
+			ctxp->ts_status_wqput = ktime_get_ns();
+		else
+			ctxp->ts_data_wqput = ktime_get_ns();
+#endif
 		return 0;
 	}
 
@@ -586,6 +836,9 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
 	struct fc_frame_header *fc_hdr;
 	uint32_t *payload;
 	uint32_t size, oxid, sid, rc;
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+	uint32_t id;
+#endif
 
 	oxid = 0;
 	if (!nvmebuf || !phba->targetport) {
@@ -625,6 +878,27 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
 	ctxp->entry_cnt = 1;
 	ctxp->flag = 0;
 
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+	if (phba->ktime_on) {
+		ctxp->ts_isr_cmd = isr_timestamp;
+		ctxp->ts_cmd_nvme = ktime_get_ns();
+		ctxp->ts_nvme_data = 0;
+		ctxp->ts_data_wqput = 0;
+		ctxp->ts_isr_data = 0;
+		ctxp->ts_data_nvme = 0;
+		ctxp->ts_nvme_status = 0;
+		ctxp->ts_status_wqput = 0;
+		ctxp->ts_isr_status = 0;
+		ctxp->ts_status_nvme = 0;
+	}
+
+	if (phba->cpucheck_on & LPFC_CHECK_NVMET_RCV) {
+		id = smp_processor_id();
+		if (id < LPFC_CHECK_CPU_CNT)
+			phba->cpucheck_rcv_io[id]++;
+	}
+#endif
+
 	atomic_inc(&tgtp->rcv_fcp_cmd_in);
 	/*
 	 * The calling sequence should be:
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.h b/drivers/scsi/lpfc/lpfc_nvmet.h
index 7e19992..ca63677 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.h
+++ b/drivers/scsi/lpfc/lpfc_nvmet.h
@@ -98,5 +98,18 @@ struct lpfc_nvmet_rcv_ctx {
 #define LPFC_NVMET_IO_INP		1
 #define LPFC_NVMET_ABORT_OP		2
 	struct rqb_dmabuf *rqb_buffer;
+
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+	uint64_t ts_isr_cmd;
+	uint64_t ts_cmd_nvme;
+	uint64_t ts_nvme_data;
+	uint64_t ts_data_wqput;
+	uint64_t ts_isr_data;
+	uint64_t ts_data_nvme;
+	uint64_t ts_nvme_status;
+	uint64_t ts_status_wqput;
+	uint64_t ts_isr_status;
+	uint64_t ts_status_nvme;
+#endif
 };
 
-- 
2.5.0
