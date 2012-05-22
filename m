From: Girish K S <girish.shivananjappa@linaro.org>
Subject: Re: [RFC V3 2/2] SCSI: UFS: Add platform support for ufs host controller
Date: Tue, 22 May 2012 12:59:09 +0530
Message-ID: <CAGxe1ZGcW0QXTwmDduM_LMhK0Gz4ujfq53AeS4b9M_1_4J61rg@mail.gmail.com>
References: <1337581868-3042-1-git-send-email-girish.shivananjappa@linaro.org>
	<1337581868-3042-3-git-send-email-girish.shivananjappa@linaro.org>
	<CANfBPZ-iU7_0uD0aDiczDqK=jQW1ZVOhPDEH7q27TAy4V0rVGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:54225 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab2EVH3K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 May 2012 03:29:10 -0400
Received: by qadb17 with SMTP id b17so2071179qad.19
        for <linux-scsi@vger.kernel.org>; Tue, 22 May 2012 00:29:09 -0700 (PDT)
In-Reply-To: <CANfBPZ-iU7_0uD0aDiczDqK=jQW1ZVOhPDEH7q27TAy4V0rVGw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "S, Venkatraman" <svenkatr@ti.com>
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, vinholikatti@gmail.com, santoshsy@gmail.com, hch@infradead.org, patches@linaro.org

On 22 May 2012 11:07, S, Venkatraman <svenkatr@ti.com> wrote:
> On Mon, May 21, 2012 at 12:01 PM, Girish K S
> <girish.shivananjappa@linaro.org> wrote:
>> This patch adds platform support for ufs host controller
>> The SoC's that use non-pci probing should use this option.
>>
>> Signed-off-by: Girish K S <girish.shivananjappa@linaro.org>
>> ---
>> =A0drivers/scsi/ufs/Kconfig =A0 =A0 =A0 =A0| =A0 13 +++
>> =A0drivers/scsi/ufs/Makefile =A0 =A0 =A0 | =A0 =A01 +
>> =A0drivers/scsi/ufs/ufshcd-pltfm.c | =A0180 ++++++++++++++++++++++++=
+++++++++++++++
>> =A03 files changed, 194 insertions(+), 0 deletions(-)
>> =A0create mode 100644 drivers/scsi/ufs/ufshcd-pltfm.c
>>
>> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
>> index 2a70972..dae5428 100644
>> --- a/drivers/scsi/ufs/Kconfig
>> +++ b/drivers/scsi/ufs/Kconfig
>> @@ -60,3 +60,16 @@ config SCSI_UFSHCD_PCI
>> =A0 =A0 =A0 =A0If you have a controller with this interface, say Y o=
r M here.
>>
>> =A0 =A0 =A0 =A0If unsure, say N.
>> +
>> +config SCSI_UFSHCD_PLTFM
>> + =A0 =A0 =A0 tristate "Universal Flash Storage host support as plat=
form device"
>> + =A0 =A0 =A0 depends on SCSI_UFSHCD
>> + =A0 =A0 =A0 help
>> + =A0 =A0 =A0 This selects the common helper functions support for H=
ost Controller
>> + =A0 =A0 =A0 Interface based platform driver. Please select this op=
tion if the IP
>> + =A0 =A0 =A0 is present as a platform device. This is the common in=
terface for the
>> + =A0 =A0 =A0 UFS Host Controller IP.
>> +
>> + =A0 =A0 =A0 If you have a controller with this interface, say Y or=
 M here.
