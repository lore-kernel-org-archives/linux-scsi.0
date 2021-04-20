Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A12EC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 399E061107
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233720AbhDTCPC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:15:02 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:37548 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233645AbhDTCO6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:14:58 -0400
Received: by mail-pj1-f52.google.com with SMTP id e8-20020a17090a7288b029014e51f5a6baso14474059pjg.2
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 19:14:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nHj60OkfvqvhuU2v6Uc5kZaE5/t3aNgn0E5cBViqlPQ=;
        b=bfEvR07cUWfuKmmu2CiF6Me91kkePIcOT1tBy9cO4Vxdfi4vEuHT02uyupOHUCywG8
         Ho0Dx3a0hoaOGkUwhQHXwJF+lH8ZYOoqbKWC+mqmNTkheEY6o3F+MFzjRqr7UACRJYSW
         kFVn0zNi07p63Z1pBcX1Cijc0wgq0T2KxtdVqFIj/i+0g1ZcV9BUFE4xWAKkejhmKvLv
         CCuqH5cMbIQpwjR4cLWDL+Y2l+3kcohTNff/9Ufqy92Oyn1pE4KhUk2+O6HvTr8MZGCp
         4J0XbEIkgWKifiCDpg1eW2WwGj3IzzgfPHVyt61EqbkFeQQprZa2BvjSFgFjQIjD262n
         rv5Q==
X-Gm-Message-State: AOAM533MvjSqXQUu6MNiCiXfaedWbn6BiaDW+h+6JvS24hm/ubwQld7p
        PRo+MIsppCSkj0nF46KLM7E=
X-Google-Smtp-Source: ABdhPJy2UJeh0qCqGD4J3sY+eO3Xk/wrYql0b0yt/2W1KpGmbLRCBa0zsTBp7c5UOqWVck0YhYQTgA==
X-Received: by 2002:a17:902:525:b029:e8:e347:b07f with SMTP id 34-20020a1709020525b02900e8e347b07fmr26290477plf.34.1618884867700;
        Mon, 19 Apr 2021 19:14:27 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id mq2sm630984pjb.24.2021.04.19.19.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:14:27 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 106/117] wd33c93: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 19:13:51 -0700
Message-Id: <20210420021402.27678-16-bvanassche@acm.org>
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

Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/wd33c93.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index a23277bb870e..a4efe6fcb982 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -381,7 +381,7 @@ wd33c93_queuecommand_lck(struct scsi_cmnd *cmd,
  */
 	cmd->host_scribble = NULL;
 	cmd->scsi_done = done;
-	cmd->result = 0;
+	cmd->status.combined = 0;
 
 /* We use the Scsi_Pointer structure that's included with each command
  * as a scratchpad (as it's intended to be used!). The handy thing about
@@ -853,7 +853,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 			hostdata->selecting = NULL;
 		}
 
-		cmd->result = DID_NO_CONNECT << 16;
+		cmd->status.combined = DID_NO_CONNECT << 16;
 		hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xff));
 		hostdata->state = S_UNCONNECTED;
 		cmd->scsi_done(cmd);
@@ -1177,11 +1177,10 @@ wd33c93_intr(struct Scsi_Host *instance)
 				cmd->SCp.Status = lun;
 			if (cmd->cmnd[0] == REQUEST_SENSE
 			    && cmd->SCp.Status != SAM_STAT_GOOD)
-				cmd->result =
-				    (cmd->
-				     result & 0x00ffff) | (DID_ERROR << 16);
+				cmd->status.combined =
+				    (cmd->status.combined & 0x00ffff) | (DID_ERROR << 16);
 			else
-				cmd->result =
+				cmd->status.combined =
 				    cmd->SCp.Status | (cmd->SCp.Message << 8);
 			cmd->scsi_done(cmd);
 
@@ -1263,10 +1262,10 @@ wd33c93_intr(struct Scsi_Host *instance)
 		hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xff));
 		hostdata->state = S_UNCONNECTED;
 		if (cmd->cmnd[0] == REQUEST_SENSE && cmd->SCp.Status != SAM_STAT_GOOD)
-			cmd->result =
-			    (cmd->result & 0x00ffff) | (DID_ERROR << 16);
+			cmd->status.combined =
+			    (cmd->status.combined & 0x00ffff) | (DID_ERROR << 16);
 		else
-			cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
+			cmd->status.combined = cmd->SCp.Status | (cmd->SCp.Message << 8);
 		cmd->scsi_done(cmd);
 
 /* We are no longer connected to a target - check to see if
@@ -1297,11 +1296,10 @@ wd33c93_intr(struct Scsi_Host *instance)
 			DB(DB_INTR, printk(":%d", cmd->SCp.Status))
 			    if (cmd->cmnd[0] == REQUEST_SENSE
 				&& cmd->SCp.Status != SAM_STAT_GOOD)
-				cmd->result =
-				    (cmd->
-				     result & 0x00ffff) | (DID_ERROR << 16);
+				cmd->status.combined =
+				    (cmd->status.combined & 0x00ffff) | (DID_ERROR << 16);
 			else
-				cmd->result =
+				cmd->status.combined =
 				    cmd->SCp.Status | (cmd->SCp.Message << 8);
 			cmd->scsi_done(cmd);
 			break;
@@ -1593,7 +1591,7 @@ wd33c93_host_reset(struct scsi_cmnd * SCpnt)
 	hostdata->outgoing_len = 0;
 
 	reset_wd33c93(instance);
-	SCpnt->result = DID_RESET << 16;
+	SCpnt->status.combined = DID_RESET << 16;
 	enable_irq(instance->irq);
 	spin_unlock_irq(instance->host_lock);
 	return SUCCESS;
@@ -1628,7 +1626,7 @@ wd33c93_abort(struct scsi_cmnd * cmd)
 				hostdata->input_Q =
 				    (struct scsi_cmnd *) cmd->host_scribble;
 			cmd->host_scribble = NULL;
-			cmd->result = DID_ABORT << 16;
+			cmd->status.combined = DID_ABORT << 16;
 			printk
 			    ("scsi%d: Abort - removing command from input_Q. ",
 			     instance->host_no);
@@ -1702,7 +1700,7 @@ wd33c93_abort(struct scsi_cmnd * cmd)
 		hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xff));
 		hostdata->connected = NULL;
 		hostdata->state = S_UNCONNECTED;
-		cmd->result = DID_ABORT << 16;
+		cmd->status.combined = DID_ABORT << 16;
 
 /*      sti();*/
 		wd33c93_execute(instance);
