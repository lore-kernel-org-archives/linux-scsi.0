From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Fri, 24 Jan 2003 10:34:11 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0301241026060.821-100000@ida.rowland.org>
References: <20030123152554.F12788@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030123152554.F12788@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Oliver Neukum <oliver@neukum.name>, Doug Ledford <dledford@redhat.com>, Luben Tuikov <luben@splentec.com>, David Brownell <david-b@pacbell.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

On Thu, 23 Jan 2003, Matthew Dharm wrote:

> What I want:
> 
> I want to be able to free resources associated with a device within a
> finite (and well bounded) amount of time after I am notified that the
> device is gone.
> 
> I want to be able to inform the SCSI mid-layer, which will then inform
> higher layers, that the device is gone.  This is so that all may deal with
> this however they want.  I really don't care who does what, as long as we
> don't crash.  This implies that all block-type drivers will need to become
> hotplug aware, or the SCSI mid-layer will have to fake command failures.
> 
> I want to be able to do as little command-trickery as possible.  If I have
> to do it, then that means the next hotplug-capable LLDD must do it also.
> Duplication of code is bad -- it should all be handled in the mid-layer.

Matt's current proposed patch has the USB LLDD calling
scsi_unregister_host()  (because the device is respresented as an emulated
host adapter) when it learns that the device is gone.  Provided that
routine doesn't block for very long, provided it handles all the details
of hotplug notifications, and provided it guarantees that after it returns
there will be no more calls to the emulated adapter, I don't see any
problem.  The LLDD can go ahead and remove all records of the former
device, secure in the knowledge that all pointers to data structures and
entry points have been erased.

Isn't this exactly what everyone has been asking for and debating about?

Alan Stern


