From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: 26 Apr 2003 21:15:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1051409717.4089.146.camel@mulgrave>
References: <UTC200304262144.h3QLiAt04450.aeb@smtp.cwi.nl>
	<20030426151356.A8697@one-eyed-alien.net>
	<1051397024.4089.86.camel@mulgrave>
	<20030426183428.B8697@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:58372 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263228AbTD0CDX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Apr 2003 22:03:23 -0400
In-Reply-To: <20030426183428.B8697@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Andries.Brouwer@cwi.nl, greg@kroah.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net

On Sat, 2003-04-26 at 20:34, Matthew Dharm wrote:
> To parse correctly, I would need to remember what type of device it is by
> snooping the INQUIRY data.  I would also have to keep around data such as
> block size (for TYPE_DISK).  I haven't even looked at what extra data I
> would need to keep around for all the other types.

OK, I don't understand this.  To extract the transfer length from a
given SCSI command (excluding vendor specific ones) is a well defined
process.  All you need is the command, it doesn't require knowing device
type or anything else.

> Why should usb-storage do that when someone else (the command source)
> already knows this data?  Whatever is sending the command already knows how
> much data to expect -- my reparsing the command to try to figure it out is
> guaranteed to be less precise than just using the correct answer from the
> source of the command.

Because we're exploring options for this "lengthen the transfer size"
behaviour the USB layer exhibits.  Assuming you can transfer more bytes
than the indicated buffer size is a recipe for data corruption problems
down the line.

> Also, user-issued commands can specify buffer size and transfer length
> separately, but only one value gets given to the usb-storage driver.  The
> other is dropped on the floor somewhere in the mid-layer.

I usually use the SCSI_IOCTL_SEND_COMMAND, which only allows the
specification of a buffer size (rather than both length and buffer
size), how do you send SCSI commands?

> In the end, I guess the short-answer to 'what is wrong with parsing' is
> that we tried it for over a year, and it kept biting us on the ass with
> weird corner-cases and strange devices.

Well, the only weird corner cases are vendor specific commands and for
these the rule is that we assume the buffer size and the transfer size
to be the same.  Since they aren't currently issued by the mid-layer
this must be true today (otherwise they wouldn't work today), so I think
we have everything covered.

James


