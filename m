From: Reuben Farrelly <reuben-lkml@reub.net>
Subject: Re: 2.6.13-mm1: hangs during boot ...
Date: Mon, 05 Sep 2005 20:37:44 +1200
Message-ID: <431C03D8.9080609@reub.net>
References: <fa.qs5cahs.i2khgm@ifi.uio.no> <fa.fm9i4v6.1ekchhm@ifi.uio.no>	 <4319A402.7030705@reub.net> <1125851525.4842.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932374AbVIEIh4@vger.kernel.org>
In-Reply-To: <1125851525.4842.8.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Peter Williams <pwil3058@bigpond.net.au>, "Brown, Len" <len.brown@intel.com>, Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

On 5/09/2005 4:32 a.m., James Bottomley wrote:
> On Sun, 2005-09-04 at 01:24 +1200, Reuben Farrelly wrote:
>> I am seeing it fill up my messages log as it is logging 1 or so messages each 
>> minute.  I've emailed the SCSI maintainer James Bottomley twice about it but 
>> had no response either time.
> 
> OK, can you try this ... it should confirm the theory if the messages go
> away.
> 
> Thanks,
> 
> James
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -315,7 +315,7 @@ int scsi_execute(struct scsi_device *sde
>  	req->sense = sense;
>  	req->sense_len = 0;
>  	req->timeout = timeout;
> -	req->flags |= flags | REQ_BLOCK_PC | REQ_SPECIAL;
> +	req->flags |= flags | REQ_BLOCK_PC | REQ_SPECIAL | REQ_QUIET;
>  
>  	/*
>  	 * head injection *required* here otherwise quiesce won't work
> @@ -927,17 +927,20 @@ void scsi_io_completion(struct scsi_cmnd
>  				scsi_requeue_command(q, cmd);
>  				return;
>  			}
> -			printk(KERN_INFO "Device %s not ready.\n",
> -			       req->rq_disk ? req->rq_disk->disk_name : "");
> +			if (!(req->flags & REQ_QUIET))
> +				dev_printk(KERN_INFO,
> +					   &cmd->device->sdev_gendev,
> +					   "Device not ready.\n");
>  			cmd = scsi_end_request(cmd, 0, this_count, 1);
>  			return;
>  		case VOLUME_OVERFLOW:
> -			printk(KERN_INFO "Volume overflow <%d %d %d %d> CDB: ",
> -			       cmd->device->host->host_no,
> -			       (int)cmd->device->channel,
> -			       (int)cmd->device->id, (int)cmd->device->lun);
> -			__scsi_print_command(cmd->data_cmnd);
> -			scsi_print_sense("", cmd);
> +			if (!(req->flags & REQ_QUIET)) {
> +				dev_printk(KERN_INFO,
> +					   &cmd->device->sdev_gendev,
> +					   "Volume overflow, CDB: ");
> +				__scsi_print_command(cmd->data_cmnd);
> +				scsi_print_sense("", cmd);
> +			}
>  			cmd = scsi_end_request(cmd, 0, block_bytes, 1);
>  			return;
>  		default:
> @@ -954,15 +957,13 @@ void scsi_io_completion(struct scsi_cmnd
>  		return;
>  	}
>  	if (result) {
> -		if (!(req->flags & REQ_SPECIAL))
> -			printk(KERN_INFO "SCSI error : <%d %d %d %d> return code "
> -			       "= 0x%x\n", cmd->device->host->host_no,
> -			       cmd->device->channel,
> -			       cmd->device->id,
> -			       cmd->device->lun, result);
> +		if (!(req->flags & REQ_QUIET)) {
> +			dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
> +				   "SCSI error: return code = 0x%x\n", result);
>  
> -		if (driver_byte(result) & DRIVER_SENSE)
> -			scsi_print_sense("", cmd);
> +			if (driver_byte(result) & DRIVER_SENSE)
> +				scsi_print_sense("", cmd);
> +		}
>  		/*
>  		 * Mark a single buffer as not uptodate.  Queue the remainder.
>  		 * We sometimes get this cruft in the event that a medium error

This patch fixes it, and there was no message during boot about not being 
ready, nor after the machine had fully booted.  Great ;-)

However, I did get an oops when warm booting the kernel, I suspect this may be 
the oops that I get every now and then when warm rebooting, with no real 
pattern, and possibly isn't related to the patch.  As my serial console wasn't 
set up at the time, I took a photo instead, at 
http://www.reub.net/kernel/scsi-oops.jpg

Thanks
reuben
