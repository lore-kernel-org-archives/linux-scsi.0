Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B59D3C47083
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DE506115C
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbhEXDLC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:02 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:37631 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbhEXDLB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:01 -0400
Received: by mail-pj1-f50.google.com with SMTP id gb21-20020a17090b0615b029015d1a863a91so10437096pjb.2
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xh8XA54Imxo9ILc5L+S6WvBmWu7PpD2lkFGz180jRy0=;
        b=A5+92Cq2CVdJREsp5FD7EEQlL3BkjkgcJ3y7NbZarPVGqG0YDOM03fPMlx5F+QzCtE
         lBtzr6ic46KHcztmTFesvcOkwc12x3E9Z5d+PsgPj3M1mk0kTx0UXmQypL0AUY55Wfev
         VmZIavfS1UkhnRJonGDWbPMajGBJb6ZOhJUHUGuqGJ9hmE8eXlUSOK1VrC08tQvRch4m
         0FAtlQK/w04/HJk6zoRH+qBDt7f9Os/J3xwHY3Xz5FSJjh/dqzPtxVQE60ivvemW2INd
         4Ds0DXcrPXi7ii8H7vpA5Kgox7N9+p8SJtdHquegOnYXDCxUk0INoZoYHlyQibIyCp6G
         3+2w==
X-Gm-Message-State: AOAM5322RxxGXw7eVou9KFbU0YYE6RAW0RhraLWpcr/UnoZ7UvfdMPnA
        eh2eHsv80XC5oa5Y4PvrEyo=
X-Google-Smtp-Source: ABdhPJxDCt9hROd+ssAfg3M7Ywfn57b0Ink6ZD4ljmSw8rUHoDrJOdPtSm7+rOfQ77Ns8qHnXAos2g==
X-Received: by 2002:a17:90a:549:: with SMTP id h9mr23616771pjf.158.1621825773218;
        Sun, 23 May 2021 20:09:33 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "Manoj N. Kumar" <manoj@linux.ibm.com>,
        "Matthew R. Ochs" <mrochs@linux.ibm.com>,
        Uma Krishnan <ukrishn@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 18/51] cxlflash: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:23 -0700
Message-Id: <20210524030856.2824-19-bvanassche@acm.org>
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
