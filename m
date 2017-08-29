From: Nikola Pajkovsky <npajkovsky@suse.cz>
Subject: [PATCH 2/3] scsi: aacraid: get rid of one level of indentation
Date: Tue, 29 Aug 2017 13:59:03 +0200
Message-ID: <bc42b0e33f50825a6227c49459f253557d862b24.1504007944.git.npajkovsky@suse.cz>
References: <d039d8dcc35ced04bf27f20a653532429486d190.1504007944.git.npajkovsky@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d039d8dcc35ced04bf27f20a653532429486d190.1504007944.git.npajkovsky@suse.cz>
In-Reply-To: <d039d8dcc35ced04bf27f20a653532429486d190.1504007944.git.npajkovsky@suse.cz>
References: <d039d8dcc35ced04bf27f20a653532429486d190.1504007944.git.npajkovsky@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: Nikola Pajkovsky <npajkovsky@suse.cz>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

  unsigned long byte_count = 0;
  nseg = scsi_dma_map(scsicmd);
  if (nseg < 0)
     return nseg;
  if (nseg) {
     ...
  }
  return byte_count;

is equal to

  unsigned long byte_count = 0;
  nseg = scsi_dma_map(scsicmd);
  if (nseg <= 0)
     return nseg;
  ...
  return byte_count;

No other code has changed.

Signed-off-by: Nikola Pajkovsky <npajkovsky@suse.cz>
---
 drivers/scsi/aacraid/aachba.c | 267 +++++++++++++++++++++---------------------
 1 file changed, 131 insertions(+), 136 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index a1a2c71e1626..3c354766791e 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -3763,6 +3763,8 @@ static long aac_build_sg(struct scsi_cmnd *scsicmd, struct sgmap *psg)
 	struct aac_dev *dev;
 	unsigned long byte_count = 0;
 	int nseg;
+	struct scatterlist *sg;
+	int i;
 
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 	// Get rid of old data
@@ -3771,32 +3773,29 @@ static long aac_build_sg(struct scsi_cmnd *scsicmd, struct sgmap *psg)
 	psg->sg[0].count = 0;
 
 	nseg = scsi_dma_map(scsicmd);
-	if (nseg < 0)
+	if (nseg <= 0)
 		return nseg;
-	if (nseg) {
-		struct scatterlist *sg;
-		int i;
 
-		psg->count = cpu_to_le32(nseg);
+	psg->count = cpu_to_le32(nseg);
 
-		scsi_for_each_sg(scsicmd, sg, nseg, i) {
-			psg->sg[i].addr = cpu_to_le32(sg_dma_address(sg));
-			psg->sg[i].count = cpu_to_le32(sg_dma_len(sg));
-			byte_count += sg_dma_len(sg);
-		}
-		/* hba wants the size to be exact */
-		if (byte_count > scsi_bufflen(scsicmd)) {
-			u32 temp = le32_to_cpu(psg->sg[i-1].count) -
-				(byte_count - scsi_bufflen(scsicmd));
-			psg->sg[i-1].count = cpu_to_le32(temp);
-			byte_count = scsi_bufflen(scsicmd);
-		}
-		/* Check for command underflow */
-		if(scsicmd->underflow && (byte_count < scsicmd->underflow)){
-			printk(KERN_WARNING"aacraid: cmd len %08lX cmd underflow %08X\n",
-					byte_count, scsicmd->underflow);
-		}
+	scsi_for_each_sg(scsicmd, sg, nseg, i) {
+		psg->sg[i].addr = cpu_to_le32(sg_dma_address(sg));
+		psg->sg[i].count = cpu_to_le32(sg_dma_len(sg));
+		byte_count += sg_dma_len(sg);
+	}
+	/* hba wants the size to be exact */
+	if (byte_count > scsi_bufflen(scsicmd)) {
+		u32 temp = le32_to_cpu(psg->sg[i-1].count) -
+			(byte_count - scsi_bufflen(scsicmd));
+		psg->sg[i-1].count = cpu_to_le32(temp);
+		byte_count = scsi_bufflen(scsicmd);
+	}
+	/* Check for command underflow */
+	if(scsicmd->underflow && (byte_count < scsicmd->underflow)){
+		printk(KERN_WARNING"aacraid: cmd len %08lX cmd underflow %08X\n",
+		       byte_count, scsicmd->underflow);
 	}
+
 	return byte_count;
 }
 
