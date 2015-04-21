From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RESEND 4/18] megaraid_sas : Move controller's queue depth
 calculation in adapter specific function
Date: Tue, 21 Apr 2015 12:21:51 +0200
Message-ID: <553624BF.7030301@suse.de>
References: <201504201235.t3KCZCCD016481@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60935 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537AbbDUKVy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2015 06:21:54 -0400
In-Reply-To: <201504201235.t3KCZCCD016481@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

On 04/20/2015 02:33 PM, Sumit.Saxena@avagotech.com wrote:
> This patch will move controller's queue depth calculation in adapter =
specific functions.
>=20
> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
>=20
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c   |   39 ++++++++++-------=
---------
>  drivers/scsi/megaraid/megaraid_sas_fusion.c |    9 ++++++
>  2 files changed, 24 insertions(+), 24 deletions(-)
>=20
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi=
/megaraid/megaraid_sas_base.c
> index e6cb2bd..7f426e0 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -4354,6 +4354,21 @@ megasas_init_adapter_mfi(struct megasas_instan=
ce *instance)
>  	instance->max_num_sge =3D (instance->instancet->read_fw_status_reg(=
reg_set) & 0xFF0000) >>
>  					0x10;
>  	/*
> +	 * For MFI skinny adapters, MEGASAS_SKINNY_INT_CMDS commands
> +	 * are reserved for IOCTL + driver's internal DCMDs.
> +	 */
> +	if ((instance->pdev->device =3D=3D PCI_DEVICE_ID_LSI_SAS0073SKINNY)=
 ||
> +		(instance->pdev->device =3D=3D PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
> +		instance->max_scsi_cmds =3D (instance->max_fw_cmds -
> +			MEGASAS_SKINNY_INT_CMDS);
> +		sema_init(&instance->ioctl_sem, MEGASAS_SKINNY_INT_CMDS);
> +	} else {
> +		instance->max_scsi_cmds =3D (instance->max_fw_cmds -
> +			MEGASAS_INT_CMDS);
> +		sema_init(&instance->ioctl_sem, (MEGASAS_INT_CMDS - 5));
'- 5' ?
I'd prefer to have a separate #define as you did for the fusion side...

> +	}
> +
> +	/*
>  	 * Create a pool of commands
>  	 */
>  	if (megasas_alloc_cmds(instance))
> @@ -4751,30 +4766,6 @@ static int megasas_init_fw(struct megasas_inst=
ance *instance)
>  	if (tmp_sectors && (instance->max_sectors_per_req > tmp_sectors))
>  		instance->max_sectors_per_req =3D tmp_sectors;
> =20
> -	/*
> -	 * 1. For fusion adapters, 3 commands for IOCTL and 5 commands
> -	 *    for driver's internal DCMDs.
> -	 * 2. For MFI skinny adapters, 5 commands for IOCTL + driver's
> -	 *    internal DCMDs.
> -	 * 3. For rest of MFI adapters, 27 commands reserved for IOCTLs
> -	 *    and 5 commands for drivers's internal DCMD.
> -	 */
> -	if (instance->ctrl_context) {
> -		instance->max_scsi_cmds =3D instance->max_fw_cmds -
> -					(MEGASAS_FUSION_INTERNAL_CMDS +
> -					MEGASAS_FUSION_IOCTL_CMDS);
> -		sema_init(&instance->ioctl_sem, MEGASAS_FUSION_IOCTL_CMDS);
> -	} else if ((instance->pdev->device =3D=3D PCI_DEVICE_ID_LSI_SAS0073=
SKINNY) ||
> -		(instance->pdev->device =3D=3D PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
> -		instance->max_scsi_cmds =3D instance->max_fw_cmds -
> -						MEGASAS_SKINNY_INT_CMDS;
> -		sema_init(&instance->ioctl_sem, MEGASAS_SKINNY_INT_CMDS);
> -	} else {
> -		instance->max_scsi_cmds =3D instance->max_fw_cmds -
> -						MEGASAS_INT_CMDS;
> -		sema_init(&instance->ioctl_sem, (MEGASAS_INT_CMDS - 5));
> -	}
> -
>  	/* Check for valid throttlequeuedepth module parameter */
>  	if (throttlequeuedepth &&
>  			throttlequeuedepth <=3D instance->max_scsi_cmds)
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/sc=
si/megaraid/megaraid_sas_fusion.c
> index c5619f8..3cd1d5f 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -1061,6 +1061,15 @@ megasas_init_adapter_fusion(struct megasas_ins=
tance *instance)
>  		fusion->last_reply_idx[i] =3D 0;
> =20
>  	/*
> +	 * For fusion adapters, 3 commands for IOCTL and 5 commands
> +	 * for driver's internal DCMDs.
> +	 */
> +	instance->max_scsi_cmds =3D instance->max_fw_cmds -
> +				(MEGASAS_FUSION_INTERNAL_CMDS +
> +				MEGASAS_FUSION_IOCTL_CMDS);
> +	sema_init(&instance->ioctl_sem, MEGASAS_FUSION_IOCTL_CMDS);
> +
> +	/*
>  	 * Allocate memory for descriptors
>  	 * Create a pool of commands
>  	 */
>=20
See? Here it's a #define ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
