From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2 01/15] megaraid_sas: mismatch of allocated MFI frame
 size and length exposed in MFI MPT pass through command
Date: Mon, 10 Jul 2017 15:46:30 +0200
Message-ID: <08b1e18b-b6c8-8b1f-d5ee-ef8fa9234e61@redhat.com>
References: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1499256029-16319-2-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23441 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932137AbdGJNqo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Jul 2017 09:46:44 -0400
In-Reply-To: <1499256029-16319-2-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Language: en-MW
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de

On 5.7.2017 14:00, Shivasharan S wrote:
>  Fix - Driver allocated 256 byte MFI frames bytes but while sending MFI
>  frame (embedded inside chain frame of MPT frame) to firmware, driver
>  sets the length as 4k. This results in DMA read error messages during
>  boot.
>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

tomash

> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index f990ab4d..f717fbc 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -3283,7 +3283,7 @@ irqreturn_t megasas_isr_fusion(int irq, void *devp)
>  	mpi25_ieee_chain->Flags = IEEE_SGE_FLAGS_CHAIN_ELEMENT |
>  		MPI2_IEEE_SGE_FLAGS_IOCPLBNTA_ADDR;
>  
> -	mpi25_ieee_chain->Length = cpu_to_le32(instance->max_chain_frame_sz);
> +	mpi25_ieee_chain->Length = cpu_to_le32(instance->mfi_frame_size);
>  }
>  
>  /**
