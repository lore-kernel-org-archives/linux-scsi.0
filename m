From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 3/4] scsi: storvsc: Refactor the code in
 storvsc_channel_init()
Date: Fri, 11 Dec 2015 10:02:29 +0100
Message-ID: <20151211090229.GE9903@c203.arch.suse.de>
References: <1449792829-15406-1-git-send-email-kys@microsoft.com>
 <1449792860-15447-1-git-send-email-kys@microsoft.com>
 <1449792860-15447-3-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449792860-15447-3-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 10, 2015 at 04:14:19PM -0800, K. Y. Srinivasan wrote:
> The function storvsc_channel_init() repeatedly interacts with the hos=
t to
> extract various channel properties. Refactor this code to eliminate c=
ode
> repetition.
>=20
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Long Li <longli@microsoft.com>
> Tested-by: Alex Ng <alexng@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c |  155 ++++++++++++++++------------------=
----------
>  1 files changed, 57 insertions(+), 98 deletions(-)
>=20
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index b94d471..6f18e94 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -721,29 +721,16 @@ static void cache_wwn(struct storvsc_device *st=
or_device,
>  	}
>  }
> =20
> -static int storvsc_channel_init(struct hv_device *device, bool is_fc=
)
> +static int storvsc_execute_vstor_op(struct hv_device *device,
> +				    struct storvsc_cmd_request *request,
> +				    bool status_check)
>  {
> -	struct storvsc_device *stor_device;
> -	struct storvsc_cmd_request *request;
>  	struct vstor_packet *vstor_packet;
> -	int ret, t, i;
> -	int max_chns;
> -	bool process_sub_channels =3D false;
> -
> -	stor_device =3D get_out_stor_device(device);
> -	if (!stor_device)
> -		return -ENODEV;
> +	int ret, t;
> =20
> -	request =3D &stor_device->init_request;
>  	vstor_packet =3D &request->vstor_packet;
> =20
> -	/*
> -	 * Now, initiate the vsc/vsp initialization protocol on the open
> -	 * channel
> -	 */
> -	memset(request, 0, sizeof(struct storvsc_cmd_request));
>  	init_completion(&request->wait_event);
> -	vstor_packet->operation =3D VSTOR_OPERATION_BEGIN_INITIALIZATION;
>  	vstor_packet->flags =3D REQUEST_COMPLETION_FLAG;
> =20
>  	ret =3D vmbus_sendpacket(device->channel, vstor_packet,
> @@ -753,27 +740,62 @@ static int storvsc_channel_init(struct hv_devic=
e *device, bool is_fc)
>  			       VM_PKT_DATA_INBAND,
>  			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
>  	if (ret !=3D 0)
> -		goto cleanup;
> +		goto done;
> =20
>  	t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
>  	if (t =3D=3D 0) {
>  		ret =3D -ETIMEDOUT;
> -		goto cleanup;
> +		goto done;
>  	}
> =20
> +	if (!status_check)
> +		goto done;
> +
>  	if (vstor_packet->operation !=3D VSTOR_OPERATION_COMPLETE_IO ||
>  	    vstor_packet->status !=3D 0) {
>  		ret =3D -EINVAL;
> -		goto cleanup;
> +		goto done;
>  	}
> =20
> +done:
> +	return ret;
> +}
> +
> +static int storvsc_channel_init(struct hv_device *device, bool is_fc=
)
> +{
> +	struct storvsc_device *stor_device;
> +	struct storvsc_cmd_request *request;
> +	struct vstor_packet *vstor_packet;
> +	int ret, i;
> +	int max_chns;
> +	bool process_sub_channels =3D false;
> +
> +	stor_device =3D get_out_stor_device(device);
> +	if (!stor_device)
> +		return -ENODEV;
> +
> +	request =3D &stor_device->init_request;
> +	vstor_packet =3D &request->vstor_packet;
> +
> +	/*
> +	 * Now, initiate the vsc/vsp initialization protocol on the open
> +	 * channel
> +	 */
> +	memset(request, 0, sizeof(struct storvsc_cmd_request));
> +	vstor_packet->operation =3D VSTOR_OPERATION_BEGIN_INITIALIZATION;
> +	ret =3D storvsc_execute_vstor_op(device, request, true);
> +	if (ret)
> +		goto cleanup;
> +
> +	/*
> +	 * Query host supported protocol version.
> +	 */
> =20
>  	for (i =3D 0; i < ARRAY_SIZE(vmstor_protocols); i++) {
>  		/* reuse the packet for version range supported */
>  		memset(vstor_packet, 0, sizeof(struct vstor_packet));
>  		vstor_packet->operation =3D
>  			VSTOR_OPERATION_QUERY_PROTOCOL_VERSION;
> -		vstor_packet->flags =3D REQUEST_COMPLETION_FLAG;
> =20
>  		vstor_packet->version.major_minor =3D
>  			vmstor_protocols[i].protocol_version;
> @@ -783,20 +805,9 @@ static int storvsc_channel_init(struct hv_device=
 *device, bool is_fc)
>  		 */
>  		vstor_packet->version.revision =3D 0;
> =20
> -		ret =3D vmbus_sendpacket(device->channel, vstor_packet,
> -			       (sizeof(struct vstor_packet) -
> -				vmscsi_size_delta),
> -			       (unsigned long)request,
> -			       VM_PKT_DATA_INBAND,
> -			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
> -		if (ret !=3D 0)
> -			goto cleanup;
> -
> -		t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
> -		if (t =3D=3D 0) {
> -			ret =3D -ETIMEDOUT;
> +		ret =3D storvsc_execute_vstor_op(device, request, false);
> +		if (ret)
>  			goto cleanup;
> -		}
> =20
>  		if (vstor_packet->operation !=3D VSTOR_OPERATION_COMPLETE_IO) {
>  			ret =3D -EINVAL;
> @@ -822,32 +833,14 @@ static int storvsc_channel_init(struct hv_devic=
e *device, bool is_fc)
>  		goto cleanup;
>  	}
> =20
> -
> +	/*
> +	 * Query channel properties.
> +	 */
>  	memset(vstor_packet, 0, sizeof(struct vstor_packet));
>  	vstor_packet->operation =3D VSTOR_OPERATION_QUERY_PROPERTIES;
> -	vstor_packet->flags =3D REQUEST_COMPLETION_FLAG;
> -
> -	ret =3D vmbus_sendpacket(device->channel, vstor_packet,
> -			       (sizeof(struct vstor_packet) -
> -				vmscsi_size_delta),
> -			       (unsigned long)request,
> -			       VM_PKT_DATA_INBAND,
> -			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
> -
> -	if (ret !=3D 0)
> -		goto cleanup;
> -
> -	t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
> -	if (t =3D=3D 0) {
> -		ret =3D -ETIMEDOUT;
> -		goto cleanup;
> -	}
> -
> -	if (vstor_packet->operation !=3D VSTOR_OPERATION_COMPLETE_IO ||
> -	    vstor_packet->status !=3D 0) {
> -		ret =3D -EINVAL;
> +	ret =3D storvsc_execute_vstor_op(device, request, true);
> +	if (ret)
>  		goto cleanup;
> -	}
> =20
>  	/*
>  	 * Check to see if multi-channel support is there.
> @@ -866,30 +859,15 @@ static int storvsc_channel_init(struct hv_devic=
e *device, bool is_fc)
>  	if (!is_fc)
>  		goto done;
> =20
> +	/*
> +	 * For FC devices retrieve FC HBA data.
> +	 */
>  	memset(vstor_packet, 0, sizeof(struct vstor_packet));
>  	vstor_packet->operation =3D VSTOR_OPERATION_FCHBA_DATA;
> -	vstor_packet->flags =3D REQUEST_COMPLETION_FLAG;
> =20
> -	ret =3D vmbus_sendpacket(device->channel, vstor_packet,
> -			       (sizeof(struct vstor_packet) -
> -			       vmscsi_size_delta),
> -			       (unsigned long)request,
> -			       VM_PKT_DATA_INBAND,
> -			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
> -
> -	if (ret !=3D 0)
> -		goto cleanup;
> -
> -	t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
> -	if (t =3D=3D 0) {
> -		ret =3D -ETIMEDOUT;
> -		goto cleanup;
> -	}
> -
> -	if (vstor_packet->operation !=3D VSTOR_OPERATION_COMPLETE_IO ||
> -	    vstor_packet->status !=3D 0)
> +	ret =3D storvsc_execute_vstor_op(device, request, true);
> +	if (ret)
>  		goto cleanup;
> -
>  	/*
>  	 * Cache the currently active port and node ww names.
>  	 */
> @@ -899,29 +877,10 @@ done:
> =20
>  	memset(vstor_packet, 0, sizeof(struct vstor_packet));
>  	vstor_packet->operation =3D VSTOR_OPERATION_END_INITIALIZATION;
> -	vstor_packet->flags =3D REQUEST_COMPLETION_FLAG;
> =20
> -	ret =3D vmbus_sendpacket(device->channel, vstor_packet,
> -			       (sizeof(struct vstor_packet) -
> -				vmscsi_size_delta),
> -			       (unsigned long)request,
> -			       VM_PKT_DATA_INBAND,
> -			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
> -
> -	if (ret !=3D 0)
> -		goto cleanup;
> -
> -	t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
> -	if (t =3D=3D 0) {
> -		ret =3D -ETIMEDOUT;
> -		goto cleanup;
> -	}
> -
> -	if (vstor_packet->operation !=3D VSTOR_OPERATION_COMPLETE_IO ||
> -	    vstor_packet->status !=3D 0) {
> -		ret =3D -EINVAL;
> +	ret =3D storvsc_execute_vstor_op(device, request, true);
> +	if (ret)
>  		goto cleanup;
> -	}
> =20
>  	if (process_sub_channels)
>  		handle_multichannel_storage(device, max_chns);
> --=20
> 1.7.4.1
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
