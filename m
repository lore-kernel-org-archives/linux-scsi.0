From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
Date: Tue, 3 Mar 2009 15:35:26 +0900
Message-ID: <20090303153402A.fujita.tomonori@lab.ntt.co.jp>
References: <20090302145650.GW15340@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:47835 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbZCCGkI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Mar 2009 01:40:08 -0500
In-Reply-To: <20090302145650.GW15340@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cca.cpqcorp.net
Cc: linux-kernel@vger.kernel.org, mike.miller@hp.com, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, coldwell@redhat.com, hare@novell.com, iss_storagedev@hp.com

On Mon, 2 Mar 2009 08:56:50 -0600
scameron@beardog.cca.cpqcorp.net wrote:

> [...]
> > > +     .this_id                = -1,
> > > +     .sg_tablesize           = MAXSGENTRIES,
> > 
> > MAXSGENTRIES (32) is the limitation of hardware? If not, it might be
> > better to enlarge this for better performance?
> 
> Yes, definitely, though this value varies from controller to controller,
> so this is just a default value that needs to be overridden, probably
> in hpsa_scsi_detect().

I see. If we override this in hpsa_scsi_detect(), we need a trick for
SG in CommandList_struct, I guess.


> [...]
> > > +     .cmd_per_lun            = 512,
> > > +     .use_clustering         = DISABLE_CLUSTERING,
> > 
> > Why can we use ENABLE_CLUSTERING here? We would get the better
> > performance with ENABLE_CLUSTERING.
> 
> Yes, we should do that.  BTW, the comments in include/linux/scsi_host.h
> don't do a very good job of describing exactly what use_clustering is for,
> they say:
>         /*
>          * True if this host adapter can make good use of clustering.
>          * I originally thought that if the tablesize was large that it
>          * was a waste of CPU cycles to prepare a cluster list, but
>          * it works out that the Buslogic is faster if you use a smaller
>          * number of segments (i.e. use clustering).  I guess it is
>          * inefficient.
>          */
> 
> It never actually tells you what is meant by "clustering"

Yeah, looks like it needs a fix.


> > > +     use_sg = scsi_dma_map(cmd);
> > >  +     if (!use_sg)
> > > +             goto sglist_finished;
> > 
> > We need to handle dma mapping failure here; scsi_dma_map could fail.
> 
> Grepping around a bit in drivers scsi I see some drivers do this:
> 
> 	SCpnt->result = DID_ERROR << 16;
> 	
> 	then call the scsi done function,
> 
> some drivers call BUG_ON() when scsi_dma_map() returns -1,
> and some do nothing.

These drivers are bad. Well, in ancient times dma_map_sg never failed
on X86. So BUG_ON or ignoring is acceptable for drivers for ancient
systems.

But nowadays dma_map_sg can fail (e.g. with Intel VT-D IOMMU).


> I'm guessing setting result = DID_ERROR << 16 and calling
> the done function is the way to go, right? 

Not. It's a temporary error, kinda out-of-memory. So we want to retry.
returning SCSI_MLQUEUE_HOST_BUSY is appropriate here.


> > We really need this? Creating something under /proc is not good. Using
> > /sys/class/scsi_host/ is the proper way. If we remove the overlap
> > between hpsa and cciss, we can do the proper way, I think.
> 
> We can take it out.  We figured we'd take it out when
> someone complained, which we figured would probably
> happen pretty much immediately.

I see, please drop this. This is an issue that we need to take care
about before mainline merging.


> > > + * For operations that cannot sleep, a command block is allocated at init,
> > > + * and managed by cmd_alloc() and cmd_free() using a simple bitmap to track
> > > + * which ones are free or in use.  Lock must be held when calling this.
> > > + * cmd_free() is the complement.
> > > + */
> > > +static struct CommandList_struct *cmd_alloc(struct ctlr_info *h)
> > > +{
> > > +     struct CommandList_struct *c;
> > > +     int i;
> > > +     union u64bit temp64;
> > > +     dma_addr_t cmd_dma_handle, err_dma_handle;
> > > +
> > > +     do {
> > > +             i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
> > > +             if (i == h->nr_cmds)
> > > +                     return NULL;
> > > +     } while (test_and_set_bit
> > > +              (i & (BITS_PER_LONG - 1),
> > > +               h->cmd_pool_bits + (i / BITS_PER_LONG)) != 0);
> > 
> > Using bitmap to manage free commands looks too complicated a bit to
> > me. Can we just use lists for command management?
> 
> Hmm, this doesn't seem all that complicated to me, and this code snippet
> has been pretty stable for about 10 years. it's nearly identical to what's in
> cpqarray in the 2.2.13 kernel from 1999:
> 
>                 do {
>                         i = find_first_zero_bit(h->cmd_pool_bits, NR_CMDS);
>                         if (i == NR_CMDS)
>                                 return NULL;
>                 } while(test_and_set_bit(i%32, h->cmd_pool_bits+(i/32)) != 0)
> 
> It's fast, works well, and has needed very little maintenance over the 
> years.  Without knowing what you have in mind specifically, I don't see a
> big need to change this.

I see. Seems that some drivers want something similar. I might come
back later on with a patch to replace this with library
functions.
