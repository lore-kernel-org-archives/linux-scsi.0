From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: btrfs zero divide
Date: Wed, 14 Aug 2013 10:56:40 +0200
Message-ID: <CAMuHMdV-nBbhKbVSAAwh5M45-7kz4RJRqfHrCfudRA5dE2CKoA@mail.gmail.com>
References: <Pine.BSM.4.64L.1307300820160.20675@herc.mirbsd.org>
	<alpine.DEB.2.02.1307301052010.23107@ayla.of.borg>
	<20130730171329.GF24583@localhost.localdomain>
	<Pine.BSM.4.64L.1307301741360.20305@herc.mirbsd.org>
	<20130730204001.GG24583@localhost.localdomain>
	<87eha33v9f.fsf@igel.home>
	<20130809180441.GB12314@lenny.home.zabbo.net>
	<alpine.DEB.2.02.1308131714130.12565@ayla.of.borg>
	<CAMuHMdXu+j03r_TQWC74e1dZzi6n9DsdBj_gRfrznW-VzzyTHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdXu+j03r_TQWC74e1dZzi6n9DsdBj_gRfrznW-VzzyTHQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zach Brown <zab@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>, Josef Bacik <jbacik@fusionio.com>, Thorsten Glaser <tg@mirbsd.de>, Joe Perches <joe@perches.com>, Debian GNU/Linux m68k <debian-68k@lists.debian.org>, linux-btrfs@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, David Woodhouse <David.Woodhouse@intel.com>, Chris Mason <chris.mason@fusionio.com>, scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 14, 2013 at 10:40 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Tue, Aug 13, 2013 at 6:32 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Fri, 9 Aug 2013, Zach Brown wrote:
>>> On Fri, Aug 09, 2013 at 02:26:36PM +0200, Andreas Schwab wrote:
>>> > Josef Bacik <jbacik@fusionio.com> writes:
>>> >
>>> > > So stripe_len shouldn't be 0, if it is you have bigger problems :).
>>> >
>>> > The bigger problem is that stripe_nr is u64, this is completely bogus.
>>> > The first operand of do_div must be u32.  This goes through the whole
>>> > file.
>>
>> This was introduced by commit 53b381b3abeb86f12787a6c40fee9b2f71edc23b
>> ("Btrfs: RAID5 and RAID6"), which changed the divisor from
>> map->stripe_len (struct map_lookup.stripe_len is int) to a 64-bit
>> temporary.
>>
>>> Definitely.  Can we get some typeof() tricks in the macros to have the
>>> build fail if (when, evidently) someone gets it wrong?
>>
>> Not using typeof, as there are way too many callsites where int is used
>> instead of u32.
>>
>> However, checking that sizeof() equals to 4 seems to work.
>> Below is a patch for asm-generic, which is untested, but it works when
>> adding the same checks to arch/m68k/include/asm/div64.h
>>
>> This is not something we just want to drop in, as it has the potential of
>> breaking lots of things (yes, it breaks btrfs :-)
>
> Found so far:
>   - Several calls to sector_div() in blkdev_issue_discard()
>   - Two calls to do_div() in sd_completed_bytes()
>
> Some of these even operate on dividends that never exceed 32-bit, tss...

Two more:
 drivers/md/dm-cache-target.c:too_many_discard_blocks
 fs/jfs/jfs_dmap.c:dbDiscardAG

These bring in the 64-bit divisor from somewhere else, so they're less
trivial to fix.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
