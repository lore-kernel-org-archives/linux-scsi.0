From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 6/6] bsg: add SG_IO to SG v4
Date: Wed, 20 Dec 2006 11:24:44 +0100
Message-ID: <20061220102444.GO5010@kernel.dk>
References: <20061220144313T.fujita.tomonori@lab.ntt.co.jp> <20061220101614.GN5010@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:11850 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932721AbWLTKW6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Dec 2006 05:22:58 -0500
Content-Disposition: inline
In-Reply-To: <20061220101614.GN5010@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: linux-scsi@vger.kernel.org, dougg@torque.net

On Wed, Dec 20 2006, Jens Axboe wrote:
> On Wed, Dec 20 2006, FUJITA Tomonori wrote:
> > This adds SG_IO support to SG v4.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  block/bsg.c |   23 +++++++++++++++++++++--
> >  1 files changed, 21 insertions(+), 2 deletions(-)
> > 
> > diff --git a/block/bsg.c b/block/bsg.c
> > index 6d139d2..9dc5d36 100644
> > --- a/block/bsg.c
> > +++ b/block/bsg.c
> > @@ -945,8 +945,27 @@ bsg_ioctl(struct inode *inode, struct fi
> >  		void __user *uarg = (void __user *) arg;
> >  		return scsi_cmd_ioctl(file, bd->disk, cmd, uarg);
> >  	}
> > -	case SG_IO:
> > -		return -EINVAL;
> > +	case SG_IO: {
> > +		struct request *rq;
> > +		struct bio *bio;
> > +		struct sg_io_v4 hdr;
> > +
> > +		if (copy_from_user(&hdr, uarg, sizeof(hdr)))
> > +			return -EFAULT;
> > +
> > +		rq = bsg_map_hdr(bd, &hdr);
> > +		if (IS_ERR(rq))
> > +			return PTR_ERR(rq);
> > +
> > +		bio = rq->bio;
> 
> Pointless assignment. In fact the bio can be completely removed.

> > +		blk_execute_rq(bd->queue, bd->disk, rq, 0);
> > +		blk_complete_sgv4_hdr_rq(rq, &hdr, bio);

My mistake, the bio assignment is fine and of course needed.

-- 
Jens Axboe

