From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 4/5] lpfc: convert lpfc to use target reset handler.
Date: Mon, 21 Apr 2008 16:43:12 -0400
Message-ID: <480CFC60.5070700@emulex.com>
References: <1204331123-3833-1-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-2-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-3-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-4-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-5-git-send-email-michaelc@cs.wisc.edu>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:32894 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbYDUUoP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Apr 2008 16:44:15 -0400
In-Reply-To: <1204331123-3833-5-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, andrew.vasquez@qlogic.com, christof.schmitt@de.ibm.com, mp3@de.ibm.com, rmk@arm.linux.org.uk, matthew@wil.cx

fyi: this patch has been superceeded by :
http://marc.info/?l=linux-scsi&m=120880973719266&w=2

-- james s

michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> lpfc is sending a target reset from the device reset handler,
> so this patch just has it use the target reset handler.
> 
> This patch also has the driver use CTX_TGT instead of CTX_LUN
> in the target reset handler. It looked like a bug.
> 
> One thing I was not sure of was if lpfc_scsi_tgt_reset fails, but
> the caller ends up calling lpfc_sli_abort_iocb and that aborts all
> the commands for the context that is requested and those are all
> cleaned up by the driver/firmware, should we return SUCCESS.
> 
> This patch should wait for James Smart. I think he is on vacation,
> but the driver will work without the patch like it did before, so
> it is not required that this patch be merged with the rest.
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/lpfc/lpfc_scsi.c |   85 ++++++++++++++---------------------------
>  1 files changed, 29 insertions(+), 56 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index 70255c1..e881ffb 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -835,13 +835,15 @@ lpfc_tskmgmt_def_cmpl(struct lpfc_hba *phba,
>  static int
>  lpfc_scsi_tgt_reset(struct lpfc_scsi_buf *lpfc_cmd, struct lpfc_vport *vport,
>  		    unsigned  tgt_id, unsigned int lun,
> -		    struct lpfc_rport_data *rdata)
> +		    struct lpfc_rport_data *rdata, int *iocb_status)
>  {
>  	struct lpfc_hba   *phba = vport->phba;
>  	struct lpfc_iocbq *iocbq;
>  	struct lpfc_iocbq *iocbqrsp;
>  	int ret;
>  
> +	*iocb_status = 0;
> +
>  	if (!rdata->pnode)
>  		return FAILED;
>  
> @@ -861,13 +863,14 @@ lpfc_scsi_tgt_reset(struct lpfc_scsi_buf *lpfc_cmd, struct lpfc_vport *vport,
>  	lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
>  			 "0702 Issue Target Reset to TGT %d Data: x%x x%x\n",
>  			 tgt_id, rdata->pnode->nlp_rpi, rdata->pnode->nlp_flag);
> -	ret = lpfc_sli_issue_iocb_wait(phba,
> +	*iocb_status = lpfc_sli_issue_iocb_wait(phba,
>  				       &phba->sli.ring[phba->sli.fcp_ring],
>  				       iocbq, iocbqrsp, lpfc_cmd->timeout);
> -	if (ret != IOCB_SUCCESS) {
> -		if (ret == IOCB_TIMEDOUT)
> +	if (*iocb_status != IOCB_SUCCESS) {
> +		if (*iocb_status == IOCB_TIMEDOUT)
>  			iocbq->iocb_cmpl = lpfc_tskmgmt_def_cmpl;
>  		lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
> +		ret = FAILED;
>  	} else {
>  		ret = SUCCESS;
>  		lpfc_cmd->result = iocbqrsp->iocb.un.ulpWord[4];
> @@ -1125,16 +1128,14 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
>  }
>  
>  static int
> -lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
> +lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
>  {
>  	struct Scsi_Host  *shost = cmnd->device->host;
>  	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
>  	struct lpfc_hba   *phba = vport->phba;
>  	struct lpfc_scsi_buf *lpfc_cmd;
> -	struct lpfc_iocbq *iocbq, *iocbqrsp;
>  	struct lpfc_rport_data *rdata = cmnd->device->hostdata;
>  	struct lpfc_nodelist *pnode = rdata->pnode;
> -	uint32_t cmd_result = 0, cmd_status = 0;
>  	int ret = FAILED;
>  	int iocb_status = IOCB_SUCCESS;
>  	int cnt, loopcnt;
> @@ -1156,7 +1157,7 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
>  			if (!rdata ||
>  				(loopcnt > ((vport->cfg_devloss_tmo * 2) + 1))){
>  				lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
> -						 "0721 LUN Reset rport "
> +						 "0721 Target Reset rport "
>  						 "failure: cnt x%x rdata x%p\n",
>  						 loopcnt, rdata);
>  				goto out;
> @@ -1174,52 +1175,20 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
>  		goto out;
>  
>  	lpfc_cmd->timeout = 60;
> -	lpfc_cmd->rdata = rdata;
> -
> -	ret = lpfc_scsi_prep_task_mgmt_cmd(vport, lpfc_cmd, cmnd->device->lun,
> -					   FCP_TARGET_RESET);
> -	if (!ret)
> -		goto out_free_scsi_buf;
> -
> -	iocbq = &lpfc_cmd->cur_iocbq;
> -
> -	/* get a buffer for this IOCB command response */
> -	iocbqrsp = lpfc_sli_get_iocbq(phba);
> -	if (iocbqrsp == NULL)
> -		goto out_free_scsi_buf;
> -
> -	lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
> -			 "0703 Issue target reset to TGT %d LUN %d "
> -			 "rpi x%x nlp_flag x%x\n", cmnd->device->id,
> -			 cmnd->device->lun, pnode->nlp_rpi, pnode->nlp_flag);
> -	iocb_status = lpfc_sli_issue_iocb_wait(phba,
> -				       &phba->sli.ring[phba->sli.fcp_ring],
> -				       iocbq, iocbqrsp, lpfc_cmd->timeout);
> -
> -	if (iocb_status == IOCB_TIMEDOUT)
> -		iocbq->iocb_cmpl = lpfc_tskmgmt_def_cmpl;
> -
> -	if (iocb_status == IOCB_SUCCESS)
> -		ret = SUCCESS;
> -	else
> -		ret = iocb_status;
> -
> -	cmd_result = iocbqrsp->iocb.un.ulpWord[4];
> -	cmd_status = iocbqrsp->iocb.ulpStatus;
> -
> -	lpfc_sli_release_iocbq(phba, iocbqrsp);
>  
> +	ret = lpfc_scsi_tgt_reset(lpfc_cmd, vport, cmnd->device->id,
> +				  cmnd->device->lun, rdata, &iocb_status);
>  	/*
>  	 * All outstanding txcmplq I/Os should have been aborted by the device.
>  	 * Unfortunately, some targets do not abide by this forcing the driver
>  	 * to double check.
>  	 */
>  	cnt = lpfc_sli_sum_iocb(vport, cmnd->device->id, cmnd->device->lun,
> -				LPFC_CTX_LUN);
> +				LPFC_CTX_TGT);
>  	if (cnt)
>  		lpfc_sli_abort_iocb(vport, &phba->sli.ring[phba->sli.fcp_ring],
>  				    cmnd->device->id, cmnd->device->lun,
> -				    LPFC_CTX_LUN);
> +				    LPFC_CTX_TGT);
>  	loopcnt = 0;
>  	while(cnt) {
>  		schedule_timeout_uninterruptible(LPFC_RESET_WAIT*HZ);
> @@ -1229,25 +1198,29 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
>  			break;
>  
>  		cnt = lpfc_sli_sum_iocb(vport, cmnd->device->id,
> -					cmnd->device->lun, LPFC_CTX_LUN);
> +					cmnd->device->lun, LPFC_CTX_TGT);
>  	}
>  
> +	/*
> +	 * if lpfc_scsi_tgt_reset returned FAILED but lpfc_sli_abort_iocb
> +	 * got run above and that aborted all the commands and cnt=0, should
> +	 * we return SUCCESS because at least the commands were unstuck?
> +	 */
>  	if (cnt) {
>  		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
> -				 "0719 device reset I/O flush failure: "
> +				 "0719 target reset I/O flush failure: "
>  				 "cnt x%x\n", cnt);
>  		ret = FAILED;
>  	}
>  
> -out_free_scsi_buf:
>  	if (iocb_status != IOCB_TIMEDOUT) {
>  		lpfc_release_scsi_buf(phba, lpfc_cmd);
>  	}
>  	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
> -			 "0713 SCSI layer issued device reset (%d, %d) "
> +			 "0713 SCSI layer issued target reset (%d) "
>  			 "return x%x status x%x result x%x\n",
> -			 cmnd->device->id, cmnd->device->lun, ret,
> -			 cmd_status, cmd_result);
> +			 cmnd->device->id, ret,
> +			 lpfc_cmd->status, lpfc_cmd->result);
>  out:
>  	return ret;
>  }
> @@ -1263,6 +1236,7 @@ lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
>  	int ret = FAILED, i, err_count = 0;
>  	int cnt, loopcnt;
>  	struct lpfc_scsi_buf * lpfc_cmd;
> +	int iocb_status = IOCB_SUCCESS;
>  
>  	lpfc_block_error_handler(cmnd);
>  
> @@ -1296,9 +1270,8 @@ lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
>  		if (!match)
>  			continue;
>  
> -		ret = lpfc_scsi_tgt_reset(lpfc_cmd, vport, i,
> -					  cmnd->device->lun,
> -					  ndlp->rport->dd_data);
> +		ret = lpfc_scsi_tgt_reset(lpfc_cmd, vport, i, cmnd->device->lun,
> +					  ndlp->rport->dd_data, &iocb_status);
>  		if (ret != SUCCESS) {
>  			lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
>  					 "0700 Bus Reset on target %d failed\n",
> @@ -1308,7 +1281,7 @@ lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
>  		}
>  	}
>  
> -	if (ret != IOCB_TIMEDOUT)
> +	if (iocb_status != IOCB_TIMEDOUT)
>  		lpfc_release_scsi_buf(phba, lpfc_cmd);
>  
>  	if (err_count == 0)
> @@ -1453,7 +1426,7 @@ struct scsi_host_template lpfc_template = {
>  	.info			= lpfc_info,
>  	.queuecommand		= lpfc_queuecommand,
>  	.eh_abort_handler	= lpfc_abort_handler,
> -	.eh_device_reset_handler= lpfc_device_reset_handler,
> +	.eh_target_reset_handler= lpfc_target_reset_handler,
>  	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
>  	.slave_alloc		= lpfc_slave_alloc,
>  	.slave_configure	= lpfc_slave_configure,
> @@ -1473,7 +1446,7 @@ struct scsi_host_template lpfc_vport_template = {
>  	.info			= lpfc_info,
>  	.queuecommand		= lpfc_queuecommand,
>  	.eh_abort_handler	= lpfc_abort_handler,
> -	.eh_device_reset_handler= lpfc_device_reset_handler,
> +	.eh_target_reset_handler= lpfc_target_reset_handler,
>  	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
>  	.slave_alloc		= lpfc_slave_alloc,
>  	.slave_configure	= lpfc_slave_configure,

