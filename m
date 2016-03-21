From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH RFC 1/2] scatterlist: add mempool based chained SG
 alloc/free api
Date: Sun, 20 Mar 2016 23:55:17 -0700
Message-ID: <1458543317.4550.1.camel@kernel.org>
References: <1458081569-30953-1-git-send-email-mlin@kernel.org>
	 <1458081569-30953-2-git-send-email-mlin@kernel.org>
	 <20160316082339.GA6203@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40088 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbcCUGzU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2016 02:55:20 -0400
In-Reply-To: <20160316082339.GA6203@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2016-03-16 at 09:23 +0100, Christoph Hellwig wrote:
> >=C2=A0
> We can defintively kill this one.

We want to support different size of pools.
How can we kill this one?

Or did you mean we just create a single pool with size SG_CHUNK_SIZE?

>=20
> > +static __init int sg_mempool_init(void)
> > +{
> > +	int i;
> > +
> > +	for (i =3D 0; i < SG_MEMPOOL_NR; i++) {
> > +		struct sg_mempool *sgp =3D sg_pools + i;
> > +		int size =3D sgp->size * sizeof(struct scatterlist);
> > +
> > +		sgp->slab =3D kmem_cache_create(sgp->name, size, 0,
> > +				SLAB_HWCACHE_ALIGN, NULL);
>=20
> Having these mempoools around in every kernel will make some embedded
> developers rather unhappy.=C2=A0=C2=A0We could either not create them=
 at
> runtime, which would require either a check in the fast path, or
> an init call in every driver, or just move the functions you
> added into a separe file, which will be compiled only based on a
> Kconfig
> symbol, and could even be potentially modular.=C2=A0=C2=A0I think tha=
t
> second option might be easier.

I created lib/sg_pool.c with CONFIG_SG_POOL.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
