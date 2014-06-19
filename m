From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 2/2] ata: Fix the dma state machine lockup for the
 IDENTIFY DEVICE PIO mode command.
Date: Thu, 19 Jun 2014 10:21:20 -0400
Message-ID: <20140619142120.GC26904@htj.dyndns.org>
References: <1403160654-31612-1-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:46527 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756435AbaFSOVY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jun 2014 10:21:24 -0400
Content-Disposition: inline
In-Reply-To: <1403160654-31612-1-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>

Two more things.

On Thu, Jun 19, 2014 at 12:20:54PM +0530, Suman Tripathi wrote:
>  /**
> + * xgene_ahci_qc_issue - Issue commands to the device
> + * @qc: Command to issue
> + *
> + * Due to H/W errata, for the IENTIFY DEVICE command
> + * controller is unable to clear the BSY bit after
> + * receiving the PIO setup FIS and results the dma
> + * state machine to go into the CMFatalErrorUpdate
> + * state resulting in the dma state machine lockup.
> + * By restarting the dma engine to move it removes
> + * the controller out of lock up state.

Please re-flow it to 75th or so column.

> + */
> +static unsigned int xgene_ahci_qc_issue(struct ata_queued_cmd *qc)
> +{
> +	struct ata_port *ap = qc->ap;
> +	void __iomem *port_mmio = ahci_port_base(ap);
> +	struct ahci_port_priv *pp = ap->private_data;
> +	struct ahci_host_priv *hpriv = ap->host->private_data;
> +	struct xgene_ahci_context *ctx = hpriv->plat_data;
> +
> +	/* Keep track of the currently active link.  It will be used
> +	 * in completion path to determine whether NCQ phase is in
> +	 * progress.
> +	 */
> +	pp->active_link = qc->dev->link;
> +
> +	/*
> +	 * Restart the dma engine if the last cmd issued
> +	 * is IDENTIFY DEVICE command
> +	 */
> +	if (unlikely(ctx->last_cmd[ap->port_no] == ATA_CMD_ID_ATA))
> +		ahci_restart_engine(ap);
> +
> +	if (qc->tf.protocol == ATA_PROT_NCQ)
> +		writel(1 << qc->tag, port_mmio + PORT_SCR_ACT);
> +
> +	if (pp->fbs_enabled && pp->fbs_last_dev != qc->dev->link->pmp) {
> +		u32 fbs = readl(port_mmio + PORT_FBS);
> +		fbs &= ~(PORT_FBS_DEV_MASK | PORT_FBS_DEC);
> +		fbs |= qc->dev->link->pmp << PORT_FBS_DEV_OFFSET;
> +		writel(fbs, port_mmio + PORT_FBS);
> +		pp->fbs_last_dev = qc->dev->link->pmp;
> +	}
> +
> +	writel(1 << qc->tag, port_mmio + PORT_CMD_ISSUE);
> +
> +	/* Save the last command issued */
> +	ctx->last_cmd[ap->port_no] = qc->tf.command;
> +
> +	ahci_sw_activity(qc->dev->link);
> +
> +	return 0;
> +}

Why copy the whole function body?  Can't you do the following?

static unsigned int xgene_ahci_qc_issue(struct ata_queued_cmd *qc)
{
	unsigned int ret;

	if (unlikely(last_cmd == IDENTIFY))
		ahci_restart_engine(ap);

	ret = ahci_qc_issue(qc);

	last_cmd = qc->tf.command;

	return ret;
}

Thanks.

-- 
tejun
