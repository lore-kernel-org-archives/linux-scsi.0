From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
Date: Fri, 6 Mar 2009 09:55:29 +0100
Message-ID: <20090306085529.GP11787@kernel.dk>
References: <20090302145650.GW15340@beardog.cca.cpqcorp.net> <20090303153402A.fujita.tomonori@lab.ntt.co.jp> <20090303162821.GB15340@beardog.cca.cpqcorp.net> <20090305144843N.fujita.tomonori@lab.ntt.co.jp> <20090305142114.GG15340@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:41060 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbZCFIze (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Mar 2009 03:55:34 -0500
Content-Disposition: inline
In-Reply-To: <20090305142114.GG15340@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cca.cpqcorp.net
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, mike.miller@hp.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, coldwell@redhat.com, hare@novell.com, iss_storagedev@hp.com

On Thu, Mar 05 2009, scameron@beardog.cca.cpqcorp.net wrote:
> On Thu, Mar 05, 2009 at 02:48:09PM +0900, FUJITA Tomonori wrote:
> > On Tue, 3 Mar 2009 10:28:21 -0600
> > scameron@beardog.cca.cpqcorp.net wrote:
> > 
> > > On Tue, Mar 03, 2009 at 03:35:26PM +0900, FUJITA Tomonori wrote:
> > > > On Mon, 2 Mar 2009 08:56:50 -0600
> > > > scameron@beardog.cca.cpqcorp.net wrote:
> > > > 
> > > > > [...]
> > > > > > > +     .this_id                = -1,
> > > > > > > +     .sg_tablesize           = MAXSGENTRIES,
> > > > > > 
> > > > > > MAXSGENTRIES (32) is the limitation of hardware? If not, it might be
> > > > > > better to enlarge this for better performance?
> > > > > 
> > > > > Yes, definitely, though this value varies from controller to controller,
> > > > > so this is just a default value that needs to be overridden, probably
> > > > > in hpsa_scsi_detect().
> > > > 
> > > > I see. If we override this in hpsa_scsi_detect(), we need a trick for
> > > > SG in CommandList_struct, I guess.
> > > 
> > > Yes.  There are some limits to what can be put into CommandList_struct
> > > directly, but there is also scatter gather chaining, in which we use
> > > the last element in the CommandList_struct to point to another buffer
> > > of SG entries.
> > > 
> > > If you have a system with a lot of controllers, having a large number of 
> > > scatter gathers can be a bit of a memory hog, and since this memory is all
> > > via pci_alloc_consistent, that can be a concern.  It would be nice if
> > > there was a way for the user to specify differing amounts of scatter
> > > gathers for different controller instances so for instance the controller
> > > which he's running his big oracle database, or webserver or whatever on
> > > gets lots, while the controller he's booted from that's mostly idle
> > > gets not so many.  I don't know what a good way for a user to identify
> > > what controller he's talking about in a module parameter would be 
> > > though.  Maybe by pci domain/bus/device/function?  Maybe something along
> > > the lines of:
> > > 
> > > 	modprobe hpsa dev1=0:0e:00.0 sg1=1000 dev2=0:0b:00.0 sg2=31
> > > 
> > > to say that one controller gets 1000 scatter gather elements, but
> > > another gets only 31.  But PCI busses can change if hardware 
> > > configuration changes, and this isn't exactly obvious, so seems less
> > > than ideal.  Any bright ideas on that front?
> > 
> > We have /sys/class/scsi_host/host*/sg_tablesize:
> > 
> > How about modifying this value on the fly?
> > 
> > fujita@clover:/sys/class/scsi_host/host3$ echo 1000 > sg_tablesize
> > 
> 
> We pci_alloc_consistent that space, so... I think that would mean
> we'd have to do things considerably differently.  I think we'd have
> to quit allocating commands in big chunks, and instead of indexing
> into that chunk we'd probably have to have an array of pointers or
> something.  If we wanted sg_tablesize adjustable down to single
> command counts, we'd probably have to allocate each command separately
> and have an array of pointers to those...
> 
> e.g. if you did 
> 
> 	echo 1000 > sg_tablesize
> 	echo 999 > sg_tablesize
> 
> you probably wouldn't want to keep the 1000 commands around,
> and then allocate 999 additional, then let all the outstanding 
> commands using the first 1000 block complete, then finally free
> the first block of 1000, leaving just the 999.  You'd probably want
> instead to free one of the 1000 to get to 999.
> 
> Likewise with this:
> 
> 	echo 999 > sg_tablesize
> 	echo 1000 > sg_tablesize
> 
> These are somewhat pathological cases, granted.
> 
> I'm not sure dynamically modifying the number of SGs a controller
> can do is something that comes up enough to be worth implementing
> something so complicated.
> 
> If it's settable at init time, that would probably be enough for
> the vast majority of uses (and more flexible than what we have now)
> and a lot easier to implement.

Completely agree, don't waste time implementing something that nobody
will ever touch. The only reason to fiddle with such a setting would be
to increase it, because ios are too small. And even finding out that the
segment limit is the one killing you would take some insight and work
from the user.

Just make it Big Enough to cover most cases. 32 is definitely small, 256
entries would get you 1MB ios which I guess is more appropriate.

-- 
Jens Axboe

