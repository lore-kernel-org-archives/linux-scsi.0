From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: Race to power off harming SATA SSDs
Date: Mon, 8 May 2017 13:48:07 +0200
Message-ID: <20170508134807.498b3ee7@bbrezillon>
References: <20170410232118.GA4816@khazad-dum.debian.net>
        <20170410235206.GA28603@wtj.duckdns.org>
        <20170507204007.GA25628@atrey.karlin.mff.cuni.cz>
        <1494228094.6528.14.camel@infradead.org>
        <20170508092846.GA11029@amd>
        <1494236048.6528.32.camel@infradead.org>
        <20170508104953.GA17773@amd>
        <CAFLxGvzAmURHU_6K3gmBfOqHKgvQOkkO_+qgMKsmzhWZwwGnqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFLxGvzAmURHU_6K3gmBfOqHKgvQOkkO_+qgMKsmzhWZwwGnqw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, David Woodhouse <dwmw2@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hans de Goede <hdegoede@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 8 May 2017 13:06:17 +0200
Richard Weinberger <richard.weinberger@gmail.com> wrote:

> On Mon, May 8, 2017 at 12:49 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > Aha, nice, so it looks like ubifs is a step back here.
> >
> > 'clean marker' is a good idea... empty pages have plenty of space.  
> 
> If UBI (not UBIFS) faces an empty block, it also re-erases it.

Unfortunately, that's not the case, though UBI can easily be patched
to do that (see below).

> The EC header is uses as clean marker.

That is true. If the EC header has been written to a block, that means
this block has been correctly erased.

> 
> > How do you handle the issue during regular write? Always ignore last
> > successfully written block?  

I guess UBIFS can know what was written last, because of the log-based
approach + the seqnum stored along with FS nodes, but I'm pretty sure
UBIFS does not re-write the last written block in case of an unclean
mount. Richard, am I wrong?

> 
> The last page of a block is inspected and allowed to be corrupted.

Actually, it's not really about corrupted pages, it's about pages that
might become unreadable after a few reads.

> 
> > Do you handle "paired pages" problem on MLC?  
> 
> Nope, no MLC support in mainline so far.

Richard and I have put a lot of effort to reliably support MLC NANDs in
mainline, unfortunately this projects has been paused. You can access
the last version of our work here [1] if you're interested (it's
clearly not in a shippable state ;-)).

[1]https://github.com/bbrezillon/linux-sunxi/commits/bb/4.7/ubi-mlc

--->8---
diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index 93ceea4f27d5..3d76941c9570 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -1121,21 +1121,20 @@ static int scan_peb(struct ubi_device *ubi, struct ubi_attach_info *ai,
                        return err;
                goto adjust_mean_ec;
        case UBI_IO_FF_BITFLIPS:
+       case UBI_IO_FF:
+               /*
+                * Always erase the block if the EC header is empty, even if
+                * no bitflips were reported because otherwise we might
+                * expose ourselves to the 'unstable bits' issue described
+                * here:
+                *
+                * http://www.linux-mtd.infradead.org/doc/ubifs.html#L_unstable_bits
+                */
                err = add_to_list(ai, pnum, UBI_UNKNOWN, UBI_UNKNOWN,
                                  ec, 1, &ai->erase);
                if (err)
                        return err;
                goto adjust_mean_ec;
-       case UBI_IO_FF:
-               if (ec_err || bitflips)
-                       err = add_to_list(ai, pnum, UBI_UNKNOWN,
-                                         UBI_UNKNOWN, ec, 1, &ai->erase);
-               else
-                       err = add_to_list(ai, pnum, UBI_UNKNOWN,
-                                         UBI_UNKNOWN, ec, 0, &ai->free);
-               if (err)
-                       return err;
-               goto adjust_mean_ec;
        default:
                ubi_err(ubi, "'ubi_io_read_vid_hdr()' returned unknown code %d",
                        err);
