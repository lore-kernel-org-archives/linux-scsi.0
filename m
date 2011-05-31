From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 41/42] target/iscsi: remove unsolicited_data_comp
	completion
Date: Tue, 31 May 2011 02:58:36 -0700
Message-ID: <1306835916.8193.182.camel@haakon2.linux-iscsi.org>
References: <1306523240-15543-1-git-send-email-agrover@redhat.com>
	 <1306523240-15543-42-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56360 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab1EaKHA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2011 06:07:00 -0400
In-Reply-To: <1306523240-15543-42-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: target-devel <target-devel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2011-05-27 at 12:07 -0700, Andy Grover wrote:
> Since iscsi now allocates its own buffers and in its own thread, we don't
> need the unsolicited_data_comp completion.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---

Committed as 26bc999ea68 with a few very minor changes in order to apply
w/o patch #25-#26..

Once again, very well done for enabling direct task allocation from
iscsi RX thread context and saving the initial context switch, and the
second switch with immediate write data and/or unsolicited data out.

I am excited to see to see how much of an latency improvement this buys
gives us.  Really great work Andy.  :)

--nab

>  drivers/target/iscsi/iscsi_target.c          |   41 +++----------------------
>  drivers/target/iscsi/iscsi_target_configfs.c |   13 ++------
>  drivers/target/iscsi/iscsi_target_core.h     |    2 -
>  drivers/target/iscsi/iscsi_target_util.c     |    1 -
>  drivers/target/target_core_transport.c       |    2 +-
>  5 files changed, 9 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index a36064b..e8b72d4 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1139,15 +1139,9 @@ attach_cmd:
>  		goto after_immediate_data;
>  	}
>  
> -	/*
> -	 * Immediate Data is present, send to the transport and block until
> -	 * the underlying transport plugin has allocated the buffer to
> -	 * receive the Immediate Write Data into.
> -	 */
> +	/* Allocates backstore tasks */
>  	transport_generic_new_cmd(SE_CMD(cmd));
>  
> -	wait_for_completion(&cmd->unsolicited_data_comp);
> -
>  	if (SE_CMD(cmd)->se_cmd_flags & SCF_SE_CMD_FAILED) {
>  		immed_ret = IMMEDIATE_DATA_NORMAL_OPERATION;
>  		dump_immediate_data = 1;
> @@ -1344,7 +1338,7 @@ static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
>  	}
>  
>  	if (cmd->unsolicited_data) {
> -		int dump_unsolicited_data = 0, wait_for_transport = 0;
> +		int dump_unsolicited_data = 0;
>  
>  		if (conn->sess->sess_ops->InitialR2T) {
>  			printk(KERN_ERR "Received unexpected unsolicited data"
> @@ -1358,37 +1352,12 @@ static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
>  		 * and Unsupported SAM WRITE Opcodes and SE resource allocation
>  		 * failures;
>  		 */
> +
> +		/* Something's amiss if we're not in WRITE_PENDING state... */
>  		spin_lock_irqsave(&se_cmd->t_state_lock, flags);
> -		/*
> -		 * Handle cases where we do or do not want to sleep on
> -		 * unsolicited_data_comp
> -		 *
> -		 * First, if TRANSPORT_WRITE_PENDING state has not been reached,
> -		 * we need assume we need to wait and sleep..
> -		 */
> -		 wait_for_transport =
> -				(se_cmd->t_state != TRANSPORT_WRITE_PENDING);
> -		/*
> -		 * For the ImmediateData=Yes cases, there will already be
> -		 * generic target memory allocated with the original
> -		 * ISCSI_OP_SCSI_CMD PDU, so do not sleep for that case.
> -		 *
> -		 * The last is a check for a delayed TASK_ABORTED status that
> -		 * means the data payload will be dropped because
> -		 * SCF_SE_CMD_FAILED has been set to indicate that an exception
> -		 * condition for this struct sse_cmd has occured in generic target
> -		 * code that requires us to drop payload.
> -		 */
> -		wait_for_transport =
> -				(se_cmd->t_state != TRANSPORT_WRITE_PENDING);
> -		if ((cmd->immediate_data != 0) ||
> -		    (atomic_read(&se_cmd->t_transport_aborted) != 0))
> -			wait_for_transport = 0;
> +		WARN_ON(se_cmd->t_state != TRANSPORT_WRITE_PENDING);
>  		spin_unlock_irqrestore(&se_cmd->t_state_lock, flags);
>  
> -		if (wait_for_transport)
> -			wait_for_completion(&cmd->unsolicited_data_comp);
> -
>  		spin_lock_irqsave(&se_cmd->t_state_lock, flags);
>  		if (!(se_cmd->se_cmd_flags & SCF_SUPPORTED_SAM_OPCODE) ||
>  		     (se_cmd->se_cmd_flags & SCF_SE_CMD_FAILED))
> diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
> index 4d712cf..fafeddf 100644
> --- a/drivers/target/iscsi/iscsi_target_configfs.c
> +++ b/drivers/target/iscsi/iscsi_target_configfs.c
> @@ -1510,10 +1510,7 @@ static int iscsi_get_cmd_state(struct se_cmd *se_cmd)
>  
>  static void iscsi_new_cmd_failure(struct se_cmd *se_cmd)
>  {
> -	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
> -
> -	if (cmd->immediate_data || cmd->unsolicited_data)
> -		complete(&cmd->unsolicited_data_comp);
> +	/* We no longer sleep while core allocs (we do alloc), so we can ignore this */
>  }
>  
>  static int iscsi_is_state_remove(struct se_cmd *se_cmd)
> @@ -1572,12 +1569,8 @@ static int lio_write_pending(struct se_cmd *se_cmd)
>  {
>  	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
>  
> -	if (cmd->immediate_data || cmd->unsolicited_data)
> -		complete(&cmd->unsolicited_data_comp);
> -	else {
> -		if (iscsit_build_r2ts_for_cmd(cmd, cmd->conn, 1) < 0)
> -			return PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
> -	}
> +	if (!cmd->immediate_data && !cmd->unsolicited_data)
> +		return iscsit_build_r2ts_for_cmd(cmd, cmd->conn, 1);
>  
>  	return 0;
>  }
> diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscsi/iscsi_target_core.h
> index 693f8c8..fa45d87 100644
> --- a/drivers/target/iscsi/iscsi_target_core.h
> +++ b/drivers/target/iscsi/iscsi_target_core.h
> @@ -438,8 +438,6 @@ struct iscsi_cmd {
>  	/* R2T List */
>  	struct list_head	cmd_r2t_list;
>  	struct completion	reject_comp;
> -	/* Semaphore used for allocating buffer */
> -	struct completion	unsolicited_data_comp;
>  	/* Timer for DataOUT */
>  	struct timer_list	dataout_timer;
>  	/* Iovecs for SCSI data payload RX/TX w/ kernel level sockets */
> diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
> index 79d3b6e..c6219e5 100644
> --- a/drivers/target/iscsi/iscsi_target_util.c
> +++ b/drivers/target/iscsi/iscsi_target_util.c
> @@ -153,7 +153,6 @@ struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *conn, gfp_t gfp_mask)
>  	INIT_LIST_HEAD(&cmd->datain_list);
>  	INIT_LIST_HEAD(&cmd->cmd_r2t_list);
>  	init_completion(&cmd->reject_comp);
> -	init_completion(&cmd->unsolicited_data_comp);
>  	spin_lock_init(&cmd->datain_lock);
>  	spin_lock_init(&cmd->dataout_timeout_lock);
>  	spin_lock_init(&cmd->istate_lock);
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 3c2c74f..7759404 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -4715,7 +4715,7 @@ static int transport_new_cmd(struct se_cmd *cmd)
>  	}
>  
>  	/*
> -	 * For WRITEs, let the iSCSI Target RX Thread know its buffer is ready..
> +	 * For WRITEs, let the fabric know its buffer is ready..
>  	 * This WRITE struct se_cmd (and all of its associated struct se_task's)
>  	 * will be added to the struct se_device execution queue after its WRITE
>  	 * data has arrived. (ie: It gets handled by the transport processing
> -- 
> 1.7.1
> 

