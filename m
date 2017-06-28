From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v3 0/4] g_NCR5380: PDMA fixes and cleanup
Date: Wed, 28 Jun 2017 14:09:47 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1706281209010.1766@nippy.intranet>
References: <cover.1498461406.git.fthain@telegraphics.com.au> <201706262127.03911.linux@rainbow-software.org> <alpine.LNX.2.00.1706270957390.1990@nippy.intranet> <201706272044.42894.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201706272044.42894.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 27 Jun 2017, Ondrej Zary wrote:

> On Tuesday 27 June 2017 03:49:16 Finn Thain wrote:
> >
> > ... As long as there's no gated IRQ, we poll for buffer readiness 
> > until timeout. And when there is a gated IRQ, we break both the 
> > polling loop and the transfer loop immediately. Your code and mine are 
> > basically in agreement here.
> 
> Yes, it stops transfer when an IRQ arrives. But the host buffer could be 
> ready at the same time. The IRQ can be an "end-of-DMA" IRQ (IIRC DTC 
> chips assert this earlier than 53C400). Or just a disconnect that 
> occured right now but the chip already read a buffer full of data.
> 

The IRQ should not normally arise during the loop. A BASR_END_DMA_TRANSFER 
interrupt could only happen after the loop has finished sending/receiving, 
which is when /EOP becomes active.

The BASR_PHASE_MATCH interrupt could happen during the transfer if the 
target disconnects suddenly.

It is possible that the 53c400 core would assert /EOP upon 
BASR_PHASE_MATCH interrupt, which could then cause the 53c80 to raise a 
BASR_END_DMA_TRANSFER interrupt too. But who knows?

> > > According to my tests, buffer ready signal is most important - if 
> > > there is any data to read/write, do the transfer. If not, only then 
> > > check why - maybe we got an IRQ (that terminated PDMA). Or no IRQ, 
> > > sometimes the wait for buffer ready times out - we need to terminate 
> > > PDMA manually then (reset).
> > >
> > > Then 53C80 registers should become ready.
> >
> > You seem to be saying that we should ignore the IRQ signal if the 
> > buffers have become ready. Maybe so. Can we try simply resetting the 
> > block counter? (I could imagine that the 53c400 core might leave the 
> > 53c80 registers inaccessible unless we keep accessing the buffers in 
> > the 53c400 core until the transfer is done.)
> 
> We can't reset the block counter because 0 means 256 blocks to transfer 
> (page 13 in datasheet).

I forgot about that. How awful.

> Yes, the 53C80 registers seem to become available only when the PDMA 
> transfer ends by either:
> 1. transferring all blocks (block counter decrementing to zero)
> 2. IRQ

I don't think that Gated IRQ is sufficient to make the 53c80 registers 
available again. If it was, you probably wouldn't have seen "switching to 
slow handshake" when you tested my earlier patch series.

> 3. reset
> 

Maybe we need to do the reset whenever IRQ is detected. I'll put this in 
v4. Please try commenting it out, to see what difference that makes.

