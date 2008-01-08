From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC] Implementation of SCSI dynamic power management
Date: Mon, 7 Jan 2008 22:56:03 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0801072235110.30331-100000@netrider.rowland.org>
References: <200801072306.56227.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:1542 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753748AbYAHD4G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jan 2008 22:56:06 -0500
In-Reply-To: <200801072306.56227.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>

On Mon, 7 Jan 2008, Oliver Neukum wrote:

> Am Montag, 7. Januar 2008 22:34:52 schrieb Alan Stern:
> > On Mon, 7 Jan 2008, Oliver Neukum wrote:
> > 
> > > Am Montag, 7. Januar 2008 20:42:23 schrieb Alan Stern:
> > > > When all the devices under a host are suspended, the LLD is informed 
> > > > (via a new "autosuspend" method in the host template) so that it can
> > > 
> > > That is most certainly a mistake.
> > 
> > Why?
> 
> You'll have to add this method whenever a new subsystem is affected
> by power management.

Sorry, I don't understand your point.  If you mean that we'll have to
add autosuspend and autoresume code to every driver that wants to
support autosuspend, I agree.  There doesn't seem to be any way around
it.  Note that the code added by the companion usb-storage patch is 
pretty small.

> Besides what are the semantics of this method?

The semantics are simple.  The SCSI midlayer calls the autosuspend
method when all the host's devices are suspended and the host's usage
count becomes <= 0 (redundant, since each non-suspended device
contributes to the usage count).  The midlayer calls the autoresume
method whenever the host's usage count rises from 0 to 1.

(There are a few exceptions, such as when the host is being removed.  
We don't have to worry about them now.)

To put it another way, the autosuspend method tells the LLD that it 
_may_ autosuspend the host adapter, not that it _must_.  However the 
autoresume method does mean that the LLD _must_ attempt an immediate 
autoresume (the attempt is allowed to fail).

> May suspend() be called after autosuspend() ?

Your question contains a layering violation: The SCSI host template 
doesn't contain a suspend method.

Do you mean to ask whether, for example, a PCI host adapter driver's 
PCI-suspend method could be called after its SCSI-autosuspend method?  
In general yes, but it depends on exactly what the autosuspend method 
does.

> If not, will resume() be
> called or autoresume() ?

Let's take USB as a representative example (since it is the _only_
example at the moment).  The SCSI core will call usb-storage's
autosuspend method when the SCSI device is suspended.  In turn, the
method calls usb_autopm_put_interface().  This starts a timer that
will, after 2 seconds, call usb-storage's suspend method and actually
suspend the USB port.

Or consider what happens during a system resume.  The PM core will
first resume the USB device, which causes usb-storage's resume method
to be invoked.  A little later the PM core will resume the SCSI device,
which is lower in the device tree.  This will cause the SCSI midlayer
to call usb-storage's autoresume method, which will call
usb_autopm_get_interface() -- thereby preventing the USB device from
autosuspending 2 seconds after it was resumed.

Does that answer your questions?

Alan Stern

