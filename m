Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42524C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D51D6138F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347068AbhI2WIL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:11 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:35618 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347056AbhI2WIF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:05 -0400
Received: by mail-pg1-f175.google.com with SMTP id e7so4162722pgk.2
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:06:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Mg3T+99vJDGFQS38jEjRvUdcAMlxVj1hvtWz+HZhgU=;
        b=UJqNojznnGl5qBxn3cPVT86pgAtdfW6S7/PK5bui7oOd3HWbqCvM24eJGohxRCFmNP
         SB0e48y1zGXljXQxNep9sAt1z0nbk57HG8i853Gr/jvOjcJLqzxofJjGoEz2ItkYIL2O
         Uzjd9DFNjTwGkBiCSQbqTlfuPhbY1/AzzCl3tFoVscmRRTtKKCg3K85VlDas1/3lgHmf
         I7mWxTTLT/wo3ZZfi7vmS6Oa/1Dk8pLKL7ZfCIteCyFASDMLOlpN4xDJqJgOCA99IBRZ
         qgTRBmB3lZHALencWeULiGvlUppW4PN1ejxrfHtJ1nS785dRNhVcccLJ59ejp2ZfanZ2
         +eTQ==
X-Gm-Message-State: AOAM530c2RZqannEPtDA6m4EVo3ObgU1WXZCbyZw9AK7m8DX1fpJ2eY4
        mlKikEnWHxj8JMdHY4oeIE/H5tKlnms=
X-Google-Smtp-Source: ABdhPJwZEn7F8labz1y3nHgsplwkzBxKmO7WDGJUNmokYUxNwE4w23UnCGptVo1e05DXusJtpZYnJw==
X-Received: by 2002:aa7:9ac2:0:b0:443:a477:6684 with SMTP id x2-20020aa79ac2000000b00443a4776684mr2109487pfp.25.1632953183581;
        Wed, 29 Sep 2021 15:06:23 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.06.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:06:23 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH v2 05/84] ib_srp: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:04:41 -0700
Message-Id: <20210929220600.3509089-6-bvanassche@acm.org>
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
