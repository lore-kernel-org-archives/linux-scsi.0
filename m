From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: 23 Sep 2003 09:51:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064328668.1832.30.camel@mulgrave>
References: <UTC200309231437.h8NEb8N23975.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:41734 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263371AbTIWOwA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Sep 2003 10:52:00 -0400
In-Reply-To: <UTC200309231437.h8NEb8N23975.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: david-b@pacbell.net, greg@kroah.com, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net, mdharm-usb@one-eyed-alien.net, Patrick Mansfield <patmans@us.ibm.com>, stern@rowland.harvard.edu, Linus Torvalds <torvalds@osdl.org>

On Tue, 2003-09-23 at 09:37, Andries.Brouwer@cwi.nl wrote:
> No, the design goal of "hot-pluggable" is that it indicates that
> the device can disappear any moment. Nothing at all about SCSI
> compliance.

Actually, then, these are two issues...hotplug is being worked on
separately at the moment.

I thought the problem under discussion was devices which lacked SCSI
standards compliance.

> Pulling out a device while it is actively reading or writing
> will probably break something. But if a device is hot-pluggable
> it should be OK to pull it out when it has been inactive for
> a second or so.
> 
> But if that is really true, then it should not be necessary
> to send the device any "synchronise cache" commands when we
> shut down.

For a FC array, suprise unplug would be caveat emptor (possibly because
fibre connection transience is going to cause it to come back), but
notified unplug would still want to flush the cache on the assumption
the next action might be to power down the array.

James


