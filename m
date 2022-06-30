Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5907FC43334
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 19:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236755AbiF3T5Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jun 2022 15:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236807AbiF3T5V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2022 15:57:21 -0400
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D3E45071
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 12:57:20 -0700 (PDT)
Received: by mail-pf1-f180.google.com with SMTP id 65so394774pfw.11
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 12:57:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x+VedQD8FvUupAZy5QJcTnXgCO+K/j+5bjjX830t0Tc=;
        b=X2IRW4HAAYILAOkv7FhRjrf+wZQej/aUNOR3xDjQ//v5icK9uTmc1u3AwsGdo1XgGm
         SP+VSnI1m4cYWV8SdkT19KCPYAjh8cZ454hN91cdg8EGSbKqKnPkaHrmE82jbVlvgIBG
         /VVoF+c1AH3he2LZZmU0AGY45osWMmViqVbeK9j4Z2gbdPdyoWcopksS7nmE+ls9meFc
         5CrUYpg9aHlT3vNPJqCp9n2tUOMl2yr5eVJ6UJyvDuNlSytDmenMq2zDoFM3FRM4TQMp
         8GoVGZLCyMmKschMmPQWs7Z2IivEp0eTzwnaillBIkXMgBhfNcTtbauZWjxIM+19SkOW
         AWYw==
X-Gm-Message-State: AJIora/ACZsK4BtOci/KcXtvBF4045bNrr1Lg3kS22ciBjuE5SulO3op
        7h35LxfsdfhQuJJgoItbG8w=
X-Google-Smtp-Source: AGRyM1sJT0VP0TdpYgYKWbztC8ivVhrR0HMLswAQsm5h+g5nhEnZzqBNL9lMFyl2EsKhqaOV8dCQ9A==
X-Received: by 2002:a63:cb:0:b0:40c:a2b4:4890 with SMTP id 194-20020a6300cb000000b0040ca2b44890mr8847938pga.304.1656619039696;
        Thu, 30 Jun 2022 12:57:19 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id x1-20020a17090300c100b0016a33177d3csm13789452plc.160.2022.06.30.12.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 12:57:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>, ericspero@icloud.com,
        jason600.groome@gmail.com
Subject: [PATCH v2 2/2] scsi: sd: Rework asynchronous resume support
Date:   Thu, 30 Jun 2022 12:57:03 -0700
Message-Id: <20220630195703.10155-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630195703.10155-1-bvanassche@acm.org>
References: <20220630195703.10155-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For some technologies, e.g. an ATA bus, resuming can take multiple
seconds. Waiting for resume to finish can cause a very noticeable delay.
Hence this patch that restores the behavior from before patch "scsi:
core: pm: Rely on the device driver core for async power management" for
most SCSI devices.

This patch introduces a behavior change: if the START command fails, do
not consider this as a SCSI disk resume failure.

Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Cc: ericspero@icloud.com
Cc: jason600.groome@gmail.com
Tested-by: jason600.groome@gmail.com
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215880
Fixes: a19a93e4c6a9 ("scsi: core: pm: Rely on the device driver core for async power management")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 84 +++++++++++++++++++++++++++++++++++++----------
 drivers/scsi/sd.h |  5 +++
 2 files changed, 71 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 895b56c8f25e..84696b3652ee 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -103,6 +103,7 @@ static void sd_config_discard(struct scsi_disk *, unsigned int);
 static void sd_config_write_same(struct scsi_disk *);
 static int  sd_revalidate_disk(struct gendisk *);
 static void sd_unlock_native_capacity(struct gendisk *disk);
+static void sd_start_done_work(struct work_struct *work);
 static int  sd_probe(struct device *);
 static int  sd_remove(struct device *);
 static void sd_shutdown(struct device *);
@@ -3463,6 +3464,7 @@ static int sd_probe(struct device *dev)
 	sdkp->max_retries = SD_MAX_RETRIES;
 	atomic_set(&sdkp->openers, 0);
 	atomic_set(&sdkp->device->ioerr_cnt, 0);
+	INIT_WORK(&sdkp->start_done_work, sd_start_done_work);
 
 	if (!sdp->request_queue->rq_timeout) {
 		if (sdp->type != TYPE_MOD)
@@ -3585,12 +3587,69 @@ static void scsi_disk_release(struct device *dev)
 	kfree(sdkp);
 }
 
