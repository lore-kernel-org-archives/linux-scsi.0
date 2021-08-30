Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED062C43216
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 21:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3B0460FA0
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 21:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238662AbhH3V1m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Aug 2021 17:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237685AbhH3V1I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Aug 2021 17:27:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C43C061796;
        Mon, 30 Aug 2021 14:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=1YUk7uUX188ex4Qeqb2q2FbA+vqSeistafw96wSb9q8=; b=lEZUf7GgHMbX1+8gRrsrsvmyDn
        I+l8qrzbBpIWozAGTLTsWh0ax350SK798hajnAmKrtIYwcj70N+TaMp/HanMyyRUp054bd1I72PoR
        tx8Hq7NMaNET0LOlyYCx0TsGyJCTqk6w1OvYvpXbRKuuMRQd2pUNw7KlIMpg2IIjBZ+zvhlvLDIXl
        uJ3BiUfzRZCBBpNJqKtyJRWmGjjAIWHZWiJAynl3xGzd17VZHRg2LRBXRyRNRBZ7p564JgTHzY+67
        cukqYn6bVuTsu0iduaOcSEpdZaD/+3zQZbDczNcUC1Z4qd2F8DLoqpMTdUu6EcUbL56xrdqtLrnTN
        YcfMXpzQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mKomk-000ci4-DU; Mon, 30 Aug 2021 21:25:42 +0000
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
Subject: [PATCH v3 0/8] block: first batch of add_disk() error handling conversions
Date:   Mon, 30 Aug 2021 14:25:30 -0700
Message-Id: <20210830212538.148729-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Jens,

I think this first set is ready, but pending review of just two patches:

  * mmc/core/block
  * dm

All other patches have a respective Reviewed-by tag. The above two
patches were integrated back into the series once I understood
Christoph's concerns, and adjusted the patch as such.

This goes rebased onto your for-next as of today. If anyone wants to
explore the pending full set this is up on my linux-next branch
20210830-for-axboe-add-disk-error-handling-next [0].

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=20210830-for-axboe-add-disk-error-handling-next

Luis Chamberlain (8):
  scsi/sd: add error handling support for add_disk()
  scsi/sr: add error handling support for add_disk()
  nvme: add error handling support for add_disk()
  mmc/core/block: add error handling support for add_disk()
  md: add error handling support for add_disk()
  dm: add add_disk() error handling
  loop: add error handling support for add_disk()
  nbd: add error handling support for add_disk()

 drivers/block/loop.c     | 9 ++++++++-
 drivers/block/nbd.c      | 6 +++++-
 drivers/md/dm.c          | 4 +++-
 drivers/md/md.c          | 7 ++++++-
 drivers/mmc/core/block.c | 7 ++++++-
 drivers/nvme/host/core.c | 9 ++++++++-
 drivers/scsi/sd.c        | 6 +++++-
 drivers/scsi/sr.c        | 5 ++++-
 8 files changed, 45 insertions(+), 8 deletions(-)

-- 
2.30.2

