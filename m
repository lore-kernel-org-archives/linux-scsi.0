From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH v2] qla2xxx: Protect access to qpair members with
 qpair->qp_lock
Date: Wed, 28 Jun 2017 16:33:16 +0000
Message-ID: <7686A840-575D-4760-8D83-372394F59041@cavium.com>
References: <20170623071011.21184-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0067.outbound.protection.outlook.com ([104.47.38.67]:55962
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752536AbdF1QdS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 12:33:18 -0400
In-Reply-To: <20170623071011.21184-1-jthumshirn@suse.de>
Content-Language: en-US
Content-ID: <499A949F5D27CD49B9CF1CA9822BD42A@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, Hannes Reinecke <hare@suse.de>, John Garry <john.garry@huawei.com>


> On Jun 23, 2017, at 12:10 AM, Johannes Thumshirn <jthumshirn@suse.de> wro=
te:
>=20
> In qla2xx_start_scsi_mq() and qla2xx_dif_start_scsi_mq() we grab the
> qpair->qp_lock but do access members of the qpair before having the lock.
> Re-order the locking sequence to have all read and write access to qpair
> members under the qpair->qp_lock.
>=20
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
> drivers/scsi/qla2xxx/qla_iocb.c | 23 +++++++++++++----------
> 1 file changed, 13 insertions(+), 10 deletions(-)
>=20
> Changes to v1:
> * Use __qla2x00_marker() instead of qla2x00_marker which is fit to be cal=
led
>  with the qp_lock held (John)
> * Don't protect qpair->online and qpair->difdix_supported as it's not
>  needed (Hannes)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index 8404f17f3c6c..c64036ddd365 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -1770,6 +1770,9 @@ qla2xxx_start_scsi_mq(srb_t *sp)
> 	struct qla_hw_data *ha =3D vha->hw;
> 	struct qla_qpair *qpair =3D sp->qpair;
>=20
> +	/* Acquire qpair specific lock */
> +	spin_lock_irqsave(&qpair->qp_lock, flags);
> +
> 	/* Setup qpair pointers */
> 	rsp =3D qpair->rsp;
> 	req =3D qpair->req;
> @@ -1779,15 +1782,14 @@ qla2xxx_start_scsi_mq(srb_t *sp)
>=20
> 	/* Send marker if required */
> 	if (vha->marker_needed !=3D 0) {
> -		if (qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL) !=3D
> -		    QLA_SUCCESS)
> +		if (__qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL) !=3D
> +		    QLA_SUCCESS) {
> +			spin_unlock_irqrestore(&qpair->qp_lock, flags);
> 			return QLA_FUNCTION_FAILED;
> +		}
> 		vha->marker_needed =3D 0;
> 	}
>=20
> -	/* Acquire qpair specific lock */
> -	spin_lock_irqsave(&qpair->qp_lock, flags);
> -
> 	/* Check for room in outstanding command list. */
> 	handle =3D req->current_outstanding_cmd;
> 	for (index =3D 1; index < req->num_outstanding_cmds; index++) {
> @@ -1942,6 +1944,8 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
> 			return qla2xxx_start_scsi_mq(sp);
> 	}
>=20
> +	spin_lock_irqsave(&qpair->qp_lock, flags);
> +
> 	/* Setup qpair pointers */
> 	rsp =3D qpair->rsp;
> 	req =3D qpair->req;
> @@ -1951,15 +1955,14 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
>=20
> 	/* Send marker if required */
> 	if (vha->marker_needed !=3D 0) {
> -		if (qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL) !=3D
> -		    QLA_SUCCESS)
> +		if (__qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL) !=3D
> +		    QLA_SUCCESS) {
> +			spin_unlock_irqrestore(&qpair->qp_lock, flags);
> 			return QLA_FUNCTION_FAILED;
> +		}
> 		vha->marker_needed =3D 0;
> 	}
>=20
> -	/* Acquire ring specific lock */
> -	spin_lock_irqsave(&qpair->qp_lock, flags);
> -
> 	/* Check for room in outstanding command list. */
> 	handle =3D req->current_outstanding_cmd;
> 	for (index =3D 1; index < req->num_outstanding_cmds; index++) {
> --=20
> 2.12.3
>=20

Looks Good.=20

Acked-By: Himanshu Madhani <himanshu.madhani@cavium.com>
