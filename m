From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 02/14] lpfc: Fix sg_reset on SCSI device causing kernel
 crash
Date: Fri, 12 Aug 2016 10:28:08 +0200
Message-ID: <20160812082808.ac66s2kp5ee2hh5y@c203.arch.suse.de>
References: <57acc585.HP3iyAK6go/SCR18%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60336 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbcHLI2L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2016 04:28:11 -0400
Content-Disposition: inline
In-Reply-To: <57acc585.HP3iyAK6go/SCR18%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Aug 11, 2016 at 11:35:49AM -0700, James Smart wrote:
> 
> Fix sg_reset on SCSI device causing kernel crash
> 
> Driver could reference stale node pointers in task mgmt call.
> Changed to use resetting cmd and look up node pointer in task mgmt
> function.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_scsi.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index d197aa1..c100477 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -4945,18 +4945,21 @@ lpfc_check_fcp_rsp(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd)
>   *   0x2002 - Success.
>   **/
>  static int
> -lpfc_send_taskmgmt(struct lpfc_vport *vport, struct lpfc_rport_data *rdata,
> -		    unsigned  tgt_id, uint64_t lun_id,
> -		    uint8_t task_mgmt_cmd)
> +lpfc_send_taskmgmt(struct lpfc_vport *vport, struct scsi_cmnd *cmnd,
> +		   unsigned int tgt_id, uint64_t lun_id,
> +		   uint8_t task_mgmt_cmd)
>  {
>  	struct lpfc_hba   *phba = vport->phba;
>  	struct lpfc_scsi_buf *lpfc_cmd;
>  	struct lpfc_iocbq *iocbq;
>  	struct lpfc_iocbq *iocbqrsp;
> -	struct lpfc_nodelist *pnode = rdata->pnode;
> +	struct lpfc_rport_data *rdata;
> +	struct lpfc_nodelist *pnode;
>  	int ret;
>  	int status;
>  
> +	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);

	if (!rdata  || !rdata->pnode)
		return FAILED;

As you do it in lpfc_chk_tgt_mapped() and lpfc_device_reset_handler()?


> +	pnode = rdata->pnode;
>  	if (!pnode || !NLP_CHK_NODE_ACT(pnode))
>  		return FAILED;
>  
> @@ -4965,6 +4968,7 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct lpfc_rport_data *rdata,
>  		return FAILED;
>  	lpfc_cmd->timeout = phba->cfg_task_mgmt_tmo;
>  	lpfc_cmd->rdata = rdata;
> +	lpfc_cmd->pCmd = cmnd;
>  
>  	status = lpfc_scsi_prep_task_mgmt_cmd(vport, lpfc_cmd, lun_id,
>  					   task_mgmt_cmd);
> @@ -5171,7 +5175,7 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
>  	fc_host_post_vendor_event(shost, fc_get_event_number(),
>  		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);
>  
> -	status = lpfc_send_taskmgmt(vport, rdata, tgt_id, lun_id,
> +	status = lpfc_send_taskmgmt(vport, cmnd, tgt_id, lun_id,
>  						FCP_LUN_RESET);
>  
>  	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
> @@ -5249,7 +5253,7 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
>  	fc_host_post_vendor_event(shost, fc_get_event_number(),
>  		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);
>  
> -	status = lpfc_send_taskmgmt(vport, rdata, tgt_id, lun_id,
> +	status = lpfc_send_taskmgmt(vport, cmnd, tgt_id, lun_id,
>  					FCP_TARGET_RESET);
>  
>  	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
> @@ -5328,7 +5332,7 @@ lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
>  		if (!match)
>  			continue;
>  
> -		status = lpfc_send_taskmgmt(vport, ndlp->rport->dd_data,
> +		status = lpfc_send_taskmgmt(vport, cmnd,
>  					i, 0, FCP_TARGET_RESET);
>  
>  		if (status != SUCCESS) {
> -- 
> 2.5.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
