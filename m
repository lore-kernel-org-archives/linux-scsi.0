From: Joe Perches <joe@perches.com>
Subject: [PATCH -next 15/26] bfa: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:44 -0700
Message-ID: <bd5384bd59bf7eb9bf616832f5c51fdb96be9764.1402863905.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/bfa/bfad_bsg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 8994fb8..65f3e74 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3270,13 +3270,13 @@ bfad_fcxp_map_sg(struct bfad_s *bfad, void *payload_kbuf,
 	/* Allocate dma coherent memory */
 	buf_info = buf_base;
 	buf_info->size = payload_len;
-	buf_info->virt = dma_alloc_coherent(&bfad->pcidev->dev, buf_info->size,
-					&buf_info->phys, GFP_KERNEL);
+	buf_info->virt = dma_zalloc_coherent(&bfad->pcidev->dev,
+					     buf_info->size, &buf_info->phys,
+					     GFP_KERNEL);
 	if (!buf_info->virt)
 		goto out_free_mem;
 
 	/* copy the linear bsg buffer to buf_info */
-	memset(buf_info->virt, 0, buf_info->size);
 	memcpy(buf_info->virt, payload_kbuf, buf_info->size);
 
 	/*
-- 
1.8.1.2.459.gbcd45b4.dirty
