From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: 05 Apr 2003 14:08:29 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1049573311.1762.121.camel@mulgrave>
References: <20030322233136.D17056@one-eyed-alien.net>
	<1048467235.1634.22.camel@mulgrave>
	<20030323173733.B24668@one-eyed-alien.net>
	<1048469946.1643.2.camel@mulgrave>
	<20030323230438.E24668@one-eyed-alien.net>
	<1048519237.1982.16.camel@mulgrave>
	<20030324093028.A1066@one-eyed-alien.net>
	<1049556643.1762.16.camel@mulgrave>
	<20030405112759.B4320@one-eyed-alien.net>
	<1049571946.2538.94.camel@mulgrave>
	<20030405115546.C4320@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:38661 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262639AbTDET5S (for <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Apr 2003 14:57:18 -0500
In-Reply-To: <20030405115546.C4320@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Sat, 2003-04-05 at 13:55, Matthew Dharm wrote:
> 
> My big complaint about that is that it's ugly.  I would like to keep the
> device type as part of the filter command structure, so I can keep the call
> to scsi_filter_cmd() simple and easy to maintain.  Maybe it's just me, but
> I think that editing the filter table with an extra field will be easier to
> get right than trying to maintain several different filter tables (for each
> device type).

But that would reduce the power of the filter.  At the moment you can
code "all devices apart from tapes" or "only disk and cdrom".  If I add
it to the body of the filter, I either have to add a complex language to
express this or reduce the power.  Neither seems to be particularly
optimal

> I guess the real power of this filter is in the ability to add logic to
> scsi_filter_exceptions()... but centralizing that seems contrary to the
> idea of doing this on a per-HBA basis.

The filter is just a language.  HBAs don't need to use all the
expressions in the exceptions, so unless it gets too big I don't see why
necessary additions can't go centrally.

James


