From: Torsten Kaiser <just.for.lkml@googlemail.com>
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
Date: Fri, 5 Jun 2009 17:52:27 +0200
Message-ID: <64bb37e0906050852g2be64c7elb2872a6129d13f56@mail.gmail.com>
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp>
	 <20090605104132.GE24836@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:54967 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbZFEPw1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jun 2009 11:52:27 -0400
In-Reply-To: <20090605104132.GE24836@amd.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu, lethal@linux-sh.org, hancockrwd@gmail.com, jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Jun 5, 2009 at 12:41 PM, Joerg Roedel <joerg.roedel@amd.com> wr=
ote:
> From c0baa4d43a674c9cc321af3b23a6d5c9b46d65bd Mon Sep 17 00:00:00 200=
1
> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Fri, 5 Jun 2009 12:01:35 +0200
> Subject: [PATCH] dma-debug: change hash_bucket_find from first-fit to=
 best-fit
>
> Some device drivers map the same physical address multiple times to a
> dma address. Without an IOMMU this results in the same dma address be=
ing
> put into the dma-debug hash multiple times. With a first-fit match in
> hash_bucket_find() this function may return the wrong dma_debug_entry=
=2E
> This can result in false positive warnings. This patch fixes it by
> changing the first-fit behavior of hash_bucket_find() into a best-fit
> algorithm.
>
> Reported-by: Torsten Kaiser <just.for.lkml@googlemail.com>
> Reported-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  lib/dma-debug.c |   43 +++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 39 insertions(+), 4 deletions(-)
>
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index 69da09a..2b16536 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -185,15 +185,50 @@ static void put_hash_bucket(struct hash_bucket =
*bucket,
>  static struct dma_debug_entry *hash_bucket_find(struct hash_bucket *=
bucket,
>                                                struct dma_debug_entry=
 *ref)
>  {
> -       struct dma_debug_entry *entry;
> +       struct dma_debug_entry *entry, *ret =3D NULL;
> +       int matches =3D 0, match_lvl, last_lvl =3D 0;
>
>        list_for_each_entry(entry, &bucket->list, list) {
> -               if ((entry->dev_addr =3D=3D ref->dev_addr) &&
> -                   (entry->dev =3D=3D ref->dev))
> +               if ((entry->dev_addr !=3D ref->dev_addr) ||
> +                   (entry->dev !=3D ref->dev))
> +                       continue;
> +
> +               /*
> +                * Some drivers map the same physical address multipl=
e
> +                * times. Without a hardware IOMMU this results in th=
e
> +                * same device addresses being put into the dma-debug
> +                * hash multiple times too. This can result in false
> +                * positives being reported. Therfore we implement a
> +                * best-fit algorithm here which returns the entry fr=
om
> +                * the hash which fits best to the reference value
> +                * instead of the first-fit.
> +                */
> +               matches +=3D 1;
> +               match_lvl =3D 0;
> +               entry->size      =3D=3D ref->size      ? ++match_lvl =
: match_lvl;
> +               entry->type      =3D=3D ref->type      ? ++match_lvl =
: match_lvl;
> +               entry->direction =3D=3D ref->direction ? ++match_lvl =
: match_lvl;
> +
> +               if (match_lvl =3D=3D 3) {
> +                       /* perfect-fit - return the result */
>                        return entry;
> +               } else if (match_lvl > last_lvl) {
> +                       /*
> +                        * We found an entry that fits better then th=
e
> +                        * previous one
> +                        */
> +                       last_lvl =3D match_lvl;
> +                       ret      =3D entry;
> +               }
>        }
>
> -       return NULL;
> +       /*
> +        * If we have multiple matches but no perfect-fit, just retur=
n
> +        * NULL.
> +        */
> +       ret =3D (matches =3D=3D 1) ? ret : NULL;

This doesn't look right to me.
The comment above says "returns the entry from the hash which fits
best", but this will always return NULL, if there are are multiple
entrys, but no perfect match.

On a wrong unmap that would result in "DMA-API: device driver tries to
free DMA memory it has not allocated" instead of a report what kind of
mismatches happend.

Or did you mean to return NULL if there are more then one matches at
the last_lvl? Then a matches=3D1; is missing from the "found an entry"
block.

Should there be a warning if more then one possible match were found?

* driver maps address 'a' with size 1
* driver maps same address 'a' with size 2
* driver wrongly unmaps the second allocation with size 1
  -> no warning, because the first allocation is returned
* driver wants to correctly unmap the first allocation
  -> wrong warning about this unmap because size mismatch

Also what about sg_call_ents and sg_mapped_ents?
Could it be possible to get the same address/size with different sg-cou=
nts.

As in my case most of the warnings where about a wrong unmap count and
only a few about the memory size, that seems possible.

=46or reference, here part of the warnings from my system:

Wrong count:
Jun  5 03:32:58 treogen [   51.469720] sata_sil24 0000:04:00.0:
DMA-API: device driver frees DMA sg list with different entry count
[map count=3D1] [unmap count=3D2]
Jun  5 03:32:58 treogen [   51.469725] Modules linked in: msp3400
tuner tea5767 tda8290 tuner_xc2028 xc
5000 tda9887 tuner_simple tuner_types mt20xx tea5761 bttv ir_common
v4l2_common videodev v4l1_compat v4
l2_compat_ioctl32 videobuf_dma_sg videobuf_core btcx_risc tveeprom sg p=
ata_amd
Jun  5 03:32:58 treogen [   51.469771] Pid: 0, comm: swapper Not
tainted 2.6.30-rc7 #1
Jun  5 03:32:58 treogen [   51.469775] Call Trace:
Jun  5 03:32:58 treogen [   51.469779]  <IRQ>  [<ffffffff8041755e>] ?
check_unmap+0x65e/0x6a0
Jun  5 03:32:58 treogen [   51.469797]  [<ffffffff802432d8>]
warn_slowpath_common+0x78/0xd0
Jun  5 03:32:58 treogen [   51.469804]  [<ffffffff802433b4>]
warn_slowpath_fmt+0x64/0x70
Jun  5 03:32:58 treogen [   51.469816]  [<ffffffff8028dd42>] ?
mempool_free_slab+0x12/0x20
Jun  5 03:32:58 treogen [   51.469828]  [<ffffffff8068d74d>] ?
_spin_lock_irqsave+0x1d/0x40
Jun  5 03:32:58 treogen [   51.469835]  [<ffffffff8041755e>]
check_unmap+0x65e/0x6a0
Jun  5 03:32:58 treogen [   51.469842]  [<ffffffff804176ae>]
debug_dma_unmap_sg+0x10e/0x1b0

Wrong size:
Jun  3 06:50:33 treogen [  276.421432] sata_sil24 0000:04:00.0:
DMA-API: device driver frees DMA memory with different size [device
address=3D0x000000007b590000] [map size=3D16384 bytes] [unmap size=3D12=
288
bytes]
                                     Jun  3 06:50:33 treogen [
276.421438] Modules linked in: msp3400 tuner tea5767 tda8290
tuner_xc2028 xc5000 tda9887 tuner_simple tuner_types mt20xx tea5761
bttv ir_common v4l2_common videodev v4l1_compat v4l2_compat_ioctl32
videobuf_dma_sg videobuf_core btcx_risc sg pata_amd tveeprom
Jun  3 06:50:33 treogen [  276.421480] Pid: 1301, comm: kcryptd Not
tainted 2.6.30-rc7 #1
Jun  3 06:50:33 treogen [  276.421485] Call Trace:
Jun  3 06:50:33 treogen [  276.421490]  <IRQ>  [<ffffffff80417355>] ?
check_unmap+0x455/0x6a0
Jun  3 06:50:33 treogen [  276.421507]  [<ffffffff802432d8>]
warn_slowpath_common+0x78/0xd0
Jun  3 06:50:33 treogen [  276.421514]  [<ffffffff802433b4>]
warn_slowpath_fmt+0x64/0x70
Jun  3 06:50:33 treogen [  276.421524]  [<ffffffff8028dd42>] ?
mempool_free_slab+0x12/0x20
Jun  3 06:50:33 treogen [  276.421535]  [<ffffffff8068d74d>] ?
_spin_lock_irqsave+0x1d/0x40
Jun  3 06:50:33 treogen [  276.421542]  [<ffffffff80417355>]
check_unmap+0x455/0x6a0
Jun  3 06:50:33 treogen [  276.421549]  [<ffffffff804176ae>]
debug_dma_unmap_sg+0x10e/0x1b0

> +
> +       return ret;
>  }
>
>  /*
> --
> 1.6.3.1
>
>
>
>
> --
>           | Advanced Micro Devices GmbH
>  Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei M=FCnchen
>  System    |
>  Research  | Gesch=E4ftsf=FChrer: Thomas M. McCoy, Giuliano Meroni
>  Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis M=FCnchen
>           | Registergericht M=FCnchen, HRB Nr. 43632
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
