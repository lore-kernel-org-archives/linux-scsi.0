From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] Set elsiocb contexts to NULL after freeing it
Date: Fri, 13 Jan 2017 16:21:38 +0100
Message-ID: <20170113152138.GC3409@linux-x5ow.site>
References: <20170110110554.13770-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170110110554.13770-1-jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Dick Kennedy <dick.kennedy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

[+Cc James S. I'm sorry]

On Tue, Jan 10, 2017 at 12:05:54PM +0100, Johannes Thumshirn wrote:
> Set the elsiocb contexts to NULL after freeing as others depend on it.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/lpfc/lpfc_els.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 236e4e5..7b6bd8e 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -3590,12 +3590,14 @@ lpfc_els_free_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *elsiocb)
>  		} else {
>  			buf_ptr1 = (struct lpfc_dmabuf *) elsiocb->context2;
>  			lpfc_els_free_data(phba, buf_ptr1);
> +			elsiocb->context2 = NULL;
>  		}
>  	}
>  
>  	if (elsiocb->context3) {
>  		buf_ptr = (struct lpfc_dmabuf *) elsiocb->context3;
>  		lpfc_els_free_bpl(phba, buf_ptr);
> +		elsiocb->context3 = NULL;
>  	}
>  	lpfc_sli_release_iocbq(phba, elsiocb);
>  	return 0;

Dick, James, any comments? I'd really like to get this in soon as it solves
customer issues.

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
