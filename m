Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C4CC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D91DF6109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbhDTAKN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:13 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:55248 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233304AbhDTAJ4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:56 -0400
Received: by mail-pj1-f49.google.com with SMTP id cu16so16860170pjb.4
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RXIQbLgWP0BT0MrD9i9BLnIouIhtTaVlSkqaFLLo6m4=;
        b=EJtRM8vPNRMqlh4rzHYAN4wv00Rmv4165LWFkazBPD/Dn7MiTqKlbhd6L2w7b5Cahl
         ous1znCvuVaRqAmb1Yq1zuTDsiKUo1yHB8QfCAUm1bMOUvTqeH2VGf+pCeVgkL+araNX
         HFmmYmDBJex18vMKo+vBYSlAEajPIOO2NFECi/JhnYv9Wu6auT1nXgas8vmZLhapf/r7
         +m+9LbKEfiaazPd4AOcFl6jtKVKYxbSeuF3ljt44uTFHDiWxleE0HiFN56/fJhPxd55Q
         w9xJwSYzyqr8mWiSC814iQzr5I1tzSZMsc25f1untMbehi3msVw5EHgq1Y/xYYd1s3Jg
         0CNQ==
X-Gm-Message-State: AOAM532UhlH/0fw1Jy7LqoMJiw714VYL9HF2v3lDSKY/rvD7FvKQw6BV
        NVq5doGe4UNQOOMcjv695so=
X-Google-Smtp-Source: ABdhPJyIQmkit7HjTaD+dX7qLIqjBpGO6riJLdrYd6ifmg3nSvNtLzg/3vV40SksDFYIhCLjiuXF/Q==
X-Received: by 2002:a17:902:ee8a:b029:eb:6d3:1431 with SMTP id a10-20020a170902ee8ab02900eb06d31431mr25960137pld.60.1618877365757;
        Mon, 19 Apr 2021 17:09:25 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:25 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 029/117] aic*: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:17 -0700
