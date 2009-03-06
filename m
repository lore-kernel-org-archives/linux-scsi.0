From: scameron@beardog.cca.cpqcorp.net
Subject: Re: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
Date: Fri, 6 Mar 2009 08:38:56 -0600
Message-ID: <20090306143856.GT15340@beardog.cca.cpqcorp.net>
References: <20090306085529.GP11787@kernel.dk> <20090306181302X.fujita.tomonori@lab.ntt.co.jp> <20090306092114.GS11787@kernel.dk> <20090306182705P.fujita.tomonori@lab.ntt.co.jp> <20090306093520.GV11787@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:8695 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZCFOi5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2009 09:38:57 -0500
Content-Disposition: inline
In-Reply-To: <20090306093520.GV11787@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, mike.miller@hp.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, coldwell@redhat.com, hare@novell.com, iss_storagedev@hp.com

On Fri, Mar 06, 2009 at 10:35:21AM +0100, Jens Axboe wrote:
> On Fri, Mar 06 2009, FUJITA Tomonori wrote:
> > On Fri, 6 Mar 2009 10:21:14 +0100
> > Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > On Fri, Mar 06 2009, FUJITA Tomonori wrote:
> > > > On Fri, 6 Mar 2009 09:55:29 +0100
> > > > Jens Axboe <jens.axboe@oracle.com> wrote:
> > > > 
> > > > > > If it's settable at init time, that would probably be enough for
> > > > > > the vast majority of uses (and more flexible than what we have now)
> > > > > > and a lot easier to implement.
> > > > > 
> > > > > Completely agree, don't waste time implementing something that nobody
> > > > > will ever touch. The only reason to fiddle with such a setting would be
> > > > > to increase it, because ios are too small. And even finding out that the
> > > > > segment limit is the one killing you would take some insight and work
> > > > > from the user.
> > > > > 
> > > > > Just make it Big Enough to cover most cases. 32 is definitely small, 256
> > > > > entries would get you 1MB ios which I guess is more appropriate.
> > > > 
> > > > I guess that the dynamic scheme is overdoing but seems that vendors
> > > > like some way to configure the sg entry size. The new MPT2SAS driver
> > > > has SCSI_MPT2SAS_MAX_SGE kernel config option:
> > > > 
> > > > http://marc.info/?l=linux-scsi&m=123619290803547&w=2
> > > > 
> > > > 
> > > > The kernel module option for this might be appropriate.
> > > 
> > > Dunno, still seems pretty pointless to me. The config option there
> > > quotes memory consumption as the reason to reduce the number of sg
> > > entries, however I think that's pretty silly. Additionally, a kernel
> > > config entry just means that customers will be stuck with a fixed value
> > > anyway. So I just don't see any merit to doing it that way either.
> > 
> > Yeah, agreed. the kernel config option is pretty pointless. But I'm
> > not sure that reducing memory consumption is completely pointless.
> 
> Agree, depends on how you do it. If you preallocate all the memory
> required for 1024 entries times the queue depth, then it may not be that
> small. But you can do it a bit more cleverly than that, and then I don't
> think it makes a lot of sense to provide any options for shrinking it.

The reason I mentioned making the number of SGs configurable is because with
a lot of controllers in the box (say 8, or ridiculous numbers of controllers
are potentially possible on some big ia64 boxes) then the memory available
by way of pci_alloc_consistent can be exhausted, and we have seen that happen.

The command buffers have to be in the first 4GB of memory, as the command
register is only 32 bits, so they are allocated by pci_alloc_consistent.
However, the chained SG lists don't have that limitation, so I think they
can be kmalloc'ed, and so not chew up and unreasonable amount of the
pci_alloc_consistent memory and get a larger number of SGs.   ...right?
Maybe that's the better way to do it.

-- steve
