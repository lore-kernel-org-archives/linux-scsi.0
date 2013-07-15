From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/13] lpfc 8.3.41: Fixed max value of lpfc_lun_queue_depth
Date: Mon, 15 Jul 2013 18:32:43 -0400
Message-ID: <1373927563.15647.21.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:19211 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758330Ab3GOWcr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jul 2013 18:32:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed max value of lpfc_lun_queue_depth


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c  |    9 ++++++---
 lpfc_init.c  |   34 ++++++++++++++++++++++++----------
 lpfc_sli.c   |   11 +++++++++++
 lpfc_vport.c |    3 +++
 4 files changed, 44 insertions(+), 13 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2013-07-15 06:56:23.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2013-07-15 07:15:17.540055827 -0400
@@ -2591,9 +2591,12 @@ LPFC_VPORT_ATTR_R(enable_da_id, 1, 0, 1,
 
 /*
 # lun_queue_depth:  This parameter is used to limit the number of outstanding
-# commands per FCP LUN. Value range is [1,128]. Default value is 30.
+# commands per FCP LUN. Value range is [1,512]. Default value is 30.
+# If this parameter value is greater than 1/8th the maximum number of exchanges
+# supported by the HBA port, then the lun queue depth will be reduced to
+# 1/8th the maximum number of exchanges.
 */
-LPFC_VPORT_ATTR_R(lun_queue_depth, 30, 1, 128,
+LPFC_VPORT_ATTR_R(lun_queue_depth, 30, 1, 512,
 		  "Max number of FCP commands we can queue to a specific LUN");
 
 /*
@@ -2601,7 +2604,7 @@ LPFC_VPORT_ATTR_R(lun_queue_depth, 30, 1
 # commands per target port. Value range is [10,65535]. Default value is 65535.
 */
 LPFC_VPORT_ATTR_R(tgt_queue_depth, 65535, 10, 65535,
-	"Max number of FCP commands we can queue to a specific target port");
+		  "Max number of FCP commands we can queue to a specific target port");
 
 /*
 # hba_queue_depth:  This parameter is used to limit the number of outstanding
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2013-07-15 06:56:23.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2013-07-15 07:15:17.580055828 -0400
@@ -472,10 +472,22 @@ lpfc_config_port_post(struct lpfc_hba *p
 	lpfc_sli_read_link_ste(phba);
 
 	/* Reset the DFT_HBA_Q_DEPTH to the max xri  */
-	if (phba->cfg_hba_queue_depth > (mb->un.varRdConfig.max_xri+1))
-		phba->cfg_hba_queue_depth =
-			(mb->un.varRdConfig.max_xri + 1) -
-					lpfc_sli4_get_els_iocb_cnt(phba);
+	i = (mb->un.varRdConfig.max_xri + 1);
+	if (phba->cfg_hba_queue_depth > i) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"3359 HBA queue depth changed from %d to %d\n",
+				phba->cfg_hba_queue_depth, i);
+		phba->cfg_hba_queue_depth = i;
+	}
+
+	/* Reset the DFT_LUN_Q_DEPTH to (max xri >> 3)  */
+	i = (mb->un.varRdConfig.max_xri >> 3);
+	if (phba->pport->cfg_lun_queue_depth > i) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"3360 LUN queue depth changed from %d to %d\n",
+				phba->pport->cfg_lun_queue_depth, i);
+		phba->pport->cfg_lun_queue_depth = i;
+	}
 
 	phba->lmt = mb->un.varRdConfig.lmt;
 
@@ -6664,12 +6676,14 @@ lpfc_sli4_read_config(struct lpfc_hba *p
 		goto read_cfg_out;
 
 	/* Reset the DFT_HBA_Q_DEPTH to the max xri  */
-	if (phba->cfg_hba_queue_depth >
-		(phba->sli4_hba.max_cfg_param.max_xri -
-			lpfc_sli4_get_els_iocb_cnt(phba)))
-		phba->cfg_hba_queue_depth =
-			phba->sli4_hba.max_cfg_param.max_xri -
-				lpfc_sli4_get_els_iocb_cnt(phba);
+	length = phba->sli4_hba.max_cfg_param.max_xri -
+			lpfc_sli4_get_els_iocb_cnt(phba);
+	if (phba->cfg_hba_queue_depth > length) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"3361 HBA queue depth changed from %d to %d\n",
+				phba->cfg_hba_queue_depth, length);
+		phba->cfg_hba_queue_depth = length;
+	}
 
 	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) !=
 	    LPFC_SLI_INTF_IF_TYPE_2)
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-07-15 07:15:14.692055763 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-07-15 07:15:17.589055828 -0400
@@ -6163,6 +6163,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 		kfree(vpd);
 		goto out_free_mbox;
 	}
+
 	mqe = &mboxq->u.mqe;
 	phba->sli_rev = bf_get(lpfc_mbx_rd_rev_sli_lvl, &mqe->un.read_rev);
 	if (bf_get(lpfc_mbx_rd_rev_fcoe, &mqe->un.read_rev))
@@ -6249,6 +6250,16 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 			phba->vpd.rev.fcphHigh, phba->vpd.rev.fcphLow,
 			phba->vpd.rev.feaLevelHigh, phba->vpd.rev.feaLevelLow);
 
+	/* Reset the DFT_LUN_Q_DEPTH to (max xri >> 3)  */
+	rc = (phba->sli4_hba.max_cfg_param.max_xri >> 3);
+	if (phba->pport->cfg_lun_queue_depth > rc) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"3362 LUN queue depth changed from %d to %d\n",
+				phba->pport->cfg_lun_queue_depth, rc);
+		phba->pport->cfg_lun_queue_depth = rc;
+	}
+
+
 	/*
 	 * Discover the port's supported feature set and match it against the
 	 * hosts requests.
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2013-05-03 09:24:34.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2013-07-15 07:15:17.659055830 -0400
@@ -387,6 +387,9 @@ lpfc_vport_create(struct fc_vport *fc_vp
 	/* Create binary sysfs attribute for vport */
 	lpfc_alloc_sysfs_attr(vport);
 
+	/* Set the DFT_LUN_Q_DEPTH accordingly */
+	vport->cfg_lun_queue_depth  = phba->pport->cfg_lun_queue_depth;
+
 	*(struct lpfc_vport **)fc_vport->dd_data = vport;
 	vport->fc_vport = fc_vport;
 




