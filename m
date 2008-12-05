From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 7/14] lpfc 8.3.0 :  Fix issue with assumed IEB support
Date: Thu, 4 Dec 2008 22:39:23 -0500
Message-ID: <1228448363.19053.47.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:45922 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbYLEOnh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2008 09:43:37 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id mB5EhaJ8004234
	for <linux-scsi@vger.kernel.org>; Fri, 5 Dec 2008 06:43:36 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

lpfc 8.3.0 : Fix issue with assumed Interrupt Enable Block support

The phba hbq_get address was setup before the HBA reported support for
Interrupt Enable Block (INB).  This caused loopback tests to fail
after all HBQs had been used once.  Moved setting of hba_get until
after config port mailbox command completes.


Signed-off-by: James Smart <James.Smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc_mbox.c |   11 +++--------
 drivers/scsi/lpfc/lpfc_sli.c  |    3 +++
 2 files changed, 6 insertions(+), 8 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -1198,16 +1198,11 @@ lpfc_config_port(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 				    sizeof(*phba->host_gp));
 	}
 
-	/* Setup Port Group ring pointer */
-	if (phba->sli3_options & LPFC_SLI3_INB_ENABLED) {
-		pgp_offset = offsetof(struct lpfc_sli2_slim,
-				      mbx.us.s3_inb_pgp.port);
-		phba->hbq_get = phba->mbox->us.s3_inb_pgp.hbq_get;
-	} else if (phba->sli_rev == 3) {
+	/* Setup Port Group offset */
+	if (phba->sli_rev == 3)
 		pgp_offset = offsetof(struct lpfc_sli2_slim,
 				      mbx.us.s3_pgp.port);
-		phba->hbq_get = phba->mbox->us.s3_pgp.hbq_get;
-	} else
+	else
 		pgp_offset = offsetof(struct lpfc_sli2_slim, mbx.us.s2.port);
 	pdma_addr = phba->slim2p.phys + pgp_offset;
 	phba->pcb->pgpAddrHigh = putPaddrHigh(pdma_addr);
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -3144,17 +3144,20 @@ lpfc_sli_config_port(struct lpfc_hba *phba, int sli_mode)
 			phba->sli3_options |= LPFC_SLI3_CRP_ENABLED;
 		if (pmb->mb.un.varCfgPort.ginb) {
 			phba->sli3_options |= LPFC_SLI3_INB_ENABLED;
+			phba->hbq_get = phba->mbox->us.s3_inb_pgp.hbq_get;
 			phba->port_gp = phba->mbox->us.s3_inb_pgp.port;
 			phba->inb_ha_copy = &phba->mbox->us.s3_inb_pgp.ha_copy;
 			phba->inb_counter = &phba->mbox->us.s3_inb_pgp.counter;
 			phba->inb_last_counter =
 					phba->mbox->us.s3_inb_pgp.counter;
 		} else {
+			phba->hbq_get = phba->mbox->us.s3_pgp.hbq_get;
 			phba->port_gp = phba->mbox->us.s3_pgp.port;
 			phba->inb_ha_copy = NULL;
 			phba->inb_counter = NULL;
 		}
 	} else {
+		phba->hbq_get = NULL;
 		phba->port_gp = phba->mbox->us.s2.port;
 		phba->inb_ha_copy = NULL;
 		phba->inb_counter = NULL;


