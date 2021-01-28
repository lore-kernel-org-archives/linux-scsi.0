Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE36C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 09:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D420A64DEE
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 09:35:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbhA1JfW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 04:35:22 -0500
Received: from verein.lst.de ([213.95.11.211]:56674 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231810AbhA1JdY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Jan 2021 04:33:24 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 13FDC68AFE; Thu, 28 Jan 2021 10:32:41 +0100 (CET)
Date:   Thu, 28 Jan 2021 10:32:40 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Keith Busch <Keith.Busch@wdc.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH v4 2/8] nvme: cleanup zone information initialization
Message-ID: <20210128093240.GA3212@lst.de>
References: <20210128044733.503606-1-damien.lemoal@wdc.com> <20210128044733.503606-3-damien.lemoal@wdc.com> <20210128091710.GA1959@lst.de> <BL0PR04MB6514F6AD357E545CBCAB877DE7BA9@BL0PR04MB6514.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL0PR04MB6514F6AD357E545CBCAB877DE7BA9@BL0PR04MB6514.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jan 28, 2021 at 09:27:41AM +0000, Damien Le Moal wrote:
> 
> I tried that first, but it did not work. I end up with
> blk_revalidate_disk_zones() undefined error with !CONFIG_BLK_DEV_ZONED.
> This is because blk_queue_is_zoned() is *not* stubbed for !CONFIG_BLK_DEV_ZONED.
> It will simply always return 0/none in that case. We would need to have:

Hmm.  blk_queue_is_zoned is calls blk_queue_zoned_model, which
always returns BLK_ZONED_NONE for !CONFIG_BLK_DEV_ZONED, and I thought we
rely on that elsewhere in nvme.  That is a fairly recent change from me,
though.

> 
> if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) && blk_queue_is_zoned()) {
> 	ret = blk_revalidate_disk_zones(ns->disk, NULL);
> 	...
> 
> Or stub blk_queue_is_zoned()...

If the above really doesn't work we should properly stub it out.

Anyway, I think we can go with your current patch:

Reviewed-by: Christoph Hellwig <hch@lst.de>

and refine all the zoned stubs later.  I have a few more ideas for
improvements there anyway.
