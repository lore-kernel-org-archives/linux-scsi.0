From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 0/2] convert libsas to the libata new eh
Date: Wed, 26 Jan 2011 12:55:49 -0500
Message-ID: <1296064549.4893.75.camel@mulgrave.site>
References: <1295797260.3007.118.camel@mulgrave.site>
	 <4D3F1CC6.5080208@linux.vnet.ibm.com>
	 <1296050931.4893.9.camel@mulgrave.site>  <4D405E06.5020400@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40248 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706Ab1AZRz5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Jan 2011 12:55:57 -0500
In-Reply-To: <4D405E06.5020400@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Brian King <brking@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, Robert Jennings <rcj@linux.vnet.ibm.com>, Wayne Boyer <wayneb@linux.vnet.ibm.com>

On Wed, 2011-01-26 at 12:46 -0500, Jeff Garzik wrote:
> On 01/26/2011 09:08 AM, James Bottomley wrote:
> > I think better might be to move the eh thread functionality into block.
> > What libata really wants is one eh thread per phy.  It gets this by
> [...]
> > machinery, everyone should get what they want, and libata could dispense
> > with its current corruption of multiple SCSI hosts per physical bus
> > attachment.
> 
> That's not the whole picture.  libata originally chose one-host-per-port 
> because that winds up being the best queueing/queue-busy arrangement for 
> legacy IDE ports.

Right, but we count things at the lun, the target and the host.  For a
two level queue setup, you could use the target.

>   They behave quite similarly to independent 
> controllers -- even to the point of having separate irqs -- even though 
> multiple IDE ports are shoehorned into a single PCI device.

So interrupts don't really have much to do with the host, that's all
part of driver setup.  IDE is really just using the two lines as a
simple completion signal ... much like the current multi queue cards do
(which also have multiple interrupts per host).

James


