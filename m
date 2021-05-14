Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 198A0C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3C0D613C5
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbhENVgV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:21 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:39561 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233239AbhENVgR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:17 -0400
Received: by mail-pj1-f47.google.com with SMTP id o17-20020a17090a9f91b029015cef5b3c50so2316808pjp.4
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HdPSFSADOS6w1ZpaHgCH6SYynJeSJyGBXB5zWI/Lzmg=;
        b=MIeJkfTvZV3g4xUIS5eDbesZoVLJVwNzXDFcYot5yjXjTIHwc2wqBq2LcWkrm2G5i5
         EN6yhsARstKs0H7rHAaZd7FIY6dwzpe900E0tQvOCbRWFCIPSJFvvua7Vv4PEj+bcZSa
         iLrthxBLRZ/cKeya0/tYo94d+UWcEDO0nIjXjXtgOCKRaVDK0OO08ome6pHmws5DanxM
         f/hZz3A8M4MUCIQEUYGhZV3UcKeRXecgDeyxupT6aVGGIBhpFH1xeVcQkdNBqsW/Ewod
         rWgDrnXLhZeghJ/DwJWZx0bwJ2QABuT41QGYapw7UYB/hidymmc8hkyAG0qsZ5mJAwvF
         2zig==
X-Gm-Message-State: AOAM532AGgXR66OKCX+z0kJZ3i4MOa8gCl6YzKL9CVndminoxNuf2QWa
        OERg/38LSkSrLcvO7tUEFpSmBfJBEVSOPQ==
X-Google-Smtp-Source: ABdhPJxg8XLdSRrAdpH2CTep2CywCaXvg2PrFz+mn02yU9yPOz+Y5/Zj/xVxQB6KVd56u1KJ64/BZw==
X-Received: by 2002:a17:90a:f18e:: with SMTP id bv14mr6857919pjb.234.1621028104473;
        Fri, 14 May 2021 14:35:04 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 34/50] qedi: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:49 -0700
Message-Id: <20210514213356.5264-35-bvanassche@acm.org>
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
 drivers/scsi/qedi/qedi_fw.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 440ddd2309f1..7af8e62739ac 100644
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
+	if (!blk_req(sc_cmd)->q) {
 		QEDI_WARN(&qedi->dbg_ctx,
 			  "request->q is NULL so request is not valid, sc_cmd=%p.\n",
 			  sc_cmd);
