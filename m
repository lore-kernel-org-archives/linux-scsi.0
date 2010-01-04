From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] libsrp: fix compile failure
Date: Mon, 04 Jan 2010 13:37:17 -0600
Message-ID: <1262633838.2724.218.camel@mulgrave.site>
References: <1262200866.2749.226.camel@mulgrave.site>
	 <alpine.LFD.2.00.0912301132260.11961@localhost.localdomain>
	 <alpine.LRH.2.00.1001041619130.15694@twin.jikos.cz>
	 <1262625721.2724.158.camel@mulgrave.site>
	 <20100104173530.48690e39@lxorguk.ukuu.org.uk>
	 <1262633054.4814.21.camel@wall-e>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47294 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871Ab0ADTha (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Jan 2010 14:37:30 -0500
In-Reply-To: <1262633054.4814.21.camel@wall-e>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefani Seibold <stefani@seibold.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jiri Kosina <jkosina@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2010-01-04 at 20:24 +0100, Stefani Seibold wrote:
> Am Montag, den 04.01.2010, 17:35 +0000 schrieb Alan Cox:
> > > least once before it goes to Linus.  There were originally technical
> > > reasons why -mm wasn't in ... I just thought they'd been fixed by now.
> > 
> > No - mm also caused problems with the kfifo merge of a core API change
> > that didn't go via -next.
> > 
> > Alan
> 
> I tried my best to port everything to the new kfifo API. But it was not
> possible to check it against every architecture.

That's what linux-next is for:  to make at least this compile checking
against all of our architectures more of a reality.  It's still missing
bits, and some of the ports (*cough* parisc *cough*) compile against
linux-next rather infrequently, but it's far better than nothing.

>  x86 and x86_64 was
> compile clean. I think the missing #include was not a big thing.

It's easily fixable, yes ... breaking the build *is* a pretty big thing
because of the fallout it causes (for ppc: about ~100 instant WTF
moments followed by grubbing around in git to find the cause).

It's also an indicator of future problems.  Realistically, all API
changes should go into linux-next both to prevent this sort of thing
from happening and to see if we have any other pending conflicts that
may cause problems.

James


