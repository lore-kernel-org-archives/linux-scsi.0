Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D78E0C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 13:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbhKZNG0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 08:06:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbhKZNE0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2021 08:04:26 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF360C06174A;
        Fri, 26 Nov 2021 04:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=Xa7hqASrrdIfGtS8qaD3qdcF3OYpNGlFpwwMebmiLrE=; b=fI5pv/RH+6N3RO2WI1bmtIPlGd
        ZDq9FMvDyvuuFP6RO8GNEx5tLSQOdgcaQOmIJTmOPzJOrWsEulis4zqVUMb9Knf9cOgsuRq/N+4we
        evxfnOe51eFgOs3Dbc14pfx5WKzfG5BhTvCHWnfQtf5iLYJulF1XgIGzoIN9HCGK9jaylpfwhCIxG
        2+r2DF2WZEe9UGELBF5Z+RntIJokJnxfVpmAEK132BPGg9K00G2ZRwXNvDEgwMNUtpIeE1i9hk/mM
        RzBrQ67t9P27ZWVW95iHz6mDsmIyO1OuJb3APm1kNtPx/XMW324YzOii54uuTWMvBB2A7wUJ11dfM
        huamnjTw==;
Received: from [2001:4bb8:191:f9ce:bae8:5658:102a:5491] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mqaB1-00AWFm-0W; Fri, 26 Nov 2021 12:18:03 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: remove ->rq_disk v2
Date:   Fri, 26 Nov 2021 13:17:57 +0100
Message-Id: <20211126121802.2090656-1-hch@lst.de>
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

Changes since v1:
 - rebased to the latests for-5.17/block tree

Diffstat:
 block/blk-flush.c                  |    3 --
 block/blk-merge.c                  |    7 ------
 block/blk-mq.c                     |   24 +++++++-------------
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
 drivers/scsi/ufs/ufshpb.c          |    4 +--
 drivers/scsi/virtio_scsi.c         |    2 -
 drivers/target/target_core_pscsi.c |    2 -
 drivers/usb/storage/transport.c    |    2 -
 include/linux/blk-mq.h             |   11 ++-------
 include/scsi/scsi_cmnd.h           |    2 -
 include/scsi/scsi_device.h         |    4 +--
 include/scsi/scsi_ioctl.h          |    4 +--
 include/trace/events/block.h       |    8 +++---
 kernel/trace/blktrace.c            |    2 -
 47 files changed, 124 insertions(+), 157 deletions(-)
