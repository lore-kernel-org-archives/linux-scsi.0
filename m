Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B08FCC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 08:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbiBII2k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 03:28:40 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:35678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238528AbiBII2b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 03:28:31 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501BCC05CBB1;
        Wed,  9 Feb 2022 00:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=HuBqH9pL1cSgksE1rOkQ00xzpnMV+RQMWShTili3kcU=; b=rMNxa7XnmkkEZW+NLw8qjNYiVH
        gdvIjYUDiKEVQy73TpXR0Y2HZ1GgfVdHN4xhX6XFIFErEOw4M3nbeLNEzzTFIiOPwIoqtRmjtrS26
        3FxKl1CZFPZ39dA7g9manNwD+KL8+neecIpsAn/yfo62a9k2WLUwtByyd7HfIZCtOO/j+nGMCI8kN
        r34FmK/vzfI+JZqJuXjGujVfSBjYsxBXwMPRb5766KetKEbcFPDv9L+65bMs5LgLk0Psunohe8VQp
        xB/l9r9iqG6t1KeHac5uqpqRN8Z3yXs7zPnsvwPcgHZcZ4jeqojv2DuNgzJKvHiFtPq8swZVswXLe
        U/p0egdA==;
Received: from [2001:4bb8:188:3efc:ea2:7599:7eeb:4b5a] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHiL1-00Gc6p-7q; Wed, 09 Feb 2022 08:28:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     axboe@kernel.dk, martin.petersen@oracle.com,
        philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
        target-devel@vger.kernel.org, haris.iqbal@ionos.com,
        jinpu.wang@ionos.com, manoj@linux.ibm.com, mrochs@linux.ibm.com,
        ukrishn@linux.ibm.com
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        drbd-dev@lists.linbit.com, dm-devel@redhat.com
Subject: remove REQ_OP_WRITE_SAME v2
Date:   Wed,  9 Feb 2022 09:28:21 +0100
Message-Id: <20220209082828.2629273-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now that we are using REQ_OP_WRITE_ZEROES for all zeroing needs in the
kernel there is very little use left for REQ_OP_WRITE_SAME.  We only
have two callers left, and both just export optional protocol features
to remote systems: DRBD and the target code.

For the target code the only real use case was zeroing offload, which
is kept with this series, and for DRBD I suspect the same based on the
usage.

    git://git.infradead.org/users/hch/block.git delete-write-same

Gitweb:

    http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/delete-write-same

Changes since v2:
 - split up
 - rebased ontop of five years of kernel change, including the totally
   pointless addition of REQ_OP_WRITE_SAME in rnbd

Changes from RFC:
 - add zeroing offload for the SCSI target.

Diffstat:
 block/blk-core.c                   |   13 -----
 block/blk-lib.c                    |   91 -------------------------------------
 block/blk-merge.c                  |   40 ----------------
 block/blk-settings.c               |   16 ------
 block/blk-sysfs.c                  |    8 ---
 block/blk-zoned.c                  |    1 
 block/blk.h                        |    1 
 block/bounce.c                     |    3 -
 drivers/block/drbd/drbd_main.c     |   31 +-----------
 drivers/block/drbd/drbd_nl.c       |   72 -----------------------------
 drivers/block/drbd/drbd_receiver.c |   47 ++-----------------
 drivers/block/drbd/drbd_req.c      |    1 
 drivers/block/drbd/drbd_worker.c   |    5 --
 drivers/block/rnbd/rnbd-clt.c      |    7 --
 drivers/block/rnbd/rnbd-clt.h      |    1 
 drivers/block/rnbd/rnbd-proto.h    |    6 --
 drivers/block/rnbd/rnbd-srv.c      |    3 -
 drivers/md/dm-core.h               |    1 
 drivers/md/dm-crypt.c              |    1 
 drivers/md/dm-ebs-target.c         |    1 
 drivers/md/dm-io.c                 |   22 --------
 drivers/md/dm-linear.c             |    1 
 drivers/md/dm-mpath.c              |    1 
 drivers/md/dm-rq.c                 |    3 -
 drivers/md/dm-stripe.c             |    4 -
 drivers/md/dm-table.c              |   29 -----------
 drivers/md/dm-zone.c               |    4 -
 drivers/md/dm.c                    |   15 ------
 drivers/md/md-linear.c             |    1 
 drivers/md/md-multipath.c          |    1 
 drivers/md/md.h                    |    7 --
 drivers/md/raid0.c                 |    2 
 drivers/md/raid1.c                 |    4 -
 drivers/md/raid10.c                |    1 
 drivers/md/raid5.c                 |    1 
 drivers/scsi/cxlflash/vlun.c       |    4 -
 drivers/scsi/sd.c                  |   75 ++----------------------------
 drivers/scsi/sd_zbc.c              |    2 
 include/linux/bio.h                |    3 -
 include/linux/blk_types.h          |    2 
 include/linux/blkdev.h             |   19 -------
 include/linux/device-mapper.h      |    6 --
 kernel/trace/blktrace.c            |    1 
 43 files changed, 30 insertions(+), 527 deletions(-)
