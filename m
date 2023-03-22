Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E9F9C76196
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 20:00:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbjCVUAw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 16:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbjCVT7z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:59:55 -0400
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF8E5A922
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:21 -0700 (PDT)
Received: by mail-pj1-f51.google.com with SMTP id j3-20020a17090adc8300b0023d09aea4a6so24645819pjv.5
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515099;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zeBcHhBT8lTvtzrpIMuLtB00FAo06aPx5N7DZXVv5iM=;
        b=dbSnq+00nN7sSN7BTlN1Dh0PNsCmTSVJETSEnRGpBx5q4dXGtL5v/ebBTEO7jBwRPy
         8piLGJb3BXRUgEpT0LOaY/ElPgNvetMb5BsWCYABFUshHN8YIhMoP7p/M7HbVMrHGGoK
         arDjdhtmeQS2r0d6h7TbesREoUum3Gem+MB/AY6vv0+gdOO8J26+rx8WNoID70vo8L7/
         DyZvrRk1hYGVZl2RSJuAvchO74JI9dztMl41sY27iBbyRgAZ5TfHUYUZpvxwKPJQArAW
         U8bWfUdZeYPj/i6hKk9S/JnKpyKb/c7bZuIQuiUPoLCN/fB7h90UFyypdfkhg1B2LHzv
         VJUA==
X-Gm-Message-State: AO0yUKVwW973kzThUtWftjMYMAVeblv08IuUMnihIlWArI3HYeHOxiGb
        JCJj28XXd8yCwRWukI/lbys=
X-Google-Smtp-Source: AK7set/EdKb8gtD5iXIpz6Dvtxd7je51MELT1GmC86I2zifGH1JTaECKwOrextQJj9pvcZ0uTlNzug==
X-Received: by 2002:a17:90b:4d8a:b0:23f:9fac:6b31 with SMTP id oj10-20020a17090b4d8a00b0023f9fac6b31mr4682090pjb.25.1679515099267;
        Wed, 22 Mar 2023 12:58:19 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:58:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.g.garry@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Alexey Galakhov <agalakhov@gmail.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v3 56/80] scsi: mvsas: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:51 -0700
Message-Id: <20230322195515.1267197-57-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mvsas/mv_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index cfe84473a515..49e2a5e7ce54 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -29,7 +29,7 @@ static const struct attribute_group *mvst_host_groups[];
 
 #define SOC_SAS_NUM 2
 
-static struct scsi_host_template mvs_sht = {
+static const struct scsi_host_template mvs_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
 	.queuecommand		= sas_queuecommand,
