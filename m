Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F2F4CDB483
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Oct 2023 17:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbjJRR4R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Oct 2023 13:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbjJRR4P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Oct 2023 13:56:15 -0400
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5718111;
        Wed, 18 Oct 2023 10:56:13 -0700 (PDT)
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-581e819cf28so949259eaf.3;
        Wed, 18 Oct 2023 10:56:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697651773; x=1698256573;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YYNKMom8jjXqDEBH9HFAMvNyP6hcy2d5eSZ+OrY9FFU=;
        b=CVgtHr/kF/aPyJLhsHIG2aVmkyZhuOMpQQUNi1tBdXIGuGxmFeQnCc3oZ3H+qdkTim
         X8HGeBpuxQwIF18ZJzYMFEYMFKmCUHgLp+CxRqQbGGkQw0Qf3TPFeICHHb3ZPEfvWxgZ
         QWm8Y+D4UpyCa4JaR+rzhfET3YCKyBdinaZkP5UmGnqE0qnXpZ9wNJD5vDY8G6/mZK/O
         +gaxArMFyJOzoF79NkkeGKZL9wXHqQbRIt1/yV6cCoqMUpMB27fqmv+X17MhcS5wDGvf
         WQ3Ob4FONRpgIarNj2xgo3aoLiUVh+hGJPH4txUnwemtH6iHcxLDc0dGfPJ/XQtvUlMa
         GGEg==
X-Gm-Message-State: AOJu0YzrtiLW2L53il9Ri/q0xHSxyI2EuLDTj9djq71VyPoyM5+KhzcU
        2beLAUYzyvBwcQEWn4Iec4Y=
X-Google-Smtp-Source: AGHT+IFhxxegUXAufWaeBDIwiKwceMI1SJ+QNTTVbgeOw8KTx8f6Ali1HcNjof9L9omluoDWF5/ZFQ==
X-Received: by 2002:a05:6359:6c17:b0:142:fd2b:d30c with SMTP id tc23-20020a0563596c1700b00142fd2bd30cmr4581823rwb.23.1697651772706;
        Wed, 18 Oct 2023 10:56:12 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:66c1:dd00:1e1e:add3])
        by smtp.gmail.com with ESMTPSA id p15-20020aa7860f000000b00690cd981652sm3628612pfn.61.2023.10.18.10.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Oct 2023 10:56:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v13 00/18] Improve write performance for zoned UFS devices
Date:   Wed, 18 Oct 2023 10:54:22 -0700
Message-ID: <20231018175602.2148415-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
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

Changes compared to v12:
 - Added two new patches: "block: Preserve the order of requeued zoned writes"
   and "scsi: sd: Add a unit test for sd_cmp_sector()"
 - Restricted the number of zoned write retries. To my surprise I had to add
   "&& scmd->retries <= scmd->allowed" in the SCSI error handler to limit the
   number of retries.
 - In patch "scsi: ufs: Inform the block layer about write ordering", only set
   ELEVATOR_F_ZBD_SEQ_WRITE for zoned block devices.

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

Bart Van Assche (18):
  block: Introduce more member variables related to zone write locking
  block: Only use write locking if necessary
  block: Preserve the order of requeued zoned writes
  block/mq-deadline: Only use zone locking if necessary
  scsi: core: Introduce a mechanism for reordering requests in the error
    handler
  scsi: core: Add unit tests for scsi_call_prepare_resubmit()
  scsi: sd: Sort commands by LBA before resubmitting
  scsi: sd: Add a unit test for sd_cmp_sector()
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

 block/blk-mq.c                 |   4 +-
 block/blk-settings.c           |  15 +++
 block/blk-zoned.c              |  10 +-
 block/mq-deadline.c            |  11 +-
 drivers/scsi/Kconfig           |   2 +
 drivers/scsi/Kconfig.kunit     |   9 ++
 drivers/scsi/Makefile          |   2 +
 drivers/scsi/Makefile.kunit    |   2 +
 drivers/scsi/scsi_debug.c      |  21 +++-
 drivers/scsi/scsi_error.c      |  91 +++++++++++++++
 drivers/scsi/scsi_error_test.c | 207 +++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c        |   1 +
 drivers/scsi/scsi_priv.h       |   1 +
 drivers/scsi/sd.c              |  52 +++++++++
 drivers/scsi/sd.h              |   2 +
 drivers/scsi/sd_test.c         |  91 +++++++++++++++
 drivers/scsi/sd_zbc.c          |   4 +-
 drivers/ufs/core/ufs-sysfs.c   |   2 +-
 drivers/ufs/core/ufshcd-priv.h |   1 -
 drivers/ufs/core/ufshcd.c      | 118 +++++++++++++++----
 drivers/ufs/host/ufs-hisi.c    |   5 +-
 include/linux/blkdev.h         |  10 ++
 include/scsi/scsi.h            |   1 +
 include/scsi/scsi_driver.h     |   2 +
 include/ufs/ufshcd.h           |   3 +-
 25 files changed, 626 insertions(+), 41 deletions(-)
 create mode 100644 drivers/scsi/Kconfig.kunit
 create mode 100644 drivers/scsi/Makefile.kunit
 create mode 100644 drivers/scsi/scsi_error_test.c
 create mode 100644 drivers/scsi/sd_test.c

