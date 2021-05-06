Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74250C433ED
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 20:32:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C1C661107
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 20:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbhEFUdU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 May 2021 16:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbhEFUdU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 May 2021 16:33:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A590C061574
        for <linux-scsi@vger.kernel.org>; Thu,  6 May 2021 13:32:21 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1lekfS-0004Rp-6K; Thu, 06 May 2021 22:32:18 +0200
Received: from ukl by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1lekfR-0004J2-1c; Thu, 06 May 2021 22:32:17 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH] scsi: scsi_debug: Drop if with an always false condition
Date:   Thu,  6 May 2021 22:32:06 +0200
Message-Id: <20210506203206.254258-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-scsi@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

to_sdebug_host() is a container_of operation, so it never returns NULL.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/scsi/scsi_debug.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 70165be10f00..71ad30172ded 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -7676,11 +7676,6 @@ static int sdebug_driver_remove(struct device *dev)
 
 	sdbg_host = to_sdebug_host(dev);
 
-	if (!sdbg_host) {
-		pr_err("Unable to locate host info\n");
-		return -ENODEV;
-	}
-
 	scsi_remove_host(sdbg_host->shost);
 
 	list_for_each_entry_safe(sdbg_devinfo, tmp, &sdbg_host->dev_info_list,

base-commit: 38182162b50aa4e970e5997df0a0c4288147a153
-- 
2.30.2

