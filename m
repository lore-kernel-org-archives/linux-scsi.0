From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH] storvsc: remove bogus code to transfer struct scatterlist
Date: Mon, 30 Jan 2017 23:48:04 +0000
Message-ID: <DM5PR03MB24909AC03B603A11E84C9255A04B0@DM5PR03MB2490.namprd03.prod.outlook.com>
References: <1485681138-21236-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-eopbgr730100.outbound.protection.outlook.com ([40.107.73.100]:4869
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754502AbdA3XsG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Jan 2017 18:48:06 -0500
In-Reply-To: <1485681138-21236-1-git-send-email-hch@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@lst.de]
> Sent: Sunday, January 29, 2017 1:12 AM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>
> Cc: linux-scsi@vger.kernel.org
> Subject: [PATCH] storvsc: remove bogus code to transfer struct scatterlis=
t
>=20
> Remove a piece of code in storvsc_queuecommand that tries to pass the
> physical address of the kernel struct scatterlist pointer to the host.
>=20
> Fortunately the code can't ever be reached anyway.

Thanks Christoph.

Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

K. Y

>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/storvsc_drv.c | 7 -------
>  1 file changed, 7 deletions(-)
>=20
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 05526b7..62f4545 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1511,13 +1511,6 @@ static int storvsc_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *scmnd)
>  				page_to_pfn(sg_page((cur_sgl)));
>  			cur_sgl =3D sg_next(cur_sgl);
>  		}
> -
> -	} else if (scsi_sglist(scmnd)) {
> -		payload->range.len =3D length;
> -		payload->range.offset =3D
> -			virt_to_phys(scsi_sglist(scmnd)) & (PAGE_SIZE-1);
> -		payload->range.pfn_array[0] =3D
> -			virt_to_phys(scsi_sglist(scmnd)) >> PAGE_SHIFT;
>  	}
>=20
>  	cmd_request->payload =3D payload;
> --
> 2.1.4

