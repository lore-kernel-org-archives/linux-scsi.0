Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 093CAC25B5C
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Aug 2023 19:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345904AbjHPTzV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Aug 2023 15:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345905AbjHPTzC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2023 15:55:02 -0400
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20FDE6B;
        Wed, 16 Aug 2023 12:55:00 -0700 (PDT)
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-565f24a5c20so146712a12.1;
        Wed, 16 Aug 2023 12:55:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692215700; x=1692820500;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j+E87ZxpjzgRZ6hqmzAUuSWQPj2isw7kq8DrCbnK33I=;
        b=ep2FDkSZIJKaeMNlg+fp8DKRY3LLf+7mPce/WIJUHedOIp1uN09x3biddomkSNmNav
         3lsl7dkulfdUSWsJFoFxij2j+UkkMB6v/+zruNePewBN8SB36GMdarifuOoJNFAHhzeh
         rq91Yf8OlKwX9trm82B0WBiid2dYdCqEOpan3VtmDbW5aiXgKU1tN9F5+6nNucRxA+ZA
         F/tp2BDH9a3GFzhiaF0Xlx1CdDNYW6INI7ukST5E8fGpG40n5SxluXHHNzBvJMfKtPfV
         AUk0t6WOZrzIOp9R791U6ziiEG6/oRYtV7JmrE0ioOMYnCekND1kJvO1N7nI5IrSu5zb
         Npnw==
X-Gm-Message-State: AOJu0YwYGduqUE4iXSH6ikZJo2AE+LP6yyqtDqNM9/5/dudcEEzHIQ+H
        x8Us8YBGSSsL6vPW/9z+s6g=
X-Google-Smtp-Source: AGHT+IFB4hoQKHgr06GkX/IdHUx/XP2yl7PPszedLI1/oWs35NfLy27AaEdVdVaqlgyjnbLQYs2o9g==
X-Received: by 2002:a05:6a20:258f:b0:13e:2080:ab91 with SMTP id k15-20020a056a20258f00b0013e2080ab91mr729787pzd.28.1692215699969;
        Wed, 16 Aug 2023 12:54:59 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7141:e456:f574:7de0])
        by smtp.gmail.com with ESMTPSA id r26-20020a62e41a000000b0068890c19c49sm1588508pfh.180.2023.08.16.12.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 12:54:59 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v9 00/17] Improve performance for zoned UFS devices
Date:   Wed, 16 Aug 2023 12:53:12 -0700
Message-ID: <20230816195447.3703954-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Jens,

This patch series improves small write IOPS by a factor of four (+300%) for
zoned UFS devices on my test setup with an UFSHCI 3.0 controller. Please
consider this patch series for the next merge window.

Thank you,

Bart.

Changes compared to v8:
 - Fixed handling of 'driver_preserves_write_order' and 'use_zone_write_lock'
   in blk_stack_limits().
 - Added a comment in disk_set_zoned().
 - Modified blk_req_needs_zone_write_lock() such that it returns false if
   q->limits.use_zone_write_lock is false.
 - Modified disk_clear_zone_settings() such that it clears
   q->limits.use_zone_write_lock.
 - Left out one change from the mq-deadline patch that became superfluous due to
   the blk_req_needs_zone_write_lock() change.
 - Modified scsi_call_prepare_resubmit() such that it only calls list_sort() if
   zoned writes have to be resubmitted for which zone write locking is disabled.
 - Added an additional unit test for scsi_call_prepare_resubmit().
 - Modified the sorting code in the sd driver such that only those SCSI commands
   are sorted for which write locking is disabled.
 - Modified sd_zbc.c such that ELEVATOR_F_ZBD_SEQ_WRITE is only set if the
   write order is not preserved.
 - Included three patches for UFS host drivers that rework code that wrote
   directly to the auto-hibernation controller register.
 - Modified the UFS driver such that enabling auto-hibernation is not allowed
   if a zoned logical unit is present and if the controller operates in legacy
   mode.
 - Also in the UFS driver, simplified ufshcd_auto_hibern8_update().

Changes compared to v7:
 - Split the queue_limits member variable `use_zone_write_lock' into two member
   variables: `use_zone_write_lock' (set by disk_set_zoned()) and
   `driver_preserves_write_order' (set by the block driver or SCSI LLD). This
   should clear up the confusion about the purpose of this variable.
 - Moved the code for sorting SCSI commands by LBA from the SCSI error handler
   into the SCSI disk (sd) driver as requested by Christoph.
   
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

Bart Van Assche (17):
  block: Introduce more member variables related to zone write locking
  block: Only use write locking if necessary
  block/mq-deadline: Only use zone locking if necessary
  scsi: core: Call .eh_prepare_resubmit() before resubmitting
  scsi: core: Add unit tests for scsi_call_prepare_resubmit()
  scsi: sd: Sort commands by LBA before resubmitting
  scsi: core: Retry unaligned zoned writes
  scsi: sd_zbc: Only require an I/O scheduler if needed
  scsi: scsi_debug: Support disabling zone write locking
  scsi: scsi_debug: Support injecting unaligned write errors
  scsi: ufs: hisi: Rework the code that disables auto-hibernation
  scsi: ufs: mediatek: Rework the code for disabling auto-hibernation
  scsi: ufs: sprd: Rework the code for disabling auto-hibernation
  scsi: ufs: Rename ufshcd_auto_hibern8_enable() and make it static
  scsi: ufs: Simplify ufshcd_auto_hibern8_update()
  scsi: ufs: Forbid auto-hibernation without I/O scheduler
  scsi: ufs: Inform the block layer about write ordering

 block/blk-settings.c            |  15 +++
 block/blk-zoned.c               |  10 +-
 block/mq-deadline.c             |  11 +-
 drivers/scsi/Kconfig            |   2 +
 drivers/scsi/Kconfig.kunit      |   4 +
 drivers/scsi/Makefile           |   2 +
 drivers/scsi/Makefile.kunit     |   1 +
 drivers/scsi/scsi_debug.c       |  20 +++-
 drivers/scsi/scsi_error.c       |  81 +++++++++++++
 drivers/scsi/scsi_error_test.c  | 196 ++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c         |   1 +
 drivers/scsi/scsi_priv.h        |   1 +
 drivers/scsi/sd.c               |  41 +++++++
 drivers/scsi/sd_zbc.c           |   4 +-
 drivers/ufs/core/ufs-sysfs.c    |   2 +-
 drivers/ufs/core/ufshcd-priv.h  |   1 -
 drivers/ufs/core/ufshcd.c       | 110 ++++++++++++++----
 drivers/ufs/host/ufs-hisi.c     |   5 +-
 drivers/ufs/host/ufs-mediatek.c |   2 +-
 drivers/ufs/host/ufs-sprd.c     |  11 +-
 include/linux/blkdev.h          |  10 ++
 include/scsi/scsi.h             |   1 +
 include/scsi/scsi_driver.h      |   1 +
 include/ufs/ufshcd.h            |   3 +-
 24 files changed, 485 insertions(+), 50 deletions(-)
 create mode 100644 drivers/scsi/Kconfig.kunit
 create mode 100644 drivers/scsi/Makefile.kunit
 create mode 100644 drivers/scsi/scsi_error_test.c

