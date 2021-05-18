Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C01FC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85022611BF
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351245AbhERRqi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:38 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:36841 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351246AbhERRqf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:35 -0400
Received: by mail-pj1-f46.google.com with SMTP id n6-20020a17090ac686b029015d2f7aeea8so1986240pjt.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xh8XA54Imxo9ILc5L+S6WvBmWu7PpD2lkFGz180jRy0=;
        b=LuMLnbR8PvXX92owEAFHi+rQY5BJ/JvIxl2d8ABDJTcP6uzIDpDhwaoCuYwYknavUs
         CQ5/gLHXK/XwPERhSbykodWCxCV0yMn79uLQkPVhQJWvVJWfH3OdTjD9lnHeqHLZLZkI
         XVVAXM2tm9zA8exZ01Ft97r7ZpT7IShGi38mKR64j0POe/bP/lStZigCut301NGIEEZU
         Wq13W8nDTiDAWAdWyfmDqlEeIuUemPXvaSyDVQR/n73I0cpaVpVdquKizogcMZpWJbB4
         CRxL7vLLtLbpnVYa6/pl/zNXCMdXSNEMdHhbHsxPrFYoa282VmEM8t4eS8uFTOosCdjx
         Xq2A==
X-Gm-Message-State: AOAM532947lFAUrPyxt1fjLCbHmN4/HkMI3Fb1tHaN+gQDfLs7kaTBNC
        vQdTq3LdLOeJtP7noOhXMVs=
X-Google-Smtp-Source: ABdhPJyvLH0ewihXKJXGKjgCi3aYFvVOCOQSXsM0Beg/s4DQRe5ZAQYvANbqeAgA/10soy8tNpUYPA==
X-Received: by 2002:a17:90a:f811:: with SMTP id ij17mr6157058pjb.63.1621359917384;
        Tue, 18 May 2021 10:45:17 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Manoj N. Kumar" <manoj@linux.ibm.com>,
        "Matthew R. Ochs" <mrochs@linux.ibm.com>,
        Uma Krishnan <ukrishn@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 17/50] cxlflash: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:17 -0700
Message-Id: <20210518174450.20664-18-bvanassche@acm.org>
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
 drivers/scsi/cxlflash/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 222593bc2afe..2f1894588e0b 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -433,7 +433,7 @@ static u32 cmd_to_target_hwq(struct Scsi_Host *host, struct scsi_cmnd *scp,
 		hwq = afu->hwq_rr_count++ % afu->num_hwqs;
 		break;
 	case HWQ_MODE_TAG:
-		tag = blk_mq_unique_tag(scp->request);
+		tag = blk_mq_unique_tag(scsi_cmd_to_rq(scp));
 		hwq = blk_mq_unique_tag_to_hwq(tag);
 		break;
 	case HWQ_MODE_CPU:
