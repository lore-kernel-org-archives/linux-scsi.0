Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CFF3C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 036BE60FC2
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347167AbhI2WJX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:23 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:37423 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347137AbhI2WJU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:20 -0400
Received: by mail-pl1-f179.google.com with SMTP id j4so1053026plx.4
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zzph1uDkPcIcdUP5G5gS+ivy3IN7W172PeUiXwtTCtg=;
        b=2MLRy6eG2AKGw+Odetxiaq14XEwPBnmBnE3H0CH9DcgpwWuO4rcYsH+6FWh1wsCT5V
         mX7KdcURLuGfCfBwgYcvZbi99njY7pJCH9E6V9GpQmoXY6laCDHNhmCDzHw01YNI3gXK
         RSP3yA1SlXrY48mruagXX8+aSsyaqOun9/wV/JT3V4Lk50T0A1SZNtzMz0hpQCpPhBWN
         bpsJqneP6Hs4/32e8OGJLGDsxiQs0aWb2CG8Eb+o/lnP7n5j6rUoE2zPk6wHyXsYlJEO
         MtvwX8fTwKBT2wWM9lxCUw3eWELIsOzJimQl8w58mE8FTjgxNeo6EAMhwAFiKsstBU6/
         p7dw==
X-Gm-Message-State: AOAM532oN8s/sGuOk4MEizge68wP9Yyio0X5eF0jHohpWKnqJGUBUaqm
        Kvxc9M9VND9dZXPbao6xsuk=
X-Google-Smtp-Source: ABdhPJx0nITAIx0CPOt9MgKSsVJfwBI4rqggYz+PeEIWleUuRyUPqlDPZ1yK1mZXHsRnaB4ZvcCwBA==
X-Received: by 2002:a17:902:8a8c:b0:13e:45bc:e9a9 with SMTP id p12-20020a1709028a8c00b0013e45bce9a9mr931046plo.11.1632953258214;
        Wed, 29 Sep 2021 15:07:38 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 51/84] mpi3mr: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:27 -0700
Message-Id: <20210929220600.3509089-52-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
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
 
