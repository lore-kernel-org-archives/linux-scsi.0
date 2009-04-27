From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/2] qla4xxx: Driver Fault Recovery
Date: Mon, 27 Apr 2009 10:09:12 -0500
Message-ID: <49F5CA98.8060708@cs.wisc.edu>
References: <DBF768B1A111084580554DADE800BF9D72EA041EFD@AVEXMB2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41360 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758170AbZD0PJU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Apr 2009 11:09:20 -0400
In-Reply-To: <DBF768B1A111084580554DADE800BF9D72EA041EFD@AVEXMB2.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karen Higgins <karen.higgins@qlogic.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Karen Higgins wrote:
> Driver Fault Recovery
> 
> Fixed driver bug where adapter recovery did not complete if there were
> outstanding commands detected on that host adapter.
> 
> Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c |   19 +++++++++----------
>  1 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index eb3a414..fcc65a5 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -904,18 +904,17 @@ static int qla4xxx_recover_adapter(struct scsi_qla_host *ha,
>      /* Flush any pending ddb changed AENs */
>      qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
>  
> +    qla4xxx_flush_active_srbs(ha);
> +
>      /* Reset the firmware.    If successful, function
>       * returns with ISP interrupts enabled.
>       */
> -    if (status == QLA_SUCCESS) {
> -        DEBUG2(printk("scsi%ld: %s - Performing soft reset..\n",
> -                  ha->host_no, __func__));
> -        qla4xxx_flush_active_srbs(ha);
> -        if (ql4xxx_lock_drvr_wait(ha) == QLA_SUCCESS)
> -            status = qla4xxx_soft_reset(ha);
> -        else
> -            status = QLA_ERROR;
> -    }
> +    DEBUG2(printk("scsi%ld: %s - Performing soft reset..\n",
> +              ha->host_no, __func__));
> +    if (ql4xxx_lock_drvr_wait(ha) == QLA_SUCCESS)
> +        status = qla4xxx_soft_reset(ha);
> +    else
> +        status = QLA_ERROR;
>  
>      /* Flush any pending ddb changed AENs */
>      qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
> @@ -1644,7 +1643,7 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
>      ha = (struct scsi_qla_host *) cmd->device->host->hostdata;
>  
>      dev_info(&ha->pdev->dev,
> -           "scsi(%ld:%d:%d:%d): ADAPTER RESET ISSUED.\n", ha->host_no,
> +           "scsi(%ld:%d:%d:%d): HOST RESET ISSUED.\n", ha->host_no,
>             cmd->device->channel, cmd->device->id, cmd->device->lun);
>  
>      if (qla4xxx_wait_for_hba_online(ha) != QLA_SUCCESS) {



My mailer is messing up the formatting so it looks like spaces instead 
of tabs are getting adedd. If that is my mailers fault then patch looks ok:

Reviewed-by Mike Christie <michaelc@cs.wisc.edu>
