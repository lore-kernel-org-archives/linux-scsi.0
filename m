Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09D38C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D338561363
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbhDTAKT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:19 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:37491 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233156AbhDTAKE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:04 -0400
Received: by mail-pj1-f48.google.com with SMTP id e8-20020a17090a7288b029014e51f5a6baso14331491pjg.2
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZLNuGccprtYmmykrLJH25vip1NQz4ZTS9TdDzbZCUE8=;
        b=X7wWnjyp6ftf5mFJesH3JI3SwNkPw7uyoxA6+citZgmq+PTQI5H5CWBrQBGT8Eak/I
         vnLZoelOZwJ1rUWBpjTnoGM5MmRvtIJwu+0fTmUJGR8MLwYeqGmvSdYX0BMFWIWpT4jg
         PEZ4yqFxYQgmqInSQxfpMx4OZqxkWEpPXVsoelU0K83sU9kWfig2TZJ1WdheOaMD/+Gv
         nH+PxSPKHD3S9fZWo35SyeMAi9ztHjZ8pIzKgF9P7TiVZX8bo2lsnVSjm5VpxHOy+oTw
         6ONv5787Q1Lp6ls9bVcC9orSf46pAPk4Hki70t+ykW3EQB3y2BsQ80z6gO8DM1ZZLLyD
         Smpw==
X-Gm-Message-State: AOAM532CDa1hQP+GayFqYBBFm/z+lW0zp7QN/8NP3clC+wptvv6vhNjY
        rI9+lntSNYFH6Qeb4amFZbc=
X-Google-Smtp-Source: ABdhPJwDbLYaKodYiCfITZNCIEs8xK7oE3M9rpnM7rfTFzffpTgv9FCYl+GdKbmrZ/0ROl+hahqXbw==
X-Received: by 2002:a17:90b:19d3:: with SMTP id nm19mr1798334pjb.140.1618877372630;
        Mon, 19 Apr 2021 17:09:32 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Subject: [PATCH 035/117] bfa: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:23 -0700
Message-Id: <20210420000845.25873-36-bvanassche@acm.org>
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

Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/bfa/bfad_bsg.c | 12 ++++++------
 drivers/scsi/bfa/bfad_im.c  | 30 +++++++++++++++---------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 371856bc67a8..237bed710e03 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3161,16 +3161,16 @@ bfad_im_bsg_vendor_request(struct bsg_job *job)
 	/* Fill the BSG job reply data */
 	job->reply_len = job->reply_payload.payload_len;
 	bsg_reply->reply_payload_rcv_len = job->reply_payload.payload_len;
-	bsg_reply->result = rc;
+	bsg_reply->status.combined = rc;
 
-	bsg_job_done(job, bsg_reply->result,
+	bsg_job_done(job, bsg_reply->status.combined,
 		       bsg_reply->reply_payload_rcv_len);
 	return rc;
 error:
 	/* free the command buffer */
 	kfree(payload_kbuf);
 out:
-	bsg_reply->result = rc;
+	bsg_reply->status.combined = rc;
 	job->reply_len = sizeof(uint32_t);
 	bsg_reply->reply_payload_rcv_len = 0;
 	return rc;
@@ -3538,10 +3538,10 @@ bfad_im_bsg_els_ct_request(struct bsg_job *job)
 	kfree(bsg_fcpt);
 	kfree(drv_fcxp);
 out:
-	bsg_reply->result = rc;
+	bsg_reply->status.combined = rc;
 
 	if (rc == BFA_STATUS_OK)
-		bsg_job_done(job, bsg_reply->result,
+		bsg_job_done(job, bsg_reply->status.combined,
 			       bsg_reply->reply_payload_rcv_len);
 
 	return rc;
@@ -3567,7 +3567,7 @@ bfad_im_bsg_request(struct bsg_job *job)
 		rc = bfad_im_bsg_els_ct_request(job);
 		break;
 	default:
-		bsg_reply->result = rc = -EINVAL;
+		bsg_reply->status.combined = rc = -EINVAL;
 		bsg_reply->reply_payload_rcv_len = 0;
 		break;
 	}
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 6b5841b1c06e..4b8d4cb923ca 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -62,18 +62,18 @@ bfa_cb_ioim_done(void *drv, struct bfad_ioim_s *dio,
 				host_status = DID_ERROR;
 			}
 		}
-		cmnd->result = host_status << 16 | scsi_status;
+		cmnd->status.combined = host_status << 16 | scsi_status;
 
 		break;
 
 	case BFI_IOIM_STS_TIMEDOUT:
