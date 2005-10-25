From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 2/2] libata: Add support for SATA attachment to SAS adapters
Date: Tue, 25 Oct 2005 13:58:44 -0400
Message-ID: <435E7254.4070809@pobox.com>
References: <4341A91A.3020000@us.ibm.com> <434251E0.9060000@pobox.com>	 <58cb370e0510040322q1cb7a13bjfc6c7875140d20a9@mail.gmail.com> <58cb370e0510041356h780e7a5aifda0c232f677471e@mail.gmail.com> <43443E99.4090008@pobox.com> <435D5D83.1060201@us.ibm.com> <435D5E32.4080902@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:3794 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932273AbVJYR6u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Oct 2005 13:58:50 -0400
In-Reply-To: <435D5E32.4080902@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Brian King wrote:
> +/**
> + *	ata_sas_port_alloc - Allocate port for a SAS attached SATA device
> + *	@pdev: PCI device that the scsi device is attached to
> + *	@port_info: Information from low-level host driver
> + *
> + *	LOCKING:
> + *	PCI/etc. bus probe sem.
> + *
> + *	RETURNS:
> + *	ata_port pointer on success / NULL on failure.
> + */
> +
> +struct ata_port *ata_sas_port_alloc(struct pci_dev *pdev,
> +				    struct ata_port_info *port_info)
> +{
> +	struct ata_port *ap = kzalloc(sizeof(*ap), GFP_KERNEL);
> +
> +	if (!ap)
> +		return NULL;
> +
> +	ap->dev = &pdev->dev;
> +	ap->ops = port_info->port_ops;
> +	ap->flags = port_info->host_flags;
> +	ap->pio_mask = port_info->pio_mask;
> +	ap->mwdma_mask = port_info->mwdma_mask;
> +	ap->udma_mask = port_info->udma_mask;
> +	ap->cbl = ATA_CBL_SATA;
> +	ap->active_tag = ATA_TAG_POISON;
> +	ap->last_ctl = 0xFF;
> +	return ap;
> +}
> +EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
> +
> +static void ata_sas_port_free(struct ata_port *ap)
> +{
> +	kfree(ap);
> +}
> +
> +/**
> + *	ata_sas_port_init - Initialize a SATA device
> + *	@ap: SATA port to initialize
> + *
> + *	LOCKING:
> + *	PCI/etc. bus probe sem.
> + *
> + *	RETURNS:
> + *	Zero on success, non-zero on error.
> + */
> +
> +int ata_sas_port_init(struct ata_port *ap)
> +{
> +	int rc = ap->ops->port_start(ap);
> +
> +	if (!rc)
> +		rc = ata_bus_probe(ap);
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(ata_sas_port_init);
> +
> +/**
> + *	ata_sas_port_destroy - Destroy a SATA port allocated by ata_sas_port_alloc
> + *	@ap: SATA port to destroy
> + *
> + */
> +
> +void ata_sas_port_destroy(struct ata_port *ap)
> +{
> +	if (ap) {
> +		ap->ops->port_stop(ap);
> +		ata_sas_port_free(ap);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(ata_sas_port_destroy);
> +
> +/**
> + *	ata_sas_slave_configure - Default slave_config routine for libata devices
> + *	@sdev: SCSI device to configure
> + *	@ap: ATA port to which SCSI device is attached
> + *
> + *	RETURNS:
> + *	Zero.
> + */
> +
> +int ata_sas_slave_configure(struct scsi_device *sdev, struct ata_port *ap)
> +{
> +	ata_scsi_sdev_config(sdev);
> +	ata_scsi_dev_config(sdev, ap->device);
> +	if (ata_dev_knobble(ap))
> +		blk_queue_max_sectors(sdev->request_queue, ATA_MAX_SECTORS);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ata_sas_slave_configure);
> +
> +/**
> + *	ata_sas_queuecmd - Issue SCSI cdb to libata-managed device
> + *	@cmd: SCSI command to be sent
> + *	@done: Completion function, called when command is complete
> + *	@ap:	ATA port to which the command is being sent
> + *
> + *	RETURNS:
> + *	Zero.
> + */
> +
> +int ata_sas_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *),
> +		     struct ata_port *ap)
> +{
> +	if (unlikely(!ata_dev_present(ap->device))) {
> +		cmd->result = (DID_BAD_TARGET << 16);
> +		done(cmd);
> +		return 0;
> +	}
> +
> +	if (cmd->cmd_len > ap->cdb_len) {
> +		cmd->result = (DID_ABORT << 16);
> +		done(cmd);
> +		return 0;
> +	}
> +
> +	__ata_scsi_queuecmd(cmd, done, ap, ap->device);
> +	return 0;
> +}

I'm still thinking about these functions, so it would be nice to split 
them up into a third patch.  That would allow me to apply the other 
cleanups in this patch.

	Jeff


