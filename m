From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Lsf] Notes from the four separate IO track sessions at LSF/MM
Date: Thu, 28 Apr 2016 10:33:42 -0700
Message-ID: <1461864822.2307.28.camel@HansenPartnership.com>
References: <1461800389.2311.70.camel@HansenPartnership.com>
	 <20160428121108.GA9903@redhat.com>
	 <1461858038.2307.16.camel@HansenPartnership.com>
	 <5722320E.5080202@sandisk.com>
	 <d8e572ba7c9a46aaa3af4c5703ec07e3@hioexcmbx07-prd.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60916 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753278AbcD1Rdp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Apr 2016 13:33:45 -0400
In-Reply-To: <d8e572ba7c9a46aaa3af4c5703ec07e3@hioexcmbx07-prd.hq.netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Knight, Frederick" <Frederick.Knight@netapp.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Mike Snitzer <snitzer@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "lsf@lists.linux-foundation.org" <lsf@lists.linux-foundation.org>, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2016-04-28 at 16:19 +0000, Knight, Frederick wrote:
> There are multiple possible situations being intermixed in this
> discussion.  First, I assume you're talking only about random access
> devices (if you try transport level error recover on a sequential
> access device - tape or SMR disk - there are lots of additional
> complexities).

Tape figured prominently in the reset discussion.  Resetting beyond the
LUN has the possibility to cause grave impact to long running jobs
(mostly on tapes).

> Failures can occur at multiple places:
> a) Transport layer failures that the transport layer is able to
> detect quickly;
> b) SCSI device layer failures that the transport layer never even
> knows about.
> 
> For (a) there are two competing goals.  If a port drops off the
> fabric and comes back again, should you be able to just recover and
> continue.  But how long do you wait during that drop?  Some devices
> use this technique to "move" a WWPN from one place to another.  The
> port drops from the fabric, and a short time later, shows up again
> (the WWPN moves from one physical port to a different physical port).
> There are FC driver layer timers that define the length of time
> allowed for this operation.  The goal is fast failover, but not too
> fast - because too fast will break this kind of "transparent
> failover".  This timer also allows for the "OH crap, I pulled the
> wrong cable - put it back in; quick" kind of stupid user bug.

I think we already have this sorted out with the dev loss timeout which
is implemented in the transport.  It's the grace period you have before
we act on a path loss.

> For (b) the transport never has a failure.  A LUN (or a group of
> LUNs) have an ALUA transition from one set of ports to a different
> set of ports.  Some of the LUNs on the port continue to work just
> fine, but others enter ALUA TRANSITION state so they can "move" to a
> different part of the hardware.  After the move completes, you now
> have different sets of optimized and non-optimized paths (or possible
> standby, or unavailable).  The transport will never even know this
> happened.  This kind of "failure" is handled by the SCSI layer
> drivers.

OK, so ALUA did come up as well, I just forgot.  Perhaps I should back
off a bit and give the historical reasons why dm became our primary
path failover system.  It's because for the first ~15 years of Linux we
had no separate transport infrastructure in SCSI (and, to be fair, T10
didn't either).  In fact, all scsi drivers implemented their own
variants of transport stuff.  This meant there was intial pressure to
make the transport failover stuff driver specific and the answer to
that was a resounding "hell no!" so dm (and md) became the de-facto
path failover standard because there was nowhere else to put it.  The
transport infrastructure didn't really become mature until 2006-2007,
well after this decision was made.  However, now we have transport
infrastructure the question of whether we can use it for path failover
isn't unreasonable.  If we abstract it correctly, it could become a
library usable by all our current transports, so we might only need a
single implementation.

For ALUA specifically (and other weird ALUA like implementations), the
handling code actually sits in drivers/scsi/device-handler, so it could
also be used by the transport code to make path decisions.  The point
here is that even if we implement path failover at the transport level,
we do have more than the information available that the transport
should strictly know to make the failover decision.

James


