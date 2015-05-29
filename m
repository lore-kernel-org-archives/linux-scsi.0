From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH 3/6] hv:scsi:Untangle the storage protocol negotiation
 from the vmbus protocol negotiation.
Date: Fri, 29 May 2015 20:37:13 +0000
Message-ID: <DM2PR03MB416DB8411B9CCAAA0B89574CEC90@DM2PR03MB416.namprd03.prod.outlook.com>
References: <1432931336-14434-1-git-send-email-kys@microsoft.com>
 <1432931359-14473-1-git-send-email-kys@microsoft.com>
 <1432931359-14473-3-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1432931359-14473-3-git-send-email-kys@microsoft.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: KY Srinivasan <kys@microsoft.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>
Cc: Keith Mange <Keith.Mange@microsoft.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: devel [mailto:driverdev-devel-bounces@linuxdriverproject.org] On
> Behalf Of K. Y. Srinivasan
> Sent: Friday, May 29, 2015 1:29 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; jbottomley@parallels.com;
> hch@infradead.org; linux-scsi@vger.kernel.org; apw@canonical.com;
> vkuznets@redhat.com; jasowang@redhat.com
> Cc: Keith Mange
> Subject: [PATCH 3/6] hv:scsi:Untangle the storage protocol negotiation from
> the vmbus protocol negotiation.
> 
> From: keith.mange@microsoft.com <keith.mange@microsoft.com>
> 
> Currently we are making decisions based on vmbus protocol versions that have
> been negotiated; use storage potocol versions instead.
> 
Reviewed-by: Long Li <longli@microsoft.com>
> Tested-by: Alex Ng <alexng@microsoft.com>
> Signed-off-by: Keith Mange <keith.mange@microsoft.com>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c |  109 +++++++++++++++++++++++++++++++++++------
> ---
>  1 files changed, 87 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c index
> 5f9d133..f29871e 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -56,14 +56,18 @@
>   * V1 RC > 2008/1/31:  2.0
>   * Win7: 4.2
>   * Win8: 5.1
> + * Win8.1: 6.0
> + * Win10: 6.2
>   */
> 
>  #define VMSTOR_PROTO_VERSION(MAJOR_, MINOR_)	((((MAJOR_) & 0xff)
> << 8) | \
>  						(((MINOR_) & 0xff)))
> 
> +#define VMSTOR_PROTO_VERSION_WIN6	VMSTOR_PROTO_VERSION(2,
> 0)
>  #define VMSTOR_PROTO_VERSION_WIN7	VMSTOR_PROTO_VERSION(4,
> 2)
>  #define VMSTOR_PROTO_VERSION_WIN8	VMSTOR_PROTO_VERSION(5,
> 1)
> -
> +#define VMSTOR_PROTO_VERSION_WIN8_1	VMSTOR_PROTO_VERSION(6,
> 0)
> +#define VMSTOR_PROTO_VERSION_WIN10	VMSTOR_PROTO_VERSION(6,
> 2)
> 
>  /*  Packet structure describing virtual storage requests. */  enum
> vstor_packet_operation { @@ -205,6 +209,46 @@ struct vmscsi_request {
> 
> 
>  /*
> + * The list of storage protocols in order of preference.
> + */
> +struct vmstor_protocol {
> +	int protocol_version;
> +	int sense_buffer_size;
> +	int vmscsi_size_delta;
> +};
> +
> +#define VMSTOR_NUM_PROTOCOLS    5
> +
> +const struct vmstor_protocol vmstor_protocols[VMSTOR_NUM_PROTOCOLS]
> = {
> +	{
> +		VMSTOR_PROTO_VERSION_WIN10,
> +		POST_WIN7_STORVSC_SENSE_BUFFER_SIZE,
> +		0
> +	},
> +	{
> +		VMSTOR_PROTO_VERSION_WIN8_1,
> +		POST_WIN7_STORVSC_SENSE_BUFFER_SIZE,
> +		0
> +	},
> +	{
> +		VMSTOR_PROTO_VERSION_WIN8,
> +		POST_WIN7_STORVSC_SENSE_BUFFER_SIZE,
> +		0
> +	},
> +	{
> +		VMSTOR_PROTO_VERSION_WIN7,
> +		PRE_WIN8_STORVSC_SENSE_BUFFER_SIZE,
> +		sizeof(struct vmscsi_win8_extension),
> +	},
> +	{
> +		VMSTOR_PROTO_VERSION_WIN6,
> +		PRE_WIN8_STORVSC_SENSE_BUFFER_SIZE,
> +		sizeof(struct vmscsi_win8_extension),
> +	}
> +};
> +
> +
> +/*
>   * This structure is sent during the intialization phase to get the different
>   * properties of the channel.
>   */
> @@ -871,7 +915,7 @@ static int storvsc_channel_init(struct hv_device *device)
>  	struct storvsc_device *stor_device;
>  	struct storvsc_cmd_request *request;
>  	struct vstor_packet *vstor_packet;
> -	int ret, t;
> +	int ret, t, i;
>  	int max_chns;
>  	bool process_sub_channels = false;
> 
> @@ -911,36 +955,59 @@ static int storvsc_channel_init(struct hv_device
> *device)
>  		goto cleanup;
> 
> 
> -	/* reuse the packet for version range supported */
> -	memset(vstor_packet, 0, sizeof(struct vstor_packet));
> -	vstor_packet->operation =
> VSTOR_OPERATION_QUERY_PROTOCOL_VERSION;
> -	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
> +	for (i = 0; i < VMSTOR_NUM_PROTOCOLS; i++) {
> +		/* reuse the packet for version range supported */
> +		memset(vstor_packet, 0, sizeof(struct vstor_packet));
> +		vstor_packet->operation =
> +			VSTOR_OPERATION_QUERY_PROTOCOL_VERSION;
> +		vstor_packet->flags = REQUEST_COMPLETION_FLAG;
> 
> -	vstor_packet->version.major_minor = vmstor_proto_version;
> +		vstor_packet->version.major_minor =
> +			vmstor_protocols[i].protocol_version;
> 
> -	/*
> -	 * The revision number is only used in Windows; set it to 0.
> -	 */
> -	vstor_packet->version.revision = 0;
> +		/*
> +		 * The revision number is only used in Windows; set it to 0.
> +		 */
> +		vstor_packet->version.revision = 0;
> 
> -	ret = vmbus_sendpacket(device->channel, vstor_packet,
> +		ret = vmbus_sendpacket(device->channel, vstor_packet,
>  			       (sizeof(struct vstor_packet) -
>  				vmscsi_size_delta),
>  			       (unsigned long)request,
>  			       VM_PKT_DATA_INBAND,
> 
> VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
> -	if (ret != 0)
> -		goto cleanup;
> +		if (ret != 0)
> +			goto cleanup;
> 
> -	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
> -	if (t == 0) {
> -		ret = -ETIMEDOUT;
> -		goto cleanup;
> +		t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
> +		if (t == 0) {
> +			ret = -ETIMEDOUT;
> +			goto cleanup;
> +		}
> +
> +		if (vstor_packet->operation !=
> VSTOR_OPERATION_COMPLETE_IO) {
> +			ret = -EINVAL;
> +			goto cleanup;
> +		}
> +
> +		if (vstor_packet->status == 0) {
> +			vmstor_proto_version =
> +				vmstor_protocols[i].protocol_version;
> +
> +			sense_buffer_size =
> +				vmstor_protocols[i].sense_buffer_size;
> +
> +			vmscsi_size_delta =
> +				vmstor_protocols[i].vmscsi_size_delta;
> +
> +			break;
> +		}
>  	}
> 
> -	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
> -	    vstor_packet->status != 0)
> +	if (vstor_packet->status != 0) {
> +		ret = -EINVAL;
>  		goto cleanup;
> +	}
> 
> 
>  	memset(vstor_packet, 0, sizeof(struct vstor_packet)); @@ -1745,14
> +1812,12 @@ static int storvsc_probe(struct hv_device *device,
>  	if (vmbus_proto_version < VERSION_WIN8) {
>  		sense_buffer_size = PRE_WIN8_STORVSC_SENSE_BUFFER_SIZE;
>  		vmscsi_size_delta = sizeof(struct vmscsi_win8_extension);
> -		vmstor_proto_version = VMSTOR_PROTO_VERSION_WIN7;
>  		max_luns_per_target =
> STORVSC_IDE_MAX_LUNS_PER_TARGET;
>  		max_targets = STORVSC_IDE_MAX_TARGETS;
>  		max_channels = STORVSC_IDE_MAX_CHANNELS;
>  	} else {
>  		sense_buffer_size =
> POST_WIN7_STORVSC_SENSE_BUFFER_SIZE;
>  		vmscsi_size_delta = 0;
> -		vmstor_proto_version = VMSTOR_PROTO_VERSION_WIN8;
>  		max_luns_per_target = STORVSC_MAX_LUNS_PER_TARGET;
>  		max_targets = STORVSC_MAX_TARGETS;
>  		max_channels = STORVSC_MAX_CHANNELS;
> --
> 1.7.4.1
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
