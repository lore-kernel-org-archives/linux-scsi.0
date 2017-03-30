From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 22/23] drbd: implement REQ_OP_WRITE_ZEROES
Date: Thu, 30 Mar 2017 13:44:09 +0200
Message-ID: <20170330114408.GA15777@lst.de>
References: <20170323143341.31549-1-hch@lst.de> <20170323143341.31549-23-hch@lst.de> <20170330100641.GI5939@soda.linbit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170330100641.GI5939@soda.linbit>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 30, 2017 at 12:06:41PM +0200, Lars Ellenberg wrote:
> On Thu, Mar 23, 2017 at 10:33:40AM -0400, Christoph Hellwig wrote:
> > It seems like DRBD assumes its on the wire TRIM request always zeroes data.
> > Use that fact to implement REQ_OP_WRITE_ZEROES.
> > 
> > XXX: will need a careful audit from the drbd team!
> 
> Thanks, this one looks ok to me.

So the DRBD protocol requires the TRIM operation to always zero?

> The real question for me is, will the previous one (21/23)
> return != 0 (some EOPNOTSUPP or else) to DRBD in more situations than
> what we have now?

No, blkdev_issue_zeroout should never return -EOPNOTSUPP.

> Will it make an fstrim cause thinly provisioned
> devices to suddenly be fully allocated?

Not for SCSI devices.  Yes for dm-thinp until it implements
REQ_OP_WRITE_ZEROES, which will hopefully be soon.
