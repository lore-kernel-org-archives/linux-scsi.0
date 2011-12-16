From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] lpfc: nested calls to spin_lock_irq()
Date: Fri, 16 Dec 2011 23:28:19 +0300
Message-ID: <20111216202819.GF18570@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:21142 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760558Ab1LPU21 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Dec 2011 15:28:27 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

We already have disabled IRQs so there is no need to disable them again.
Also the functions are not nestable, the first spin_unlock_irq() will
enable IRQs and we don't want to do that until the second unlock.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 678a4b1..d7e916b 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -2977,9 +2977,9 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
 				"topology\n");
 				/* Get Loop Map information */
 		if (bf_get(lpfc_mbx_read_top_il, la)) {
-			spin_lock_irq(shost->host_lock);
+			spin_lock(shost->host_lock);
 			vport->fc_flag |= FC_LBIT;
-			spin_unlock_irq(shost->host_lock);
+			spin_unlock(shost->host_lock);
 		}
 
 		vport->fc_myDID = bf_get(lpfc_mbx_read_top_alpa_granted, la);
@@ -3029,9 +3029,9 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
 				phba->sli3_options |= LPFC_SLI3_NPIV_ENABLED;
 		}
 		vport->fc_myDID = phba->fc_pref_DID;
-		spin_lock_irq(shost->host_lock);
+		spin_lock(shost->host_lock);
 		vport->fc_flag |= FC_LBIT;
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock(shost->host_lock);
 	}
 	spin_unlock_irq(&phba->hbalock);
 
