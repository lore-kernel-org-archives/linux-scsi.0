Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A0B3C432BE
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E24E61132
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242791AbhHETUB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:20:01 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:53166 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242618AbhHETUA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:20:00 -0400
Received: by mail-pj1-f42.google.com with SMTP id nh14so11321516pjb.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6RFPIMyLjhMpfnOIb75hPSlP1Uw3EoOUZEQ1HTdVJZU=;
        b=Cd6bNvikcissCTFnRnPbi1ySf06H7LTikXrJ/ed4yLPIWF/zqzi5jTwc6ERku/HylC
         mqUbYEQGa4MF4VLa0OqYwlF9tBJJtHaF3KnfiXOFLd9aeGY0jSGjawvUz6okxM0QmBMe
         S94OhIvhVfpvNSW1/zBaq/lZk05tTZ0XcPEru5ySm7V/t+ejpttZMioIB5mWG/r5nnFs
         Tmrv7l0v5z2Hb0oqSidosl5qjnNYYPFPN+wDrQ9Z1PNgb5yUD30VQjjPDvT4ks32FAu5
         5wvpfpvYINOw/BogVFyOUu8aumkyRuL5jWjX5qQxFI7hvvwOz+rvGul839JJMtZgXqmf
         bsjQ==
X-Gm-Message-State: AOAM5326G6zpjDoAvYYeNNFuT2Vbm4ZHeNjEUHiAQaTr7hcz+KaxCuGE
        K84Rr+n+lBPT4L76EOCVWdg=
X-Google-Smtp-Source: ABdhPJyZ+AeSn62g+lS7+fSOkra7SL0jBUAxxOhEleC1ZyvN9ZioDil8lY7a7ElU0dxGsSUF9aNuYg==
X-Received: by 2002:a63:6645:: with SMTP id a66mr606819pgc.339.1628191185265;
        Thu, 05 Aug 2021 12:19:45 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:44 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 35/52] qedf: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:11 -0700
Message-Id: <20210805191828.3559897-36-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qedf/qedf_io.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index 6b5b6a75ac88..3404782988d5 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -1162,13 +1162,7 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 		return;
 	}
 
-	if (!sc_cmd->request) {
-		QEDF_WARN(&(qedf->dbg_ctx), "sc_cmd->request is NULL, "
-		    "sc_cmd=%p.\n", sc_cmd);
-		return;
-	}
-
-	if (!sc_cmd->request->q) {
+	if (!scsi_cmd_to_rq(sc_cmd)->q) {
 		QEDF_WARN(&(qedf->dbg_ctx), "request->q is NULL so request "
 		   "is not valid, sc_cmd=%p.\n", sc_cmd);
 		return;
