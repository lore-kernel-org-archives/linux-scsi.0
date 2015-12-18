From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V3 3/4] scsi: storvsc: Refactor the code in
 storvsc_channel_init()
Date: Fri, 18 Dec 2015 09:50:57 +0100
Message-ID: <5673C8F1.8050507@suse.de>
References: <1450038486-19211-1-git-send-email-kys@microsoft.com>
 <1450038512-19252-1-git-send-email-kys@microsoft.com>
 <1450038512-19252-3-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38480 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932311AbbLRIu7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Dec 2015 03:50:59 -0500
In-Reply-To: <1450038512-19252-3-git-send-email-kys@microsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com

On 12/13/2015 09:28 PM, K. Y. Srinivasan wrote:
> The function storvsc_channel_init() repeatedly interacts with the hos=
t to
> extract various channel properties. Refactor this code to eliminate c=
ode
> repetition.
>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Long Li <longli@microsoft.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> Tested-by: Alex Ng <alexng@microsoft.com>
> ---
> 	V2: Fixed error paths - Dan Carpenter <dan.carpenter@oracle.com>
>
>   drivers/scsi/storvsc_drv.c |  126 ++++++++++++++++-----------------=
-----------
>   1 files changed, 46 insertions(+), 80 deletions(-)
>
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 220b794..d6ca4f2 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -723,29 +723,17 @@ static void cache_wwn(struct storvsc_device *st=
or_device,
>   	}
>   }
>
> -static int storvsc_channel_init(struct hv_device *device, bool is_fc=
)
> +
> +static int storvsc_execute_vstor_op(struct hv_device *device,
> +				    struct storvsc_cmd_request *request,
> +				    bool status_check)
>   {
> -	struct storvsc_device *stor_device;
> -	struct storvsc_cmd_request *request;
>   	struct vstor_packet *vstor_packet;
> -	int ret, t, i;
> -	int max_chns;
> -	bool process_sub_channels =3D false;
> -
> -	stor_device =3D get_out_stor_device(device);
> -	if (!stor_device)
> -		return -ENODEV;
> +	int ret, t;
>
> -	request =3D &stor_device->init_request;
>   	vstor_packet =3D &request->vstor_packet;
>
> -	/*
> -	 * Now, initiate the vsc/vsp initialization protocol on the open
> -	 * channel
> -	 */
> -	memset(request, 0, sizeof(struct storvsc_cmd_request));
>   	init_completion(&request->wait_event);
> -	vstor_packet->operation =3D VSTOR_OPERATION_BEGIN_INITIALIZATION;
>   	vstor_packet->flags =3D REQUEST_COMPLETION_FLAG;
>
>   	ret =3D vmbus_sendpacket(device->channel, vstor_packet,
> @@ -761,17 +749,50 @@ static int storvsc_channel_init(struct hv_devic=
e *device, bool is_fc)
>   	if (t =3D=3D 0)
>   		return -ETIMEDOUT;
>
> +	if (!status_check)
> +		return ret;
> +
>   	if (vstor_packet->operation !=3D VSTOR_OPERATION_COMPLETE_IO ||
>   	    vstor_packet->status !=3D 0)
>   		return -EINVAL;
>
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
> +		return ret;
> +	/*
> +	 * Query host supported protocol version.
> +	 */
>
>   	for (i =3D 0; i < ARRAY_SIZE(vmstor_protocols); i++) {
>   		/* reuse the packet for version range supported */
>   		memset(vstor_packet, 0, sizeof(struct vstor_packet));
>   		vstor_packet->operation =3D
>   			VSTOR_OPERATION_QUERY_PROTOCOL_VERSION;
> -		vstor_packet->flags =3D REQUEST_COMPLETION_FLAG;
>
>   		vstor_packet->version.major_minor =3D
>   			vmstor_protocols[i].protocol_version;
> @@ -780,20 +801,10 @@ static int storvsc_channel_init(struct hv_devic=
e *device, bool is_fc)
>   		 * The revision number is only used in Windows; set it to 0.
>   		 */
>   		vstor_packet->version.revision =3D 0;
> -
> -		ret =3D vmbus_sendpacket(device->channel, vstor_packet,
> -			       (sizeof(struct vstor_packet) -
> -				vmscsi_size_delta),
> -			       (unsigned long)request,
> -			       VM_PKT_DATA_INBAND,
> -			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
> +		ret =3D storvsc_execute_vstor_op(device, request, false);
>   		if (ret !=3D 0)
>   			return ret;
>
> -		t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
> -		if (t =3D=3D 0)
> -			return -ETIMEDOUT;
> -
>   		if (vstor_packet->operation !=3D VSTOR_OPERATION_COMPLETE_IO)
>   			return -EINVAL;
>
> @@ -817,26 +828,10 @@ static int storvsc_channel_init(struct hv_devic=
e *device, bool is_fc)
>
>   	memset(vstor_packet, 0, sizeof(struct vstor_packet));
>   	vstor_packet->operation =3D VSTOR_OPERATION_QUERY_PROPERTIES;
> -	vstor_packet->flags =3D REQUEST_COMPLETION_FLAG;
> -
> -	ret =3D vmbus_sendpacket(device->channel, vstor_packet,
> -			       (sizeof(struct vstor_packet) -
> -				vmscsi_size_delta),
> -			       (unsigned long)request,
> -			       VM_PKT_DATA_INBAND,
> -			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
> -
> +	ret =3D storvsc_execute_vstor_op(device, request, true);
>   	if (ret !=3D 0)
>   		return ret;
>
> -	t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
> -	if (t =3D=3D 0)
> -		return -ETIMEDOUT;
> -
> -	if (vstor_packet->operation !=3D VSTOR_OPERATION_COMPLETE_IO ||
> -	    vstor_packet->status !=3D 0)
> -		return -EINVAL;
> -
>   	/*
>   	 * Check to see if multi-channel support is there.
>   	 * Hosts that implement protocol version of 5.1 and above
> @@ -854,28 +849,15 @@ static int storvsc_channel_init(struct hv_devic=
e *device, bool is_fc)
>   	if (!is_fc)
>   		goto done;
>
> +	/*
> +	 * For FC devices retrieve FC HBA data.
> +	 */
>   	memset(vstor_packet, 0, sizeof(struct vstor_packet));
>   	vstor_packet->operation =3D VSTOR_OPERATION_FCHBA_DATA;
> -	vstor_packet->flags =3D REQUEST_COMPLETION_FLAG;
> -
> -	ret =3D vmbus_sendpacket(device->channel, vstor_packet,
> -			       (sizeof(struct vstor_packet) -
> -			       vmscsi_size_delta),
> -			       (unsigned long)request,
> -			       VM_PKT_DATA_INBAND,
> -			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
> -
> +	ret =3D storvsc_execute_vstor_op(device, request, true);
>   	if (ret !=3D 0)
>   		return ret;
>
> -	t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
> -	if (t =3D=3D 0)
> -		return -ETIMEDOUT;
> -
> -	if (vstor_packet->operation !=3D VSTOR_OPERATION_COMPLETE_IO ||
> -	    vstor_packet->status !=3D 0)
> -		return -EINVAL;
> -
>   	/*
>   	 * Cache the currently active port and node ww names.
>   	 */
> @@ -885,26 +867,10 @@ done:
>
>   	memset(vstor_packet, 0, sizeof(struct vstor_packet));
>   	vstor_packet->operation =3D VSTOR_OPERATION_END_INITIALIZATION;
> -	vstor_packet->flags =3D REQUEST_COMPLETION_FLAG;
> -
> -	ret =3D vmbus_sendpacket(device->channel, vstor_packet,
> -			       (sizeof(struct vstor_packet) -
> -				vmscsi_size_delta),
> -			       (unsigned long)request,
> -			       VM_PKT_DATA_INBAND,
> -			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
> -
> +	ret =3D storvsc_execute_vstor_op(device, request, true);
>   	if (ret !=3D 0)
>   		return ret;
>
> -	t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
> -	if (t =3D=3D 0)
> -		return -ETIMEDOUT;
> -
> -	if (vstor_packet->operation !=3D VSTOR_OPERATION_COMPLETE_IO ||
> -	    vstor_packet->status !=3D 0)
> -		return -EINVAL;
> -
>   	if (process_sub_channels)
>   		handle_multichannel_storage(device, max_chns);
>
>
The same applies here; please make the FC support configurable both=20
during configuration and during runtime.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
