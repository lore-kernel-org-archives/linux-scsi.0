From: James Smart <James.Smart@emulex.com>
Subject: Re: [PATCH 47/62] scsi/lpfc: convert to idr_alloc()
Date: Mon, 11 Feb 2013 17:46:56 -0500
Message-ID: <511974E0.4040703@emulex.com>
References: <1359854463-2538-1-git-send-email-tj@kernel.org> <1359854463-2538-48-git-send-email-tj@kernel.org>
Reply-To: <James.Smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1359854463-2538-48-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Acked-by: James Smart <james.smart@emulex.com>

-- james s


On 2/2/2013 8:20 PM, Tejun Heo wrote:
> Convert to the much saner new idr interface.
>
> Only compile tested.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: James Smart <james.smart@emulex.com>
> Cc: linux-scsi@vger.kernel.org
> ---
> This patch depends on an earlier idr changes and I think it would be
> best to route these together through -mm.  Please holler if there's
> any objection.  Thanks.
>
>   drivers/scsi/lpfc/lpfc_init.c | 12 ++++--------
>   1 file changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 89ad558..7de4ef14 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -3165,14 +3165,10 @@ destroy_port(struct lpfc_vport *vport)
>   int
>   lpfc_get_instance(void)
>   {
> -	int instance = 0;
> -
> -	/* Assign an unused number */
> -	if (!idr_pre_get(&lpfc_hba_index, GFP_KERNEL))
> -		return -1;
> -	if (idr_get_new(&lpfc_hba_index, NULL, &instance))
> -		return -1;
> -	return instance;
> +	int ret;
> +
> +	ret = idr_alloc(&lpfc_hba_index, NULL, 0, 0, GFP_KERNEL);
> +	return ret < 0 ? -1 : ret;
>   }
>   
>   /**
