From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/25] scsi: hisi_sas: add phy SAS ADDR initialization
Date: Tue, 13 Oct 2015 08:12:27 +0200
Message-ID: <561CA0CB.5090802@suse.de>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com> <1444663237-238302-10-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46987 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbbJMGMa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Oct 2015 02:12:30 -0400
In-Reply-To: <1444663237-238302-10-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>, James.Bottomley@HansenPartnership.com
Cc: devicetree@vger.kernel.org, arnd@arndb.de, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie

On 10/12/2015 05:20 PM, John Garry wrote:
> This SAS ID is chosen as Huawei IEEE id: 001882
>=20
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas_init.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>=20
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_init.c b/drivers/scsi/his=
i_sas/hisi_sas_init.c
> index 44fc524..c295c39 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_init.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_init.c
> @@ -283,6 +283,19 @@ err_out:
>  	return NULL;
>  }
> =20
> +static void hisi_sas_init_add(struct hisi_hba *hisi_hba)
> +{
> +	u8 i;
> +
> +	/* Huawei IEEE id (001882) */
> +	for (i =3D 0; i < hisi_hba->n_phy; i++)
> +		hisi_hba->phy[i].dev_sas_addr =3D
> +			cpu_to_be64(0x5001882016072015ULL);
> +
Ouch. Each phy has the same SAS address?
=46or all boards? Ever?

Not sure if that's a good idea, nor even valid.
It'll confuse the hell out of any SAS array.

Please provide a means of having individual SAS addresses for each HBA.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
