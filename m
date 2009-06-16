From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: PATCH: PMC-Sierra MaxRAID driver to support 6Gb/s SAS RAID controller
Date: Tue, 16 Jun 2009 11:48:29 -0700
Message-ID: <4A37E8FD.2090404@oracle.com>
References: <alpine.LNX.1.10.0906161019300.6270@rslab159.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:37355 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523AbZFPSwD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2009 14:52:03 -0400
In-Reply-To: <alpine.LNX.1.10.0906161019300.6270@rslab159.pmc-sierra.bc.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, gregkh@suse.de

Anil Ravindranath wrote:
> Hi,

Hi,

> diff -urN -x scsi-misc-2.6.orig/Documentation/dontdiff scsi-misc-2.6.orig//MAINTAINERS scsi-misc-2.6//MAINTAINERS
> --- scsi-misc-2.6.orig//MAINTAINERS	2009-06-07 23:44:50.000000000 -0700
> +++ scsi-misc-2.6//MAINTAINERS	2009-06-08 03:55:03.000000000 -0700
> @@ -6377,6 +6377,14 @@
>  S:	Maintained
>  F:	drivers/serial/zs.*
>  
> +PMC SIERRA MaxRAID DRIVER
> +P:	Anil Ravindranath
> +M:	anil_ravindranath@pmc-sierra.com
> +L:	linux-scsi@vger.kernel.org
> +W:	http://www.pmc-sierra.com/
> +S:	Supported
> +F:	drivers/scsi/pmcraid.*
> +

MAINTAINERS is meant to be listed in alpha order by SUBJECT (PMC SIERRA e.g.).

>  THE REST
>  P:	Linus Torvalds
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

> diff -urN -x scsi-misc-2.6.orig/Documentation/dontdiff scsi-misc-2.6.orig//drivers/scsi/pmcraid.c scsi-misc-2.6//drivers/scsi/pmcraid.c
> --- scsi-misc-2.6.orig//drivers/scsi/pmcraid.c	1969-12-31 16:00:00.000000000 -0800
> +++ scsi-misc-2.6//drivers/scsi/pmcraid.c	2009-06-16 09:58:00.000000000 -0700
> @@ -0,0 +1,5450 @@

> +/**
> + * pmcraid_slave_alloc - Prepare for commands to a device
> + * @sdev: scsi device struct

s/sdev/scsi_dev/

> + *
> + * This function is called by mid-layer prior to sending any command to the new
> + * device. Stores resource entry details of the device in scsi_device struct.
> + * Queuecommand uses the resource handle and other details to fill up IOARCB
> + * while sending commands to the device. It also sets sync_reqd flag on this
> + * resource to ensure that the first command to the device always goes with
> + * SYNC_COMPLETE flag set.
> + *
> + * Return value:
> + *	  0 on success / -ENXIO if device does not exist
> + **/
> +static int pmcraid_slave_alloc(struct scsi_device *scsi_dev)
> +{
> +	struct pmcraid_resource_entry *temp, *res = NULL;
> +	struct pmcraid_instance *pinstance;
> +	u8 target, bus, lun;
> +	unsigned long lock_flags;
> +	int rc = -ENXIO;
> +
> +	pinstance = shost_priv(scsi_dev->host);
> +
> +	/* Driver exposes VSET and GSCSI resources only; all other device types
> +	 * are not exposed. Resource list is synchronized using resource lock
> +	 * so any traversal or modifications to the list should be done inside
> +	 * this lock
> +	 */

Long comments should be formatted like so:

	/*
	 * foo
	 * bar
	 * blah
	 */

> +	spin_lock_irqsave(&pinstance->resource_lock, lock_flags);
> +}



