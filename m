From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: question on flushing buffers and spinning down disk
Date: Mon, 24 Sep 2007 10:38:15 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0709241032180.4256-100000@iolanthe.rowland.org>
References: <200709241233.23028.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:47760 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752634AbXIXOiQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Sep 2007 10:38:16 -0400
In-Reply-To: <200709241233.23028.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Mon, 24 Sep 2007, Oliver Neukum wrote:

> Am Dienstag 18 September 2007 schrieb James Bottomley:
> > On Tue, 2007-09-18 at 16:15 +0200, Oliver Neukum wrote:

> > > It is for runtime power management. We've gotten a bug report about
> > > a drive enclosure that doesn't properly park heads if the usb device is
> > > simply suspended. Apparently it simply cuts power so the cache can
> > > be lost, too.
> > 
> > But even for runtime, if you want to suspend the device, shouldn't you
> > be calling the suspend methods in the device tree?
> 
> Very good question. It seems to that yes indeed, we should. But we don't
> in case of autosuspend. We simply suspend the interfaces:

It's a loaded question.  The fact is, the existing suspend methods in
the device tree are intended for system-wide suspend, not for runtime
suspend.  The PM and driver cores don't include _any_ provision for
runtime suspend; it has to be managed separately by each subsystem.

And that means we need a method of communication between the SCSI and 
USB subsystems.  The SCSI core has to tell usb-storage when it's okay 
to do a runtime suspend.  More generally, every host adapter driver 
should have a method in its driver template which the SCSI core can 
invoke when it is safe to suspend the adapter (and thus the entire 
bus).

Alan Stern

