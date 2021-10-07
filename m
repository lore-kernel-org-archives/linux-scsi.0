Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42622C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C323610A0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240950AbhJGVWm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:22:42 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:41685 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238287AbhJGVWm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:22:42 -0400
Received: by mail-pj1-f45.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so6250579pjb.0
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:20:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gKfpQzpGvviquOa/5ScRBq5qSCTQ056PvQuLg3pgnrM=;
        b=MjU+zHR8svJ4TE21pwKDfglkZMrJRcPtgZFLFuLjzsG39XykmYAxieKWlZ4L9ZGDH7
         QF6kCIP7NEivL/gXJYsX4kEz6Nrbj7PnQt8vX36bPgi4xfB2+fQAnyu64+BCqfNR1xbx
         R14P96l+M/IdQLV3qsguGbltWjqq2zEsgVIheB3A6qkMD4ddj2TRi6G0Vzm69fVmGL1Y
         UZrLgSyodPfWCMCDlu6zcqiqmRt1I6F0zyivx6ccN0f/Mn4BWC9c6xF1/wifyOy24uvX
         YlDNSipiJJW/OSZERLyECtDILKQlkCheJ1tL0W7IAnvCBsg9A740YroYytkzQQyB9hVc
         7cbA==
X-Gm-Message-State: AOAM532aoU+LrTDWPQXJPzB1JnnP+Vl1IiDpeN9tZISWI5o2vNPiJ3KL
        S0UQSU/hh3fsgiHNeMDRTjA=
X-Google-Smtp-Source: ABdhPJwNHWYn67vX2N6g7BqOf/T0AelGPe32rPsEHY+yoU1UGKBcGZ3IaC49Ya5MEbBWieO+38g+WQ==
X-Received: by 2002:a17:90a:1942:: with SMTP id 2mr7972682pjh.195.1633641647867;
        Thu, 07 Oct 2021 14:20:47 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:20:47 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        David Kershner <david.kershner@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Song Chen <chensong_2000@189.cn>,
        "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH v2 44/46] scsi: unisys: Remove the shost_attrs member
Date:   Thu,  7 Oct 2021 14:18:50 -0700
Message-Id: <20211007211852.256007-45-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007211852.256007-1-bvanassche@acm.org>
References: <20211007211852.256007-1-bvanassche@acm.org>
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
