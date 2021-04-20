Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B034C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBC30613AA
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbhDTAK5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:57 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:43548 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233975AbhDTAKi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:38 -0400
Received: by mail-pl1-f177.google.com with SMTP id u15so10124682plf.10
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0msCEhu9ZIztDcdafSO2QdXWUwmOBmuTseKPHJT+qWM=;
        b=XYbiXfiXr+MaPR7s2U+up4OdariDUUDCGW2TW5tdBbkuWxzTzbPLprldjbwV/iQQ60
         1KuWnph6IL+U2VlR/XxjEwTFp3IuXvItittVeBnZsyx5DQ6TofqmQOaD/qmdw41KckhE
         KlKuHYxDwcZeSURp9/z1APg8Ver8SvXaJES3Nu7b5hcC63sitTEVAKxg1WdowlU5fJML
         tTP62DKFRIhRvfZiT78ZjxIAnXUEkt77aZkRHEOfQaejRkQtE2+yNY7fHaN37GIWMK6+
         YeALwLZK2cF0tfOyUODBWuoWCfyiYCNqoBf0KpCG+ih3DWSRgpYedMkwTq9w9pTVhAop
         YJjg==
X-Gm-Message-State: AOAM530+HubWOJV6yfsLV++Aj/A3bKWkuL9R1iLgljYOPcqyyyFzUhIR
        v5s+FS285j1NoSiO9sNdang=
X-Google-Smtp-Source: ABdhPJz2KaOYyBixLEFN+R1KSovVO99GBJi2VMXp3fYxtp4ZXImKufmasyDGubln4/Dvk+SUdbYahg==
X-Received: by 2002:a17:902:ee8a:b029:eb:6d3:1431 with SMTP id a10-20020a170902ee8ab02900eb06d31431mr25962718pld.60.1618877406855;
        Mon, 19 Apr 2021 17:10:06 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        James Smart <james.smart@broadcom.com>
Subject: [PATCH 065/117] lpfc: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:53 -0700
Message-Id: <20210420000845.25873-66-bvanassche@acm.org>
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

