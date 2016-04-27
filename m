From: Johannes Thumshirn <jthmshirn@suse.de>
Subject: Re: [PATCH 08/10] aacraid: Remove code to needlessly complete fib
Date: Wed, 27 Apr 2016 11:24:03 +0200
Message-ID: <20160427092403.GE2820@c203.arch.suse.de>
References: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
 <20160426063226.28402.37546.stgit@pmcuser-System-Product-Name>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39482 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbcD0JYH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2016 05:24:07 -0400
Content-Disposition: inline
In-Reply-To: <20160426063226.28402.37546.stgit@pmcuser-System-Product-Name>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: JBottomley@odin.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, aacraid@pmc-sierra.com, gana.sridaran@microsemi.com, scott.benesh@microsemi.com, vishal.josemannanal@microsemi.com

On Mon, Apr 25, 2016 at 11:32:26PM -0700, Raghava Aditya Renukunta wrot=
e:
> Currently driver completes double completed or spurious interrupted f=
ibs.
> This  is not necessary and causes the SCSI mid layer to issue aborts =
and
> resets, since completing a fib  prematurely might trigger a race cond=
ition
> resulting in the driver not calling the scsi_done callback.
>=20
> Fixed by removing the call to fib complete.
>=20
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@micr=
osemi.com>
> ---
>  drivers/scsi/aacraid/dpcsup.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpc=
sup.c
> index d677b52..7e83620 100644
> --- a/drivers/scsi/aacraid/dpcsup.c
> +++ b/drivers/scsi/aacraid/dpcsup.c
> @@ -392,9 +392,10 @@ unsigned int aac_intr_normal(struct aac_dev *dev=
, u32 index,
>  			if (likely(fib->callback && fib->callback_data)) {
>  				fib->flags &=3D FIB_CONTEXT_FLAG_FASTRESP;
>  				fib->callback(fib->callback_data, fib);
> -			} else {
> -				aac_fib_complete(fib);
> -			}
> +			} else
> +				dev_info(&dev->pdev->dev,
> +				"Invalid callback_fib[%d] (*%p)(%p)\n",
> +				index, fib->callback, fib->callback_data);

I'm not sure INFO is the right logging level for this. WARN or ERROR mi=
ght be
more suited.

>  		} else {
>  			unsigned long flagv;
>  	  		dprintk((KERN_INFO "event_wait up\n"));
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
