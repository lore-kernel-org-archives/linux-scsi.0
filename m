From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 1/5] lpfc 8.1.10 : Add support to post events via new FC
	event interfaces
Date: Fri, 18 Aug 2006 17:46:43 -0400
Message-ID: <1155937603.12933.28.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:35526 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751494AbWHRVqk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Aug 2006 17:46:40 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k7ILkcBd024267
	for <linux-scsi@vger.kernel.org>; Fri, 18 Aug 2006 14:46:39 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add support to post events via new FC event interfaces

Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -391,3 +391,5 @@ struct rnidrsp {
 	struct list_head list;
 	uint32_t data;
 };
+
+#define FC_REG_DUMP_EVENT	0x10	/* Register for Dump events */
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2506,6 +2506,7 @@ lpfc_els_rcv_rscn(struct lpfc_hba * phba
 	uint32_t *lp;
 	IOCB_t *icmd;
 	uint32_t payload_len, cmd;
+	int i;
 
 	icmd = &cmdiocb->iocb;
 	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
@@ -2524,6 +2525,10 @@ lpfc_els_rcv_rscn(struct lpfc_hba * phba
 			phba->brd_no,
 			phba->fc_flag, payload_len, *lp, phba->fc_rscn_id_cnt);
 
+	for (i = 0; i < payload_len/sizeof(uint32_t); i++)
+		fc_host_post_event(phba->host, fc_get_event_number(),
+			FCH_EVT_RSCN, lp[i]);
+
 	/* If we are about to begin discovery, just ACC the RSCN.
 	 * Discovery processing will satisfy it.
 	 */
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -340,6 +340,9 @@ lpfc_linkdown(struct lpfc_hba * phba)
 		spin_unlock_irq(phba->host->host_lock);
 	}
 
+	fc_host_post_event(phba->host, fc_get_event_number(),
+			FCH_EVT_LINKDOWN, 0);
+
 	/* Clean up any firmware default rpi's */
 	if ((mb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL))) {
 		lpfc_unreg_did(phba, 0xffffffff, mb);
@@ -427,6 +430,9 @@ lpfc_linkup(struct lpfc_hba * phba)
 	struct list_head *listp, *node_list[7];
 	int i;
 
+	fc_host_post_event(phba->host, fc_get_event_number(),
+			FCH_EVT_LINKUP, 0);
+
 	spin_lock_irq(phba->host->host_lock);
 	phba->hba_state = LPFC_LINK_UP;
 	phba->fc_flag &= ~(FC_PT2PT | FC_PT2PT_PLOGI | FC_ABORT_DISCOVERY |
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -513,6 +513,7 @@ lpfc_handle_eratt(struct lpfc_hba * phba
 {
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring  *pring;
+	uint32_t event_data;
 
 	if (phba->work_hs & HS_FFER6) {
 		/* Re-establishing Link */
@@ -557,6 +558,11 @@ lpfc_handle_eratt(struct lpfc_hba * phba
 				phba->brd_no, phba->work_hs,
 				phba->work_status[0], phba->work_status[1]);
 
+		event_data = FC_REG_DUMP_EVENT;
+		fc_host_post_vendor_event(phba->host, fc_get_event_number(),
+				sizeof(event_data), (char *) &event_data,
+				SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_EMULEX);
+
 		psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
 		lpfc_offline(phba);
 		phba->hba_state = LPFC_HBA_ERROR;


