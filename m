From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/7] lpfc 8.3.36: Fix bug with Target Resets and FCP2 devices
Date: Wed, 31 Oct 2012 14:44:42 -0400
Message-ID: <1351709082.957.17.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:15752 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759216Ab2JaSpY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2012 14:45:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix bug with Target Resets and FCP2 devices

Create module parameter to disable Target Reset on FCP-Tape devices
when a "bus reset" is requested. Default is to reset all devices on
bus reset.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h      |    1 +
 lpfc_attr.c |   12 ++++++++++++
 lpfc_scsi.c |    3 +++
 3 files changed, 16 insertions(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2012-10-29 11:18:27.431032734 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2012-10-29 11:18:35.022032906 -0400
@@ -3859,6 +3859,16 @@ LPFC_ATTR_RW(fcp_io_sched, 0, 0, 1, "Det
 		"issuing commands [0] - Round Robin, [1] - Current CPU");
 
 /*
+# lpfc_fcp2_no_tgt_reset: Determine bus reset behavior
+# range is [0,1]. Default value is 0.
+# For [0], bus reset issues target reset to ALL devices
+# For [1], bus reset issues target reset to non-FCP2 devices
+*/
+LPFC_ATTR_RW(fcp2_no_tgt_reset, 0, 0, 1, "Determine bus reset behavior for "
+	     "FCP2 devices [0] - issue tgt reset, [1] - no tgt reset");
+
+
+/*
 # lpfc_cr_delay & lpfc_cr_count: Default values for I/O colaesing
 # cr_delay (msec) or cr_count outstanding commands. cr_delay can take
 # value [0,63]. cr_count can take value [1,255]. Default value of cr_delay
@@ -4100,6 +4110,7 @@ struct device_attribute *lpfc_hba_attrs[
 	&dev_attr_lpfc_scan_down,
 	&dev_attr_lpfc_link_speed,
 	&dev_attr_lpfc_fcp_io_sched,
+	&dev_attr_lpfc_fcp2_no_tgt_reset,
 	&dev_attr_lpfc_cr_delay,
 	&dev_attr_lpfc_cr_count,
 	&dev_attr_lpfc_multi_ring_support,
@@ -5091,6 +5102,7 @@ void
 lpfc_get_cfgparam(struct lpfc_hba *phba)
 {
 	lpfc_fcp_io_sched_init(phba, lpfc_fcp_io_sched);
+	lpfc_fcp2_no_tgt_reset_init(phba, lpfc_fcp2_no_tgt_reset);
 	lpfc_cr_delay_init(phba, lpfc_cr_delay);
 	lpfc_cr_count_init(phba, lpfc_cr_count);
 	lpfc_multi_ring_support_init(phba, lpfc_multi_ring_support);
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2012-10-29 11:18:27.452032734 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2012-10-29 11:18:35.027032906 -0400
@@ -689,6 +689,7 @@ struct lpfc_hba {
 #define LPFC_FCF_PRIORITY 2	/* Priority fcf failover */
 	uint32_t cfg_fcf_failover_policy;
 	uint32_t cfg_fcp_io_sched;
+	uint32_t cfg_fcp2_no_tgt_reset;
 	uint32_t cfg_cr_delay;
 	uint32_t cfg_cr_count;
 	uint32_t cfg_multi_ring_support;
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2012-10-23 09:51:51.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2012-10-29 11:18:35.053032906 -0400
@@ -4914,6 +4914,9 @@ lpfc_bus_reset_handler(struct scsi_cmnd
 		list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
 			if (!NLP_CHK_NODE_ACT(ndlp))
 				continue;
+			if (vport->phba->cfg_fcp2_no_tgt_reset &&
+			    (ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE))
+				continue;
 			if (ndlp->nlp_state == NLP_STE_MAPPED_NODE &&
 			    ndlp->nlp_sid == i &&
 			    ndlp->rport) {



