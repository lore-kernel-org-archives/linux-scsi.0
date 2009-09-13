From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 3/5] scsi: Fix protection scsi_data_buffer leak
Date: Sun, 13 Sep 2009 12:36:10 +0300
Message-ID: <4AACBD0A.90703@panasas.com>
References: <1252696852-17091-1-git-send-email-martin.petersen@oracle.com> <1252696852-17091-4-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dip-colo-pa.panasas.com ([67.152.220.67]:14846 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751122AbZIMJgg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Sep 2009 05:36:36 -0400
In-Reply-To: <1252696852-17091-4-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

On 09/11/2009 10:20 PM, Martin K. Petersen wrote:
> We would leak a scsi_data_buffer if the free_list command was of the
> protected variety.
> 
> Reported-by: Boaz Harrosh <bharrosh@panasas.com>

Reviewed-by: Boaz Harrosh <bharrosh@panasas.com>

I like the locality of the temp variables, thanks.
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/scsi/scsi.c |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 2de5f3a..69397bb 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -241,10 +241,7 @@ scsi_host_alloc_command(struct Scsi_Host *shost, gfp_t gfp_mask)
>   */
>  struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
>  {
> -	struct scsi_cmnd *cmd;
> -	unsigned char *buf;
> -
> -	cmd = scsi_host_alloc_command(shost, gfp_mask);
> +	struct scsi_cmnd *cmd = scsi_host_alloc_command(shost, gfp_mask);
>  
>  	if (unlikely(!cmd)) {
>  		unsigned long flags;
> @@ -258,9 +255,15 @@ struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
>  		spin_unlock_irqrestore(&shost->free_list_lock, flags);
>  
>  		if (cmd) {
> +			void *buf, *prot;
> +
>  			buf = cmd->sense_buffer;
> +			prot = cmd->prot_sdb;
> +
>  			memset(cmd, 0, sizeof(*cmd));
> +
>  			cmd->sense_buffer = buf;
> +			cmd->prot_sdb = prot;
>  		}
>  	}
>  

