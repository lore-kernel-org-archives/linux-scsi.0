Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 670EFC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 513CE60F48
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344360AbhIRAJO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:09:14 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:38728 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344221AbhIRAJD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:03 -0400
Received: by mail-pj1-f41.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so11129842pjc.3
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zzph1uDkPcIcdUP5G5gS+ivy3IN7W172PeUiXwtTCtg=;
        b=7L/Ilrg/QvTe1gO/0pBXutuWrJBLgcq/PfZRyhx4Z2XYMJiDvdtrUhue6TM3ZHA4kb
         ab6kqMjS2uvA2awYQPf47yvHSaXihrI8i17upfHLUVYTTVr3+DF0CPvhceyuGbYkdUT2
         XCCcL3S6fjtqZGhzlI82hbbcnaGadVzMcUXubd4qeWXuAqGLSbOCixMr9AP00GSMGpR2
         VN18G/zlsAbI5pyG1etCYLOei8RQicxOLJbJQ1b+hBBRv0fqFdwxBXGTpGaUeEgw9inA
         cvwPV8UGV1Y9upts49zBr66++bhnBG2hmZBu8Nwr4ESxHosDXfEvS7Um0Xy7lOiRj5QV
         U/MQ==
X-Gm-Message-State: AOAM530ERBi//6gkWUbap3A5TL6/pFPsF6I9LqTZkIhjGfNGG7y/LiU6
        L4L3aIP53koBK40rjNDDXl0=
X-Google-Smtp-Source: ABdhPJx/jtKal5Xk+XFW0IwTR9H58pdhlp+jbC9OsV9pdg20T1gLysS/DEqRvDzJfOz7vhMIrEYVWQ==
X-Received: by 2002:a17:90a:6b01:: with SMTP id v1mr20200247pjj.6.1631923660585;
        Fri, 17 Sep 2021 17:07:40 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:40 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 51/84] mpi3mr: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:34 -0700
Message-Id: <20210918000607.450448-52-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 2197988333fe..6373a877f439 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -409,7 +409,7 @@ static bool mpi3mr_flush_scmd(struct request *rq,
 		scsi_dma_unmap(scmd);
 		scmd->result = DID_RESET << 16;
 		scsi_print_command(scmd);
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		mrioc->flush_io_count++;
 	}
 
@@ -2312,7 +2312,7 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
 	}
 	mpi3mr_clear_scmd_priv(mrioc, scmd);
 	scsi_dma_unmap(scmd);
-	scmd->scsi_done(scmd);
+	scsi_done(scmd);
 out:
 	if (sense_buf)
 		mpi3mr_repost_sense_buf(mrioc,
@@ -3322,7 +3322,7 @@ static bool mpi3mr_check_return_unmap(struct mpi3mr_ioc *mrioc,
 		    __func__);
 		scsi_print_command(scmd);
 		scmd->result = DID_OK << 16;
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		return true;
 	}
 
@@ -3334,7 +3334,7 @@ static bool mpi3mr_check_return_unmap(struct mpi3mr_ioc *mrioc,
 		scmd->result = SAM_STAT_CHECK_CONDITION;
 		scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
 		    0x1A, 0);
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		return true;
 	}
 	if (param_len != scsi_bufflen(scmd)) {
@@ -3345,7 +3345,7 @@ static bool mpi3mr_check_return_unmap(struct mpi3mr_ioc *mrioc,
 		scmd->result = SAM_STAT_CHECK_CONDITION;
 		scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
 		    0x1A, 0);
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		return true;
 	}
 	buf = kzalloc(scsi_bufflen(scmd), GFP_ATOMIC);
@@ -3354,7 +3354,7 @@ static bool mpi3mr_check_return_unmap(struct mpi3mr_ioc *mrioc,
 		scmd->result = SAM_STAT_CHECK_CONDITION;
 		scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
 		    0x55, 0x03);
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		return true;
 	}
 	scsi_sg_copy_to_buffer(scmd, buf, scsi_bufflen(scmd));
@@ -3368,7 +3368,7 @@ static bool mpi3mr_check_return_unmap(struct mpi3mr_ioc *mrioc,
 		scmd->result = SAM_STAT_CHECK_CONDITION;
 		scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
 		    0x26, 0);
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		kfree(buf);
 		return true;
 	}
@@ -3438,14 +3438,14 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
 	sdev_priv_data = scmd->device->hostdata;
 	if (!sdev_priv_data || !sdev_priv_data->tgt_priv_data) {
 		scmd->result = DID_NO_CONNECT << 16;
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		goto out;
 	}
 
 	if (mrioc->stop_drv_processing &&
 	    !(mpi3mr_allow_scmd_to_fw(scmd))) {
 		scmd->result = DID_NO_CONNECT << 16;
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		goto out;
 	}
 
@@ -3459,19 +3459,19 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
 	dev_handle = stgt_priv_data->dev_handle;
 	if (dev_handle == MPI3MR_INVALID_DEV_HANDLE) {
 		scmd->result = DID_NO_CONNECT << 16;
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		goto out;
 	}
 	if (stgt_priv_data->dev_removed) {
 		scmd->result = DID_NO_CONNECT << 16;
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		goto out;
 	}
 
 	if (atomic_read(&stgt_priv_data->block_io)) {
 		if (mrioc->stop_drv_processing) {
 			scmd->result = DID_NO_CONNECT << 16;
-			scmd->scsi_done(scmd);
+			scsi_done(scmd);
 			goto out;
 		}
 		retval = SCSI_MLQUEUE_DEVICE_BUSY;
@@ -3486,7 +3486,7 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
 	host_tag = mpi3mr_host_tag_for_scmd(mrioc, scmd);
 	if (host_tag == MPI3MR_HOSTTAG_INVALID) {
 		scmd->result = DID_ERROR << 16;
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		goto out;
 	}
 
