From: Johannes Thumshirn <jthumshirn@suse.com>
Subject: Re: [PATCH 04/18] scsi_dh_alua: Use vpd_pg83 information
Date: Tue, 01 Dec 2015 10:53:40 +0100
Message-ID: <1448963620.3103.6.camel@suse.com>
References: <1448961418-29013-1-git-send-email-hare@suse.de>
	 <1448961418-29013-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44051 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707AbbLAJxm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Dec 2015 04:53:42 -0500
In-Reply-To: <1448961418-29013-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <jbottomley@odin.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Tue, 2015-12-01 at 10:16 +0100, Hannes Reinecke wrote:
> The SCSI device now has the VPD page 0x83 information attached,
> so there is no need to query it again.
>=20
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
> =C2=A0drivers/scsi/device_handler/scsi_dh_alua.c | 87 +++++++--------=
-------------
> --
> =C2=A01 file changed, 18 insertions(+), 69 deletions(-)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 7d01ef0..9b3b2f7 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -131,43 +131,6 @@ static struct request *get_alua_req(struct scsi_=
device
> *sdev,
> =C2=A0}
> =C2=A0
> =C2=A0/*
> - * submit_vpd_inquiry - Issue an INQUIRY VPD page 0x83 command
> - * @sdev: sdev the command should be sent to
> - */
> -static int submit_vpd_inquiry(struct scsi_device *sdev, struct alua_=
dh_data
> *h)
> -{
> -	struct request *rq;
> -	int err =3D SCSI_DH_RES_TEMP_UNAVAIL;
> -
> -	rq =3D get_alua_req(sdev, h->buff, h->bufflen, READ);
> -	if (!rq)
> -		goto done;
> -
> -	/* Prepare the command. */
> -	rq->cmd[0] =3D INQUIRY;
> -	rq->cmd[1] =3D 1;
> -	rq->cmd[2] =3D 0x83;
> -	rq->cmd[4] =3D h->bufflen;
> -	rq->cmd_len =3D COMMAND_SIZE(INQUIRY);
> -
> -	rq->sense =3D h->sense;
> -	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
> -	rq->sense_len =3D h->senselen =3D 0;
> -
> -	err =3D blk_execute_rq(rq->q, NULL, rq, 1);
> -	if (err =3D=3D -EIO) {
> -		sdev_printk(KERN_INFO, sdev,
> -			=C2=A0=C2=A0=C2=A0=C2=A0"%s: evpd inquiry failed with %x\n",
> -			=C2=A0=C2=A0=C2=A0=C2=A0ALUA_DH_NAME, rq->errors);
> -		h->senselen =3D rq->sense_len;
> -		err =3D SCSI_DH_IO;
> -	}
> -	blk_put_request(rq);
> -done:
> -	return err;
> -}
> -
> -/*
> =C2=A0 * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
> =C2=A0 * @sdev: sdev the command should be sent to
> =C2=A0 */
> @@ -359,43 +322,29 @@ static int alua_check_tpgs(struct scsi_device *=
sdev,
> struct alua_dh_data *h)
> =C2=A0}
> =C2=A0
> =C2=A0/*
> - * alua_vpd_inquiry - Evaluate INQUIRY vpd page 0x83
> + * alua_check_vpd - Evaluate INQUIRY vpd page 0x83
> =C2=A0 * @sdev: device to be checked
> =C2=A0 *
> =C2=A0 * Extract the relative target port and the target port group
> =C2=A0 * descriptor from the list of identificators.
> =C2=A0 */
> -static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh=
_data
> *h)
> +static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_d=
ata *h)
> =C2=A0{
> -	int len;
> -	unsigned err;
> =C2=A0	unsigned char *d;
> +	unsigned char __rcu *vpd_pg83;
> =C2=A0
> - retry:
> -	err =3D submit_vpd_inquiry(sdev, h);
> -
> -	if (err !=3D SCSI_DH_OK)
> -		return err;
> -
> -	/* Check if vpd page exceeds initial buffer */
> -	len =3D (h->buff[2] << 8) + h->buff[3] + 4;
> -	if (len > h->bufflen) {
> -		/* Resubmit with the correct length */
> -		if (realloc_buffer(h, len)) {
> -			sdev_printk(KERN_WARNING, sdev,
> -				=C2=A0=C2=A0=C2=A0=C2=A0"%s: kmalloc buffer failed\n",
> -				=C2=A0=C2=A0=C2=A0=C2=A0ALUA_DH_NAME);
> -			/* Temporary failure, bypass */
> -			return SCSI_DH_DEV_TEMP_BUSY;
> -		}
> -		goto retry;
> +	rcu_read_lock();
> +	if (!rcu_dereference(sdev->vpd_pg83)){
> +		rcu_read_unlock();
> +		return SCSI_DH_DEV_UNSUPP;
> =C2=A0	}
> =C2=A0
> =C2=A0	/*
> -	=C2=A0* Now look for the correct descriptor.
> +	=C2=A0* Look for the correct descriptor.
> =C2=A0	=C2=A0*/
> -	d =3D h->buff + 4;
> -	while (d < h->buff + len) {
> +	vpd_pg83 =3D rcu_dereference(sdev->vpd_pg83);
> +	d =3D vpd_pg83 + 4;
> +	while (d < vpd_pg83 + sdev->vpd_pg83_len) {
> =C2=A0		switch (d[1] & 0xf) {
> =C2=A0		case 0x4:
> =C2=A0			/* Relative target port */
> @@ -410,6 +359,7 @@ static int alua_vpd_inquiry(struct scsi_device *s=
dev,
> struct alua_dh_data *h)
> =C2=A0		}
> =C2=A0		d +=3D d[3] + 4;
> =C2=A0	}
> +	rcu_read_unlock();
> =C2=A0
> =C2=A0	if (h->group_id =3D=3D -1) {
> =C2=A0		/*
> @@ -422,14 +372,13 @@ static int alua_vpd_inquiry(struct scsi_device =
*sdev,
> struct alua_dh_data *h)
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0ALUA_DH_NAME);
> =C2=A0		h->state =3D TPGS_STATE_OPTIMIZED;
> =C2=A0		h->tpgs =3D TPGS_MODE_NONE;
> -		err =3D SCSI_DH_DEV_UNSUPP;
> -	} else {
> -		sdev_printk(KERN_INFO, sdev,
> -			=C2=A0=C2=A0=C2=A0=C2=A0"%s: port group %02x rel port %02x\n",
> -			=C2=A0=C2=A0=C2=A0=C2=A0ALUA_DH_NAME, h->group_id, h->rel_port);
> +		return SCSI_DH_DEV_UNSUPP;
> =C2=A0	}
> +	sdev_printk(KERN_INFO, sdev,
> +		=C2=A0=C2=A0=C2=A0=C2=A0"%s: port group %02x rel port %02x\n",
> +		=C2=A0=C2=A0=C2=A0=C2=A0ALUA_DH_NAME, h->group_id, h->rel_port);
> =C2=A0
> -	return err;
> +	return 0;
> =C2=A0}
> =C2=A0
> =C2=A0static char print_alua_state(int state)
> @@ -692,7 +641,7 @@ static int alua_initialize(struct scsi_device *sd=
ev,
> struct alua_dh_data *h)
> =C2=A0	if (err !=3D SCSI_DH_OK)
> =C2=A0		goto out;
> =C2=A0
> -	err =3D alua_vpd_inquiry(sdev, h);
> +	err =3D alua_check_vpd(sdev, h);
> =C2=A0	if (err !=3D SCSI_DH_OK)
> =C2=A0		goto out;
> =C2=A0

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
