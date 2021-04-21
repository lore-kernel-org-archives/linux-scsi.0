Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 241F7C43461
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC9A561405
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245024AbhDURtB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 13:49:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:51736 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244927AbhDURsg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Apr 2021 13:48:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 479E8AFD8;
        Wed, 21 Apr 2021 17:48:01 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/42] scsi: stop using DRIVER_ERROR
Date:   Wed, 21 Apr 2021 19:47:12 +0200
Message-Id: <20210421174749.11221-6-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210421174749.11221-1-hare@suse.de>
References: <20210421174749.11221-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Return the actual error code in __scsi_execute() (which, according
to the documentation, should have happened anyway).
And audit all callers to cope with negative return values from
__scsi_execute() and friends.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-scsi.c         |  8 ++++++++
 drivers/scsi/ch.c                 |  3 ++-
 drivers/scsi/cxlflash/superpipe.c |  2 +-
 drivers/scsi/scsi.c               |  2 ++
 drivers/scsi/scsi_ioctl.c         |  4 +++-
 drivers/scsi/scsi_lib.c           | 15 +++++++++------
 drivers/scsi/scsi_scan.c          |  4 ++--
 drivers/scsi/scsi_transport_spi.c |  2 +-
 drivers/scsi/sd.c                 | 15 +++++++++------
 drivers/scsi/sd_zbc.c             |  2 +-
 drivers/scsi/sr_ioctl.c           |  4 ++++
 drivers/scsi/ufs/ufshcd.c         |  2 +-
 drivers/scsi/virtio_scsi.c        |  2 +-
 include/scsi/scsi.h               |  3 +++
 14 files changed, 47 insertions(+), 21 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 48b8934970f3..c5129b9e3afd 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -409,6 +409,10 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 	cmd_result = scsi_execute(scsidev, scsi_cmd, data_dir, argbuf, argsize,
 				  sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
 
+	if (cmd_result < 0) {
+		rc = cmd_result;
+		goto error;
+	}
 	if (driver_byte(cmd_result) == DRIVER_SENSE) {/* sense data available */
 		u8 *desc = sensebuf + 8;
 		cmd_result &= ~(0xFF<<24); /* DRIVER_SENSE is not an error */
@@ -490,6 +494,10 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 	cmd_result = scsi_execute(scsidev, scsi_cmd, DMA_NONE, NULL, 0,
 				sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
 
+	if (cmd_result < 0) {
+		rc = cmd_result;
+		goto error;
+	}
 	if (driver_byte(cmd_result) == DRIVER_SENSE) {/* sense data available */
 		u8 *desc = sensebuf + 8;
 		cmd_result &= ~(0xFF<<24); /* DRIVER_SENSE is not an error */
diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index cb74ab1ae5a4..0e7d1214c3d8 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -198,7 +198,8 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 	result = scsi_execute_req(ch->device, cmd, direction, buffer,
 				  buflength, &sshdr, timeout * HZ,
 				  MAX_RETRIES, NULL);
-
+	if (result < 0)
+		return result;
 	if (driver_byte(result) == DRIVER_SENSE) {
 		if (debug)
 			scsi_print_sense_hdr(ch->device, ch->name, &sshdr);
diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index ee11ec340654..caa7c5fd233d 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -369,7 +369,7 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 		goto out;
 	}
 
-	if (driver_byte(result) == DRIVER_SENSE) {
+	if (result > 0 && driver_byte(result) == DRIVER_SENSE) {
 		result &= ~(0xFF<<24); /* DRIVER_SENSE is not an error */
 		if (result & SAM_STAT_CHECK_CONDITION) {
 			switch (sshdr.sense_key) {
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index e9e2f0e15ac8..99dc6ec0b6e5 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -508,6 +508,8 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer, len,
 				  &sshdr, 30 * HZ, 3, NULL);
 
+	if (result < 0)
+		return result;
 	if (result && scsi_sense_valid(&sshdr) &&
 	    sshdr.sense_key == ILLEGAL_REQUEST &&
 	    (sshdr.asc == 0x20 || sshdr.asc == 0x24) && sshdr.ascq == 0x00)
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 14872c9dc78c..d34e1b41dc71 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -101,6 +101,8 @@ static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 	SCSI_LOG_IOCTL(2, sdev_printk(KERN_INFO, sdev,
 				      "Ioctl returned  0x%x\n", result));
 
+	if (result < 0)
+		goto out;
 	if (driver_byte(result) == DRIVER_SENSE &&
 	    scsi_sense_valid(&sshdr)) {
 		switch (sshdr.sense_key) {
@@ -133,7 +135,7 @@ static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 			break;
 		}
 	}
-
+out:
 	SCSI_LOG_IOCTL(2, sdev_printk(KERN_INFO, sdev,
 				      "IOCTL Releasing command\n"));
 	return result;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c532f9390ae3..2d9b533ef1ec 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -245,20 +245,23 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 {
 	struct request *req;
 	struct scsi_request *rq;
-	int ret = DRIVER_ERROR << 24;
+	int ret;
 
 	req = blk_get_request(sdev->request_queue,
 			data_direction == DMA_TO_DEVICE ?
 			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN,
 			rq_flags & RQF_PM ? BLK_MQ_REQ_PM : 0);
 	if (IS_ERR(req))
-		return ret;
-	rq = scsi_req(req);
+		return PTR_ERR(req);
 
-	if (bufflen &&	blk_rq_map_kern(sdev->request_queue, req,
-					buffer, bufflen, GFP_NOIO))
-		goto out;
+	rq = scsi_req(req);
 
+	if (bufflen) {
+		ret = blk_rq_map_kern(sdev->request_queue, req,
+				      buffer, bufflen, GFP_NOIO);
+		if (ret)
+			goto out;
+	}
 	rq->cmd_len = COMMAND_SIZE(cmd[0]);
 	memcpy(rq->cmd, cmd, rq->cmd_len);
 	rq->retries = retries;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 9f1b7f3c650a..493f17bf26f2 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -616,7 +616,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 				"scsi scan: INQUIRY %s with code 0x%x\n",
 				result ? "failed" : "successful", result));
 
-		if (result) {
+		if (result > 0) {
 			/*
 			 * not-ready to ready transition [asc/ascq=0x28/0x0]
 			 * or power-on, reset [asc/ascq=0x29/0x0], continue.
@@ -631,7 +631,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 				    (sshdr.ascq == 0))
 					continue;
 			}
-		} else {
+		} else if (result == 0) {
 			/*
 			 * if nothing was transferred, we try
 			 * again. It's a workaround for some USB
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index c37dd15d16d2..a9bb7ae2fafd 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -127,7 +127,7 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 				      REQ_FAILFAST_TRANSPORT |
 				      REQ_FAILFAST_DRIVER,
 				      RQF_PM, NULL);
-		if (driver_byte(result) != DRIVER_SENSE ||
+		if (result < 0 || driver_byte(result) != DRIVER_SENSE ||
 		    sshdr->sense_key != UNIT_ATTENTION)
 			break;
 	}
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2ef2954375f4..5733fbee2bae 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1658,7 +1658,7 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 					      &sshdr);
 
 		/* failed to execute TUR, assume media not present */
-		if (host_byte(retval)) {
+		if (retval < 0 || host_byte(retval)) {
 			set_media_not_present(sdkp);
 			goto out;
 		}
@@ -1719,6 +1719,9 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 	if (res) {
 		sd_print_result(sdkp, "Synchronize Cache(10) failed", res);
 
+		if (res < 0)
+			return res;
+
 		if (driver_byte(res) == DRIVER_SENSE)
 			sd_print_sense_hdr(sdkp, sshdr);
 
@@ -1825,7 +1828,7 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, &data, sizeof(data),
 			&sshdr, SD_TIMEOUT, sdkp->max_retries, NULL);
 
-	if (driver_byte(result) == DRIVER_SENSE &&
+	if (result > 0 && driver_byte(result) == DRIVER_SENSE &&
 	    scsi_sense_valid(&sshdr)) {
 		sdev_printk(KERN_INFO, sdev, "PR command failed: %d\n", result);
 		scsi_print_sense_hdr(sdev, NULL, &sshdr);
@@ -2177,7 +2180,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			  ((driver_byte(the_result) == DRIVER_SENSE) &&
 			  sense_valid && sshdr.sense_key == UNIT_ATTENTION)));
 
-		if (driver_byte(the_result) != DRIVER_SENSE) {
+		if (the_result < 0 || driver_byte(the_result) != DRIVER_SENSE) {
 			/* no sense, TUR either succeeded or failed
 			 * with a status error */
 			if(!spintime && !scsi_status_is_good(the_result)) {
@@ -2362,7 +2365,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
 
-		if (the_result) {
+		if (the_result > 0) {
 			sense_valid = scsi_sense_valid(&sshdr);
 			if (sense_valid &&
 			    sshdr.sense_key == ILLEGAL_REQUEST &&
@@ -2447,7 +2450,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
 
-		if (the_result) {
+		if (the_result > 0) {
 			sense_valid = scsi_sense_valid(&sshdr);
 			if (sense_valid &&
 			    sshdr.sense_key == UNIT_ATTENTION &&
@@ -3591,7 +3594,7 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 			SD_TIMEOUT, sdkp->max_retries, 0, RQF_PM, NULL);
 	if (res) {
 		sd_print_result(sdkp, "Start/Stop Unit failed", res);
-		if (driver_byte(res) == DRIVER_SENSE)
+		if (res > 0 && driver_byte(res) == DRIVER_SENSE)
 			sd_print_sense_hdr(sdkp, &sshdr);
 		if (scsi_sense_valid(&sshdr) &&
 			/* 0x3a is medium not present */
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index e45d8d94574c..d4a79fdcfffe 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -116,7 +116,7 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 		sd_printk(KERN_ERR, sdkp,
 			  "REPORT ZONES start lba %llu failed\n", lba);
 		sd_print_result(sdkp, "REPORT ZONES", result);
-		if (driver_byte(result) == DRIVER_SENSE &&
+		if (result > 0 && driver_byte(result) == DRIVER_SENSE &&
 		    scsi_sense_valid(&sshdr))
 			sd_print_sense_hdr(sdkp, &sshdr);
 		return -EIO;
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index 5703f8400b73..a78f2138d784 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -205,6 +205,10 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 			      cgc->timeout, IOCTL_RETRIES, 0, 0, NULL);
 
 	/* Minimal error checking.  Ignore cases we know about, and report the rest. */
+	if (result < 0) {
+		err = result;
+		goto out;
+	}
 	if (driver_byte(result) != 0) {
 		switch (sshdr->sense_key) {
 		case UNIT_ATTENTION:
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0625da7a42ee..f743434073ac 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8487,7 +8487,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 		sdev_printk(KERN_WARNING, sdp,
 			    "START_STOP failed for power mode: %d, result %x\n",
 			    pwr_mode, ret);
-		if (driver_byte(ret) == DRIVER_SENSE)
+		if (ret > 0 && driver_byte(ret) == DRIVER_SENSE)
 			scsi_print_sense_hdr(sdp, NULL, &sshdr);
 	}
 
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index b9c86a7e3b97..1678b6f14af9 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -355,7 +355,7 @@ static void virtscsi_rescan_hotunplug(struct virtio_scsi *vscsi)
 		if (result == 0 && inq_result[0] >> 5) {
 			/* PQ indicates the LUN is not attached */
 			scsi_remove_device(sdev);
-		} else if (host_byte(result) == DID_BAD_TARGET) {
+		} else if (result > 0 && host_byte(result) == DID_BAD_TARGET) {
 			/*
 			 * If all LUNs of a virtio-scsi device are unplugged
 			 * it will respond with BAD TARGET on any INQUIRY
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 246ced401683..d0a24e55ad63 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -40,6 +40,9 @@ enum scsi_timeouts {
  */
 static inline int scsi_status_is_good(int status)
 {
+	if (status < 0)
+		return false;
+
 	/*
 	 * FIXME: bit0 is listed as reserved in SCSI-2, but is
 	 * significant in SCSI-3.  For now, we follow the SCSI-2
-- 
2.29.2

