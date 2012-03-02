From: James Smart <james.smart@emulex.com>
Subject: [PATCH 17/21] lpfc 8.3.30: Fix handling of REG_VFI and cable pull.
Date: Thu, 1 Mar 2012 22:37:54 -0500
Message-ID: <1330659476.18500.44.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:38869 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757685Ab2CBDiT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 22:38:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix bug with mailbox handling of REG_VFI and cable pull.


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hbadisc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2012-03-01 17:33:47.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2012-03-01 17:33:53.000000000 -0500
@@ -2843,7 +2843,14 @@ lpfc_mbx_cmpl_reg_vfi(struct lpfc_hba *p
 	struct lpfc_vport *vport = mboxq->vport;
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 
-	if (mboxq->u.mb.mbxStatus) {
+	/*
+	 * VFI not supported for interface type 0, so ignore any mailbox
+	 * error (except VFI in use) and continue with the discovery.
+	 */
+	if (mboxq->u.mb.mbxStatus &&
+	    (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) !=
+			LPFC_SLI_INTF_IF_TYPE_0) &&
+	    mboxq->u.mb.mbxStatus != MBX_VFI_IN_USE) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
 			 "2018 REG_VFI mbxStatus error x%x "
 			 "HBA state x%x\n",



