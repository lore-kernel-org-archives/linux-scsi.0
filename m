Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0DC2C6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjCVT5H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbjCVT4r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:56:47 -0400
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF5964B31
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:39 -0700 (PDT)
Received: by mail-pl1-f175.google.com with SMTP id z19so9875293plo.2
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679514999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9O+CFHroXeGMQJXjLpdEI2pqL5MGU1cKW/jyaRLyaNA=;
        b=hRtib4bD4kxfz8nrf8D6c4U1BNBi1noIt4hj29RyQ58ZFPDn8iVIkyyxp4ZgvcYNiw
         /cNK8Khubw75Q3Aft75Od6r3GUs9zOVha3lxyq2GOxweoLm/oBoU3qe/gztei1S0ARWk
         d1eZtwSSKkJ9G/vPXp6vbyibYmhZU8Pp4pZuGPL3tQNHu6/uYQjBs4CSAGyv4I4yT2Se
         JLUyohwfGlTneEwWZLHIjwmafCZQBQuMlwsVy41GYjbyUkLxMZZzZ3wqHyIoEK8BwZnc
         gq2XVpq8Hx0Vi2Fu/fpv2ilU/DdT7ySnvzDqU+9+HRnLazSSIT3/p+z9aOoywkRoA63h
         WOAA==
X-Gm-Message-State: AO0yUKVeDa8foXiLEF1sAfNsD0Yf3vGYLuE1yTq2jqTeWXKNVFNpGxn9
        fljJAZ2f/BUTSxv03y3JmyBIF1jKM5w=
X-Google-Smtp-Source: AK7set86EPmNgSi1ceSGRTzKoEcPv+9G9d4D7eIFgQPzb2X7euHdb/KH20bQR+aWFc3JPF+pNEgUBw==
X-Received: by 2002:a17:90b:4c49:b0:23d:a2a:3ae4 with SMTP id np9-20020a17090b4c4900b0023d0a2a3ae4mr5231608pjb.44.1679514999341;
        Wed, 22 Mar 2023 12:56:39 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:56:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 15/80] scsi: a3000: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:10 -0700
Message-Id: <20230322195515.1267197-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/a3000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index 2c5cb1a02e86..c3028726bbe4 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -197,7 +197,7 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	}
 }
 
-static struct scsi_host_template amiga_a3000_scsi_template = {
+static const struct scsi_host_template amiga_a3000_scsi_template = {
 	.module			= THIS_MODULE,
 	.name			= "Amiga 3000 built-in SCSI",
 	.show_info		= wd33c93_show_info,
