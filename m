Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F7D8C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 16:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58FC0619DB
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 16:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbhC3QSI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 12:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbhC3QRl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 12:17:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35F7C061574;
        Tue, 30 Mar 2021 09:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=wBx0Ov1qFfoFIbPnFM3+4UcF+elN8xz2+Stq7Mk5rxs=; b=IeZ/p9qlHvFgAXTMKXQpI6qkqk
        8NrZ5THtl63tPfePZ3Z4LeuVPrFkBtL5XxQwNeKa7v3BcJgr7C6TAWQglZCdYWW3ERk3yDFbR1l1U
        7e4ZPX2d6MfSTXzvW3wX5txuizpEfbE1pqRPh1W2V9lFoRG9doNXioW56gGx9rYmqR5QXI3b35XNZ
        Ywkl1vgJXGBhl8K2ZIRw/SXYZR+HcrxOI4NrbS+f2/TzR8NQMjYTwVMXMh6p9yjA3SloIT2d2jmGy
        sTa3f+EEHyiXrYWvQ4oF2e5yD57iqb4A9fA1ybzu40Pe+8zvtQLxLxAbjAeD/n4y23iqCowF8Koue
        BnGv5MNA==;
Received: from [185.12.131.45] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lRH3a-008aJf-Ps; Tue, 30 Mar 2021 16:17:31 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: move bd_mutex to the gendisk
Date:   Tue, 30 Mar 2021 18:17:12 +0200
Message-Id: <20210330161727.2297292-1-hch@lst.de>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

this series first cleans up gendisk allocation in the md driver to remove
the ERESTARTSYS hack in blkdev_get, then further refactors blkdev_get
and then finally moves bd_mutex into the gendisk as having separate locks
for the whole device vs partitions just complicates locking in places that
add an remove partitions a lot.

Note that this series sits on top of the for-5.13/drivers branch as that
has the ->revalidate_disk cleanup.

Diffstat:
 Documentation/filesystems/locking.rst |    2 
 block/genhd.c                         |   55 +++-----
 block/partitions/core.c               |   45 +++----
 drivers/block/loop.c                  |   14 +-
 drivers/block/xen-blkfront.c          |    8 -
 drivers/block/zram/zram_drv.c         |   18 +-
 drivers/block/zram/zram_drv.h         |    2 
 drivers/md/md.c                       |  204 ++++++++++++++++-----------------
 drivers/md/md.h                       |    6 
 drivers/s390/block/dasd_genhd.c       |    8 -
 drivers/scsi/sd.c                     |    4 
 fs/block_dev.c                        |  208 +++++++++++++++-------------------
 fs/btrfs/volumes.c                    |    2 
 fs/super.c                            |    8 -
 include/linux/blk_types.h             |    4 
 include/linux/genhd.h                 |    6 
 init/do_mounts.c                      |   10 -
 17 files changed, 279 insertions(+), 325 deletions(-)
