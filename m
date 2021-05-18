Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69EC6C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D8A4611BF
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351314AbhERRrA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:47:00 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:39533 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351286AbhERRq4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:56 -0400
Received: by mail-pg1-f171.google.com with SMTP id v14so4802643pgi.6
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QzEJvtDauqNDIH4mB2ZVGavJEwyn/VwgmFEFxaZ4vrA=;
        b=Xnc7UgWNNa5cupSz8z8qCI6mEDJya2Eg1Exoh7OdpPL6CF5wjbumH2P/UIXnKOjee6
         lZN/gPXsBkYXXdaCX3wHMeLrv3OO9VOz4U9aRe8TAjcHWI8D9TKGG+bcQFWNIBWUH167
         DXmHkytkfwTRzDuv68rnmg3cTcDHHUMiyHK5mWDxfpwTlfqgpesEfB3p5Ta1ADoak9hP
         SzuLzaO8a4qVF+iChS2O+sthRehqdyIdHL8ligvA5zIJyw6NPZdT1DChslPd0/LQqFgJ
         d09+Ckks3BPr7yrOteeq2F9ght2TLSNCORe13u6RNlLUr6xwmBxOcMqDJ0FCgavrrPrL
         jwlg==
X-Gm-Message-State: AOAM530rfFjxAXOMKcqu7p5V2XspyGB9Bekf+ZrQSdODOAXJzgSddAV4
        j9hZ/fyYSuS/zssdB6UpRfY=
X-Google-Smtp-Source: ABdhPJz4tPBpwW0s7atpO416ppT0fr2OJFR0asNnSllSRTFqtqr2+B9B9+uOCXXi+Lq38nhDXP3ugg==
X-Received: by 2002:a65:68d5:: with SMTP id k21mr6230023pgt.383.1621359938109;
        Tue, 18 May 2021 10:45:38 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 33/50] qedf: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:33 -0700
Message-Id: <20210518174450.20664-34-bvanassche@acm.org>
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
 drivers/scsi/qedf/qedf_io.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index 6184bc485811..73f29e0e9a5c 100644
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
