From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH-v0 2/2] Fix memory corruption of the lpfc_ncmd->list
 pointers
Date: Fri, 21 Apr 2017 16:54:09 -0700
Message-ID: <65dd7de1-d191-d10d-e78d-935494d2b896@broadcom.com>
References: <1492800146-24218-1-git-send-email-dick.kennedy@broadcom.com>
 <1492800146-24218-3-git-send-email-dick.kennedy@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1492800146-24218-3-git-send-email-dick.kennedy@broadcom.com>
Sender: linux-block-owner@vger.kernel.org
To: Dick Kennedy <dick.kennedy@broadcom.com>, linux-block@vger.kernel.org, linux-scsi@vreg.kernel.org
Cc: martin.petersen@orcale.com, jthumshirn@suse.de, emilne@redhat.com
List-Id: linux-scsi@vger.kernel.org

Please disregard - I am recutting, breaking it from the series, 
reposting as an individual patch.

-- james


On 4/21/2017 11:42 AM, Dick Kennedy wrote:
> When starting the nvme Initiator and nvmet Target cli apps,
> the nvmeI would cause an Oops in the nvme buffer list_head.
>
> The nvmeI was using the private data area of the template and
> setting it to 0 size.  This caused a use conflict with the
> nvme transport also using the memory area and causing the
> memory corruption.
>
> NVMEI driver now claims a size for fcpreq that is provided in
> the template and zero's out the area when done.  This
> change has fixed the memory corruption.  I also altered some
> list_del's to list_del_init because the lpfc_ncmd's are
> migrating between the abts and put lists.
> There are some new debug log statements added to help
> debug.
>
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>   drivers/scsi/lpfc/lpfc_nvme.c | 17 +++++++++++------
>   drivers/scsi/lpfc/lpfc_nvme.h |  4 ++++
>   2 files changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
> index f98cbc2..8008c82 100644
> --- a/drivers/scsi/lpfc/lpfc_nvme.c
> +++ b/drivers/scsi/lpfc/lpfc_nvme.c
> @@ -761,6 +761,7 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
>   	struct nvme_fc_cmd_iu *cp;
>   	struct lpfc_nvme_rport *rport;
>   	struct lpfc_nodelist *ndlp;
> +	struct lpfc_nvme_fcpreq_priv *freqpriv;
>   	unsigned long flags;
>   	uint32_t code;
>   	uint16_t cid, sqhd, data;
> @@ -918,6 +919,8 @@ out_err:
>   			phba->cpucheck_cmpl_io[lpfc_ncmd->cpu]++;
>   	}
>   #endif
> +	freqpriv = nCmd->private;
> +	freqpriv->nvme_buf = NULL;
>   	nCmd->done(nCmd);
>   
>   	spin_lock_irqsave(&phba->hbalock, flags);
> @@ -1214,6 +1217,7 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
>   	struct lpfc_nvme_buf *lpfc_ncmd;
>   	struct lpfc_nvme_rport *rport;
>   	struct lpfc_nvme_qhandle *lpfc_queue_info;
> +	struct lpfc_nvme_fcpreq_priv *freqpriv = pnvme_fcreq->private;
>   #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
>   	uint64_t start = 0;
>   #endif
> @@ -1292,7 +1296,7 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
>   	 * Do not let the IO hang out forever.  There is no midlayer issuing
>   	 * an abort so inform the FW of the maximum IO pending time.
>   	 */
> -	pnvme_fcreq->private = (void *)lpfc_ncmd;
> +	freqpriv->nvme_buf = lpfc_ncmd;
>   	lpfc_ncmd->nvmeCmd = pnvme_fcreq;
>   	lpfc_ncmd->nrport = rport;
>   	lpfc_ncmd->ndlp = ndlp;
> @@ -1422,6 +1426,7 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
>   	struct lpfc_nvme_buf *lpfc_nbuf;
>   	struct lpfc_iocbq *abts_buf;
>   	struct lpfc_iocbq *nvmereq_wqe;
> +	struct lpfc_nvme_fcpreq_priv *freqpriv = pnvme_fcreq->private;
>   	union lpfc_wqe *abts_wqe;
>   	unsigned long flags;
>   	int ret_val;
> @@ -1484,7 +1489,7 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
>   		return;
>   	}
>   
> -	lpfc_nbuf = (struct lpfc_nvme_buf *)pnvme_fcreq->private;
> +	lpfc_nbuf = freqpriv->nvme_buf;
>   	if (!lpfc_nbuf) {
>   		spin_unlock_irqrestore(&phba->hbalock, flags);
>   		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_ABTS,
> @@ -1637,7 +1642,7 @@ static struct nvme_fc_port_template lpfc_nvme_template = {
>   	.local_priv_sz = sizeof(struct lpfc_nvme_lport),
>   	.remote_priv_sz = sizeof(struct lpfc_nvme_rport),
>   	.lsrqst_priv_sz = 0,
> -	.fcprqst_priv_sz = 0,
> +	.fcprqst_priv_sz = sizeof(struct lpfc_nvme_fcpreq_priv),
>   };
>   
>   /**
> @@ -2068,7 +2073,7 @@ lpfc_get_nvme_buf(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
>   		if (lpfc_test_rrq_active(phba, ndlp,
>   					 lpfc_ncmd->cur_iocbq.sli4_lxritag))
>   			continue;
> -		list_del(&lpfc_ncmd->list);
> +		list_del_init(&lpfc_ncmd->list);
>   		found = 1;
>   		break;
>   	}
> @@ -2083,7 +2088,7 @@ lpfc_get_nvme_buf(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
>   			if (lpfc_test_rrq_active(
>   				phba, ndlp, lpfc_ncmd->cur_iocbq.sli4_lxritag))
>   				continue;
> -			list_del(&lpfc_ncmd->list);
> +			list_del_init(&lpfc_ncmd->list);
>   			found = 1;
>   			break;
>   		}
> @@ -2542,7 +2547,7 @@ lpfc_sli4_nvme_xri_aborted(struct lpfc_hba *phba,
>   				 &phba->sli4_hba.lpfc_abts_nvme_buf_list,
>   				 list) {
>   		if (lpfc_ncmd->cur_iocbq.sli4_xritag == xri) {
> -			list_del(&lpfc_ncmd->list);
> +			list_del_init(&lpfc_ncmd->list);
>   			lpfc_ncmd->flags &= ~LPFC_SBUF_XBUSY;
>   			lpfc_ncmd->status = IOSTAT_SUCCESS;
>   			spin_unlock(
> diff --git a/drivers/scsi/lpfc/lpfc_nvme.h b/drivers/scsi/lpfc/lpfc_nvme.h
> index 2582f46..ec32f45 100644
> --- a/drivers/scsi/lpfc/lpfc_nvme.h
> +++ b/drivers/scsi/lpfc/lpfc_nvme.h
> @@ -97,3 +97,7 @@ struct lpfc_nvme_buf {
>   	uint64_t ts_data_nvme;
>   #endif
>   };
> +
> +struct lpfc_nvme_fcpreq_priv {
> +	struct lpfc_nvme_buf *nvme_buf;
> +};
