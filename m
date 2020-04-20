Return-Path: <SRS0=Uzsj=6E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C85C3815B
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 16:25:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD40320B1F
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 16:25:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="gq2J9ids"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgDTQZY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 12:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726277AbgDTQZX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Apr 2020 12:25:23 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2075C061A10
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2020 09:25:23 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id y22so4137058pll.4
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2020 09:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h6O5pouxMkfS4MhUt15/M16e6wVyxSAERoX5vX/qg58=;
        b=gq2J9idsuEJjxnlb+/Y8Ex352DgS3Tc1trCPdBI569/qJnnFXkEsGqzz9usdZTrivG
         9vXpbwntbqZWzqRpx9K17dBuQgHIyOA8EqQmnfb6nPZ+GepXlR0ccrjhpQQJTMhSIkFD
         d8T6/EyV29q9u80HHhABX8Ux0EytBQoRdwLP4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h6O5pouxMkfS4MhUt15/M16e6wVyxSAERoX5vX/qg58=;
        b=fUCZB1FhlojlJYchis/eROKQ6qMS8ukFQbvsyLjwKCgPwN56m/xWmoxqVfr20InUZS
         fOCXmY4DIkQ+n1uxk4bKkDPrqs2/V0B7MMUMEC9oPWzrbC7Ti2ZcJTjTydJWrvUHtFuK
         v6LeieZOV2VktFH4H9CHizYJHyi2FdpLP3T56Rjy3mSUDdZE7LPzZvZAmPQ6F5rvpzJh
         jhgWzWnFaiXt6Atfwc2+lqZm5DJ5a7ZVb6Jg07VSXGbKiRInnMPbsMcdF8br7Sdvi+1e
         1IN5BhnvhLHyZ26otMMcPeo92MrgfuohUHFuOSY/3uOio7ategftGmU3i4myLRUSZAwM
         K6gg==
X-Gm-Message-State: AGi0PualI33ZjFw4cKWnIJFDzXFhv/axsLq2NuNbBp+SNS7nWoxIQOkK
        AdQCVIiGHrD5Q3Kt6KKiRvfxQA==
X-Google-Smtp-Source: APiQypJj4eX+FQrtw07KDqPc8UEQD7yoFZIghLv3NxJpjufkIJlEeOElVt6W7Haum8nXF6qey7N/9g==
X-Received: by 2002:a17:90a:dc01:: with SMTP id i1mr216076pjv.94.1587399922972;
        Mon, 20 Apr 2020 09:25:22 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id p64sm93150pjp.7.2020.04.20.09.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 09:25:22 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>,
        sqazi@google.com, groeck@chromium.org,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        paolo.valente@linaro.org, Douglas Anderson <dianders@chromium.org>,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        John Garry <john.garry@huawei.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Sagi Grimberg <sagi@grimberg.me>, linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/4] blk-mq: Fix two causes of IO stalls found in reboot testing
Date:   Mon, 20 Apr 2020 09:24:50 -0700
Message-Id: <20200420162454.48679-1-dianders@chromium.org>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
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

Changes in v5:
- Rebase atop commit 5fe56de799ad ("...Put driver tag...when no budget")

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
 block/blk-mq.c          | 27 +++++++++++++++++++++++++--
 drivers/scsi/scsi_lib.c |  7 +------
 include/linux/blk-mq.h  |  1 +
 4 files changed, 45 insertions(+), 8 deletions(-)

-- 
2.26.1.301.g55bc3eb7cb9-goog

