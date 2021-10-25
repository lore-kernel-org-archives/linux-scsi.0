Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D371C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 07:05:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3657160F6F
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 07:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhJYHHs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Oct 2021 03:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbhJYHHr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Oct 2021 03:07:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069DBC061745;
        Mon, 25 Oct 2021 00:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=MWfB/Pp9FZbja07tYucEjisRFC0HHkvFMwtwn3gyp3o=; b=iYjOpX6U1STCkN0OBRL3wUW+pj
        lq61H5lzNBFdkjygcXrFzebRbs5zTLj2vCwNUvz8ibdeTvQyxfB7T8pzvjdiQ9pelfHpUmtADRAuy
        gzTveXNaTNxIQ6CwFcF8ssczvalPLNqioI8Oxbfl3/c6pd1Rd4HHOojx48lTatSy5twHuhg3RZXJg
        FZa7noPc8mLvcGEG7sBXxo1MEG6aABF3MMcjV2Cc7RtmkzMhYgS4dZHVhGZs7VQLla9BXDCRTFpHF
        B91GjTc0FzbsnJmGRzI+4YSKyx159kUBQpKFxQFC9TeQGQ2imvj2A54eSNFbdKA4eR0F7Wx22dWEz
        sDcehvPw==;
Received: from [2001:4bb8:184:6dcb:6093:467a:cccc:351c] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1meu2p-00FUNj-1e; Mon, 25 Oct 2021 07:05:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: move all struct request releated code out of blk-core.c
Date:   Mon, 25 Oct 2021 09:05:05 +0200
Message-Id: <20211025070517.1548584-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Jens,

this series (against the for-5.16/passthrough-flag branch) removes the
remaining struct request related code from blk-core.c and cleans up a
few related bits around that.

Diffstat:
 b/block/Makefile                     |    2 
 b/block/blk-core.c                   |  362 ----------------------
 b/block/blk-mq.c                     |  573 +++++++++++++++++++++++++++++------
 b/block/blk-mq.h                     |    3 
 b/block/blk.h                        |   33 --
 b/drivers/block/paride/pd.c          |    4 
 b/drivers/block/pktcdvd.c            |    2 
 b/drivers/block/virtio_blk.c         |    4 
 b/drivers/md/dm-mpath.c              |    4 
 b/drivers/mmc/core/block.c           |   20 -
 b/drivers/mtd/mtd_blkdevs.c          |   10 
 b/drivers/mtd/ubi/block.c            |    6 
 b/drivers/scsi/scsi_bsg.c            |    2 
 b/drivers/scsi/scsi_error.c          |    2 
 b/drivers/scsi/scsi_ioctl.c          |    4 
 b/drivers/scsi/scsi_lib.c            |   46 ++
 b/drivers/scsi/sg.c                  |    6 
 b/drivers/scsi/sr.c                  |    2 
 b/drivers/scsi/st.c                  |    4 
 b/drivers/scsi/ufs/ufshcd.c          |   20 -
 b/drivers/scsi/ufs/ufshpb.c          |    8 
 b/drivers/target/target_core_pscsi.c |    4 
 b/include/linux/blk-mq.h             |   16 
 block/blk-exec.c                     |  116 -------
 24 files changed, 597 insertions(+), 656 deletions(-)
