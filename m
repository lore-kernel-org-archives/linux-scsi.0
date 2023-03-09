Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE43CC61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjCIT1S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjCIT1P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:27:15 -0500
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EADEA00D
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:27:11 -0800 (PST)
Received: by mail-pj1-f43.google.com with SMTP id x34so3101159pjj.0
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:27:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QxASyLi8nqGzT795DVp8Cos4Ht8OMveiQULpG2J4on4=;
        b=ToHLE3EtS1VKkWmn9mCoGs2gBjtquB2gPoCGJk/r0oaYIdLb2oHKWRiByiknbaUkv5
         wRtJs2xSEEC5BqSiqRfqreeMbL1SePvevocepTr/d2hVFFcH6XtZzV3/H+Dq/Lnt/JAQ
         tfCuHbmWUwKXcv1cu7sOMKiShYvgVgEoC4uiWCU5C3pTdZ2OP0ABL8CHsQCJo1eg3e73
         7drUXKBaE39hKhssD8UAH+AdeM5mo3Wxj7UuVPlTkBcjWrLgBSCGU4M0ODL8Y87Ha47w
         AVlxwQaOGFFkTLSOIEaIMNe9oDZ9cK/OGsYdGnTZiMxd0PGXsXiQ37SRQ438CABDsycH
         L7Bg==
X-Gm-Message-State: AO0yUKUcqLNPr2ubHEd7lKyWx0XDSHvObv+RwwHsdc90GX+KAES5XOR0
        F2H2pOkPX5c0AWKhBstgsfY=
X-Google-Smtp-Source: AK7set/62RStAAsaqc8dr2EzPTlq+uD5m4v6DadFpRT8iHSb4xEOAVvSsZ7/BIM4mlYgg3LzlV8z+Q==
X-Received: by 2002:a05:6a20:7d9e:b0:cd:8ed8:8e1d with SMTP id v30-20020a056a207d9e00b000cd8ed88e1dmr23787031pzj.12.1678390030961;
        Thu, 09 Mar 2023 11:27:10 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:27:10 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH v2 05/82] firewire: sbp2: Declare the SCSI host template const
Date:   Thu,  9 Mar 2023 11:24:57 -0800
Message-Id: <20230309192614.2240602-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the sbp2 host template it not modified.

Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/firewire/sbp2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 60051c0cabea..26db5b8dfc1e 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1117,7 +1117,7 @@ static void sbp2_init_workarounds(struct sbp2_target *tgt, u32 model,
 	tgt->workarounds = w;
 }
 
-static struct scsi_host_template scsi_driver_template;
+static const struct scsi_host_template scsi_driver_template;
 static void sbp2_remove(struct fw_unit *unit);
 
 static int sbp2_probe(struct fw_unit *unit, const struct ieee1394_device_id *id)
@@ -1586,7 +1586,7 @@ static struct attribute *sbp2_scsi_sysfs_attrs[] = {
 
 ATTRIBUTE_GROUPS(sbp2_scsi_sysfs);
 
-static struct scsi_host_template scsi_driver_template = {
+static const struct scsi_host_template scsi_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "SBP-2 IEEE-1394",
 	.proc_name		= "sbp2",
