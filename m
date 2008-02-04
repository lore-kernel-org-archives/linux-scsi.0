From: "David Somayajulu" <david.somayajulu@qlogic.com>
Subject: RE: [PATCH 05/12] qla4xxx: fix recovery timer and session unblock race
Date: Mon, 4 Feb 2008 10:19:08 -0800
Message-ID: <0BB3E5E7462EEA4295BC02D49691DC070120BF1B@AVEXCH1.qlogic.org>
References: <12018082161847-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:4923 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbYBDSTK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 13:19:10 -0500
Content-class: urn:content-classes:message
In-Reply-To: <12018082161847-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

 
Mike Christie wrote :
> If qla4xxx is resetting up a session and the recovery timer
> fires we do not want to just set it to dead, because
> the dpc thread could have just set it to online and is in the
> middle of resetting it up.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c |   19 +++++++++++--------
>  1 files changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c 
> b/drivers/scsi/qla4xxx/ql4_os.c
> index 437d169..d4dd149 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -124,16 +124,19 @@ static void 
> qla4xxx_recovery_timedout(struct iscsi_cls_session *session)
>  	struct ddb_entry *ddb_entry = session->dd_data;
>  	struct scsi_qla_host *ha = ddb_entry->ha;
>  
> -	DEBUG2(printk("scsi%ld: %s: index [%d] port down retry 
> count of (%d) "
> -		      "secs exhausted, marking device DEAD.\n", 
> ha->host_no,
> -		      __func__, ddb_entry->fw_ddb_index,
> -		      ha->port_down_retry_count));
> +	if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
> +		atomic_set(&ddb_entry->state, DDB_STATE_DEAD);
>  
> -	atomic_set(&ddb_entry->state, DDB_STATE_DEAD);
> +		DEBUG2(printk("scsi%ld: %s: index [%d] port 
> down retry count "
> +			      "of (%d) secs exhausted, marking 
> device DEAD.\n",
> +			      ha->host_no, __func__, 
> ddb_entry->fw_ddb_index,
> +			      ha->port_down_retry_count));
>  
> -	DEBUG2(printk("scsi%ld: %s: scheduling dpc routine - 
> dpc flags = "
> -		      "0x%lx\n", ha->host_no, __func__, ha->dpc_flags));
> -	queue_work(ha->dpc_thread, &ha->dpc_work);
> +		DEBUG2(printk("scsi%ld: %s: scheduling dpc 
> routine - dpc "
> +			      "flags = 0x%lx\n",
> +			      ha->host_no, __func__, ha->dpc_flags));
> +		queue_work(ha->dpc_thread, &ha->dpc_work);
> +	}
>  }
>  
>  static int qla4xxx_host_get_param(struct Scsi_Host *shost,
> -- 
> 1.5.2.1

Acked by David Somayajulu <david.somayajulu@qlogic.com>
