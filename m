Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98114C3F2C6
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 06:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 688082192A
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 06:24:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ELkoBwNz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgCKGYH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 02:24:07 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49070 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgCKGYH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2020 02:24:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jXEywDLUJFLPe676gL/ac97/VyQ5qLJgQIFldyhTKCQ=; b=ELkoBwNz6tBNaYPGgO6JIxs5Mo
        7YVwESOwVGqNFg5+4moVhDNUOCIeSFfuKh6Tutkk3VJyRGr7RpcAabmJ8IRyM2WCh86nGuwEIl79a
        0xD6EDeCM1rbegZuDXuv3bg1JgZmSbgtebuhw1GCYGnNkD/tXtctdD4/p3Pcuc4AnMigpRsMjV4yg
        megNCe/vZfXQX38GtfhdddpD5bgV2vSf/jaoqu+YiCLkoLXxke/T4XRQvzi/Uw/+NxJ+XBYPZdPi5
        4czR7T1v5mTN5R6x4LGshMsOaWuTK26Z/tXc0XhgI8cx+J9tCc2kSHYdwkYbBy85OxcbOT0ACI2gw
        lXMBlfDg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jBumk-0001Zj-SD; Wed, 11 Mar 2020 06:24:06 +0000
Date:   Tue, 10 Mar 2020 23:24:06 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 09/11] block: Introduce zone write pointer offset caching
Message-ID: <20200311062406.GA5729@infradead.org>
References: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
 <20200310094653.33257-10-johannes.thumshirn@wdc.com>
 <20200310164615.GG15878@infradead.org>
 <BYAPR04MB5816F62B4BB0482359F85AD8E7FC0@BYAPR04MB5816.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR04MB5816F62B4BB0482359F85AD8E7FC0@BYAPR04MB5816.namprd04.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 11, 2020 at 12:34:33AM +0000, Damien Le Moal wrote:
> Yes, I agree with you here. That would be nicer, but early attempt to do so
> failed as we always ended up with potential races on number of zones/wp array
> size in the case of a device change/revalidation. Moving the wp array allocation
> and initialization to blk_revalidate_disk_zones() greatly simplifies the code
> and removes the races as all updates to zone bitmaps, wp array and nr zones are
> done under a queue freeze all together. Moving the wp array only to sd_zbc, even
> using a queue freeze, leads to potential out-of-bounds accesses for the wp array.
> 
> Another undesirable side effect of moving the wp array initialization to sd_zbc
> is that we would need another full drive zone report after
> blk_revalidate_disk_zones() own full report. That is costly. On 20TB SMR disks
> with more than 75000 zones, the added delay is significant. Doing all
> initialization within blk_revalidate_disk_zones() full zone report loop avoids
> that added overhead.

That explanation needs to got into the commit log.
