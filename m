Return-Path: <SRS0=+0y/=5S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CD1BC43331
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 15:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C932D20737
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 15:52:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="hnUfbYNS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389458AbgDBPwF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Apr 2020 11:52:05 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37054 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389241AbgDBPwF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2020 11:52:05 -0400
Received: by mail-pj1-f66.google.com with SMTP id k3so1667149pjj.2
        for <linux-scsi@vger.kernel.org>; Thu, 02 Apr 2020 08:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=53EevbSsJHKTeq9s0IC3tQ9L0J1W+vMWAqSDuwkHqVk=;
        b=hnUfbYNShzJoidHGNUR989NwioR4qzZOhooPJ+fqHC852NAHPbteoeLIrFP+9Abvrk
         kd9cMxkNIU0dKxnPV58SMtnHXcdQZVtnYDxUQkMJcQfnxwQ6PqdbnrlIg+4+MBZWAG75
         7cG/w/cTwSUkBBeHfCHcBSR0ayXe+nF5HX/oI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=53EevbSsJHKTeq9s0IC3tQ9L0J1W+vMWAqSDuwkHqVk=;
        b=sT8DKnmjWPsR30lhnqEbtfTbPeab1dqq08VxLeGYBWQMy7NnHtHBiAQL0sd0rKsAr8
         O2CwYbhadpn93WQ0OqIBDCO3LPKAo+1eJHvCe9u81JgiokhIU6M75ffJUNVGoAaD80kl
         L5FpcXmm+uma7XyOR7Cg1/pipqQhs8W3ATGyO1xjtW3E0dFJVy3S64RCeAdnFz/7Ao/q
         Mh3f7GellEeNRwW5hT60SOY9+dyXi6slCyzG1QXp8/CXL83woBVMkOufHMdonqX9Lb4O
         3FWI3rpP1Zljk8L6bImxqXAxgSsye/rsNvU5km+qElWDnppA7po/sfYOX7Mp+SUZhK0O
         g5CA==
X-Gm-Message-State: AGi0PuaCUgKvibD2PfNqB4tzXrFr1Ea//in/91wesuZ5ZXIQRw8jBfCg
        2ipesYIH4HfR15yQx7B4HyJPDQ==
X-Google-Smtp-Source: APiQypIEEhOEPCQbbgYFfbiYTmmYZHjny8hB9JCWz1W4N8EfmbXxbelQJ90O7FdrjCwpWqdOWigUaQ==
X-Received: by 2002:a17:902:449:: with SMTP id 67mr3383633ple.339.1585842723755;
        Thu, 02 Apr 2020 08:52:03 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id x68sm2578815pfb.5.2020.04.02.08.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 08:52:02 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     paolo.valente@linaro.org, sqazi@google.com,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, groeck@chromium.org,
        Douglas Anderson <dianders@chromium.org>,
        Ajay Joshi <ajay.joshi@wdc.com>, Arnd Bergmann <arnd@arndb.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hou Tao <houtao1@huawei.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] blk-mq: Fix two causes of IO stalls found in reboot testing
Date:   Thu,  2 Apr 2020 08:51:28 -0700
Message-Id: <20200402155130.8264-1-dianders@chromium.org>
X-Mailer: git-send-email 2.26.0.rc2.310.g2932bb562d-goog
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
hctx->dispatch.  This is why we need both fixes or a heavier hammer
where we always kick whenever two threads request budget at the same
time.

Most of my testing has been atop Chrome OS 5.4's kernel tree which
currently has v5.4.28 merged in.  The Chrome OS 5.4 tree also has a
patch by Salman Qazi, namely ("block: Limit number of items taken from
the I/O scheduler in one go").  Reverting that patch didn't make the
hung tasks go away, so I kept it in for most of my testing.

I have also done some testing on mainline Linux (git describe says I'm
on v5.6-rc7-227-gf3e69428b5e2) even without Salman's patch.  I found
that I could reproduce the problems there and that traces looked about
the same as I saw on the downstream branch.  These patches were also
confirmed to fix the problems on mainline.

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

Changes in v2:
- Replace ("scsi: core: Fix stall...") w/ ("blk-mq: Rerun dispatch...")

Douglas Anderson (2):
  blk-mq: In blk_mq_dispatch_rq_list() "no budget" is a reason to kick
  blk-mq: Rerun dispatching in the case of budget contention

 block/blk-mq-sched.c   | 26 ++++++++++++++++++++++++--
 block/blk-mq.c         | 14 +++++++++++---
 include/linux/blkdev.h |  2 ++
 3 files changed, 37 insertions(+), 5 deletions(-)

-- 
2.26.0.rc2.310.g2932bb562d-goog

