From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH 7/9] lpfc: Fix scsi task management error message.
Date: Sun, 24 May 2015 22:27:39 +0200
Message-ID: <20150524222739.0000392d@localhost>
References: <555f4061.JF1uAXJ3MNmJF4W9%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:64722 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbbEXU1k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 May 2015 16:27:40 -0400
In-Reply-To: <555f4061.JF1uAXJ3MNmJF4W9%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>
Cc: linux-scsi@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>

James Smart wrote:
> 
> Fix scsi task management error message.
> 
> TMF's were getting error messages on FCP_RSP errors (underrun). Underruns
> aren't meaningful in the scenario. Change the error message to filter out
> these response check errors, and don't unconditionally mark the cmd as
> in error.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>  drivers/scsi/lpfc/lpfc_scsi.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index b3b195f..e5eb40d 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -5011,13 +5011,16 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct lpfc_rport_data *rdata,
>  					  iocbq, iocbqrsp, lpfc_cmd->timeout);
>  	if ((status != IOCB_SUCCESS) ||
>  	    (iocbqrsp->iocb.ulpStatus != IOSTAT_SUCCESS)) {
> -		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
> -			 "0727 TMF %s to TGT %d LUN %llu failed (%d, %d) "
> -			 "iocb_flag x%x\n",
> -			 lpfc_taskmgmt_name(task_mgmt_cmd),
> -			 tgt_id, lun_id, iocbqrsp->iocb.ulpStatus,
> -			 iocbqrsp->iocb.un.ulpWord[4],
> -			 iocbq->iocb_flag);
> +		if (status != IOCB_SUCCESS ||
> +		    iocbqrsp->iocb.ulpStatus != IOSTAT_FCP_RSP_ERROR)
> +			lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
> +					 "0727 TMF %s to TGT %d LUN %llu "
> +					 "failed (%d, %d) iocb_flag x%x\n",
> +					 lpfc_taskmgmt_name(task_mgmt_cmd),
> +					 tgt_id, lun_id,
> +					 iocbqrsp->iocb.ulpStatus,
> +					 iocbqrsp->iocb.un.ulpWord[4],
> +					 iocbq->iocb_flag);

checkpatch suggests to not split this user-visible string.

Sebastian
