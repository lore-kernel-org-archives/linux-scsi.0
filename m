From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH; make sr.c respect use_10_for_ms
Date: 23 Jun 2003 09:33:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1056378827.1826.14.camel@mulgrave>
References: <20030621165920.F2811@one-eyed-alien.net>
	<1056241551.1775.14.camel@mulgrave>
	<20030621174640.M2811@one-eyed-alien.net>
	<1056250487.1775.58.camel@mulgrave>
	<20030621212406.N2811@one-eyed-alien.net>
	<1056290282.1979.4.camel@mulgrave>
	<20030622124917.A21716@one-eyed-alien.net>
	<20030622125650.D21716@one-eyed-alien.net>
	<1056314343.10846.93.camel@mulgrave>
	<20030622140657.A22396@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:20742 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266056AbTFWOTs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jun 2003 10:19:48 -0400
In-Reply-To: <20030622140657.A22396@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: torvalds@transmeta.com, Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>

On Sun, 2003-06-22 at 16:06, Matthew Dharm wrote:
> The problem as I see it is ATAPI devices.  That means that sbp2, ide-scsi,
> and usb-storage (all of which bridge ATAPI devices to the SCSI layer) will
> be affected.  These devices don't include the DBD bit in their command
> specification -- the bit is reserved.

That's SFF-8020i?  The bit is listed as reserved, *but* the
implementation defined behaves as if DBD were specified.  The BD header
component of the mode sense header is specifically listed as "reserved"
and the spec doesn't allow for block descriptors to be returned.

The current code for ATAPI CD-ROMS must just be lucky because the
reserved fields are zero filled.

the SFF-8020i says that the recipient "shall not check" reserved fields,
so the standard makes it sound like we can get away with the correct
behaviour in all cases by setting DBD.

Have you actually heard of setting DBD causing a failure on ATAPI
devices?

James


