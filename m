Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EF67C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2008D61107
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbhDTCPJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:15:09 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:41512 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233742AbhDTCPH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:15:07 -0400
Received: by mail-pf1-f181.google.com with SMTP id w6so9947408pfc.8
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 19:14:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bwHCFpLsVX8rqHH5vL11TcWELe35KuYUJmSlE/XLmrE=;
        b=IpWqOFPRKg0XPytaWIDvliXnxbWk/i8A1Sj/HCn5ybSM13YUY+DpazbtUn0e4ow6QY
         /SXt2aVCii+3mh8BGCaq9PJfPwg48R13v7111+V7tEfihRVmz0cO0J6XA6ct3sUBjbn6
         82rMxIqlhlonb35Z0PDoOrMmq/BZhPMsr1EqWg23uSwWdLzChu4rKT3rRPfU+B4fMepP
         UfwJ0XymGjhh+rvFnXHGR/7Gc1bb+KSExOKAD7wpzhFjf7viXVPKNiAlOFo4aqPmu+Hi
         UKpaxPC1OXK0idVjKYGTWu1t/KbXWtcj7i1PmFQjrBSx1RfoQS3ppnqN4nLFS+xjKaM5
         dy2w==
X-Gm-Message-State: AOAM531BIPHh2Gg06qjE0sJ35oG2dmT+ytfny9zWeEyXvw/NTzu7hPZW
        Q7WLUrHbW8pZbjWUgIc1uiY=
X-Google-Smtp-Source: ABdhPJzJ9Ktv1v2OaBYM/Tylnj+lSn2Nidts3P4EjNHqXT37pwO1lRe3NCuyr2szkaoh8jtAhHCNtQ==
X-Received: by 2002:a63:db47:: with SMTP id x7mr5468251pgi.360.1618884876359;
        Mon, 19 Apr 2021 19:14:36 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id mq2sm630984pjb.24.2021.04.19.19.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:14:35 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 113/117] Change the return type of scsi_execute_req() into union scsi_status
Date:   Mon, 19 Apr 2021 19:13:58 -0700
Message-Id: <20210420021402.27678-23-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that scsi_execute_req() returns a SCSI status.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/hwmon/drivetemp.c          |  2 +-
 drivers/scsi/ch.c                  |  2 +-
 drivers/scsi/scsi.c                |  8 ++++----
 drivers/scsi/scsi_ioctl.c          |  2 +-
 drivers/scsi/scsi_lib.c            |  8 ++++----
 drivers/scsi/scsi_scan.c           | 13 ++++++-------
 drivers/scsi/sd.c                  |  9 ++++-----
 drivers/scsi/sd_zbc.c              |  2 +-
 drivers/scsi/ses.c                 |  4 ++--
 drivers/scsi/sr.c                  |  6 +++---
 drivers/scsi/virtio_scsi.c         |  4 ++--
 drivers/target/target_core_pscsi.c |  6 +++---
 include/scsi/scsi_device.h         |  4 ++--
 13 files changed, 34 insertions(+), 36 deletions(-)

diff --git a/drivers/hwmon/drivetemp.c b/drivers/hwmon/drivetemp.c
index 1eb37106a220..a1affc2b5e0a 100644
--- a/drivers/hwmon/drivetemp.c
+++ b/drivers/hwmon/drivetemp.c
@@ -194,7 +194,7 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
 
 	return scsi_execute_req(st->sdev, scsi_cmd, data_dir,
 				st->smartdata, ATA_SECT_SIZE, NULL, HZ, 5,
-				NULL);
+				NULL).combined;
 }
 
 static int drivetemp_ata_command(struct drivetemp_data *st, u8 feature,
diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 663af5ed20de..0944ceefa287 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -196,7 +196,7 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 
  retry:
 	errno = 0;
-	result.combined = scsi_execute_req(ch->device, cmd, direction, buffer,
+	result = scsi_execute_req(ch->device, cmd, direction, buffer,
 				  buflength, &sshdr, timeout * HZ,
 				  MAX_RETRIES, NULL);
 
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index c6f3bbec8982..92f16d937882 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -308,7 +308,7 @@ EXPORT_SYMBOL(scsi_track_queue_full);
 static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
 							u8 page, unsigned len)
 {
-	int result;
+	union scsi_status result;
 	unsigned char cmd[16];
 
 	if (len < 4)
@@ -327,7 +327,7 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
 	 */
 	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
 				  len, NULL, 30 * HZ, 3, NULL);
-	if (result)
+	if (result.combined)
 		return -EIO;
 
 	/* Sanity check that we got the page back that we asked for */
@@ -492,7 +492,7 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 {
 	unsigned char cmd[16];
 	struct scsi_sense_hdr sshdr;
-	int result;
+	union scsi_status result;
 
 	if (sdev->no_report_opcodes || sdev->scsi_level < SCSI_SPC_3)
 		return -EINVAL;
@@ -508,7 +508,7 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer, len,
 				  &sshdr, 30 * HZ, 3, NULL);
 
-	if (result && scsi_sense_valid(&sshdr) &&
+	if (result.combined && scsi_sense_valid(&sshdr) &&
 	    sshdr.sense_key == ILLEGAL_REQUEST &&
 	    (sshdr.asc == 0x20 || sshdr.asc == 0x24) && sshdr.ascq == 0x00)
 		return -EINVAL;
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index fee0e72917b3..b9e2f5b03c83 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -95,7 +95,7 @@ static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 	SCSI_LOG_IOCTL(1, sdev_printk(KERN_INFO, sdev,
 				      "Trying ioctl with scsi command %d\n", *cmd));
 
-	result.combined = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0,
+	result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0,
 				  &sshdr, timeout, retries, NULL);
 
 	SCSI_LOG_IOCTL(2, sdev_printk(KERN_INFO, sdev,
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 485cb002cbc9..23750d167c47 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2121,7 +2121,7 @@ scsi_mode_select(struct scsi_device *sdev, int pf, int sp, int modepage,
 	}
 
 	ret = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, real_buffer, len,
-			       sshdr, timeout, retries, NULL);
+			       sshdr, timeout, retries, NULL).combined;
 	kfree(real_buffer);
 	return ret;
 }
