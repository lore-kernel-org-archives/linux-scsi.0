Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E45ABC6FD19
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbjCIT3R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbjCIT2k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:40 -0500
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0057BA03
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:28:35 -0800 (PST)
Received: by mail-pl1-f170.google.com with SMTP id v11so3094661plz.8
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:28:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Eqt+ITNuMCviCw/LJKFT6yVsmzr7b0qC6Hk9y7auM8=;
        b=hqSygRfAxoInbXh74huygfzS4WZvbXUHvcaf85GwXWulmZ67duEtRB8XX5UXaE0RRv
         2QfDUfepQosomLZgbcHlqYKKiC4njsRoe6hQPKQfVJxoUEiSkTHuAXTbVDZGd4ahj+Xg
         7mllOW6eDIP5TAms1Z8BfhTJjkVQnNA13LKVxVznygBfsyBs0YM+KgGWiLoR3UpWDRfD
         c0m6aUchRYzcYjM7bPrPV9iKYGVxcSFrZFiYnAWzI5I38JcLWiaykjLWdx80dCLo4GlX
         ewdehrG1IRaNwBx0uXbv9BB9woxFse8QBwfwCqQT9v2ThRULf3y6r5zXt/VLySSSbEfu
         4t1g==
X-Gm-Message-State: AO0yUKW8vTycHiwHEMvkyAolRWEgnfx3L0M2566r5Zzj3YbV6Cws7uMd
        0WCHVOEN4zlm4cJj1lxIqcs=
X-Google-Smtp-Source: AK7set8NTNC7BOQybd8NwvIRT7FSQlkYtIXtduabxY4jRlVapc+2DQKW7AwQUJaunZ068rO3cOUW0A==
X-Received: by 2002:a05:6a20:8f09:b0:cb:cfb1:5009 with SMTP id b9-20020a056a208f0900b000cbcfb15009mr28844865pzk.34.1678390114925;
        Thu, 09 Mar 2023 11:28:34 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:28:34 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 39/82] scsi: NCR5380: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:31 -0800
Message-Id: <20230309192614.2240602-40-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
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
