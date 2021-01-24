Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E814C433DB
	for <linux-scsi@archiver.kernel.org>; Sun, 24 Jan 2021 10:10:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51F2C22ADF
	for <linux-scsi@archiver.kernel.org>; Sun, 24 Jan 2021 10:10:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbhAXKKM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Jan 2021 05:10:12 -0500
Received: from verein.lst.de ([213.95.11.211]:41681 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbhAXKIK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 24 Jan 2021 05:08:10 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id D94556736F; Sun, 24 Jan 2021 11:07:24 +0100 (CET)
Date:   Sun, 24 Jan 2021 11:07:24 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Keith Busch <Keith.Busch@wdc.com>
Subject: Re: [PATCH v3 1/3] block: introduce zone_write_granularity limit
Message-ID: <20210124100724.GA27580@lst.de>
References: <20210122080014.174391-1-damien.lemoal@wdc.com> <20210122080014.174391-2-damien.lemoal@wdc.com> <20210122084209.GA15710@lst.de> <BL0PR04MB6514A2655635DFF482E4252BE7A00@BL0PR04MB6514.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL0PR04MB6514A2655635DFF482E4252BE7A00@BL0PR04MB6514.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jan 22, 2021 at 08:56:58AM +0000, Damien Le Moal wrote:
> > This looks a little strange.  If we special case zoned vs not zoned
> > here anyway, why not set the zone_write_granularity to the logical
> > block size here by default.
> 
> The convention is zone_write_granularity == 0 for the BLK_ZONED_NONE case. Hence
> the reset here if we force the zoned model to none for HA drives. This way, this
> does not create a special case for HA drives used as regular disks.

Just inititialize it for all cases if you initialize it for some here.
That way everyone but sd already gets a right default and life becomes
simpler.
