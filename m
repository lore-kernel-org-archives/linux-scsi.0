Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B3EC4321E
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 23:05:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51A0F611C1
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 23:05:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhKCXHk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 19:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhKCXHg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 19:07:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C3CC06127A;
        Wed,  3 Nov 2021 16:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=Xd6YuCyb18cjuJyRwo9MyHD/mPo5oA5yl/m0ZXil8Xw=; b=CLzatVB7Y4MA5599zxHd7h+OOU
        odqO2uUKW1KKAL9CO4igmOm2Q+MtV10TKt7tZy8Lrr09GscZI8U3VCnFlgcuybE4PBMl+0jmA29IV
        6rGcpBrRuijy7HswKJBDhcBu1rNozvpu8bH2vTYt5Db0t6/yqWrzBZMlJ0nqSu9keFvg19MtXT5u+
        1pWUciagWYdIqvtc4WYGlZYrB7PcczGEUsSPkkwTIvoJE1Cpxu6O0lV5qt5rOg+ZCLl3/QtpmSvSn
        bGupuRWJ3IWs5YiyTXTIB/AoSyAEGGu5HNVoIIdEUoB6AFqwMeMf3SybCCNgXabBmIRNT/igJ3HN9
        BJMApGQQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miPJ8-006seD-EU; Wed, 03 Nov 2021 23:04:38 +0000
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
Subject: [PATCH v5 00/14] last set for add_disk() error handling
Date:   Wed,  3 Nov 2021 16:04:23 -0700
Message-Id: <20211103230437.1639990-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Jens,

as requested, I've folded all pending changes into this series. This
v5 pegs on Christoph's reviewed-by tags and since I was respinning I
modified the ataprobe and floppy driver changes as he suggested.

I think this is it. The world of floppy has been exciting for v5.16.

This goes based on your axboe/for-next tree as of just a few minutes ago.

Luis Chamberlain (13):
  nvdimm/btt: use goto error labels on btt_blk_init()
  nvdimm/btt: add error handling support for add_disk()
  nvdimm/blk: avoid calling del_gendisk() on early failures
  nvdimm/blk: add error handling support for add_disk()
  nvdimm/pmem: cleanup the disk if pmem_release_disk() is yet assigned
  nvdimm/pmem: use add_disk() error handling
  z2ram: add error handling support for add_disk()
  block/sunvdc: add error handling support for add_disk()
  mtd/ubi/block: add error handling support for add_disk()
  block: update __register_blkdev() probe documentation
  ataflop: address add_disk() error handling on probe
  floppy: address add_disk() error handling on probe
  block: add __must_check for *add_disk*() callers

Tetsuo Handa (1):
  ataflop: remove ataflop_probe_lock mutex

 block/genhd.c           | 11 +++++---
 drivers/block/ataflop.c | 61 +++++++++++++++++++++++++----------------
 drivers/block/floppy.c  | 17 +++++++++---
 drivers/block/sunvdc.c  | 14 ++++++++--
 drivers/block/z2ram.c   |  7 +++--
 drivers/mtd/ubi/block.c |  8 +++++-
 drivers/nvdimm/blk.c    | 21 ++++++++++----
 drivers/nvdimm/btt.c    | 20 +++++++++-----
 drivers/nvdimm/pmem.c   | 21 ++++++++++----
 include/linux/genhd.h   |  6 ++--
 10 files changed, 127 insertions(+), 59 deletions(-)

-- 
2.33.0

