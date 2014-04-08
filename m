From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scsi: lpfc: lpfc_init: use kcalloc for allocating memory
Date: Tue, 08 Apr 2014 12:48:22 -0700
Message-ID: <1396986502.5212.68.camel@joe-AO722>
References: <1396986291-28530-1-git-send-email-eu@opreamatei.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1396986291-28530-1-git-send-email-eu@opreamatei.ro>
Sender: linux-kernel-owner@vger.kernel.org
To: Matei Oprea <eu@opreamatei.ro>
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ROSEdu Kernel Community <firefly@lists.rosedu.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2014-04-08 at 22:44 +0300, Matei Oprea wrote:
> It's easier to use kcalloc for allocating arrays. While at it
> also remove useless casting value.
> 
> Signed-off-by: Matei Oprea <eu@opreamatei.ro>
> Cc: ROSEdu Kernel Community <firefly@lists.rosedu.org>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 635eeb3..e286909 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -4742,12 +4742,12 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
>  			phba->cfg_sg_seg_cnt = LPFC_DEFAULT_MENLO_SG_SEG_CNT;
>  	}
>  
> -	if (!phba->sli.ring)
> -		phba->sli.ring = (struct lpfc_sli_ring *)
> -			kzalloc(LPFC_SLI3_MAX_RING *
> -			sizeof(struct lpfc_sli_ring), GFP_KERNEL);
> -	if (!phba->sli.ring)
> +	if (!phba->sli.ring) {
> +		phba->sli.ring = kcalloc(LPFC_SLI3_MAX_RING,
> +				sizeof(struct lpfc_sli_ring),
> +				GFP_KERNEL);
>  		return -ENOMEM;
> +	}

You seem to be returning -ENOMEM after kcalloc.

You need to put back the

	if (!phba->sli.ring)
		return -ENOMEM;

after the alloc.
