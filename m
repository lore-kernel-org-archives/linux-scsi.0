From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 0/4] Fastboot revisited: Asynchronous function calls
Date: Sun, 4 Jan 2009 21:44:38 +0000
Message-ID: <20090104214438.196ff4ff@lxorguk.ukuu.org.uk>
References: <20090104092430.7ffd2c41@infradead.org>
	<alpine.LFD.2.00.0901041009060.3179@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901041009060.3179@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

> I _think_ it's the irq auto-probing, but that's just a guess. The 8250 
> driver does some historical crud, like
> 
> 	probe_irq_off(probe_irq_on());
> 
> to get rid of any pending irq's, but that should be entirely pointless 
> these days. I bet that line basically goes back to pre-history, before we 
> made the auto-probing much stabler.

For non ISA boxes we shouldn't be - but this old code. The IRQ for the
built in ports is defined by convention, in the BIOS PnP tables or with
ACPI in the ACPI tables. So we shouldn't even be autoprobing the IRQ.

We *do* have to wait one transmission timeout or so to detect buggy uarts
but in theory that could be moved down into the open path.

Alan

