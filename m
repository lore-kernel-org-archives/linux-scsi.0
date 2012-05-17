From: "S, Venkatraman" <svenkatr@ti.com>
Subject: Re: [RFC V2 1/2] SCSI: UFS: Create separate UFS core and pci modules
Date: Thu, 17 May 2012 18:41:57 +0530
Message-ID: <CANfBPZ8_-CDmvgM+Xjs5Ggdbe_aE0c0TzcbFb-6JJfedLtaWcw@mail.gmail.com>
References: <1337253726-2666-1-git-send-email-girish.shivananjappa@linaro.org> <1337253726-2666-2-git-send-email-girish.shivananjappa@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:45052 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759681Ab2EQNMV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 May 2012 09:12:21 -0400
Received: by bkwj10 with SMTP id j10so1832599bkw.32
        for <linux-scsi@vger.kernel.org>; Thu, 17 May 2012 06:12:17 -0700 (PDT)
In-Reply-To: <1337253726-2666-2-git-send-email-girish.shivananjappa@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Girish K S <girish.shivananjappa@linaro.org>
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, vinholikatti@gmail.com, santoshsy@gmail.com, hch@infradead.org, patches@linaro.org

On Thu, May 17, 2012 at 4:52 PM, Girish K S
<girish.shivananjappa@linaro.org> wrote:
> The existing driver was pci specific. This patch removes the
> pci specific code from the core driver. Irrespective of the
> pci or non-pci probe, the same core driver can be re-used.
>
> It also creates 2 separate modules of core and pci driver
>
> Signed-off-by: Girish K S <girish.shivananjappa@linaro.org>
> ---
> =A0drivers/scsi/ufs/Kconfig =A0 =A0 =A0| =A0 19 ++-
> =A0drivers/scsi/ufs/Makefile =A0 =A0 | =A0 =A01 +
> =A0drivers/scsi/ufs/ufs.h =A0 =A0 =A0 =A0| =A0103 +++++++++++
> =A0drivers/scsi/ufs/ufshcd-pci.c | =A0217 ++++++++++++++++++++++++
> =A0drivers/scsi/ufs/ufshcd.c =A0 =A0 | =A0374 +++++++++++------------=
------------------
> =A05 files changed, 436 insertions(+), 278 deletions(-)
> =A0create mode 100644 drivers/scsi/ufs/ufshcd-pci.c
>
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index 8f27f9d..2a70972 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -44,6 +44,19 @@
>
> =A0config SCSI_UFSHCD
> =A0 =A0 =A0 =A0tristate "Universal Flash Storage host controller driv=
er"
> - =A0 =A0 =A0 depends on PCI && SCSI
> - =A0 =A0 =A0 ---help---
> - =A0 =A0 =A0 This is a generic driver which supports PCIe UFS Host c=
ontrollers.
> + =A0 =A0 =A0 depends on SCSI
> + =A0 =A0 =A0 help
> + =A0 =A0 =A0 This is a generic driver which supports UFS Host contro=
llers.
> + =A0 =A0 =A0 This option is selected automatically if the SCSI optio=
n is
> + =A0 =A0 =A0 selected. This is a core ufs driver.
> +
> +config SCSI_UFSHCD_PCI
> + =A0 =A0 =A0 tristate "Universal Flash Storage host support on PCI b=
us"
> + =A0 =A0 =A0 depends on SCSI_UFSHCD && PCI
> + =A0 =A0 =A0 help
> + =A0 =A0 =A0 This selects the PCI bus for the Universal Flash Storag=
e IP.
> + =A0 =A0 =A0 Select this option if the IP is present on PCI platform=
=2E
> +
> + =A0 =A0 =A0 If you have a controller with this interface, say Y or =
M here.
> +
> + =A0 =A0 =A0 If unsure, say N.
> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> index adf7895..9eda0df 100644
> --- a/drivers/scsi/ufs/Makefile
> +++ b/drivers/scsi/ufs/Makefile
> @@ -1,2 +1,3 @@
> =A0# UFSHCD makefile
> =A0obj-$(CONFIG_SCSI_UFSHCD) +=3D ufshcd.o
> +obj-$(CONFIG_SCSI_UFSHCD_PCI) +=3D ufshcd-pci.o
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index b207529..029a3f3 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -46,6 +46,8 @@
> =A0#ifndef _UFS_H
> =A0#define _UFS_H
>
> +#define ufs_hostname(x) =A0 =A0 =A0 =A0(dev_name(&(x)->dev))
> +
> =A0#define MAX_CDB_SIZE =A0 16
>
> =A0#define UPIU_HEADER_DWORD(byte3, byte2, byte1, byte0)\
> @@ -204,4 +206,105 @@ struct utp_upiu_task_rsp {
> =A0 =A0 =A0 =A0u32 reserved[3];
> =A0};
>
> +/**
> + * struct uic_command - UIC command structure
> + * @command: UIC command
> + * @argument1: UIC command argument 1
> + * @argument2: UIC command argument 2
> + * @argument3: UIC command argument 3
> + * @cmd_active: Indicate if UIC command is outstanding
> + * @result: UIC command result
> + */
> +struct uic_command {
> + =A0 =A0 =A0 u32 command;
> + =A0 =A0 =A0 u32 argument1;
> + =A0 =A0 =A0 u32 argument2;
> + =A0 =A0 =A0 u32 argument3;
> + =A0 =A0 =A0 int cmd_active;
> + =A0 =A0 =A0 int result;
> +};
> +
> +struct ufs_pdata {
> + =A0 =A0 =A0 /* TODO */
> + =A0 =A0 =A0 u32 quirks; /* Quirk flags */
> +};
> +
> +/**
> + * struct ufs_hba - per adapter private structure
> + * @mmio_base: UFSHCI base register address
> + * @ucdl_base_addr: UFS Command Descriptor base address
> + * @utrdl_base_addr: UTP Transfer Request Descriptor base address
> + * @utmrdl_base_addr: UTP Task Management Descriptor base address
> + * @ucdl_dma_addr: UFS Command Descriptor DMA address
> + * @utrdl_dma_addr: UTRDL DMA address
> + * @utmrdl_dma_addr: UTMRDL DMA address
> + * @host: Scsi_Host instance of the driver
> + * @dev: device handle
> + * @lrb: local reference block
> + * @outstanding_tasks: Bits representing outstanding task requests
> + * @outstanding_reqs: Bits representing outstanding transfer request=
s
> + * @capabilities: UFS Controller Capabilities
> + * @nutrs: Transfer Request Queue depth supported by controller
> + * @nutmrs: Task Management Queue depth supported by controller
> + * @active_uic_cmd: handle of active UIC command
> + * @ufshcd_tm_wait_queue: wait queue for task management
> + * @tm_condition: condition variable for task management
> + * @ufshcd_state: UFSHCD states
> + * @int_enable_mask: Interrupt Mask Bits
> + * @uic_workq: Work queue for UIC completion handling
> + * @feh_workq: Work queue for fatal controller error handling
> + * @errors: HBA errors
> + */
> +struct ufs_hba {
> + =A0 =A0 =A0 void __iomem *mmio_base;
> +
> + =A0 =A0 =A0 /* Virtual memory reference */
> + =A0 =A0 =A0 struct utp_transfer_cmd_desc *ucdl_base_addr;
> + =A0 =A0 =A0 struct utp_transfer_req_desc *utrdl_base_addr;
> + =A0 =A0 =A0 struct utp_task_req_desc *utmrdl_base_addr;
> +
> + =A0 =A0 =A0 /* DMA memory reference */
> + =A0 =A0 =A0 dma_addr_t ucdl_dma_addr;
> + =A0 =A0 =A0 dma_addr_t utrdl_dma_addr;
> + =A0 =A0 =A0 dma_addr_t utmrdl_dma_addr;
> +
> + =A0 =A0 =A0 struct Scsi_Host *host;
> + =A0 =A0 =A0 struct device dev;
> +
> + =A0 =A0 =A0 struct ufshcd_lrb *lrb;
> +
> + =A0 =A0 =A0 unsigned long outstanding_tasks;
> + =A0 =A0 =A0 unsigned long outstanding_reqs;
> +
> + =A0 =A0 =A0 u32 capabilities;
> + =A0 =A0 =A0 int nutrs;
> + =A0 =A0 =A0 int nutmrs;
> + =A0 =A0 =A0 u32 ufs_version;
> +
> + =A0 =A0 =A0 struct uic_command active_uic_cmd;
> + =A0 =A0 =A0 wait_queue_head_t ufshcd_tm_wait_queue;
> + =A0 =A0 =A0 unsigned long tm_condition;
> +
> + =A0 =A0 =A0 u32 ufshcd_state;
> + =A0 =A0 =A0 u32 int_enable_mask;
> +
> + =A0 =A0 =A0 /* Work Queues */
> + =A0 =A0 =A0 struct work_struct uic_workq;
> + =A0 =A0 =A0 struct work_struct feh_workq;
> +
> + =A0 =A0 =A0 /* HBA Errors */
> + =A0 =A0 =A0 u32 errors;
> +
> + =A0 =A0 =A0 unsigned int =A0 =A0 =A0 =A0 =A0 =A0irq;
> +};
> +
> +extern int ufshcd_initialize_hba(struct ufs_hba *hba);
> +extern int ufshcd_probe(struct ufs_hba **hostdat, struct device *dev=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int irq_no, void __iome=
m *mmio_base);
> +extern void ufshcd_remove(struct ufs_hba *hba);
> +#ifdef CONFIG_PM
> +extern int ufshcd_suspend(struct ufs_hba *hba);
> +extern int ufshcd_resume(struct ufs_hba *hba);
> +#endif /* CONFIG_PM */
> +
> =A0#endif /* End of Header */
> diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-=
pci.c
> new file mode 100644
> index 0000000..eabdaa6
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufshcd-pci.c
> @@ -0,0 +1,217 @@
> +/*
> + * Universal Flash Storage Host controller driver
> + *
> + * This code is based on drivers/scsi/ufs/ufshcd.c
> + * Copyright (C) 2011-2012 Samsung India Software Operations
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. =A0See the
> + * GNU General Public License for more details.
> + *
> + * NO WARRANTY
> + * THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES O=
R
> + * CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITH=
OUT
> + * LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEME=
NT,
> + * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipie=
nt is
> + * solely responsible for determining the appropriateness of using a=
nd
> + * distributing the Program and assumes all risks associated with it=
s
> + * exercise of rights under this Agreement, including but not limite=
d to
> + * the risks and costs of program errors, damage to or loss of data,
> + * programs or equipment, and unavailability or interruption of oper=
ations.
> +
> + * DISCLAIMER OF LIABILITY
> + * NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY F=
OR ANY
> + * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIA=
L
> + * DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAUS=
ED AND
> + * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY=
, OR
> + * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT O=
=46 THE
> + * USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS =
GRANTED
> + * HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
> +
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA =A0=
02110-1301,
> + * USA.
> + */
> +
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/io.h>
> +#include <linux/pci.h>
> +#include <scsi/scsi_host.h>
> +
> +#include "ufs.h"
> +#include "ufshci.h"
> +
> +/**
> + * ufshcd_pci_set_dma_mask - Set dma mask based on the controller
> + * =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0addressing capability
> + * @ihba: pointer to host platform data
> + *
> + * Returns 0 for success, non-zero for failure
> + */
> +static int ufshcd_pci_set_dma_mask(struct pci_dev *pdev)
> +{
> + =A0 =A0 =A0 int err;
> + =A0 =A0 =A0 u64 dma_mask;
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* If controller supports 64 bit addressing mode, the=
n set the DMA
> + =A0 =A0 =A0 =A0* mask to 64-bit, else set the DMA mask to 32-bit
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 dma_mask =3D DMA_BIT_MASK(64);
> + =A0 =A0 =A0 err =3D pci_set_dma_mask(pdev, dma_mask);
> + =A0 =A0 =A0 if (err) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_mask =3D DMA_BIT_MASK(32);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D pci_set_dma_mask(pdev, dma_mask=
);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (err)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return err;
> +
> + =A0 =A0 =A0 err =3D pci_set_consistent_dma_mask(pdev, dma_mask);
> +
> + =A0 =A0 =A0 return err;
> +}
> +
> +static int __devinit ufshcd_pci_probe(struct pci_dev *pdev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 con=
st struct pci_device_id *entries)
> +{
> + =A0 =A0 =A0 struct ufs_hba *uninitialized_var(hba);
> + =A0 =A0 =A0 int err;
> + =A0 =A0 =A0 void __iomem *mmio_base;
> +
> + =A0 =A0 =A0 err =3D pci_enable_device(pdev);
> + =A0 =A0 =A0 if (err) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "pci_enable_device =
failed\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_return;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 pci_set_master(pdev);
> +
> + =A0 =A0 =A0 err =3D pci_request_regions(pdev, "ufshcd_pci");
> + =A0 =A0 =A0 if (err < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "request regions fa=
iled\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_disable;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 mmio_base =3D pci_ioremap_bar(pdev, 0);
> + =A0 =A0 =A0 if (!mmio_base) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "memory map failed\=
n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_release;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 err =3D ufshcd_pci_set_dma_mask(pdev);
> + =A0 =A0 =A0 if (err) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "set dma mask faile=
d\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_iounmap;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 err =3D ufshcd_probe(&hba, &pdev->dev, pdev->irq, mmio_=
base);
> + =A0 =A0 =A0 if (err)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_iounmap;
> +
> + =A0 =A0 =A0 pci_set_drvdata(pdev, hba);
> +
> + =A0 =A0 =A0 /* Initialization routine */
> + =A0 =A0 =A0 err =3D ufshcd_initialize_hba(hba);
> + =A0 =A0 =A0 if (err) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->dev, "Initialization fail=
ed\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_remove;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return err;
> +
> +err_remove:
> + =A0 =A0 =A0 ufshcd_remove(hba);
> +err_iounmap:
> + =A0 =A0 =A0 iounmap(hba->mmio_base);
> +err_release:
> + =A0 =A0 =A0 pci_release_regions(pdev);
> +err_disable:
> + =A0 =A0 =A0 pci_clear_master(pdev);
> + =A0 =A0 =A0 pci_disable_device(pdev);
> +err_return:
> + =A0 =A0 =A0 return err;
> +}
> +
> +static void __devexit ufshcd_pci_remove(struct pci_dev *pdev)
> +{
> + =A0 =A0 =A0 struct ufs_hba *hba =3D pci_get_drvdata(pdev);
> +
> + =A0 =A0 =A0 ufshcd_remove(hba);
> + =A0 =A0 =A0 iounmap(hba->mmio_base);
> + =A0 =A0 =A0 pci_set_drvdata(pdev, NULL);
> + =A0 =A0 =A0 pci_clear_master(pdev);
> + =A0 =A0 =A0 pci_release_regions(pdev);
> + =A0 =A0 =A0 pci_disable_device(pdev);
> +}
> +
> +#ifdef CONFIG_PM_SLEEP

Is there a reason to use CONFIG_PM for ufshcd_suspend and
CONFIG_PM_SLEEP for ufshcd_pci_suspend ?

> +static int ufshcd_pci_suspend(struct device *dev)
> +{
> + =A0 =A0 =A0 int ret;
> + =A0 =A0 =A0 struct pci_dev *pdev =3D to_pci_dev(dev);
> + =A0 =A0 =A0 struct ufs_hba *hba =3D pci_get_drvdata(pdev);
> +
> + =A0 =A0 =A0 ret =3D ufshcd_suspend(hba);
> + =A0 =A0 =A0 return ret;
> +}
> +
> +static int ufshcd_pci_resume(struct device *dev)
> +{
> + =A0 =A0 =A0 int ret;
> + =A0 =A0 =A0 struct pci_dev *pdev =3D to_pci_dev(dev);
> + =A0 =A0 =A0 struct ufs_hba *hba =3D pci_get_drvdata(pdev);
> +
> + =A0 =A0 =A0 ret =3D ufshcd_resume(hba);
> + =A0 =A0 =A0 return ret;
> +}
> +#else
> +#define ufshcd_pci_suspend =A0 =A0 NULL
> +#define ufshcd_pci_resume =A0 =A0 =A0NULL
> +#endif /* CONFIG_PM_SLEEP */
> +
> +static SIMPLE_DEV_PM_OPS(ufshcd_pci_pmops,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ufshcd_pci_suspend,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ufshcd_pci_resume);
> +
> +static DEFINE_PCI_DEVICE_TABLE(ufshcd_pci_id) =3D {
> + =A0 =A0 =A0 { PCI_VENDOR_ID_SAMSUNG, 0xC00C, PCI_ANY_ID, PCI_ANY_ID=
, 0, 0, 0 },
> + =A0 =A0 =A0 {}
> +};
> +MODULE_DEVICE_TABLE(pci, ufshcd_pci_id);
> +
> +static struct pci_driver ufshcd_pci_driver =3D {
> + =A0 =A0 =A0 .name =A0 =A0 =A0 =A0 =A0 =3D "ufshcd_pci",
> + =A0 =A0 =A0 .id_table =A0 =A0 =A0 =3D ufshcd_pci_id,
> + =A0 =A0 =A0 .probe =A0 =A0 =A0 =A0 =A0=3D ufshcd_pci_probe,
> + =A0 =A0 =A0 .remove =A0 =A0 =A0 =A0 =3D ufshcd_pci_remove,
Please use the __devexit_p annotation

> + =A0 =A0 =A0 .driver =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .pm =3D =A0 &ufshcd_pci_pmops
> + =A0 =A0 =A0 },
> +};
> +
> +static int __init ufshcd_init(void)
> +{
> + =A0 =A0 =A0 return pci_register_driver(&ufshcd_pci_driver);
> +}
> +
> +static void __exit ufshcd_exit(void)
> +{
> + =A0 =A0 =A0 pci_unregister_driver(&ufshcd_pci_driver);
> +}
> +
> +module_init(ufshcd_init);
> +module_exit(ufshcd_exit);
> +
Please use the module_pci_driver() macro

