From: Andries Brouwer <Andries.Brouwer@cwi.nl>
Subject: Re: [usb-storage] Time to allow MODE SENSE for USB disk-type storage devices?
Date: Wed, 10 Mar 2004 10:13:12 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040310091312.GA25632@apps.cwi.nl>
References: <Pine.LNX.4.44L0.0403081046190.1187-100000@ida.rowland.org> <20040308201328.GA13708@apps.cwi.nl> <20040309174353.A15780@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:9112 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S261698AbUCJJNZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2004 04:13:25 -0500
Content-Disposition: inline
In-Reply-To: <20040309174353.A15780@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Andries Brouwer <Andries.Brouwer@cwi.nl>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, Mar 09, 2004 at 05:43:53PM -0800, Patrick Mansfield wrote:

> Andries or others -
> 
> Can you elaborate on this comment in sd.c? Do you have a device that hangs
> with the current kernel when asking for more than 4 bytes here? Is it USB
> storage?
> 
> 	/*
> 	 * First attempt: ask for all pages (0x3F), but only 4 bytes.
> 	 * We have to start carefully: some devices hang if we ask
> 	 * for more than is available.
> 	 */
> 	res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 4, &data);
> 
> Per this changeset:
> 
> http://linux.bkbits.net:8080/linux-2.5/diffs/drivers/scsi/sd.c@1.53?nav=index.html|src/|src/drivers|src/drivers/scsi|hist/drivers/scsi/sd.c
> 
> -- Patrick Mansfield

Yes, I changed this code twice, I think, each time because I acquired
a USB device that did not work. The state that I left things in
was carefully crafted in such a way that each of my half a dozen or so
USB card reader devices worked. In the meantime I got a few more readers,
and they all worked (late 2.5).

Of course there is no particular interest in my selection of devices,
and no reason to expect that code exists that works on everything
on the market.

An oft repeated maxim is: do as Windows does - and that may be
a good idea. On the other hand, half of my devices come with their
own drivers, and also fail under Windows without their own driver.

The conclusion is that yes, if you change something here then
almost certainly there will be devices that are broken by the
change, but the change may still be an improvement if there
are more devices that were broken and now function.

Andries
