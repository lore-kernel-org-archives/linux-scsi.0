From: Robert Love <robert.w.love@intel.com>
Subject: Re: [Open-FCoE] [PATCH] add cpu on/offline support in Fibre
 Channel exchange and sequence handling
Date: Mon, 11 Oct 2010 15:08:08 -0700
Message-ID: <1286834888.13422.1572.camel@fritz>
References: <AANLkTi=ViAo=uYK0JwK597WkV1x78mntFqU-Cn4u0Dju@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:64540 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463Ab0JKWIJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Oct 2010 18:08:09 -0400
In-Reply-To: <AANLkTi=ViAo=uYK0JwK597WkV1x78mntFqU-Cn4u0Dju@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, devel@open-fcoe.org, linux-scsi@vger.kernel.org

On Fri, 2010-10-08 at 22:57 +0800, Hillf Danton wrote:

Hi Hillf,

Can you please prefix the libfc patches with "libfc: <title>"? Also, fo=
r
your other patches that have a "SCSI" prefix, I think James' system add=
s
the "[SCSI]" prefix when he applies patches so you don't need to add it=
=2E

> Fibre Channel exchange pool is setup in a per cpu way that
> entire exchange id range is divided equally across all cpus.
>=20
> When cpu goes offline, the corresponding range of exchg id
> becomes unavailable until it is online again.
>=20
> This work tries to fix the unavailability based on notifier_block.
>=20
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
>=20
> --- o/linux-2.6.36-rc4/drivers/scsi/libfc/fc_exch.c	2010-09-13
> 07:07:38.000000000 +0800
> +++ m/linux-2.6.36-rc4/drivers/scsi/libfc/fc_exch.c	2010-10-08
> 22:24:48.000000000 +0800

Most patches I've seen on the various mailing lists are created by
diffing the files within the kernel directory, so that you don't have
the "/linux-2.6.36-rc/" in each hunk. It's the difference between using
'patch -p1' or 'patch -p2' when applying the patch.

I think this is preventing git-am from applying the patches. To import
them I ended up having git-am fail and then manually using the 'patch
-p2' command, so that I could get both the commit message from git-am
and then the patch itself from 'patch'. I don't know about anyone else,
but if you post patches without the kernel directory in the diff line i=
t
would help me out. Thanks.

> @@ -26,6 +26,9 @@
>  #include <linux/timer.h>
>  #include <linux/slab.h>
>  #include <linux/err.h>
> +#include <linux/notifier.h>
> +#include <linux/cpu.h>
> +#include <linux/cpumask.h>
>=20
>  #include <scsi/fc/fc_fc2.h>
>=20
> @@ -40,6 +43,8 @@ static u16	fc_cpu_order;	/* 2's power to
>  static struct kmem_cache *fc_em_cachep;	       /* cache for exchange=
s */
>  struct workqueue_struct *fc_exch_workqueue;
>=20
> +static cpumask_t fc_offline_cpu_mask =3D CPU_MASK_NONE;
> +
>  /*
>   * Structure and function definitions for managing Fibre Channel Exc=
hanges
>   * and Sequences.
> @@ -666,6 +671,7 @@ static struct fc_exch *fc_exch_em_alloc(
>  	unsigned int cpu;
>  	u16 index;
>  	struct fc_exch_pool *pool;
> +	unsigned int index =3D -1;

This patch doesn't compile:

drivers/scsi/libfc/fc_exch.c: In function =E2=80=98fc_exch_em_alloc=E2=80=
=99:
drivers/scsi/libfc/fc_exch.c:674: error: conflicting types for =E2=80=98=
index=E2=80=99
drivers/scsi/libfc/fc_exch.c:672: note: previous declaration of =E2=80=98=
index=E2=80=99
was here
make[3]: *** [drivers/scsi/libfc/fc_exch.o] Error 1

In general I think the idea is fine. I haven't run into any
circumstances where the per-CPU pools are exhausted. I know others have
when using NPIV, but there were other ways to fix those issues.

>=20
>  	/* allocate memory for exchange */
>  	ep =3D mempool_alloc(mp->ep_pool, GFP_ATOMIC);
> @@ -679,6 +685,7 @@ static struct fc_exch *fc_exch_em_alloc(
>  	pool =3D per_cpu_ptr(mp->pool, cpu);
>  	spin_lock_bh(&pool->lock);
>  	put_cpu();
> +again:
>  	index =3D pool->next_index;
>  	/* allocate new exch from pool */
>  	while (fc_exch_ptr_get(pool, index)) {
> @@ -719,6 +726,17 @@ out:
>  err:
>  	spin_unlock_bh(&pool->lock);
>  	atomic_inc(&mp->stats.no_free_exch_xid);

I think this should be moved below the offline pool check, when we've
really failed to allocate an exchange. It's not a per-CPU pool stat,
it's an overall resource allocation failure stat, which you're now
helping to happen less frequently. With the current placement we'll be
bumping up the counter even though we have allocated an exchange.

Thanks, //Rob

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
