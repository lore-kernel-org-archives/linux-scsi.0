From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] scsi: Fix printing of failed 32-byte commands
Date: Wed, 20 Jan 2010 10:47:06 +0200
Message-ID: <4B56C30A.6040107@panasas.com>
References: <yq1636zt1yr.fsf@sermon.lab.mkp.net>	<4B5588B4.4030608@panasas.com> <yq1ska1kzsk.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:38191 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750703Ab0ATIrK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2010 03:47:10 -0500
In-Reply-To: <yq1ska1kzsk.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On 01/20/2010 09:20 AM, Martin K. Petersen wrote:
>>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:
> 
> Boaz> I don't like that flag. If cmd->cmnd is invalid after the call to
> Boaz> sd_done.  Then I prefer if sd_done could NULL the pointer and any
> Boaz> access will BUG, instead of a dangerous use after free, which you
> Boaz> never know when it will bite.
> 
> Boaz> Then if so scsi_print_command() can just silently ignore any
> cmd-> cmnd == NULL cases. (And a fat comment somewhere)
> 
> Yeah, that's a better idea.  I considered that flag a wart from the
> get-go...
> 
> 
> scsi: Fix printing of failed 32-byte commands
> 
> Having the large CDB allocation logic in sd.c means that
> scsi_io_completion does not have access to the command buffer. That in
> turn causes garbage to be printed when a 32-byte command fails. Move the
> command printing to sd_done where the command buffer is intact.  Clear
> the command buffer pointer after the extended CDB has been freed.
> 
> Make scsi_print_command ignore commands with NULL CDB pointers to
> inhibit printing of garbled command strings.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 

Grate, thanks looks much better.
Reviewed-by: Boaz Harrosh <bharrosh@panasas.com>

> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
> index db68e3b..93606bc 100644
> --- a/drivers/scsi/constants.c
> +++ b/drivers/scsi/constants.c
> @@ -349,6 +349,9 @@ void scsi_print_command(struct scsi_cmnd *cmd)
>  {
>  	int k;
>  
> +	if (cmd->cmnd == NULL)
> +		return;
> +
>  	scmd_printk(KERN_INFO, cmd, "CDB: ");
>  	print_opcode_name(cmd->cmnd, cmd->cmd_len);
>  
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 255da53..5f0f6c7 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1218,8 +1218,19 @@ static int sd_done(struct scsi_cmnd *SCpnt)
>  		sd_dif_complete(SCpnt, good_bytes);
>  
>  	if (scsi_host_dif_capable(sdkp->device->host, sdkp->protection_type)
> -	    == SD_DIF_TYPE2_PROTECTION && SCpnt->cmnd != SCpnt->request->cmd)
> +	    == SD_DIF_TYPE2_PROTECTION && SCpnt->cmnd != SCpnt->request->cmd) {
> +
> +		/* We have to print a failed command here as the
> +		 * extended CDB gets freed before scsi_io_completion()
> +		 * is called.
> +		 */
> +		if (result)
> +			scsi_print_command(SCpnt);
> +
>  		mempool_free(SCpnt->cmnd, sd_cdb_pool);
> +		SCpnt->cmnd = NULL;
> +		SCpnt->cmd_len = 0;
> +	}
>  
>  	return good_bytes;
>  }

