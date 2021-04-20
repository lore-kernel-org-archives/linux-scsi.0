Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57BDCC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 362CD6109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233876AbhDTAKu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:50 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:42711 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbhDTAKe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:34 -0400
Received: by mail-pl1-f174.google.com with SMTP id v13so5082833ple.9
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HTguomwyGGvp07rauCYYrFmDbqB59oC0wWZ5Au503FE=;
        b=d7iwScbtypTT+g+2vgCZlhUJD6md7rcGt5+CLxYYBr6gYFWyKcAiCsUNRazffrz/WY
         DsMrx/GgAKpRDnEAnBvp9AUR2n1PBX9GvDbesZxZTSA02kQnpvoPWaFqdGepSjew1BRw
         C28Qb3sw2wI13gUGFrBKnMNuqbqrUJY41bQGz4uJxJ2EPfekIgWisv1FhIwm0VRJwmG6
         N6sOM80tywhxqbU7brj5DjmSnz+I2tG6WTDs1jn9+13yJhQyAfYWOssmAP0QGu0OEtiQ
         H5ET9gQPrSBuP+NpXMdP9Nvevoq+5PZxFBujUlsA4GD5hyp51SRAa5+07d5fKbFI3Gdd
         029Q==
X-Gm-Message-State: AOAM531+6PeCQt6WtO/F0EYyuayWBRnktCVthCJeXDchsMExMBQWbz7H
        eF+V3fjIovOyZSEEu9hVPCU=
X-Google-Smtp-Source: ABdhPJyIc10y1NVGnScnpE6HVBsNAOgDoB+zhe795Ea9hcHpA++atcfCLif9k+ptyCn+4dclug8kGg==
X-Received: by 2002:a17:90b:19ca:: with SMTP id nm10mr1805603pjb.175.1618877403291;
        Mon, 19 Apr 2021 17:10:03 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:02 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Lee Duncan <lduncan@suse.com>
Subject: [PATCH 062/117] iscsi: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:50 -0700
Message-Id: <20210420000845.25873-63-bvanassche@acm.org>
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

Cc: Lee Duncan <lduncan@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/libiscsi.c             | 46 ++++++++++++++---------------
 drivers/scsi/scsi_transport_iscsi.c |  2 +-
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 4b8c9b9cf927..6bd81501fa55 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -616,7 +616,7 @@ static void fail_scsi_task(struct iscsi_task *task, enum host_status err)
 		state = ISCSI_TASK_ABRT_TMF;
 
 	sc = task->sc;
-	sc->result = err << 16;
+	sc->status.combined = err << 16;
 	scsi_set_resid(sc, scsi_bufflen(sc));
 	iscsi_complete_task(task, state);
 	spin_unlock_bh(&conn->session->back_lock);
@@ -814,7 +814,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	iscsi_update_cmdsn(session, (struct iscsi_nopin*)rhdr);
 	conn->exp_statsn = be32_to_cpu(rhdr->statsn) + 1;
 
-	sc->result = (DID_OK << 16) | rhdr->cmd_status;
+	sc->status.combined = (DID_OK << 16) | rhdr->cmd_status;
 
 	if (task->protected) {
 		sector_t sector;
@@ -829,7 +829,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 
 		ascq = session->tt->check_protection(task, &sector);
 		if (ascq) {
-			sc->result = DRIVER_SENSE << 24 |
+			sc->status.combined = DRIVER_SENSE << 24 |
 				     SAM_STAT_CHECK_CONDITION;
 			scsi_build_sense_buffer(1, sc->sense_buffer,
 						ILLEGAL_REQUEST, 0x10, ascq);
@@ -841,7 +841,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	}
 
 	if (rhdr->response != ISCSI_STATUS_CMD_COMPLETED) {
-		sc->result = DID_ERROR << 16;
+		sc->status.combined = DID_ERROR << 16;
 		goto out;
 	}
 
@@ -853,7 +853,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			iscsi_conn_printk(KERN_ERR,  conn,
 					 "Got CHECK_CONDITION but invalid data "
 					 "buffer size of %d\n", datalen);
-			sc->result = DID_BAD_TARGET << 16;
+			sc->status.combined = DID_BAD_TARGET << 16;
 			goto out;
 		}
 
@@ -870,7 +870,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 
 	if (rhdr->flags & (ISCSI_FLAG_CMD_BIDI_UNDERFLOW |
 			   ISCSI_FLAG_CMD_BIDI_OVERFLOW)) {
-		sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
+		sc->status.combined = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
 	}
 
 	if (rhdr->flags & (ISCSI_FLAG_CMD_UNDERFLOW |
@@ -883,11 +883,11 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			/* write side for bidi or uni-io set_resid */
 			scsi_set_resid(sc, res_count);
 		else
-			sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
+			sc->status.combined = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
 	}
 out:
 	ISCSI_DBG_SESSION(session, "cmd rsp done [sc %p res %d itt 0x%x]\n",
-			  sc, sc->result, task->itt);
+			  sc, sc->status.combined, task->itt);
 	conn->scsirsp_pdus_cnt++;
 	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
 }
