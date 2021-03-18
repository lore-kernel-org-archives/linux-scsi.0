Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB4AC4332B
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 03:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9454064F38
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 03:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbhCRD3I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 23:29:08 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:39598 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbhCRD24 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 23:28:56 -0400
Received: by mail-pj1-f41.google.com with SMTP id ot17-20020a17090b3b51b0290109c9ac3c34so2005264pjb.4
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 20:28:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gg1avgyywlAHUAw1chJwnBc0TLhADSublheldOVu61M=;
        b=hEZfGqdrEJ6I7hJesWWpAfSghcm2e3hrwtjL2qgIokUzCAdF5XqMcXgg9IwuM2XmTY
         kg9P4KMPWWvJie/xZj3pNW1Wn1afuvOruH616842aUVrPsdP4CvRfu+banUMQ0SDK/i+
         diCXZ3e978eCMLFb5bmJYepXExnUQ1mKuZblCF2iTvqJ8VKM3ePUUcoBfFnXzPCsgNDQ
         sceVKPm5sF9MAlNWN8rtmxCU5AWdmSO5FYHHIf4dpNEiAHJoKakw/+Ko2L1RoCm9qMUD
         CZHazWHQ1/j7eiT09bo//E93eq6/rvpVEv1cHN/RWOQIFhqcWnSNSRhW/P8ABjpVyepP
         K0Ug==
X-Gm-Message-State: AOAM530Cxk7qZmPid/Z+zW02d1g/1SIbup1fIcrNxYMSG/M0lLx7STO9
        wVtq31vfGaGqlLsvEVycaBY=
X-Google-Smtp-Source: ABdhPJwsDkVBOrj2nEYQ5MzBN7993O+BogBD6xAASTHbkGfRMbDRwO0Qd6ZvKGa0SpihtQX4C4DhFg==
X-Received: by 2002:a17:902:ee95:b029:e5:e2c7:5f76 with SMTP id a21-20020a170902ee95b02900e5e2c75f76mr7650216pld.25.1616038136329;
        Wed, 17 Mar 2021 20:28:56 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7fb2:1f41:ab33:bae6])
        by smtp.gmail.com with ESMTPSA id y68sm473687pgy.5.2021.03.17.20.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 20:28:55 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v2 6/6] qla2xxx: Always check the return value of qla24xx_get_isp_stats()
Date:   Wed, 17 Mar 2021 20:28:40 -0700
Message-Id: <20210318032840.7611-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210318032840.7611-1-bvanassche@acm.org>
References: <20210318032840.7611-1-bvanassche@acm.org>
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
 drivers/scsi/qla2xxx/qla_attr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 63391c9be05d..5813b17f1633 100644
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
@@ -2873,7 +2875,9 @@ qla2x00_reset_host_stats(struct Scsi_Host *shost)
 		}
 
 		/* reset firmware statistics */
-		qla24xx_get_isp_stats(base_vha, stats, stats_dma, BIT_0);
+		rval = qla24xx_get_isp_stats(base_vha, stats, stats_dma, BIT_0);
+		ql_log(ql_log_warn, vha, 0x70d9,
+		       "Resetting ISP statistics failed: rval = %d\n", rval);
 
 		dma_free_coherent(&ha->pdev->dev, sizeof(*stats),
 		    stats, stats_dma);
