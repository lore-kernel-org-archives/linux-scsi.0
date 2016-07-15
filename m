From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 14/19] qla2xxx: Correction to function
 qla26xx_dport_diagnostics().
Date: Fri, 15 Jul 2016 14:59:34 +0200
Message-ID: <4705f051-8e7b-8c3c-80ff-6953a93769b3@suse.de>
References: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
 <1467818075-15246-15-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52868 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbcGOM7g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2016 08:59:36 -0400
In-Reply-To: <1467818075-15246-15-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On 07/06/2016 05:14 PM, Himanshu Madhani wrote:
> From: Joe Carnuccio <joe.carnuccio@qlogic.com>
>=20
> Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_dbg.c | 2 +-
>  drivers/scsi/qla2xxx/qla_isr.c | 8 +++-----
>  drivers/scsi/qla2xxx/qla_mbx.c | 5 -----
>  3 files changed, 4 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/ql=
a_dbg.c
> index 288338d..1a04270 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.c
> +++ b/drivers/scsi/qla2xxx/qla_dbg.c
> @@ -14,7 +14,7 @@
>   * | Module Init and Probe        |       0x0191       | 0x0146     =
    |
>   * |                              |                    | 0x015b-0x01=
60	|
>   * |                              |                    | 0x016e		|
> - * | Mailbox commands             |       0x1196       |		|
> + * | Mailbox commands             |       0x1196       | 0x1193		|
>   * |                              |                    |		|
>   * | Device Discovery             |       0x2003       | 0x2016		|
>   * |                              |                    | 0x2011-0x20=
12, |
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/ql=
a_isr.c
> index 134ad2f..1b87977 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1159,13 +1159,11 @@ global_port_update:
> =20
>  	case MBA_DPORT_DIAGNOSTICS:
>  		ql_dbg(ql_dbg_async, vha, 0x5052,
> -		    "D-Port Diagnostics: %04x result=3D%s index=3D%u size=3D%u\n",
> +		    "D-Port Diagnostics: %04x result=3D%s\n",
>  		    mb[0],
>  		    mb[1] =3D=3D 0 ? "start" :
> -		    mb[1] =3D=3D 1 ? "done (ok)" :
> -		    mb[1] =3D=3D 2 ? "done (error)" : "other",
> -		    LSB(mb[2]),
> -		    mb[3]);
> +		    mb[1] =3D=3D 1 ? "done (pass)" :
> +		    mb[1] =3D=3D 2 ? "done (error)" : "other");
>  		break;
> =20
>  	case MBA_TEMPERATURE_ALERT:
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/ql=
a_mbx.c
> index 0f7b83a..bf16e6f 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -5764,11 +5764,6 @@ qla26xx_dport_diagnostics(scsi_qla_host_t *vha=
,
>  	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1192,
>  	    "Entered %s.\n", __func__);
> =20
> -	if (size < 1024) {
> -		ql_log(ql_log_warn, vha, 0x1193, "Failed insufficient size.\n");
> -		return QLA_FUNCTION_PARAMETER_ERROR;
> -	}
> -
>  	dd_dma =3D dma_map_single(&vha->hw->pdev->dev,
>  	    dd_buf, size, DMA_FROM_DEVICE);
>  	if (!dd_dma) {
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
