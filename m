Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9DEFC28CF5
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jan 2022 05:50:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbiAZFuI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jan 2022 00:50:08 -0500
Received: from verein.lst.de ([213.95.11.211]:38471 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233890AbiAZFuH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Jan 2022 00:50:07 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2E30867373; Wed, 26 Jan 2022 06:50:04 +0100 (CET)
Date:   Wed, 26 Jan 2022 06:50:03 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 05/13] block: only account passthrough IO from
 userspace
Message-ID: <20220126055003.GA21089@lst.de>
References: <20220122111054.1126146-1-ming.lei@redhat.com> <20220122111054.1126146-6-ming.lei@redhat.com> <20220124130555.GD27269@lst.de> <Ye8xleeYZfmwA3D7@T590> <20220125061634.GA26495@lst.de> <20220125071906.GA27674@lst.de> <Ye++VmBkg0I8Lq8+@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ye++VmBkg0I8Lq8+@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 25, 2022 at 05:09:42PM +0800, Ming Lei wrote:
> Follows another simple way by accounting all request with bio attached,
> except for requests with kernel buffer.

> -	else if (rq->q->disk)
> +	else if (rq->q->disk && rq->bio)
>  		rq->part = rq->q->disk->part0;

Most passthrough requests will have a bio, so you'll still use e.g.
the sd gendisk for sg request here.

I think the right way would be to just remove this branch entirely.
This means we only account bios with a block_device, which implies
they have a gendisk.
