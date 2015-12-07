From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH v2 77/71] ncr5380: Fix wait for 53C80 registers registers after PDMA
Date: Mon, 7 Dec 2015 09:08:25 +0100
Message-ID: <201512070908.26036.linux@rainbow-software.org>
References: <20151118083455.331768508@telegraphics.com.au> <1449443866-27296-1-git-send-email-linux@rainbow-software.org> <alpine.LNX.2.00.1512071359180.16204@nippy.intranet>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1512071359180.16204@nippy.intranet>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Monday 07 December 2015 04:16:14 Finn Thain wrote:
> 
> On Mon, 7 Dec 2015, Ondrej Zary wrote:
> 
> > The check for 53C80 registers accessibility was commented out because
> > it was broken (inverted). Fix and enable it.
> > 
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> > ---
> >  drivers/scsi/g_NCR5380.c |   37 ++++++-------------------------------
> >  1 file changed, 6 insertions(+), 31 deletions(-)
> > 
> > diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> > index 038dddf..a7479c6 100644
> > --- a/drivers/scsi/g_NCR5380.c
> > +++ b/drivers/scsi/g_NCR5380.c
> > @@ -603,14 +603,10 @@ static inline int NCR5380_pread(struct Scsi_Host *instance, unsigned char *dst,
> >  	if (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ))
> >  		printk("53C400r: no 53C80 gated irq after transfer");
> >  
> > -#if 0
> > -	/*
> > -	 *	DON'T DO THIS - THEY NEVER ARRIVE!
> > -	 */
> > -	printk("53C400r: Waiting for 53C80 registers\n");
> > -	while (NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG)
> > +	/* wait for 53C80 registers to be available */
> > +	while (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG))
> >  		;
> 
> In the previous patch, udelay(4) was added to a CSR_GATED_53C80_IRQ 
> polling loop. It is interesting that you don't need it here when polling 
> CSR_53C80_REG.

Yes, it's weird. Reads work fine without the delay. Small writes work most of
the time without the delay but crash sometimes. Large writes crash the chip
consistently without the delay.

> > -#endif
> > +
> >  	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_END_DMA_TRANSFER))
> >  		printk(KERN_ERR "53C400r: no end dma signal\n");
> >  		
> > @@ -632,7 +628,6 @@ static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src,
> >  	struct NCR5380_hostdata *hostdata = shost_priv(instance);
> >  	int blocks = len / 128;
> >  	int start = 0;
> > -	int i;
> >  
> >  	NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
> >  	NCR5380_write(hostdata->c400_blk_cnt, blocks);
> > @@ -681,36 +676,16 @@ static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src,
> >  		blocks--;
> >  	}
> >  
> > -#if 0
> > -	printk("53C400w: waiting for registers to be available\n");
> > -	THEY NEVER DO ! while (NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG);
> > -	printk("53C400w: Got em\n");
> > -#endif
> > -
> > -	/* Let's wait for this instead - could be ugly */
> > -	/* All documentation says to check for this. Maybe my hardware is too
> > -	 * fast. Waiting for it seems to work fine! KLL
> > -	 */
> > -	while (!(i = NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ)) {
> > +	/* wait for 53C80 registers to be available */
> > +	while (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG)) {
> >  		udelay(4); /* DTC436 chip hangs without this */
> 
> ... based on the above, this udelay is probably not needed.
> 
> (Or perhaps it is only needed once, in between the final host_buf register 
> access and the first ctl_status access??)

I guess that the delay is needed when the chip does write in the background.
But why only on the last block?
Adding delays inside the while(1) loop does not help, it crashes anyway.
Single delay before the first ctl_status does not help either (perhaps only
if it's long enough for the write to complete).

The chip also crashes in transfer_pio during bigger transfers in a similar
way. With Quantum HDD, it did not crash once I got PDMA working.
But with a faster IBM HDD, it crashes even with smaller PIO trasnfers.

> Is there any reference in the docs to timing sensitivity?

Haven't found anything in NCR docs. Unfortunately, we don't have any DTC
docs.

> >  		/* FIXME - no timeout */
> >  	}
> >  
> > -	/*
> > -	 * I know. i is certainly != 0 here but the loop is new. See previous
> > -	 * comment.
> > -	 */
> 
> Thanks for cleaning up this mess!
> 


-- 
Ondrej Zary
