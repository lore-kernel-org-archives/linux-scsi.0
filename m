From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: RFC: SCSI Generic version 4 interface
Date: Thu, 07 Dec 2006 23:12:25 +0900
Message-ID: <200612071412.kB7ECPsN018881@r-dd.iij4u.or.jp>
References: <20061207083019.GY4392@kernel.dk>
	<20061207175351Y.fujita.tomonori@lab.ntt.co.jp>
	<20061207085756.GZ4392@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo01.iij4u.or.jp ([210.130.0.20]:61237 "EHLO mo01.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032246AbWLGOMo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Dec 2006 09:12:44 -0500
In-Reply-To: <20061207085756.GZ4392@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, dougg@torque.net, linux-scsi@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: RFC: SCSI Generic version 4 interface
Date: Thu, 7 Dec 2006 09:57:56 +0100

> On Thu, Dec 07 2006, FUJITA Tomonori wrote:
> > From: Jens Axboe <jens.axboe@oracle.com>
> > Subject: Re: RFC: SCSI Generic version 4 interface
> > Date: Thu, 7 Dec 2006 09:30:20 +0100
> > 
> > > On Thu, Dec 07 2006, FUJITA Tomonori wrote:
> > > > From: Jens Axboe <jens.axboe@oracle.com>
> > > > Subject: Re: RFC: SCSI Generic version 4 interface
> > > > Date: Thu, 7 Dec 2006 09:06:59 +0100
> > > > 
> > > > > On Thu, Dec 07 2006, FUJITA Tomonori wrote:
> > > > > > From: Jens Axboe <jens.axboe@oracle.com>
> > > > > > Subject: Re: RFC: SCSI Generic version 4 interface
> > > > > > Date: Tue, 7 Nov 2006 16:31:48 +0100
> > > > > > 
> > > > > > > On Tue, Nov 07 2006, Jeff Garzik wrote:
> > > > > > > > Douglas Gilbert wrote:
> > > > > > > > >I was asked to put together a proposal in May this
> > > > > > > > >year for a new SCSI Generic interface structure. This
> > > > > > > > >is the same structure that is used by the block layer
> > > > > > > > >SG_IO ioctl. A few people have asked whether I had forgotten
> > > > > > > > >that I agreed to write the proposal. So here it is. Those
> > > > > > > > >who have seen it have made comments, some of which have
> > > > > > > > >been incorporated.
> > > > > > > > >
> > > > > > > > >Some shortcomings of the sg version 3 interface are:
> > > > > > > > >  - can't handle commands with bidirectional data (either
> > > > > > > > >    can the SCSI subsystem at the moment)
> > > > > > > > >  - if it was a bit more general it could carry other
> > > > > > > > >    request/response protocols (e.g. Task Management
> > > > > > > > >    Functions and SMP in Serial Attached SCSI)
> > > > > > > > >  - no way of associating a task attribute or task tag
> > > > > > > > >    with a SCSI command
> > > > > > > > 
> > > > > > > > Why avoid Jens Axboe's bsg?
> > > > > > > > 
> > > > > > > > It seems like that is already a good interface for carrying other 
> > > > > > > > req/resp protocols.
> > > > > > > 
> > > > > > > I don't think Doug is avoiding that (if you are Doug, please do explain
> > > > > > > :-), but rather outlining the next generation command format that bsg
> > > > > > > should support for future use.
> > > > > > 
> > > > > > sg4 can be implemented on bsg nicely, I think. But why does the
> > > > > > current bsg support sg3 partially? Do you plan to add the rest of sg3
> > > > > > (which doesn't work nicely) to bsg?
> > > > > 
> > > > > What parts of sg v3 are missing? It's been a while since I implemented
> > > > > that stuff, so I forget if I knowingly left out some features.
> > > > 
> > > > SG_FLAG_MMAP_IO, indirect IO, probably I miss something more.
> > > 
> > > bsg chooses the best way to handle the buffers on its own right now, in
> > > my opinion sg has grown too many "features" that aren't very useful.
> > 
> > I agree. But if bsg replaces sg3 code, it supports the full features,
> > doesn't it? If bsg does not replace sg3 code, we have more
> > duplication.
> > 
> > I think it would be nice for bsg to support only sg4 (does not support
> > some of the old sg3 interfaces) and not add sg4 support to sg.c and
> > scsi_ioctl.c (of course they can share some code).
> 
> Yeah, I agree with that (if only to reduce my headache of actually
> supporting the code!). When the sg v4 command interface is fully fleshed
> out, I'm fine with moving bsg in that direction and dumping sg v3
> support completely.

Nice.

BTW, do you plan to use bsg only for sg4 (like putting sg4 hdr into
bsg_command directly) or provide generic interfaces (I mean that sg4
calls something like bsg_register_protocol) ?


> > Oh, bsg's sg3 doesn't work on 32-bit userspace and 64-bit kernel too
> > if applicationos use the iovec interface, does it?
> 
> Probably not, haven't looked or checked :-)

Whatever sg3 interface is used, bsg's sg3 doesn't work in such
environments, I think.


> > > mmap io may be useful, we could add that if anyone is actually using
> > > it.
> > 
> > sg mmap io is tricky. sg_io_hdr doesn't have a mapped address,
> > instead, the sg driver keeps a mapped address when an application
> > calls mmap (that means sg cannot handle multiple mmap io requests
> > simultaneously).
> 
> With sg v3 support out of the picture, that's not a worry. I'll probably
> look into a different request/response architecture as well, the user
> visible ring buffer is a strong approach in my opinion.

The scsi target infrastructure uses something like that. I'd like to
use bsg for it in the future.
