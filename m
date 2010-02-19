From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] atp870u: Split long udelay()
Date: Fri, 19 Feb 2010 16:44:57 +0000
Message-ID: <20100219164457.GX21665@decadent.org.uk>
References: <1266544619.10567.715.camel@localhost> <1266593299.2822.7.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46968 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751864Ab0BSQpA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2010 11:45:00 -0500
Content-Disposition: inline
In-Reply-To: <1266593299.2822.7.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

On Fri, Feb 19, 2010 at 09:28:19AM -0600, James Bottomley wrote:
> On Fri, 2010-02-19 at 01:56 +0000, Ben Hutchings wrote:
> > udelay() is supposed to be limited to 1 ms, and will generate a
> > __bad_udelay() on ARM for constant arguments > 2000.  Split
> > udelay(0x800) into mdelay(2); udelay(48).  (I suspect that msleep(3)
> > would work but I do not know how critical the timing is here.)
> 
> So no to this one.  Either ARM is right and udelay > 2000 is wrong
> (which actually sounds correct given how long this will eat CPU for) so
> the driver needs fixing, or ARM is wrong and the warning needs fixing.
> 
> Splitting the delay to defeat the warning while retaining the behaviour
> it was trying to warn about is the wrong thing to do.
 
AIUI the restrictions on udelay() are there because the delay is likely
to be inaccurate for large arguments.  If it was actually wrong to wait
for over a millisecond then mdelay() would not exist.

Ben.

-- 
Ben Hutchings
The two most common things in the universe are hydrogen and stupidity.