-		cmnd->result = DID_TIME_OUT << 16;
+		cmnd->status.combined = DID_TIME_OUT << 16;
 		break;
 	case BFI_IOIM_STS_PATHTOV:
-		cmnd->result = DID_TRANSPORT_DISRUPTED << 16;
+		cmnd->status.combined = DID_TRANSPORT_DISRUPTED << 16;
 		break;
 	default:
-		cmnd->result = DID_ERROR << 16;
+		cmnd->status.combined = DID_ERROR << 16;
 	}
 
 	/* Unmap DMA, if host is NULL, it means a scsi passthru cmd */
@@ -81,16 +81,16 @@ bfa_cb_ioim_done(void *drv, struct bfad_ioim_s *dio,
 		scsi_dma_unmap(cmnd);
 
 	cmnd->host_scribble = NULL;
-	bfa_trc(bfad, cmnd->result);
+	bfa_trc(bfad, cmnd->status.combined);
 
 	itnim_data = cmnd->device->hostdata;
 	if (itnim_data) {
 		itnim = itnim_data->itnim;
-		if (!cmnd->result && itnim &&
+		if (!cmnd->status.combined && itnim &&
 			 (bfa_lun_queue_depth > cmnd->device->queue_depth)) {
 			/* Queue depth adjustment for good status completion */
 			bfad_ramp_up_qdepth(itnim, cmnd->device);
-		} else if (cmnd->result == SAM_STAT_TASK_SET_FULL && itnim) {
+		} else if (cmnd->status.combined == SAM_STAT_TASK_SET_FULL && itnim) {
 			/* qfull handling */
 			bfad_handle_qfull(itnim, cmnd->device);
 		}
@@ -106,7 +106,7 @@ bfa_cb_ioim_good_comp(void *drv, struct bfad_ioim_s *dio)
 	struct bfad_itnim_data_s *itnim_data;
 	struct bfad_itnim_s *itnim;
 
-	cmnd->result = DID_OK << 16 | SAM_STAT_GOOD;
+	cmnd->status.combined = DID_OK << 16 | SAM_STAT_GOOD;
 
 	/* Unmap DMA, if host is NULL, it means a scsi passthru cmd */
 	if (cmnd->device->host != NULL)
@@ -133,13 +133,13 @@ bfa_cb_ioim_abort(void *drv, struct bfad_ioim_s *dio)
 	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
 	struct bfad_s         *bfad = drv;
 
-	cmnd->result = DID_ERROR << 16;
+	cmnd->status.combined = DID_ERROR << 16;
 
 	/* Unmap DMA, if host is NULL, it means a scsi passthru cmd */
 	if (cmnd->device->host != NULL)
 		scsi_dma_unmap(cmnd);
 
-	bfa_trc(bfad, cmnd->result);
+	bfa_trc(bfad, cmnd->status.combined);
 	cmnd->host_scribble = NULL;
 }
 
@@ -1215,16 +1215,16 @@ bfad_im_queuecommand_lck(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd
 
 	rc = fc_remote_port_chkready(rport);
 	if (rc) {
-		cmnd->result = rc;
+		cmnd->status.combined = rc;
 		done(cmnd);
 		return 0;
 	}
 
 	if (bfad->bfad_flags & BFAD_EEH_BUSY) {
 		if (bfad->bfad_flags & BFAD_EEH_PCI_CHANNEL_IO_PERM_FAILURE)
-			cmnd->result = DID_NO_CONNECT << 16;
+			cmnd->status.combined = DID_NO_CONNECT << 16;
 		else
-			cmnd->result = DID_REQUEUE << 16;
+			cmnd->status.combined = DID_REQUEUE << 16;
 		done(cmnd);
 		return 0;
 	}
@@ -1240,14 +1240,14 @@ bfad_im_queuecommand_lck(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd
 		printk(KERN_WARNING
 			"bfad%d, queuecommand %p %x failed, BFA stopped\n",
 		       bfad->inst_no, cmnd, cmnd->cmnd[0]);
-		cmnd->result = DID_NO_CONNECT << 16;
+		cmnd->status.combined = DID_NO_CONNECT << 16;
 		goto out_fail_cmd;
 	}
 
 
 	itnim = itnim_data->itnim;
 	if (!itnim) {
-		cmnd->result = DID_IMM_RETRY << 16;
+		cmnd->status.combined = DID_IMM_RETRY << 16;
 		goto out_fail_cmd;
 	}
 
