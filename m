Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF016C43216
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 19:05:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B58A560FD9
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 19:05:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbhH0TGV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 15:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbhH0TGT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 15:06:19 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34A4C061757;
        Fri, 27 Aug 2021 12:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=IsF55LCy7ysAV+Rm80KZ9tErQbHcawqg3Q3yNeHfxbs=; b=RPMz9UlSK4TyPH48FRjNV8+6ps
        kdN6hJk1/NLnYNL1MnfzIbcSmJDiKy36yuwoXW3jrB40rqNOfNa2hizF2+HHyGoIs8UiVtrPWdyMG
        V+l5R1xTeDS5NEldObc/4vAK6D2yzcRDR3pvRKso6faA5p7ncx5uRwM7tntiUXlvEvZO4hdhUC7WY
        aoIZnqlZGx7nAPK0PoBCAhmqUvxtOrf2aXeDJZf4e//pFCoqf3VFmlFmVvS0ur0V+Qf9zUOKm5MeQ
        hq2JxtvhBnxvqkJNFTWlK/mCXDO7AJRgyoiqohbHriiumjaRCO3QxO04M9UUPrfBzE2JgXW0ConAs
        JgIeDpMw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJhA1-00D1Kz-4A; Fri, 27 Aug 2021 19:05:05 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, martin.petersen@oracle.com, jejb@linux.ibm.com,
        kbusch@kernel.org, sagi@grimberg.me, adrian.hunter@intel.com,
        beanhuo@micron.com, ulf.hansson@linaro.org, avri.altman@wdc.com,
        swboyd@chromium.org, agk@redhat.com, snitzer@redhat.com,
        josef@toxicpanda.com
Cc:     hch@infradead.org, hare@suse.de, bvanassche@acm.org,
        ming.lei@redhat.com, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-mmc@vger.kernel.org,
        dm-devel@redhat.com, nbd@other.debian.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v2 0/6] block: first batch of add_disk() error handling conversions
Date:   Fri, 27 Aug 2021 12:04:58 -0700
Message-Id: <20210827190504.3103362-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This v2 drops two of the scsi patches which  Christoph pointed out were
not needed. It also fixes the nvme driver change to account for the
missing put of the ctrl. It also just appends the commits with the
respective reviewed tags. I've also dropped the mmc and dm patches
from this series as that is still pending discussion. I'll roll that
into the my next series after discussion is done.

The only patch which goes without a review tag is the nvme driver change.

These changes go rebased on Jen's latest axboe/for-next. The respective
full queue of my changes can be found on my git branch [0].

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=20210827-for-axboe-add-disk-error-handling-next

Luis Chamberlain (6):
  scsi/sd: add error handling support for add_disk()
  scsi/sr: add error handling support for add_disk()
  nvme: add error handling support for add_disk()
  md: add error handling support for add_disk()
  loop: add error handling support for add_disk()
  nbd: add error handling support for add_disk()

 drivers/block/loop.c     | 9 ++++++++-
 drivers/block/nbd.c      | 6 +++++-
 drivers/md/md.c          | 7 ++++++-
 drivers/nvme/host/core.c | 9 ++++++++-
 drivers/scsi/sd.c        | 6 +++++-
 drivers/scsi/sr.c        | 5 ++++-
 6 files changed, 36 insertions(+), 6 deletions(-)

-- 
2.30.2

