From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Announce] Emulex lpfcdriver v8.0.12 available
Date: Mon, 18 Oct 2004 21:55:36 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041018205536.GA2302@infradead.org>
References: <0B1E13B586976742A7599D71A6AC733C08670D@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:61959 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267301AbUJRUzh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Oct 2004 16:55:37 -0400
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C08670D@xbl3.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: hch@infradead.org, linux-scsi@vger.kernel.org

> - slimreg, ctlrreg, and mbox: 
>  > For slimreg and ctlreg that is true, but I wonder whether 
>  > they're needed at all.  Check how recent X servers access mmio space.
> As mentioned, these should meet your definition and be fine. You asked whether they are needed at all. Given that these are the heart of the adapter message passing interface, and used extensively by the driver - having the user space application use them without the coordination of the driver is asking for trouble. Minimally, the driver's lock over the registers/memory needs to be involved. In some cases, the driver remaps these areas away from pci memory and into driver-allocated dma-mapped memory. The application would have no clue where to locate these.  These should stay as is.  It is through these interfaces that diagnostics, firmware loading, and the like take place.

And why should userspace mess with the adapter anyway?  The older drivers
seem to work very well without that interface.  Also note that due to this
interfasce you added really horrible helper functions in the driver.

> - sendrnid and ctpass:
>  > The sendrnid and ctpass ones looks extremly fishy, it's 
>  > certainly not a single value that's read/written, and it's
>  > deeply magic (and btw, current->pid is not uniqueue in a
>  > multithreaded enviroment)
> These are used to have the application (usually a storage management suite) interact with FC fabrics - performing requests of nameservers, querying for additional node id information, etc. The use is typically to build topology maps of the FC fabric and the devices attached.

If you want this in find a portable and non-broken interface together with
the qlogic, lsi and ibm people.

