From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: Fri, 3 Oct 2003 14:35:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031003143518.A16624@beaverton.ibm.com>
References: <Pine.LNX.4.44L0.0310031013370.1676-100000@ida.rowland.org> <1065193559.1887.52.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:55500 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S261311AbTJCVhq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Oct 2003 17:37:46 -0400
Content-Disposition: inline
In-Reply-To: <1065193559.1887.52.camel@mulgrave>; from James.Bottomley@SteelEye.com on Fri, Oct 03, 2003 at 10:05:52AM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Linus Torvalds <torvalds@osdl.org>, Ruud Linders <rkmp@xs4all.nl>, Christoph Hellwig <hch@infradead.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, Andries.Brouwer@cwi.nl

On Fri, Oct 03, 2003 at 10:05:52AM -0500, James Bottomley wrote:

> Well, the patch isn't quite correct because if it's not going to probe
> the cache it should set up a write through cache (or disabled cache) as
> the default.

Alan's original patch is included in my patch.

> Patrick's patch
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=106366112221507
> 
> Does get this right.

I am re-rolling the patch based on current 2.6, plus a couple comments
Christoph had, I'll resend to you and linux-scsi.

> But my principle objection, as I've stated before, is that it isn't true
> that we don't need to manage the caches of hot pluggable devices, fibre
> channel being the counter example.

I agree - the type of transport does not indicate the capabilties of the
device. If connectors were free and took no space (yeh never), we would
have usb, firewire, spi, and fcp available on all disk drives.

But for some reason with USB, we are more likely to have devices that
cannot handle mode sense page 8 (cache). So shove some code into the
usb-storage driver, and make it possible to set policy allowing us to
disable page 8 for any device.

Though I do not see the utility in syncing the cache, especially given the
failure to figure out the caching method. 

High end storage won't care (probably battery backed ram, redundant
storage, and separate out-of-band monitoring facilities). 

If the cache sync fails, the best we can do is notify the user, we can't
reissue the write or even tell the user what block failed to make it to
disk, the best we can do is say "your hosed".

-- Patrick Mansfield
