Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B37AC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Apr 2022 06:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356888AbiDTGuy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Apr 2022 02:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343934AbiDTGuy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Apr 2022 02:50:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222016576;
        Tue, 19 Apr 2022 23:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=2h0PxlUlFNU0ySs1hMG9RiSm7k2NO4Ql9lChGPha84Q=; b=jKa4Kk7mB+UcF870o53xqo9zZt
        W5ag6W7Hp5SqKIzhuqhiEgs9JjueHT+zcF50gDw+TolpaS9D7O99QvlqkGCptNWQuDtTu6wkhGAM7
        HUZ7TJ6SgA3L6gKg5LOqS1MOxs9333LhDgZW8OVSveENFoRSbJ3TEu1LLlkpSgh8dkx2gC6/oSB7j
        mIaK8SJO7uComI306mLxdlFAzcx/Qh8KOnMnx1W/hAM31v83+PbgLXLeNPQAAAT86MuRzPr574gxw
        bo1K4x9ch3sEfh8nD12rCeCbcwu/M+69M8x4ul1XIjRupf2HcIwjizJi1pxiqiKK26wP9z1GC/7Tl
        tuCS4Nsw==;
Received: from [2001:4bb8:191:364b:4299:55c7:4b14:f042] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nh47x-007cXh-3O; Wed, 20 Apr 2022 06:47:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Eric Biggers <ebiggers@google.com>
Cc:     Mike Snitzer <snitzer@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: fix blk_crypto_profile liftetime
Date:   Wed, 20 Apr 2022 08:47:43 +0200
Message-Id: <20220420064745.1119823-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

the newly added blk-crypto sysfs support does not seem to keep the
blk_crypto_profile lifetimes aligned to what sysfs expects.

This was found by code inspection only and is completely untested.

Diffstat:
 b/Documentation/block/inline-encryption.rst |   10 -
 b/block/Makefile                            |    3 
 b/block/blk-crypto-fallback.c               |   20 +-
 b/block/blk-crypto-profile.c                |  263 ++++++++++++++++++++++------
 b/drivers/md/dm-table.c                     |   28 --
 b/drivers/mmc/core/crypto.c                 |    4 
 b/drivers/mmc/host/cqhci-crypto.c           |   16 -
 b/drivers/scsi/ufs/ufshcd-crypto.c          |   31 +--
 b/drivers/scsi/ufs/ufshcd.h                 |    2 
 b/include/linux/blk-crypto-profile.h        |   19 +-
 b/include/linux/blkdev.h                    |    1 
 b/include/linux/mmc/host.h                  |    2 
 block/blk-crypto-sysfs.c                    |  172 ------------------
 13 files changed, 265 insertions(+), 306 deletions(-)
