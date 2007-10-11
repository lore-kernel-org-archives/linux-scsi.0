From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 3/3] faster workaround
Date: Thu, 11 Oct 2007 14:26:28 +0100
Message-ID: <20071011142628.48272a4a@the-village.bc.nu>
References: <200710081709.18253.bs@q-leap.de>
	<200710101112.20448.bs@q-leap.de>
	<200710111409.56210.bs@q-leap.de>
	<200710111433.23833.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55546 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752307AbXJKNVz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Oct 2007 09:21:55 -0400
In-Reply-To: <200710111433.23833.bs@q-leap.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> -static void ata_fill_sg(struct ata_queued_cmd *qc)
> +void ata_fill_sg(struct ata_queued_cmd *qc)
>  {
>  	struct ata_port *ap = qc->ap;
>  	struct scatterlist *sg;
> @@ -4217,10 +4217,15 @@ int ata_check_atapi_dma(struct ata_queue
>   */
>  void ata_qc_prep(struct ata_queued_cmd *qc)
>  {
> +	struct ata_port *ap = qc->ap;
> +
>  	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
>  		return;
>  
> -	ata_fill_sg(qc);
> +	if (ap->ops->fill_sg)
> +		ap->ops->fill_sg(qc);
> +	else
> +		ata_fill_sg(qc);
>  }

Its probably better to simply make your own sil_qc_prep function for this
case rather than touch the core code.

> -	.sg_tablesize		= LIBATA_MAX_PRD,
> +	.sg_tablesize		= 120, /* max 15 kiB sectors ? */

If you are just fiddling with the way the data is split then
LIBATA_MAX_PRD - 1 should be totally safe)

>  	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
>  	.emulated		= ATA_SHT_EMULATED,
> -	.use_clustering		= ATA_SHT_USE_CLUSTERING,
> +	.use_clustering		= 1,

Un-needed

>  	.proc_name		= DRV_NAME,
> -	.dma_boundary		= ATA_DMA_BOUNDARY,
> +	.dma_boundary		= 0x1fff,

Ok

>  	.slave_configure	= ata_scsi_slave_config,
>  	.slave_destroy		= ata_scsi_slave_destroy,
>  	.bios_param		= ata_std_bios_param,

> +	/* Errata workaround: if last segment is exactly 8K, split
> +	 * into 7.5K and 512b pieces.
> +	 */
> +	len = le32_to_cpu(ap->prd[idx].flags_len) & 0xffff;
> +	if (len == 8192) {
> +		addr = le32_to_cpu(ap->prd[idx].addr);
> +		ap->prd[idx].flags_len = cpu_to_le32(15 * 512);
> +
> +		idx++;
> +		ap->prd[idx].addr = cpu_to_le32(addr + (15 * 512));
> +		ap->prd[idx].flags_len = cpu_to_le32(512 | ATA_PRD_EOT);
> +	}
> +}

And since in this approach we are merely splitting the last PRD entry in
some obscure cases we might as well do it by default as it should have no
performance impact of any note done this way.


