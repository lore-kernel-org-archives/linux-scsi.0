Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12063C636D4
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Feb 2023 19:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbjBJTeC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Feb 2023 14:34:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbjBJTeB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2023 14:34:01 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00E763109
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2023 11:33:46 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id nn4-20020a17090b38c400b00233a6f118d0so3938830pjb.2
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2023 11:33:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ldMhpi7kDZItu84d8Djynn4N63PPrLSrS9wk11Cp5LI=;
        b=5V2uYB2hS9RJTCBtG1I1rLwe2YOvdjP2rWDAmmEs+MRPBtuH+k8v53mW3AFV08Nd1c
         iA3gGzCfDjNsCEM4rv19WH0925v5XbkcZ49zgVySPtDpA/tnsPcSIVMCbU70Zd5WPIaU
         nOWFSEqZZoGKKQsXeskTtWW0lAFoxQnk7dKhJgIPMri41ElQAd7kMfIRygN2LLTu0pF2
         q7VMws3Jr7C5lw7gTLNvPM/TwFQr2bVqd21fyD7/JrnPji3JoGWBMpWf8cKY6XPOD3Gn
         piNJtwkglfgq60ZfwjprzTZygwoUT+d1pLuJI81IS18q06uawCYbI1eVtkn3HfTNJB4O
         U5nw==
X-Gm-Message-State: AO0yUKWibwBdVKAidBPlezhtG4AvYx7LnMuK8IP3Ud8fGL2q2dbvdnQ/
        TuSPsegpHZHRW54a9BjxTLo=
X-Google-Smtp-Source: AK7set9fQe3byqj8YLGYSgx86NytngEhtiISlzJaLDtveNzL2dhu6Gj1Zh1eDNkQqsjf6f125rwwLQ==
X-Received: by 2002:a17:903:283:b0:199:494b:4223 with SMTP id j3-20020a170903028300b00199494b4223mr7683739plr.66.1676057626279;
        Fri, 10 Feb 2023 11:33:46 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a834:2664:42:db8b])
        by smtp.gmail.com with ESMTPSA id w9-20020a1709029a8900b0019605d48707sm3718356plp.114.2023.02.10.11.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 11:33:45 -0800 (PST)
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
Subject: [PATCH v3 3/3] scsi: ufs: Simplify ufshcd_execute_start_stop()
Date:   Fri, 10 Feb 2023 11:32:58 -0800
Message-Id: <20230210193258.4004923-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
In-Reply-To: <20230210193258.4004923-1-bvanassche@acm.org>
References: <20230210193258.4004923-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_execute_cmd() instead of open-coding it.

Cc: Mike Christie <michael.christie@oracle.com>
Cc: John Garry <john.g.garry@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 35 ++++++++---------------------------
 1 file changed, 8 insertions(+), 27 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 293933806ffa..cb59f6b55cfd 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9125,34 +9125,15 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
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
