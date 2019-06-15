From: Michael Kelley <mikelley@microsoft.com>
Subject: RE: [PATCH] scsi: storvsc: Add ability to change scsi queue depth
Date: Sat, 15 Jun 2019 18:19:00 +0000
Message-ID: <BL0PR2101MB13482F73342F77866D6A6AABD7E90@BL0PR2101MB1348.namprd21.prod.outlook.com>
References: <20190614234822.5193-1-brandonbonaby94@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190614234822.5193-1-brandonbonaby94@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, "sashal@kernel.org" <sashal@kernel.org>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: brandonbonaby94 <brandonbonaby94@gmail.com>, "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Branden Bonaby <brandonbonaby94@gmail.com> Sent: Friday, June 14, 201=
9 4:48 PM
>=20
> Adding functionality to allow the SCSI queue depth to be changed,
> by utilizing the "scsi_change_queue_depth" function.
>=20
> Signed-off-by: Branden Bonaby <brandonbonaby94@gmail.com>
> ---
>  drivers/scsi/storvsc_drv.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>=20
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 8472de1007ff..719ca9906fc2 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -387,6 +387,7 @@ enum storvsc_request_type {
>=20
>  static int storvsc_ringbuffer_size =3D (128 * 1024);
>  static u32 max_outstanding_req_per_channel;
> +static int storvsc_change_queue_depth(struct scsi_device *sdev, int queu=
e_depth);
>=20
>  static int storvsc_vcpus_per_sub_channel =3D 4;
>=20
> @@ -1711,6 +1712,7 @@ static struct scsi_host_template scsi_driver =3D {
>  	.dma_boundary =3D		PAGE_SIZE-1,
>  	.no_write_same =3D	1,
>  	.track_queue_depth =3D	1,
> +	.change_queue_depth =3D	storvsc_change_queue_depth,
>  };
>=20
>  enum {
> @@ -1917,6 +1919,15 @@ static int storvsc_probe(struct hv_device *device,
>  	return ret;
>  }
>=20
> +/* Change a scsi target's queue depth */
> +static int storvsc_change_queue_depth(struct scsi_device *sdev, int queu=
e_depth)
> +{
> +	if (queue_depth > scsi_driver.can_queue){
> +		queue_depth =3D scsi_driver.can_queue;
> +	}
> +	return scsi_change_queue_depth(sdev, queue_depth);
> +}
> +
>  static int storvsc_remove(struct hv_device *dev)
>  {
>  	struct storvsc_device *stor_device =3D hv_get_drvdata(dev);
> --
> 2.17.1

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
