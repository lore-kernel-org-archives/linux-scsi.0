From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v12 2/3] ata: Add APM X-Gene SoC AHCI SATA host
 controller driver
Date: Fri, 21 Feb 2014 12:55:42 -0500
Message-ID: <20140221175542.GA12830@htj.dyndns.org>
References: <1393004853-25994-1-git-send-email-lho@apm.com>
 <1393004853-25994-2-git-send-email-lho@apm.com>
 <1393004853-25994-3-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1393004853-25994-3-git-send-email-lho@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hello, Loc.

On Fri, Feb 21, 2014 at 10:47:32AM -0700, Loc Ho wrote:
> +/**
> + * Custom Query ID command
> + *
> + * Due to HW errata, we must stop and re-start the port state machine after
> + * read ID command. Also disable support for DEVSLP as hardware don't support
> + * it.
> + */

Sorry about not being clear before but /** function comment means
something like

/**
 * ata_scsi_port_error_handler - recover the port after the commands
 * @host: SCSI host containing the port
 * @ap: the ATA port
 *
 * Handle the recovery of the port @ap after all the commands have
 * been recovered.
 */

> +static int xgene_ahci_do_hardreset(struct ata_link *link,
> +				   unsigned long deadline, bool *online)
> +{
> +	const unsigned long *timing = sata_ehc_deb_timing(&link->eh_context);
> +	struct ata_port *ap = link->ap;
> +	struct ahci_host_priv *hpriv = ap->host->private_data;
> +	struct xgene_ahci_context *ctx = pdata_to_ctx(hpriv->plat_data);
> +	struct ahci_port_priv *pp = ap->private_data;
> +	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
> +	void __iomem *port_mmio = ahci_port_base(ap);
> +	struct ata_taskfile tf;
> +	int first_time = 1;
> +	int rc;
> +	u32 val;
> +	int i;
> +
> +hardreset_retry:
> +	/* clear D2H reception area to properly wait for D2H FIS */
> +	ata_tf_init(link->device, &tf);
> +	tf.command = ATA_BUSY;
> +	ata_tf_to_fis(&tf, 0, 0, d2h_fis);
> +	rc = sata_link_hardreset(link, timing, deadline, online,
> +				 ahci_check_ready);
> +
> +	if (*online) {
> +		/* Check to ensure that the disk comes up in matching speed */
> +		if (first_time) {
> +			u32 gen_speed;
> +
> +			first_time = 0;
> +			sata_scr_read(link, SCR_STATUS, &gen_speed);
> +			gen_speed = (gen_speed >> 4) & 0xf;
> +			if (gen_speed == 1 || gen_speed == 2) {
> +				/*
> +				 * For Gen2/1 and first time, let's check again
> +				 * with Gen2/1 PHY to ensure actual Gen2/1 disk.
> +				 */

Can you please go back two reviews and re-read what I requested?
Also, if you're unsure, please don't hesitate to ask back.  It's
usually a lot easier for both parties than iterating through patchsets
without properly understanding each other.

Thanks.

-- 
tejun
