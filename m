Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15C56C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D85486109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbhDTAKv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:51 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:44863 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233882AbhDTAKf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:35 -0400
Received: by mail-pl1-f173.google.com with SMTP id y1so3025452plg.11
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iCbGuv8mM/Bi/sfsK62XvrA5jOalmb9s5iqwNNn8tPg=;
        b=Q/UWUwBgyURLoCbN3BRr9RXFWXRTHbMZVGF+eoDpLryeFEA5+1oM8Tnq5xrdxKenkl
         Q+M/LKaVXPCRAx3gFerBCf6RkWi2i3ABNKexw+I6PLbdSxyJmxmjMXJoUy25raGq6hAp
         iic02csMNER8X0v9S4Q/RzJKL5jcdvdjYjAY70yUN2EzFdd6JLS3jBWNeqfYxjPdn9Yx
         GS3Pw4s8SmJcHOULsAp7PkDO2SDX46w41+LLmGTy4Z3RVLzp9JcIMLQSZpN9IE/CIeQS
         g5HQrhdt3mh3U4cts6obrs6pKWcdbHWnKa2/Z8KV795koQuGH2gTXGWyfkDyxLQ8vFTl
         aeqw==
X-Gm-Message-State: AOAM532rw1URGxBzquXOewNjgBp/8j6KuDTdGkyT7EAWZpXYgT+cAqcw
        ogjnfxfIvaB5z9bWG0krjzo=
X-Google-Smtp-Source: ABdhPJz5Ki4k58uaQ9ajE7b46KH5UUUXZ543BOia6X4O8DgdDbpMCe0PBLmlbFuWlml4Y4rYB+B9vA==
X-Received: by 2002:a17:90b:915:: with SMTP id bo21mr1770118pjb.118.1618877404522;
        Mon, 19 Apr 2021 17:10:04 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 063/117] libfc: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:51 -0700
Message-Id: <20210420000845.25873-64-bvanassche@acm.org>
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
 drivers/scsi/libfc/fc_fcp.c   | 36 +++++++++++++++++------------------
 drivers/scsi/libfc/fc_lport.c |  8 ++++----
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 509eacd7893d..94001fd15f3e 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1869,7 +1869,7 @@ int fc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc_cmd)
 
 	rval = fc_remote_port_chkready(rport);
 	if (rval) {
-		sc_cmd->result = rval;
+		sc_cmd->status.combined = rval;
 		sc_cmd->scsi_done(sc_cmd);
 		return 0;
 	}
@@ -1879,7 +1879,7 @@ int fc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc_cmd)
 		 * rport is transitioning from blocked/deleted to
 		 * online
 		 */
-		sc_cmd->result = DID_IMM_RETRY << 16;
+		sc_cmd->status.combined = DID_IMM_RETRY << 16;
 		sc_cmd->scsi_done(sc_cmd);
 		goto out;
 	}
@@ -1990,7 +1990,7 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 			/*
 			 * good I/O status
 			 */
-			sc_cmd->result = DID_OK << 16;
+			sc_cmd->status.combined = DID_OK << 16;
 			if (fsp->scsi_resid)
 				CMD_RESID_LEN(sc_cmd) = fsp->scsi_resid;
 		} else {
@@ -1998,13 +1998,13 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 			 * transport level I/O was ok but scsi
 			 * has non zero status
 			 */
-			sc_cmd->result = (DID_OK << 16) | fsp->cdb_status;
+			sc_cmd->status.combined = (DID_OK << 16) | fsp->cdb_status;
 		}
 		break;
 	case FC_ERROR:
 		FC_FCP_DBG(fsp, "Returning DID_ERROR to scsi-ml "
 			   "due to FC_ERROR\n");
