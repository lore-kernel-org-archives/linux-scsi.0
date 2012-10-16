From: Mahesh Rajashekhara <Mahesh_Rajashekhara@pmc-sierra.com>
Subject: [PATCH 1/1] aacraid: SCSI dma mapping failure case handling
Date: Wed, 17 Oct 2012 02:29:30 +0530
Message-ID: <1350421170-2436-1-git-send-email-Mahesh_Rajashekhara@pmc-sierra.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:45895 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753939Ab2JPPun (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Oct 2012 11:50:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, Achim_Leubner@pmc-sierra.com, Tony_Ruiz@pmc-sierra.com, Mahesh_Rajashekhara@pmc-sierra.com

This patch handles SCSI dma mapping failure case. Reporting error code to the upper layer instead of BUG_ON().

This patch is created against current upstream kernel.

Signed-off-by: Mahesh Rajashekhara <Mahesh_Rajashekhara@pmc-sierra.com>
---
 drivers/scsi/aacraid/aachba.c  |   63 +++++++++++++++++++++++++++++++---------
 drivers/scsi/aacraid/aacraid.h |    2 +-
 2 files changed, 50 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index d79457a..efa2900 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -971,6 +971,7 @@ static int aac_read_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u3
 {
 	struct aac_dev *dev = fib->dev;
 	u16 fibsize, command;
+	unsigned long ret;
 
 	aac_fib_init(fib);
 	if (dev->comm_interface == AAC_COMM_MESSAGE_TYPE2 && !dev->sync_mode) {
@@ -982,7 +983,10 @@ static int aac_read_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u3
 		readcmd2->byteCount = cpu_to_le32(count<<9);
 		readcmd2->cid = cpu_to_le16(scmd_id(cmd));
 		readcmd2->flags = cpu_to_le16(RIO2_IO_TYPE_READ);
-		aac_build_sgraw2(cmd, readcmd2, dev->scsi_host_ptr->sg_tablesize);
+		ret = aac_build_sgraw2(cmd, readcmd2,
+				dev->scsi_host_ptr->sg_tablesize);
+		if (ret < 0)
+			return ret;
 		command = ContainerRawIo2;
 		fibsize = sizeof(struct aac_raw_io2) +
 			((le32_to_cpu(readcmd2->sgeCnt)-1) * sizeof(struct sge_ieee1212));
@@ -996,7 +1000,9 @@ static int aac_read_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u3
 		readcmd->flags = cpu_to_le16(RIO_TYPE_READ);
 		readcmd->bpTotal = 0;
 		readcmd->bpComplete = 0;
-		aac_build_sgraw(cmd, &readcmd->sg);
+		ret = aac_build_sgraw(cmd, &readcmd->sg);
+		if (ret < 0)
+			return ret;
 		command = ContainerRawIo;
 		fibsize = sizeof(struct aac_raw_io) +
 			((le32_to_cpu(readcmd->sg.count)-1) * sizeof(struct sgentryraw));
@@ -1019,6 +1025,7 @@ static int aac_read_block64(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u
 {
 	u16 fibsize;
 	struct aac_read64 *readcmd;
+	unsigned long ret;
 	aac_fib_init(fib);
 	readcmd = (struct aac_read64 *) fib_data(fib);
 	readcmd->command = cpu_to_le32(VM_CtHostRead64);
@@ -1028,7 +1035,9 @@ static int aac_read_block64(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u
 	readcmd->pad   = 0;
 	readcmd->flags = 0;
 
-	aac_build_sg64(cmd, &readcmd->sg);
+	ret = aac_build_sg64(cmd, &readcmd->sg);
+	if (ret < 0)
+		return ret;
 	fibsize = sizeof(struct aac_read64) +
 		((le32_to_cpu(readcmd->sg.count) - 1) *
 		 sizeof (struct sgentry64));
@@ -1050,6 +1059,8 @@ static int aac_read_block(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u32
 {
 	u16 fibsize;
 	struct aac_read *readcmd;
+	unsigned long ret;
+
 	aac_fib_init(fib);
 	readcmd = (struct aac_read *) fib_data(fib);
 	readcmd->command = cpu_to_le32(VM_CtBlockRead);
@@ -1057,7 +1068,9 @@ static int aac_read_block(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u32
 	readcmd->block = cpu_to_le32((u32)(lba&0xffffffff));
 	readcmd->count = cpu_to_le32(count * 512);
 
-	aac_build_sg(cmd, &readcmd->sg);
+	ret = aac_build_sg(cmd, &readcmd->sg);
+	if (ret < 0)
+		return ret;
 	fibsize = sizeof(struct aac_read) +
 			((le32_to_cpu(readcmd->sg.count) - 1) *
 			 sizeof (struct sgentry));
@@ -1079,6 +1092,7 @@ static int aac_write_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u
 {
 	struct aac_dev *dev = fib->dev;
 	u16 fibsize, command;
+	unsigned long ret;
 
 	aac_fib_init(fib);
 	if (dev->comm_interface == AAC_COMM_MESSAGE_TYPE2 && !dev->sync_mode) {
@@ -1093,7 +1107,10 @@ static int aac_write_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u
 						   (((aac_cache & 5) != 5) || !fib->dev->cache_protected)) ?
 			cpu_to_le16(RIO2_IO_TYPE_WRITE|RIO2_IO_SUREWRITE) :
 			cpu_to_le16(RIO2_IO_TYPE_WRITE);
-		aac_build_sgraw2(cmd, writecmd2, dev->scsi_host_ptr->sg_tablesize);
+		ret = aac_build_sgraw2(cmd, writecmd2,
+				dev->scsi_host_ptr->sg_tablesize);
+		if (ret < 0)
+			return ret;
 		command = ContainerRawIo2;
 		fibsize = sizeof(struct aac_raw_io2) +
 			((le32_to_cpu(writecmd2->sgeCnt)-1) * sizeof(struct sge_ieee1212));
@@ -1110,7 +1127,9 @@ static int aac_write_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u
 			cpu_to_le16(RIO_TYPE_WRITE);
 		writecmd->bpTotal = 0;
 		writecmd->bpComplete = 0;
-		aac_build_sgraw(cmd, &writecmd->sg);
+		ret = aac_build_sgraw(cmd, &writecmd->sg);
+		if (ret < 0)
+			return ret;
 		command = ContainerRawIo;
 		fibsize = sizeof(struct aac_raw_io) +
 			((le32_to_cpu(writecmd->sg.count)-1) * sizeof (struct sgentryraw));
@@ -1133,6 +1152,7 @@ static int aac_write_block64(struct fib * fib, struct scsi_cmnd * cmd, u64 lba,
 {
 	u16 fibsize;
 	struct aac_write64 *writecmd;
+	unsigned long ret;
 	aac_fib_init(fib);
 	writecmd = (struct aac_write64 *) fib_data(fib);
 	writecmd->command = cpu_to_le32(VM_CtHostWrite64);
@@ -1142,7 +1162,9 @@ static int aac_write_block64(struct fib * fib, struct scsi_cmnd * cmd, u64 lba,
 	writecmd->pad	= 0;
 	writecmd->flags	= 0;
 
-	aac_build_sg64(cmd, &writecmd->sg);
+	ret = aac_build_sg64(cmd, &writecmd->sg);
+	if (ret < 0)
+		return ret;
 	fibsize = sizeof(struct aac_write64) +
 		((le32_to_cpu(writecmd->sg.count) - 1) *
 		 sizeof (struct sgentry64));
@@ -1164,6 +1186,7 @@ static int aac_write_block(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u3
 {
 	u16 fibsize;
 	struct aac_write *writecmd;
+	unsigned long ret;
 	aac_fib_init(fib);
 	writecmd = (struct aac_write *) fib_data(fib);
 	writecmd->command = cpu_to_le32(VM_CtBlockWrite);
@@ -1173,7 +1196,9 @@ static int aac_write_block(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u3
 	writecmd->sg.count = cpu_to_le32(1);
 	/* ->stable is not used - it did mean which type of write */
 
-	aac_build_sg(cmd, &writecmd->sg);
+	ret = aac_build_sg(cmd, &writecmd->sg);
+	if (ret < 0)
+		return ret;
 	fibsize = sizeof(struct aac_write) +
 		((le32_to_cpu(writecmd->sg.count) - 1) *
 		 sizeof (struct sgentry));
@@ -1235,8 +1260,11 @@ static int aac_scsi_64(struct fib * fib, struct scsi_cmnd * cmd)
 {
 	u16 fibsize;
 	struct aac_srb * srbcmd = aac_scsi_common(fib, cmd);
+	unsigned long ret;
 
-	aac_build_sg64(cmd, (struct sgmap64*) &srbcmd->sg);
+	ret = aac_build_sg64(cmd, (struct sgmap64 *) &srbcmd->sg);
+	if (ret < 0)
+		return ret;
 	srbcmd->count = cpu_to_le32(scsi_bufflen(cmd));
 
 	memset(srbcmd->cdb, 0, sizeof(srbcmd->cdb));
@@ -1263,8 +1291,11 @@ static int aac_scsi_32(struct fib * fib, struct scsi_cmnd * cmd)
 {
 	u16 fibsize;
 	struct aac_srb * srbcmd = aac_scsi_common(fib, cmd);
+	unsigned long ret;
 
-	aac_build_sg(cmd, (struct sgmap*)&srbcmd->sg);
+	ret = aac_build_sg(cmd, (struct sgmap *)&srbcmd->sg);
+	if (ret < 0)
+		return ret;
 	srbcmd->count = cpu_to_le32(scsi_bufflen(cmd));
 
 	memset(srbcmd->cdb, 0, sizeof(srbcmd->cdb));
@@ -2883,7 +2914,8 @@ static unsigned long aac_build_sg(struct scsi_cmnd* scsicmd, struct sgmap* psg)
 	psg->sg[0].count = 0;
 
 	nseg = scsi_dma_map(scsicmd);
-	BUG_ON(nseg < 0);
+	if (nseg < 0)
+		return nseg;
 	if (nseg) {
 		struct scatterlist *sg;
 		int i;
@@ -2927,7 +2959,8 @@ static unsigned long aac_build_sg64(struct scsi_cmnd* scsicmd, struct sgmap64* p
 	psg->sg[0].count = 0;
 
 	nseg = scsi_dma_map(scsicmd);
-	BUG_ON(nseg < 0);
+	if (nseg < 0)
+		return nseg;
 	if (nseg) {
 		struct scatterlist *sg;
 		int i;
@@ -2972,7 +3005,8 @@ static unsigned long aac_build_sgraw(struct scsi_cmnd* scsicmd, struct sgmapraw*
 	psg->sg[0].flags = 0;
 
 	nseg = scsi_dma_map(scsicmd);
-	BUG_ON(nseg < 0);
+	if (nseg < 0)
+		return nseg;
 	if (nseg) {
 		struct scatterlist *sg;
 		int i;
@@ -3011,7 +3045,8 @@ static unsigned long aac_build_sgraw2(struct scsi_cmnd *scsicmd, struct aac_raw_
 	int nseg;
 
 	nseg = scsi_dma_map(scsicmd);
-	BUG_ON(nseg < 0);
+	if (nseg < 0)
+		return nseg;
 	if (nseg) {
 		struct scatterlist *sg;
 		int i, conformable = 0;
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 9e933a8..742f5d7 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -12,7 +12,7 @@
  *----------------------------------------------------------------------------*/
 
 #ifndef AAC_DRIVER_BUILD
-# define AAC_DRIVER_BUILD 29800
+# define AAC_DRIVER_BUILD 29801
 # define AAC_DRIVER_BRANCH "-ms"
 #endif
 #define MAXIMUM_NUM_CONTAINERS	32
-- 
1.7.7.6

