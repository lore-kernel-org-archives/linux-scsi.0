From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH RESEND 3/7] megaraid_sas : Do not process IOCTLs and SCSI
 commands during driver removal
Date: Fri, 21 Nov 2014 14:51:31 +0100
Message-ID: <546F4363.3000808@redhat.com>
References: <201411170957.sAH9vnhF008957@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540AbaKUNwB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 08:52:01 -0500
In-Reply-To: <201411170957.sAH9vnhF008957@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

On 11/17/2014 10:54 AM, Sumit.Saxena@avagotech.com wrote:
> Do not process any SCSI and IOCTL command further(return them with appropriate return values to callers),
> while driver removal is in progress/PCI shutdown is invoked. 
>
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c |   19 +++++++++++++++----
>  1 files changed, 15 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 5fa6ce2..3781920 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -1571,6 +1571,12 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
>  	instance = (struct megasas_instance *)
>  	    scmd->device->host->hostdata;
>  
> +	if (instance->unload == 1) {
> +		scmd->result = DID_NO_CONNECT << 16;
> +		scmd->scsi_done(scmd);
> +		return 0;
> +	}
> +
>  	if (instance->issuepend_done == 0)
>  		return SCSI_MLQUEUE_HOST_BUSY;
>  
> @@ -4956,10 +4962,6 @@ static int megasas_io_attach(struct megasas_instance *instance)
>  		return -ENODEV;
>  	}
>  
> -	/*
> -	 * Trigger SCSI to scan our drives
> -	 */
> -	scsi_scan_host(host);
>  	return 0;
>  }
>  
> @@ -5287,6 +5289,10 @@ retry_irq_register:
>  		goto fail_io_attach;
>  
>  	instance->unload = 0;
> +	/*
> +	 * Trigger SCSI to scan our drives
> +	 */
> +	scsi_scan_host(host);
>  
>  	/*
>  	 * Initiate AEN (Asynchronous Event Notification)
> @@ -6050,6 +6056,11 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
>  	megasas_issue_blocked_cmd(instance, cmd, 0);
>  	cmd->sync_cmd = 0;
>  
> +	if (instance->unload == 1) {
> +		dev_info(&instance->pdev->dev, "Driver unload is in progress "
> +			"don't submit data to application\n");
> +		goto out;
> +	}
>  	/*
>  	 * copy out the kernel buffers to user buffers
>  	 */

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

