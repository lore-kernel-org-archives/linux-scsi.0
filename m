Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FE74C4320A
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:18:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3263D61078
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242702AbhHETTA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:00 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:35627 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbhHETS6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:18:58 -0400
Received: by mail-pj1-f44.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so17371415pjs.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:18:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sYyDzkQscy0lkr4Zi/O4lCsrEgwRq/OBtfUMxYFRILY=;
        b=oPX3wNueQU30qdsF1wZ2pkDb3WjCZPPh1Lb1cESBj3Hwixo9dHV1C/QFFJDTHdOER4
         nYVzKruNWcwdU+JJlS5kd3Jqamqhy0JgWMKjQVFyvB4+dT2digY7FkaxFvgcz2zHMx0+
         2HUtiwCoytdpSIgbRcUsMO4Ht3sJ5LjhSVIk+2Xbih2gH+l6Hu5+Esg6PkATDHEB9SVr
         FbWo5r/7aumtvbjB2QbAcru89jPjppsvxB5jnrO+IouxhAWGjZS+Cz0vsRrAkZorYSQl
         Ojs5wsmwSfGwU52XM83KZsbsQg7jrNZLQBX/FJ/ZlMOuPodrt/2l+5FZu/X1tCdVDNym
         j9ow==
X-Gm-Message-State: AOAM531Tjhk0Q6+4CoP56wHHDU9DNFFrcDgZDSn/iV4OQtWkVw20IMR7
        7MRuSODj4fA0ZF/bRikEVZw=
X-Google-Smtp-Source: ABdhPJw/fKL2hDulhbGYh9Wg4VFptzQQOMuF0hmhRcHKPGuZiYSoDpHFBRx4yuVr26hkyRis5FVmQQ==
X-Received: by 2002:a17:902:7595:b029:12c:2d46:348d with SMTP id j21-20020a1709027595b029012c2d46348dmr5173149pll.49.1628191123916;
        Thu, 05 Aug 2021 12:18:43 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.18.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:18:43 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 03/52] sd: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:17:39 -0700
