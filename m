Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B7AC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CF40610FB
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236613AbhDOWJU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 18:09:20 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:37655 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236580AbhDOWJT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 18:09:19 -0400
Received: by mail-pj1-f50.google.com with SMTP id e8-20020a17090a7288b029014e51f5a6baso8188316pjg.2
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 15:08:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ocHOwrYqm9AUi6V9vYkRBF8Zd84TLHxRiJTc4dUOmZ8=;
        b=INwkp8aWmKKgyJHKZFhIawj0+ZITcP08y4OBrluDWedi2zgeyyVWin4BqQDn+eQc4p
         24oXiDsasNpIjam2jSjVQv81h0gH/MPlUZfGPQtqGjWY6IMK4R1QmUoYRJVNpvVJuniA
         9kq7ubzQ+IQ4JrQz/dpbyZVtdWaiqtDRQMYPMMId8tmv5Y78F+6GXpnFfYf90HPre/xY
         tFekHfam1kf7ibD8Fwzhds96wnUmtQ0OEnF9LDqD8kMKmMBtZ+Gr7qQ8MYrVTgiGz/rP
         Iu4SdX/co26pajWjhJMH+3uCyMLRb/E1xuuuyXaxYtMRcye4PCsuFavpuF56WdowlLRB
         O15A==
X-Gm-Message-State: AOAM531h0X6YDyGaAlgfjb5EkMYbLmjT9A/l/zFwUyhdi6liItRxBEJs
        3cXk1PhwVA3OfvnJUWphIW0=
X-Google-Smtp-Source: ABdhPJz1uZOoLBkyrT/MzjBeJgkqOQYLcMbLtFjETQKAckF3hB8t+ET02vv+fHDM5InTT03vZSA2kw==
X-Received: by 2002:a17:90a:5407:: with SMTP id z7mr6346470pjh.228.1618524535534;
        Thu, 15 Apr 2021 15:08:55 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:f031:1d3a:7e95:2876])
        by smtp.gmail.com with ESMTPSA id w4sm3311155pjk.55.2021.04.15.15.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 15:08:54 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 17/20] target: Compare explicitly with SAM_STAT_GOOD
Date:   Thu, 15 Apr 2021 15:08:23 -0700
Message-Id: <20210415220826.29438-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415220826.29438-1-bvanassche@acm.org>
References: <20210415220826.29438-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of leaving it implicit that SAM_STAT_GOOD == 0, compare explicitly
with SAM_STAT_GOOD.

Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_pscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 1c9aeab93477..dac44caf77a3 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1046,7 +1046,7 @@ static void pscsi_req_done(struct request *req, blk_status_t status)
 	int result = scsi_req(req)->result;
 	u8 scsi_status = status_byte(result) << 1;
 
-	if (scsi_status) {
+	if (scsi_status != SAM_STAT_GOOD) {
 		pr_debug("PSCSI Status Byte exception at cmd: %p CDB:"
 			" 0x%02x Result: 0x%08x\n", cmd, pt->pscsi_cdb[0],
 			result);
