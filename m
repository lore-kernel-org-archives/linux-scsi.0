From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: Re: PATCH  [4/5]  qla2xxx: Command queueing fixes
Date: Thu, 15 Jul 2004 17:03:48 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B060EEDF@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:53418 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S266247AbUGPAGg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jul 2004 20:06:36 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

James,

There are some problems being reported with the attached patch applied
to the 8.x series driver.  Please revert the patch if you have already
applied to the scsi-misc-2.6 tree.

Sorry,
Andrew Vasquez
QLogic Corporation
 
> ChangeSet
>   1.1868 04/07/12 09:42:23 andrew.vasquez@apc.qlogic.com +1 -0
>   Fix issue where a single command could inadvertently get 
>   'stuck' in the pending queue during resource availability
>   failures.
> 
> Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> 
>  drivers/scsi/qla2xxx/qla_os.c |   25 +++++++++++--------------
>  1 files changed, 11 insertions(+), 14 deletions(-)
>
> diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> --- a/drivers/scsi/qla2xxx/qla_os.c	2004-07-12 09:55:05 -07:00
> +++ b/drivers/scsi/qla2xxx/qla_os.c	2004-07-12 09:55:05 -07:00
> @@ -4175,19 +4175,15 @@
>  	unsigned long   flags;
>  	scsi_qla_host_t *dest_ha;
>  	fc_port_t	*fcport;
> -	srb_t           *sp, *sptemp;
> -	LIST_HEAD(local_sp_list);
> +	srb_t           *sp;
>  
>  	dest_ha = NULL;
>  
>  	spin_lock_irqsave(&vis_ha->list_lock, flags);
> -	list_splice_init(&vis_ha->pending_queue, &local_sp_list);
> -	vis_ha->qthreads = 0;
> -	spin_unlock_irqrestore(&vis_ha->list_lock, flags);
> +	while (!list_empty(&vis_ha->pending_queue)) {
> +		sp = list_entry(vis_ha->pending_queue.next, srb_t, list);
>  
> -	list_for_each_entry_safe(sp, sptemp, &local_sp_list, list) {
> -		list_del_init(&sp->list);
> -        	sp->state = SRB_NO_QUEUE_STATE;
> +		__del_from_pending_queue(vis_ha, sp);
>  
>  		fcport = sp->fclun->fcport;
>  		dest_ha = fcport->ha;
> @@ -4208,7 +4204,7 @@
>  			/* 
>  			 * Initiate a failover - done routine will initiate.
>  			 */
> -			add_to_done_queue(vis_ha, sp);
> +			__add_to_done_queue(vis_ha, sp);
>  
>  			continue;
>  		}
> @@ -4243,8 +4239,7 @@
>  			    dest_ha->dpc_flags));
>  
>  			qla2x00_extend_timeout(sp->cmd, EXTEND_CMD_TIMEOUT);
> -			add_to_retry_queue(vis_ha, sp);
> -
> +			__add_to_retry_queue(vis_ha, sp);
>  			continue;
>  		} 
>  
> @@ -4262,22 +4257,24 @@
>  			    sp->cmd->allowed,
>  			    sp->cmd->retries));
>  				
> -			add_to_scsi_retry_queue(vis_ha, sp);
> -
> +			__add_to_scsi_retry_queue(vis_ha, sp);
>  			continue;
>  		}
>  
>  		sp->lun_queue->io_cnt++;
>  
> +		spin_unlock_irqrestore(&vis_ha->list_lock, flags);
>  		rval = qla2x00_start_scsi(sp);
> +		spin_lock_irqsave(&vis_ha->list_lock, flags);
>  		if (rval != QLA_SUCCESS) {
>  			/* Place request back on top of device queue */
>  			/* add to the top of queue */
> -			add_to_pending_queue_head(vis_ha, sp);
> +			__add_to_pending_queue_head(vis_ha, sp);
>  
>  			sp->lun_queue->io_cnt--;
>  		}
>  	}
> +	spin_unlock_irqrestore(&vis_ha->list_lock, flags);
>  
>  	if (!IS_QLA2100(vis_ha) && !IS_QLA2200(vis_ha)) {
>  		/* Process response_queue if ZIO support is enabled*/ 