> +/**
> + * pmcraid_init_cmdblk - re-initializes a command block
> + *
> + * @cmd : pointer to struct pmcraid_cmd to be initialized

Missing @index: and description of it.

> + *
> + * Return Value
> + *	 None
> + */
> +
> +void pmcraid_init_cmdblk(struct pmcraid_cmd *cmd, int index)
> +{
> +	struct pmcraid_ioarcb *ioarcb = &(cmd->ioa_cb->ioarcb);
> +	dma_addr_t dma_addr = cmd->ioa_cb_bus_addr;
> +
> +	if (index >= 0) {
> +		/* first time initialization (called from  probe) */
> +		u32 ioasa_offset =
> +			offsetof(struct pmcraid_control_block, ioasa);
> +
> +		cmd->index = index;
> +		ioarcb->response_handle = cpu_to_le32(index << 2);
> +		ioarcb->ioarcb_bus_addr = cpu_to_le64(dma_addr);
> +		ioarcb->ioasa_bus_addr = cpu_to_le64(dma_addr + ioasa_offset);
> +		ioarcb->ioasa_len = cpu_to_le16(sizeof(struct pmcraid_ioasa));
> +	} else {
> +		/* re-initialization of various lengths, called once command is
> +		 * processed by IOA
> +		 */
> +		memset(&cmd->ioa_cb->ioarcb.cdb, 0, PMCRAID_MAX_CDB_LEN);
> +		ioarcb->request_flags0 = 0;
> +		ioarcb->request_flags1 = 0;
> +		ioarcb->cmd_timeout = 0;
> +
> +		/* based on required number of ioadls driver uses IOADL list
> +		 * allocated as part of IOARCB or list allocated as part of
> +		 * pmcraid_control_block. By default initialize ioadl_bus_addr
> +		 * to the list that is part of pmcraid_ioarcb itself
> +		 */
> +		ioarcb->ioarcb_bus_addr &= (~0x1FULL);
> +		ioarcb->ioadl_bus_addr = 0;
> +		ioarcb->ioadl_length = 0;
> +
> +		ioarcb->data_transfer_length = 0;
> +		ioarcb->add_cmd_param_length = 0;
> +		ioarcb->add_cmd_param_offset = 0;
> +		cmd->ioa_cb->ioasa.ioasc = 0;
> +		cmd->ioa_cb->ioasa.residual_data_length = 0;
> +	}
> +
> +	cmd->cmd_done = NULL;
> +	cmd->scsi_cmd = NULL;
> +	cmd->release = 0;
> +	cmd->completion_req = 0;
> +	cmd->dma_handle = 0;
> +	init_timer(&cmd->timer);
> +}
> +

> +/**
> + * pmcraid_disable_interrupts - Masks and clears all specified interrupts
> + *
> + * @pinstance: pointer to per adapter instance structure
> + * @intr: interrupts to disable

s/intr/intrs/


> +static void pmcraid_disable_interrupts(
> +	struct pmcraid_instance *pinstance,
> +	u32 intrs
> +)
> +{
> +	u32 gmask = ioread32(pinstance->int_regs.global_interrupt_mask_reg);
> +	u32 nmask = gmask | GLOBAL_INTERRUPT_MASK;
> +
> +	iowrite32(nmask, pinstance->int_regs.global_interrupt_mask_reg);
> +	iowrite32(intrs, pinstance->int_regs.ioa_host_interrupt_clr_reg);
> +	iowrite32(intrs, pinstance->int_regs.ioa_host_interrupt_mask_reg);
> +	ioread32(pinstance->int_regs.ioa_host_interrupt_mask_reg);
> +}
> +
> +/**
> + * pmcraid_enable_interrupts - Enables specified interrupts
> + *
> + * @pinstance: pointer to per adapter instance structure
> + * @intr: interrupts to enable

s/intr/intrs/


> + *
> + * Return Value
> + *	 None
> + */
> +static void pmcraid_enable_interrupts(
> +	struct pmcraid_instance *pinstance,
> +	u32 intrs
> +)
> +{
> +	u32 gmask = ioread32(pinstance->int_regs.global_interrupt_mask_reg);
> +	u32 nmask = gmask & (~GLOBAL_INTERRUPT_MASK);
> +
> +	iowrite32(nmask, pinstance->int_regs.global_interrupt_mask_reg);
> +
> +	iowrite32(intrs, pinstance->int_regs.ioa_host_interrupt_mask_clr_reg);
> +
> +	pmcraid_info("enabled interrupts mask = %x mask_clr = %x\n",
> +		ioread32(pinstance->int_regs.ioa_host_interrupt_mask_reg),
> +		ioread32(pinstance->int_regs.ioa_host_interrupt_mask_clr_reg));
> +}
> +
> +
> +/**
> + * pmcraid_reset_type - Determine the required reset type
> + * @pinstnace : pointer to adapter instance structure

typo (pinstance)

> + *
> + * IOA requires hard reset if any of the following conditions is true.
> + * 1. If HRRQ valid interrupt is not masked
> + * 2. IOA reset alert doorbell is set
> + * 3. If there are any error interrupts
> + */
> +
> +static void pmcraid_reset_type(struct pmcraid_instance *pinstance)
> +{
> +	u32 mask;
> +	u32 intrs;
> +	u32 alerts;
> +
> +	mask = ioread32(pinstance->int_regs.ioa_host_interrupt_mask_reg);
> +	intrs = ioread32(pinstance->int_regs.ioa_host_interrupt_reg);
> +	alerts = ioread32(pinstance->int_regs.host_ioa_interrupt_reg);
> +
> +	if ((mask & INTRS_HRRQ_VALID) == 0 ||
> +	    (alerts & DOORBELL_IOA_RESET_ALERT) ||
> +	    (intrs & PMCRAID_ERROR_INTERRUPTS)) {
> +		pmcraid_info("IOA requires hard reset\n");
> +		pinstance->ioa_hard_reset = 1;
> +	}
> +
> +	/* If unit check is active, trigger the dump */
> +	if (intrs & INTRS_IOA_UNIT_CHECK)
> +		pinstance->ioa_unit_check = 1;
> +}
> +

