From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2 08/15] megaraid_sas: Use SMID for Task abort case only
Date: Tue, 18 Jul 2017 13:51:51 +0200
Message-ID: <abd41eed-c2eb-5e91-03ea-c7c780fc9cb9@redhat.com>
References: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1499256029-16319-9-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46078 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751374AbdGRLvz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Jul 2017 07:51:55 -0400
In-Reply-To: <1499256029-16319-9-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Language: en-MW
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de

On 5.7.2017 14:00, Shivasharan S wrote:
> Fix - In TM code, smid_task is valid only in case of task aborts.
>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index a308e14..c239762 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -3754,7 +3754,7 @@ static int megasas_track_scsiio(struct megasas_instance *instance,
>  	struct megasas_cmd_fusion *cmd_fusion;
>  	struct megasas_cmd *cmd_mfi;
>  	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
> -	struct fusion_context *fusion;
> +	struct fusion_context *fusion = NULL;

This^ change seems to be needless,
but not important.

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

tomash


>  	struct megasas_cmd_fusion *scsi_lookup;
>  	int rc;
>  	struct MPI2_SCSI_TASK_MANAGE_REPLY *mpi_reply;
> @@ -3781,8 +3781,6 @@ static int megasas_track_scsiio(struct megasas_instance *instance,
>  	cmd_fusion->request_desc = req_desc;
>  	req_desc->Words = 0;
>  
> -	scsi_lookup = fusion->cmd_list[smid_task - 1];
> -
>  	mr_request = (struct MR_TASK_MANAGE_REQUEST *) cmd_fusion->io_request;
>  	memset(mr_request, 0, sizeof(struct MR_TASK_MANAGE_REQUEST));
>  	mpi_request = (struct MPI2_SCSI_TASK_MANAGE_REQUEST *) &mr_request->TmRequest;
> @@ -3829,6 +3827,8 @@ static int megasas_track_scsiio(struct megasas_instance *instance,
>  	rc = SUCCESS;
>  	switch (type) {
>  	case MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK:
> +		scsi_lookup = fusion->cmd_list[smid_task - 1];
> +
>  		if (scsi_lookup->scmd == NULL)
>  			break;
>  		else {
