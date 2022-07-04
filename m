Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A01F6C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jul 2022 13:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234598AbiGDNB6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 09:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234591AbiGDNB5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 09:01:57 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8554B1C2;
        Mon,  4 Jul 2022 06:01:56 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 35AC368AA6; Mon,  4 Jul 2022 15:01:53 +0200 (CEST)
Date:   Mon, 4 Jul 2022 15:01:53 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 01/17] block: remove a superflous ifdef in blkdev.h
Message-ID: <20220704130153.GA23752@lst.de>
References: <20220704124500.155247-1-hch@lst.de> <20220704124500.155247-2-hch@lst.de> <PH0PR04MB741671715E7F16D5335002509BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR04MB741671715E7F16D5335002509BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 04, 2022 at 12:58:40PM +0000, Johannes Thumshirn wrote:
> > -#ifdef CONFIG_BLK_DEV_ZONED
> > -
> >  /* Helper to convert BLK_ZONE_ZONE_XXX to its string format XXX */
> >  const char *blk_zone_cond_str(enum blk_zone_cond zone_cond);
> >  
> 
> Won't this break tracing in null_blk, which uses blk_zone_cond_str()?

How could removing an ifdef and exposing a prototype unconditionally
in a header break tracing?
