Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F0FC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 06:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA56561B2B
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 06:14:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbhKQGRU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Nov 2021 01:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbhKQGRT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2021 01:17:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828C7C061746;
        Tue, 16 Nov 2021 22:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=DFAEmPcXtpPd/YSnlYCa7vsCV48/DH47DKoFE2HC6W8=; b=RQs+dlZc/iJE0doyQERQ7LRMgh
        3X1tfu/Q30APhRnF5Ef4VirkMrLgZ1op5aImQLxh2b11YXZPQ4A0b1Pz5C7orl1nszA1fJNUQa1s0
        CchP5jsjhwMwU8fbUZMY/AVoGjYPobNJqsscv2ur2eRykbRO9NEACOeX4jVtYHit0/ub9X2HwUSu9
        WhX5xrw4sP/NC1ISaYvxPA0dNQlSlQB8TtXdtJEuSaZI8m5mgr7EpJIYUzCcZnw9qw7C2F1eLhak7
        ELd0fHnmNS+wpmEoMjwzFV2S7/f1OMSiHxhzHgT9BUeFCP/qEfqGOup2GJtEsihFbjIKuIkEG2qNC
        27gP8/EQ==;
Received: from 213-225-5-109.nat.highway.a1.net ([213.225.5.109] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mnECr-007MEM-GM; Wed, 17 Nov 2021 06:14:06 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: move all struct request releated code out of blk-core.c (rebased)
Date:   Wed, 17 Nov 2021 07:13:53 +0100
Message-Id: <20211117061404.331732-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Jens,

this series (against the for-5.16/passthrough-flag branch) removes the
remaining struct request related code from blk-core.c and cleans up a
few related bits around that.

Diffstat:
 b/block/Makefile            |    2 
 b/block/blk-core.c          |  341 --------------------------
 b/block/blk-mq.c            |  573 ++++++++++++++++++++++++++++++++++++--------
 b/block/blk-mq.h            |    3 
 b/block/blk.h               |   33 --
 b/drivers/mtd/mtd_blkdevs.c |   10 
 b/drivers/mtd/ubi/block.c   |    6 
 b/drivers/scsi/scsi_lib.c   |   42 +++
 b/include/linux/blk-mq.h    |   13 
 block/blk-exec.c            |  116 --------
 10 files changed, 552 insertions(+), 587 deletions(-)
