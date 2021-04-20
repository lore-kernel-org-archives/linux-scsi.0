Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C0DC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F53961363
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbhDTAJs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:09:48 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:53866 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232912AbhDTAJk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:40 -0400
Received: by mail-pj1-f54.google.com with SMTP id nk8so5702844pjb.3
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IjD2HvDdVBMANt+Z2pBSPnhdQVFrSYM3KI2m6kX0dI8=;
        b=iUMlgOgEzbOG4Ir+wMhq1PdcQltm1AtIzqlZlUgF6bg2GSaDIscUtEeGh0DfLX985P
         HwuzITfnFGQm2B+p4QRXp8nwiWIh+DcSyYUb2S3nQa0Ml2glJr1+aXNvLKwI2K/YVvws
         +tvRKK3U04xo/1ly3x5a4vtBzekjM28ARrK8f4Z6Bwswq3YJFKOjdTuXhkd523fRG28l
         I+1Oa17X20FDP/2IEtJXhPdTFY4iP4eb6IYGI6rL3DElPKtQtUraHPGTpuAVy4kiRhk7
         RwhknVwqkEXW/JjhNGgPD1gxzh5ZpLGEtETB7zHqjTOhJabnFRvr3Ve9IIARVeSsq9p6
         yPEg==
X-Gm-Message-State: AOAM532A170e0/a1VSFkCpN7lFbwcy+h6TuQrf9dfT1VyWxQbZOhgdal
        BzmZ7G1/1toiignYp1EpRV0=
X-Google-Smtp-Source: ABdhPJwd9L4SH8O5m31hB67o5ZdYOJk3TDO3rfqGlX3WjYCHQIW4zmKnfUu4aHnW+LHv+hmlrD4RHA==
X-Received: by 2002:a17:90b:19ca:: with SMTP id nm10mr1801986pjb.175.1618877349715;
        Mon, 19 Apr 2021 17:09:09 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:09 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 015/117] sd: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:03 -0700