> +MODULE_DESCRIPTION("UFS Host Controller PCI Interface driver");
> +MODULE_AUTHOR("Girish K S <ks.giri@samsung.com>");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index e47a0da..7c49074 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -46,7 +46,6 @@
> =A0#include <linux/module.h>
> =A0#include <linux/kernel.h>
> =A0#include <linux/init.h>
> -#include <linux/pci.h>
> =A0#include <linux/interrupt.h>
> =A0#include <linux/io.h>
> =A0#include <linux/delay.h>
> @@ -102,91 +101,6 @@ enum {
> =A0};
>
> =A0/**
> - * struct uic_command - UIC command structure
> - * @command: UIC command
> - * @argument1: UIC command argument 1
> - * @argument2: UIC command argument 2
> - * @argument3: UIC command argument 3
> - * @cmd_active: Indicate if UIC command is outstanding
> - * @result: UIC command result
> - */
> -struct uic_command {
> - =A0 =A0 =A0 u32 command;
> - =A0 =A0 =A0 u32 argument1;
> - =A0 =A0 =A0 u32 argument2;
> - =A0 =A0 =A0 u32 argument3;
> - =A0 =A0 =A0 int cmd_active;
> - =A0 =A0 =A0 int result;
> -};
> -
> -/**
> - * struct ufs_hba - per adapter private structure
> - * @mmio_base: UFSHCI base register address
> - * @ucdl_base_addr: UFS Command Descriptor base address
> - * @utrdl_base_addr: UTP Transfer Request Descriptor base address
> - * @utmrdl_base_addr: UTP Task Management Descriptor base address
> - * @ucdl_dma_addr: UFS Command Descriptor DMA address
> - * @utrdl_dma_addr: UTRDL DMA address
> - * @utmrdl_dma_addr: UTMRDL DMA address
> - * @host: Scsi_Host instance of the driver
> - * @pdev: PCI device handle
> - * @lrb: local reference block
> - * @outstanding_tasks: Bits representing outstanding task requests
> - * @outstanding_reqs: Bits representing outstanding transfer request=
s
> - * @capabilities: UFS Controller Capabilities
> - * @nutrs: Transfer Request Queue depth supported by controller
> - * @nutmrs: Task Management Queue depth supported by controller
> - * @active_uic_cmd: handle of active UIC command
> - * @ufshcd_tm_wait_queue: wait queue for task management
> - * @tm_condition: condition variable for task management
> - * @ufshcd_state: UFSHCD states
> - * @int_enable_mask: Interrupt Mask Bits
> - * @uic_workq: Work queue for UIC completion handling
> - * @feh_workq: Work queue for fatal controller error handling
> - * @errors: HBA errors
> - */
> -struct ufs_hba {
> - =A0 =A0 =A0 void __iomem *mmio_base;
> -
> - =A0 =A0 =A0 /* Virtual memory reference */
> - =A0 =A0 =A0 struct utp_transfer_cmd_desc *ucdl_base_addr;
> - =A0 =A0 =A0 struct utp_transfer_req_desc *utrdl_base_addr;
> - =A0 =A0 =A0 struct utp_task_req_desc *utmrdl_base_addr;
> -
> - =A0 =A0 =A0 /* DMA memory reference */
> - =A0 =A0 =A0 dma_addr_t ucdl_dma_addr;
> - =A0 =A0 =A0 dma_addr_t utrdl_dma_addr;
> - =A0 =A0 =A0 dma_addr_t utmrdl_dma_addr;
> -
> - =A0 =A0 =A0 struct Scsi_Host *host;
> - =A0 =A0 =A0 struct pci_dev *pdev;
> -
> - =A0 =A0 =A0 struct ufshcd_lrb *lrb;
> -
> - =A0 =A0 =A0 unsigned long outstanding_tasks;
> - =A0 =A0 =A0 unsigned long outstanding_reqs;
> -
> - =A0 =A0 =A0 u32 capabilities;
> - =A0 =A0 =A0 int nutrs;
> - =A0 =A0 =A0 int nutmrs;
> - =A0 =A0 =A0 u32 ufs_version;
> -
> - =A0 =A0 =A0 struct uic_command active_uic_cmd;
> - =A0 =A0 =A0 wait_queue_head_t ufshcd_tm_wait_queue;
> - =A0 =A0 =A0 unsigned long tm_condition;
> -
> - =A0 =A0 =A0 u32 ufshcd_state;
> - =A0 =A0 =A0 u32 int_enable_mask;
> -
> - =A0 =A0 =A0 /* Work Queues */
> - =A0 =A0 =A0 struct work_struct uic_workq;
> - =A0 =A0 =A0 struct work_struct feh_workq;
> -
> - =A0 =A0 =A0 /* HBA Errors */
> - =A0 =A0 =A0 u32 errors;
> -};
> -
> -/**
> =A0* struct ufshcd_lrb - local reference block
> =A0* @utr_descriptor_ptr: UTRD address of the command
> =A0* @ucd_cmd_ptr: UCD address of the command
> @@ -335,21 +249,21 @@ static inline void ufshcd_free_hba_memory(struc=
t ufs_hba *hba)
>
> =A0 =A0 =A0 =A0if (hba->utmrdl_base_addr) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0utmrdl_size =3D sizeof(struct utp_task=
_req_desc) * hba->nutmrs;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_free_coherent(&hba->pdev->dev, utmr=
dl_size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_free_coherent(&hba->dev, utmrdl_siz=
e,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0hb=
a->utmrdl_base_addr, hba->utmrdl_dma_addr);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (hba->utrdl_base_addr) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0utrdl_size =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(sizeof(struct utp_transfer_req_desc) =
* hba->nutrs);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_free_coherent(&hba->pdev->dev, utrd=
l_size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_free_coherent(&hba->dev, utrdl_size=
,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0hb=
a->utrdl_base_addr, hba->utrdl_dma_addr);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (hba->ucdl_base_addr) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ucdl_size =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(sizeof(struct utp_transfer_cmd_desc) =
* hba->nutrs);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_free_coherent(&hba->pdev->dev, ucdl=
_size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_free_coherent(&hba->dev, ucdl_size,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0hb=
a->ucdl_base_addr, hba->ucdl_dma_addr);
> =A0 =A0 =A0 =A0}
> =A0}
> @@ -724,7 +638,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hb=
a)
>
> =A0 =A0 =A0 =A0/* Allocate memory for UTP command descriptors */
> =A0 =A0 =A0 =A0ucdl_size =3D (sizeof(struct utp_transfer_cmd_desc) * =
hba->nutrs);
> - =A0 =A0 =A0 hba->ucdl_base_addr =3D dma_alloc_coherent(&hba->pdev->=
dev,
> + =A0 =A0 =A0 hba->ucdl_base_addr =3D dma_alloc_coherent(&hba->dev,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 ucdl_size,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 &hba->ucdl_dma_addr,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 GFP_KERNEL);
> @@ -737,7 +651,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hb=
a)
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0if (!hba->ucdl_base_addr ||
> =A0 =A0 =A0 =A0 =A0 =A0WARN_ON(hba->ucdl_dma_addr & (PAGE_SIZE - 1)))=
 {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->dev,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"Command Descriptor Me=
mory allocation failed\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
> @@ -747,13 +661,13 @@ static int ufshcd_memory_alloc(struct ufs_hba *=
hba)
> =A0 =A0 =A0 =A0 * UFSHCI requires 1024 byte alignment of UTRD
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0utrdl_size =3D (sizeof(struct utp_transfer_req_desc) *=
 hba->nutrs);
> - =A0 =A0 =A0 hba->utrdl_base_addr =3D dma_alloc_coherent(&hba->pdev-=
>dev,
> + =A0 =A0 =A0 hba->utrdl_base_addr =3D dma_alloc_coherent(&hba->dev,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0utrdl_size,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0&hba->utrdl_dma_addr,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0GFP_KERNEL);
> =A0 =A0 =A0 =A0if (!hba->utrdl_base_addr ||
> =A0 =A0 =A0 =A0 =A0 =A0WARN_ON(hba->utrdl_dma_addr & (PAGE_SIZE - 1))=
) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->dev,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"Transfer Descriptor M=
emory allocation failed\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
> @@ -763,13 +677,13 @@ static int ufshcd_memory_alloc(struct ufs_hba *=
hba)
> =A0 =A0 =A0 =A0 * UFSHCI requires 1024 byte alignment of UTMRD
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0utmrdl_size =3D sizeof(struct utp_task_req_desc) * hba=
->nutmrs;
> - =A0 =A0 =A0 hba->utmrdl_base_addr =3D dma_alloc_coherent(&hba->pdev=
->dev,
> + =A0 =A0 =A0 hba->utmrdl_base_addr =3D dma_alloc_coherent(&hba->dev,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 utmrdl_size,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &hba->utmrdl_dma_addr,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 GFP_KERNEL);
> =A0 =A0 =A0 =A0if (!hba->utmrdl_base_addr ||
> =A0 =A0 =A0 =A0 =A0 =A0WARN_ON(hba->utmrdl_dma_addr & (PAGE_SIZE - 1)=
)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->dev,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"Task Management Descriptor Memory all=
ocation failed\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
> @@ -777,7 +691,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hb=
a)
> =A0 =A0 =A0 =A0/* Allocate memory for local reference block */
> =A0 =A0 =A0 =A0hba->lrb =3D kcalloc(hba->nutrs, sizeof(struct ufshcd_=
lrb), GFP_KERNEL);
> =A0 =A0 =A0 =A0if (!hba->lrb) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev, "LRB Memory al=
location failed\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->dev, "LRB Memory allocati=
on failed\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0return 0;
> @@ -867,7 +781,7 @@ static int ufshcd_dme_link_startup(struct ufs_hba=
 *hba)
> =A0 =A0 =A0 =A0/* check if controller is ready to accept UIC commands=
 */
> =A0 =A0 =A0 =A0if (((readl(hba->mmio_base + REG_CONTROLLER_STATUS)) &
> =A0 =A0 =A0 =A0 =A0 =A0UIC_COMMAND_READY) =3D=3D 0x0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->dev,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"Controller not ready"
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0" to accept UIC comman=
ds\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EIO;
> @@ -912,7 +826,7 @@ static int ufshcd_make_hba_operational(struct ufs=
_hba *hba)
> =A0 =A0 =A0 =A0/* check if device present */
> =A0 =A0 =A0 =A0reg =3D readl((hba->mmio_base + REG_CONTROLLER_STATUS)=
);
> =A0 =A0 =A0 =A0if (!ufshcd_is_device_present(reg)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev, "cc: Device no=
t present\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->dev, "cc: Device not pres=
ent\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D -ENXIO;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
> @@ -924,7 +838,7 @@ static int ufshcd_make_hba_operational(struct ufs=
_hba *hba)
> =A0 =A0 =A0 =A0if (!(ufshcd_get_lists_status(reg))) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ufshcd_enable_run_stop_reg(hba);
> =A0 =A0 =A0 =A0} else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->dev,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"Host controller not r=
eady to process requests");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D -EIO;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> @@ -1005,7 +919,7 @@ static int ufshcd_hba_enable(struct ufs_hba *hba=
)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (retry) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0retry--;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->dev,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"Contr=
oller enable failed\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EIO;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -1015,37 +929,6 @@ static int ufshcd_hba_enable(struct ufs_hba *hb=
a)
> =A0}
>
> =A0/**
> - * ufshcd_initialize_hba - start the initialization process
> - * @hba: per adapter instance
> - *
> - * 1. Enable the controller via ufshcd_hba_enable.
> - * 2. Program the Transfer Request List Address with the starting ad=
dress of
> - * UTRDL.
> - * 3. Program the Task Management Request List Address with starting=
 address
> - * of UTMRDL.
> - *
> - * Returns 0 on success, non-zero value on failure.
> - */
> -static int ufshcd_initialize_hba(struct ufs_hba *hba)
> -{
> - =A0 =A0 =A0 if (ufshcd_hba_enable(hba))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> -
> - =A0 =A0 =A0 /* Configure UTRL and UTMRL base address registers */
> - =A0 =A0 =A0 writel(lower_32_bits(hba->utrdl_dma_addr),
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0(hba->mmio_base + REG_UTP_TRANSFER_REQ_L=
IST_BASE_L));
> - =A0 =A0 =A0 writel(upper_32_bits(hba->utrdl_dma_addr),
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0(hba->mmio_base + REG_UTP_TRANSFER_REQ_L=
IST_BASE_H));
> - =A0 =A0 =A0 writel(lower_32_bits(hba->utmrdl_dma_addr),
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0(hba->mmio_base + REG_UTP_TASK_REQ_LIST_=
BASE_L));
> - =A0 =A0 =A0 writel(upper_32_bits(hba->utmrdl_dma_addr),
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0(hba->mmio_base + REG_UTP_TASK_REQ_LIST_=
BASE_H));
> -
> - =A0 =A0 =A0 /* Initialize unipro link startup procedure */
> - =A0 =A0 =A0 return ufshcd_dme_link_startup(hba);
> -}
> -
> -/**
> =A0* ufshcd_do_reset - reset the host controller
> =A0* @hba: per adapter instance
> =A0*
> @@ -1084,7 +967,7 @@ static int ufshcd_do_reset(struct ufs_hba *hba)
>
> =A0 =A0 =A0 =A0/* start the initialization process */
> =A0 =A0 =A0 =A0if (ufshcd_initialize_hba(hba)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->dev,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"Reset: Controller ini=
tialization failed\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return FAILED;
> =A0 =A0 =A0 =A0}
> @@ -1167,7 +1050,7 @@ static int ufshcd_task_req_compl(struct ufs_hba=
 *hba, u32 index)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0task_result =3D SUCCES=
S;
> =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0task_result =3D FAILED;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->dev,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"trc: Invalid ocs =3D =
%x\n", ocs_value);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0spin_unlock_irqrestore(hba->host->host_lock, flags);
> @@ -1281,7 +1164,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba,=
 struct ufshcd_lrb *lrbp)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* check if the returned transfer resp=
onse is valid */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0result =3D ufshcd_is_valid_req_rsp(lrb=
p->ucd_rsp_ptr);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (result) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->dev,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"Inval=
id response =3D %x\n", result);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -1310,7 +1193,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba,=
 struct ufshcd_lrb *lrbp)
