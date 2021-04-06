Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94B6FC433B4
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 06:27:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D93461205
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 06:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238210AbhDFG2C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 02:28:02 -0400
Received: from verein.lst.de ([213.95.11.211]:53104 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237859AbhDFG2B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Apr 2021 02:28:01 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4B5BE68BEB; Tue,  6 Apr 2021 08:27:50 +0200 (CEST)
Date:   Tue, 6 Apr 2021 08:27:50 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/8] Buslogic: remove ISA support
Message-ID: <20210406062750.GA6277@lst.de>
References: <20210331073001.46776-1-hch@lst.de> <20210331073001.46776-3-hch@lst.de> <alpine.DEB.2.21.2104031805520.18977@angie.orcam.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2104031805520.18977@angie.orcam.me.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Apr 03, 2021 at 06:58:24PM +0200, Maciej W. Rozycki wrote:
>  Last but not least I do hope you do not plan to retire ISA DMA bounce 
> buffering support for drivers/block/floppy.c, as there is hardly an 
> alternative available (I do have a single SCSI<->FDD interface built 
> around an Intel 8080 CPU, in the half-height 5.25" drive form factor, but 
> such devices are exceedingly rare, and then you need a suitable parallel 
> SCSI host too).

The floppy driver already uses its own bounce buffering for addressing
limitations, and only the kernel bounce buffering to avoid getting
fed highmem patches.  Please take a look at this series to clean up the
latter:

https://lore.kernel.org/linux-block/20210406061755.811522-1-hch@lst.de/T/#u

>  Would it be feasible to convert it and any other drivers for ISA DMA 
> devices (like those support for which you propose to remove here) still 
> have users who could verify operation to the IOMMU framework?

I've converted the only once that still has signs of having users in
the last 10 or so years.
