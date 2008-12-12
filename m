From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod 9/12]: Update PSCSI, IBLOCK, FILEIO and
	RAMDISK subsystem plugins
Date: Fri, 12 Dec 2008 01:34:50 -0800
Message-ID: <1229074490.4153.656.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:20035 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757731AbYLLJez (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2008 04:34:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

>From f6a4a22459ed17fd26ea58ae9c76a99c07a08b62 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 12 Dec 2008 00:59:43 -0800
Subject: [PATCH] [Target_Core_Mod]: Update PSCSI, IBLOCK, FILEIO and RAMDISK subsystem plugins

This patch updates Target_Core_Mod subsytem plugins to use the updated target_core_base.h
data structures.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_file.c   |   10 +++++-----
 drivers/lio-core/target_core_iblock.c |   12 ++++++------
 drivers/lio-core/target_core_pscsi.c  |   17 ++++++++---------
 drivers/lio-core/target_core_rd.c     |   10 +++++-----
 4 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/drivers/lio-core/target_core_file.c b/drivers/lio-core/target_core_file.c
index 2eaf8b4..1a1034f 100644
--- a/drivers/lio-core/target_core_file.c
+++ b/drivers/lio-core/target_core_file.c
@@ -418,7 +418,7 @@ extern void fd_get_evpd_prod (unsigned char *buf, u32 size, se_device_t *dev)
 extern void fd_get_evpd_sn (unsigned char *buf, u32 size, se_device_t *dev)
 {
 	fd_dev_t *fdev = (fd_dev_t *) dev->dev_ptr;
-	se_hba_t *hba = dev->iscsi_hba;
+	se_hba_t *hba = dev->se_hba;
 
 	snprintf(buf, size, "%u_%u", hba->hba_id, fdev->fd_dev_id);	
 	return;
@@ -433,8 +433,8 @@ extern int fd_emulate_inquiry (se_task_t *task)
 	unsigned char prod[64], se_location[128];
 	unsigned char *sub_sn = NULL;
 	se_cmd_t *cmd = TASK_CMD(task);
-	fd_dev_t *fdev = (fd_dev_t *) task->iscsi_dev->dev_ptr;
-	se_hba_t *hba = task->iscsi_dev->iscsi_hba;
+	fd_dev_t *fdev = (fd_dev_t *) task->se_dev->dev_ptr;
+	se_hba_t *hba = task->se_dev->se_hba;
 	
 	memset(prod, 0, 64);
 	memset(se_location, 0, 128);
@@ -461,7 +461,7 @@ extern int fd_emulate_inquiry (se_task_t *task)
  */
 static int fd_emulate_read_cap (se_task_t *task)
 {
-	fd_dev_t *fd_dev = (fd_dev_t *) task->iscsi_dev->dev_ptr;
+	fd_dev_t *fd_dev = (fd_dev_t *) task->se_dev->dev_ptr;
 	u32 blocks = (fd_dev->fd_dev_size / FD_BLOCKSIZE);
 	
 	if ((fd_dev->fd_dev_size / FD_BLOCKSIZE) >= 0x00000000ffffffff)
@@ -472,7 +472,7 @@ static int fd_emulate_read_cap (se_task_t *task)
 
 static int fd_emulate_read_cap16 (se_task_t *task)
 {
-	fd_dev_t *fd_dev = (fd_dev_t *) task->iscsi_dev->dev_ptr;
+	fd_dev_t *fd_dev = (fd_dev_t *) task->se_dev->dev_ptr;
 	unsigned long long blocks_long = (fd_dev->fd_dev_size / FD_BLOCKSIZE);
 	
 	return(transport_generic_emulate_readcapacity_16(TASK_CMD(task), blocks_long, FD_BLOCKSIZE));
diff --git a/drivers/lio-core/target_core_iblock.c b/drivers/lio-core/target_core_iblock.c
index 9f38756..0db23b6 100644
--- a/drivers/lio-core/target_core_iblock.c
+++ b/drivers/lio-core/target_core_iblock.c
@@ -352,8 +352,8 @@ static int iblock_emulate_inquiry (se_task_t *task)
 {
 	unsigned char prod[64], se_location[128];
 	se_cmd_t *cmd = TASK_CMD(task);
-	iblock_dev_t *ibd = (iblock_dev_t *) task->iscsi_dev->dev_ptr;
-	se_hba_t *hba = task->iscsi_dev->iscsi_hba;
+	iblock_dev_t *ibd = (iblock_dev_t *) task->se_dev->dev_ptr;
+	se_hba_t *hba = task->se_dev->se_hba;
 	unsigned char *sub_sn = NULL;
 
 	memset(prod, 0, 64);
@@ -377,7 +377,7 @@ static int iblock_emulate_inquiry (se_task_t *task)
 
 static int iblock_emulate_read_cap (se_task_t *task)
 {
-	iblock_dev_t *ibd = (iblock_dev_t *) task->iscsi_dev->dev_ptr;
+	iblock_dev_t *ibd = (iblock_dev_t *) task->se_dev->dev_ptr;
 	struct block_device *bd = ibd->ibd_bd;
 	u32 blocks = (get_capacity(bd->bd_disk) - 1);
 
@@ -389,7 +389,7 @@ static int iblock_emulate_read_cap (se_task_t *task)
 
 static int iblock_emulate_read_cap16 (se_task_t *task)
 {
-	iblock_dev_t *ibd = (iblock_dev_t *) task->iscsi_dev->dev_ptr;
+	iblock_dev_t *ibd = (iblock_dev_t *) task->se_dev->dev_ptr;
 	struct block_device *bd = ibd->ibd_bd;
 	unsigned long long blocks_long = (get_capacity(bd->bd_disk) - 1);
 
@@ -713,7 +713,7 @@ extern void iblock_map_task_non_SG (se_task_t *task)
 static void iblock_bio_destructor (struct bio *bio)
 {
 	se_task_t *task = (se_task_t *)bio->bi_private;
-	iblock_dev_t *ib_dev = (iblock_dev_t *) task->iscsi_dev->dev_ptr;
+	iblock_dev_t *ib_dev = (iblock_dev_t *) task->se_dev->dev_ptr;
 
 	bio_free(bio, ib_dev->ibd_bio_set);
 }
@@ -752,7 +752,7 @@ static struct bio *iblock_get_bio (se_task_t *task,
 
 extern int iblock_map_task_SG (se_task_t *task)
 {
-	iblock_dev_t *ib_dev = (iblock_dev_t *) task->iscsi_dev->dev_ptr;
+	iblock_dev_t *ib_dev = (iblock_dev_t *) task->se_dev->dev_ptr;
 	iblock_req_t *ib_req = (iblock_req_t *) task->transport_req;
 	struct bio *bio = NULL, *hbio = NULL, *tbio = NULL;
 	struct scatterlist *sg = task->task_sg;
diff --git a/drivers/lio-core/target_core_pscsi.c b/drivers/lio-core/target_core_pscsi.c
index 43fa6e3..e8a2c95 100644
--- a/drivers/lio-core/target_core_pscsi.c
+++ b/drivers/lio-core/target_core_pscsi.c
@@ -603,7 +603,7 @@ extern void pscsi_free_device (void *p)
  */
 extern int pscsi_transport_complete (se_task_t *task)
 {
-	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->iscsi_dev->dev_ptr;
+	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->se_dev->dev_ptr;
 	struct scsi_device *sd = (struct scsi_device *) pdv->pdv_sd;
 	void *pscsi_buf;
 	int result;
@@ -618,8 +618,7 @@ extern int pscsi_transport_complete (se_task_t *task)
 		u32 len = 0;
 		unsigned char *dst = (unsigned char *)pscsi_buf, *iqn = NULL;
 		unsigned char buf[EVPD_BUF_LEN];
-//#warning FIXME v2.8: se_obj_api usage
-		se_hba_t *hba = task->iscsi_dev->iscsi_hba;
+		se_hba_t *hba = task->se_dev->se_hba;
 
 		/*
 		 * The Initiator port did not request EVPD information.
@@ -696,10 +695,10 @@ extern int pscsi_transport_complete (se_task_t *task)
 	 */
 	if (((cdb[0] == MODE_SENSE) || (cdb[0] == MODE_SENSE_10)) &&
 	     (status_byte(result) << 1) == SAM_STAT_GOOD) {
-		if (!TASK_CMD(task)->iscsi_deve)
+		if (!TASK_CMD(task)->se_deve)
 			goto after_mode_sense;
 
-		if (TASK_CMD(task)->iscsi_deve->lun_flags & ISCSI_LUNFLAGS_READ_ONLY) {
+		if (TASK_CMD(task)->se_deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY) {
 			unsigned char *buf = (unsigned char *)pscsi_buf;
 
 			if (cdb[0] == MODE_SENSE_10) {
@@ -785,7 +784,7 @@ extern void pscsi_get_evpd_sn (unsigned char *buf, u32 size, se_device_t *dev)
 {
 	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) dev->dev_ptr;
 	struct scsi_device *sd = (struct scsi_device *) pdv->pdv_sd;
-	se_hba_t *hba = dev->iscsi_hba;
+	se_hba_t *hba = dev->se_hba;
 
 	snprintf(buf, size, "%u_%u_%u_%u", hba->hba_id, sd->channel, sd->id, sd->lun);
 	return;
@@ -794,7 +793,7 @@ extern void pscsi_get_evpd_sn (unsigned char *buf, u32 size, se_device_t *dev)
 static int pscsi_blk_get_request (se_task_t *task)
 {
 	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
-	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->iscsi_dev->dev_ptr;
+	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->se_dev->dev_ptr;
 
 	pt->pscsi_req = blk_get_request(pdv->pdv_sd->request_queue,
 			(pt->pscsi_direction == DMA_TO_DEVICE), GFP_KERNEL);
@@ -835,7 +834,7 @@ static int pscsi_blk_get_request (se_task_t *task)
 extern int pscsi_do_task (se_task_t *task)
 {
 	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
-	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->iscsi_dev->dev_ptr;
+	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->se_dev->dev_ptr;
 	struct gendisk *gd = NULL;
 	/*
 	 * Grab pointer to struct gendisk for TYPE_DISK and TYPE_ROM
@@ -1195,7 +1194,7 @@ extern int pscsi_map_task_non_SG (se_task_t *task)
 	se_cmd_t *cmd = TASK_CMD(task);
 	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
 	unsigned char *buf = (unsigned char *) T_TASK(cmd)->t_task_buf;
-	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->iscsi_dev->dev_ptr;
+	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->se_dev->dev_ptr;
 	int ret = 0;
 
 	pt->pscsi_buf = (void *)buf;
diff --git a/drivers/lio-core/target_core_rd.c b/drivers/lio-core/target_core_rd.c
index d735569..9b6d859 100644
--- a/drivers/lio-core/target_core_rd.c
+++ b/drivers/lio-core/target_core_rd.c
@@ -405,7 +405,7 @@ extern void rd_get_evpd_prod (unsigned char *buf, u32 size, se_device_t *dev)
 extern void rd_get_evpd_sn (unsigned char *buf, u32 size, se_device_t *dev)
 {
 	rd_dev_t *rd_dev = (rd_dev_t *) dev->dev_ptr;
-	se_hba_t *hba = dev->iscsi_hba;
+	se_hba_t *hba = dev->se_hba;
 
 	snprintf(buf, size, "%u_%u", hba->hba_id, rd_dev->rd_dev_id);
 	return;
@@ -418,9 +418,9 @@ extern void rd_get_evpd_sn (unsigned char *buf, u32 size, se_device_t *dev)
 static int rd_emulate_inquiry (se_task_t *task)
 {
 	unsigned char prod[64], se_location[128];
-	rd_dev_t *rd_dev = (rd_dev_t *) task->iscsi_dev->dev_ptr;
+	rd_dev_t *rd_dev = (rd_dev_t *) task->se_dev->dev_ptr;
 	se_cmd_t *cmd = TASK_CMD(task);
-	se_hba_t *hba = task->iscsi_dev->iscsi_hba;
+	se_hba_t *hba = task->se_dev->se_hba;
 	
 	memset(prod, 0, 64);
 	memset(se_location, 0, 128);
@@ -439,7 +439,7 @@ static int rd_emulate_inquiry (se_task_t *task)
  */
 static int rd_emulate_read_cap (se_task_t *task)
 {
-	rd_dev_t *rd_dev = (rd_dev_t *) task->iscsi_dev->dev_ptr;
+	rd_dev_t *rd_dev = (rd_dev_t *) task->se_dev->dev_ptr;
 	u32 blocks = ((rd_dev->rd_page_count * PAGE_SIZE) / RD_BLOCKSIZE) - 1;
 
 	if ((((rd_dev->rd_page_count * PAGE_SIZE) / RD_BLOCKSIZE) - 1) > 0x00000000ffffffff)
@@ -450,7 +450,7 @@ static int rd_emulate_read_cap (se_task_t *task)
 
 static int rd_emulate_read_cap16 (se_task_t *task)
 {
-	rd_dev_t *rd_dev = (rd_dev_t *) task->iscsi_dev->dev_ptr;
+	rd_dev_t *rd_dev = (rd_dev_t *) task->se_dev->dev_ptr;
 	unsigned long long blocks_long = ((rd_dev->rd_page_count * PAGE_SIZE) / RD_BLOCKSIZE) - 1;	
 
 	return(transport_generic_emulate_readcapacity_16(TASK_CMD(task), blocks_long, RD_BLOCKSIZE));
-- 
1.5.4.1



