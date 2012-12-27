From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] a100u2w: Added sanitization for pointer dereference
 using a value from hardware. Detected using Carburizer
 (http://lwn.net/Articles/479653/)
Date: Thu, 27 Dec 2012 14:53:34 +0000
Message-ID: <1356620014.2306.23.camel@dabdike>
References: <159925B4-EEAA-441E-8A8E-666DCA702D5B@cs.wisc.edu>
	 <1356607503.2306.20.camel@dabdike>
	 <E83641E5-24F4-493A-8D0C-347D8611FC75@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46375 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752593Ab2L0Oxk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Dec 2012 09:53:40 -0500
In-Reply-To: <E83641E5-24F4-493A-8D0C-347D8611FC75@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Asim Kadav <kadav@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On Thu, 2012-12-27 at 08:12 -0600, Asim Kadav wrote:
> > If your theory is that the hardware just returned a bogus value, this
> > isn't the right way to sanitise it because the chances are you'll
> > complete the wrong command and cause corruption: you'd have to halt the
> > entire system at that point.  Also, I don't understand why you think the
> > value should only be 0-31?  The size of variable allocated there is for
> > SCBs up to 243, no idea why, since some of the allocation routines will
> > search up to 256.  However, safety from overrun should be guaranteed at
> > least at the system level by the can_queue value.
> 
> I agree. If the hardware returns a bogus value, it immediately would crash.
> Would a more appropriate patch be checking within the ORC_MAXQUEUE 
> range and flagging an error?

It's probably really not worth it.  The u100w2 is a pretty old SCSI
driver.  I can't imagine there's more than a handful of them left.  As I
said, there's no evidence of a problem.

> > Double checking hardware values isn't something we habitually do unless
> > there's a known reason for it (like the state machine does throw bogus
> > values with a defined recovery procedure).  We definitely don't run in
> > the mode where you can't trust your hardware.
> > 
> 
> Hardware can fail for multiple reasons. Furthermore, such bugs are security
> vulnerabilities too in the case of virtual hardware or USB drivers where
> such values can be faked. The article in my patch gives more details.
> http://lwn.net/Articles/479653/

USB possibly, but this isn't a USB driver.  Virtual hardware is a bit
unlikely, since it's created by the host for the guest.  I don't believe
there's any hypervisor system that can survive attempted subversion by
the *host* (host protecting against guest, yes, but guest trying to
protect against host is a very different ball game).

James


