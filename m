From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v3 0/4] g_NCR5380: PDMA fixes and cleanup
Date: Wed, 28 Jun 2017 14:10:29 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1706281252530.2609@nippy.intranet>
References: <cover.1498461406.git.fthain@telegraphics.com.au> <201706270828.40336.linux@rainbow-software.org> <alpine.LNX.2.00.1706272205340.25239@nippy.intranet> <201706271806.05004.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201706271806.05004.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 27 Jun 2017, Ondrej Zary wrote:

> On Tuesday 27 June 2017 14:42:29 Finn Thain wrote:
> 
> > > ... it triggers sometimes: the value is 1 instead of 0. As we use 
> > > only 16-bit writes, I don't see how the value could ever be odd. 
> > > Looks like a bug in the chip. The index register corrupts during the 
> > > transfer, not after IRQ or timeout. The same check at beginning of 
> > > pwrite() did not trigger.
> >
> > Are you reading this register at the right moment? Have you tried 
> > waiting for it to reach zero, as in,
> >
> > 	if (NCR5380_poll_politely(hostdata, 13, 0xff, 0, HZ / 64) < 0)
> > 		/* printk, reset etc */;
> 
> I have not but will try (expecting that it will not change by itself).
> 

Now that I know that it is the byte at the beginning of the block that 
went missing, I agree that there's no point waiting for the byte count to 
change.

I've included a patch with your 512 B limit in v4.

Thanks.

> > Even if this is a reliable way to detect a short transfer, it would be 
> > nice to know the root cause. But I'm being unrealistic: the DTC436 
> > vendor never responded to my requests for technical documentation.
> 
> According to the data corruption observed, it's not a short transfer. 
> The corruption is always the same: one byte missing at the beginning of 
> a 128 B block. It happens only with slow Quantum LPS 240 drive, not with 
> faster IBM DORS-32160.
> 

-- 
