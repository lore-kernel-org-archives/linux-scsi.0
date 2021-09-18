Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5F92C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DC4961179
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242793AbhIRAHr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:07:47 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:33364 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242416AbhIRAHp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:07:45 -0400
Received: by mail-pl1-f180.google.com with SMTP id t4so7273920plo.0
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:06:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Mg3T+99vJDGFQS38jEjRvUdcAMlxVj1hvtWz+HZhgU=;
        b=rarUwOTdmhAiD/MTcRsTfA4PPO6zVtuAI8b42nr/l8KP++89LappisLJ/3aqomuUv0
         7gvaAQ70LYRcz2+JGSOeM5YdQ3LedQQ2+VMSlRk/vxe9r5Pjl8CVjwFAB0tQVZLY06LV
         rEQxz7OhIMpxWlYzJ5ThwBF/ocQU2Ga82m0xj/TyehXhzeJk9GFa4TFyFM2MObSzgVEW
         iyt76dtMlXGa03HHva/QObY+jYxI/fDtgEQEDVuWnWDqNqzP4p+fyj0iMQvuEsfy5k4z
         3Lu9u0XhuA8qMNXhkfFP2DZyBgmm+TmLTAiZCrqpuqa7dNurSq1tM6ofkhcfyRlEmCm5
         5GHA==
X-Gm-Message-State: AOAM530UvIYdDk5be2tkDbC1y/40+f6JuXSI5k/Pf+v+NtS8QDtK083M
        ni8MKHnGVZcyGAUCpK4+G+c=
X-Google-Smtp-Source: ABdhPJzhQs4ekjvKZCv6kaFB9aOV4uPoWw5LM3jvCe+X2GrmynTKsyFafru3aOjVnweYMWH6ZNaujA==
X-Received: by 2002:a17:90a:de0b:: with SMTP id m11mr24288256pjv.39.1631923582658;
        Fri, 17 Sep 2021 17:06:22 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:06:22 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH 06/84] ib_srp: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:04:49 -0700
Message-Id: <20210918000607.450448-7-bvanassche@acm.org>
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
 drivers/infiniband/ulp/srp/ib_srp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 71eda91e810c..f8765f96ec1e 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1266,7 +1266,7 @@ static void srp_finish_req(struct srp_rdma_ch *ch, struct srp_request *req,
 	if (scmnd) {
 		srp_free_req(ch, req, scmnd, 0);
 		scmnd->result = result;
-		scmnd->scsi_done(scmnd);
+		scsi_done(scmnd);
 	}
 }
 
@@ -1987,7 +1987,7 @@ static void srp_process_rsp(struct srp_rdma_ch *ch, struct srp_rsp *rsp)
 		srp_free_req(ch, req, scmnd,
 			     be32_to_cpu(rsp->req_lim_delta));
 
-		scmnd->scsi_done(scmnd);
+		scsi_done(scmnd);
 	}
 }
 
@@ -2239,7 +2239,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 
 err:
 	if (scmnd->result) {
-		scmnd->scsi_done(scmnd);
+		scsi_done(scmnd);
 		ret = 0;
 	} else {
 		ret = SCSI_MLQUEUE_HOST_BUSY;
@@ -2811,7 +2811,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 	if (ret == SUCCESS) {
 		srp_free_req(ch, req, scmnd, 0);
 		scmnd->result = DID_ABORT << 16;
-		scmnd->scsi_done(scmnd);
+		scsi_done(scmnd);
 	}
 
 	return ret;
