From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH V4 2/4] scsi: storvsc: Properly support Fibre Channel
 devices
Date: Mon, 28 Dec 2015 17:59:25 +0000
Message-ID: <BY2PR0301MB16542894155337479CA0296EA0FB0@BY2PR0301MB1654.namprd03.prod.outlook.com>
References: <1450905327-9497-1-git-send-email-kys@microsoft.com>
 <1450905351-9538-1-git-send-email-kys@microsoft.com>
 <1450905351-9538-2-git-send-email-kys@microsoft.com>
 <568124B4.7030609@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <568124B4.7030609@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Monday, December 28, 2015 4:02 AM
> To: KY Srinivasan <kys@microsoft.com>; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org;
> apw@canonical.com; vkuznets@redhat.com; jasowang@redhat.com;
> martin.petersen@oracle.com
> Subject: Re: [PATCH V4 2/4] scsi: storvsc: Properly support Fibre Channel
> devices
> 
> On 12/23/2015 10:15 PM, K. Y. Srinivasan wrote:
> > For FC devices managed by this driver, atttach the appropriate transport
> > template. This will allow us to create the appropriate sysfs files for
> > these devices. With this we can publish the wwn for both the port and the
> node.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Reviewed-by: Long Li <longli@microsoft.com>
> > Tested-by: Alex Ng <alexng@microsoft.com>
> > ---
> > 	V2: Fixed error paths - Dan Carpenter <dan.carpenter@oracle.com>
> > 	V3: Fixed build issues reported by kbuild test robot <lkp@intel.com>
> > 	V4: Handle configuration of SCSI_FC_ATTRS correctly (both module
> and built in)
> >
> >   drivers/scsi/storvsc_drv.c |  181
> ++++++++++++++++++++++++++++++++-----------
> >   1 files changed, 134 insertions(+), 47 deletions(-)
> >
> > diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> > index 00bb4bd..cfbb289 100644
> > --- a/drivers/scsi/storvsc_drv.c
> > +++ b/drivers/scsi/storvsc_drv.c
> > @@ -41,6 +41,7 @@
> >   #include <scsi/scsi_eh.h>
> >   #include <scsi/scsi_devinfo.h>
> >   #include <scsi/scsi_dbg.h>
> > +#include <scsi/scsi_transport_fc.h>
> >
> >   /*
> >    * All wire protocol details (storage protocol between the guest and the
> host)
> > @@ -397,6 +398,9 @@ static int storvsc_timeout = 180;
> >
> >   static int msft_blist_flags = BLIST_TRY_VPD_PAGES;
> >
> > +#if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
> > +static struct scsi_transport_template *fc_transport_template;
> > +#endif
> >
> >   static void storvsc_on_channel_callback(void *context);
> >
> > @@ -456,6 +460,11 @@ struct storvsc_device {
> >   	/* Used for vsc/vsp channel reset process */
> >   	struct storvsc_cmd_request init_request;
> >   	struct storvsc_cmd_request reset_request;
> > +	/*
> > +	 * Currently active port and node names for FC devices.
> > +	 */
> > +	u64 node_name;
> > +	u64 port_name;
> >   };
> >
> >   struct hv_host_device {
> > @@ -695,7 +704,26 @@ static void  handle_multichannel_storage(struct
> hv_device *device, int max_chns)
> >   	vmbus_are_subchannels_present(device->channel);
> >   }
> >
> > -static int storvsc_channel_init(struct hv_device *device)
> > +static void cache_wwn(struct storvsc_device *stor_device,
> > +		      struct vstor_packet *vstor_packet)
> > +{
> > +	/*
> > +	 * Cache the currently active port and node ww names.
> > +	 */
> > +	if (vstor_packet->wwn_packet.primary_active) {
> > +		stor_device->node_name =
> > +			wwn_to_u64(vstor_packet-
> >wwn_packet.primary_node_wwn);
> > +		stor_device->port_name =
> > +			wwn_to_u64(vstor_packet-
> >wwn_packet.primary_port_wwn);
> > +	} else {
> > +		stor_device->node_name =
> > +			wwn_to_u64(vstor_packet-
> >wwn_packet.secondary_node_wwn);
> > +		stor_device->port_name =
> > +			wwn_to_u64(vstor_packet-
> >wwn_packet.secondary_port_wwn);
> > +	}
> > +}
> > +
> > +static int storvsc_channel_init(struct hv_device *device, bool is_fc)
> >   {
> >   	struct storvsc_device *stor_device;
> >   	struct storvsc_cmd_request *request;
> > @@ -727,19 +755,15 @@ static int storvsc_channel_init(struct hv_device
> *device)
> >   			       VM_PKT_DATA_INBAND,
> >
> VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
> >   	if (ret != 0)
> > -		goto cleanup;
> > +		return ret;
> >
> >   	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
> > -	if (t == 0) {
> > -		ret = -ETIMEDOUT;
> > -		goto cleanup;
> > -	}
> > +	if (t == 0)
> > +		return -ETIMEDOUT;
> >
> >   	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO
> ||
> > -	    vstor_packet->status != 0) {
> > -		ret = -EINVAL;
> > -		goto cleanup;
> > -	}
> > +	    vstor_packet->status != 0)
> > +		return -EINVAL;
> >
> >
> >   	for (i = 0; i < ARRAY_SIZE(vmstor_protocols); i++) {
> > @@ -764,18 +788,14 @@ static int storvsc_channel_init(struct hv_device
> *device)
> >   			       VM_PKT_DATA_INBAND,
> >
> VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
> >   		if (ret != 0)
> > -			goto cleanup;
> > +			return ret;
> >
> >   		t = wait_for_completion_timeout(&request->wait_event,
> 5*HZ);
> > -		if (t == 0) {
> > -			ret = -ETIMEDOUT;
> > -			goto cleanup;
> > -		}
> > +		if (t == 0)
> > +			return -ETIMEDOUT;
> >
> > -		if (vstor_packet->operation !=
> VSTOR_OPERATION_COMPLETE_IO) {
> > -			ret = -EINVAL;
> > -			goto cleanup;
> > -		}
> > +		if (vstor_packet->operation !=
> VSTOR_OPERATION_COMPLETE_IO)
> > +			return -EINVAL;
> >
> >   		if (vstor_packet->status == 0) {
> >   			vmstor_proto_version =
> > @@ -791,10 +811,8 @@ static int storvsc_channel_init(struct hv_device
> *device)
> >   		}
> >   	}
> >
> > -	if (vstor_packet->status != 0) {
> > -		ret = -EINVAL;
> > -		goto cleanup;
> > -	}
> > +	if (vstor_packet->status != 0)
> > +		return -EINVAL;
> >
> >
> >   	memset(vstor_packet, 0, sizeof(struct vstor_packet));
> > @@ -809,19 +827,15 @@ static int storvsc_channel_init(struct hv_device
> *device)
> >
> VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
> >
> >   	if (ret != 0)
> > -		goto cleanup;
> > +		return ret;
> >
> >   	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
> > -	if (t == 0) {
> > -		ret = -ETIMEDOUT;
> > -		goto cleanup;
> > -	}
> > +	if (t == 0)
> > +		return -ETIMEDOUT;
> >
> >   	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO
> ||
> > -	    vstor_packet->status != 0) {
> > -		ret = -EINVAL;
> > -		goto cleanup;
> > -	}
> > +	    vstor_packet->status != 0)
> > +		return -EINVAL;
> >
> >   	/*
> >   	 * Check to see if multi-channel support is there.
> > @@ -837,6 +851,38 @@ static int storvsc_channel_init(struct hv_device
> *device)
> >   	stor_device->max_transfer_bytes =
> >   		vstor_packet-
> >storage_channel_properties.max_transfer_bytes;
> >
> > +	if (!is_fc)
> > +		goto done;
> > +
> > +	memset(vstor_packet, 0, sizeof(struct vstor_packet));
> > +	vstor_packet->operation = VSTOR_OPERATION_FCHBA_DATA;
> > +	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
> > +
> > +	ret = vmbus_sendpacket(device->channel, vstor_packet,
> > +			       (sizeof(struct vstor_packet) -
> > +			       vmscsi_size_delta),
> > +			       (unsigned long)request,
> > +			       VM_PKT_DATA_INBAND,
> > +
> VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
> > +
> > +	if (ret != 0)
> > +		return ret;
> > +
> > +	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
> > +	if (t == 0)
> > +		return -ETIMEDOUT;
> > +
> > +	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO
> ||
> > +	    vstor_packet->status != 0)
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * Cache the currently active port and node ww names.
> > +	 */
> > +	cache_wwn(stor_device, vstor_packet);
> > +
> > +done:
> > +
> >   	memset(vstor_packet, 0, sizeof(struct vstor_packet));
> >   	vstor_packet->operation =
> VSTOR_OPERATION_END_INITIALIZATION;
> >   	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
> > @@ -849,25 +895,19 @@ static int storvsc_channel_init(struct hv_device
> *device)
> >
> VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
> >
> >   	if (ret != 0)
> > -		goto cleanup;
> > +		return ret;
> >
> >   	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
> > -	if (t == 0) {
> > -		ret = -ETIMEDOUT;
> > -		goto cleanup;
> > -	}
> > +	if (t == 0)
> > +		return -ETIMEDOUT;
> >
> >   	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO
> ||
> > -	    vstor_packet->status != 0) {
> > -		ret = -EINVAL;
> > -		goto cleanup;
> > -	}
> > +	    vstor_packet->status != 0)
> > +		return -EINVAL;
> >
> >   	if (process_sub_channels)
> >   		handle_multichannel_storage(device, max_chns);
> >
> > -
> > -cleanup:
> >   	return ret;
> >   }
> >
> > @@ -1076,6 +1116,14 @@ static void storvsc_on_receive(struct hv_device
> *device,
> >   		schedule_work(&work->work);
> >   		break;
> >
> > +	case VSTOR_OPERATION_FCHBA_DATA:
> > +		stor_device = get_in_stor_device(device);
> > +		cache_wwn(stor_device, vstor_packet);
> > +#if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
> > +		fc_host_node_name(stor_device->host) = stor_device-
> >node_name;
> > +		fc_host_port_name(stor_device->host) = stor_device-
> >port_name;
> > +#endif
> > +		break;
> >   	default:
> >   		break;
> >   	}
> > @@ -1131,7 +1179,8 @@ static void storvsc_on_channel_callback(void
> *context)
> >   	return;
> >   }
> >
> > -static int storvsc_connect_to_vsp(struct hv_device *device, u32 ring_size)
> > +static int storvsc_connect_to_vsp(struct hv_device *device, u32 ring_size,
> > +				  bool is_fc)
> >   {
> >   	struct vmstorage_channel_properties props;
> >   	int ret;
> > @@ -1148,7 +1197,7 @@ static int storvsc_connect_to_vsp(struct
> hv_device *device, u32 ring_size)
> >   	if (ret != 0)
> >   		return ret;
> >
> > -	ret = storvsc_channel_init(device);
> > +	ret = storvsc_channel_init(device, is_fc);
> >
> >   	return ret;
> >   }
> > @@ -1573,6 +1622,7 @@ static int storvsc_probe(struct hv_device *device,
> >   	struct Scsi_Host *host;
> >   	struct hv_host_device *host_dev;
> >   	bool dev_is_ide = ((dev_id->driver_data == IDE_GUID) ? true : false);
> > +	bool is_fc = ((dev_id->driver_data == SFC_GUID) ? true : false);
> >   	int target = 0;
> >   	struct storvsc_device *stor_device;
> >   	int max_luns_per_target;
> > @@ -1630,7 +1680,7 @@ static int storvsc_probe(struct hv_device *device,
> >   	hv_set_drvdata(device, stor_device);
> >
> >   	stor_device->port_number = host->host_no;
> > -	ret = storvsc_connect_to_vsp(device, storvsc_ringbuffer_size);
> > +	ret = storvsc_connect_to_vsp(device, storvsc_ringbuffer_size, is_fc);
> >   	if (ret)
> >   		goto err_out1;
> >
> > @@ -1642,6 +1692,9 @@ static int storvsc_probe(struct hv_device *device,
> >   		host->max_lun = STORVSC_FC_MAX_LUNS_PER_TARGET;
> >   		host->max_id = STORVSC_FC_MAX_TARGETS;
> >   		host->max_channel = STORVSC_FC_MAX_CHANNELS - 1;
> > +#if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
> > +		host->transportt = fc_transport_template;
> > +#endif
> >   		break;
> >
> >   	case SCSI_GUID:
> > @@ -1681,6 +1734,12 @@ static int storvsc_probe(struct hv_device
> *device,
> >   			goto err_out2;
> >   		}
> >   	}
> > +#if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
> > +	if (host->transportt == fc_transport_template) {
> > +		fc_host_node_name(host) = stor_device->node_name;
> > +		fc_host_port_name(host) = stor_device->port_name;
> > +	}
> > +#endif
> >   	return 0;
> >
> >   err_out2:
> > @@ -1706,6 +1765,10 @@ static int storvsc_remove(struct hv_device
> *dev)
> >   	struct storvsc_device *stor_device = hv_get_drvdata(dev);
> >   	struct Scsi_Host *host = stor_device->host;
> >
> > +#if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
> > +	if (host->transportt == fc_transport_template)
> > +		fc_remove_host(host);
> > +#endif
> >   	scsi_remove_host(host);
> >   	storvsc_dev_remove(dev);
> >   	scsi_host_put(host);
> > @@ -1720,8 +1783,16 @@ static struct hv_driver storvsc_drv = {
> >   	.remove = storvsc_remove,
> >   };
> >
> > +#if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
> > +static struct fc_function_template fc_transport_functions = {
> > +	.show_host_node_name = 1,
> > +	.show_host_port_name = 1,
> > +};
> > +#endif
> > +
> >   static int __init storvsc_drv_init(void)
> >   {
> > +	int ret;
> >
> >   	/*
> >   	 * Divide the ring buffer data size (which is 1 page less
> > @@ -1736,12 +1807,28 @@ static int __init storvsc_drv_init(void)
> >   		vmscsi_size_delta,
> >   		sizeof(u64)));
> >
> > -	return vmbus_driver_register(&storvsc_drv);
> > +#if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
> > +	fc_transport_template =
> fc_attach_transport(&fc_transport_functions);
> > +	if (!fc_transport_template)
> > +		return -ENODEV;
> > +#endif
> > +
> > +	ret = vmbus_driver_register(&storvsc_drv);
> > +
> > +#if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
> > +	if (ret)
> > +		fc_release_transport(fc_transport_template);
> > +#endif
> > +
> > +	return ret;
> >   }
> >
> >   static void __exit storvsc_drv_exit(void)
> >   {
> >   	vmbus_driver_unregister(&storvsc_drv);
> > +#if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
> > +	fc_release_transport(fc_transport_template);
> > +#endif
> >   }
> >
> >   MODULE_LICENSE("GPL");
> >
> My original question still stands: Where is the point if supporting FC
> devices if CONFIG_SCSI_FC_ATTRS is disabled?
> I would rather disable FC support completely if that option is
> deselected; otherwise you'll end up with a strange cross-breed which
> presents FC LUNs but no attributes.

I have been supporting FC LUNs with no attributes since Win8 and based on
Feedback from a handful of customers, I have now implemented a small subset of
FC attributes (this yet to be committed patch-set). Furthermore, the only
attributes supported on the Windows host are the wwn for port and node.
So, if CONFIG_SCSI_FC_ATTRS is disabled, in the current implementation,
all we would be doing is preserving the existing behavior.

Regards,

K. Y
