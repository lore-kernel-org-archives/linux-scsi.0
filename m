From: "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>
Subject: RE: [PATCH v2] storvsc: Set up correct queue depth values for IDE
 devices
Date: Sat, 24 Mar 2018 16:50:59 +0000
Message-ID: <DM5PR2101MB1030FD5B6261CC7BCF0092D1DCAF0@DM5PR2101MB1030.namprd21.prod.outlook.com>
References: <20180322214718.29547-1-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180322214718.29547-1-longli@linuxonhyperv.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Long Li <longli@linuxonhyperv.com>, KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, "James E . J . Bottomley" <JBottomley@odin.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Long Li <longli@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org <linux-kernel-owner@vger.kernel.=
org> On Behalf
> Of Long Li
> Sent: Thursday, March 22, 2018 2:47 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.=
com>; Stephen
> Hemminger <sthemmin@microsoft.com>; James E . J . Bottomley <JBottomley@o=
din.com>;
> Martin K . Petersen <martin.petersen@oracle.com>; devel@linuxdriverprojec=
t.org; linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: Long Li <longli@microsoft.com>
> Subject: [PATCH v2] storvsc: Set up correct queue depth values for IDE de=
vices
>=20
> From: Long Li <longli@microsoft.com>
>=20
> Unlike SCSI and FC, we don't use multiple channels for IDE.
> Also fix the calculation for sub-channels.
>=20
> Change log:
> v2: Addressed comment on incorrect number of sub-channels.
> (Michael Kelley <Michael.H.Kelley@microsoft.com>)
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Reviewed-by: Michael Kelley <mikelley@microsoft.com>

> ---
>  drivers/scsi/storvsc_drv.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 8c51d628b52e..a2ec0bc9e9fa 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1722,11 +1722,14 @@ static int storvsc_probe(struct hv_device *device=
,
>  		max_targets =3D STORVSC_MAX_TARGETS;
>  		max_channels =3D STORVSC_MAX_CHANNELS;
>  		/*
> -		 * On Windows8 and above, we support sub-channels for storage.
> +		 * On Windows8 and above, we support sub-channels for storage
> +		 * on SCSI and FC controllers.
>  		 * The number of sub-channels offerred is based on the number of
>  		 * VCPUs in the guest.
>  		 */
> -		max_sub_channels =3D (num_cpus / storvsc_vcpus_per_sub_channel);
> +		if (!dev_is_ide)
> +			max_sub_channels =3D
> +				(num_cpus - 1) / storvsc_vcpus_per_sub_channel;
>  	}
>=20
>  	scsi_driver.can_queue =3D (max_outstanding_req_per_channel *
> --
> 2.14.1
