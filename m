Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B47C43461
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 038FB61446
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbhENVg7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:59 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:41508 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233451AbhENVgv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:51 -0400
Received: by mail-pg1-f180.google.com with SMTP id t30so247858pgl.8
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e1DN+xXfpZr3JlML+Pyq4Pi3tSk9QmkyYcgqp3sJ1g8=;
        b=WrAtLmQTNYRXiGXqyJu4nkaKa9S168OnZLMV85eDCvdWmaBfNDp6k7+zE4oOgK3zBc
         ycZAY/SfrrP6FC2WMRGYCOLL2rQzstdGszKOP/bjk7yFIJwFK3cvlzw8X/W8I0XBYevs
         yfsX3lfYvR8RiY9rKhjMlfnPvAn3JAtED9Rl6KcA7ZCuFzhSs7PSDcAxur1ULuadhQ2K
         phvJy83rr/JZQAzP6TQbhetEGErSGKiYcOIX/YCnesRSBlbms+OC50YuxiwNarKe+uct
         9R1a4gNqAHy8jErKdRwDM9tS1THiPNIM0sHBY/zZZjd3gV0M5ArvbEbuBIfHUuqvYals
         Qiwg==
X-Gm-Message-State: AOAM532Kz+sOXtqtfrkl3wbAddrYcQXjv+t2kh8GvhHZ1WX3hGoYR5t8
        XZBDpfLqJJ8tgLilGU8CrVE=
X-Google-Smtp-Source: ABdhPJz5SuHKmGkU0w+C7zdrGTRKYmxGGLh0AgvOjiQ5zGmDav6ArtOGiHHQrGdoBD77qKU9y6crJw==
X-Received: by 2002:aa7:9398:0:b029:2ce:9147:85c2 with SMTP id t24-20020aa793980000b02902ce914785c2mr14559128pfe.23.1621028139412;
        Fri, 14 May 2021 14:35:39 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:38 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 03/50] sd: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:33:09 -0700
