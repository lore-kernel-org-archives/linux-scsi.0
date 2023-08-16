Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 413FFC25B5F
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Aug 2023 19:56:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345954AbjHPTz5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Aug 2023 15:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345949AbjHPTz3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2023 15:55:29 -0400
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B14CE55;
        Wed, 16 Aug 2023 12:55:28 -0700 (PDT)
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-565f24a24c4so993311a12.1;
        Wed, 16 Aug 2023 12:55:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692215727; x=1692820527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bxmh1ZZBBxGsevqYm7Hoejol5PAGBkpBUksXBvv8y1U=;
        b=bXFV6S8Gs/xmcbdJAo5qrT48RuA4j9rlRim8+yxBG6RSdHuUiUhgnnHq2Z4whLbd4k
         F4b3Yc7K7NkP5NtOz5EGq5Ba5/ZvccU3bulCKJeYhsCie2gk1t9pH/oHNMyHWuCeAPTe
         VaBKcHETmW0DZQmB9oUxR4C384I9NO55eAdpBI9QIcepHWFV6/kcf6D6ls4dpXRi1Bkr
         4iITYiB41z0J4OqKq/9+EaRw/MOvJCStpt536yG8c5HzlzepOK7+H/yIJVyUqD9aOpBj
         csouGtDvwT6oU9mWV+IuH7vEEIJ/YUL/FEFdnOq+gKuT+L66LQ2tu2uwEJi1rVnjoyq0
         S50A==
X-Gm-Message-State: AOJu0YzXYMBG9Nt7F/E6/qhgPJOwldoBE0irujgVyKDRdItfm4bNyNDH
        YxV+5GCHQt2VmWavZfBbB9Y=
X-Google-Smtp-Source: AGHT+IE5cVldksZVSEi9QTyWuADmKmyVKqjdO82EHUvRdCcSQ5snc9qjey3+DzRCHkh/wPWJZBSRLg==
X-Received: by 2002:a05:6a21:7888:b0:12f:382d:2a37 with SMTP id bf8-20020a056a21788800b0012f382d2a37mr4212498pzc.15.1692215727576;
        Wed, 16 Aug 2023 12:55:27 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7141:e456:f574:7de0])
        by smtp.gmail.com with ESMTPSA id r26-20020a62e41a000000b0068890c19c49sm1588508pfh.180.2023.08.16.12.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 12:55:27 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH v9 12/17] scsi: ufs: mediatek: Rework the code for disabling auto-hibernation
Date:   Wed, 16 Aug 2023 12:53:24 -0700
Message-ID: <20230816195447.3703954-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
In-Reply-To: <20230816195447.3703954-1-bvanassche@acm.org>
References: <20230816195447.3703954-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Call ufshcd_auto_hibern8_update() instead of writing directly into the
auto-hibernation control register. This patch is part of an effort to
move all auto-hibernation register changes into the UFSHCI driver core.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/host/ufs-mediatek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index e68b05976f9e..a3cf30e603ca 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1252,7 +1252,7 @@ static void ufs_mtk_auto_hibern8_disable(struct ufs_hba *hba)
 	int ret;
 
 	/* disable auto-hibern8 */
-	ufshcd_writel(hba, 0, REG_AUTO_HIBERNATE_IDLE_TIMER);
+	ufshcd_auto_hibern8_update(hba, 0);
 
 	/* wait host return to idle state when auto-hibern8 off */
 	ufs_mtk_wait_idle_state(hba, 5);
