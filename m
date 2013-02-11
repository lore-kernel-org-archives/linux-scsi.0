From: James Smart <James.Smart@emulex.com>
Subject: Re: [PATCH 63/77] scsi/lpfc: convert to idr_alloc()
Date: Mon, 11 Feb 2013 17:47:09 -0500
Message-ID: <511974ED.2020305@emulex.com>
References: <1360179649-22465-1-git-send-email-tj@kernel.org> <1360179649-22465-64-git-send-email-tj@kernel.org>
Reply-To: <James.Smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1360179649-22465-64-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Acked-by: James Smart <james.smart@emulex.com>

-- james s


On 2/6/2013 2:40 PM, Tejun Heo wrote:
> Convert to the much saner new idr interface.
>
> Only compile tested.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: James Smart <james.smart@emulex.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>   drivers/scsi/lpfc/lpfc_init.c | 12 ++++--------
>   1 file changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 26ca2ef..314b4f6 100644
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
