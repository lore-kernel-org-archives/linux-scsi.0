Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6666C61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjCDAcJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjCDAcE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:32:04 -0500
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04A96A1C4
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:32:00 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id h8so4509978plf.10
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:32:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889920;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OPnE9n7QtyCEk3n3COjGJDpQv0RiMi/T6qwio7dM47Q=;
        b=JUhprouEqH+LvbAivvJmcOguBpWqVjeK49yOWV7mJ2p+Tb7iPbrsDlfhRRg5eTmhKV
         G0tM4WOdMzfQbDg2VhuSAWICDbnIl+9qn68iVwMqye8MrLEMoUQkVPZR0U3/EGwvMBWC
         29SqsHmwttCT+LuuVETugcpegfpzAjeSzAD7QQHIdYJYdf6o3CnYGh2ikk8etzLdyRmR
         EwjKUPgLwlSTmTiGQujdnG8iBz+9z/vdryiQU+Yq32dTR6bZoE/ATxc+18GoLDoylDsI
         WH8PFbLlhLw5B+QiMGsNFvXO+jOYZrQGqM29INLRDu3pOZ8dR0vQRg0IKU4griiIhMoP
         ju7Q==
X-Gm-Message-State: AO0yUKUg76t43P/x1YdRYUlJbYmCJWLFHoegbzkuZlpsroxRmBxaSK/Z
        bqGbAxW4vMKP6SuCL5eNxcU=
X-Google-Smtp-Source: AK7set8UY38CN+4DeZ/SUEz9y3wwHTgT11yLvOXgg517pZY5bZMo94EZFOaCks74lu29mjVogZQd4Q==
X-Received: by 2002:a17:903:2351:b0:19a:fa2f:5588 with SMTP id c17-20020a170903235100b0019afa2f5588mr4431677plh.49.1677889920279;
        Fri, 03 Mar 2023 16:32:00 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:31:59 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 12/81] scsi: BusLogic: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:29:54 -0800
Message-Id: <20230304003103.2572793-13-bvanassche@acm.org>
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
 drivers/scsi/BusLogic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index f7b7ffda1161..72ceaf650b0d 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -54,7 +54,7 @@
 #define FAILURE (-1)
 #endif
 
-static struct scsi_host_template blogic_template;
+static const struct scsi_host_template blogic_template;
 
 /*
   blogic_drvr_options_count is a count of the number of BusLogic Driver
@@ -3663,7 +3663,7 @@ static int __init blogic_parseopts(char *options)
   Get it all started
 */
 
-static struct scsi_host_template blogic_template = {
+static const struct scsi_host_template blogic_template = {
 	.module = THIS_MODULE,
 	.proc_name = "BusLogic",
 	.write_info = blogic_write_info,
