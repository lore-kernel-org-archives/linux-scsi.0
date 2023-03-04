Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 084E9C61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbjCDAfM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjCDAeg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:34:36 -0500
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360613AB5
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:34:10 -0800 (PST)
Received: by mail-pl1-f177.google.com with SMTP id u5so4525764plq.7
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:34:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gtXkLpjqkzEtUpPCfZWQmuI25j02ukzVqxS1meSBiZY=;
        b=oXqkOdXqEoBt6lizvF2PWJcTsUnpjSoocEPC5PnpeuTiJLML5w6Uh88/GRC0MAJ7+T
         pQKIktmhTxjcT/zBpkzcSqawXmwZ3Ur0k+3TnSX9hzF2AmlfCoLIZ7CAKkAYZ4j8PXr3
         zjn1iNsSRjeIjXzvDe5j6Buvm4+p/XIw6ZZnO3A9HRhH4mprldu/M5vFhpoSc2p2fdox
         i9WrSfDch+I8QD5jYIWDLbRTtx+x7uoSJFDJ2BzO7uakZLxE+tMJd8OHFQdBMhwgEbGh
         T0BzwC7Yu1GwPhCe9w46TGRyvF4f4uHpW7CxlMBeYytXtl95xczsg+Vp/5Y+M3jSE2Rx
         bEqQ==
X-Gm-Message-State: AO0yUKXpndAy9B0pliaGssJsBqQ0kdm1fjv/08xbjuzx55XIy22vw0n1
        Z/Svp9jtHi3JSJ42GNBUlJg=
X-Google-Smtp-Source: AK7set9dXG9i6E5wxikdv1H83xB11SqH0r4a8s5q09yA0U8ElhMprkO4RHXap7A25Z8BVb+xC4jPfw==
X-Received: by 2002:a17:902:e54d:b0:19a:aa0e:2d67 with SMTP id n13-20020a170902e54d00b0019aaa0e2d67mr2966496plf.32.1677890040851;
        Fri, 03 Mar 2023 16:34:00 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:33:59 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 58/81] scsi: myrb: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:40 -0800
Message-Id: <20230304003103.2572793-59-bvanassche@acm.org>
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
 drivers/scsi/myrb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index e885c1dbf61f..ca2e932dd9b7 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -2203,7 +2203,7 @@ static struct attribute *myrb_shost_attrs[] = {
 
 ATTRIBUTE_GROUPS(myrb_shost);
 
-static struct scsi_host_template myrb_template = {
+static const struct scsi_host_template myrb_template = {
 	.module			= THIS_MODULE,
 	.name			= "DAC960",
 	.proc_name		= "myrb",
