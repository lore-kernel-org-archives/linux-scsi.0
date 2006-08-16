From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/1] ipr: Support attaching SATA devices - drop
Date: Wed, 16 Aug 2006 12:58:31 -0500
Message-ID: <44E35CC7.8030807@us.ibm.com>
References: <200608091522.k79FMON6004111@d01av01.pok.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200608091522.k79FMON6004111@d01av01.pok.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, jgarzik@pobox.com, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

James,

Please drop this patch since it won't build with the move of 
libata to drivers/ata. Will send an updated patch shortly.

Should this be going through your tree or Jeff's? It might be simpler
to go through Jeff's tree.


Thanks,

Brian

Brian King wrote:
> Adds support to attach SATA devices to ipr SAS adapters.
> 
> Signed-off-by: Brian King <brking@us.ibm.com>
> ---
> 
>  libata-dev-bjking1/drivers/scsi/Kconfig  |    1 
>  libata-dev-bjking1/drivers/scsi/Makefile |    2 
>  libata-dev-bjking1/drivers/scsi/ipr.c    |  676 ++++++++++++++++++++++++++++++-
>  libata-dev-bjking1/drivers/scsi/ipr.h    |   18 
>  4 files changed, 676 insertions(+), 21 deletions(-)
> 
> diff -puN drivers/scsi/ipr.h~ipr_sata_with_libata_changes drivers/scsi/ipr.h
> --- libata-dev/drivers/scsi/ipr.h~ipr_sata_with_libata_changes	2006-08-07 12:44:09.000000000 -0500
> +++ libata-dev-bjking1/drivers/scsi/ipr.h	2006-08-07 12:44:09.000000000 -0500
> @@ -28,6 +28,7 @@
>  
>  #include <linux/types.h>
>  #include <linux/completion.h>
> +#include <linux/libata.h>
>  #include <linux/list.h>
>  #include <linux/kref.h>
>  #include <scsi/scsi.h>
> @@ -36,8 +37,8 @@
>  /*
>   * Literals
>   */
> -#define IPR_DRIVER_VERSION "2.1.4"
> -#define IPR_DRIVER_DATE "(August 2, 2006)"
> +#define IPR_DRIVER_VERSION "2.2.0"
> +#define IPR_DRIVER_DATE "(August 3, 2006)"
>  
>  /*
>   * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
> @@ -849,6 +850,13 @@ struct ipr_bus_attributes {
>  	u32 max_xfer_rate;
>  };
>  
> +struct ipr_sata_port {
> +	struct ipr_ioa_cfg *ioa_cfg;
> +	struct ata_port *ap;
> +	struct ipr_resource_entry *res;
> +	struct ipr_ioasa_gata ioasa;
> +};
> +
>  struct ipr_resource_entry {
>  	struct ipr_config_table_entry cfgte;
>  	u8 needs_sync_complete:1;
> @@ -858,6 +866,7 @@ struct ipr_resource_entry {
>  	u8 resetting_device:1;
>  
>  	struct scsi_device *sdev;
> +	struct ipr_sata_port *sata_port;
>  	struct list_head queue;
>  };
>  
> @@ -928,10 +937,11 @@ struct ipr_trace_entry {
>  	u32 time;
>  
>  	u8 op_code;
> +	u8 ata_op_code;
>  	u8 type;
>  #define IPR_TRACE_START			0x00
>  #define IPR_TRACE_FINISH		0xff
> -	u16 cmd_index;
> +	u8 cmd_index;
>  
>  	__be32 res_handle;
>  	union {
> @@ -1073,6 +1083,7 @@ struct ipr_ioa_cfg {
>  
>  	struct ipr_cmnd *reset_cmd;
>  
> +	struct ata_host_set ata_host_set;
>  	char ipr_cmd_label[8];
>  #define IPR_CMD_LABEL		"ipr_cmnd"
>  	struct ipr_cmnd *ipr_cmnd_list[IPR_NUM_CMD_BLKS];
> @@ -1085,6 +1096,7 @@ struct ipr_cmnd {
>  	struct ipr_ioadl_desc ioadl[IPR_NUM_IOADL_ENTRIES];
>  	struct list_head queue;
>  	struct scsi_cmnd *scsi_cmd;
> +	struct ata_queued_cmd *qc;
>  	struct completion completion;
>  	struct timer_list timer;
>  	void (*done) (struct ipr_cmnd *);
> diff -puN drivers/scsi/ipr.c~ipr_sata_with_libata_changes drivers/scsi/ipr.c
> --- libata-dev/drivers/scsi/ipr.c~ipr_sata_with_libata_changes	2006-08-07 12:44:09.000000000 -0500
> +++ libata-dev-bjking1/drivers/scsi/ipr.c	2006-08-09 09:50:12.000000000 -0500
> @@ -70,6 +70,7 @@
>  #include <linux/firmware.h>
>  #include <linux/module.h>
>  #include <linux/moduleparam.h>
> +#include <linux/libata.h>
>  #include <asm/io.h>
>  #include <asm/irq.h>
>  #include <asm/processor.h>
> @@ -78,6 +79,7 @@
>  #include <scsi/scsi_tcq.h>
>  #include <scsi/scsi_eh.h>
>  #include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_transport.h>
>  #include "ipr.h"
>  
>  /*
> @@ -261,6 +263,8 @@ struct ipr_error_table_t ipr_error_table
>  	"Device bus status error"},
>  	{0x04448600, 0, 1,
>  	"8157: IOA error requiring IOA reset to recover"},
> +	{0x04448700, 0, 0,
> +	"ATA device status error"},
>  	{0x04490000, 0, 0,
>  	"Message reject received from the device"},
>  	{0x04449200, 0, 1,
> @@ -453,7 +457,8 @@ static void ipr_trc_hook(struct ipr_cmnd
>  	trace_entry->time = jiffies;
>  	trace_entry->op_code = ipr_cmd->ioarcb.cmd_pkt.cdb[0];
>  	trace_entry->type = type;
> -	trace_entry->cmd_index = ipr_cmd->cmd_index;
> +	trace_entry->ata_op_code = ipr_cmd->ioarcb.add_data.u.regs.command;
> +	trace_entry->cmd_index = ipr_cmd->cmd_index & 0xff;
>  	trace_entry->res_handle = ipr_cmd->ioarcb.res_handle;
>  	trace_entry->u.add_data = add_data;
>  }
> @@ -480,8 +485,10 @@ static void ipr_reinit_ipr_cmnd(struct i
>  	ioarcb->read_ioadl_len = 0;
>  	ioasa->ioasc = 0;
>  	ioasa->residual_data_len = 0;
> +	ioasa->u.gata.status = 0;
>  
>  	ipr_cmd->scsi_cmd = NULL;
> +	ipr_cmd->qc = NULL;
>  	ipr_cmd->sense_buffer[0] = 0;
>  	ipr_cmd->dma_use_sg = 0;
>  }
> @@ -626,6 +633,28 @@ static int ipr_set_pcix_cmd_reg(struct i
>  }
>  
>  /**
> + * ipr_sata_eh_done - done function for aborted SATA commands
> + * @ipr_cmd:	ipr command struct
> + *
> + * This function is invoked for ops generated to SATA
> + * devices which are being aborted.
> + *
> + * Return value:
> + * 	none
> + **/
> +static void ipr_sata_eh_done(struct ipr_cmnd *ipr_cmd)
> +{
> +	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
> +	struct ata_queued_cmd *qc = ipr_cmd->qc;
> +	struct ipr_sata_port *sata_port = qc->ap->private_data;
> +
> +	qc->err_mask |= AC_ERR_OTHER;
> +	sata_port->ioasa.status |= ATA_BUSY;
> +	list_add_tail(&ipr_cmd->queue, &ioa_cfg->free_q);
> +	ata_qc_complete(qc);
> +}
> +
> +/**
>   * ipr_scsi_eh_done - mid-layer done function for aborted ops
>   * @ipr_cmd:	ipr command struct
>   *
> @@ -669,6 +698,8 @@ static void ipr_fail_all_ops(struct ipr_
>  
>  		if (ipr_cmd->scsi_cmd)
>  			ipr_cmd->done = ipr_scsi_eh_done;
> +		else if (ipr_cmd->qc)
> +			ipr_cmd->done = ipr_sata_eh_done;
>  
>  		ipr_trc_hook(ipr_cmd, IPR_TRACE_FINISH, IPR_IOASC_IOA_WAS_RESET);
>  		del_timer(&ipr_cmd->timer);
> @@ -825,6 +856,7 @@ static void ipr_init_res_entry(struct ip
>  	res->del_from_ml = 0;
>  	res->resetting_device = 0;
>  	res->sdev = NULL;
> +	res->sata_port = NULL;
>  }
>  
>  /**
> @@ -3051,6 +3083,17 @@ static int ipr_free_dump(struct ipr_ioa_
>   **/
>  static int ipr_change_queue_depth(struct scsi_device *sdev, int qdepth)
>  {
> +	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)sdev->host->hostdata;
> +	struct ipr_resource_entry *res;
> +	unsigned long lock_flags = 0;
> +
> +	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
> +	res = (struct ipr_resource_entry *)sdev->hostdata;
> +
> +	if (res && ipr_is_gata(res) && qdepth > IPR_MAX_CMD_PER_ATA_LUN)
> +		qdepth = IPR_MAX_CMD_PER_ATA_LUN;
> +	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
> +
>  	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
>  	return sdev->queue_depth;
>  }
> @@ -3166,6 +3209,122 @@ static int ipr_biosparam(struct scsi_dev
>  }
>  
>  /**
> + * ipr_find_starget - Find target based on bus/target.
> + * @starget:	scsi target struct
> + *
> + * Return value:
> + * 	resource entry pointer if found / NULL if not found
> + **/
> +static struct ipr_resource_entry *ipr_find_starget(struct scsi_target *starget)
> +{
> +	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
> +	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *) shost->hostdata;
> +	struct ipr_resource_entry *res;
> +
> +	list_for_each_entry(res, &ioa_cfg->used_res_q, queue) {
> +		if ((res->cfgte.res_addr.bus == starget->channel) &&
> +		    (res->cfgte.res_addr.target == starget->id) &&
> +		    (res->cfgte.res_addr.lun == 0)) {
> +			return res;
> +		}
> +	}
> +
> +	return NULL;
> +}
> +
> +static struct ata_port_info sata_port_info;
> +
> +/**
> + * ipr_target_alloc - Prepare for commands to a SCSI target
> + * @starget:	scsi target struct
> + *
> + * If the device is a SATA device, this function allocates an
> + * ATA port with libata, else it does nothing.
> + *
> + * Return value:
> + * 	0 on success / non-0 on failure
> + **/
> +static int ipr_target_alloc(struct scsi_target *starget)
> +{
> +	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
> +	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *) shost->hostdata;
> +	struct ipr_sata_port *sata_port;
> +	struct ata_port *ap;
> +	struct ipr_resource_entry *res;
> +	unsigned long lock_flags;
> +
> +	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
> +	res = ipr_find_starget(starget);
> +	starget->hostdata = NULL;
> +
> +	if (res && ipr_is_gata(res)) {
> +		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
> +		sata_port = kzalloc(sizeof(*sata_port), GFP_KERNEL);
> +		if (!sata_port)
> +			return -ENOMEM;
> +
> +		ap = ata_sas_port_alloc(&ioa_cfg->ata_host_set, &sata_port_info, shost);
> +		if (ap) {
> +			spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
> +			sata_port->ioa_cfg = ioa_cfg;
> +			sata_port->ap = ap;
> +			sata_port->res = res;
> +
> +			res->sata_port = sata_port;
> +			ap->private_data = sata_port;
> +			starget->hostdata = sata_port;
> +		} else {
> +			kfree(sata_port);
> +			return -ENOMEM;
> +		}
> +	}
> +	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
> +
> +	return 0;
> +}
> +
> +/**
> + * ipr_target_destroy - Destroy a SCSI target
> + * @starget:	scsi target struct
> + *
> + * If the device was a SATA device, this function frees the libata
> + * ATA port, else it does nothing.
> + *
> + **/
> +static void ipr_target_destroy(struct scsi_target *starget)
> +{
> +	struct ipr_sata_port *sata_port = starget->hostdata;
> +
> +	if (sata_port) {
> +		starget->hostdata = NULL;
> +		ata_sas_port_destroy(sata_port->ap);
> +		kfree(sata_port);
> +	}
> +}
> +
> +/**
> + * ipr_find_sdev - Find device based on bus/target/lun.
> + * @sdev:	scsi device struct
> + *
> + * Return value:
> + * 	resource entry pointer if found / NULL if not found
> + **/
> +static struct ipr_resource_entry *ipr_find_sdev(struct scsi_device *sdev)
> +{
> +	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *) sdev->host->hostdata;
> +	struct ipr_resource_entry *res;
> +
> +	list_for_each_entry(res, &ioa_cfg->used_res_q, queue) {
> +		if ((res->cfgte.res_addr.bus == sdev->channel) &&
> +		    (res->cfgte.res_addr.target == sdev->id) &&
> +		    (res->cfgte.res_addr.lun == sdev->lun))
> +			return res;
> +	}
> +
> +	return NULL;
> +}
> +
> +/**
>   * ipr_slave_destroy - Unconfigure a SCSI device
>   * @sdev:	scsi device struct
>   *
> @@ -3183,8 +3342,11 @@ static void ipr_slave_destroy(struct scs
>  	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
>  	res = (struct ipr_resource_entry *) sdev->hostdata;
>  	if (res) {
> +		if (res->sata_port)
> +			ata_port_disable(res->sata_port->ap);
>  		sdev->hostdata = NULL;
>  		res->sdev = NULL;
> +		res->sata_port = NULL;
>  	}
>  	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
>  }
> @@ -3219,13 +3381,45 @@ static int ipr_slave_configure(struct sc
>  		}
>  		if (ipr_is_vset_device(res) || ipr_is_scsi_disk(res))
>  			sdev->allow_restart = 1;
> -		scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
> +		if (ipr_is_gata(res) && res->sata_port) {
> +			scsi_adjust_queue_depth(sdev, 0, IPR_MAX_CMD_PER_ATA_LUN);
> +			ata_sas_slave_configure(sdev, res->sata_port->ap);
> +		} else {
> +			scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
> +		}
>  	}
>  	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
>  	return 0;
>  }
>  
>  /**
> + * ipr_ata_slave_alloc - Prepare for commands to a SATA device
> + * @sdev:	scsi device struct
> + *
> + * This function initializes an ATA port so that future commands
> + * sent through queuecommand will work.
> + *
> + * Return value:
> + * 	0 on success
> + **/
> +static int ipr_ata_slave_alloc(struct scsi_device *sdev)
> +{
> +	struct ipr_sata_port *sata_port = NULL;
> +	int rc = -ENXIO;
> +
> +	ENTER;
> +	if (sdev->sdev_target)
> +		sata_port = sdev->sdev_target->hostdata;
> +	if (sata_port)
> +		rc = ata_sas_port_init(sata_port->ap);
> +	if (rc)
> +		ipr_slave_destroy(sdev);
> +
> +	LEAVE;
> +	return rc;
> +}
> +
> +/**
>   * ipr_slave_alloc - Prepare for commands to a device.
>   * @sdev:	scsi device struct
>   *
> @@ -3248,18 +3442,18 @@ static int ipr_slave_alloc(struct scsi_d
>  
>  	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
>  
> -	list_for_each_entry(res, &ioa_cfg->used_res_q, queue) {
> -		if ((res->cfgte.res_addr.bus == sdev->channel) &&
> -		    (res->cfgte.res_addr.target == sdev->id) &&
> -		    (res->cfgte.res_addr.lun == sdev->lun)) {
> -			res->sdev = sdev;
> -			res->add_to_ml = 0;
> -			res->in_erp = 0;
> -			sdev->hostdata = res;
> -			if (!ipr_is_naca_model(res))
> -				res->needs_sync_complete = 1;
> -			rc = 0;
> -			break;
> +	res = ipr_find_sdev(sdev);
> +	if (res) {
> +		res->sdev = sdev;
> +		res->add_to_ml = 0;
> +		res->in_erp = 0;
> +		sdev->hostdata = res;
> +		if (!ipr_is_naca_model(res))
> +			res->needs_sync_complete = 1;
> +		rc = 0;
> +		if (ipr_is_gata(res)) {
> +			spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
> +			return ipr_ata_slave_alloc(sdev);
>  		}
>  	}
>  
> @@ -3314,7 +3508,8 @@ static int ipr_eh_host_reset(struct scsi
>   * This function issues a device reset to the affected device.
>   * If the device is a SCSI device, a LUN reset will be sent
>   * to the device first. If that does not work, a target reset
> - * will be sent.
> + * will be sent. If the device is a SATA device, a PHY reset will
> + * be sent.
>   *
>   * Return value:
>   *	0 on success / non-zero on failure
> @@ -3325,26 +3520,79 @@ static int ipr_device_reset(struct ipr_i
>  	struct ipr_cmnd *ipr_cmd;
>  	struct ipr_ioarcb *ioarcb;
>  	struct ipr_cmd_pkt *cmd_pkt;
> +	struct ipr_ioarcb_ata_regs *regs;
>  	u32 ioasc;
>  
>  	ENTER;
>  	ipr_cmd = ipr_get_free_ipr_cmnd(ioa_cfg);
>  	ioarcb = &ipr_cmd->ioarcb;
>  	cmd_pkt = &ioarcb->cmd_pkt;
> +	regs = &ioarcb->add_data.u.regs;
>  
>  	ioarcb->res_handle = res->cfgte.res_handle;
>  	cmd_pkt->request_type = IPR_RQTYPE_IOACMD;
>  	cmd_pkt->cdb[0] = IPR_RESET_DEVICE;
> +	if (ipr_is_gata(res)) {
> +		cmd_pkt->cdb[2] = IPR_ATA_PHY_RESET;
> +		ioarcb->add_cmd_parms_len = cpu_to_be32(sizeof(regs->flags));
> +		regs->flags |= IPR_ATA_FLAG_STATUS_ON_GOOD_COMPLETION;
> +	}
>  
>  	ipr_send_blocking_cmd(ipr_cmd, ipr_timeout, IPR_DEVICE_RESET_TIMEOUT);
>  	ioasc = be32_to_cpu(ipr_cmd->ioasa.ioasc);
>  	list_add_tail(&ipr_cmd->queue, &ioa_cfg->free_q);
> +	if (ipr_is_gata(res) && res->sata_port && ioasc != IPR_IOASC_IOA_WAS_RESET)
> +		memcpy(&res->sata_port->ioasa, &ipr_cmd->ioasa.u.gata,
> +		       sizeof(struct ipr_ioasa_gata));
>  
>  	LEAVE;
>  	return (IPR_IOASC_SENSE_KEY(ioasc) ? -EIO : 0);
>  }
>  
>  /**
> + * ipr_sata_reset - Reset the SATA port
> + * @ap:		SATA port to reset
> + * @classes:	class of the attached device
> + *
> + * This function issues a SATA phy reset to the affected ATA port.
> + *
> + * Return value:
> + *	0 on success / non-zero on failure
> + **/
> +static int ipr_sata_reset(struct ata_port *ap, unsigned int *classes)
> +{
> +	struct ipr_sata_port *sata_port = ap->private_data;
> +	struct ipr_ioa_cfg *ioa_cfg = sata_port->ioa_cfg;
> +	struct ipr_resource_entry *res;
> +	unsigned long lock_flags = 0;
> +	int rc = -ENXIO;
> +
> +	ENTER;
> +	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
> +	res = sata_port->res;
> +	if (res) {
> +		rc = ipr_device_reset(ioa_cfg, res);
> +		switch(res->cfgte.proto) {
> +		case IPR_PROTO_SATA:
> +		case IPR_PROTO_SAS_STP:
> +			*classes = ATA_DEV_ATA;
> +			break;
> +		case IPR_PROTO_SATA_ATAPI:
> +		case IPR_PROTO_SAS_STP_ATAPI:
> +			*classes = ATA_DEV_ATAPI;
> +			break;
> +		default:
> +			*classes = ATA_DEV_UNKNOWN;
> +			break;
> +		};
> +	}
> +
> +	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
> +	LEAVE;
> +	return rc;
> +}
> +
> +/**
>   * ipr_eh_dev_reset - Reset the device
>   * @scsi_cmd:	scsi command struct
>   *
> @@ -3360,7 +3608,8 @@ static int __ipr_eh_dev_reset(struct scs
>  	struct ipr_cmnd *ipr_cmd;
>  	struct ipr_ioa_cfg *ioa_cfg;
>  	struct ipr_resource_entry *res;
> -	int rc;
> +	struct ata_port *ap;
> +	int rc = 0;
>  
>  	ENTER;
>  	ioa_cfg = (struct ipr_ioa_cfg *) scsi_cmd->device->host->hostdata;
> @@ -3388,7 +3637,14 @@ static int __ipr_eh_dev_reset(struct scs
>  
>  	res->resetting_device = 1;
>  	scmd_printk(KERN_ERR, scsi_cmd, "Resetting device\n");
> -	rc = ipr_device_reset(ioa_cfg, res);
> +
> +	if (ipr_is_gata(res) && res->sata_port) {
> +		ap = res->sata_port->ap;
> +		spin_unlock_irq(scsi_cmd->device->host->host_lock);
> +		ata_do_eh(ap, NULL, NULL, ipr_sata_reset, NULL);
> +		spin_lock_irq(scsi_cmd->device->host->host_lock);
> +	} else
> +		rc = ipr_device_reset(ioa_cfg, res);
>  	res->resetting_device = 0;
>  
>  	LEAVE;
> @@ -4300,6 +4556,9 @@ static int ipr_queuecommand(struct scsi_
>  		return 0;
>  	}
>  
> +	if (ipr_is_gata(res) && res->sata_port)
> +		return ata_sas_queuecmd(scsi_cmd, done, res->sata_port->ap);
> +
>  	ipr_cmd = ipr_get_free_ipr_cmnd(ioa_cfg);
>  	ioarcb = &ipr_cmd->ioarcb;
>  	list_add_tail(&ipr_cmd->queue, &ioa_cfg->pending_q);
> @@ -4345,6 +4604,26 @@ static int ipr_queuecommand(struct scsi_
>  }
>  
>  /**
> + * ipr_ioctl - IOCTL handler
> + * @sdev:	scsi device struct
> + * @cmd:	IOCTL cmd
> + * @arg:	IOCTL arg
> + *
> + * Return value:
> + * 	0 on success / other on failure
> + **/
> +int ipr_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
> +{
> +	struct ipr_resource_entry *res;
> +
> +	res = (struct ipr_resource_entry *)sdev->hostdata;
> +	if (res && ipr_is_gata(res))
> +		return ata_scsi_ioctl(sdev, cmd, arg);
> +
> +	return -EINVAL;
> +}
> +
> +/**
>   * ipr_info - Get information about the card/driver
>   * @scsi_host:	scsi host struct
>   *
> @@ -4366,10 +4645,45 @@ static const char * ipr_ioa_info(struct 
>  	return buffer;
>  }
>  
> +/**
> + * ipr_scsi_timed_out - Handle scsi command timeout
> + * @scsi_cmd:	scsi command struct
> + *
> + * Return value:
> + * 	EH_NOT_HANDLED
> + **/
> +enum scsi_eh_timer_return ipr_scsi_timed_out(struct scsi_cmnd *scsi_cmd)
> +{
> +	struct ipr_ioa_cfg *ioa_cfg;
> +	struct ipr_cmnd *ipr_cmd;
> +	unsigned long flags;
> +
> +	ENTER;
> +	spin_lock_irqsave(scsi_cmd->device->host->host_lock, flags);
> +	ioa_cfg = (struct ipr_ioa_cfg *)scsi_cmd->device->host->hostdata;
> +
> +	list_for_each_entry(ipr_cmd, &ioa_cfg->pending_q, queue) {
> +		if (ipr_cmd->qc && ipr_cmd->qc->scsicmd == scsi_cmd) {
> +			ipr_cmd->qc->err_mask |= AC_ERR_TIMEOUT;
> +			ipr_cmd->qc->flags |= ATA_QCFLAG_FAILED;
> +			break;
> +		}
> +	}
> +
> +	spin_unlock_irqrestore(scsi_cmd->device->host->host_lock, flags);
> +	LEAVE;
> +	return EH_NOT_HANDLED;
> +}
> +
> +static struct scsi_transport_template ipr_transport_template = {
> +	.eh_timed_out = ipr_scsi_timed_out
> +};
> +
>  static struct scsi_host_template driver_template = {
>  	.module = THIS_MODULE,
>  	.name = "IPR",
>  	.info = ipr_ioa_info,
> +	.ioctl = ipr_ioctl,
>  	.queuecommand = ipr_queuecommand,
>  	.eh_abort_handler = ipr_eh_abort,
>  	.eh_device_reset_handler = ipr_eh_dev_reset,
> @@ -4377,6 +4691,8 @@ static struct scsi_host_template driver_
>  	.slave_alloc = ipr_slave_alloc,
>  	.slave_configure = ipr_slave_configure,
>  	.slave_destroy = ipr_slave_destroy,
> +	.target_alloc = ipr_target_alloc,
> +	.target_destroy = ipr_target_destroy,
>  	.change_queue_depth = ipr_change_queue_depth,
>  	.change_queue_type = ipr_change_queue_type,
>  	.bios_param = ipr_biosparam,
> @@ -4391,6 +4707,329 @@ static struct scsi_host_template driver_
>  	.proc_name = IPR_NAME
>  };
>  
> +/**
> + * ipr_ata_phy_reset - libata phy_reset handler
> + * @ap:		ata port to reset
> + *
> + **/
> +static void ipr_ata_phy_reset(struct ata_port *ap)
> +{
> +	unsigned long flags;
> +	struct ipr_sata_port *sata_port = ap->private_data;
> +	struct ipr_resource_entry *res = sata_port->res;
> +	struct ipr_ioa_cfg *ioa_cfg = sata_port->ioa_cfg;
> +	int rc;
> +
> +	ENTER;
> +	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
> +	while(ioa_cfg->in_reset_reload) {
> +		spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
> +		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
> +		spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
> +	}
> +
> +	if (!ioa_cfg->allow_cmds)
> +		goto out_unlock;
> +
> +	rc = ipr_device_reset(ioa_cfg, res);
> +
> +	if (rc) {
> +		ap->ops->port_disable(ap);
> +		goto out_unlock;
> +	}
> +
> +	switch(res->cfgte.proto) {
> +	case IPR_PROTO_SATA:
> +	case IPR_PROTO_SAS_STP:
> +		ap->device[0].class = ATA_DEV_ATA;
> +		break;
> +	case IPR_PROTO_SATA_ATAPI:
> +	case IPR_PROTO_SAS_STP_ATAPI:
> +		ap->device[0].class = ATA_DEV_ATAPI;
> +		break;
> +	default:
> +		ap->device[0].class = ATA_DEV_UNKNOWN;
> +		ap->ops->port_disable(ap);
> +		break;
> +	};
> +
> +out_unlock:
> +	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
> +	LEAVE;
> +}
> +
> +/**
> + * ipr_ata_post_internal - Cleanup after an internal command
> + * @qc:	ATA queued command
> + *
> + * Return value:
> + * 	none
> + **/
> +static void ipr_ata_post_internal(struct ata_queued_cmd *qc)
> +{
> +	struct ipr_sata_port *sata_port = qc->ap->private_data;
> +	struct ipr_ioa_cfg *ioa_cfg = sata_port->ioa_cfg;
> +	struct ipr_cmnd *ipr_cmd;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
> +	list_for_each_entry(ipr_cmd, &ioa_cfg->pending_q, queue) {
> +		if (ipr_cmd->qc == qc) {
> +			ipr_device_reset(ioa_cfg, sata_port->res);
> +			break;
> +		}
> +	}
> +	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
> +}
> +
> +/**
> + * ipr_tf_read - Read the current ATA taskfile for the ATA port
> + * @ap:	ATA port
> + * @tf:	destination ATA taskfile
> + *
> + * Return value:
> + * 	none
> + **/
> +static void ipr_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
> +{
> +	struct ipr_sata_port *sata_port = ap->private_data;
> +	struct ipr_ioasa_gata *g = &sata_port->ioasa;
> +
> +	tf->feature = g->error;
> +	tf->nsect = g->nsect;
> +	tf->lbal = g->lbal;
> +	tf->lbam = g->lbam;
> +	tf->lbah = g->lbah;
> +	tf->device = g->device;
> +	tf->command = g->status;
> +	tf->hob_nsect = g->hob_nsect;
> +	tf->hob_lbal = g->hob_lbal;
> +	tf->hob_lbam = g->hob_lbam;
> +	tf->hob_lbah = g->hob_lbah;
> +	tf->ctl = g->alt_status;
> +}
> +
> +/**
> + * ipr_copy_sata_tf - Copy a SATA taskfile to an IOA data structure
> + * @regs:	destination
> + * @tf:	source ATA taskfile
> + *
> + * Return value:
> + * 	none
> + **/
> +static void ipr_copy_sata_tf(struct ipr_ioarcb_ata_regs *regs,
> +			     struct ata_taskfile *tf)
> +{
> +	regs->feature = tf->feature;
> +	regs->nsect = tf->nsect;
> +	regs->lbal = tf->lbal;
> +	regs->lbam = tf->lbam;
> +	regs->lbah = tf->lbah;
> +	regs->device = tf->device;
> +	regs->command = tf->command;
> +	regs->hob_feature = tf->hob_feature;
> +	regs->hob_nsect = tf->hob_nsect;
> +	regs->hob_lbal = tf->hob_lbal;
> +	regs->hob_lbam = tf->hob_lbam;
> +	regs->hob_lbah = tf->hob_lbah;
> +	regs->ctl = tf->ctl;
> +}
> +
> +/**
> + * ipr_sata_done - done function for SATA commands
> + * @ipr_cmd:	ipr command struct
> + *
> + * This function is invoked by the interrupt handler for
> + * ops generated by the SCSI mid-layer to SATA devices
> + *
> + * Return value:
> + * 	none
> + **/
> +static void ipr_sata_done(struct ipr_cmnd *ipr_cmd)
> +{
> +	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
> +	struct ata_queued_cmd *qc = ipr_cmd->qc;
> +	struct ipr_sata_port *sata_port = qc->ap->private_data;
> +	struct ipr_resource_entry *res = sata_port->res;
> +
> +	memcpy(&sata_port->ioasa, &ipr_cmd->ioasa.u.gata,
> +	       sizeof(struct ipr_ioasa_gata));
> +	ipr_dump_ioasa(ioa_cfg, ipr_cmd, res);
> +
> +	if (be32_to_cpu(ipr_cmd->ioasa.ioasc_specific) & IPR_ATA_DEVICE_WAS_RESET)
> +		scsi_report_device_reset(ioa_cfg->host, res->cfgte.res_addr.bus,
> +					 res->cfgte.res_addr.target);
> +
> +	if (IPR_IOASC_SENSE_KEY(be32_to_cpu(ipr_cmd->ioasa.ioasc)))
> +		qc->err_mask |= __ac_err_mask(ipr_cmd->ioasa.u.gata.status);
> +	else
> +		qc->err_mask |= ac_err_mask(ipr_cmd->ioasa.u.gata.status);
> +	list_add_tail(&ipr_cmd->queue, &ioa_cfg->free_q);
> +	ata_qc_complete(qc);
> +}
> +
> +/**
> + * ipr_build_ata_ioadl - Build an ATA scatter/gather list
> + * @ipr_cmd:	ipr command struct
> + * @qc:		ATA queued command
> + *
> + **/
> +static void ipr_build_ata_ioadl(struct ipr_cmnd *ipr_cmd,
> +				struct ata_queued_cmd *qc)
> +{
> +	u32 ioadl_flags = 0;
> +	struct ipr_ioarcb *ioarcb = &ipr_cmd->ioarcb;
> +	struct ipr_ioadl_desc *ioadl = ipr_cmd->ioadl;
> +	int len = qc->nbytes + qc->pad_len;
> +	struct scatterlist *sg;
> +
> +	if (len == 0)
> +		return;
> +
> +	if (qc->dma_dir == DMA_TO_DEVICE) {
> +		ioadl_flags = IPR_IOADL_FLAGS_WRITE;
> +		ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_WRITE_NOT_READ;
> +		ioarcb->write_data_transfer_length = cpu_to_be32(len);
> +		ioarcb->write_ioadl_len =
> +			cpu_to_be32(sizeof(struct ipr_ioadl_desc) * ipr_cmd->dma_use_sg);
> +	} else if (qc->dma_dir == DMA_FROM_DEVICE) {
> +		ioadl_flags = IPR_IOADL_FLAGS_READ;
> +		ioarcb->read_data_transfer_length = cpu_to_be32(len);
> +		ioarcb->read_ioadl_len =
> +			cpu_to_be32(sizeof(struct ipr_ioadl_desc) * ipr_cmd->dma_use_sg);
> +	}
> +
> +	ata_for_each_sg(sg, qc) {
> +		ioadl->flags_and_data_len = cpu_to_be32(ioadl_flags | sg_dma_len(sg));
> +		ioadl->address = cpu_to_be32(sg_dma_address(sg));
> +		if (ata_sg_is_last(sg, qc))
> +			ioadl->flags_and_data_len |= cpu_to_be32(IPR_IOADL_FLAGS_LAST);
> +		else
> +			ioadl++;
> +	}
> +}
> +
> +/**
> + * ipr_qc_issue - Issue a SATA qc to a device
> + * @qc:	queued command
> + *
> + * Return value:
> + * 	0 if success
> + **/
> +static unsigned int ipr_qc_issue(struct ata_queued_cmd *qc)
> +{
> +	struct ata_port *ap = qc->ap;
> +	struct ipr_sata_port *sata_port = ap->private_data;
> +	struct ipr_resource_entry *res = sata_port->res;
> +	struct ipr_ioa_cfg *ioa_cfg = sata_port->ioa_cfg;
> +	struct ipr_cmnd *ipr_cmd;
> +	struct ipr_ioarcb *ioarcb;
> +	struct ipr_ioarcb_ata_regs *regs;
> +
> +	if (unlikely(!ioa_cfg->allow_cmds || ioa_cfg->ioa_is_dead))
> +		return -EIO;
> +
> +	ipr_cmd = ipr_get_free_ipr_cmnd(ioa_cfg);
> +	ioarcb = &ipr_cmd->ioarcb;
> +	regs = &ioarcb->add_data.u.regs;
> +
> +	memset(&ioarcb->add_data, 0, sizeof(ioarcb->add_data));
> +	ioarcb->add_cmd_parms_len = cpu_to_be32(sizeof(ioarcb->add_data.u.regs));
> +
> +	list_add_tail(&ipr_cmd->queue, &ioa_cfg->pending_q);
> +	ipr_cmd->qc = qc;
> +	ipr_cmd->done = ipr_sata_done;
> +	ipr_cmd->ioarcb.res_handle = res->cfgte.res_handle;
> +	ioarcb->cmd_pkt.request_type = IPR_RQTYPE_ATA_PASSTHRU;
> +	ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_LINK_DESC;
> +	ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_ULEN_CHK;
> +	ipr_cmd->dma_use_sg = qc->pad_len ? qc->n_elem + 1 : qc->n_elem;
> +
> +	ipr_build_ata_ioadl(ipr_cmd, qc);
> +	regs->flags |= IPR_ATA_FLAG_STATUS_ON_GOOD_COMPLETION;
> +	ipr_copy_sata_tf(regs, &qc->tf);
> +	memcpy(ioarcb->cmd_pkt.cdb, qc->cdb, IPR_MAX_CDB_LEN);
> +	ipr_trc_hook(ipr_cmd, IPR_TRACE_START, IPR_GET_PHYS_LOC(res->cfgte.res_addr));
> +
> +	switch (qc->tf.protocol) {
> +	case ATA_PROT_NODATA:
> +	case ATA_PROT_PIO:
> +		break;
> +
> +	case ATA_PROT_DMA:
> +		regs->flags |= IPR_ATA_FLAG_XFER_TYPE_DMA;
> +		break;
> +
> +	case ATA_PROT_ATAPI:
> +	case ATA_PROT_ATAPI_NODATA:
> +		regs->flags |= IPR_ATA_FLAG_PACKET_CMD;
> +		break;
> +
> +	case ATA_PROT_ATAPI_DMA:
> +		regs->flags |= IPR_ATA_FLAG_PACKET_CMD;
> +		regs->flags |= IPR_ATA_FLAG_XFER_TYPE_DMA;
> +		break;
> +
> +	default:
> +		WARN_ON(1);
> +		return -1;
> +	}
> +
> +	mb();
> +	writel(be32_to_cpu(ioarcb->ioarcb_host_pci_addr),
> +	       ioa_cfg->regs.ioarrin_reg);
> +	return 0;
> +}
> +
> +/**
> + * ipr_ata_check_status - Return last ATA status
> + * @ap:	ATA port
> + *
> + * Return value:
> + * 	ATA status
> + **/
> +static u8 ipr_ata_check_status(struct ata_port *ap)
> +{
> +	struct ipr_sata_port *sata_port = ap->private_data;
> +	return sata_port->ioasa.status;
> +}
> +
> +/**
> + * ipr_ata_check_altstatus - Return last ATA altstatus
> + * @ap:	ATA port
> + *
> + * Return value:
> + * 	Alt ATA status
> + **/
> +static u8 ipr_ata_check_altstatus(struct ata_port *ap)
> +{
> +	struct ipr_sata_port *sata_port = ap->private_data;
> +	return sata_port->ioasa.alt_status;
> +}
> +
> +static struct ata_port_operations ipr_sata_ops = {
> +	.port_disable = ata_port_disable,
> +	.check_status = ipr_ata_check_status,
> +	.check_altstatus = ipr_ata_check_altstatus,
> +	.dev_select = ata_noop_dev_select,
> +	.phy_reset = ipr_ata_phy_reset,
> +	.post_internal_cmd = ipr_ata_post_internal,
> +	.tf_read = ipr_tf_read,
> +	.qc_prep = ata_noop_qc_prep,
> +	.qc_issue = ipr_qc_issue,
> +	.port_start = ata_sas_port_start,
> +	.port_stop = ata_sas_port_stop
> +};
> +
> +static struct ata_port_info sata_port_info = {
> +	.host_flags	= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY | ATA_FLAG_SATA_RESET |
> +	ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA,
> +	.pio_mask	= 0x10, /* pio4 */
> +	.mwdma_mask = 0x07,
> +	.udma_mask	= 0x7f, /* udma0-6 */
> +	.port_ops	= &ipr_sata_ops
> +};
> +
>  #ifdef CONFIG_PPC_PSERIES
>  static const u16 ipr_blocked_processors[] = {
>  	PV_NORTHSTAR,
> @@ -6374,6 +7013,9 @@ static int __devinit ipr_probe_ioa(struc
>  
>  	ioa_cfg = (struct ipr_ioa_cfg *)host->hostdata;
>  	memset(ioa_cfg, 0, sizeof(struct ipr_ioa_cfg));
> +	host->transportt = &ipr_transport_template;
> +	ata_host_set_init(&ioa_cfg->ata_host_set, &pdev->dev,
> +			  sata_port_info.host_flags, &ipr_sata_ops);
>  
>  	ioa_cfg->chip_cfg = ipr_get_chip_cfg(dev_id);
>  
> diff -puN drivers/scsi/Kconfig~ipr_sata_with_libata_changes drivers/scsi/Kconfig
> --- libata-dev/drivers/scsi/Kconfig~ipr_sata_with_libata_changes	2006-08-07 12:44:09.000000000 -0500
> +++ libata-dev-bjking1/drivers/scsi/Kconfig	2006-08-07 12:44:09.000000000 -0500
> @@ -1124,6 +1124,7 @@ config SCSI_IPR
>  	tristate "IBM Power Linux RAID adapter support"
>  	depends on PCI && SCSI
>  	select FW_LOADER
> +	select SCSI_SATA
>  	---help---
>  	  This driver supports the IBM Power Linux family RAID adapters.
>  	  This includes IBM pSeries 5712, 5703, 5709, and 570A, as well
> diff -puN drivers/scsi/Makefile~ipr_sata_with_libata_changes drivers/scsi/Makefile
> --- libata-dev/drivers/scsi/Makefile~ipr_sata_with_libata_changes	2006-08-07 12:44:09.000000000 -0500
> +++ libata-dev-bjking1/drivers/scsi/Makefile	2006-08-07 12:44:09.000000000 -0500
> @@ -120,7 +120,7 @@ obj-$(CONFIG_SUN3X_ESP)		+= NCR53C9x.o	s
>  obj-$(CONFIG_SCSI_FCAL)		+= fcal.o
>  obj-$(CONFIG_SCSI_LASI700)	+= 53c700.o lasi700.o
>  obj-$(CONFIG_SCSI_NSP32)	+= nsp32.o
> -obj-$(CONFIG_SCSI_IPR)		+= ipr.o
> +obj-$(CONFIG_SCSI_IPR)		+= libata.o ipr.o
>  obj-$(CONFIG_SCSI_IBMVSCSI)	+= ibmvscsi/
>  obj-$(CONFIG_SCSI_SATA_AHCI)	+= libata.o ahci.o
>  obj-$(CONFIG_SCSI_SATA_SVW)	+= libata.o sata_svw.o
> _
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
