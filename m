From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: sd_setup_discard_cmnd: BUG: unable to handle kernel NULL pointer
 dereference at (null)
Date: Fri, 20 Jun 2014 17:53:21 +0200
Message-ID: <20140620155321.GA24389@soda.linbit>
References: <53A28B21.7070500@profihost.ag>
 <yq1ionwjn15.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1ionwjn15.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, JBottomley@parallels.com, Jens Axboe <axboe@kernel.dk>, konrad.wilk@oracle.com, elder@linaro.org, Josh Durgin <josh.durgin@inktank.com>, Greg KH <gregkh@linuxfoundation.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 19, 2014 at 11:08:22PM -0400, Martin K. Petersen wrote:
> >>>>> "Stefan" == Stefan Priebe <- Profihost AG <s.priebe@profihost.ag>> writes:
> 
> Stefan> Hi, while using vanilla 3.10.44 with drbd on top of a md raid1.
> 
> Stefan> I'm pretty often hitting the followin kernel bug.
> 
> Stefan> [<ffffffff8128105c>] blk_add_request_payload+0xc/0x90
> 
> That's really messed up. This means we received a request with no bio.

No.
That means you received a bio that has been allocated with
bio_alloc(... , nr_iovecs = 0);

thus bio->bi_io_vec is NULL,
but blk_add_request_payload insists on using it anyways.

Even though it also requires that bio->bi_vcnt = 0
(because it then explicitly sets that to 1).

This is some subtlety with discard requests that has bitten some
stacking drivers now.

Any bio allocated that will be passed down with REQ_DISCARD
has to be allocated with nr_iovecs = 1 (at least),
even though it must not contain any bio_vec payload.

Though DRBD in 3.10 is not supposed to accept discard requests.
So I'm not sure how it manages to pass them down?

	Lars

