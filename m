From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 2/6] ibmvscsi: Add and use enums for valid CRQ header
 values
Date: Thu, 4 Feb 2016 09:39:17 +0100
Message-ID: <20160204083917.GV27969@c203.arch.suse.de>
References: <1454542114-1797-1-git-send-email-tyreld@linux.vnet.ibm.com>
 <1454542114-1797-3-git-send-email-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454542114-1797-3-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: JBottomley@odin.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, nfont@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 03, 2016 at 05:28:30PM -0600, Tyrel Datwyler wrote:
> The PAPR defines four valid header values for the first byte of a
> CRQ message. Namely, an unused/empty message (0x00), a valid
> command/response entry (0x80), a valid initialization entry (0xC0),
> and a transport event (0xFF). Define these values as enums and use
> them in the code in place of their magic number equivalents.
>=20
> Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvscsi.c | 14 +++++++-------
>  drivers/scsi/ibmvscsi/viosrp.h   |  7 +++++++
>  2 files changed, 14 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi=
/ibmvscsi.c
> index adfef9d..176260d 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -182,7 +182,7 @@ static struct viosrp_crq *crq_queue_next_crq(stru=
ct crq_queue *queue)
> =20
>  	spin_lock_irqsave(&queue->lock, flags);
>  	crq =3D &queue->msgs[queue->cur];
> -	if (crq->valid & 0x80) {
> +	if (crq->valid & VIOSRP_CRQ_VALID) {
>  		if (++queue->cur =3D=3D queue->size)
>  			queue->cur =3D 0;
> =20
> @@ -231,7 +231,7 @@ static void ibmvscsi_task(void *data)
>  		/* Pull all the valid messages off the CRQ */
>  		while ((crq =3D crq_queue_next_crq(&hostdata->queue)) !=3D NULL) {
>  			ibmvscsi_handle_crq(crq, hostdata);
> -			crq->valid =3D 0x00;
> +			crq->valid =3D VIOSRP_CRQ_FREE;
>  		}
> =20
>  		vio_enable_interrupts(vdev);
> @@ -239,7 +239,7 @@ static void ibmvscsi_task(void *data)
>  		if (crq !=3D NULL) {
>  			vio_disable_interrupts(vdev);
>  			ibmvscsi_handle_crq(crq, hostdata);
> -			crq->valid =3D 0x00;
> +			crq->valid =3D VIOSRP_CRQ_FREE;
>  		} else {
>  			done =3D 1;
>  		}
> @@ -474,7 +474,7 @@ static int initialize_event_pool(struct event_poo=
l *pool,
>  		struct srp_event_struct *evt =3D &pool->events[i];
>  		memset(&evt->crq, 0x00, sizeof(evt->crq));
>  		atomic_set(&evt->free, 1);
> -		evt->crq.valid =3D 0x80;
> +		evt->crq.valid =3D VIOSRP_CRQ_VALID;
>  		evt->crq.IU_length =3D cpu_to_be16(sizeof(*evt->xfer_iu));
>  		evt->crq.IU_data_ptr =3D cpu_to_be64(pool->iu_token +
>  			sizeof(*evt->xfer_iu) * i);
> @@ -1767,7 +1767,7 @@ static void ibmvscsi_handle_crq(struct viosrp_c=
rq *crq,
>  	struct srp_event_struct *evt_struct =3D
>  			(__force struct srp_event_struct *)crq->IU_data_ptr;
>  	switch (crq->valid) {
> -	case 0xC0:		/* initialization */
> +	case VIOSRP_CRQ_INIT:		/* initialization */
>  		switch (crq->format) {
>  		case 0x01:	/* Initialization message */
>  			dev_info(hostdata->dev, "partner initialized\n");
> @@ -1791,7 +1791,7 @@ static void ibmvscsi_handle_crq(struct viosrp_c=
rq *crq,
>  			dev_err(hostdata->dev, "unknown crq message type: %d\n", crq->for=
mat);
>  		}
>  		return;
> -	case 0xFF:	/* Hypervisor telling us the connection is closed */
> +	case VIOSRP_CRQ_TRANSPORT:	/* Hypervisor telling us the connection =
is closed */
>  		scsi_block_requests(hostdata->host);
>  		atomic_set(&hostdata->request_limit, 0);
>  		if (crq->format =3D=3D 0x06) {
> @@ -1807,7 +1807,7 @@ static void ibmvscsi_handle_crq(struct viosrp_c=
rq *crq,
>  			ibmvscsi_reset_host(hostdata);
>  		}
>  		return;
> -	case 0x80:		/* real payload */
> +	case VIOSRP_CRQ_VALID:		/* real payload */
>  		break;
>  	default:
>  		dev_err(hostdata->dev, "got an invalid message type 0x%02x\n",
> diff --git a/drivers/scsi/ibmvscsi/viosrp.h b/drivers/scsi/ibmvscsi/v=
iosrp.h
> index d1044e9..17f2de0 100644
> --- a/drivers/scsi/ibmvscsi/viosrp.h
> +++ b/drivers/scsi/ibmvscsi/viosrp.h
> @@ -51,6 +51,13 @@ union srp_iu {
>  	u8 reserved[SRP_MAX_IU_LEN];
>  };
> =20
> +enum viosrp_crq_headers {
> +	VIOSRP_CRQ_FREE =3D 0x00,
> +	VIOSRP_CRQ_VALID =3D 0x80,
> +	VIOSRP_CRQ_INIT =3D 0xC0,
> +	VIOSRP_CRQ_TRANSPORT =3D 0xFF
> +};
> +
>  enum viosrp_crq_formats {
>  	VIOSRP_SRP_FORMAT =3D 0x01,
>  	VIOSRP_MAD_FORMAT =3D 0x02,
> --=20
> 2.5.0
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
