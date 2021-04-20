Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 506E6C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 280416109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbhDTAKa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:30 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:35416 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233156AbhDTAKU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:20 -0400
Received: by mail-pl1-f181.google.com with SMTP id e9so1695641plj.2
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2qvxVa6iVc0a+8az0ddZrswZIYaKQqoWuNMljUhUyXE=;
        b=D/NslOcjXk6iotx/Z/E2gpkly8z+Gev5DX+R9dC8vHuccCu73IKAuOYdrv9FxnbV4k
         /u/VxSvr8UOg0fu0HbFDGX0CFMIFhJGtGsL3gvHPeCZw8oXwT9KF0dit3XHT0D4YgOjs
         lVmRWj0vA9sJmTAnUQ6gHHreIAImkaLiqMOEex8g2XLFz78GUBxkCTCP4MrKOwhaayiN
         pexc7ZmccvGkyUS7z9IKoXYtPFIrowzZwAs7PV98ma/6gW3oVugd6AxKMiwhwrfBZz01
         egxIrDLMjsYPIyfCzaxwFm7WZEYIRrlgSuQVKzvzpLTAcCDw8OkFXCc0RNo7tvUQp9xH
         g/cA==
X-Gm-Message-State: AOAM530lMfW2FUtFI+vlfh51bgJBzqCFaJwqGcIbA+g9x6eHg5y6Qz6J
        bYXTfZ4iY9qqGgaUKhEHi08=
X-Google-Smtp-Source: ABdhPJx4VFVNRKejXBN5yVkwlFt8AW0J+EmnQRcxdGcfATqhivL55wXqpgliijkaUw55EF1qWV+EjA==
X-Received: by 2002:a17:902:6544:b029:ea:f94e:9d4e with SMTP id d4-20020a1709026544b02900eaf94e9d4emr26090035pln.16.1618877389719;
        Mon, 19 Apr 2021 17:09:49 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:49 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH 050/117] fnic: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:38 -0700
Message-Id: <20210420000845.25873-51-bvanassche@acm.org>
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

Cc: Satish Kharat <satishkh@cisco.com>
Cc: Sesidhar Baddela <sebaddel@cisco.com>
Cc: Karan Tilak Kumar <kartilak@cisco.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fnic/fnic_scsi.c | 38 +++++++++++++++++------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index e619a82f921b..9e7afb827f8e 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -447,7 +447,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 	if (!rport) {
 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 				"returning DID_NO_CONNECT for IO as rport is NULL\n");
-		sc->result = DID_NO_CONNECT << 16;
+		sc->status.combined = DID_NO_CONNECT << 16;
 		done(sc);
 		return 0;
 	}
@@ -457,7 +457,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 				"rport is not ready\n");
 		atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
-		sc->result = ret;
+		sc->status.combined = ret;
 		done(sc);
 		return 0;
 	}
@@ -469,7 +469,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 			rport->port_id);
 
 		atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
-		sc->result = DID_NO_CONNECT<<16;
+		sc->status.combined = DID_NO_CONNECT<<16;
 		done(sc);
 		return 0;
 	}
@@ -479,7 +479,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 			"rport 0x%x in state 0x%x, returning DID_IMM_RETRY\n",
 			rport->port_id, rp->rp_state);
 
-		sc->result = DID_IMM_RETRY << 16;
+		sc->status.combined = DID_IMM_RETRY << 16;
 		done(sc);
 		return 0;
 	}
