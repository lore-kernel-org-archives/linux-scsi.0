Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F2CC43332
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A672650DC
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233869AbhCPD5W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 23:57:22 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:46402 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233757AbhCPD5L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 23:57:11 -0400
Received: by mail-pf1-f178.google.com with SMTP id t85so7899791pfc.13
        for <linux-scsi@vger.kernel.org>; Mon, 15 Mar 2021 20:57:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x2GwOnDvnCTqkgLMZjnaMsUN8onZNv9f/92XghOmjCc=;
        b=sXENfbcqPFGDRFJzUjuPf2KLKD8P0gdnhzCrVZI9CUB28R/p7sX/BibldJLPI1n6ol
         Xic4zu7VqyL7os0AFKDZSRONFi7b+VbZ5/XR/67L/sMIdnQRLdXAa25TMDn1NDU47tHN
         WNqgQMpsLzbNzma/tBLUhidRIt75W1HhIL2aDi7U79zY1JkLDX052pYAf/MSS5BVv2aB
         rOgFY1VAwcXhnMUdAM5UqYcEwNEFcuVyb5Lc7u7V9Cqh6c1aeqN5DWYvnfcTqOWlEHIo
         M/wAAleCIg0faevsWKAEPlWwcWfPhSQYg9OMcneG9UBmfZ2Eso5M5vWbjfjYNim8MTv0
         MdOg==
X-Gm-Message-State: AOAM530KgyGE8s/aJwseDms60jG2pckh9o2EW0Zwp597sT5lbrM8G7Ap
        U3h9JkD4mP7be9Iyqcwm6p8=
X-Google-Smtp-Source: ABdhPJzS4Jjs3vqNnYmiRfU1zOdGOWHR6eQOI4VGZw8vOvbVmcLmCvE7iYBqoMiDmthYNx9Moq/qjg==
X-Received: by 2002:a62:3847:0:b029:202:ad05:4476 with SMTP id f68-20020a6238470000b0290202ad054476mr12754281pfa.67.1615867031494;
        Mon, 15 Mar 2021 20:57:11 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:8641:766a:ce30:8278])
        by smtp.gmail.com with ESMTPSA id fs9sm1031673pjb.40.2021.03.15.20.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 20:57:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH 7/7] qla2xxx: Always check the return value of qla24xx_get_isp_stats()
Date:   Mon, 15 Mar 2021 20:56:55 -0700
Message-Id: <20210316035655.2835-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210316035655.2835-1-bvanassche@acm.org>
References: <20210316035655.2835-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes the following Coverity warning:

    CID 361199 (#1 of 1): Unchecked return value (CHECKED_RETURN)
    3. check_return: Calling qla24xx_get_isp_stats without checking return
    value (as is done elsewhere 4 out of 5 times).

Cc: Quinn Tran <qutran@marvell.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_attr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 63391c9be05d..ad57111f8cb9 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2864,6 +2864,8 @@ qla2x00_reset_host_stats(struct Scsi_Host *shost)
 	vha->qla_stats.jiffies_at_last_reset = get_jiffies_64();
 
 	if (IS_FWI2_CAPABLE(ha)) {
+		int rval;
+
 		stats = dma_alloc_coherent(&ha->pdev->dev,
 		    sizeof(*stats), &stats_dma, GFP_KERNEL);
 		if (!stats) {
@@ -2873,7 +2875,8 @@ qla2x00_reset_host_stats(struct Scsi_Host *shost)
 		}
 
 		/* reset firmware statistics */
-		qla24xx_get_isp_stats(base_vha, stats, stats_dma, BIT_0);
+		rval = qla24xx_get_isp_stats(base_vha, stats, stats_dma, BIT_0);
+		WARN_ONCE(rval != QLA_SUCCESS, "rval = %d\n", rval);
 
 		dma_free_coherent(&ha->pdev->dev, sizeof(*stats),
 		    stats, stats_dma);
