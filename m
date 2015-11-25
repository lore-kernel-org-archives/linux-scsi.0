From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: kernel BUG at drivers/scsi/scsi_lib.c:1096!
Date: Wed, 25 Nov 2015 16:20:26 -0500
Message-ID: <20151125212026.GA19936@redhat.com>
References: <20151119082325.GA11419@infradead.org>
 <564DEC41.5010600@suse.de>
 <1448030316.4067.18.camel@localhost.localdomain>
 <564F3453.9040603@suse.de>
 <1448033323.4067.24.camel@localhost.localdomain>
 <565579A2.4000005@suse.de>
 <5655F635.5040805@fb.com>
 <5656079A.3040805@suse.de>
 <56560ADF.9060905@fb.com>
 <20151125202317.GA19657@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbbKYVU2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Nov 2015 16:20:28 -0500
Content-Disposition: inline
In-Reply-To: <20151125202317.GA19657@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Hannes Reinecke <hare@suse.de>, emilne@redhat.com, Christoph Hellwig <hch@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>, Mark Salter <msalter@redhat.com>, "James E. J. Bottomley" <JBottomley@odin.com>, brking <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-block@vger.kernel.org, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

On Wed, Nov 25 2015 at  3:23pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Wed, Nov 25 2015 at  2:24pm -0500,
> Jens Axboe <axboe@fb.com> wrote:
> 
> > On 11/25/2015 12:10 PM, Hannes Reinecke wrote:
> > >The problem is that NOMERGE does too much, as it inhibits _any_ merging.
> > 
> > Right, that is the point of the flag from the block layer view,
> > where it was originally added for the case mentioned.
> 
> And we really don't want _any_ merging.  The merging, if any, will have
> already happened in upper DM-multipath's elevator.  So there should be
> no need to have the underlying SCSI paths do any merging.
> 
> > >Unfortunately, the req->nr_phys_segments value is evaluated in the final
> > >_driver_ context _after_ the merging happend; cf
> > >scsi_lib.c:scsi_init_sgtable().
> > >As nr_phys_segments is inherited from the original request (and never
> > >recalculated with the new request queue limits) the following
> > >blk_rq_map_sg() call might end up at a different calculation, especially
> > >after retrying a request on another path.
> > 
> > That all sounds pretty horrible. Why is blk_rq_check_limits()
> > checking for mergeable at all? If merging is disabled on the
> > request, I'm assuming that's an attempt at an optimization since we
> > know it won't change. But that should be tracked separately, like
> > how it's done on the bio.
> 
> Not clear to me why it was checking for merging...

Ewan pointed out that blk_rq_check_limits()'s call to rq_mergable() was
introduced as part of Martin's DISCARD cleanup that prepared for
WRITE_SAME, see: commit e2a60da74 ("block: Clean up special command handling logic")

And prior to that, blk_rq_check_limits()'s (rq->cmd_flags & REQ_DISCARD)
check was introduced by some guy crazy doppelganger name "Ike Snitzer",
see commit: 3383977f ("block: update request stacking methods to support discards")

So basically we probably never needed the extra check in
blk_rq_check_limits() to begin with.. Ike was probably paranoid. ;)
