From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 1/2] be2iscsi: Fix error return code
Date: Fri, 12 Aug 2016 12:02:32 +0200
Message-ID: <1470996152-31081-1-git-send-email-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: jayamohan.kallickal@avagotech.com, jejb@linux.vnet.ibm.com, ketan.mukadam@avagotech.com, sony.john@avagotech.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-scsi@vger.kernel.org

We know that 'ret' is not an error code because it has been tested a few
lines above.
So, if one of these function fails, 0 will be returned instead of an error
code.
Return -ENOMEM instead.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/be2iscsi/be_main.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index f05e7737107d..89ae6390b697 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3286,8 +3286,10 @@ static int beiscsi_create_eqs(struct beiscsi_hba *phba,
 		eq_vaddress = pci_alloc_consistent(phba->pcidev,
 						     num_eq_pages * PAGE_SIZE,
 						     &paddr);
-		if (!eq_vaddress)
+		if (!eq_vaddress) {
+			ret = -ENOMEM;
 			goto create_eq_error;
+		}
 
 		mem->va = eq_vaddress;
 		ret = be_fill_queue(eq, phba->params.num_eq_entries,
@@ -3349,8 +3351,11 @@ static int beiscsi_create_cqs(struct beiscsi_hba *phba,
 		cq_vaddress = pci_alloc_consistent(phba->pcidev,
 						     num_cq_pages * PAGE_SIZE,
 						     &paddr);
-		if (!cq_vaddress)
+		if (!cq_vaddress) {
+			ret = -ENOMEM;
 			goto create_cq_error;
+		}
+
 		ret = be_fill_queue(cq, phba->params.num_cq_entries,
 				    sizeof(struct sol_cqe), cq_vaddress);
 		if (ret) {
@@ -5635,6 +5640,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	if (!phba) {
 		dev_err(&pcidev->dev,
 			"beiscsi_dev_probe - Failed in beiscsi_hba_alloc\n");
+		ret = -ENOMEM;
 		goto disable_pci;
 	}
 
@@ -5754,6 +5760,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
 			    "BM_%d : beiscsi_dev_probe-"
 			    "Failed to allocate work queue\n");
+		ret = -ENOMEM;
 		goto free_twq;
 	}
 
-- 
2.7.4


---
L'absence de virus dans ce courrier électronique a été vérifiée par le logiciel antivirus Avast.
https://www.avast.com/antivirus

