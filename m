From: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: [RFC][PATCH] move dma_mask into struct device
Date: Sat, 16 Nov 2002 12:01:59 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <200211161701.gAGH1xF03711@localhost.localdomain>
References: <arndb@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: Message from Arnd Bergmann <arndb@de.ibm.com>
   of "Sat, 16 Nov 2002 19:26:52 +0100." <200211161926.52092.arndb@de.ibm.com>
To: Arnd Bergmann <ibm.com@arndb.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux Scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

arndb@de.ibm.com said:
> On my s390 system, I can have many thousand devices and none of them
> is doing DMA, so I would indeed call it architecture specific. Note
> that  even in a normal PC system, most devices (e.g. CPUs, input
> devices or the disks attached to the host adapter) don't have any
> concept of DMA. 

DMA itself is pervasive to almost every architecture, that's why we have the 
DMA API.  That some devices don't do DMA, I agree with (the struct scsi_device 
is another example).  However, in order to divorce DMA from the PCI bus, it 
has to be obtainable from the generic device, without requiring knowledge of 
the bus.  In OO terms, it would be in a dmaable_device which inherits from 
device, but for expediency in layering all this into the kernel means I'd have 
to break almost every driver and introduce them to the concept of 
dmaable_device, so it's just easier to expand device by a pointer.

James
