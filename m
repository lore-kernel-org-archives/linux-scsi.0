From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Re: bug 2400
Date: Tue, 6 Apr 2004 12:55:41 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0404061251460.1042-100000@ida.rowland.org>
References: <1081266433.1837.29.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:17156 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263914AbUDFQzm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2004 12:55:42 -0400
In-Reply-To: <1081266433.1837.29.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: David Brownell <david-b@pacbell.net>, Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 6 Apr 2004, James Bottomley wrote:

> Supposing we did no hotplug at all and just relied on the fact that a
> driver responds DID_NO_CONNECT to a missing device.
> 
> We have a mounted fs on a CD on SCSI on USB which gets disconnected. No
> event is generated because no hotplug. Now every read of the fs gets
> EIO.  The system can continue in this state forever if necessary. 
> However, eventually the user will get bored and unmount the fs
> 
> If we just generated a single event saying "device gone" and did nothing
> else, userland helpers could pull apart the entire stack (clean up
> application, kill processes, unmount fs, remove scsi device etc).

In principle, yes.  However...  The kernel still has to process requests 
correctly while the stack is partially deconstructed.  It also has to 
protect against userland helpers trying to pull things apart in the wrong 
order.

I'm not trying to say that anything you wrote was wrong -- just that the 
situation is more complicated than you make it appear.

Alan Stern

