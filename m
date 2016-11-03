From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 4/6] g_NCR5380: Add IRQ auto-configuration for HP C2502
Date: Thu, 3 Nov 2016 13:17:18 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1611022056450.12392@nippy.intranet>
References: <1477945112-25659-1-git-send-email-linux@rainbow-software.org> <1477945112-25659-5-git-send-email-linux@rainbow-software.org> <alpine.LNX.2.00.1611011258090.25806@nippy.intranet> <201611020929.22464.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201611020929.22464.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Wed, 2 Nov 2016, Ondrej Zary wrote:

> > Also, you've ignored the irq module parameters. From the user's point 
> > of view, surely the least surprising thing is to attempt to configure 
> > the card for whatever irq the user asked for.
> 
> I haven't. NCR5380_find_irq is only called when irq is set to IRQ_AUTO.
> 

My mistake.

> > If the specified irq isn't supported by the board, just log an error 
> > and fail. If you want to be user friendly, print a message to tell 
> > them what irqs the card supports.
> 
> If the IRQ is not supported (or does not work), user gets a warning and 
> the driver continues with IRQ disabled.
> 
> > If the user asks for IRQ_AUTO, just configure the board for a 
> > hard-coded default, say 9, and print a warning message to say so.
> 
> The card is almost Plug&Play. The base address is already configured 
> automatically by the driver so doing the same for IRQ makes sense.

Why don't we see any other drivers doing this?

If the card was really plug and play, I expect we would just call 
pnp_irq(), as the other PNP drivers do.

> 
> > Either way, if request_irq fails just continue with NO_IRQ, as per 
> > usual.
> >
> > To me that's the most flexible and least surprising behaviour. But 
> > again, if someone with more ISA knowledge wishes to weigh in, that's 
> > fine too.

-- 
