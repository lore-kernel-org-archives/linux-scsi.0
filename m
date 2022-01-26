Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19EEDC28CF5
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jan 2022 08:10:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238180AbiAZIK4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jan 2022 03:10:56 -0500
Received: from verein.lst.de ([213.95.11.211]:38846 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230194AbiAZIK4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Jan 2022 03:10:56 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id DB70F68AFE; Wed, 26 Jan 2022 09:10:52 +0100 (CET)
Date:   Wed, 26 Jan 2022 09:10:52 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 05/13] block: only account passthrough IO from
 userspace
Message-ID: <20220126081052.GA23154@lst.de>
References: <20220122111054.1126146-1-ming.lei@redhat.com> <20220122111054.1126146-6-ming.lei@redhat.com> <20220124130555.GD27269@lst.de> <Ye8xleeYZfmwA3D7@T590> <20220125061634.GA26495@lst.de> <20220125071906.GA27674@lst.de> <Ye++VmBkg0I8Lq8+@T590> <20220126055003.GA21089@lst.de> <YfD2YNRf+lhe5BcU@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfD2YNRf+lhe5BcU@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 26, 2022 at 03:21:04PM +0800, Ming Lei wrote:
> > I think the right way would be to just remove this branch entirely.
> > This means we only account bios with a block_device, which implies
> > they have a gendisk.
> 
> That will not account userspace IO, and people may complain.
> 
> We can just account passthrough request from userspace by the patch
> in my last email.

Let's take a step back:  what I/O do we want to account, and how
do we want to archive that?

Assuming accounting is enabled:

 - current mainline accounts all I/O one queues that have a gendisk
 - your original patch accounts file system I/O and some passthrough I/O
   that has a special flag set

Dropping the conditional to grab a bdev from the queue leaves us with
the following rule:

 - all I/O that has a bio and bdev is accounted.  This requires
   passthrough I/O to explicitly set the bdev in case we haven't
   done so, and it requires them to have a bio at all

I guess you are worried about the latter conditionin that we stop
accounting for no data transfer passthrough commands?
