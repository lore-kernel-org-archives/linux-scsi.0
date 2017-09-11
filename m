From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V2 00/12] scsi-mq support for ZBC disks
Date: Mon, 11 Sep 2017 14:24:11 +0200
Message-ID: <20170911122411.GA22255@lst.de>
References: <20170907161640.30465-1-damien.lemoal@wdc.com> <20170908082040.GA25719@lst.de> <c3305202-43d3-20e3-825a-ae5fff462d54@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46125 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751013AbdIKMYM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Sep 2017 08:24:12 -0400
Content-Disposition: inline
In-Reply-To: <c3305202-43d3-20e3-825a-ae5fff462d54@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Bart Van Assche <Bart.VanAssche@wdc.com>, Jens Axboe <axboe@kernel.dk>

On Fri, Sep 08, 2017 at 09:12:12AM -0700, Damien Le Moal wrote:
> 1) The zone size and the number of zones of the device (for the bitmaps
> allocation and offset->zone number conversion).
> 2) Zone type for the optimization that avoids locking conventional zones.
> 
> (2) is optional. We can do without, but still really nice to have from a
> performance perspective as conventional zones tend to be used for
> storing metadata. So a lot of small random writes is more likely and
> high queue depth writing would improve performance significantly.
> 
> For (1), the zone size is known through q->limits.chunk_sectors. But the
> disk capacity is not known using request_queue only, so the number of
> zones cannot be calculated... I thought of exporting it through queue
> limits too, but then stacking of device mappers using ZBC drives becomes
> a pain as the number of zones needs to be recalculated.

For 4.14-rc+ you should be able to easily get at the gendisk as the
whole submission path is now gendisk based, although it might need
some minor argument reshuffle to pass it instead of the request_queue
in a few places.  Note that for everything passing the request
you can get the gendisk from the request as it contains a pointer.

The only annoying issue is that some of our passthrough character
device callers don't have a gendisk at all, which causes
problems all over and should probably be fixed at some point.