@@ -2188,7 +2188,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 
 	memset(buffer, 0, len);
 
-	result.combined = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
+	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
 					   len, sshdr, timeout, retries, NULL);
 
 	/* This code looks awful: what it's doing is making sure an
@@ -2262,7 +2262,7 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 	char cmd[] = {
 		TEST_UNIT_READY, 0, 0, 0, 0, 0,
 	};
-	int result;
+	union scsi_status result;
 
 	/* try to eat the UNIT_ATTENTION if there are enough retries */
 	do {
@@ -2274,7 +2274,7 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 	} while (scsi_sense_valid(sshdr) &&
 		 sshdr->sense_key == UNIT_ATTENTION && --retries);
 
-	return result;
+	return result.combined;
 }
 EXPORT_SYMBOL(scsi_test_unit_ready);
 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 43346f7dedd1..26c5066ecac5 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -608,8 +608,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
 		memset(inq_result, 0, try_inquiry_len);
 
-		result.combined =
-			scsi_execute_req(sdev,  scsi_cmd, DMA_FROM_DEVICE,
+		result = scsi_execute_req(sdev,  scsi_cmd, DMA_FROM_DEVICE,
 					  inq_result, try_inquiry_len, &sshdr,
 					  HZ / 2 + HZ * scsi_inq_timeout, 3,
 					  &resid);
@@ -1315,7 +1314,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	u64 lun;
 	unsigned int num_luns;
 	unsigned int retries;
-	int result;
+	union scsi_status result;
 	struct scsi_lun *lunp, *lun_data;
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev;
@@ -1402,9 +1401,9 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
 				"scsi scan: REPORT LUNS"
 				" %s (try %d) result 0x%x\n",
-				result ?  "failed" : "successful",
-				retries, result));
-		if (result == 0)
+				result.combined ?  "failed" : "successful",
+				retries, result.combined));
+		if (result.combined == 0)
 			break;
 		else if (scsi_sense_valid(&sshdr)) {
 			if (sshdr.sense_key != UNIT_ATTENTION)
@@ -1412,7 +1411,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 		}
 	}
 
-	if (result) {
+	if (result.combined) {
 		/*
 		 * The device probably does not support a REPORT LUN command
 		 */
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 263a0e253f60..1df895e0e619 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1824,8 +1824,7 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	put_unaligned_be64(sa_key, &data[8]);
 	data[20] = flags;
 
-	result.combined =
-		scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, &data, sizeof(data),
+	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, &data, sizeof(data),
 			&sshdr, SD_TIMEOUT, sdkp->max_retries, NULL);
 
 	if (driver_byte(result) == DRIVER_SENSE &&
@@ -2160,7 +2159,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			cmd[0] = TEST_UNIT_READY;
 			memset((void *) &cmd[1], 0, 9);
 
-			the_result.combined = scsi_execute_req(sdkp->device, cmd,
+			the_result = scsi_execute_req(sdkp->device, cmd,
 						      DMA_NONE, NULL, 0,
 						      &sshdr, SD_TIMEOUT,
 						      sdkp->max_retries, NULL);
@@ -2359,7 +2358,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		cmd[13] = RC16_LEN;
 		memset(buffer, 0, RC16_LEN);
 
-		the_result.combined = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
+		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
 					buffer, RC16_LEN, &sshdr,
 					SD_TIMEOUT, sdkp->max_retries, NULL);
 
@@ -2444,7 +2443,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		memset(&cmd[1], 0, 9);
 		memset(buffer, 0, 8);
 
-		the_result.combined = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
+		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
 					buffer, 8, &sshdr,
 					SD_TIMEOUT, sdkp->max_retries, NULL);
 
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index dc63bce96ec5..8a9fe228aea9 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -109,7 +109,7 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	if (partial)
 		cmd[14] = ZBC_REPORT_ZONE_PARTIAL;
 
-	result.combined = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
+	result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
 				  buf, buflen, &sshdr,
 				  timeout, SD_MAX_RETRIES, NULL);
 	if (result.combined) {
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index c2afba2a5414..69a0507b1f0a 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -89,7 +89,7 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 	unsigned char recv_page_code;
 
 	ret =  scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
-				NULL, SES_TIMEOUT, SES_RETRIES, NULL);
+				NULL, SES_TIMEOUT, SES_RETRIES, NULL).combined;
 	if (unlikely(ret))
 		return ret;
 
