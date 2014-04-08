From: Boaz Harrosh <openosd@gmail.com>
Subject: Re: [PATCH] scsi: lpfc: lpfc_init: use kcalloc for allocating memory
Date: Tue, 08 Apr 2014 09:36:02 +0300
Message-ID: <534398D2.6010008@gmail.com>
References: <1395175900-9659-1-git-send-email-eu@opreamatei.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1395175900-9659-1-git-send-email-eu@opreamatei.ro>
Sender: linux-kernel-owner@vger.kernel.org
To: Matei Oprea <eu@opreamatei.ro>, jbottomley@parallels.com
Cc: james.smart@emulex.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ROSEdu Kernel Community <firefly@lists.rosedu.org>
List-Id: linux-scsi@vger.kernel.org

On 03/18/2014 10:51 PM, Matei Oprea wrote:
> It's easier to use kcalloc for allocating arrays. While at it
> also remove useless casting value.
> 
> Signed-off-by: Matei Oprea <eu@opreamatei.ro>
> Cc: ROSEdu Kernel Community <firefly@lists.rosedu.org>
> ---
>  drivers/scsi/lpfc/lpfc_init.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 68c94cc..0a51ca5 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -4731,9 +4731,9 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
>  	}
>  
>  	if (!phba->sli.ring)
> -		phba->sli.ring = (struct lpfc_sli_ring *)
> -			kzalloc(LPFC_SLI3_MAX_RING *
> +		phba->sli.ring = kcalloc(LPFC_SLI3_MAX_RING,
>  			sizeof(struct lpfc_sli_ring), GFP_KERNEL);
> +

Just a nit please put this recheck inside the if(){} so in the hot path
when phba->sli.ring is already allocated it will not test twice.

>  	if (!phba->sli.ring)

and unlikely() on this if

>  		return -ENOMEM;
>  
> 

thanks
Boaz