Message-Id: <20210420000845.25873-30-bvanassche@acm.org>
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

Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c | 10 +++++-----
 drivers/scsi/aic7xxx/aic79xx_osm.h | 16 ++++++++--------
 drivers/scsi/aic7xxx/aic7xxx_osm.c |  8 ++++----
 drivers/scsi/aic7xxx/aic7xxx_osm.h | 16 ++++++++--------
 4 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 4f7102f8eeb0..d338e8ed68e7 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -582,7 +582,7 @@ ahd_linux_queue_lck(struct scsi_cmnd * cmd, void (*scsi_done) (struct scsi_cmnd
 	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
 
 	cmd->scsi_done = scsi_done;
-	cmd->result = CAM_REQ_INPROG << 16;
+	cmd->status.combined = CAM_REQ_INPROG << 16;
 	rtn = ahd_linux_run_command(ahd, dev, cmd);
 
 	return rtn;
@@ -1772,8 +1772,8 @@ ahd_done(struct ahd_softc *ahd, struct scb *scb)
 	dev = scb->platform_data->dev;
 	dev->active--;
 	dev->openings++;
-	if ((cmd->result & (CAM_DEV_QFRZN << 16)) != 0) {
-		cmd->result &= ~(CAM_DEV_QFRZN << 16);
+	if ((cmd->status.combined & (CAM_DEV_QFRZN << 16)) != 0) {
+		cmd->status.combined &= ~(CAM_DEV_QFRZN << 16);
 		dev->qfrozen--;
 	}
 	ahd_linux_unmap_scb(ahd, scb);
@@ -1928,7 +1928,7 @@ ahd_linux_handle_scsi_status(struct ahd_softc *ahd,
 			memcpy(cmd->sense_buffer,
 			       ahd_get_sense_buf(ahd, scb)
 			       + sense_offset, sense_size);
-			cmd->result |= (DRIVER_SENSE << 24);
+			cmd->status.combined |= (DRIVER_SENSE << 24);
 
 #ifdef AHD_DEBUG
 			if (ahd_debug & AHD_SHOW_SENSE) {
@@ -2041,7 +2041,7 @@ ahd_linux_queue_cmd_complete(struct ahd_softc *ahd, struct scsi_cmnd *cmd)
 		switch(scsi_status) {
 		case SAM_STAT_COMMAND_TERMINATED:
 		case SAM_STAT_CHECK_CONDITION:
-			if ((cmd->result >> 24) != DRIVER_SENSE) {
+			if (cmd->status.b.driver != DRIVER_SENSE) {
 				do_fallback = 1;
 			} else {
 				struct scsi_sense_data *sense;
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.h b/drivers/scsi/aic7xxx/aic79xx_osm.h
index 35ec24f28d2c..6b33bcadc772 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -501,8 +501,8 @@ int	ahd_linux_show_info(struct seq_file *,struct Scsi_Host *);
 static inline
 void ahd_cmd_set_transaction_status(struct scsi_cmnd *cmd, uint32_t status)
 {
-	cmd->result &= ~(CAM_STATUS_MASK << 16);
-	cmd->result |= status << 16;
+	cmd->status.combined &= ~(CAM_STATUS_MASK << 16);
+	cmd->status.combined |= status << 16;
 }
 
 static inline
@@ -514,8 +514,8 @@ void ahd_set_transaction_status(struct scb *scb, uint32_t status)
 static inline
 void ahd_cmd_set_scsi_status(struct scsi_cmnd *cmd, uint32_t status)
 {
-	cmd->result &= ~0xFFFF;
-	cmd->result |= status;
+	cmd->status.combined &= ~0xFFFF;
+	cmd->status.combined |= status;
 }
 
 static inline
@@ -527,7 +527,7 @@ void ahd_set_scsi_status(struct scb *scb, uint32_t status)
 static inline
 uint32_t ahd_cmd_get_transaction_status(struct scsi_cmnd *cmd)
 {
-	return ((cmd->result >> 16) & CAM_STATUS_MASK);
+	return ((cmd->status.combined >> 16) & CAM_STATUS_MASK);
 }
 
 static inline
@@ -539,7 +539,7 @@ uint32_t ahd_get_transaction_status(struct scb *scb)
 static inline
 uint32_t ahd_cmd_get_scsi_status(struct scsi_cmnd *cmd)
 {
-	return (cmd->result & 0xFFFF);
+	return (cmd->status.combined & 0xFFFF);
 }
 
 static inline
@@ -631,8 +631,8 @@ void	ahd_platform_freeze_devq(struct ahd_softc *ahd, struct scb *scb);
 static inline void
 ahd_freeze_scb(struct scb *scb)
 {
-	if ((scb->io_ctx->result & (CAM_DEV_QFRZN << 16)) == 0) {
-		scb->io_ctx->result |= CAM_DEV_QFRZN << 16;
+	if ((scb->io_ctx->status.combined & (CAM_DEV_QFRZN << 16)) == 0) {
+		scb->io_ctx->status.combined |= CAM_DEV_QFRZN << 16;
 		scb->platform_data->dev->qfrozen++;
 	}
 }
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index d33f5a00bf0b..a243de992695 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -531,7 +531,7 @@ ahc_linux_queue_lck(struct scsi_cmnd * cmd, void (*scsi_done) (struct scsi_cmnd
 	ahc_lock(ahc, &flags);
 	if (ahc->platform_data->qfrozen == 0) {
 		cmd->scsi_done = scsi_done;
-		cmd->result = CAM_REQ_INPROG << 16;
+		cmd->status.combined = CAM_REQ_INPROG << 16;
 		rtn = ahc_linux_run_command(ahc, dev, cmd);
 	}
 	ahc_unlock(ahc, &flags);
@@ -1698,8 +1698,8 @@ ahc_done(struct ahc_softc *ahc, struct scb *scb)
 	dev = scb->platform_data->dev;
 	dev->active--;
 	dev->openings++;
-	if ((cmd->result & (CAM_DEV_QFRZN << 16)) != 0) {
-		cmd->result &= ~(CAM_DEV_QFRZN << 16);
+	if ((cmd->status.combined & (CAM_DEV_QFRZN << 16)) != 0) {
+		cmd->status.combined &= ~(CAM_DEV_QFRZN << 16);
 		dev->qfrozen--;
 	}
 	ahc_linux_unmap_scb(ahc, scb);
@@ -1838,7 +1838,7 @@ ahc_linux_handle_scsi_status(struct ahc_softc *ahc,
 			if (sense_size < SCSI_SENSE_BUFFERSIZE)
 				memset(&cmd->sense_buffer[sense_size], 0,
 				       SCSI_SENSE_BUFFERSIZE - sense_size);
-			cmd->result |= (DRIVER_SENSE << 24);
+			cmd->status.b.driver = DRIVER_SENSE;
 #ifdef AHC_DEBUG
 			if (ahc_debug & AHC_SHOW_SENSE) {
 				int i;
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.h b/drivers/scsi/aic7xxx/aic7xxx_osm.h
index 53240f53b654..6d0087e8c568 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.h
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.h
@@ -519,8 +519,8 @@ int	ahc_linux_show_info(struct seq_file *, struct Scsi_Host *);
 static inline
 void ahc_cmd_set_transaction_status(struct scsi_cmnd *cmd, uint32_t status)
 {
-	cmd->result &= ~(CAM_STATUS_MASK << 16);
-	cmd->result |= status << 16;
+	cmd->status.combined &= ~(CAM_STATUS_MASK << 16);
+	cmd->status.combined |= status << 16;
 }
 
 static inline
@@ -532,8 +532,8 @@ void ahc_set_transaction_status(struct scb *scb, uint32_t status)
 static inline
 void ahc_cmd_set_scsi_status(struct scsi_cmnd *cmd, uint32_t status)
 {
-	cmd->result &= ~0xFFFF;
-	cmd->result |= status;
+	cmd->status.combined &= ~0xFFFF;
+	cmd->status.combined |= status;
 }
 
 static inline
@@ -545,7 +545,7 @@ void ahc_set_scsi_status(struct scb *scb, uint32_t status)
 static inline
 uint32_t ahc_cmd_get_transaction_status(struct scsi_cmnd *cmd)
 {
-	return ((cmd->result >> 16) & CAM_STATUS_MASK);
+	return ((cmd->status.combined >> 16) & CAM_STATUS_MASK);
 }
 
 static inline
@@ -557,7 +557,7 @@ uint32_t ahc_get_transaction_status(struct scb *scb)
 static inline
 uint32_t ahc_cmd_get_scsi_status(struct scsi_cmnd *cmd)
 {
-	return (cmd->result & 0xFFFF);
+	return (cmd->status.combined & 0xFFFF);
 }
 
 static inline
@@ -647,8 +647,8 @@ void	ahc_platform_freeze_devq(struct ahc_softc *ahc, struct scb *scb);
 static inline void
 ahc_freeze_scb(struct scb *scb)
 {
-	if ((scb->io_ctx->result & (CAM_DEV_QFRZN << 16)) == 0) {
-		scb->io_ctx->result |= CAM_DEV_QFRZN << 16;
+	if ((scb->io_ctx->status.combined & (CAM_DEV_QFRZN << 16)) == 0) {
+		scb->io_ctx->status.combined |= CAM_DEV_QFRZN << 16;
 		scb->platform_data->dev->qfrozen++;
 	}
 }
