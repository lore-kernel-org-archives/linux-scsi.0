From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: 21 Apr 2003 16:27:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1050960465.1772.168.camel@mulgrave>
References: <20030323173733.B24668@one-eyed-alien.net>
	<1048469946.1643.2.camel@mulgrave>
	<20030323230438.E24668@one-eyed-alien.net>
	<1048519237.1982.16.camel@mulgrave>
	<20030324093028.A1066@one-eyed-alien.net>
	<1049556643.1762.16.camel@mulgrave>
	<20030420143351.C20891@one-eyed-alien.net>
	<1050942530.1772.12.camel@mulgrave>
	<20030421100102.A12581@one-eyed-alien.net>
	<1050953018.2269.140.camel@mulgrave>
	<20030421123541.C12581@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:4103 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262272AbTDUVQC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Apr 2003 17:16:02 -0400
In-Reply-To: <20030421123541.C12581@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

On Mon, 2003-04-21 at 14:35, Matthew Dharm wrote:
> I think takers may be waiting in the wings to see this code merged.
> Honestly, tho, I don't think I can send you such strings.  I work pretty
> closely with some vendors, so most of the devices in my possession have
> 'fixed' firmware (to report meaningful INQUIRY length).  However, I get
> report after report of devices that blow this in new and creative ways from
> end-users.
> 
> You may recall that my first approach was to set the BLIST flag for 36-byte
> INQUIRY -- Linus shot that down in favor of a command-filter approach.

You mean we can junk the BLIST_INQUIRY flags?  Does the 58 byte inquiry
serve any purpose then (i.e. do you have a device that lies about its
inquiry length but can return 58 bytes?).  The 58 bytes is useful
because SPI fields lie in the 57th byte (information for the higher
ultra speeds), but on the other hand those bits are only defined for a
parallel bus.

If I junk the flags, we'll send a 36 byte inquiry and then one sized
from the inquiry return (unless we have to do an intermediate 58 byte
one) and let you filter them.  Does that sound OK?

James


