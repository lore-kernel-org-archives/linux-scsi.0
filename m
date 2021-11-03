Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44AEEC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 17:46:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9A4E60F58
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 17:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbhKCRsp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 13:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbhKCRs0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 13:48:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B17C06120D;
        Wed,  3 Nov 2021 10:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=8YgCrXhskJfBLDgdrSAYpFd5mLjr1aeU1Eb3qvfMGec=; b=xh5RUMzXgyNfkuuhvCzmI/IkQC
        toFUYYOH5zdxpFbZvr6HgL2jQIHAzw5UGtbZ7OET/fzpmvdbKKk0K6PEzzwBAAL4pl1IQyB1jOK6L
        /TMGNy3ypForrR8WGlkBiWqX8I1ZcXnk9Bt021U6DxY5VOItgVzjYlPv71tJx+ZNkHCsLUVbnC/DF
        Adso88zvIIx2nxOcehVnIEMnqRFvcWj3OhqL1IlH27SOJJwr7OcKo4lQVaB5yfwjU2MN3DjKHFisP
        flAGiTiU6KmHaGQnRZMIHJiWJ7+YfcDRnRUMPbKUhiNFfZ9dBrn99cELomR7VcJ11Qua/TH/0Y2CU
        xulDYgzg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miKKA-005z5L-0I; Wed, 03 Nov 2021 17:45:22 +0000
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
Subject: [PATCH v3 00/13] block: add_disk() error handling stragglers
Date:   Wed,  3 Nov 2021 10:45:08 -0700
Message-Id: <20211103174521.1426407-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This v3 series has the following changes:

 o clarifies the nvdimm/btt fix to not call del_gendisk to be a proper
   fix regardless of kernel.
 o Adds reviewed-by tags
 o modified the __register_blkdev() changes so that we do not propagate
   the error code from add_disk() but instead we just cleanup the
   resources where needed, and update the documentation to reflect
   suggestions by Christoph

You can find these changes on tree:

https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=20211103-for-axboe-add-disk-error-handling-v3

Luis Chamberlain (12):
  nvdimm/btt: do not call del_gendisk() if not needed
  nvdimm/btt: use goto error labels on btt_blk_init()
  nvdimm/btt: add error handling support for add_disk()
  nvdimm/blk: avoid calling del_gendisk() on early failures
  nvdimm/blk: add error handling support for add_disk()
  nvdimm/pmem: cleanup the disk if pmem_release_disk() is yet assigned
  nvdimm/pmem: use add_disk() error handling
  z2ram: add error handling support for add_disk()
  block/sunvdc: add error handling support for add_disk()
  mtd/ubi/block: add error handling support for add_disk()
  block: fix __register_blkdev() probe add_disk() failures
  block: add __must_check for *add_disk*() callers

Tetsuo Handa (1):
  ataflop: remove ataflop_probe_lock mutex

 block/genhd.c           | 11 +++++---
 drivers/block/ataflop.c | 59 +++++++++++++++++++++++++----------------
 drivers/block/floppy.c  | 11 ++++++--
 drivers/block/sunvdc.c  | 14 +++++++---
 drivers/block/z2ram.c   |  7 +++--
 drivers/mtd/ubi/block.c |  8 +++++-
 drivers/nvdimm/blk.c    | 21 ++++++++++-----
 drivers/nvdimm/btt.c    | 21 +++++++++------
 drivers/nvdimm/pmem.c   | 21 +++++++++++----
 include/linux/genhd.h   |  6 ++---
 10 files changed, 122 insertions(+), 57 deletions(-)

-- 
2.33.0

