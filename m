Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9711C28CF5
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jan 2022 16:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243170AbiAZQhe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jan 2022 11:37:34 -0500
Received: from verein.lst.de ([213.95.11.211]:40700 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243168AbiAZQhb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Jan 2022 11:37:31 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 500F768AFE; Wed, 26 Jan 2022 17:37:28 +0100 (CET)
Date:   Wed, 26 Jan 2022 17:37:28 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 05/13] block: only account passthrough IO from
 userspace
Message-ID: <20220126163728.GA31935@lst.de>
References: <Ye8xleeYZfmwA3D7@T590> <20220125061634.GA26495@lst.de> <20220125071906.GA27674@lst.de> <Ye++VmBkg0I8Lq8+@T590> <20220126055003.GA21089@lst.de> <YfD2YNRf+lhe5BcU@T590> <20220126081052.GA23154@lst.de> <YfEHcs6psrBqFu3l@T590> <20220126084950.GA23957@lst.de> <YfEbbPr1Q5Ci48cg@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfEbbPr1Q5Ci48cg@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 26, 2022 at 05:59:08PM +0800, Ming Lei wrote:
> nvme just sets part0 to rq->bio, which is fine since nvme doesn't
> support partial completion.
> 
> The simplest way could be to assign bio->bi_bdev with q->disk->part0 in both
> bio_copy_user_iov() and bio_map_user_iov(), which should cover most of cases.
> Given user io is always on device instead of partition even though the
> command is sent via partition bdev.

This would be easiest, but it would also assign them when called from
the SG driver.  And that means these I/Os could be in flight when
detaching a SCSI ULP.  At least without the freeze in del_gendisk
(or the local one in case of the sd driver).
