Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF2F2C4320A
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 20:30:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A0F660E97
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 20:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbhHWUbE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 16:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbhHWUay (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2021 16:30:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6F6C0613C1;
        Mon, 23 Aug 2021 13:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=DLM7OpK51Ado9gYy0YDGfAm3WTAIQ8qg7keZCnkOFqQ=; b=pRpfRJCMOVjVB5eST79I8dMXE1
        zN5tckeOQn7ug/UrNoFMIKzi0Wrgtkg7mqqFV9OIZrv3pmKW95KV2KXSeHaGa/rcbd8XK4R29J35k
        zuiCzr7Ohb1tTLFNpqCR47b99W475xMg+yAP4bJle7LaySnSnnYLFOy5ScLyF8qBEbEPZWuXiKFfP
        oqvsd9CTIw4thJcNF1rbGsQ/p3PD7QOh+4NdOMP027mWG3r1TH+f9dweZky5gKtWS7AdpV7FzxLjL
        NSvXe59oS/fquoUNNEbR3CbCPaF+Y22CUZLNjZClT6k9Cchdi6zeMUr3QI7cI202gCJmAHEhpAyRz
        DGAuplhQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIGZZ-000ZjI-Ty; Mon, 23 Aug 2021 20:29:33 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, martin.petersen@oracle.com, jejb@linux.ibm.com,
        kbusch@kernel.org, sagi@grimberg.me, adrian.hunter@intel.com,
        beanhuo@micron.com, ulf.hansson@linaro.org, avri.altman@wdc.com,
        swboyd@chromium.org, agk@redhat.com, snitzer@redhat.com,
        josef@toxicpanda.com
Cc:     hch@infradead.org, hare@suse.de, bvanassche@acm.org,
        ming.lei@redhat.com, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-mmc@vger.kernel.org,
        dm-devel@redhat.com, nbd@other.debian.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 00/10] block: first batch of add_disk() error handling conversions
Date:   Mon, 23 Aug 2021 13:29:20 -0700
Message-Id: <20210823202930.137278-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There's a total of 70 pending patches in my queue which transform
drivers over to use the new add_disk() error handling. Now that
Jens has merged the core components what is left are all the other
driver conversions. A bit of these changes are helpers to make that
easier to do.

I'm going to split the driver conversions into batches, and
this first batch are drivers which should be of high priority
to consider.

Should this get merged, I'll chug on with the next batch, and
so on with batches of 10 each, until we tackle last the wonderful
world of floppy drivers.

I've put together a git tree based on Jen's for-5.15/block branch
which holds all of my pending changes, in case anyone wants to
take a peak.

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=20210823-for-axboe-add-disk-error-handling-next

Luis Chamberlain (10):
  scsi/sd: use blk_cleanup_queue() insted of put_disk()
  scsi/sd: add error handling support for add_disk()
  scsi/sr: use blk_cleanup_disk() instead of put_disk()
  scsi/sr: add error handling support for add_disk()
  nvme: add error handling support for add_disk()
  mmc/core/block: add error handling support for add_disk()
  md: add error handling support for add_disk()
  dm: add add_disk() error handling
  loop: add error handling support for add_disk()
  nbd: add error handling support for add_disk()

 drivers/block/loop.c     |  9 ++++++++-
 drivers/block/nbd.c      |  6 +++++-
 drivers/md/dm.c          | 16 +++++++++++-----
 drivers/md/md.c          |  7 ++++++-
 drivers/mmc/core/block.c |  4 +++-
 drivers/nvme/host/core.c | 10 +++++++++-
 drivers/scsi/sd.c        |  8 ++++++--
 drivers/scsi/sr.c        |  7 +++++--
 8 files changed, 53 insertions(+), 14 deletions(-)

-- 
2.30.2

