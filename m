Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BF6AC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 12:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 061DD60E08
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 12:22:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbhKCMYz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 08:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbhKCMYs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 08:24:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44ECEC061714;
        Wed,  3 Nov 2021 05:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=CN1NTFUhaC8Qz7H6XI1QPx8+n2/dfwPUgQpxJIog77o=; b=JlBaVdGXDnkFPV+MAM3AoT91cQ
        qGuarXUbJDrdNDoYo8ji1XyxGgGgfQCTCnJCy+Nz+xTt5EXsq4tbC5hiJBFnbLMpHJPwL1Mn1fXuU
        fhogGbOXOs1+0tO9lWzLeoIRRDQGV0kWEpftYRAzUGryJt7JxxMy0QBNTcfKgK6uh6hANojBX2zyP
        rVBXhmLldJmGrZ3ho0MbSKkFCFuQ366x1kmq8w1TawrneZj1kM7HEOmDs+0FrrBQW3SaVf+col2tz
        lU+xrCGCepzFnLoUELcXMjkJbezjY30tAzyXM2/7gBnATknVaFcYC8nSUN2fDMuarfUh/VGQjZj8r
        Hzhd+4Vw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miFHC-0056I8-4e; Wed, 03 Nov 2021 12:21:58 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, hch@lst.de, penguin-kernel@i-love.sakura.ne.jp,
        dan.j.williams@intel.com, vishal.l.verma@intel.com,
        dave.jiang@intel.com, ira.weiny@intel.com, richard@nod.at,
        miquel.raynal@bootlin.com, vigneshr@ti.com, efremov@linux.com,
        song@kernel.org, martin.petersen@oracle.com, hare@suse.de,
        jack@suse.cz, ming.lei@redhat.com, tj@kernel.org, mcgrof@kernel.org
Cc:     linux-mtd@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/13] block: add_disk() error handling stragglers
Date:   Wed,  3 Nov 2021 05:21:44 -0700
Message-Id: <20211103122157.1215783-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is the last pending changes to address add_disk() error handling
completely. Changes on this v2 series:

  o dropped all patches which folks have said they'd pick up on their
    own trees or that I already see present on linux-next
  o rebased onto next-20211103
  o Added Reviewed-by tag by Dan Williams and addressed his recommended
    changes.
  o Re-added the nvdimm/blk changes given Dan Williams was not able to
    remove the driver in time for v5.16
  o Added new nvdimm/pmem driver changes, not sure how I missed addressing
    this before.
  o Just note that I keep Tetsuo Handa's patch in this series as it is
    a requirement for the __register_blkdev() changes.

You can find all these changes on my git tree:

https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=20211103-for-axboe-add-disk-error-handling

Luis Chamberlain (12):
  nvdimm/btt: do not call del_gendisk() if not needed
  nvdimm/btt: use goto error labels on btt_blk_init()
  nvdimm/btt: add error handling support for add_disk()
  nvdimm/blk: avoid calling del_gendisk() on early failures
  nvdimm/blk: add error handling support for add_disk()
  nvdimm/pmem: cleanup the disk if pmem_release_disk() is yet assigned
  nvdimm/pmem: use add_disk() error handling
  z2ram: add error handling support for add_disk()
  block/sunvdc: add error handling support for add_disk()
  mtd/ubi/block: add error handling support for add_disk()
  block: make __register_blkdev() return an error
  block: add __must_check for *add_disk*() callers

Tetsuo Handa (1):
  ataflop: remove ataflop_probe_lock mutex

 block/bdev.c            |  5 +++-
 block/genhd.c           | 27 +++++++++++------
 drivers/block/ataflop.c | 66 +++++++++++++++++++++++++----------------
 drivers/block/brd.c     |  7 +++--
 drivers/block/floppy.c  | 17 ++++++++---
 drivers/block/loop.c    | 11 +++++--
 drivers/block/sunvdc.c  | 14 +++++++--
 drivers/block/z2ram.c   |  7 +++--
 drivers/md/md.c         | 12 ++++++--
 drivers/mtd/ubi/block.c |  8 ++++-
 drivers/nvdimm/blk.c    | 21 +++++++++----
 drivers/nvdimm/btt.c    | 21 ++++++++-----
 drivers/nvdimm/pmem.c   | 21 +++++++++----
 drivers/scsi/sd.c       |  3 +-
 include/linux/genhd.h   | 10 +++----
 15 files changed, 172 insertions(+), 78 deletions(-)

-- 
2.33.0

