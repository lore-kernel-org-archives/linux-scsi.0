From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH] add support for DWC UFS Host Controller
Date: Tue, 2 Feb 2016 12:00:07 +1100
Message-ID: <CAGRGNgUZOZx80yQoqLq-YWxj7u7rWvGEy9UKSRU++t7VtXEOXQ@mail.gmail.com>
References: <33d190af027d92da449f379a5e60366729d37eab.1454330442.git.jpinto@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:34030 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbcBBBA2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2016 20:00:28 -0500
In-Reply-To: <33d190af027d92da449f379a5e60366729d37eab.1454330442.git.jpinto@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joao Pinto <Joao.Pinto@synopsys.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Christoph Hellwig <hch@infradead.org>, gbroner@codeaurora.org, subhashj@codeaurora.org, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, CARLOS.PALMINHA@synopsys.com, Ian Campbell <ijc+devicetree@hellion.org.uk>

Hi Joao,

On Mon, Feb 1, 2016 at 11:47 PM, Joao Pinto <Joao.Pinto@synopsys.com> wrote:
> This patch includes:
> - quirks in the ufs core driver to support Synopsys MPHY Test Chip config
> - quirks in the ufs core driver to support DWC configuration sequence
> - New Unipro attributes were added
> - ufs core driver was tweaked to support UFS 2.0
> - support for Synopsys PCI ID in the pci glue driver
> - new platform glue driver for Synopsys devices
>
> Signed-off-by: Joao Pinto <jpinto@synopsys.com>
> ---
>  Documentation/devicetree/bindings/ufs/ufs-dwc.txt |  16 +
>  drivers/scsi/ufs/Kconfig                          |  54 ++
>  drivers/scsi/ufs/Makefile                         |   1 +
>  drivers/scsi/ufs/ufs-dwc.c                        | 115 +++
>  drivers/scsi/ufs/ufshcd-pci.c                     |   2 +
>  drivers/scsi/ufs/ufshcd-pltfrm.c                  |   2 +-
>  drivers/scsi/ufs/ufshcd.c                         | 822 +++++++++++++++++++++-
>  drivers/scsi/ufs/ufshcd.h                         |  15 +
>  drivers/scsi/ufs/ufshci.h                         |  29 +
>  drivers/scsi/ufs/unipro.h                         |  39 +
>  10 files changed, 1089 insertions(+), 6 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/ufs/ufs-dwc.txt
>  create mode 100644 drivers/scsi/ufs/ufs-dwc.c

You should separate out your changes into separate patches, e.g.

1. Fix the spelling mistake
2. Update the base code for UFSHCI_VERSION_20 compatiblity.
3. Implement any common code as a separate module
4. Add the OF and PCI drivers

> diff --git a/Documentation/devicetree/bindings/ufs/ufs-dwc.txt b/Documentation/devicetree/bindings/ufs/ufs-dwc.txt
> new file mode 100644
> index 0000000..fa361f2
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/ufs-dwc.txt
> @@ -0,0 +1,16 @@
> +* Universal Flash Storage (UFS) DesignWare Host Controller
> +
> +DWC_UFSHC nodes are defined to describe on-chip UFS host controllers.
> +Each UFS controller instance should have its own node.
> +
> +Required properties:
> +- compatible        : compatible list, contains "snps,ufshcd"
> +- reg               : <registers mapping>
> +- interrupts        : <interrupt mapping for UFS host controller IRQ>
> +
> +Example:
> +       dwc_ufshcd@0xD0000000 {
> +               compatible = "snps,ufshcd";
> +               reg = < 0xD0000000 0x10000 >;
> +               interrupts = < 24 >;
> +       };

If I recall correctly, when adding device tree bindings, you need to
cc the devicetree list, devicetree@vger.kernel.org.

