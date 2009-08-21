From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: O_DIRECT and barriers
Date: Fri, 21 Aug 2009 09:06:10 -0600
Message-ID: <1250867170.7363.17.camel@mulgrave.site>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
	 <20090820221221.GA14440@infradead.org> <20090821114010.GG12579@kernel.dk>
	 <20090821142008.GA30617@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090821142008.GA30617@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2009-08-21 at 10:20 -0400, Christoph Hellwig wrote:
> On Fri, Aug 21, 2009 at 01:40:10PM +0200, Jens Axboe wrote:
> > I've talked to Chris about this in the past too, but I never got around
> > to benchmarking FUA for O_DIRECT. It should be pretty easy to wire up
> > without making too many changes, and we do have FUA support on most SATA
> > drives too. Basically just a check in the driver for whether the
> > request is O_DIRECT and a WRITE, ala:
> > 
> >         if (rq_data_dir(rq) == WRITE && rq_is_sync(rq))
> >                 WRITE_FUA;
> > 
> > I know that FUA is used by that other OS, so I think we should be golden
> > on the hw support side.
> 
> Just doing FUA should be pretty easy, in fact from my reading of the
> code we already use FUA for barriers if supported, that is only drain
> the queue, do a pre-flush for a barrier and then issue the actual
> barrier write as FUA.

I've never really understood why FUA is considered equivalent to a
barrier.  Our barrier semantics are that all I/Os before the barrier
should be safely on disk after the barrier executes.  The FUA semantics
are that *this write* should be safely on disk after it executes ... it
can still leave preceding writes in the cache.  I can see that if you're
only interested in metadata that making every metadata write a FUA and
leaving the cache to sort out data writes does give FS image
consistency.

How does FUA give us linux barrier semantics?

James