> +/**
> + * pmcraid_reset_alert_done - completion routine for reset_alert
> + * @cmd : pointer to command block used in reset sequence
> + * Return value
> + *  None
> + */
> +static void pmcraid_reset_alert_done(struct pmcraid_cmd *cmd)
> +{
> +	struct pmcraid_instance *pinstance = cmd->drv_inst;
> +	u32 status = ioread32(pinstance->ioa_status);
> +	unsigned long flags;
> +
> +	/* if the critical operation in progress bit is set or the wait times
> +	 * out, invoke reset engine to proceed with hard reset. If there is
> +	 * some more time to wait, restart the timer
> +	 */
> +	if ((0 == (status & INTRS_CRITICAL_OP_IN_PROGRESS)) ||

Kernel style preference is for constant value on right side, like:

	if ((status & INTRS_CRITICAL_OP_IN_PROGRESS) == 0)) ||

> +	    cmd->u.time_left <= 0) {
> +		pmcraid_info("critical op is reset proceeding with reset\n");
> +		spin_lock_irqsave(pinstance->host->host_lock, flags);
> +		pmcraid_ioa_reset(cmd);
> +		spin_unlock_irqrestore(pinstance->host->host_lock, flags);
> +	} else {
> +		pmcraid_info("critical op is not yet reset waiting again\n");
> +		/* restart timer if some more time is available to wait */
> +		cmd->u.time_left -= PMCRAID_CHECK_FOR_RESET_TIMEOUT;
> +		cmd->timer.data = (unsigned long)cmd;
> +		cmd->timer.expires = jiffies + PMCRAID_CHECK_FOR_RESET_TIMEOUT;
> +		cmd->timer.function =
> +			(void (*)(unsigned long))pmcraid_reset_alert_done;
> +		add_timer(&cmd->timer);
> +	}
> +}
> +



> +/**
> + * pmcraid_send_cmd - fires a command using host_lock and also sets up timeout
> + *		function, and command completion function

Function name + short description must be on one line.  (sorry about that)
Use a descriptive paragraph below if more is needed.
> + *
> + * @cmd: pointer to the command block to be fired to IOA
> + * @cmd_done: command completion function, called once IOA responds
> + * @timeout: timeout to wait for this command completion
> + * @timeout_func: timeout handler
> + *
> + * Return value
> + *   none
> + */
> +static void pmcraid_send_cmd(
> +	struct pmcraid_cmd *cmd,
> +	void (*cmd_done) (struct pmcraid_cmd *),
> +	unsigned long timeout,
> +	void (*timeout_func) (struct pmcraid_cmd *)
> +)
> +{
> +	/* initialize done function */
> +	cmd->cmd_done = cmd_done;
> +
> +	if (timeout_func) {
> +		/* setup timeout handler */
> +		cmd->timer.data = (unsigned long)cmd;
> +		cmd->timer.expires = jiffies + timeout;
> +		cmd->timer.function = (void (*)(unsigned long))timeout_func;
> +		add_timer(&cmd->timer);
> +	}
> +
> +	/* fire the command to IOA */
> +	_pmcraid_fire_command(cmd, 1);
> +}
> +
> +/**
> + * pmcraid_ioa_shutdown - sends SHUTDOWN command to ioa and participates
> + *			  in reset sequence

Ditto.

> + * @cmd: pointer to the command block used as part of reset sequence
> + * @type: type of shutdown to perform

No type parameter.

> + *
> + * Return Value
> + *  None
> + */
> +static void pmcraid_ioa_shutdown(struct pmcraid_cmd *cmd)
> +{
> +	/* Note that commands sent during reset require next command to be sent
> +	 * to IOA. Hence setup the done function as well as timeout function
> +	 */
> +	pmcraid_reinit_cmdblk(cmd);
> +
> +	cmd->ioa_cb->ioarcb.request_type = REQ_TYPE_IOACMD;
> +	cmd->ioa_cb->ioarcb.resource_handle =
> +		cpu_to_le32(PMCRAID_IOA_RES_HANDLE);
> +	cmd->ioa_cb->ioarcb.cdb[0] = PMCRAID_IOA_SHUTDOWN;
> +	cmd->ioa_cb->ioarcb.cdb[1] = PMCRAID_SHUTDOWN_NORMAL;
> +
> +	/* fire shutdown command to hardware. */
> +	pmcraid_info("firing normal shutdown command (%d) to IOA\n",
> +		     le32_to_cpu(cmd->ioa_cb->ioarcb.response_handle));
> +
> +	pmcraid_send_cmd(cmd, pmcraid_ioa_reset,
> +			 PMCRAID_SHUTDOWN_TIMEOUT,
> +			 pmcraid_timeout_handler);
> +}
> +
> +/* pmcraid_complete_ioa_reset: Called by either timer or tasklet during
> + * 	                       completion of the ioa reset

One line and function name separator is '-', not ':'.
But I do appreciate you adding the function documentation.


> + * @cmd : pointer to reset command block
> + */
> +static void pmcraid_complete_ioa_reset(struct pmcraid_cmd *cmd)
> +{
> +	struct pmcraid_instance *pinstance = cmd->drv_inst;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(pinstance->host->host_lock, flags);
> +	pmcraid_ioa_reset(cmd);
> +	spin_unlock_irqrestore(pinstance->host->host_lock, flags);
> +	scsi_unblock_requests(pinstance->host);
> +}
> +


