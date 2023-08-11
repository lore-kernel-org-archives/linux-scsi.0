Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F046C0015E
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Aug 2023 21:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236941AbjHKVgK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Aug 2023 17:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbjHKVgJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Aug 2023 17:36:09 -0400
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A41213F;
        Fri, 11 Aug 2023 14:36:09 -0700 (PDT)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1bbf8cb694aso21064425ad.3;
        Fri, 11 Aug 2023 14:36:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691789769; x=1692394569;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZP2zWZCEMkImhnIX+u/m9IfTzgWoVmIHljvmPKpsZus=;
        b=lwam60Qa5A4dDnqA6qXjRP/yEr0ki1zVtLV+6SUzlrQcxJvWpkHztffYM3ITsSlPlR
         bWPAFwDHPrFytulsgejNSHyPzuc0J7RRQ2ZxeTa/ikGoPaqjBsuFXaehCisUsyhB0qHL
         p9iiDK9Ez/vi+4HNCdobDKxa+xM5CJu6blx4slpdu5DdnNUh1jzHKkKE0C3XwRn9xTNm
         zNpXIrvemHLTXEbbSC6G6tBwEWSsAr71Cx9oKzmqzUw5lMcg+4amo+lTqcXJzYA54d79
         JqlH9yImT0CJjZ6liFeIKL+zLCx9DIeLUWscZsz6cM5Gf6DfyWa8vrFWRRckFO1k3/HP
         nupw==
X-Gm-Message-State: AOJu0YxPC194jiTsES/D+FTqAYZqqoZMnVaZYFc9HOVeC4XufOFzZIjg
        W7ipFg6sqI0ZAfyiaGPj1QI=
X-Google-Smtp-Source: AGHT+IH8OgZ8pKXOo5AFotp14Xd8C4Zb10B4P6QkS78jJPyGh88JhdSvnymlNG40m6wf+eH3gOyKoA==
X-Received: by 2002:a17:902:ecc5:b0:1bc:7001:6e5e with SMTP id a5-20020a170902ecc500b001bc70016e5emr3511910plh.32.1691789768566;
        Fri, 11 Aug 2023 14:36:08 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:cdd8:4c3:2f3c:adea])
        by smtp.gmail.com with ESMTPSA id c10-20020a170903234a00b001b89c313185sm4394865plh.205.2023.08.11.14.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 14:36:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v8 0/9] Improve performance for zoned UFS devices
Date:   Fri, 11 Aug 2023 14:35:34 -0700
Message-ID: <20230811213604.548235-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
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

Bart Van Assche (9):
  block: Introduce more member variables related to zone write locking
  block/mq-deadline: Only use zone locking if necessary
  scsi: core: Call .eh_prepare_resubmit() before resubmitting
  scsi: sd: Sort commands by LBA before resubmitting
  scsi: core: Retry unaligned zoned writes
  scsi: scsi_debug: Support disabling zone write locking
  scsi: scsi_debug: Support injecting unaligned write errors
  scsi: ufs: Split an if-condition
  scsi: ufs: Inform the block layer about write ordering

 block/blk-settings.c           |  7 +++
 block/mq-deadline.c            | 14 +++---
 drivers/scsi/Kconfig           |  2 +
 drivers/scsi/Kconfig.kunit     |  4 ++
 drivers/scsi/Makefile          |  2 +
 drivers/scsi/Makefile.kunit    |  1 +
 drivers/scsi/scsi_debug.c      | 20 +++++++-
 drivers/scsi/scsi_error.c      | 59 ++++++++++++++++++++++
 drivers/scsi/scsi_error_test.c | 92 ++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c        |  1 +
 drivers/scsi/scsi_priv.h       |  1 +
 drivers/scsi/sd.c              | 25 +++++++++
 drivers/ufs/core/ufshcd.c      | 40 +++++++++++++--
 include/linux/blkdev.h         | 10 ++++
 include/scsi/scsi.h            |  1 +
 include/scsi/scsi_driver.h     |  1 +
 16 files changed, 270 insertions(+), 10 deletions(-)
 create mode 100644 drivers/scsi/Kconfig.kunit
 create mode 100644 drivers/scsi/Makefile.kunit
 create mode 100644 drivers/scsi/scsi_error_test.c

