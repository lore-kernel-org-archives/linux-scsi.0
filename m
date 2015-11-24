From: Johannes Thumshirn <jthumshirn@suse.com>
Subject: Re: [PATCH 12/18] scsi_dh_alua: use unaligned access macros
Date: Tue, 24 Nov 2015 13:17:02 +0100
Message-ID: <1448367422.2877.21.camel@suse.com>
References: <1447081703-110552-1-git-send-email-hare@suse.de>
	 <1447081703-110552-13-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46636 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbbKXMRE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2015 07:17:04 -0500
In-Reply-To: <1447081703-110552-13-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On Mon, 2015-11-09 at 16:08 +0100, Hannes Reinecke wrote:
> Use 'get_unaligned_XX' and 'put_unaligned_XX' instead of
> open-coding it.
>=20
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
> =C2=A0drivers/scsi/device_handler/scsi_dh_alua.c | 23 ++++++++-------=
---
> -----
> =C2=A01 file changed, 8 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 03f8190..d54f42e 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -22,6 +22,7 @@
> =C2=A0#include <linux/slab.h>
> =C2=A0#include <linux/delay.h>
> =C2=A0#include <linux/module.h>
> +#include <asm/unaligned.h>
> =C2=A0#include <scsi/scsi.h>
> =C2=A0#include <scsi/scsi_dbg.h>
> =C2=A0#include <scsi/scsi_eh.h>
> @@ -152,10 +153,7 @@ static unsigned submit_rtpg(struct scsi_device
> *sdev, struct alua_dh_data *h)
> =C2=A0		rq->cmd[1] =3D MI_REPORT_TARGET_PGS |
> MI_EXT_HDR_PARAM_FMT;
> =C2=A0	else
> =C2=A0		rq->cmd[1] =3D MI_REPORT_TARGET_PGS;
> -	rq->cmd[6] =3D (h->bufflen >> 24) & 0xff;
> -	rq->cmd[7] =3D (h->bufflen >> 16) & 0xff;
> -	rq->cmd[8] =3D (h->bufflen >>=C2=A0=C2=A08) & 0xff;
> -	rq->cmd[9] =3D h->bufflen & 0xff;
> +	put_unaligned_be32(h->bufflen, &rq->cmd[6]);
> =C2=A0	rq->cmd_len =3D COMMAND_SIZE(MAINTENANCE_IN);
> =C2=A0
> =C2=A0	rq->sense =3D h->sense;
> @@ -236,8 +234,7 @@ static unsigned submit_stpg(struct alua_dh_data
> *h)
> =C2=A0	/* Prepare the data buffer */
> =C2=A0	memset(h->buff, 0, stpg_len);
> =C2=A0	h->buff[4] =3D TPGS_STATE_OPTIMIZED & 0x0f;
> -	h->buff[6] =3D (h->group_id >> 8) & 0xff;
> -	h->buff[7] =3D h->group_id & 0xff;
> +	put_unaligned_be16(h->group_id, &h->buff[6]);
> =C2=A0
> =C2=A0	rq =3D get_alua_req(sdev, h->buff, stpg_len, WRITE);
> =C2=A0	if (!rq)
> @@ -246,10 +243,7 @@ static unsigned submit_stpg(struct alua_dh_data
> *h)
> =C2=A0	/* Prepare the command. */
> =C2=A0	rq->cmd[0] =3D MAINTENANCE_OUT;
> =C2=A0	rq->cmd[1] =3D MO_SET_TARGET_PGS;
> -	rq->cmd[6] =3D (stpg_len >> 24) & 0xff;
> -	rq->cmd[7] =3D (stpg_len >> 16) & 0xff;
> -	rq->cmd[8] =3D (stpg_len >>=C2=A0=C2=A08) & 0xff;
> -	rq->cmd[9] =3D stpg_len & 0xff;
> +	put_unaligned_be32(stpg_len, &rq->cmd[6]);
> =C2=A0	rq->cmd_len =3D COMMAND_SIZE(MAINTENANCE_OUT);
> =C2=A0
> =C2=A0	rq->sense =3D h->sense;
> @@ -343,11 +337,11 @@ static int alua_check_vpd(struct scsi_device
> *sdev, struct alua_dh_data *h)
> =C2=A0		switch (d[1] & 0xf) {
> =C2=A0		case 0x4:
> =C2=A0			/* Relative target port */
> -			h->rel_port =3D (d[6] << 8) + d[7];
> +			h->rel_port =3D get_unaligned_be16(&d[6]);
> =C2=A0			break;
> =C2=A0		case 0x5:
> =C2=A0			/* Target port group */
> -			h->group_id =3D (d[6] << 8) + d[7];
> +			h->group_id =3D get_unaligned_be16(&d[6]);
> =C2=A0			break;
> =C2=A0		default:
> =C2=A0			break;
> @@ -540,8 +534,7 @@ static int alua_rtpg(struct scsi_device *sdev,
> struct alua_dh_data *h, int wait_
> =C2=A0		return SCSI_DH_IO;
> =C2=A0	}
> =C2=A0
> -	len =3D (h->buff[0] << 24) + (h->buff[1] << 16) +
> -		(h->buff[2] << 8) + h->buff[3] + 4;
> +	len =3D get_unaligned_be32(&h->buff[0]) + 4;
> =C2=A0
> =C2=A0	if (len > h->bufflen) {
> =C2=A0		/* Resubmit with the correct length */
> @@ -576,7 +569,7 @@ static int alua_rtpg(struct scsi_device *sdev,
> struct alua_dh_data *h, int wait_
> =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0k < len;
> =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0k +=3D off, ucp +=3D off) {
> =C2=A0
> -		if (h->group_id =3D=3D (ucp[2] << 8) + ucp[3]) {
> +		if (h->group_id =3D=3D get_unaligned_be16(&ucp[2])) {
> =C2=A0			h->state =3D ucp[0] & 0x0f;
> =C2=A0			h->pref =3D ucp[0] >> 7;
> =C2=A0			valid_states =3D ucp[1];

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
