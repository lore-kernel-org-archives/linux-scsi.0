From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: sg regression in 2.6.16-rc5
Date: Thu, 2 Mar 2006 16:02:58 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0603021555020.22647@g5.osdl.org>
References: <E94491DE-8378-41DC-9C01-E8C1C91B6B4E@mac.com> <4404AA2A.5010703@torque.net>
 <20060301083824.GA9871@merlin.emma.line.org> <Pine.LNX.4.64.0603011027400.22647@g5.osdl.org>
 <4405F6F1.9040106@torque.net> <Pine.LNX.4.63.0603012239440.5789@kai.makisara.local>
 <44074CA1.3000007@torque.net> <Pine.LNX.4.64.0603021317520.22647@g5.osdl.org>
 <20060302230814.GB16237@merlin.emma.line.org> <Pine.LNX.4.64.0603021518430.22647@g5.osdl.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:7126 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751003AbWCCADX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2006 19:03:23 -0500
In-Reply-To: <Pine.LNX.4.64.0603021518430.22647@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <matthias.andree@gmx.de>
Cc: Douglas Gilbert <dougg@torque.net>, Kai Makisara <Kai.Makisara@kolumbus.fi>, Mark Rustad <mrustad@mac.com>, linux-scsi@vger.kernel.org



On Thu, 2 Mar 2006, Linus Torvalds wrote:
>
> As far as I can tell, the rest of the thread has been _whining_.
> 
> Guys, what's so hard with just raising the limits on the common SG_IO 
> thing (the same way people had to raise the limits on the _old_ sg-only 
> thing), instead of whining about it?

To clarify, the thing people seem to be whining about is that SG now 
_honors_ the limits that we have. For example, the code now honors things 
like "max_sectors", which was apparently totally ignored before, and sg 
could pass in requests that were simply NOT VALID for the limits the 
driver itself could have set..

This is why I say people are "whining". It's obviously fixing something 
that we did wrong before. The fact that the wrong thing happened to work 
is not all that relevant, especially since 

 - any breakage will likely be pretty obvious
 - any breakage will be limited to people who do special things on special 
   hardware.
 - the people who did special things like this are apparently already used 
   to doing things like changing SG_SCATTER_SZ and then _recompiling_ the 
   whole kernel (it wasn't ever a dynamic option or anything like that).

so we're not exactly looking at a poor clueless users going "uhhuh, my 
machine won't boot any more" kind of issues. We're looking at fixing a 
deficiency in the code, that may expose drivers etc that have set their 
limits low.

			Linus
