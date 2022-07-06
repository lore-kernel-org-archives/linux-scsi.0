Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A624C43334
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 07:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbiGFHDz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 03:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiGFHDz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 03:03:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8AA5D5A;
        Wed,  6 Jul 2022 00:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=FNPTWfp4mk8fJGbONDFfJNnSLRYFpC010l13Y9aXWQ8=; b=z7xVdIuu3H3x41dq61eVCF6X7P
        203Nf5e3o9KTwJfCIvCVaL8+2rLtAVD8zjUk/8/hdo+lBP2H+O+VZVp/EOSBA04QIYA9q+UGm+ndF
        Htzq08g7menFmb/WuDB/KD6PPbugjJgZrxFcTEn0CqoRhON7oQrd+2Z3USZhLb7QLOUKOQ59CYzV1
        z+U29+jL50yR0+H411LiPbBYF/GzpkFWcl5p4LKWOW+YtL6dJcPwW4mDcIFmK6dqtJ+uWxD7lBWVm
        l03L6e5LbsqY7HutLnmStnt2d5TEIx+8o8WH53OxTRmodpUMhUc52NZIJR1dDeJe7mCIGEqhN4DND
        cP3JEVVA==;
Received: from [2001:4bb8:189:3c4a:f22c:c36a:4e84:c723] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8z4i-006uoJ-K5; Wed, 06 Jul 2022 07:03:53 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: clean up zoned device information v2
Date:   Wed,  6 Jul 2022 09:03:34 +0200
Message-Id: <20220706070350.1703384-1-hch@lst.de>
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

Changes since v1:
 - drop the blk-zoned/nvmet code sharing for now
 - use a helper a little earlier
 - various spelling fixes

Diffstat:
 block/bio.c                    |    2 
 block/blk-core.c               |   13 +--
 block/blk-merge.c              |    2 
 block/blk-mq-debugfs-zoned.c   |    6 -
 block/blk-mq.c                 |    2 
 block/blk-mq.h                 |   18 ++---
 block/blk-settings.c           |   11 +--
 block/blk-sysfs.c              |    8 --
 block/blk-zoned.c              |   85 ++++++++++++------------
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
 drivers/nvme/target/zns.c      |   14 +--
 drivers/scsi/sd.c              |    6 -
 drivers/scsi/sd_zbc.c          |   10 +-
 fs/zonefs/super.c              |   17 ++--
 include/linux/blk-mq.h         |    8 +-
 include/linux/blkdev.h         |  144 +++++++++++++++--------------------------
 26 files changed, 227 insertions(+), 267 deletions(-)
