Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15AAAEE4993
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Aug 2023 19:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjHVTSr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 15:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjHVTSr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 15:18:47 -0400
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01ACDCD2;
        Tue, 22 Aug 2023 12:18:44 -0700 (PDT)
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-564cd28d48dso2787195a12.0;
        Tue, 22 Aug 2023 12:18:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692731923; x=1693336723;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ajIorwPqtCFSlxSaD0jFCANn9MKhLAabjEUYdnRNkTo=;
        b=HxbUL/ydcrUbnLERsoMc+j2PeNRqBw330wM1L5GAyxNRJsENwdV1OutG/0bsTQHQqA
         djyAvsjVAXVmkvq/I97cL1VQOWLuNGqSJN8Huhb+aryHDSQynYzb51G+I9mZtqnkbrrB
         Mzy9mJKQjypzb8DyljPRa0LwJJPEnNAFecMcGKxXbSpcrWkYFPMWLXsq5kt7dvSm+2jy
         wLkZVy/ImOf/gpNKfPO2EKVz+if0E6PJLhkPaydbUa6VQOj7l5bkjg4RJ86tpiITTuUv
         igPQZjcJNLcBUKEaLbFijdp1WNUCrImSYfahOzBQvuSQybk7orPddeZXpWgfwb7F2PP3
         hn5g==
X-Gm-Message-State: AOJu0Yzr19tnC6etQb0IEDK+BphGjGQ8M5OF2eTD5/8tpJ449NOlJxMO
        ipxsa2+o0qEwAjmSQ26pxPrfPO4LF+g=
X-Google-Smtp-Source: AGHT+IF3COvh3BB/r6zb5RnPv+WTpjFhUL37d6Dq18wIDP6S3cdPDVn2JbUPiQZwhzEAINMDYbewfw==
X-Received: by 2002:a17:90a:43e2:b0:268:81c6:a01f with SMTP id r89-20020a17090a43e200b0026881c6a01fmr7226556pjg.26.1692731923296;
        Tue, 22 Aug 2023 12:18:43 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:88be:bf57:de29:7cc])
        by smtp.gmail.com with ESMTPSA id m11-20020a17090a414b00b002696bd123e4sm8081632pjg.46.2023.08.22.12.18.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 12:18:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v11 00/16] Improve write performance for zoned UFS devices
Date:   Tue, 22 Aug 2023 12:16:55 -0700
Message-ID: <20230822191822.337080-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
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
 drivers/scsi/scsi_error.c      |  81 +++++++++++++
 drivers/scsi/scsi_error_test.c | 207 +++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c        |   1 +
 drivers/scsi/scsi_priv.h       |   1 +
 drivers/scsi/sd.c              |  51 ++++++++
 drivers/scsi/sd_zbc.c          |   4 +-
 drivers/ufs/core/ufs-sysfs.c   |   2 +-
 drivers/ufs/core/ufshcd-priv.h |   1 -
 drivers/ufs/core/ufshcd.c      | 114 ++++++++++++++----
 drivers/ufs/host/ufs-hisi.c    |   5 +-
 include/linux/blkdev.h         |  10 ++
 include/scsi/scsi.h            |   1 +
 include/scsi/scsi_driver.h     |   2 +
 include/ufs/ufshcd.h           |   3 +-
 22 files changed, 509 insertions(+), 40 deletions(-)
 create mode 100644 drivers/scsi/Kconfig.kunit
 create mode 100644 drivers/scsi/Makefile.kunit
 create mode 100644 drivers/scsi/scsi_error_test.c

