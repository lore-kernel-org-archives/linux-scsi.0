From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH 2/6] scsi: storvsc: Use a single value to track protocol
 versions
Date: Fri, 29 May 2015 20:34:54 +0000
Message-ID: <DM2PR03MB4164E6BCBAE34FECA2EC712CEC90@DM2PR03MB416.namprd03.prod.outlook.com>
References: <1432931336-14434-1-git-send-email-kys@microsoft.com>
 <1432931359-14473-1-git-send-email-kys@microsoft.com>
 <1432931359-14473-2-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1432931359-14473-2-git-send-email-kys@microsoft.com>
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
> Subject: [PATCH 2/6] scsi: storvsc: Use a single value to track protocol versions
> 
> From: keith.mange@microsoft.com <keith.mange@microsoft.com>
> 
> Use a single value to track protocol versions to simplify comparisons and to be
> consistent with vmbus version tracking.
> 
Reviewed-by: Long Li <longli@microsoft.com>
> Tested-by: Alex Ng <alexng@microsoft.com>
> Signed-off-by: Keith Mange <keith.mange@microsoft.com>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c |   35 +++++++++--------------------------
>  1 files changed, 9 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c index
> 582f3b5..5f9d133 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -58,12 +58,11 @@
>   * Win8: 5.1
>   */
> 
> +#define VMSTOR_PROTO_VERSION(MAJOR_, MINOR_)	((((MAJOR_) & 0xff)
> << 8) | \
> +						(((MINOR_) & 0xff)))
> 
> -#define VMSTOR_WIN7_MAJOR 4
> -#define VMSTOR_WIN7_MINOR 2
> -
> -#define VMSTOR_WIN8_MAJOR 5
> -#define VMSTOR_WIN8_MINOR 1
> +#define VMSTOR_PROTO_VERSION_WIN7	VMSTOR_PROTO_VERSION(4,
> 2)
> +#define VMSTOR_PROTO_VERSION_WIN8	VMSTOR_PROTO_VERSION(5,
> 1)
> 
> 
>  /*  Packet structure describing virtual storage requests. */ @@ -161,8 +160,7
> @@ static int sense_buffer_size;
>   */
> 
>  static int vmscsi_size_delta;
> -static int vmstor_current_major;
> -static int vmstor_current_minor;
> +static int vmstor_proto_version;
> 
>  struct vmscsi_win8_extension {
>  	/*
> @@ -481,18 +479,6 @@ done:
>  	kfree(wrk);
>  }
> 
> -/*
> - * Major/minor macros.  Minor version is in LSB, meaning that earlier flat
> - * version numbers will be interpreted as "0.x" (i.e., 1 becomes 0.1).
> - */
> -
> -static inline u16 storvsc_get_version(u8 major, u8 minor) -{
> -	u16 version;
> -
> -	version = ((major << 8) | minor);
> -	return version;
> -}
> 
>  /*
>   * We can get incoming messages from the host that are not in response to
> @@ -930,8 +916,7 @@ static int storvsc_channel_init(struct hv_device *device)
>  	vstor_packet->operation =
> VSTOR_OPERATION_QUERY_PROTOCOL_VERSION;
>  	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
> 
> -	vstor_packet->version.major_minor =
> -		storvsc_get_version(vmstor_current_major,
> vmstor_current_minor);
> +	vstor_packet->version.major_minor = vmstor_proto_version;
> 
>  	/*
>  	 * The revision number is only used in Windows; set it to 0.
> @@ -1562,7 +1547,7 @@ static int storvsc_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *scmnd)
>  	u32 payload_sz;
>  	u32 length;
> 
> -	if (vmstor_current_major <= VMSTOR_WIN8_MAJOR) {
> +	if (vmstor_proto_version <= VMSTOR_PROTO_VERSION_WIN8) {
>  		/*
>  		 * On legacy hosts filter unimplemented commands.
>  		 * Future hosts are expected to correctly handle @@ -1760,16
> +1745,14 @@ static int storvsc_probe(struct hv_device *device,
>  	if (vmbus_proto_version < VERSION_WIN8) {
>  		sense_buffer_size = PRE_WIN8_STORVSC_SENSE_BUFFER_SIZE;
>  		vmscsi_size_delta = sizeof(struct vmscsi_win8_extension);
> -		vmstor_current_major = VMSTOR_WIN7_MAJOR;
> -		vmstor_current_minor = VMSTOR_WIN7_MINOR;
> +		vmstor_proto_version = VMSTOR_PROTO_VERSION_WIN7;
>  		max_luns_per_target =
> STORVSC_IDE_MAX_LUNS_PER_TARGET;
>  		max_targets = STORVSC_IDE_MAX_TARGETS;
>  		max_channels = STORVSC_IDE_MAX_CHANNELS;
>  	} else {
>  		sense_buffer_size =
> POST_WIN7_STORVSC_SENSE_BUFFER_SIZE;
>  		vmscsi_size_delta = 0;
> -		vmstor_current_major = VMSTOR_WIN8_MAJOR;
> -		vmstor_current_minor = VMSTOR_WIN8_MINOR;
> +		vmstor_proto_version = VMSTOR_PROTO_VERSION_WIN8;
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