> diff --git a/drivers/scsi/ufs/ufs-dwc.c b/drivers/scsi/ufs/ufs-dwc.c
> new file mode 100644
> index 0000000..e4d70b7
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufs-dwc.c
> @@ -0,0 +1,115 @@
> +/* ==========================================================================
> + * The Synopsys DWC UFS Software Driver and documentation (hereinafter
> + * "Software") is an unsupported proprietary work of Synopsys, Inc. unless
> + * otherwise expressly agreed to in writing between Synopsys and you.
> + *
> + * The Software IS NOT an item of Licensed Software or Licensed Product under
> + * any End User Software License Agreement or Agreement for Licensed Product
> + * with Synopsys or any supplement thereto.  Permission is hereby granted,
> + * free of charge, to any person obtaining a copy of this software annotated
> + * with this license and the Software, to deal in the Software without
> + * restriction, including without limitation the rights to use, copy, modify,
> + * merge, publish, distribute, sublicense, and/or sell copies of the Software,
> + * and to permit persons to whom the Software is furnished to do so, subject
> + * to the following conditions:
> + *
> + * The above copyright notice and this permission notice shall be included in
> + * all copies or substantial portions of the Software.
> + *
> + * THIS SOFTWARE IS BEING DISTRIBUTED BY SYNOPSYS SOLELY ON AN "AS IS" BASIS
> + * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
> + * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
> + * ARE HEREBY DISCLAIMED. IN NO EVENT SHALL SYNOPSYS BE LIABLE FOR ANY DIRECT,
> + * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
> + * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
> + * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
> + * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
> + * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
> + * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
> + * DAMAGE.
> + * ==========================================================================

Is this GPLv2 compatible?

> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/of.h>
> +#include <linux/delay.h>
> +
> +#include "ufshcd.h"
> +#include "ufshcd-pltfrm.h"
> +
> +/**
> + * struct ufs_hba_dwc_vops - UFS DWC specific variant operations
> + *
> + */
> +static struct ufs_hba_variant_ops ufs_hba_dwc_vops = {
> +       .name                   = "dwc",
> +};
> +
> +/**
> + * ufs_dwc_probe()
> + * @pdev: pointer to platform device structure
> + *
> + */
> +static int ufs_dwc_probe(struct platform_device *pdev)
> +{
> +       int err;
> +       struct device *dev = &pdev->dev;
> +
> +       /* Perform generic probe */
> +       err = ufshcd_pltfrm_init(pdev, &ufs_hba_dwc_vops);
> +       if (err)
> +               dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
> +
> +       return err;
> +}
> +
> +/**
> + * ufs_dwc_remove()
> + * @pdev: pointer to platform device structure
> + *
> + */
> +static int ufs_dwc_remove(struct platform_device *pdev)
> +{
> +       struct ufs_hba *hba =  platform_get_drvdata(pdev);
> +
> +       pm_runtime_get_sync(&(pdev)->dev);
> +       ufshcd_remove(hba);
> +
> +       return 0;
> +}
> +
> +static const struct of_device_id ufs_dwc_match[] = {
> +       {
> +               .compatible = "snps,ufshcd"
> +       },
> +       { },
> +};
> +MODULE_DEVICE_TABLE(of, ufs_dwc_match);
> +
> +static const struct dev_pm_ops ufs_dwc_pm_ops = {
> +       .suspend        = ufshcd_pltfrm_suspend,
> +       .resume         = ufshcd_pltfrm_resume,
> +       .runtime_suspend = ufshcd_pltfrm_runtime_suspend,
> +       .runtime_resume  = ufshcd_pltfrm_runtime_resume,
> +       .runtime_idle    = ufshcd_pltfrm_runtime_idle,
> +};
> +
> +static struct platform_driver ufs_dwc_driver = {
> +       .probe          = ufs_dwc_probe,
> +       .remove         = ufs_dwc_remove,
> +       .shutdown = ufshcd_pltfrm_shutdown,
> +       .driver         = {
> +               .name   = "ufshcd-dwc",
> +               .pm     = &ufs_dwc_pm_ops,
> +               .of_match_table = of_match_ptr(ufs_dwc_match),
> +       },
> +};
> +
> +module_platform_driver(ufs_dwc_driver);
> +
> +MODULE_ALIAS("platform:ufshcd-dwc");
> +MODULE_DESCRIPTION("DesignWare UFS Host platform glue driver");
> +MODULE_AUTHOR("Joao Pinto <Joao.Pinto@synopsys.com>");
> +MODULE_LICENSE("Dual BSD/GPL");
> diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
> index d15eaa4..0ee6c62 100644
> --- a/drivers/scsi/ufs/ufshcd-pci.c
> +++ b/drivers/scsi/ufs/ufshcd-pci.c
> @@ -167,6 +167,8 @@ static const struct dev_pm_ops ufshcd_pci_pm_ops = {
>
>  static const struct pci_device_id ufshcd_pci_tbl[] = {
>         { PCI_VENDOR_ID_SAMSUNG, 0xC00C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
> +       { PCI_VENDOR_ID_SYNOPSYS, 0xB101, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
> +       { PCI_VENDOR_ID_SYNOPSYS, 0xB102, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },

Listing these here implies that the devices these lines match are
"normal" PCI UFSHCD devices that don't require any special handling
whatsoever. Is that correct?

If they do require special handling, then you need to put them in a
separate driver, e.g. ufs-dwc-pci.c

>         { }     /* terminate list */
>  };
>
> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
> index d2a7b12..0522891 100644
> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
> @@ -353,6 +353,6 @@ EXPORT_SYMBOL_GPL(ufshcd_pltfrm_init);
>
>  MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
>  MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
> -MODULE_DESCRIPTION("UFS host controller Pltform bus based glue driver");
> +MODULE_DESCRIPTION("UFS host controller Platform bus based glue driver");

A spelling fix like this belongs in a separate patch.

>  MODULE_LICENSE("GPL");
>  MODULE_VERSION(UFSHCD_DRIVER_VERSION);
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 85cd256..05d309d 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5521,6 +5541,790 @@ static struct devfreq_dev_profile ufs_devfreq_profile = {
>         .get_dev_status = ufshcd_devfreq_get_dev_status,
>  };
>
> +#ifdef CONFIG_SCSI_UFS_DWC_HOOKS

This doesn't look right.

The driver should be structured like this:

 - ufs-dwc: contains everything that is specific to your hardware.
 - ufshcd: contains everything that is common to multiple types of
ufshcd from different vendors

Your "hooks" here look like they're doing stuff that is specific to
the Designware hardware. They should not be in this file as it's for
hardware type independent code.

If you need to do something special at some point in the common code,
then this should be exposed as an op in struct ufs_hba_variant_ops
which is then implemented in your device-specific code.

> +/**
> + * ufshcd_dwc_program_clk_div()
> + * This function programs the clk divider value. This value is needed to
> + * provide 1 microsecond tick to unipro layer.
> + * @hba: Private Structure pointer
> + * @divider_val: clock divider value to be programmed
> + *
> + */
> +void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
> +{
> +       ufshcd_writel(hba, divider_val, DWC_UFS_REG_HCLKDIV);
> +}
> +
> +/**
> + * ufshcd_dwc_link_is_up()
> + * Check if link is up
> + * @hba: private structure poitner
> + *
> + * Returns 0 on success, non-zero value on failure
> + */
> +int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
> +{
> +       int dme_result = 0;
> +
> +       ufshcd_dme_get(hba, UIC_ARG_MIB(VS_POWERSTATE), &dme_result);
> +
> +       if (dme_result == UFSHCD_LINK_IS_UP) {
> +               ufshcd_set_link_active(hba);
> +               return 0;
> +       }
> +
> +       return 1;
> +}
> +
> +/**
> + * ufshcd_dwc_connection_setup()
> + * This function configures both the local side (host) and the peer side
> + * (device) unipro attributes to establish the connection to application/
> + * cport.
> + * This function is not required if the hardware is properly configured to
> + * have this connection setup on reset. But invoking this function does no
> + * harm and should be fine even working with any ufs device.
> + *
> + * @hba: pointer to drivers private data
> + *
> + * Returns 0 on success non-zero value on failure
> + */
> +int ufshcd_dwc_connection_setup(struct ufs_hba *hba)
> +{
> +       int ret = 0;
> +
> +       /* Local side Configuration */
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), 0);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB(N_DEVICEID), 0);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB(N_DEVICEID_VALID), 0);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERDEVICEID), 1);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERCPORTID), 0);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_TRAFFICCLASS), 0);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_CPORTFLAGS), 0x6);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_CPORTMODE), 1);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), 1);
> +       if (ret)
> +               goto out;
> +
> +
> +       /* Peer side Configuration */
> +       ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), 0);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(N_DEVICEID), 1);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(N_DEVICEID_VALID), 1);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_PEERDEVICEID), 1);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_PEERCPORTID), 0);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_TRAFFICCLASS), 0);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_CPORTFLAGS), 0x6);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_CPORTMODE), 1);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), 1);
> +       if (ret)
> +               goto out;
> +
> +out:
> +       return ret;
> +}
> +
> +/**
> + * ufshcd_dwc_setup_20bit_rmmi_lane0()
> + * This function configures Synopsys MPHY 20-bit RMMI Lane 0
> + * @hba: Pointer to drivers structure
> + *
> + * Returns 0 on success or non-zero value on failure
> + */
> +int ufshcd_dwc_setup_20bit_rmmi_lane0(struct ufs_hba *hba)
> +{
> +       int ret = 0;
> +
> +       /* TX Reference Clock 26MHz */
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(TX_REFCLKFREQ,
> +                                                       SELIND_LN0_TX), 0x01);
> +       if (ret)
> +               goto out;
> +
> +#ifdef CONFIG_SCSI_UFS_DWC_MPHY_TC_GEN2