+/* Process sense data after a START command finished. */
+static void sd_start_done_work(struct work_struct *work)
+{
+	struct scsi_disk *sdkp = container_of(work, typeof(*sdkp),
+					      start_done_work);
+	struct scsi_sense_hdr sshdr;
+	int res = sdkp->start_result;
+
+	if (res == 0)
+		return;
+
+	sd_print_result(sdkp, "Start/Stop Unit failed", res);
+
+	if (res < 0)
+		return;
+
+	if (scsi_normalize_sense(sdkp->start_sense_buffer,
+				 sdkp->start_sense_len, &sshdr))
+		sd_print_sense_hdr(sdkp, &sshdr);
+}
+
+/* A START command finished. May be called from interrupt context. */
+static void sd_start_done(struct request *req, blk_status_t status)
+{
+	const struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+	struct scsi_disk *sdkp = scsi_disk(req->q->disk);
+
+	sdkp->start_result = scmd->result;
+	WARN_ON_ONCE(scmd->sense_len > SCSI_SENSE_BUFFERSIZE);
+	sdkp->start_sense_len = scmd->sense_len;
+	memcpy(sdkp->start_sense_buffer, scmd->sense_buffer,
+	       ARRAY_SIZE(sdkp->start_sense_buffer));
+	WARN_ON_ONCE(!schedule_work(&sdkp->start_done_work));
+}
+
+/* Submit a START command asynchronously. */
+static int sd_submit_start(struct scsi_disk *sdkp, u8 cmd[], u8 cmd_len)
+{
+	struct scsi_device *sdev = sdkp->device;
+	struct request_queue *q = sdev->request_queue;
+	struct request *req;
+	struct scsi_cmnd *scmd;
+
+	req = scsi_alloc_request(q, REQ_OP_DRV_IN, BLK_MQ_REQ_PM);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	scmd = blk_mq_rq_to_pdu(req);
+	scmd->cmd_len = cmd_len;
+	memcpy(scmd->cmnd, cmd, cmd_len);
+	scmd->allowed = sdkp->max_retries;
+	req->timeout = SD_TIMEOUT;
+	req->rq_flags |= RQF_PM | RQF_QUIET;
+	req->end_io = sd_start_done;
+	blk_execute_rq_nowait(req, /*at_head=*/true);
+
+	return 0;
+}
+
 static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 {
 	unsigned char cmd[6] = { START_STOP };	/* START_VALID */
-	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdp = sdkp->device;
-	int res;
 
 	if (start)
 		cmd[4] |= 1;	/* START */
@@ -3601,23 +3660,10 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			SD_TIMEOUT, sdkp->max_retries, 0, RQF_PM, NULL);
-	if (res) {
-		sd_print_result(sdkp, "Start/Stop Unit failed", res);
-		if (res > 0 && scsi_sense_valid(&sshdr)) {
-			sd_print_sense_hdr(sdkp, &sshdr);
-			/* 0x3a is medium not present */
-			if (sshdr.asc == 0x3a)
-				res = 0;
-		}
-	}
+	/* Wait until processing of sense data has finished. */
+	flush_work(&sdkp->start_done_work);
 
-	/* SCSI error codes must not go to the generic layer */
-	if (res)
-		return -EIO;
-
-	return 0;
+	return sd_submit_start(sdkp, cmd, sizeof(cmd));
 }
 
 /*
@@ -3644,6 +3690,8 @@ static void sd_shutdown(struct device *dev)
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		sd_start_stop_device(sdkp, 0);
 	}
+
+	flush_work(&sdkp->start_done_work);
 }
 
 static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 5eea762f84d1..b89187761d61 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -150,6 +150,11 @@ struct scsi_disk {
 	unsigned	urswrz : 1;
 	unsigned	security : 1;
 	unsigned	ignore_medium_access_errors : 1;
+
+	int		start_result;
+	u32		start_sense_len;
+	u8		start_sense_buffer[SCSI_SENSE_BUFFERSIZE];
+	struct work_struct start_done_work;
 };
 #define to_scsi_disk(obj) container_of(obj, struct scsi_disk, disk_dev)
 
