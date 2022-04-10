Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B042BC433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Apr 2022 17:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240015AbiDJRjQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Apr 2022 13:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiDJRjP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Apr 2022 13:39:15 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2022428E1E
        for <linux-scsi@vger.kernel.org>; Sun, 10 Apr 2022 10:37:02 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 6BDFD2041CF;
        Sun, 10 Apr 2022 19:37:01 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZkgPw+SpFj-U; Sun, 10 Apr 2022 19:36:59 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-78-195-155.dyn.295.ca [45.78.195.155])
        by smtp.infotech.no (Postfix) with ESMTPA id 20C212041BD;
        Sun, 10 Apr 2022 19:36:58 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, hch@lst.de
Subject: [PATCH v2 2/6] sd, sd_zbc: use scsi_cmnd cdb access functions
Date:   Sun, 10 Apr 2022 13:36:48 -0400
Message-Id: <20220410173652.313016-3-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220410173652.313016-1-dgilbert@interlog.com>
References: <20220410173652.313016-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Although currently unlikely to be needed, allow the sd driver to
issue SCSI commands whose CDB length is > 32. Remove the
direct access to the scsi_cmnd::cmnd field and use an access
function instead. Use 'cdb' rather than 'cmd' to refer to the
SCSI CDB field.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sd.c     | 176 +++++++++++++++++++++++-------------------
 drivers/scsi/sd_zbc.c |  12 +--
 2 files changed, 101 insertions(+), 87 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a390679cf458..f0fc5789ccbf 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -842,6 +842,7 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	unsigned int data_len = 24;
 	char *buf;
+	u8 *cdb;
 
 	rq->special_vec.bv_page = mempool_alloc(sd_page_pool, GFP_ATOMIC);
 	if (!rq->special_vec.bv_page)
@@ -851,9 +852,9 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 	rq->special_vec.bv_len = data_len;
 	rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
 
-	cmd->cmd_len = 10;
-	cmd->cmnd[0] = UNMAP;
-	cmd->cmnd[8] = 24;
+	cdb = scsi_cmnd_set_cdb(cmd, NULL, 10);
+	cdb[0] = UNMAP;
+	cdb[8] = 24;
 
 	buf = bvec_virt(&rq->special_vec);
 	put_unaligned_be16(6 + 16, &buf[0]);
@@ -877,6 +878,7 @@ static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
 	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	u32 data_len = sdp->sector_size;
+	u8 *cdb;
 
 	rq->special_vec.bv_page = mempool_alloc(sd_page_pool, GFP_ATOMIC);
 	if (!rq->special_vec.bv_page)
@@ -886,12 +888,12 @@ static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
 	rq->special_vec.bv_len = data_len;
 	rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
 
-	cmd->cmd_len = 16;
-	cmd->cmnd[0] = WRITE_SAME_16;
+	cdb = scsi_cmnd_set_cdb(cmd, NULL, 16);
+	cdb[0] = WRITE_SAME_16;
 	if (unmap)
-		cmd->cmnd[1] = 0x8; /* UNMAP */
-	put_unaligned_be64(lba, &cmd->cmnd[2]);
-	put_unaligned_be32(nr_blocks, &cmd->cmnd[10]);
+		cdb[1] = 0x8; /* UNMAP */
+	put_unaligned_be64(lba, &cdb[2]);
+	put_unaligned_be32(nr_blocks, &cdb[10]);
 
 	cmd->allowed = sdkp->max_retries;
 	cmd->transfersize = data_len;
@@ -909,6 +911,7 @@ static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
 	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	u32 data_len = sdp->sector_size;
+	u8 *cdb;
 
 	rq->special_vec.bv_page = mempool_alloc(sd_page_pool, GFP_ATOMIC);
 	if (!rq->special_vec.bv_page)
@@ -918,12 +921,12 @@ static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
 	rq->special_vec.bv_len = data_len;
 	rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
 
-	cmd->cmd_len = 10;
-	cmd->cmnd[0] = WRITE_SAME;
+	cdb = scsi_cmnd_set_cdb(cmd, NULL, 10);
+	cdb[0] = WRITE_SAME;
 	if (unmap)
