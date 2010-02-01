From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 10/11] qla4xxx: added support for abort task management
 command
Date: Mon, 01 Feb 2010 12:53:35 -0600
Message-ID: <4B67232F.2020304@cs.wisc.edu>
References: <20100130062934.GK10274@linux-qf4p>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50037 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164Ab0BASx4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Feb 2010 13:53:56 -0500
In-Reply-To: <20100130062934.GK10274@linux-qf4p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: James Bottomley <james.bottomley@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Karen Higgins <karen.higgins@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>

On 01/30/2010 12:29 AM, Ravi Anand wrote:
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
> +	int ret = SUCCESS;
> +	unsigned int channel;
> +	unsigned int id;
> +	unsigned int lun;
> +	unsigned long serial;
> +	unsigned long flags = 0;
> +	int i = 0;
> +	int got_ref = 0;
> +	unsigned long wait_online;
> +
> +	if (cmd == NULL) {
> +		DEBUG2(printk("ABORT - **** SCSI mid-layer passing in NULL cmd\n"));
> +		return SUCCESS;
> +	}
> +
> +	ha = to_qla_host(cmd->device->host);
> +	ddb_entry = cmd->device->hostdata;
> +	channel = cmd->device->channel;
> +	id = cmd->device->id;
> +	lun = cmd->device->lun;
> +	serial = cmd->serial_number;
> +
> +	if (!ddb_entry) {
> +		DEBUG2(printk("scsi%ld: ABORT - NULL ddb entry.\n", ha->host_no));
> +		return FAILED;
> +	}
> +
> +	if (!cmd->SCp.ptr) {
> +		DEBUG2(printk("scsi%ld: ABORT - cmd already completed.\n",
> +			      ha->host_no));
> +		return ret;


Not a big deal, but a couple lines above you keep switching between 
using ret or SUCCESS/FAILED. In the cmd == NULL check you use SUCESS. 
Here is use ret, but ret is never changed. Not a big deal, but harder to 
read, because we have to double check if we missed ret getting changed 
since we keep switching back and forth using it.



> +	}
> +
> +
> +
> +	srb = (struct srb *) cmd->SCp.ptr;
> +
> +	dev_info(&ha->pdev->dev, "scsi%ld:%d:%d:%d: ABORT ISSUED "
> +		 "cmd=%p, pid=%ld, ref=%d\n", ha->host_no, channel, id, lun,
> +		 cmd, serial, atomic_read(&srb->ref_count));
> +
> +	if (qla4xxx_wait_for_hba_online(ha) != QLA_SUCCESS) {
> +		DEBUG2(printk("scsi%ld:%d: %s: Unable to abort task. Adapter "
> +				"DEAD.\n", ha->host_no, cmd->device->channel
> +				, __func__));
> +
> +		return FAILED;
> +	}
> +
> +	/* Check active list for command */
> +	spin_lock_irqsave(&ha->hardware_lock, flags);
> +	for (i = 1; i<  MAX_SRBS; i++) {
> +		srb_cmd = scsi_host_find_tag(ha->host, i);
> +		if (srb_cmd == NULL)
> +			continue;
> +
> +		srb = (struct srb *)srb_cmd->host_scribble;
> +		if (srb == NULL)
> +			continue;
> +
> +		if (srb->cmd != cmd)
> +			continue;
> +
> +		DEBUG2(printk("scsi%ld:%d:%d:%d %s: aborting srb %p from RISC. "
> +			      "pid=%ld.\n", ha->host_no, channel, id, lun,
> +			      __func__, srb, serial));
> +		DEBUG3(qla4xxx_print_scsi_cmd(cmd));
> +
> +		/* Get a reference to the sp and drop the lock.*/
> +		sp_get(srb);
> +		got_ref++;
> +
> +		spin_unlock_irqrestore(&ha->hardware_lock, flags);
> +
> +		/*
> +		 * If device is not online wait for 10 sec for device to come online,
> +		 * else return error and do not issue abort task.
> +		 */
> +		if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
> +			wait_online = jiffies + (DEVICE_ONLINE_TOV * HZ);
> +			while (time_before(jiffies, wait_online)) {
> +				set_current_state(TASK_INTERRUPTIBLE);
> +				schedule_timeout(HZ);
> +				if (atomic_read(&ddb_entry->state) == DDB_STATE_ONLINE)
> +					break;
> +			}
> +			if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
> +				DEBUG2(printk("scsi%ld:%d: %s: Unable to abort task."
> +						"Device is not online.\n", ha->host_no
> +						, cmd->device->channel, __func__));
> +
> +				return FAILED;
> +			}
> +		}

Does the abort command for your card do a abort task tmf and do some 
firmware cleanup?

If the session is went down, and it is now back up, do you have to send 
a abort to the firmware? In other places, like for a ddb changed or link 
down handling, you do not do that.

For iscsi in erl0, the tasks are wiped out when you relogin, so if you 
went from ddb state non online to online, there is no point in sending 
the tmf to the target since the relogin had the same clearing effects.

If you need to send this to clear up some firmware stuff, then it seems 
like you have a bug in the other paths when the session does offline (it 
does not like we are sending a abort to the card there).

If you do not need to send a abort for firmware cleanup, and if doing 
erl0, then it is fastest to just escalate to the target reset callout 
for this case. We can wait just once there instead of waiting 10 secs * 
num_commands.
