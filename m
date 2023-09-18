Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7274CD37B0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Sep 2023 16:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbjIRQ5d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbjIRQ5c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2023 12:57:32 -0400
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278E98E;
        Mon, 18 Sep 2023 09:57:26 -0700 (PDT)
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-68fbbea0dfeso3656239b3a.0;
        Mon, 18 Sep 2023 09:57:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695056245; x=1695661045;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z0JewZoZDknEfGxSVW6hX4nAQhzffYOZMsj/WncWodQ=;
        b=DZbOV+AheGKFJSINclKSnBflLkEKm9uRc2AEAlfRIGj95Abvgci5Joih6qqDsyDkCG
         4AHVwUb34DgLl4mFc+aZShLg/rDvuy39zEz6yq5zmIzwnF2a+6y4iMTiktezm+6dMFeE
         +o3UZhgnyajKrQeUhKp+uH4yFQk8gQQiErRpl3YFQFxQgNUWCMA41rlX5LcJ29L/ENZ+
         IoRzKhoDm0EY69Hovzh+eImC/w164ZvcokmMVZmdtqESbiLI4LAYBZIdInqPURk+23KX
         vLJ20cyyT2OOm3uJ7ahW9n+wpEGIhCFTkl8GhjVVXr5BhWJS7aGG9Zi8xhOtOsIFzpNo
         411A==
X-Gm-Message-State: AOJu0YyUvvoK7KRjbEobP7LmNODD5LJJnHNPfJsauFdKoUuSs79IRdag
        ftfSDHRjOT6sFWLs/LHcJbzHNYmZ510=
X-Google-Smtp-Source: AGHT+IFda1+0kIikICKwpz/lY7B5ik39eLITbBMQoqa9gc8W4bt9mDHk/ENePcknukKYjFYgoI4HcQ==
X-Received: by 2002:a05:6a21:818f:b0:13a:43e8:3fa6 with SMTP id pd15-20020a056a21818f00b0013a43e83fa6mr7438684pzb.23.1695056245406;
        Mon, 18 Sep 2023 09:57:25 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:33e7:1437:5d00:8e3b])
        by smtp.gmail.com with ESMTPSA id p17-20020a639511000000b005740aa41237sm5658041pgd.74.2023.09.18.09.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 09:57:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v12 00/16] Improve write performance for zoned UFS devices
Date:   Mon, 18 Sep 2023 09:55:39 -0700
Message-ID: <20230918165713.1598705-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
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

Changes compared to v11:
 - Fixed a NULL pointer dereference that happened when booting from an ATA
   device by adding an scmd->device != NULL check in scsi_needs_preparation().
 - Updated Reviewed-by tags.

Changes compared to v10:
 - Dropped the UFS MediaTek and HiSilicon patches because these are not correct
   and because it is safe to drop these patches.
 - Updated Acked-by / Reviewed-by tags.

Changes compared to v9:
 - Introduced an additional scsi_driver callback: .eh_needs_prepare_resubmit().
 - Renamed the scsi_debug kernel module parameter 'no_zone_write_lock' into
   'preserves_write_order'.
 - Fixed an out-of-bounds access in the unit scsi_call_prepare_resubmit() unit
   test.
 - Wrapped ufshcd_auto_hibern8_update() calls in UFS host drivers with
   WARN_ON_ONCE() such that a kernel stack appears in case an error code is
   returned.
 - Elaborated a comment in the UFSHCI driver.

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

Bart Van Assche (16):
  block: Introduce more member variables related to zone write locking
  block: Only use write locking if necessary
  block/mq-deadline: Only use zone locking if necessary
  scsi: core: Introduce a mechanism for reordering requests in the error
    handler
  scsi: core: Add unit tests for scsi_call_prepare_resubmit()
  scsi: sd: Sort commands by LBA before resubmitting
  scsi: core: Retry unaligned zoned writes
  scsi: sd_zbc: Only require an I/O scheduler if needed
  scsi: scsi_debug: Add the preserves_write_order module parameter
  scsi: scsi_debug: Support injecting unaligned write errors
  scsi: ufs: hisi: Rework the code that disables auto-hibernation
  scsi: ufs: Rename ufshcd_auto_hibern8_enable() and make it static
  scsi: ufs: Change the return type of ufshcd_auto_hibern8_update()
  scsi: ufs: Simplify ufshcd_auto_hibern8_update()
  scsi: ufs: Forbid auto-hibernation without I/O scheduler
  scsi: ufs: Inform the block layer about write ordering

 block/blk-settings.c           |  15 +++
 block/blk-zoned.c              |  10 +-
 block/mq-deadline.c            |  11 +-
 drivers/scsi/Kconfig           |   2 +
 drivers/scsi/Kconfig.kunit     |   4 +
 drivers/scsi/Makefile          |   2 +
 drivers/scsi/Makefile.kunit    |   1 +
 drivers/scsi/scsi_debug.c      |  21 +++-
 drivers/scsi/scsi_error.c      |  91 +++++++++++++++
 drivers/scsi/scsi_error_test.c | 207 +++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c        |   1 +
 drivers/scsi/scsi_priv.h       |   1 +
 drivers/scsi/sd.c              |  49 ++++++++
 drivers/scsi/sd_zbc.c          |   4 +-
 drivers/ufs/core/ufs-sysfs.c   |   2 +-
 drivers/ufs/core/ufshcd-priv.h |   1 -
 drivers/ufs/core/ufshcd.c      | 117 +++++++++++++++----
 drivers/ufs/host/ufs-hisi.c    |   5 +-
 include/linux/blkdev.h         |  10 ++
 include/scsi/scsi.h            |   1 +
 include/scsi/scsi_driver.h     |   2 +
 include/ufs/ufshcd.h           |   3 +-
 22 files changed, 520 insertions(+), 40 deletions(-)
 create mode 100644 drivers/scsi/Kconfig.kunit
 create mode 100644 drivers/scsi/Makefile.kunit
 create mode 100644 drivers/scsi/scsi_error_test.c

