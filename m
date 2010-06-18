From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 04/11] qla4xxx: set correct value in sess->recovery_tmo
Date: Fri, 18 Jun 2010 17:58:53 -0500
Message-ID: <4C1BFA2D.6050607@cs.wisc.edu>
References: <20100616205111.GA8149@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54955 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742Ab0FRW4a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jun 2010 18:56:30 -0400
In-Reply-To: <20100616205111.GA8149@sles11sp1b1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: james.bottomley@suse.de, linux-scsi@vger.kernel.org, ravi.anand@qlogic.com

Actually, I am going to take back my ACK/review-by on this.

After discussing with Qlogic what the ka_timeout really is, it seems it 
is the wrong value to use. When the session->recovery_tmo is running the 
session is down so iscsi nops cannot be sent.



On 06/16/2010 03:51 PM, Vikas Chaudhary wrote:
> Signed-off-by: Vikas Chaudhary<vikas.chaudhary@qlogic.com>
> Signed-off-by: Ravi Anand<ravi.anand@qlogic.com>
> ---
>   drivers/scsi/qla4xxx/ql4_def.h  |    3 +--
>   drivers/scsi/qla4xxx/ql4_init.c |    6 +++---
>   drivers/scsi/qla4xxx/ql4_mbx.c  |    1 -
>   drivers/scsi/qla4xxx/ql4_os.c   |    4 ++--
>   4 files changed, 6 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
> index 4288026..2b53c79 100644
> --- a/drivers/scsi/qla4xxx/ql4_def.h
> +++ b/drivers/scsi/qla4xxx/ql4_def.h
> @@ -239,12 +239,12 @@ struct ddb_entry {
>   	uint32_t default_time2wait; /* Default Min time between
>   				     * relogins (+aens) */
>
> -	atomic_t port_down_timer; /* Device connection timer */
>   	atomic_t retry_relogin_timer; /* Min Time between relogins
>   				       * (4000 only) */
>   	atomic_t relogin_timer;	/* Max Time to wait for relogin to complete */
>   	atomic_t relogin_retry_count; /* Num of times relogin has been
>   				       * retried */
> +	uint16_t ka_timeout;
>
>   	uint16_t port;
>   	uint32_t tpgt;
> @@ -394,7 +394,6 @@ struct scsi_qla_host {
>   	uint32_t timer_active;
>
>   	/* Recovery Timers */
> -	uint32_t port_down_retry_count;
>   	uint32_t discovery_wait;
>   	atomic_t check_relogin_timeouts;
>   	uint32_t retry_reset_ha_cnt;
> diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
> index d525405..6cdfe9f 100644
> --- a/drivers/scsi/qla4xxx/ql4_init.c
> +++ b/drivers/scsi/qla4xxx/ql4_init.c
> @@ -548,6 +548,9 @@ static int qla4xxx_update_ddb_entry(struct scsi_qla_host *ha,
>   	ddb_entry->default_relogin_timeout =
>   		le16_to_cpu(fw_ddb_entry->def_timeout);
>   	ddb_entry->default_time2wait = le16_to_cpu(fw_ddb_entry->iscsi_def_time2wait);
> +	ddb_entry->ka_timeout = le16_to_cpu(fw_ddb_entry->ka_timeout);
> +	if (ddb_entry->sess)
> +		ddb_entry->sess->recovery_tmo = ddb_entry->ka_timeout;
>
>   	/* Update index in case it changed */
>   	ddb_entry->fw_ddb_index = fw_ddb_index;
> @@ -633,7 +636,6 @@ static struct ddb_entry * qla4xxx_alloc_ddb(struct scsi_qla_host *ha,
>   	}
>
>   	ddb_entry->fw_ddb_index = fw_ddb_index;
> -	atomic_set(&ddb_entry->port_down_timer, ha->port_down_retry_count);
>   	atomic_set(&ddb_entry->retry_relogin_timer, INVALID_ENTRY);
>   	atomic_set(&ddb_entry->relogin_timer, 0);
>   	atomic_set(&ddb_entry->relogin_retry_count, 0);
> @@ -1500,8 +1502,6 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
>   	/* Device is back online. */
>   	if (ddb_entry->fw_ddb_device_state == DDB_DS_SESSION_ACTIVE) {
>   		atomic_set(&ddb_entry->state, DDB_STATE_ONLINE);
> -		atomic_set(&ddb_entry->port_down_timer,
> -			   ha->port_down_retry_count);
>   		atomic_set(&ddb_entry->relogin_retry_count, 0);
>   		atomic_set(&ddb_entry->relogin_timer, 0);
>   		clear_bit(DF_RELOGIN,&ddb_entry->flags);
> diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
> index 75496fb..aa12ffd 100644
> --- a/drivers/scsi/qla4xxx/ql4_mbx.c
> +++ b/drivers/scsi/qla4xxx/ql4_mbx.c
> @@ -287,7 +287,6 @@ qla4xxx_update_local_ifcb(struct scsi_qla_host *ha,
>   	       min(sizeof(ha->alias), sizeof(init_fw_cb->Alias)));*/
>
>   	/* Save Command Line Paramater info */
> -	ha->port_down_retry_count = le16_to_cpu(init_fw_cb->conn_ka_timeout);
>   	ha->discovery_wait = ql4xdiscoverywait;
>
>   	if (ha->acb_version == ACB_SUPPORTED) {
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index 38b1d38..11a4bd1 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -155,7 +155,7 @@ static void qla4xxx_recovery_timedout(struct iscsi_cls_session *session)
>   		DEBUG2(printk("scsi%ld: %s: index [%d] port down retry count "
>   			      "of (%d) secs exhausted, marking device DEAD.\n",
>   			      ha->host_no, __func__, ddb_entry->fw_ddb_index,
> -			      ha->port_down_retry_count));
> +			      ddb_entry->ka_timeout));
>
>   		DEBUG2(printk("scsi%ld: %s: scheduling dpc routine - dpc "
>   			      "flags = 0x%lx\n",
> @@ -286,7 +286,7 @@ int qla4xxx_add_sess(struct ddb_entry *ddb_entry)
>   {
>   	int err;
>
> -	ddb_entry->sess->recovery_tmo = ddb_entry->ha->port_down_retry_count;
> +	ddb_entry->sess->recovery_tmo = ddb_entry->ka_timeout;
>   	err = iscsi_add_session(ddb_entry->sess, ddb_entry->fw_ddb_index);
>   	if (err) {
>   		DEBUG2(printk(KERN_ERR "Could not add session.\n"));

