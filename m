From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 3/4] ata: Add APM X-Gene SoC SATA host controller driver
Date: Fri, 15 Nov 2013 14:48:15 +0100
Message-ID: <201311151448.16279.arnd@arndb.de>
References: <1384465153-29902-1-git-send-email-lho@apm.com>
 <1384465153-29902-3-git-send-email-lho@apm.com>
 <1384465153-29902-4-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1384465153-29902-4-git-send-email-lho@apm.com>
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

On Thursday 14 November 2013, Loc Ho wrote:
>  
> +config SATA_XGENE
> +	tristate "APM X-Gene 6.0Gbps SATA host controller support"
> +	depends on SATA_AHCI_PLATFORM
> +	default y if ARM64
> +	select SATA_XGENE_PHY

I don't think the "default y" is appropriate here, since there are going to
be lots of ARM64 platforms in the long run that don't have this. Also,
there is a trend towards using CONFIG_COMPILE_TEST to limit the
visibility.

I'd suggest something like

config SATA_XGENE
	tristate "APM X-Gene 6.0Gbps SATA host controller support"
	depends on ARM64 || COMPILE_TEST
	...

> +/* Enable for dumping CSR read/write access */
> +#undef XGENE_DBG_CSR

This should be removed now as well, along with the debug macro you already removed.

> +
> +/* Temporary function until the PHY parameter API */
> +extern void xgene_ahci_phy_set_pq(struct phy *phy, int chan, int data);
> +extern void xgene_ahci_phy_set_spd(struct phy *phy, int chan, int gen);

Ah, that should have been mentioned in the changeset text. Do you think you
can remove these for the final version?

> +static void xgene_rd(void *addr, u32 *val)
> +{
> +	*val = readl(addr);
> +#if defined(XGENE_DBG_CSR)
> +	printk(KERN_DEBUG "SATAPHY CSR RD: 0x%p value: 0x%08x\n", addr, *val);
> +#endif
> +}

The interface you are looking for is pr_debug() or dev_dbg(), which get
built-in only if the DEBUG macro is set.

In a lot of cases, it's actually best to remove debug output like this from
the driver once you have it working  -- whoever is debugging problems in 
the driver next might need completely different debugging information or
can add them back easily if needed.

It's your choice if you want to use pr_debug() or remove that output
entirely. If you remove it, best remove the helper functions entirely
and use readl/writel directly.

> +/* Flush the IOB to ensure all SATA controller writes completed before
> +   servicing the completed command. */
> +static int xgene_ahci_iob_flush(struct xgene_ahci_context *ctx)
> +{
> +	if (ctx->ahbc_io_base == NULL) {
> +		void *ahbc_base;
> +		u32 val;
> +
> +		/* The AHBC address is fixed in X-Gene */
> +		ahbc_base = devm_ioremap(ctx->dev, 0x1F2A0000, 0x80000);
> +		if (!ahbc_base) {
> +			dev_err(ctx->dev, "can't map AHBC resource\n");
> +			return -ENODEV;
> +		}

I had an important comment about the misuse of hardcoded I/O addresses
here. Please never just post a new version with the same issue. In general,
your options are:

* rewrite the code in a more appropriate way
* reply to the comment, arguing why you think your code is correct
* ask for clarification if you don't know how to improve the code
* mark the code as TODO and mention in the patch description why you
  are still working on this and that the current version should not
  be seen as final.

If you don't do any of these, reviewers will get annoyed because you
are wasting their time.
> +
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

There are more previous comments that you have not addressed yet.

> diff --git a/drivers/ata/sata_xgene.h b/drivers/ata/sata_xgene.h
> new file mode 100644
> index 0000000..51e73f6
> --- /dev/null
> +++ b/drivers/ata/sata_xgene.h

This file should probably just be folded into the driver, since it contains no
interfaces between  modules, just internal definitions.

	Arnd
