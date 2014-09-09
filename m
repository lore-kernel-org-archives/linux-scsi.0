From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 02/11] megaraid_sas : Use writeq for 64bit pci write to
 avoid spinlock overhead
Date: Tue, 09 Sep 2014 15:30:46 +0200
Message-ID: <540F0106.6090702@redhat.com>
References: <201409061328.s86DS4h1012830@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756722AbaIINbZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Sep 2014 09:31:25 -0400
In-Reply-To: <201409061328.s86DS4h1012830@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, aradford@gmail.com

On 09/06/2014 03:25 PM, Sumit.Saxena@avagotech.com wrote:
> Use writeq() for 64bit PCI write instead of writel() to avoid additional lock overhead.
>
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 57b47fe..c69c1ac 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -1065,6 +1065,13 @@ megasas_fire_cmd_fusion(struct megasas_instance *instance,
>  			u32 req_desc_hi,
>  			struct megasas_register_set __iomem *regs)

Hi Sumit,
the fn params are a bit confusing req_desc_lo is of type dma_addr_t
and req_desc_hi is u32, is it possible to unite it in the future?

>  {
> +#if defined(writeq) && defined(CONFIG_64BIT)

On a similar place mpt2sas(_base_writeq) uses only "#ifndef writeq"
if it's incorrect fix it there too or remove the CONFIG_64 here

> +	u64 req_data = 0;
> +
> +	req_data = req_desc_hi;
> +	req_data = ((req_data << 32) | (u32)req_desc_lo);

This seems to be critical path (you are removing an spinlock to avoid overhead),
so why do you have three consecutive assignments to the same variable?
(~(u64 req_data = r_hi << 32 | r_lo))

Cheers,
Tomas

> +	writeq(le64_to_cpu(req_data), &(regs)->inbound_low_queue_port);
> +#else
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&instance->hba_lock, flags);
> @@ -1072,6 +1079,7 @@ megasas_fire_cmd_fusion(struct megasas_instance *instance,
>  	writel(le32_to_cpu(req_desc_lo), &(regs)->inbound_low_queue_port);
>  	writel(le32_to_cpu(req_desc_hi), &(regs)->inbound_high_queue_port);
>  	spin_unlock_irqrestore(&instance->hba_lock, flags);
> +#endif
>  }
>  
>  /**

