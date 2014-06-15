From: Joe Perches <joe@perches.com>
Subject: [PATCH -next 22/26] qla2xxx: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:51 -0700
Message-ID: <5e845f43a014ad7dd4ab3a4fdcd95b879bc496ef.1402863905.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e218441..46990f4 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1526,8 +1526,8 @@ try_fce:
 			    FCE_SIZE, ha->fce, ha->fce_dma);
 
 		/* Allocate memory for Fibre Channel Event Buffer. */
-		tc = dma_alloc_coherent(&ha->pdev->dev, FCE_SIZE, &tc_dma,
-		    GFP_KERNEL);
+		tc = dma_zalloc_coherent(&ha->pdev->dev, FCE_SIZE, &tc_dma,
+					 GFP_KERNEL);
 		if (!tc) {
 			ql_log(ql_log_warn, vha, 0x00be,
 			    "Unable to allocate (%d KB) for FCE.\n",
@@ -1535,7 +1535,6 @@ try_fce:
 			goto try_eft;
 		}
 
-		memset(tc, 0, FCE_SIZE);
 		rval = qla2x00_enable_fce_trace(vha, tc_dma, FCE_NUM_BUFFERS,
 		    ha->fce_mb, &ha->fce_bufs);
 		if (rval) {
@@ -1560,8 +1559,8 @@ try_eft:
 			    EFT_SIZE, ha->eft, ha->eft_dma);
 
 		/* Allocate memory for Extended Trace Buffer. */
-		tc = dma_alloc_coherent(&ha->pdev->dev, EFT_SIZE, &tc_dma,
-		    GFP_KERNEL);
+		tc = dma_zalloc_coherent(&ha->pdev->dev, EFT_SIZE, &tc_dma,
+					 GFP_KERNEL);
 		if (!tc) {
 			ql_log(ql_log_warn, vha, 0x00c1,
 			    "Unable to allocate (%d KB) for EFT.\n",
@@ -1569,7 +1568,6 @@ try_eft:
 			goto cont_alloc;
 		}
 
-		memset(tc, 0, EFT_SIZE);
 		rval = qla2x00_enable_eft_trace(vha, tc_dma, EFT_NUM_BUFFERS);
 		if (rval) {
 			ql_log(ql_log_warn, vha, 0x00c2,
-- 
1.8.1.2.459.gbcd45b4.dirty
