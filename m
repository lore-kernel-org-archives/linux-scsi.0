From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting
 root
Date: Fri, 20 Jun 2008 11:42:21 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0806201130390.2719-100000@iolanthe.rowland.org>
References: <19f34abd0806200815t49b59df9sd9567b52482eaee3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:34383 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756561AbYFTPmW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jun 2008 11:42:22 -0400
In-Reply-To: <19f34abd0806200815t49b59df9sd9567b52482eaee3@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Pekka J Enberg <penberg@cs.helsinki.fi>, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org, dsd@gentoo.org, mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org, vegardno@ifi.uio.no, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>

On Fri, 20 Jun 2008, Vegard Nossum wrote:

> Hi,
> 
> On Thu, Jun 19, 2008 at 11:39 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Thu, 19 Jun 2008, Matthew Wilcox wrote:
> >
> >> This discussion seemed to die off ... did anything ever come of it?
> >
> > As I recall, it died because the whole notion was very poorly defined
> > to begin with.  The idea was to stop waiting when all the SCSI buses
> > had been scanned -- but there's no way to know when that occurs because
> > new buses can be added at any time.
> 
> Can you please explain why this is?
> 
> We only want to scan buses that are present when the system is
> started. If we reach the point where all USB ports/devices/whatever
> have been enumerated, all SCSI buses scanned, and all partition tables
> loaded, what more is there to wait for?

New USB devices can appear at any time.  None are present when the 
system is started; they are all detected dynamically by the khubd 
thread.

While I'm not familiar with the details of any other hotpluggable 
buses (like Firewire), I imagine much the same is true for them.

> I can't understand that this is fundamentally a hardware problem. I
> understand that there might be a problem with the patch that was
> proposed a the beginning of the thread, but is this really a truly
> unsolvable problem? Please correct me if I am wrong -- the problem
> here is that Pekka's newly introduced nr_root_scans can drop to 0
> before everything has been enumerated at least once. This is because
> scsi_scan_host() forks a new thread which is what's actually doing the
> scanning. Can't we just stick a begin_root_scan() before forking, and
> drop it inside the thread, just like we do with the
> usb_stor_scan_thread? If the thread is actually a loop, the first
> iteration should be enough, right?
> 
> I'm grateful for any explanations that will help my poor head understand... :-)

Suppose there are two USB disk drives attached, and the one containing
the root fs is probed second.  The count could easily drop to 0 when
the first drive has been scanned, especially if scanning is done
synchronously.

What happens when the root fs is on a hotpluggable bus that doesn't use
the SCSI infrastructure?  You'd have to extend your hooks into that
other subsystem as well.

Besides, why do you want to go to all this trouble to find out
_exactly_ when the device containing the root fs becomes available?  
What's wrong with just checking at 1/10-second intervals?

For example, what happens if the USB device containing the root fs
isn't plugged in when the system boots?  The user will quickly realize
that nothing is happening and will then plug it in.  But your code will
already have decided that the device doesn't exist and given up.  
Wouldn't it be better simply to keep on trying, so that then the device 
does get plugged in the system can use it?

Alan Stern

