Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D47C636D3
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Feb 2023 18:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjBISyD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Feb 2023 13:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbjBISx5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2023 13:53:57 -0500
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C4039B8A
        for <linux-scsi@vger.kernel.org>; Thu,  9 Feb 2023 10:53:56 -0800 (PST)
Received: by mail-pl1-f180.google.com with SMTP id k13so3963607plg.0
        for <linux-scsi@vger.kernel.org>; Thu, 09 Feb 2023 10:53:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BsXYfzx1zFtNXOxMbtvslkoXX8qL5ws0GYag8HKrQqQ=;
        b=BD+3kWznQuJvvnRDu9Cysr7+RxZiB5sSHmNbVwPq8Iy0qnS3UWN7L1DKxx1moIkdPm
         5a2x54fNxrV8HZHjj8NBrgZk6jXppgziopUBbIGSaHDrDiFk1z/S4/u39bVUZMK/fGdm
         DPoxboCS8+ko3O7RfhkvMjItPXKfOIVaa0LgRRdAMvpJXSiag3W34SJmgMExsFDCWFXD
         sYauTZf+6nW6RIO4QRegNzIFgz32Ij2Nnc3pfs4wa3g/HdmvoFhAIJPaZyZH9S0FJeZR
         xMddEUp/Q+ebmJLLRGFTxXBaiBP8118DMVTsOwksAhCZG0ecUwIu3FsbzP9QWfbsmMYx
         01/Q==
X-Gm-Message-State: AO0yUKWLEpvVnOZpfyN6dlRBaGHjwRaoisbAGCZ8sYugcQnIwa9RKaSJ
        T6Ztq5v4ovoDAWQikQ1+DpVzpWe8gY8=
X-Google-Smtp-Source: AK7set/7CBRuw/GjzlZrC9FeLCpRnfEEe39vy/mTVrxkxA2E2mrycLA1RJ32RYRX0HTvEzG2NO36fg==
X-Received: by 2002:a05:6a20:394f:b0:be:a177:af42 with SMTP id r15-20020a056a20394f00b000bea177af42mr15236629pzg.62.1675968835957;
        Thu, 09 Feb 2023 10:53:55 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:15f5:48f5:6861:f3f6])
        by smtp.gmail.com with ESMTPSA id x18-20020a63b212000000b00478162d9923sm1603988pge.13.2023.02.09.10.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 10:53:55 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH v2 3/3] scsi: ufs: Simplify ufshcd_execute_start_stop()
Date:   Thu,  9 Feb 2023 10:53:28 -0800
Message-Id: <20230209185328.2762796-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
In-Reply-To: <20230209185328.2762796-1-bvanassche@acm.org>
References: <20230209185328.2762796-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_execute_cmd() instead of open-coding it.

Cc: Mike Christie <michael.christie@oracle.com>
Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 36 ++++++++----------------------------
 1 file changed, 8 insertions(+), 28 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3512dcc152c8..cb59f6b55cfd 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9125,35 +9125,15 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
 				     enum ufs_dev_pwr_mode pwr_mode,
 				     struct scsi_sense_hdr *sshdr)
 {
-	unsigned char cdb[6] = { START_STOP, 0, 0, 0, pwr_mode << 4, 0 };
-	struct request *req;
-	struct scsi_cmnd *scmd;
-	int ret;
-
-	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN,
-				 BLK_MQ_REQ_PM);
-	if (IS_ERR(req))
-		return PTR_ERR(req);
-
-	scmd = blk_mq_rq_to_pdu(req);
-	scmd->cmd_len = COMMAND_SIZE(cdb[0]);
-	memcpy(scmd->cmnd, cdb, scmd->cmd_len);
-	scmd->allowed = 0/*retries*/;
-	scmd->flags |= SCMD_FAIL_IF_RECOVERING;
-	req->timeout = 1 * HZ;
-	req->rq_flags |= RQF_QUIET;
-	WARN_ON_ONCE(!(req->rq_flags & RQF_PM));
-
-	blk_execute_rq(req, /*at_head=*/true);
-
-	if (sshdr)
-		scsi_normalize_sense(scmd->sense_buffer, scmd->sense_len,
-				     sshdr);
-	ret = scmd->result;
-
-	blk_mq_free_request(req);
+	const unsigned char cdb[6] = { START_STOP, 0, 0, 0, pwr_mode << 4, 0 };
+	const struct scsi_exec_args args = {
+		.sshdr = sshdr,
+		.req_flags = BLK_MQ_REQ_PM,
+		.scmd_flags = SCMD_FAIL_IF_RECOVERING,
+	};
 
-	return ret;
+	return scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, /*buffer=*/NULL,
+			/*bufflen=*/0, /*timeout=*/HZ, /*retries=*/0, &args);
 }
 
 /**