-		cmd->cmnd[1] = 0x8; /* UNMAP */
-	put_unaligned_be32(lba, &cmd->cmnd[2]);
-	put_unaligned_be16(nr_blocks, &cmd->cmnd[7]);
+		cdb[1] = 0x8; /* UNMAP */
+	put_unaligned_be32(lba, &cdb[2]);
+	put_unaligned_be16(nr_blocks, &cdb[7]);
 
 	cmd->allowed = sdkp->max_retries;
 	cmd->transfersize = data_len;
@@ -1024,12 +1027,13 @@ static blk_status_t sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
 {
 	struct request *rq = scsi_cmd_to_rq(cmd);
 	struct scsi_disk *sdkp = scsi_disk(rq->q->disk);
+	u8 *cdb;
 
 	/* flush requests don't perform I/O, zero the S/G table */
 	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
 
-	cmd->cmnd[0] = SYNCHRONIZE_CACHE;
-	cmd->cmd_len = 10;
+	cdb = scsi_cmnd_set_cdb(cmd, NULL, 10);
+	cdb[0] = SYNCHRONIZE_CACHE;
 	cmd->transfersize = 0;
 	cmd->allowed = sdkp->max_retries;
 
@@ -1041,14 +1045,16 @@ static blk_status_t sd_setup_rw32_cmnd(struct scsi_cmnd *cmd, bool write,
 				       sector_t lba, unsigned int nr_blocks,
 				       unsigned char flags)
 {
-	cmd->cmd_len = SD_EXT_CDB_SIZE;
-	cmd->cmnd[0]  = VARIABLE_LENGTH_CMD;
-	cmd->cmnd[7]  = 0x18; /* Additional CDB len */
-	cmd->cmnd[9]  = write ? WRITE_32 : READ_32;
-	cmd->cmnd[10] = flags;
-	put_unaligned_be64(lba, &cmd->cmnd[12]);
-	put_unaligned_be32(lba, &cmd->cmnd[20]); /* Expected Indirect LBA */
-	put_unaligned_be32(nr_blocks, &cmd->cmnd[28]);
+	u8 *cdb;
+
+	cdb = scsi_cmnd_set_cdb(cmd, NULL, SD_EXT_CDB_SIZE);
+	cdb[0]  = VARIABLE_LENGTH_CMD;
+	cdb[7]  = 0x18; /* Additional CDB len */
+	cdb[9]  = write ? WRITE_32 : READ_32;
+	cdb[10] = flags;
+	put_unaligned_be64(lba, &cdb[12]);
+	put_unaligned_be32(lba, &cdb[20]); /* Expected Indirect LBA */
+	put_unaligned_be32(nr_blocks, &cdb[28]);
 
 	return BLK_STS_OK;
 }
@@ -1057,13 +1063,15 @@ static blk_status_t sd_setup_rw16_cmnd(struct scsi_cmnd *cmd, bool write,
 				       sector_t lba, unsigned int nr_blocks,
 				       unsigned char flags)
 {
-	cmd->cmd_len  = 16;
-	cmd->cmnd[0]  = write ? WRITE_16 : READ_16;
-	cmd->cmnd[1]  = flags;
-	cmd->cmnd[14] = 0;
-	cmd->cmnd[15] = 0;
-	put_unaligned_be64(lba, &cmd->cmnd[2]);
-	put_unaligned_be32(nr_blocks, &cmd->cmnd[10]);
+	u8 *cdb;
+
+	cdb = scsi_cmnd_set_cdb(cmd, NULL, 16);
+	cdb[0]  = write ? WRITE_16 : READ_16;
+	cdb[1]  = flags;
+	cdb[14] = 0;
+	cdb[15] = 0;
+	put_unaligned_be64(lba, &cdb[2]);
+	put_unaligned_be32(nr_blocks, &cdb[10]);
 
 	return BLK_STS_OK;
 }
@@ -1072,13 +1080,15 @@ static blk_status_t sd_setup_rw10_cmnd(struct scsi_cmnd *cmd, bool write,
 				       sector_t lba, unsigned int nr_blocks,
 				       unsigned char flags)
 {
-	cmd->cmd_len = 10;
-	cmd->cmnd[0] = write ? WRITE_10 : READ_10;
-	cmd->cmnd[1] = flags;
-	cmd->cmnd[6] = 0;
-	cmd->cmnd[9] = 0;
-	put_unaligned_be32(lba, &cmd->cmnd[2]);
-	put_unaligned_be16(nr_blocks, &cmd->cmnd[7]);
+	u8 *cdb;
+
+	cdb = scsi_cmnd_set_cdb(cmd, NULL, 10);
+	cdb[0] = write ? WRITE_10 : READ_10;
+	cdb[1] = flags;
+	cdb[6] = 0;
+	cdb[9] = 0;
+	put_unaligned_be32(lba, &cdb[2]);
+	put_unaligned_be16(nr_blocks, &cdb[7]);
 
 	return BLK_STS_OK;
 }
@@ -1087,6 +1097,8 @@ static blk_status_t sd_setup_rw6_cmnd(struct scsi_cmnd *cmd, bool write,
 				      sector_t lba, unsigned int nr_blocks,
 				      unsigned char flags)
 {
+	u8 *cdb;
+
 	/* Avoid that 0 blocks gets translated into 256 blocks. */
 	if (WARN_ON_ONCE(nr_blocks == 0))
 		return BLK_STS_IOERR;
@@ -1101,13 +1113,13 @@ static blk_status_t sd_setup_rw6_cmnd(struct scsi_cmnd *cmd, bool write,
 		return BLK_STS_IOERR;
 	}
 
-	cmd->cmd_len = 6;
-	cmd->cmnd[0] = write ? WRITE_6 : READ_6;
-	cmd->cmnd[1] = (lba >> 16) & 0x1f;
-	cmd->cmnd[2] = (lba >> 8) & 0xff;
-	cmd->cmnd[3] = lba & 0xff;
-	cmd->cmnd[4] = nr_blocks;
-	cmd->cmnd[5] = 0;
+	cdb = scsi_cmnd_set_cdb(cmd, NULL, 6);
+	cdb[0] = write ? WRITE_6 : READ_6;
+	cdb[1] = (lba >> 16) & 0x1f;
+	cdb[2] = (lba >> 8) & 0xff;
+	cdb[3] = lba & 0xff;
+	cdb[4] = nr_blocks;
+	cdb[5] = 0;
 
 	return BLK_STS_OK;
 }
@@ -1589,14 +1601,14 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 		sshdr = &my_sshdr;
 
 	for (retries = 3; retries > 0; --retries) {
-		unsigned char cmd[10] = { 0 };
+		unsigned char cdb[10] = { 0 };
 
-		cmd[0] = SYNCHRONIZE_CACHE;
+		cdb[0] = SYNCHRONIZE_CACHE;
 		/*
 		 * Leave the rest of the command zero to indicate
 		 * flush everything.
 		 */
-		res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, sshdr,
+		res = scsi_execute(sdp, cdb, DMA_NONE, NULL, 0, NULL, sshdr,
 				timeout, sdkp->max_retries, 0, RQF_PM, NULL);
 		if (res == 0)
 			break;
@@ -1710,19 +1722,19 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	struct scsi_device *sdev = sdkp->device;
 	struct scsi_sense_hdr sshdr;
 	int result;
-	u8 cmd[16] = { 0, };
+	u8 cdb[16] = { 0, };
 	u8 data[24] = { 0, };
 
-	cmd[0] = PERSISTENT_RESERVE_OUT;
-	cmd[1] = sa;
-	cmd[2] = type;
-	put_unaligned_be32(sizeof(data), &cmd[5]);
+	cdb[0] = PERSISTENT_RESERVE_OUT;
+	cdb[1] = sa;
+	cdb[2] = type;
+	put_unaligned_be32(sizeof(data), &cdb[5]);
 
 	put_unaligned_be64(key, &data[0]);
 	put_unaligned_be64(sa_key, &data[8]);
 	data[20] = flags;
 
-	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, &data, sizeof(data),
+	result = scsi_execute_req(sdev, cdb, DMA_TO_DEVICE, &data, sizeof(data),
 			&sshdr, SD_TIMEOUT, sdkp->max_retries, NULL);
 
 	if (scsi_status_is_check_condition(result) &&
@@ -1931,6 +1943,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	struct scsi_sense_hdr sshdr;
 	struct request *req = scsi_cmd_to_rq(SCpnt);
 	struct scsi_disk *sdkp = scsi_disk(req->q->disk);
+	const u8 *cdb;
 	int sense_valid = 0;
 	int sense_deferred = 0;
 
@@ -1979,6 +1992,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	    (!sense_valid || sense_deferred))
 		goto out;
 
+	cdb = scsi_cmnd_get_cdb(SCpnt);
 	switch (sshdr.sense_key) {
 	case HARDWARE_ERROR:
 	case MEDIUM_ERROR:
@@ -2006,13 +2020,13 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 			break;
 		case 0x20:	/* INVALID COMMAND OPCODE */
 		case 0x24:	/* INVALID FIELD IN CDB */
-			switch (SCpnt->cmnd[0]) {
+			switch (cdb[0]) {
 			case UNMAP:
 				sd_config_discard(sdkp, SD_LBP_DISABLE);
 				break;
 			case WRITE_SAME_16:
 			case WRITE_SAME:
-				if (SCpnt->cmnd[1] & 8) { /* UNMAP */
+				if (cdb[1] & 8) { /* UNMAP */
 					sd_config_discard(sdkp, SD_LBP_DISABLE);
 				} else {
 					sdkp->device->no_write_same = 1;
@@ -2044,7 +2058,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 static void
 sd_spinup_disk(struct scsi_disk *sdkp)
 {
-	unsigned char cmd[10];
+	u8 cdb[10];
 	unsigned long spintime_expire = 0;
 	int retries, spintime;
 	unsigned int the_result;
@@ -2061,10 +2075,10 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 		do {
 			bool media_was_present = sdkp->media_present;
 
-			cmd[0] = TEST_UNIT_READY;
-			memset((void *) &cmd[1], 0, 9);
+			cdb[0] = TEST_UNIT_READY;
+			memset((void *) &cdb[1], 0, 9);
 
-			the_result = scsi_execute_req(sdkp->device, cmd,
+			the_result = scsi_execute_req(sdkp->device, cdb,
 						      DMA_NONE, NULL, 0,
 						      &sshdr, SD_TIMEOUT,
 						      sdkp->max_retries, NULL);
@@ -2118,13 +2132,13 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			 */
 			if (!spintime) {
 				sd_printk(KERN_NOTICE, sdkp, "Spinning up disk...");
-				cmd[0] = START_STOP;
-				cmd[1] = 1;	/* Return immediately */
-				memset((void *) &cmd[2], 0, 8);
-				cmd[4] = 1;	/* Start spin cycle */
+				cdb[0] = START_STOP;
+				cdb[1] = 1;	/* Return immediately */
+				memset((void *) &cdb[2], 0, 8);
+				cdb[4] = 1;	/* Start spin cycle */
 				if (sdkp->device->start_stop_pwr_cond)
-					cmd[4] |= 1 << 4;
-				scsi_execute_req(sdkp->device, cmd, DMA_NONE,
+					cdb[4] |= 1 << 4;
+				scsi_execute_req(sdkp->device, cdb, DMA_NONE,
 						 NULL, 0, &sshdr,
 						 SD_TIMEOUT, sdkp->max_retries,
 						 NULL);
@@ -2247,7 +2261,7 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 						unsigned char *buffer)
 {
-	unsigned char cmd[16];
+	u8 cdb[16];
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	int the_result;
@@ -2260,13 +2274,13 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		return -EINVAL;
 
 	do {
-		memset(cmd, 0, 16);
-		cmd[0] = SERVICE_ACTION_IN_16;
-		cmd[1] = SAI_READ_CAPACITY_16;
-		cmd[13] = RC16_LEN;
+		memset(cdb, 0, 16);
+		cdb[0] = SERVICE_ACTION_IN_16;
+		cdb[1] = SAI_READ_CAPACITY_16;
+		cdb[13] = RC16_LEN;
 		memset(buffer, 0, RC16_LEN);
 
-		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
+		the_result = scsi_execute_req(sdp, cdb, DMA_FROM_DEVICE,
 					buffer, RC16_LEN, &sshdr,
 					SD_TIMEOUT, sdkp->max_retries, NULL);
 
@@ -2338,7 +2352,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 						unsigned char *buffer)
 {
-	unsigned char cmd[16];
+	unsigned char cdb[16];
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	int the_result;
@@ -2347,11 +2361,11 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	unsigned sector_size;
 
 	do {
-		cmd[0] = READ_CAPACITY;
-		memset(&cmd[1], 0, 9);
+		cdb[0] = READ_CAPACITY;
+		memset(&cdb[1], 0, 9);
 		memset(buffer, 0, 8);
 
-		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
+		the_result = scsi_execute_req(sdp, cdb, DMA_FROM_DEVICE,
 					buffer, 8, &sshdr,
 					SD_TIMEOUT, sdkp->max_retries, NULL);
 
@@ -3546,21 +3560,21 @@ static void scsi_disk_release(struct device *dev)
 
 static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 {
-	unsigned char cmd[6] = { START_STOP };	/* START_VALID */
+	u8 cdb[6] = { START_STOP };	/* START_VALID */
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdp = sdkp->device;
 	int res;
 
 	if (start)
-		cmd[4] |= 1;	/* START */
+		cdb[4] |= 1;	/* START */
 
 	if (sdp->start_stop_pwr_cond)
-		cmd[4] |= start ? 1 << 4 : 3 << 4;	/* Active or Standby */
+		cdb[4] |= start ? 1 << 4 : 3 << 4;	/* Active or Standby */
 
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
+	res = scsi_execute(sdp, cdb, DMA_NONE, NULL, 0, NULL, &sshdr,
 			SD_TIMEOUT, sdkp->max_retries, 0, RQF_PM, NULL);
 	if (res) {
 		sd_print_result(sdkp, "Start/Stop Unit failed", res);
@@ -3700,9 +3714,9 @@ static int sd_resume_runtime(struct device *dev)
 
 	if (sdp->ignore_media_change) {
 		/* clear the device's sense data */
-		static const u8 cmd[10] = { REQUEST_SENSE };
+		static const u8 cdb[10] = { REQUEST_SENSE };
 
-		if (scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL,
+		if (scsi_execute(sdp, cdb, DMA_NONE, NULL, 0, NULL,
 				 NULL, sdp->request_queue->rq_timeout, 1, 0,
 				 RQF_PM, NULL))
 			sd_printk(KERN_NOTICE, sdkp,
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 7f466280993b..5567e6af5b49 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -389,6 +389,7 @@ blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
 	struct request *rq = scsi_cmd_to_rq(cmd);
 	sector_t sector = blk_rq_pos(rq);
 	struct scsi_disk *sdkp = scsi_disk(rq->q->disk);
+	u8 *cdb;
 	sector_t block = sectors_to_logical(sdkp->device, sector);
 	blk_status_t ret;
 
@@ -396,14 +397,13 @@ blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
 	if (ret != BLK_STS_OK)
 		return ret;
 
-	cmd->cmd_len = 16;
-	memset(cmd->cmnd, 0, cmd->cmd_len);
-	cmd->cmnd[0] = ZBC_OUT;
-	cmd->cmnd[1] = op;
+	cdb = scsi_cmnd_set_cdb(cmd, NULL, 16);
+	cdb[0] = ZBC_OUT;
+	cdb[1] = op;
 	if (all)
-		cmd->cmnd[14] = 0x1;
+		cdb[14] = 0x1;
 	else
-		put_unaligned_be64(block, &cmd->cmnd[2]);
+		put_unaligned_be64(block, &cdb[2]);
 
 	rq->timeout = SD_TIMEOUT;
 	cmd->sc_data_direction = DMA_NONE;
-- 
2.25.1

