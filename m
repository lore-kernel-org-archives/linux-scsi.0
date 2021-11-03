Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C41DC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 18:13:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16837611C0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 18:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhKCSQL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 14:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbhKCSQE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 14:16:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F327C061203;
        Wed,  3 Nov 2021 11:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=by6uJflRSZTQtQScy9xY7EdpixGFhaKVKW6/eBoiVlM=; b=uKn9h2k73gti5ReaTupFiVo1FJ
        /IN/qPsGWYh3/bDZMmzmVHyP879ON62mQBObuTiEwITC3ESnNNg0zSokKE98Exfel6vk0sprqI3FO
        O6wHnltYeGzDngG1cwu0Ar03cFNukxDjfiXQb6YbZWLVSRTJedkvd3+yVfo5p42eUlQ7hyecANdnH
        ZNpA9jaj04+TRZLRbo4XZe8xOoraj7E7jqdprlRGDoqDfWKxCSmN72UGJsnwCg8CMvc76xeWIfEKc
        T2dNERsK/o5HHocXZncvczKFFDBCFWaj1Q89XJd353S9gMCfjfZ2OXILJun0hm3faKv/P8ia4jWgt
        GF8y4QSA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miKkt-0068X4-PK; Wed, 03 Nov 2021 18:12:59 +0000
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
Subject: [PATCH v4 0/4] last set for add_disk() error handling
Date:   Wed,  3 Nov 2021 11:12:54 -0700
Message-Id: <20211103181258.1462704-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This v4 only updates the last 2 patches from my v3 series of stragglers
to account for Christoph's request to split the __register_blkdev()
probe call changes into 3 patches, one for documentation, the other 2
patches for each respective driver.

I also noticed I had a typo on the documentation, so fixed that.

Luis Chamberlain (4):
  block: update __register_blkdev() probe documentation
  ataflop: address add_disk() error handling on probe
  floppy: address add_disk() error handling on probe
  block: add __must_check for *add_disk*() callers

 block/genhd.c           | 11 +++++++----
 drivers/block/ataflop.c | 16 +++++++++++++---
 drivers/block/floppy.c  | 15 +++++++++++++--
 include/linux/genhd.h   |  6 +++---
 4 files changed, 36 insertions(+), 12 deletions(-)

-- 
2.33.0

