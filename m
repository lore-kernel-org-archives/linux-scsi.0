From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH] ibmvscsis: fix sleeping in interrupt context
Date: Wed, 11 Jan 2017 13:16:42 -0600
Message-ID: <1484162202-64392-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Bart.VanAssche@sandisk.com
Cc: nab@linux-iscsi.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Currently, dma_alloc_coherent is being called with a GFP_KERNEL
flag which allows it to sleep in an interrupt context, need to
change to GFP_ATOMIC.

Cc: stable@vger.kernel.org
Tested-by: Steven Royer <seroyer@linux.vnet.ibm.com>
Reviewed-by: Michael Cyr <mikecyr@linux.vnet.ibm.com>
Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 792a8bd..8e308fd 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -1391,7 +1391,7 @@ static long ibmvscsis_adapter_info(struct scsi_info *vscsi,
 	}
 
 	info = dma_alloc_coherent(&vscsi->dma_dev->dev, sizeof(*info), &token,
-				  GFP_KERNEL);
+				  GFP_ATOMIC);
 	if (!info) {
 		dev_err(&vscsi->dev, "bad dma_alloc_coherent %p\n",
 			iue->target);
@@ -1509,7 +1509,7 @@ static int ibmvscsis_cap_mad(struct scsi_info *vscsi, struct iu_entry *iue)
 	}
 
 	cap = dma_alloc_coherent(&vscsi->dma_dev->dev, olen, &token,
-				 GFP_KERNEL);
+				 GFP_ATOMIC);
 	if (!cap) {
 		dev_err(&vscsi->dev, "bad dma_alloc_coherent %p\n",
 			iue->target);
-- 
2.5.4 (Apple Git-61)
