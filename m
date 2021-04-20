Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F04D2C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8876611EE
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbhDTCOo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:14:44 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:35527 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbhDTCOm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:14:42 -0400
Received: by mail-pl1-f172.google.com with SMTP id e9so1836562plj.2
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 19:14:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FRvAzcibd8eNyJOlNByQi/0ebIXSgfv3RMgPMs8ZpsQ=;
        b=cO4q9HC7NJNxdvXi7y4JUqcrIJLagylFC6aJTConmifyealqdwwzE0sKenwXbtrFP8
         f+Y4NWBks6WrsezFXCJm9Z0idaBUO7zSne8pw4N6HsjHc5UG0FSTdu7U5u9t21xoTYF1
         iJXauOa+nNoVoRYlgIpLFIBgVyNti0rQ2GUa88m2+Gn7LqYUm4BxxxD2zWy2EpUTB+Py
         ZdkDX+cyVZMlaPsW/Z00cigb5va6VS2o0rnoZZHoGA9Znp0d7WIWKHCuoCliWnIMYE7O
         ycCo0jv0pXF80xfMEVs2rFWQ4BNts4mfPNQ5SYA1Xbb6iM6BZq0oAy4L1Y7WmO+N+mNr
         bykA==
X-Gm-Message-State: AOAM5333cFlTLPaqHr/zP42ZREvHaBnncNLe2jPuRFNvKK4cm7yB3q5y
        leetegOSVAOI3h0Zw0FHdg6MpoRdXsixYA==
X-Google-Smtp-Source: ABdhPJzk2cMJhM8cnkGmErz7qN2NZSzyOlyDpPai3mIHP31tq4q1hVtLwM9HdtzlfaqeTLNdpIus8g==
X-Received: by 2002:a17:90a:1c02:: with SMTP id s2mr2219537pjs.17.1618884851835;
        Mon, 19 Apr 2021 19:14:11 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id mq2sm630984pjb.24.2021.04.19.19.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:14:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 093/117] staging: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 19:13:38 -0700
Message-Id: <20210420021402.27678-3-bvanassche@acm.org>
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

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/staging/rts5208/rtsx.c                  | 14 +++++++-------
 drivers/staging/rts5208/rtsx_transport.c        |  8 ++++----
 drivers/staging/unisys/include/iochannel.h      |  3 ++-
 drivers/staging/unisys/visorhba/visorhba_main.c | 12 ++++++------
 4 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/rts5208/rtsx.c b/drivers/staging/rts5208/rtsx.c
