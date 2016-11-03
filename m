From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 1/6] NCR5380: Use probe_irq_*() for IRQ probing
Date: Thu, 3 Nov 2016 13:16:42 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1611022056350.12392@nippy.intranet>
References: <1477945112-25659-1-git-send-email-linux@rainbow-software.org> <1477945112-25659-2-git-send-email-linux@rainbow-software.org> <alpine.LNX.2.00.1611011208420.25806@nippy.intranet> <201611020900.31899.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201611020900.31899.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Wed, 2 Nov 2016, Ondrej Zary wrote:

> On Wednesday 02 November 2016, Finn Thain wrote:
> > On Mon, 31 Oct 2016, Ondrej Zary wrote:
> >
> > > +	NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
> > > +	NCR5380_write(OUTPUT_DATA_REG, hostdata->id_mask);
> > > +	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_DATA | ICR_ASSERT_SEL);
> > > + 
> > > +	usleep_range(1000, 20000);
> >
> > Again, msleep(1) would be more appropriate here.
> 
> WARNING: msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt
> #164: FILE: drivers/scsi/g_NCR5380.c:88:
> +       msleep(1);
> 

That link is almost 10 years old. I wonder if it is still accurate.

Anyway, I take it that you chose usleep_range() so as to make the 
checkpatch warning go away. Why not use checkpatch.conf for that, or just 
ignore it? The upper bound for the delay is unimportant and so the warning 
isn't applicable.

Since the lower bound is some unknown number of microseconds, I think 
msleep(1) nicely expresses the two constraints. Whereas, 
usleep_range(1000, 20000) misrepresents them.

We really don't need three significant figures. If you want precision, 
surely you would have to measure the time it takes for the IRQ to fire, 
and derive a worst case (lower bound) from the measurements.

-- 
