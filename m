From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/4] Fastboot revisited: Asynchronous function calls
Date: Sun, 4 Jan 2009 11:27:08 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901041118390.3179@localhost.localdomain>
References: <20090104092430.7ffd2c41@infradead.org> <alpine.LFD.2.00.0901041009060.3179@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758346AbZADT1T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jan 2009 14:27:19 -0500
In-Reply-To: <alpine.LFD.2.00.0901041009060.3179@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, akpm@linux-foundation.org



On Sun, 4 Jan 2009, Linus Torvalds wrote:
> 
> Ok, so why does the serial port init take so long? That's a quarter of a 
> second for you, which is ridiculous.

Hmm. I also note that you don't seem to have the IDE probing configured in 
at all. It's not _that_ uncommon, afaik, and even if you have no devices 
behind it (or perhaps _especially_ if you have no devices behind it), the 
IDE probe is actually pretty expensive. Hmm?

Also, I'm looking at the AHCI vs Marvell thing, and the problem seems to 
be that you do that libata port scan like this:

        for (i = 0; i < host->n_ports; i++) {
                struct ata_port *ap = host->ports[i];

                async_schedule(async_port_probe, ap);
        }

	async_synchronize_full();
        /* probes are done, now scan each port's disk(s) */
        DPRINTK("host probe begin\n");
        for (i = 0; i < host->n_ports; i++) {
                struct ata_port *ap = host->ports[i];

                ata_scsi_scan_host(ap, 1);
        }

which means that there is a full serialization between each controller.

Wouldn't is be possible to move the "ata_scsi_scan_host(ap, 1);" _into_ 
the async_port_probe(), and just do a

	async_synchronize_cookie(cookie);

before it? Hmm?

And then not do any async_synchronize_full() at all, until much later. For 
example, we clearly do need that full synchronization before we try to 
mount the root filesystem, but we should have that particular 
synchronization regardless of any SATA issues.

I may be missing something obvious, of course. Maybe a simple cookie 
synchronization isn't sufficient for some reason (most likely reason: 
other SCSI drivers that don't do it).

			Linus