index 898add4d1fc8..5e97fee2fa16 100644
--- a/drivers/staging/rts5208/rtsx.c
+++ b/drivers/staging/rts5208/rtsx.c
@@ -134,7 +134,7 @@ static int queuecommand_lck(struct scsi_cmnd *srb,
 	/* fail the command if we are disconnecting */
 	if (rtsx_chk_stat(chip, RTSX_STAT_DISCONNECT)) {
 		dev_info(&dev->pci->dev, "Fail command during disconnect\n");
-		srb->result = DID_NO_CONNECT << 16;
+		srb->status.combined = DID_NO_CONNECT << 16;
 		done(srb);
 		return 0;
 	}
@@ -377,7 +377,7 @@ static int rtsx_control_thread(void *__dev)
 
 		/* has the command aborted ? */
 		if (rtsx_chk_stat(chip, RTSX_STAT_ABORT)) {
-			chip->srb->result = DID_ABORT << 16;
+			chip->srb->status.combined = DID_ABORT << 16;
 			goto skip_for_abort;
 		}
 
@@ -388,7 +388,7 @@ static int rtsx_control_thread(void *__dev)
 		 */
 		if (chip->srb->sc_data_direction == DMA_BIDIRECTIONAL) {
 			dev_err(&dev->pci->dev, "UNKNOWN data direction\n");
-			chip->srb->result = DID_ERROR << 16;
+			chip->srb->status.combined = DID_ERROR << 16;
 		}
 
 		/* reject if target != 0 or if LUN is higher than
@@ -398,14 +398,14 @@ static int rtsx_control_thread(void *__dev)
 			dev_err(&dev->pci->dev, "Bad target number (%d:%d)\n",
 				chip->srb->device->id,
 				(u8)chip->srb->device->lun);
-			chip->srb->result = DID_BAD_TARGET << 16;
+			chip->srb->status.combined = DID_BAD_TARGET << 16;
 		}
 
 		else if (chip->srb->device->lun > chip->max_lun) {
 			dev_err(&dev->pci->dev, "Bad LUN (%d:%d)\n",
 				chip->srb->device->id,
 				(u8)chip->srb->device->lun);
-			chip->srb->result = DID_BAD_TARGET << 16;
+			chip->srb->status.combined = DID_BAD_TARGET << 16;
 		}
 
 		/* we've got a command, let's do it! */
@@ -422,7 +422,7 @@ static int rtsx_control_thread(void *__dev)
 			;		/* nothing to do */
 
 		/* indicate that the command is done */
-		else if (chip->srb->result != DID_ABORT << 16) {
+		else if (chip->srb->status.combined != DID_ABORT << 16) {
 			chip->srb->scsi_done(chip->srb);
 		} else {
 skip_for_abort:
@@ -633,7 +633,7 @@ static void quiesce_and_remove_host(struct rtsx_dev *dev)
 	 */
 	mutex_lock(&dev->dev_mutex);
 	if (chip->srb) {
-		chip->srb->result = DID_NO_CONNECT << 16;
+		chip->srb->status.combined = DID_NO_CONNECT << 16;
 		scsi_lock(host);
 		chip->srb->scsi_done(dev->chip->srb);
 		chip->srb = NULL;
diff --git a/drivers/staging/rts5208/rtsx_transport.c b/drivers/staging/rts5208/rtsx_transport.c
index 909a3e663ef6..1c8a0bda8e25 100644
--- a/drivers/staging/rts5208/rtsx_transport.c
+++ b/drivers/staging/rts5208/rtsx_transport.c
@@ -160,18 +160,18 @@ void rtsx_invoke_transport(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	 */
 	if (rtsx_chk_stat(chip, RTSX_STAT_ABORT)) {
 		dev_dbg(rtsx_dev(chip), "-- command was aborted\n");
-		srb->result = DID_ABORT << 16;
+		srb->status.combined = DID_ABORT << 16;
 		goto handle_errors;
 	}
 
 	/* if there is a transport error, reset and don't auto-sense */
 	if (result == TRANSPORT_ERROR) {
 		dev_dbg(rtsx_dev(chip), "-- transport indicates error, resetting\n");
-		srb->result = DID_ERROR << 16;
+		srb->status.combined = DID_ERROR << 16;
 		goto handle_errors;
 	}
 
-	srb->result = SAM_STAT_GOOD;
+	srb->status.combined = SAM_STAT_GOOD;
 
 	/*
 	 * If we have a failure, we're going to do a REQUEST_SENSE
@@ -180,7 +180,7 @@ void rtsx_invoke_transport(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	 */
 	if (result == TRANSPORT_FAILED) {
 		/* set the result so the higher layers expect this data */
-		srb->result = SAM_STAT_CHECK_CONDITION;
+		srb->status.combined = SAM_STAT_CHECK_CONDITION;
 		memcpy(srb->sense_buffer,
 		       (unsigned char *)&chip->sense_buffer[SCSI_LUN(srb)],
 		       sizeof(struct sense_data_t));
diff --git a/drivers/staging/unisys/include/iochannel.h b/drivers/staging/unisys/include/iochannel.h
index 9ef812c0bc42..810548f469b2 100644
--- a/drivers/staging/unisys/include/iochannel.h
+++ b/drivers/staging/unisys/include/iochannel.h
@@ -34,6 +34,7 @@
 #include <linux/uuid.h>
 #include <linux/skbuff.h>
 #include <linux/visorbus.h>
+#include <scsi/scsi_status.h>
 
 /*
  * Must increment these whenever you insert or delete fields within this channel
@@ -217,7 +218,7 @@ struct uiscmdrsp_scsi {
 	u32 data_dir;
 	struct uisscsi_dest vdest;
 	/* Needed to queue the rsp back to cmd originator. */
-	int linuxstat;
+	union scsi_status linuxstat;
 	u8 scsistat;
 	u8 addlstat;
 #define ADDL_SEL_TIMEOUT 4
diff --git a/drivers/staging/unisys/visorhba/visorhba_main.c b/drivers/staging/unisys/visorhba/visorhba_main.c
index 4455d26f7c96..895bd33a96d6 100644
--- a/drivers/staging/unisys/visorhba/visorhba_main.c
+++ b/drivers/staging/unisys/visorhba/visorhba_main.c
@@ -343,7 +343,7 @@ static int visorhba_abort_handler(struct scsi_cmnd *scsicmd)
 		atomic_set(&vdisk->ios_threshold, IOS_ERROR_THRESHOLD);
 	rtn = forward_taskmgmt_command(TASK_MGMT_ABORT_TASK, scsidev);
 	if (rtn == SUCCESS) {
-		scsicmd->result = DID_ABORT << 16;
+		scsicmd->status.combined = DID_ABORT << 16;
 		scsicmd->scsi_done(scsicmd);
 	}
 	return rtn;
@@ -370,7 +370,7 @@ static int visorhba_device_reset_handler(struct scsi_cmnd *scsicmd)
 		atomic_set(&vdisk->ios_threshold, IOS_ERROR_THRESHOLD);
 	rtn = forward_taskmgmt_command(TASK_MGMT_LUN_RESET, scsidev);
 	if (rtn == SUCCESS) {
-		scsicmd->result = DID_RESET << 16;
+		scsicmd->status.combined = DID_RESET << 16;
 		scsicmd->scsi_done(scsicmd);
 	}
 	return rtn;
@@ -399,7 +399,7 @@ static int visorhba_bus_reset_handler(struct scsi_cmnd *scsicmd)
 	}
 	rtn = forward_taskmgmt_command(TASK_MGMT_BUS_RESET, scsidev);
 	if (rtn == SUCCESS) {
-		scsicmd->result = DID_RESET << 16;
+		scsicmd->status.combined = DID_RESET << 16;
 		scsicmd->scsi_done(scsicmd);
 	}
 	return rtn;
@@ -702,7 +702,7 @@ static void visorhba_serverdown_complete(struct visorhba_devdata *devdata)
 		switch (pendingdel->cmdtype) {
 		case CMD_SCSI_TYPE:
 			scsicmd = pendingdel->sent;
-			scsicmd->result = DID_RESET << 16;
+			scsicmd->status.combined = DID_RESET << 16;
 			if (scsicmd->scsi_done)
 				scsicmd->scsi_done(scsicmd);
 			break;
@@ -864,8 +864,8 @@ static void complete_scsi_command(struct uiscmdrsp *cmdrsp,
 				  struct scsi_cmnd *scsicmd)
 {
 	/* take what we need out of cmdrsp and complete the scsicmd */
-	scsicmd->result = cmdrsp->scsi.linuxstat;
-	if (cmdrsp->scsi.linuxstat)
+	scsicmd->status = cmdrsp->scsi.linuxstat;
+	if (cmdrsp->scsi.linuxstat.combined)
 		do_scsi_linuxstat(cmdrsp, scsicmd);
 	else
 		do_scsi_nolinuxstat(cmdrsp, scsicmd);
