From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 01/10] aacraid: SCSI blk tag support
Date: Wed, 02 Dec 2015 11:49:31 +0100
Message-ID: <1449053371.3103.68.camel@suse.de>
References: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
	 <1448973589-9216-2-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769AbbLBKte (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Dec 2015 05:49:34 -0500
In-Reply-To: <1448973589-9216-2-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Santosh.Akula@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Rich.Bono@pmcs.com

On Tue, 2015-12-01 at 04:39 -0800, Raghava Aditya Renukunta wrote:
> From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
>=20
> The method to allocate and free FIB's in the present code utilizes
> spinlocks.Multiple IO's have to wait on the spinlock to acquire or
> free fibs creating a performance bottleneck.
>=20
> An alternative solution would be to use block layer tags to keep trac=
k
> of the fibs allocated and freed. To this end 2 functions
> aac_fib_alloc_tag and aac_fib_free_tag were created which utilize the
> blk layer tags to plug into the Fib pool.These functions are used
> exclusively in the IO path. 8 fibs are reserved for the use of AIF
> management software and utilize the previous spinlock based
> implementations.
>=20
> Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs=
=2Ecom>
> ---
> =C2=A0drivers/scsi/aacraid/aachba.c=C2=A0=C2=A0| 35 +++++++++++++++++=
-------------
> =C2=A0drivers/scsi/aacraid/aacraid.h |=C2=A0=C2=A02 ++
> =C2=A0drivers/scsi/aacraid/commsup.c | 49 +++++++++++++++++++++++++++=
++++++++++++-
> --
> =C2=A0drivers/scsi/aacraid/dpcsup.c=C2=A0=C2=A0|=C2=A0=C2=A04 ++--
> =C2=A0drivers/scsi/aacraid/linit.c=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A02 ++
> =C2=A05 files changed, 72 insertions(+), 20 deletions(-)
>=20
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aac=
hba.c
> index e4c2437..06cbab8 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -323,7 +323,7 @@ static inline int aac_valid_context(struct scsi_c=
mnd=20

[...]

>=20
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0
> @@ -166,6 +166,49 @@ int aac_fib_setup(struct aac_dev * dev)
> =C2=A0 *	aac_fib_alloc	-	allocate a fib

Nitpick/Typo aac_fib_alloc_tag

> =C2=A0 *	@dev: Adapter to allocate the fib for
> =C2=A0 *
> + *	Allocate a fib from the adapter fib pool using tags
> + *	from the blk layer.
> + */
> +
> +struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd =
*scmd)
> +{
> +	struct fib *fibptr;
> +
> +	fibptr =3D &dev->fibs[scmd->request->tag];
> +	/*
> +	=C2=A0*	Set the proper node type code and node byte size
> +	=C2=A0*/
> +	fibptr->type =3D FSAFS_NTC_FIB_CONTEXT;
> +	fibptr->size =3D sizeof(struct fib);
> +	/*
> +	=C2=A0*	Null out fields that depend on being zero at the start of
> +	=C2=A0*	each I/O
> +	=C2=A0*/
> +	fibptr->hw_fib_va->header.XferState =3D 0;
> +	fibptr->flags =3D 0;
> +	fibptr->callback =3D NULL;
> +	fibptr->callback_data =3D NULL;
> +
> +	return fibptr;
> +}
> +
> +/**
> + *	aac_fib_free_tag	free a fib
> + *	@fibptr: fib to free up
> + *
> + *	Placeholder to free tag allocated fibs
> + *	Does not do anything
> + */
> +
> +void aac_fib_free_tag(struct fib *fibptr)
> +{
> +	(void)fibptr;
> +}
> +

I'm not sure if I like this placeholder. Sure it's a NOP and doesn't co=
st
anything but it's dead code. But if I'm the only one objecting here I'm=
 fine
with it.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
