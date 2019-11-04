Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D1ACA9ECF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 588B120656
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbfKDJCN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 04:02:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:56968 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727419AbfKDJCM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Nov 2019 04:02:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 18CE2B2A5;
        Mon,  4 Nov 2019 09:02:10 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/52] aic7xxx,aic79xxx: remove driver-defined SAM status definitions
Date:   Mon,  4 Nov 2019 10:01:00 +0100
Message-Id: <20191104090151.129140-2-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191104090151.129140-1-hare@suse.de>
References: <20191104090151.129140-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace the driver-defined SAM status definitions with the
standard mid-layer defined ones.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart van Assche <bvanassche@acm.org>
---
 drivers/scsi/aic7xxx/aic79xx_core.c |  8 ++++----
 drivers/scsi/aic7xxx/aic79xx_osm.c  | 16 ++++++++--------
 drivers/scsi/aic7xxx/aic7xxx_core.c |  6 +++---
 drivers/scsi/aic7xxx/aic7xxx_osm.c  | 12 ++++++------
 drivers/scsi/aic7xxx/aiclib.h       | 15 ---------------
 5 files changed, 21 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 7e5044bf05c0..03a9abc7d959 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -8955,7 +8955,7 @@ ahd_handle_scsi_status(struct ahd_softc *ahd, struct scb *scb)
 					break;
 				}
 			}
-			if (siu->status == SCSI_STATUS_OK)
+			if (siu->status == SAM_STAT_GOOD)
 				ahd_set_transaction_status(scb,
 							   CAM_REQ_CMP_ERR);
 		}
@@ -8969,8 +8969,8 @@ ahd_handle_scsi_status(struct ahd_softc *ahd, struct scb *scb)
 		ahd_done(ahd, scb);
 		break;
 	}
-	case SCSI_STATUS_CMD_TERMINATED:
-	case SCSI_STATUS_CHECK_COND:
+	case SAM_STAT_COMMAND_TERMINATED:
+	case SAM_STAT_CHECK_CONDITION:
 	{
 		struct ahd_devinfo devinfo;
 		struct ahd_dma_seg *sg;
@@ -9060,7 +9060,7 @@ ahd_handle_scsi_status(struct ahd_softc *ahd, struct scb *scb)
 		ahd_queue_scb(ahd, scb);
 		break;
 	}
