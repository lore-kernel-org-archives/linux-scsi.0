From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] improvement of fastfail operation
Date: Thu, 1 Apr 2004 00:04:17 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040331220416.GQ24370@suse.de>
References: <1080696593.2075.120.camel@mulgrave> <Pine.LNX.4.44.0403302108550.7851-200000@dyn319701.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:13763 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261802AbUCaWFu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Mar 2004 17:05:50 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0403302108550.7851-200000@dyn319701.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Mar 30 2004, Mike Christie wrote:
> On 30 Mar 2004, James Bottomley wrote:
> 
> > On Mon, 2004-03-29 at 07:17, Masao Fukuchi wrote:
> > > By the way, how about item 1.
> > > I think this is bug and we need to validate fastfail for command timeout.
> > > If you agree with this, please put it into official patch.
> > > (See attached patch)
> > 
> > Well, the patch doesn't apply, but I put an equivalent in the tree.
> > 
> > > Next, I tested the fastfail recovery using Kernel 2.6.4.
> > > But the command didn't complete forever.
> > > Then I installed following Mike Christie's patch and it worked fine.
> > >  http://marc.theaimsgroup.com/?l=linux-scsi&m=107904932710899&w=2
> > > Please put it into official patch.
> > 
> > This patch is obviously wrong on its face.  It completes the request
> > without regard to any leftovers.
> > 
> > There's clearly a problem somewhere in the completion path for commands
> > that run out of retries, but whatever it is, this patch only covers it
> > up it doesn't solve the root problem.
> > 
> 
> This patch
> http://marc.theaimsgroup.com/?l=linux-scsi&m=107904932710899&w=2
> is correct wrt how the block layer uses hard_nr_sectors ;)
> 
> The blkdev.h comments state that hard_nr_sectors is the number
> of sectors left to be completed. This is managed by the block layer
> for drivers like SCSI when end_that_request_* calls
> __end_that_request_first which for partial completions calls
> blk_recalc_rq_sectors. This function updates hard_nr_sectors
> by the completed number of bytes, so by scsi_end_request doing this:
> 
>  if (end_that_request_chunk(req, uptodate, bytes)) {
>         int leftover = (req->hard_nr_sectors << 9) - bytes;
> 
> we end up with "bytes" getting subtracted twice and the final
> bio not getting completed.

Yeah, that's the buggy bit. Ater calling end_that_request_chunk(), that
should just read

	int leftover = req->hard_nr_sectors << 9;

which iirc is what your patch did, it was correct.

> I know we went through that already. It is just to update
> Masao/linux-scsi.
> 
> I had sent the attached patch to Jens (cc'd him)
> that modifies how blk_recalc_rq_sectors uses hard_nr_sectors,
> but I think it might break some other drivers that expect the
> hard_nr_sectors to be updated as the request is completed.

Yeah that doesn't work... hard_* values are really just to make sure
that the non-hard values are sane after block driver messes with the
other ones. So consider hard_* internal block stuff.

So the new patch you sent with this mail is no good. Your previous one
should be adopted ;-)

-- 
Jens Axboe

