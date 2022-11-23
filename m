Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A89E1C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Nov 2022 20:58:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236305AbiKWU6b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Nov 2022 15:58:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239170AbiKWU6H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2022 15:58:07 -0500
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF29E0C8;
        Wed, 23 Nov 2022 12:58:03 -0800 (PST)
Received: by mail-pf1-f178.google.com with SMTP id x66so9828778pfx.3;
        Wed, 23 Nov 2022 12:58:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rbxM8TRTKqiQCaG2etHAP+UycEMVCiMfi11R98Xmp3U=;
        b=dRsh2TZAbnpcILQaMRoIWftrBqPvKesDwUIFtUZnHRRLPGM6pj8qRJoSOcRiL2K1xH
         kNam7ApNCTtkj1N511uYtf5mQmOxtA9RFEAl46LJiTG6jI8fth47oCJ49Cx46YaQjRVA
         7FY8IPl17Zv8Ij/Vz/2/gqeKj+EBSExgq5CReHcAHIK7xZW6dAlNtgKLnhtj9jEGhvjJ
         Ti2sO3EMELf1lwRo8nMrSeDW12+1/lZ4petgaajCjmfA/+rNG1JVPq55gDURmS9CTId0
         n6BysEyMpACHWGrhGuwtAJ/aDLeTK8Jq0dB5dm173F6NixVJe7ARU09DAvs9qC2iwxrK
         LUdw==
X-Gm-Message-State: ANoB5pmEwTY/kxhFSS+eorcxJZaMjcmVvrgm5zMgVSNh4DGPr8g/wrkW
        +wPexIx3dqz8M5SQZQOYs4o=
X-Google-Smtp-Source: AA0mqf59rGefP6xlUHtt0s7z/ntEnAYFtQJ3hLgZe4eN8vMiGWPmpoRjliG1W+ukJ2I0u6tPnBmwRA==
X-Received: by 2002:a62:5f81:0:b0:56b:bb06:7dd5 with SMTP id t123-20020a625f81000000b0056bbb067dd5mr11190009pfb.3.1669237082397;
        Wed, 23 Nov 2022 12:58:02 -0800 (PST)
Received: from bvanassche-glaptop2.roam.corp.google.com ([2601:642:4c02:686d:4311:4764:eee7:ac6d])
        by smtp.gmail.com with ESMTPSA id i89-20020a17090a3de200b0020b2082e0acsm1858809pjc.0.2022.11.23.12.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 12:58:01 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/8] Add support for segments smaller than one page
Date:   Wed, 23 Nov 2022 12:57:32 -0800
Message-Id: <20221123205740.463185-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
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

Changes compared to v1:
- Added a CONFIG variable that controls whether or not small segment support
  is enabled.
- Improved patch descriptions.

Bart Van Assche (8):
  block: Introduce CONFIG_BLK_SUB_PAGE_SEGMENTS and
    QUEUE_FLAG_SUB_PAGE_SEGMENTS
  block: Support configuring limits below the page size
  block: Support submitting passthrough requests with small segments
  block: Add support for filesystem requests and small segments
  block: Add support for small segments in blk_rq_map_user_iov()
  scsi: core: Set the SUB_PAGE_SEGMENTS request queue flag
  scsi_debug: Support configuring the maximum segment size
  null_blk: Support configuring the maximum segment size

 block/Kconfig                     |  9 +++++++
 block/blk-map.c                   | 43 ++++++++++++++++++++++++++-----
 block/blk-merge.c                 |  6 +++--
 block/blk-mq.c                    |  2 ++
 block/blk-settings.c              | 20 ++++++++------
 block/blk.h                       | 14 +++++++++-
 drivers/block/null_blk/main.c     | 20 +++++++++++---
 drivers/block/null_blk/null_blk.h |  1 +
 drivers/scsi/scsi_debug.c         |  3 +++
 drivers/scsi/scsi_lib.c           |  2 ++
 include/linux/blkdev.h            |  7 +++++
 11 files changed, 107 insertions(+), 20 deletions(-)

