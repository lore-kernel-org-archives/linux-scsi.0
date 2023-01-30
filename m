Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F6DC54EAA
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Jan 2023 21:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjA3V1H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Jan 2023 16:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjA3V1G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2023 16:27:06 -0500
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A75330E9D;
        Mon, 30 Jan 2023 13:27:05 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id b5so5793911plz.5;
        Mon, 30 Jan 2023 13:27:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Va1b/Ohoy79n+u2MXTGHTdUDX3T7M+BNVNtwasEEI3g=;
        b=XH0IrxG6XpOVEth4cqSH5ZyM5iUsMsth9LEpgEA/zSrTnjWsZWRa5hp25kkg0nKAtV
         25OqO3F/pz2UW6c7DV4lzjEpplAJHSnNWnfHAfbpbOOLo3pN5RLdvf2DYr++mcpdjTHR
         1r6x/UXI2fvi4Jg66Nq4GL1TIv1w7MhYqrRWbCNAFkJoUyhcWGPg+vqC4fsXV8WzNSvJ
         8qI8AtcvAtXYcxMMoqpFvftIFol39hMAEJGRekXtn32b80Kp2YerruicnlKzai1ItEeX
         K2b3puQ3fs6ic5080OS/QqkimevVnuoU8PrN05qJsWo7IvFdjC5/ZKOtLJdQ3nliYMFl
         ZXYQ==
X-Gm-Message-State: AFqh2krd8MVA20ZdZssYtV11K/ZKODv1OqD7R01/fn/yzHdzaPJFgxUF
        eImByWq6F6nnZxsUzmELJvw=
X-Google-Smtp-Source: AMrXdXtnitI1HYZc9yFj3SnC0zTXUYnt0RPwsnJqp8+Iy5tz6vjss85yy5wuROmTB+zzdc25CmMOqQ==
X-Received: by 2002:a17:902:b20f:b0:194:a268:1201 with SMTP id t15-20020a170902b20f00b00194a2681201mr45004223plr.43.1675114024433;
        Mon, 30 Jan 2023 13:27:04 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5016:3bcd:59fe:334b])
        by smtp.gmail.com with ESMTPSA id u18-20020a170902e5d200b00196087a3d7csm7425613plf.77.2023.01.30.13.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 13:27:03 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 0/7] Add support for limits below the page size
Date:   Mon, 30 Jan 2023 13:26:49 -0800
Message-Id: <20230130212656.876311-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Jens,

We want to improve Android performance by increasing the page size from 4 KiB
to 16 KiB. However, some of the storage controllers we care about do not support
DMA segments larger than 4 KiB. Hence the need support for DMA segments that are
smaller than the size of one virtual memory page. This patch series implements
that support. Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v3:
- Removed CONFIG_BLK_SUB_PAGE_SEGMENTS and QUEUE_FLAG_SUB_PAGE_SEGMENTS.
  Replaced these by a new member in struct queue_limits and a static branch.
- The static branch that controls whether or not sub-page limits are enabled
  is set by the block layer core instead of by block drivers.
- Dropped the patches that are no longer needed (SCSI core and UFS Exynos
  driver).

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

Bart Van Assche (7):
  block: Introduce blk_mq_debugfs_init()
  block: Support configuring limits below the page size
  block: Support submitting passthrough requests with small segments
  block: Add support for filesystem requests and small segments
  block: Add support for small segments in blk_rq_map_user_iov()
  scsi_debug: Support configuring the maximum segment size
  null_blk: Support configuring the maximum segment size

 block/blk-core.c                  |  4 +-
 block/blk-map.c                   | 29 ++++++++---
 block/blk-merge.c                 |  7 ++-
 block/blk-mq-debugfs.c            | 10 ++++
 block/blk-mq-debugfs.h            |  6 +++
 block/blk-mq.c                    |  2 +
 block/blk-settings.c              | 82 ++++++++++++++++++++++++++++---
 block/blk.h                       | 39 ++++++++++++---
 drivers/block/null_blk/main.c     | 19 +++++--
 drivers/block/null_blk/null_blk.h |  1 +
 drivers/scsi/scsi_debug.c         |  4 ++
 include/linux/blkdev.h            |  2 +
 12 files changed, 179 insertions(+), 26 deletions(-)

