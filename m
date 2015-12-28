From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V4 2/4] scsi: storvsc: Properly support Fibre Channel
 devices
Date: Mon, 28 Dec 2015 13:01:56 +0100
Message-ID: <568124B4.7030609@suse.de>
References: <1450905327-9497-1-git-send-email-kys@microsoft.com>
 <1450905351-9538-1-git-send-email-kys@microsoft.com>
 <1450905351-9538-2-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1450905351-9538-2-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

On 12/23/2015 10:15 PM, K. Y. Srinivasan wrote:
> For FC devices managed by this driver, atttach the appropriate transport
> template. This will allow us to create the appropriate sysfs files for
> these devices. With this we can publish the wwn for both the port and the=
 node.
>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Long Li <longli@microsoft.com>
> Tested-by: Alex Ng <alexng@microsoft.com>
> ---
> 	V2: Fixed error paths - Dan Carpenter <dan.carpenter@oracle.com>
> 	V3: Fixed build issues reported by kbuild test robot <lkp@intel.com>
> 	V4: Handle configuration of SCSI_FC_ATTRS correctly (both module and bui=
lt in)
>
>   drivers/scsi/storvsc_drv.c |  181 ++++++++++++++++++++++++++++++++-----=
------
>   1 files changed, 134 insertions(+), 47 deletions(-)
>
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 00bb4bd..cfbb289 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -41,6 +41,7 @@
>   #include <scsi/scsi_eh.h>
>   #include <scsi/scsi_devinfo.h>
>   #include <scsi/scsi_dbg.h>
> +#include <scsi/scsi_transport_fc.h>
>
>   /*
>    * All wire protocol details (storage protocol between the guest and th=
e host)
> @@ -397,6 +398,9 @@ static int storvsc_timeout =3D 180;
>
>   static int msft_blist_flags =3D BLIST_TRY_VPD_PAGES;
>
> +#if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
> +static struct scsi_transport_template *fc_transport_template;
> +#endif
>
>   static void storvsc_on_channel_callback(void *context);
>
> @@ -456,6 +460,11 @@ struct storvsc_device {
>   	/* Used for vsc/vsp channel reset process */
>   	struct storvsc_cmd_request init_request;
>   	struct storvsc_cmd_request reset_request;
> +	/*
> +	 * Currently active port and node names for FC devices.
> +	 */
> +	u64 node_name;
> +	u64 port_name;
>   };
>
>   struct hv_host_device {
> @@ -695,7 +704,26 @@ static void  handle_multichannel_storage(struct hv_d=
evice *device, int max_chns)
>   	vmbus_are_subchannels_present(device->channel);
>   }
>
> -static int storvsc_channel_init(struct hv_device *device)
> +static void cache_wwn(struct storvsc_device *stor_device,
> +		      struct vstor_packet *vstor_packet)
> +{
> +	/*
> +	 * Cache the currently active port and node ww names.
> +	 */
> +	if (vstor_packet->wwn_packet.primary_active) {
> +		stor_device->node_name =3D
> +			wwn_to_u64(vstor_packet->wwn_packet.primary_node_wwn);
> +		stor_device->port_name =3D
> +			wwn_to_u64(vstor_packet->wwn_packet.primary_port_wwn);
> +	} else {
> +		stor_device->node_name =3D
> +			wwn_to_u64(vstor_packet->wwn_packet.secondary_node_wwn);
> +		stor_device->port_name =3D
> +			wwn_to_u64(vstor_packet->wwn_packet.secondary_port_wwn);
> +	}
> +}
> +
> +static int storvsc_channel_init(struct hv_device *device, bool is_fc)
>   {
>   	struct storvsc_device *stor_device;
>   	struct storvsc_cmd_request *request;
> @@ -727,19 +755,15 @@ static int storvsc_channel_init(struct hv_device *d=
evice)
>   			       VM_PKT_DATA_INBAND,
>   			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
>   	if (ret !=3D 0)
> -		goto cleanup;
> +		return ret;
>
>   	t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
> -	if (t =3D=3D 0) {
> -		ret =3D -ETIMEDOUT;
> -		goto cleanup;
> -	}
> +	if (t =3D=3D 0)
> +		return -ETIMEDOUT;
>
>   	if (vstor_packet->operation !=3D VSTOR_OPERATION_COMPLETE_IO ||
> -	    vstor_packet->status !=3D 0) {
> -		ret =3D -EINVAL;
> -		goto cleanup;
> -	}
> +	    vstor_packet->status !=3D 0)
> +		return -EINVAL;
>
>
>   	for (i =3D 0; i < ARRAY_SIZE(vmstor_protocols); i++) {
> @@ -764,18 +788,14 @@ static int storvsc_channel_init(struct hv_device *d=
evice)
>   			       VM_PKT_DATA_INBAND,
>   			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
>   		if (ret !=3D 0)
> -			goto cleanup;
> +			return ret;
>
>   		t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
> -		if (t =3D=3D 0) {
> -			ret =3D -ETIMEDOUT;
> -			goto cleanup;
> -		}
> +		if (t =3D=3D 0)
> +			return -ETIMEDOUT;
>
> -		if (vstor_packet->operation !=3D VSTOR_OPERATION_COMPLETE_IO) {
> -			ret =3D -EINVAL;
> -			goto cleanup;
> -		}
> +		if (vstor_packet->operation !=3D VSTOR_OPERATION_COMPLETE_IO)
> +			return -EINVAL;
>
>   		if (vstor_packet->status =3D=3D 0) {
>   			vmstor_proto_version =3D
> @@ -791,10 +811,8 @@ static int storvsc_channel_init(struct hv_device *de=
vice)
>   		}
>   	}
>
> -	if (vstor_packet->status !=3D 0) {
> -		ret =3D -EINVAL;
> -		goto cleanup;
> -	}
> +	if (vstor_packet->status !=3D 0)
> +		return -EINVAL;
>
>
>   	memset(vstor_packet, 0, sizeof(struct vstor_packet));
> @@ -809,19 +827,15 @@ static int storvsc_channel_init(struct hv_device *d=
evice)
>   			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
>
>   	if (ret !=3D 0)
> -		goto cleanup;
> +		return ret;
>
>   	t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
> -	if (t =3D=3D 0) {
> -		ret =3D -ETIMEDOUT;
> -		goto cleanup;
> -	}
> +	if (t =3D=3D 0)
> +		return -ETIMEDOUT;
>
>   	if (vstor_packet->operation !=3D VSTOR_OPERATION_COMPLETE_IO ||
> -	    vstor_packet->status !=3D 0) {
> -		ret =3D -EINVAL;
> -		goto cleanup;
> -	}
> +	    vstor_packet->status !=3D 0)
> +		return -EINVAL;
>
>   	/*
>   	 * Check to see if multi-channel support is there.
> @@ -837,6 +851,38 @@ static int storvsc_channel_init(struct hv_device *de=
vice)
>   	stor_device->max_transfer_bytes =3D
>   		vstor_packet->storage_channel_properties.max_transfer_bytes;
>
> +	if (!is_fc)
> +		goto done;
> +
> +	memset(vstor_packet, 0, sizeof(struct vstor_packet));
> +	vstor_packet->operation =3D VSTOR_OPERATION_FCHBA_DATA;
> +	vstor_packet->flags =3D REQUEST_COMPLETION_FLAG;
> +
> +	ret =3D vmbus_sendpacket(device->channel, vstor_packet,
> +			       (sizeof(struct vstor_packet) -
> +			       vmscsi_size_delta),
> +			       (unsigned long)request,
> +			       VM_PKT_DATA_INBAND,
> +			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
> +
> +	if (ret !=3D 0)
> +		return ret;
> +
> +	t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
> +	if (t =3D=3D 0)
> +		return -ETIMEDOUT;
> +
> +	if (vstor_packet->operation !=3D VSTOR_OPERATION_COMPLETE_IO ||
> +	    vstor_packet->status !=3D 0)
> +		return -EINVAL;
> +
> +	/*
> +	 * Cache the currently active port and node ww names.
> +	 */
> +	cache_wwn(stor_device, vstor_packet);
> +
> +done:
> +
>   	memset(vstor_packet, 0, sizeof(struct vstor_packet));
>   	vstor_packet->operation =3D VSTOR_OPERATION_END_INITIALIZATION;
>   	vstor_packet->flags =3D REQUEST_COMPLETION_FLAG;
> @@ -849,25 +895,19 @@ static int storvsc_channel_init(struct hv_device *d=
evice)
>   			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
>
>   	if (ret !=3D 0)
> -		goto cleanup;
> +		return ret;
>
>   	t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
> -	if (t =3D=3D 0) {
> -		ret =3D -ETIMEDOUT;
> -		goto cleanup;
> -	}
> +	if (t =3D=3D 0)
> +		return -ETIMEDOUT;
>
>   	if (vstor_packet->operation !=3D VSTOR_OPERATION_COMPLETE_IO ||
> -	    vstor_packet->status !=3D 0) {
> -		ret =3D -EINVAL;
> -		goto cleanup;
> -	}
> +	    vstor_packet->status !=3D 0)
> +		return -EINVAL;
>
>   	if (process_sub_channels)
>   		handle_multichannel_storage(device, max_chns);
>
> -
> -cleanup:
>   	return ret;
>   }
>
> @@ -1076,6 +1116,14 @@ static void storvsc_on_receive(struct hv_device *d=
evice,
>   		schedule_work(&work->work);
>   		break;
>
> +	case VSTOR_OPERATION_FCHBA_DATA:
> +		stor_device =3D get_in_stor_device(device);
> +		cache_wwn(stor_device, vstor_packet);
> +#if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
> +		fc_host_node_name(stor_device->host) =3D stor_device->node_name;
> +		fc_host_port_name(stor_device->host) =3D stor_device->port_name;
> +#endif
> +		break;
>   	default:
>   		break;
>   	}
> @@ -1131,7 +1179,8 @@ static void storvsc_on_channel_callback(void *conte=
xt)
>   	return;
>   }
>
> -static int storvsc_connect_to_vsp(struct hv_device *device, u32 ring_siz=
e)
> +static int storvsc_connect_to_vsp(struct hv_device *device, u32 ring_siz=
e,
> +				  bool is_fc)
>   {
>   	struct vmstorage_channel_properties props;
>   	int ret;
> @@ -1148,7 +1197,7 @@ static int storvsc_connect_to_vsp(struct hv_device =
*device, u32 ring_size)
>   	if (ret !=3D 0)
>   		return ret;
>
> -	ret =3D storvsc_channel_init(device);
> +	ret =3D storvsc_channel_init(device, is_fc);
>
>   	return ret;
>   }
> @@ -1573,6 +1622,7 @@ static int storvsc_probe(struct hv_device *device,
>   	struct Scsi_Host *host;
>   	struct hv_host_device *host_dev;
>   	bool dev_is_ide =3D ((dev_id->driver_data =3D=3D IDE_GUID) ? true : fa=
lse);
> +	bool is_fc =3D ((dev_id->driver_data =3D=3D SFC_GUID) ? true : false);
>   	int target =3D 0;
>   	struct storvsc_device *stor_device;
>   	int max_luns_per_target;
> @@ -1630,7 +1680,7 @@ static int storvsc_probe(struct hv_device *device,
>   	hv_set_drvdata(device, stor_device);
>
>   	stor_device->port_number =3D host->host_no;
> -	ret =3D storvsc_connect_to_vsp(device, storvsc_ringbuffer_size);
> +	ret =3D storvsc_connect_to_vsp(device, storvsc_ringbuffer_size, is_fc);
>   	if (ret)
>   		goto err_out1;
>
> @@ -1642,6 +1692,9 @@ static int storvsc_probe(struct hv_device *device,
>   		host->max_lun =3D STORVSC_FC_MAX_LUNS_PER_TARGET;
>   		host->max_id =3D STORVSC_FC_MAX_TARGETS;
>   		host->max_channel =3D STORVSC_FC_MAX_CHANNELS - 1;
> +#if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
> +		host->transportt =3D fc_transport_template;
> +#endif
>   		break;
>
>   	case SCSI_GUID:
> @@ -1681,6 +1734,12 @@ static int storvsc_probe(struct hv_device *device,
>   			goto err_out2;
>   		}
>   	}
> +#if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
> +	if (host->transportt =3D=3D fc_transport_template) {
> +		fc_host_node_name(host) =3D stor_device->node_name;
> +		fc_host_port_name(host) =3D stor_device->port_name;
> +	}
> +#endif
>   	return 0;
>
>   err_out2:
> @@ -1706,6 +1765,10 @@ static int storvsc_remove(struct hv_device *dev)
>   	struct storvsc_device *stor_device =3D hv_get_drvdata(dev);
>   	struct Scsi_Host *host =3D stor_device->host;
>
> +#if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
> +	if (host->transportt =3D=3D fc_transport_template)
> +		fc_remove_host(host);
> +#endif
>   	scsi_remove_host(host);
>   	storvsc_dev_remove(dev);
>   	scsi_host_put(host);
> @@ -1720,8 +1783,16 @@ static struct hv_driver storvsc_drv =3D {
>   	.remove =3D storvsc_remove,
>   };
>
> +#if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
> +static struct fc_function_template fc_transport_functions =3D {
> +	.show_host_node_name =3D 1,
> +	.show_host_port_name =3D 1,
> +};
> +#endif
> +
>   static int __init storvsc_drv_init(void)
>   {
> +	int ret;
>
>   	/*
>   	 * Divide the ring buffer data size (which is 1 page less
> @@ -1736,12 +1807,28 @@ static int __init storvsc_drv_init(void)
>   		vmscsi_size_delta,
>   		sizeof(u64)));
>
> -	return vmbus_driver_register(&storvsc_drv);
> +#if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
> +	fc_transport_template =3D fc_attach_transport(&fc_transport_functions);
> +	if (!fc_transport_template)
> +		return -ENODEV;
> +#endif
> +
> +	ret =3D vmbus_driver_register(&storvsc_drv);
> +
> +#if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
> +	if (ret)
> +		fc_release_transport(fc_transport_template);
> +#endif
> +
> +	return ret;
>   }
>
>   static void __exit storvsc_drv_exit(void)
>   {
>   	vmbus_driver_unregister(&storvsc_drv);
> +#if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
> +	fc_release_transport(fc_transport_template);
> +#endif
>   }
>
>   MODULE_LICENSE("GPL");
>
My original question still stands: Where is the point if supporting FC =

devices if CONFIG_SCSI_FC_ATTRS is disabled?
I would rather disable FC support completely if that option is =

deselected; otherwise you'll end up with a strange cross-breed which =

presents FC LUNs but no attributes.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
