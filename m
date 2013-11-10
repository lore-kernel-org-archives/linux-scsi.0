From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 3/5] ata: Add APM X-Gene SATA driver
Date: Sun, 10 Nov 2013 22:06:46 +0100
Message-ID: <201311102206.46551.arnd@arndb.de>
References: <1383980431-6572-1-git-send-email-lho@apm.com>
 <1383980431-6572-3-git-send-email-lho@apm.com>
 <1383980431-6572-4-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1383980431-6572-4-git-send-email-lho@apm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org
Cc: Suman Tripathi <stripathi@apm.com>, linux-scsi@vger.kernel.org, jcm@redhat.com, tj@kernel.org, Loc Ho <lho@apm.com>, olof@lixom.net, Tuan Phan <tphan@apm.com>
List-Id: linux-scsi@vger.kernel.org

On Saturday 09 November 2013, Loc Ho wrote:
> +
> +#undef XGENE_DBG_CSR		/* Enable CSR read/write dumping */
> +#ifdef XGENE_DBG_CSR
> +#define XGENE_CSRDBG(fmt, args...)	\
> +	printk(KERN_INFO "XGENESATA: " fmt "\n", ## args);
> +#else
> +#define XGENE_CSRDBG(fmt, args...)
> +#endif

Please kill those private debug macros and use the generic interfaces.

> +void xgene_ahci_delayus(unsigned long us)
> +{
> +	udelay(us);
> +}
> +
> +void xgene_ahci_delayms(unsigned long us)
> +{
> +	mdelay(us);
> +}

Same for these pointless wrappers. Also every use of mdelay and ideally also udelay
needs a good explanation about why the hardware is so broken to require it or
why you cannot use msleep().

> +static int xgene_ahci_get_irq(struct platform_device *pdev, int index)
> +{
> +	if (efi_enabled(EFI_BOOT))
> +		return platform_get_irq(pdev, index);
> +	return irq_of_parse_and_map(pdev->dev.of_node, index);
> +}
> +
> +static int xgene_ahci_get_resource(struct platform_device *pdev, int index,
> +				   struct resource *res)
> +{
> +	struct resource *regs;
> +	if (efi_enabled(EFI_BOOT)) {
> +		regs = platform_get_resource(pdev, IORESOURCE_MEM, index);
> +		if (regs == NULL)
> +			return -ENODEV;
> +		*res = *regs;
> +		return 0;
> +	}
> +	return of_address_to_resource(pdev->dev.of_node, index, res);
> +}

These wrappers look wrong. Why can't you always use platform_get_irq/platform_get_resource?
What does the use of the of_* interfaces have to do with EFI?

> +static int xgene_ahci_get_u32_param(struct platform_device *pdev,
> +				    const char *of_name, char *acpi_name,
> +				    u32 *param)
> +{
> +#ifdef CONFIG_ACPI
> +	if (efi_enabled(EFI_BOOT)) {
> +		unsigned long long value;
> +		acpi_status status;
> +		if (acpi_name == NULL)
> +			return -ENODEV;
> +		status = acpi_evaluate_integer(ACPI_HANDLE(&pdev->dev),
> +					       acpi_name, NULL, &value);
> +		if (ACPI_FAILURE(status))
> +			return -ENODEV;
> +		*param = value;
> +		return 0;
> +	}
> +#endif
> +	if (of_name == NULL)
> +		return -ENODEV;
> +	return of_property_read_u32(pdev->dev.of_node, of_name, param);
> +}

This is worse. A device driver is *not* the place to put abstractions for
the bindings, those belong into common code.
Also it seems you are trying to do register-level programming based on
attributes you pull out of the respective firmware interfaces.

While there has been some progress regarding getting a common direction
for embedded x86 machines using ACPI, you should not assume that the same
makes sense for ARM systems.

* In case of the Open Firmware DT, the model is that we use per-subsystem
  bindings to describe the hardware in an abstract way, e.g. using the
  PHY controller, reset controller, clock controller, ... APIs. This is
  how we can handle complex SoC-type systems.

* In case of a server-class ACPI based machine, the model is that those
  details are handled by the firmware and you don't need to bother the
  device driver with them.

> +	rc = xgene_ahci_get_str_param(pdev, "clock-names", "CLNM", res_name,
> +				      sizeof(res_name));
> +	if (rc) {
> +		dev_err(&pdev->dev, "no clock name resource\n");
> +		goto error;
> +	}

As mentioned in the other mail, the driver must not read the "clock-names"
property but have a hardcoded name for the clock (or use NULL for simplicity).

> +	if (strcmp(res_name, "eth01clk") == 0)
> +		hpriv->cid = 0;
> +	else if (strcmp(res_name, "eth23clk") == 0)
> +		hpriv->cid = 1;
> +	else
> +		hpriv->cid = 2;
> +
> +	if (hpriv->cid == 2) {
> +		rc = xgene_ahci_get_resource(pdev, 2, &res);
> +		if (rc != 0) {
> +			dev_err(&pdev->dev, "no SATA/PCIE resource address\n");
> +			goto error;
> +		}
> +		hpriv->pcie_base = devm_ioremap(&pdev->dev, res.start,
> +						resource_size(&res));
> +		if (!hpriv->pcie_base) {
> +			dev_err(&pdev->dev, "can't map SATA/PCIe resource\n");
> +			rc = -ENOMEM;
> +			goto error;
> +		}
> +	}

This seems to incorrectly rely on side-effects of which particular clock
gets used. What are you trying to do here?

> +	/* Custom Serdes override paraemter */
> +	rc = xgene_ahci_get_u32_param(pdev, "gen-sel", "GENS", &gen_sel);
> +	if (rc != 0)
> +		gen_sel = 3;	/* Default to Gen3 */
> +	rc = xgene_ahci_get_u32_param(pdev, "serdes-diff-clk", "SDCL",
> +				      &serdes_diff_clk);
> +	if (rc != 0)
> +		serdes_diff_clk = SATA_CLK_EXT_DIFF; /* Default to external */
> +	rc = xgene_ahci_get_u32_param(pdev, "EQA1", "EQA1",
> +				      &hpriv->ctrl_eq_A1);
> +	if (rc != 0)
> +		hpriv->ctrl_eq_A1 = CTLE_EQ;
> +	rc = xgene_ahci_get_u32_param(pdev, "EQ", "EQ00", &hpriv->ctrl_eq);
> +	if (rc != 0)
> +		hpriv->ctrl_eq = CTLE_EQ_A2;
> +	dev_dbg(&pdev->dev, "SATA%d ctrl_eq %u %u\n", hpriv->cid,
> +		hpriv->ctrl_eq_A1, hpriv->ctrl_eq);
> +	rc = xgene_ahci_get_u32_param(pdev, "GENAVG", "GAVG",
> +				      &hpriv->use_gen_avg);
> +	if (rc != 0)
> +		hpriv->use_gen_avg = xgene_ahci_is_A1() ? 0 : 1;
> +	dev_dbg(&pdev->dev, "SATA%d use avg %u\n", hpriv->cid,
> +		hpriv->use_gen_avg);
> +	rc = xgene_ahci_get_u32_param(pdev, "LBA1", "LBA1",
> +				      &hpriv->loopback_buf_en_A1);
> +	if (rc != 0)
> +		hpriv->loopback_buf_en_A1 = 1;
> +	rc = xgene_ahci_get_u32_param(pdev, "LB", "LB00",
> +				      &hpriv->loopback_buf_en);
> +	if (rc != 0)
> +		hpriv->loopback_buf_en = 0;
> +	dev_dbg(&pdev->dev, "SATA%d loopback_buf_en %u %u\n", hpriv->cid,
> +		hpriv->loopback_buf_en_A1, hpriv->loopback_buf_en);
> +	rc = xgene_ahci_get_u32_param(pdev, "LCA1", "LCA1",
> +				      &hpriv->loopback_ena_ctle_A1);
> +	if (rc != 0)
> +		hpriv->loopback_ena_ctle_A1 = 1;
> +	rc = xgene_ahci_get_u32_param(pdev, "LC", "LC00",
> +				      &hpriv->loopback_ena_ctle);
> +	if (rc != 0)
> +		hpriv->loopback_ena_ctle = 0;
> +	dev_dbg(&pdev->dev, "SATA%d loopback_ena_ctle %u %u\n", hpriv->cid,
> +		hpriv->loopback_ena_ctle_A1, hpriv->loopback_ena_ctle);
> +	rc = xgene_ahci_get_u32_param(pdev, "CDRA1", "CDR1",
> +				      &hpriv->spd_sel_cdr_A1);
> +	if (rc != 0)
> +		hpriv->spd_sel_cdr_A1 = SPD_SEL;
> +	rc = xgene_ahci_get_u32_param(pdev, "CDR", "CDR0",
> +				      &hpriv->spd_sel_cdr);
> +	if (rc != 0)
> +		hpriv->spd_sel_cdr = SPD_SEL;
> +	dev_dbg(&pdev->dev, "SATA%d spd_sel_cdr %u %u\n", hpriv->cid,
> +		hpriv->spd_sel_cdr_A1, hpriv->spd_sel_cdr);
> +	rc = xgene_ahci_get_u32_param(pdev, "PQA1", "PQA1", &hpriv->pq_A1);
> +	if (rc != 0)
> +		hpriv->pq_A1 = PQ_REG;
> +	rc = xgene_ahci_get_u32_param(pdev, "PQ", "PQ00", &hpriv->pq);

All this this crap can probably just go away if you have a proper PHY driver
(in case of DT) or handle it in the firmware (in case of a server).

> +	if (rc != 0)
> +		hpriv->pq = PQ_REG_A2;
> +	hpriv->pq_sign = 0x1;
> +	dev_dbg(&pdev->dev, "SATA%d pq %u %u %d\n", hpriv->cid, hpriv->pq_A1,
> +		hpriv->pq, hpriv->pq_sign);
> +	rc = xgene_ahci_get_u32_param(pdev, "coherent", "COHT",
> +				      &hpriv->coherent);

Coherency should be managed by the DMA-mapping API, don't introduce custom
properties for this.

> +	/* Setup DMA mask */
> +	pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
> +	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(64);

Drivers are not allowed to touch these fields directly, you have to use
dma_set_mask/dma_set_coherent_mask so the architecture code can check
that the bus is actually 64-bit capable.

> +static int xgene_ahci_remove(struct platform_device *pdev)
> +{
> +	struct ata_host *host = dev_get_drvdata(&pdev->dev);
> +	struct xgene_ahci_context *hpriv = host->private_data;
> +
> +	dev_dbg(&pdev->dev, "SATA%d remove\n", hpriv->cid);
> +	devm_kfree(&pdev->dev, hpriv);
> +	return 0;
> +}

The devm_kfree seems pointless here.

	Arnd
