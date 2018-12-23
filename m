From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 03/20] scsi: lpfc: lpfc_nvme: drop useless LIST_HEAD
Date: Sun, 23 Dec 2018 09:56:58 +0100
Message-ID: <1545555435-24576-4-git-send-email-Julia.Lawall@lip6.fr>
References: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: kernel-janitors@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Drop LIST_HEAD where the variable it declares is never used.

These were introduced with the file, but were not even used
at that time.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier x;
@@
- LIST_HEAD(x);
  ... when != x
// </smpl>

Fixes: 01649561a8b4b ("scsi: lpfc: NVME Initiator: bind to nvme_fc api")
Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Successfully 0-day tested on 151 configurations.

 drivers/scsi/lpfc/lpfc_nvme.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 4c66b19e6199..2119f36213e4 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2234,9 +2234,7 @@ lpfc_new_nvme_buf(struct lpfc_vport *vport, int num_to_alloc)
 	dma_addr_t pdma_phys_sgl;
 	uint16_t iotag, lxri = 0;
 	int bcnt, num_posted;
-	LIST_HEAD(prep_nblist);
 	LIST_HEAD(post_nblist);
-	LIST_HEAD(nvme_nblist);
 
 	for (bcnt = 0; bcnt < num_to_alloc; bcnt++) {
 		lpfc_ncmd = kzalloc(sizeof(struct lpfc_nvme_buf), GFP_KERNEL);
