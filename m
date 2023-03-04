Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B3F7C678D5
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjCDAcH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjCDAcD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:32:03 -0500
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7210565442
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:31:55 -0800 (PST)
Received: by mail-pl1-f170.google.com with SMTP id ky4so4556684plb.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:31:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fMZZSzHNKzDNL64pOw/gqMY4JB5yYVuh2s/FZomE/a4=;
        b=vm+yadLyen51i5QKKS5rjfNO1KBVsmdDr8tZqAlWJJatBVnB5OoqMU7netWx3Akcul
         QcBT03/VJgi6LhGor/BRy1MPBqKMBEgH/+dDcUT9+X3API4/9hj5WVTKlGjJlyIU7MqL
         xvbrkVzdb9gJB5xn3TICTK5Sd6YEPh5SXpdn9xT0YRe+i0yuW39lfIcwrv2DGMyXz8jM
         gtJr4xCh7tKdo5wByFA9GND6KY1vWk8sm6CRvnuOURISZXC2biqBzqKVn6J9pqSQ6mLX
         JIVXxAg8X3PNKmfCrsEHNC9/phRGd85+0a7nl9pO9fKvXs5SILhYqbfrVcaRn1GCs4v+
         nk8w==
X-Gm-Message-State: AO0yUKXYiMBYf1rGJhq38sHlqthWeNjnBgT83ecyFyCILlamjGNXCTtP
        DzpbhmWJhvI5LXy+7UACxmw=
X-Google-Smtp-Source: AK7set9OPu58y8ZeP8zVwTe7A9ufyzd/huMVT07lQsMpdGeRHwsONqWr3ZsXfs1YlJDFoOwTSS+QMg==
X-Received: by 2002:a17:903:11c8:b0:199:2a89:f912 with SMTP id q8-20020a17090311c800b001992a89f912mr3942988plh.20.1677889915072;
        Fri, 03 Mar 2023 16:31:55 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:31:54 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 09/81] scsi: 3w-9xxx: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:29:51 -0800
Message-Id: <20230304003103.2572793-10-bvanassche@acm.org>
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
 drivers/scsi/3w-9xxx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 6cb9cca9565b..38d20a69ee12 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1976,8 +1976,7 @@ static int twa_slave_configure(struct scsi_device *sdev)
 	return 0;
 } /* End twa_slave_configure() */
 
-/* scsi_host_template initializer */
-static struct scsi_host_template driver_template = {
+static const struct scsi_host_template driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "3ware 9000 Storage Controller",
 	.queuecommand		= twa_scsi_queue,
