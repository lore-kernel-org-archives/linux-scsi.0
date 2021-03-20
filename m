Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41BCAC433C1
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Mar 2021 23:25:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D0476193B
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Mar 2021 23:25:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhCTXYx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Mar 2021 19:24:53 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:46718 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhCTXYQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Mar 2021 19:24:16 -0400
Received: by mail-pg1-f171.google.com with SMTP id e33so6162607pgm.13
        for <linux-scsi@vger.kernel.org>; Sat, 20 Mar 2021 16:24:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yFAzczovREgLtzPFvwufMKeAL8tjwLLyNIaQjD0pczc=;
        b=fZNTYpZdzRkJL+Y156p71ItRVvWRJZURo7k+TeKNhhobvzpB4ykR7EjxpjUKdY2peQ
         uQ5aj6xqoy+AKI7t1U1uy/F9RhYyNV+h7ReAQ4u4qLz7k0h+bYcLdH7P4AwjlypUJ+dy
         tAziyFZSwXemsWw6bCYIZ/ypdrRXfYTClDi+ny5v/cRZunJyokunAsjOXTynq+1RwV9B
         +CqxTbHmbD7ZiaJ8M37iQ6diPCBhTiZ8P0AWta+XM3XQKEjIv473ydrRtr/NoJMGBuoJ
         0KC7r2hUecjNw8qWH+RE/ytLjvUVAWsYioLF6CZgaUzDk3XOx6Rm0wY9s+atPaCDD3ZA
         7/DA==
X-Gm-Message-State: AOAM533TOgVdGgvi9WluyDPJdu/lHEcMQhA9EIrng0ynO2zZqfSdjaq3
        e8prY93yQu2dyHJBdOO3C50=
X-Google-Smtp-Source: ABdhPJydRJeivs3bUpeCMyxh2/zDIgXd9pMQ55PRJWHlueRbxo06Y+qENIlnxHkEdzPqg5ZjQEInUg==
X-Received: by 2002:a63:db57:: with SMTP id x23mr16830861pgi.432.1616282656044;
        Sat, 20 Mar 2021 16:24:16 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:9252:a76b:2952:3189])
        by smtp.gmail.com with ESMTPSA id u7sm8869159pfh.150.2021.03.20.16.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 16:24:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Daniel Wagner <dwagner@suse.de>, Lee Duncan <lduncan@suse.com>
Subject: [PATCH v3 6/7] qla2xxx: Always check the return value of qla24xx_get_isp_stats()
Date:   Sat, 20 Mar 2021 16:23:58 -0700
Message-Id: <20210320232359.941-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210320232359.941-1-bvanassche@acm.org>
References: <20210320232359.941-1-bvanassche@acm.org>
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
Cc: Lee Duncan <lduncan@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_attr.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 63391c9be05d..3aa9869f6fae 100644
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
@@ -2873,7 +2875,11 @@ qla2x00_reset_host_stats(struct Scsi_Host *shost)
 		}
 
 		/* reset firmware statistics */
-		qla24xx_get_isp_stats(base_vha, stats, stats_dma, BIT_0);
+		rval = qla24xx_get_isp_stats(base_vha, stats, stats_dma, BIT_0);
+		if (rval != QLA_SUCCESS)
+			ql_log(ql_log_warn, vha, 0x70de,
+			       "Resetting ISP statistics failed: rval = %d\n",
+			       rval);
 
 		dma_free_coherent(&ha->pdev->dev, sizeof(*stats),
 		    stats, stats_dma);
