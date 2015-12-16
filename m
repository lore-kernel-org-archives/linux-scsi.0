From: James Smart <james.smart@avagotech.com>
Subject: Re: [PATCH v2] lpfc: replaced kmalloc + memset with kzalloc
Date: Wed, 16 Dec 2015 15:20:57 -0800
Message-ID: <5671F1D9.6050107@avagotech.com>
References: <1446015219-16131-1-git-send-email-saurabh.truth@gmail.com>
 <1447918452-15299-1-git-send-email-saurabh.truth@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447918452-15299-1-git-send-email-saurabh.truth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Saurabh Sengar <saurabh.truth@gmail.com>, dick.kennedy@avagotech.com, JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

fyi - this patch was just pushed in our 11.0.0.10 patch set - patch 16/17

Note: Patch 16 contains the exact same patch submitted by Punit Vara. I 
posted Punit's change only as it arrived earlier.

-- james s



On 11/18/2015 11:34 PM, Saurabh Sengar wrote:
> replacing kmalloc and memset by a single call of kzalloc
>
> Signed-off-by: Saurabh Sengar <saurabh.truth@gmail.com>
> ---
> v2 : I didn't got any response for my initial patch,
> I am sending it again on top of latest kernel(today's)
>
>   drivers/scsi/lpfc/lpfc_els.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index b6fa257..92dd204 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -4956,13 +4956,12 @@ lpfc_els_rcv_rdp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
>   	if (RDP_NPORT_ID_SIZE !=
>   			be32_to_cpu(rdp_req->nport_id_desc.length))
>   		goto rjt_logerr;
> -	rdp_context = kmalloc(sizeof(struct lpfc_rdp_context), GFP_KERNEL);
> +	rdp_context = kzalloc(sizeof(struct lpfc_rdp_context), GFP_KERNEL);
>   	if (!rdp_context) {
>   		rjt_err = LSRJT_UNABLE_TPC;
>   		goto error;
>   	}
>   
> -	memset(rdp_context, 0, sizeof(struct lpfc_rdp_context));
>   	cmd = &cmdiocb->iocb;
>   	rdp_context->ndlp = lpfc_nlp_get(ndlp);
>   	rdp_context->ox_id = cmd->unsli3.rcvsli3.ox_id;