> =A0 =A0 =A0 =A0case OCS_FATAL_ERROR:
> =A0 =A0 =A0 =A0default:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0result |=3D DID_ERROR << 16;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->dev,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"OCS error from controller =3D %x\n", =
ocs);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0} /* end of switch */
> @@ -1374,7 +1257,7 @@ static void ufshcd_uic_cc_handler (struct work_=
struct *work)
> =A0 =A0 =A0 =A0 =A0 =A0!(ufshcd_get_uic_cmd_result(hba))) {
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ufshcd_make_hba_operational(hba))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->dev,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"cc: h=
ba not operational state\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
> =A0 =A0 =A0 =A0}
> @@ -1509,7 +1392,7 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
> =A0 =A0 =A0 =A0free_slot =3D ufshcd_get_tm_free_slot(hba);
> =A0 =A0 =A0 =A0if (free_slot >=3D hba->nutmrs) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock_irqrestore(host->host_lock=
, flags);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev, "Task manageme=
nt queue full\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->dev, "Task management que=
ue full\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D FAILED;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
> @@ -1552,7 +1435,7 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 &hba->tm_condition) !=3D 0),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 60 * HZ);
> =A0 =A0 =A0 =A0if (!err) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->dev,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"Task management comma=
nd timed-out\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D FAILED;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> @@ -1688,23 +1571,46 @@ static struct scsi_host_template ufshcd_drive=
r_template =3D {
> =A0};
>
> =A0/**
> - * ufshcd_shutdown - main function to put the controller in reset st=
ate
> - * @pdev: pointer to PCI device handle
> + * ufshcd_initialize_hba - start the initialization process
> + * @hba: per adapter instance
> + *
> + * 1. Enable the controller via ufshcd_hba_enable.
> + * 2. Program the Transfer Request List Address with the starting ad=
dress of
> + * UTRDL.
> + * 3. Program the Task Management Request List Address with starting=
 address
> + * of UTMRDL.
> + *
> + * Returns 0 on success, non-zero value on failure.
> =A0*/
> -static void ufshcd_shutdown(struct pci_dev *pdev)
> +int ufshcd_initialize_hba(struct ufs_hba *hba)
> =A0{
> - =A0 =A0 =A0 ufshcd_hba_stop((struct ufs_hba *)pci_get_drvdata(pdev)=
);
> + =A0 =A0 =A0 if (ufshcd_hba_enable(hba))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
It'd be better to propogate the error returned by ufshcd_hba_enable ?

> +
> + =A0 =A0 =A0 /* Configure UTRL and UTMRL base address registers */
> + =A0 =A0 =A0 writel(hba->utrdl_dma_addr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(hba->mmio_base + REG_UTP_TRANSFER_REQ_L=
IST_BASE_L));
> + =A0 =A0 =A0 writel(lower_32_bits(hba->utrdl_dma_addr),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(hba->mmio_base + REG_UTP_TRANSFER_REQ_L=
IST_BASE_H));
> + =A0 =A0 =A0 writel(hba->utmrdl_dma_addr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(hba->mmio_base + REG_UTP_TASK_REQ_LIST_=
BASE_L));
> + =A0 =A0 =A0 writel(upper_32_bits(hba->utmrdl_dma_addr),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(hba->mmio_base + REG_UTP_TASK_REQ_LIST_=
BASE_H));
> +
> + =A0 =A0 =A0 /* Initialize unipro link startup procedure */
> + =A0 =A0 =A0 return ufshcd_dme_link_startup(hba);
> =A0}
> +EXPORT_SYMBOL(ufshcd_initialize_hba);
>
> =A0#ifdef CONFIG_PM
> =A0/**
> =A0* ufshcd_suspend - suspend power management function
> - * @pdev: pointer to PCI device handle
> + * @hba: pointer to host controller platform data
> =A0* @state: power state
> =A0*
> =A0* Returns -ENOSYS
> =A0*/
> -static int ufshcd_suspend(struct pci_dev *pdev, pm_message_t state)
> +int ufshcd_suspend(struct ufs_hba *hba)
> =A0{
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * TODO:
> @@ -1717,14 +1623,15 @@ static int ufshcd_suspend(struct pci_dev *pde=
v, pm_message_t state)
>
> =A0 =A0 =A0 =A0return -ENOSYS;
> =A0}
> +EXPORT_SYMBOL(ufshcd_suspend);
>
> =A0/**
> =A0* ufshcd_resume - resume power management function
> - * @pdev: pointer to PCI device handle
> + * @hba: pointer to host controller platform data
> =A0*
> =A0* Returns -ENOSYS
> =A0*/
> -static int ufshcd_resume(struct pci_dev *pdev)
> +int ufshcd_resume(struct ufs_hba *hba)
> =A0{
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * TODO:
> @@ -1737,119 +1644,55 @@ static int ufshcd_resume(struct pci_dev *pde=
v)
>
> =A0 =A0 =A0 =A0return -ENOSYS;
> =A0}
> -#endif /* CONFIG_PM */
> +EXPORT_SYMBOL(ufshcd_resume);
>
> -/**
> - * ufshcd_hba_free - free allocated memory for
> - * =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 host memory space data st=
ructures
> - * @hba: per adapter instance
> - */
> -static void ufshcd_hba_free(struct ufs_hba *hba)
> -{
> - =A0 =A0 =A0 iounmap(hba->mmio_base);
> - =A0 =A0 =A0 ufshcd_free_hba_memory(hba);
> - =A0 =A0 =A0 pci_release_regions(hba->pdev);
> -}
> +#endif /* CONFIG_PM */
>
> =A0/**
> - * ufshcd_remove - de-allocate PCI/SCSI host and host memory space
> + * ufshcd_remove - de-allocate SCSI host and host memory space
> =A0* =A0 =A0 =A0 =A0 =A0 =A0 data structure memory
> - * @pdev - pointer to PCI handle
> + * @dev - pointer to host platform data
> =A0*/
> -static void ufshcd_remove(struct pci_dev *pdev)
> +void ufshcd_remove(struct ufs_hba *hba)
> =A0{
> - =A0 =A0 =A0 struct ufs_hba *hba =3D pci_get_drvdata(pdev);
> -
> =A0 =A0 =A0 =A0/* disable interrupts */
> =A0 =A0 =A0 =A0ufshcd_int_config(hba, UFSHCD_INT_DISABLE);
> - =A0 =A0 =A0 free_irq(pdev->irq, hba);
> + =A0 =A0 =A0 free_irq(hba->irq, hba);
>
> =A0 =A0 =A0 =A0ufshcd_hba_stop(hba);
> - =A0 =A0 =A0 ufshcd_hba_free(hba);
> + =A0 =A0 =A0 ufshcd_free_hba_memory(hba);
>
> =A0 =A0 =A0 =A0scsi_remove_host(hba->host);
> =A0 =A0 =A0 =A0scsi_host_put(hba->host);
> - =A0 =A0 =A0 pci_set_drvdata(pdev, NULL);
> - =A0 =A0 =A0 pci_clear_master(pdev);
> - =A0 =A0 =A0 pci_disable_device(pdev);
> -}
> -
> -/**
> - * ufshcd_set_dma_mask - Set dma mask based on the controller
> - * =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0addressing capability
> - * @pdev: PCI device structure
> - *
> - * Returns 0 for success, non-zero for failure
> - */
> -static int ufshcd_set_dma_mask(struct ufs_hba *hba)
> -{
> - =A0 =A0 =A0 int err;
> - =A0 =A0 =A0 u64 dma_mask;
> -
> - =A0 =A0 =A0 /*
> - =A0 =A0 =A0 =A0* If controller supports 64 bit addressing mode, the=
n set the DMA
> - =A0 =A0 =A0 =A0* mask to 64-bit, else set the DMA mask to 32-bit
> - =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 if (hba->capabilities & MASK_64_ADDRESSING_SUPPORT)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_mask =3D DMA_BIT_MASK(64);
> - =A0 =A0 =A0 else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_mask =3D DMA_BIT_MASK(32);
> -
> - =A0 =A0 =A0 err =3D pci_set_dma_mask(hba->pdev, dma_mask);
> - =A0 =A0 =A0 if (err)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return err;
> -
> - =A0 =A0 =A0 err =3D pci_set_consistent_dma_mask(hba->pdev, dma_mask=
);
> -
> - =A0 =A0 =A0 return err;
> =A0}
> +EXPORT_SYMBOL(ufshcd_remove);
>
> =A0/**
> - * ufshcd_probe - probe routine of the driver
> - * @pdev: pointer to PCI device handle
> - * @id: PCI device id
> + * ufshcd_probe - generic probe routine of the driver
> + * @hba: pointer to platform data
> =A0*
> =A0* Returns 0 on success, non-zero value on failure
> =A0*/
> -static int __devinit
> -ufshcd_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +int ufshcd_probe(struct ufs_hba **hostdata, struct device *dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int irq_no, void __iomem *mmio_base)
> =A0{
> =A0 =A0 =A0 =A0struct Scsi_Host *host;
> - =A0 =A0 =A0 struct ufs_hba *hba;
> =A0 =A0 =A0 =A0int err;
> -
> - =A0 =A0 =A0 err =3D pci_enable_device(pdev);
> - =A0 =A0 =A0 if (err) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "pci_enable_device =
failed\n");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_error;
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 pci_set_master(pdev);
> + =A0 =A0 =A0 struct ufs_hba *hba;
>
> =A0 =A0 =A0 =A0host =3D scsi_host_alloc(&ufshcd_driver_template,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof=
(struct ufs_hba));
> =A0 =A0 =A0 =A0if (!host) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "scsi_host_alloc fa=
iled\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->dev, "scsi_host_alloc fai=
led\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D -ENOMEM;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_disable;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0hba =3D shost_priv(host);
> -
> - =A0 =A0 =A0 err =3D pci_request_regions(pdev, UFSHCD);
> - =A0 =A0 =A0 if (err < 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "request regions fa=
iled\n");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_disable;
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 hba->mmio_base =3D pci_ioremap_bar(pdev, 0);
> - =A0 =A0 =A0 if (!hba->mmio_base) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "memory map failed\=
n");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -ENOMEM;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_release_regions;
> - =A0 =A0 =A0 }
> -
> + =A0 =A0 =A0 hba->dev =3D *dev;
> =A0 =A0 =A0 =A0hba->host =3D host;
> - =A0 =A0 =A0 hba->pdev =3D pdev;
> + =A0 =A0 =A0 hba->irq =3D irq_no;
> + =A0 =A0 =A0 hba->mmio_base =3D mmio_base;
> + =A0 =A0 =A0 *hostdata =3D hba;
>
> =A0 =A0 =A0 =A0/* Read capabilities registers */
> =A0 =A0 =A0 =A0ufshcd_hba_capabilities(hba);
> @@ -1857,17 +1700,11 @@ ufshcd_probe(struct pci_dev *pdev, const stru=
ct pci_device_id *id)
> =A0 =A0 =A0 =A0/* Get UFS version supported by the controller */
> =A0 =A0 =A0 =A0hba->ufs_version =3D ufshcd_get_ufs_version(hba);
>
> - =A0 =A0 =A0 err =3D ufshcd_set_dma_mask(hba);
> - =A0 =A0 =A0 if (err) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "set dma mask faile=
d\n");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_iounmap;
> - =A0 =A0 =A0 }
> -
> =A0 =A0 =A0 =A0/* Allocate memory for host memory space */
> =A0 =A0 =A0 =A0err =3D ufshcd_memory_alloc(hba);
> =A0 =A0 =A0 =A0if (err) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "Memory allocation =
failed\n");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_iounmap;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->dev, "Memory allocation f=
ailed\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_disable;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0/* Configure LRB */
> @@ -1889,72 +1726,59 @@ ufshcd_probe(struct pci_dev *pdev, const stru=
ct pci_device_id *id)
> =A0 =A0 =A0 =A0INIT_WORK(&hba->feh_workq, ufshcd_fatal_err_handler);
>
> =A0 =A0 =A0 =A0/* IRQ registration */
> - =A0 =A0 =A0 err =3D request_irq(pdev->irq, ufshcd_intr, IRQF_SHARED=
, UFSHCD, hba);
> + =A0 =A0 =A0 err =3D request_irq(hba->irq, ufshcd_intr, IRQF_SHARED,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ufs_hostname(hba), =
hba);
> =A0 =A0 =A0 =A0if (err) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "request irq failed=
\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->dev, "request irq failed\=
n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_lrb_free;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0/* Enable SCSI tag mapping */
> =A0 =A0 =A0 =A0err =3D scsi_init_shared_tag_map(host, host->can_queue=
);
> =A0 =A0 =A0 =A0if (err) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "init shared queue =
failed\n");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_free_irq;
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 pci_set_drvdata(pdev, hba);
> -
> - =A0 =A0 =A0 err =3D scsi_add_host(host, &pdev->dev);
> - =A0 =A0 =A0 if (err) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "scsi_add_host fail=
ed\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->dev, "init shared queue f=
ailed\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_free_irq;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 /* Initialization routine */
> - =A0 =A0 =A0 err =3D ufshcd_initialize_hba(hba);
> + =A0 =A0 =A0 err =3D scsi_add_host(host, &hba->dev);
> =A0 =A0 =A0 =A0if (err) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "Initialization fai=
led\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->dev, "scsi_add_host faile=
d\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_free_irq;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0return 0;
>
> =A0out_free_irq:
> - =A0 =A0 =A0 free_irq(pdev->irq, hba);
> + =A0 =A0 =A0 free_irq(hba->irq, hba);
> =A0out_lrb_free:
> =A0 =A0 =A0 =A0ufshcd_free_hba_memory(hba);
> -out_iounmap:
> - =A0 =A0 =A0 iounmap(hba->mmio_base);
> -out_release_regions:
> - =A0 =A0 =A0 pci_release_regions(pdev);
> =A0out_disable:
> =A0 =A0 =A0 =A0scsi_host_put(host);
> - =A0 =A0 =A0 pci_clear_master(pdev);
> - =A0 =A0 =A0 pci_disable_device(pdev);
> -out_error:
> =A0 =A0 =A0 =A0return err;
> =A0}
> +EXPORT_SYMBOL(ufshcd_probe);
>
> -static DEFINE_PCI_DEVICE_TABLE(ufshcd_pci_tbl) =3D {
> - =A0 =A0 =A0 { PCI_VENDOR_ID_SAMSUNG, 0xC00C, PCI_ANY_ID, PCI_ANY_ID=
, 0, 0, 0 },
> - =A0 =A0 =A0 { } =A0 =A0 /* terminate list */
> -};
> +/*******************************************************************=
**********\
> + * =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 *
> + * Driver init/exit =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*
> + * =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 *
> +\*******************************************************************=
**********/
>
> -MODULE_DEVICE_TABLE(pci, ufshcd_pci_tbl);
> +static int __init ufshcd_drv_init(void)
> +{
> + =A0 =A0 =A0 pr_info(UFSHCD
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ": Generic UFS host controller driver\n=
");
> + =A0 =A0 =A0 pr_info(UFSHCD ": Copyright(c) Samsung India Software O=
perations\n");
>
> -static struct pci_driver ufshcd_pci_driver =3D {
> - =A0 =A0 =A0 .name =3D UFSHCD,
> - =A0 =A0 =A0 .id_table =3D ufshcd_pci_tbl,
> - =A0 =A0 =A0 .probe =3D ufshcd_probe,
> - =A0 =A0 =A0 .remove =3D __devexit_p(ufshcd_remove),
> - =A0 =A0 =A0 .shutdown =3D ufshcd_shutdown,
> -#ifdef CONFIG_PM
> - =A0 =A0 =A0 .suspend =3D ufshcd_suspend,
> - =A0 =A0 =A0 .resume =3D ufshcd_resume,
> -#endif
> -};
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static void __exit ufshcd_drv_exit(void)
> +{
> +}
>
> -module_pci_driver(ufshcd_pci_driver);
> +module_init(ufshcd_drv_init);
> +module_exit(ufshcd_drv_exit);
There doesn't allow the core ufshcd to be inserted and removed as a
module, the actual probe and remove functions aren't annotated
properly like a true driver.

You can see the example of dwc3 driver in USB which does a thorough spl=
it..
(drivers/usb/dwc3/core.c and drivers/usb/dwc3/dwc3-pci.c)

>
> =A0MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>, "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0"Vinayak Holikatti <h.vinayak@samsung.com>=
");
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
