From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 04/10] aacraid: Fix memory leak in aac_fib_map_free
Date: Wed, 02 Dec 2015 10:44:31 +0100
Message-ID: <1449049471.3103.46.camel@suse.de>
References: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
	 <1448973589-9216-5-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53898 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914AbbLBJod (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Dec 2015 04:44:33 -0500
In-Reply-To: <1448973589-9216-5-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Santosh.Akula@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Rich.Bono@pmcs.com

On Tue, 2015-12-01 at 04:39 -0800, Raghava Aditya Renukunta wrote:
> From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
>=20
> aac_fib_map_free() calls pci_free_consistent() without checking that
> dev->hw_fib_va is not NULL and dev->max_fib_size is not zero.If they
> are indeed NULL/0, this will result in a hang as pci_free_consistent(=
)
> will attempt to invalidate cache for the entire 64-bit address space
> (which would take a very long time).
>=20
> Fixed by adding a check to make sure that dev->hw_fib_va and
> dev->max_fib_size are not NULL and 0 respectively.
>=20
> Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs=
=2Ecom>
> ---
> =C2=A0drivers/scsi/aacraid/commsup.c | 9 ++++++---
> =C2=A01 file changed, 6 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/co=
mmsup.c
> index b257d3b..9533f47 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -83,9 +83,12 @@ static int fib_map_alloc(struct aac_dev *dev)
> =C2=A0
> =C2=A0void aac_fib_map_free(struct aac_dev *dev)
> =C2=A0{
> -	pci_free_consistent(dev->pdev,
> -	=C2=A0=C2=A0dev->max_fib_size * (dev->scsi_host_ptr->can_queue +
> AAC_NUM_MGT_FIB),
> -	=C2=A0=C2=A0dev->hw_fib_va, dev->hw_fib_pa);
> +	if (dev->hw_fib_va && dev->max_fib_size) {
> +		pci_free_consistent(dev->pdev,
> +		(dev->max_fib_size *
> +		(dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB)),
> +		dev->hw_fib_va, dev->hw_fib_pa);
> +	}
> =C2=A0	dev->hw_fib_va =3D NULL;
> =C2=A0	dev->hw_fib_pa =3D 0;
> =C2=A0}

=46ixes:=C2=A09ad5204d6 - "[SCSI] aacraid: incorrect dma mapping mask d=
uring blinkled
recover or user initiated reset"
Cc: stable@vger.kernel.org
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
