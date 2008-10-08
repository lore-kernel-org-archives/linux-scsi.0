From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [RFC] Normalizing byteorder/unaligned access API
Date: Wed, 8 Oct 2008 09:13:09 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0810080908480.19202@anakin>
References: <1223416391.8195.22.camel@brick>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754371AbYJHHNX@vger.kernel.org>
In-Reply-To: <1223416391.8195.22.camel@brick>
Sender: linux-kernel-owner@vger.kernel.org
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <matthew@wil.cx>, linux-scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 7 Oct 2008, Harvey Harrison wrote:
> [related question regarding the SCSI-private endian helper needs at the end]
> 
> Currently on the read side, we have (le16 as an example endianness)
> 
> le16_to_cpup(__le16 *)
> get_unaligned_le16(void *)
> 
> And on the write side:
> 
> *(__le16)ptr = cpu_to_le16(u16)
> put_unaligned_le16(u16, void *);
> 
> On the read side, Al said he would have preferred the unaligned version
> take the same types as the aligned, rather than void *.  AKPM didn't think

As I said before, me too (take the same types as the aligned). I like to
rely on sparse for:

    struct {
	...
	__le32 x;
	...
    } s __attribute__ ((packed));

get_unaligned_le16(&s.x);

> the use of get_ was that great as get/put generally implies some kind of reference
> taking in the kernel.

OK.

> As the le16_to_cpup has been around for so long and is more recognizable, let's
> make it the same for the unaligned case and typesafe:
> 
> le16_to_cpup(__le16 *)
> unaligned_le16_to_cpup(__le16 *)

I always hated that naming...

> On the write side, the above get/put and type issues are still there, in addition AKPM felt
> that the ordering of the put_unaligned parameters was opposite what was intuitive and that
> the pointer should come first.
> 
> In this case, as there is currently no aligned helper (other than in some drivers defining macros)
> define the api thusly:
> 
> Aligned:
> write_le16(__le16 *ptr, u16 val)
> 
> Unaligned:
> unaligned_write_le16(__le16 *ptr, u16 val)

Does it write to MMIO I/O space? No? Then please don't use write (like
in writeb()).

What about load_{unaligned_,}le16() and store_{unaligned_,}le16()?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
