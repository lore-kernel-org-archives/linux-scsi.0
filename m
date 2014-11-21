From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH RESEND 6/7] megaraid_sas : Corrected return of wait_event
 from abort frame path
Date: Fri, 21 Nov 2014 14:52:08 +0100
Message-ID: <546F4388.6040508@redhat.com>
References: <201411170958.sAH9w4GU008976@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758650AbaKUNwf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 08:52:35 -0500
In-Reply-To: <201411170958.sAH9w4GU008976@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

On 11/17/2014 10:54 AM, Sumit.Saxena@avagotech.com wrote:
> Corrected wait_event() call which was waiting for wrong completion status(0xFF).
>
> Cc: <stable@vger.kernel.org>
>
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 8262067..f11c5f3 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -1007,7 +1007,7 @@ megasas_issue_blocked_abort_cmd(struct megasas_instance *instance,
>  		cpu_to_le32(upper_32_bits(cmd_to_abort->frame_phys_addr));
>  
>  	cmd->sync_cmd = 1;
> -	cmd->cmd_status = 0xFF;
> +	cmd->cmd_status = ENODATA;
>  
>  	instance->instancet->issue_dcmd(instance, cmd);
>  

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

