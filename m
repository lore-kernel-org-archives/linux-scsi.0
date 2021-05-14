Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FFCCC433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18DC36143F
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbhENVgU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:20 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:40699 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233267AbhENVgP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:15 -0400
Received: by mail-pl1-f175.google.com with SMTP id n3so98922plf.7
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fhEVAQbeiuG8u4w7wEIEIvBbbtDHPDLgytXrqVt11s8=;
        b=XvTSds/bzbqx5ozSZjK6IzEuhKV78WN+be4uN9UjrNAhlaUoGuwEeGpkjHv0UUioBc
         W6UwMmQkX92nwuO82O06tWozeP34QAZqJF9cM8KRHYziw3ucr+49KmxtHBVMpyRE4xF1
         Yf21TxaZMIarZkAY8GGCGXenX8wmVFxxnFyX8UIlYXjVxpxyp1md6SbysnKwfQYw3i49
         Etn7DwYiGTS6FcEIdCwLeRLflLfiotmCrlHYWbrQlW+Tg1OUKo6B2WmVxkktkv49gRbl
         MwnRSasYy8SG/F2vp1AbXKbn+eE9c2eU1bULnyv0rxsksqLczVAFXmy/X5BPiMlSi5ID
         dyQg==
X-Gm-Message-State: AOAM53240o0uxq6FL9CDFAKE0WhSOgZNJgFUZtfp3FhxL4ooMMp7JoyH
        oxSUz07ZOSKeoMM9OtkTws4=
X-Google-Smtp-Source: ABdhPJwO5JSJcd+NIzeifx9BIrFfewj0WS4JirU6x1U5a1Qj03+kqlr2uEWv5V6jfk18h1AqWRFx1g==
X-Received: by 2002:a17:90a:e550:: with SMTP id ei16mr13502706pjb.127.1621028102934;
        Fri, 14 May 2021 14:35:02 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:02 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 33/50] qedf: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:48 -0700
Message-Id: <20210514213356.5264-34-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using blk_req() instead. This
patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qedf/qedf_io.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index 4869ef813dc4..6883218df66b 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -1167,13 +1167,7 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 		return;
 	}
 
-	if (!sc_cmd->request) {
-		QEDF_WARN(&(qedf->dbg_ctx), "sc_cmd->request is NULL, "
-		    "sc_cmd=%p.\n", sc_cmd);
-		return;
-	}
-
-	if (!sc_cmd->request->q) {
+	if (!blk_req(sc_cmd)->q) {
 		QEDF_WARN(&(qedf->dbg_ctx), "request->q is NULL so request "
 		   "is not valid, sc_cmd=%p.\n", sc_cmd);
 		return;
