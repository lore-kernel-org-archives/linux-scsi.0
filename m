From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: 24 Apr 2003 16:20:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1051215651.1754.71.camel@mulgrave>
References: <UTC200304241859.h3OIxjh16776.aeb@smtp.cwi.nl>
	<20030424121409.C10511@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:17415 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263447AbTDXUJF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2003 16:09:05 -0400
In-Reply-To: <20030424121409.C10511@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Andries.Brouwer@cwi.nl, afafc@rnl.ist.utl.pt, Alan Cox <alan@lxorguk.ukuu.org.uk>, greg@kroah.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net, mike@hingston.demon.co.uk, stelian@popies.net, torvalds@transmeta.com

On Thu, 2003-04-24 at 15:14, Matthew Dharm wrote:
> Well, at this point, I guess I should just be happy that something is being
> done.  But, what I'm really afraid of, this coming right back to this
> point.
> 
> In the past, I modified the write-protect probing in 2.4.x to be more compatible
> with what usb-storage wanted.  But then someone changed it, and it broke.
> So we changed it again... and it was fine for a while.  Then someone
> changed it in 2.5.x, and it broke again.
> 
> I guess what's got me frustrated is that this is very fragile, tends to
> cause serious problems when it fails, often gets changed, and isn't really
> necessary -- after all, that's why the 'assume write-enabled' code path is
> there for when the request fails.
> 
> I've just been around and around this merry-go-round, and I'm trying to get
> off.  We can fix it now, but I am truly afraid that it's going to get
> broken again in 6 months.

To some extent, I'm afraid you can't get off:  you're stuck on here with
the rest of us.

I can't guarantee that changes to the SCSI subsystem won't break USB
devices.  However, what I can guarantee is that we'll work to fix the
problems as they arise.

> And, as for the need for filtering, I know we have such a need.  I have
> several devices on my desk which choke at INQUIRY EVPD -- so right now I
> filter it in the usb-storage driver.  I also have devices that report bogus
> INQUIRY data lengths, but (luckily) the sanity checks in the INQUIRY
> probing code generally catch those cases and save us.

I think the evpd code can be thrown out into user land (where the rules
governing how it's used can be much more flexible).  All we really use
it for is to get a unique name.  However, even WWN inquiries don't
always guarantee even that...

> I've seen devices that choke on START_STOP, unless that START_STOP is an
> eject command.  I fixed this by eliminating the only non-eject use of
> START_STOP in sd.c -- but how long is it before someone decides they need
> to use START_STOP for something?

sd.c uses START_STOP to spin up an inactive disc (but only if we get a
check condition/NOT READY). sr_ioctl.c uses it to eject or close a cd
tray.

> We may have fixed MODE_SENSE, but what about the other cases?

I think we just have to identify them and tackle them in the same way.

Do you have any other current bug reports you'd like to share with us?

James


