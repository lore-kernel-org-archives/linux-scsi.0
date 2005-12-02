From: Hugh Dickins <hugh@veritas.com>
Subject: Re: Fw: crash on x86_64 - mm related?
Date: Fri, 2 Dec 2005 13:45:04 +0000 (GMT)
Message-ID: <Pine.LNX.4.61.0512021325020.1507@goblin.wat.veritas.com>
References: <20051129092432.0f5742f0.akpm@osdl.org>
 <Pine.LNX.4.63.0512012040390.5777@kai.makisara.local>
 <Pine.LNX.4.64.0512011136000.3099@g5.osdl.org> <1133468882.5232.14.camel@mulgrave>
 <Pine.LNX.4.63.0512012304240.5777@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gold.veritas.com ([143.127.12.110]:41013 "EHLO gold.veritas.com")
	by vger.kernel.org with ESMTP id S1750729AbVLBNpf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2005 08:45:35 -0500
Received: from linux.wat.veritas.com([10.10.97.50]) (3451 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1EiBDh-0001FaC@megami.veritas.com>
	for <linux-scsi@vger.kernel.org>; Fri, 2 Dec 2005 05:45:01 -0800 (PST)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
In-Reply-To: <Pine.LNX.4.63.0512012304240.5777@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linus Torvalds <torvalds@osdl.org>, Ryan Richter <ryan@tau.solarneutrino.net>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 1 Dec 2005, Kai Makisara wrote:
> On Thu, 1 Dec 2005, James Bottomley wrote:
> > 
> > On a side note, I have Kai's patch in the scsi-rc-fixes tree which I'm
> > getting ready to push.  Can we get a consensus on whether it should be
> > removed before I merge upwards?

I too need to decide whether to base my little sg.c,st.c patchset
on top of Kai's (as I see in 2.6.15-rc3-mm1, I presume) or on top
of 2.6.15-rc4.

> I think it should be removed because it is based partly on a wrong 
> assumption: asynchronous writes are _not_ done together with direct i/o. 
> (I have also experimentally verified that this does not happen.)

I'm assuming from this that I'd best base on 2.6.15-rc4;
but by all means overrule me if you've changed your mind.

> The patch includes the patch I sent sent to linux-scsi on Nov 21. Nobody 
> has commented it and I don't know if the user pages have to be explicitly 
> marked dirty after the HBA has read data there. If they have to, then this 
> earlier patch is valid.

What I see in 2.6.15-rc3-mm1 looks like three patches.

One to do with resetting sg_segs to 0 at various points:
I've no appreciation of that patch at all.  If it would help you for
me to add that into my little set, please send me a comment for it.

One to add an "is_read" argument to release_buffering.  Yes, that's
a part of my set too, though in my case called "dirtied" (and I believe
that the call at the end of st_read can say 0, because that's just for
an error path: when it's really dirtied user memory, it'll be read_tape
that does the release_buffering).  sg.c was always saying dirtied, even
when writing from memory; st.c was always saying not dirtied, even when
reading into memory.  Usually the latter is okay, get_user_pages has
said dirty in advance; but under pressure there's a window whereby it's
not good enough.  And SetPageDirty can be counter-productive these days,
so your patch is incomplete in that regard: I'll explain more in mine.

One to move around where release_buffering is called from:
that's the part you've decided was wrong, or at least unnecessary.

> If not, I will send a patch for 2.6.16 to remove the latent code.

I didn't understand that bit, but I probably don't need to.

Hugh
