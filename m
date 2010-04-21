From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 21 Apr 2010 14:08:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1004211356300.1422-100000@iolanthe.rowland.org>
References: <20100421174101.GA6288@xanatos>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <20100421174101.GA6288@xanatos>
Sender: linux-hotplug-owner@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Luben Tuikov <ltuikov@yahoo.com>, Jonas Schwertfeger <jschwertfeger@gmail.com>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, "<linux-scsi@vger.kernel.org>" <linux-scsi@vger.kernel.org>, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>, "<Dinh.Nguyen@freescale.com>" <Dinh.Nguyen@freescale.com>, Mark Lord <mlord@pobox.com>, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, "<linux-hotplug@vger.kernel.org>" <linux-hotplug@vger.kernel.org>, "<linux-usb@vger.kernel.org>" <linux-usb@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 21 Apr 2010, Sarah Sharp wrote:

> > Doug posted to the T10 list and here's what Jim Hatfield from Seagate
> > responded:
> > 
> >      For ATA (SATA or PATA), the Count field should NEVER be zero,
> >      because neither interface supports zero-length data transfer for
> >      any protocol (dma, pio, etc).
> > 
> >      In ATA, 'N/A' is defined the way it is because there are some
> >      ancient implementations for which there are vendor specific
> >      differences.
> 
> So, if Jim is correct, then this may not be a bug in the Buffalo device?
> Or is the phase error in the status of the CSW still an incorrect
> response after a stall on what the device thinks is an invalid command?

Sarah, _please_ forget about the stall!  It's just not relevant.

Yes, a phase error is an incorrect response to an invalid command.  A
correct response would be to return Check Condition status together
with sense data indicating: ILLEGAL REQUEST, Invalid field in CDB.

It's possible the bridge chip might not realize the command is invalid
and would try to carry it out.  If it did so and encountered some kind 
of unrecoverable internal error as a result, then a phase error would 
be the correct response.

Alan Stern

