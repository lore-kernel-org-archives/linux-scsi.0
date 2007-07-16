From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 22/33] aic94xx: sg chaining support
Date: Mon, 16 Jul 2007 11:47:36 +0200
Message-ID: <11845792681200-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9292 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762553AbXGPJsm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:42 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/scsi/aic94xx/aic94xx_task.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index e2ad5be..1327281 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -89,7 +89,7 @@ static inline int asd_map_scatterlist(struct sas_task *task,
 			res = -ENOMEM;
 			goto err_unmap;
 		}
-		for (sc = task->scatter, i = 0; i < num_sg; i++, sc++) {
+		for_each_sg(task->scatter, sc, num_sg, i) {
 			struct sg_el *sg =
 				&((struct sg_el *)ascb->sg_arr->vaddr)[i];
 			sg->bus_addr = cpu_to_le64((u64)sg_dma_address(sc));
@@ -98,7 +98,7 @@ static inline int asd_map_scatterlist(struct sas_task *task,
 				sg->flags |= ASD_SG_EL_LIST_EOL;
 		}
 
-		for (sc = task->scatter, i = 0; i < 2; i++, sc++) {
+		for_each_sg(task->scatter, sc, 2, i) {
 			sg_arr[i].bus_addr =
 				cpu_to_le64((u64)sg_dma_address(sc));
 			sg_arr[i].size = cpu_to_le32((u32)sg_dma_len(sc));
@@ -110,7 +110,7 @@ static inline int asd_map_scatterlist(struct sas_task *task,
 		sg_arr[2].bus_addr=cpu_to_le64((u64)ascb->sg_arr->dma_handle);
 	} else {
 		int i;
-		for (sc = task->scatter, i = 0; i < num_sg; i++, sc++) {
+		for_each_sg(task->scatter, sc, num_sg, i) {
 			sg_arr[i].bus_addr =
 				cpu_to_le64((u64)sg_dma_address(sc));
 			sg_arr[i].size = cpu_to_le32((u32)sg_dma_len(sc));
-- 
1.5.3.rc0.90.gbaa79

