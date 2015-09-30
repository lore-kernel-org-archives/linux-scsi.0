From: =?utf-8?B?IlTDs3RoIEF0dGlsYSI=?= <atoth@atoth.sote.hu>
Subject: Re: twa generates WARNING upon boot
Date: Wed, 30 Sep 2015 22:18:35 +0200
Message-ID: <4842895e93cd2ce66b77390fdba98eb5.squirrel@atoth.sote.hu>
References: <1443548266.2207.19.camel@HansenPartnership.com>
    <1443549768.2207.22.camel@HansenPartnership.com>
    <95d34bcc4c0fcf84d02d76a4443ba07c.squirrel@atoth.sote.hu>
    <1443551581.2207.26.camel@HansenPartnership.com>
    <20150930160835.GA16534@infradead.org>
    <1443629730.2185.25.camel@HansenPartnership.com>
    <20150930163147.GA2928@infradead.org>
    <1443630984.2185.27.camel@HansenPartnership.com>
    <20150930164123.GA24596@infradead.org>
    <1443631408.2185.32.camel@HansenPartnership.com>
    <20150930164426.GA4169@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atoth.sote.hu ([195.111.75.211]:43620 "EHLO atoth.sote.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932722AbbI3UTJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Sep 2015 16:19:09 -0400
In-Reply-To: <20150930164426.GA4169@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, adam radford <aradford@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>

2015.Szeptember 30.(Sze) 18:44 id=C5=91pontban Christoph Hellwig ezt =C3=
=ADrta:
> On Wed, Sep 30, 2015 at 09:43:28AM -0700, James Bottomley wrote:
>> OK, post a compilable version of the patch and lets get the reporter=
 to
>> try it out.  Not resurrecting esoteric flags suits me.

No WARNINGs upon reboot using this patch, either. The controller seems =
to
work properly so far.

Thanks:
Dw.
--=20
dr T=C3=B3th Attila, Radiol=C3=B3gus, 06-20-825-8057
Attila Toth MD, Radiologist, +36-20-825-8057

> Right here:
>
> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index add419d..a56a7b2 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -212,6 +212,17 @@ static const struct file_operations twa_fops =3D=
 {
>  	.llseek		=3D noop_llseek,
>  };
>
> +/*
> + * The controllers use an inline buffer instead of a mapped SGL for
> small,
> + * single entry buffers.  Note that we treat a zero-length transfer =
like
> + * a mapped SGL.
> + */
> +static bool twa_command_mapped(struct scsi_cmnd *cmd)
> +{
> +	return scsi_sg_count(cmd) !=3D 1 ||
> +		scsi_bufflen(cmd) >=3D TW_MIN_SGL_LENGTH;
> +}
> +
>  /* This function will complete an aen request from the isr */
>  static int twa_aen_complete(TW_Device_Extension *tw_dev, int request=
_id)
>  {
> @@ -1339,7 +1350,8 @@ static irqreturn_t twa_interrupt(int irq, void
> *dev_instance)
>  				}
>
>  				/* Now complete the io */
> -				scsi_dma_unmap(cmd);
> +				if (twa_command_mapped(cmd))
> +					scsi_dma_unmap(cmd);
>  				cmd->scsi_done(cmd);
>  				tw_dev->state[request_id] =3D TW_S_COMPLETED;
>  				twa_free_request_id(tw_dev, request_id);
> @@ -1582,7 +1594,8 @@ static int
> twa_reset_device_extension(TW_Device_Extension *tw_dev)
>  				struct scsi_cmnd *cmd =3D tw_dev->srb[i];
>
>  				cmd->result =3D (DID_RESET << 16);
> -				scsi_dma_unmap(cmd);
> +				if (twa_command_mapped(cmd))
> +					scsi_dma_unmap(cmd);
>  				cmd->scsi_done(cmd);
>  			}
>  		}
> @@ -1765,12 +1778,14 @@ static int twa_scsi_queue_lck(struct scsi_cmn=
d
> *SCpnt, void (*done)(struct scsi_
>  	retval =3D twa_scsiop_execute_scsi(tw_dev, request_id, NULL, 0, NUL=
L);
>  	switch (retval) {
>  	case SCSI_MLQUEUE_HOST_BUSY:
> -		scsi_dma_unmap(SCpnt);
> +		if (twa_command_mapped(SCpnt))
> +			scsi_dma_unmap(SCpnt);
>  		twa_free_request_id(tw_dev, request_id);
>  		break;
>  	case 1:
>  		SCpnt->result =3D (DID_ERROR << 16);
> -		scsi_dma_unmap(SCpnt);
> +		if (twa_command_mapped(SCpnt))
> +			scsi_dma_unmap(SCpnt);
>  		done(SCpnt);
>  		tw_dev->state[request_id] =3D TW_S_COMPLETED;
>  		twa_free_request_id(tw_dev, request_id);
> @@ -1831,8 +1846,7 @@ static int
> twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
>  		/* Map sglist from scsi layer to cmd packet */
>
>  		if (scsi_sg_count(srb)) {
> -			if ((scsi_sg_count(srb) =3D=3D 1) &&
> -			    (scsi_bufflen(srb) < TW_MIN_SGL_LENGTH)) {
> +			if (!twa_command_mapped(srb)) {
>  				if (srb->sc_data_direction =3D=3D DMA_TO_DEVICE ||
>  				    srb->sc_data_direction =3D=3D DMA_BIDIRECTIONAL)
>  					scsi_sg_copy_to_buffer(srb,
> @@ -1905,7 +1919,7 @@ static void
> twa_scsiop_execute_scsi_complete(TW_Device_Extension *tw_dev, int re
>  {
>  	struct scsi_cmnd *cmd =3D tw_dev->srb[request_id];
>
> -	if (scsi_bufflen(cmd) < TW_MIN_SGL_LENGTH &&
> +	if (!twa_command_mapped(cmd) &&
>  	    (cmd->sc_data_direction =3D=3D DMA_FROM_DEVICE ||
>  	     cmd->sc_data_direction =3D=3D DMA_BIDIRECTIONAL)) {
>  		if (scsi_sg_count(cmd) =3D=3D 1) {
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
