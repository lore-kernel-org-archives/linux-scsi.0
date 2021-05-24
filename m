Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8810C47080
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE5A661151
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbhEXDLb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:31 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:35530 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbhEXDLa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:30 -0400
Received: by mail-pj1-f46.google.com with SMTP id lx17-20020a17090b4b11b029015f3b32b8dbso8657480pjb.0
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:10:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QzEJvtDauqNDIH4mB2ZVGavJEwyn/VwgmFEFxaZ4vrA=;
        b=ZA+ILzMEsiAs0OdGUuLVPVIoMVnGT74IOjOTSLqavBSuRC5RlWtCxNab/j1zfg1N+5
         JZ0XDLB3610e8iEGtH53Tg1UTvYaxY2pOORyX8iuNOO2SYWtiNp7w4QQD8QWc8e3wT3p
         F4QkJswLDn0wqNp+s1N+sCae+zv5rdmpDfyq0iFiXk5XCzEPKwrc4Z+rsZ2UX1pFfliF
         8llqRj6RAQV1T1TKDJUGGEpl7oLSdQq6fU+8lLFcly7Q6/aX+djVngefSrfWggQO7wBm
         DOd0aPzxmz2pT9hxl9lwgExiLfxBWkUXfXGSsBONu0v+Rnl312r6Yei3ZHZ384NbOKPa
         Yi0A==
X-Gm-Message-State: AOAM533HCRKDuLT2suL5IgyI1VqY9DkdjnRyHz+wQdWLALvZ+UgmuS8x
        fQ1I3Xnd8wIIEwTyzGahpzd+juwJm1cQ5Q==
X-Google-Smtp-Source: ABdhPJyOTK1D22ih2vAAOfCOh8TUuHKJnEBsFpfsPX5lfxRoJ8Tdr2dnCCXkc6BYioqU6clDt7WhAg==
X-Received: by 2002:a17:90b:308:: with SMTP id ay8mr13271047pjb.19.1621825802314;
        Sun, 23 May 2021 20:10:02 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:10:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 34/51] qedf: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:39 -0700
Message-Id: <20210524030856.2824-35-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524030856.2824-1-bvanassche@acm.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
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
