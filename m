From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 5/5] megaraid_sas: add mmio barrier after register writes
Date: Fri, 18 Nov 2016 16:53:06 +0100
Message-ID: <5f6fcc3e-a48f-7909-c409-1d265ea9135c@redhat.com>
References: <1478857492-4581-1-git-send-email-hare@suse.de>
 <1478857492-4581-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53052 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751613AbcKRPxJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Nov 2016 10:53:09 -0500
In-Reply-To: <1478857492-4581-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 11.11.2016 10:44, Hannes Reinecke wrote:
> The megaraid_sas HBA only has a single register for I/O submission,
> which will be hit pretty hard with scsi-mq. To ensure that the
> PCI writes have made it across we need to add a mmio barrier
> after each write; otherwise I've been seeing spurious command
> completions and I/O stalls.

Why is it needed that the PCI write reaches the hw exactly at this point?
Is it possible that this is a hw deficiency like that the hw can't handle
communication without tiny pauses, and so possible to remove
in next generation?
Thanks,
Tomas

>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index aba53c0..729a654 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -196,6 +196,7 @@ inline void megasas_return_cmd_fusion(struct megasas_instance *instance,
>  			le32_to_cpu(req_desc->u.low));
>  
>  	writeq(req_data, &instance->reg_set->inbound_low_queue_port);
> +	mmiowb();
>  #else
>  	unsigned long flags;
>  


