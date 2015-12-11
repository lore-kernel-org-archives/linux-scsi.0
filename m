From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 2/4] scsi: storvsc: Properly support Fibre Channel devices
Date: Fri, 11 Dec 2015 09:58:55 +0100
Message-ID: <20151211085855.GD9903@c203.arch.suse.de>
References: <1449792829-15406-1-git-send-email-kys@microsoft.com>
 <1449792860-15447-1-git-send-email-kys@microsoft.com>
 <1449792860-15447-2-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1449792860-15447-2-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, jasowang@redhat.com, ohering@suse.com, jbottomley@parallels.com, linux-kernel@vger.kernel.org, hch@infradead.org, apw@canonical.com, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 10, 2015 at 04:14:18PM -0800, K. Y. Srinivasan wrote:
> For FC devices managed by this driver, atttach the appropriate transport
> template. This will allow us to create the appropriate sysfs files for
> these devices. With this we can publish the wwn for both the port and the=
 node.
> =

> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Long Li <longli@microsoft.com>
> Tested-by: Alex Ng <alexng@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c |  100 ++++++++++++++++++++++++++++++++++++++=
+++--
>  1 files changed, 95 insertions(+), 5 deletions(-)
> =

> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 00bb4bd..b94d471 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -41,6 +41,7 @@
>  #include <scsi/scsi_eh.h>
>  #include <scsi/scsi_devinfo.h>
>  #include <scsi/scsi_dbg.h>
> +#include <scsi/scsi_transport_fc.h>
>  =

>  /*
>   * All wire protocol details (storage protocol between the guest and the=
 host)
> @@ -397,6 +398,7 @@ static int storvsc_timeout =3D 180;
>  =

>  static int msft_blist_flags =3D BLIST_TRY_VPD_PAGES;
>  =

> +static struct scsi_transport_template *fc_transport_template;
>  =

>  static void storvsc_on_channel_callback(void *context);
>  =

> @@ -456,6 +458,11 @@ struct storvsc_device {
>  	/* Used for vsc/vsp channel reset process */
>  	struct storvsc_cmd_request init_request;
>  	struct storvsc_cmd_request reset_request;
> +	/*
> +	 * Currently active port and node names for FC devices.
> +	 */
> +	u64 node_name;
> +	u64 port_name;
>  };
>  =

>  struct hv_host_device {
> @@ -695,7 +702,26 @@ static void  handle_multichannel_storage(struct hv_d=
evice *device, int max_chns)
>  	vmbus_are_subchannels_present(device->channel);
>  }
>  =

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
>  {
>  	struct storvsc_device *stor_device;
>  	struct storvsc_cmd_request *request;
> @@ -837,6 +863,40 @@ static int storvsc_channel_init(struct hv_device *de=
vice)
>  	stor_device->max_transfer_bytes =3D
>  		vstor_packet->storage_channel_properties.max_transfer_bytes;
>  =

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
> +		goto cleanup;
> +
> +	t =3D wait_for_completion_timeout(&request->wait_event, 5*HZ);
> +	if (t =3D=3D 0) {
> +		ret =3D -ETIMEDOUT;
> +		goto cleanup;
> +	}
> +
> +	if (vstor_packet->operation !=3D VSTOR_OPERATION_COMPLETE_IO ||
> +	    vstor_packet->status !=3D 0)
> +		goto cleanup;
> +
> +	/*
> +	 * Cache the currently active port and node ww names.
> +	 */
> +	cache_wwn(stor_device, vstor_packet);
> +
> +done:
> +

That goto use is a bit weird. I see you did it because of the 80 chars limit
but =

if (is_fc) {
	[...]
}

is way more readable IMHO.

>  	memset(vstor_packet, 0, sizeof(struct vstor_packet));
>  	vstor_packet->operation =3D VSTOR_OPERATION_END_INITIALIZATION;
>  	vstor_packet->flags =3D REQUEST_COMPLETION_FLAG;
> @@ -1076,6 +1136,12 @@ static void storvsc_on_receive(struct hv_device *d=
evice,
>  		schedule_work(&work->work);
>  		break;
>  =

> +	case VSTOR_OPERATION_FCHBA_DATA:
> +		stor_device =3D get_in_stor_device(device);
> +		cache_wwn(stor_device, vstor_packet);
> +		fc_host_node_name(stor_device->host) =3D stor_device->node_name;
> +		fc_host_port_name(stor_device->host) =3D stor_device->port_name;
> +		break;
>  	default:
>  		break;
>  	}
> @@ -1131,7 +1197,8 @@ static void storvsc_on_channel_callback(void *conte=
xt)
>  	return;
>  }
>  =

