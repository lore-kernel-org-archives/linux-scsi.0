From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] ipr: Fix HDIO_GET_IDENTITY oops for SATA devices
Date: Mon, 02 Jun 2008 14:35:08 -0500
Message-ID: <1212435308.3369.58.camel@localhost.localdomain>
References: <12124164141515-patch-mail.ibm.com>
	 <48441AEE.6050605@garzik.org>  <48441F82.6060706@linux.vnet.ibm.com>
	 <1212425124.3369.20.camel@localhost.localdomain>
	 <4844312C.7010403@garzik.org>
	 <1212429428.3369.45.camel@localhost.localdomain>
	 <484437C3.8020306@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <484437C3.8020306@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: brking@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, linux-ide@vger.kernel.org, miltonm@bga.com, Tejun Heo <htejun@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2008-06-02 at 14:11 -0400, Jeff Garzik wrote:
> James Bottomley wrote:
> > The quickest way seems to be to break the scsi_host <-> ata_port link by
> > mapping scsi_host <-> ata_host instead.
> 
> Correct for newer controllers... not desirable for older master/slave
> 
> 
> > Legacy controllers with only a
> > single port can keep the apparent 1:1 mapping (we can even keep the
> > hostdata stuff).
> 
> Not sure what you mean by this

I think it's possible to do the shift while still making it look to
single port hosts that nothing has changed

> > Unfortunately, the standard way of doing this is via
> > the transport classes, but as long as you have a pointer from the port
> > to the host and from the device to the port (which you do) it should be
> > possible.
> 
> I've always been open to an ATA transport class and thought that was the 
> best way to go long term.  But I confess to not knowing the best way to 
> implement that goal in concrete terms.

Perhaps it is best to approach it from what libsas needs, that way the
structures can be made to map to each other.

> > The downside I can see is that qc_defer handling changes non trivially
> > because of this, but there don't seem to be many other issues.
> 
> There are a lot of little details that are easily fixable.
> 
> The main detail is not breaking queueing for master/slave. 
> Master/slave, if you recall, _requires_ one-shost-per-port because it 
> relies on scsi queueing to handle the balancing between master/slave. 
> We set can_queue to 1, and for the 2-device case -- master and slave 
> present -- SCSI does the heavy lifting to ensure proper arbitration.

Well, we can be elastic on this.  The common case is a two port
master/slave, isn't it.  This particular one could just be treated as
two separate interfaces and hence two hosts (it's reasonably analagous
to the 53c896---which is a single chip that presents two SCSI channels
as two PCI functions).

> Adding support for NCQ and qc_defer made it a bit easier to change the 
> master/slave setup, though.
> 
> The other reason why we use one-short-per-port on master/slave is that, 
> in many respects, each legacy IDE port really can behave like a 
> completely separate controller, each port with its own interrupts and 
> independent reset logic.
> 
> Thus ATA really has two models:  1-port-1-host and N-ports-1-host.
> 
> [meta:  I'm not disagreeing with you here, just explaining how all this 
> came about...]

OK ... so how bad would it be to maintain two attachment models for the
two cases?  The architect in me says yuk because special casing like
this always leads to complexity, but I can't see a simpler way of doing
it.

James


