From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/15] megaraid_sas: Use SMID for Task abort case only
Date: Fri, 30 Jun 2017 15:35:48 +0200
Message-ID: <f80bf93c-5969-7794-0810-ffdbd50028eb@suse.de>
References: <1498811409-11157-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1498811409-11157-9-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38028 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751695AbdF3Nfu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jun 2017 09:35:50 -0400
In-Reply-To: <1498811409-11157-9-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de

On 06/30/2017 10:30 AM, Shivasharan S wrote:
> Fix - In TM code, smid_task is valid only in case of task aborts.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index a308e14..c239762 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -3754,7 +3754,7 @@ megasas_issue_tm(struct megasas_instance *instance, u16 device_handle,
>  	struct megasas_cmd_fusion *cmd_fusion;
>  	struct megasas_cmd *cmd_mfi;
>  	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
> -	struct fusion_context *fusion;
> +	struct fusion_context *fusion = NULL;
>  	struct megasas_cmd_fusion *scsi_lookup;
>  	int rc;
>  	struct MPI2_SCSI_TASK_MANAGE_REPLY *mpi_reply;
> @@ -3781,8 +3781,6 @@ megasas_issue_tm(struct megasas_instance *instance, u16 device_handle,
>  	cmd_fusion->request_desc = req_desc;
>  	req_desc->Words = 0;
>  
> -	scsi_lookup = fusion->cmd_list[smid_task - 1];
> -
>  	mr_request = (struct MR_TASK_MANAGE_REQUEST *) cmd_fusion->io_request;
>  	memset(mr_request, 0, sizeof(struct MR_TASK_MANAGE_REQUEST));
>  	mpi_request = (struct MPI2_SCSI_TASK_MANAGE_REQUEST *) &mr_request->TmRequest;
> @@ -3829,6 +3827,8 @@ megasas_issue_tm(struct megasas_instance *instance, u16 device_handle,
>  	rc = SUCCESS;
>  	switch (type) {
>  	case MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK:
> +		scsi_lookup = fusion->cmd_list[smid_task - 1];
> +
>  		if (scsi_lookup->scmd == NULL)
>  			break;
>  		else {
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
