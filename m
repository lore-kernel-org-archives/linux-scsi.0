Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A07C7C77B60
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbjCVT6n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbjCVT5x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:57:53 -0400
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776466A9D1
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:34 -0700 (PDT)
Received: by mail-pj1-f46.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so20263892pjb.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515054;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Eqt+ITNuMCviCw/LJKFT6yVsmzr7b0qC6Hk9y7auM8=;
        b=xMxl9t827AI9kI3LVv2eb/kUlOe5/at0/7Cua8m3vV2s7ykBypYUMFVydIBEWAmP1v
         +zsUNvebYAPZtvw12xRoRyjn6x/L2UvKa9y3SP1W063DbGqO6C+Y5Mw91rMC7ewvFJeh
         +imJtBKS0VQMuj2ebExj7pRVQtbjTOiFMg4R9LRTRIhfvgDaQK4nsawO5ehf4sJKdEOZ
         CnvgOhepCq7R9MXqAJNXXzsgBQrRSY5ZvANKfi1wZibNxCOTxt9TvkRKAGpD/L/AB83Z
         /8VOfogtWSbTuNARrMZHJedOX120+DsP2PsBJqLd+avM/aeifYWWaJf8gph895VweI32
         nF/A==
X-Gm-Message-State: AO0yUKVfs0SZsY0AOgDt2vuaIXHMEBqPq1lPZMm3xPHVQuM68ffMZSZr
        f2MxbXr8xf5+hAX5+9v+/oU=
X-Google-Smtp-Source: AK7set96ib2cF5DIy0vB9Mokr4mdhacHH3zsHFq7eU8Pu460+Kpt6C78caPdiZxVRwMdSSbzNtO3Yw==
X-Received: by 2002:a17:90b:4b43:b0:23f:680e:78be with SMTP id mi3-20020a17090b4b4300b0023f680e78bemr4262987pjb.48.1679515054056;
        Wed, 22 Mar 2023 12:57:34 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:57:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 39/80] scsi: NCR5380: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:34 -0700
Message-Id: <20230322195515.1267197-40-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/g_NCR5380.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 0c768e7d06b9..f6305e3e60f4 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -219,7 +219,7 @@ static int hp_c2502_irqs[] = {
 	9, 5, 7, 3, 4, -1
 };
 
-static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
+static int generic_NCR5380_init_one(const struct scsi_host_template *tpnt,
 			struct device *pdev, int base, int irq, int board)
 {
 	bool is_pmio = base <= 0xffff;
@@ -689,7 +689,7 @@ static int generic_NCR5380_dma_residual(struct NCR5380_hostdata *hostdata)
 
 #include "NCR5380.c"
 
-static struct scsi_host_template driver_template = {
+static const struct scsi_host_template driver_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= DRV_MODULE_NAME,
 	.name			= "Generic NCR5380/NCR53C400 SCSI",