Message-Id: <20210514213356.5264-55-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using blk_req() instead. This
patch does not change any functionality.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c     | 32 ++++++++++++++++----------------
 drivers/scsi/sd_zbc.c | 10 +++++-----
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cb3c37d1e009..0886b4dbef32 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -779,8 +779,8 @@ static unsigned int sd_prot_flag_mask(unsigned int prot_op)
 static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
 					   unsigned int dix, unsigned int dif)
 {
-	struct bio *bio = scmd->request->bio;
-	unsigned int prot_op = sd_prot_op(rq_data_dir(scmd->request), dix, dif);
+	struct bio *bio = blk_req(scmd)->bio;
+	unsigned int prot_op = sd_prot_op(rq_data_dir(blk_req(scmd)), dix, dif);
 	unsigned int protect = 0;
 
 	if (dix) {				/* DIX Type 0, 1, 2, 3 */
@@ -871,7 +871,7 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdp = cmd->device;
-	struct request *rq = cmd->request;
+	struct request *rq = blk_req(cmd);
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
@@ -907,7 +907,7 @@ static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
 		bool unmap)
 {
 	struct scsi_device *sdp = cmd->device;
-	struct request *rq = cmd->request;
+	struct request *rq = blk_req(cmd);
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
@@ -939,7 +939,7 @@ static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
 		bool unmap)
 {
 	struct scsi_device *sdp = cmd->device;
-	struct request *rq = cmd->request;
+	struct request *rq = blk_req(cmd);
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
@@ -969,7 +969,7 @@ static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
 
 static blk_status_t sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
 {
-	struct request *rq = cmd->request;
+	struct request *rq = blk_req(cmd);
 	struct scsi_device *sdp = cmd->device;
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
@@ -1066,7 +1066,7 @@ static void sd_config_write_same(struct scsi_disk *sdkp)
  **/
 static blk_status_t sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 {
-	struct request *rq = cmd->request;
+	struct request *rq = blk_req(cmd);
 	struct scsi_device *sdp = cmd->device;
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	struct bio *bio = rq->bio;
@@ -1115,7 +1115,7 @@ static blk_status_t sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 
 static blk_status_t sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
 {
-	struct request *rq = cmd->request;
+	struct request *rq = blk_req(cmd);
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 
 	/* flush requests don't perform I/O, zero the S/G table */
@@ -1213,7 +1213,7 @@ static blk_status_t sd_setup_rw6_cmnd(struct scsi_cmnd *cmd, bool write,
 
 static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 {
-	struct request *rq = cmd->request;
+	struct request *rq = blk_req(cmd);
 	struct scsi_device *sdp = cmd->device;
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	sector_t lba = sectors_to_logical(sdp, blk_rq_pos(rq));
@@ -1327,7 +1327,7 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 
 static blk_status_t sd_init_command(struct scsi_cmnd *cmd)
 {
-	struct request *rq = cmd->request;
+	struct request *rq = blk_req(cmd);
 
 	switch (req_op(rq)) {
 	case REQ_OP_DISCARD:
@@ -1373,7 +1373,7 @@ static blk_status_t sd_init_command(struct scsi_cmnd *cmd)
 
 static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 {
-	struct request *rq = SCpnt->request;
+	struct request *rq = blk_req(SCpnt);
 	u8 *cmnd;
 
 	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
@@ -1906,7 +1906,7 @@ static const struct block_device_operations sd_fops = {
  **/
 static void sd_eh_reset(struct scsi_cmnd *scmd)
 {
-	struct scsi_disk *sdkp = scsi_disk(scmd->request->rq_disk);
+	struct scsi_disk *sdkp = scsi_disk(blk_req(scmd)->rq_disk);
 
 	/* New SCSI EH run, reset gate variable */
 	sdkp->ignore_medium_access_errors = false;
@@ -1926,7 +1926,7 @@ static void sd_eh_reset(struct scsi_cmnd *scmd)
  **/
 static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
 {
-	struct scsi_disk *sdkp = scsi_disk(scmd->request->rq_disk);
+	struct scsi_disk *sdkp = scsi_disk(blk_req(scmd)->rq_disk);
 	struct scsi_device *sdev = scmd->device;
 
 	if (!scsi_device_online(sdev) ||
@@ -1967,7 +1967,7 @@ static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
 
 static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
 {
-	struct request *req = scmd->request;
+	struct request *req = blk_req(scmd);
 	struct scsi_device *sdev = scmd->device;
 	unsigned int transferred, good_bytes;
 	u64 start_lba, end_lba, bad_lba;
@@ -2022,8 +2022,8 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	unsigned int sector_size = SCpnt->device->sector_size;
 	unsigned int resid;
 	struct scsi_sense_hdr sshdr;
-	struct scsi_disk *sdkp = scsi_disk(SCpnt->request->rq_disk);
-	struct request *req = SCpnt->request;
+	struct scsi_disk *sdkp = scsi_disk(blk_req(SCpnt)->rq_disk);
+	struct request *req = blk_req(SCpnt);
 	int sense_valid = 0;
 	int sense_deferred = 0;
 
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index e45d8d94574c..0fc26fbc5a3c 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -244,7 +244,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 
 static blk_status_t sd_zbc_cmnd_checks(struct scsi_cmnd *cmd)
 {
-	struct request *rq = cmd->request;
+	struct request *rq = blk_req(cmd);
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	sector_t sector = blk_rq_pos(rq);
 
@@ -322,7 +322,7 @@ static void sd_zbc_update_wp_offset_workfn(struct work_struct *work)
 blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd, sector_t *lba,
 					unsigned int nr_blocks)
 {
-	struct request *rq = cmd->request;
+	struct request *rq = blk_req(cmd);
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	unsigned int wp_offset, zno = blk_rq_zone_no(rq);
 	unsigned long flags;
@@ -387,7 +387,7 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd, sector_t *lba,
 blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
 					 unsigned char op, bool all)
 {
-	struct request *rq = cmd->request;
+	struct request *rq = blk_req(cmd);
 	sector_t sector = blk_rq_pos(rq);
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	sector_t block = sectors_to_logical(sdkp->device, sector);
@@ -443,7 +443,7 @@ static unsigned int sd_zbc_zone_wp_update(struct scsi_cmnd *cmd,
 					  unsigned int good_bytes)
 {
 	int result = cmd->result;
-	struct request *rq = cmd->request;
+	struct request *rq = blk_req(cmd);
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	unsigned int zno = blk_rq_zone_no(rq);
 	enum req_opf op = req_op(rq);
@@ -517,7 +517,7 @@ unsigned int sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
 		     struct scsi_sense_hdr *sshdr)
 {
 	int result = cmd->result;
-	struct request *rq = cmd->request;
+	struct request *rq = blk_req(cmd);
 
 	if (op_is_zone_mgmt(req_op(rq)) &&
 	    result &&
