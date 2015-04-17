From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 20/43] hpsa: add more ioaccel2 error handling, including
 underrun statuses.
Date: Fri, 17 Apr 2015 15:15:58 +0200
Message-ID: <5531078E.8060006@suse.de>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134833.30238.28782.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32861 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbbDQNQA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:16:00 -0400
In-Reply-To: <20150416134833.30238.28782.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:48 PM, Don Brace wrote:
> From: Joe Handzik <joseph.t.handzik@hp.com>
>=20
> improve ioaccel2 error handling, including better handling of
> underrun statuses
>=20
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Joe Handzik <joseph.t.handzik@hp.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c     |   33 ++++++++++++++++++++++++++++-----
>  drivers/scsi/hpsa_cmd.h |    6 ++++++
>  2 files changed, 34 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 1839761..fd9620d 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -1868,6 +1868,7 @@ static int handle_ioaccel_mode2_error(struct ct=
lr_info *h,
>  {
>  	int data_len;
>  	int retry =3D 0;
> +	u32 ioaccel2_resid =3D 0;
> =20
>  	switch (c2->error_data.serv_response) {
>  	case IOACCEL2_SERV_RESPONSE_COMPLETE:
> @@ -1926,11 +1927,33 @@ static int handle_ioaccel_mode2_error(struct =
ctlr_info *h,
>  		}
>  		break;
>  	case IOACCEL2_SERV_RESPONSE_FAILURE:
> -		/* don't expect to get here. */
> -		dev_warn(&h->pdev->dev,
> -			"unexpected delivery or target failure, status =3D 0x%02x\n",
> -			c2->error_data.status);
> -		retry =3D 1;
> +		switch (c2->error_data.status) {
> +		case IOACCEL2_STATUS_SR_IO_ERROR:
> +		case IOACCEL2_STATUS_SR_IO_ABORTED:
> +		case IOACCEL2_STATUS_SR_OVERRUN:
> +			retry =3D 1;
> +			break;
> +		case IOACCEL2_STATUS_SR_UNDERRUN:
> +			cmd->result =3D (DID_OK << 16);		/* host byte */
> +			cmd->result |=3D (COMMAND_COMPLETE << 8);	/* msg byte */
> +			ioaccel2_resid =3D c2->error_data.resid_cnt[3] << 24;
> +			ioaccel2_resid |=3D c2->error_data.resid_cnt[2] << 16;
> +			ioaccel2_resid |=3D c2->error_data.resid_cnt[1] << 8;
> +			ioaccel2_resid |=3D c2->error_data.resid_cnt[0];
> +			scsi_set_resid(cmd, ioaccel2_resid);
> +			break;
How curious. be32_to_cpu is probably a better choice here.

> +		case IOACCEL2_STATUS_SR_NO_PATH_TO_DEVICE:
> +		case IOACCEL2_STATUS_SR_INVALID_DEVICE:
> +		case IOACCEL2_STATUS_SR_IOACCEL_DISABLED:
> +			/* We will get an event from ctlr to trigger rescan */
> +			retry =3D 1;
> +			break;
> +		default:
> +			retry =3D 1;
> +			dev_warn(&h->pdev->dev,
> +				"unexpected delivery or target failure, status =3D 0x%02x\n",
> +				c2->error_data.status);
> +		}
>  		break;
>  	case IOACCEL2_SERV_RESPONSE_TMF_COMPLETE:
>  		break;
> diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
> index 0efb6f2b..cecb62b 100644
> --- a/drivers/scsi/hpsa_cmd.h
> +++ b/drivers/scsi/hpsa_cmd.h
> @@ -532,6 +532,12 @@ struct io_accel2_scsi_response {
>  #define IOACCEL2_STATUS_SR_TASK_COMP_SET_FULL	0x28
>  #define IOACCEL2_STATUS_SR_TASK_COMP_ABORTED	0x40
>  #define IOACCEL2_STATUS_SR_IOACCEL_DISABLED	0x0E
> +#define IOACCEL2_STATUS_SR_IO_ERROR		0x01
> +#define IOACCEL2_STATUS_SR_IO_ABORTED		0x02
> +#define IOACCEL2_STATUS_SR_NO_PATH_TO_DEVICE	0x03
> +#define IOACCEL2_STATUS_SR_INVALID_DEVICE	0x04
> +#define IOACCEL2_STATUS_SR_UNDERRUN		0x51
> +#define IOACCEL2_STATUS_SR_OVERRUN		0x75
>  	u8 data_present;		/* low 2 bits */
>  #define IOACCEL2_NO_DATAPRESENT		0x000
>  #define IOACCEL2_RESPONSE_DATAPRESENT	0x001
>=20
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
