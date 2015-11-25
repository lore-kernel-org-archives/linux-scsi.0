From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v3 1/5] arcmsr: fixed getting wrong configuration data
Date: Wed, 25 Nov 2015 12:59:25 +0100
Message-ID: <1448452765.2877.74.camel@suse.de>
References: <1448451362.4670.29.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60049 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbbKYL71 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Nov 2015 06:59:27 -0500
In-Reply-To: <1448451362.4670.29.camel@Centos6.3-64>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>
Cc: hch@lst.de, hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de

On Wed, 2015-11-25 at 19:36 +0800, Ching Huang wrote:
> From: Ching Huang <ching2048@areca.com.tw>
>=20
> Fixed getting wrong configuration data of adapter type B and type D.
>=20
> Signed-of-by: Ching Huang <ching2048@areca.com.tw>
>=20
> ---
>=20
> diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c
> b/drivers/scsi/arcmsr/arcmsr_hba.c
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-23 16:25:22.000000000
> +0800
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-24 11:35:26.000000000
> +0800
> @@ -2694,15 +2694,15 @@ static bool arcmsr_hbaB_get_config(struc
> =C2=A0		acb->firm_model,
> =C2=A0		acb->firm_version);
> =C2=A0
> -	acb->signature =3D readl(&reg->message_rwbuffer[1]);
> +	acb->signature =3D readl(&reg->message_rwbuffer[0]);
> =C2=A0	/*firm_signature,1,00-03*/
> -	acb->firm_request_len =3D readl(&reg->message_rwbuffer[2]);
> +	acb->firm_request_len =3D readl(&reg->message_rwbuffer[1]);
> =C2=A0	/*firm_request_len,1,04-07*/
> -	acb->firm_numbers_queue =3D readl(&reg->message_rwbuffer[3]);
> +	acb->firm_numbers_queue =3D readl(&reg->message_rwbuffer[2]);
> =C2=A0	/*firm_numbers_queue,2,08-11*/
> -	acb->firm_sdram_size =3D readl(&reg->message_rwbuffer[4]);
> +	acb->firm_sdram_size =3D readl(&reg->message_rwbuffer[3]);
> =C2=A0	/*firm_sdram_size,3,12-15*/
> -	acb->firm_hd_channels =3D readl(&reg->message_rwbuffer[5]);
> +	acb->firm_hd_channels =3D readl(&reg->message_rwbuffer[4]);
> =C2=A0	/*firm_ide_channels,4,16-19*/
> =C2=A0	acb->firm_cfg_version =3D readl(&reg-
> >message_rwbuffer[25]);=C2=A0=C2=A0/*firm_cfg_version,25,100-103*/
> =C2=A0	/*firm_ide_channels,4,16-19*/
> @@ -2880,15 +2880,15 @@ static bool arcmsr_hbaD_get_config(struc
> =C2=A0		iop_device_map++;
> =C2=A0		count--;
> =C2=A0	}
> -	acb->signature =3D readl(&reg->msgcode_rwbuffer[1]);
> +	acb->signature =3D readl(&reg->msgcode_rwbuffer[0]);
> =C2=A0	/*firm_signature,1,00-03*/
> -	acb->firm_request_len =3D readl(&reg->msgcode_rwbuffer[2]);
> +	acb->firm_request_len =3D readl(&reg->msgcode_rwbuffer[1]);
> =C2=A0	/*firm_request_len,1,04-07*/
> -	acb->firm_numbers_queue =3D readl(&reg->msgcode_rwbuffer[3]);
> +	acb->firm_numbers_queue =3D readl(&reg->msgcode_rwbuffer[2]);
> =C2=A0	/*firm_numbers_queue,2,08-11*/
> -	acb->firm_sdram_size =3D readl(&reg->msgcode_rwbuffer[4]);
> +	acb->firm_sdram_size =3D readl(&reg->msgcode_rwbuffer[3]);
> =C2=A0	/*firm_sdram_size,3,12-15*/
> -	acb->firm_hd_channels =3D readl(&reg->msgcode_rwbuffer[5]);
> +	acb->firm_hd_channels =3D readl(&reg->msgcode_rwbuffer[4]);
> =C2=A0	/*firm_hd_channels,4,16-19*/
> =C2=A0	acb->firm_cfg_version =3D readl(&reg->msgcode_rwbuffer[25]);
> =C2=A0	pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",
>=20
>=20

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
