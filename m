From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4 3/4] ata: Add APM X-Gene SoC SATA host controller driver
Date: Thu, 21 Nov 2013 14:01:14 +0100
Message-ID: <201311211401.14836.arnd@arndb.de>
References: <1385014298-15700-1-git-send-email-lho@apm.com>
 <1385014298-15700-3-git-send-email-lho@apm.com>
 <1385014298-15700-4-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1385014298-15700-4-git-send-email-lho@apm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Loc Ho <lho@apm.com>
Cc: devicetree@vger.kernel.org, Suman Tripathi <stripathi@apm.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jcm@redhat.com, tj@kernel.org, olof@lixom.net, Tuan Phan <tphan@apm.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On Thursday 21 November 2013, Loc Ho wrote:

> +struct xgene_ahci_context {
> +	struct ahci_host_priv  hpriv;
> +	struct device *dev;
> +	int irq;		/* IRQ */
> +	void __iomem *csr_base;	/* CSR base address of IP */
> +	u64 csr_phys;		/* Physical address of CSR base address */
> +	void __iomem *mmio_base; /* AHCI I/O base address */
> +	u64 mmio_phys;		/* Physical address of MMIO base address */
> +	void __iomem *ahbc_csr_base; /* Used for IOB flushing if non-zero */
> +	void __iomem *ahbc_io_base;  /* Used for IOB flushing if non-zero *

I still think the flushing should be split out into a separate subsystem of some
sort, or into common code. Can you explain why it is needed in this driver, and
what other parts of your SoC also need to do the same thing?

Maybe we can have custom dma_map_ops for your platform so the flushing automatically
happens in dma_unmap_sg().

> +/* These wrapper existed for future expansion to support running on MSLIM
> +   cores. */
> +#define xgene_ahci_fill_cmd_slot	ahci_fill_cmd_slot
> +#define xgene_ahci_exec_polled_cmd	ahci_exec_polled_cmd
> +#define xgene_ahci_to_axi(x)		(x)
> +#define xgene_ahci_dflush(x, ...)

In general, I recommend against adding code "for future expansion", because you
never actually know what that future expansion is going to be like until the
patches have been reviewed.

> +static void xgene_wr_flush(void *addr, u32 val)
> +{
> +	writel(val, addr);
> +	pr_debug("X-Gene SATA CSR WR: 0x%p value: 0x%08x\n", addr, val);
> +	val = readl(addr);
> +}

This seems to be a rather expensive operation. Can you explain what the extra
flush is trying to achieve here? Normally you'd want to eliminate any readl()
from high-performance device drivers if you can. Is this used in any fast
path?

> +static int xgene_ahci_init_memram(struct xgene_ahci_context *ctx)
> +{
> +	void *diagcsr = ctx->csr_base + SATA_DIAG_OFFSET;
> +	int timeout;
> +	u32 val;
> +
> +	xgene_rd(diagcsr + REGSPEC_CFG_MEM_RAM_SHUTDOWN_ADDR, &val);
> +	if (val == 0) {
> +		dev_dbg(ctx->dev, "memory already released from shutdown\n");
> +		return 0;
> +	}
> +	dev_dbg(ctx->dev, "Release memory from shutdown\n");
> +	/* SATA controller memory in shutdown. Remove from shutdown. */
> +	xgene_wr_flush(diagcsr + REGSPEC_CFG_MEM_RAM_SHUTDOWN_ADDR, 0x00);
> +	timeout = SATA_RESET_MEM_RAM_TO;
> +	do {
> +		xgene_rd(diagcsr + REGSPEC_BLOCK_MEM_RDY_ADDR, &val);
> +		if (val != 0xFFFFFFFF)
> +			udelay(1);
> +	} while (val != 0xFFFFFFFF && timeout-- > 0);

With SATA_RESET_MEM_RAM_TO == 100000, this is an awfully long busy-loop.
Can you replace the udelay with usleep_range() providing a reasonable
wide range, and the replace the retry count with a time_before(jiffies(),
timeout) comparision?

> +/* Flush the IOB to ensure all SATA controller writes completed before
> +   servicing the completed command. This is needed due to the possibility
> +   that interrupt serviced before the data actually written to the cache/DDR.
> +   Writes from the IP to the CPU domain is not synchronized with the IRQ
> +   line or the IP core toggled the CI bits before the data write completed. */
> +static int xgene_ahci_iob_flush(struct xgene_ahci_context *ctx)
> +{
> +	if (ctx->ahbc_io_base)
> +		readl(ctx->ahbc_io_base);
> +	return 0;
> +}

Normally the synchronization should be guaranteed by using MSI interrupts
rather than edge or level interrupt pins. Do you have MSI support in your
hardware? Using that would get rid of this ugly hack and likely improve
performance significantly.

If you don't have MSI, why isn't the PORT_IRQ_STAT read sufficient
to do the flush? Like the MSI message, that should serialize any DMA
from this device.

> +static unsigned int xgene_ahci_fill_sg(struct ata_queued_cmd *qc,
> +				       void *cmd_tbl)
> +{
> +	struct scatterlist *sg;
> +	struct ahci_sg *ahci_sg = cmd_tbl + AHCI_CMD_TBL_HDR_SZ;
> +	unsigned int si;
> +
> +	/*
> +	 * Next, the S/G list.
> +	 */
> +	for_each_sg(qc->sg, sg, qc->n_elem, si) {
> +		dma_addr_t addr = sg_dma_address(sg);
> +		u64 dma_addr = xgene_ahci_to_axi(addr);
> +		u32 sg_len = sg_dma_len(sg);
> +		ahci_sg[si].addr = cpu_to_le32(dma_addr & 0xffffffff);
> +		ahci_sg[si].addr_hi = cpu_to_le32((dma_addr >> 16) >> 16);
> +		ahci_sg[si].flags_size = cpu_to_le32(sg_len - 1);
> +		xgene_ahci_dflush((void *) __va(addr), sg_len);

(void *) __va(addr) is /not/ generally speaking a valid pointer, you cannot
rely on this to work, e.g. when you have an IOMMU, or if someone tries
to reuse the driver for a 32-bit system where the memory is in highmem.

Also, I suspect the xgene_ahci_to_axi() call is what you incorrectly
do instead of using the dma_map_ops provide the correct dma_addr_t.

Note the sg_list is populated using dma_map_sg(), which is supposed
to fill the dma_addr_t field in the address space of the current device,
and also do all the necessary flushing.

I suspect a significant portion of your ahci driver (and by extension,
all other dma master drivers on the same bus) can be removed after you
implement the dma_map_ops for your hardware.

> +	tf.ctl |= ATA_SRST;
> +	/* Must call X-Gene version in case it needs to flush the cache for
> +	   MSLIM as well as AXI address translation */
> +	if (xgene_ahci_exec_polled_cmd(ap, pmp, &tf, 0,
> +				       AHCI_CMD_RESET | AHCI_CMD_CLR_BUSY,
> +				       msecs)) {
> +		rc = -EIO;
> +		reason = "1st FIS failed";
> +		goto fail;
> +	}

This part seems to fall in the same category, according to the comment.

> +	/* When both ACPi and DTS are enabled, custom ACPI built-in ACPI
> +	   table, and booting via DTS, we need to skip the probe of the
> +	   built-in ACPI table probe. */
> +	if (!efi_enabled(EFI_BOOT) && pdev->dev.of_node == NULL)
> +		return -ENODEV;
> +
> +	/* Check if the entry is disabled for OF only */
> +	if (!efi_enabled(EFI_BOOT) &&
> +	    !of_device_is_available(pdev->dev.of_node))
> +		return -ENODEV;

You seem to do the same check twice, with the first one being incorrect
in case of_node is present but disabled.

> +#if defined(CONFIG_ACPI)
> +	if (efi_enabled(EFI_BOOT)) {
> +		struct acpi_device *device;
> +
> +		if (acpi_bus_get_device(ACPI_HANDLE(&pdev->dev), &device))
> +			return -ENODEV;
> +
> +		if (acpi_bus_get_status(device) || !device->status.present)
> +			return -ENODEV;
> +	}
> +#endif

This will fail when ACPI is enabled and you boot on a UEFI system and DT probing.
I think that would be the common case for a while.

I also suspect this driver won't work with ACPI as-is, as it currently relies
on the phy driver and won't use that with ACPI. IMHO it would be easier to
defer the ACPI enablement for now. It was good that you had it in here in the
initial version as Jon recommended, but for the purpose of merging the driver
it seems like more of a distraction.

> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "no AHCI MMIO resource address\n");
> +		goto error;
> +	}
> +	hpriv->mmio_phys = res->start;
> +	hpriv->mmio_base = devm_ioremap(&pdev->dev, res->start,
> +					resource_size(res));
> +	if (!hpriv->mmio_base) {
> +		dev_err(&pdev->dev, "can't map AHCI MMIO resource\n");
> +		rc = -ENOMEM;
> +		goto error;
> +	}
> +	hpriv->hpriv.mmio = hpriv->mmio_base;
> +

You can use devm_ioremap_resource() here now to replace the longer construct.
I think you can also remove the hpriv->mmio_phys field	as that is used only
for informational purposes (use the dev_name instead).

> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	if (!res) {
> +		dev_err(&pdev->dev, "no host resource address\n");
> +		goto error;
> +	}
> +	hpriv->csr_phys = res->start;
> +	hpriv->csr_base = devm_ioremap(&pdev->dev, res->start,
> +				       resource_size(res));
> +	if (!hpriv->csr_base) {
> +		dev_err(&pdev->dev, "can't map host resource\n");
> +		rc = -ENOMEM;
> +		goto error;
> +	}

same here and for the other resources.

> +	/* Setup DMA mask */
> +	dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
> +	dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));

