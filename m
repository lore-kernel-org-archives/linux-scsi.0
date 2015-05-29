From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH 1/6] scsi: storvsc: Rather than look for sets of specific
 protocol versions, make decisions based on ranges.
Date: Fri, 29 May 2015 20:33:34 +0000
Message-ID: <DM2PR03MB416988E42919F0534C0A073CEC90@DM2PR03MB416.namprd03.prod.outlook.com>
References: <1432931336-14434-1-git-send-email-kys@microsoft.com>
 <1432931359-14473-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1432931359-14473-1-git-send-email-kys@microsoft.com>
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
> Subject: [PATCH 1/6] scsi: storvsc: Rather than look for sets of specific protocol
> versions, make decisions based on ranges.
> 
> From: keith.mange@microsoft.com <keith.mange@microsoft.com>
> 
> Rather than look for sets of specific protocol versions, make decisions based on
> ranges. This will be safer and require fewer changes going forward as we add
> more storage protocol versions.
> 
Reviewed-by: Long Li <longli@microsoft.com>
> Tested-by: Alex Ng <alexng@microsoft.com>
> Signed-off-by: Keith Mange <keith.mange@microsoft.com>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c |   11 +++--------
>  1 files changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c index
> 3c6584f..582f3b5 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -988,8 +988,7 @@ static int storvsc_channel_init(struct hv_device *device)
>  	 * support multi-channel.
>  	 */
>  	max_chns = vstor_packet-
> >storage_channel_properties.max_channel_cnt;
> -	if ((vmbus_proto_version != VERSION_WIN7) &&
> -	   (vmbus_proto_version != VERSION_WS2008))  {
> +	if (vmbus_proto_version >= VERSION_WIN8) {
>  		if (vstor_packet->storage_channel_properties.flags &
>  		    STORAGE_CHANNEL_SUPPORTS_MULTI_CHANNEL)
>  			process_sub_channels = true;
> @@ -1758,9 +1757,7 @@ static int storvsc_probe(struct hv_device *device,
>  	 * set state to properly communicate with the host.
>  	 */
> 
> -	switch (vmbus_proto_version) {
> -	case VERSION_WS2008:
> -	case VERSION_WIN7:
> +	if (vmbus_proto_version < VERSION_WIN8) {
>  		sense_buffer_size = PRE_WIN8_STORVSC_SENSE_BUFFER_SIZE;
>  		vmscsi_size_delta = sizeof(struct vmscsi_win8_extension);
>  		vmstor_current_major = VMSTOR_WIN7_MAJOR; @@ -
> 1768,8 +1765,7 @@ static int storvsc_probe(struct hv_device *device,
>  		max_luns_per_target =
> STORVSC_IDE_MAX_LUNS_PER_TARGET;
>  		max_targets = STORVSC_IDE_MAX_TARGETS;
>  		max_channels = STORVSC_IDE_MAX_CHANNELS;
> -		break;
> -	default:
> +	} else {
>  		sense_buffer_size =
> POST_WIN7_STORVSC_SENSE_BUFFER_SIZE;
>  		vmscsi_size_delta = 0;
>  		vmstor_current_major = VMSTOR_WIN8_MAJOR; @@ -
> 1783,7 +1779,6 @@ static int storvsc_probe(struct hv_device *device,
>  		 * VCPUs in the guest.
>  		 */
>  		max_sub_channels = (num_cpus /
> storvsc_vcpus_per_sub_channel);
> -		break;
>  	}
> 
>  	scsi_driver.can_queue = (max_outstanding_req_per_channel *
> --
> 1.7.4.1
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
