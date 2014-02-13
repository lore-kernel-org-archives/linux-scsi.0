From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v10 0/4] ata: Add APM X-Gene SoC SATA host controller support
Date: Thu, 13 Feb 2014 15:28:01 -0800
Message-ID: <CAPw-ZTn5c=v+7pbetEjXWpw9i=cG+zdeHPxO1QD0e42uFrKnCg@mail.gmail.com>
References: <CAPw-ZTkbpOEHowGvp-_3DcW1qW0AK_ZbpdS1LESJfhFU-n_Mtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAPw-ZTkbpOEHowGvp-_3DcW1qW0AK_ZbpdS1LESJfhFU-n_Mtw@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, David Milburn <dmilburn@redhat.com>, Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hi Tejun,

With regard to make use of the standard ahci_platform and recent Hans'
PHY works, the original version of the driver was an ahci_platform
driver. Unfortunately, the APM X-Gene SATA controller is more
complicate than an standard AHCI controller. In order to make it works
properly, the follow additional programming sequences are required:

1. There are a number of errata that require workaround. Some can be
fixed by adding broken flags while others are better to just wrap
around the existent libahci library routines and not overly polluting
the libahci routines.
2. There are additional controller programming sequences to configure.
2a. By default, RAM are powered down and require brought out of shutdown.
2b. The controller has an additional corresponding PHY part that needs
to be programmed after PHY configuration.
2c. The controller requires extra programming sequence for the
hardreset due to errata.
2d. For the IO flush, it requires additional memory resources.
3. With the current AHCI platform data handing and ARM64 arch support,
if I were to add custom AHCI platform data routine, I would need
equivalent functions and that would make the ARCH support having
knowledge of the SATA code which I don't want. Also, the DTS
processing/scanning in ARCH64 is NULL for platform data and would have
make X-Gene to have its own version which I also don't want.

-Loc

> On Thu, Jan 16, 2014 at 8:11 AM, Loc Ho <lho@apm.com> wrote:
>> This patch adds support for the APM X-Gene SoC SATA host controller. In
>> order for the host controller to work, the corresponding PHY driver
>> musts also be available.
>>
>> v10:
>>  * Update binding documentation
>>
>> v9:
>>  * Remove ACPI/EFI include files
>>  * Remove the IO flush support, interrupt routine, and DTS resources
>>  * Remove function xgene_rd, xgene_wr, and xgene_wr_flush
>>  * Remove PMP support (function xgene_ahci_qc_issue, xgene_ahci_qc_prep,
>>    xgene_ahci_qc_fill_rtf, xgene_ahci_softreset, and xgene_ahci_do_softreset)
>>  * Rename function xgene_ahci_enable_phy to xgene_ahci_force_phy_rdy
>>  * Clean up hardreset functions
>>  * Require v7 of the PHY driver
>>
>> v8:
>>  * Remove _ADDR from defines
>>  * Remove define MSTAWAUX_COHERENT_BYPASS_SET and
>>    STARAUX_COHERENT_BYPASS_SET and use direct coding
>>  * Remove the un-necessary check for DTS boot with built in ACPI table
>>  * Switch to use dma_set_mask_and_coherent for setting DMA mask
>>  * Remove ACPI table matching code
>>  * Update clock-names for sata01clk, sata23clk, and sata45clk
>>
>> v7:
>>  * Update the clock code by toggle the clock
>>  * Update the DTS clock mask values due to the clock spilt between host and
>>    v5 of the PHY drivers
>>
>> v6:
>>  * Update binding documentation
>>  * Change select PHY_XGENE_SATA to PHY_XGENE
>>  * Add ULL to constants
>>  * Change indentation and comments
>>  * Clean up the probe functions a bit more
>>  * Remove xgene_ahci_remove function
>>  * Add the flush register to DTS
>>  * Remove the interrupt-parent from DTS
>>
>> v5:
>>  * Sync up to v3 of the PHY driver
>>  * Remove MSLIM wrapper functions
>>  * Change the memory shutdown loop to use usleep_range
>>  * Use devm_ioremap_resource instead devm_ioremap
>>  * Remove suspend/resume functions as not needed
>>
>> v4:
>>  * Remove the ID property in DT
>>  * Remove the temporary PHY direct function call and use PHY function
>>  * Change printk to pr_debug
>>  * Move the IOB flush addresses into the DT
>>  * Remove the parameters retrieval function as no longer needed
>>  * Remove the header file as no longer needed
>>  * Require v2 patch of the SATA PHY driver. Require slightly modification
>>    in the Kconfig as it is moved to folder driver/phy and use Kconfig
>>    PHY_XGENE_SATA instead SATA_XGENE_PHY.
>>
>> v3:
>>  * Move out the SATA PHY to another driver
>>  * Remove the clock-cells entry from DTS
>>  * Remove debug wrapper
>>  * Remove delay functions wrapper
>>  * Clean up resource and IRQ query
>>  * Remove query clock name
>>  * Switch to use dma_set_mask/dma_coherent_mask
>>  * Remove un-necessary devm_kfree
>>  * Update GPL license header to v2
>>  * Spilt up function xgene_ahci_hardreset
>>  * Spilt up function xgene_ahci_probe
>>  * Remove all reference of CONFIG_ARCH_MSLIM
>>  * Clean up chip revision code
>>
>> v2:
>>  * Clean up file sata_xgene.c with Lindent and etc
>>  * Clean up file sata_xgene_serdes.c with Lindent and etc
>>  * Add description to each patch
>>
>> v1:
>>  * inital version
>>
>> Signed-off-by: Loc Ho <lho@apm.com>
>> Signed-off-by: Tuan Phan <tphan@apm.com>
>> Signed-off-by: Suman Tripathi <stripathi@apm.com>
>> ---
>> Loc Ho (4):
>>   ata: Export required functions by APM X-Gene SATA driver
>>   Documentation: Add documentation for APM X-Gene SoC SATA host
>>     controller DTS binding
>>   ata: Add APM X-Gene SoC SATA host controller driver
>>   arm64: Add APM X-Gene SoC SATA host controller DTS entries
>>
>>  .../devicetree/bindings/ata/apm-xgene.txt          |   70 +++
>>  arch/arm64/boot/dts/apm-storm.dtsi                 |   75 +++
>>  drivers/ata/Kconfig                                |    8 +
>>  drivers/ata/Makefile                               |    1 +
>>  drivers/ata/ahci.h                                 |    9 +
>>  drivers/ata/libahci.c                              |   16 +-
>>  drivers/ata/sata_xgene.c                           |  630 ++++++++++++++++++++
>>  7 files changed, 803 insertions(+), 6 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/ata/apm-xgene.txt
>>  create mode 100644 drivers/ata/sata_xgene.c
>>