You need to check the errors here: this will fail if the bus
underneath is not 64-bit. I would also recommend using the new
dma_set_mask_and_coherent() helper that was introduced in this
merge window.

> +#ifdef CONFIG_PM
> +static int xgene_ahci_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +	struct ata_host *host = dev_get_drvdata(&pdev->dev);
> +	struct xgene_ahci_context *hpriv = host->private_data;
> +	void __iomem *mmio = hpriv->mmio_base;
> +	u32 ctl;
> +	int rc;
> +
> +	dev_dbg(&pdev->dev, "suspend\n");
> +
> +	/*
> +	 * AHCI spec rev1.1 section 8.3.3:
> +	 * Software must disable interrupts prior to requesting a
> +	 * transition of the HBA to D3 state.
> +	 */
> +	ctl = readl(mmio + HOST_CTL);
> +	ctl &= ~HOST_IRQ_EN;
> +	writel(ctl, mmio + HOST_CTL);
> +	readl(mmio + HOST_CTL);	/* flush */
> +
> +	rc = ata_host_suspend(host, state);
> +	if (rc)
> +		return rc;
> +
> +	return 0;
> +}

Nothing in this function seems to be xgene specific, and you don't
use the hpriv pointer. Can you use a generic libata function instead,
or add this one to libata if it can be reused for other drivers?

> +static int xgene_ahci_resume(struct platform_device *pdev)

Same here.

	Arnd