> +/**
> + * pmcraid_identify_hrrq - registers host rrq buffers with IOA
> + * @pinstance  : pointer to adapter instance structure

Function parameter is cmd, not pinstance.

> + *
> + * Return Value
> + *	 0 in case of success, otherwise non-zero failure code
> + */
> +static void pmcraid_identify_hrrq(struct pmcraid_cmd *cmd)
> +{
> +	struct pmcraid_instance *pinstance = cmd->drv_inst;
> +	struct pmcraid_ioarcb *ioarcb = &cmd->ioa_cb->ioarcb;
> +	int index = 0;
> +	unsigned long hrrq_addr = pinstance->hrrq_start_bus_addr[index];
> +	u32 hrrq_size = cpu_to_be32(sizeof(u32) * PMCRAID_MAX_CMD);
> +
> +	pmcraid_reinit_cmdblk(cmd);
> +
> +	/* Initialize ioarcb */
> +	ioarcb->request_type = REQ_TYPE_IOACMD;
> +	ioarcb->resource_handle = cpu_to_le32(PMCRAID_IOA_RES_HANDLE);
> +
> +	/* initialize the hrrq number where IOA will respond to this command */
> +	ioarcb->hrrq_id = index;
> +	ioarcb->cdb[0] = PMCRAID_IDENTIFY_HRRQ;
> +	ioarcb->cdb[1] = index;
> +
> +	/* If the dma_addr is 64-bit (i.e. in case of 64-bit platforms or
> +	 * CONFIG_HIGHMEM64G otherwise it is 32-bit value. IOA expects 64-bit
> +	 * pci address to be written in B.E format (i.e cdb[2]=MSB..cdb[9]=LSB.
> +	 */
> +	ioarcb->cdb[2] = hrrq_addr >> 24 & 0xFF;
> +	ioarcb->cdb[3] = hrrq_addr >> 16 & 0xFF;
> +	ioarcb->cdb[4] = hrrq_addr >> 8 & 0xFF;
> +	ioarcb->cdb[5] = hrrq_addr & 0xFF;
> +
> +	memcpy(&(ioarcb->cdb[10]), &hrrq_size, sizeof(hrrq_size));
> +
> +	pmcraid_info("HRRQ_IDENTIFY with hrrq:ioarcb => %lx:%llx\n",
> +		     hrrq_addr, ioarcb->ioarcb_bus_addr);
> +
> +	/* Subsequent commands require HRRQ identification to be successful.
> +	 * Note that this gets called even during reset from SCSI mid-layer
> +	 * or tasklet
> +	 */
> +	pmcraid_send_cmd(cmd, pmcraid_querycfg,
> +			 PMCRAID_INTERNAL_TIMEOUT,
> +			 pmcraid_timeout_handler);
> +}
> +
> +static void pmcraid_process_ccn(struct pmcraid_cmd *cmd);
> +static void pmcraid_process_ldn(struct pmcraid_cmd *cmd);
> +
> +/* pmcraid_send_hcam_cmd - send an initialized command block(HCAM) to IOA

/**
 * pmcraid_send_hcam_cmd - send an initialized command block(HCAM) to IOA

> + *
> + * @cmd : initialized command block pointer
> + *
> + * Return Value
> + *   none
> + */
> +static void pmcraid_send_hcam_cmd(struct pmcraid_cmd *cmd)
> +{
> +	/* Invalidate the previous data as the buffers will be re-used by IOA
> +	 * for DMA
> +	 */
> +	if (cmd->ioa_cb->ioarcb.cdb[1] == PMCRAID_HCAM_CODE_CONFIG_CHANGE) {
> +		atomic_set(&(cmd->drv_inst->ccn.valid), 0);
> +		atomic_set(&(cmd->drv_inst->ccn.ignore), 0);
> +	} else {
> +		atomic_set(&(cmd->drv_inst->ldn.valid), 0);
> +		atomic_set(&(cmd->drv_inst->ldn.ignore), 0);
> +	}
> +
> +	pmcraid_send_cmd(cmd, cmd->cmd_done, 0, NULL);
> +}
> +
> +/*
> + * pmcraid_send_hcam_locked : send an hcam command with host_lock held

s/ : / - /

> + * @cmd : pointer to hcam command to be sent
> + *
> + * This is wrapper over pmcraid_send_hcam_cmd, and used after ioa reset
> + */
> +static void pmcraid_send_hcam_locked(struct pmcraid_cmd *cmd)
> +{
> +	unsigned long flags;
> +	spin_lock_irqsave(cmd->drv_inst->host->host_lock, flags);
> +	pmcraid_send_hcam_cmd(cmd);
> +	spin_unlock_irqrestore(cmd->drv_inst->host->host_lock, flags);
> +}
> +
> +/* pmcraid_init_hcam - send an initialized command block(HCAM) to IOA

/**
 * pmcraid_init_hcam - send an initialized command block(HCAM) to IOA

> + *
> + * @pinstance: pointer to adapter instance structure
> + * @type: HCAM type
> + *
> + * Return Value
> + *   pointer to initialized pmcraid_cmd structure or NULL
> + */
> +static struct pmcraid_cmd *pmcraid_init_hcam
> +(
> +	struct pmcraid_instance *pinstance,
> +	u8 type
> +)
> +{

> +}


