From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH 5/6] scsi: storvsc: use storage protocol version to
 determine storage capabilities
Date: Fri, 29 May 2015 20:38:56 +0000
Message-ID: <DM2PR03MB4162BEE3C8EE276599B8311CEC90@DM2PR03MB416.namprd03.prod.outlook.com>
References: <1432931336-14434-1-git-send-email-kys@microsoft.com>
 <1432931359-14473-1-git-send-email-kys@microsoft.com>
 <1432931359-14473-5-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0133.outbound.protection.outlook.com ([157.56.111.133]:38368
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756544AbbE2Ui6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2015 16:38:58 -0400
In-Reply-To: <1432931359-14473-5-git-send-email-kys@microsoft.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>
Cc: Keith Mange <Keith.Mange@microsoft.com>



> -----Original Message-----
> From: devel [mailto:driverdev-devel-bounces@linuxdriverproject.org] On
> Behalf Of K. Y. Srinivasan
> Sent: Friday, May 29, 2015 1:29 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; jbottomley@parallels.com;
> hch@infradead.org; linux-scsi@vger.kernel.org; apw@canonical.com;
> vkuznets@redhat.com; jasowang@redhat.com
> Cc: Keith Mange
> Subject: [PATCH 5/6] scsi: storvsc: use storage protocol version to determine
> storage capabilities
> 
> From: keith.mange@microsoft.com <keith.mange@microsoft.com>
> 
> Use storage protocol version instead of vmbus protocol version when
> determining storage capabilities.
> 
Reviewed-by: Long Li <longli@microsoft.com>
> Tested-by: Alex Ng <alexng@microsoft.com>
> Signed-off-by: Keith Mange <keith.mange@microsoft.com>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c index
> 6f38cdf..58fa47a 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1049,7 +1049,7 @@ static int storvsc_channel_init(struct hv_device
> *device)
>  	 * support multi-channel.
>  	 */
>  	max_chns = vstor_packet-
> >storage_channel_properties.max_channel_cnt;
> -	if (vmbus_proto_version >= VERSION_WIN8) {
> +	if (vmstor_proto_version >= VMSTOR_PROTO_VERSION_WIN8) {
>  		if (vstor_packet->storage_channel_properties.flags &
>  		    STORAGE_CHANNEL_SUPPORTS_MULTI_CHANNEL)
>  			process_sub_channels = true;
> @@ -1491,9 +1491,9 @@ static int storvsc_device_configure(struct
> scsi_device *sdevice)
>  	 * if the device is a MSFT virtual device.
>  	 */
>  	if (!strncmp(sdevice->vendor, "Msft", 4)) {
> -		switch (vmbus_proto_version) {
> -		case VERSION_WIN8:
> -		case VERSION_WIN8_1:
> +		switch (vmstor_proto_version) {
> +		case VMSTOR_PROTO_VERSION_WIN8:
> +		case VMSTOR_PROTO_VERSION_WIN8_1:
>  			sdevice->scsi_level = SCSI_SPC_3;
>  			break;
>  		}
> --
> 1.7.4.1
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