-		sc_cmd->result = DID_ERROR << 16;
+		sc_cmd->status.combined = DID_ERROR << 16;
 		break;
 	case FC_DATA_UNDRUN:
 		if ((fsp->cdb_status == 0) && !(fsp->req_flags & FC_SRB_READ)) {
@@ -2013,11 +2013,11 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 			 * underrun.
 			 */
 			if (fsp->state & FC_SRB_RCV_STATUS) {
-				sc_cmd->result = DID_OK << 16;
+				sc_cmd->status.combined = DID_OK << 16;
 			} else {
 				FC_FCP_DBG(fsp, "Returning DID_ERROR to scsi-ml"
 					   " due to FC_DATA_UNDRUN (trans)\n");
-				sc_cmd->result = DID_ERROR << 16;
+				sc_cmd->status.combined = DID_ERROR << 16;
 			}
 		} else {
 			/*
@@ -2026,7 +2026,7 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 			FC_FCP_DBG(fsp, "Returning DID_ERROR to scsi-ml "
 				   "due to FC_DATA_UNDRUN (scsi)\n");
 			CMD_RESID_LEN(sc_cmd) = fsp->scsi_resid;
-			sc_cmd->result = (DID_ERROR << 16) | fsp->cdb_status;
+			sc_cmd->status.combined = (DID_ERROR << 16) | fsp->cdb_status;
 		}
 		break;
 	case FC_DATA_OVRRUN:
@@ -2035,10 +2035,10 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 		 */
 		FC_FCP_DBG(fsp, "Returning DID_ERROR to scsi-ml "
 			   "due to FC_DATA_OVRRUN\n");
-		sc_cmd->result = (DID_ERROR << 16) | fsp->cdb_status;
+		sc_cmd->status.combined = (DID_ERROR << 16) | fsp->cdb_status;
 		break;
 	case FC_CMD_ABORTED:
-		if (host_byte(sc_cmd->result) == DID_TIME_OUT)
+		if (host_byte(sc_cmd->status) == DID_TIME_OUT)
 			FC_FCP_DBG(fsp, "Returning DID_TIME_OUT to scsi-ml "
 				   "due to FC_CMD_ABORTED\n");
 		else {
@@ -2046,42 +2046,42 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 				   "due to FC_CMD_ABORTED\n");
 			set_host_byte(sc_cmd, DID_ERROR);
 		}
-		sc_cmd->result |= fsp->io_status;
+		sc_cmd->status.combined |= fsp->io_status;
 		break;
 	case FC_CMD_RESET:
 		FC_FCP_DBG(fsp, "Returning DID_RESET to scsi-ml "
 			   "due to FC_CMD_RESET\n");
-		sc_cmd->result = (DID_RESET << 16);
+		sc_cmd->status.combined = (DID_RESET << 16);
 		break;
 	case FC_TRANS_RESET:
 		FC_FCP_DBG(fsp, "Returning DID_SOFT_ERROR to scsi-ml "
 			   "due to FC_TRANS_RESET\n");
-		sc_cmd->result = (DID_SOFT_ERROR << 16);
+		sc_cmd->status.combined = (DID_SOFT_ERROR << 16);
 		break;
 	case FC_HRD_ERROR:
 		FC_FCP_DBG(fsp, "Returning DID_NO_CONNECT to scsi-ml "
 			   "due to FC_HRD_ERROR\n");
-		sc_cmd->result = (DID_NO_CONNECT << 16);
+		sc_cmd->status.combined = (DID_NO_CONNECT << 16);
 		break;
 	case FC_CRC_ERROR:
 		FC_FCP_DBG(fsp, "Returning DID_PARITY to scsi-ml "
 			   "due to FC_CRC_ERROR\n");
-		sc_cmd->result = (DID_PARITY << 16);
+		sc_cmd->status.combined = (DID_PARITY << 16);
 		break;
 	case FC_TIMED_OUT:
 		FC_FCP_DBG(fsp, "Returning DID_BUS_BUSY to scsi-ml "
 			   "due to FC_TIMED_OUT\n");
-		sc_cmd->result = (DID_BUS_BUSY << 16) | fsp->io_status;
+		sc_cmd->status.combined = (DID_BUS_BUSY << 16) | fsp->io_status;
 		break;
 	default:
 		FC_FCP_DBG(fsp, "Returning DID_ERROR to scsi-ml "
 			   "due to unknown error\n");
-		sc_cmd->result = (DID_ERROR << 16);
+		sc_cmd->status.combined = (DID_ERROR << 16);
 		break;
 	}
 
 	if (lport->state != LPORT_ST_READY && fsp->status_code != FC_COMPLETE)
-		sc_cmd->result = (DID_TRANSPORT_DISRUPTED << 16);
+		sc_cmd->status.combined = (DID_TRANSPORT_DISRUPTED << 16);
 
 	spin_lock_irqsave(&si->scsi_queue_lock, flags);
 	list_del(&fsp->list);
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index cf36c8cb5493..855bb084336d 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1883,10 +1883,10 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
 	void *buf;
 
 	if (IS_ERR(fp)) {
-		bsg_reply->result = (PTR_ERR(fp) == -FC_EX_CLOSED) ?
+		bsg_reply->status.combined = (PTR_ERR(fp) == -FC_EX_CLOSED) ?
 			-ECONNABORTED : -ETIMEDOUT;
 		job->reply_len = sizeof(uint32_t);
-		bsg_job_done(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->status.combined,
 			       bsg_reply->reply_payload_rcv_len);
 		kfree(info);
 		return;
@@ -1920,8 +1920,8 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
 		    job->reply_payload.payload_len)
 			bsg_reply->reply_payload_rcv_len =
 				job->reply_payload.payload_len;
-		bsg_reply->result = 0;
-		bsg_job_done(job, bsg_reply->result,
+		bsg_reply->status.combined = 0;
+		bsg_job_done(job, bsg_reply->status.combined,
 			       bsg_reply->reply_payload_rcv_len);
 		kfree(info);
 	}
