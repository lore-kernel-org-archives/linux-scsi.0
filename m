Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 799ABC43611
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FD26611BF
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351324AbhERRrC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:47:02 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:52757 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351272AbhERRq5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:57 -0400
Received: by mail-pj1-f44.google.com with SMTP id q6so5921701pjj.2
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XEfWU9LUhzWPDuMzwDDPW6MUHgQj6+8h3kxlWqjtmfs=;
        b=rA6d61DMWM6BgLWNt+jQMKfn2ZAAQ2kfYsGjaAqtQUsUQQOgKsLHwXMPZi7XpDKLVz
         ClTNFRgTmuAfejUd/SsxQin9JyMcdOryB9g8cWaz7jcqJ2GJaeAtbv96SkFZfHjy1UGt
         sHQBDaKlV8e5eq8Xj+8eNaHiAG3+Aw742PGfzKJHtOHzhG4rjpcVc6uqi6lZjktkrqEq
         jlVRaoJHnvQFzg+OW0szrtkjyPXM4bq8QSewBAWDRq4SnVBLE+i9Aae1g6oLfHRbdlhs
         alB14WvkH0OtxL2MFMIIv+xZRO8R5V++OYnaW+fJnbiEJPzX40lqwxxDEoltt4J3jaUv
         w8+Q==
X-Gm-Message-State: AOAM531wGOG5GFchC6tQYZzuNNVWapplCCvTfp7EflRbvfl3iahMWN34
        fwaLKLf+czIYQ4ibqy9Yw0A=
X-Google-Smtp-Source: ABdhPJxBqN9aF2y+lytjQC6UKZk9uHk6wjI/+gdlIVLaJ5Ojo4x1OqgNnP/9sXkFiwnP7kqMKmLjLQ==
X-Received: by 2002:a17:90a:7e09:: with SMTP id i9mr6432969pjl.141.1621359939051;
        Tue, 18 May 2021 10:45:39 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:38 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 34/50] qedi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:34 -0700
Message-Id: <20210518174450.20664-35-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qedi/qedi_fw.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 440ddd2309f1..f371c358c8c4 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -611,14 +611,7 @@ static void qedi_scsi_completion(struct qedi_ctx *qedi,
 		goto error;
 	}
 
-	if (!sc_cmd->request) {
-		QEDI_WARN(&qedi->dbg_ctx,
-			  "sc_cmd->request is NULL, sc_cmd=%p.\n",
-			  sc_cmd);
-		goto error;
-	}
-
-	if (!sc_cmd->request->q) {
+	if (!scsi_cmd_to_rq(sc_cmd)->q) {
 		QEDI_WARN(&qedi->dbg_ctx,
 			  "request->q is NULL so request is not valid, sc_cmd=%p.\n",
 			  sc_cmd);
