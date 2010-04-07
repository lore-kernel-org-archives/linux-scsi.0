From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 08/12] qla4xxx: added support for abort task management
 command
Date: Tue, 06 Apr 2010 23:34:07 -0500
Message-ID: <4BBC0B3F.9000009@cs.wisc.edu>
References: <20100406101423.GO22922@linux-qf4p>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39279 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab0DGE3x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Apr 2010 00:29:53 -0400
In-Reply-To: <20100406101423.GO22922@linux-qf4p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: James Bottomley <james.bottomley@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>

On 04/06/2010 05:14 AM, Ravi Anand wrote:
> From: Vikas Chaudhary<vikas.chaudhary@qlogic.com>
>
> Handles SCSI aborts.
>
> Signed-off-by: Karen Higgins<karen.higgins@qlogic.com>
> Signed-off-by: Vikas Chaudhary<vikas.chaudhary@qlogic.com>
> Signed-off-by: Ravi Anand<ravi.anand@qlogic.com>
> ---
>   drivers/scsi/qla4xxx/ql4_fw.h   |    1 +
>   drivers/scsi/qla4xxx/ql4_glbl.h |    1 +
>   drivers/scsi/qla4xxx/ql4_mbx.c  |   49 +++++++++++++++++
>   drivers/scsi/qla4xxx/ql4_os.c   |  112 +++++++++++++++++++++++++++++++++++++++
>   4 files changed, 163 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
> index dfe7b4d..855226e 100644
> --- a/drivers/scsi/qla4xxx/ql4_fw.h
> +++ b/drivers/scsi/qla4xxx/ql4_fw.h
> @@ -215,6 +215,7 @@ union external_hw_config_reg {
>   /*  Mailbox command definitions */
>   #define MBOX_CMD_ABOUT_FW			0x0009
>   #define MBOX_CMD_PING				0x000B
> +#define MBOX_CMD_ABORT_TASK			0x0015
>   #define MBOX_CMD_LUN_RESET			0x0016
>   #define MBOX_CMD_TARGET_WARM_RESET		0x0017
>   #define MBOX_CMD_GET_MANAGEMENT_DATA		0x001E
> diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
> index 987658f..3c8f753 100644
> --- a/drivers/scsi/qla4xxx/ql4_glbl.h
> +++ b/drivers/scsi/qla4xxx/ql4_glbl.h
> @@ -25,6 +25,7 @@ void qla4xxx_process_aen(struct scsi_qla_host * ha, uint8_t process_aen);
>   int qla4xxx_get_dhcp_ip_address(struct scsi_qla_host * ha);
>   int qla4xxx_relogin_device(struct scsi_qla_host * ha,
>   			   struct ddb_entry * ddb_entry);
> +int qla4xxx_abort_task(struct scsi_qla_host *ha, struct srb *srb);
>   int qla4xxx_reset_lun(struct scsi_qla_host * ha, struct ddb_entry * ddb_entry,
>   		      int lun);
>   int qla4xxx_reset_target(struct scsi_qla_host * ha,
> diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
> index 12e17a3..ad073a6 100644
> --- a/drivers/scsi/qla4xxx/ql4_mbx.c
> +++ b/drivers/scsi/qla4xxx/ql4_mbx.c
> @@ -762,6 +762,55 @@ exit_get_event_log:
>   }
>
>   /**
> + * qla4xxx_abort_task - issues Abort Task
> + * @ha: Pointer to host adapter structure.
> + * @srb: Pointer to srb entry
> + *
> + * This routine performs a LUN RESET on the specified target/lun.
> + * The caller must ensure that the ddb_entry and lun_entry pointers
> + * are valid before calling this routine.
> + **/
> +int qla4xxx_abort_task(struct scsi_qla_host *ha, struct srb *srb)
> +{
> +	uint32_t mbox_cmd[MBOX_REG_COUNT];
> +	uint32_t mbox_sts[MBOX_REG_COUNT];
> +	struct scsi_cmnd *cmd = srb->cmd;
> +	int status = QLA_SUCCESS;
> +
> +	DEBUG2(printk(KERN_INFO "scsi%ld:%d:%d:%d: abort task issued\n",
> +			ha->host_no, cmd->device->channel, cmd->device->id,
> +			cmd->device->lun));
> +
> +	/*
> +	 * Send abort task command to ISP, so that the ISP will return
> +	 * request with ABORT status
> +	 */
> +	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
> +	memset(&mbox_sts, 0, sizeof(mbox_sts));
> +
> +	mbox_cmd[0] = MBOX_CMD_ABORT_TASK;
> +	mbox_cmd[1] = srb->fw_ddb_index;
> +	mbox_cmd[2] = (unsigned long)(unsigned char *)cmd->host_scribble;
> +	mbox_cmd[5] = 0x01;     /* Immediate Command Enable */
> +
> +	qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 5,&mbox_cmd[0],
> +				&mbox_sts[0]);
> +	if (mbox_sts[0] != MBOX_STS_COMMAND_COMPLETE) {
> +		status = QLA_ERROR;
> +
> +		DEBUG2(printk(KERN_WARNING "scsi%ld:%d:%d:%d: abort task "
> +				"FAILED: ", ha->host_no, cmd->device->channel,
> +				cmd->device->id, cmd->device->lun));
> +		DEBUG2(printk(KERN_WARNING "mbx0=%04X, mb1=%04X, mb2=%04X,"
> +				" mb3=%04X, mb4=%04X\n", mbox_sts[0],
> +				mbox_sts[1], mbox_sts[2], mbox_sts[3],
> +				mbox_sts[4]));
> +	}
> +
> +	return status;
> +}
> +
> +/**
>    * qla4xxx_reset_lun - issues LUN Reset
>    * @ha: Pointer to host adapter structure.
>    * @db_entry: Pointer to device database entry
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index ca1d293..2ca5659 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -73,6 +73,7 @@ static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc);
>    */
>   static int qla4xxx_queuecommand(struct scsi_cmnd *cmd,
>   				void (*done) (struct scsi_cmnd *));
> +static int qla4xxx_eh_abort(struct scsi_cmnd *cmd);
>   static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd);
>   static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd);
>   static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd);
> @@ -87,6 +88,7 @@ static struct scsi_host_template qla4xxx_driver_template = {
>   	.proc_name		= DRIVER_NAME,
>   	.queuecommand		= qla4xxx_queuecommand,
>
> +	.eh_abort_handler	= qla4xxx_eh_abort,
>   	.eh_device_reset_handler = qla4xxx_eh_device_reset,
>   	.eh_target_reset_handler = qla4xxx_eh_target_reset,
>   	.eh_host_reset_handler	= qla4xxx_eh_host_reset,
> @@ -1579,6 +1581,116 @@ static int qla4xxx_eh_wait_for_commands(struct scsi_qla_host *ha,
>   }
>
>   /**
> + * qla4xxx_eh_abort - callback for abort task.
> + * @cmd: Pointer to Linux's SCSI command structure
> + *
> + * This routine is called by the Linux OS to abort the specified
> + * command.
> + **/
> +static int qla4xxx_eh_abort(struct scsi_cmnd *cmd)
> +{
> +	struct scsi_qla_host *ha;
> +	struct srb *srb = NULL;
> +	struct ddb_entry *ddb_entry;
> +	struct scsi_cmnd *srb_cmd = NULL;
> +	int ret = FAILED;
> +	unsigned int channel;
> +	unsigned int id;
> +	unsigned int lun;
> +	unsigned long serial;
> +	unsigned long flags = 0;
> +	int i = 0;
> +
> +	if (cmd == NULL) {
> +		DEBUG2(printk(KERN_INFO "ABORT - **** SCSI mid-layer passing"
> +				" in NULL cmd\n"));
> +		return SUCCESS;
> +	}


Are you hitting this null scsi cmd case?


> +
> +	ha = to_qla_host(cmd->device->host);
> +	ddb_entry = cmd->device->hostdata;
> +	channel = cmd->device->channel;
> +	id = cmd->device->id;
> +	lun = cmd->device->lun;
> +	serial = cmd->serial_number;
> +
> +	if (!ddb_entry) {
> +		DEBUG2(printk(KERN_WARNING "scsi%ld: ABORT - NULL ddb entry.\n",
> +				ha->host_no));
> +		return FAILED;
> +	}
> +
> +	if (!cmd->SCp.ptr) {
> +		DEBUG2(printk(KERN_INFO "scsi%ld: ABORT - cmd already"
> +				" completed.\n", ha->host_no));
> +		return SUCCESS;
> +	}
> +
> +	srb = (struct srb *) cmd->SCp.ptr;

You do not need this do you? You never really use it. It seems to only 
be used to print a refcount that is never used.


> +
> +	dev_info(&ha->pdev->dev, "scsi%ld:%d:%d:%d: ABORT ISSUED "
> +		 "cmd=%p, pid=%ld, ref=%d\n", ha->host_no, channel, id, lun,
> +		 cmd, serial, atomic_read(&srb->ref_count));
> +
> +	if (qla4xxx_wait_for_hba_online(ha) != QLA_SUCCESS) {
> +		DEBUG2(printk(KERN_WARNING "scsi%ld:%d: %s: Unable to abort "
> +				"task. Adapter DEAD.\n", ha->host_no,
> +				cmd->device->channel, __func__));
> +		return FAILED;
> +	}



If the adapter went down, do you need to abort commands? If the adapter 
goes down does it fail all the running commands, or do you still need to 
do a an abort to clean them up in firmware?

Or if the adapter goes down does it fail the running sessions, which 
would fail the commands if doing erl0. And in that case we would not 
need to abort them.




> +
> +	/* Check active list for command */
> +	spin_lock_irqsave(&ha->hardware_lock, flags);
> +	for (i = 1; i<  MAX_SRBS; i++) {


Why loop? Can't you grab the hardware lock then check if tcmd->SCp.ptr 
and cmd->host_scribble is set? If it is then it should be your srb in 
the host_scribble right?
