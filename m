Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA7A7C25B0E
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Aug 2022 17:26:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234196AbiHPR0s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Aug 2022 13:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbiHPR0r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2022 13:26:47 -0400
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC35565672
        for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2022 10:26:45 -0700 (PDT)
Received: by mail-pg1-f173.google.com with SMTP id d71so9802450pgc.13
        for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2022 10:26:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=ylXuMnw+vH/GzPh3PA7OhSDQO9GYjPfUVDxwmyjjY9A=;
        b=qfzFFlFhgs3GARRAeKYuvIRji8UAo3fGwNtdhgv9AB2JM8rZ/9ujhMFUucNImr89Kx
         8FFvx8YggJ9VRVkxb68lli4BdIFKGBrX35RRw/U2er8+Lo16w8EBpkRk0SfSDkpzpq53
         Vo6wQDuj3H5Viuoi/eVGYOsk/XCAZIRWc4kFvKwXH1Il9J06Pxq3LFwXeV0m2s6BBOQX
         uavNV3cqa/ILP4HbptLzMIS9FHkQST4s4X5kI2iCKSqMdERMkOqmEaMXn6WaXPmXVMU+
         CfencNUaFIRpPiCuXhY6pa2gEPhnf5W64HdOB73A48FgFZzXkk2ztbvFr6UZzB7QQt5y
         VoKQ==
X-Gm-Message-State: ACgBeo2cndRD93m/b727NH56Ent01RtU4pMQ7eMzVl07VssJCBlz5B4t
        zFD0RM8hIf+Wa+i4EApOIck=
X-Google-Smtp-Source: AA6agR48anUyeh65cBK+gP5lDGa6Nnh58a86shECkOuPE+05EmpY5pVsZA2Y1PYcUTZH4klktu8M2Q==
X-Received: by 2002:a05:6a00:32cb:b0:52e:2756:3558 with SMTP id cl11-20020a056a0032cb00b0052e27563558mr21887129pfb.59.1660670805158;
        Tue, 16 Aug 2022 10:26:45 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ff4b:545d:11c8:da9f])
        by smtp.gmail.com with ESMTPSA id d15-20020aa797af000000b0052e0fd762c5sm9053077pfq.14.2022.08.16.10.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 10:26:44 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>, gzhqyz@gmail.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH] scsi: sd: Revert "Rework asynchronous resume support"
