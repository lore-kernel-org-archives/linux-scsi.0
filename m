From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
Date: Fri, 5 Jun 2009 20:38:22 +0900
Message-ID: <20090605203753K.fujita.tomonori@lab.ntt.co.jp>
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp>
	<20090605104132.GE24836@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:50206 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbZFELjR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jun 2009 07:39:17 -0400
In-Reply-To: <20090605104132.GE24836@amd.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, torvalds@linux-foundation.org, mingo@elte.hu, lethal@linux-sh.org, just.for.lkml@googlemail.com, hancockrwd@gmail.com, jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 5 Jun 2009 12:41:33 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

>=20
> On Fri, Jun 05, 2009 at 05:33:14PM +0900, FUJITA Tomonori wrote:
> > dma-debugs wrongly assumes that no multiple DMA transfers are
> > performed against the same dma address on one device at the same
> > time. However it's true only with hardware IOMMUs. For example, an
> > application can easily send the same buffer twice with different
> > lengths to one device by using DIO and AIO. If these requests are n=
ot
> > unmapped in the same order in which they were mapped,
> > hash_bucket_find() finds a wrong entry and gives a false warning.
> >=20
> > We should fix this before 2.6.30 release. Seems that there is no
> > easy way to fix it. I think that it's better to just disable
> > dma-debug for now.
> >=20
> > Torsten Kaiser found this bug with the RAID1 configuration:
> >=20
> > http://marc.info/?t=3D124336541900008&r=3D1&w=3D2
> >=20
>=20
> Argh, I never thought that this can happen. But its not explicitly
> forbidden so we have to handle this situation. Thanks for tracking do=
wn
> the bug to this issue.
> However, I think there is a somehow simple fix for the issue. Patch i=
s
> attached. Its the least intrusive way I can think of to fix this
> problem.
> But its up to Linus/Ingo to decide if it can be accepted at this very
> late point in the cycle. Since dma-debug is new with 2.6.30 it will a=
t
> least not introduce any regression. The patch is boot and basically
> load-tested with some disk and network load and showed no issues on m=
y
> test machine. The diffstat looks big but more than the half of the pa=
tch
> adds comments to explain what it does. So the diffstat looks bigger t=
han
> the actual change.
> Linus, if you think my patch is not acceptable at this point then ple=
ase
> apply the patch from FUJITA Tomonori.
>=20
> Regards,
>=20
> 	Joerg
>=20
> From c0baa4d43a674c9cc321af3b23a6d5c9b46d65bd Mon Sep 17 00:00:00 200=
1
> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Fri, 5 Jun 2009 12:01:35 +0200
> Subject: [PATCH] dma-debug: change hash_bucket_find from first-fit to=
 best-fit
>=20
> Some device drivers map the same physical address multiple times to a
> dma address. Without an IOMMU this results in the same dma address be=
ing
> put into the dma-debug hash multiple times. With a first-fit match in
> hash_bucket_find() this function may return the wrong dma_debug_entry=
=2E
> This can result in false positive warnings. This patch fixes it by
> changing the first-fit behavior of hash_bucket_find() into a best-fit
> algorithm.

I thought about something like this fix however we can do better; with
this fix, we could overlook a bad hardware IOMMU bug.

I think that the better fix can handle both cases per device:

- multiple identical dma addresses should not happen (with devices
  behind hardware IOMMU)
- multiple identical dma addresses could happen


It's better to use a strict-fit algorithm (as we do now) with the
former. It's pretty difficult to do something better than a best-fit
algorithm with the latter though.



> Reported-by: Torsten Kaiser <just.for.lkml@googlemail.com>
> Reported-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  lib/dma-debug.c |   43 +++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 39 insertions(+), 4 deletions(-)
>=20
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index 69da09a..2b16536 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -185,15 +185,50 @@ static void put_hash_bucket(struct hash_bucket =
*bucket,
>  static struct dma_debug_entry *hash_bucket_find(struct hash_bucket *=
bucket,
>  						struct dma_debug_entry *ref)
>  {
> -	struct dma_debug_entry *entry;
> +	struct dma_debug_entry *entry, *ret =3D NULL;
> +	int matches =3D 0, match_lvl, last_lvl =3D 0;
> =20
>  	list_for_each_entry(entry, &bucket->list, list) {
> -		if ((entry->dev_addr =3D=3D ref->dev_addr) &&
> -		    (entry->dev =3D=3D ref->dev))
> +		if ((entry->dev_addr !=3D ref->dev_addr) ||
> +		    (entry->dev !=3D ref->dev))
> +			continue;
> +
> +		/*
> +		 * Some drivers map the same physical address multiple
> +		 * times. Without a hardware IOMMU this results in the
> +		 * same device addresses being put into the dma-debug
> +		 * hash multiple times too. This can result in false
> +		 * positives being reported. Therfore we implement a
> +		 * best-fit algorithm here which returns the entry from
> +		 * the hash which fits best to the reference value
> +		 * instead of the first-fit.
> +		 */
> +		matches +=3D 1;
> +		match_lvl =3D 0;
> +		entry->size      =3D=3D ref->size      ? ++match_lvl : match_lvl;
> +		entry->type      =3D=3D ref->type      ? ++match_lvl : match_lvl;
> +		entry->direction =3D=3D ref->direction ? ++match_lvl : match_lvl;
> +
> +		if (match_lvl =3D=3D 3) {
> +			/* perfect-fit - return the result */
>  			return entry;
> +		} else if (match_lvl > last_lvl) {
> +			/*
> +			 * We found an entry that fits better then the
> +			 * previous one
> +			 */
> +			last_lvl =3D match_lvl;
> +			ret      =3D entry;
> +		}
>  	}
> =20
> -	return NULL;
> +	/*
> +	 * If we have multiple matches but no perfect-fit, just return
> +	 * NULL.
> +	 */
> +	ret =3D (matches =3D=3D 1) ? ret : NULL;
> +
> +	return ret;
>  }
> =20
>  /*
> --=20
> 1.6.3.1
>=20
>=20
>=20
>=20
> --=20
>            | Advanced Micro Devices GmbH
>  Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei M=FCnchen
>  System    |=20
>  Research  | Gesch=E4ftsf=FChrer: Thomas M. McCoy, Giuliano Meroni
>  Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis M=FCnchen
>            | Registergericht M=FCnchen, HRB Nr. 43632
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
