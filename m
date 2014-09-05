From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: Re: [PATCH 18/20] scsi: remove scsi_show_result()
Date: Fri, 05 Sep 2014 13:22:13 +0900
Message-ID: <54093A75.6050207@hitachi.com>
References: <1409738775-80876-1-git-send-email-hare@suse.de> <1409738775-80876-19-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail7.hitachi.co.jp ([133.145.228.42]:44246 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbaIEEWQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Sep 2014 00:22:16 -0400
In-Reply-To: <1409738775-80876-19-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

This patch looks good.

Thanks,
Yoshihiro YUNOMAE

(2014/09/03 19:06), Hannes Reinecke wrote:
> scsi_show_result() was only ever used in one place in sd.c.
> So open-code scsi_show_result() in sd.c and remove it from
> constants.c.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/constants.c | 16 -------------
>   drivers/scsi/sd.c        | 62 +++++++++++++++++++++++++++++-------------------
>   include/scsi/scsi_dbg.h  |  1 -
>   3 files changed, 37 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
> index 630e272..d7516c3 100644
> --- a/drivers/scsi/constants.c
> +++ b/drivers/scsi/constants.c
> @@ -1496,22 +1496,6 @@ const char *scsi_show_driverbyte(int result)
>   }
>   EXPORT_SYMBOL(scsi_show_driverbyte);
>   
> -void scsi_show_result(int result)
> -{
> -	const char *hb_string = scsi_show_hostbyte(result);
> -	const char *db_string = scsi_show_driverbyte(result);
> -
> -	if (hb_string || db_string)
> -		printk("Result: hostbyte=%s driverbyte=%s\n",
> -		       hb_string ? hb_string : "invalid",
> -		       db_string ? db_string : "invalid");
> -	else
> -		printk("Result: hostbyte=0x%02x driverbyte=0x%02x\n",
> -		       host_byte(result), driver_byte(result));
> -}
> -EXPORT_SYMBOL(scsi_show_result);
> -
> -
>   void scsi_print_result(struct scsi_cmnd *cmd)
>   {
>   	const char *hb_string = scsi_show_hostbyte(cmd->result);
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index aac267a..f96e3f9 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -116,7 +116,7 @@ static int sd_eh_action(struct scsi_cmnd *, int);
>   static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
>   static void scsi_disk_release(struct device *cdev);
>   static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
> -static void sd_print_result(struct scsi_disk *, int);
> +static void sd_print_result(struct scsi_disk *, const char *, int);
>   
>   static DEFINE_SPINLOCK(sd_index_lock);
>   static DEFINE_IDA(sd_index_ida);
> @@ -1479,7 +1479,7 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
>   	}
>   
>   	if (res) {
> -		sd_print_result(sdkp, res);
> +		sd_print_result(sdkp, "SYNCHRONIZE CACHE failed", res);
>   
>   		if (driver_byte(res) & DRIVER_SENSE)
>   			sd_print_sense_hdr(sdkp, &sshdr);
> @@ -1820,8 +1820,8 @@ sd_spinup_disk(struct scsi_disk *sdkp)
>   			/* no sense, TUR either succeeded or failed
>   			 * with a status error */
>   			if(!spintime && !scsi_status_is_good(the_result)) {
> -				sd_printk(KERN_NOTICE, sdkp, "Unit Not Ready\n");
> -				sd_print_result(sdkp, the_result);
> +				sd_print_result(sdkp, "Unit Not Ready",
> +						the_result);
>   			}
>   			break;
>   		}
> @@ -1937,11 +1937,13 @@ static int sd_read_protection_type(struct scsi_disk *sdkp, unsigned char *buffer
>   	return ret;
>   }
>   
> -static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
> -			struct scsi_sense_hdr *sshdr, int sense_valid,
> -			int the_result)
> +static void read_capacity_error(struct scsi_disk *sdkp,
> +				struct scsi_sense_hdr *sshdr, int sense_valid,
> +				const char *msg, int the_result)
>   {
> -	sd_print_result(sdkp, the_result);
> +	struct scsi_device *sdp = sdkp->device;
> +
> +	sd_print_result(sdkp, msg, the_result);
>   	if (driver_byte(the_result) & DRIVER_SENSE)
>   		sd_print_sense_hdr(sdkp, sshdr);
>   	else
> @@ -1970,9 +1972,9 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
>   
>   #define READ_CAPACITY_RETRIES_ON_RESET	10
>   
> -static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
> -						unsigned char *buffer)
> +static int read_capacity_16(struct scsi_disk *sdkp, unsigned char *buffer)
>   {
> +	struct scsi_device *sdp = sdkp->device;
>   	unsigned char cmd[16];
>   	struct scsi_sense_hdr sshdr;
>   	int sense_valid = 0;
> @@ -2022,8 +2024,8 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>   	} while (the_result && retries);
>   
>   	if (the_result) {
> -		sd_printk(KERN_NOTICE, sdkp, "READ CAPACITY(16) failed\n");
> -		read_capacity_error(sdkp, sdp, &sshdr, sense_valid, the_result);
> +		read_capacity_error(sdkp, &sshdr, sense_valid,
> +				    "READ CAPACITY(16) failed", the_result);
>   		return -EINVAL;
>   	}
>   
> @@ -2066,9 +2068,9 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>   	return sector_size;
>   }
>   
> -static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
> -						unsigned char *buffer)
> +static int read_capacity_10(struct scsi_disk *sdkp, unsigned char *buffer)
>   {
> +	struct scsi_device *sdp = sdkp->device;
>   	unsigned char cmd[16];
>   	struct scsi_sense_hdr sshdr;
>   	int sense_valid = 0;
> @@ -2104,8 +2106,8 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
>   	} while (the_result && retries);
>   
>   	if (the_result) {
> -		sd_printk(KERN_NOTICE, sdkp, "READ CAPACITY failed\n");
> -		read_capacity_error(sdkp, sdp, &sshdr, sense_valid, the_result);
> +		read_capacity_error(sdkp, &sshdr, sense_valid,
> +				    "READ CAPACITY failed", the_result);
>   		return -EINVAL;
>   	}
>   
> @@ -2158,17 +2160,17 @@ sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer)
>   	sector_t old_capacity = sdkp->capacity;
>   
>   	if (sd_try_rc16_first(sdp)) {
> -		sector_size = read_capacity_16(sdkp, sdp, buffer);
> +		sector_size = read_capacity_16(sdkp, buffer);
>   		if (sector_size == -EOVERFLOW)
>   			goto got_data;
>   		if (sector_size == -ENODEV)
>   			return;
>   		if (sector_size < 0)
> -			sector_size = read_capacity_10(sdkp, sdp, buffer);
> +			sector_size = read_capacity_10(sdkp, buffer);
>   		if (sector_size < 0)
>   			return;
>   	} else {
> -		sector_size = read_capacity_10(sdkp, sdp, buffer);
> +		sector_size = read_capacity_10(sdkp, buffer);
>   		if (sector_size == -EOVERFLOW)
>   			goto got_data;
>   		if (sector_size < 0)
> @@ -2178,7 +2180,7 @@ sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer)
>   			int old_sector_size = sector_size;
>   			sd_printk(KERN_NOTICE, sdkp, "Very big device. "
>   					"Trying to use READ CAPACITY(16).\n");
> -			sector_size = read_capacity_16(sdkp, sdp, buffer);
> +			sector_size = read_capacity_16(sdkp, buffer);
>   			if (sector_size < 0) {
>   				sd_printk(KERN_NOTICE, sdkp,
>   					"Using 0xffffffff as device size\n");
> @@ -3124,8 +3126,7 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>   	res = scsi_execute_req_flags(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
>   			       SD_TIMEOUT, SD_MAX_RETRIES, NULL, REQ_PM);
>   	if (res) {
> -		sd_printk(KERN_WARNING, sdkp, "START_STOP FAILED\n");
> -		sd_print_result(sdkp, res);
> +		sd_print_result(sdkp, "START_STOP failed", res);
>   		if (driver_byte(res) & DRIVER_SENSE)
>   			sd_print_sense_hdr(sdkp, &sshdr);
>   		if (scsi_sense_valid(&sshdr) &&
> @@ -3326,9 +3327,20 @@ static void sd_print_sense_hdr(struct scsi_disk *sdkp,
>   			     sshdr->asc, sshdr->ascq);
>   }
>   
> -static void sd_print_result(struct scsi_disk *sdkp, int result)
> +static void sd_print_result(struct scsi_disk *sdkp, const char *msg,
> +			    int result)
>   {
> -	sd_printk(KERN_INFO, sdkp, " ");
> -	scsi_show_result(result);
> +	const char *hb_string = scsi_show_hostbyte(result);
> +	const char *db_string = scsi_show_driverbyte(result);
> +
> +	if (hb_string || db_string)
> +		sd_printk(KERN_INFO, sdkp,
> +			  "%s: Result: hostbyte=%s driverbyte=%s\n", msg,
> +			  hb_string ? hb_string : "invalid",
> +			  db_string ? db_string : "invalid");
> +	else
> +		sd_printk(KERN_INFO, sdkp,
> +			  "%s: Result: hostbyte=0x%02x driverbyte=0x%02x\n",
> +			  msg, host_byte(result), driver_byte(result));
>   }
>   
> diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
> index a3170a5..b4770f0 100644
> --- a/include/scsi/scsi_dbg.h
> +++ b/include/scsi/scsi_dbg.h
> @@ -17,7 +17,6 @@ extern void scsi_print_sense(struct scsi_cmnd *);
>   extern void __scsi_print_sense(struct scsi_device *, const char *name,
>   			       const unsigned char *sense_buffer,
>   			       int sense_len);
> -extern void scsi_show_result(int);
>   extern void scsi_print_result(struct scsi_cmnd *);
>   extern const char *scsi_show_hostbyte(int);
>   extern const char *scsi_show_driverbyte(int);
> 

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


