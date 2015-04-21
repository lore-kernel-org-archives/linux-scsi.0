From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RESEND 18/18] megaraid_sas : swap whole register in megasas_register_aen
Date: Tue, 21 Apr 2015 12:33:05 +0200
Message-ID: <55362761.8030402@suse.de>
References: <201504201237.t3KCbWt3016906@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33463 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbbDUKdG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2015 06:33:06 -0400
In-Reply-To: <201504201237.t3KCbWt3016906@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

On 04/20/2015 02:35 PM, Sumit.Saxena@avagotech.com wrote:
> Swap the whole 32 bits we read from the hardware instead of swapping
> just the 16bits we care about in place later.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi=
/megaraid/megaraid_sas_base.c
> index e863701..fa6c3c9 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -4923,8 +4923,9 @@ megasas_register_aen(struct megasas_instance *i=
nstance, u32 seq_num,
> =20
>  	if (instance->aen_cmd) {
> =20
> -		prev_aen.word =3D instance->aen_cmd->frame->dcmd.mbox.w[1];
> -		prev_aen.members.locale =3D le16_to_cpu(prev_aen.members.locale);
> +		prev_aen.word =3D
> +			le32_to_cpu(instance->aen_cmd->frame->dcmd.mbox.w[1]);
> +		prev_aen.members.locale =3D prev_aen.members.locale;
> =20
>  		/*
>  		 * A class whose enum value is smaller is inclusive of all
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

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
