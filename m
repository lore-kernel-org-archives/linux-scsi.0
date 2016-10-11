From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] scsi: NCR5380: no longer mark irq probing as __init
Date: Wed, 12 Oct 2016 10:20:33 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1610121004480.20775@nippy.intranet>
References: <20161011092356.2872181-1-arnd@arndb.de> <alpine.LNX.2.00.1610112038160.17850@nippy.intranet> <201610112258.05050.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201610112258.05050.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Tue, 11 Oct 2016, Ondrej Zary wrote:

> 
> I've tested IRQ probing on my IRQ7-hardwired ISA card without any 
> success some time ago. No IRQ was detected because it wasn't even 
> generated (no increment in /proc/interruptts).

The IRQ line does not appear in /proc/interrupts unless it has already 
been claimed. So if you saw that the interrupt count stayed the same, then 
the interrupt line wasn't available in the first place.

> It also produced some warnings in dmesg about conflicting interrupt 
> flags.

Presumably that's because there is no way to probe shared interrupt lines.

> Can't the IRQ probing be simply deleted?
> 

It isn't clear to me that there's a bug in the driver. I never saw a bug 
in the irq probe code when I went looking for a reason to delete that code 
a while ago.

Anyway, assuming that the interrupt line on your card works fine, have you 
considered using probe_irq_on/probe_irq_off? See for example, sym53c416.c 
and NCR53c406a.c.

Bug or no bug, I'd be very happy to delete the NCR5380 probe code if we 
can use the standard probe functions to retain the documented 
functionality.

-- 