Furthermore, the ARM developers are moving towards having single
kernels that support multiple different hardware platforms based on
the devicetree loaded at boot.

It's expected that a single kernel might have drivers to support
multiple different types of UFS hardware from multiple vendors.

Consequently, as the GEN2 hardware needs extra stuff, this stuff
should be enabled either by:
1. detecting it at runtime
2. adding a second compatible string and checking it where needed
3. using a separate driver with a different compatible string

[snip]

> @@ -5645,8 +6449,16 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>          */
>         ufshcd_set_ufs_dev_poweroff(hba);
>
> +#ifndef CONFIG_SCSI_UFS_DWC_HOOKS
>         async_schedule(ufshcd_async_scan, hba);
> -
> +#else
> +       /* Synopsys DWC Core + MPHY Test Chip needs a specific init routine */
> +       err = ufshcd_dwc_host_configuration(hba);
> +       if (err)
> +               dev_err(dev, "DWC host configuration failed\n");
> +       else
> +               dev_info(dev, "DWC host configuration successful\n");
> +#endif

This initialisation should be in your hardware specific code.

>         return 0;
>
>  out_remove_scsi_host:
> diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
> index 0ae0967..9bf67fb 100644
> --- a/drivers/scsi/ufs/ufshci.h
> +++ b/drivers/scsi/ufs/ufshci.h
> @@ -72,8 +72,28 @@ enum {
>         REG_UIC_COMMAND_ARG_1                   = 0x94,
>         REG_UIC_COMMAND_ARG_2                   = 0x98,
>         REG_UIC_COMMAND_ARG_3                   = 0x9C,
> +
> +/* DWC UFS HC specific Registers */
> +#ifdef CONFIG_SCSI_UFS_DWC_HOOKS
> +       DWC_UFS_REG_HCLKDIV                     = 0xFC,
> +#endif

All the DWC specific registers and datatypes should be in a separate header.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
