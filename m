From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: 26 Apr 2003 17:43:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1051397024.4089.86.camel@mulgrave>
References: <UTC200304262144.h3QLiAt04450.aeb@smtp.cwi.nl>
	<20030426151356.A8697@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:37895 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263126AbTDZWdW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Apr 2003 18:33:22 -0400
In-Reply-To: <20030426151356.A8697@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Andries.Brouwer@cwi.nl, greg@kroah.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net

On Sat, 2003-04-26 at 17:13, Matthew Dharm wrote:
> > Of course it is bad when variables have a function that differs
> > from what is suggested by their name. So, sr_bufflen must be
> > the length of the buffer and nothing else. If the length of
> > the transfer is needed, there must be a field sr_xferlen or so.
> 
> Sounds good.  It also sounds very similar to what I proposed some time ago.
> Here's a question from that discussion: How you you set sr_xferlen?  I'm
> guessing that you want to add a parameters to scsi_wait_req()?  Or
> will you simply remove the bufflen parameter and force callers to set both
> fields in the struct scsi_request?
> 
> Either way, you'll be touching a great deal of code.  Which isn't
> necessarily a bad thing, but it might raise a few eyebrows....

What's actually wrong with simply parsing the commands?  For all SCSI
Spec commands there's a well known algorithm to get the transfer size
from the command group.  For vendor specific commands, well the
mid-layer doesn't issue them so you'd just have to rely on the user
doing it to pass the correct buffer length (which is no different really
from what happens today).

James



