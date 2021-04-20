Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E420C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3A8861107
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbhDTCPB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:15:01 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:34401 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbhDTCO5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:14:57 -0400
Received: by mail-pj1-f44.google.com with SMTP id em21-20020a17090b0155b029014e204a81e6so509812pjb.1
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 19:14:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=usuHqcxIWUx4j+Tz4TJvO8lNGPhlAbmAsEpFsh44+Hc=;
        b=KRrAkDtHVwY3C5Hv5/3U5RABWM38zvE3cusVpn2UXOvuSDVzh0aeakfqCDiNwhgKIF
         UEO9KRPgRqDY16fjKEC94+7KrEXmmbjr33Ddjy73nnvi/wOpQkFPUm8rAfRSoe2WKk9c
         miVoJMNbrZIGpqRfSX94ybob0Rx26qoh80UiVF2bZCMWVyLnu/R6ODTrNFgFVBBAZOQi
         qP4pNmuHZ5Bc80wGrByuxAK8DRpCGw1clTVZQGOqCCkozjnswjy9dXSSOECNWm81jR9k
         RcTCzlZyrRjipa0FcngbsgZqqxENODIFxRnkgh4PSZgnI/Kzr50RW68cS9cyrfArI/y1
         4Y3A==
X-Gm-Message-State: AOAM533JLu+1ctGd0WcKEsZelWgt6gFy7XbmW3Iu1RB+pX7ccE5TUP2q
        1twt3nEy4dmctapRcM5QCZz9NgTiKqtLwA==
X-Google-Smtp-Source: ABdhPJxUY5GWGKF8ukuUf4Al5nmaHhHzpUebZ3ZbAHPJRFEolmuqoXtwK+kEfkrroLHcmShYVregOg==
X-Received: by 2002:a17:90b:f87:: with SMTP id ft7mr2297690pjb.11.1618884866561;
        Mon, 19 Apr 2021 19:14:26 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id mq2sm630984pjb.24.2021.04.19.19.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:14:25 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        Vishal Bhakta <vbhakta@vmware.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>
Subject: [PATCH 105/117] vmw_pvscsi: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 19:13:50 -0700
Message-Id: <20210420021402.27678-15-bvanassche@acm.org>
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

Cc: Vishal Bhakta <vbhakta@vmware.com>
Cc: VMware PV-Drivers <pv-drivers@vmware.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/vmw_pvscsi.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 8a79605d9652..36473ba06990 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -567,18 +567,18 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
 		return;
 	}
 
-	cmd->result = 0;
+	cmd->status.combined = 0;
 	if (sdstat != SAM_STAT_GOOD &&
 	    (btstat == BTSTAT_SUCCESS ||
 	     btstat == BTSTAT_LINKED_COMMAND_COMPLETED ||
 	     btstat == BTSTAT_LINKED_COMMAND_COMPLETED_WITH_FLAG)) {
 		if (sdstat == SAM_STAT_COMMAND_TERMINATED) {
-			cmd->result = (DID_RESET << 16);
+			cmd->status.combined = (DID_RESET << 16);
 		} else {
-			cmd->result = (DID_OK << 16) | sdstat;
+			cmd->status.combined = (DID_OK << 16) | sdstat;
 			if (sdstat == SAM_STAT_CHECK_CONDITION &&
 			    cmd->sense_buffer)
-				cmd->result |= (DRIVER_SENSE << 24);
+				cmd->status.combined |= (DRIVER_SENSE << 24);
 		}
 	} else
 		switch (btstat) {
@@ -586,25 +586,25 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
 		case BTSTAT_LINKED_COMMAND_COMPLETED:
 		case BTSTAT_LINKED_COMMAND_COMPLETED_WITH_FLAG:
 			/* If everything went fine, let's move on..  */
-			cmd->result = (DID_OK << 16);
+			cmd->status.combined = (DID_OK << 16);
 			break;
 
 		case BTSTAT_DATARUN:
 		case BTSTAT_DATA_UNDERRUN:
 			/* Report residual data in underruns */
 			scsi_set_resid(cmd, scsi_bufflen(cmd) - e->dataLen);
-			cmd->result = (DID_ERROR << 16);
+			cmd->status.combined = (DID_ERROR << 16);
 			break;
 
 		case BTSTAT_SELTIMEO:
 			/* Our emulation returns this for non-connected devs */
-			cmd->result = (DID_BAD_TARGET << 16);
+			cmd->status.combined = (DID_BAD_TARGET << 16);
 			break;
 
 		case BTSTAT_LUNMISMATCH:
 		case BTSTAT_TAGREJECT:
 		case BTSTAT_BADMSG:
-			cmd->result = (DRIVER_INVALID << 24);
+			cmd->status.combined = (DRIVER_INVALID << 24);
 			fallthrough;
 
 		case BTSTAT_HAHARDWARE:
@@ -615,25 +615,25 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
 		case BTSTAT_HASOFTWARE:
 		case BTSTAT_BUSFREE:
 		case BTSTAT_SENSFAILED:
-			cmd->result |= (DID_ERROR << 16);
+			cmd->status.combined |= (DID_ERROR << 16);
 			break;
 
 		case BTSTAT_SENTRST:
 		case BTSTAT_RECVRST:
 		case BTSTAT_BUSRESET:
-			cmd->result = (DID_RESET << 16);
+			cmd->status.combined = (DID_RESET << 16);
 			break;
 
 		case BTSTAT_ABORTQUEUE:
-			cmd->result = (DID_BUS_BUSY << 16);
+			cmd->status.combined = (DID_BUS_BUSY << 16);
 			break;
 
 		case BTSTAT_SCSIPARITY:
-			cmd->result = (DID_PARITY << 16);
+			cmd->status.combined = (DID_PARITY << 16);
 			break;
 
 		default:
-			cmd->result = (DID_ERROR << 16);
+			cmd->status.combined = (DID_ERROR << 16);
 			scmd_printk(KERN_DEBUG, cmd,
 				    "Unknown completion status: 0x%x\n",
 				    btstat);
@@ -641,7 +641,7 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
 
 	dev_dbg(&cmd->device->sdev_gendev,
 		"cmd=%p %x ctx=%p result=0x%x status=0x%x,%x\n",
-		cmd, cmd->cmnd[0], ctx, cmd->result, btstat, sdstat);
+		cmd, cmd->cmnd[0], ctx, cmd->status.combined, btstat, sdstat);
 
 	cmd->scsi_done(cmd);
 }
@@ -859,7 +859,7 @@ static int pvscsi_abort(struct scsi_cmnd *cmd)
 	/*
 	 * Successfully aborted the command.
 	 */
-	cmd->result = (DID_ABORT << 16);
+	cmd->status.combined = (DID_ABORT << 16);
 	cmd->scsi_done(cmd);
 
 out:
@@ -886,7 +886,7 @@ static void pvscsi_reset_all(struct pvscsi_adapter *adapter)
 			pvscsi_unmap_buffers(adapter, ctx);
 			pvscsi_patch_sense(cmd);
 			pvscsi_release_context(adapter, ctx);
-			cmd->result = (DID_RESET << 16);
+			cmd->status.combined = (DID_RESET << 16);
 			cmd->scsi_done(cmd);
 		}
 	}
