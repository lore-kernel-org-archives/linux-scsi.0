Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E0AFC61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjCDAdu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjCDAd1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:33:27 -0500
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF1D92
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:33:08 -0800 (PST)
Received: by mail-pj1-f50.google.com with SMTP id x20-20020a17090a8a9400b00233ba727724so6670274pjn.1
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:33:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Eqt+ITNuMCviCw/LJKFT6yVsmzr7b0qC6Hk9y7auM8=;
        b=U9/iYmlq2kClonNQOG3oWFNCbwKf9Y097Ve/o5g0TU6VqiMP+WRTAOCpmr9Lyc+jyO
         LyxOLzwR+MTzXBHHrHI6Zj/u+FiHC/RHd6v7/3KZa73D2CGi7q04B5zQxMwsLww7SwlF
         4aovcyV3WRICl6aU2rtAWU5FJh0dRPcx6l3z3u0niOyVAgt0fmDj8+LbAAfPkNCDTikq
         O9vnWjxMpr4qrIQxiaBLuAsjF0mnSB9Emf28QU1uuYOpqFkJspvDzZgvRuFw9oOPoVMA
         ivSZNY3ZLiOFYJ7CjAbFctkZItrn1k7vcUwnMH9AofMY7McJnVCxkZzbYe+V7tWTtwqx
         oe3A==
X-Gm-Message-State: AO0yUKUOKsvO7TvH4OCEVQ6hC75q0tZwdY983/rRIj1K1BmvFjb41ohh
        By82EUNvTYwqygvT4ZrBDLM=
X-Google-Smtp-Source: AK7set96zSrO0SF5K5gn1NNbDltivsGuXY1OJIdOas2TCyuwHXxXI5Hsmi9UwJHGNRU2RqdXPbVAAA==
X-Received: by 2002:a17:902:7007:b0:19d:47b:67c8 with SMTP id y7-20020a170902700700b0019d047b67c8mr2966851plk.48.1677889987390;
        Fri, 03 Mar 2023 16:33:07 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:33:06 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 39/81] scsi: NCR5380: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:21 -0800
Message-Id: <20230304003103.2572793-40-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
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
