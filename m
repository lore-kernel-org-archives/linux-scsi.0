From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] scsi: Fix printing of failed 32-byte commands
Date: Tue, 19 Jan 2010 12:25:56 +0200
Message-ID: <4B5588B4.4030608@panasas.com>
References: <yq1636zt1yr.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:24407 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755060Ab0ASKZ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2010 05:25:59 -0500
In-Reply-To: <yq1636zt1yr.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On 01/19/2010 01:42 AM, Martin K. Petersen wrote:
> 
> Having the large CDB allocation logic in sd.c means that
> scsi_io_completion does not have access to the command buffer. That in
> turn causes garbage to be printed when a 32-byte command fails. Move the
> command printing to sd_done where the command buffer is intact and
> inform scsi_lib.c that no printing is necessary.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> ---
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index d892768..d716ff2 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -897,7 +897,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  			scsi_print_result(cmd);
>  			if (driver_byte(result) & DRIVER_SENSE)
>  				scsi_print_sense("", cmd);
> -			scsi_print_command(cmd);
> +			if (!cmd->device->prints_failed_commands)
> +				scsi_print_command(cmd);

I don't like that flag. If cmd->cmnd is invalid after the call to sd_done.
Then I prefer if sd_done could NULL the pointer and any access will BUG,
instead of a dangerous use after free, which you never know when it will
bite.

Then if so scsi_print_command() can just silently ignore any
cmd->cmnd == NULL cases. (And a fat comment somewhere)

>  		}
>  		if (blk_end_request_err(req, error))
>  			scsi_requeue_command(q, cmd);
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 255da53..ad15c2e 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1214,6 +1214,9 @@ static int sd_done(struct scsi_cmnd *SCpnt)
>  		break;
>  	}
>   out:
> +	if (result)
> +		scsi_print_command(SCpnt);
> +
>  	if (rq_data_dir(SCpnt->request) == READ && scsi_prot_sg_count(SCpnt))
>  		sd_dif_complete(SCpnt, good_bytes);
>  

You must do this in any case
---
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 255da53..cd5196d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1218,8 +1218,10 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 		sd_dif_complete(SCpnt, good_bytes);
 
 	if (scsi_host_dif_capable(sdkp->device->host, sdkp->protection_type)
-	    == SD_DIF_TYPE2_PROTECTION && SCpnt->cmnd != SCpnt->request->cmd)
+	    == SD_DIF_TYPE2_PROTECTION && SCpnt->cmnd != SCpnt->request->cmd) {
 		mempool_free(SCpnt->cmnd, sd_cdb_pool);
+		SCpnt->cmnd = NULL;
+	}
 
 	return good_bytes;
 }


> @@ -2071,6 +2074,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  	}
>  
>  	sdkp->first_scan = 0;
> +	sdp->prints_failed_commands = 1;
>  
>  	/*
>  	 * We now have all cache related info, determine how we deal
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 7c44499..0d551a3 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -149,6 +149,7 @@ struct scsi_device {
>  	unsigned last_sector_bug:1;	/* do not use multisector accesses on
>  					   SD_LAST_BUGGY_SECTORS */
>  	unsigned is_visible:1;	/* is the device visible in sysfs */
> +	unsigned prints_failed_commands:1;	/* ULD prints failed commands */
>  
>  	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
>  	struct list_head event_list;	/* asserted events */
> --

Thanks
Boaz
