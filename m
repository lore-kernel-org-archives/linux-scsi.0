From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Fri, 13 Dec 2002 16:32:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <77130000.1039822376@aslan.btc.adaptec.com>
References: <1266570000.1039619906@aslan.scsiguy.com>
 <20021211153935.A23704@infradead.org>
 <1221760000.1039627865@aslan.btc.adaptec.com>
 <20021211181745.A30253@infradead.org> <20021212202052.GC8842@redhat.com>
 <20021213210215.A15074@infradead.org> <20021213212352.GA10883@redhat.com>
 <20021213215113.A16528@infradead.org> <20021213225225.GB10883@redhat.com>
 <59730000.1039820896@aslan.btc.adaptec.com>
 <20021213232013.GF10883@redhat.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021213232013.GF10883@redhat.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

>> If the new driver is loaded second, you'll wind up with a config
>> space COMMAND register with both IO space and MEM space disabled.
>> The reason for this was to ensure that the aic7xxx controller was
>> not responding to a memory or I/O port already requested for a
>> *different device*.
> 
> Two PCI devices sharing the same I/O or Mem space either one is invalid.

Sure.  But I've seen BIOSes that screw this up before, especially if
you have more devices in the system then you have I/O space to map them
all.  This becomes even more important in a PCI hot-plug environment.
I dont' want to reserve regions that I'm not going to use because that
resource space might be vital for some future hot-plug device.  The fact
that the BIOSes allocate all regions is a holdover from when OSes were
not PCI PNP capable.

>> In the other load order, the driver only reserves the region type it is
>> using.
> 
> Which I think is technically wrong IMHO.  Whether you use the I/O space or
> not, it's been allocated to you by the BIOS/PCI subsystem.  If you can't
> have control over an area allocated to you then there is a bogon hiding
> somewhere in the woodpile.

There are lots of PCI devices that have extra bars that a driver may or
may not choose to use.  In some cases, the memory regions supported by
those bars are *huge* but only one bar need be active at a time.  On some
devices it may be safe to allocate and just not use all BARs on the card,
but I don't think that it applies to all devices.  I would rather the PCI
subsystem defer to the device driver to tell it which regions are required
rather than attempt to allocate them all upfront and exhaust what is
a limited pool of resources.

--
Justin

