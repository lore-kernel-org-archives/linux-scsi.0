From: James Smart <james.smart@emulex.com>
Subject: [PATCH 6/11] lpfc 10.2.8000.0: Fix FW dump using sysfs
Date: Fri, 4 Apr 2014 13:52:12 -0400
Message-ID: <1396633932.1924.19.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:53483 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbaDDRwO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Apr 2014 13:52:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix FW dump using sysfs


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h      |    1 +
 lpfc_attr.c |    7 ++++++-
 lpfc_sli.c  |   13 ++++++++++---
 3 files changed, 17 insertions(+), 4 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2014-03-31 16:21:36.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2014-04-03 10:24:25.958308791 -0400
@@ -919,10 +919,15 @@ lpfc_sli4_pdev_reg_request(struct lpfc_h
 		phba->cfg_sriov_nr_virtfn = 0;
 	}
 
+	if (opcode == LPFC_FW_DUMP)
+		phba->hba_flag |= HBA_FW_DUMP_OP;
+
 	status = lpfc_do_offline(phba, LPFC_EVT_OFFLINE);
 
-	if (status != 0)
+	if (status != 0) {
+		phba->hba_flag &= ~HBA_FW_DUMP_OP;
 		return status;
+	}
 
 	/* wait for the device to be quiesced before firmware reset */
 	msleep(100);
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2014-03-31 16:21:36.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2014-04-03 10:24:25.959308791 -0400
@@ -640,6 +640,7 @@ struct lpfc_hba {
 #define HBA_DEVLOSS_TMO         0x2000 /* HBA in devloss timeout */
 #define HBA_RRQ_ACTIVE		0x4000 /* process the rrq active list */
 #define HBA_FCP_IOQ_FLUSH	0x8000 /* FCP I/O queues being flushed */
+#define HBA_FW_DUMP_OP		0x10000 /* Skips fn reset before FW dump */
 	uint32_t fcp_ring_in_use; /* When polling test if intr-hndlr active*/
 	struct lpfc_dmabuf slim2p;
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2014-04-03 10:24:24.244308704 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2014-04-03 10:24:26.012308793 -0400
@@ -4036,12 +4036,13 @@ lpfc_sli4_brdreset(struct lpfc_hba *phba
 {
 	struct lpfc_sli *psli = &phba->sli;
 	uint16_t cfg_value;
-	int rc;
+	int rc = 0;
 
 	/* Reset HBA */
 	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
-			"0295 Reset HBA Data: x%x x%x\n",
-			phba->pport->port_state, psli->sli_flag);
+			"0295 Reset HBA Data: x%x x%x x%x\n",
+			phba->pport->port_state, psli->sli_flag,
+			phba->hba_flag);
 
 	/* perform board reset */
 	phba->fc_eventTag = 0;
@@ -4054,6 +4055,12 @@ lpfc_sli4_brdreset(struct lpfc_hba *phba
 	phba->fcf.fcf_flag = 0;
 	spin_unlock_irq(&phba->hbalock);
 
+	/* SLI4 INTF 2: if FW dump is being taken skip INIT_PORT */
+	if (phba->hba_flag & HBA_FW_DUMP_OP) {
+		phba->hba_flag &= ~HBA_FW_DUMP_OP;
+		return rc;
+	}
+
 	/* Now physically reset the device */
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 			"0389 Performing PCI function reset!\n");