@@ -3807,6 +3806,8 @@ static long aac_build_sg64(struct scsi_cmnd *scsicmd, struct sgmap64 *psg)
 	unsigned long byte_count = 0;
 	u64 addr;
 	int nseg;
+	struct scatterlist *sg;
+	int i;
 
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 	// Get rid of old data
@@ -3816,34 +3817,31 @@ static long aac_build_sg64(struct scsi_cmnd *scsicmd, struct sgmap64 *psg)
 	psg->sg[0].count = 0;
 
 	nseg = scsi_dma_map(scsicmd);
-	if (nseg < 0)
+	if (nseg <= 0)
 		return nseg;
-	if (nseg) {
-		struct scatterlist *sg;
-		int i;
-
-		scsi_for_each_sg(scsicmd, sg, nseg, i) {
-			int count = sg_dma_len(sg);
-			addr = sg_dma_address(sg);
-			psg->sg[i].addr[0] = cpu_to_le32(addr & 0xffffffff);
-			psg->sg[i].addr[1] = cpu_to_le32(addr>>32);
-			psg->sg[i].count = cpu_to_le32(count);
-			byte_count += count;
-		}
-		psg->count = cpu_to_le32(nseg);
-		/* hba wants the size to be exact */
-		if (byte_count > scsi_bufflen(scsicmd)) {
-			u32 temp = le32_to_cpu(psg->sg[i-1].count) -
-				(byte_count - scsi_bufflen(scsicmd));
-			psg->sg[i-1].count = cpu_to_le32(temp);
-			byte_count = scsi_bufflen(scsicmd);
-		}
-		/* Check for command underflow */
-		if(scsicmd->underflow && (byte_count < scsicmd->underflow)){
-			printk(KERN_WARNING"aacraid: cmd len %08lX cmd underflow %08X\n",
-					byte_count, scsicmd->underflow);
-		}
+
+	scsi_for_each_sg(scsicmd, sg, nseg, i) {
+		int count = sg_dma_len(sg);
+		addr = sg_dma_address(sg);
+		psg->sg[i].addr[0] = cpu_to_le32(addr & 0xffffffff);
+		psg->sg[i].addr[1] = cpu_to_le32(addr>>32);
+		psg->sg[i].count = cpu_to_le32(count);
+		byte_count += count;
 	}
+	psg->count = cpu_to_le32(nseg);
+	/* hba wants the size to be exact */
+	if (byte_count > scsi_bufflen(scsicmd)) {
+		u32 temp = le32_to_cpu(psg->sg[i-1].count) -
+			(byte_count - scsi_bufflen(scsicmd));
+		psg->sg[i-1].count = cpu_to_le32(temp);
+		byte_count = scsi_bufflen(scsicmd);
+	}
+	/* Check for command underflow */
+	if(scsicmd->underflow && (byte_count < scsicmd->underflow)){
+		printk(KERN_WARNING"aacraid: cmd len %08lX cmd underflow %08X\n",
+		       byte_count, scsicmd->underflow);
+	}
+
 	return byte_count;
 }
 
