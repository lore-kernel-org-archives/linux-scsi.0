From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Handling erroneous READ CAPACITY response in sd.c
Date: Fri, 5 Nov 2004 13:34:34 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0411051333440.1015-100000@ida.rowland.org>
References: <20041105180611.GA23104@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:15364 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261154AbUKESef (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Nov 2004 13:34:35 -0500
In-Reply-To: <20041105180611.GA23104@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

On Fri, 5 Nov 2004, Matthew Dharm wrote:

> On Fri, Nov 05, 2004 at 11:18:34AM -0500, Alan Stern wrote:
> > On the other hand, the adjustment of the READ CAPACITY value should still 
> > be moved to sd.c from usb-storage.  This can be implemented easily enough 
> > by adding a bitflag to the scsi_device structure; the flag could be set 
> > either by a SCSI blist entry or by usb-storage in its slave_configure 
> > routine.  The flag would tell sd_read_capacity to decrement the number of 
> > sectors it receives from the device.
> 
> If I read this right, you're saying we should flag the device, but not
> actually tweak the READ_CAPACITY data?  In other words we get rid of the
> code which tries to munge the data in-flight?

Right.  Let usb-storage transport the data unchanged, and let the user of 
the data (sd.c in this case) decide what to do about it.

Alan Stern

