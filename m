From: Asim Kadav <kadav@cs.wisc.edu>
Subject: Re: [PATCH] a100u2w: Added sanitization for pointer dereference using a value from hardware. Detected using Carburizer  (http://lwn.net/Articles/479653/)
Date: Thu, 27 Dec 2012 08:12:01 -0600
Message-ID: <E83641E5-24F4-493A-8D0C-347D8611FC75@cs.wisc.edu>
References: <159925B4-EEAA-441E-8A8E-666DCA702D5B@cs.wisc.edu> <1356607503.2306.20.camel@dabdike>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56249 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446Ab2L0OML (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Dec 2012 09:12:11 -0500
In-Reply-To: <1356607503.2306.20.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org


> If your theory is that the hardware just returned a bogus value, this
> isn't the right way to sanitise it because the chances are you'll
> complete the wrong command and cause corruption: you'd have to halt the
> entire system at that point.  Also, I don't understand why you think the
> value should only be 0-31?  The size of variable allocated there is for
> SCBs up to 243, no idea why, since some of the allocation routines will
> search up to 256.  However, safety from overrun should be guaranteed at
> least at the system level by the can_queue value.

I agree. If the hardware returns a bogus value, it immediately would crash.
Would a more appropriate patch be checking within the ORC_MAXQUEUE 
range and flagging an error?

> 
> Double checking hardware values isn't something we habitually do unless
> there's a known reason for it (like the state machine does throw bogus
> values with a defined recovery procedure).  We definitely don't run in
> the mode where you can't trust your hardware.
> 

Hardware can fail for multiple reasons. Furthermore, such bugs are security
vulnerabilities too in the case of virtual hardware or USB drivers where
such values can be faked. The article in my patch gives more details.
http://lwn.net/Articles/479653/

Thanks,
Asim