@@ -123,7 +123,7 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 	};
 
 	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, buf, bufflen,
-				  NULL, SES_TIMEOUT, SES_RETRIES, NULL);
+				NULL, SES_TIMEOUT, SES_RETRIES, NULL).combined;
 	if (result)
 		sdev_printk(KERN_ERR, sdev, "SEND DIAGNOSTIC result: %8x\n",
 			    result);
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index a78e499d4836..d745ff8a30e8 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -206,7 +206,7 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 	int result;
 
 	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, sizeof(buf),
-				  &sshdr, SR_TIMEOUT, MAX_RETRIES, NULL);
+				&sshdr, SR_TIMEOUT, MAX_RETRIES, NULL).combined;
 	if (scsi_sense_valid(&sshdr) && sshdr.sense_key == UNIT_ATTENTION)
 		return DISK_EVENT_MEDIA_CHANGE;
 
@@ -813,8 +813,8 @@ static void get_sectorsize(struct scsi_cd *cd)
 
 		/* Do the command and wait.. */
 		the_result = scsi_execute_req(cd->device, cmd, DMA_FROM_DEVICE,
-					      buffer, sizeof(buffer), NULL,
-					      SR_TIMEOUT, MAX_RETRIES, NULL);
+					buffer, sizeof(buffer), NULL,
+					SR_TIMEOUT, MAX_RETRIES, NULL).combined;
 
 		retries--;
 
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index bc937cc74f20..fc288787d5d6 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -351,8 +351,8 @@ static void virtscsi_rescan_hotunplug(struct virtio_scsi *vscsi)
 
 		result.combined =
 			scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
-					  inq_result, inquiry_len, NULL,
-					  SD_TIMEOUT, SD_MAX_RETRIES, NULL);
+				inq_result, inquiry_len, NULL,
+				SD_TIMEOUT, SD_MAX_RETRIES, NULL).combined;
 
 		if (result.combined == 0 && inq_result[0] >> 5) {
 			/* PQ indicates the LUN is not attached */
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 5b562dbd4f11..fd9bb57fd337 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -146,7 +146,7 @@ static void pscsi_tape_read_blocksize(struct se_device *dev,
 	cdb[4] = 0x0c; /* 12 bytes */
 
 	ret = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf, 12, NULL,
-			HZ, 1, NULL);
+			HZ, 1, NULL).combined;
 	if (ret)
 		goto out_free;
 
@@ -197,7 +197,7 @@ pscsi_get_inquiry_vpd_serial(struct scsi_device *sdev, struct t10_wwn *wwn)
 	put_unaligned_be16(INQUIRY_VPD_SERIAL_LEN, &cdb[3]);
 
 	ret = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf,
-			      INQUIRY_VPD_SERIAL_LEN, NULL, HZ, 1, NULL);
+			INQUIRY_VPD_SERIAL_LEN, NULL, HZ, 1, NULL).combined;
 	if (ret)
 		goto out_free;
 
@@ -233,7 +233,7 @@ pscsi_get_inquiry_vpd_device_ident(struct scsi_device *sdev,
 
 	ret = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf,
 			      INQUIRY_VPD_DEVICE_IDENTIFIER_LEN,
-			      NULL, HZ, 1, NULL);
+			      NULL, HZ, 1, NULL).combined;
 	if (ret)
 		goto out;
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index c91c284c88ef..27f3e5eb7c9a 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -455,13 +455,13 @@ __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 		       sense, sshdr, timeout, retries, flags, rq_flags,	\
 		       resid);						\
 })
-static inline int scsi_execute_req(struct scsi_device *sdev,
+static inline union scsi_status scsi_execute_req(struct scsi_device *sdev,
 	const unsigned char *cmd, int data_direction, void *buffer,
 	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
 	int retries, int *resid)
 {
 	return scsi_execute(sdev, cmd, data_direction, buffer,
-		bufflen, NULL, sshdr, timeout, retries,  0, 0, resid).combined;
+		bufflen, NULL, sshdr, timeout, retries,  0, 0, resid);
 }
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
