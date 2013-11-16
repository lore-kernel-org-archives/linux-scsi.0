From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v3 3/4] ata: Add APM X-Gene SoC SATA host controller driver
Date: Fri, 15 Nov 2013 22:36:56 -0800
Message-ID: <CAPw-ZTmaz3nnV3ThRgecT_RaYYW0bmfWvL8Kr-S3z1aKyUWc+w@mail.gmail.com>
References: <1384465153-29902-1-git-send-email-lho@apm.com>
	<1384465153-29902-3-git-send-email-lho@apm.com>
	<1384465153-29902-4-git-send-email-lho@apm.com>
	<201311151448.16279.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <201311151448.16279.arnd@arndb.de>
Sender: linux-ide-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Kishon Vijay Abraham I <kishon@ti.com>
Cc: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Jon Masters <jcm@redhat.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

>> +config SATA_XGENE
>> +     tristate "APM X-Gene 6.0Gbps SATA host controller support"
>> +     depends on SATA_AHCI_PLATFORM
>> +     default y if ARM64
>> +     select SATA_XGENE_PHY
>
> I don't think the "default y" is appropriate here, since there are going to
> be lots of ARM64 platforms in the long run that don't have this. Also,
> there is a trend towards using CONFIG_COMPILE_TEST to limit the
> visibility.
>
> I'd suggest something like
>
> config SATA_XGENE
>         tristate "APM X-Gene 6.0Gbps SATA host controller support"
>         depends on ARM64 || COMPILE_TEST
>         ...
>
[Loc Ho]
Okay. How about this?

 depends on ARM64 || COMPILE_TEST
 select SATA_XGENE_PHY && SATA_AHCI_PLATFORM

>> +/* Enable for dumping CSR read/write access */
>> +#undef XGENE_DBG_CSR
>
> This should be removed now as well, along with the debug macro you already removed.
[Loc Ho]
This is very useful if one running into problem - one can enable all
CSR dump. I would like to keep this around for the time being.

>
>> +
>> +/* Temporary function until the PHY parameter API */
>> +extern void xgene_ahci_phy_set_pq(struct phy *phy, int chan, int data);
>> +extern void xgene_ahci_phy_set_spd(struct phy *phy, int chan, int gen);
>
> Ah, that should have been mentioned in the changeset text. Do you think you
> can remove these for the final version?
[Loc Ho]
Yes... Krishon, can you provide an patch that allows me to accommodate
this? Or should I come up one? I will trying to get rip of the first
one. But I will need the function to set the PHY speed - for
Gen2/Gen1. Let's plan on add these function:

a. int (*set_speed)(int gen_speed) where gen_speed is either AUTO,
GEN1, GEN2, or GEN3.
b. Change the PHY init function to take an optional parameter. This
would help my first function in case I can get rip of it.

>
>> +static void xgene_rd(void *addr, u32 *val)
>> +{
>> +     *val = readl(addr);
>> +#if defined(XGENE_DBG_CSR)
>> +     printk(KERN_DEBUG "SATAPHY CSR RD: 0x%p value: 0x%08x\n", addr, *val);
>> +#endif
>> +}
>
> The interface you are looking for is pr_debug() or dev_dbg(), which get
> built-in only if the DEBUG macro is set.
>
> In a lot of cases, it's actually best to remove debug output like this from
> the driver once you have it working  -- whoever is debugging problems in
> the driver next might need completely different debugging information or
> can add them back easily if needed.
>
> It's your choice if you want to use pr_debug() or remove that output
> entirely. If you remove it, best remove the helper functions entirely
> and use readl/writel directly.
[Loc Ho]
I would like to keep this function for now until this driver actual
being used in production. I will use pr_debug.

>
>> +/* Flush the IOB to ensure all SATA controller writes completed before
>> +   servicing the completed command. */
>> +static int xgene_ahci_iob_flush(struct xgene_ahci_context *ctx)
>> +{
>> +     if (ctx->ahbc_io_base == NULL) {
>> +             void *ahbc_base;
>> +             u32 val;
>> +
>> +             /* The AHBC address is fixed in X-Gene */
>> +             ahbc_base = devm_ioremap(ctx->dev, 0x1F2A0000, 0x80000);
>> +             if (!ahbc_base) {
>> +                     dev_err(ctx->dev, "can't map AHBC resource\n");
>> +                     return -ENODEV;
>> +             }
>
> I had an important comment about the misuse of hardcoded I/O addresses
> here. Please never just post a new version with the same issue. In general,
> your options are:
>
> * rewrite the code in a more appropriate way
> * reply to the comment, arguing why you think your code is correct
> * ask for clarification if you don't know how to improve the code
> * mark the code as TODO and mention in the patch description why you
>   are still working on this and that the current version should not
>   be seen as final.
>
> If you don't do any of these, reviewers will get annoyed because you
> are wasting their time.
[Loc Ho]
Sorry about this one. I will add this to the DTS. If this resource
isn't available, then it will be nop.

>> +
>> +static int xgene_ahci_get_u32_param(struct platform_device *pdev,
>> +                                 const char *of_name, char *acpi_name,
>> +                                 u32 *param)
>> +{
>> +#ifdef CONFIG_ACPI
>> +     if (efi_enabled(EFI_BOOT)) {
>> +             unsigned long long value;
>> +             acpi_status status;
>> +             if (acpi_name == NULL)
>> +                     return -ENODEV;
>> +             status = acpi_evaluate_integer(ACPI_HANDLE(&pdev->dev),
>> +                                            acpi_name, NULL, &value);
>> +             if (ACPI_FAILURE(status))
>> +                     return -ENODEV;
>> +             *param = value;
>> +             return 0;
>> +     }
>> +#endif
>
> There are more previous comments that you have not addressed yet.
[Loc Ho]
Original, I didn't want to get rip of this as ACPI isn't available in
the 3.12 kernel yet. I will get rip of this as I don't need the ID any
more. Also, I will also get rip of the clock interface. Don't need
this as it is handled directly by the driver. This will address for DT
as well as ACPI.

>
>> diff --git a/drivers/ata/sata_xgene.h b/drivers/ata/sata_xgene.h
>> new file mode 100644
>> index 0000000..51e73f6
>> --- /dev/null
>> +++ b/drivers/ata/sata_xgene.h
>
> This file should probably just be folded into the driver, since it contains no
> interfaces between  modules, just internal definitions.
[Loc Ho]
I can get rip this header file now. But in the future I may need to
add this back as I intended this driver to also support running from
our co-processor (ARMv7 32-bit). For that, I will need anothe file and
other function that will need knowledge of the context structure and
etc.

-Loc
