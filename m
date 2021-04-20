Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F554C43460
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02F9B6109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233225AbhDTAKY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:24 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:39445 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbhDTAKI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:08 -0400
Received: by mail-pg1-f181.google.com with SMTP id s22so4290808pgk.6
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yGpyfe1y9hdi7f1v0mhsqFa9PYwPbUjfmXXPgGJ412U=;
        b=Fx9EZsRi59vBf8GHvF26EUVHBdsmOZtei13gw2VJ1zx2GtdlQZ11OQzkfT9KI8t/Or
         b9u39v/NkiiGJRqbvZVNx5RGlyHQ0TJulX/aNOmsFPEh/eXKO4U33OGKXiHXF9Ax0hdj
         OVwiqwJhtlghFBY0BWAx0hNuhlR6/rqc0c7tTwdnap914LCsl7bYXszEI7OiCqzqvqPE
         uW503o8kRbB2A0v+nNdgNKN+13rDUo3aDyYgDmgvglWHAHR6Xv29j9BEM6KXKP5Kb24B
         gIGJKlnhdSXZ8CdNGGwvzXgoIVYhpnQB5gSwnvom97kCMIS+wwq8fCIOni7P6I4O5XZK
         zxUw==
X-Gm-Message-State: AOAM533Ode7xBaS5efsHlsMhAHI7l/ZPdnJN/VKn37p00AFfenImAT1h
        0TNw4o9gQHYMlKhAArEz+a0=
X-Google-Smtp-Source: ABdhPJxLBV+gkulKQ6zpaWxp9+GKQN5rHrOuOvGyzkWA+gL0aOcRyYAzw6NDx0DCm8gEOctXAsgbWg==
X-Received: by 2002:a63:ff0a:: with SMTP id k10mr14530972pgi.303.1618877377405;
        Mon, 19 Apr 2021 17:09:37 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:36 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Manoj N . Kumar" <manoj@linux.ibm.com>,
        "Matthew R . Ochs" <mrochs@linux.ibm.com>,
        Uma Krishnan <ukrishn@linux.ibm.com>
Subject: [PATCH 039/117] cxlflash: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:27 -0700
Message-Id: <20210420000845.25873-40-bvanassche@acm.org>
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

Cc: Manoj N. Kumar <manoj@linux.ibm.com>
Cc: Matthew R. Ochs <mrochs@linux.ibm.com>
Cc: Uma Krishnan <ukrishn@linux.ibm.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/cxlflash/main.c      | 32 +++++++++++++++----------------
 drivers/scsi/cxlflash/superpipe.c | 16 ++++++++--------
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index dc36531d589e..8c5c28f29911 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -59,7 +59,7 @@ static void process_cmd_err(struct afu_cmd *cmd, struct scsi_cmnd *scp)
 	if (ioasa->rc.flags & SISL_RC_FLAGS_OVERRUN) {
 		dev_dbg(dev, "%s: cmd underrun cmd = %p scp = %p\n",
 			__func__, cmd, scp);
-		scp->result = (DID_ERROR << 16);
+		scp->status.combined = (DID_ERROR << 16);
 	}
 
 	dev_dbg(dev, "%s: cmd failed afu_rc=%02x scsi_rc=%02x fc_rc=%02x "
@@ -72,20 +72,20 @@ static void process_cmd_err(struct afu_cmd *cmd, struct scsi_cmnd *scp)
 		if (ioasa->rc.flags & SISL_RC_FLAGS_SENSE_VALID) {
 			memcpy(scp->sense_buffer, ioasa->sense_data,
 			       SISL_SENSE_DATA_LEN);
-			scp->result = ioasa->rc.scsi_rc;
+			scp->status.combined = ioasa->rc.scsi_rc;
 		} else
-			scp->result = ioasa->rc.scsi_rc | (DID_ERROR << 16);
+			scp->status.combined = ioasa->rc.scsi_rc | (DID_ERROR << 16);
 	}
 
 	/*
-	 * We encountered an error. Set scp->result based on nature
+	 * We encountered an error. Set scp->status based on nature
 	 * of error.
 	 */
 	if (ioasa->rc.fc_rc) {
 		/* We have an FC status */
 		switch (ioasa->rc.fc_rc) {
 		case SISL_FC_RC_LINKDOWN:
-			scp->result = (DID_REQUEUE << 16);
+			scp->status.combined = (DID_REQUEUE << 16);
 			break;
 		case SISL_FC_RC_RESID:
 			/* This indicates an FCP resid underrun */
@@ -95,7 +95,7 @@ static void process_cmd_err(struct afu_cmd *cmd, struct scsi_cmnd *scp)
 				 * If not then we must handle it here.
 				 * This is probably an AFU bug.
 				 */
-				scp->result = (DID_ERROR << 16);
+				scp->status.combined = (DID_ERROR << 16);
 			}
 			break;
 		case SISL_FC_RC_RESIDERR:
@@ -108,7 +108,7 @@ static void process_cmd_err(struct afu_cmd *cmd, struct scsi_cmnd *scp)
 		case SISL_FC_RC_WRABORTPEND:
 		case SISL_FC_RC_NOEXP:
 		case SISL_FC_RC_INUSE:
-			scp->result = (DID_ERROR << 16);
+			scp->status.combined = (DID_ERROR << 16);
 			break;
 		}
 	}
