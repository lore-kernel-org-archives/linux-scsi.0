From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Re: bug 2400
Date: 05 Apr 2004 16:44:21 -0500
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <1081201463.2050.92.camel@mulgrave>
References: <Pine.LNX.4.44L0.0404032026590.30873-100000@netrider.rowland.org>	<108109222
	3.2034.8.camel@mulgrave>  <407050F4.2090607@pacbell.net>
	<1081104161.2112.34.camel@mulgrave>  <4070D891.9040409@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <4070D891.9040409@pacbell.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: David Brownell <david-b@pacbell.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2004-04-04 at 22:54, David Brownell wrote:
> Which directly follows from what I said ... USB propagates
> that knowledge in carefully defined ways.   Other layers can
> do the same, although clearly state associated with open file
> descriptors needs to use a slightly different strategy.  And
> that strategy is what Alan's original comment was about.

Well, again, this is at the core of the argument.

I say that as long as we have all our objects correctly refcounted, how
disconnections propagate up the stack is irrelevant.

If you have to have a "carefully defined" order for the propagation of
an asynchronous event to save you from oopsing, it's a sure sign of bugs
in the code.

My reasoning is that I/O down the stack will ultimately hit the part of
the kernel (or even just timeout in transmission to the device if it's
disappeared without trace) that contains the knowledge and be returned
with an error.  Ordering the disconnection propagation cannot change
this fact, merely alter *which* component returns the error.

As long as we're robust to the error there is no problem.

At this point, the object lifetime does nothing more that count how long
we have to keep the object around to return the error.

James




-------------------------------------------------------
This SF.Net email is sponsored by: IBM Linux Tutorials
Free Linux tutorial presented by Daniel Robbins, President and CEO of
GenToo technologies. Learn everything from fundamentals to system
administration.http://ads.osdn.com/?ad_id=1470&alloc_id=3638&op=click
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
