From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Fri, 17 Jan 2003 12:49:39 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030117204939.GF1225@beaverton.ibm.com>
References: <10426732153816@kroah.com> <200301171155.36452.oliver@neukum.name> <20030117105414.E359@one-eyed-alien.net> <200301172126.56014.oliver@neukum.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200301172126.56014.oliver@neukum.name>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Oliver Neukum [oliver@neukum.name] wrote:
> 
> > In a separate discussion with Mike, he mentioned that you can't
> > scsi_remove_device() unless there are no pending commands.
> >
> > How the hell is an LLD supposed to assure that!?!?
> >
> > The minute I error a command and call scsi_done(), I can get a new one.
> > Unless I lock out requests with scsi_block_requests(), but that comes with
> > major warnings about needing to get unblocked.
> 
> If I understand the scsi code correctly, doing that will result in a memory
> leak at least. Perhaps exporting a function to declare a host's devices
> offline might do the trick. But as yet I havn't found out where the scsi layer
> actually checks that flag.

It is returned by scsi_block_when_processing_errors (upper level drivers
opens, ioctl, etc). It is checked in scsi_decide_disposition the
scsi_softirq / scsi_done side. It is checked in the command init of the
upper level drivers during scsi_prep_fn.

-andmike
--
Michael Anderson
andmike@us.ibm.com