Date:   Tue, 16 Aug 2022 10:26:38 -0700
Message-Id: <20220816172638.538734-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Although patch "Rework asynchronous resume support" eliminates the delay
for some ATA disks after resume, it causes resume of ATA disks to fail
on other setups. See also:
* "Resume process hangs for 5-6 seconds starting sometime in 5.16"
  (https://bugzilla.kernel.org/show_bug.cgi?id=215880).
* Geert's regression report
  (https://lore.kernel.org/linux-scsi/alpine.DEB.2.22.394.2207191125130.1006766@ramsan.of.borg/).

This is what I understand about this issue:
* During resume, ata_port_pm_resume() starts the SCSI error handler.
  This changes the SCSI host state into SHOST_RECOVERY and causes
  scsi_queue_rq() to return BLK_STS_RESOURCE.
* sd_resume() calls sd_start_stop_device() for ATA devices. That
  function in turn calls sd_submit_start() which tries to submit a START
  STOP UNIT command. That command can only be submitted after the SCSI
  error handler has changed the SCSI host state back to SHOST_RUNNING.
* The SCSI error handler runs on its own thread and calls
  schedule_work(&(ap->scsi_rescan_task)). That causes
  ata_scsi_dev_rescan() to be called from the context of a kernel
  workqueue. That call hangs in blk_mq_get_tag(). I'm not sure why -
  maybe because all available tags have been allocated by
  sd_submit_start() calls (this is a guess).

Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: gzhqyz@gmail.com
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reported-by: gzhqyz@gmail.com
Fixes: 88f1669019bd ("scsi: sd: Rework asynchronous resume support"; v6.0-rc1~114^2~68)
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 84 ++++++++++-------------------------------------
 drivers/scsi/sd.h |  5 ---
 2 files changed, 18 insertions(+), 71 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8f79fa6318fe..eb76ba055021 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -103,7 +103,6 @@ static void sd_config_discard(struct scsi_disk *, unsigned int);
 static void sd_config_write_same(struct scsi_disk *);
 static int  sd_revalidate_disk(struct gendisk *);
 static void sd_unlock_native_capacity(struct gendisk *disk);
-static void sd_start_done_work(struct work_struct *work);
 static int  sd_probe(struct device *);
 static int  sd_remove(struct device *);
 static void sd_shutdown(struct device *);
@@ -3471,7 +3470,6 @@ static int sd_probe(struct device *dev)
 	sdkp->max_retries = SD_MAX_RETRIES;
 	atomic_set(&sdkp->openers, 0);
 	atomic_set(&sdkp->device->ioerr_cnt, 0);
-	INIT_WORK(&sdkp->start_done_work, sd_start_done_work);
 
 	if (!sdp->request_queue->rq_timeout) {
 		if (sdp->type != TYPE_MOD)
@@ -3594,69 +3592,12 @@ static void scsi_disk_release(struct device *dev)
 	kfree(sdkp);
 }
 
-/* Process sense data after a START command finished. */
-static void sd_start_done_work(struct work_struct *work)
-{
-	struct scsi_disk *sdkp = container_of(work, typeof(*sdkp),
-					      start_done_work);
-	struct scsi_sense_hdr sshdr;
-	int res = sdkp->start_result;
-
-	if (res == 0)
-		return;
-
-	sd_print_result(sdkp, "Start/Stop Unit failed", res);
-
-	if (res < 0)
-		return;
-
-	if (scsi_normalize_sense(sdkp->start_sense_buffer,
-				 sdkp->start_sense_len, &sshdr))
-		sd_print_sense_hdr(sdkp, &sshdr);
-}
-
-/* A START command finished. May be called from interrupt context. */
-static void sd_start_done(struct request *req, blk_status_t status)
-{
-	const struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
-	struct scsi_disk *sdkp = scsi_disk(req->q->disk);
-
-	sdkp->start_result = scmd->result;
-	WARN_ON_ONCE(scmd->sense_len > SCSI_SENSE_BUFFERSIZE);
-	sdkp->start_sense_len = scmd->sense_len;
-	memcpy(sdkp->start_sense_buffer, scmd->sense_buffer,
-	       ARRAY_SIZE(sdkp->start_sense_buffer));
-	WARN_ON_ONCE(!schedule_work(&sdkp->start_done_work));
-}
-
-/* Submit a START command asynchronously. */
-static int sd_submit_start(struct scsi_disk *sdkp, u8 cmd[], u8 cmd_len)
-{
-	struct scsi_device *sdev = sdkp->device;
-	struct request_queue *q = sdev->request_queue;
-	struct request *req;
-	struct scsi_cmnd *scmd;
-
-	req = scsi_alloc_request(q, REQ_OP_DRV_IN, BLK_MQ_REQ_PM);
-	if (IS_ERR(req))
-		return PTR_ERR(req);
-
-	scmd = blk_mq_rq_to_pdu(req);
-	scmd->cmd_len = cmd_len;
-	memcpy(scmd->cmnd, cmd, cmd_len);
-	scmd->allowed = sdkp->max_retries;
-	req->timeout = SD_TIMEOUT;
-	req->rq_flags |= RQF_PM | RQF_QUIET;
-	req->end_io = sd_start_done;
-	blk_execute_rq_nowait(req, /*at_head=*/true);
-
-	return 0;
-}
-
 static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 {
 	unsigned char cmd[6] = { START_STOP };	/* START_VALID */
+	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdp = sdkp->device;
+	int res;
 
 	if (start)
 		cmd[4] |= 1;	/* START */
@@ -3667,10 +3608,23 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	/* Wait until processing of sense data has finished. */
-	flush_work(&sdkp->start_done_work);
+	res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
+			SD_TIMEOUT, sdkp->max_retries, 0, RQF_PM, NULL);
+	if (res) {
+		sd_print_result(sdkp, "Start/Stop Unit failed", res);
+		if (res > 0 && scsi_sense_valid(&sshdr)) {
+			sd_print_sense_hdr(sdkp, &sshdr);
+			/* 0x3a is medium not present */
+			if (sshdr.asc == 0x3a)
+				res = 0;
+		}
+	}
 
-	return sd_submit_start(sdkp, cmd, sizeof(cmd));
+	/* SCSI error codes must not go to the generic layer */
+	if (res)
+		return -EIO;
+
+	return 0;
 }
 
 /*
@@ -3697,8 +3651,6 @@ static void sd_shutdown(struct device *dev)
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		sd_start_stop_device(sdkp, 0);
 	}
-
-	flush_work(&sdkp->start_done_work);
 }
 
 static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index b89187761d61..5eea762f84d1 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -150,11 +150,6 @@ struct scsi_disk {
 	unsigned	urswrz : 1;
 	unsigned	security : 1;
 	unsigned	ignore_medium_access_errors : 1;
-
-	int		start_result;
-	u32		start_sense_len;
-	u8		start_sense_buffer[SCSI_SENSE_BUFFERSIZE];
-	struct work_struct start_done_work;
 };
 #define to_scsi_disk(obj) container_of(obj, struct scsi_disk, disk_dev)
 
