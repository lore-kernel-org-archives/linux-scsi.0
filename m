From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/6] lpfc 8.3.7: Fix SCSI protocol related errors.
Date: Mon, 21 Dec 2009 17:02:51 -0500
Message-ID: <1261432991.12238.15.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:37988 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751701AbZLUWHg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2009 17:07:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix SCSI protocol related errors:
- Avoid I/O failures during EEH and HBA/CNA reset by correcting when
  we block the targets on the adapter.

Signed-off-by: James Smart <james.smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc_hbadisc.c |    4 ++++
 drivers/scsi/lpfc/lpfc_init.c    |    5 +++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index f40b960..1c27372 100755
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -747,6 +747,10 @@ lpfc_linkdown(struct lpfc_hba *phba)
 
 	if (phba->link_state == LPFC_LINK_DOWN)
 		return 0;
+
+	/* Block all SCSI stack I/Os */
+	lpfc_scsi_dev_block(phba);
+
 	spin_lock_irq(&phba->hbalock);
 	phba->fcf.fcf_flag &= ~(FCF_AVAILABLE | FCF_DISCOVERED);
 	if (phba->link_state > LPFC_LINK_DOWN) {
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 7083ef3..974ea6d 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7226,8 +7226,6 @@ lpfc_prep_dev_for_perm_failure(struct lpfc_hba *phba)
 {
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 			"2711 PCI channel permanent disable for failure\n");
-	/* Block all SCSI devices' I/Os on the host */
-	lpfc_scsi_dev_block(phba);
 	/* Clean up all driver's outstanding SCSI I/Os */
 	lpfc_sli_flush_fcp_rings(phba);
 }
@@ -7256,6 +7254,9 @@ lpfc_io_error_detected_s3(struct pci_dev *pdev, pci_channel_state_t state)
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 
+	/* Block all SCSI devices' I/Os on the host */
+	lpfc_scsi_dev_block(phba);
+
 	switch (state) {
 	case pci_channel_io_normal:
 		/* Non-fatal error, prepare for recovery */
-- 
1.6.5.2



