From: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: [RFC][PATCH] move dma_mask into struct device
Date: Sat, 16 Nov 2002 13:12:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211161812.gAGICj604696@localhost.localdomain>
References: <arndb@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id KAA18080
	for <linux-scsi@vger.kernel.org>; Sat, 16 Nov 2002 10:12:47 -0800
In-Reply-To: Message from Arnd Bergmann <arndb@de.ibm.com>
   of "Sat, 16 Nov 2002 20:56:54 +0100." <200211162056.54008.arndb@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <ibm.com@arndb.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux Scsi <linux-scsi@vger.kernel.org>

arndb@de.ibm.com said:
> You can easily keep out the pci stuff if you do something like this: 

No...look at what you've done.  Now SCSI has to know about every bus type on 
every architecture; that's an extreme layering violation.  architecture/bus 
types are generally only defined for the arch (PCI being the exception), so 
now the additions have to be #ifdef'd just so it will compile..

You've done this because you effectively have to pull a common but differently 
located structure element out of each of these bus specific devices.  That 
implies to me that dma_mask should be in a common structure, which was the 
whole basis for the dmaable_device that I outlined previously.  As I said, the 
only reason I haven't implemented dmaable_device is for expediency.

James


