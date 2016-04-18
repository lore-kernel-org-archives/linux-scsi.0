From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: This patch triggers a bad gcc bug (was Re: [PATCH] force inlining of some byteswap operations)
Date: Mon, 18 Apr 2016 16:21:42 +0200
Message-ID: <5175460.GbO2sgX9fL@wuerfel>
References: <20160413151500.tate3u6trg4agugo@treble> <4545519.Kr6IHPvbv3@wuerfel> <20160418141241.gcgfawrtnmfamz6t@treble>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:59235 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbcDROWe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Apr 2016 10:22:34 -0400
In-Reply-To: <20160418141241.gcgfawrtnmfamz6t@treble>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, jamborm@gcc.gnu.org

On Monday 18 April 2016 09:12:41 Josh Poimboeuf wrote:
> On Mon, Apr 18, 2016 at 04:07:51PM +0200, Arnd Bergmann wrote:
> > On Monday 18 April 2016 08:39:32 Josh Poimboeuf wrote:
> > > 
> > > I agree.  So how should we work around the bug in this case?  There have
> > > been several suggestions:
> > > 
> > > - change wwn_to_u64() to __always_inline
> > > 
> > > - change qla2x00_get_host_fabric_name() to skip the unnecessary call to
> > >   wwn_to_u64()
> > > 
> > > - revert one of the two commits:
> > >   bc27fb68aaad ("include/uapi/linux/byteorder, swab: force inlining of some byteswap operations")
> > >   ef3fb2422ffe ("scsi: fc: use get/put_unaligned64 for wwn access")
> > 
> > What about the patch to change get_unaligned_be64() that I posted?
> > 
> > I think we want to merge that anyway, I just don't know if that helps
> > with this particular problem as well.
> 
> I replied to your other email about that -- it doesn't seem to help this
> issue.
> 

Ok, I see. I had problems with my mail server last week, your reply
must have been a victim of that as I never saw it (found it on the
web archive now).

I'd vote for the wwn_to_u64 change then as it should prevent the
same thing from happining in other drivers. I would prefer not to
see ef3fb2422ffe reverted, as that works around another gcc-6 bug
on ARM.

	Arnd
