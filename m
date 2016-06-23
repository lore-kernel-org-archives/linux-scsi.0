From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] byteswap: try to avoid __builtin_constant_p gcc bug
Date: Thu, 23 Jun 2016 11:29:18 +0200
Message-ID: <3921705.19HEvQgj2d@wuerfel>
References: <1780465.XdtPJpi8Tt@wuerfel> <7892604.CjmUVh55Wd@wuerfel> <CA+i0qc4z2aNHQ+WcCJ7uz9pt9WCseQ-B_x7D0baMYduDcsV8Rw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:49766 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbcFWJ2b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jun 2016 05:28:31 -0400
In-Reply-To: <CA+i0qc4z2aNHQ+WcCJ7uz9pt9WCseQ-B_x7D0baMYduDcsV8Rw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Winkler <tomasw@gmail.com>
Cc: "Levy, Amir (Jer)" <amir.jer.levy@intel.com>, Andrew Morton <akpm@linux-foundation.org>, "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jpoimboe@redhat.com" <jpoimboe@redhat.com>, Martin Jambor <mjambor@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Denys Vlasenko <dvlasenk@redhat.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@kernel.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>, Jan Hubicka <hubicka@ucw.cz>

On Thursday, June 23, 2016 9:27:30 AM CEST Tomas Winkler wrote:
> On Wed, Jun 22, 2016 at 3:25 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Wednesday, June 22, 2016 2:44:21 PM CEST Tomas Winkler wrote:
> >> >
> >> > There are more than 20 files that have the statement: case cpu_to_...
> >> > Sparse complains about: case __builtin_bswap, not about __builtin_constant_p.
> >>
> >> There is even much more in the header files used in  initializers,
> >> which also require constants.  I wonder if __builtin_bswap produces
> >> constant expression correctly under gcc?
> >
> > In gcc-4.8 or later yes. gcc-4.6/4.7 on powerpc was a special case that we
> > have worked around now, as the 16-bit byteswap there was not a constant
> > expression, unlike the 32-bit and 64-bit ones.
> 
> Can you please give any references to that?

The patch description for the last change has a good explanation:

commit 8634de6d254462e6953b7dac772a1df4f44c8030
Author: Josh Poimboeuf <jpoimboe@redhat.com>
Date:   Fri May 6 09:22:25 2016 -0500

    compiler-gcc: require gcc 4.8 for powerpc __builtin_bswap16()
    
    gcc support for __builtin_bswap16() was supposedly added for powerpc in
    gcc 4.6, and was then later added for other architectures in gcc 4.8.
    
    However, Stephen Rothwell reported that attempting to use it on powerpc
    in gcc 4.6 fails with:
    
      lib/vsprintf.c:160:2: error: initializer element is not constant
      lib/vsprintf.c:160:2: error: (near initialization for 'decpair[0]')
      lib/vsprintf.c:160:2: error: initializer element is not constant
      lib/vsprintf.c:160:2: error: (near initialization for 'decpair[1]')
      ...
    
    I'm not entirely sure what those errors mean, but I don't see them on
    gcc 4.8.  So let's consider gcc 4.8 to be the official starting point
    for __builtin_bswap16().
    
    Arnd Bergmann adds:
     "I found the commit in gcc-4.8 that replaced the powerpc-specific
      implementation of __builtin_bswap16 with an architecture-independent
      one.  Apparently the powerpc version (gcc-4.6 and 4.7) just mapped to
      the lhbrx/sthbrx instructions, so it ended up not being a constant,
      though the intent of the patch was mainly to add support for the
      builtin to x86:
    
        https://gcc.gnu.org/bugzilla/show_bug.cgi?id=52624
    
      has the patch that went into gcc-4.8 and more information."
    
    Fixes: 7322dd755e7d ("byteswap: try to avoid __builtin_constant_p gcc bug")
    Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Acked-by: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
    Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

 include/linux/compiler-gcc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


> Just to make sure we are on the same line , the  bottom line is that
> sparse has to be adjusted.

Yes, that sounds right. I don't know if sparse actually tracks the
value of the constant, or if it's good enough for sparse to know that
a constant input to __builtin_bswap results in a constant output.
If that is the case, we could just #define __builtin_bswap32(x) (x)
in the kernel headers when building with sparse, and have it work
for older sparse versions too.

	Arnd
