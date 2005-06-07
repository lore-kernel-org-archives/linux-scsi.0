From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all block pc
	requests and simplify hw handlers
Date: Tue, 7 Jun 2005 20:09:43 +0200
Message-ID: <20050607180942.GC8172@suse.de>
References: <1117847972.23638.62.camel@mina> <1117901234.5005.9.camel@mulgrave>
	<20050607121020.GA6458@infradead.org>
	<1118146802.4998.3.camel@mulgrave>
	<1118158614.42a5bf160d317@webmail.cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1118158614.42a5bf160d317@webmail.cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Michael Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 07 2005, Michael Christie wrote:
> Quoting James Bottomley <James.Bottomley@SteelEye.com>:
> 
> > On Tue, 2005-06-07 at 13:10 +0100, Christoph Hellwig wrote:
> > > shouldn't blk_rq_map_kern handle a 0 buffer and do nothing more than
> > > blk_get_request?  It's not exactly a criticial fastpath and that would make
> > life
> > > easier for the callers.
> > 
> > Yes ... and it should probably do bio bouncing as well, since there's
> > nothing special we have to do on completion to clean it up.
> 
> ok. I just made it like the existing blk_rq_map_user which made the caller do
> those things.

I agree with Christoph, makes it nicer for blk_rq_map_user as well. I'll
change the latter if you fix the former.

> > I also think we might need a blk_rq_kern_iovec call that would take a
> > vector of user I/O's and map it to a multiple bio request.  This would
> 
> Does it need to be a multiple bio request? A single bio should be able
> to handle a request's segments and sectors limits.

Indeed.

> Will the user assure that the iovec will fit in a single request to
> handle a case where the iovec is greater than the phys or hw segment
> limits though?

This is where the block layer SG_IO and the SCSI layer sg differ. The
SCSI layer has historically handled these partial completion requests
fine, where the block layer didn't provide functionality for it and the
ide driver didn't cope with it.

-- 
Jens Axboe