> +/**
> + * pmcraid_initiate_reset - initiates reset sequence. This is called from
> + * ISR/tasklet during error interrupts including IOA unit check. If reset
> + * is already in progress, it just returns, otherwise initiates IOA reset
> + * to bring IOA up to operational state.
> + *

kernel-doc format is

/**
 * function_name - short description on one line
 * @params:
 *
 * More description if needed.

> + * @pinstance : pointer to adapter instance structure
> + *
> + * Return value
> + *	 none
> + */
> +static void pmcraid_initiate_reset(struct pmcraid_instance *pinstance)
> +{
> +	struct pmcraid_cmd *cmd;
> +
> +	/* If the reset is already in progress, just return, otherwise start
> +	 * reset sequence and return
> +	 */
> +	if (!pinstance->ioa_reset_in_progress) {
> +		scsi_block_requests(pinstance->host);
> +		cmd = pmcraid_get_free_cmd(pinstance);
> +		if (cmd == NULL) {
> +			pmcraid_err("No cmd blocks are available for reset\n");
> +			return;
> +		}
> +		pinstance->ioa_shutdown_type = SHUTDOWN_NONE;
> +		pinstance->ioa_reset_in_progress = 1;
> +		pinstance->reset_cmd = cmd;
> +		pinstance->ioa_state = IOA_STATE_IN_RESET_ALERT;
> +		pmcraid_reset_alert(cmd);
> +	}
> +}
> +
> +/*

/**

> + * pmcraid_process_ldn - op done function for an LDN
> + * @cmd : pointer to command block
> + *
> + * Return value
> + *   none
> + */
> +static void pmcraid_process_ldn(struct pmcraid_cmd *cmd)
> +{

> +}
> +

> +/**
> + * pmcraid_soft_reset - performs a soft reset and makes IOA become ready
> + * @cmd : pointer to reset command block
> + * Return Value: none
> + */

End of comments for now.  (out of time; large source file)

> +static void pmcraid_soft_reset(struct pmcraid_cmd *cmd)
> +{
> +}

-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