Message-Id: <20210805191828.3559897-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c     | 33 +++++++++++++++++----------------
 drivers/scsi/sd_zbc.c | 10 +++++-----
 2 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c1b75f159e0c..ac431b0477da 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -776,8 +776,9 @@ static unsigned int sd_prot_flag_mask(unsigned int prot_op)
 static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
 					   unsigned int dix, unsigned int dif)
 {
-	struct bio *bio = scmd->request->bio;
-	unsigned int prot_op = sd_prot_op(rq_data_dir(scmd->request), dix, dif);
+	struct request *rq = scsi_cmd_to_rq(scmd);
+	struct bio *bio = rq->bio;
+	unsigned int prot_op = sd_prot_op(rq_data_dir(rq), dix, dif);
 	unsigned int protect = 0;
 
 	if (dix) {				/* DIX Type 0, 1, 2, 3 */
@@ -868,7 +869,7 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdp = cmd->device;
-	struct request *rq = cmd->request;
+	struct request *rq = scsi_cmd_to_rq(cmd);
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
@@ -904,7 +905,7 @@ static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
 		bool unmap)
 {
 	struct scsi_device *sdp = cmd->device;
-	struct request *rq = cmd->request;
+	struct request *rq = scsi_cmd_to_rq(cmd);
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
@@ -936,7 +937,7 @@ static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
 		bool unmap)
 {
 	struct scsi_device *sdp = cmd->device;
-	struct request *rq = cmd->request;
+	struct request *rq = scsi_cmd_to_rq(cmd);
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
@@ -966,7 +967,7 @@ static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
 
 static blk_status_t sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
 {
-	struct request *rq = cmd->request;
+	struct request *rq = scsi_cmd_to_rq(cmd);
 	struct scsi_device *sdp = cmd->device;
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
@@ -1063,7 +1064,7 @@ static void sd_config_write_same(struct scsi_disk *sdkp)
  **/
 static blk_status_t sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 {
-	struct request *rq = cmd->request;
+	struct request *rq = scsi_cmd_to_rq(cmd);
 	struct scsi_device *sdp = cmd->device;
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	struct bio *bio = rq->bio;
@@ -1112,7 +1113,7 @@ static blk_status_t sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 
 static blk_status_t sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
 {
-	struct request *rq = cmd->request;
+	struct request *rq = scsi_cmd_to_rq(cmd);
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 
 	/* flush requests don't perform I/O, zero the S/G table */
@@ -1210,7 +1211,7 @@ static blk_status_t sd_setup_rw6_cmnd(struct scsi_cmnd *cmd, bool write,
 
 static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 {
-	struct request *rq = cmd->request;
+	struct request *rq = scsi_cmd_to_rq(cmd);
 	struct scsi_device *sdp = cmd->device;
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	sector_t lba = sectors_to_logical(sdp, blk_rq_pos(rq));
@@ -1324,7 +1325,7 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 
 static blk_status_t sd_init_command(struct scsi_cmnd *cmd)
 {
-	struct request *rq = cmd->request;
+	struct request *rq = scsi_cmd_to_rq(cmd);
 
 	switch (req_op(rq)) {
 	case REQ_OP_DISCARD:
@@ -1370,7 +1371,7 @@ static blk_status_t sd_init_command(struct scsi_cmnd *cmd)
 
 static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 {
-	struct request *rq = SCpnt->request;
+	struct request *rq = scsi_cmd_to_rq(SCpnt);
 	u8 *cmnd;
 
 	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
@@ -1875,7 +1876,7 @@ static const struct block_device_operations sd_fops = {
  **/
 static void sd_eh_reset(struct scsi_cmnd *scmd)
 {
-	struct scsi_disk *sdkp = scsi_disk(scmd->request->rq_disk);
+	struct scsi_disk *sdkp = scsi_disk(scsi_cmd_to_rq(scmd)->rq_disk);
 
 	/* New SCSI EH run, reset gate variable */
 	sdkp->ignore_medium_access_errors = false;
@@ -1895,7 +1896,7 @@ static void sd_eh_reset(struct scsi_cmnd *scmd)
  **/
 static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
 {
-	struct scsi_disk *sdkp = scsi_disk(scmd->request->rq_disk);
+	struct scsi_disk *sdkp = scsi_disk(scsi_cmd_to_rq(scmd)->rq_disk);
 	struct scsi_device *sdev = scmd->device;
 
 	if (!scsi_device_online(sdev) ||
@@ -1936,7 +1937,7 @@ static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
 
 static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
 {
-	struct request *req = scmd->request;
+	struct request *req = scsi_cmd_to_rq(scmd);
 	struct scsi_device *sdev = scmd->device;
 	unsigned int transferred, good_bytes;
 	u64 start_lba, end_lba, bad_lba;
@@ -1991,8 +1992,8 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	unsigned int sector_size = SCpnt->device->sector_size;
 	unsigned int resid;
 	struct scsi_sense_hdr sshdr;
-	struct scsi_disk *sdkp = scsi_disk(SCpnt->request->rq_disk);
-	struct request *req = SCpnt->request;
+	struct request *req = scsi_cmd_to_rq(SCpnt);
+	struct scsi_disk *sdkp = scsi_disk(req->rq_disk);
 	int sense_valid = 0;
 	int sense_deferred = 0;
 
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 186b5ff52c3a..b9757f24b0d6 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -243,7 +243,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 
 static blk_status_t sd_zbc_cmnd_checks(struct scsi_cmnd *cmd)
 {
-	struct request *rq = cmd->request;
+	struct request *rq = scsi_cmd_to_rq(cmd);
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	sector_t sector = blk_rq_pos(rq);
 
@@ -321,7 +321,7 @@ static void sd_zbc_update_wp_offset_workfn(struct work_struct *work)
 blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd, sector_t *lba,
 					unsigned int nr_blocks)
 {
-	struct request *rq = cmd->request;
+	struct request *rq = scsi_cmd_to_rq(cmd);
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	unsigned int wp_offset, zno = blk_rq_zone_no(rq);
 	unsigned long flags;
@@ -386,7 +386,7 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd, sector_t *lba,
 blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
 					 unsigned char op, bool all)
 {
-	struct request *rq = cmd->request;
+	struct request *rq = scsi_cmd_to_rq(cmd);
 	sector_t sector = blk_rq_pos(rq);
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	sector_t block = sectors_to_logical(sdkp->device, sector);
@@ -442,7 +442,7 @@ static unsigned int sd_zbc_zone_wp_update(struct scsi_cmnd *cmd,
 					  unsigned int good_bytes)
 {
 	int result = cmd->result;
-	struct request *rq = cmd->request;
+	struct request *rq = scsi_cmd_to_rq(cmd);
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	unsigned int zno = blk_rq_zone_no(rq);
 	enum req_opf op = req_op(rq);
@@ -516,7 +516,7 @@ unsigned int sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
 		     struct scsi_sense_hdr *sshdr)
 {
 	int result = cmd->result;
-	struct request *rq = cmd->request;
+	struct request *rq = scsi_cmd_to_rq(cmd);
 
 	if (op_is_zone_mgmt(req_op(rq)) &&
 	    result &&
