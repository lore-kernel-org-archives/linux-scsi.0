From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Promise 'stex' driver
Date: Tue, 25 Jul 2006 13:30:32 -0400
Message-ID: <44C65538.7050809@garzik.org>
References: <NONAMEBFJ3sl3xbYiMC000000d4@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:56294 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1750785AbWGYRag (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jul 2006 13:30:36 -0400
In-Reply-To: <NONAMEBFJ3sl3xbYiMC000000d4@nonameb.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "James.Bottomley" <James.Bottomley@SteelEye.com>, hch <hch@infradead.org>, linux-kernel <linux-kernel@vger.kernel.org>, akpm <akpm@osdl.org>, promise_linux <promise_linux@promise.com>

Ed Lin wrote:
> So it seems there are several possibilities here(regarding no.1 comment):
> 1.The bridge code is kept unchanged. And, as this is a violation to
> Linux tradition and requirement, it could not be admitted upstream.
> 2.The code could be modified to be conforming to Linux standard. But,
> we are new to Linux. Maybe we need some specific instructions to know
> how to do it. Sorry if this request becomes annoying.
> 3.Remove the code.
> 
> We are wondering what should we do next. We are seeking the community's 
> help, and advice, something we definitely need.

The normal process for submitting changes to the Linux kernel is by
submitting a series of patches, each containing a single logical set of
changes.  For example:

[PATCH 1/4] stex: white space/ minor fix(INQUIRY, max_channel)
[PATCH 2/4] stex: add new device ids
[PATCH 3/4] stex: update internal copy code path
[PATCH 4/4] stex: add hard reset function

Each patch may be dependent on prior patches.  Each patch should produce
a usable driver, e.g.

patch #1 must produce a usable driver.
patch #1 + #2 must produce a usable driver.
patch #1 + #2 + #3 must produce a usable driver.
patch #2 + #3 (missing patch #1) need not produce a usable driver.

This is analogous to a mathematical proof:  each step in the proof
describes a complete equation.

Therefore, to move forward, I would suggest that you break up your
submitted patch into multiple patches, ordered such that the PCI
bridge-related code is in the final patch.  This permits me to
immediately merge patches not related to PCI bridge stuff, while
simultaneously discussing the hard reset/bridge change.

Note that this is standard iterative development:

	1. 'stex' driver development, testing.
	2. Post a set of 'stex' patches.
	3. Community reviews patches.
	4. Upstream maintainer merges some or all of the patches.
	5. Go to step #1, perhaps to resend (changed or unchanged)
	   the patches that were not merged.

Regards,

	Jeff



