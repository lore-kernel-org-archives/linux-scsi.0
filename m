From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [linux-usb-devel] Re: bug 2400
Date: 06 Apr 2004 10:47:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081266433.1837.29.camel@mulgrave>
References: <Pine.LNX.4.44L0.0404032026590.30873-100000@netrider.rowland.org>	<108109222
			3.2034.8.camel@mulgrave>
		<407050F4.2090607@pacbell.net>	<1081104161.2112.34.camel@mulgrave>
		<4070D891.9040409@pacbell.net> <1081201463.2050.92.camel@mulgrave>
		<4071EA82.3020901@pacbell.net> <1081214360.1756.330.camel@mulgrave>
	<4072C876.7030906@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:62136 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263875AbUDFPre (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Apr 2004 11:47:34 -0400
In-Reply-To: <4072C876.7030906@pacbell.net>
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-04-06 at 10:10, David Brownell wrote:
> James Bottomley wrote:
> >  that's intra subsystem synchronisation, not inter subsystem
> 
> I'd say that device_driver.remove() calls from the bus management
> code to a given device driver are inter-subsystem...

so using a subsystem provided API from another subsystem constitutes
inter subsytem synchronisation?  I don't think so.

> Refcounting systems need loop-breaking protocols ("disconnect");
> this is needed for that sort of reason, if no other.

No, they don't.

Supposing we did no hotplug at all and just relied on the fact that a
driver responds DID_NO_CONNECT to a missing device.

We have a mounted fs on a CD on SCSI on USB which gets disconnected. No
event is generated because no hotplug. Now every read of the fs gets
EIO.  The system can continue in this state forever if necessary. 
However, eventually the user will get bored and unmount the fs

If we just generated a single event saying "device gone" and did nothing
else, userland helpers could pull apart the entire stack (clean up
application, kill processes, unmount fs, remove scsi device etc).

You're trying to make a particular event special.  That's not correct. 
There are many types of disconnect (user unmount, user offlines device)
coming from essentially all parts of the stack.

James