@@ -117,25 +117,25 @@ static void process_cmd_err(struct afu_cmd *cmd, struct scsi_cmnd *scp)
 		/* We have an AFU error */
 		switch (ioasa->rc.afu_rc) {
 		case SISL_AFU_RC_NO_CHANNELS:
-			scp->result = (DID_NO_CONNECT << 16);
+			scp->status.combined = (DID_NO_CONNECT << 16);
 			break;
 		case SISL_AFU_RC_DATA_DMA_ERR:
 			switch (ioasa->afu_extra) {
 			case SISL_AFU_DMA_ERR_PAGE_IN:
 				/* Retry */
-				scp->result = (DID_IMM_RETRY << 16);
+				scp->status.combined = (DID_IMM_RETRY << 16);
 				break;
 			case SISL_AFU_DMA_ERR_INVALID_EA:
 			default:
-				scp->result = (DID_ERROR << 16);
+				scp->status.combined = (DID_ERROR << 16);
 			}
 			break;
 		case SISL_AFU_RC_OUT_OF_DATA_BUFS:
 			/* Retry */
-			scp->result = (DID_ALLOC_FAILURE << 16);
+			scp->status.combined = (DID_ALLOC_FAILURE << 16);
 			break;
 		default:
-			scp->result = (DID_ERROR << 16);
+			scp->status.combined = (DID_ERROR << 16);
 		}
 	}
 }
@@ -167,10 +167,10 @@ static void cmd_complete(struct afu_cmd *cmd)
 		if (unlikely(cmd->sa.ioasc))
 			process_cmd_err(cmd, scp);
 		else
-			scp->result = (DID_OK << 16);
+			scp->status.combined = (DID_OK << 16);
 
 		dev_dbg_ratelimited(dev, "%s:scp=%p result=%08x ioasc=%08x\n",
-				    __func__, scp, scp->result, cmd->sa.ioasc);
+				    __func__, scp, scp->status.combined, cmd->sa.ioasc);
 		scp->scsi_done(scp);
 	} else if (cmd->cmd_tmf) {
 		spin_lock_irqsave(&cfg->tmf_slock, lock_flags);
@@ -204,7 +204,7 @@ static void flush_pending_cmds(struct hwq *hwq)
 
 		if (cmd->scp) {
 			scp = cmd->scp;
-			scp->result = (DID_IMM_RETRY << 16);
+			scp->status.combined = (DID_IMM_RETRY << 16);
 			scp->scsi_done(scp);
 		} else {
 			cmd->cmd_aborted = true;
@@ -600,7 +600,7 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 		goto out;
 	case STATE_FAILTERM:
 		dev_dbg_ratelimited(dev, "%s: device has failed\n", __func__);
-		scp->result = (DID_NO_CONNECT << 16);
+		scp->status.combined = (DID_NO_CONNECT << 16);
 		scp->scsi_done(scp);
 		rc = 0;
 		goto out;
diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index ee11ec340654..4a19a154e237 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -336,7 +336,7 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 	u8 *cmd_buf = NULL;
 	u8 *scsi_cmd = NULL;
 	int rc = 0;
-	int result = 0;
+	union scsi_status result;
 	int retry_cnt = 0;
 	u32 to = CMD_TIMEOUT * HZ;
 
@@ -357,26 +357,26 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 
 	/* Drop the ioctl read semahpore across lengthy call */
 	up_read(&cfg->ioctl_rwsem);
-	result = scsi_execute(sdev, scsi_cmd, DMA_FROM_DEVICE, cmd_buf,
+	result.combined = scsi_execute(sdev, scsi_cmd, DMA_FROM_DEVICE, cmd_buf,
 			      CMD_BUFSIZE, NULL, &sshdr, to, CMD_RETRIES,
 			      0, 0, NULL);
 	down_read(&cfg->ioctl_rwsem);
 	rc = check_state(cfg);
 	if (rc) {
 		dev_err(dev, "%s: Failed state result=%08x\n",
-			__func__, result);
+			__func__, result.combined);
 		rc = -ENODEV;
 		goto out;
 	}
 
 	if (driver_byte(result) == DRIVER_SENSE) {
-		result &= ~(0xFF<<24); /* DRIVER_SENSE is not an error */
-		if (result & SAM_STAT_CHECK_CONDITION) {
+		result.b.driver = DRIVER_OK; /* DRIVER_SENSE is not an error */
+		if (result.b.status & SAM_STAT_CHECK_CONDITION) {
 			switch (sshdr.sense_key) {
 			case NO_SENSE:
 			case RECOVERED_ERROR:
 			case NOT_READY:
-				result &= ~SAM_STAT_CHECK_CONDITION;
+				result.b.status &= ~SAM_STAT_CHECK_CONDITION;
 				break;
 			case UNIT_ATTENTION:
 				switch (sshdr.asc) {
@@ -398,9 +398,9 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 		}
 	}
 
-	if (result) {
+	if (result.combined) {
 		dev_err(dev, "%s: command failed, result=%08x\n",
-			__func__, result);
+			__func__, result.combined);
 		rc = -EIO;
 		goto out;
 	}
