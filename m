From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH] storvsc: add more logging for error and warning messages
Date: Fri, 04 Dec 2015 10:52:49 +0100
Message-ID: <87vb8e5ymm.fsf@vitty.brq.redhat.com>
References: <1449200865-20694-1-git-send-email-longli@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1449200865-20694-1-git-send-email-longli@microsoft.com> (Long
 Li's message of "Thu, 3 Dec 2015 19:47:45 -0800")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Long Li <longli@microsoft.com>
Cc: linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

Long Li <longli@microsoft.com> writes:

> Introduce a logging level for storvsc to log certain error/warning
> messages. Those messages are helpful in some environments,
> e.g. Microsoft Azure, for customer support and troubleshooting
> purposes.

I have an alternative suggestion: let's use dynamic debug! Basically, we
need to convert all non-error logging to using dev_dbg() and this can be
enabled dynamically when needed, even reboot won't be required.

>
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c | 30 +++++++++++++++++++++++++++++-
>  1 file changed, 29 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 40c43ae..afa1647 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -164,6 +164,21 @@ static int sense_buffer_size = PRE_WIN8_STORVSC_SENSE_BUFFER_SIZE;
>  */
>  static int vmstor_proto_version;
>
> +#define STORVSC_LOGGING_NONE	0
> +#define STORVSC_LOGGING_ERROR	1
> +#define STORVSC_LOGGING_WARN	2
> +
> +static int logging_level = STORVSC_LOGGING_ERROR;
> +module_param(logging_level, int, S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(logging_level,
> +	"Logging level, 0 - None, 1 - Error (default), 2 - Warning.");
> +
> +static inline bool do_logging(int level)
> +{
> +	return (logging_level >= level) ? true : false;
> +}
> +
> +
>  struct vmscsi_win8_extension {
>  	/*
>  	 * The following were added in Windows 8
> @@ -1183,7 +1198,7 @@ static void storvsc_command_completion(struct storvsc_cmd_request *cmd_request)
>
>  	scmnd->result = vm_srb->scsi_status;
>
> -	if (scmnd->result) {
> +	if (scmnd->result && do_logging(STORVSC_LOGGING_ERROR)) {
>  		if (scsi_normalize_sense(scmnd->sense_buffer,
>  				SCSI_SENSE_BUFFERSIZE, &sense_hdr))
>  			scsi_print_sense_hdr(scmnd->device, "storvsc",
> @@ -1239,12 +1254,25 @@ static void storvsc_on_io_completion(struct hv_device *device,
>  	stor_pkt->vm_srb.sense_info_length =
>  	vstor_packet->vm_srb.sense_info_length;
>
> +	if (vstor_packet->vm_srb.scsi_status != 0 ||
> +		vstor_packet->vm_srb.srb_status != SRB_STATUS_SUCCESS)
> +		if (do_logging(STORVSC_LOGGING_WARN))
> +			dev_warn(&device->device,
> +				"cmd 0x%x scsi status 0x%x srb status 0x%x\n",
> +				stor_pkt->vm_srb.cdb[0],
> +				vstor_packet->vm_srb.scsi_status,
> +				vstor_packet->vm_srb.srb_status);
>
>  	if ((vstor_packet->vm_srb.scsi_status & 0xFF) == 0x02) {
>  		/* CHECK_CONDITION */
>  		if (vstor_packet->vm_srb.srb_status &
>  			SRB_STATUS_AUTOSENSE_VALID) {
>  			/* autosense data available */
> +			if (do_logging(STORVSC_LOGGING_WARN))
> +				dev_warn(&device->device,
> +					"stor pkt %p autosense data valid - len %d\n",
> +					request,
> +					vstor_packet->vm_srb.sense_info_length);
>
>  			memcpy(request->cmd->sense_buffer,
>  			       vstor_packet->vm_srb.sense_data,

-- 
  Vitaly
