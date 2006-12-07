From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: RFC: SCSI Generic version 4 interface
Date: Thu, 7 Dec 2006 09:30:20 +0100
Message-ID: <20061207083019.GY4392@kernel.dk>
References: <20061107153147.GV19471@kernel.dk> <20061207170208R.fujita.tomonori@lab.ntt.co.jp> <20061207080657.GX4392@kernel.dk> <20061207172133L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:28909 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031852AbWLGI32 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Dec 2006 03:29:28 -0500
Content-Disposition: inline
In-Reply-To: <20061207172133L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jeff@garzik.org, dougg@torque.net, linux-scsi@vger.kernel.org

On Thu, Dec 07 2006, FUJITA Tomonori wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> Subject: Re: RFC: SCSI Generic version 4 interface
> Date: Thu, 7 Dec 2006 09:06:59 +0100
> 
> > On Thu, Dec 07 2006, FUJITA Tomonori wrote:
> > > From: Jens Axboe <jens.axboe@oracle.com>
> > > Subject: Re: RFC: SCSI Generic version 4 interface
> > > Date: Tue, 7 Nov 2006 16:31:48 +0100
> > > 
> > > > On Tue, Nov 07 2006, Jeff Garzik wrote:
> > > > > Douglas Gilbert wrote:
> > > > > >I was asked to put together a proposal in May this
> > > > > >year for a new SCSI Generic interface structure. This
> > > > > >is the same structure that is used by the block layer
> > > > > >SG_IO ioctl. A few people have asked whether I had forgotten
> > > > > >that I agreed to write the proposal. So here it is. Those
> > > > > >who have seen it have made comments, some of which have
> > > > > >been incorporated.
> > > > > >
> > > > > >Some shortcomings of the sg version 3 interface are:
> > > > > >  - can't handle commands with bidirectional data (either
> > > > > >    can the SCSI subsystem at the moment)
> > > > > >  - if it was a bit more general it could carry other
> > > > > >    request/response protocols (e.g. Task Management
> > > > > >    Functions and SMP in Serial Attached SCSI)
> > > > > >  - no way of associating a task attribute or task tag
> > > > > >    with a SCSI command
> > > > > 
> > > > > Why avoid Jens Axboe's bsg?
> > > > > 
> > > > > It seems like that is already a good interface for carrying other 
> > > > > req/resp protocols.
> > > > 
> > > > I don't think Doug is avoiding that (if you are Doug, please do explain
> > > > :-), but rather outlining the next generation command format that bsg
> > > > should support for future use.
> > > 
> > > sg4 can be implemented on bsg nicely, I think. But why does the
> > > current bsg support sg3 partially? Do you plan to add the rest of sg3
> > > (which doesn't work nicely) to bsg?
> > 
> > What parts of sg v3 are missing? It's been a while since I implemented
> > that stuff, so I forget if I knowingly left out some features.
> 
> SG_FLAG_MMAP_IO, indirect IO, probably I miss something more.

bsg chooses the best way to handle the buffers on its own right now, in
my opinion sg has grown too many "features" that aren't very useful. If
the buffer and length are properly aligned, bsg does direct io. If not,
it does indirect.  mmap io may be useful, we could add that if anyone is
actually using it.

-- 
Jens Axboe

