From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v11 2/3] ata: Add APM X-Gene SoC AHCI SATA host
 controller driver
Date: Fri, 21 Feb 2014 11:06:19 -0500
Message-ID: <20140221160619.GC460@htj.dyndns.org>
References: <1392621433-5566-1-git-send-email-lho@apm.com>
 <1392621433-5566-2-git-send-email-lho@apm.com>
 <1392621433-5566-3-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1392621433-5566-3-git-send-email-lho@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hello, Loc.

On Mon, Feb 17, 2014 at 12:17:12AM -0700, Loc Ho wrote:
...
> +static int xgene_ahci_get_channel(struct ata_host *host, struct ata_port *port)
> +{
> +	int i;
> +	for (i = 0; i < host->n_ports; i++)
> +		if (host->ports[i] == port)
> +			return i;
> +	return -1;
> +}

Didn't I ask you why you weren't using ap->port_no?

> +/*
> + * Custom Query ID command
> + *
> + * Due to HW errata, we must stop and re-start the port state machine after
> + * read ID command. Also disable support for DEVSLP as hardware don't support
> + * it.
> + */

Please use /** function comment style.

> +static unsigned int xgene_ahci_read_id(struct ata_device *dev,
> +				       struct ata_taskfile *tf, u16 *id)
> +{
> +	u32 err_mask;
> +	void __iomem *port_mmio = ahci_port_base(dev->link->ap);
> +
> +	err_mask = ata_do_dev_read_id(dev, tf, id);
> +	if (err_mask)
> +		return err_mask;
> +
> +	/* Mask reserved area. Bit78 spec of Link Power Management

Another review point which hasn't been addressed.  Please use
fully-winged comments for multiline comments.

> +	 * bit15-8: reserved
> +	 * bit7: NCQ autosence
> +	 * bit6: Software settings preservation supported
> +	 * bit5: reserved
> +	 * bit4: In-order sata delivery supported
> +	 * bit3: DIPM requests supported
> +	 * bit2: DMA Setup FIS Auto-Activate optimization supported
> +	 * bit1: DMA Setup FIX non-Zero buffer offsets supported
> +	 * bit0: Reserved
> +	 *
> +	 * Clear reserved bit (DEVSLP bit) as we don't support DEVSLP
> +	 */
> +	id[78] &= 0x00FF;
> +
> +	/* Restart the port if required due to HW errata */
> +	if (!readl(port_mmio + PORT_CMD_ISSUE)) {
> +		writel(PORT_CMD_FIS_RX, port_mmio + PORT_CMD);
> +		readl(port_mmio + PORT_CMD);	/* Force a barrier */
> +		writel(PORT_CMD_FIS_RX | PORT_CMD_START, port_mmio + PORT_CMD);
> +		readl(port_mmio + PORT_CMD);	/* Force a barrier */
> +	}
> +	return 0;
> +}
...
> +static int xgene_ahci_do_hardreset(struct ata_link *link,
> +				   unsigned long deadline, bool *online)
> +{
...
> +hardreset_retry:
> +	/* clear D2H reception area to properly wait for D2H FIS */
> +	ata_tf_init(link->device, &tf);
> +	tf.command = ATA_BUSY;
> +	ata_tf_to_fis(&tf, 0, 0, d2h_fis);
> +	rc = sata_link_hardreset(link, timing, deadline, online,
> +				 ahci_check_ready);
> +
> +	if (*online) {
> +		int chan = xgene_ahci_get_channel(ap->host, ap);
> +
> +		/* Check to ensure that the disk comes up in matching speed */
> +		if (first_time) {
> +			u32 gen_speed;
> +
> +			first_time = 0;
> +			sata_scr_read(link, SCR_STATUS, &gen_speed);
> +			gen_speed = (gen_speed >> 4) & 0xf;
> +			if (gen_speed == 1 || gen_speed == 2) {
> +				/* For Gen2/1 and first time, let's check again
> +				 * with Gen2/1 PHY to ensure actual Gen2/1 disk.
> +				 */

Another review point not addressed.

Thanks.

-- 
tejun
