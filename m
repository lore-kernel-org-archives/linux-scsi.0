Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE556CCA479
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jul 2022 12:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbiGDMpH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 08:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbiGDMpG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 08:45:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084A6DF69;
        Mon,  4 Jul 2022 05:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=r8Vz34uF3hgjoNeR0v/rpIhSqu91TXSVbFAMBKa/d70=; b=2Glapi//WtqY3AMOGBs0DSP1E8
        mTDmR/yyUZ4PzULuRY/BAOYHHHTZSWE31rp1PenrON7U0Dtnt8aSidrBxwOpKHfMen6MPL1ov2tev
        N7sSubL0iaHwBhyLviMeAyh80Lux+4tZyk9NmBsEut8i26mw2f59rI5PnHXsrFMvJum3fWM2BHzW4
        n13oiD6mIPnDWQXrAbZD1q+hMKIqRsz+M8LvTp6IgafdgjxSc0b3ThWFDoq22K3WpB4QeoBv/ULFz
        NdcciYIs/jodQw5Ap4V7zDLzTszirGqj4QqeC2KcXM4i0V4dmIm1PCqZHYgl61HRbVI9PMxMUJqBZ
        vD8zB3Iw==;
Received: from [2001:4bb8:189:3c4a:8758:74d9:4df6:6417] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8LRm-008s8e-3R; Mon, 04 Jul 2022 12:45:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: clean up zoned device information
Date:   Mon,  4 Jul 2022 14:44:43 +0200
Message-Id: <20220704124500.155247-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

this cleans up the block layer zoned device information APIs and
moves all fields currently in the request_queue to the gendisk as
they aren't relevant for passthrough I/O.

Diffstat:
 block/bio.c                    |    2 
 block/blk-core.c               |   13 +--
 block/blk-merge.c              |    2 
 block/blk-mq-debugfs-zoned.c   |    6 -
 block/blk-mq.c                 |    2 
 block/blk-mq.h                 |   18 ++---
 block/blk-settings.c           |   11 +--
 block/blk-sysfs.c              |    8 --
 block/blk-zoned.c              |   95 +++++++++++++-------------
 block/blk.h                    |    8 +-
 block/genhd.c                  |    1 
 block/ioctl.c                  |    2 
 block/partitions/core.c        |    2 
 drivers/block/null_blk/zoned.c |    8 +-
 drivers/md/dm-table.c          |    6 -
 drivers/md/dm-zone.c           |   86 +++++++++++-------------
 drivers/md/dm-zoned-target.c   |   25 +++----
 drivers/md/dm.c                |    2 
 drivers/nvme/host/multipath.c  |    2 
 drivers/nvme/host/zns.c        |    6 -
 drivers/nvme/target/zns.c      |  110 +-----------------------------
 drivers/scsi/sd.c              |    6 -
 drivers/scsi/sd_zbc.c          |   10 +-
 fs/zonefs/super.c              |   17 ++--
 include/linux/blk-mq.h         |    8 +-
 include/linux/blkdev.h         |  146 ++++++++++++++++-------------------------
 26 files changed, 233 insertions(+), 369 deletions(-)