Message-Id: <20210420000845.25873-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c     | 103 ++++++++++++++++++++++--------------------
 drivers/scsi/sd.h     |   3 +-
 drivers/scsi/sd_zbc.c |  14 +++---
 3 files changed, 64 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cb3c37d1e009..8df2f25e4129 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1622,7 +1622,7 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 {
 	struct scsi_disk *sdkp = scsi_disk_get(disk);
 	struct scsi_device *sdp;
-	int retval;
+	union scsi_status retval;
 	bool disk_changed;
 
 	if (!sdkp)
@@ -1654,7 +1654,8 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 	if (scsi_block_when_processing_errors(sdp)) {
 		struct scsi_sense_hdr sshdr = { 0, };
 
-		retval = scsi_test_unit_ready(sdp, SD_TIMEOUT, sdkp->max_retries,
+		retval.combined =
+			scsi_test_unit_ready(sdp, SD_TIMEOUT, sdkp->max_retries,
 					      &sshdr);
 
 		/* failed to execute TUR, assume media not present */
@@ -1689,7 +1690,8 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 
 static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 {
-	int retries, res;
+	int retries;
+	union scsi_status res;
 	struct scsi_device *sdp = sdkp->device;
 	const int timeout = sdp->request_queue->rq_timeout
 		* SD_FLUSH_TIMEOUT_MULTIPLIER;
@@ -1710,13 +1712,13 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 		 * Leave the rest of the command zero to indicate
 		 * flush everything.
 		 */
-		res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, sshdr,
+		res.combined = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, sshdr,
 				timeout, sdkp->max_retries, 0, RQF_PM, NULL);
-		if (res == 0)
+		if (res.combined == 0)
 			break;
 	}
 
-	if (res) {
+	if (res.combined) {
 		sd_print_result(sdkp, "Synchronize Cache(10) failed", res);
 
 		if (driver_byte(res) == DRIVER_SENSE)
@@ -1809,7 +1811,7 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdev = sdkp->device;
 	struct scsi_sense_hdr sshdr;
-	int result;
+	union scsi_status result;
 	u8 cmd[16] = { 0, };
 	u8 data[24] = { 0, };
 
@@ -1822,16 +1824,18 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	put_unaligned_be64(sa_key, &data[8]);
 	data[20] = flags;
 
-	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, &data, sizeof(data),
+	result.combined =
+		scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, &data, sizeof(data),
 			&sshdr, SD_TIMEOUT, sdkp->max_retries, NULL);
 
 	if (driver_byte(result) == DRIVER_SENSE &&
 	    scsi_sense_valid(&sshdr)) {
-		sdev_printk(KERN_INFO, sdev, "PR command failed: %d\n", result);
+		sdev_printk(KERN_INFO, sdev, "PR command failed: %d\n",
+			    result.combined);
 		scsi_print_sense_hdr(sdev, NULL, &sshdr);
 	}
 
-	return result;
+	return result.combined;
 }
 
 static int sd_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
@@ -1931,7 +1935,7 @@ static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
 
 	if (!scsi_device_online(sdev) ||
 	    !scsi_medium_access_command(scmd) ||
-	    host_byte(scmd->result) != DID_TIME_OUT ||
+	    host_byte(scmd->status) != DID_TIME_OUT ||
 	    eh_disp != SUCCESS)
 		return eh_disp;
 
@@ -2017,8 +2021,8 @@ static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
  **/
 static int sd_done(struct scsi_cmnd *SCpnt)
 {
-	int result = SCpnt->result;
-	unsigned int good_bytes = result ? 0 : scsi_bufflen(SCpnt);
+	union scsi_status result = SCpnt->status;
+	unsigned int good_bytes = result.combined ? 0 : scsi_bufflen(SCpnt);
 	unsigned int sector_size = SCpnt->device->sector_size;
 	unsigned int resid;
 	struct scsi_sense_hdr sshdr;
@@ -2036,7 +2040,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	case REQ_OP_ZONE_OPEN:
 	case REQ_OP_ZONE_CLOSE:
 	case REQ_OP_ZONE_FINISH:
-		if (!result) {
+		if (!result.combined) {
 			good_bytes = blk_rq_bytes(req);
 			scsi_set_resid(SCpnt, 0);
 		} else {
@@ -2062,7 +2066,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 		}
 	}
 
-	if (result) {
+	if (result.combined) {
 		sense_valid = scsi_command_normalize_sense(SCpnt, &sshdr);
 		if (sense_valid)
 			sense_deferred = scsi_sense_is_deferred(&sshdr);
@@ -2086,7 +2090,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 		 * unknown amount of data was transferred so treat it as an
 		 * error.
 		 */
-		SCpnt->result = 0;
+		SCpnt->status.combined = 0;
 		memset(SCpnt->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 		break;
 	case ABORTED_COMMAND:
@@ -2141,7 +2145,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 	unsigned char cmd[10];
 	unsigned long spintime_expire = 0;
 	int retries, spintime;
-	unsigned int the_result;
+	union scsi_status the_result;
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 
@@ -2156,7 +2160,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			cmd[0] = TEST_UNIT_READY;
 			memset((void *) &cmd[1], 0, 9);
 
-			the_result = scsi_execute_req(sdkp->device, cmd,
+			the_result.combined = scsi_execute_req(sdkp->device, cmd,
 						      DMA_NONE, NULL, 0,
 						      &sshdr, SD_TIMEOUT,
 						      sdkp->max_retries, NULL);
@@ -2169,7 +2173,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			if (media_not_present(sdkp, &sshdr))
 				return;
 
-			if (the_result)
+			if (the_result.combined)
 				sense_valid = scsi_sense_valid(&sshdr);
 			retries++;
 		} while (retries < 3 && 
@@ -2303,7 +2307,7 @@ static int sd_read_protection_type(struct scsi_disk *sdkp, unsigned char *buffer
 
 static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 			struct scsi_sense_hdr *sshdr, int sense_valid,
-			int the_result)
+			union scsi_status the_result)
 {
 	if (driver_byte(the_result) == DRIVER_SENSE)
 		sd_print_sense_hdr(sdkp, sshdr);
@@ -2339,7 +2343,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	unsigned char cmd[16];
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
-	int the_result;
+	union scsi_status the_result;
 	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	unsigned int alignment;
 	unsigned long long lba;
@@ -2355,14 +2359,14 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		cmd[13] = RC16_LEN;
 		memset(buffer, 0, RC16_LEN);
 
-		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
+		the_result.combined = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
 					buffer, RC16_LEN, &sshdr,
 					SD_TIMEOUT, sdkp->max_retries, NULL);
 
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
 
-		if (the_result) {
+		if (the_result.combined) {
 			sense_valid = scsi_sense_valid(&sshdr);
 			if (sense_valid &&
 			    sshdr.sense_key == ILLEGAL_REQUEST &&
@@ -2382,9 +2386,9 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		}
 		retries--;
 
-	} while (the_result && retries);
+	} while (the_result.combined && retries);
 
-	if (the_result) {
+	if (the_result.combined) {
 		sd_print_result(sdkp, "Read Capacity(16) failed", the_result);
 		read_capacity_error(sdkp, sdp, &sshdr, sense_valid, the_result);
 		return -EINVAL;
@@ -2430,7 +2434,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	unsigned char cmd[16];
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
-	int the_result;
+	union scsi_status the_result;
 	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	sector_t lba;
 	unsigned sector_size;
@@ -2440,14 +2444,14 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		memset(&cmd[1], 0, 9);
 		memset(buffer, 0, 8);
 
-		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
+		the_result.combined = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
 					buffer, 8, &sshdr,
 					SD_TIMEOUT, sdkp->max_retries, NULL);
 
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
 
-		if (the_result) {
+		if (the_result.combined) {
 			sense_valid = scsi_sense_valid(&sshdr);
 			if (sense_valid &&
 			    sshdr.sense_key == UNIT_ATTENTION &&
@@ -2459,9 +2463,9 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		}
 		retries--;
 
-	} while (the_result && retries);
+	} while (the_result.combined && retries);
 
-	if (the_result) {
+	if (the_result.combined) {
 		sd_print_result(sdkp, "Read Capacity(10) failed", the_result);
 		read_capacity_error(sdkp, sdp, &sshdr, sense_valid, the_result);
 		return -EINVAL;
@@ -2643,7 +2647,7 @@ sd_do_mode_sense(struct scsi_disk *sdkp, int dbd, int modepage,
 static void
 sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 {
-	int res;
+	union scsi_status res;
 	struct scsi_device *sdp = sdkp->device;
 	struct scsi_mode_data data;
 	int old_wp = sdkp->write_prot;
@@ -2655,14 +2659,14 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 	}
 
 	if (sdp->use_192_bytes_for_3f) {
-		res = sd_do_mode_sense(sdkp, 0, 0x3F, buffer, 192, &data, NULL);
+		res.combined = sd_do_mode_sense(sdkp, 0, 0x3F, buffer, 192, &data, NULL);
 	} else {
 		/*
 		 * First attempt: ask for all pages (0x3F), but only 4 bytes.
 		 * We have to start carefully: some devices hang if we ask
 		 * for more than is available.
 		 */
-		res = sd_do_mode_sense(sdkp, 0, 0x3F, buffer, 4, &data, NULL);
+		res.combined = sd_do_mode_sense(sdkp, 0, 0x3F, buffer, 4, &data, NULL);
 
 		/*
 		 * Second attempt: ask for page 0 When only page 0 is
@@ -2671,13 +2675,13 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 		 * CDB.
 		 */
 		if (!scsi_status_is_good(res))
-			res = sd_do_mode_sense(sdkp, 0, 0, buffer, 4, &data, NULL);
+			res.combined = sd_do_mode_sense(sdkp, 0, 0, buffer, 4, &data, NULL);
 
 		/*
 		 * Third attempt: ask 255 bytes, as we did earlier.
 		 */
 		if (!scsi_status_is_good(res))
-			res = sd_do_mode_sense(sdkp, 0, 0x3F, buffer, 255,
+			res.combined = sd_do_mode_sense(sdkp, 0, 0x3F, buffer, 255,
 					       &data, NULL);
 	}
 
@@ -2702,7 +2706,8 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 static void
 sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 {
-	int len = 0, res;
+	int len = 0;
+	union scsi_status res;
 	struct scsi_device *sdp = sdkp->device;
 
 	int dbd;
@@ -2739,7 +2744,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 	}
 
 	/* cautiously ask */
-	res = sd_do_mode_sense(sdkp, dbd, modepage, buffer, first_len,
+	res.combined = sd_do_mode_sense(sdkp, dbd, modepage, buffer, first_len,
 			&data, &sshdr);
 
 	if (!scsi_status_is_good(res))
@@ -2771,7 +2776,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 
 	/* Get the data */
 	if (len > first_len)
-		res = sd_do_mode_sense(sdkp, dbd, modepage, buffer, len,
+		res.combined = sd_do_mode_sense(sdkp, dbd, modepage, buffer, len,
 				&data, &sshdr);
 
 	if (scsi_status_is_good(res)) {
@@ -2878,7 +2883,8 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
  */
 static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 {
-	int res, offset;
+	union scsi_status res;
+	int offset;
 	struct scsi_device *sdp = sdkp->device;
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
@@ -2889,7 +2895,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 	if (sdkp->protection_type == 0)
 		return;
 
-	res = scsi_mode_sense(sdp, 1, 0x0a, buffer, 36, SD_TIMEOUT,
+	res.combined = scsi_mode_sense(sdp, 1, 0x0a, buffer, 36, SD_TIMEOUT,
 			      sdkp->max_retries, &data, &sshdr);
 
 	if (!scsi_status_is_good(res) || !data.header_length ||
@@ -3576,7 +3582,7 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 	unsigned char cmd[6] = { START_STOP };	/* START_VALID */
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdp = sdkp->device;
-	int res;
+	union scsi_status res;
 
 	if (start)
 		cmd[4] |= 1;	/* START */
@@ -3587,20 +3593,20 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
+	res.combined = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
 			SD_TIMEOUT, sdkp->max_retries, 0, RQF_PM, NULL);
-	if (res) {
+	if (res.combined) {
 		sd_print_result(sdkp, "Start/Stop Unit failed", res);
 		if (driver_byte(res) == DRIVER_SENSE)
 			sd_print_sense_hdr(sdkp, &sshdr);
 		if (scsi_sense_valid(&sshdr) &&
 			/* 0x3a is medium not present */
 			sshdr.asc == 0x3a)
-			res = 0;
+			res.combined = 0;
 	}
 
 	/* SCSI error codes must not go to the generic layer */
-	if (res)
+	if (res.combined)
 		return -EIO;
 
 	return 0;
@@ -3803,10 +3809,11 @@ void sd_print_sense_hdr(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 			     sdkp->disk ? sdkp->disk->disk_name : NULL, sshdr);
 }
 
-void sd_print_result(const struct scsi_disk *sdkp, const char *msg, int result)
+void sd_print_result(const struct scsi_disk *sdkp, const char *msg,
+		     union scsi_status result)
 {
-	const char *hb_string = scsi_hostbyte_string(result);
-	const char *db_string = scsi_driverbyte_string(result);
+	const char *hb_string = scsi_hostbyte_string(result.combined);
+	const char *db_string = scsi_driverbyte_string(result.combined);
 
 	if (hb_string || db_string)
 		sd_printk(KERN_INFO, sdkp,
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index e75dd3e85dc3..c699ff1117ba 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -237,6 +237,7 @@ static inline blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd,
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 void sd_print_sense_hdr(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr);
-void sd_print_result(const struct scsi_disk *sdkp, const char *msg, int result);
+void sd_print_result(const struct scsi_disk *sdkp, const char *msg,
+		     union scsi_status result);
 
 #endif /* _SCSI_DISK_H */
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index e45d8d94574c..dc63bce96ec5 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -99,7 +99,7 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	struct scsi_sense_hdr sshdr;
 	unsigned char cmd[16];
 	unsigned int rep_len;
-	int result;
+	union scsi_status result;
 
 	memset(cmd, 0, 16);
 	cmd[0] = ZBC_IN;
@@ -109,10 +109,10 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	if (partial)
 		cmd[14] = ZBC_REPORT_ZONE_PARTIAL;
 
-	result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
+	result.combined = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
 				  buf, buflen, &sshdr,
 				  timeout, SD_MAX_RETRIES, NULL);
-	if (result) {
+	if (result.combined) {
 		sd_printk(KERN_ERR, sdkp,
 			  "REPORT ZONES start lba %llu failed\n", lba);
 		sd_print_result(sdkp, "REPORT ZONES", result);
@@ -442,7 +442,7 @@ static bool sd_zbc_need_zone_wp_update(struct request *rq)
 static unsigned int sd_zbc_zone_wp_update(struct scsi_cmnd *cmd,
 					  unsigned int good_bytes)
 {
-	int result = cmd->result;
+	const union scsi_status result = cmd->status;
 	struct request *rq = cmd->request;
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	unsigned int zno = blk_rq_zone_no(rq);
@@ -457,7 +457,7 @@ static unsigned int sd_zbc_zone_wp_update(struct scsi_cmnd *cmd,
 	 */
 	spin_lock_irqsave(&sdkp->zones_wp_offset_lock, flags);
 
-	if (result && op != REQ_OP_ZONE_RESET_ALL) {
+	if (result.combined && op != REQ_OP_ZONE_RESET_ALL) {
 		if (op == REQ_OP_ZONE_APPEND) {
 			/* Force complete completion (no retry) */
 			good_bytes = 0;
@@ -516,11 +516,11 @@ static unsigned int sd_zbc_zone_wp_update(struct scsi_cmnd *cmd,
 unsigned int sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
 		     struct scsi_sense_hdr *sshdr)
 {
-	int result = cmd->result;
+	const union scsi_status result = cmd->status;
 	struct request *rq = cmd->request;
 
 	if (op_is_zone_mgmt(req_op(rq)) &&
-	    result &&
+	    result.combined &&
 	    sshdr->sense_key == ILLEGAL_REQUEST &&
 	    sshdr->asc == 0x24) {
 		/*
