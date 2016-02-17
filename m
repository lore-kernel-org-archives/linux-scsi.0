From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/2] mpt3sas: Deallocate resources before trying
 reallocation of the same in _base_allocate_memory_pools()
Date: Wed, 17 Feb 2016 12:36:39 +0100
Message-ID: <20160217113639.GK18134@c203.arch.suse.de>
References: <1455708326-7584-1-git-send-email-chaitra.basappa@broadcom.com>
 <1455708326-7584-2-git-send-email-chaitra.basappa@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1455708326-7584-2-git-send-email-chaitra.basappa@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, krishnaraddi.mankani@avagotech.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 17, 2016 at 04:55:25PM +0530, Chaitra P B wrote:
> Deallocates resources before reallocating of the same in retry_alloca=
tion
> path of _base_allocate_memory_pools()
>=20
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
> Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3s=
as/mpt3sas_base.c
> index f59495b..60c2e86 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -3124,8 +3124,10 @@ _base_release_memory_pools(struct MPT3SAS_ADAP=
TER *ioc)
>  		free_pages((ulong)ioc->scsi_lookup, ioc->scsi_lookup_pages);
>  		ioc->scsi_lookup =3D NULL;
>  	}
> -	kfree(ioc->hpr_lookup);
> -	kfree(ioc->internal_lookup);
> +	if (ioc->hpr_lookup)
> +		kfree(ioc->hpr_lookup);
> +	if (ioc->internal_lookup)
> +		kfree(ioc->internal_lookup);

kfree() can handle NULL pointers as arguments, so checking isn't needed=
=2E In
fact there are coccinelle scripts to check for it (make coccicheck) and=
 it'll
spawn patches from people "fixing" it. So please get rid of the checks.

Otherwise

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

>  	if (ioc->chain_lookup) {
>  		for (i =3D 0; i < ioc->chain_depth; i++) {
>  			if (ioc->chain_lookup[i].chain_buffer)
> @@ -3360,6 +3362,7 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAP=
TER *ioc,  int sleep_flag)
>  			goto out;
>  		retry_sz +=3D 64;
>  		ioc->hba_queue_depth =3D max_request_credit - retry_sz;
> +		_base_release_memory_pools(ioc);
>  		goto retry_allocation;
>  	}
> =20
> --=20
> 1.8.3.1
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
