Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD41DC28CF5
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jan 2022 08:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbiAZItz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jan 2022 03:49:55 -0500
Received: from verein.lst.de ([213.95.11.211]:38949 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230222AbiAZIty (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Jan 2022 03:49:54 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id AEA7268AFE; Wed, 26 Jan 2022 09:49:50 +0100 (CET)
Date:   Wed, 26 Jan 2022 09:49:50 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 05/13] block: only account passthrough IO from
 userspace
Message-ID: <20220126084950.GA23957@lst.de>
References: <20220122111054.1126146-6-ming.lei@redhat.com> <20220124130555.GD27269@lst.de> <Ye8xleeYZfmwA3D7@T590> <20220125061634.GA26495@lst.de> <20220125071906.GA27674@lst.de> <Ye++VmBkg0I8Lq8+@T590> <20220126055003.GA21089@lst.de> <YfD2YNRf+lhe5BcU@T590> <20220126081052.GA23154@lst.de> <YfEHcs6psrBqFu3l@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfEHcs6psrBqFu3l@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 26, 2022 at 04:33:54PM +0800, Ming Lei wrote:
> > I guess you are worried about the latter conditionin that we stop
> > accounting for no data transfer passthrough commands?
> 
> No, I meant that bio->bi_bdev isn't setup yet for passthrough request,
> and not sure that can be done easily.

Take a look at e.g. nvme_submit_user_cmd and iblock_get_bio.
