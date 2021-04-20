Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A9FFC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DFD3613AA
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbhDTAJ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:09:58 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:39898 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbhDTAJs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:48 -0400
Received: by mail-pj1-f47.google.com with SMTP id ot17-20020a17090b3b51b0290109c9ac3c34so21334826pjb.4
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XwMsKBytId2WdL1rtUGAMNeg9/dFS0GCUaKXfvLDvYw=;
        b=OssqBIzggOBGleJKcb1CDh0yYlW4dsiZOv8g9VR+S2oINxRToSVMWJ4c6dEEBwBVJt
         8rA+a1ztPKJHSTcN6F4rvfyg1mPX+DAif/SEGhxhoKwN+9YqIgJfIpG8hWc1zbN78JuB
         j9lolNyvOW/bQTd1Gu+gnJzlApHZ62Bu2rkhrOMiZz8ZSZMlFGRhDi779/j/kL50O3oa
         v6h+Fzh0CpsdLsKTji3jpeCAsYzOVfhJMlkXRJUCZQ7j3lSAvKJOV0u8QpMx/uZtBqsn
         3qcdGLQi7wfT0JAHRWev+pWOmC+hqIAGfn9zl2Zqdm8T0LjOp2Mbm9pkqq11hn/mFlpB
         B4NQ==
X-Gm-Message-State: AOAM531jMCrw6mpX5qxw1s6hk+OPIw73jtld8cjx+38ZxzaJp3leNNTV
        mMO+g4JqeO/m2ZSTqJUwDJ4=
X-Google-Smtp-Source: ABdhPJxei1dh8rvN6XhYS8wCOPPmL9szIngIrIAxClUACtDGxdZVNAFzh803r0fDvmFbJL6PoQ/hpA==
X-Received: by 2002:a17:90a:cd06:: with SMTP id d6mr1837817pju.91.1618877357850;
        Mon, 19 Apr 2021 17:09:17 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 022/117] NCR5380: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:10 -0700
Message-Id: <20210420000845.25873-23-bvanassche@acm.org>
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

Cc: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/NCR5380.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 2ddbcaa667d1..5efe0e82c195 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -538,7 +538,7 @@ static void complete_cmd(struct Scsi_Host *instance,
 
 	if (hostdata->sensing == cmd) {
 		/* Autosense processing ends here */
-		if (status_byte(cmd->result) != GOOD) {
+		if (status_byte(cmd->status) != GOOD) {
 			scsi_eh_restore_cmnd(cmd, &hostdata->ses);
 		} else {
 			scsi_eh_restore_cmnd(cmd, &hostdata->ses);
@@ -572,13 +572,13 @@ static int NCR5380_queue_command(struct Scsi_Host *instance,
 	case WRITE_6:
 	case WRITE_10:
 		shost_printk(KERN_DEBUG, instance, "WRITE attempted with NDEBUG_NO_WRITE set\n");
-		cmd->result = (DID_ERROR << 16);
+		cmd->status.combined = (DID_ERROR << 16);
 		cmd->scsi_done(cmd);
 		return 0;
 	}
 #endif /* (NDEBUG & NDEBUG_NO_WRITE) */
 
-	cmd->result = 0;
+	cmd->status.combined = 0;
 
 	spin_lock_irqsave(&hostdata->lock, flags);
 
@@ -961,7 +961,7 @@ static irqreturn_t __maybe_unused NCR5380_intr(int irq, void *dev_id)
  * SELECT interrupt will be disabled.
  *
  * If failed (no target) : cmd->scsi_done() will be called, and the
- * cmd->result host byte set to DID_BAD_TARGET.
+ * cmd->status host byte set to DID_BAD_TARGET.
  */
 
 static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
@@ -1154,7 +1154,7 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 		if (!hostdata->selecting)
 			return false;
 
-		cmd->result = DID_BAD_TARGET << 16;
+		cmd->status.combined = DID_BAD_TARGET << 16;
 		complete_cmd(instance, cmd);
 		dsprintk(NDEBUG_SELECTION, instance,
 			"target did not respond within 250ms\n");
@@ -1203,7 +1203,7 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 	NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
 	if (len) {
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		cmd->result = DID_ERROR << 16;
+		cmd->status.combined = DID_ERROR << 16;
 		complete_cmd(instance, cmd);
 		dsprintk(NDEBUG_SELECTION, instance, "IDENTIFY message transfer failed\n");
 		ret = false;
@@ -1743,7 +1743,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				shost_printk(KERN_DEBUG, instance, "NDEBUG_NO_DATAOUT set, attempted DATAOUT aborted\n");
 				sink = 1;
 				do_abort(instance, 0);
-				cmd->result = DID_ERROR << 16;
+				cmd->status.combined = DID_ERROR << 16;
 				complete_cmd(instance, cmd);
 				hostdata->connected = NULL;
 				hostdata->busy[scmd_id(cmd)] &= ~(1 << cmd->device->lun);
@@ -1826,9 +1826,9 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 					hostdata->connected = NULL;
 					hostdata->busy[scmd_id(cmd)] &= ~(1 << cmd->device->lun);
 
-					cmd->result &= ~0xffff;
-					cmd->result |= cmd->SCp.Status;
-					cmd->result |= cmd->SCp.Message << 8;
+					cmd->status.combined &= ~0xffff;
+					cmd->status.combined |= cmd->SCp.Status;
+					cmd->status.combined |= cmd->SCp.Message << 8;
 
 					set_resid_from_SCp(cmd);
 
@@ -1980,7 +1980,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				if (msgout == ABORT) {
 					hostdata->connected = NULL;
 					hostdata->busy[scmd_id(cmd)] &= ~(1 << cmd->device->lun);
-					cmd->result = DID_ERROR << 16;
+					cmd->status.combined = DID_ERROR << 16;
 					complete_cmd(instance, cmd);
 					return;
 				}
@@ -2261,7 +2261,7 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
 	if (list_del_cmd(&hostdata->unissued, cmd)) {
 		dsprintk(NDEBUG_ABORT, instance,
 		         "abort: removed %p from issue queue\n", cmd);
-		cmd->result = DID_ABORT << 16;
+		cmd->status.combined = DID_ABORT << 16;
 		cmd->scsi_done(cmd); /* No tag or busy flag to worry about */
 		goto out;
 	}
@@ -2270,7 +2270,7 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
 		dsprintk(NDEBUG_ABORT, instance,
 		         "abort: cmd %p == selecting\n", cmd);
 		hostdata->selecting = NULL;
-		cmd->result = DID_ABORT << 16;
+		cmd->status.combined = DID_ABORT << 16;
 		complete_cmd(instance, cmd);
 		goto out;
 	}
@@ -2341,7 +2341,7 @@ static void bus_reset_cleanup(struct Scsi_Host *instance)
 	 */
 
 	if (hostdata->selecting) {
-		hostdata->selecting->result = DID_RESET << 16;
+		hostdata->selecting->status.combined = DID_RESET << 16;
 		complete_cmd(instance, hostdata->selecting);
 		hostdata->selecting = NULL;
 	}
@@ -2399,7 +2399,7 @@ static int NCR5380_host_reset(struct scsi_cmnd *cmd)
 	list_for_each_entry(ncmd, &hostdata->unissued, list) {
 		struct scsi_cmnd *scmd = NCR5380_to_scmd(ncmd);
 
-		scmd->result = DID_RESET << 16;
+		scmd->status.combined = DID_RESET << 16;
 		scmd->scsi_done(scmd);
 	}
 	INIT_LIST_HEAD(&hostdata->unissued);