@@ -912,7 +912,7 @@ iscsi_data_in_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		return;
 
 	iscsi_update_cmdsn(conn->session, (struct iscsi_nopin *)hdr);
-	sc->result = (DID_OK << 16) | rhdr->cmd_status;
+	sc->status.combined = (DID_OK << 16) | rhdr->cmd_status;
 	conn->exp_statsn = be32_to_cpu(rhdr->statsn) + 1;
 	if (rhdr->flags & (ISCSI_FLAG_DATA_UNDERFLOW |
 	                   ISCSI_FLAG_DATA_OVERFLOW)) {
@@ -923,12 +923,12 @@ iscsi_data_in_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		     res_count <= sc->sdb.length))
 			scsi_set_resid(sc, res_count);
 		else
-			sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
+			sc->status.combined = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
 	}
 
 	ISCSI_DBG_SESSION(conn->session, "data in with status done "
 			  "[sc %p res %d itt 0x%x]\n",
-			  sc, sc->result, task->itt);
+			  sc, sc->status.combined, task->itt);
 	conn->scsirsp_pdus_cnt++;
 	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
 }
@@ -1678,7 +1678,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 	struct iscsi_conn *conn;
 	struct iscsi_task *task = NULL;
 
-	sc->result = 0;
+	sc->status.combined = 0;
 	sc->SCp.ptr = NULL;
 
 	ihost = shost_priv(host);
@@ -1689,7 +1689,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 
 	reason = iscsi_session_chkready(cls_session);
 	if (reason) {
-		sc->result = reason;
+		sc->status.combined = reason;
 		goto fault;
 	}
 
@@ -1708,29 +1708,29 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 			 */
 			if (unlikely(system_state != SYSTEM_RUNNING)) {
 				reason = FAILURE_SESSION_FAILED;
-				sc->result = DID_NO_CONNECT << 16;
+				sc->status.combined = DID_NO_CONNECT << 16;
 				break;
 			}
 			fallthrough;
 		case ISCSI_STATE_IN_RECOVERY:
 			reason = FAILURE_SESSION_IN_RECOVERY;
-			sc->result = DID_IMM_RETRY << 16;
+			sc->status.combined = DID_IMM_RETRY << 16;
 			break;
 		case ISCSI_STATE_LOGGING_OUT:
 			reason = FAILURE_SESSION_LOGGING_OUT;
-			sc->result = DID_IMM_RETRY << 16;
+			sc->status.combined = DID_IMM_RETRY << 16;
 			break;
 		case ISCSI_STATE_RECOVERY_FAILED:
 			reason = FAILURE_SESSION_RECOVERY_TIMEOUT;
-			sc->result = DID_TRANSPORT_FAILFAST << 16;
+			sc->status.combined = DID_TRANSPORT_FAILFAST << 16;
 			break;
 		case ISCSI_STATE_TERMINATE:
 			reason = FAILURE_SESSION_TERMINATE;
-			sc->result = DID_NO_CONNECT << 16;
+			sc->status.combined = DID_NO_CONNECT << 16;
 			break;
 		default:
 			reason = FAILURE_SESSION_FREED;
-			sc->result = DID_NO_CONNECT << 16;
+			sc->status.combined = DID_NO_CONNECT << 16;
 		}
 		goto fault;
 	}
@@ -1738,13 +1738,13 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 	conn = session->leadconn;
 	if (!conn) {
 		reason = FAILURE_SESSION_FREED;
-		sc->result = DID_NO_CONNECT << 16;
+		sc->status.combined = DID_NO_CONNECT << 16;
 		goto fault;
 	}
 
 	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
 		reason = FAILURE_SESSION_IN_RECOVERY;
-		sc->result = DID_REQUEUE << 16;
+		sc->status.combined = DID_REQUEUE << 16;
 		goto fault;
 	}
 
@@ -1766,7 +1766,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 				reason = FAILURE_OOM;
 				goto prepd_reject;
 			} else {
-				sc->result = DID_ABORT << 16;
+				sc->status.combined = DID_ABORT << 16;
 				goto prepd_fault;
 			}
 		}
@@ -2017,7 +2017,7 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 		 * upper layer to deal with the result.
 		 */
 		if (unlikely(system_state != SYSTEM_RUNNING)) {
-			sc->result = DID_NO_CONNECT << 16;
+			sc->status.combined = DID_NO_CONNECT << 16;
 			ISCSI_DBG_EH(session, "sc on shutdown, handled\n");
 			rc = BLK_EH_DONE;
 			goto done;
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 4f821118ea23..b34155d285be 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1534,7 +1534,7 @@ static int iscsi_bsg_host_dispatch(struct bsg_job *job)
 	/* return the errno failure code as the only status */
 	BUG_ON(job->reply_len < sizeof(uint32_t));
 	reply->reply_payload_rcv_len = 0;
-	reply->result = ret;
+	reply->status.combined = ret;
 	job->reply_len = sizeof(uint32_t);
 	bsg_job_done(job, ret, 0);
 	return 0;
