Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19842C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA14B613AB
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbhDTCPQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:15:16 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:36508 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233766AbhDTCPI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:15:08 -0400
Received: by mail-pl1-f182.google.com with SMTP id g16so1962601plq.3
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 19:14:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0j9B81elc6mROxqYj+Hz5lGCxgOsk7A//QRvAns885U=;
        b=U6mVJiN3KfRPoX033IoaFAG2jUvVa8dfxATMdGNbIGxTfh6/6Feamwr18KHOdjZvvk
         GAopsebY71iHTH/9JjLVkVYZb6+F26kfzm66Zf5I5fSeyW7dw0BS69BrxPbUWZvvzPFv
         DWDRc6hswtR+WzyV5d9Df7hDc74y4BfWXu4CxCvSqfVXQnrL9U5BToH5qSWMKr9aOwSL
         r0rKqGDM4yRIYdpTNtmT0vGt9HBdLeepTcLDFbWmvfGz6YA6xTEB8/DtfKDzh5Apg0FP
         shOlqSlY8WzjQ5z6BKCqbUg1qkb7TrMuGAX/R9RPDy2RtLbxReh/kOFxTX0UIMDKpBix
         JSJw==
X-Gm-Message-State: AOAM5306vJ7WBRm90hfYN74I2g8lxENqo5w5n1viLUyw+7ipjk7vPuUt
        HT7FWBadRwplYJmjGIIwcBc=
X-Google-Smtp-Source: ABdhPJwN9Abafzdf32eD0Zx+j5VRBoQjG9Xk5pLkLk5bMU8VqVK7gF9XGQtGbrlF/DfTv5oN6lcqsw==
X-Received: by 2002:a17:902:7203:b029:e6:a8b1:8d37 with SMTP id ba3-20020a1709027203b02900e6a8b18d37mr26010272plb.44.1618884877600;
        Mon, 19 Apr 2021 19:14:37 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id mq2sm630984pjb.24.2021.04.19.19.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:14:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 114/117] Change the return type of scsi_test_unit_ready() into union scsi_status
Date:   Mon, 19 Apr 2021 19:13:59 -0700
Message-Id: <20210420021402.27678-24-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that scsi_test_unit_ready() returns a SCSI status.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 4 ++--
 drivers/scsi/scsi_ioctl.c                  | 2 +-
 drivers/scsi/scsi_lib.c                    | 4 ++--
 drivers/scsi/sd.c                          | 5 ++---
 drivers/scsi/sr.c                          | 6 +++---
 drivers/scsi/sr_ioctl.c                    | 3 ++-
 include/scsi/scsi_device.h                 | 4 ++--
 7 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 0de3096f9df7..476a875f6c06 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -490,14 +490,14 @@ static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
 static int alua_tur(struct scsi_device *sdev)
 {
 	struct scsi_sense_hdr sense_hdr;
-	int retval;
+	union scsi_status retval;
 
 	retval = scsi_test_unit_ready(sdev, ALUA_FAILOVER_TIMEOUT * HZ,
 				      ALUA_FAILOVER_RETRIES, &sense_hdr);
 	if (sense_hdr.sense_key == NOT_READY &&
 	    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a)
 		return SCSI_DH_RETRY;
-	else if (retval)
+	else if (retval.combined)
 		return SCSI_DH_IO;
 	else
 		return SCSI_DH_OK;
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index b9e2f5b03c83..8b3bab5b5cb8 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -237,7 +237,7 @@ static int scsi_ioctl_common(struct scsi_device *sdev, int cmd, void __user *arg
 		return scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);
 	case SCSI_IOCTL_TEST_UNIT_READY:
 		return scsi_test_unit_ready(sdev, IOCTL_NORMAL_TIMEOUT,
-					    NORMAL_RETRIES, &sense_hdr);
+					NORMAL_RETRIES, &sense_hdr).combined;
 	case SCSI_IOCTL_START_UNIT:
 		scsi_cmd[0] = START_STOP;
 		scsi_cmd[1] = 0;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 23750d167c47..44925839ccee 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2255,7 +2255,7 @@ EXPORT_SYMBOL(scsi_mode_sense);
  *	Returns zero if unsuccessful or an error if TUR failed.  For
  *	removable media, UNIT_ATTENTION sets ->changed flag.
  **/
-int
+union scsi_status
 scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 		     struct scsi_sense_hdr *sshdr)
 {
@@ -2274,7 +2274,7 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 	} while (scsi_sense_valid(sshdr) &&
 		 sshdr->sense_key == UNIT_ATTENTION && --retries);
 
-	return result.combined;
+	return result;
 }
 EXPORT_SYMBOL(scsi_test_unit_ready);
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 1df895e0e619..14cf7841a0bf 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1654,9 +1654,8 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 	if (scsi_block_when_processing_errors(sdp)) {
 		struct scsi_sense_hdr sshdr = { 0, };
 
-		retval.combined =
-			scsi_test_unit_ready(sdp, SD_TIMEOUT, sdkp->max_retries,
-					      &sshdr);
+		retval = scsi_test_unit_ready(sdp, SD_TIMEOUT,
+					      sdkp->max_retries, &sshdr);
 
 		/* failed to execute TUR, assume media not present */
 		if (host_byte(retval)) {
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index d745ff8a30e8..da78b402072f 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -273,8 +273,7 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 do_tur:
 	/* let's see whether the media is there with TUR */
 	last_present = cd->media_present;
-	ret.combined = scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES,
-					    &sshdr);
+	ret = scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
 
 	/*
 	 * Media is considered to be present if TUR succeeds or fails with
@@ -508,7 +507,8 @@ static void sr_revalidate_disk(struct scsi_cd *cd)
 	struct scsi_sense_hdr sshdr;
 
 	/* if the unit is not ready, nothing more to do */
-	if (scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr))
+	if (scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr)
+	    .combined)
 		return;
 	sr_cd_check(&cd->cdi);
 	get_sectorsize(cd);
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index b13612f50d6d..798a22990dc7 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -292,7 +292,8 @@ int sr_drive_status(struct cdrom_device_info *cdi, int slot)
 		/* we have no changer support */
 		return -EINVAL;
 	}
-	if (!scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr))
+	if (!scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr)
+	    .combined)
 		return CDS_DISC_OK;
 
 	/* SK/ASC/ASCQ of 2/4/1 means "unit is becoming ready" */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 27f3e5eb7c9a..3192610af5db 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -411,8 +411,8 @@ extern int scsi_mode_select(struct scsi_device *sdev, int pf, int sp,
 			    int timeout, int retries,
 			    struct scsi_mode_data *data,
 			    struct scsi_sense_hdr *);
-extern int scsi_test_unit_ready(struct scsi_device *sdev, int timeout,
-				int retries, struct scsi_sense_hdr *sshdr);
+extern union scsi_status scsi_test_unit_ready(struct scsi_device *sdev,
+			int timeout, int retries, struct scsi_sense_hdr *sshdr);
 extern int scsi_get_vpd_page(struct scsi_device *, u8 page, unsigned char *buf,
 			     int buf_len);
 extern int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
