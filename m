From: "Smart, James" <James.Smart@Emulex.Com>
Subject: RE: Emulex lpfcdriver v8.0.2 available
Date: Wed, 2 Jun 2004 09:03:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF28034F9421@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:28588 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S262488AbUFBNDQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Jun 2004 09:03:16 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>, Anton Blanchard <anton@samba.org>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>


Anton,

Thanks for the feedback.

We've avoided (actually removed) more driver memory pools. The thought was
that it was unneeded, especially as kmem_alloc is ultimately mempool backed.

The real issue, as Christoph points out, is the allocations taking place
under spinlocks, thus requiring the atomic allocations. The driver has a
very ugly lock scheme due to past history, and one which we are hesitant to
rewrite right now (it will happen, but not in the short term).  

Anyway - there's a couple of things we're going to do...  The first is to
reorder the fastpath (queuecommand -> to the hardware) so that we can
perform the allocations outside of locks, thus loose the atomic requirement.
The number of allocations is not excessive, but there are a couple of spots
where separate control structures are always allocated which we can optimize
by embedding them in other structures.  Hopefully, this can make the code
drop due the end of the week.

-- James S


> -----Original Message-----
> From: 'Christoph Hellwig' [mailto:hch@infradead.org]
> Sent: Tuesday, June 01, 2004 3:01 PM
> To: Anton Blanchard
> Cc: Smart, James; 'linux-scsi@vger.kernel.org'
> Subject: Re: Emulex lpfcdriver v8.0.2 available
> 
> 
> On Wed, Jun 02, 2004 at 04:52:00AM +1000, Anton Blanchard wrote:
> > We gave it a spin on a ppc64 box and managed to hit the following
> > backtrace when doing heavy writeout. I wonder if a number of these
> > atomic allocations (in lpfc_get_scsi_buf etc) should be 
> using a mempool,
> > otherwise we could deadlock on writeout.
> 
> The ->queuecommand path has a few more problems.  The number 
> of different
> memory allocation is just too many, this needs some thinking 
> into needing
> less allocations.  Most allocations are happening under a spinlock and
> with irqs disabled which is not exactly a good idea.  And the whole
> I/O submission path is very badly structured and hard to follow.
> 
