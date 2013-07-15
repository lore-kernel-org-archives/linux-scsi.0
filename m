From: James Smart <james.smart@emulex.com>
Subject: [PATCH 10/13] lpfc 8.3.41: Add first burst support to driver
Date: Mon, 15 Jul 2013 18:35:04 -0400
Message-ID: <1373927704.15647.27.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:19236 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758115Ab3GOWfH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jul 2013 18:35:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add first burst support to driver


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h           |    1 +
 lpfc_attr.c      |   11 +++++++++++
 lpfc_disc.h      |    1 +
 lpfc_els.c       |    2 ++
 lpfc_nportdisc.c |   12 ++++++++++--
 lpfc_scsi.c      |    5 +++++
 6 files changed, 30 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2013-07-15 07:15:28.343056073 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2013-07-15 07:15:29.696056104 -0400
@@ -3950,6 +3950,14 @@ LPFC_VPORT_ATTR_RW(use_adisc, 0, 0, 1,
 		   "Use ADISC on rediscovery to authenticate FCP devices");
 
 /*
+# lpfc_first_burst_size: First burst size to use on the NPorts
+# that support first burst.
+# Value range is [0,65536]. Default value is 0.
+*/
+LPFC_VPORT_ATTR_RW(first_burst_size, 0, 0, 65536,
+		   "First burst size for Targets that support first burst");
+
+/*
 # lpfc_max_scsicmpl_time: Use scsi command completion time to control I/O queue
 # depth. Default value is 0. When the value of this parameter is zero the
 # SCSI command completion time is not used for controlling I/O queue depth. When
@@ -4277,6 +4285,7 @@ struct device_attribute *lpfc_hba_attrs[
 	&dev_attr_lpfc_devloss_tmo,
 	&dev_attr_lpfc_fcp_class,
 	&dev_attr_lpfc_use_adisc,
+	&dev_attr_lpfc_first_burst_size,
 	&dev_attr_lpfc_ack0,
 	&dev_attr_lpfc_topology,
 	&dev_attr_lpfc_scan_down,
@@ -4353,6 +4362,7 @@ struct device_attribute *lpfc_vport_attr
 	&dev_attr_lpfc_restrict_login,
 	&dev_attr_lpfc_fcp_class,
 	&dev_attr_lpfc_use_adisc,
+	&dev_attr_lpfc_first_burst_size,
 	&dev_attr_lpfc_fdmi_on,
 	&dev_attr_lpfc_max_luns,
 	&dev_attr_nport_evt_cnt,
@@ -5332,6 +5342,7 @@ lpfc_get_vport_cfgparam(struct lpfc_vpor
 	lpfc_restrict_login_init(vport, lpfc_restrict_login);
 	lpfc_fcp_class_init(vport, lpfc_fcp_class);
 	lpfc_use_adisc_init(vport, lpfc_use_adisc);
+	lpfc_first_burst_size_init(vport, lpfc_first_burst_size);
 	lpfc_max_scsicmpl_time_init(vport, lpfc_max_scsicmpl_time);
 	lpfc_fdmi_on_init(vport, lpfc_fdmi_on);
 	lpfc_discovery_threads_init(vport, lpfc_discovery_threads);
diff -upNr a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
--- a/drivers/scsi/lpfc/lpfc_disc.h	2013-04-10 16:46:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_disc.h	2013-07-15 07:15:29.696056104 -0400
@@ -154,6 +154,7 @@ struct lpfc_node_rrq {
 #define NLP_NODEV_REMOVE   0x08000000	/* Defer removal till discovery ends */
 #define NLP_TARGET_REMOVE  0x10000000   /* Target remove in process */
 #define NLP_SC_REQ         0x20000000	/* Target requires authentication */
+#define NLP_FIRSTBURST     0x40000000	/* Target supports FirstBurst */
 #define NLP_RPI_REGISTERED 0x80000000	/* nlp_rpi is valid */
 
 /* ndlp usage management macros */
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2013-07-15 06:56:23.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2013-07-15 07:15:29.702056105 -0400
@@ -2122,6 +2122,8 @@ lpfc_issue_els_prli(struct lpfc_vport *v
 	}
 	npr->estabImagePair = 1;
 	npr->readXferRdyDis = 1;
+	 if (vport->cfg_first_burst_size)
+		npr->writeXferRdyDis = 1;
 
 	/* For FCP support */
 	npr->prliType = PRLI_FCP_TYPE;
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2013-07-15 06:56:23.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2013-07-15 07:15:29.712056105 -0400
@@ -421,6 +421,7 @@ struct lpfc_vport {
 	uint32_t cfg_enable_da_id;
 	uint32_t cfg_max_scsicmpl_time;
 	uint32_t cfg_tgt_queue_depth;
+	uint32_t cfg_first_burst_size;
 
 	uint32_t dev_loss_tmo_changed;
 
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2013-07-15 06:56:23.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2013-07-15 07:15:29.715056106 -0400
@@ -690,11 +690,15 @@ lpfc_rcv_prli(struct lpfc_vport *vport,
 
 	ndlp->nlp_type &= ~(NLP_FCP_TARGET | NLP_FCP_INITIATOR);
 	ndlp->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
+	ndlp->nlp_flag &= ~NLP_FIRSTBURST;
 	if (npr->prliType == PRLI_FCP_TYPE) {
 		if (npr->initiatorFunc)
 			ndlp->nlp_type |= NLP_FCP_INITIATOR;
-		if (npr->targetFunc)
+		if (npr->targetFunc) {
 			ndlp->nlp_type |= NLP_FCP_TARGET;
+			if (npr->writeXferRdyDis)
+				ndlp->nlp_flag |= NLP_FIRSTBURST;
+		}
 		if (npr->Retry)
 			ndlp->nlp_fcp_info |= NLP_FCP_2_DEVICE;
 	}
@@ -1676,12 +1680,16 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vp
 	/* Check out PRLI rsp */
 	ndlp->nlp_type &= ~(NLP_FCP_TARGET | NLP_FCP_INITIATOR);
 	ndlp->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
+	ndlp->nlp_flag &= ~NLP_FIRSTBURST;
 	if ((npr->acceptRspCode == PRLI_REQ_EXECUTED) &&
 	    (npr->prliType == PRLI_FCP_TYPE)) {
 		if (npr->initiatorFunc)
 			ndlp->nlp_type |= NLP_FCP_INITIATOR;
-		if (npr->targetFunc)
+		if (npr->targetFunc) {
 			ndlp->nlp_type |= NLP_FCP_TARGET;
+			if (npr->writeXferRdyDis)
+				ndlp->nlp_flag |= NLP_FIRSTBURST;
+		}
 		if (npr->Retry)
 			ndlp->nlp_fcp_info |= NLP_FCP_2_DEVICE;
 	}
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2013-07-15 07:15:23.877055972 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2013-07-15 07:15:29.717056105 -0400
@@ -4387,6 +4387,11 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *v
 		if (datadir == DMA_TO_DEVICE) {
 			iocb_cmd->ulpCommand = CMD_FCP_IWRITE64_CR;
 			iocb_cmd->ulpPU = PARM_READ_CHECK;
+			if (vport->cfg_first_burst_size &&
+			    (pnode->nlp_flag & NLP_FIRSTBURST)) {
+				piocbq->iocb.un.fcpi.fcpi_XRdy =
+					vport->cfg_first_burst_size;
+			}
 			fcp_cmnd->fcpCntl3 = WRITE_DATA;
 			phba->fc4OutputRequests++;
 		} else {