> > BTW, with regard to your patch, note that this construct is race prone:
> >
> > while (1) {	/* monitor IRQ while waiting for host buffer */
> > 	csr = NCR5380_read(hostdata->c400_ctl_status);
> > 	if (!(csr & CSR_HOST_BUF_NOT_RDY))
> > 		break;
> > 	if (csr & CSR_GATED_53C80_IRQ) {
> > 		basr = NCR5380_read(BUS_AND_STATUS_REG);
> > 		if (!(basr & BASR_PHASE_MATCH) ||
> > 			   (basr & BASR_BUSY_ERROR)) {
> > 			printk("basr=0x%02x csr=0x%02x at start=%d\n", basr, csr, start);
> > 			goto out_wait;
> > 		}
> > 	}
> > 	if (retries-- < 1) {
> > 		shost_printk(KERN_ERR, hostdata->host, "53C400r: host buffer not ready in
> > time\n"); NCR5380_write(hostdata->c400_ctl_status, CSR_RESET);
> > 		NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
> > 		goto out_wait;
> > 	}
> > }
> >
> > This code can "goto out_wait" when !(csr & CSR_HOST_BUF_NOT_RDY). It 
> > depends on timing. This would seem to be contrary to your stated aim.
> >
> > Moreover, this code can also "break" when (csr & CSR_GATED_53C80_IRQ). 
> > That depends on timing too. But this may be an improvement on my code 
> > if it allows the 53c80 registers to become accessible, by allowing the 
> > block counter to be decremented.
> 
> Yes, it continue the transfer even if the IRQ is asserted - as long as 
> the buffer is ready. That's intended.
> 

If we continue to try to send when there is a phase mismatch (i.e. sudden 
disconnection) we'll probably end up with a buffer ready timeout. And we 
may also have trouble calculating the residual correctly.

Hence my version of your patch always breaks out of the transfer loop as 
soon as any Gated IRQ is detected. If that then means a compulsory reset 
of the 53c400 core, I guess I can live with that.

> > The uncertainty here was one of the reasons I reworked this code.
> 
> My version reads CSR only once per loop but that probably does not help 
> at all as the HW state could change anytime. The chip's design seems to 
> be very race-prone.
> 
> > > This is a log from writing 230 MB file using my code with some debug 
> > > prints, on a NCR53C400. No 53C80 timeouts, only disconnects and some 
> > > host buffer timeouts (maybe the drive sometimes just slows down 
> > > without disconnecting?)
> > >
> > > [ 3378.503828] basr=0x10 csr=0xd5 at start=512
> > > [ 3461.257973] w basr=0x10 csr=0x95 at start=3840
> > > [ 3461.838225] w basr=0x10 csr=0x95 at start=3840
> > > [ 3462.683446] w basr=0x10 csr=0x95 at start=3840
> > > [ 3463.416911] w basr=0x10 csr=0x95 at start=3840
> > > [ 3465.117804] scsi host2: 53C400w: host buffer not ready in time
> > > [ 3465.276375] w basr=0x10 csr=0x95 at start=3328
> > > [ 3466.457701] w basr=0x10 csr=0x95 at start=1792
> > > [ 3467.019643] scsi host2: 53C400w: host buffer not ready in time
> > > [ 3467.619058] scsi host2: 53C400w: host buffer not ready in time
> > > [ 3467.799619] w basr=0x10 csr=0x95 at start=3840
> > > [ 3552.123501] w basr=0x10 csr=0x95 at start=2304
> > > [ 3552.771223] w basr=0x10 csr=0x95 at start=1280
> > > [ 3554.556451] w basr=0x10 csr=0x95 at start=2816
> > > [ 3555.229646] w basr=0x10 csr=0x95 at start=1792
> > > [ 3555.630632] scsi host2: 53C400w: host buffer not ready in time
> > > [ 3555.774560] w basr=0x10 csr=0x95 at start=768
> > > [ 3625.541608] w basr=0x10 csr=0x95 at start=3328
> > > [ 3640.099861] w basr=0x10 csr=0x95 at start=1792
> > > [ 3641.442671] w basr=0x10 csr=0x95 at start=2816
> > > [ 3641.865469] w basr=0x10 csr=0x95 at start=768
> > > [ 3642.939223] w basr=0x10 csr=0x95 at start=1280
> > > [ 3643.356858] w basr=0x10 csr=0x95 at start=3328
> > > [ 3643.701636] w basr=0x10 csr=0x95 at start=3840
> > > [ 3645.153405] w basr=0x10 csr=0x95 at start=2304
> > > [ 3646.135642] w basr=0x10 csr=0x95 at start=1280
> > > [ 3647.007321] w basr=0x10 csr=0x95 at start=2816
> > > [ 3648.065874] w basr=0x10 csr=0x95 at start=3328
> > > [ 3650.071961] w basr=0x10 csr=0x95 at start=1280
> > > [ 3650.827630] w basr=0x10 csr=0x95 at start=1792
> > > [ 3651.827011] w basr=0x10 csr=0x95 at start=2816
> > > [ 3652.559984] w basr=0x10 csr=0x95 at start=2816
> > > [ 3653.203566] w basr=0x10 csr=0x95 at start=3328
> > > [ 3653.594376] w basr=0x10 csr=0x95 at start=1280
> > > [ 3653.903437] w basr=0x10 csr=0x95 at start=3840
> > > [ 3654.305753] w basr=0x10 csr=0x95 at start=1792
> > > [ 3654.676009] w basr=0x10 csr=0x95 at start=2304
> > > [ 3655.367686] w basr=0x10 csr=0x95 at start=2816
> > > [ 3655.733854] w basr=0x10 csr=0x95 at start=768
> > > [ 3656.075023] w basr=0x10 csr=0x95 at start=3328
> > > [ 3656.493046] w basr=0x10 csr=0x95 at start=2816
> > > [ 3657.208089] w basr=0x10 csr=0x95 at start=1280
> > > [ 3657.537223] w basr=0x10 csr=0x95 at start=1280
> > >
> > > And this is from reading the file back:
> > > [ 3799.053067] basr=0x10 csr=0xd5 at start=512
> > > [ 3801.056337] basr=0x10 csr=0xd5 at start=3584
> > > [ 3976.323836] scsi host2: 53C400r: host buffer not ready in time
> > > [ 3976.404699] basr=0x10 csr=0xd5 at start=512
> > > [ 3977.800647] basr=0x10 csr=0xd5 at start=512
> > > [ 3979.240611] scsi host2: 53C400r: host buffer not ready in time
> > > [ 3979.320698] basr=0x10 csr=0xd5 at start=512
> > > [ 3980.040220] scsi host2: 53C400r: host buffer not ready in time
> > > [ 3980.096401] basr=0x10 csr=0xd5 at start=512
> > > [ 3980.394854] scsi host2: 53C400r: host buffer not ready in time
> >
> > The register values look normal (?)
> >
> > Anyway, there are only a few material differences between your code 
> > and this patch series.
> >
> > 1) Your code does not break the transfer loop for any Gated IRQ, but 
> >    only for a phase error IRQ. My version responds to any Gated IRQ, 
> >    as per the algorithm in the datasheet. Your code seems to assume 
> >    that the 53c80 registers are accessible whenever gated IRQ is set, 
> >    which seems unlikely.
> 
> BASR seems to be always readable. Nothing in the datasheet about that 
> but I needed it to determine the IRQ type and it works.
> 

So, the BASR_PHASE_MATCH bit appears to be set... but that doesn't mean 
that the register is actually accessable and valid.

-- 
