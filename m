Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16BA8C32793
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Jan 2023 22:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjARWzX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjARWy4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2023 17:54:56 -0500
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9D64EE3;
        Wed, 18 Jan 2023 14:54:55 -0800 (PST)
Received: by mail-pj1-f54.google.com with SMTP id v10-20020a17090abb8a00b00229c517a6eeso4012427pjr.5;
        Wed, 18 Jan 2023 14:54:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KlYumYyYBJmIWh0Km6C1yyftclaPkipz1dA+5CLJEE0=;
        b=Q60Z3QgjXurT6mln/hXAQa4vxAXeM9qoQ7SS/4qsj9qV9SUyEd3MhigVrIhzsd5dkU
         FO2ZYXxmqemY71QusFTiW0k5ckqvfPl1LdomG7uLUp3RPK6HSbYAVnjQ7EnFo5x7LLl2
         9Rd8ppelRLKgsfy+G8M8dxm3EzmQWgc3iOgvILJDcV6h4RShki2A6GzuoRVQXQ+ublot
         /s2oEYBuH1IW2wAx6hfzTVcQY78CWNuVq7zV3r6t/ke9nWZUCjkX0ZHbxBLI1BVMMm9E
         W8rHE+tNFlFhmKlmrp8Lye7WJmegPOA9LYKVQabZOhfrBzGFCnRX+SNargi0nAxldc7u
         IxRQ==
X-Gm-Message-State: AFqh2koLL3X/UJCOFwH0chhcXXkoVnTHJAyLbELWSTSOYrP68FkKIlb/
        2oOCKDysOyIOmsbbUGaeV7XglyAp5Ig=
X-Google-Smtp-Source: AMrXdXtL0n7lBIbFjpdDrKzJVsIIzbhUts2scfbuzZzuwj9JMQtzgn8jpyvLJBkcez8sz24LMd39NQ==
X-Received: by 2002:a17:902:f650:b0:192:b43e:272 with SMTP id m16-20020a170902f65000b00192b43e0272mr10623725plg.53.1674082495430;
        Wed, 18 Jan 2023 14:54:55 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:22ae:3ae3:fde6:2308])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090341c700b00186e34524e3sm23649466ple.136.2023.01.18.14.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:54:54 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/9] Add support for segments smaller than one page
Date:   Wed, 18 Jan 2023 14:54:38 -0800
Message-Id: <20230118225447.2809787-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Jens,

Several embedded storage controllers need support for DMA segments that are
smaller than the size of one virtual memory page. Hence this patch series.
Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v2:
- For SCSI drivers, only set flag QUEUE_FLAG_SUB_PAGE_SEGMENTS if necessary.
- In the scsi_debug patch, sorted kernel module parameters alphabetically.
  Only set flag QUEUE_FLAG_SUB_PAGE_SEGMENTS if necessary.
- Added a patch for the UFS Exynos driver that enables
  CONFIG_BLK_SUB_PAGE_SEGMENTS if the page size exceeds 4 KiB.

Changes compared to v1:
- Added a CONFIG variable that controls whether or not small segment support
  is enabled.
- Improved patch descriptions.

Bart Van Assche (9):
  block: Introduce QUEUE_FLAG_SUB_PAGE_SEGMENTS and
    CONFIG_BLK_SUB_PAGE_SEGMENTS
  block: Support configuring limits below the page size
  block: Support submitting passthrough requests with small segments
  block: Add support for filesystem requests and small segments
  block: Add support for small segments in blk_rq_map_user_iov()
  scsi_debug: Support configuring the maximum segment size
  null_blk: Support configuring the maximum segment size
  scsi: core: Set BLK_SUB_PAGE_SEGMENTS for small max_segment_size
    values
  scsi: ufs: exynos: Select CONFIG_BLK_SUB_PAGE_SEGMENTS for lage page
    sizes

 block/Kconfig                     |  9 +++++++
 block/blk-map.c                   | 43 ++++++++++++++++++++++++++-----
 block/blk-merge.c                 |  6 +++--
 block/blk-mq.c                    |  2 ++
 block/blk-settings.c              | 20 ++++++++------
 block/blk.h                       | 22 +++++++++++-----
 drivers/block/null_blk/main.c     | 21 ++++++++++++---
 drivers/block/null_blk/null_blk.h |  1 +
 drivers/scsi/scsi_debug.c         | 15 +++++++++++
 drivers/scsi/scsi_lib.c           |  3 +++
 drivers/ufs/host/Kconfig          |  1 +
 include/linux/blkdev.h            |  7 +++++
 12 files changed, 125 insertions(+), 25 deletions(-)

