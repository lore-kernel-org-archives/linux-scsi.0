From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: Wed, 24 Sep 2003 09:53:02 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0309240948550.3178-100000@home.osdl.org>
References: <3F71C8FD.2050109@xs4all.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:38820 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261508AbTIXQyu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2003 12:54:50 -0400
In-Reply-To: <3F71C8FD.2050109@xs4all.nl>
List-Id: linux-scsi@vger.kernel.org
To: Ruud Linders <rkmp@xs4all.nl>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Patrick Mansfield <patmans@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, Andries.Brouwer@cwi.nl


On Wed, 24 Sep 2003, Ruud Linders wrote:
> > 
> > Is this different from a plain kernel _without_ the patch?
> 
> No difference.

Ok. I committed my version as "better than what is there now", but clearly
it's not good enough.

So we should really add code to sd_read_cache_type() to default to 
write-through for USB devices. The question is, what kind of flag do we 
want to use?

We already have the combination "removable && !lockable", which would make
a lot of sense. But I don't think USB even touches those flags, and
"removable" wrt USB is actually a bit ambiguous (in the USB unplug case,
it's actually the _controller_ that is removed, not the medium).

Suggestions? Just add a new flag like the "use_10_for_ms" flag?

		Linus

