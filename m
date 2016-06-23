From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v7] ibmvscsis: Initial commit of IBM VSCSI Tgt Driver
Date: Thu, 23 Jun 2016 07:22:13 -0700
Message-ID: <20160623142213.GA30453@infradead.org>
References: <1464274721-36453-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <1466433229-8812-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49791 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbcFWOWR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jun 2016 10:22:17 -0400
Content-Disposition: inline
In-Reply-To: <1466433229-8812-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: nab@linux-iscsi.org, joe@perches.com, hch@infradead.org, mikecyr@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, akpm@linux-foundation.org, bart.vanassche@sandisk.com, gregkh@linuxfoundation.org, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com

> -config SCSI_SRP
> -	tristate "SCSI RDMA Protocol helper library"
> -	depends on SCSI && PCI
> -	select SCSI_TGT
> -	help
> -	  If you wish to use SRP target drivers, say Y.
> -
> -	  To compile this driver as a module, choose M here: the
> -	  module will be called libsrp.
> -

Please split that removal of libsrp into a separate patch before
adding the new driver.

> new file mode 100644
> index 0000000..887574d
> --- /dev/null
> +++ b/drivers/scsi/ibmvscsi_tgt/Makefile
> @@ -0,0 +1,4 @@
> +obj-$(CONFIG_SCSI_IBMVSCSIS)	+= ibmvscsis.o
> +
> +ibmvscsis-objs := libsrp.o ibmvscsi_tgt.o

please use module-y for adding objects.  Also what's the reason
for splitting these files?

> +/*******************************************************************************
> + * IBM Virtual SCSI Target Driver
> + * Copyright (C) 2003-2005 Dave Boutcher (boutcher@us.ibm.com) IBM Corp.
> + *			   Santiago Leon (santil@us.ibm.com) IBM Corp.
> + *			   Linda Xie (lxie@us.ibm.com) IBM Corp.
> + *
> + * Copyright (C) 2005-2011 FUJITA Tomonori <tomof@acm.org>
> + * Copyright (C) 2010 Nicholas A. Bellinger <nab@kernel.org>
> + * Copyright (C) 2016 Bryant G. Ly <bryantly@linux.vnet.ibm.com> IBM Corp.
> + *
> + * Authors: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> + * Authors: Michael Cyr <mikecyr@linux.vnet.ibm.com>

What's the reational for the copyright vs Authors lines?

> +#include "ibmvscsi_tgt.h"
> +
> +#ifndef H_GET_PARTNER_INFO
> +#define H_GET_PARTNER_INFO      0x0000000000000008LL
> +#endif

Should this be in a header with the other hcalls?

> +static const char ibmvscsis_driver_name[] = "ibmvscsis";

I think you can just assign the name directly in the driver ops
structure.

> +static const char ibmvscsis_workq_name[] = "ibmvscsis";

This one seems unused.

> +		vscsi->flags &= (~PROCESSING_MAD);

No need for the braces here. (ditto for many other places later on)

> +static long ibmvscsis_parse_command(struct scsi_info *vscsi,
> +				    struct viosrp_crq *crq);

Can you avoid forward declarations where easily possible, and if not
keep them all at the beginning of the file?

> +static struct ibmvscsis_tport *ibmvscsis_lookup_port(const char *name)
> +{
> +	struct ibmvscsis_tport *tport = NULL;
> +	struct vio_dev *vdev;
> +	struct scsi_info *vscsi;
> +
> +	spin_lock_bh(&ibmvscsis_dev_lock);
> +	list_for_each_entry(vscsi, &ibmvscsis_dev_list, list) {
> +		vdev = vscsi->dma_dev;
> +		if (!strcmp(dev_name(&vdev->dev), name)) {
> +			tport = &vscsi->tport;
> +			break;
> +		}
> +	}
> +	spin_unlock_bh(&ibmvscsis_dev_lock);

Without grabbing a reference this looks inherently unsafe.

> +static void ibmvscsis_scheduler(struct work_struct *work)

Odd name for a work item.

> +{
> +	struct ibmvscsis_cmd *cmd = container_of(work, struct ibmvscsis_cmd,
> +						 work);
> +	struct scsi_info *vscsi = cmd->adapter;
> +
> +	spin_lock_bh(&vscsi->intr_lock);
> +
> +	/* Remove from schedule_q */
> +	list_del(&cmd->list);

What do you need the schedule_q for as the workqueue already tracks
the commands?

> +static int ibmvscsis_alloc_cmds(struct scsi_info *vscsi, int num)
> +{
> +	struct ibmvscsis_cmd *cmd;
> +	int i;
> +
> +	INIT_LIST_HEAD(&vscsi->free_cmd);
> +	vscsi->cmd_pool = kcalloc(num, sizeof(struct ibmvscsis_cmd),
> +				  GFP_KERNEL);
> +	if (!vscsi->cmd_pool)
> +		return -ENOMEM;
> +
> +	for (i = 0, cmd = (struct ibmvscsis_cmd *)vscsi->cmd_pool; i < num;
> +	     i++, cmd++) {
> +		cmd->adapter = vscsi;
> +		INIT_WORK(&cmd->work, ibmvscsis_scheduler);
> +		list_add_tail(&cmd->list, &vscsi->free_cmd);
> +	}
> +
> +	return 0;
> +}

Why can't you use the existing infrastructure for cmd pools in the
target core?

> +static void ibmvscsis_alloc_common_locks(struct scsi_info *vscsi)
> +{
> +	spin_lock_init(&vscsi->intr_lock);
> +}
> +
> +static void ibmvscsis_free_common_locks(struct scsi_info *vscsi)
> +{
> +	/* Nothing to do here */
> +}

No need for these wrapers.

> +static irqreturn_t ibmvscsis_interrupt(int dummy, void *data)
> +{
> +	struct scsi_info *vscsi = data;
> +
> +	vio_disable_interrupts(vscsi->dma_dev);
> +	tasklet_schedule(&vscsi->work_task);
> +
> +	return IRQ_HANDLED;
> +}

Can you explain the need for the tasklet?  There shouldn't be a whole
lot of working before passing the command off to the workqueue anyway.

> +	rc = srp_transfer_data(cmd, &vio_iu(iue)->srp.cmd, ibmvscsis_rdma, 1,
> +			       1);
> +	if (rc) {
> +		pr_err("srp_transfer_data failed: %d\n", rc);
> +		sd = se_cmd->sense_buffer;
> +		se_cmd->scsi_sense_length = 18;
> +		memset(se_cmd->sense_buffer, 0, se_cmd->scsi_sense_length);
> +		/* Current error */
> +		sd[0] = 0x70;
> +		/* sense key = Medium Error */
> +		sd[2] = 3;
> +		/* additional length (length - 8) */
> +		sd[7] = 10;
> +		/* asc/ascq 0x801 = Logical Unit Communication time-out */
> +		sd[12] = 8;
> +		sd[13] = 1;

The Fabrics driver shouldn't generate it's own sense codes.  This
would for example break for a lun using descriptor format sense data.
