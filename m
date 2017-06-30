From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/15] megaraid_sas: mismatch of allocated MFI frame size
 and length exposed in MFI MPT pass through command
Date: Fri, 30 Jun 2017 15:23:19 +0200
Message-ID: <520c90f1-c934-5c4d-6fd9-47dc3c1a7ed1@suse.de>
References: <1498811409-11157-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1498811409-11157-2-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1498811409-11157-2-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/30/2017 10:29 AM, Shivasharan S wrote:
>  Fix - Driver allocated 256 byte MFI frames bytes but while sending MFI
>  frame (embedded inside chain frame of MPT frame) to firmware, driver
>  sets the length as 4k. This results in DMA read error messages during
>  boot.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index f990ab4d..f717fbc 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -3283,7 +3283,7 @@ build_mpt_mfi_pass_thru(struct megasas_instance *instance,
>  	mpi25_ieee_chain->Flags = IEEE_SGE_FLAGS_CHAIN_ELEMENT |
>  		MPI2_IEEE_SGE_FLAGS_IOCPLBNTA_ADDR;
>  
> -	mpi25_ieee_chain->Length = cpu_to_le32(instance->max_chain_frame_sz);
> +	mpi25_ieee_chain->Length = cpu_to_le32(instance->mfi_frame_size);
>  }
>  
>  /**
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
