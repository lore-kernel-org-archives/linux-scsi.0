From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v6 0/6] g_NCR5380: PDMA fixes and cleanup
Date: Mon, 3 Jul 2017 18:01:03 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1707031033190.1760@nippy.intranet>
References: <cover.1498876618.git.fthain@telegraphics.com.au> <201707012349.04652.linux@rainbow-software.org> <alpine.LNX.2.00.1707021008110.2389@nippy.intranet> <201707021651.37016.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201707021651.37016.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2 Jul 2017, Ondrej Zary wrote:

> On Sunday 02 July 2017 05:11:27 Finn Thain wrote:
> > On Sat, 1 Jul 2017, Ondrej Zary wrote:
> > > The write corruption is still present - "start" must be rolled back 
> > > in both IRQ and timeout cases.
> >
> > Your original algorithm aborts the transfer for a timeout. Same with 
> > mine.
> 
> I do "start -= 2 * 128" even after timeout.
> 

Right. My mistake.

> > The bug must be a elsewhere.
> >
> > > And 128 B is not enough , 256 is OK (why did it work last time?).
> >
> > When I get contradictory results it usually means I booted the wrong 
> > build or built the wrong branch.
> 
> I've just retested PATCHv5, it really misses 128 bytes and works if I 
> add "residual += 128;".
> 
> > Actually, I think that adding 128 to the residual is correct in some 
> > sitations, and 256 is correct in other situations.
> >
> > > We just wrote a buffer to the chip but the chip is writing the 
> > > previous one to the drive - so if a problem arises, both buffers are 
> > > lost.
> >
> > I see. I guess we have to take buffer swaps into account.
> >
> > > This fixes the corruption (although the "start > 0" check seems wrong
> > > now):
> > > --- a/drivers/scsi/g_NCR5380.c
> > > +++ b/drivers/scsi/g_NCR5380.c
> > > @@ -598,23 +598,17 @@ static inline int generic_NCR5380_psend(struct
> > > NCR5380_hostdata *hostdata, CSR_HOST_BUF_NOT_RDY, 0,
> > >  		                           hostdata->c400_ctl_status,
> > >  		                           CSR_GATED_53C80_IRQ,
> > > -		                           CSR_GATED_53C80_IRQ, HZ / 64) < 0)
> > > -                       break;
> > > -
> > > -		if (NCR5380_read(hostdata->c400_ctl_status) &
> > > -		    CSR_HOST_BUF_NOT_RDY) {
> > > +		                           CSR_GATED_53C80_IRQ, HZ / 64) < 0 ||
> > > +		    (NCR5380_read(hostdata->c400_ctl_status) &
> > > +		     (CSR_HOST_BUF_NOT_RDY | CSR_GATED_53C80_IRQ))) {
> >
> > You could add a printk to the timeout branch. If it executes, 
> > something is seriously wrong. E.g.
> >
> > -	break;
> > +	{ pr_err("send timeout %02x, %d/%d\n",
> > NCR5380_read(hostdata->c400_ctl_status), start, len); break; }
> 
> Yes, timeouts do happen:
> [ 9671.909223] send timeout 14, 3840/4096
> [ 9672.978079] send timeout 14, 2816/4096
> [ 9675.323751] send timeout 14, 1280/4096
> 

Interesting that these occur unpredictably at 1.07 and 2.34 seconds apart 
(I'm assuming that these were logged during continuous write activity.)

The 0x14 means CSR_53C80_INTR | CSR_HOST_BUF_NOT_RDY which is normal.

The 'start' values are multiples of 256, not 128, which is curious.

This problem looks like the DTC436 PDMA send problem that required the 512 
byte transfer limit.

Can you make the problem go away by setting sg_tablesize = SG_NONE?

Does this happen with some boards or targets and not others?

The workaround for the DTC436 problem didn't seem to harm performance 
(timeouts will) so we might use the same workaround here. But I am 
concerned that we actually caused this problem by over-estimating the 
residual somehow.

If the residual was too large, the driver would try to send too much data, 
and the scsi target would never drain the scsi buffer, which would lead to 
a CSR_HOST_BUF_NOT_RDY timeout. This may be detectable as data corruption, 
but not necessarily.

Is it possible that a generic_NCR5380_psend() call which terminates due to 
CSR_HOST_BUF_NOT_RDY always follows a generic_NCR5380_psend() call which 
terminated due to CSR_GATED_53C80_IRQ?

Other than that, I've no explanation for the timeout, except maybe device 
erratum.

> > >  			/* The chip has done a 128 B buffer swap but the first
> > >  			 * buffer still has not reached the SCSI bus.
> > >  			 */
> > >  			if (start > 0)
> > > -				start -= 128;
> > > +				start -= 256;
> > >  			break;
> > >  		}
> >
> > BTW, that change carries the risk of 'start' going negative and the 
> > residual exceeding the length of the original transfer.
> >
> > But I agree with you that there's a problem with the residual.
> >
> > If I understand correctly, the 53c400 can't do a buffer swap until the 
> > disk acknowledges each of the 128 bytes from the buffer. But I guess 
> > the first buffer is special because the disk will not see the first 
> > byte of the transfer until after the first buffer swap.
> >
> > And it appears that the last buffer is also special: we have to wait 
> > for CSR_HOST_BUF_NOT_RDY even after start == len otherwise we may not 
> > detect a failure and fix the residual. So I think the datasheet is 
> > right; we have to iterate until the block counter goes to zero.
> >
> > I think it is safe to say that when CSR_HOST_BUF_NOT_RDY, 'start' is 
> > between 128 and 256 B ahead of the disk. Otherwise, the host buffer is 
> > empty and 'start' is no more than 128 B ahead of the disk.
> >
> > > -		if (NCR5380_read(hostdata->c400_ctl_status) &
> > > -		    CSR_GATED_53C80_IRQ)
> > > -			break;
> > > -
> > >  		if (hostdata->io_port && hostdata->io_width == 2)
> > >  			outsw(hostdata->io_port + hostdata->c400_host_buf,
> > >  			      src + start, 64);
> > >
> > >
> > > DTC seems to work too.
> >
> > OK. Thanks for testing. Please try the patch below on top of v6.
> 
> It misses 256B blocks. It's caused by the timeouts, this patch fixes it:
> 
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -598,11 +598,9 @@ static inline int generic_NCR5380_psend(struct NCR5380_hostdata *hostdata,
>  		                           CSR_HOST_BUF_NOT_RDY, 0,
>  		                           hostdata->c400_ctl_status,
>  		                           CSR_GATED_53C80_IRQ,
> -		                           CSR_GATED_53C80_IRQ, HZ / 64) < 0)
> -			break;
> -
> -		if (NCR5380_read(hostdata->c400_ctl_status) &
> -		    CSR_HOST_BUF_NOT_RDY) {
> +		                           CSR_GATED_53C80_IRQ, HZ / 64) < 0 ||
> +		    (NCR5380_read(hostdata->c400_ctl_status) &
> +		     CSR_HOST_BUF_NOT_RDY)) {
>  			/* Both 128 B buffers are in use */
>  			if (start >= 128)
>  				start -= 128;
> 

Thanks for this. I've included this in v7 because even if we fix the 
timeouts during normal operation, we still need this change for timeouts 
in abnormal situations.

-- 
