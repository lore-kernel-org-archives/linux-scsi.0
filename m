From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: Re: [PATCH 4/9] qla4xxx: use SCSI_ML_TARGET_BUSY and iscsi helper
Date: Mon, 03 Mar 2008 09:34:08 -0800
Message-ID: <1204565648.3824.4.camel@n5102av4sv2pdc1.qlogic.org>
References: <1204448602-5435-1-git-send-email-michaelc@cs.wisc.edu>
	 <1204448602-5435-2-git-send-email-michaelc@cs.wisc.edu>
	 <1204448602-5435-3-git-send-email-michaelc@cs.wisc.edu>
	 <1204448602-5435-4-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:42845 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761197AbYCCRg2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2008 12:36:28 -0500
In-Reply-To: <1204448602-5435-4-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, James.Smart@Emulex.com, Eric.Moore@lsil.com

On Sun, 2008-03-02 at 03:03 -0600, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> When transitioning to the blocked state use SCSI_ML_TARGET_BUSY
> instead of returning with DID_IMM_RETRY, because DID_IMM_RETRY
> causes a requeue and then possibly (if under recursion limits)
> a queuecommand call.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c |   37 ++++++++++++++++++++-----------------
>  1 files changed, 20 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index c3c59d7..40ad624 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -341,9 +341,7 @@ void qla4xxx_mark_device_missing(struct scsi_qla_host *ha,
>  }
>  
>  static struct srb* qla4xxx_get_new_srb(struct scsi_qla_host *ha,
> -				       struct ddb_entry *ddb_entry,
> -				       struct scsi_cmnd *cmd,
> -				       void (*done)(struct scsi_cmnd *))
> +				       struct ddb_entry *ddb_entry)
>  {
>  	struct srb *srb;
>  
> @@ -354,11 +352,7 @@ static struct srb* qla4xxx_get_new_srb(struct scsi_qla_host *ha,
>  	atomic_set(&srb->ref_count, 1);
>  	srb->ha = ha;
>  	srb->ddb = ddb_entry;
> -	srb->cmd = cmd;
>  	srb->flags = 0;
> -	cmd->SCp.ptr = (void *)srb;
> -	cmd->scsi_done = done;
> -
>  	return srb;
>  }
>  
> @@ -407,33 +401,41 @@ static int qla4xxx_queuecommand(struct scsi_cmnd *cmd,
>  	struct srb *srb;
>  	int rval;
>  
> +	cmd->scsi_done = done;
> +	cmd->result = 0;
> +
>  	if (!sess) {
>  		cmd->result = DID_IMM_RETRY << 16;
>  		goto qc_fail_command;
>  	}
>  
> -	rval = iscsi_session_chkready(sess);
> -	if (rval) {
> -		cmd->result = rval;
> +	rval = iscsi_session_queue_ready(sess, cmd);
> +	if (rval)
> +		goto qc_busy;
> +	if (cmd->result)
>  		goto qc_fail_command;
> -	}
>  
>  	if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
>  		if (atomic_read(&ddb_entry->state) == DDB_STATE_DEAD) {
>  			cmd->result = DID_NO_CONNECT << 16;
>  			goto qc_fail_command;
>  		}
> -		goto qc_host_busy;
> +		rval = SCSI_MLQUEUE_TARGET_BUSY;
> +		goto qc_busy;
>  	}
>  
> -	if (test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags))
> -		goto qc_host_busy;
> +	if (test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags)) {
> +		rval = SCSI_MLQUEUE_HOST_BUSY;
> +		goto qc_busy;
> +	}
>  
>  	spin_unlock_irq(ha->host->host_lock);
>  
> -	srb = qla4xxx_get_new_srb(ha, ddb_entry, cmd, done);
> +	srb = qla4xxx_get_new_srb(ha, ddb_entry);
>  	if (!srb)On Sun, 2008-03-02 at 03:03 -0600, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> When transitioning to the blocked state use SCSI_ML_TARGET_BUSY
> instead of returning with DID_IMM_RETRY, because DID_IMM_RETRY
> causes a requeue and then possibly (if under recursion limits)
> a queuecommand call.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c |   37 ++++++++++++++++++++-----------------
>  1 files changed, 20 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index c3c59d7..40ad624 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -341,9 +341,7 @@ void qla4xxx_mark_device_missing(struct scsi_qla_host *ha,
>  }
>  
>  static struct srb* qla4xxx_get_new_srb(struct scsi_qla_host *ha,
> -				       struct ddb_entry *ddb_entry,
> -				       struct scsi_cmnd *cmd,
> -				       void (*done)(struct scsi_cmnd *))
> +				       struct ddb_entry *ddb_entry)
>  {
>  	struct srb *srb;
>  
> @@ -354,11 +352,7 @@ static struct srb* qla4xxx_get_new_srb(struct scsi_qla_host *ha,
>  	atomic_set(&srb->ref_count, 1);
>  	srb->ha = ha;
>  	srb->ddb = ddb_entry;
> -	srb->cmd = cmd;On Sun, 2008-03-02 at 03:03 -0600, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> When transitioning to the blocked state use SCSI_ML_TARGET_BUSY
> instead of returning with DID_IMM_RETRY, because DID_IMM_RETRY
> causes a requeue and then possibly (if under recursion limits)
> a queuecommand call.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c |   37 ++++++++++++++++++++-----------------
>  1 files changed, 20 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index c3c59d7..40ad624 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -341,9 +341,7 @@ void qla4xxx_mark_device_missing(struct scsi_qla_host *ha,
>  }
>  
>  static struct srb* qla4xxx_get_new_srb(struct scsi_qla_host *ha,
> -				       struct ddb_entry *ddb_entry,
> -				       struct scsi_cmnd *cmd,
> -				       void (*done)(struct scsi_cmnd *))
> +				       struct ddb_entry *ddb_entry)
>  {
>  	struct srb *srb;
>  
> @@ -354,11 +352,7 @@ static struct srb* qla4xxx_get_new_srb(struct scsi_qla_host *ha,
>  	atomic_set(&srb->ref_count, 1);
>  	srb->ha = ha;
>  	srb->ddb = ddb_entry;
> -	srb->cmd = cmd;
>  	srb->flags = 0;
> -	cmd->SCp.ptr = (void *)srb;
> -	cmd->scsi_done = done;
> -
>  	return srb;
>  }
>  
> @@ -407,33 +401,41 @@ static int qla4xxx_queuecommand(struct scsi_cmnd *cmd,
>  	struct srb *srb;
>  	int rval;
>  
> +	cmd->scsi_done = done;
> +	cmd->result = 0;
> +
>  	if (!sess) {
>  		cmd->result = DID_IMM_RETRY << 16;
>  		goto qc_fail_command;
>  	}
>  
> -	rval = iscsi_session_chkready(sess);
> -	if (rval) {
> -		cmd->result = rval;
> +	rval = iscsi_session_queue_ready(sess, cmd);
> +	if (rval)
> +		goto qc_busy;
> +	if (cmd->result)
>  		goto qc_fail_command;
> -	}
>  
>  	if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
>  		if (atomic_read(&ddb_entry->state) == DDB_STATE_DEAD) {
>  			cmd->result = DID_NO_CONNECT << 16;
>  			goto qc_fail_command;
>  		}
> -		goto qc_host_busy;
> +		rval = SCSI_MLQUEUE_TARGET_BUSY;
> +		goto qc_busy;
>  	}
>  
> -	if (test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags))
> -		goto qc_host_busy;
> +	if (test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags)) {
> +		rval = SCSI_MLQUEUE_HOST_BUSY;
> +		goto qc_busy;
> +	}
>  
>  	spin_unlock_irq(ha->host->host_lock);
>  
> -	srb = qla4xxx_get_new_srb(ha, ddb_entry, cmd, done);
> +	srb = qla4xxx_get_new_srb(ha, ddb_entry);
>  	if (!srb)
>  		goto qc_host_busy_lock;
> +	cmd->SCp.ptr = (void *)srb;
> +	srb->cmd = cmd;
>  
>  	rval = qla4xxx_send_command_to_isp(ha, srb);
>  	if (rval != QLA_SUCCESS)
> @@ -447,10 +449,11 @@ qc_host_busy_free_sp:
>  	mempool_free(srb, ha->srb_mempool);
>  
>  qc_host_busy_lock:
> +	rval = SCSI_MLQUEUE_HOST_BUSY;
>  	spin_lock_irq(ha->host->host_lock);
>  
> -qc_host_busy:
> -	return SCSI_MLQUEUE_HOST_BUSY;
> +qc_busy:
> +	return rval;
>  
>  qc_fail_command:
>  	done(cmd);
>  	srb->flags = 0;
> -	cmd->SCp.ptr = (void *)srb;
> -	cmd->scsi_done = done;
> -On Sun, 2008-03-02 at 03:03 -0600, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> When transitioning to the blocked state use SCSI_ML_TARGET_BUSY
> instead of returning with DID_IMM_RETRY, because DID_IMM_RETRY
> causes a requeue and then possibly (if under recursion limits)
> a queuecommand call.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c |   37 ++++++++++++++++++++-----------------
>  1 files changed, 20 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index c3c59d7..40ad624 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -341,9 +341,7 @@ void qla4xxx_mark_device_missing(struct scsi_qla_host *ha,
>  }
>  
>  static struct srb* qla4xxx_get_new_srb(struct scsi_qla_host *ha,
> -				       struct ddb_entry *ddb_entry,
> -				       struct scsi_cmnd *cmd,
> -				       void (*done)(struct scsi_cmnd *))
> +				       struct ddb_entry *ddb_entry)
>  {
>  	struct srb *srb;
>  
> @@ -354,11 +352,7 @@ static struct srb* qla4xxx_get_new_srb(struct scsi_qla_host *ha,
>  	atomic_set(&srb->ref_count, 1);
>  	srb->ha = ha;
>  	srb->ddb = ddb_entry;
> -	srb->cmd = cmd;
>  	srb->flags = 0;
> -	cmd->SCp.ptr = (void *)srb;
> -	cmd->scsi_done = done;
> -
>  	return srb;
>  }
>  
> @@ -407,33 +401,41 @@ static int qla4xxx_queuecommand(struct scsi_cmnd *cmd,
>  	struct srb *srb;
>  	int rval;
>  
> +	cmd->scsi_done = done;
> +	cmd->result = 0;
> +
>  	if (!sess) {
>  		cmd->result = DID_IMM_RETRY << 16;
>  		goto qc_fail_command;
>  	}
>  
> -	rval = iscsi_session_chkready(sess);
> -	if (rval) {
> -		cmd->result = rval;
> +	rval = iscsi_session_queue_ready(sess, cmd);
> +	if (rval)
> +		goto qc_busy;
> +	if (cmd->result)
>  		goto qc_fail_command;
> -	}
>  
>  	if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
>  		if (atomic_read(&ddb_entry->state) == DDB_STATE_DEAD) {
>  			cmd->result = DID_NO_CONNECT << 16;
>  			goto qc_fail_command;
>  		}
> -		goto qc_host_busy;
> +		rval = SCSI_MLQUEUE_TARGET_BUSY;
> +		goto qc_busy;
>  	}
>  
> -	if (test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags))
> -		goto qc_host_busy;
> +	if (test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags)) {
> +		rval = SCSI_MLQUEUE_HOST_BUSY;
> +		goto qc_busy;
> +	}
>  
>  	spin_unlock_irq(ha->host->host_lock);
>  
> -	srb = qla4xxx_get_new_srb(ha, ddb_entry, cmd, done);On Sun, 2008-03-02 at 03:03 -0600, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> When transitioning to the blocked state use SCSI_ML_TARGET_BUSY
> instead of returning with DID_IMM_RETRY, because DID_IMM_RETRY
> causes a requeue and then possibly (if under recursion limits)
> a queuecommand call.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c |   37 ++++++++++++++++++++-----------------
>  1 files changed, 20 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index c3c59d7..40ad624 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -341,9 +341,7 @@ void qla4xxx_mark_device_missing(struct scsi_qla_host *ha,
>  }
>  
>  static struct srb* qla4xxx_get_new_srb(struct scsi_qla_host *ha,
> -				       struct ddb_entry *ddb_entry,
> -				       struct scsi_cmnd *cmd,
> -				       void (*done)(struct scsi_cmnd *))
> +				       struct ddb_entry *ddb_entry)
>  {
>  	struct srb *srb;
>  
> @@ -354,11 +352,7 @@ static struct srb* qla4xxx_get_new_srb(struct scsi_qla_host *ha,
>  	atomic_set(&srb->ref_count, 1);
>  	srb->ha = ha;
>  	srb->ddb = ddb_entry;
> -	srb->cmd = cmd;
>  	srb->flags = 0;
> -	cmd->SCp.ptr = (void *)srb;
> -	cmd->scsi_done = done;
> -
>  	return srb;
>  }
>  
> @@ -407,33 +401,41 @@ static int qla4xxx_queuecommand(struct scsi_cmnd *cmd,
>  	struct srb *srb;
>  	int rval;
>  
> +	cmd->scsi_done = done;
> +	cmd->result = 0;
> +
>  	if (!sess) {
>  		cmd->result = DID_IMM_RETRY << 16;
>  		goto qc_fail_command;
>  	}
>  
> -	rval = iscsi_session_chkready(sess);
> -	if (rval) {
> -		cmd->result = rval;
> +	rval = iscsi_session_queue_ready(sess, cmd);
> +	if (rval)
> +		goto qc_busy;
> +	if (cmd->result)
>  		goto qc_fail_command;
> -	}
>  
>  	if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
>  		if (atomic_read(&ddb_entry->state) == DDB_STATE_DEAD) {
>  			cmd->result = DID_NO_CONNECT << 16;
>  			goto qc_fail_command;
>  		}
> -		goto qc_host_busy;
> +		rval = SCSI_MLQUEUE_TARGET_BUSY;
> +		goto qc_busy;
>  	}
>  
> -	if (test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags))
> -		goto qc_host_busy;
> +	if (test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags)) {
> +		rval = SCSI_MLQUEUE_HOST_BUSY;
> +		goto qc_busy;
> +	}
>  
>  	spin_unlock_irq(ha->host->host_lock);
>  
> -	srb = qla4xxx_get_new_srb(ha, ddb_entry, cmd, done);
> +	srb = qla4xxx_get_new_srb(ha, ddb_entry);
>  	if (!srb)
>  		goto qc_host_busy_lock;
> +	cmd->SCp.ptr = (void *)srb;
> +	srb->cmd = cmd;
>  
>  	rval = qla4xxx_send_command_to_isp(ha, srb);
>  	if (rval != QLA_SUCCESS)
> @@ -447,10 +449,11 @@ qc_host_busy_free_sp:
>  	mempool_free(srb, ha->srb_mempool);
>  
>  qc_host_busy_lock:
> +	rval = SCSI_MLQUEUE_HOST_BUSY;
>  	spin_lock_irq(ha->host->host_lock);
>  
> -qc_host_busy:
> -	return SCSI_MLQUEUE_HOST_BUSY;
> +qc_busy:
> +	return rval;
>  
>  qc_fail_command:
>  	done(cmd);
> +	srb = qla4xxx_get_new_srb(ha, ddb_entry);
>  	if (!srb)
>  		goto qc_host_busy_lock;
> +	cmd->SCp.ptr = (void *)srb;
> +	srb->cmd = cmd;
>  
>  	rval = qla4xxx_send_command_to_isp(ha, srb);
>  	if (rval != QLA_SUCCESS)
> @@ -447,10 +449,11 @@ qc_host_busy_free_sp:
>  	mempool_free(srb, ha->srb_mempool);
>  
>  qc_host_busy_lock:
> +	rval = SCSI_MLQUEUE_HOST_BUSY;
>  	spin_lock_irq(ha->host->host_lock);
>  
> -qc_host_busy:
> -	return SCSI_MLQUEUE_HOST_BUSY;
> +qc_busy:
> +	return rval;
>  
>  qc_fail_command:
>  	done(cmd);
>  	return srb;
>  }
>  
> @@ -407,33 +401,41 @@ static int qla4xxx_queuecommand(struct scsi_cmnd *cmd,
>  	struct srb *srb;
>  	int rval;
>  
> +	cmd->scsi_done = done;
> +	cmd->result = 0;
> +
>  	if (!sess) {
>  		cmd->result = DID_IMM_RETRY << 16;
>  		goto qc_fail_command;
>  	}
>  
> -	rval = iscsi_session_chkready(sess);
> -	if (rval) {
> -		cmd->result = rval;
> +	rval = iscsi_session_queue_ready(sess, cmd);
> +	if (rval)
> +		goto qc_busy;
> +	if (cmd->result)
>  		goto qc_fail_command;
> -	}
>  
>  	if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
>  		if (atomic_read(&ddb_entry->state) == DDB_STATE_DEAD) {
>  			cmd->result = DID_NO_CONNECT << 16;
>  			goto qc_fail_command;
>  		}
> -		goto qc_host_busy;
> +		rval = SCSI_MLQUEUE_TARGET_BUSY;
> +		goto qc_busy;
>  	}
>  
> -	if (test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags))
> -		goto qc_host_busy;
> +	if (test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags)) {
> +		rval = SCSI_MLQUEUE_HOST_BUSY;
> +		goto qc_busy;
> +	}
>  
>  	spin_unlock_irq(ha->host->host_lock);
>  
> -	srb = qla4xxx_get_new_srb(ha, ddb_entry, cmd, done);
> +	srb = qla4xxx_get_new_srb(ha, ddb_entry);
>  	if (!srb)
>  		goto qc_host_busy_lock;
> +	cmd->SCp.ptr = (void *)srb;
> +	srb->cmd = cmd;
>  
>  	rval = qla4xxx_send_command_to_isp(ha, srb);
>  	if (rval != QLA_SUCCESS)
> @@ -447,10 +449,11 @@ qc_host_busy_free_sp:
>  	mempool_free(srb, ha->srb_mempool);
>  
>  qc_host_busy_lock:
> +	rval = SCSI_MLQUEUE_HOST_BUSY;
>  	spin_lock_irq(ha->host->host_lock);
>  
> -qc_host_busy:
> -	return SCSI_MLQUEUE_HOST_BUSY;
> +qc_busy:
> +	return rval;
>  
>  qc_fail_command:
>  	done(cmd);
>  		goto qc_host_busy_lock;
> +	cmd->SCp.ptr = (void *)srb;
> +	srb->cmd = cmd;
>  
>  	rval = qla4xxx_send_command_to_isp(ha, srb);
>  	if (rval != QLA_SUCCESS)
> @@ -447,10 +449,11 @@ qc_host_busy_free_sp:
>  	mempool_free(srb, ha->srb_mempool);
>  
>  qc_host_busy_lock:
> +	rval = SCSI_MLQUEUE_HOST_BUSY;
>  	spin_lock_irq(ha->host->host_lock);
>  
> -qc_host_busy:
> -	return SCSI_MLQUEUE_HOST_BUSY;
> +qc_busy:
> +	return rval;
>  
>  qc_fail_command:
>  	done(cmd);
Signed-off-by: David C Somayajulu <david.somayajulu@qlogic.com>

