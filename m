From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 4/9] lpfc 8.1.3: Fix performance when using multiple SLI rings
Date: Tue, 28 Feb 2006 22:33:08 -0500
Message-ID: <20060301033308.GA21547@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:24529 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S1750781AbWCADdK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 22:33:10 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k213X8PF021555
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 22:33:08 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k213X8H2021553
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 22:33:08 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix performance when using multiple SLI rings

Currently the driver allocates all of its SLI command and response ring
entries to one primary ring. Other rings get little, or no, resources.

Allow more resources to be given to ring 1

Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -671,6 +671,14 @@ LPFC_ATTR_RW(cr_count, 1, 1, 255, "A cou
 		"interrupt response is generated");
 
 /*
+# lpfc_multi_ring_support:  Determines how many rings to spread available
+# cmd/rsp IOCB entries across.
+# Value range is [1,2]. Default value is 1.
+*/
+LPFC_ATTR_R(multi_ring_support, 1, 1, 2, "Determines number of primary "
+		"SLI rings to spread IOCB entries across");
+
+/*
 # lpfc_fdmi_on: controls FDMI support.
 #       0 = no FDMI support
 #       1 = support FDMI without attribute of hostname
@@ -726,6 +734,7 @@ struct class_device_attribute *lpfc_host
 	&class_device_attr_lpfc_link_speed,
 	&class_device_attr_lpfc_cr_delay,
 	&class_device_attr_lpfc_cr_count,
+	&class_device_attr_lpfc_multi_ring_support,
 	&class_device_attr_lpfc_fdmi_on,
 	&class_device_attr_lpfc_max_luns,
 	&class_device_attr_nport_evt_cnt,
@@ -1440,6 +1449,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_log_verbose_init(phba, lpfc_log_verbose);
 	lpfc_cr_delay_init(phba, lpfc_cr_delay);
 	lpfc_cr_count_init(phba, lpfc_cr_count);
+	lpfc_multi_ring_support_init(phba, lpfc_multi_ring_support);
 	lpfc_lun_queue_depth_init(phba, lpfc_lun_queue_depth);
 	lpfc_fcp_class_init(phba, lpfc_fcp_class);
 	lpfc_use_adisc_init(phba, lpfc_use_adisc);
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -293,6 +293,7 @@ struct lpfc_hba {
 	uint32_t cfg_link_speed;
 	uint32_t cfg_cr_delay;
 	uint32_t cfg_cr_count;
+	uint32_t cfg_multi_ring_support;
 	uint32_t cfg_fdmi_on;
 	uint32_t cfg_discovery_threads;
 	uint32_t cfg_max_luns;
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -766,7 +766,9 @@ lpfc_sli_process_unsol_iocb(struct lpfc_
 	}
 	/* unSolicited Responses */
 	if (pring->prt[0].profile) {
-		(pring->prt[0].lpfc_sli_rcv_unsol_event) (phba, pring, saveq);
+		if (pring->prt[0].lpfc_sli_rcv_unsol_event)
+			(pring->prt[0].lpfc_sli_rcv_unsol_event) (phba, pring,
+									saveq);
 		match = 1;
 	} else {
 		/* We must search, based on rctl / type
@@ -777,8 +779,9 @@ lpfc_sli_process_unsol_iocb(struct lpfc_
 			     Rctl)
 			    && (pring->prt[i].
 				type == Type)) {
-				(pring->prt[i].lpfc_sli_rcv_unsol_event)
-					(phba, pring, saveq);
+				if (pring->prt[i].lpfc_sli_rcv_unsol_event)
+					(pring->prt[i].lpfc_sli_rcv_unsol_event)
+							(phba, pring, saveq);
 				match = 1;
 				break;
 			}
@@ -2377,6 +2380,37 @@ lpfc_sli_issue_iocb(struct lpfc_hba *phb
 	return IOCB_BUSY;
 }
 
+static int
+lpfc_extra_ring_setup( struct lpfc_hba *phba)
+{
+	struct lpfc_sli *psli;
+	struct lpfc_sli_ring *pring;
+
+	psli = &phba->sli;
+
+	/* Adjust cmd/rsp ring iocb entries more evenly */
+	pring = &psli->ring[psli->fcp_ring];
+	pring->numCiocb -= SLI2_IOCB_CMD_R1XTRA_ENTRIES;
+	pring->numRiocb -= SLI2_IOCB_RSP_R1XTRA_ENTRIES;
+	pring->numCiocb -= SLI2_IOCB_CMD_R3XTRA_ENTRIES;
+	pring->numRiocb -= SLI2_IOCB_RSP_R3XTRA_ENTRIES;
+
+	pring = &psli->ring[1];
+	pring->numCiocb += SLI2_IOCB_CMD_R1XTRA_ENTRIES;
+	pring->numRiocb += SLI2_IOCB_RSP_R1XTRA_ENTRIES;
+	pring->numCiocb += SLI2_IOCB_CMD_R3XTRA_ENTRIES;
+	pring->numRiocb += SLI2_IOCB_RSP_R3XTRA_ENTRIES;
+
+	/* Setup default profile for this ring */
+	pring->iotag_max = 4096;
+	pring->num_mask = 1;
+	pring->prt[0].profile = 0;      /* Mask 0 */
+	pring->prt[0].rctl = FC_UNSOL_DATA;
+	pring->prt[0].type = 5;
+	pring->prt[0].lpfc_sli_rcv_unsol_event = NULL;
+	return 0;
+}
+
 int
 lpfc_sli_setup(struct lpfc_hba *phba)
 {
@@ -2460,6 +2494,8 @@ lpfc_sli_setup(struct lpfc_hba *phba)
 				"SLI2 SLIM Data: x%x x%x\n",
 				phba->brd_no, totiocb, MAX_SLI2_IOCB);
 	}
+	if (phba->cfg_multi_ring_support == 2)
+		lpfc_extra_ring_setup(phba);
 
 	return 0;
 }
