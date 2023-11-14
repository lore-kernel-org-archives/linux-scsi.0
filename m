Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47BCAC4167B
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 21:18:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbjKNVSR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Nov 2023 16:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjKNVSQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Nov 2023 16:18:16 -0500
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D99C3;
        Tue, 14 Nov 2023 13:18:11 -0800 (PST)
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-5be30d543c4so2840760a12.2;
        Tue, 14 Nov 2023 13:18:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699996691; x=1700601491;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LIi80d0wTdAiKH84WVt7O7Wmuj2gOT+jI6c8jCsMHMc=;
        b=eG5OjLlne/DrjkXWyRAcOJQn88A7/5FtN32x74cYCYVU6zbsWWg5WUMsapPjfhbtYr
         Krtn3g6TVXodD7SQmtA2ZzgZ55DheY4peeQJmQlWdn7rUrgB89hJsFtot3g+YI/dCj47
         6OkryvZNrpp0VZFGymA1PfIhcZscfiory5Yc+XD7xpTp+B3PsSfKrF/Kbery+aEdhhvU
         YIatNULXFRObsd516MwenKr/a3K7UKsgoe9VozRfChMkbG6QfXRS36wqYNsB8BMxG6Tj
         +ZSa/TNk/uq3vxMMHsAgQfIwQvbY9meSq1aDGNPktz+i7POUGFCnxLDUalOdZeMiCS7a
         Rv5g==
X-Gm-Message-State: AOJu0Yxaob2fIF0vLwaLWDXaiy/zl1/9RiyS9AyHNCoLsUHJPtdafJjj
        lKcRZ+4qkSlioHVcE+S4LHk=
X-Google-Smtp-Source: AGHT+IFQPrJwlq7zf6DvhsFUcHQxbcFaxlVhthZYbedRRtb8JGUdzhl/mV0LfBP29jWtiv/frlocyA==
X-Received: by 2002:a17:90b:3849:b0:280:aa7b:fbe8 with SMTP id nl9-20020a17090b384900b00280aa7bfbe8mr9120186pjb.32.1699996691219;
        Tue, 14 Nov 2023 13:18:11 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:2278:ad72:cefb:4d49])
        by smtp.gmail.com with ESMTPSA id ix7-20020a170902f80700b001c71ec1866fsm6169288plb.258.2023.11.14.13.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 13:18:10 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: =?UTF-8?q?=5BPATCH=20v15=2000/19=5D=20Improve=20write=20performance=20for=20zoned=20UFS=20devices=E2=80=8B?=
Date:   Tue, 14 Nov 2023 13:16:08 -0800
Message-ID: <20231114211804.1449162-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series improves small write IOPS by a factor of four (+300%) for
zoned UFS devices on my test setup with an UFSHCI 3.0 controller. Please
consider this patch series for the next merge window.

Thank you,

Bart.

Changes compared to v14:
 - Removed the drivers/scsi/Kconfig.kunit and drivers/scsi/Makefile.kunit
   files. Instead, modified drivers/scsi/Kconfig and added #include "*_test.c"
   directives in the appropriate .c files. Removed the EXPORT_SYMBOL()
   directives that were added to make the unit tests link.
 - Fixed a double free in a unit test.

Changes compared to v13:
 - Reworked patch "block: Preserve the order of requeued zoned writes".
 - Addressed a performance concern by removing the eh_needs_prepare_resubmit
   SCSI driver callback and by introducing the SCSI host template flag
   .needs_prepare_resubmit instead.
 - Added a patch that adds a 'host' argument to scsi_eh_flush_done_q().
 - Made the code in unit tests less repetitive.

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

Bart Van Assche (19):
  block: Introduce more member variables related to zone write locking
  block: Only use write locking if necessary
  block: Preserve the order of requeued zoned writes
  block/mq-deadline: Only use zone locking if necessary
  scsi: Pass SCSI host pointer to scsi_eh_flush_done_q()
  scsi: core: Introduce a mechanism for reordering requests in the error
    handler
  scsi: core: Add unit tests for scsi_call_prepare_resubmit()
  scsi: sd: Support sorting commands by LBA before resubmitting
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

 block/blk-mq.c                      |   6 +-
 block/blk-settings.c                |  15 ++
 block/blk-zoned.c                   |  10 +-
 block/mq-deadline.c                 |  11 +-
 drivers/ata/libata-eh.c             |   2 +-
 drivers/scsi/Kconfig                |  10 ++
 drivers/scsi/constants.c            |   1 +
 drivers/scsi/libsas/sas_scsi_host.c |   2 +-
 drivers/scsi/scsi_debug.c           |  21 ++-
 drivers/scsi/scsi_error.c           |  77 ++++++++-
 drivers/scsi/scsi_error_test.c      | 233 ++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c             |   1 +
 drivers/scsi/sd.c                   |  44 ++++++
 drivers/scsi/sd_test.c              |  86 ++++++++++
 drivers/scsi/sd_zbc.c               |   4 +-
 drivers/ufs/core/ufs-sysfs.c        |   2 +-
 drivers/ufs/core/ufshcd-priv.h      |   1 -
 drivers/ufs/core/ufshcd.c           | 119 +++++++++++---
 drivers/ufs/host/ufs-hisi.c         |   5 +-
 include/linux/blkdev.h              |  10 ++
 include/scsi/scsi.h                 |   1 +
 include/scsi/scsi_driver.h          |   1 +
 include/scsi/scsi_eh.h              |   3 +-
 include/scsi/scsi_host.h            |   6 +
 include/ufs/ufshcd.h                |   3 +-
 25 files changed, 628 insertions(+), 46 deletions(-)
 create mode 100644 drivers/scsi/scsi_error_test.c
 create mode 100644 drivers/scsi/sd_test.c

