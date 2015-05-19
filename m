From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3 17/18] megaraid_sas : fix megasas_fire_cmd_fusion
 calling convention
Date: Mon, 18 May 2015 23:22:58 -0700
Message-ID: <1432016578.4337.62.camel@HansenPartnership.com>
References: <201504231106.t3NB6PX8030941@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59876 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753405AbbESGXA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 May 2015 02:23:00 -0400
In-Reply-To: <201504231106.t3NB6PX8030941@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, kashyap.desai@avagotech.com

On Thu, 2015-04-23 at 16:34 +0530, Sumit.Saxena@avagotech.com wrote:
> The fusion HBAs don't really use the instance template like the other
> variants, as it branches off at a much higher level.  So instead of
> trying to squeeze megasas_fire_cmd_fusion into the wrong calling
> convention call it locally with argument data types that match what
> is passed.
> 
> From: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
> 
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c |   72 +++++++++++---------------
>  1 files changed, 31 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 487cd34..826ba1c 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -182,6 +182,31 @@ inline void megasas_return_cmd_fusion(struct megasas_instance *instance,
>  }
>  
>  /**
> + * megasas_fire_cmd_fusion -	Sends command to the FW
> + */
> +static void
> +megasas_fire_cmd_fusion(struct megasas_instance *instance,
> +		union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc)
> +{
> +#if defined(writeq) && defined(CONFIG_64BIT)
> +	u64 req_data = (((u64)le32_to_cpu(req_desc->u.high) << 32) |
> +			le32_to_cpu(req_desc->u.low));
> +
> +	writeq(req_data, &instance->reg_set->inbound_low_queue_port);
> +#else
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&instance->hba_lock, flags);
> +	writel(le32_to_cpu(req_desc->u.low),
> +		&instance->reg_set->inbound_low_queue_port);
> +	writel(le32_to_cpu(req_desc.u.high),
                                    ^^^
Compile the bloody code.  This should be req_desc->u.high

I fixed it but I expect you to submit better code in future.

James


