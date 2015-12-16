From: James Smart <james.smart@avagotech.com>
Subject: Re: [PATCH] SCSI-lpfc: Delete unnecessary checks before the function
 call "mempool_destroy"
Date: Wed, 16 Dec 2015 15:17:23 -0800
Message-ID: <5671F103.8070404@avagotech.com>
References: <5307CAA2.8060406@users.sourceforge.net>
 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
 <530A086E.8010901@users.sourceforge.net>
 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
 <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net>
 <alpine.DEB.2.10.1402241710370.2074@hadrien>
 <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <564AE8EB.4050509@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <564AE8EB.4050509@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E. J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

fyi - this patch was just pushed in our 11.0.0.10 patch set - patch 15/17

-- james s


On 11/17/2015 12:44 AM, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 17 Nov 2015 09:34:27 +0100
>
> The mempool_destroy() function tests whether its argument is NULL
> and then returns immediately. Thus the test around the calls is not needed.
>
> This issue was detected by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>   drivers/scsi/lpfc/lpfc_mem.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
> index 3fa6533..4fb3581 100644
> --- a/drivers/scsi/lpfc/lpfc_mem.c
> +++ b/drivers/scsi/lpfc/lpfc_mem.c
> @@ -231,15 +231,13 @@ lpfc_mem_free(struct lpfc_hba *phba)
>   	if (phba->lpfc_hbq_pool)
>   		pci_pool_destroy(phba->lpfc_hbq_pool);
>   	phba->lpfc_hbq_pool = NULL;
> -
> -	if (phba->rrq_pool)
> -		mempool_destroy(phba->rrq_pool);
> +	mempool_destroy(phba->rrq_pool);
>   	phba->rrq_pool = NULL;
>   
>   	/* Free NLP memory pool */
>   	mempool_destroy(phba->nlp_mem_pool);
>   	phba->nlp_mem_pool = NULL;
> -	if (phba->sli_rev == LPFC_SLI_REV4 && phba->active_rrq_pool) {
> +	if (phba->sli_rev == LPFC_SLI_REV4) {
>   		mempool_destroy(phba->active_rrq_pool);
>   		phba->active_rrq_pool = NULL;
>   	}

