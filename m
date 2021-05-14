Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEC6AC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C07C3613C5
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbhENVf1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:35:27 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:43769 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbhENVfY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:35:24 -0400
Received: by mail-pl1-f174.google.com with SMTP id v12so91424plo.10
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:34:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e1DN+xXfpZr3JlML+Pyq4Pi3tSk9QmkyYcgqp3sJ1g8=;
        b=RRRAI2Nuuiug1oo/3radbvH50EKjnGX4m1aTNWi1QbQiu5vXy6Bt9ARDbibfEpCJyH
         XuDK/z2oEhMU0pllsAHvoariW6jzNxeBk43yi8C/KGUmcKySQBeV2ps2SbdHJT2jG+dV
         GHlkt7nlrvGHuVlTaVGVs1+b9Y/GAJ3Zrejz9R22rhJK0UoMe15YuUwZ2OKWQ+DENlnV
         BQVo4QlLFntcu4ZmpRDZpw21mkj74BMKdD8aKKzQ8U2UhEYcRK6bfdI1yxrFSglgoUvG
         DBNxqxuhUlePgehHszQWB3lLr6mLBgx4yMNmRVdWTCht4ODqvFmu1VPmwGoi7THmRnk8
         m7pg==
X-Gm-Message-State: AOAM531PWmX88j+TvXlFtDBGUXG0yjISqrjSM3Gdv6m3KTI6B4xU6D5F
        w6W0Wf1bPObwvtmF3usVTnA=
X-Google-Smtp-Source: ABdhPJwT2FTzP99WIsMfK6rmpxax1fFl/2FqjP82CuKyoI7GClfL6FAJ5RkijJysQSmKpTlbzaw15g==
X-Received: by 2002:a17:90a:474f:: with SMTP id y15mr11418989pjg.108.1621028051099;
        Fri, 14 May 2021 14:34:11 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:34:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 03/50] sd: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:18 -0700
Message-Id: <20210514213356.5264-4-bvanassche@acm.org>
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
