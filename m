From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] scsi: lpfc: double lock typo in lpfc_ns_rsp()
Date: Thu, 4 May 2017 00:22:16 +0300
Message-ID: <20170503212215.m2t2rfrkoktugkg4@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

There is a double lock bug here so this will deadlock instead of
unlocking.

Fixes: 1c5b12f76301 ("Fix implicit logo and RSCN handling for NVMET")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 1487406aea77..c7962dae4dab 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -630,7 +630,7 @@ lpfc_ns_rsp(struct lpfc_vport *vport, struct lpfc_dmabuf *mp, uint8_t fc4_type,
 						NLP_EVT_DEVICE_RECOVERY);
 			spin_lock_irq(shost->host_lock);
 			ndlp->nlp_flag &= ~NLP_NVMET_RECOV;
-			spin_lock_irq(shost->host_lock);
+			spin_unlock_irq(shost->host_lock);
 		}
 	}
 