Cc: James Smart <james.smart@broadcom.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/lpfc/lpfc_bsg.c  | 114 +++++++++++++++++-----------------
 drivers/scsi/lpfc/lpfc_scsi.c |  66 ++++++++++----------
 2 files changed, 90 insertions(+), 90 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index c2776b88d493..965fa8a1c344 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -373,8 +373,8 @@ lpfc_bsg_send_mgmt_cmd_cmp(struct lpfc_hba *phba,
 	/* Complete the job if the job is still active */
 
 	if (job) {
-		bsg_reply->result = rc;
-		bsg_job_done(job, bsg_reply->result,
+		bsg_reply->status.combined = rc;
+		bsg_job_done(job, bsg_reply->status.combined,
 			       bsg_reply->reply_payload_rcv_len);
 	}
 	return;
@@ -545,7 +545,7 @@ lpfc_bsg_send_mgmt_cmd(struct bsg_job *job)
 	kfree(dd_data);
 no_dd_data:
 	/* make error code available to userspace */
-	bsg_reply->result = rc;
+	bsg_reply->status.combined = rc;
 	job->dd_data = NULL;
 	return rc;
 }
@@ -643,8 +643,8 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
 	/* Complete the job if the job is still active */
 
 	if (job) {
-		bsg_reply->result = rc;
-		bsg_job_done(job, bsg_reply->result,
+		bsg_reply->status.combined = rc;
+		bsg_job_done(job, bsg_reply->status.combined,
 			       bsg_reply->reply_payload_rcv_len);
 	}
 	return;
@@ -782,7 +782,7 @@ lpfc_bsg_rport_els(struct bsg_job *job)
 
 no_dd_data:
 	/* make error code available to userspace */
-	bsg_reply->result = rc;
+	bsg_reply->status.combined = rc;
 	job->dd_data = NULL;
 	return rc;
 }
@@ -1113,11 +1113,11 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			bsg_reply = job->reply;
 			bsg_reply->reply_payload_rcv_len = size;
 			/* make error code available to userspace */
-			bsg_reply->result = 0;
+			bsg_reply->status.combined = 0;
 			job->dd_data = NULL;
 			/* complete the job back to userspace */
 			spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
-			bsg_job_done(job, bsg_reply->result,
+			bsg_job_done(job, bsg_reply->status.combined,
 				       bsg_reply->reply_payload_rcv_len);
 			spin_lock_irqsave(&phba->ct_ev_lock, flags);
 		}
@@ -1340,14 +1340,14 @@ lpfc_bsg_hba_get_event(struct bsg_job *job)
 	lpfc_bsg_event_unref(evt);
 	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 	job->dd_data = NULL;
-	bsg_reply->result = 0;
-	bsg_job_done(job, bsg_reply->result,
+	bsg_reply->status.combined = 0;
+	bsg_job_done(job, bsg_reply->status.combined,
 		       bsg_reply->reply_payload_rcv_len);
 	return 0;
 
 job_error:
 	job->dd_data = NULL;
-	bsg_reply->result = rc;
+	bsg_reply->status.combined = rc;
 	return rc;
 }
 
@@ -1438,8 +1438,8 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *phba,
 	/* Complete the job if the job is still active */
 
 	if (job) {
-		bsg_reply->result = rc;
-		bsg_job_done(job, bsg_reply->result,
+		bsg_reply->status.combined = rc;
+		bsg_job_done(job, bsg_reply->status.combined,
 			       bsg_reply->reply_payload_rcv_len);
 	}
 	return;
@@ -1670,7 +1670,7 @@ lpfc_bsg_send_mgmt_rsp(struct bsg_job *job)
 	kfree(bmp);
 send_mgmt_rsp_exit:
 	/* make error code available to userspace */
-	bsg_reply->result = rc;
+	bsg_reply->status.combined = rc;
 	job->dd_data = NULL;
 	return rc;
 }
@@ -1878,10 +1878,10 @@ lpfc_sli3_bsg_diag_loopback_mode(struct lpfc_hba *phba, struct bsg_job *job)
 
 job_error:
 	/* make error code available to userspace */
-	bsg_reply->result = rc;
+	bsg_reply->status.combined = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
-		bsg_job_done(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->status.combined,
 			       bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
@@ -2243,10 +2243,10 @@ lpfc_sli4_bsg_diag_loopback_mode(struct lpfc_hba *phba, struct bsg_job *job)
 
 job_done:
 	/* make error code available to userspace */
-	bsg_reply->result = rc;
+	bsg_reply->status.combined = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
-		bsg_job_done(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->status.combined,
 			       bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
@@ -2358,10 +2358,10 @@ lpfc_sli4_bsg_diag_mode_end(struct bsg_job *job)
 
 loopback_mode_end_exit:
 	/* make return code available to userspace */
-	bsg_reply->result = rc;
+	bsg_reply->status.combined = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
-		bsg_job_done(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->status.combined,
 			       bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
@@ -2507,10 +2507,10 @@ lpfc_sli4_bsg_link_diag_test(struct bsg_job *job)
 	/* make error code available to userspace */
 	if (rc1 && !rc)
 		rc = rc1;
-	bsg_reply->result = rc;
+	bsg_reply->status.combined = rc;
 	/* complete the job back to userspace if no error */
 	if (rc == 0)
-		bsg_job_done(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->status.combined,
 			       bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
@@ -3369,11 +3369,11 @@ lpfc_bsg_diag_loopback_run(struct bsg_job *job)
 loopback_test_exit:
 	kfree(dataout);
 	/* make error code available to userspace */
-	bsg_reply->result = rc;
+	bsg_reply->status.combined = rc;
 	job->dd_data = NULL;
 	/* complete the job back to userspace if no error */
 	if (rc == IOCB_SUCCESS)
-		bsg_job_done(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->status.combined,
 			       bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
@@ -3414,9 +3414,9 @@ lpfc_bsg_get_dfc_rev(struct bsg_job *job)
 	event_reply->info.a_Major = MANAGEMENT_MAJOR_REV;
 	event_reply->info.a_Minor = MANAGEMENT_MINOR_REV;
 job_error:
-	bsg_reply->result = rc;
+	bsg_reply->status.combined = rc;
 	if (rc == 0)
-		bsg_job_done(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->status.combined,
 			       bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
@@ -3481,8 +3481,8 @@ lpfc_bsg_issue_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 	/* Complete the job if the job is still active */
 
 	if (job) {
-		bsg_reply->result = 0;
-		bsg_job_done(job, bsg_reply->result,
+		bsg_reply->status.combined = 0;
+		bsg_job_done(job, bsg_reply->status.combined,
 			       bsg_reply->reply_payload_rcv_len);
 	}
 	return;
@@ -3671,7 +3671,7 @@ lpfc_bsg_issue_mbox_ext_handle_job(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 					    pmb_buf, size);
 
 		/* result for successful */
-		bsg_reply->result = 0;
+		bsg_reply->status.combined = 0;
 
 		lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
 				"2937 SLI_CONFIG ext-buffer mailbox command "
@@ -3732,7 +3732,7 @@ lpfc_bsg_issue_read_mbox_ext_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 	/* if the job is still active, call job done */
 	if (job) {
 		bsg_reply = job->reply;
-		bsg_job_done(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->status.combined,
 			       bsg_reply->reply_payload_rcv_len);
 	}
 	return;
@@ -3770,7 +3770,7 @@ lpfc_bsg_issue_write_mbox_ext_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 	/* if the job is still active, call job done */
 	if (job) {
 		bsg_reply = job->reply;
-		bsg_job_done(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->status.combined,
 			       bsg_reply->reply_payload_rcv_len);
 	}
 
@@ -4213,8 +4213,8 @@ lpfc_bsg_sli_cfg_write_cmd_ext(struct lpfc_hba *phba, struct bsg_job *job,
 
 	/* wait for additional external buffers */
 
-	bsg_reply->result = 0;
-	bsg_job_done(job, bsg_reply->result,
+	bsg_reply->status.combined = 0;
+	bsg_job_done(job, bsg_reply->status.combined,
 		       bsg_reply->reply_payload_rcv_len);
 	return SLI_CONFIG_HANDLED;
 
@@ -4441,8 +4441,8 @@ lpfc_bsg_read_ebuf_get(struct lpfc_hba *phba, struct bsg_job *job)
 		lpfc_bsg_mbox_ext_session_reset(phba);
 	}
 
-	bsg_reply->result = 0;
-	bsg_job_done(job, bsg_reply->result,
+	bsg_reply->status.combined = 0;
+	bsg_job_done(job, bsg_reply->status.combined,
 		       bsg_reply->reply_payload_rcv_len);
 
 	return SLI_CONFIG_HANDLED;
@@ -4560,8 +4560,8 @@ lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct bsg_job *job,
 	}
 
 	/* wait for additional external buffers */
-	bsg_reply->result = 0;
-	bsg_job_done(job, bsg_reply->result,
+	bsg_reply->status.combined = 0;
+	bsg_job_done(job, bsg_reply->status.combined,
 		       bsg_reply->reply_payload_rcv_len);
 	return SLI_CONFIG_HANDLED;
 
@@ -5030,16 +5030,16 @@ lpfc_bsg_mbox_cmd(struct bsg_job *job)
 
 	if (rc == 0) {
 		/* job done */
-		bsg_reply->result = 0;
+		bsg_reply->status.combined = 0;
 		job->dd_data = NULL;
-		bsg_job_done(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->status.combined,
 			       bsg_reply->reply_payload_rcv_len);
 	} else if (rc == 1)
 		/* job submitted, will complete later*/
 		rc = 0; /* return zero, no error */
 	else {
 		/* some error occurred */
-		bsg_reply->result = rc;
+		bsg_reply->status.combined = rc;
 		job->dd_data = NULL;
 	}
 
@@ -5142,8 +5142,8 @@ lpfc_bsg_menlo_cmd_cmp(struct lpfc_hba *phba,
 	/* Complete the job if active */
 
 	if (job) {
-		bsg_reply->result = rc;
-		bsg_job_done(job, bsg_reply->result,
+		bsg_reply->status.combined = rc;
+		bsg_job_done(job, bsg_reply->status.combined,
 			       bsg_reply->reply_payload_rcv_len);
 	}
 
@@ -5318,7 +5318,7 @@ lpfc_menlo_cmd(struct bsg_job *job)
 	kfree(dd_data);
 no_dd_data:
 	/* make error code available to userspace */
-	bsg_reply->result = rc;
+	bsg_reply->status.combined = rc;
 	job->dd_data = NULL;
 	return rc;
 }
@@ -5358,9 +5358,9 @@ lpfc_forced_link_speed(struct bsg_job *job)
 				   ? LPFC_FORCED_LINK_SPEED_SUPPORTED
 				   : LPFC_FORCED_LINK_SPEED_NOT_SUPPORTED;
 job_error:
-	bsg_reply->result = rc;
+	bsg_reply->status.combined = rc;
 	if (rc == 0)
-		bsg_job_done(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->status.combined,
 			       bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
@@ -5434,11 +5434,11 @@ lpfc_bsg_get_ras_config(struct bsg_job *job)
 
 ras_job_error:
 	/* make error code available to userspace */
-	bsg_reply->result = rc;
+	bsg_reply->status.combined = rc;
 
 	/* complete the job back to userspace */
 	if (!rc)
-		bsg_job_done(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->status.combined,
 			     bsg_reply->reply_payload_rcv_len);
 	return rc;
 }
@@ -5520,11 +5520,11 @@ lpfc_bsg_set_ras_config(struct bsg_job *job)
 	}
 ras_job_error:
 	/* make error code available to userspace */
-	bsg_reply->result = rc;
+	bsg_reply->status.combined = rc;
 
 	/* complete the job back to userspace */
 	if (!rc)
-		bsg_job_done(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->status.combined,
 			     bsg_reply->reply_payload_rcv_len);
 
 	return rc;
@@ -5582,11 +5582,11 @@ lpfc_bsg_get_ras_lwpd(struct bsg_job *job)
 
 ras_job_error:
 	/* make error code available to userspace */
-	bsg_reply->result = rc;
+	bsg_reply->status.combined = rc;
 
 	/* complete the job back to userspace */
 	if (!rc)
-		bsg_job_done(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->status.combined,
 			     bsg_reply->reply_payload_rcv_len);
 
 	return rc;
@@ -5671,9 +5671,9 @@ lpfc_bsg_get_ras_fwlog(struct bsg_job *job)
 	vfree(fwlog_buff);
 
 ras_job_error:
-	bsg_reply->result = rc;
+	bsg_reply->status.combined = rc;
 	if (!rc)
-		bsg_job_done(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->status.combined,
 			     bsg_reply->reply_payload_rcv_len);
 
 	return rc;
@@ -5743,9 +5743,9 @@ lpfc_get_trunk_info(struct bsg_job *job)
 	event_reply->logical_speed =
 				phba->sli4_hba.link_state.logical_speed / 1000;
 job_error:
-	bsg_reply->result = rc;
+	bsg_reply->status.combined = rc;
 	if (!rc)
-		bsg_job_done(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->status.combined,
 			     bsg_reply->reply_payload_rcv_len);
 	return rc;
 
@@ -5817,7 +5817,7 @@ lpfc_bsg_hst_vendor(struct bsg_job *job)
 		rc = -EINVAL;
 		bsg_reply->reply_payload_rcv_len = 0;
 		/* make error code available to userspace */
-		bsg_reply->result = rc;
+		bsg_reply->status.combined = rc;
 		break;
 	}
 
@@ -5851,7 +5851,7 @@ lpfc_bsg_request(struct bsg_job *job)
 		rc = -EINVAL;
 		bsg_reply->reply_payload_rcv_len = 0;
 		/* make error code available to userspace */
-		bsg_reply->result = rc;
+		bsg_reply->status.combined = rc;
 		break;
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 81455b53ef3e..cc356463956f 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -156,7 +156,7 @@ lpfc_update_stats(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd)
 
 	if (!vport->stat_data_enabled ||
 	    vport->stat_data_blocked ||
-	    (cmd->result))
+	    (cmd->status.combined))
 		return;
 
 	latency = jiffies_to_msecs((long)jiffies - (long)lpfc_cmd->start_time);
@@ -2871,7 +2871,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 	if (err_type == BGS_GUARD_ERR_MASK) {
 		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
 					0x10, 0x1);
-		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
+		cmd->status.combined = DRIVER_SENSE << 24 | DID_ABORT << 16 |
 			      SAM_STAT_CHECK_CONDITION;
 		phba->bg_guard_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
@@ -2882,7 +2882,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 	} else if (err_type == BGS_REFTAG_ERR_MASK) {
 		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
 					0x10, 0x3);
-		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
+		cmd->status.combined = DRIVER_SENSE << 24 | DID_ABORT << 16 |
 			      SAM_STAT_CHECK_CONDITION;
 
 		phba->bg_reftag_err_cnt++;
@@ -2894,7 +2894,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 	} else if (err_type == BGS_APPTAG_ERR_MASK) {
 		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
 					0x10, 0x2);
-		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
+		cmd->status.combined = DRIVER_SENSE << 24 | DID_ABORT << 16 |
 			      SAM_STAT_CHECK_CONDITION;
 
 		phba->bg_apptag_err_cnt++;
@@ -2956,7 +2956,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 
 		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
 					0x10, 0x1);
-		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
+		cmd->status.combined = DRIVER_SENSE << 24 | DID_ABORT << 16 |
 			      SAM_STAT_CHECK_CONDITION;
 		phba->bg_guard_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
@@ -2972,7 +2972,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 
 		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
 					0x10, 0x3);
-		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
+		cmd->status.combined = DRIVER_SENSE << 24 | DID_ABORT << 16 |
 			      SAM_STAT_CHECK_CONDITION;
 
 		phba->bg_reftag_err_cnt++;
@@ -2989,7 +2989,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 
 		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
 					0x10, 0x2);
-		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
+		cmd->status.combined = DRIVER_SENSE << 24 | DID_ABORT << 16 |
 			      SAM_STAT_CHECK_CONDITION;
 
 		phba->bg_apptag_err_cnt++;
@@ -3074,7 +3074,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 	uint64_t failing_sector = 0;
 
 	if (lpfc_bgs_get_invalid_prof(bgstat)) {
-		cmd->result = DID_ERROR << 16;
+		cmd->status.combined = DID_ERROR << 16;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9072 BLKGRD: Invalid BG Profile in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
@@ -3086,7 +3086,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 	}
 
 	if (lpfc_bgs_get_uninit_dif_block(bgstat)) {
-		cmd->result = DID_ERROR << 16;
+		cmd->status.combined = DID_ERROR << 16;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9073 BLKGRD: Invalid BG PDIF Block in cmd "
 				"0x%x reftag 0x%x blk cnt 0x%x "
@@ -3102,7 +3102,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 
 		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
 				0x10, 0x1);
-		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
+		cmd->status.combined = DRIVER_SENSE << 24 | DID_ABORT << 16 |
 			      SAM_STAT_CHECK_CONDITION;
 		phba->bg_guard_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
@@ -3118,7 +3118,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 
 		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
 				0x10, 0x3);
-		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
+		cmd->status.combined = DRIVER_SENSE << 24 | DID_ABORT << 16 |
 			      SAM_STAT_CHECK_CONDITION;
 
 		phba->bg_reftag_err_cnt++;
@@ -3135,7 +3135,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 
 		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
 				0x10, 0x2);
-		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
+		cmd->status.combined = DRIVER_SENSE << 24 | DID_ABORT << 16 |
 			      SAM_STAT_CHECK_CONDITION;
 
 		phba->bg_apptag_err_cnt++;
@@ -3741,15 +3741,15 @@ lpfc_send_scsi_error_event(struct lpfc_hba *phba, struct lpfc_vport *vport,
 		return;
 
 	/* If there is queuefull or busy condition send a scsi event */
-	if ((cmnd->result == SAM_STAT_TASK_SET_FULL) ||
-		(cmnd->result == SAM_STAT_BUSY)) {
+	if ((cmnd->status.combined == SAM_STAT_TASK_SET_FULL) ||
+		(cmnd->status.combined == SAM_STAT_BUSY)) {
 		fast_path_evt = lpfc_alloc_fast_evt(phba);
 		if (!fast_path_evt)
 			return;
 		fast_path_evt->un.scsi_evt.event_type =
 			FC_REG_SCSI_EVENT;
 		fast_path_evt->un.scsi_evt.subcategory =
-		(cmnd->result == SAM_STAT_TASK_SET_FULL) ?
+		(cmnd->status.combined == SAM_STAT_TASK_SET_FULL) ?
 		LPFC_EVENT_QFULL : LPFC_EVENT_DEVBSY;
 		fast_path_evt->un.scsi_evt.lun = cmnd->device->lun;
 		memcpy(&fast_path_evt->un.scsi_evt.wwpn,
@@ -4015,7 +4015,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd,
 	}
 
  out:
-	cmnd->result = host_status << 16 | scsi_status;
+	cmnd->status.combined = host_status << 16 | scsi_status;
 	lpfc_send_scsi_error_event(vport->phba, vport, lpfc_cmd, fcpi_parm);
 }
 
@@ -4161,7 +4161,7 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 
 	switch (lpfc_cmd->status) {
 	case IOSTAT_SUCCESS:
-		cmd->result = DID_OK << 16;
+		cmd->status.combined = DID_OK << 16;
 		break;
 	case IOSTAT_FCP_RSP_ERROR:
 		lpfc_handle_fcp_err(vport, lpfc_cmd,
@@ -4170,7 +4170,7 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 		break;
 	case IOSTAT_NPORT_BSY:
 	case IOSTAT_FABRIC_BSY:
-		cmd->result = DID_TRANSPORT_DISRUPTED << 16;
+		cmd->status.combined = DID_TRANSPORT_DISRUPTED << 16;
 		fast_path_evt = lpfc_alloc_fast_evt(phba);
 		if (!fast_path_evt)
 			break;
@@ -4230,14 +4230,14 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 		    lpfc_cmd->result == IOERR_ELXSEC_KEY_UNWRAP_COMPARE_ERROR ||
 		    lpfc_cmd->result == IOERR_ELXSEC_CRYPTO_ERROR ||
 		    lpfc_cmd->result == IOERR_ELXSEC_CRYPTO_COMPARE_ERROR) {
-			cmd->result = DID_NO_CONNECT << 16;
+			cmd->status.combined = DID_NO_CONNECT << 16;
 			break;
 		}
 		if (lpfc_cmd->result == IOERR_INVALID_RPI ||
 		    lpfc_cmd->result == IOERR_NO_RESOURCES ||
 		    lpfc_cmd->result == IOERR_ABORT_REQUESTED ||
 		    lpfc_cmd->result == IOERR_SLER_CMD_RCV_FAILURE) {
-			cmd->result = DID_REQUEUE << 16;
+			cmd->status.combined = DID_REQUEUE << 16;
 			break;
 		}
 		if ((lpfc_cmd->result == IOERR_RX_DMA_FAILED ||
@@ -4276,7 +4276,7 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	default:
 		if (lpfc_cmd->status >= IOSTAT_CNT)
 			lpfc_cmd->status = IOSTAT_DEFAULT;
-		cmd->result = DID_ERROR << 16;
+		cmd->status.combined = DID_ERROR << 16;
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_IOERR,
 				 "9037 FCP Completion Error: xri %x "
 				 "status x%x result x%x [x%x] "
@@ -4286,14 +4286,14 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 				 wcqe->parameter,
 				 wcqe->total_data_placed);
 	}
-	if (cmd->result || lpfc_cmd->fcp_rsp->rspSnsLen) {
+	if (cmd->status.combined || lpfc_cmd->fcp_rsp->rspSnsLen) {
 		u32 *lp = (u32 *)cmd->sense_buffer;
 
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
 				 "9039 Iodone <%d/%llu> cmd x%px, error "
 				 "x%x SNS x%x x%x Data: x%x x%x\n",
 				 cmd->device->id, cmd->device->lun, cmd,
-				 cmd->result, *lp, *(lp + 3), cmd->retries,
+				 cmd->status.combined, *lp, *(lp + 3), cmd->retries,
 				 scsi_get_resid(cmd));
 	}
 
@@ -4471,7 +4471,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 			break;
 		case IOSTAT_NPORT_BSY:
 		case IOSTAT_FABRIC_BSY:
-			cmd->result = DID_TRANSPORT_DISRUPTED << 16;
+			cmd->status.combined = DID_TRANSPORT_DISRUPTED << 16;
 			fast_path_evt = lpfc_alloc_fast_evt(phba);
 			if (!fast_path_evt)
 				break;
@@ -4503,14 +4503,14 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 			    lpfc_cmd->result == IOERR_ELXSEC_KEY_UNWRAP_COMPARE_ERROR ||
 			    lpfc_cmd->result == IOERR_ELXSEC_CRYPTO_ERROR ||
 			    lpfc_cmd->result == IOERR_ELXSEC_CRYPTO_COMPARE_ERROR) {
-				cmd->result = DID_NO_CONNECT << 16;
+				cmd->status.combined = DID_NO_CONNECT << 16;
 				break;
 			}
 			if (lpfc_cmd->result == IOERR_INVALID_RPI ||
 			    lpfc_cmd->result == IOERR_NO_RESOURCES ||
 			    lpfc_cmd->result == IOERR_ABORT_REQUESTED ||
 			    lpfc_cmd->result == IOERR_SLER_CMD_RCV_FAILURE) {
-				cmd->result = DID_REQUEUE << 16;
+				cmd->status.combined = DID_REQUEUE << 16;
 				break;
 			}
 			if ((lpfc_cmd->result == IOERR_RX_DMA_FAILED ||
@@ -4544,24 +4544,24 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 			}
 			fallthrough;
 		default:
-			cmd->result = DID_ERROR << 16;
+			cmd->status.combined = DID_ERROR << 16;
 			break;
 		}
 
 		if (!pnode || (pnode->nlp_state != NLP_STE_MAPPED_NODE))
-			cmd->result = DID_TRANSPORT_DISRUPTED << 16 |
+			cmd->status.combined = DID_TRANSPORT_DISRUPTED << 16 |
 				      SAM_STAT_BUSY;
 	} else
-		cmd->result = DID_OK << 16;
+		cmd->status.combined = DID_OK << 16;
 
-	if (cmd->result || lpfc_cmd->fcp_rsp->rspSnsLen) {
+	if (cmd->status.combined || lpfc_cmd->fcp_rsp->rspSnsLen) {
 		uint32_t *lp = (uint32_t *)cmd->sense_buffer;
 
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
 				 "0710 Iodone <%d/%llu> cmd x%px, error "
 				 "x%x SNS x%x x%x Data: x%x x%x\n",
 				 cmd->device->id, cmd->device->lun, cmd,
-				 cmd->result, *lp, *(lp + 3), cmd->retries,
+				 cmd->status.combined, *lp, *(lp + 3), cmd->retries,
 				 scsi_get_resid(cmd));
 	}
 
@@ -5179,7 +5179,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 
 	err = fc_remote_port_chkready(rport);
 	if (err) {
-		cmnd->result = err;
+		cmnd->status.combined = err;
 		goto out_fail_command;
 	}
 	ndlp = rdata->pnode;
@@ -5286,7 +5286,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 
 	if (unlikely(err)) {
 		if (err == 2) {
-			cmnd->result = DID_ERROR << 16;
+			cmnd->status.combined = DID_ERROR << 16;
 			goto out_fail_command_release_buf;
 		}
 		goto out_host_busy_free_buf;
