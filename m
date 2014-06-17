From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 2/2] ata: Fix the dma state machine lockup for the
 IDENTIFY DEVICE PIO mode command.
Date: Tue, 17 Jun 2014 12:31:44 -0400
Message-ID: <20140617163144.GJ31819@htj.dyndns.org>
References: <1402911336-31788-1-git-send-email-stripathi@apm.com>
 <1402911336-31788-3-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:33127 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964938AbaFQQbs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jun 2014 12:31:48 -0400
Content-Disposition: inline
In-Reply-To: <1402911336-31788-3-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com

On Mon, Jun 16, 2014 at 03:05:36PM +0530, Suman Tripathi wrote:
> This patch fixes the dma state machine lockup due to the IDENTIFY DEVICE PIO mode command. The controller is unable to clear the BSY bit after receiving the PIO setup FIS and results the dma state machine to go into the CMFatalErrorUpdate state resulting in the dma state machine lockup.

Ditto on description formatting and SOB.  Also, please describe why
this patch is removing the restart from read_id.

> +int ahci_complete_pio_cmd(struct ata_port *ap, u32 cmd_done)
> +{
> +	struct ata_queued_cmd *qc;
> +
> +	while (cmd_done) {
> +		unsigned int tag = __ffs(cmd_done);
> +
> +		qc = ata_qc_from_tag(ap, tag);
> +		if (qc) {
> +			/*
> +			 * For the IDENTIFY DEVICE PIO command,
> +			 * some controller's unable to clear the BSY bit after
> +			 * receiving the PIO Setup FIS from device resulting
> +			 * the DMA state to go into CMFatalErrorUpdate state.
> +			 * So need to restart the dma engine to get the
> +			 * controller out of this state.
> +			 */
> +			if (qc->tf.command == ATA_CMD_ID_ATA)
> +				ahci_restart_engine(ap);
> +		}
> +		cmd_done &= ~(1 << tag);
> +	}
> +
> +	return 0;
> +}
> +
>  static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
>  {
>  	struct ahci_host_priv *hpriv = ap->host->private_data;
> @@ -1778,6 +1804,14 @@ static void ahci_handle_port_interrupt(struct ata_port *ap,
>  	}
> 
> 
> +	/* Due to HW errata, some controllers need special handling
> +	 * of the completion of some PIO commands.
> +	 */
> +	if (hpriv->flags & AHCI_HFLAG_BROKEN_PIO_CMD) {
> +		u32 cmd_done = ap->qc_active ^ qc_active;
> +		ahci_complete_pio_cmd(ap, cmd_done);
> +	}

Heh, I feel this is a bit too specific to bury in libahci.c and don't
really like adding this sort workaround in the hot path for everybody.
Then again, ahci interrupt handler isn't exactly structured in a way
which is easy to wrap and create a custom one.

Does this have to happen from interrupt path tho?  Can't you just
record the last protocol executed and restart the engine on the next
qc_issue?

Thanks.

-- 
tejun
