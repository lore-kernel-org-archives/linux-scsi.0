From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [linux-usb-devel] Re: bug 2400
Date: 05 Apr 2004 20:19:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081214360.1756.330.camel@mulgrave>
References: <Pine.LNX.4.44L0.0404032026590.30873-100000@netrider.rowland.org>	<108109222
		3.2034.8.camel@mulgrave>
	<407050F4.2090607@pacbell.net>	<1081104161.2112.34.camel@mulgrave>
	<4070D891.9040409@pacbell.net> <1081201463.2050.92.camel@mulgrave>
	<4071EA82.3020901@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:56212 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263580AbUDFBTr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Apr 2004 21:19:47 -0400
In-Reply-To: <4071EA82.3020901@pacbell.net>
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-04-05 at 18:23, David Brownell wrote:
> "Irrelevant" is pointlessly strong, even for what I'm guessing
> you really mean to be saying.

No, it's the very point.

If we have to enforce ordering on the event propagation across
subsystems, that can't be done without inter subsystem synchronisation.

In order to get away without any inter subsystem synchronisation the
order has to not matter.  i.e. be irrelevant.

> Minimally, there needs to be synchronization to prevent open() on
> one CPU from using data structures disconnect() just invalidated
> on another CPU.  That's a basic "how to write multi-threaded code"
> kind of issue, which I won't bother to explain (yet again).

Yes, but that's intra subsystem synchronisation, not inter subsystem
synchronisation.

Look, the rules are very simple:

- Every subsystem gives out refcounted objects.

- Every subsystem takes in a disconnection event for another object. 
Now what the subsystem does with the event is up to it.  The only
guarantee is if the subsystem holds no references to the other object
after the disconnection completes in that subsystem, then it may be
garbage collected.  However, if not, the other object must remain until
the last reference is dropped.

The point is that all the disconnection event does is inform a subsystem
that the entity represented by the other object has gone.  What it
chooses to do with the information is up to it.  It could set it's own
connected object to degraded, never use the other object again and drop
the reference.  Or, it could simply ignore the indication and continue
to use the other object (even though it will return errors for every
operation).

Now, if the subsystem is going to garbage collect its own object as a
result of the other object disconnect, then it is responsible for
synchronising that with reference gets on its own object.  However, that
is easily achievable via *intra* subsystem synchronisation.

If you follow these rules, there's no *inter* subsystem ordering or
synchronisation requirement.

James


