From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH; make sr.c respect use_10_for_ms
Date: 22 Jun 2003 08:58:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1056290282.1979.4.camel@mulgrave>
References: <20030621165920.F2811@one-eyed-alien.net>
	<1056241551.1775.14.camel@mulgrave>
	<20030621174640.M2811@one-eyed-alien.net>
	<1056250487.1775.58.camel@mulgrave>
	<20030621212406.N2811@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:20485 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265023AbTFVNoF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Jun 2003 09:44:05 -0400
In-Reply-To: <20030621212406.N2811@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: torvalds@transmeta.com, Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>

On Sat, 2003-06-21 at 23:24, Matthew Dharm wrote:
> On Sat, Jun 21, 2003 at 09:54:46PM -0500, James Bottomley wrote:
> >  	}
> > -	n = buffer[3] + 4;
> > +	n = rc;
> >  	cd->cdi.speed = ((buffer[n + 8] << 8) + buffer[n + 9]) / 176;
> 
> This bit isn't right.  n is supposed to point to the start of the page
> data, not the page header.  The header is a different size if the command
> is 6-byte or 10-byte.

Yes it is.

That's why I eliminated the dbd bit.  Your patch was calculating the
offsets past the dbd headers.  However, if you tell the mode sense not
to send any dbd headers (which are pointless, because the routine isn't
interested in them), then you don't have to skip past them. and the mode
data begins just past the mode header.

James


