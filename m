Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D31B9C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 15:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66B772074B
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 15:17:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cVGtUAOq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbgIOPQc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 11:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbgIOPQG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 11:16:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A64C06174A;
        Tue, 15 Sep 2020 08:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wRN8sWDO0+SCC+OUQvGYvMdLcX/OxNDA+MSRmTAp8h8=; b=cVGtUAOq2VbI+QFCJEIhl1BmSz
        Ve8VU8sDxLYVX68bALip1W9+2frGw9zKOjboA/2MzzWK/wNE3mGX9pTIjq/B0XPEAyty7m2hocutk
        ZrC1tjjJLoskBu1qUyrvyfe3mH0XgKLl/oPFFilnipvHhoydJqL/FkvjBmxJGvphlJb/Y58WOkLm3
        OL4siREOgU0ZNezNXTbp2eYUFynvsh7MUUpVzJbfWSJRPN1d8TDsO2emTgynPR1tyOmzxV9y0RF3n
        ebsdN0TE1pF5M5Kn+pviu3C8pb0KDEkcXGGR+Ji3sV15jlLUZAApCvh3mdU7Fq/59MF+zoJj9VuV6
        5knJCkWw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kICgc-0000cn-MV; Tue, 15 Sep 2020 15:16:02 +0000
Date:   Tue, 15 Sep 2020 16:16:02 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Borislav Petkov <bp@suse.de>, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH v3 2/2] scsi: Fix ZBC disk initialization
Message-ID: <20200915151602.GB1266@infradead.org>
References: <20200915073347.832424-1-damien.lemoal@wdc.com>
 <20200915073347.832424-3-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915073347.832424-3-damien.lemoal@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 15, 2020 at 04:33:47PM +0900, Damien Le Moal wrote:
> Make sure to call sd_zbc_init_disk() when the sdkp->zoned field is
> known, that is, once sd_read_block_characteristics() is executed in
> sd_revalidate_disk(), so that host-aware disks also get initialized.
> To do so, move sd_zbc_init_disk() call in sd_zbc_revalidate_zones() and
> make sure to execute it for all zoned disks, including for host-aware
> disks used as regular disks as these disk zoned model may be changed
> back to BLK_ZONED_HA when partitions are deleted.
> 
> Reported-by: Borislav Petkov <bp@alien8.de>
> Fixes: 5795eb443060 ("scsi: sd_zbc: emulate ZONE_APPEND commands")
> Cc: <stable@vger.kernel.org> # v5.8+
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> Tested-by: Borislav Petkov <bp@suse.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
