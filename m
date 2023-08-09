Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED36CC04FE1
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Aug 2023 20:24:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234402AbjHIUYC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Aug 2023 16:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234344AbjHIUYA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2023 16:24:00 -0400
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42092100;
        Wed,  9 Aug 2023 13:23:59 -0700 (PDT)
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3a3fbfb616dso144289b6e.3;
        Wed, 09 Aug 2023 13:23:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691612639; x=1692217439;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WzzSmGcpZZLnGFg27gsHyuNqbxfmUFCdCiBtY1Nf7pE=;
        b=b3dHs6xnVdS5VvJQlUQ0Wf4+2Byp2UV8P+NbdwI/JWpE8afpkMp00t/KD97taXphDW
         jloSvatZ+jGXIysoa7BHIFUgKEGEo6OFHvvEty78NY5F3yajvfv/gYMDaycTrV7cuDaJ
         fr2Mcb74/04ogYM8iRO6pAgOlIYgNKnpdZMOSiJ+NWcP2+W8Xgo4p0vKha6PrGBe9lTt
         f8IdRpDX2JhetTMHuExIewfNmXzbZxmqZe76YlqJNeUqtV/BOmynJ80McmVDExDEn3Ru
         vX9XaWBJWliahSE0gMsUGG3buX6j09cTSONUPYfZNLBAClnAxBl0FV9//M3JFZv/mfvs
         7IAQ==
X-Gm-Message-State: AOJu0YxBxSIEgEUaXC/4yS50wrAot2S7I71rIYIDUy/3+op7DHaKek29
        DT6Bqu80BsGfhOA7Eay73CM=
X-Google-Smtp-Source: AGHT+IHS87HRmEf8MY75u3+3RCBcRkQdqsXis/fO0MiFYijP2abGMRF7laH45mRVg9e/KVYjxmcS7w==
X-Received: by 2002:a05:6808:6092:b0:3a7:3b6f:ed46 with SMTP id de18-20020a056808609200b003a73b6fed46mr351493oib.27.1691612638900;
        Wed, 09 Aug 2023 13:23:58 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id gq9-20020a17090b104900b002694da8a9cdsm1868103pjb.48.2023.08.09.13.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 13:23:58 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v7 0/7] Improve performance for zoned UFS devices
Date:   Wed,  9 Aug 2023 13:23:41 -0700
Message-ID: <20230809202355.1171455-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Jens,

This patch series improves small write IOPS by a factor of four (+300%) for
zoned UFS devices on my test setup with a UFSHCI 3.0 controller. Please
consider this patch series for the next merge window.

Thank you,

Bart.

Changes compared to v6:
 - Removed QUEUE_FLAG_NO_ZONE_WRITE_LOCK and instead introduced a flag in
   the request queue limits data structure.

Changes compared to v5:
 - Renamed scsi_cmp_lba() into scsi_cmp_sector().
 - Improved several source code comments.

Changes compared to v4:
 - Dropped the patch that introduces the REQ_NO_ZONE_WRITE_LOCK flag.
 - Dropped the null_blk patch and added two scsi_debug patches instead.
 - Dropped the f2fs patch.
 - Split the patch for the UFS driver into two patches.
 - Modified several patch descriptions and source code comments.
 - Renamed dd_use_write_locking() into dd_use_zone_write_locking().
 - Moved the list_sort() call from scsi_unjam_host() into scsi_eh_flush_done_q()
   such that sorting happens just before reinserting.
 - Removed the scsi_cmd_retry_allowed() call from scsi_check_sense() to make
   sure that the retry counter is adjusted once per retry instead of twice.

Changes compared to v3:
 - Restored the patch that introduces QUEUE_FLAG_NO_ZONE_WRITE_LOCK. That patch
   had accidentally been left out from v2.
 - In patch "block: Introduce the flag REQ_NO_ZONE_WRITE_LOCK", improved the
   patch description and added the function blk_no_zone_write_lock().
 - In patch "block/mq-deadline: Only use zone locking if necessary", moved the
   blk_queue_is_zoned() call into dd_use_write_locking().
 - In patch "fs/f2fs: Disable zone write locking", set REQ_NO_ZONE_WRITE_LOCK
   from inside __bio_alloc() instead of in f2fs_submit_write_bio().

Changes compared to v2:
 - Renamed the request queue flag for disabling zone write locking.
 - Introduced a new request flag for disabling zone write locking.
 - Modified the mq-deadline scheduler such that zone write locking is only
   disabled if both flags are set.
 - Added an F2FS patch that sets the request flag for disabling zone write
   locking.
 - Only disable zone write locking in the UFS driver if auto-hibernation is
   disabled.

Changes compared to v1:
 - Left out the patches that are already upstream.
 - Switched the approach in patch "scsi: Retry unaligned zoned writes" from
   retrying immediately to sending unaligned write commands to the SCSI error
   handler.

Bart Van Assche (7):
  block: Introduce the use_zone_write_lock member variable
  block/mq-deadline: Only use zone locking if necessary
  scsi: core: Retry unaligned zoned writes
  scsi: scsi_debug: Support disabling zone write locking
  scsi: scsi_debug: Support injecting unaligned write errors
  scsi: ufs: Split an if-condition
  scsi: ufs: Disable zone write locking

 block/blk-settings.c      |  6 ++++++
 block/mq-deadline.c       | 24 ++++++++++++++++------
 drivers/scsi/scsi_debug.c | 20 ++++++++++++++++++-
 drivers/scsi/scsi_error.c | 37 ++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c   |  1 +
 drivers/scsi/sd.c         |  3 +++
 drivers/ufs/core/ufshcd.c | 42 ++++++++++++++++++++++++++++++++++++---
 include/linux/blkdev.h    |  1 +
 include/scsi/scsi.h       |  1 +
 9 files changed, 125 insertions(+), 10 deletions(-)

