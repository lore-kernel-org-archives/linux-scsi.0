Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01B99C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 13:06:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235215AbhKVNJg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 08:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbhKVNJg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 08:09:36 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BBCC061574;
        Mon, 22 Nov 2021 05:06:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=M0AE+ZplCG2vjHuG8BzMEuw7b+ZVgcj/t/lpsJgxGc4=; b=IWFNx6Of/NY/pZDFOc5W+F7qHu
        FH8Jyq1Dxm4uaYFWacBeOBfZU1yfsX4sXTjxuv/xBaqlWxQ7qoZ1m2403HQ9P2+0bQEuKsUOGJP6I
        nZqlyUuDRHGAJQiv7ofh7Cv+cpngte6QBea8oEnF39HmRigGsDgNXt93yVxMsuYii2IYbam60Fdqo
        fm7L3wLh1BKMuZM8vz7D8gYKU+kIerIEztew9MqVhVsp2NoiHZ6ihbFrS2BQ1bJ25HL/qFFc3hc8l
        GA/VaNN4Au+UnlMkKifQH+F/x+aKYe+5ic7NI1Vb5vssFi7GVbEkYpEYt3u0QWY4Yc6dNqxNUHlSz
        rECUybfg==;
Received: from [2001:4bb8:180:22b2:9649:4579:dcf9:9fb2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mp91e-00CrqS-0H; Mon, 22 Nov 2021 13:06:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>, linux-block@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: cleanup and simplify the gendisk flags
Date:   Mon, 22 Nov 2021 14:06:11 +0100
Message-Id: <20211122130625.1136848-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Ho Jens,

the gendisk flags have been a complete mess for a while.  This series
tries to untangle them as much as easily possible.

Diffstat:
 block/bdev.c                       |    5 --
 block/blk.h                        |    1 
 block/genhd.c                      |   41 +++++++----------
 block/ioctl.c                      |   31 ++-----------
 block/partitions/core.c            |   24 ++++------
 drivers/block/amiflop.c            |    1 
 drivers/block/ataflop.c            |    1 
 drivers/block/brd.c                |    1 
 drivers/block/drbd/drbd_main.c     |    1 
 drivers/block/floppy.c             |    1 
 drivers/block/loop.c               |    9 +--
 drivers/block/n64cart.c            |    2 
 drivers/block/null_blk/main.c      |    1 
 drivers/block/paride/pcd.c         |    3 -
 drivers/block/paride/pf.c          |    1 
 drivers/block/pktcdvd.c            |    2 
 drivers/block/ps3vram.c            |    1 
 drivers/block/rbd.c                |    6 --
 drivers/block/sunvdc.c             |   17 +++----
 drivers/block/swim.c               |    1 
 drivers/block/swim3.c              |    2 
 drivers/block/virtio_blk.c         |    1 
 drivers/block/xen-blkback/xenbus.c |    2 
 drivers/block/xen-blkfront.c       |   26 ++++-------
 drivers/block/z2ram.c              |    1 
 drivers/block/zram/zram_drv.c      |    1 
 drivers/cdrom/gdrom.c              |    1 
 drivers/md/dm.c                    |    1 
 drivers/md/md.c                    |    5 --
 drivers/mmc/core/block.c           |    4 -
 drivers/mtd/ubi/block.c            |    1 
 drivers/scsi/sd.c                  |    1 
 drivers/scsi/sr.c                  |    6 +-
 include/linux/genhd.h              |   85 +++++++++----------------------------
 34 files changed, 104 insertions(+), 183 deletions(-)
