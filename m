From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] target updates for v3.17-rc3
Date: Sun, 31 Aug 2014 17:51:07 -0700
Message-ID: <CA+55aFx6_pbUwuyhYYSu+=eAA+7o0LDu251Bo7T2ZYo9vZc1kg@mail.gmail.com>
References: <1409511586.1483.5.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1409511586.1483.5.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Aug 31, 2014 at 11:59 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>
> Note that these patches where originally intended for -rc1, but misse=
d
> the merge window.  They are mostly iser-target related bug-fixes, alo=
ng
> with a few other very minor cleanups.

So this pull request was strictly speaking too late for rc3, but I
went "what the hell, it's small" and pulled it anyway.

And then I get this:

  drivers/target/target_core_transport.c: In function
=E2=80=98transport_dump_vpd_ident_type=E2=80=99:
  drivers/target/target_core_transport.c:956:3: warning: passing
argument 1 of =E2=80=98strlen=E2=80=99 makes pointer from integer witho=
ut a cast
[enabled by default]
     len =3D strlen(len);
     ^
  In file included from include/linux/bitmap.h:8:0,
                   from include/linux/cpumask.h:11,
                   from ./arch/x86/include/asm/cpumask.h:4,
                   from ./arch/x86/include/asm/msr.h:10,
                   from ./arch/x86/include/asm/processor.h:20,
                   from ./arch/x86/include/asm/archrandom.h:26,
                   from include/linux/random.h:81,
                   from include/linux/net.h:22,
                   from drivers/target/target_core_transport.c:26:
  include/linux/string.h:80:24: note: expected =E2=80=98const char *=E2=
=80=99 but
argument is of type =E2=80=98int=E2=80=99
   extern __kernel_size_t strlen(const char *);
                          ^

and I just go "Yeah, that broken crap can wait until 3.18 after all".

So it got unpulled.

That "strlen(len)" should clearly be a "strlen(buf)" in that commit
6cfa853ceee4, but equally clearly this pull request was pure and utter
garbage, and that "cleanup" commit was shit that nobody had ever even
bothered to compile.

Thanks, but no. And please never send this kind of untested crap to me =
again,

                   Linus
