From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: 03 Oct 2003 10:05:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065193559.1887.52.camel@mulgrave>
References: <Pine.LNX.4.44L0.0310031013370.1676-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:23814 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263756AbTJCPIY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Oct 2003 11:08:24 -0400
In-Reply-To: <Pine.LNX.4.44L0.0310031013370.1676-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linus Torvalds <torvalds@osdl.org>, Ruud Linders <rkmp@xs4all.nl>, Patrick Mansfield <patmans@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, Andries.Brouwer@cwi.nl

On Fri, 2003-10-03 at 09:18, Alan Stern wrote:
> There haven't been any replies to my suggestion from a week ago
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=106462295800726&w=2
> 
> for a way to resolve the mode-sense page 8 problem.  One way or another, I 
> wish somebody would do _something_ about this, particularly before 
> 2.6.0-final comes out.

Well, the patch isn't quite correct because if it's not going to probe
the cache it should set up a write through cache (or disabled cache) as
the default.

Patrick's patch

http://marc.theaimsgroup.com/?l=linux-scsi&m=106366112221507

Does get this right.

But my principle objection, as I've stated before, is that it isn't true
that we don't need to manage the caches of hot pluggable devices, fibre
channel being the counter example.

Even for devices whose model is always forced remove, knowing the cache
type is valuable information (especially as writeback cache type would
be a rather grave error).

The reason not to try to read the cache type for USB is that some of the
devices barf on receiving the command.  These type of devices are the
ones we don't want to make any attempt to manage the cache for, and I'd
like the flag name we settle on to reflect this.

However, if there's no further objections on the naming front, I'll put
Patrick's patch into the SCSI repository.

James


