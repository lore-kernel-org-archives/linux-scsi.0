From: Arnd Bergmann <arndb@de.ibm.com>
Subject: Re: [RFC][PATCH] move dma_mask into struct device
Date: Sat, 16 Nov 2002 21:46:46 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211162145.44304.arndb@de.ibm.com>
References: <200211161812.gAGICj604696@localhost.localdomain>
Reply-To: Arnd Bergmann <ibm.com@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200211161812.gAGICj604696@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux Scsi <linux-scsi@vger.kernel.org>

On Saturday 16 November 2002 19:12, J.E.J. Bottomley wrote:

> No...look at what you've done.  Now SCSI has to know about every bus type
> on every architecture; that's an extreme layering violation. 
> architecture/bus types are generally only defined for the arch (PCI being
> the exception), so now the additions have to be #ifdef'd just so it will
> compile..

Right, the definitions for how to get the dma_mask out of a bus specific
device don't belong into the generic header file.
Still, each host driver knows how to find the dma_mask if any, so
it can easily set the field in the Scsi_Host. Existing pci host
adapter drivers can keep using scsi_set_pci_device(), others
can just as well do it themselves.

	Arnd <><
