From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 4/6] g_NCR5380: Add IRQ auto-configuration for HP C2502
Date: Fri, 4 Nov 2016 14:00:46 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1611041357230.709@nippy.intranet>
References: <1477945112-25659-1-git-send-email-linux@rainbow-software.org> <201611020929.22464.linux@rainbow-software.org> <alpine.LNX.2.00.1611022056450.12392@nippy.intranet> <201611030900.56371.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:54332 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932829AbcKDDAj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Nov 2016 23:00:39 -0400
In-Reply-To: <201611030900.56371.linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


On Thu, 3 Nov 2016, Ondrej Zary wrote:

> On Thursday 03 November 2016, Finn Thain wrote:
> > On Wed, 2 Nov 2016, Ondrej Zary wrote:
> > > 
> > > The card is almost Plug&Play. The base address is already configured 
> > > automatically by the driver so doing the same for IRQ makes sense.
> >
> > Why don't we see any other drivers doing this?
> 
> Many ISA sound card drivers do this - there's even a function for this: 
> static int snd_legacy_find_free_irq(int *irq_table)

Well, if snd_legacy_find_free_irq() is good enough for the ALSA 
maintainers, it is good enough for me.

But I still don't like this patch. I would prefer to cut-and-paste 
snd_legacy_find_free_irq() as g_NCR5380_find_free_irq(), and 
snd_legacy_empty_irq_handler() as g_NCR5380_empty_irq_handler(), to allow 
for refactoring all that into a common header file later on.

When the user asks for board == BOARD_HP_C2502 and irq == IRQ_AUTO, just 
use the first result from g_NCR5380_find_free_irq() to program the card. 
If no irq is free, program the card for irq 0.

Then just proceed with the usual IRQ_AUTO probing, like you would for any 
other board. That way, there is no need for NCR5380_test_irq() at all, and 
you can drop patch 2/5 (at least until we figure out why a command timeout 
during modprobe hangs your system).

-- 
