From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH 2/4] drivers/scsi/lpfc/lpfc_sli.c: convert GFP_KERNEL
 to GFP_ATOMIC
Date: Thu, 12 Jan 2012 15:00:28 -0500
Message-ID: <4F0F3BDC.10103@emulex.com>
References: <1326102050-30265-2-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1326102050-30265-2-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Julia,

We actually do not want any ATOMIC allocations if we can avoid them.  We 
reworked the calling sequence to deal with the locks being held. The change 
will be in the next patch set.

As such - Nack on the patch.

-- james s



On 1/9/2012 4:40 AM, Julia Lawall wrote:
> From: Julia Lawall<julia.lawall@lip6.fr>
>
> The function is called with locks held and thus should not use GFP_KERNEL.
>
> The semantic patch that makes this report is available
> in scripts/coccinelle/locks/call_kern.cocci.
>
> More information about semantic patching is available at
> http://coccinelle.lip6.fr/
>
> Signed-off-by: Julia Lawall<julia.lawall@lip6.fr>
>
> ---
>   drivers/scsi/lpfc/lpfc_sli.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 23a2759..622d24f 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -601,7 +601,7 @@ __lpfc_set_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
>   	if (test_and_set_bit(xritag, ndlp->active_rrqs.xri_bitmap))
>   		goto out;
>
> -	rrq = mempool_alloc(phba->rrq_pool, GFP_KERNEL);
> +	rrq = mempool_alloc(phba->rrq_pool, GFP_ATOMIC);
>   	if (rrq) {
>   		rrq->send_rrq = send_rrq;
>   		rrq->xritag = xritag;
>
>