>> +
>> + =A0 =A0 =A0 If unsure, say N.
>> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
>> index 9eda0df..fc56471 100644
>> --- a/drivers/scsi/ufs/Makefile
>> +++ b/drivers/scsi/ufs/Makefile
>> @@ -1,3 +1,4 @@
>> =A0# UFSHCD makefile
>> =A0obj-$(CONFIG_SCSI_UFSHCD) +=3D ufshcd.o
>> =A0obj-$(CONFIG_SCSI_UFSHCD_PCI) +=3D ufshcd-pci.o
>> +obj-$(CONFIG_SCSI_UFSHCD_PLTFM) +=3D ufshcd-pltfm.o
>> diff --git a/drivers/scsi/ufs/ufshcd-pltfm.c b/drivers/scsi/ufs/ufsh=
cd-pltfm.c
>> new file mode 100644
>> index 0000000..7558210
>> --- /dev/null
>> +++ b/drivers/scsi/ufs/ufshcd-pltfm.c
>> @@ -0,0 +1,180 @@
>> +/*
>> + * Universal Flash Storage Host controller driver
>> + *
>> + * This code is based on drivers/scsi/ufs/ufshcd.c
>> + * Copyright (C) 2011-2012 Samsung India Software Operations
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * as published by the Free Software Foundation; either version 2
>> + * of the License, or (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. =A0See the
>> + * GNU General Public License for more details.
>> + *
>> + * NO WARRANTY
>> + * THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES =
OR
>> + * CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WIT=
HOUT
>> + * LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEM=
ENT,
>> + * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipi=
ent is
>> + * solely responsible for determining the appropriateness of using =
and
>> + * distributing the Program and assumes all risks associated with i=
ts
>> + * exercise of rights under this Agreement, including but not limit=
ed to
>> + * the risks and costs of program errors, damage to or loss of data=
,
>> + * programs or equipment, and unavailability or interruption of ope=
rations.
>> +
>> + * DISCLAIMER OF LIABILITY
>> + * NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY =
=46OR ANY
>> + * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTI=
AL
>> + * DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAU=
SED AND
>> + * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILIT=
Y, OR
>> + * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT =
OF THE
>> + * USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS=
 GRANTED
>> + * HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
>> +
>> + * You should have received a copy of the GNU General Public Licens=
e
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA =A0=
02110-1301,
>> + * USA.
>> + */
>> +
>> +#include <linux/interrupt.h>
>> +#include <linux/module.h>
>> +#include <linux/io.h>
>> +#include <linux/irq.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/slab.h>
>> +#include <linux/dma-mapping.h>
>> +#include <scsi/scsi_host.h>
>> +
>> +#include "ufs.h"
>> +#include "ufshci.h"
>> +
>> +/**
>> + * ufshcd_pltfmset_dma_mask - Set dma mask based on the controller
>> + * =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0addressing capability
>> + * @ihba: pointer to host platform data
>> + *
>> + * Returns 0 for success, non-zero for failure
>> + */
>> +static int ufshcd_pltfm_set_dma_mask(struct platform_device *pdev)
>> +{
>> + =A0 =A0 =A0 int err;
>> + =A0 =A0 =A0 u64 dma_mask;
>> +
>> + =A0 =A0 =A0 dma_mask =3D DMA_BIT_MASK(64);
>> + =A0 =A0 =A0 err =3D dma_set_coherent_mask(&pdev->dev, dma_mask);
>> + =A0 =A0 =A0 if (err) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_mask =3D DMA_BIT_MASK(32);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D dma_set_coherent_mask(&pdev->d=
ev, dma_mask);
>> + =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 return err;
>> +}
>> +
>> +static int __devinit ufshcd_pltfm_probe(struct platform_device *pde=
v)
>> +{
>> + =A0 =A0 =A0 struct ufs_hba *uninitialized_var(hba);
>> + =A0 =A0 =A0 struct resource *regs;
>> + =A0 =A0 =A0 int err, irq;
>> + =A0 =A0 =A0 void __iomem *mmio_base;
>> +
>> + =A0 =A0 =A0 regs =3D platform_get_resource(pdev, IORESOURCE_MEM, 0=
);
>> + =A0 =A0 =A0 if (!regs)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENXIO;
>> +
>> + =A0 =A0 =A0 irq =3D platform_get_irq(pdev, 0);
>> + =A0 =A0 =A0 if (irq < 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return irq;
>> +
>> + =A0 =A0 =A0 mmio_base =3D ioremap(regs->start, resource_size(regs)=
);
>> + =A0 =A0 =A0 if (!mmio_base)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> +
>> + =A0 =A0 =A0 err =3D ufshcd_pltfm_set_dma_mask(pdev);
>> + =A0 =A0 =A0 if (err) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "set dma mask fail=
ed\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto =A0err_iounmap;
>> + =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 err =3D ufshcd_drv_init(&hba, &pdev->dev, irq, mmio_ba=
se);
>> + =A0 =A0 =A0 if (err)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_iounmap;
>> +
>> + =A0 =A0 =A0 platform_set_drvdata(pdev, hba);
>> +
>> + =A0 =A0 =A0 /* Initialization routine */
>> + =A0 =A0 =A0 err =3D ufshcd_initialize_hba(hba);
>> + =A0 =A0 =A0 if (err) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->dev, "Initialization fai=
led\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_remove;
>> + =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 return err;
>> +
>> +err_remove:
>> + =A0 =A0 =A0 ufshcd_drv_exit(hba);
>> +err_iounmap:
>> + =A0 =A0 =A0 iounmap(hba->mmio_base);
>> + =A0 =A0 =A0 return err;
>> +}
>> +
>> +static int __devexit ufshcd_pltfm_remove(struct platform_device *pd=
ev)
>> +{
>> + =A0 =A0 =A0 struct ufs_hba *hba =3D platform_get_drvdata(pdev);
>> +
>> + =A0 =A0 =A0 ufshcd_drv_exit(hba);
>> + =A0 =A0 =A0 iounmap(hba->mmio_base);
>> + =A0 =A0 =A0 platform_set_drvdata(pdev, NULL);
>> + =A0 =A0 =A0 return 0;
>> +}
>> +
>> +#ifdef CONFIG_PM
>> +static int ufshcd_pltfm_suspend(struct device *dev)
>> +{
>> + =A0 =A0 =A0 int ret;
>> + =A0 =A0 =A0 struct ufs_hba *hba =3D dev_get_drvdata(dev);
>> +
>> + =A0 =A0 =A0 ret =3D ufshcd_suspend(hba);
>> + =A0 =A0 =A0 if (ret)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> The above 2 lines are redundant...
agreed.
>> +
>> + =A0 =A0 =A0 return 0;
> .. if you simply do a "return ret" here...
>
>> +}
>> +
>> +static int ufshcd_pltfm_resume(struct device *dev)
>> +{
>> + =A0 =A0 =A0 int ret;
>> + =A0 =A0 =A0 struct ufs_hba *hba =3D dev_get_drvdata(dev);
>> +
>> + =A0 =A0 =A0 ret =3D ufshcd_resume(hba);
>> + =A0 =A0 =A0 if (ret)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
>
> .. ditto
>> +
>> + =A0 =A0 =A0 return 0;
>> +}
>> +#else
>> +#define ufshcd_pltfm_suspend =A0 NULL
>> +#define ufshcd_pltfm_resume =A0 =A0NULL
>> +#endif /* CONFIG_PM */
>> +
>> +static SIMPLE_DEV_PM_OPS(ufshcd_pltfm_pmops,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ufshcd_pltfm_suspen=
d,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ufshcd_pltfm_resume=
);
>> +
>> +static struct platform_driver ufshcd_pltfm_driver =3D {
>> + =A0 =A0 =A0 .probe =A0 =A0 =A0 =A0 =A0=3D ufshcd_pltfm_probe,
>> + =A0 =A0 =A0 .remove =A0 =A0 =A0 =A0 =3D __devexit_p(ufshcd_pltfm_r=
emove),
>> + =A0 =A0 =A0 .driver =A0 =A0 =A0 =A0 =3D {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .name =A0 =A0 =A0 =A0 =A0 =3D "ufshcd-=
pltfm",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .pm =A0 =A0 =A0 =A0 =A0 =A0 =3D &ufshc=
d_pltfm_pmops,
>> + =A0 =A0 =A0 },
>> +};
>> +
>> +module_platform_driver(ufshcd_pltfm_driver);
>> +
>> +MODULE_DESCRIPTION("UFS Host Controller platform Interface driver")=
;
>> +MODULE_AUTHOR("Girish K S <ks.giri@samsung.com>");
>> +MODULE_LICENSE("GPL");
>> --
>> 1.7.4.1
>>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
