From: Hugh Dickins <hugh@veritas.com>
Subject: Re: Fw: crash on x86_64 - mm related?
Date: Wed, 7 Dec 2005 18:37:22 +0000 (GMT)
Message-ID: <Pine.LNX.4.61.0512071803300.2975@goblin.wat.veritas.com>
References: <Pine.LNX.4.63.0512012040390.5777@kai.makisara.local>
 <Pine.LNX.4.64.0512011136000.3099@g5.osdl.org> <20051201195657.GB7236@tau.solarneutrino.net>
 <Pine.LNX.4.61.0512012008420.28450@goblin.wat.veritas.com>
 <20051202180326.GB7634@tau.solarneutrino.net>
 <Pine.LNX.4.61.0512021856170.4940@goblin.wat.veritas.com>
 <20051202194447.GA7679@tau.solarneutrino.net>
 <Pine.LNX.4.61.0512022037230.6058@goblin.wat.veritas.com>
 <20051206160815.GC11560@tau.solarneutrino.net>
 <Pine.LNX.4.61.0512062025230.28217@goblin.wat.veritas.com>
 <20051206204336.GA12248@tau.solarneutrino.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from silver.veritas.com ([143.127.12.111]:25655 "EHLO
	silver.veritas.com") by vger.kernel.org with ESMTP id S1751732AbVLGSiT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Dec 2005 13:38:19 -0500
Received: from linux.wat.veritas.com([10.10.97.50]) (3409 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1Ek4AP-0001J4C@megami.veritas.com>
	for <linux-scsi@vger.kernel.org>; Wed, 7 Dec 2005 10:37:25 -0800 (PST)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
In-Reply-To: <20051206204336.GA12248@tau.solarneutrino.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ryan Richter <ryan@tau.solarneutrino.net>
Cc: Linus Torvalds <torvalds@osdl.org>, Kai Makisara <Kai.Makisara@kolumbus.fi>, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 6 Dec 2005, Ryan Richter wrote:
> On Tue, Dec 06, 2005 at 08:31:43PM +0000, Hugh Dickins wrote:
> > Thanks for the further report.  And you had my st.c patch in along
> > with 2.6.14.3, but it still happened, very much like before (except the
> > latter errors, general protection fault onwards - but once we get into
> > using one page for two uses at the same time, anything can go wrong).
> > 
> > I've been staring and thinking, but no inspiration yet.
> 
> That's correct, thanks for looking.  Let me know if there's anything I
> could do get more information.

Still no luck with it, I'm afraid: I've found no error in st.c,
beyond what the patch already fixed, to account for what you see.

I have noticed that struct st_buffer's unsigned char do_dio ought to be
unsigned short, in order to accommodate its maximum value of 256; but
that would not account for your symptoms, nor does taper approach that
maximum.

The symptoms are consistent with that do_dio field (near the start of
struct st_buffer) being corrupted, infrequently but repeatedly - the
same page has been mis-released three times before your first error
message.  But I see nothing wrong with st.c's handling of do_dio,
nor with get_user_pages' returned count.

So I think the best I can suggest is that you rebuild your kernel with
CONFIG_DEBUG_SLAB=y, and see if that sheds any light.  And if you don't
mind doing so, advancing to 2.6.15-rc5 (which includes my patch) with
CONFIG_DEBUG_SLAB=y would be even better: there's a chance it's a bug
that's already been fixed.  Though that won't really be proved if you
don't hit the problem, since the new kernel will be sufficiently
different that it might just have shifted the bug aside.

To be honest, the symptoms seem a little too regular to blame someone
overrunning their slab; but I've searched in vain and must move on.

Hugh
