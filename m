From: scameron@beardog.cca.cpqcorp.net
Subject: Re: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
Date: Tue, 3 Mar 2009 10:28:21 -0600
Message-ID: <20090303162821.GB15340@beardog.cca.cpqcorp.net>
References: <20090302145650.GW15340@beardog.cca.cpqcorp.net> <20090303153402A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:19392 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbZCCQ2X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Mar 2009 11:28:23 -0500
Content-Disposition: inline
In-Reply-To: <20090303153402A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, mike.miller@hp.com, jens.axboe@oracle.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, coldwell@redhat.com, hare@novell.com, iss_storagedev@hp.com

On Tue, Mar 03, 2009 at 03:35:26PM +0900, FUJITA Tomonori wrote:
> On Mon, 2 Mar 2009 08:56:50 -0600
> scameron@beardog.cca.cpqcorp.net wrote:
> 
> > [...]
> > > > +     .this_id                = -1,
> > > > +     .sg_tablesize           = MAXSGENTRIES,
> > > 
> > > MAXSGENTRIES (32) is the limitation of hardware? If not, it might be
> > > better to enlarge this for better performance?
> > 
> > Yes, definitely, though this value varies from controller to controller,
> > so this is just a default value that needs to be overridden, probably
> > in hpsa_scsi_detect().
> 
> I see. If we override this in hpsa_scsi_detect(), we need a trick for
> SG in CommandList_struct, I guess.

Yes.  There are some limits to what can be put into CommandList_struct
directly, but there is also scatter gather chaining, in which we use
the last element in the CommandList_struct to point to another buffer
of SG entries.

If you have a system with a lot of controllers, having a large number of 
scatter gathers can be a bit of a memory hog, and since this memory is all
via pci_alloc_consistent, that can be a concern.  It would be nice if
there was a way for the user to specify differing amounts of scatter
gathers for different controller instances so for instance the controller
which he's running his big oracle database, or webserver or whatever on
gets lots, while the controller he's booted from that's mostly idle
gets not so many.  I don't know what a good way for a user to identify
what controller he's talking about in a module parameter would be 
though.  Maybe by pci domain/bus/device/function?  Maybe something along
the lines of:

	modprobe hpsa dev1=0:0e:00.0 sg1=1000 dev2=0:0b:00.0 sg2=31

to say that one controller gets 1000 scatter gather elements, but
another gets only 31.  But PCI busses can change if hardware 
configuration changes, and this isn't exactly obvious, so seems less
than ideal.  Any bright ideas on that front?

We have some specialized versions of cciss around that have variable
sized SG arrays in CommandList_struct as well as doing scatter gather
chaining (not to be confused with the scatter gather chaining concept
in the scsi mid layer.)

[...snip...]
> 
> 
> > > > + * For operations that cannot sleep, a command block is allocated at init,
> > > > + * and managed by cmd_alloc() and cmd_free() using a simple bitmap to track
> > > > + * which ones are free or in use.  Lock must be held when calling this.
> > > > + * cmd_free() is the complement.
> > > > + */
> > > > +static struct CommandList_struct *cmd_alloc(struct ctlr_info *h)
> > > > +{
> > > > +     struct CommandList_struct *c;
> > > > +     int i;
> > > > +     union u64bit temp64;
> > > > +     dma_addr_t cmd_dma_handle, err_dma_handle;
> > > > +
> > > > +     do {
> > > > +             i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
> > > > +             if (i == h->nr_cmds)
> > > > +                     return NULL;
> > > > +     } while (test_and_set_bit
> > > > +              (i & (BITS_PER_LONG - 1),
> > > > +               h->cmd_pool_bits + (i / BITS_PER_LONG)) != 0);
> > > 
> > > Using bitmap to manage free commands looks too complicated a bit to
> > > me. Can we just use lists for command management?
> > 
> > Hmm, this doesn't seem all that complicated to me, and this code snippet
> > has been pretty stable for about 10 years. it's nearly identical to what's in
> > cpqarray in the 2.2.13 kernel from 1999:
> > 
> >                 do {
> >                         i = find_first_zero_bit(h->cmd_pool_bits, NR_CMDS);
> >                         if (i == NR_CMDS)
> >                                 return NULL;
> >                 } while(test_and_set_bit(i%32, h->cmd_pool_bits+(i/32)) != 0)
> > 
> > It's fast, works well, and has needed very little maintenance over the 
> > years.  Without knowing what you have in mind specifically, I don't see a
> > big need to change this.
> 
> I see. Seems that some drivers want something similar. I might come
> back later on with a patch to replace this with library
> functions.

There was some other discussion about pushing this sort of thing to 
upper layers, using a tag generated in the scsi layer as a means
of allocating driver command buffers, since, presumably there's a
one to one mapping.  (I didn't completely grok it all though.)

-- steve

