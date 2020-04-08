Return-Path: <SRS0=Y1+o=5Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 085DCC2BA1A
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 15:11:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB8B820747
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 15:11:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="LkpfPCBM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbgDHPLU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Apr 2020 11:11:20 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:37462 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728309AbgDHPLU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2020 11:11:20 -0400
Received: by mail-io1-f68.google.com with SMTP id n20so391066ioa.4
        for <linux-scsi@vger.kernel.org>; Wed, 08 Apr 2020 08:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SssEa34uyWGuXvyMVdQpqUpofdA5aXmoGGscUTPybO4=;
        b=LkpfPCBMz5VnGfzoWxExmYIpo0+FnFFGjJY1msnRJtTohUxZbu0BG52EXxkq6IBeuf
         ZZf+IObj/jLDbnZGwYQ7xiOI2IQsIBVjrZVTvh/8oz1mUI1bTJudCZFtMzBs/e2VQke+
         10kX6P7ZJlrLlWCp+Ri1Ros9d0kublJPJe4K4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SssEa34uyWGuXvyMVdQpqUpofdA5aXmoGGscUTPybO4=;
        b=RQWGuftzz6ECNCKcCkIvNgxJwrlztY2ngTqusY4xPLfAjP8k+XCCTTOq49giPvQJic
         7bc48GDU4bKUnwTUIq2L3QQXE/5OqOmjYCX2QnoJqfvN9iZxwk4ULDmzHPY+IqEt9yA2
         WA9fGIHg+dVuLco8coEAQTD6GVA0IXYHvCOgCfvj7MSzZvHlfXj5Z7Gcvak4CW8YTFoq
         tJf5mhjoW3op5A75JUfUKQjL9onmcOk+LDenNaMQR+dNJSep4VLEHoxxbiimkAbjvO4Y
         2ZJziLNmk/XmhiBNKo2VQFDBk7HvkfvrzyIoPQEFl3GXd8HeSFF6KvttT0uIMw562w2y
         EHhg==
X-Gm-Message-State: AGi0Pub6fIWSHT1gV8q8Pdp98N36gbBTvmYN3giy3ITeQcNzCaERMDXz
        xMGLG23gzypQnxkrE4AqGUZSkXnjgIWLaA==
X-Google-Smtp-Source: APiQypJ/jLI3GuzCIUnaE0J6LM/OrpH9vqwGhYBMjKYfjXiXGgMJd8Y15SYRX2g99IdcymrlbrcVqw==
X-Received: by 2002:a63:d143:: with SMTP id c3mr7174945pgj.171.1586358270481;
        Wed, 08 Apr 2020 08:04:30 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id d85sm1468083pfd.157.2020.04.08.08.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 08:04:30 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     paolo.valente@linaro.org, groeck@chromium.org,
        Gwendal Grignou <gwendal@chromium.org>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, sqazi@google.com,
        Douglas Anderson <dianders@chromium.org>,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        John Garry <john.garry@huawei.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Sagi Grimberg <sagi@grimberg.me>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/4] blk-mq: Fix two causes of IO stalls found in reboot testing
Date:   Wed,  8 Apr 2020 08:03:58 -0700
Message-Id: <20200408150402.21208-1-dianders@chromium.org>
X-Mailer: git-send-email 2.26.0.292.g33ef6b2f38-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

While doing reboot testing, I found that occasionally my device would
trigger the hung task detector.  Many tasks were stuck waiting for the
a blkdev mutex, but at least one task in the system was always sitting
waiting for IO to complete (and holding the blkdev mutex).  One
example of a task that was just waiting for its IO to complete on one
reboot:

 udevd           D    0  2177    306 0x00400209
 Call trace:
  __switch_to+0x15c/0x17c
  __schedule+0x6e0/0x928
  schedule+0x8c/0xbc
  schedule_timeout+0x9c/0xfc
  io_schedule_timeout+0x24/0x48
  do_wait_for_common+0xd0/0x160
  wait_for_completion_io_timeout+0x54/0x74
  blk_execute_rq+0x9c/0xd8
  __scsi_execute+0x104/0x198
  scsi_test_unit_ready+0xa0/0x154
  sd_check_events+0xb4/0x164
  disk_check_events+0x58/0x154
  disk_clear_events+0x74/0x110
  check_disk_change+0x28/0x6c
  sd_open+0x5c/0x130
  __blkdev_get+0x20c/0x3d4
  blkdev_get+0x74/0x170
  blkdev_open+0x94/0xa8
  do_dentry_open+0x268/0x3a0
  vfs_open+0x34/0x40
  path_openat+0x39c/0xdf4
  do_filp_open+0x90/0x10c
  do_sys_open+0x150/0x3c8
  ...

