From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v4 1/4] block: add a flag to identify PM request
Date: Thu, 5 Jul 2012 15:09:42 +0200
Message-ID: <201207051509.42979.rjw@sisk.pl>
References: <1341473199-3837-1-git-send-email-ming.m.lin@intel.com> <1341473199-3837-2-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1341473199-3837-2-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thursday, July 05, 2012, Lin Ming wrote:
> Add a flag REQ_PM to identify the request is PM related.
> As an example, modify scsi code to use this flag.
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  drivers/scsi/scsi_lib.c    |   25 ++++++++++++++++++++++---
>  drivers/scsi/sd.c          |    9 +++++----
>  include/linux/blk_types.h  |    2 ++
>  include/scsi/scsi_device.h |    4 ++++
>  4 files changed, 33 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 6dfb978..45538e5 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -256,10 +256,10 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
>  EXPORT_SYMBOL(scsi_execute);
>  
>  
> -int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
> +static int __scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
>  		     int data_direction, void *buffer, unsigned bufflen,
>  		     struct scsi_sense_hdr *sshdr, int timeout, int retries,
> -		     int *resid)
> +		     int *resid, int flags)
>  {
>  	char *sense = NULL;
>  	int result;
> @@ -270,15 +270,34 @@ int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
>  			return DRIVER_ERROR << 24;
>  	}
>  	result = scsi_execute(sdev, cmd, data_direction, buffer, bufflen,
> -			      sense, timeout, retries, 0, resid);
> +			      sense, timeout, retries, flags, resid);
>  	if (sshdr)
>  		scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, sshdr);
>  
>  	kfree(sense);
>  	return result;
>  }
> +
> +int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
> +		     int data_direction, void *buffer, unsigned bufflen,
> +		     struct scsi_sense_hdr *sshdr, int timeout, int retries,
> +		     int *resid)
> +{
> +	return __scsi_execute_req(sdev, cmd, data_direction, buffer, bufflen,
> +			      sshdr, timeout, retries, resid, 0);
> +}
>  EXPORT_SYMBOL(scsi_execute_req);
>  
> +int scsi_execute_req_flag(struct scsi_device *sdev, const unsigned char *cmd,
> +		     int data_direction, void *buffer, unsigned bufflen,
> +		     struct scsi_sense_hdr *sshdr, int timeout, int retries,
> +		     int *resid, int flags)
> +{
> +	return __scsi_execute_req(sdev, cmd, data_direction, buffer, bufflen,
> +			      sshdr, timeout, retries, resid, flags);
> +}
> +EXPORT_SYMBOL(scsi_execute_req_flag);

Hmm.  You're only adding one item to the call chain this way and with many
arguments.  I think it would be better to export __scsi_execute_req()
directly and define the wrappers as static inlines in a header.

In which case you won't need the second wrapper even.  So perhaps it would be
a good idea to call the function scsi_execute_req_flags() and add a static
inline wrapper called scsi_execute_req() around it that will pass 0 as flags?

Rafael


> +
>  /*
>   * Function:    scsi_init_cmd_errh()
>   *
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 6f72b80..bf8413a 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1270,8 +1270,9 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
>  		 * Leave the rest of the command zero to indicate
>  		 * flush everything.
>  		 */
> -		res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
> -				       SD_FLUSH_TIMEOUT, SD_MAX_RETRIES, NULL);
> +		res = scsi_execute_req_flag(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
> +				       SD_FLUSH_TIMEOUT, SD_MAX_RETRIES, NULL,
> +				       REQ_PM);
>  		if (res == 0)
>  			break;
>  	}
> @@ -2815,8 +2816,8 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>  	if (!scsi_device_online(sdp))
>  		return -ENODEV;
>  
> -	res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
> -			       SD_TIMEOUT, SD_MAX_RETRIES, NULL);
> +	res = scsi_execute_req_flag(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
> +			       SD_TIMEOUT, SD_MAX_RETRIES, NULL, REQ_PM);
>  	if (res) {
>  		sd_printk(KERN_WARNING, sdkp, "START_STOP FAILED\n");
>  		sd_print_result(sdkp, res);
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 0edb65d..ed53dca 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -160,6 +160,7 @@ enum rq_flag_bits {
>  	__REQ_FLUSH_SEQ,	/* request for flush sequence */
>  	__REQ_IO_STAT,		/* account I/O stat */
>  	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
> +	__REQ_PM,		/* runtime pm request */
>  	__REQ_NR_BITS,		/* stops here */
>  };
>  
> @@ -201,5 +202,6 @@ enum rq_flag_bits {
>  #define REQ_IO_STAT		(1 << __REQ_IO_STAT)
>  #define REQ_MIXED_MERGE		(1 << __REQ_MIXED_MERGE)
>  #define REQ_SECURE		(1 << __REQ_SECURE)
> +#define REQ_PM			(1 << __REQ_PM)
>  
>  #endif /* __LINUX_BLK_TYPES_H */
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index ba96988..e7fdff5 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -388,6 +388,10 @@ extern int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
>  			    int data_direction, void *buffer, unsigned bufflen,
>  			    struct scsi_sense_hdr *, int timeout, int retries,
>  			    int *resid);
> +extern int scsi_execute_req_flag(struct scsi_device *sdev, const unsigned char *cmd,
> +			    int data_direction, void *buffer, unsigned bufflen,
> +			    struct scsi_sense_hdr *, int timeout, int retries,
> +			    int *resid, int flags);
>  
>  #ifdef CONFIG_PM_RUNTIME
>  extern int scsi_autopm_get_device(struct scsi_device *);
> 
