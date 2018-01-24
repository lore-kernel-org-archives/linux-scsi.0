From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 06/19] lpfc: Fix PRLI handling when topology type changes
Date: Wed, 24 Jan 2018 14:45:35 -0800
Message-ID: <20180124224548.9530-7-jsmart2021@gmail.com>
References: <20180124224548.9530-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:46397 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933059AbeAXWqG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jan 2018 17:46:06 -0500
Received: by mail-qt0-f193.google.com with SMTP id o35so14609916qtj.13
        for <linux-scsi@vger.kernel.org>; Wed, 24 Jan 2018 14:46:05 -0800 (PST)
In-Reply-To: <20180124224548.9530-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

The lpfc driver does not discover a target when the topology
changes from switched-fabric to direct-connect. The target
rejects the PRLI from the initiator in direct-connect as the
driver is using the old S_ID from the switched topology.

The driver was inappropriately clearing the VP bit to register the
VPI, which is what is associated with the S_ID.

Fix by leaving the VP bit set (it was set earlier) and as the VFI
is being re-registered, set the UPDT bit.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_mbox.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 81fb92967b11..c32d4a323db2 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -2170,10 +2170,8 @@ lpfc_reg_vfi(struct lpfcMboxq *mbox, struct lpfc_vport *vport, dma_addr_t phys)
 	/* Only FC supports upd bit */
 	if ((phba->sli4_hba.lnk_info.lnk_tp == LPFC_LNK_TYPE_FC) &&
 	    (vport->fc_flag & FC_VFI_REGISTERED) &&
-	    (!phba->fc_topology_changed)) {
-		bf_set(lpfc_reg_vfi_vp, reg_vfi, 0);
+	    (!phba->fc_topology_changed))
 		bf_set(lpfc_reg_vfi_upd, reg_vfi, 1);
-	}
 
 	bf_set(lpfc_reg_vfi_bbcr, reg_vfi, 0);
 	bf_set(lpfc_reg_vfi_bbscn, reg_vfi, 0);
-- 
2.13.1