@@ -919,7 +919,7 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 
 	switch (hdr_status) {
 	case FCPIO_SUCCESS:
-		sc->result = (DID_OK << 16) | icmnd_cmpl->scsi_status;
+		sc->status.combined = (DID_OK << 16) | icmnd_cmpl->scsi_status;
 		xfer_len = scsi_bufflen(sc);
 
 		if (icmnd_cmpl->flags & FCPIO_ICMND_CMPL_RESID_UNDER) {
@@ -936,50 +936,50 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 
 	case FCPIO_TIMEOUT:          /* request was timed out */
 		atomic64_inc(&fnic_stats->misc_stats.fcpio_timeout);
-		sc->result = (DID_TIME_OUT << 16) | icmnd_cmpl->scsi_status;
+		sc->status.combined = (DID_TIME_OUT << 16) | icmnd_cmpl->scsi_status;
 		break;
 
 	case FCPIO_ABORTED:          /* request was aborted */
 		atomic64_inc(&fnic_stats->misc_stats.fcpio_aborted);
-		sc->result = (DID_ERROR << 16) | icmnd_cmpl->scsi_status;
+		sc->status.combined = (DID_ERROR << 16) | icmnd_cmpl->scsi_status;
 		break;
 
 	case FCPIO_DATA_CNT_MISMATCH: /* recv/sent more/less data than exp. */
 		atomic64_inc(&fnic_stats->misc_stats.data_count_mismatch);
 		scsi_set_resid(sc, icmnd_cmpl->residual);
-		sc->result = (DID_ERROR << 16) | icmnd_cmpl->scsi_status;
+		sc->status.combined = (DID_ERROR << 16) | icmnd_cmpl->scsi_status;
 		break;
 
 	case FCPIO_OUT_OF_RESOURCE:  /* out of resources to complete request */
 		atomic64_inc(&fnic_stats->fw_stats.fw_out_of_resources);
-		sc->result = (DID_REQUEUE << 16) | icmnd_cmpl->scsi_status;
+		sc->status.combined = (DID_REQUEUE << 16) | icmnd_cmpl->scsi_status;
 		break;
 
 	case FCPIO_IO_NOT_FOUND:     /* requested I/O was not found */
 		atomic64_inc(&fnic_stats->io_stats.io_not_found);
-		sc->result = (DID_ERROR << 16) | icmnd_cmpl->scsi_status;
+		sc->status.combined = (DID_ERROR << 16) | icmnd_cmpl->scsi_status;
 		break;
 
 	case FCPIO_SGL_INVALID:      /* request was aborted due to sgl error */
 		atomic64_inc(&fnic_stats->misc_stats.sgl_invalid);
-		sc->result = (DID_ERROR << 16) | icmnd_cmpl->scsi_status;
+		sc->status.combined = (DID_ERROR << 16) | icmnd_cmpl->scsi_status;
 		break;
 
 	case FCPIO_FW_ERR:           /* request was terminated due fw error */
 		atomic64_inc(&fnic_stats->fw_stats.io_fw_errs);
-		sc->result = (DID_ERROR << 16) | icmnd_cmpl->scsi_status;
+		sc->status.combined = (DID_ERROR << 16) | icmnd_cmpl->scsi_status;
 		break;
 
 	case FCPIO_MSS_INVALID:      /* request was aborted due to mss error */
 		atomic64_inc(&fnic_stats->misc_stats.mss_invalid);
-		sc->result = (DID_ERROR << 16) | icmnd_cmpl->scsi_status;
+		sc->status.combined = (DID_ERROR << 16) | icmnd_cmpl->scsi_status;
 		break;
 
 	case FCPIO_INVALID_HEADER:   /* header contains invalid data */
 	case FCPIO_INVALID_PARAM:    /* some parameter in request invalid */
 	case FCPIO_REQ_NOT_SUPPORTED:/* request type is not supported */
 	default:
-		sc->result = (DID_ERROR << 16) | icmnd_cmpl->scsi_status;
+		sc->status.combined = (DID_ERROR << 16) | icmnd_cmpl->scsi_status;
 		break;
 	}
 
@@ -1188,7 +1188,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 				      "abts cmpl, completing IO\n");
 			CMD_SP(sc) = NULL;
-			sc->result = (DID_ERROR << 16);
+			sc->status.combined = (DID_ERROR << 16);
 
 			spin_unlock_irqrestore(io_lock, flags);
 
@@ -1418,7 +1418,7 @@ static void fnic_cleanup_io(struct fnic *fnic, int exclude_id)
 		fnic_release_ioreq_buf(fnic, io_req, sc);
 		mempool_free(io_req, fnic->io_req_pool);
 
-		sc->result = DID_TRANSPORT_DISRUPTED << 16;
+		sc->status.combined = DID_TRANSPORT_DISRUPTED << 16;
 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 			      "%s: tag:0x%x : sc:0x%p duration = %lu DID_TRANSPORT_DISRUPTED\n",
 			      __func__, sc->request->tag, sc,
@@ -1494,7 +1494,7 @@ void fnic_wq_copy_cleanup_handler(struct vnic_wq_copy *wq,
 	mempool_free(io_req, fnic->io_req_pool);
 
 wq_copy_cleanup_scsi_cmd:
-	sc->result = DID_NO_CONNECT << 16;
+	sc->status.combined = DID_NO_CONNECT << 16;
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, "wq_copy_cleanup_handler:"
 		      " DID_NO_CONNECT\n");
 
@@ -2039,7 +2039,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 
 	if (sc->scsi_done) {
 	/* Call SCSI completion function to complete the IO */
-		sc->result = (DID_ABORT << 16);
+		sc->status.combined = (DID_ABORT << 16);
 		sc->scsi_done(sc);
 		atomic64_dec(&fnic_stats->io_stats.active_ios);
 		if (atomic64_read(&fnic->io_cmpl_skip))
@@ -2272,7 +2272,7 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 		 */
 		if (sc->scsi_done) {
 			/* Set result to let upper SCSI layer retry */
-			sc->result = DID_RESET << 16;
+			sc->status.combined = DID_RESET << 16;
 			sc->scsi_done(sc);
 		}
 	}
