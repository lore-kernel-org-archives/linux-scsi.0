Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCCC5C001DB
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Aug 2023 15:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbjHDPsa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Aug 2023 11:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbjHDPs2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2023 11:48:28 -0400
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2FA1734;
        Fri,  4 Aug 2023 08:48:27 -0700 (PDT)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-686be28e1a8so1659091b3a.0;
        Fri, 04 Aug 2023 08:48:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691164107; x=1691768907;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Svmb7vUiQmGpYLaHTeg+6W6igOZUZG/FFgL7GRXZI1U=;
        b=i51oxKM6fRYH2e9VyJNsFQej7LS7yCsG85gDLfVlx0v3urc34J94nvbMH4JH/sDH7Y
         I7r1WWPTyJMoljSS6kV2iD6ub4o6rKo1RZmq8yVHAM1fVTssftFidzHsGY7MR8XCLMZe
         DVNISVTP99EgX/q5Jl/dR3hjoYSq8bMhPCotBgcJFP3nFLWtL7HTD2adF0QwsL2ly+XQ
         Vmxysq5EaP6qx1/Ui8NPFJ1d/BexoMXlXs/q73CIt4LnIotCOnT/R1JIgsRXHZ8Qkynh
         6pv9grcp+m9z7nGxxtzxQdG7IybQnKfuqFJQ4/zXj99Mj8TjLkahiBPAf49NHAxjKtP8
         mXLQ==
X-Gm-Message-State: AOJu0Yxk8nPieljUdrPiM9qdKHt6KjOErCrHjOdUxx5xweKQ8HKpFymh
        unuWR/IGgM+nAKEZVS8Nrrk=
X-Google-Smtp-Source: AGHT+IExq15j5nygxevyTwWXOpRS7teppJxCEa2JUiqe6jwlhKcAr0bJr87U3hNBal33U0O2Im86zg==
X-Received: by 2002:a05:6a21:2703:b0:13f:9dbc:e530 with SMTP id rm3-20020a056a21270300b0013f9dbce530mr1504766pzb.8.1691164107101;
        Fri, 04 Aug 2023 08:48:27 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4af5:d063:a66d:403b])
        by smtp.gmail.com with ESMTPSA id h8-20020a62b408000000b00640ddad2e0dsm1760839pfn.47.2023.08.04.08.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Aug 2023 08:48:26 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v6 0/7] Improve performance for zoned UFS devices
Date:   Fri,  4 Aug 2023 08:47:58 -0700
Message-ID: <20230804154821.3232094-1-bvanassche@acm.org>
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
  block: Introduce the flag QUEUE_FLAG_NO_ZONE_WRITE_LOCK
  block/mq-deadline: Only use zone locking if necessary
  scsi: core: Retry unaligned zoned writes
  scsi: scsi_debug: Support disabling zone write locking
  scsi: scsi_debug: Support injecting unaligned write errors
  scsi: ufs: Split an if-condition
  scsi: ufs: Disable zone write locking

 block/mq-deadline.c       | 24 +++++++++++++++------
 drivers/scsi/scsi_debug.c | 20 ++++++++++++++++-
 drivers/scsi/scsi_error.c | 37 ++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c   |  1 +
 drivers/scsi/sd.c         |  3 +++
 drivers/ufs/core/ufshcd.c | 45 ++++++++++++++++++++++++++++++++++++---
 include/linux/blkdev.h    | 11 ++++++++++
 include/scsi/scsi.h       |  1 +
 8 files changed, 132 insertions(+), 10 deletions(-)

