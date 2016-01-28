From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 08/11] qla2xxx: Provide mbx info in BBCR data after
 mbx failure
Date: Thu, 28 Jan 2016 10:00:31 +0100
Message-ID: <20160128090031.GM27565@c203.arch.suse.de>
References: <1453914218-380-1-git-send-email-himanshu.madhani@qlogic.com>
 <1453914218-380-9-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33481 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165AbcA1JAd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jan 2016 04:00:33 -0500
Content-Disposition: inline
In-Reply-To: <1453914218-380-9-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On Wed, Jan 27, 2016 at 12:03:35PM -0500, Himanshu Madhani wrote:
> From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
>=20
> Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_bsg.c |    9 +++++++--
>  drivers/scsi/qla2xxx/qla_bsg.h |    4 +++-
>  2 files changed, 10 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/ql=
a_bsg.c
> index 913fef2..392c147 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -2204,8 +2204,12 @@ qla27xx_get_bbcr_data(struct fc_bsg_job *bsg_j=
ob)
>  	if (bbcr.status =3D=3D QLA_BBCR_STATUS_ENABLED) {
>  		rval =3D qla2x00_get_adapter_id(vha, &loop_id, &al_pa,
>  			&area, &domain, &topo, &sw_cap);
> -		if (rval !=3D QLA_SUCCESS)
> -			return -EIO;
> +		if (rval !=3D QLA_SUCCESS) {
> +			bbcr.status =3D QLA_BBCR_STATUS_UNKNOWN;
> +			bbcr.state =3D QLA_BBCR_STATE_OFFLINE;
> +			bbcr.mbx1 =3D loop_id;
> +			goto done;
> +		}
> =20
>  		state =3D (vha->bbcr >> 12) & 0x1;
> =20
> @@ -2220,6 +2224,7 @@ qla27xx_get_bbcr_data(struct fc_bsg_job *bsg_jo=
b)
>  		bbcr.configured_bbscn =3D vha->bbcr & 0xf;
>  	}
> =20
> +done:
>  	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
>  		bsg_job->reply_payload.sg_cnt, &bbcr, sizeof(bbcr));
>  	bsg_job->reply->reply_payload_rcv_len =3D sizeof(bbcr);
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/ql=
a_bsg.h
> index c40dd8b..c80192d 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.h
> +++ b/drivers/scsi/qla2xxx/qla_bsg.h
> @@ -245,6 +245,7 @@ struct qla_flash_update_caps {
>  /* BB_CR Status */
>  #define QLA_BBCR_STATUS_DISABLED       0
>  #define QLA_BBCR_STATUS_ENABLED        1
> +#define QLA_BBCR_STATUS_UNKNOWN        2
> =20
>  /* BB_CR State */
>  #define QLA_BBCR_STATE_OFFLINE         0
> @@ -262,6 +263,7 @@ struct  qla_bbcr_data {
>  	uint8_t   configured_bbscn;       /* 0-15 */
>  	uint8_t   negotiated_bbscn;       /* 0-15 */
>  	uint8_t   offline_reason_code;
> -	uint8_t   reserved[11];
> +	uint16_t  mbx1;			/* Port state */
> +	uint8_t   reserved[9];
>  } __packed;
>  #endif
> --=20
> 1.7.7
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
