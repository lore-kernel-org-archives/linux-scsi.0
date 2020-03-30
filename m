Return-Path: <SRS0=+9Kw=5P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDFC3C2D0E5
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 14:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 922C220781
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 14:50:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="BI2bXz9J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgC3OuX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Mar 2020 10:50:23 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:40261 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgC3Ott (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Mar 2020 10:49:49 -0400
Received: by mail-pj1-f65.google.com with SMTP id kx8so7418112pjb.5
        for <linux-scsi@vger.kernel.org>; Mon, 30 Mar 2020 07:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wxokKJDNKMFQP8TduvPKlZRyw/xvX4p8PZKE/poLUcs=;
        b=BI2bXz9JW0Ja3fmTC65vw+5yLxMHKax69XlM02QwBhthxk9ja8mnYC9qep7ffRQon5
         9GpkYJeJDkAUXFRUfBvrqYVeqpKygk9VElxZDgpdD3oEtfeMhJHZqqyL3gvel4R3CR9E
         C2n+feDGjeSD9ogfLWGTZZCf7TuF1UcFkTzGQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wxokKJDNKMFQP8TduvPKlZRyw/xvX4p8PZKE/poLUcs=;
        b=awvCdtKggEUUrdfUSRPnJI1zUpLdsGPAcwa/02MYRgWHLzpYpK4gXuclDQIxssNP8X
         8VsKOfYd37Mq6+nNVe9BQlQg4rFuS90UHbM0bpidRmg3R+nLB1OIiYOyj/Gc1/eGsw1O
         5rhRpJ/fnqKOZRZRL7lQvs1Q3cAFwrFNuMvGni6vecHAzswPX2MDnNVTcD4HHn6mp9b6
         AsRbMYcEevz0UqRczg5XKCCagYt5lTG3RSNE6GlWxAX/ULLd87s+b8xzPnIctFsl7GrX
         j/Al9Tf2eMNEEjMVzOzOrV2ZqTfrAvZ2eWvYmc9pEymrqCDkxEKU5fDV46i5brrduzXY
         8U5g==
X-Gm-Message-State: ANhLgQ3g+Mee3fMpXhrfJu/E5m97+bZ1YzJKIbBMbFMG4pL2oTswLnVx
        f/7cbcVwKCXSXC7JYKoua2sCow==
X-Google-Smtp-Source: ADFU+vtXgURST9UkxUGS9nBDGF1TSE53YJGFU75fkGqIG44/V0AceUy6aiiUTYuxOtuZm2nXC/glsg==
X-Received: by 2002:a17:90b:d91:: with SMTP id bg17mr16307893pjb.70.1585579786967;
        Mon, 30 Mar 2020 07:49:46 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id y198sm1460972pfg.123.2020.03.30.07.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 07:49:46 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-block@vger.kernel.org, groeck@chromium.org,
        paolo.valente@linaro.org, linux-scsi@vger.kernel.org,
        sqazi@google.com, Douglas Anderson <dianders@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] blk-mq: Fix two causes of IO stalls found in reboot testing
Date:   Mon, 30 Mar 2020 07:49:04 -0700
Message-Id: <20200330144907.13011-1-dianders@chromium.org>
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
budget.  In one case it seems clear that the blk-mq code should have
restarted itself.  In another case it seems that we have to make the
SCSI code kick the queues.

I have done testing with only one or the other of the two patches in
this series and found that I could still encounter hung tasks if only
one of the two patches was applied.  This deserves a bit of
explanation.  To me, it's fairly obvious that the blk-mq wouldn't fix
the problems talked about in the scsi patch.  However, it's less
obvious why the scsi patch doesn't fix the problems in
blk_mq_dispatch_rq_list().  It turns out that it _almost_ does
(problems become much more rare), but I did manage to get a single
trace where the "kick" scheduled by the scsi fix happened really
quickly.  The scheduled kick then ran and found nothing to do.  This
happened in parallel to a task running in blk_mq_dispatch_rq_list()
which hadn't gotten around to splicing the list back into
hctx->dispatch.  This is why we need both fixes or a heavier hammer
where we always kick whenever two threads request budget at the same
time.

Most of my testing has been atop Chrome OS 5.4's kernel tree which
currently has v5.4.27 merged in.  The Chrome OS 5.4 tree also has a
patch by Salman Qazi, namely ("block: Limit number of items taken from
the I/O scheduler in one go").  Reverting that patch didn't make the
hung tasks go away, so I kept it in for most of my testing.

I have also done some testing on mainline Linux (git describe says I'm
on v5.6-rc7-227-gf3e69428b5e2) even without Salman's patch.  I found
that I could reproduce the problems there and that traces looked about
the same as I saw on the downstream branch.  These patches were also
confirmed to fix the problems on mainline.

Chrome OS is currently setup to use the BFQ scheduler and I found that
I couldn't reproduce the problems without BFQ.  It's possible that
other schedulers simply never trip the code sequences I ran into or
it's possible that the timing was simply different.  One important
note is that to reproduce the problems the I/O scheduler must have
returned "true" for has_work() but then dispatch_request() returns
NULL.  In any case the problems I found do seem to be real problems
and theoretically should be possible with other schedulers.

I'll insert my usual caveat that I'm sending patches to code that I
know very little about.  If I'm making a total bozo patch here, please
help me figure out how I should fix the problems I found in a better
way.

If you want to see a total ridiculous amount of chatter where I
stumbled around a whole bunch trying to figure out what was wrong and
how to fix it, feel free to read <https://crbug.com/1061950>.  I
promise it will make your eyes glaze over right away if this cover
letter didn't already do that.

I don't know if these fixes represent a regression of some sort or are
new.  As per above I could only reproduce with BFQ enabled which makes
it nearly impossible to go too far back with this.  I haven't listed
any "Fixes" tags here, but if someone felt it was appropriate to
backport this to some stable trees that seems like it'd be nice.
Presumably at least 5.4 stable would make sense.

Thanks to Salman Qazi, Paolo Valente, and Guenter Roeck who spent a
bunch of time helping me trawl through some of this code and reviewing
early versions of this patch.


Douglas Anderson (2):
  blk-mq: In blk_mq_dispatch_rq_list() "no budget" is a reason to kick
  scsi: core: Fix stall if two threads request budget at the same time

 block/blk-mq.c             | 11 ++++++++---
 drivers/scsi/scsi_lib.c    | 27 ++++++++++++++++++++++++---
 drivers/scsi/scsi_scan.c   |  1 +
 include/scsi/scsi_device.h |  2 ++
 4 files changed, 35 insertions(+), 6 deletions(-)

-- 
2.26.0.rc2.310.g2932bb562d-goog

