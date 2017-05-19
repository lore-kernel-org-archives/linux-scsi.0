From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 02/25] qla2xxx: Remove redundant fc_host_port_name call
Date: Fri, 19 May 2017 22:37:31 +0000
Message-ID: <1495233450.2581.7.camel@sandisk.com>
References: <20170519215344.2168-1-himanshu.madhani@cavium.com>
         <20170519215344.2168-3-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:51518 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755997AbdESWhe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 May 2017 18:37:34 -0400
In-Reply-To: <20170519215344.2168-3-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <0944C626703B9246994724E884E07532@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2017-05-19 at 14:53 -0700, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
>=20
> Remove redundant fc_host_port_name calls to prevent
> early access of scsi_host->shost_data buffer. This
> prevent null pointer access.
>=20
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_mbx.c | 9 ---------
>  1 file changed, 9 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index a113ab3592a7..12fea77e31c6 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -3676,15 +3676,6 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha=
,
>  				qlt_update_host_map(vha, id);
>  			}
> =20
> -			fc_host_port_name(vha->host) =3D
> -			    wwn_to_u64(vha->port_name);
> -
> -			if (qla_ini_mode_enabled(vha))
> -				ql_dbg(ql_dbg_mbx, vha, 0x1018,
> -				    "FA-WWN portname %016llx (%x)\n",
> -				    fc_host_port_name(vha->host),
> -				    rptid_entry->vp_status);
> -
>  			set_bit(REGISTER_FC4_NEEDED, &vha->dpc_flags);
>  			set_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags);
>  		} else {

Hello Himanshu,

If the above host port name assignment is redundant, what is the host
port name assignment it is redundant with?

Which of the removed statements could trigger a NULL pointer access, and
from what context? Is there perhaps a call trace available of the NULL
pointer access?

Thanks,

Bart.=
