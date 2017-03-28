From: "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [PATCH 1/7] =?utf-8?B?0ZVk?= =?utf-8?Q?=3A?= split
 sd_setup_discard_cmnd
Date: Tue, 28 Mar 2017 08:05:09 -0600
Message-ID: <20170328140509.GA27578@kernel.dk>
References: <20170320204319.12628-1-hch@lst.de>
 <20170320204319.12628-2-hch@lst.de>
 <1490653474.7897.13.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1490653474.7897.13.camel@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "hch@lst.de" <hch@lst.de>, "tj@kernel.org" <tj@kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 27 2017, Bart Van Assche wrote:
> On Mon, 2017-03-20 at 16:43 -0400, Christoph Hellwig wrote:
> > +	u64 sector = blk_rq_pos(rq) >> (ilog2(sdp->sector_size) - 9);
> > +	u32 nr_sectors = blk_rq_sectors(rq) >> (ilog2(sdp->sector_size) - 9);
> 
> Although I know this is an issue in the existing code and not something
> introduced by you: please consider using logical_to_sectors() instead of
> open-coding this function. Otherwise this patch looks fine to me.

The downside of doing that is that we still call ilog2() twice, which
sucks. Would be faster to cache ilog2(sector_size) and use that in the
shift calculation.

-- 
Jens Axboe
