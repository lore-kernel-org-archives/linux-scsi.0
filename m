Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A9F7C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84601610E7
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243017AbhJHU1e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:27:34 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:42927 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242279AbhJHU1Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:27:24 -0400
Received: by mail-pj1-f44.google.com with SMTP id nn3-20020a17090b38c300b001a03bb6c4ebso6183100pjb.1
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:25:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gKfpQzpGvviquOa/5ScRBq5qSCTQ056PvQuLg3pgnrM=;
        b=uJPw1VZV10lN7nbQvOB+8JxUYK9c5fnvfg1zoqF/OMvmkxgmo1yXMuYNKFN4iCgBMg
         jh95poEeAhwpWHon4KewXEBktsF9ViO+OX+rVzziz56ICapDC3yZfOdX0glWJR4EiRcG
         c3dMiPo+M52BKO1I1meD0ErJxdjuI5o5pwtza3g69DQGFI6fLIgV3YRtRBzgFNNoDQVu
         px6BzU5NbLYyxFy/L6amEVUeWN7TwFZLVwwTc5guzvmClHyMXikp/OVv9nVqH+ttyq/2
         pUg6XWoxt8jnpwJBdU2yGgtMsWSwHarjfMOq1DHEaFRFgTzCYXmdeSnP6Klqi2cr1BdI
         KtSQ==
X-Gm-Message-State: AOAM530Qg8MPtrxD7TaZ4DA9/PpO7RWK74NHMZAUGtx92AsdvpEhDxQY
        FYFLzGLh3af8kDJ/IwdW/JY=
X-Google-Smtp-Source: ABdhPJySMrW0ssjWCQRhqwLEQJQghIgyJobtj8hP/a6kkyu2/a2FjXJBuWZnYmRKLyCOItShqexwRg==
X-Received: by 2002:a17:90a:6289:: with SMTP id d9mr14973522pjj.110.1633724728117;
        Fri, 08 Oct 2021 13:25:28 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:25:27 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        David Kershner <david.kershner@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Song Chen <chensong_2000@189.cn>,
        "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: [PATCH v3 44/46] scsi: unisys: Remove the shost_attrs member
Date:   Fri,  8 Oct 2021 13:23:51 -0700
Message-Id: <20211008202353.1448570-45-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211008202353.1448570-1-bvanassche@acm.org>
References: <20211008202353.1448570-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch prepares for removal of the shost_attrs member from struct
scsi_host_template.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/staging/unisys/visorhba/visorhba_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/unisys/visorhba/visorhba_main.c b/drivers/staging/unisys/visorhba/visorhba_main.c
index 41f8a72a2a95..f0c647b97354 100644
--- a/drivers/staging/unisys/visorhba/visorhba_main.c
+++ b/drivers/staging/unisys/visorhba/visorhba_main.c
@@ -584,7 +584,6 @@ static struct scsi_host_template visorhba_driver_template = {
 	.eh_device_reset_handler = visorhba_device_reset_handler,
 	.eh_bus_reset_handler = visorhba_bus_reset_handler,
 	.eh_host_reset_handler = visorhba_host_reset_handler,
-	.shost_attrs = NULL,
 #define visorhba_MAX_CMNDS 128
 	.can_queue = visorhba_MAX_CMNDS,
 	.sg_tablesize = 64,
