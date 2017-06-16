From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/11] Fix crash in lpfc_sli_ringtxcmpl_put when nvmet
 gets an abort request.
Date: Fri, 16 Jun 2017 10:02:33 +0200
Message-ID: <bca78487-f5a3-5626-87af-27da0c9ff157@suse.de>
References: <20170616055651.9674-1-jsmart2021@gmail.com>
 <20170616055651.9674-10-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56711 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752134AbdFPICg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Jun 2017 04:02:36 -0400
In-Reply-To: <20170616055651.9674-10-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 06/16/2017 07:56 AM, James Smart wrote:
> When running nvme detach-ns /dev/nvme0n1 -n 1 command,
> the nvmet lpfc driver crashes with this stack dump:
> 
> kernel BUG at /root/NVME/lpfc_8.4/lpfc_sli.c:1393!
> invalid opcode: 0000 [#1] SMP
> Workqueue: nvmet-fc-cpu0 nvmet_fc_do_work_on_cpu [nvmet_fc]
>  lpfc_sli4_issue_wqe+0x357/0x440 [lpfc]
>  lpfc_nvmet_xmt_fcp_abort+0x36b/0x5c0 [lpfc]
>  nvmet_fc_abort_op+0x30/0x50 [nvmet_fc]
>  nvmet_fc_do_work_on_cpu+0xd9/0x130 [nvmet_fc]
>  process_one_work+0x14e/0x410
>  worker_thread+0x116/0x490
>  kthread+0xc7/0xe0
>  ret_from_fork+0x3f/0x70
> 
> Crash is due to an uninitialized iocbq->vport pointer.
> 
> Explicitly set the iocbq->vport field to phba->pport in
> lpfc_nvmet_sol_fcp_issue_abort as it does all abort iocbq
> initialization in the routine.  Using phba->pport is ok because
> target does not support NPIV instances.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_nvmet.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
> index 5fb29735e236..7dc061a14f95 100644
> --- a/drivers/scsi/lpfc/lpfc_nvmet.c
> +++ b/drivers/scsi/lpfc/lpfc_nvmet.c
> @@ -2523,6 +2523,7 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
>  	abts_wqeq->iocb_cmpl = 0;
>  	abts_wqeq->iocb_flag |= LPFC_IO_NVME;
>  	abts_wqeq->context2 = ctxp;
> +	abts_wqeq->vport = phba->pport;
>  	rc = lpfc_sli4_issue_wqe(phba, LPFC_FCP_RING, abts_wqeq);
>  	spin_unlock_irqrestore(&phba->hbalock, flags);
>  	if (rc == WQE_SUCCESS) {
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
