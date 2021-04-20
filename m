Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E792FC43460
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8AE061363
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbhDTAK1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:27 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:39856 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbhDTAKP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:15 -0400
Received: by mail-pl1-f179.google.com with SMTP id u7so16863866plr.6
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hv7vqN7aLYkL3JACDvUKjzlkOd/8PywmRSclWzhfuKc=;
        b=GYG0K4VQb6vgI9Cp8Z34JbFx+C6hFMegz7w/RX2lKcpcbfp5MXfeHSuCOs4gMq3fb5
         Bni1El50D9OPtscZbS4SqyAevQFkFQyZrANtz4AGp86SvO7WJYAdlNe58g3H1YWdiC/X
         Iihz4Od3x5ARwnlG0HqXupQKS6/9ODG61Tn7NAJ08ieQAJDG9YMnhhNEqhYKOjcEVwnf
         CsiffwaAAbR2H8F8qspOw8/leob/f3XTLxpJ7bAe63CVnkhA3PmdAeOOt1K592oIMj0w
         EjT31N93nZ1ofgxQFbTBCM0rjjkDG080V9KKJ4gqUeETN9Gul3a3P3Ds1LywbieLardo
         3DBQ==
X-Gm-Message-State: AOAM5327vaiJCqcvUWw6p84TSKIhuv90t1tnyQMV7AJ2ja4GQzcksIdJ
        afQHL0rjPTlUf89MjLJ/vsg=
X-Google-Smtp-Source: ABdhPJxp/GFtqB4UyKkLLCpUTTU8ARrG+98Ma/Ize6kVwQ8cZbc3zh0WzU/XlNYawymgAQrom/4czg==
X-Received: by 2002:a17:902:c209:b029:ec:7add:e183 with SMTP id 9-20020a170902c209b02900ec7adde183mr20600998pll.74.1618877384142;
        Mon, 19 Apr 2021 17:09:44 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:43 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH 045/117] fas216: Fix two source code comments
Date:   Mon, 19 Apr 2021 17:07:33 -0700
Message-Id: <20210420000845.25873-46-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All fas216_done() callers pass a host byte (DID_*) as argument.
Additionally, fas216_done() passes its second argument 'result' to
functions that interpret it as a host byte. Hence change the description
of the second fas216*_done() argument from "driver byte" into "host byte".

Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/arm/fas216.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 2e687ce60753..b9ca25c77075 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -1999,7 +1999,7 @@ static void fas216_devicereset_done(FAS216_Info *info, struct scsi_cmnd *SCpnt,
  * fas216_rq_sns_done - Finish processing automatic request sense command
  * @info: interface that completed
  * @SCpnt: command that completed
- * @result: driver byte of result
+ * @result: host byte of result
  *
  * Finish processing automatic request sense command
  */
@@ -2033,7 +2033,7 @@ static void fas216_rq_sns_done(FAS216_Info *info, struct scsi_cmnd *SCpnt,
  * fas216_std_done - finish processing of standard command
  * @info: interface that completed
  * @SCpnt: command that completed
- * @result: driver byte of result
+ * @result: host byte of result
  *
  * Finish processing of standard command
  */
