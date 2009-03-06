From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
Date: Fri, 06 Mar 2009 15:59:10 -0600
Message-ID: <1236376750.20520.7.camel@localhost.localdomain>
References: <20090306085529.GP11787@kernel.dk>
	 <20090306181302X.fujita.tomonori@lab.ntt.co.jp>
	 <20090306092114.GS11787@kernel.dk>
	 <20090306182705P.fujita.tomonori@lab.ntt.co.jp>
	 <20090306093520.GV11787@kernel.dk>
	 <20090306143856.GT15340@beardog.cca.cpqcorp.net>
	 <da824cf30903061259j4a37ab7cneea308c736da469d@mail.gmail.com>
	 <20090306211832.GV15340@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33057 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752843AbZCFV7U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2009 16:59:20 -0500
In-Reply-To: <20090306211832.GV15340@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cca.cpqcorp.net
Cc: Grant Grundler <grundler@google.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, mike.miller@hp.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, coldwell@redhat.com, hare@novell.com, iss_storagedev@hp.com

On Fri, 2009-03-06 at 15:18 -0600, scameron@beardog.cca.cpqcorp.net
wrote:
> On Fri, Mar 06, 2009 at 12:59:48PM -0800, Grant Grundler wrote:
> > On Fri, Mar 6, 2009 at 6:38 AM,  <scameron@beardog.cca.cpqcorp.net> wrote:
> > ...
> > > The command buffers have to be in the first 4GB of memory, as the command
> > > register is only 32 bits, so they are allocated by pci_alloc_consistent.
> > 
> > Huh?!!
> > ISTR the mpt2sas driver is indicating it can handle 64-bit DMA masks for
> > both streaming and control data. I need to double check to be sure of that.
> 
> it is something specific to smart array.  The command register that we
> stuff the bus address of the command into is only 32 bits wide.  Everything
> else it does is 64 bits.
> > 
> > 
> > > However, the chained SG lists don't have that limitation, so I think they
> > > can be kmalloc'ed, and so not chew up and unreasonable amount of the
> > > pci_alloc_consistent memory and get a larger number of SGs.   ...right?
> > > Maybe that's the better way to do it.
> > 
> > I thought the driver was tracking this and using the appropriate construct
> > based on which DMA mask is in effect.
> 
> The DMA mask is insufficiently expressive to describe the limitations and
> capabilities of the Smart array.  There's no way to describe with a single
> DMA mask that the command register is 32-bits, but everything else is 64
> bits.

Actually, there is ... it's what you're doing: use a coherent mask of 32
bits and a dma mask of 64bits.

The aic79xx has exactly the same problem (its internal sequencer only
has a 32 bit wide programme counter, so it can only execute sequencer
scripts if they're in the first 4GB of memory).  I think it's fairly
common amongst intelligent controllers that are old enough to have been
32 bit only but which got extended to work on 64 bits.

To get ordinary memory for this, you just use GFP_DMA32 as has been
previously stated.

James