-	case SCSI_STATUS_OK:
+	case SAM_STAT_GOOD:
 		printk("%s: Interrupted for status of 0???\n",
 		       ahd_name(ahd));
 		/* FALLTHROUGH */
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 57992519384e..72c67e89b911 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1846,7 +1846,7 @@ ahd_done(struct ahd_softc *ahd, struct scb *scb)
 
 	if (dev->openings == 1
 	 && ahd_get_transaction_status(scb) == CAM_REQ_CMP
-	 && ahd_get_scsi_status(scb) != SCSI_STATUS_QUEUE_FULL)
+	 && ahd_get_scsi_status(scb) != SAM_STAT_TASK_SET_FULL)
 		dev->tag_success_count++;
 	/*
 	 * Some devices deal with temporary internal resource
@@ -1903,8 +1903,8 @@ ahd_linux_handle_scsi_status(struct ahd_softc *ahd,
 	switch (ahd_get_scsi_status(scb)) {
 	default:
 		break;
-	case SCSI_STATUS_CHECK_COND:
-	case SCSI_STATUS_CMD_TERMINATED:
+	case SAM_STAT_CHECK_CONDITION:
+	case SAM_STAT_COMMAND_TERMINATED:
 	{
 		struct scsi_cmnd *cmd;
 
@@ -1959,7 +1959,7 @@ ahd_linux_handle_scsi_status(struct ahd_softc *ahd,
 		}
 		break;
 	}
-	case SCSI_STATUS_QUEUE_FULL:
+	case SAM_STAT_TASK_SET_FULL:
 		/*
 		 * By the time the core driver has returned this
 		 * command, all other commands that were queued
@@ -2005,7 +2005,7 @@ ahd_linux_handle_scsi_status(struct ahd_softc *ahd,
 				dev->last_queuefull_same_count = 0;
 			}
 			ahd_set_transaction_status(scb, CAM_REQUEUE_REQ);
-			ahd_set_scsi_status(scb, SCSI_STATUS_OK);
+			ahd_set_scsi_status(scb, SAM_STAT_GOOD);
 			ahd_platform_set_tags(ahd, sdev, &devinfo,
 				     (dev->flags & AHD_DEV_Q_BASIC)
 				   ? AHD_QUEUE_BASIC : AHD_QUEUE_TAGGED);
@@ -2019,7 +2019,7 @@ ahd_linux_handle_scsi_status(struct ahd_softc *ahd,
 		ahd_platform_set_tags(ahd, sdev, &devinfo,
 			     (dev->flags & AHD_DEV_Q_BASIC)
 			   ? AHD_QUEUE_BASIC : AHD_QUEUE_TAGGED);
-		ahd_set_scsi_status(scb, SCSI_STATUS_BUSY);
+		ahd_set_scsi_status(scb, SAM_STAT_BUSY);
 	}
 }
 
@@ -2051,8 +2051,8 @@ ahd_linux_queue_cmd_complete(struct ahd_softc *ahd, struct scsi_cmnd *cmd)
 		scsi_status = ahd_cmd_get_scsi_status(cmd);
 
 		switch(scsi_status) {
-		case SCSI_STATUS_CMD_TERMINATED:
-		case SCSI_STATUS_CHECK_COND:
+		case SAM_STAT_COMMAND_TERMINATED:
+		case SAM_STAT_CHECK_CONDITION:
 			if ((cmd->result >> 24) != DRIVER_SENSE) {
 				do_fallback = 1;
 			} else {
diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index a9d40d3b90ef..c8d237ccb70d 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -1041,12 +1041,12 @@ ahc_handle_seqint(struct ahc_softc *ahc, u_int intstat)
 		ahc_freeze_scb(scb);
 		ahc_set_scsi_status(scb, hscb->shared_data.status.scsi_status);
 		switch (hscb->shared_data.status.scsi_status) {
-		case SCSI_STATUS_OK:
+		case SAM_STAT_GOOD:
 			printk("%s: Interrupted for status of 0???\n",
 			       ahc_name(ahc));
 			break;
-		case SCSI_STATUS_CMD_TERMINATED:
-		case SCSI_STATUS_CHECK_COND:
+		case SAM_STAT_COMMAND_TERMINATED:
+		case SAM_STAT_CHECK_CONDITION:
 		{
 			struct ahc_dma_seg *sg;
 			struct scsi_sense *sc;
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index d5c4a0d23706..a0b444e6209d 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1775,7 +1775,7 @@ ahc_done(struct ahc_softc *ahc, struct scb *scb)
 
 	if (dev->openings == 1
 	 && ahc_get_transaction_status(scb) == CAM_REQ_CMP
-	 && ahc_get_scsi_status(scb) != SCSI_STATUS_QUEUE_FULL)
+	 && ahc_get_scsi_status(scb) != SAM_STAT_TASK_SET_FULL)
 		dev->tag_success_count++;
 	/*
 	 * Some devices deal with temporary internal resource
@@ -1832,8 +1832,8 @@ ahc_linux_handle_scsi_status(struct ahc_softc *ahc,
 	switch (ahc_get_scsi_status(scb)) {
 	default:
 		break;
-	case SCSI_STATUS_CHECK_COND:
-	case SCSI_STATUS_CMD_TERMINATED:
+	case SAM_STAT_CHECK_CONDITION:
+	case SAM_STAT_COMMAND_TERMINATED:
 	{
 		struct scsi_cmnd *cmd;
 
@@ -1871,7 +1871,7 @@ ahc_linux_handle_scsi_status(struct ahc_softc *ahc,
 		}
 		break;
 	}
-	case SCSI_STATUS_QUEUE_FULL:
+	case SAM_STAT_TASK_SET_FULL:
 	{
 		/*
 		 * By the time the core driver has returned this
@@ -1915,7 +1915,7 @@ ahc_linux_handle_scsi_status(struct ahc_softc *ahc,
 				dev->last_queuefull_same_count = 0;
 			}
 			ahc_set_transaction_status(scb, CAM_REQUEUE_REQ);
-			ahc_set_scsi_status(scb, SCSI_STATUS_OK);
+			ahc_set_scsi_status(scb, SAM_STAT_GOOD);
 			ahc_platform_set_tags(ahc, sdev, &devinfo,
 				     (dev->flags & AHC_DEV_Q_BASIC)
 				   ? AHC_QUEUE_BASIC : AHC_QUEUE_TAGGED);
@@ -1926,7 +1926,7 @@ ahc_linux_handle_scsi_status(struct ahc_softc *ahc,
 		 * as if the target returned BUSY SCSI status.
 		 */
 		dev->openings = 1;
-		ahc_set_scsi_status(scb, SCSI_STATUS_BUSY);
+		ahc_set_scsi_status(scb, SAM_STAT_BUSY);
 		ahc_platform_set_tags(ahc, sdev, &devinfo,
 			     (dev->flags & AHC_DEV_Q_BASIC)
 			   ? AHC_QUEUE_BASIC : AHC_QUEUE_TAGGED);
diff --git a/drivers/scsi/aic7xxx/aiclib.h b/drivers/scsi/aic7xxx/aiclib.h
index f8fd198aafbc..ba08eb3c4e3b 100644
--- a/drivers/scsi/aic7xxx/aiclib.h
+++ b/drivers/scsi/aic7xxx/aiclib.h
@@ -117,21 +117,6 @@ struct scsi_sense_data
 #define SSD_FULL_SIZE sizeof(struct scsi_sense_data)
 };
 
-/*
- * Status Byte
- */
-#define	SCSI_STATUS_OK			0x00
-#define	SCSI_STATUS_CHECK_COND		0x02
-#define	SCSI_STATUS_COND_MET		0x04
-#define	SCSI_STATUS_BUSY		0x08
-#define SCSI_STATUS_INTERMED		0x10
-#define SCSI_STATUS_INTERMED_COND_MET	0x14
-#define SCSI_STATUS_RESERV_CONFLICT	0x18
-#define SCSI_STATUS_CMD_TERMINATED	0x22	/* Obsolete in SAM-2 */
-#define SCSI_STATUS_QUEUE_FULL		0x28
-#define SCSI_STATUS_ACA_ACTIVE		0x30
-#define SCSI_STATUS_TASK_ABORTED	0x40
-
 /************************* Large Disk Handling ********************************/
 static inline int
 aic_sector_div(sector_t capacity, int heads, int sectors)
-- 
2.16.4

