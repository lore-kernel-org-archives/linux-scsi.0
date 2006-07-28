From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 2/2] libata: Add support for SATA attachment to SAS adapters
Date: Fri, 28 Jul 2006 09:01:04 -0500
Message-ID: <44CA18A0.1000803@us.ibm.com>
References: <200607131335.k6DDZpMD004925@d03av03.boulder.ibm.com> <44BF9079.4040009@us.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <44BF9079.4040009@us.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Ping

Brian King wrote:
> Jeff,
> 
> Do you have any comments on my latest patches? What can I do to
> help get this support merged into libata?
> 
> 
> Here are some test results for the patchset:
> 
> 1. sg3utils test to SATA/ATAPI device
>    * Perform the following sg3utils commands to a SATA device:
>        o sg_get_config
>        o sginfo
>        o sg_inq
>        o sg_readcap
> 2. SATA error injection
>    * Use sg_reset to initiate a PHY reset to a SATA device and verify
>      the host recovers.
>    * Use sysfs to reset the ipr adapter. This will cause the SATA device
>      to receive an out of band PHY reset. Use sg_inq to issue an INQUIRY
>      to the device. Verify error handling gets invoked and the system
>      recovers.
> 3. stress_cd / internal CD/DVD exerciser (run for > 12 hours)
> 4. SLAB_DEBUG
>    * Run with memory tainting enabled.
> 5. SATA add/remove device
>    * Use sysfs to delete a SATA device from SCSI core, which will also
>      cause the associated ATA port to get deleted.
>    * Use sysfs to rescan for the SATA device. Verify the SATA device
>      shows up again.
>    * Verify no unexpected errors are logged.
> 6. SATA queue_depth
>    * Use sysfs and attempt to change the queue depth of a SATA device.
>    * Verify the queue depth stays at 1.
> 
> I would be happy to run any additional testcases.
> 
> Thanks,
> 
> Brian
> 
> 
> Brian King wrote:
>> The following patch enhances libata to allow SAS device drivers
>> to utilize libata to talk to SATA devices. It introduces some
>> new APIs which allow libata to be used without allocating a
>> virtual scsi host.
>>
>> New APIs:
>>
>> ata_sas_port_alloc - Allocate an ata_port 
>> ata_sas_port_init - Initialize an ata_port (probe device, etc)
>> ata_sas_port_destroy - Free an ata_port allocated by ata_sas_port_alloc
>> ata_sas_slave_configure - configure scsi device
>> ata_sas_queuecmd - queue a scsi command, similar to ata_scsi_queuecomand
>>
>> These new APIs can be used either directly by a SAS LLDD or could be used
>> by the SAS transport class. 
>>
>> Possible usage for a SAS LLDD would be:
>>
>> scsi_scan_host
>> 	target_alloc
>> 		ata_sas_port_alloc
>> 	slave_alloc
>> 		ata_sas_port_init
>> 	slave_configure
>> 		ata_sas_slave_configure
>>
>> Commands received by the LLDD for SATA devices would call ata_sas_queuecmd.
>>
>> Device teardown would occur with:
>>
>> slave_destroy
>> 	port_disable
>> target_destroy
>> 	ata_sas_port_destroy
>>
>> Acked-by: Jeff Garzik <jgarzik@pobox.com>
>> Signed-off-by: Brian King <brking@us.ibm.com>
>> ---
>>
>>  drivers/scsi/libata-core.c |    4 -
>>  drivers/scsi/libata-scsi.c |  166 +++++++++++++++++++++++++++++++++++++++++++++
>>  drivers/scsi/libata.h      |    2 
>>  include/linux/libata.h     |    9 ++
>>  4 files changed, 179 insertions(+), 2 deletions(-)
>>
>> diff -puN drivers/scsi/libata-scsi.c~libata_sas drivers/scsi/libata-scsi.c
>> --- libata-dev/drivers/scsi/libata-scsi.c~libata_sas	2006-07-09 13:07:22.000000000 -0500
>> +++ libata-dev-bjking1/drivers/scsi/libata-scsi.c	2006-07-09 13:07:22.000000000 -0500
>> @@ -3158,3 +3158,169 @@ void ata_scsi_dev_rescan(void *data)
>>  			scsi_rescan_device(&(dev->sdev->sdev_gendev));
>>  	}
>>  }
>> +
>> +/**
>> + *	ata_sas_port_alloc - Allocate port for a SAS attached SATA device
>> + *	@pdev: PCI device that the scsi device is attached to
>> + *	@port_info: Information from low-level host driver
>> + *	@host: SCSI host that the scsi device is attached to
>> + *
>> + *	LOCKING:
>> + *	PCI/etc. bus probe sem.
>> + *
>> + *	RETURNS:
>> + *	ata_port pointer on success / NULL on failure.
>> + */
>> +
>> +struct ata_port *ata_sas_port_alloc(struct ata_host_set *host_set,
>> +				    struct ata_port_info *port_info,
>> +				    struct Scsi_Host *host)
>> +{
>> +	struct ata_port *ap = kzalloc(sizeof(*ap), GFP_KERNEL);
>> +	int i;
>> +
>> +	if (!ap)
>> +		return NULL;
>> +
>> +	ap->dev = host_set->dev;
>> +	ap->host_set = host_set;
>> +	ap->id = ata_unique_id++;
>> +	ap->lock = host->host_lock;
>> +	ap->ops = port_info->port_ops;
>> +	ap->flags = port_info->host_flags | ATA_FLAG_DISABLED;
>> +	ap->pio_mask = port_info->pio_mask;
>> +	ap->mwdma_mask = port_info->mwdma_mask;
>> +	ap->udma_mask = port_info->udma_mask;
>> +	ap->cbl = ATA_CBL_SATA;
>> +	ap->sata_spd_limit = UINT_MAX;
>> +	ap->active_tag = ATA_TAG_POISON;
>> +	ap->last_ctl = 0xFF;
>> +	INIT_WORK(&ap->port_task, NULL, NULL);
>> +	INIT_WORK(&ap->hotplug_task, ata_scsi_hotplug, ap);
>> +	INIT_WORK(&ap->scsi_rescan_task, ata_scsi_dev_rescan, ap);
>> +	INIT_LIST_HEAD(&ap->eh_done_q);
>> +	init_waitqueue_head(&ap->eh_wait_q);
>> +
>> +	for (i = 0; i < ATA_MAX_DEVICES; i++) {
>> +		struct ata_device *dev = &ap->device[i];
>> +		dev->ap = ap;
>> +		dev->devno = i;
>> +		ata_dev_init(dev);
>> +	}
>> +
>> +	return ap;
>> +}
>> +EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
>> +
>> +/**
>> + *	ata_sas_port_start - Set port up for dma.
>> + *	@ap: Port to initialize
>> + *
>> + *	Called just after data structures for each port are
>> + *	initialized.  Allocates DMA pad.
>> + *
>> + *	May be used as the port_start() entry in ata_port_operations.
>> + *
>> + *	LOCKING:
>> + *	Inherited from caller.
>> + */
>> +int ata_sas_port_start(struct ata_port *ap)
>> +{
>> +	return ata_pad_alloc(ap, ap->dev);
>> +}
>> +EXPORT_SYMBOL_GPL(ata_sas_port_start);
>> +
>> +/**
>> + *	ata_port_stop - Undo ata_sas_port_start()
>> + *	@ap: Port to shut down
>> + *
>> + *	Frees the DMA pad.
>> + *
>> + *	May be used as the port_stop() entry in ata_port_operations.
>> + *
>> + *	LOCKING:
>> + *	Inherited from caller.
>> + */
>> +
>> +void ata_sas_port_stop(struct ata_port *ap)
>> +{
>> +	ata_pad_free(ap, ap->dev);
>> +}
>> +EXPORT_SYMBOL_GPL(ata_sas_port_stop);
>> +
>> +/**
>> + *	ata_sas_port_init - Initialize a SATA device
>> + *	@ap: SATA port to initialize
>> + *
>> + *	LOCKING:
>> + *	PCI/etc. bus probe sem.
>> + *
>> + *	RETURNS:
>> + *	Zero on success, non-zero on error.
>> + */
>> +
>> +int ata_sas_port_init(struct ata_port *ap)
>> +{
>> +	int rc = ap->ops->port_start(ap);
>> +
>> +	if (!rc)
>> +		rc = ata_bus_probe(ap);
>> +
>> +	return rc;
>> +}
>> +EXPORT_SYMBOL_GPL(ata_sas_port_init);
>> +
>> +/**
>> + *	ata_sas_port_destroy - Destroy a SATA port allocated by ata_sas_port_alloc
>> + *	@ap: SATA port to destroy
>> + *
>> + */
>> +
>> +void ata_sas_port_destroy(struct ata_port *ap)
>> +{
>> +	ap->ops->port_stop(ap);
>> +	kfree(ap);
>> +}
>> +EXPORT_SYMBOL_GPL(ata_sas_port_destroy);
>> +
>> +/**
>> + *	ata_sas_slave_configure - Default slave_config routine for libata devices
>> + *	@sdev: SCSI device to configure
>> + *	@ap: ATA port to which SCSI device is attached
>> + *
>> + *	RETURNS:
>> + *	Zero.
>> + */
>> +
>> +int ata_sas_slave_configure(struct scsi_device *sdev, struct ata_port *ap)
>> +{
>> +	ata_scsi_sdev_config(sdev);
>> +	ata_scsi_dev_config(sdev, ap->device);
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(ata_sas_slave_configure);
>> +
>> +/**
>> + *	ata_sas_queuecmd - Issue SCSI cdb to libata-managed device
>> + *	@cmd: SCSI command to be sent
>> + *	@done: Completion function, called when command is complete
>> + *	@ap:	ATA port to which the command is being sent
>> + *
>> + *	RETURNS:
>> + *	Zero.
>> + */
>> +
>> +int ata_sas_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *),
>> +		     struct ata_port *ap)
>> +{
>> +	ata_scsi_dump_cdb(ap, cmd);
>> +
>> +	if (likely(ata_scsi_dev_enabled(ap->device)))
>> +		__ata_scsi_queuecmd(cmd, done, ap->device);
>> +	else {
>> +		cmd->result = (DID_BAD_TARGET << 16);
>> +		done(cmd);
>> +	}
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(ata_sas_queuecmd);
>> diff -puN drivers/scsi/libata.h~libata_sas drivers/scsi/libata.h
>> --- libata-dev/drivers/scsi/libata.h~libata_sas	2006-07-09 13:07:22.000000000 -0500
>> +++ libata-dev-bjking1/drivers/scsi/libata.h	2006-07-09 13:07:22.000000000 -0500
>> @@ -43,6 +43,7 @@ extern struct workqueue_struct *ata_aux_
>>  extern int atapi_enabled;
>>  extern int atapi_dmadir;
>>  extern int libata_fua;
>> +extern unsigned int ata_unique_id;
>>  extern struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev);
>>  extern int ata_rwcmd_protocol(struct ata_queued_cmd *qc);
>>  extern void ata_dev_disable(struct ata_device *dev);
>> @@ -107,6 +108,7 @@ extern void ata_scsi_rbuf_fill(struct at
>>                                             u8 *rbuf, unsigned int buflen));
>>  extern void ata_schedule_scsi_eh(struct Scsi_Host *shost);
>>  extern void ata_scsi_dev_rescan(void *data);
>> +extern int ata_bus_probe(struct ata_port *ap);
>>  
>>  /* libata-eh.c */
>>  extern enum scsi_eh_timer_return ata_scsi_timed_out(struct scsi_cmnd *cmd);
>> diff -puN include/linux/libata.h~libata_sas include/linux/libata.h
>> --- libata-dev/include/linux/libata.h~libata_sas	2006-07-09 13:07:22.000000000 -0500
>> +++ libata-dev-bjking1/include/linux/libata.h	2006-07-09 13:07:22.000000000 -0500
>> @@ -689,6 +689,15 @@ extern int ata_scsi_detect(struct scsi_h
>>  extern int ata_scsi_ioctl(struct scsi_device *dev, int cmd, void __user *arg);
>>  extern int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *));
>>  extern int ata_scsi_release(struct Scsi_Host *host);
>> +extern void ata_sas_port_destroy(struct ata_port *);
>> +extern struct ata_port *ata_sas_port_alloc(struct ata_host_set *,
>> +					   struct ata_port_info *, struct Scsi_Host *);
>> +extern int ata_sas_port_init(struct ata_port *);
>> +extern int ata_sas_port_start(struct ata_port *ap);
>> +extern void ata_sas_port_stop(struct ata_port *ap);
>> +extern int ata_sas_slave_configure(struct scsi_device *, struct ata_port *);
>> +extern int ata_sas_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *),
>> +			    struct ata_port *ap);
>>  extern unsigned int ata_host_intr(struct ata_port *ap, struct ata_queued_cmd *qc);
>>  extern int sata_scr_valid(struct ata_port *ap);
>>  extern int sata_scr_read(struct ata_port *ap, int reg, u32 *val);
>> diff -puN drivers/scsi/libata-core.c~libata_sas drivers/scsi/libata-core.c
>> --- libata-dev/drivers/scsi/libata-core.c~libata_sas	2006-07-09 13:07:22.000000000 -0500
>> +++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-07-09 13:07:22.000000000 -0500
>> @@ -70,7 +70,7 @@ static unsigned int ata_dev_init_params(
>>  static unsigned int ata_dev_set_xfermode(struct ata_device *dev);
>>  static void ata_dev_xfermask(struct ata_device *dev);
>>  
>> -static unsigned int ata_unique_id = 1;
>> +unsigned int ata_unique_id = 1;
>>  static struct workqueue_struct *ata_wq;
>>  
>>  struct workqueue_struct *ata_aux_wq;
>> @@ -1528,7 +1528,7 @@ err_out_nosup:
>>   *	Zero on success, negative errno otherwise.
>>   */
>>  
>> -static int ata_bus_probe(struct ata_port *ap)
>> +int ata_bus_probe(struct ata_port *ap)
>>  {
>>  	unsigned int classes[ATA_MAX_DEVICES];
>>  	int tries[ATA_MAX_DEVICES];
>> _
> 


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
