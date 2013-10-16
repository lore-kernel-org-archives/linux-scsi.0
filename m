From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH] drivers: scsi: lpfc: Fix typo on NULL assignment
Date: Wed, 16 Oct 2013 14:17:05 -0400
Message-ID: <525ED821.80909@emulex.com>
References: <1381883390-4200-1-git-send-email-felipensp@gmail.com>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1381883390-4200-1-git-send-email-felipensp@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Felipe Pena <felipensp@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Acked-by: James Smart <james.smart@emulex.com>

-- james s


On 10/15/2013 8:29 PM, Felipe Pena wrote:
> In the lpfc_ct_free_iocb function after freeing associated memory to the
> ctiocb->context3, the ctiocb->context1 is set to NULL instead of context3.
>
> Signed-off-by: Felipe Pena <felipensp@gmail.com>
> ---
>   drivers/scsi/lpfc/lpfc_ct.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
> index 02e8cd9..da61d8d 100644
> --- a/drivers/scsi/lpfc/lpfc_ct.c
> +++ b/drivers/scsi/lpfc/lpfc_ct.c
> @@ -280,7 +280,7 @@ lpfc_ct_free_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *ctiocb)
>   		buf_ptr = (struct lpfc_dmabuf *) ctiocb->context3;
>   		lpfc_mbuf_free(phba, buf_ptr->virt, buf_ptr->phys);
>   		kfree(buf_ptr);
> -		ctiocb->context1 = NULL;
> +		ctiocb->context3 = NULL;
>   	}
>   	lpfc_sli_release_iocbq(phba, ctiocb);
>   	return 0;
> --
> 1.7.10.4
>
>
