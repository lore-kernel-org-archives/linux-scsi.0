From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 15/19] aacraid: convert to use the data buffer accessors
Date: Sat, 12 May 2007 19:05:45 +0900 (JST)
Message-ID: <20070512184228J.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:44916 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898AbXELKGA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 06:06:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mark_salyzyn@adaptec.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

This converts aacraid to use the data buffer accessors.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/aacraid/aachba.c |   96 +++++++++++++++++-----------------------
 1 files changed, 41 insertions(+), 55 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 5cdfea3..813f89f 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -341,7 +341,7 @@ static void aac_internal_transfer(struct
 {
 	void *buf;
 	unsigned int transfer_len;
-	struct scatterlist *sg = scsicmd->request_buffer;
+	struct scatterlist *sg = scsi_sglist(scsicmd);
 
 	buf = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
 	transfer_len = min(sg->length, len + offset);
@@ -1033,7 +1033,7 @@ static int aac_scsi_64(struct fib * fib,
 	struct aac_srb * srbcmd = aac_scsi_common(fib, cmd);
 
 	aac_build_sg64(cmd, (struct sgmap64*) &srbcmd->sg);
-	srbcmd->count = cpu_to_le32(cmd->request_bufflen);
+	srbcmd->count = cpu_to_le32(scsi_bufflen(cmd));
 
 	memset(srbcmd->cdb, 0, sizeof(srbcmd->cdb));
 	memcpy(srbcmd->cdb, cmd->cmnd, cmd->cmd_len);
@@ -1061,7 +1061,7 @@ static int aac_scsi_32(struct fib * fib,
 	struct aac_srb * srbcmd = aac_scsi_common(fib, cmd);
 
 	aac_build_sg(cmd, (struct sgmap*)&srbcmd->sg);
-	srbcmd->count = cpu_to_le32(cmd->request_bufflen);
+	srbcmd->count = cpu_to_le32(scsi_bufflen(cmd));
 
 	memset(srbcmd->cdb, 0, sizeof(srbcmd->cdb));
 	memcpy(srbcmd->cdb, cmd->cmnd, cmd->cmd_len);
@@ -1363,12 +1363,8 @@ static void io_callback(void *context, s
 	}
 
 	BUG_ON(fibptr == NULL);
-		
-	if(scsicmd->use_sg)
-		pci_unmap_sg(dev->pdev, 
-			(struct scatterlist *)scsicmd->request_buffer,
-			scsicmd->use_sg,
-			scsicmd->sc_data_direction);
+
+	scsi_dma_unmap(&dev->pdev->dev, scsicmd);
 
 	readreply = (struct aac_read_reply *)fib_data(fibptr);
 	if (le32_to_cpu(readreply->status) == ST_OK)
@@ -2135,15 +2131,11 @@ static void aac_srb_callback(void *conte
 	/*
 	 *	Calculate resid for sg 
 	 */
-	 
-	scsicmd->resid = scsicmd->request_bufflen - 
+
+	scsi_resid(scsicmd) = scsi_bufflen(scsicmd) -
 		le32_to_cpu(srbreply->data_xfer_length);
 
-	if(scsicmd->use_sg)
-		pci_unmap_sg(dev->pdev, 
-			(struct scatterlist *)scsicmd->request_buffer,
-			scsicmd->use_sg,
-			scsicmd->sc_data_direction);
+	scsi_dma_unmap(&dev->pdev->dev, scsicmd);
 
 	/*
 	 * First check the fib status
@@ -2329,34 +2321,33 @@ static unsigned long aac_build_sg(struct
 {
 	struct aac_dev *dev;
 	unsigned long byte_count = 0;
+	int nseg;
 
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 	// Get rid of old data
 	psg->count = 0;
 	psg->sg[0].addr = 0;
-	psg->sg[0].count = 0;  
-	if (scsicmd->use_sg) {
+	psg->sg[0].count = 0;
+
+	nseg = scsi_dma_map(&dev->pdev->dev, scsicmd);
+	BUG_ON(nseg < 0);
+	if (nseg) {
 		struct scatterlist *sg;
 		int i;
-		int sg_count;
-		sg = (struct scatterlist *) scsicmd->request_buffer;
 
-		sg_count = pci_map_sg(dev->pdev, sg, scsicmd->use_sg,
-			scsicmd->sc_data_direction);
-		psg->count = cpu_to_le32(sg_count);
+		psg->count = cpu_to_le32(nseg);
 
-		for (i = 0; i < sg_count; i++) {
+		scsi_for_each_sg(scsicmd, sg, nseg, i) {
 			psg->sg[i].addr = cpu_to_le32(sg_dma_address(sg));
 			psg->sg[i].count = cpu_to_le32(sg_dma_len(sg));
 			byte_count += sg_dma_len(sg);
-			sg++;
 		}
 		/* hba wants the size to be exact */
-		if(byte_count > scsicmd->request_bufflen){
-			u32 temp = le32_to_cpu(psg->sg[i-1].count) - 
-				(byte_count - scsicmd->request_bufflen);
+		if (byte_count > scsi_bufflen(scsicmd)) {
+			u32 temp = le32_to_cpu(psg->sg[i-1].count) -
+				(byte_count - scsi_bufflen(scsicmd));
 			psg->sg[i-1].count = cpu_to_le32(temp);
-			byte_count = scsicmd->request_bufflen;
+			byte_count = scsi_bufflen(scsicmd);
 		}
 		/* Check for command underflow */
 		if(scsicmd->underflow && (byte_count < scsicmd->underflow)){
@@ -2373,6 +2364,7 @@ static unsigned long aac_build_sg64(stru
 	struct aac_dev *dev;
 	unsigned long byte_count = 0;
 	u64 addr;
+	int nseg;
 
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 	// Get rid of old data
@@ -2380,31 +2372,28 @@ static unsigned long aac_build_sg64(stru
 	psg->sg[0].addr[0] = 0;
 	psg->sg[0].addr[1] = 0;
 	psg->sg[0].count = 0;
-	if (scsicmd->use_sg) {
+
+	nseg = scsi_dma_map(&dev->pdev->dev, scsicmd);
+	BUG_ON(nseg < 0);
+	if (nseg) {
 		struct scatterlist *sg;
 		int i;
-		int sg_count;
-		sg = (struct scatterlist *) scsicmd->request_buffer;
 
-		sg_count = pci_map_sg(dev->pdev, sg, scsicmd->use_sg,
-			scsicmd->sc_data_direction);
-
-		for (i = 0; i < sg_count; i++) {
+		scsi_for_each_sg(scsicmd, sg, nseg, i) {
 			int count = sg_dma_len(sg);
 			addr = sg_dma_address(sg);
 			psg->sg[i].addr[0] = cpu_to_le32(addr & 0xffffffff);
 			psg->sg[i].addr[1] = cpu_to_le32(addr>>32);
 			psg->sg[i].count = cpu_to_le32(count);
 			byte_count += count;
-			sg++;
 		}
-		psg->count = cpu_to_le32(sg_count);
+		psg->count = cpu_to_le32(nseg);
 		/* hba wants the size to be exact */
-		if(byte_count > scsicmd->request_bufflen){
-			u32 temp = le32_to_cpu(psg->sg[i-1].count) - 
-				(byte_count - scsicmd->request_bufflen);
+		if (byte_count > scsi_bufflen(scsicmd)) {
+			u32 temp = le32_to_cpu(psg->sg[i-1].count) -
+				(byte_count - scsi_bufflen(scsicmd));
 			psg->sg[i-1].count = cpu_to_le32(temp);
-			byte_count = scsicmd->request_bufflen;
+			byte_count = scsi_bufflen(scsicmd);
 		}
 		/* Check for command underflow */
 		if(scsicmd->underflow && (byte_count < scsicmd->underflow)){
@@ -2420,6 +2409,7 @@ static unsigned long aac_build_sgraw(str
 	struct Scsi_Host *host = scsicmd->device->host;
 	struct aac_dev *dev = (struct aac_dev *)host->hostdata;
 	unsigned long byte_count = 0;
+	int nseg;
 
 	// Get rid of old data
 	psg->count = 0;
@@ -2430,16 +2420,13 @@ static unsigned long aac_build_sgraw(str
 	psg->sg[0].count = 0;
 	psg->sg[0].flags = 0;
 
-	if (scsicmd->use_sg) {
+	nseg = scsi_dma_map(&dev->pdev->dev, scsicmd);
+	BUG_ON(nseg < 0);
+	if (nseg) {
 		struct scatterlist *sg;
 		int i;
-		int sg_count;
-		sg = (struct scatterlist *) scsicmd->request_buffer;
-
-		sg_count = pci_map_sg(dev->pdev, sg, scsicmd->use_sg,
-			scsicmd->sc_data_direction);
 
-		for (i = 0; i < sg_count; i++) {
+		scsi_for_each_sg(scsicmd, sg, nseg, i) {
 			int count = sg_dma_len(sg);
 			u64 addr = sg_dma_address(sg);
 			psg->sg[i].next = 0;
@@ -2449,15 +2436,14 @@ static unsigned long aac_build_sgraw(str
 			psg->sg[i].count = cpu_to_le32(count);
 			psg->sg[i].flags = 0;
 			byte_count += count;
-			sg++;
 		}
-		psg->count = cpu_to_le32(sg_count);
+		psg->count = cpu_to_le32(nseg);
 		/* hba wants the size to be exact */
-		if(byte_count > scsicmd->request_bufflen){
-			u32 temp = le32_to_cpu(psg->sg[i-1].count) - 
-				(byte_count - scsicmd->request_bufflen);
+		if (byte_count > scsi_bufflen(scsicmd)) {
+			u32 temp = le32_to_cpu(psg->sg[i-1].count) -
+				(byte_count - scsi_bufflen(scsicmd));
 			psg->sg[i-1].count = cpu_to_le32(temp);
-			byte_count = scsicmd->request_bufflen;
+			byte_count = scsi_bufflen(scsicmd);
 		}
 		/* Check for command underflow */
 		if(scsicmd->underflow && (byte_count < scsicmd->underflow)){
-- 
1.4.3.2

