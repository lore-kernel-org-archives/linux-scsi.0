From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 29/33] infiniband: sg chaining support
Date: Mon, 16 Jul 2007 11:47:43 +0200
Message-ID: <11845792693361-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9332 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759454AbXGPJsn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:43 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, rolandd@cisco.com

Cc: rolandd@cisco.com
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/infiniband/hw/ipath/ipath_dma.c   |    9 ++--
 drivers/infiniband/ulp/iser/iser_memory.c |   75 +++++++++++++++-------------
 2 files changed, 45 insertions(+), 39 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_dma.c b/drivers/infiniband/hw/ipath/ipath_dma.c
index f87f003..62c87e6 100644
--- a/drivers/infiniband/hw/ipath/ipath_dma.c
+++ b/drivers/infiniband/hw/ipath/ipath_dma.c
@@ -96,17 +96,18 @@ static void ipath_dma_unmap_page(struct ib_device *dev,
 	BUG_ON(!valid_dma_direction(direction));
 }
 
-static int ipath_map_sg(struct ib_device *dev, struct scatterlist *sg, int nents,
-			enum dma_data_direction direction)
+static int ipath_map_sg(struct ib_device *dev, struct scatterlist *sgl,
+			int nents, enum dma_data_direction direction)
 {
+	struct scatterlist *sg;
 	u64 addr;
 	int i;
 	int ret = nents;
 
 	BUG_ON(!valid_dma_direction(direction));
 
-	for (i = 0; i < nents; i++) {
-		addr = (u64) page_address(sg[i].page);
+	for_each_sg(sgl, sg, nents, i) {
+		addr = (u64) page_address(sg->page);
 		/* TODO: handle highmem pages */
 		if (!addr) {
 			ret = 0;
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index fc9f1fd..ff0c701 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -37,7 +37,6 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <asm/io.h>
-#include <asm/scatterlist.h>
 #include <linux/scatterlist.h>
 
 #include "iscsi_iser.h"
@@ -126,17 +125,19 @@ int iser_start_rdma_unaligned_sg(struct iscsi_iser_cmd_task  *iser_ctask,
 
 	if (cmd_dir == ISER_DIR_OUT) {
 		/* copy the unaligned sg the buffer which is used for RDMA */
-		struct scatterlist *sg = (struct scatterlist *)data->buf;
+		struct scatterlist *sgl = (struct scatterlist *)data->buf;
+		struct scatterlist *sg;
 		int i;
 		char *p, *from;
 
-		for (p = mem, i = 0; i < data->size; i++) {
-			from = kmap_atomic(sg[i].page, KM_USER0);
+		p = mem;
+		for_each_sg(sgl, sg, data->size, i) {
+			from = kmap_atomic(sg->page, KM_USER0);
 			memcpy(p,
-			       from + sg[i].offset,
-			       sg[i].length);
+			       from + sg->offset,
+			       sg->length);
 			kunmap_atomic(from, KM_USER0);
-			p += sg[i].length;
+			p += sg->length;
 		}
 	}
 
@@ -178,7 +179,7 @@ void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_cmd_task *iser_ctask,
 
 	if (cmd_dir == ISER_DIR_IN) {
 		char *mem;
-		struct scatterlist *sg;
+		struct scatterlist *sgl, *sg;
 		unsigned char *p, *to;
 		unsigned int sg_size;
 		int i;
@@ -186,16 +187,17 @@ void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_cmd_task *iser_ctask,
 		/* copy back read RDMA to unaligned sg */
 		mem	= mem_copy->copy_buf;
 
-		sg	= (struct scatterlist *)iser_ctask->data[ISER_DIR_IN].buf;
+		sgl	= (struct scatterlist *)iser_ctask->data[ISER_DIR_IN].buf;
 		sg_size = iser_ctask->data[ISER_DIR_IN].size;
 
-		for (p = mem, i = 0; i < sg_size; i++){
-			to = kmap_atomic(sg[i].page, KM_SOFTIRQ0);
-			memcpy(to + sg[i].offset,
+		p = mem;
+		for_each_sg(sgl, sg, sg_size, i) {
+			to = kmap_atomic(sg->page, KM_SOFTIRQ0);
+			memcpy(to + sg->offset,
 			       p,
-			       sg[i].length);
+			       sg->length);
 			kunmap_atomic(to, KM_SOFTIRQ0);
-			p += sg[i].length;
+			p += sg->length;
 		}
 	}
 
@@ -226,7 +228,8 @@ static int iser_sg_to_page_vec(struct iser_data_buf *data,
 			       struct iser_page_vec *page_vec,
 			       struct ib_device *ibdev)
 {
-	struct scatterlist *sg = (struct scatterlist *)data->buf;
+	struct scatterlist *sgl = (struct scatterlist *)data->buf;
+	struct scatterlist *sg;
 	u64 first_addr, last_addr, page;
 	int end_aligned;
 	unsigned int cur_page = 0;
@@ -234,14 +237,14 @@ static int iser_sg_to_page_vec(struct iser_data_buf *data,
 	int i;
 
 	/* compute the offset of first element */
-	page_vec->offset = (u64) sg[0].offset & ~MASK_4K;
+	page_vec->offset = (u64) sgl[0].offset & ~MASK_4K;
 
-	for (i = 0; i < data->dma_nents; i++) {
-		unsigned int dma_len = ib_sg_dma_len(ibdev, &sg[i]);
+	for_each_sg(sgl, sg, data->dma_nents, i) {
+		unsigned int dma_len = ib_sg_dma_len(ibdev, sg);
 
 		total_sz += dma_len;
 
-		first_addr = ib_sg_dma_address(ibdev, &sg[i]);
+		first_addr = ib_sg_dma_address(ibdev, sg);
 		last_addr  = first_addr + dma_len;
 
 		end_aligned   = !(last_addr  & ~MASK_4K);
@@ -249,9 +252,9 @@ static int iser_sg_to_page_vec(struct iser_data_buf *data,
 		/* continue to collect page fragments till aligned or SG ends */
 		while (!end_aligned && (i + 1 < data->dma_nents)) {
 			i++;
-			dma_len = ib_sg_dma_len(ibdev, &sg[i]);
+			dma_len = ib_sg_dma_len(ibdev, sg);
 			total_sz += dma_len;
-			last_addr = ib_sg_dma_address(ibdev, &sg[i]) + dma_len;
+			last_addr = ib_sg_dma_address(ibdev, sg) + dma_len;
 			end_aligned = !(last_addr  & ~MASK_4K);
 		}
 
@@ -286,25 +289,26 @@ static int iser_sg_to_page_vec(struct iser_data_buf *data,
 static unsigned int iser_data_buf_aligned_len(struct iser_data_buf *data,
 					      struct ib_device *ibdev)
 {
-	struct scatterlist *sg;
+	struct scatterlist *sgl, *sg;
 	u64 end_addr, next_addr;
 	int i, cnt;
 	unsigned int ret_len = 0;
 
-	sg = (struct scatterlist *)data->buf;
+	sgl = (struct scatterlist *)data->buf;
 
-	for (cnt = 0, i = 0; i < data->dma_nents; i++, cnt++) {
+	cnt = 0;
+	for_each_sg(sgl, sg, data->dma_nents, i) {
 		/* iser_dbg("Checking sg iobuf [%d]: phys=0x%08lX "
 		   "offset: %ld sz: %ld\n", i,
-		   (unsigned long)page_to_phys(sg[i].page),
-		   (unsigned long)sg[i].offset,
-		   (unsigned long)sg[i].length); */
-		end_addr = ib_sg_dma_address(ibdev, &sg[i]) +
-			   ib_sg_dma_len(ibdev, &sg[i]);
+		   (unsigned long)page_to_phys(sg->page),
+		   (unsigned long)sg->offset,
+		   (unsigned long)sg->length); */
+		end_addr = ib_sg_dma_address(ibdev, sg) +
+			   ib_sg_dma_len(ibdev, sg);
 		/* iser_dbg("Checking sg iobuf end address "
 		       "0x%08lX\n", end_addr); */
 		if (i + 1 < data->dma_nents) {
-			next_addr = ib_sg_dma_address(ibdev, &sg[i+1]);
+			next_addr = ib_sg_dma_address(ibdev, sg_next(sg));
 			/* are i, i+1 fragments of the same page? */
 			if (end_addr == next_addr)
 				continue;
@@ -324,15 +328,16 @@ static unsigned int iser_data_buf_aligned_len(struct iser_data_buf *data,
 static void iser_data_buf_dump(struct iser_data_buf *data,
 			       struct ib_device *ibdev)
 {
-	struct scatterlist *sg = (struct scatterlist *)data->buf;
+	struct scatterlist *sgl = (struct scatterlist *)data->buf;
+	struct scatterlist *sg;
 	int i;
 
-	for (i = 0; i < data->dma_nents; i++)
+	for_each_sg(sgl, sg, data->dma_nents, i)
 		iser_err("sg[%d] dma_addr:0x%lX page:0x%p "
 			 "off:0x%x sz:0x%x dma_len:0x%x\n",
-			 i, (unsigned long)ib_sg_dma_address(ibdev, &sg[i]),
-			 sg[i].page, sg[i].offset,
-			 sg[i].length, ib_sg_dma_len(ibdev, &sg[i]));
+			 i, (unsigned long)ib_sg_dma_address(ibdev, sg),
+			 sg->page, sg->offset,
+			 sg->length, ib_sg_dma_len(ibdev, sg));
 }
 
 static void iser_dump_page_vec(struct iser_page_vec *page_vec)
-- 
1.5.3.rc0.90.gbaa79

