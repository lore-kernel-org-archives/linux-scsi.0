From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 2/2] ata: Fix the dma state machine lockup for the
 IDENTIFY DEVICE PIO mode command.
Date: Tue, 24 Jun 2014 17:55:17 -0400
Message-ID: <20140624215517.GF14909@htj.dyndns.org>
References: <1403517193-29776-1-git-send-email-stripathi@apm.com>
 <1403517193-29776-3-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1403517193-29776-3-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Mon, Jun 23, 2014 at 03:23:13PM +0530, Suman Tripathi wrote:
> This patch fixes the dma state machine lockup due to the processing
> of IDENTIFY DEVICE PIO mode command. The X-Gene AHCI controller
> has an errata in which it cannot clear the BSY bit after
> receiving the PIO setup FIS and results the dma state machine to go
> into the CMFatalErrorUpdate state resulting in the dma state
> machine lockup. This patch also removes the dma restart workaround
> from the read_id function as the read_id function is only called by
> libata layer for ATA_INTERNAL commands. But for somecases eg:
> PORT MULTIPLIER and udev, the framework will enumerate using SCSI
> commands and it will not call read_id function.

I assume that it's verified that only IDENTIFY is affected?  Please
try to explicitly follow up on the previous discussions.  It makes
keeping track a lot easier for the reviewers.

>  /**
> + * xgene_ahci_qc_issue - Issue commands to the device
> + * @qc: Command to issue
> + *
> + * Due to H/W errata, for the IDENTIFY DEVICE command controller is unable to
> + * clear the BSY bit after receiving the PIO setup FIS and results the dma
> + * state machine to go into the CMFatalErrorUpdate state resulting in the dma
> + * state machine lockup. By restarting the dma engine to move it removes the
> + * controller out of lock up state.
> + */
> +static unsigned int xgene_ahci_qc_issue(struct ata_queued_cmd *qc)
> +{
> +	struct ata_port *ap = qc->ap;
> +	struct ahci_host_priv *hpriv = ap->host->private_data;
> +	struct xgene_ahci_context *ctx = hpriv->plat_data;
> +	int rc = 0;
> +
> +	/*
> +	 * Restart the dma engine if the last cmd issued
> +	 * is IDENTIFY DEVICE command
> +	 */

I think the function comment is doing a good job of explaining and we
can lose the above comment.  Comments which explain the code itself is
useful if the logic involved is complex but I don't think that's the
case here.

> +	if (unlikely(ctx->last_cmd[ap->port_no] == ATA_CMD_ID_ATA))
> +		ahci_restart_engine(ap);
> +
> +	rc = ahci_qc_issue(qc);
> +
> +	/* Save the last command issued */
> +	ctx->last_cmd[ap->port_no] = qc->tf.command;
> +
> +	return rc;
> +}
...
> diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
> index d1c9122..1b86cf4 100644
> --- a/drivers/ata/libahci.c
> +++ b/drivers/ata/libahci.c
> @@ -68,7 +68,6 @@ static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
> 
>  static int ahci_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
>  static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
> -static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc);
>  static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc);
>  static int ahci_port_start(struct ata_port *ap);
>  static void ahci_port_stop(struct ata_port *ap);
> @@ -1952,7 +1951,7 @@ irqreturn_t ahci_interrupt(int irq, void *dev_instance)
>  }
>  EXPORT_SYMBOL_GPL(ahci_interrupt);
> 
> -static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)
> +unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)
>  {
>  	struct ata_port *ap = qc->ap;
>  	void __iomem *port_mmio = ahci_port_base(ap);
> @@ -1981,6 +1980,7 @@ static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)
> 
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(ahci_qc_issue);

Can we please do this in the previous patch?  "implement
ahci_restart_engine() and export ahci_qc_issue()" is completely fine
with me.  Just note in the description that a following patch will
make use of them.

Thanks.

-- 
tejun
