From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: btrfs zero divide
Date: Wed, 14 Aug 2013 10:40:39 +0200
Message-ID: <CAMuHMdXu+j03r_TQWC74e1dZzi6n9DsdBj_gRfrznW-VzzyTHQ@mail.gmail.com>
References: <Pine.BSM.4.64L.1307300820160.20675@herc.mirbsd.org>
	<alpine.DEB.2.02.1307301052010.23107@ayla.of.borg>
	<20130730171329.GF24583@localhost.localdomain>
	<Pine.BSM.4.64L.1307301741360.20305@herc.mirbsd.org>
	<20130730204001.GG24583@localhost.localdomain>
	<87eha33v9f.fsf@igel.home>
	<20130809180441.GB12314@lenny.home.zabbo.net>
	<alpine.DEB.2.02.1308131714130.12565@ayla.of.borg>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:58505 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759410Ab3HNIkj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2013 04:40:39 -0400
In-Reply-To: <alpine.DEB.2.02.1308131714130.12565@ayla.of.borg>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zach Brown <zab@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>, Josef Bacik <jbacik@fusionio.com>, Thorsten Glaser <tg@mirbsd.de>, Joe Perches <joe@perches.com>, Debian GNU/Linux m68k <debian-68k@lists.debian.org>, linux-btrfs@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, David Woodhouse <David.Woodhouse@intel.com>, Chris Mason <chris.mason@fusionio.com>, scsi <linux-scsi@vger.kernel.org>

On Tue, Aug 13, 2013 at 6:32 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Fri, 9 Aug 2013, Zach Brown wrote:
>> On Fri, Aug 09, 2013 at 02:26:36PM +0200, Andreas Schwab wrote:
>> > Josef Bacik <jbacik@fusionio.com> writes:
>> >
>> > > So stripe_len shouldn't be 0, if it is you have bigger problems :).
>> >
>> > The bigger problem is that stripe_nr is u64, this is completely bogus.
>> > The first operand of do_div must be u32.  This goes through the whole
>> > file.
>
> This was introduced by commit 53b381b3abeb86f12787a6c40fee9b2f71edc23b
> ("Btrfs: RAID5 and RAID6"), which changed the divisor from
> map->stripe_len (struct map_lookup.stripe_len is int) to a 64-bit
> temporary.
>
>> Definitely.  Can we get some typeof() tricks in the macros to have the
>> build fail if (when, evidently) someone gets it wrong?
>
> Not using typeof, as there are way too many callsites where int is used
> instead of u32.
>
> However, checking that sizeof() equals to 4 seems to work.
> Below is a patch for asm-generic, which is untested, but it works when
> adding the same checks to arch/m68k/include/asm/div64.h
>
> This is not something we just want to drop in, as it has the potential of
> breaking lots of things (yes, it breaks btrfs :-)

Found so far:
  - Several calls to sector_div() in blkdev_issue_discard()
  - Two calls to do_div() in sd_completed_bytes()

Some of these even operate on dividends that never exceed 32-bit, tss...

> >From 7ccabf41beae38da514f3e09624219a9362375d7 Mon Sep 17 00:00:00 2001
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> Date: Tue, 13 Aug 2013 18:04:40 +0200
> Subject: [PATCH] asm-generic: Check divisor size in do_div()
>
> The second parameter of do_div() should be a 32-bit number.
> Enforce this using BUILD_BUG_ON().
>
> The first parameter of do_div() should be a 64-bit number,
> enforce this on 64-bit architectures, just like is done on 32-bit
> architectures.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  include/asm-generic/div64.h |    4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/include/asm-generic/div64.h b/include/asm-generic/div64.h
> index 8f4e319..69c0307 100644
> --- a/include/asm-generic/div64.h
> +++ b/include/asm-generic/div64.h
> @@ -19,12 +19,15 @@
>
>  #include <linux/types.h>
>  #include <linux/compiler.h>
> +#include <linux/bug.h>
>
>  #if BITS_PER_LONG == 64
>
>  # define do_div(n,base) ({                                     \
>         uint32_t __base = (base);                               \
>         uint32_t __rem;                                         \
> +       (void)(((typeof((n)) *)0) == ((uint64_t *)0));          \
> +       BUILD_BUG_ON(sizeof(base) != 4);                        \
>         __rem = ((uint64_t)(n)) % __base;                       \
>         (n) = ((uint64_t)(n)) / __base;                         \
>         __rem;                                                  \
> @@ -41,6 +44,7 @@ extern uint32_t __div64_32(uint64_t *dividend, uint32_t divisor);
>         uint32_t __base = (base);                       \
>         uint32_t __rem;                                 \
>         (void)(((typeof((n)) *)0) == ((uint64_t *)0));  \
> +       BUILD_BUG_ON(sizeof(base) != 4);                \
>         if (likely(((n) >> 32) == 0)) {                 \
>                 __rem = (uint32_t)(n) % __base;         \
>                 (n) = (uint32_t)(n) / __base;           \
> --
> 1.7.9.5

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
