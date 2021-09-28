Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F348C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 05:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65F1B60FC2
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 05:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbhI1FYy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 01:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233290AbhI1FYx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 01:24:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1392EC061575;
        Mon, 27 Sep 2021 22:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=A04dM+Vo9/Fetf7krH0dGPC++Y24iPZldsb1IcuSrY8=; b=aRY4V1sGCTesXudqb9o16TDrY4
        So7uD86nqB92AiLd9otKv6X6MfWgkOAeId/QuKEULs9GPk8juifoFzT1FcrlwMsQ7ZRhUI8kmCE+c
        Yli36oAEOytrjPeUgbZNvzCjU2EzP9rba/ZlJ006Z+tuNmvc9v3TUlHcc8qJ/K2P6yp3IY1ADaqjS
        J4NXRo7VuTMbjV8iDjYIIul09I5WL+RdhOTGjuJBq9NS8v9mf0g6z3H5Tny0BOZ/4hSyNzwEawg9e
        5eekUuS6ByryxDk1zzvY4nLWDB3xOU1vOs8rgt5f3Z8GKkntaFhrkCAQwL1iiiMTbmdpmGkBYAAPD
        vjp2zNNg==;
Received: from p4fdb05cb.dip0.t-ipconnect.de ([79.219.5.203] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mV5ZG-00AW6O-LM; Tue, 28 Sep 2021 05:22:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: remove ->rq_disk
Date:   Tue, 28 Sep 2021 07:22:06 +0200
Message-Id: <20210928052211.112801-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Jens,

this series removes the rq_disk field in struct request, which isn't
needed now that we can get the disk from the request_queue.

Diffstat:
 block/blk-core.c                   |   10 ++++----
 block/blk-exec.c                   |   10 ++------
 block/blk-flush.c                  |    3 --
 block/blk-merge.c                  |    7 ------
 block/blk-mq.c                     |    1 
 block/blk.h                        |    2 -
 block/bsg-lib.c                    |    2 -
 drivers/block/amiflop.c            |    2 -
 drivers/block/ataflop.c            |    6 ++---
 drivers/block/floppy.c             |    6 ++---
 drivers/block/mtip32xx/mtip32xx.c  |    2 -
 drivers/block/null_blk/trace.h     |    2 -
 drivers/block/paride/pcd.c         |    2 -
 drivers/block/paride/pd.c          |    6 ++---
 drivers/block/paride/pf.c          |    4 +--
 drivers/block/pktcdvd.c            |    2 -
 drivers/block/rnbd/rnbd-clt.c      |    4 +--
 drivers/block/sunvdc.c             |    2 -
 drivers/block/sx8.c                |    4 +--
 drivers/block/virtio_blk.c         |    2 -
 drivers/md/dm-mpath.c              |    1 
 drivers/mmc/core/block.c           |   12 +++++-----
 drivers/mtd/mtd_blkdevs.c          |   10 +-------
 drivers/nvme/host/core.c           |    4 +--
 drivers/nvme/host/fault_inject.c   |    2 -
 drivers/nvme/host/pci.c            |    7 ++----
 drivers/nvme/host/trace.h          |    6 ++---
 drivers/nvme/target/passthru.c     |    3 --
 drivers/scsi/ch.c                  |    2 -
 drivers/scsi/scsi_bsg.c            |    2 -
 drivers/scsi/scsi_error.c          |    2 -
 drivers/scsi/scsi_ioctl.c          |   43 ++++++++++++++-----------------------
 drivers/scsi/scsi_lib.c            |    5 ++--
 drivers/scsi/scsi_logging.c        |    4 ++-
 drivers/scsi/sd.c                  |   26 +++++++++++-----------
 drivers/scsi/sd_zbc.c              |    8 +++---
 drivers/scsi/sg.c                  |    6 ++---
 drivers/scsi/sr.c                  |   11 ++++-----
 drivers/scsi/st.c                  |    4 +--
 drivers/scsi/ufs/ufshcd.c          |    3 --
 drivers/scsi/ufs/ufshpb.c          |    5 +---
 drivers/scsi/virtio_scsi.c         |    2 -
 drivers/target/target_core_pscsi.c |    2 -
 drivers/usb/storage/transport.c    |    2 -
 fs/nfsd/blocklayout.c              |    2 -
 include/linux/blk-mq.h             |   11 ++-------
 include/scsi/scsi_cmnd.h           |    2 -
 include/scsi/scsi_device.h         |    4 +--
 include/scsi/scsi_ioctl.h          |    4 +--
 include/trace/events/block.h       |    8 +++---
 kernel/trace/blktrace.c            |    2 -
 51 files changed, 125 insertions(+), 159 deletions(-)
