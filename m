From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: This patch triggers a bad gcc bug (was Re: [PATCH] force
 inlining of some byteswap operations)
Date: Wed, 13 Apr 2016 12:10:58 -0500
Message-ID: <20160413171058.24tnvvquvnipnwnd@treble>
References: <1454615136-32308-1-git-send-email-dvlasenk@redhat.com>
 <1454615136-32308-2-git-send-email-dvlasenk@redhat.com>
 <20160413033649.7r3msnmo3trtq47z@treble>
 <570E37A9.2050503@redhat.com>
 <20160413123607.3y3v5esq3myto4kc@treble>
 <20160413151500.tate3u6trg4agugo@treble>
 <1460566509.2322.14.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbcDMRLD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2016 13:11:03 -0400
Content-Disposition: inline
In-Reply-To: <1460566509.2322.14.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Apr 13, 2016 at 09:55:09AM -0700, James Bottomley wrote:
> On Wed, 2016-04-13 at 10:15 -0500, Josh Poimboeuf wrote:
> > On Wed, Apr 13, 2016 at 07:36:07AM -0500, Josh Poimboeuf wrote:
> > > On Wed, Apr 13, 2016 at 02:12:25PM +0200, Denys Vlasenko wrote:
> > > > On 04/13/2016 05:36 AM, Josh Poimboeuf wrote:
> > > > > On Thu, Feb 04, 2016 at 08:45:35PM +0100, Denys Vlasenko wrote:
> > > > > > Sometimes gcc mysteriously doesn't inline
> > > > > > very small functions we expect to be inlined. See
> > > > > >     https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66122
> > > > > > 
> > > > > > With this .config:
> > > > > > http://busybox.net/~vda/kernel_config_OPTIMIZE_INLINING_and_O
> > > > > > s,
> > > > > > the following functions get deinlined many times.
> > > > > > Examples of disassembly:
> > > > > > 
> > > > > > <get_unaligned_be16> (12 copies, 51 calls):
> > > > > >        66 8b 07                mov    (%rdi),%ax
> > > > > >        55                      push   %rbp
> > > > > >        48 89 e5                mov    %rsp,%rbp
> > > > > >        86 e0                   xchg   %ah,%al
> > > > > >        5d                      pop    %rbp
> > > > > >        c3                      retq
> > > > ...
> > > > > > This patch fixes this via s/inline/__always_inline/.
> > > > > > Code size decrease after the patch is ~4.5k:
> > > > > > 
> > > > > >     text     data      bss       dec     hex filename
> > > > > > 92202377 20826112 36417536 149446025 8e85d89 vmlinux
> > > > > > 92197848 20826112 36417536 149441496 8e84bd8
> > > > > > vmlinux5_swap_after
> > > > > > 
> > > > > > Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> > > > > > Cc: Ingo Molnar <mingo@kernel.org>
> > > > > > Cc: Thomas Graf <tgraf@suug.ch>
> > > > > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > > > > Cc: David Rientjes <rientjes@google.com>
> > > > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > > > Cc: linux-kernel@vger.kernel.org
> > > > > > ---
> > > > > >  include/uapi/linux/byteorder/big_endian.h    | 24
> > > > > > ++++++++++++------------
> > > > > >  include/uapi/linux/byteorder/little_endian.h | 24
> > > > > > ++++++++++++------------
> > > > > >  include/uapi/linux/swab.h                    | 10 +++++-----
> > > > > >  3 files changed, 29 insertions(+), 29 deletions(-)
> > > > > 
> > > > > Hi,
> > > > > 
> > > > > This patch seems to trigger a gcc bug which can produce corrupt
> > > > > code.  I
> > > > > discovered it when investigating an objtool warning reported by
> > > > > kbuild
> > > > > bot:
> > > > > 
> > > > >   http://www.spinics.net/lists/linux-scsi/msg95481.html
> > > > > 
> > > > > From the disassembly of drivers/scsi/qla2xxx/qla_attr.o:
> > > > > 
> > > > > 0000000000002f53 <qla2x00_get_host_fabric_name>:
> > > > >     2f53:       55                      push   %rbp
> > > > >     2f54:       48 89 e5                mov    %rsp,%rbp
> > > > > 
> > > > > 0000000000002f57 <qla2x00_get_fc_host_stats>:
> > > > >     2f57:       55                      push   %rbp
> > > > >     2f58:       b9 e8 00 00 00          mov    $0xe8,%ecx
> > > > >     2f5d:       48 89 e5                mov    %rsp,%rbp
> > > > > ...
> > > > > 
> > > > > Note that qla2x00_get_host_fabric_name() is inexplicably
> > > > > truncated after
> > > > > setting up the frame pointer.  It falls through to the next
> > > > > function, which is
> > > > > very wrong.
> > > > 
> > > > Wow, that's ... interesting.
> > > > 
> > > > 
> > > > > I can recreate it with either gcc 5.3.1 or gcc 6.0 on
> > > > > linus/master with
> > > > > the .config from the above link.
> > > > > 
> > > > > The call chain which appears to trigger the problem is:
> > > > > 
> > > > > qla2x00_get_host_fabric_name()
> > > > >   wwn_to_u64()
> > > > >     get_unaligned_be64()
> > > > >       be64_to_cpup()
> > > > >         __be64_to_cpup() <- changed to __always_inline by this
> > > > > patch
> > > > > 
> > > > > It occurs with the combination of the following two recent
> > > > > commits:
> > > > > 
> > > > > - bc27fb68aaad ("include/uapi/linux/byteorder, swab: force
> > > > > inlining of some byteswap operations")
> > > > > - ef3fb2422ffe ("scsi: fc: use get/put_unaligned64 for wwn
> > > > > access")
> > > > > 
> > > > > I can confirm that reverting either patch makes the problem go
> > > > > away.
> > > > > I'm planning on opening a gcc bug tomorrow.
> > > > 
> > > > 
> > > > Note that if CONFIG_OPTIMIZE_INLINING is not set, _all_ "inline"
> > > > keywords are in fact __always_inline, so the bug must be
> > > > triggering
> > > > even without the patch.
> > > 
> > > Makes sense in theory, but the bug doesn't actually trigger when I
> > > revert the patch and set CONFIG_OPTIMIZE_INLINING=n.
> > > 
> > > Perhaps even more surprising, it doesn't trigger *with* the patch
> > > and
> > > CONFIG_OPTIMIZE_INLINING=n.
> > 
> > [ Adding James to CC since this bug affects scsi. ]
> > 
> > Here's the gcc bug:
> > 
> >   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=70646
> > 
> 
> 
> Actually, adding me doesn't help, I've added linux-scsi.  The summary
> is that there's a but in gcc-5.3.1 which is miscompiling qla_attr.c ...
> this means we're going to have to ask the compiler version of reported
> crashes.

The bug isn't specific to a compiler version.  I've seen it with gcc
5.3.1 and gcc 6.0.  I haven't tried any older versions.  And the gcc bug
hasn't been resolved (or even investigated) yet.

The bug is triggered by a combination of the above two commits from the
4.6 merge window, so presumably we'd need to revert one of them to avoid
crashes in 4.6.

-- 
Josh
