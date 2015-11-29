From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: block: Always check queue limits for cloned requests
Date: Sun, 29 Nov 2015 12:49:56 +0100
Message-ID: <20151129114956.GA321@x4>
References: <1448524017-130967-1-git-send-email-hare@suse.de>
 <20151126131104.GA24297@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151126131104.GA24297@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ewan Milne <emilne@redhat.com>, Jeff Moyer <jmoyer@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 2015.11.26 at 08:11 -0500, Mike Snitzer wrote:
> On Thu, Nov 26 2015 at  2:46am -0500,
> Hannes Reinecke <hare@suse.de> wrote:
> 
> > When a cloned request is retried on other queues it always needs
> > to be checked against the queue limits of that queue.
> > Otherwise the calculations for nr_phys_segments might be wrong,
> > leading to a crash in scsi_init_sgtable().
> > 
> > To clarify this the patch renames blk_rq_check_limits()
> > to blk_cloned_rq_check_limits() and removes the symbol
> > export, as the new function should only be used for
> > cloned requests and never exported.
> > 
> > Cc: Mike Snitzer <snitzer@redhat.com>
> > Cc: Ewan Milne <emilne@redhat.com>
> > Cc: Jeff Moyer <jmoyer@redhat.com>
> > Signed-off-by: Hannes Reinecke <hare@suse.de>
> 
> Patch looks good.  Thanks for getting to the bottom of this.
> 
> Jens, please add these extra tags when you pick this up:
> 
> Fixes: e2a60da74 ("block: Clean up special command handling logic")
> Cc: stable@vger.kernel.org # 3.7+
> Acked-by: Mike Snitzer <snitzer@redhat.com>

I'm still seeing the issue (BUG at drivers/scsi/scsi_lib.c:1096!) even
with this patch applied.

markus@x4 linux % git describe
v4.4-rc2-215-g081f3698e606

-- 
Markus
