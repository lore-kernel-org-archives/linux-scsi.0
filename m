From: scameron@beardog.cca.cpqcorp.net
Subject: Re: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
Date: Mon, 2 Mar 2009 08:56:50 -0600
Message-ID: <20090302145650.GW15340@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:28780 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbZCBO4x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2009 09:56:53 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: mike.miller@hp.com, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, coldwell@redhat.com, hare@novell.com, iss_storagedev@hp.com

FUJITA Tomonori wrote:

[...]
> Do we really need this static array? Allocating struct ctlr_info
> dynamically is fine?

Should be no problem to fix that.

[...]
> > +     .this_id                = -1,
> > +     .sg_tablesize           = MAXSGENTRIES,
> 
> MAXSGENTRIES (32) is the limitation of hardware? If not, it might be
> better to enlarge this for better performance?

Yes, definitely, though this value varies from controller to controller,
so this is just a default value that needs to be overridden, probably
in hpsa_scsi_detect().

[...]
> > +     .cmd_per_lun            = 512,
> > +     .use_clustering         = DISABLE_CLUSTERING,
> 
> Why can we use ENABLE_CLUSTERING here? We would get the better
> performance with ENABLE_CLUSTERING.

Yes, we should do that.  BTW, the comments in include/linux/scsi_host.h
don't do a very good job of describing exactly what use_clustering is for,
they say:
        /*
         * True if this host adapter can make good use of clustering.
         * I originally thought that if the tablesize was large that it
         * was a waste of CPU cycles to prepare a cluster list, but
         * it works out that the Buslogic is faster if you use a smaller
         * number of segments (i.e. use clustering).  I guess it is
         * inefficient.
         */

It never actually tells you what is meant by "clustering"

[...]
> > +static inline void set_bit_in_array(__u8 bitarray[], int bit)
> > +{
> > +     bitarray[bit >> 3] |= (1 << (bit & 0x07));
> > +}
> 
> Can not we use the standard bit operation functions instead?

Yeah, that should be no problem.  I was thinking as I typed that 
code in, "there's probably some way already defined to do this",
meaning to fix it later, but then I forgot to fix it.

[...]
> > +     use_sg = scsi_dma_map(cmd);
> >  +     if (!use_sg)
> > +             goto sglist_finished;
> 
> We need to handle dma mapping failure here; scsi_dma_map could fail.

Grepping around a bit in drivers scsi I see some drivers do this:

	SCpnt->result = DID_ERROR << 16;
	
	then call the scsi done function,

some drivers call BUG_ON() when scsi_dma_map() returns -1,
and some do nothing.

I'm guessing setting result = DID_ERROR << 16 and calling
the done function is the way to go, right? 

[...]
> > +     /* Get the ptr to our adapter structure (hba[i]) out of cmd->host. */
> > +     h = (struct ctlr_info *) cmd->device->host->hostdata[0];
> 
> Let's use shost_priv().

Oh, ok.  I think maybe that didn't exist when I first wrote that code.

[...]
> > +     /* Need a lock as this is being allocated from the pool */
> > +     spin_lock_irqsave(&h->lock, flags);
> > +     cp = cmd_alloc(h);
> > +     spin_unlock_irqrestore(&h->lock, flags);
> > +     if (cp == NULL) {                       /* trouble... */
> 
> We run out of commands here. Returning SCSI_MLQUEUE_HOST_BUSY is
> appropriate here, I think.

Ok.

[...]
> 
> But if we allocate shost->can_queue at startup, we can't run out of
> commands.

Yeah, we shouldn't run out.  That check is kind of paranoia.

[...]
> > +}
> > +#endif                               /* CONFIG_PROC_FS */
> 
> We really need this? Creating something under /proc is not good. Using
> /sys/class/scsi_host/ is the proper way. If we remove the overlap
> between hpsa and cciss, we can do the proper way, I think.

We can take it out.  We figured we'd take it out when
someone complained, which we figured would probably
happen pretty much immediately.

[...]
> > +/*
> > + * For operations that cannot sleep, a command block is allocated at init,
> > + * and managed by cmd_alloc() and cmd_free() using a simple bitmap to track
> > + * which ones are free or in use.  Lock must be held when calling this.
> > + * cmd_free() is the complement.
> > + */
> > +static struct CommandList_struct *cmd_alloc(struct ctlr_info *h)
> > +{
> > +     struct CommandList_struct *c;
> > +     int i;
> > +     union u64bit temp64;
> > +     dma_addr_t cmd_dma_handle, err_dma_handle;
> > +
> > +     do {
> > +             i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
> > +             if (i == h->nr_cmds)
> > +                     return NULL;
> > +     } while (test_and_set_bit
> > +              (i & (BITS_PER_LONG - 1),
> > +               h->cmd_pool_bits + (i / BITS_PER_LONG)) != 0);
> 
> Using bitmap to manage free commands looks too complicated a bit to
> me. Can we just use lists for command management?

Hmm, this doesn't seem all that complicated to me, and this code snippet
has been pretty stable for about 10 years. it's nearly identical to what's in
cpqarray in the 2.2.13 kernel from 1999:

                do {
                        i = find_first_zero_bit(h->cmd_pool_bits, NR_CMDS);
                        if (i == NR_CMDS)
                                return NULL;
                } while(test_and_set_bit(i%32, h->cmd_pool_bits+(i/32)) != 0)

It's fast, works well, and has needed very little maintenance over the 
years.  Without knowing what you have in mind specifically, I don't see a
big need to change this.

-- steve

