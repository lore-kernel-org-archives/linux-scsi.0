From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [linux-usb-devel] Re: /proc/scsi/map
Date: Mon, 17 Jun 2002 07:19:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200206170719.52136.oliver@neukum.name>
References: <200206162314.g5GNEYf03058@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200206162314.g5GNEYf03058@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@steeleye.com>, David Brownell <david-b@pacbell.net>, Andries.Brouwer@cwi.nl, garloff@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, sancho@dauskardt.de, linux-usb-devel@lists.sourceforge.net, linux1394-devel@lists.sourceforge.net, dougg@torque.net

Am Montag, 17. Juni 2002 01:14 schrieb James Bottomley:
> oliver@neukum.name said:
> > But the drivers already know, or would have to be taught to know about
> > it. Somewhence that information has to come. You cannot avoid that
> > effort.
>
> Not necessarily: consider the SCSI WWN, which is supported by most
> modern SCSI devices.  The driver never probes for or asks for this. 
> Nowhere in the current SCSI code do we ask for this.  However user level
> commands (like sg_inq) can formulate the 0x83 page inquiry to get this
> and return the output. This works today with the current driver.

These may be an exception. You usually want to get drivers involved
even if only for synchronisation. Failing to do so has already let to
problems with usb storage.

> > That is wrong. You'd need a common method to determine device type and
> > several methods of passing guid. You are better off in implementing
> > one common way of getting at that information, which shouldn't be too
> > hard, as all the generic layer would have to do is pass up that
> > information.
>
> but the complexity is in the "common method to determine device type and
> several methods of passing guid".  Even for a simple SCSI disk, there's
> no one universal way of getting a unique id (let alone when we add the
> usb devices masquerading as scsi disks into the mix).  That will lead us

That is the point. The driver knows best what kind of devices it works on.
You can forget about the whole identification method business, if you
go for the driver. In case of usb storage and firewire that data is already
sitting there ready for taking. I suspect the same for fibrechannel.

	Regards
		Oliver

