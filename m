From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/4] Fastboot revisited: Asynchronous function calls
Date: Sun, 4 Jan 2009 11:11:53 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901041107590.3179@localhost.localdomain>
References: <20090104092430.7ffd2c41@infradead.org> <alpine.LFD.2.00.0901041009060.3179@localhost.localdomain> <20090104103104.6fdda9f2@infradead.org> <alpine.LFD.2.00.0901041038570.3179@localhost.localdomain> <20090104110559.306186c4@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20090104110559.306186c4@infradead.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org



On Sun, 4 Jan 2009, Arjan van de Ven wrote:
>
> or we declare the irq probing stuff "rare" and just make THAT fully
> serializing....
> do a full synchronization before starting a probe 

Yes. That's entirely possible. However, have you verified that if an async 
thread does a synchronization, it doesn't deadlock? 

> > That said, I also wonder if we really even need to autoprobe the 
> > interrupts on any modern hardware. Rather than trying to speed up irq 
> > probing, maybe we could figure it out some other way.. The only thing
> > that matters on 99% of all machines are the one or two standard ports
> > that normally show up on 2f8h/irq3 and 3f8h/irq4 or something like
> > that. 
> 
> too bad this stuff isn't PCI enumerated.
> but if someone really still maintains this code, it could probably be
> rewritten in a "we think it's likely irq 3. how about we test that. Oh
> no? then we do expensive probing" kind of way.
> 
> Right now I don't think I have time for it (this is going to take time..
> there's so many weird things with serial ports that it's bound to break
> stuff in the beginning etc)

Yeah. The problem is that that driver is used on such varied hardware. But 
we can probably pick it up from PnP/ACPI, and autoprobe only for things 
that don't get the info from there (either because they are not PC's, or 
becuase PnP/ACPI isn't configured in). 

This is one case where I wouldn't be afraid of PnP information, because we 
could easily choose to only trust it if it makes sense (ie "if it's the 
standard 2f8/irq3 thing, then you might as well trust PnP").

		Linus
