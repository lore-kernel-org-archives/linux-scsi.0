From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 02/10] aacraid: Fix RRQ overload
Date: Wed, 02 Dec 2015 10:26:41 +0100
Message-ID: <1449048401.3103.42.camel@suse.de>
References: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
	 <1448973589-9216-3-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49727 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494AbbLBJ0n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Dec 2015 04:26:43 -0500
In-Reply-To: <1448973589-9216-3-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Santosh.Akula@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Rich.Bono@pmcs.com

On Tue, 2015-12-01 at 04:39 -0800, Raghava Aditya Renukunta wrote:
> From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
>=20
> The driver utilizes an array of atomic variables to keep track of
> IO submissions to each vector. To submit an IO multiple threads
> iterate through the array to find a vector which has empty slots
> to send an IO. The reading and updating of the variable is not atomic=
,
> causing race conditions when a thread uses a full vector to
> submit an IO.
>=20
> Fixed by mapping each FIB to a vector, the submission path then uses
> said vector to submit IO thereby removing the possibly of a race
> condition.The vector assignment is started from 1 since vector 0 is
> reserved for the use of AIF management FIBS.If the number of MSIx
> vectors is 1 (MSI or INTx mode) then all the fibs are allocated to
> vector 0.
>=20
> Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs=
=2Ecom>
> ---
> =C2=A0drivers/scsi/aacraid/aacraid.h |=C2=A0=C2=A01 +
> =C2=A0drivers/scsi/aacraid/commsup.c | 12 ++++++++++++
> =C2=A0drivers/scsi/aacraid/src.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 30 ++=
+++++-----------------------
> =C2=A03 files changed, 20 insertions(+), 23 deletions(-)
>=20
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aa=
craid.h
> index da227e8..d133c4a 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -944,6 +944,7 @@ struct fib {
> =C2=A0	=C2=A0*/
> =C2=A0	struct list_head	fiblink;
> =C2=A0	void			*data;
> +	u32			vector_no;
> =C2=A0	struct hw_fib		*hw_fib_va;		/* Actual
> shared object */
> =C2=A0	dma_addr_t		hw_fib_pa;		/* physical
> address of hw_fib*/
> =C2=A0};
> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/co=
mmsup.c
> index b5b653c..b257d3b 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -104,6 +104,7 @@ int aac_fib_setup(struct aac_dev * dev)
> =C2=A0	struct hw_fib *hw_fib;
> =C2=A0	dma_addr_t hw_fib_pa;
> =C2=A0	int i;
> +	u32 vector =3D 1;
> =C2=A0
> =C2=A0	while (((i =3D fib_map_alloc(dev)) =3D=3D -ENOMEM)
> =C2=A0	=C2=A0&& (dev->scsi_host_ptr->can_queue > (64 - AAC_NUM_MGT_FI=
B))) {
> @@ -150,6 +151,17 @@ int aac_fib_setup(struct aac_dev * dev)
> =C2=A0			dev->max_fib_size + sizeof(struct
> aac_fib_xporthdr));
> =C2=A0		hw_fib_pa =3D hw_fib_pa +
> =C2=A0			dev->max_fib_size + sizeof(struct aac_fib_xporthdr);
> +
> +		if ((dev->max_msix =3D=3D 1) ||
> +		=C2=A0=C2=A0(i > ((dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB=
 -
> 1)
> +			- dev->vector_cap))) {
> +			fibptr->vector_no =3D 0;
> +		} else {
> +			fibptr->vector_no =3D vector;
> +			vector++;
> +			if (vector =3D=3D dev->max_msix)
> +				vector =3D 1;
> +		}
> =C2=A0	}
> =C2=A0	/*
> =C2=A0	=C2=A0*	Add the fib chain to the free list
> diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
> index 2aa34ea..bc0203f 100644
> --- a/drivers/scsi/aacraid/src.c
> +++ b/drivers/scsi/aacraid/src.c
> @@ -156,8 +156,8 @@ static irqreturn_t aac_src_intr_message(int irq, =
void
> *dev_id)
> =C2=A0				break;
> =C2=A0			if (dev->msi_enabled && dev->max_msix > 1)
> =C2=A0				atomic_dec(&dev-
> >rrq_outstanding[vector_no]);
> -			aac_intr_normal(dev, handle-1, 0, isFastResponse,
> NULL);
> =C2=A0			dev->host_rrq[index++] =3D 0;
> +			aac_intr_normal(dev, handle-1, 0, isFastResponse,
> NULL);
> =C2=A0			if (index =3D=3D (vector_no + 1) * dev->vector_cap)
> =C2=A0				index =3D vector_no * dev->vector_cap;
> =C2=A0			dev->host_rrq_idx[vector_no] =3D index;
> @@ -452,36 +452,20 @@ static int aac_src_deliver_message(struct fib *=
fib)
> =C2=A0#endif
> =C2=A0
> =C2=A0	u16 hdr_size =3D le16_to_cpu(fib->hw_fib_va->header.Size);
> +	u16 vector_no;
> =C2=A0
> =C2=A0	atomic_inc(&q->numpending);
> =C2=A0
> =C2=A0	if (dev->msi_enabled && fib->hw_fib_va->header.Command !=3D Ai=
fRequest
> &&
> =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0dev->max_msix > 1) {
> -		u_int16_t vector_no, first_choice =3D 0xffff;
> -
> -		vector_no =3D dev->fibs_pushed_no % dev->max_msix;
> -		do {
> -			vector_no +=3D 1;
> -			if (vector_no =3D=3D dev->max_msix)
> -				vector_no =3D 1;
> -			if (atomic_read(&dev->rrq_outstanding[vector_no]) <
> -			=C2=A0=C2=A0=C2=A0=C2=A0dev->vector_cap)
> -				break;
> -			if (0xffff =3D=3D first_choice)
> -				first_choice =3D vector_no;
> -			else if (vector_no =3D=3D first_choice)
> -				break;
> -		} while (1);
> -		if (vector_no =3D=3D first_choice)
> -			vector_no =3D 0;
> -		atomic_inc(&dev->rrq_outstanding[vector_no]);
> -		if (dev->fibs_pushed_no =3D=3D 0xffffffff)
> -			dev->fibs_pushed_no =3D 0;
> -		else
> -			dev->fibs_pushed_no++;
> +		vector_no =3D fib->vector_no;
> =C2=A0		fib->hw_fib_va->header.Handle +=3D (vector_no << 16);
> +	} else {
> +		vector_no =3D 0;
> =C2=A0	}
> =C2=A0
> +	atomic_inc(&dev->rrq_outstanding[vector_no]);
> +
> =C2=A0	if (dev->comm_interface =3D=3D AAC_COMM_MESSAGE_TYPE2) {
> =C2=A0		/* Calculate the amount to the fibsize bits */
> =C2=A0		fibsize =3D (hdr_size + 127) / 128 - 1;

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
=46ixes:=C2=A0495c0217 "aacraid: MSI-x support"
Cc: stable@vger.kernel.org=C2=A0# v4.1
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
