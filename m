From: Arnd Bergmann <arndb@de.ibm.com>
Subject: Re: [RFC][PATCH] move dma_mask into struct device
Date: Sat, 16 Nov 2002 20:56:54 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211162056.54008.arndb@de.ibm.com>
References: <200211161701.gAGH1xF03711@localhost.localdomain>
Reply-To: Arnd Bergmann <ibm.com@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200211161701.gAGH1xF03711@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>Linux Kernel <linux-kernel@vger.kernel.org>, Linux Scsi <linux-scsi@vger.kernel.org>Linux Kernel <linux-kernel@vger.kernel.org>Linux Scsi <linux-scsi@vger.kernel.org>, Mike Anderson <andmike@us.ibm.com>

On Saturday 16 November 2002 18:01, J.E.J. Bottomley wrote:

> However, in order to divorce DMA from the
> PCI bus, it has to be obtainable from the generic device, without requiring
> knowledge of the bus.  In OO terms, it would be in a dmaable_device which
> inherits from device, but for expediency in layering all this into the
> kernel means I'd have to break almost every driver and introduce them to
> the concept of
> dmaable_device, so it's just easier to expand device by a pointer.

The Scsi_Host is already derived from struct device and since you need the 
dma_mask only for Scsi_Host, there is no need to expand the base class.

You can easily keep out the pci stuff if you do something like
this:

static inline void scsi_set_device(struct Scsi_Host *shost,
                                   struct device *dev)
{
        shost->dev = dev;
        shost->host_driverfs_dev.parent = dev;
}

static inline void scsi_set_pci_device(struct Scsi_Host *shost,
                                       struct pci_dev *pdev)
{
	scsi_set_device(shost, &pdev->dev);
	shost->dma_mask = pdev->dma_mask;
}

static inline void scsi_set_foobus_device(struct Scsi_Host *shost,
					  struct foo_dev *fdev)
{
	scsi_set_device(shost, fdev->dev);
	shost->dma_mask = fdev->foo_dma_mask;
}

You can even avoid Scsi_Host::dev completely if you make its only
remaining user (scsi_ioctl_get_pci) use host_sysfs_dev->parent.bus_id
instead.

	Arnd <><
