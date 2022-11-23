Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 779C6C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Nov 2022 20:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbiKWU6V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Nov 2022 15:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239330AbiKWU6Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2022 15:58:16 -0500
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4304A140C0;
        Wed, 23 Nov 2022 12:58:15 -0800 (PST)
Received: by mail-pl1-f181.google.com with SMTP id y4so17725962plb.2;
        Wed, 23 Nov 2022 12:58:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mp24Nu2I7gSCQlK5n4D23tYVc00qzhoCs3YPv13NVLc=;
        b=aDbAKX4/HrS6PYGlupBLqoc55qAtmVeMTr0ECmEBsyPZnak6ogYo3L6fb+I7P0x7zU
         ueEV4XyHTmft7e9CezGDKkMtsUcvnjORAUL/bHJ4f5jFmWLJ1CMb8OXVH3lEVp5P34cv
         wbShJmzXDidDdq2iucIU7fuyfkvbmPaDUsd+0m1j325esrUz6+QJimH5Cja4TXBg9eLm
         Vi7EG+2recswylP1zD43Y1SfA/xieVBuh76hoYE8dKFFSTHtkSjXfdXXWhz38dVNXRIN
         TsyKU4a7ruYut2KUQElAnqqTex9PnmNPhoy11GIVmG4K9h52eQVkizdiRxu03xvdS7dY
         Fq7Q==
X-Gm-Message-State: ANoB5pm+IYHyT/9Nn1lReRQd4a8bnsGf7rQaM4I7dD7dPh33b0VTnVGx
        +/rsAhdA2cRtG6kGtpqoOII=
X-Google-Smtp-Source: AA0mqf7B1E2KDzXA+R+qCuwUzpTvPmhl0nhIS+bgHL2i1hi5Cg3+xqJwzMUZrRsONSajQyZrwPNj6w==
X-Received: by 2002:a17:90b:2684:b0:218:907c:da24 with SMTP id pl4-20020a17090b268400b00218907cda24mr25001836pjb.18.1669237094703;
        Wed, 23 Nov 2022 12:58:14 -0800 (PST)
Received: from bvanassche-glaptop2.roam.corp.google.com ([2601:642:4c02:686d:4311:4764:eee7:ac6d])
        by smtp.gmail.com with ESMTPSA id i89-20020a17090a3de200b0020b2082e0acsm1858809pjc.0.2022.11.23.12.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 12:58:13 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 6/8] scsi: core: Set the SUB_PAGE_SEGMENTS request queue flag
Date:   Wed, 23 Nov 2022 12:57:38 -0800
Message-Id: <20221123205740.463185-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
In-Reply-To: <20221123205740.463185-1-bvanassche@acm.org>
References: <20221123205740.463185-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch enables support for segments smaller than the page size.
No changes other than setting the SUB_PAGE_SEGMENTS flag are required
since the SCSI code uses blk_rq_map_sg().

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 249757ddd8fe..d91aefdfb8d4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1877,6 +1877,8 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 {
 	struct device *dev = shost->dma_dev;
 
+	blk_queue_flag_set(QUEUE_FLAG_SUB_PAGE_SEGMENTS, q);
+
 	/*
 	 * this limit is imposed by hardware restrictions
 	 */