> -static int storvsc_connect_to_vsp(struct hv_device *device, u32 ring_siz=
e)
> +static int storvsc_connect_to_vsp(struct hv_device *device, u32 ring_siz=
e,
> +				  bool is_fc)
>  {
>  	struct vmstorage_channel_properties props;
>  	int ret;
> @@ -1148,7 +1215,7 @@ static int storvsc_connect_to_vsp(struct hv_device =
*device, u32 ring_size)
>  	if (ret !=3D 0)
>  		return ret;
>  =

> -	ret =3D storvsc_channel_init(device);
> +	ret =3D storvsc_channel_init(device, is_fc);
>  =

>  	return ret;
>  }
> @@ -1573,6 +1640,7 @@ static int storvsc_probe(struct hv_device *device,
>  	struct Scsi_Host *host;
>  	struct hv_host_device *host_dev;
>  	bool dev_is_ide =3D ((dev_id->driver_data =3D=3D IDE_GUID) ? true : fal=
se);
> +	bool is_fc =3D ((dev_id->driver_data =3D=3D SFC_GUID) ? true : false);
>  	int target =3D 0;
>  	struct storvsc_device *stor_device;
>  	int max_luns_per_target;
> @@ -1630,7 +1698,7 @@ static int storvsc_probe(struct hv_device *device,
>  	hv_set_drvdata(device, stor_device);
>  =

>  	stor_device->port_number =3D host->host_no;
> -	ret =3D storvsc_connect_to_vsp(device, storvsc_ringbuffer_size);
> +	ret =3D storvsc_connect_to_vsp(device, storvsc_ringbuffer_size, is_fc);
>  	if (ret)
>  		goto err_out1;
>  =

> @@ -1642,6 +1710,7 @@ static int storvsc_probe(struct hv_device *device,
>  		host->max_lun =3D STORVSC_FC_MAX_LUNS_PER_TARGET;
>  		host->max_id =3D STORVSC_FC_MAX_TARGETS;
>  		host->max_channel =3D STORVSC_FC_MAX_CHANNELS - 1;
> +		host->transportt =3D fc_transport_template;
>  		break;
>  =

>  	case SCSI_GUID:
> @@ -1681,6 +1750,10 @@ static int storvsc_probe(struct hv_device *device,
>  			goto err_out2;
>  		}
>  	}
> +	if (host->transportt =3D=3D fc_transport_template) {
> +		fc_host_node_name(host) =3D stor_device->node_name;
> +		fc_host_port_name(host) =3D stor_device->port_name;
> +	}
>  	return 0;
>  =

>  err_out2:
> @@ -1706,6 +1779,8 @@ static int storvsc_remove(struct hv_device *dev)
>  	struct storvsc_device *stor_device =3D hv_get_drvdata(dev);
>  	struct Scsi_Host *host =3D stor_device->host;
>  =

> +	if (host->transportt =3D=3D fc_transport_template)
> +		fc_remove_host(host);
>  	scsi_remove_host(host);
>  	storvsc_dev_remove(dev);
>  	scsi_host_put(host);
> @@ -1720,8 +1795,14 @@ static struct hv_driver storvsc_drv =3D {
>  	.remove =3D storvsc_remove,
>  };
>  =

> +static struct fc_function_template fc_transport_functions =3D {
> +	.show_host_node_name =3D 1,
> +	.show_host_port_name =3D 1,
> +};
> +
>  static int __init storvsc_drv_init(void)
>  {
> +	int ret;
>  =

>  	/*
>  	 * Divide the ring buffer data size (which is 1 page less
> @@ -1736,12 +1817,21 @@ static int __init storvsc_drv_init(void)
>  		vmscsi_size_delta,
>  		sizeof(u64)));
>  =

> -	return vmbus_driver_register(&storvsc_drv);
> +	fc_transport_template =3D fc_attach_transport(&fc_transport_functions);
> +	if (!fc_transport_template)
> +		return -ENODEV;
> +
> +	ret =3D vmbus_driver_register(&storvsc_drv);
> +	if (ret)
> +		fc_release_transport(fc_transport_template);
> +
> +	return ret;
>  }
>  =

>  static void __exit storvsc_drv_exit(void)
>  {
>  	vmbus_driver_unregister(&storvsc_drv);
> +	fc_release_transport(fc_transport_template);
>  }
>  =

>  MODULE_LICENSE("GPL");
> -- =

> 1.7.4.1
> =

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
