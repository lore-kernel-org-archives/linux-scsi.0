From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Fri, 13 Dec 2002 16:08:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <59730000.1039820896@aslan.btc.adaptec.com>
References: <200212101602.gBAG2Hi02930@localhost.localdomain>
 <20021211135855.A19325@infradead.org>
 <1266570000.1039619906@aslan.scsiguy.com>
 <20021211153935.A23704@infradead.org>
 <1221760000.1039627865@aslan.btc.adaptec.com>
 <20021211181745.A30253@infradead.org> <20021212202052.GC8842@redhat.com>
 <20021213210215.A15074@infradead.org> <20021213212352.GA10883@redhat.com>
 <20021213215113.A16528@infradead.org> <20021213225225.GB10883@redhat.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021213225225.GB10883@redhat.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

> On Fri, Dec 13, 2002 at 09:51:13PM +0000, Christoph Hellwig wrote:
>> On Fri, Dec 13, 2002 at 04:23:52PM -0500, Doug Ledford wrote:
>> > Hmmm...what's the failure mode here?
>> 
>> It complains that it can't reserve the mem regions but still continues to
>> setup, download sequencer code, and even register scsi3ff.
> 
> Hmmm...are you loading mine or Justin's driver first?  Mine should bail, 
> not continue, when it can't reserve the requested region.

If the new driver is loaded second, you'll wind up with a config
space COMMAND register with both IO space and MEM space disabled.
The reason for this was to ensure that the aic7xxx controller was
not responding to a memory or I/O port already requested for a
*different device*.  I wasn't thinking about a *different driver*
accessing the same device.  There are other PCI api functions
that are called prior to the region check too (set powerstate, enable
device, set dma mask, etc.).  I just don't know how safe you can
really make it unless the old driver uses the PCI registration API.
The new driver will fail though if *both* its memory and port addresses
cannot be mapped.

In the other load order, the driver only reserves the region type it is
using.
The other region is simply disabled in the COMMAND register.  This is
probably why things are failing.  One driver is using mem I/O.  The other
is using PIO.

--
Justin
