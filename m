Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B3F7C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jan 2022 06:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244645AbiAYGTr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jan 2022 01:19:47 -0500
Received: from verein.lst.de ([213.95.11.211]:34076 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229533AbiAYGQk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jan 2022 01:16:40 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 96C0868BFE; Tue, 25 Jan 2022 07:16:34 +0100 (CET)
Date:   Tue, 25 Jan 2022 07:16:34 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 05/13] block: only account passthrough IO from
 userspace
Message-ID: <20220125061634.GA26495@lst.de>
References: <20220122111054.1126146-1-ming.lei@redhat.com> <20220122111054.1126146-6-ming.lei@redhat.com> <20220124130555.GD27269@lst.de> <Ye8xleeYZfmwA3D7@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ye8xleeYZfmwA3D7@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 25, 2022 at 07:09:09AM +0800, Ming Lei wrote:
> > Please explain why you want to change this.
> 
> Please see the following code:

This needs to go into the commit log.

> 
>         /* passthrough requests can hold bios that do not have ->bi_bdev set */
>         if (rq->bio && rq->bio->bi_bdev)
>                 rq->part = rq->bio->bi_bdev;
>         else if (rq->q->disk)
>                 rq->part = rq->q->disk->part0;
> 
> q->disk can be cleared by disk_release() just when referring the above line, then
> NULL ptr reference is caused, and similar issue with any reference to rq->part for
> passthrough request sent not from userspace.

So why not key off accouning off "rq->bio && rq->bio->bi_bdev"
and remove the need for the flag and the second half of the assignment
above?  That is much less error probe and removes code size.
