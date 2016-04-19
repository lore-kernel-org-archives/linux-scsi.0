From: Ingo Molnar <mingo@kernel.org>
Subject: Re: This patch triggers a bad gcc bug (was Re: [PATCH] force
 inlining of some byteswap operations)
Date: Tue, 19 Apr 2016 10:52:21 +0200
Message-ID: <20160419085221.GA29087@gmail.com>
References: <1460566509.2322.14.camel@HansenPartnership.com>
 <20160413171058.24tnvvquvnipnwnd@treble>
 <570FB742.2010309@redhat.com>
 <20160414155708.upka6phfvwpbp6zw@treble>
 <570FCEB7.1070200@redhat.com>
 <20160415054518.GA28079@gmail.com>
 <20160415134745.wxb73xemv2tqib5m@treble>
 <20160415222037.wu4n6w2yedxdzfle@treble>
 <20160416090332.GA30613@gmail.com>
 <20160418133932.cnpxai32qn665un3@treble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:32987 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbcDSIw0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2016 04:52:26 -0400
Content-Disposition: inline
In-Reply-To: <20160418133932.cnpxai32qn665un3@treble>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-scsi <linux-scsi@vger.kernel.org>, jamborm@gcc.gnu.org


* Josh Poimboeuf <jpoimboe@redhat.com> wrote:

> On Sat, Apr 16, 2016 at 11:03:32AM +0200, Ingo Molnar wrote:
> > 
> > * Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > 
> > > > I don't think we know yet if there's a reliable way to turn the bug off.
> > > > 
> > > > Also, according to the gcc guys, this bug won't always result in a
> > > > truncated function, and may sometimes just make some inline function
> > > > call sites disappear:
> > > > 
> > > >   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=70646#c14
> > > > 
> > > > though I haven't been able to confirm that experimentally.  But if it's
> > > > true, that means that objtool won't be able to detect all cases of the
> > > > bug and some function calls may just silently disappear!
> > > > 
> > > > There's a lot of activity in the bug now, so hopefully they'll be able
> > > > to tell us soon if there's a reliable way to avoid it and/or detect it.
> > > > 
> > > > BTW, Denys posted a workaround patch for the qla2xxxx code:
> > > > 
> > > >   https://lkml.kernel.org/r/1460716583-15673-1-git-send-email-dvlasenk@redhat.com
> > > 
> > > Martin Jambor wrote a succinct summary of the conditions needed for this
> > > bug:
> > > 
> > >   "This bug can occur when an inlineable function containing a call to
> > >   __builtin_constant_p, which checks a parameter or a value it
> > >   references and a (possibly indirect) caller of the function actually
> > >   passes a constant, but stores it using a type of a different size."
> > > 
> > > So to prevent it from happening elsewhere in the kernel, it sounds like
> > > we'd have to either remove all uses of __builtin_constant_p() or disable
> > > inlining completely.
> > > 
> > > There's also no reliable way to detect the bug has occurred, though
> > > objtool will detect it in cases when the function gets truncated.
> > 
> > So it appears to me that due to the hard to detect nature of the GCC bug the fix 
> > will probably be backported by them, so I think we should be fine with relying on 
> > objtool to detect weird code sequences in the kernel, and should work around 
> > specific instances of the bug.
> 
> I agree.  So how should we work around the bug in this case?  There have
> been several suggestions:
> 
> - change wwn_to_u64() to __always_inline
> 
> - change qla2x00_get_host_fabric_name() to skip the unnecessary call to
>   wwn_to_u64()
> 
> - revert one of the two commits:
>   bc27fb68aaad ("include/uapi/linux/byteorder, swab: force inlining of some byteswap operations")
>   ef3fb2422ffe ("scsi: fc: use get/put_unaligned64 for wwn access")

The first option sounds like the best one by far: it does a change that is related 
to the GCC bug (tweaks inlining), has near zero impact and does not revert other 
useful progress.

Thanks,

	Ingo
