Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DDB6C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BC606103B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242404AbhJGUc4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:56 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:33520 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242426AbhJGUcy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:54 -0400
Received: by mail-pf1-f179.google.com with SMTP id s16so6359991pfk.0
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:31:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zzph1uDkPcIcdUP5G5gS+ivy3IN7W172PeUiXwtTCtg=;
        b=SRAY2AvGRFhTpLgbJT8LNU/+UmEqIuRlL3RLr3jedRXSyPeSXdpMkZ6siNZT2I9Muf
         +eq6O0t8AAVYlZbiD5k6X5Rfbsd0fyfEAGHW8NU7fN12lumjq7JD5Bg0LGQcqpyFML/c
         DIhYNcGIamkAjHogg6JeXiHiPNDtr7IxyifGfZ31+/wALbxEA4vOcQTQbr5vQqMKeLxq
         L9+7TJa86USy2yV4KKJbgBR+XpLjfhZnmuW0JXmCCQMfOoqFv3yEwOe/OXZ7odJS+En/
         DZTjMh/NRKxajE5Zs6AFyBYLeW2rLdTi9PU8ekIMgfgJfOybGgETZyv0gTI5kvNC4+H/
         1/rA==
X-Gm-Message-State: AOAM533rHV6D9l3TGzS0GYAa/Iq+FZLoMsY1nB3s9Y5V1PZw75wGylpj
        bOFGGU5UR3NJNFeIJr0XMckJkLSx/Ls=
X-Google-Smtp-Source: ABdhPJw8qcVxttkYYC8cd0MakFsIwYhW/VmVA1KqARS6HMOhmPRiXQSdVqa8PQsrGAJdtA404ceEqQ==
X-Received: by 2002:a63:3586:: with SMTP id c128mr1292010pga.413.1633638660494;
        Thu, 07 Oct 2021 13:31:00 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:59 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 51/88] mpi3mr: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:46 -0700
Message-Id: <20211007202923.2174984-52-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
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
 
