From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-usb-devel] Re: bug 2400
Date: Mon, 05 Apr 2004 16:23:46 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4071EA82.3020901@pacbell.net>
References: <Pine.LNX.4.44L0.0404032026590.30873-100000@netrider.rowland.org>	<108109222	3.2034.8.camel@mulgrave>  <407050F4.2090607@pacbell.net>	<1081104161.2112.34.camel@mulgrave>  <4070D891.9040409@pacbell.net> <1081201463.2050.92.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta7.pltn13.pbi.net ([64.164.98.8]:59609 "EHLO
	mta7.pltn13.pbi.net") by vger.kernel.org with ESMTP id S263555AbUDEXY7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Apr 2004 19:24:59 -0400
In-Reply-To: <1081201463.2050.92.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Sun, 2004-04-04 at 22:54, David Brownell wrote:
> 
>>Which directly follows from what I said ... USB propagates
>>that knowledge in carefully defined ways.   Other layers can
>>do the same, although clearly state associated with open file
>>descriptors needs to use a slightly different strategy.  And
>>that strategy is what Alan's original comment was about.
> 
> 
> Well, again, this is at the core of the argument.
> 
> I say that as long as we have all our objects correctly refcounted, how
> disconnections propagate up the stack is irrelevant.

"Irrelevant" is pointlessly strong, even for what I'm guessing
you really mean to be saying.

Minimally, there needs to be synchronization to prevent open() on
one CPU from using data structures disconnect() just invalidated
on another CPU.  That's a basic "how to write multi-threaded code"
kind of issue, which I won't bother to explain (yet again).


> If you have to have a "carefully defined" order for the propagation of
> an asynchronous event to save you from oopsing, it's a sure sign of bugs
> in the code.

It was "carefully defined" to ensure that there are clearly
defined points where it's safe to delete the hardware state.
Those are needed in situations other than disconnect().

Not having such synchronization points meant that HCDs were
reduced to _guessing_ whether it's safe to free that state.
Which was a sure sign of API bugs (inside usbcore), and made
for way too many oops-on-unplug reports in 2.4 kernels (and
kept various other things from working right, too).


> My reasoning is that I/O down the stack will ultimately hit the part of
> the kernel (or even just timeout in transmission to the device if it's
> disappeared without trace) that contains the knowledge and be returned
> with an error.  Ordering the disconnection propagation cannot change
> this fact, merely alter *which* component returns the error.

Ensuring such a behaviour certainly requires "careful design".
As does ensuring that the event propagation _completes_ every
time, rather than sometimes just refusing to finish.  Surely
you've seen both kinds of design botch.


> As long as we're robust to the error there is no problem.

The only system "error" in this discussion was that oops.

It may be a minor point ... but "disconnecting device while in use"
isn't an error at all.  It's a fault, maybe sometimes undesirable,
but one with behavior specified as fully as reading or writing a
block of data.


> At this point, the object lifetime does nothing more that count how long
> we have to keep the object around to return the error.

And that's basically what I said about the careful design of the
disconnect sequence, ensuring that there _is_ such a point:  one
where the only issues left are when references get dropped, so
that the only issue left is memory management.

- Dave



> James
> 
> 
> 


