From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 06/23] dm-kcopyd: switch to use REQ_OP_WRITE_ZEROES
Date: Thu, 23 Mar 2017 11:10:38 -0400
Message-ID: <20170323151037.GC17127@redhat.com>
References: <20170323143341.31549-1-hch@lst.de>
 <20170323143341.31549-7-hch@lst.de>
 <20170323145522.GB17127@redhat.com>
 <20170323145651.GA31771@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170323145651.GA31771@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 23 2017 at 10:56am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> On Thu, Mar 23, 2017 at 10:55:22AM -0400, Mike Snitzer wrote:
> > See commit 70d6c400a ("dm kcopyd: add WRITE SAME support to dm_kcopyd_zero")
> > drivers/md/dm-io.c:do_region() adjusts the WRITE SAME payload to be a
> > single page.
> > 
> > So you'd want to tweak dm-io.c accordingly for WRITE ZEROES (presummably
> > no payload?)
> 
> Yeah, I'll look into it.

Ah, your previous 05/23 patch re-uses the discard branch in
dm-io.c:do_region.  Looks correct.  So you should be good.

Not sure why you've split out the dm-kcopyd patch, likely best to just
fold it into the previous dm support patch.

I'll try your code out on my testbed, probably tomorrow, but in general
the DM code looks solid (thanks for doing it!).  But I'll take a closer
look and will report back with my Reviewed-by if all looks (and tests
out) good.

> Any good test case for verifying this code while I've got your
> attention?

DM thinp is the only consumer of dm_kcopyd_zero().  DM thinp
conservatively defaults to zeroing (but we recommend
'skip_block_zeroing' for most setups).  So anyway, just using a DM thin
device with partial thin blocksize IO (without 'skip_block_zeroing')
should get you coverage.

The device-mapper-test-suite thin tests have thinp w/ zeroing coverage
so I'll be sure to run those.