@@ -3851,6 +3849,8 @@ static long aac_build_sgraw(struct scsi_cmnd *scsicmd, struct sgmapraw *psg)
 {
 	unsigned long byte_count = 0;
 	int nseg;
+	struct scatterlist *sg;
+	int i;
 
 	// Get rid of old data
 	psg->count = 0;
@@ -3862,37 +3862,34 @@ static long aac_build_sgraw(struct scsi_cmnd *scsicmd, struct sgmapraw *psg)
 	psg->sg[0].flags = 0;
 
 	nseg = scsi_dma_map(scsicmd);
-	if (nseg < 0)
+	if (nseg <= 0)
 		return nseg;
-	if (nseg) {
-		struct scatterlist *sg;
-		int i;
-
-		scsi_for_each_sg(scsicmd, sg, nseg, i) {
-			int count = sg_dma_len(sg);
-			u64 addr = sg_dma_address(sg);
-			psg->sg[i].next = 0;
-			psg->sg[i].prev = 0;
-			psg->sg[i].addr[1] = cpu_to_le32((u32)(addr>>32));
-			psg->sg[i].addr[0] = cpu_to_le32((u32)(addr & 0xffffffff));
-			psg->sg[i].count = cpu_to_le32(count);
-			psg->sg[i].flags = 0;
-			byte_count += count;
-		}
-		psg->count = cpu_to_le32(nseg);
-		/* hba wants the size to be exact */
-		if (byte_count > scsi_bufflen(scsicmd)) {
-			u32 temp = le32_to_cpu(psg->sg[i-1].count) -
-				(byte_count - scsi_bufflen(scsicmd));
-			psg->sg[i-1].count = cpu_to_le32(temp);
-			byte_count = scsi_bufflen(scsicmd);
-		}
-		/* Check for command underflow */
-		if(scsicmd->underflow && (byte_count < scsicmd->underflow)){
-			printk(KERN_WARNING"aacraid: cmd len %08lX cmd underflow %08X\n",
-					byte_count, scsicmd->underflow);
-		}
+
+	scsi_for_each_sg(scsicmd, sg, nseg, i) {
+		int count = sg_dma_len(sg);
+		u64 addr = sg_dma_address(sg);
+		psg->sg[i].next = 0;
+		psg->sg[i].prev = 0;
+		psg->sg[i].addr[1] = cpu_to_le32((u32)(addr>>32));
+		psg->sg[i].addr[0] = cpu_to_le32((u32)(addr & 0xffffffff));
+		psg->sg[i].count = cpu_to_le32(count);
+		psg->sg[i].flags = 0;
+		byte_count += count;
+	}
+	psg->count = cpu_to_le32(nseg);
+	/* hba wants the size to be exact */
+	if (byte_count > scsi_bufflen(scsicmd)) {
+		u32 temp = le32_to_cpu(psg->sg[i-1].count) -
+			(byte_count - scsi_bufflen(scsicmd));
+		psg->sg[i-1].count = cpu_to_le32(temp);
+		byte_count = scsi_bufflen(scsicmd);
+	}
+	/* Check for command underflow */
+	if(scsicmd->underflow && (byte_count < scsicmd->underflow)){
+		printk(KERN_WARNING"aacraid: cmd len %08lX cmd underflow %08X\n",
+		       byte_count, scsicmd->underflow);
 	}
+
 	return byte_count;
 }
 
@@ -3901,75 +3898,73 @@ static long aac_build_sgraw2(struct scsi_cmnd *scsicmd,
 {
 	unsigned long byte_count = 0;
 	int nseg;
+	struct scatterlist *sg;
+	int i, conformable = 0;
+	u32 min_size = PAGE_SIZE, cur_size;
 
 	nseg = scsi_dma_map(scsicmd);
-	if (nseg < 0)
+	if (nseg <= 0)
 		return nseg;
-	if (nseg) {
-		struct scatterlist *sg;
-		int i, conformable = 0;
-		u32 min_size = PAGE_SIZE, cur_size;
-
-		scsi_for_each_sg(scsicmd, sg, nseg, i) {
-			int count = sg_dma_len(sg);
-			u64 addr = sg_dma_address(sg);
-
-			BUG_ON(i >= sg_max);
-			rio2->sge[i].addrHigh = cpu_to_le32((u32)(addr>>32));
-			rio2->sge[i].addrLow = cpu_to_le32((u32)(addr & 0xffffffff));
-			cur_size = cpu_to_le32(count);
-			rio2->sge[i].length = cur_size;
-			rio2->sge[i].flags = 0;
-			if (i == 0) {
-				conformable = 1;
-				rio2->sgeFirstSize = cur_size;
-			} else if (i == 1) {
-				rio2->sgeNominalSize = cur_size;
+
+	scsi_for_each_sg(scsicmd, sg, nseg, i) {
+		int count = sg_dma_len(sg);
+		u64 addr = sg_dma_address(sg);
+
+		BUG_ON(i >= sg_max);
+		rio2->sge[i].addrHigh = cpu_to_le32((u32)(addr>>32));
+		rio2->sge[i].addrLow = cpu_to_le32((u32)(addr & 0xffffffff));
+		cur_size = cpu_to_le32(count);
+		rio2->sge[i].length = cur_size;
+		rio2->sge[i].flags = 0;
+		if (i == 0) {
+			conformable = 1;
+			rio2->sgeFirstSize = cur_size;
+		} else if (i == 1) {
+			rio2->sgeNominalSize = cur_size;
+			min_size = cur_size;
+		} else if ((i+1) < nseg && cur_size != rio2->sgeNominalSize) {
+			conformable = 0;
+			if (cur_size < min_size)
 				min_size = cur_size;
-			} else if ((i+1) < nseg && cur_size != rio2->sgeNominalSize) {
-				conformable = 0;
-				if (cur_size < min_size)
-					min_size = cur_size;
-			}
-			byte_count += count;
 		}
+		byte_count += count;
+	}
 
-		/* hba wants the size to be exact */
-		if (byte_count > scsi_bufflen(scsicmd)) {
-			u32 temp = le32_to_cpu(rio2->sge[i-1].length) -
-				(byte_count - scsi_bufflen(scsicmd));
-			rio2->sge[i-1].length = cpu_to_le32(temp);
-			byte_count = scsi_bufflen(scsicmd);
-		}
+	/* hba wants the size to be exact */
+	if (byte_count > scsi_bufflen(scsicmd)) {
+		u32 temp = le32_to_cpu(rio2->sge[i-1].length) -
+			(byte_count - scsi_bufflen(scsicmd));
+		rio2->sge[i-1].length = cpu_to_le32(temp);
+		byte_count = scsi_bufflen(scsicmd);
+	}
 
-		rio2->sgeCnt = cpu_to_le32(nseg);
-		rio2->flags |= cpu_to_le16(RIO2_SG_FORMAT_IEEE1212);
-		/* not conformable: evaluate required sg elements */
-		if (!conformable) {
-			int j, nseg_new = nseg, err_found;
-			for (i = min_size / PAGE_SIZE; i >= 1; --i) {
-				err_found = 0;
-				nseg_new = 2;
-				for (j = 1; j < nseg - 1; ++j) {
-					if (rio2->sge[j].length % (i*PAGE_SIZE)) {
-						err_found = 1;
-						break;
-					}
-					nseg_new += (rio2->sge[j].length / (i*PAGE_SIZE));
-				}
-				if (!err_found)
+	rio2->sgeCnt = cpu_to_le32(nseg);
+	rio2->flags |= cpu_to_le16(RIO2_SG_FORMAT_IEEE1212);
+	/* not conformable: evaluate required sg elements */
+	if (!conformable) {
+		int j, nseg_new = nseg, err_found;
+		for (i = min_size / PAGE_SIZE; i >= 1; --i) {
+			err_found = 0;
+			nseg_new = 2;
+			for (j = 1; j < nseg - 1; ++j) {
+				if (rio2->sge[j].length % (i*PAGE_SIZE)) {
+					err_found = 1;
 					break;
+				}
+				nseg_new += (rio2->sge[j].length / (i*PAGE_SIZE));
 			}
-			if (i > 0 && nseg_new <= sg_max)
-				aac_convert_sgraw2(rio2, i, nseg, nseg_new);
-		} else
-			rio2->flags |= cpu_to_le16(RIO2_SGL_CONFORMANT);
-
-		/* Check for command underflow */
-		if (scsicmd->underflow && (byte_count < scsicmd->underflow)) {
-			printk(KERN_WARNING"aacraid: cmd len %08lX cmd underflow %08X\n",
-					byte_count, scsicmd->underflow);
+			if (!err_found)
+				break;
 		}
+		if (i > 0 && nseg_new <= sg_max)
+			aac_convert_sgraw2(rio2, i, nseg, nseg_new);
+	} else
+		rio2->flags |= cpu_to_le16(RIO2_SGL_CONFORMANT);
+
+	/* Check for command underflow */
+	if (scsicmd->underflow && (byte_count < scsicmd->underflow)) {
+		printk(KERN_WARNING"aacraid: cmd len %08lX cmd underflow %08X\n",
+		       byte_count, scsicmd->underflow);
 	}
 
 	return byte_count;
-- 
2.13.5
