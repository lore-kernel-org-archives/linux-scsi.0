Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E8A7C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 22:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiI2WBC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 18:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiI2WAq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 18:00:46 -0400
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083C413A078
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:00:45 -0700 (PDT)
Received: by mail-pl1-f181.google.com with SMTP id b21so2382136plz.7
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:00:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=R3OzMiYJLOTGRxZPN+YV+Z6KrkVcZa9EpMLGP1Zjei4=;
        b=mwylfr21EVoOqYExpWpYQ/1FErLxQRel8PgCgyHpa3fZVuDyiXCo+pnWKRmQphhn35
         YKOy8eauYKsOOC+NhsXP6xw2S7jYMF31/NOqgsMvIPDr3hAoaGWa+NUQw+vspyJ0CwlT
         hSkyN0uGus7jo8WpF4uHS3ip+icvaAbDiQn8iNjsgkeYbaOn8LtpCAVT2jRg6ywfc1Cd
         gJIejv+qiSvU9Jb1a/f3KmqAE5KTvXOTE5DCgTRkB4QEzOn3eq+BYRFvu0K5eX0gqNPR
         5cQ++sa0LEx7GmV0kStbMk61FfyNH8E2tmVlZKWdATpDGDrU66P6hlNFhYh42kXw0Cbx
         vlLg==
X-Gm-Message-State: ACrzQf2XboeU0uRCDSksKF4lhfbgicjzFrbutl8akGBn72FPKdCMvxwD
        PupsR7M2wukTtnPt75iITQ8=
X-Google-Smtp-Source: AMsMyM6bnXJqXrlO3yDydYqefOQtk8/60uq/71hIqB/NqZ4BtwLpwwyRnZ3V8xUhDgZnUMqCi1bTrA==
X-Received: by 2002:a17:902:d4d2:b0:178:491b:40d with SMTP id o18-20020a170902d4d200b00178491b040dmr5599350plg.79.1664488843001;
        Thu, 29 Sep 2022 15:00:43 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:56f2:482f:20c2:1d35])
        by smtp.gmail.com with ESMTPSA id e3-20020a17090301c300b001782f94f8ebsm407787plh.3.2022.09.29.15.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 15:00:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 3/8] scsi: core: Support failing requests while recovering
Date:   Thu, 29 Sep 2022 15:00:16 -0700
Message-Id: <20220929220021.247097-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
In-Reply-To: <20220929220021.247097-1-bvanassche@acm.org>
References: <20220929220021.247097-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The current behavior for SCSI commands submitted while error recovery
is ongoing is to retry command submission after error recovery has
finished. See also the scsi_host_in_recovery() check in
scsi_host_queue_ready(). Add support for failing SCSI commands while
host recovery is in progress. This functionality will be used to fix a
deadlock in the UFS driver.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 473d9403f0c1..ecd2ce3815df 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1337,9 +1337,6 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
 				   struct scsi_device *sdev,
 				   struct scsi_cmnd *cmd)
 {
-	if (scsi_host_in_recovery(shost))
-		return 0;
-
 	if (atomic_read(&shost->host_blocked) > 0) {
 		if (scsi_host_busy(shost) > 0)
 			goto starved;
@@ -1727,6 +1724,11 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	ret = BLK_STS_RESOURCE;
 	if (!scsi_target_queue_ready(shost, sdev))
 		goto out_put_budget;
+	if (unlikely(scsi_host_in_recovery(shost))) {
+		if (req->cmd_flags & REQ_FAILFAST_MASK)
+			ret = BLK_STS_OFFLINE;
+		goto out_dec_target_busy;
+	}
 	if (!scsi_host_queue_ready(q, shost, sdev, cmd))
 		goto out_dec_target_busy;
 
