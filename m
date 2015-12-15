From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] ses: fix additional element traversal bug
Date: Tue, 15 Dec 2015 12:27:50 +0100
Message-ID: <566FF936.5020605@suse.de>
References: <1449854198.2169.2.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33719 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964904AbbLOL1w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Dec 2015 06:27:52 -0500
In-Reply-To: <1449854198.2169.2.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

On 12/11/2015 06:16 PM, James Bottomley wrote:
> KASAN found that our additional element processing scripts drop off
> the end of the VPD page into unallocated space.  The reason is that
> not every element has additional information but our traversal
> routines think they do, leading to them expecting far more additional
> information than is present.  Fix this by adding a gate to the
> traversal routine so that it only processes elements that are expecte=
d
> to have additional information (list is in SES-2 section 6.1.13.1:
> Additional Element Status diagnostic page overview)
>
> Reported-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> Tested-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com=
>
>
> ---
>
> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> index 1736935..53ef1cb 100644
> --- a/drivers/scsi/ses.c
> +++ b/drivers/scsi/ses.c
> @@ -561,7 +561,15 @@ static void ses_enclosure_data_process(struct en=
closure_device *edev,
>   			if (desc_ptr)
>   				desc_ptr +=3D len;
>
> -			if (addl_desc_ptr)
> +			if (addl_desc_ptr &&
> +			    /* only find additional descriptions for specific devices */
> +			    (type_ptr[0] =3D=3D ENCLOSURE_COMPONENT_DEVICE ||
> +			     type_ptr[0] =3D=3D ENCLOSURE_COMPONENT_ARRAY_DEVICE ||
> +			     type_ptr[0] =3D=3D ENCLOSURE_COMPONENT_SAS_EXPANDER ||
> +			     /* these elements are optional */
> +			     type_ptr[0] =3D=3D ENCLOSURE_COMPONENT_SCSI_TARGET_PORT ||
> +			     type_ptr[0] =3D=3D ENCLOSURE_COMPONENT_SCSI_INITIATOR_PORT |=
|
> +			     type_ptr[0] =3D=3D ENCLOSURE_COMPONENT_CONTROLLER_ELECTRONIC=
S))
>   				addl_desc_ptr +=3D addl_desc_ptr[1] + 2;
>
>   		}
> diff --git a/include/linux/enclosure.h b/include/linux/enclosure.h
> index 7be22da..a4cf57c 100644
> --- a/include/linux/enclosure.h
> +++ b/include/linux/enclosure.h
> @@ -29,7 +29,11 @@
>   /* A few generic types ... taken from ses-2 */
>   enum enclosure_component_type {
>   	ENCLOSURE_COMPONENT_DEVICE =3D 0x01,
> +	ENCLOSURE_COMPONENT_CONTROLLER_ELECTRONICS =3D 0x07,
> +	ENCLOSURE_COMPONENT_SCSI_TARGET_PORT =3D 0x14,
> +	ENCLOSURE_COMPONENT_SCSI_INITIATOR_PORT =3D 0x15,
>   	ENCLOSURE_COMPONENT_ARRAY_DEVICE =3D 0x17,
> +	ENCLOSURE_COMPONENT_SAS_EXPANDER =3D 0x18,
>   };
>
>   /* ses-2 common element status */
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
