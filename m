Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D85EC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8023D61108
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240788AbhJGUbh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:31:37 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:33437 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbhJGUbg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:31:36 -0400
Received: by mail-pl1-f173.google.com with SMTP id a11so4729585plm.0
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:29:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Mg3T+99vJDGFQS38jEjRvUdcAMlxVj1hvtWz+HZhgU=;
        b=bEoeL//F0Kq/pcUW4XwvX1aU7RkWACFtYvf4eR38T5pfFge7RpNKHluTeJeNrr8Prh
         twVZQIxczmgTQuOOv+o48DGdGatSOWgPPo9iAVqFNHJlBBKAjcBON9rXuM0JqBKlsfr+
         /VHu+sXalQ5qOi/XrPAi/sKlu34tEZKhUUydRifCgyFtWRHzmI1pFruALSA7Ty84eMYS
         7qftsATyO/f3iJ6RECVLd0yOZ11yd2WVHingS0xL6B5UBLtu+AkuLbKrRthT0bRWMWmz
         bb0SPJj/bTouW4IKNUSJDN+2P+0Vegzk3bdZK2sZPAsAMVk1Qw2sq58HTdWyw+N62tlx
         zWxg==
X-Gm-Message-State: AOAM531wOpCWwBdxUTRIrq/XfpBbaVcpLOXWP61l08p2T+uj/5v1bZxZ
        IfGagjlJfg2SPJud8bhCErA=
X-Google-Smtp-Source: ABdhPJxjq3qFdwXJlzlggfbKfEr3dgg9boo26T8g8DVOJggRnZseeZl8Yg8fJckqxtSGXxvCtDWoaw==
X-Received: by 2002:a17:90a:1d6:: with SMTP id 22mr7118243pjd.39.1633638581939;
        Thu, 07 Oct 2021 13:29:41 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:29:41 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH v3 05/88] ib_srp: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:00 -0700
Message-Id: <20211007202923.2174984-6-bvanassche@acm.org>
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