I've reproduced this on two systems: one boots from an internal UFS
disk and one from eMMC.  Each has a card reader attached via USB with
an SD card plugged in.  On the USB-attached SD card is a disk with 12
partitions (a Chrome OS test image), if it matters.  The system
doesn't do much with the USB disk other than probe it (it's plugged in
my system to help me recover).

From digging, I believe that there are two separate but related
issues.  Both issues relate to the SCSI code saying that there is no
budget.

I have done testing with only one or the other of the two patches in
this series and found that I could still encounter hung tasks if only
one of the two patches was applied.  This deserves a bit of
explanation.  To me, it's fairly obvious that the first fix wouldn't
fix the problems talked about in the second patch.  However, it's less
obvious why the second patch doesn't fix the problems in
blk_mq_dispatch_rq_list().  It turns out that it _almost_ does
(problems become much more rare), but I did manage to get a single
trace where the "kick" scheduled by the second patch happened really
quickly.  The scheduled kick then ran and found nothing to do.  This
happened in parallel to a task running in blk_mq_dispatch_rq_list()
which hadn't gotten around to splicing the list back into
hctx->dispatch.  This is why we need both fixes.

Most of my testing has been atop Chrome OS 5.4's kernel tree which
currently has v5.4.30 merged in.  The Chrome OS 5.4 tree also has a
patch by Salman Qazi, namely ("block: Limit number of items taken from
the I/O scheduler in one go").  Reverting that patch didn't make the
hung tasks go away, so I kept it in for most of my testing.

I have also done some testing on mainline Linux (most on what git
describe calls v5.6-rc7-227-gf3e69428b5e2) even without Salman's
patch.  I found that I could reproduce the problems there and that
traces looked about the same as I saw on the downstream branch.  These
patches were also confirmed to fix the problems on mainline.

Chrome OS is currently setup to use the BFQ scheduler and I found that
I couldn't reproduce the problems without BFQ.  As discussed in the
second patch this is believed to be because BFQ sometimes returns
"true" from has_work() but then NULL from dispatch_request().

I'll insert my usual caveat that I'm sending patches to code that I
know very little about.  If I'm making a total bozo patch here, please
help me figure out how I should fix the problems I found in a better
way.

If you want to see a total ridiculous amount of chatter where I
stumbled around a whole bunch trying to figure out what was wrong and
how to fix it, feel free to read <https://crbug.com/1061950>.  I
promise it will make your eyes glaze over right away if this cover
letter didn't already do that.  Specifically comment 79 in that bug
includes a link to my ugly prototype of making BFQ's has_work() more
exact (I only managed it by actually defining _both_ an exact and
inexact function to avoid circular locking problems when it was called
directly from blk_mq_hctx_has_pending()).  Comment 79 also has more
thoughts about alternatives considered.

I don't know if these fixes represent a regression of some sort or are
new.  As per above I could only reproduce with BFQ enabled which makes
it nearly impossible to go too far back with this.  I haven't listed
any "Fixes" tags here, but if someone felt it was appropriate to
backport this to some stable trees that seems like it'd be nice.
Presumably at least 5.4 stable would make sense.

Thanks to Salman Qazi, Paolo Valente, and Guenter Roeck who spent a
bunch of time helping me trawl through some of this code and reviewing
early versions of this patch.

Changes in v4:
- Only kick in blk_mq_do_dispatch_ctx() / blk_mq_do_dispatch_sched().

Changes in v3:
- Note why blk_mq_dispatch_rq_list() change is needed.
- ("blk-mq: Add blk_mq_delay_run_hw_queues() API call") new for v3
- Always kick when putting the budget.
- Delay blk_mq_do_dispatch_sched() kick by 3 ms for inexact has_work().
- Totally rewrote commit message.
- ("Revert "scsi: core: run queue...") new for v3.

Changes in v2:
- Replace ("scsi: core: Fix stall...") w/ ("blk-mq: Rerun dispatch...")

Douglas Anderson (4):
  blk-mq: In blk_mq_dispatch_rq_list() "no budget" is a reason to kick
  blk-mq: Add blk_mq_delay_run_hw_queues() API call
  blk-mq: Rerun dispatching in the case of budget contention
  Revert "scsi: core: run queue if SCSI device queue isn't ready and
    queue is idle"

 block/blk-mq-sched.c    | 18 ++++++++++++++++++
 block/blk-mq.c          | 30 +++++++++++++++++++++++++++---
 drivers/scsi/scsi_lib.c |  7 +------
 include/linux/blk-mq.h  |  1 +
 4 files changed, 47 insertions(+), 9 deletions(-)

-- 
2.26.0.292.g33ef6b2f38-goog

