Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC04C636D4
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Feb 2023 19:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbjBJTdt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Feb 2023 14:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233326AbjBJTdr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2023 14:33:47 -0500
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12407A7DA
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2023 11:33:36 -0800 (PST)
Received: by mail-pj1-f45.google.com with SMTP id rm7-20020a17090b3ec700b0022c05558d22so6473392pjb.5
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2023 11:33:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oNLbUoc1DwNvxadZVXUht7Ag1uof9AiKGaYGg+xiuDc=;
        b=vevs1mDsJQTYi18BRHp32kxluqMwR0rN9rdnIPHTCi2cvNleTqxMUdHWkr/b2SD+y6
         kj3pbejRJ9W5J9tUR8F3lUPUc5u5gpXdtE6DFlyrltfB+se1qApoQVqpqv4aPWyFfjAJ
         /luotb2SSCr/zWq5qfPC/PlHn5UaQ6S7KxwrVGTpykBq19E+TdtvlpTfJ48e7sEdLLOG
         VsHlp2yxunD7xT1Fm7CG16JGQioDiAvVf44a0OBvzjppJelsNZh+/fa7Xs7bkErxNZo6
         DO1JCLBFP9d/cxxWSFJex9Em2z3mDXBHwwhGs4L/1R3BgKEdCRPbnORfFqOxzUQ/HPX+
         hTlQ==
X-Gm-Message-State: AO0yUKUqaZj1gNv4lWZp29aUSfcy40fZZ+SnSCmMag+M+RWEl8qEad9r
        tlDQe/avod0RcABAWbJAoPPqYuJRh7I=
X-Google-Smtp-Source: AK7set8KA+zvdeDo7bPWWPKhr1ouheyg38xx5xQ1BjO9Ys0cvsFBwCWdqBqykPlligFKC12NN1dZjg==
X-Received: by 2002:a17:902:ee4d:b0:198:dbd8:3cd0 with SMTP id 13-20020a170902ee4d00b00198dbd83cd0mr8582569plo.27.1676057616171;
        Fri, 10 Feb 2023 11:33:36 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a834:2664:42:db8b])
        by smtp.gmail.com with ESMTPSA id w9-20020a1709029a8900b0019605d48707sm3718356plp.114.2023.02.10.11.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 11:33:35 -0800 (PST)
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
Subject: [PATCH v3 2/3] scsi: ufs: Rely on the block layer for setting RQF_PM
Date:   Fri, 10 Feb 2023 11:32:57 -0800
Message-Id: <20230210193258.4004923-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
In-Reply-To: <20230210193258.4004923-1-bvanassche@acm.org>
References: <20230210193258.4004923-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Do not set RQF_PM explicitly since scsi_alloc_request() sets it indirectly
if BLK_MQ_REQ_PM is set. The call chain for the code that sets RQF_PM is
as follows:

    scsi_alloc_request()
      blk_mq_alloc_request()
        __blk_mq_alloc_requests()
          blk_mq_rq_ctx_init()
            if (data->flags & BLK_MQ_REQ_PM)
              data->rq_flags |= RQF_PM;

Cc: Mike Christie <michael.christie@oracle.com>
Cc: John Garry <john.g.garry@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0cfe112ff8c3..293933806ffa 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9141,7 +9141,7 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
 	scmd->allowed = 0/*retries*/;
 	scmd->flags |= SCMD_FAIL_IF_RECOVERING;
 	req->timeout = 1 * HZ;
-	req->rq_flags |= RQF_PM | RQF_QUIET;
+	req->rq_flags |= RQF_QUIET;
 
 	blk_execute_rq(req, /*at_head=*/true);
 
