From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 2/6] g_NCR5380: Test the IRQ before accepting it
Date: Thu, 3 Nov 2016 13:17:04 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1611031151350.14245@nippy.intranet>
References: <1477945112-25659-1-git-send-email-linux@rainbow-software.org> <1477945112-25659-3-git-send-email-linux@rainbow-software.org> <alpine.LNX.2.00.1611011257130.25806@nippy.intranet> <201611022016.00556.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201611022016.00556.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Wed, 2 Nov 2016, Ondrej Zary wrote:

> On Wednesday 02 November 2016 08:45:26 Finn Thain wrote:
> > On Mon, 31 Oct 2016, Ondrej Zary wrote:
> > > Trigger an IRQ first with a test IRQ handler to find out if it 
> > > really works. Disable the IRQ if not.
> > >
> > > This prevents hang when incorrect IRQ was specified by user.
> >
> > Once again, how does it cause a hang?
> 
> Kernel scans the bus, finds a HDD, then attempts to read MBR. modprobe 
> process is stuck but the system is still running. Then the transfer 
> probably times out and everything locks up hard, even fbcon cursor stops 
> blinking. I guess that kernel is trying to abort or reset.

I don't think this issue relates to the patch, because the chip irq is not 
needed for exception handling.

A backtrace from the soft lockup detector should help explain this.

> BTW. rescan-scsi-bus also causes hang, anytime, even without IRQ.

I would try "scsi_logging_level -s -a 7" to find out what is going on 
during the bus scan (for modprobe or rescan-scsi-bus).

The polling loops in generic_NCR5380_pread/pwrite can cause a lockup 
because they lack timeouts. Better to call NCR5380_poll_politely, as in 
macscsi_pread/pwrite.

-- 
