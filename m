From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 33/35] scsi: Use scsi_target as argument for
 eh_target_reset_handler()
Date: Fri, 23 Jun 2017 18:34:25 +0000
Message-ID: <1498242864.2735.15.camel@wdc.com>
References: <1498222975-71858-1-git-send-email-hare@suse.de>
         <1498222975-71858-34-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:39202 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754327AbdFWSe1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jun 2017 14:34:27 -0400
In-Reply-To: <1498222975-71858-34-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <F9349940BEEE374E999A3D1C099CC350@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

On Fri, 2017-06-23 at 15:02 +0200, Hannes Reinecke wrote:
> -static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
> +/*
> + * Note: We need to select a LUN as the storage array doesn't
> + * necessarily supports LUN 0 and might refuse the target reset.
> + */
> +static int zfcp_scsi_eh_target_reset_handler(struct scsi_target *starget=
)

A minor comment: I assume that "supports" should have been "support"?

> -static int pmcraid_eh_target_reset_handler(struct scsi_cmnd *scmd)
> +static int pmcraid_eh_target_reset_handler(struct scsi_target *starget)
>  {
> -	scmd_printk(KERN_INFO, scmd,
> +	struct Scsi_Host *shost =3D dev_to_shost(&starget->dev);
> +	struct scsi_device *scsi_dev =3D NULL, *tmp;
> +
> +	shost_for_each_device(tmp, shost) {
> +		if ((tmp->channel =3D=3D starget->channel) &&
> +		    (tmp->id =3D=3D starget->id)) {
> +			scsi_dev =3D tmp;
> +			break;
> +		}
> +	}
> +	if (!scsi_dev)
> +		return FAILED;
> +	sdev_printk(KERN_INFO, scsi_dev,
>  		    "Doing target reset due to an I/O command timeout.\n");
> -	return pmcraid_reset_device(scmd->device,
> +	return pmcraid_reset_device(scsi_dev,
>  				    PMCRAID_INTERNAL_TIMEOUT,
>  				    RESET_DEVICE_TARGET);
>  }

Is this sdev_printk() statement really useful? If any kernel messages are
reported due to a reset, shouldn't that be done by the SCSI core instead of
by a SCSI LLD?

>  void qedf_wait_for_upload(struct qedf_ctx *qedf)
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index f02a2ba..443bb29 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -1337,7 +1337,6 @@ static int is_rom_cmd(uint16_t cmd)
>  	struct req_que *req;
>  	struct rsp_que *rsp;
> =20
> -	l =3D l;
>  	vha =3D fcport->vha;
> =20
>  	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x103e,

That's a real gem ...

Although I'm not familiar enough with all the drivers that are modified by
this patch to do an in-depth review, as far as I can see the changes in thi=
s
patch look fine to me. Hence:

Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>=
