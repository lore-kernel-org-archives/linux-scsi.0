From: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Subject: Re: PATCH: PMC-Sierra MaxRAID driver to support 6Gb/s SAS RAID
 controller
Date: Thu, 11 Jun 2009 23:06:31 -0700 (PDT)
Message-ID: <alpine.LNX.1.10.0906112303240.18082@rslab159.pmc-sierra.bc.ca>
References: <alpine.LNX.1.10.0906101259500.24722@rslab159.pmc-sierra.bc.ca> <4A31319C.605@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:50437 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751830AbZFLGrp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jun 2009 02:47:45 -0400
In-Reply-To: <4A31319C.605@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, gregkh@suse.de

Brian,

Thanks for all your inputs. I will look into it and get back to you with 
an updated patch soon.

with regards,
   Anil

On Thu, 11 Jun 2009, Brian King wrote:

> Anil Ravindranath wrote:
> > +/*
> > + * Supporting user-level control interface through IOCTL commands.
> > + * pmcraid_major - major number to use
> > + * pmcraid_minor - minor number(s) to use
> > + */
> > +static unsigned int pmcraid_major;
> > +static struct class *pmcraid_class;
> > +DECLARE_BITMAP(pmcraid_minor, PMCRAID_MAX_ADAPTERS);
> 
> New IOCTL interfaces are generally not acceptable in a new driver. Some alternative
> interfaces include sysfs, netlink, and debugfs. Refer to the ipr driver for
> an example of avoiding using IOCTLs. Additional comments below on how to
> remove the dependency.
> 
> 
> > +/* Prototype of functions used as part of reset sequence */
> > +static void pmcraid_reset_type(struct pmcraid_instance *);
> > +static void pmcraid_ioa_reset(struct pmcraid_cmd *);
> > +static void pmcraid_ioa_shutdown(struct pmcraid_cmd *, u8 type);
> > +static void pmcraid_reset_alert(struct pmcraid_cmd *);
> > +static void pmcraid_start_bist(struct pmcraid_cmd *);
> > +static void pmcraid_soft_reset(struct pmcraid_cmd *);
> > +static void pmcraid_bist_done(struct pmcraid_cmd *);
> > +static void pmcraid_reset_alert_done(struct pmcraid_cmd *);
> > +
> > +/* These functions retrieve configuration table entries and initialize
> > + * the resource table maintained internally
> > + */
> > +static void pmcraid_querycfg(struct pmcraid_cmd *);
> > +static void pmcraid_init_res_table(struct pmcraid_cmd *);
> > +static void pmcraid_set_supported_devs(struct pmcraid_cmd *);
> > +static void pmcraid_fail_outstanding_cmds(struct pmcraid_instance *);
> 
> Its generally suggested to structure your driver such that you minimize,
> if not avoid having to declare prototypes. Not sure if you can move some functions
> around to reduce the number of prototypes here.
> 
> 
> > +static int pmcraid_slave_alloc(struct scsi_device *scsi_dev)
> > +{
> > +	struct pmcraid_resource_entry *temp, *res = NULL;
> > +	struct pmcraid_instance *pinstance;
> > +	u8 target, bus, lun;
> > +	unsigned long lock_flags;
> > +	int rc = -ENXIO;
> > +
> > +	pinstance = (struct pmcraid_instance *)scsi_dev->host->hostdata;
> > +
> > +	/* Driver exposes VSET and GSCSI resources only; all other device types
> > +	 * are not exposed. Resource list is synchronized using resource lock
> > +	 * so any traversal or modifications to the list should be done inside
> > +	 * this lock
> > +	 */
> > +	spin_lock_irqsave(&pinstance->resource_lock, lock_flags);
> > +	list_for_each_entry(temp, &pinstance->used_res_q, queue) {
> > +
> > +		/* do not expose VSETs with order-ids >= 240 */
> > +		if (RES_IS_VSET(temp->cfg_entry)) {
> > +			target = temp->cfg_entry.unique_flags1;
> > +			if (target >= PMCRAID_MAX_VSET_TARGETS)
> > +				continue;
> > +			bus = PMCRAID_VSET_BUS_ID;
> > +			lun = 0;
> > +		} else if (RES_IS_GSCSI(temp->cfg_entry)) {
> > +			target = RES_TARGET(temp->cfg_entry.resource_address);
> > +			bus = PMCRAID_PHYS_BUS_ID;
> > +			lun = RES_LUN(temp->cfg_entry.resource_address);
> 
> I assume this means this adapter only supports single byte LUNs...
> 
> 
> 
> > +
> > +/**
> > + * pmcraid_slave_destroy - Unconfigure a SCSI device before removing it
> > + *
> > + * @sdev: scsi device struct
> > + *
> > + * This is called by mid-layer before removing a device. Pointer assignments
> > + * done in pmcraid_slave_alloc will be reset to NULL here.
> > + *
> > + * Return value
> > + *   none
> > + **/
> > +static void pmcraid_slave_destroy(struct scsi_device *sdev)
> > +{
> > +	struct pmcraid_resource_entry *res;
> > +
> > +	res = (struct pmcraid_resource_entry *)sdev->hostdata;
> > +
> 
> Don't you need some sort of locking here?
> 
> > +	if (res)
> > +		res->scsi_dev = NULL;
> > +
> > +	sdev->hostdata = NULL;
> > +}
> > +
> 
> 
> > +
> > +/* writing  into a 64-bit iomemory address */
> > +static inline void write64(unsigned long val, void __iomem *addr)
> > +{
> > +	/* write MSBytes first as writing to LSBytes starts IOA DMA. IOARCB
> > +	 * address is always 32-bit as it allocated by pci_alloc_consistent
> > +	 * hence first write is not required
> > +	 */
> > +	/*iowrite32((u32) (val >> 32), (addr + 4)); */
> > +	iowrite32(le32_to_cpu(val), addr);
> 
> Wrapper functions like this that simply wrapper an existing Linux API
> are generally frowned upon, just call the function directly.
> Additionally, shouldn't this be calling writel instead? That's what almost every
> SCSI driver does.
> 
> 
> > +static void _pmcraid_fire_command(struct pmcraid_cmd *cmd, u8 lock)
> > +{
> > +	struct pmcraid_instance *pinstance = cmd->drv_inst;
> > +	unsigned long lock_flags;
> > +
> > +	/* Add this command block to pending cmd pool. We do this prior to
> > +	 * writting IOARCB to ioarrin because IOA might complete the command
> > +	 * by the time we are about to add it to the list. Response handler
> > +	 * (isr/tasklet) looks for cmb block in the pending pending list.
> > +	 */
> > +	spin_lock_irqsave(&pinstance->pending_pool_lock, lock_flags);
> > +	list_add_tail(&cmd->free_list, &pinstance->pending_cmd_pool);
> > +	atomic_inc(&pinstance->outstanding_cmds);
> > +	spin_unlock_irqrestore(&pinstance->pending_pool_lock, lock_flags);
> > +
> > +	/* Mulitple paths (IO path, control path) may be submitting IOARCBs,
> > +	 * hence it is necessary to protect writes to IOA's ioarrin register.
> > +	 * All writes to IOA ioarrin are synchronized with host_lock
> > +	 */
> > +	if (lock)
> > +		spin_lock_irqsave(pinstance->host->host_lock,
> > +				  pinstance->host_lock_flags);
> > +
> > +	/* apply memory barrier */
> > +	mb();
> > +	/* driver writes lower 32-bit value of IOARCB address only */
> > +	write64(cmd->ioa_cb->ioarcb.ioarcb_bus_addr, pinstance->ioarrin);
> > +
> > +	if (lock)
> > +		spin_unlock_irqrestore(pinstance->host->host_lock,
> > +				       pinstance->host_lock_flags);
> 
> Any way to get rid of this lock flag getting passed in?
> 
> 
> > +static void pmcraid_ioa_shutdown(struct pmcraid_cmd *cmd, u8 type)
> > +{
> > +	/* Note that commands sent during reset require next command to be sent
> > +	 * to IOA. Hence setup the done function as well as timeout function
> > +	 */
> > +	pmcraid_reinit_cmdblk(cmd);
> > +
> > +	cmd->ioa_cb->ioarcb.request_type = REQ_TYPE_IOACMD;
> > +	cmd->ioa_cb->ioarcb.resource_handle =
> > +		cpu_to_le32(PMCRAID_IOA_RES_HANDLE);
> > +	cmd->ioa_cb->ioarcb.cdb[0] = PMCRAID_IOA_SHUTDOWN;
> > +	cmd->ioa_cb->ioarcb.cdb[1] =
> > +		(type == SHUTDOWN_ABBREV) ? PMCRAID_SHUTDOWN_ABBREV :
> > +					    PMCRAID_SHUTDOWN_NORMAL;
> > +
> > +	/* fire shutdown command to hardware. */
> > +	pmcraid_info("firing %s shutdown command (%d) to IOA\n",
> > +		     (type == SHUTDOWN_ABBREV) ? "abbrevational" : "normal",
> > +		     le32_to_cpu(cmd->ioa_cb->ioarcb.response_handle));
> > +
> > +	pmcraid_send_cmd(cmd, pmcraid_ioa_reset,
> > +			 PMCRAID_SHUTDOWN_TIMEOUT,
> 
> Did you maybe want a shorter timeout for the abbreviated shutdown?
> 
> > +static void pmcraid_start_bist(struct pmcraid_cmd *cmd)
> > +{
> > +	struct pmcraid_instance *pinstance = cmd->drv_inst;
> > +
> > +	/* proceed with bist and wait for 2 seconds */
> > +	pci_block_user_cfg_access(pinstance->pdev);
> > +	iowrite32(DOORBELL_IOA_START_BIST,
> > +		pinstance->int_regs.host_ioa_interrupt_reg);
> 
> Are you actually running BIST here or some other reset? BIST is typically
> initiated through PCI config space rather than memory space.
> 
> 
> > +
> > +/**
> > + * pmcraid_send_delayed_hcam - Wait for 5 seconds before sending an HCAM to IOA
> > + * @pinstance: ioa config struct
> > + * @type: HCAM type
> > + *
> > + * This function initializes an hcam cmd and registers for a timer to wait for
> > + * 5 seconds, letting apps to read the HCAM data. If timer expires, the timeout
> > + * handler sends and  a Host Controlled Async command to IOA.
> 
> This sounds like what you really want is to use netlink to send these
> sort of events up to userspace.
> 
> 
> > +/**
> > + * pmcraid_handle_config_change - Handle a config change from the adapter
> > + * @pinstance: pointer to per adapter instance structure
> > + *
> > + * Return value:
> > + *  none
> > + **/
> > +static void pmcraid_handle_config_change(struct pmcraid_instance *pinstance)
> > +{
> > +	struct pmcraid_config_table_entry *cfg_entry;
> > +	struct pmcraid_resource_entry *res = NULL;
> > +	u32 new_entry = 1;
> > +	unsigned long lock_flags;
> > +	int rc;
> > +
> > +	cfg_entry = &pinstance->ccn.hcam->u.cfg_entry;
> > +
> > +	pmcraid_info
> > +		("CCN(%x): %x type: %x lost: %x flags: %x res: %x:%x:%x:%x\n",
> > +		 pinstance->ccn.hcam->ilid,
> > +		 pinstance->ccn.hcam->op_code,
> > +		 pinstance->ccn.hcam->notification_type,
> > +		 pinstance->ccn.hcam->notification_lost,
> > +		 pinstance->ccn.hcam->flags,
> > +		 pinstance->host->unique_id,
> > +		 RES_IS_VSET(*cfg_entry) ? PMCRAID_VSET_BUS_ID :
> > +		 (RES_IS_GSCSI(*cfg_entry) ? PMCRAID_PHYS_BUS_ID :
> > +			RES_BUS(cfg_entry->resource_address)),
> > +		 RES_IS_VSET(*cfg_entry) ? cfg_entry->unique_flags1 :
> > +			RES_TARGET(cfg_entry->resource_address),
> > +		 RES_LUN(cfg_entry->resource_address));
> > +
> > +	/* If this resource is not going to be added to mid-layer, just notify
> > +	 * applications and return
> > +	 */
> > +	if (!pmcraid_expose_resource(cfg_entry))
> > +		goto out_notify_apps;
> > +
> > +	spin_lock_irqsave(&pinstance->resource_lock, lock_flags);
> > +	list_for_each_entry(res, &pinstance->used_res_q, queue) {
> > +		rc = memcmp(&res->cfg_entry.resource_address,
> > +			    &cfg_entry->resource_address,
> > +			    sizeof(cfg_entry->resource_address));
> > +		if (!rc) {
> > +			new_entry = 0;
> > +			break;
> > +		}
> > +	}
> > +
> > +	if (new_entry) {
> > +
> > +		/* If there are more number of resources than what driver can
> > +		 * manage, do not notify the applications about the CCN. Just
> > +		 * ignore this notifications and re-register the same HCAM
> > +		 */
> > +		if (list_empty(&pinstance->free_res_q)) {
> > +			spin_unlock_irqrestore(&pinstance->resource_lock,
> > +						lock_flags);
> > +			pmcraid_err("too many resources attached\n");
> > +			pmcraid_send_hcam(pinstance,
> > +					  PMCRAID_HCAM_CODE_CONFIG_CHANGE);
> > +			return;
> > +		}
> > +
> > +		res = list_entry(pinstance->free_res_q.next,
> > +				 struct pmcraid_resource_entry, queue);
> > +
> > +		list_del(&res->queue);
> > +		res->scsi_dev = NULL;
> > +		res->sync_reqd = 1;
> > +		res->reset_progress = 0;
> > +		list_add_tail(&res->queue, &pinstance->used_res_q);
> > +	}
> > +
> > +	memcpy(&res->cfg_entry, cfg_entry,
> > +		sizeof(struct pmcraid_config_table_entry));
> > +
> > +	if (pinstance->ccn.hcam->notification_type ==
> > +	    NOTIFICATION_TYPE_ENTRY_DELETED) {
> > +		if (res->scsi_dev) {
> > +			res->change_detected = RES_CHANGE_DEL;
> > +			res->cfg_entry.resource_handle =
> > +				PMCRAID_INVALID_RES_HANDLE;
> > +			schedule_work(&pinstance->worker_q);
> > +		} else {
> > +			/* This may be one of the non-exposed resources */
> > +			list_move_tail(&res->queue, &pinstance->free_res_q);
> > +		}
> > +	} else if (!res->scsi_dev) {
> > +		res->change_detected = RES_CHANGE_ADD;
> > +		schedule_work(&pinstance->worker_q);
> > +	}
> > +	spin_unlock_irqrestore(&pinstance->resource_lock, lock_flags);
> > +
> > +out_notify_apps:
> > +	/* Notify configuration changes to registered applications.*/
> > +	kill_fasync(&pinstance->aen_queue, SIGIO, POLL_IN);
> 
> Once again, netlink is probably a better way to notify user space apps of
> this sort of thing.
> 
> > +static void pmcraid_handle_error_log(struct pmcraid_instance *pinstance)
> > +{
> > +	u32 ioasc;
> > +
> > +	pmcraid_info
> > +		("LDN(%x): %x type: %x lost: %x flags: %x overlay id: %x\n",
> > +		 pinstance->ldn.hcam->ilid,
> > +		 pinstance->ldn.hcam->op_code,
> > +		 pinstance->ldn.hcam->notification_type,
> > +		 pinstance->ldn.hcam->notification_lost,
> > +		 pinstance->ldn.hcam->flags,
> > +		 pinstance->ldn.hcam->overlay_id);
> > +
> > +	/* log only the errors, no need to log informational log entries */
> > +	if (pinstance->ldn.hcam->notification_type !=
> > +	    NOTIFICATION_TYPE_ERROR_LOG)
> > +		return;
> > +
> > +	if (pinstance->ldn.hcam->notification_lost ==
> > +	    HOSTRCB_NOTIFICATIONS_LOST)
> > +		dev_err(&pinstance->pdev->dev, "Error notifications lost\n");
> > +
> > +	ioasc = le32_to_cpu(pinstance->ldn.hcam->u.error_log.fd_ioasc);
> > +
> > +	if (ioasc == PMCRAID_IOASC_UA_BUS_WAS_RESET ||
> > +		ioasc == PMCRAID_IOASC_UA_BUS_WAS_RESET_BY_OTHER) {
> > +		scsi_report_bus_reset(
> > +			pinstance->host,
> > +			RES_BUS(pinstance->ldn.hcam->u.error_log.fd_ra));
> > +	}
> 
> I don't see anything actually going to the error log here.
> 
> > +
> > +/**
> > + * pmcraid_save_pci_state - save PCI config space following a reset
> > + * @pdev: pointer to adapter instance structure
> > + *
> > + * Return Value
> > + *	PCIBIOS_SUCCESSFUL on success or -EIO on failure
> > + */
> > +static int pmcraid_save_pci_state(struct pmcraid_instance *pinstance)
> > +{
> > +	int rc = -EIO;
> > +	struct pci_dev *pdev = pinstance->pdev;
> > +
> > +	if (pci_save_state(pdev) != PCIBIOS_SUCCESSFUL) {
> > +		pmcraid_err("can't save pci state\n");
> > +		return rc;
> > +	}
> > +
> > +	return 0;
> > +}
> 
> Just call pci_save_state directly
> 
> > +
> > +/**
> > + * pmcraid_restore_pci_state - restore PCI config space following a reset
> > + * @pdev  : pointer to adapter softstate structure
> > + *
> > + * Return Value
> > + *		 PCIBIOS_SUCCESSFUL on success or -EIO on failure
> > + */
> > +static int pmcraid_restore_pci_state(struct pmcraid_instance *pinstance)
> > +{
> > +	int rc = -EIO;
> > +	struct pci_dev *pdev = pinstance->pdev;
> > +
> > +	if (pci_restore_state(pdev) != PCIBIOS_SUCCESSFUL) {
> > +		pmcraid_err("couldn't restore PCI config-space\n");
> > +		return rc;
> > +	}
> > +
> > +	return 0;
> > +}
> 
> Ditto.
> 
> 
> > +static void pmcraid_initiate_reset(struct pmcraid_instance *pinstance)
> > +{
> > +	struct pmcraid_cmd *cmd;
> > +	unsigned long lock_flags;
> > +
> > +	/* If the reset is already in progress, just return, otherwise start
> > +	 * reset sequence and return
> > +	 */
> > +	spin_lock_irqsave(&pinstance->reset_lock, lock_flags);
> > +	if (pinstance->ioa_reset_in_progress) {
> > +		spin_unlock_irqrestore(&pinstance->reset_lock, lock_flags);
> > +	} else {
> > +		spin_unlock_irqrestore(&pinstance->reset_lock, lock_flags);
> 
> This looks wrong. If you need to hold the lock to check ioa_reset_in_progress,
> don't you need to hold it through the next couple of lines of code when you
> initiate the reset? How do you know the state doesn't change while you are
> executing the next few lines of code?
> 
> > +		scsi_block_requests(pinstance->host);
> > +		pinstance->ioa_shutdown_type = SHUTDOWN_NONE;
> > +		cmd = pmcraid_get_free_cmd(pinstance);
> > +		pinstance->reset_cmd = cmd;
> > +		pmcraid_ioa_reset(cmd);
> > +	}
> > +}
> > +
> 
> 
> > +static int pmcraid_error_handler(struct pmcraid_cmd *cmd)
> > +{
> > +	struct scsi_cmnd *scsi_cmd = cmd->scsi_cmd;
> > +	struct pmcraid_resource_entry *res = scsi_cmd->device->hostdata;
> > +	struct pmcraid_instance *pinstance = cmd->drv_inst;
> > +	struct pmcraid_ioasa *ioasa = &cmd->ioa_cb->ioasa;
> > +	u32 ioasc = le32_to_cpu(ioasa->ioasc);
> > +	u32 masked_ioasc = ioasc & PMCRAID_IOASC_SENSE_MASK;
> > +
> > +	if (!res) {
> > +		pmcraid_info("resource pointer is NULL\n");
> > +		return 0;
> > +	}
> 
> There seems to be a fair amount of code here that runs without locks that reads
> and writes shared data structures which has me concerned that you could have
> some very hard to track down bugs in the future...
> 
> > +
> > +	/* If this was a SCSI read/write command keep count of errors */
> > +	if (SCSI_CMD_TYPE(scsi_cmd->cmnd[0]) == SCSI_READ_CMD)
> > +		res->read_failures++;
> > +	else if (SCSI_CMD_TYPE(scsi_cmd->cmnd[0]) == SCSI_WRITE_CMD)
> > +		res->write_failures++;
> 
> These are both getting incremented without locks, which could cause them
> to get corrupted.
> 
> 
> > +static void pmcraid_fail_outstanding_cmds(struct pmcraid_instance *pinstance)
> > +{
> > +	struct pmcraid_cmd *cmd, *temp;
> > +	unsigned long lock_flags;
> > +
> > +	/* pending command list is protected by pending_pool_lock. Its
> > +	 * traversal must be done as within this lock
> > +	 */
> > +	spin_lock_irqsave(&pinstance->pending_pool_lock, lock_flags);
> > +	list_for_each_entry_safe(cmd, temp, &pinstance->pending_cmd_pool,
> > +				 free_list) {
> > +		list_del(&cmd->free_list);
> > +		spin_unlock_irqrestore(&pinstance->pending_pool_lock,
> > +					lock_flags);
> 
> I don't think list_for_each_entry_safe fully protects you here. It only
> allows you to delete an entry within the loop. Since you drop the lock here,
> the next command could end up getting completed by the interrupt handler but
> its still stored as temp here, resulting in a double completion.
> 
> 
> > +static int pmcraid_eh_abort_handler(struct scsi_cmnd *scsi_cmd)
> > +{
> > +	struct pmcraid_instance *pinstance;
> > +	struct pmcraid_cmd *cmd;
> > +	struct pmcraid_resource_entry *res;
> > +	unsigned long reset_lock_flags;
> > +	unsigned long pending_lock_flags;
> > +	int rc;
> > +	int op_found = 0;
> > +
> > +	pinstance =
> > +		(struct pmcraid_instance *)scsi_cmd->device->host->hostdata;
> > +
> > +	dev_err(&pinstance->pdev->dev,
> > +		"I/O command timed out, aborting it.\n");
> > +
> > +	res = scsi_cmd->device->hostdata;
> > +
> > +	if (res == NULL)
> > +		return FAILED;
> > +
> > +	/* If we are currently going through reset/reload, return failed.
> > +	 * This will force the mid-layer to eventually call
> > +	 * pmcraid_eh_host_reset which will then go to sleep and wait for the
> > +	 * reset to complete
> > +	 */
> > +	spin_lock_irqsave(&pinstance->reset_lock, reset_lock_flags);
> > +	if (pinstance->ioa_reset_in_progress ||
> > +	    pinstance->ioa_state == IOA_STATE_DEAD) {
> > +		spin_unlock_irqrestore(&pinstance->reset_lock,
> > +					reset_lock_flags);
> > +		return FAILED;
> > +	}
> > +	spin_unlock_irqrestore(&pinstance->reset_lock, reset_lock_flags);
> 
> It looks like you check the state of the IOA here, but then release the lock
> and do a bunch of work before sending the command, which means the IOA's state
> could have changed by the time you send the abort later on and you could be
> running through an adapter reset. 
> 
> > +
> > +	/* loop over pending cmd list to find cmd corresponding to this
> > +	 * scsi_cmd. Note that this command might not have been completed
> > +	 * already. locking: all pending commands are protected with
> > +	 * pending_pool_lock.
> > +	 */
> > +	spin_lock_irqsave(&pinstance->pending_pool_lock, pending_lock_flags);
> > +	list_for_each_entry(cmd, &pinstance->pending_cmd_pool, free_list) {
> > +
> > +		if (cmd->scsi_cmd == scsi_cmd) {
> > +			op_found = 1;
> > +			break;
> > +		}
> > +	}
> > +	spin_unlock_irqrestore(&pinstance->pending_pool_lock,
> > +				pending_lock_flags);
> > +
> > +	if (!op_found)
> > +		return SUCCESS;
> > +
> > +	/* If the command to be aborted was given to IOA and still pending with
> > +	 * it, send ABORT_TASK to abort this and wait for its completion
> > +	 */
> > +	rc = pmcraid_abort_cmd(cmd);
> > +
> > +
> > +	return rc;
> > +}
> > +
> 
> 
> > +/* ALIGNSIZE: round a number 'i' to nearest multiple of another number 'n' */
> > +#define ALIGNSIZE(i, n) (((i) + ((n) - 1)) & (~((n) - 1)))
> 
> Can you use DIV_ROUND_UP here instead?
> 
> 
> 
> > +static int pmcraid_queuecommand(
> > +	struct scsi_cmnd *scsi_cmd,
> > +	void (*done) (struct scsi_cmnd *)
> > +)
> > +{
> > +	struct pmcraid_instance *pinstance;
> > +	struct pmcraid_resource_entry *res;
> > +	struct pmcraid_ioarcb *ioarcb;
> > +	struct pmcraid_cmd *cmd;
> > +	int rc = 0;
> > +
> > +	pinstance =
> > +		(struct pmcraid_instance *)scsi_cmd->device->host->hostdata;
> > +
> > +	scsi_cmd->scsi_done = done;
> > +	res = scsi_cmd->device->hostdata;
> > +	scsi_cmd->result = (DID_OK << 16);
> > +
> > +	/* if adapter is marked as dead, set result to DID_NO_CONNECT complete
> > +	 * the command
> > +	 */
> > +	if (pinstance->ioa_state == IOA_STATE_DEAD) {
> 
> Something to note here. I notice you are using scsi_block_requests during
> your adapter reset, which is good. However, SCSI EH does not check this
> flag and sends some commands, like TUR, through anyway. You might need to
> add some code here to handle that scenario.
> 
> 
> > +
> > +/**
> > + *  pmcraid_ioctl - char node ioctl entry point
> > + */
> > +static long pmcraid_chr_ioctl(
> > +	struct file *filep,
> > +	unsigned int cmd,
> > +	unsigned long arg
> > +)
> > +{
> 
> I think the ioctl stuff can all be removed. See comments below in the ioctl
> definitions for details.
> 
> 
> > +static struct device_attribute pmcraid_aen_timeout_attr = {
> > +	.attr = {
> > +		 .name = "aen_timeout",
> > +		 .mode = S_IRUGO | S_IWUSR,
> > +		 },
> > +	.show = pmcraid_show_aen_timeout,
> > +	.store = pmcraid_store_aen_timeout,
> > +};
> > +
> 
> My guess is that this can probably be deleted if you switch to use netlink
> for your userspace async event notification mechanism.
> 
> 
> > +static ssize_t pmcraid_store_log_level(
> > +	struct device *dev,
> > +	struct device_attribute *attr,
> > +	const char *buf, size_t count
> > +)
> > +{
> > +	struct Scsi_Host *shost;
> > +	struct pmcraid_instance *pinstance;
> > +	unsigned long val;
> > +
> > +	if (strict_strtoul(buf, 10, &val))
> > +		return -EINVAL;
> > +	/* log-level should be from 0 to 4 */
> > +	if (val > 2)
> 
> According to the comment, should that be if (val > 4) ?
> 
> 
> > +static ssize_t pmcraid_show_drv_version(
> > +	struct device *dev,
> > +	struct device_attribute *attr,
> > +	char *buf
> > +)
> > +{
> > +	return snprintf(buf, PAGE_SIZE, "version: %s, build date: %s\n",
> > +			PMCRAID_DRIVER_VERSION, PMCRAID_DRIVER_DATE);
> > +}
> > +
> > +static struct device_attribute pmcraid_driver_version_attr = {
> > +	.attr = {
> > +		 .name = "drv_version",
> > +		 .mode = S_IRUGO,
> > +		 },
> > +	.show = pmcraid_show_drv_version,
> 
> Should be able to just use MODULE_VERSION instead.
> 
> 
> > +
> > +/**
> > + * pmcraid_isr  - implements interrupt handling routine
> > + *
> > + * @irq: interrupt vector number
> > + * @dev_id: pointer hrrq_vector
> > + *
> > + * Return Value
> > + *	 IRQ_HANDLED if interrupt is handled or IRQ_NONE if ignored
> > + */
> > +static irqreturn_t pmcraid_isr(int irq, void *dev_id)
> > +{
> > +	struct pmcraid_isr_param *hrrq_vector;
> > +	struct pmcraid_instance *pinstance;
> > +	u32 intrs;
> > +	int rc;
> > +	u8 unlock = 1;
> > +
> > +	/* In case of legacy interrupt mode where interrupts are shared across
> > +	 * isrs, it may be possible that the current interrupt is not from IOA
> > +	 */
> > +	if (!dev_id) {
> > +		printk(KERN_INFO "%s(): NULL host pointer\n", __func__);
> > +		return IRQ_NONE;
> > +	}
> > +
> > +	hrrq_vector = (struct pmcraid_isr_param *)dev_id;
> > +	pinstance = hrrq_vector->drv_inst;
> > +
> > +	/* Acquire the lock (currently host_lock) while processing interrupts.
> > +	 * This interval is small as most of the response processing is done by
> > +	 * tasklet without the lock.
> > +	 */
> > +	spin_lock_irqsave(pinstance->host->host_lock,
> > +			  pinstance->host_lock_flags);
> > +	intrs = pmcraid_read_interrupts(pinstance);
> > +
> > +	if (unlikely((intrs & PMCRAID_PCI_INTERRUPTS) == 0)) {
> > +		spin_unlock_irqrestore(pinstance->host->host_lock,
> > +				       pinstance->host_lock_flags);
> > +		return IRQ_NONE;
> > +	}
> > +
> > +	rc = pmcraid_isr_common(pinstance,
> > +				intrs,
> > +				hrrq_vector->hrrq_id,
> > +				&unlock);
> 
> The locking gets a bit messy here, but if you get rid of the host_lock_flags
> from pinstance, that should force this to get cleaned up as well.
> 
> > +	if (unlock)
> > +		spin_unlock_irqrestore(pinstance->host->host_lock,
> > +				       pinstance->host_lock_flags);
> > +
> > +	return rc;
> > +}
> > +
> > +
> 
> 
> > +static int __devinit
> > +pmcraid_allocate_host_rrqs(struct pmcraid_instance *pinstance)
> > +{
> > +	int i;
> > +	int buf_count = PMCRAID_MAX_CMD / pinstance->num_hrrq;
> > +
> > +	for (i = 0; i < pinstance->num_hrrq; i++) {
> > +		int buffer_size = HRRQ_ENTRY_SIZE * buf_count;
> > +
> > +		pinstance->hrrq_start[i] =
> > +			pci_alloc_consistent(
> > +					pinstance->pdev,
> > +					buffer_size,
> > +					&(pinstance->hrrq_start_bus_addr[i]));
> > +
> > +		if (0 == pinstance->hrrq_start[i]) {
> > +			pmcraid_err("could not allocate host rrq: %d\n", i);
> > +			pmcraid_release_host_rrqs(pinstance, i);
> > +			return -ENOMEM;
> > +		}
> > +
> > +		memset((void *)(pinstance->hrrq_start[i]), 0, buffer_size);
> 
> Unnecessary cast
> 
> > 
> > +/**
> > + * pmcraid_init_res_table - Initialize the resource table
> > + * @cmd:  pointer to pmcraid command struct
> > + *
> > + * This function looks through the existing resource table, comparing
> > + * it with the config table. This function will take care of old/new
> > + * devices and schedule adding/removing them from the mid-layer
> > + * as appropriate.
> > + *
> > + * Return value
> > + *	 None
> > + **/
> > +static void pmcraid_init_res_table(struct pmcraid_cmd *cmd)
> > +{
> > +	struct pmcraid_instance *pinstance = cmd->drv_inst;
> > +	struct pmcraid_resource_entry *res, *temp;
> 
> > +	/* release the resource list lock */
> > +	spin_unlock_irqrestore(&pinstance->resource_lock, lock_flags);
> > +
> > +	/* Prepare next command to be sent to IOA as part of reset sequence
> > +	 * set supported devices command needs to be sent for each of the
> > +	 * resource found. u.res is used in list traversal in the list so
> > +	 * initialize it.
> > +	 */
> > +	cmd->u.res = list_entry(pinstance->used_res_q.next,
> > +				struct pmcraid_resource_entry, queue);
> 
> Is this needed? The comment says you need to send set supported devices for
> each resource found, but you seem to be setting an ALL_DEVICES_SUPPORTED bit
> and not really using this data.
> 
> 
> 
> > +
> > +/**
> > + * pmcraid_probe - PCI probe entry pointer for PMC MaxRaid controller driver
> > + * @pdev: pointer to pci device structure
> > + * @dev_id: pointer to device ids structure
> > + *
> > + * Return Value
> > + *		returns 0 if the device is claimed and successfully configured.
> > + *		returns non-zero error code in case of any failure
> > + */
> > +static int __devinit pmcraid_probe(
> > +	struct pci_dev *pdev,
> > +	const struct pci_device_id *dev_id
> > +)
> > +{
> > +	struct pmcraid_instance *pinstance;
> > +	struct Scsi_Host *host;
> > +	void __iomem *mapped_pci_addr;
> > +	int rc = PCIBIOS_SUCCESSFUL;
> > +
> > +	if (pmcraid_adapter_count >= PMCRAID_MAX_ADAPTERS) {
> > +		pmcraid_err
> > +			("maximum number(%d) of supported adapters reached\n",
> > +			 pmcraid_adapter_count);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	pmcraid_adapter_count++;
> > +
> > +	rc = pci_enable_device(pdev);
> > +
> > +	if (rc) {
> > +		dev_err(&pdev->dev, "Cannot enable adapter\n");
> > +		pmcraid_adapter_count--;
> > +		goto out;
> > +	}
> > +
> > +	dev_info(&pdev->dev,
> > +		"Found IOA(%x:%x) on PCI bus %d slot %d with IRQ: %d\n",
> > +		 pdev->vendor, pdev->device, pdev->bus->number,
> > +		 PCI_SLOT(pdev->bus->number), pdev->irq);
> 
> The bus/slot sort of info should already be printed by the dev_info macro,
> so no need to duplicate that here.
> 
> 
> > +/* Maximum number of adapters supported by current version of the driver */
> > +#define PMCRAID_MAX_ADAPTERS		32
> 
> Why is there a limit on the max adapters supported?
> 
> > +/*
> > + * Per adapter structure maintained by LLD
> > + */
> > +struct pmcraid_instance {
> > +	/* Array of allowed-to-be-exposed resources, initialized from
> > +	 * Configutation Table, later updated with CCNs
> > +	 */
> > +	struct pmcraid_resource_entry *res_entries;
> > +
> > +	struct list_head free_res_q;	/* res_entries lists for easy lookup */
> > +	struct list_head used_res_q;	/* List of to be exposed resources */
> > +	spinlock_t resource_lock;	/* spinlock to protect resource list */
> > +	unsigned long host_lock_flags;	/* host_lock flags */
> 
> This field needs to be removed. Lock flags must be kept locally and cannot
> be passed from one function to another or shared across cpus.
> 
> 
> > +/* Driver handled IOCTL command definitions */
> > +#define PMCRAID_IOCTL_GET_DRIVER_VERSION \
> > +	DRV_IOCTL(1, _ARGSIZE(struct pmcraid_driver_version))
> 
> As already stated, this should already exist as an attribute on the module
> in sysfs via MODULE_VERSION
> 
> > +
> > +#define PMCRAID_IOCTL_GET_PCI_INFORMATION    \
> > +	DRV_IOCTL(2, _ARGSIZE(struct pmcraid_pci_info))
> 
> This information should already be available via sysfs. No need
> to duplicate that here.
> 
> > +
> > +#define PMCRAID_IOCTL_GET_DRIVER_STATISTICS  \
> > +	DRV_IOCTL(3, _ARGSIZE(struct pmcraid_driver_statistics))
> 
> I would think this could be implemented with device and host sysfs
> attributes instead.
> 
> > +
> > +#define PMCRAID_IOCTL_GET_ADAPTER_ID         \
> > +	DRV_IOCTL(4, _ARGSIZE(union pmcraid_adapter_id))
> 
> A scsi host sysfs attribute should work here
> 
> > +
> > +#define PMCRAID_IOCTL_RESET_ADAPTER          \
> > +	DRV_IOCTL(5, sizeof(struct pmcraid_ioctl_header))
> 
> A writable sysfs file should work for this
> 
> > +
> > +#define PMCRAID_IOCTL_GET_EVENT_DETAILS      \
> > +	DRV_IOCTL(6, _ARGSIZE(struct pmcraid_event_details))
> 
> This should probably use netlink instead
> 
> > +
> > +#define PMCRAID_IOCTL_GET_IOA_DUMP           \
> > +	DRV_IOCTL(7, _ARGSIZE(struct pmcraid_ioa_dump))
> 
> Can a binary sysfs file work for this instead?
> 
> > +
> > +#define PMCRAID_IOCTL_GET_RESCAN_CHANNEL     \
> > +	DRV_IOCTL(9, _ARGSIZE(struct pmcraid_channel_scan))
> 
> What is this IOCTL supposed to do? I don't see it doing anything in the
> code.
> 
> > +
> > +/* passthrough/firmware handled commands */
> > +#define PMCRAID_IOCTL_PASSTHROUGH_COMMAND         \
> > +	FMW_IOCTL(1, sizeof(struct pmcraid_passthrough_ioctl_buffer))
> 
> Can this use SG_IO instead? It looks very SCSI like.
> 
> > +
> > +#define PMCRAID_IOCTL_DOWNLOAD_MICROCODE     \
> > +	FMW_IOCTL(2, sizeof(struct pmcraid_passthrough_ioctl_buffer))
> 
> Can you use request_firmware here instead?
> 
> -- 
> Brian King
> Linux on Power Virtualization
> IBM Linux Technology Center
> 
> 
> 
