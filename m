From: li jianyun <jianyunff@gmail.com>
Subject: Re: [PATCH v3] Add Marvell UMI driver
Date: Tue, 14 Jun 2011 10:33:48 +0800
Message-ID: <BANLkTinnsp2erLDOOFrijEb+WP8krnGUTg@mail.gmail.com>
References: <Message-Id> <1305127368-1943-1-git-send-email-jianyunff@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45043 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab1FNCeR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2011 22:34:17 -0400
In-Reply-To: <1305127368-1943-1-git-send-email-jianyunff@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: Jianyun Li <jyli@marvell.com>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

Hi all
any comment or suggesting for this patch?


2011/5/11  <jianyunff@gmail.com>:
> From: Jianyun Li <jyli@marvell.com>
>
> =A0 =A0 =A0 =A0The Marvell Universal Message Interface (UMI) defines =
a messaging
> interface between host and Marvell products (Plato, for example). It
> considers situations of limited system resource and optimized system
> performance.
> =A0 =A0 =A0 =A0UMI driver translates host request to message and send=
s message
> to FW via UMI, FW receives message and processes it, then sends respo=
nse
> to UMI driver.
> =A0 =A0 =A0 =A0FW generates an interrupt when it needs to send inform=
ation or
> response to UMI driver
>
> Signed-off-by: Jianyun Li <jyli@marvell.com>
> ---
> =A0drivers/scsi/Kconfig =A0| =A0 =A09 +
> =A0drivers/scsi/Makefile | =A0 =A01 +
> =A0drivers/scsi/mvumi.c =A0| 2018 +++++++++++++++++++++++++++++++++++=
++++++++++++++
> =A0drivers/scsi/mvumi.h =A0| =A0505 ++++++++++++
> =A04 files changed, 2533 insertions(+), 0 deletions(-)
> =A0create mode 100644 drivers/scsi/mvumi.c
> =A0create mode 100644 drivers/scsi/mvumi.h
>
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 4a1f029..181ea6c 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -559,6 +559,15 @@ source "drivers/scsi/aic7xxx/Kconfig.aic79xx"
> =A0source "drivers/scsi/aic94xx/Kconfig"
> =A0source "drivers/scsi/mvsas/Kconfig"
>
> +config SCSI_MVUMI
> + =A0 =A0 =A0 tristate "Marvell UMI driver"
> + =A0 =A0 =A0 depends on SCSI && PCI
> + =A0 =A0 =A0 help
> + =A0 =A0 =A0 =A0 Module for Marvell Universal Message Interface(UMI)=
 driver
> +
> + =A0 =A0 =A0 =A0 To compile this driver as a module, choose M here: =
the
> + =A0 =A0 =A0 =A0 module will be called mvumi.
> +
> =A0config SCSI_DPT_I2O
> =A0 =A0 =A0 =A0tristate "Adaptec I2O RAID support "
> =A0 =A0 =A0 =A0depends on SCSI && PCI && VIRT_TO_BUS
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index 7ad0b8a..bce1609 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -133,6 +133,7 @@ obj-$(CONFIG_SCSI_IBMVFC) =A0 +=3D ibmvscsi/
> =A0obj-$(CONFIG_SCSI_HPTIOP) =A0 =A0 =A0+=3D hptiop.o
> =A0obj-$(CONFIG_SCSI_STEX) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0+=3D stex.o
> =A0obj-$(CONFIG_SCSI_MVSAS) =A0 =A0 =A0 +=3D mvsas/
> +obj-$(CONFIG_SCSI_MVUMI) =A0 =A0 =A0 +=3D mvumi.o
> =A0obj-$(CONFIG_PS3_ROM) =A0 =A0 =A0 =A0 =A0+=3D ps3rom.o
> =A0obj-$(CONFIG_SCSI_CXGB3_ISCSI) +=3D libiscsi.o libiscsi_tcp.o cxgb=
i/
> =A0obj-$(CONFIG_SCSI_CXGB4_ISCSI) +=3D libiscsi.o libiscsi_tcp.o cxgb=
i/
> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> new file mode 100644
> index 0000000..88cf1db
> --- /dev/null
> +++ b/drivers/scsi/mvumi.c
> @@ -0,0 +1,2018 @@
> +/*
> + * Marvell UMI driver
> + *
> + * Copyright 2011 Marvell. <jyli@marvell.com>
> + *
> + * This file is licensed under GPLv2.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; version 2 of the
> + * License.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. =A0See the G=
NU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-13=
07
> + * USA
> +*/
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/init.h>
> +#include <linux/device.h>
> +#include <linux/pci.h>
> +#include <linux/list.h>
> +#include <linux/spinlock.h>
> +#include <linux/interrupt.h>
> +#include <linux/delay.h>
> +#include <linux/blkdev.h>
> +#include <linux/io.h>
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_host.h>
> +#include <scsi/scsi_transport.h>
> +#include <scsi/scsi_eh.h>
> +#include <linux/uaccess.h>
> +
> +#include "mvumi.h"
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("jyli@marvell.com");
> +MODULE_DESCRIPTION("Marvell UMI Driver");
> +
> +static DEFINE_PCI_DEVICE_TABLE(mvumi_pci_table) =3D {
> + =A0 =A0 =A0 { PCI_DEVICE(PCI_VENDOR_ID_MARVELL_2, PCI_DEVICE_ID_MAR=
VELL_MV9143) },
> + =A0 =A0 =A0 { 0 }
> +};
> +
> +MODULE_DEVICE_TABLE(pci, mvumi_pci_table);
> +
> +static void tag_init(struct mvumi_tag *st, unsigned short size)
> +{
> + =A0 =A0 =A0 unsigned short i;
> + =A0 =A0 =A0 BUG_ON(size !=3D st->size);
> + =A0 =A0 =A0 st->top =3D size;
> + =A0 =A0 =A0 for (i =3D 0; i < size; i++)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 st->stack[i] =3D size - 1 - i;
> +}
> +
> +static unsigned short tag_get_one(struct mvumi_hba *mhba, struct mvu=
mi_tag *st)
> +{
> + =A0 =A0 =A0 BUG_ON(st->top <=3D 0);
> + =A0 =A0 =A0 return st->stack[--st->top];
> +}
> +
> +static void tag_release_one(struct mvumi_hba *mhba, struct mvumi_tag=
 *st,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned short tag)
> +{
> + =A0 =A0 =A0 BUG_ON(st->top >=3D st->size);
> + =A0 =A0 =A0 st->stack[st->top++] =3D tag;
> +}
> +
> +static bool tag_is_empty(struct mvumi_tag *st)
> +{
> + =A0 =A0 =A0 if (st->top =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> +}
> +
> +static void mvumi_unmap_pci_addr(struct pci_dev *dev, void **addr_ar=
ray)
> +{
> + =A0 =A0 =A0 int i;
> +
> + =A0 =A0 =A0 for (i =3D 0; i < MAX_BASE_ADDRESS; i++)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((pci_resource_flags(dev, i) & IORES=
OURCE_MEM) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 addr_array[i])
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pci_iounmap(dev, addr_a=
rray[i]);
> +}
> +
> +static int mvumi_map_pci_addr(struct pci_dev *dev, void **addr_array=
)
> +{
> + =A0 =A0 =A0 int i;
> +
> + =A0 =A0 =A0 for (i =3D 0; i < MAX_BASE_ADDRESS; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pci_resource_flags(dev, i) & IORESO=
URCE_MEM) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 addr_array[i] =3D pci_i=
omap(dev, i, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!addr_array[i]) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err=
(&dev->dev, "failed to map Bar[%d]\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 i);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvumi_u=
nmap_pci_addr(dev, addr_array);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
-ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 addr_array[i] =3D NULL;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_dbg(&dev->dev, "Bar %d : %p.\n", i,=
 addr_array[i]);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static struct mvumi_res *mvumi_alloc_mem_resource(struct mvumi_hba *=
mhba,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 enum re=
source_type type, unsigned int size)
> +{
> + =A0 =A0 =A0 struct mvumi_res *res =3D kzalloc(sizeof(*res), GFP_KER=
NEL);
> +
> + =A0 =A0 =A0 if (!res) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Failed to allocate mem=
ory for resouce manager.\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 switch (type) {
> + =A0 =A0 =A0 case RESOURCE_CACHED_MEMORY:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 res->virt_addr =3D kzalloc(size, GFP_KE=
RNEL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!res->virt_addr) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->de=
v,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "unable=
 to allocate memory,size =3D %d.\n", size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(res);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> +
> + =A0 =A0 =A0 case RESOURCE_UNCACHED_MEMORY:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 size =3D round_up(size, 8);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 res->virt_addr =3D pci_alloc_consistent=
(mhba->pdev, size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &res->bus_addr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!res->virt_addr) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->de=
v,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 "unable to allocate consistent mem,"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "size =3D %d.\n", size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(res);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(res->virt_addr, 0, size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> +
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->dev, "unknown reso=
urce type %d.\n", type);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(res);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 res->type =3D type;
> + =A0 =A0 =A0 res->size =3D size;
> + =A0 =A0 =A0 INIT_LIST_HEAD(&res->entry);
> + =A0 =A0 =A0 list_add_tail(&res->entry, &mhba->res_list);
> +
> + =A0 =A0 =A0 return res;
> +}
> +
> +static void mvumi_release_mem_resource(struct mvumi_hba *mhba)
> +{
> + =A0 =A0 =A0 struct mvumi_res *res, *tmp;
> +
> + =A0 =A0 =A0 list_for_each_entry_safe(res, tmp, &mhba->res_list, ent=
ry) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (res->type) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case RESOURCE_UNCACHED_MEMORY:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pci_free_consistent(mhb=
a->pdev, res->size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 res->virt_addr, res->bus_addr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case RESOURCE_CACHED_MEMORY:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(res->virt_addr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->de=
v,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "unknow=
n resource type %d\n", res->type);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del(&res->entry);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(res);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 mhba->fw_flag &=3D ~MVUMI_FW_ALLOC;
> +}
> +
> +/**
> + * mvumi_make_sgl - =A0 =A0Prepares =A0SGL
> + * @mhba: =A0 =A0 =A0 =A0 =A0 =A0 =A0Adapter soft state
> + * @scmd: =A0 =A0 =A0 =A0 =A0 =A0 =A0SCSI command from the mid-layer
> + * @sgl_p: =A0 =A0 =A0 =A0 =A0 =A0 SGL to be filled in
> + * @sg_count =A0 =A0 =A0 =A0 =A0 return the number of SG elements
> + *
> + * If successful, this function returns 0. otherwise, it returns -1.
> + */
> +static int mvumi_make_sgl(struct mvumi_hba *mhba, struct scsi_cmnd *=
scmd,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 void *sgl_p, unsigned char *sg_count)
> +{
> + =A0 =A0 =A0 struct scatterlist *sg;
> + =A0 =A0 =A0 struct mvumi_sgl *m_sg =3D (struct mvumi_sgl *) sgl_p;
> + =A0 =A0 =A0 unsigned int i;
> + =A0 =A0 =A0 unsigned int sgnum =3D scsi_sg_count(scmd);
> + =A0 =A0 =A0 dma_addr_t busaddr;
> +
> + =A0 =A0 =A0 if (sgnum) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sg =3D scsi_sglist(scmd);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *sg_count =3D pci_map_sg(mhba->pdev, sg=
, sgnum,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (int) s=
cmd->sc_data_direction);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (*sg_count > mhba->max_sge) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->de=
v, "sg count[0x%x] is bigger "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 "than max sg[0x%x].\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 *sg_count, mhba->max_sge);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < *sg_count; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 busaddr =3D sg_dma_addr=
ess(&sg[i]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 m_sg->baseaddr_l =3D cp=
u_to_le32(lower_32_bits(busaddr));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 m_sg->baseaddr_h =3D cp=
u_to_le32(upper_32_bits(busaddr));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 m_sg->flags =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 m_sg->size =3D cpu_to_l=
e32(sg_dma_len(&sg[i]));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((i + 1) =3D=3D *sg_=
count)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 m_sg->f=
lags |=3D SGD_EOT;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 m_sg++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 scmd->SCp.dma_handle =3D scsi_bufflen(s=
cmd) ?
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pci_map_single(mhba->pd=
ev, scsi_sglist(scmd),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 scsi_bu=
fflen(scmd),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (int) s=
cmd->sc_data_direction)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 busaddr =3D scmd->SCp.dma_handle;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 m_sg->baseaddr_l =3D cpu_to_le32(lower_=
32_bits(busaddr));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 m_sg->baseaddr_h =3D cpu_to_le32(upper_=
32_bits(busaddr));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 m_sg->flags =3D SGD_EOT;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 m_sg->size =3D cpu_to_le32(scsi_bufflen=
(scmd));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *sg_count =3D 1;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static int mvumi_internal_cmd_sgl(struct mvumi_hba *mhba, struct mvu=
mi_cmd *cmd,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int size)
> +{
> + =A0 =A0 =A0 struct mvumi_sgl *m_sg;
> + =A0 =A0 =A0 void *virt_addr;
> + =A0 =A0 =A0 dma_addr_t phy_addr;
> +
> + =A0 =A0 =A0 if (size =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> +
> + =A0 =A0 =A0 virt_addr =3D pci_alloc_consistent(mhba->pdev, size, &p=
hy_addr);
> + =A0 =A0 =A0 if (!virt_addr)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> +
> + =A0 =A0 =A0 memset(virt_addr, 0, size);
> +
> + =A0 =A0 =A0 m_sg =3D (struct mvumi_sgl *) &cmd->frame->payload[0];
> + =A0 =A0 =A0 cmd->frame->sg_counts =3D 1;
> + =A0 =A0 =A0 cmd->data_buf =3D virt_addr;
> +
> + =A0 =A0 =A0 m_sg->baseaddr_l =3D cpu_to_le32(lower_32_bits(phy_addr=
));
> + =A0 =A0 =A0 m_sg->baseaddr_h =3D cpu_to_le32(upper_32_bits(phy_addr=
));
> + =A0 =A0 =A0 m_sg->flags =3D SGD_EOT;
> + =A0 =A0 =A0 m_sg->size =3D cpu_to_le32(size);
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static struct mvumi_cmd *mvumi_create_internal_cmd(struct mvumi_hba =
*mhba,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigne=
d int buf_size)
> +{
> + =A0 =A0 =A0 struct mvumi_cmd *cmd;
> +
> + =A0 =A0 =A0 cmd =3D kzalloc(sizeof(*cmd), GFP_KERNEL);
> + =A0 =A0 =A0 if (!cmd) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->dev, "failed to cr=
eate a internal cmd\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 INIT_LIST_HEAD(&cmd->queue_pointer);
> +
> + =A0 =A0 =A0 cmd->frame =3D kzalloc(mhba->ib_max_size, GFP_KERNEL);
> + =A0 =A0 =A0 if (!cmd->frame) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->dev, "failed to al=
locate memory for FW"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 " frame,size =3D %d.\n"=
, mhba->ib_max_size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(cmd);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (buf_size) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mvumi_internal_cmd_sgl(mhba, cmd, b=
uf_size)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->de=
v, "failed to allocate memory"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 " for internal frame\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(cmd->frame);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(cmd);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 } else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cmd->frame->sg_counts =3D 0;
> +
> + =A0 =A0 =A0 return cmd;
> +}
> +
> +static void mvumi_delete_internal_cmd(struct mvumi_hba *mhba,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 struct mvumi_cmd *cmd)
> +{
> + =A0 =A0 =A0 struct mvumi_sgl *m_sg;
> + =A0 =A0 =A0 unsigned int size;
> + =A0 =A0 =A0 dma_addr_t phy_addr;
> +
> + =A0 =A0 =A0 if (cmd && cmd->frame) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cmd->frame->sg_counts) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 m_sg =3D (struct mvumi_=
sgl *) &cmd->frame->payload[0];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 size =3D m_sg->size;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 phy_addr =3D (dma_addr_=
t) m_sg->baseaddr_l |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (dma_ad=
dr_t) ((m_sg->baseaddr_h << 16) << 16);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pci_free_consistent(mhb=
a->pdev, size, cmd->data_buf,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 phy_addr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(cmd->frame);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(cmd);
> + =A0 =A0 =A0 }
> +}
> +
> +/**
> + * mvumi_get_cmd - =A0 =A0 Get a command from the free pool
> + * @mhba: =A0 =A0 =A0 =A0 =A0 =A0 =A0Adapter soft state
> + *
> + * Returns a free command from the pool
> + */
> +static struct mvumi_cmd *mvumi_get_cmd(struct mvumi_hba *mhba)
> +{
> + =A0 =A0 =A0 struct mvumi_cmd *cmd =3D NULL;
> +
> + =A0 =A0 =A0 if (likely(!list_empty(&mhba->cmd_pool))) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cmd =3D list_entry((&mhba->cmd_pool)->n=
ext,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct =
mvumi_cmd, queue_pointer);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del_init(&cmd->queue_pointer);
> + =A0 =A0 =A0 } else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_warn(&mhba->pdev->dev, "command poo=
l is empty!\n");
> +
> + =A0 =A0 =A0 return cmd;
> +}
> +
> +/**
> + * mvumi_return_cmd - =A0Return a cmd to free command pool
> + * @mhba: =A0 =A0 =A0 =A0 =A0 =A0 =A0Adapter soft state
> + * @cmd: =A0 =A0 =A0 =A0 =A0 =A0 =A0 Command packet to be returned t=
o free command pool
> + */
> +static inline void mvumi_return_cmd(struct mvumi_hba *mhba,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 struct mvumi_cmd *cmd)
> +{
> + =A0 =A0 =A0 cmd->scmd =3D NULL;
> + =A0 =A0 =A0 list_add_tail(&cmd->queue_pointer, &mhba->cmd_pool);
> +}
> +
> +/**
> + * mvumi_free_cmds - =A0 Free all the cmds in the free cmd pool
> + * @mhba: =A0 =A0 =A0 =A0 =A0 =A0 =A0Adapter soft state
> + */
> +static void mvumi_free_cmds(struct mvumi_hba *mhba)
> +{
> + =A0 =A0 =A0 struct mvumi_cmd *cmd;
> +
> + =A0 =A0 =A0 while (!list_empty(&mhba->cmd_pool)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cmd =3D list_first_entry(&mhba->cmd_poo=
l, struct mvumi_cmd,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 queue_pointer);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del(&cmd->queue_pointer);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(cmd->frame);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(cmd);
> + =A0 =A0 =A0 }
> +}
> +
> +/**
> + * mvumi_alloc_cmds - =A0Allocates the command packets
> + * @mhba: =A0 =A0 =A0 =A0 =A0 =A0 =A0Adapter soft state
> + *
> + */
> +static int mvumi_alloc_cmds(struct mvumi_hba *mhba)
> +{
> + =A0 =A0 =A0 int i;
> + =A0 =A0 =A0 struct mvumi_cmd *cmd;
> +
> + =A0 =A0 =A0 for (i =3D 0; i < mhba->max_io; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cmd =3D kzalloc(sizeof(*cmd), GFP_KERNE=
L);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!cmd)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_exit;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 INIT_LIST_HEAD(&cmd->queue_pointer);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_add_tail(&cmd->queue_pointer, &mhb=
a->cmd_pool);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cmd->frame =3D kzalloc(mhba->ib_max_siz=
e, GFP_KERNEL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!cmd->frame)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_exit;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return 0;
> +
> +err_exit:
> + =A0 =A0 =A0 dev_err(&mhba->pdev->dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "failed to allocate mem=
ory for cmd[0x%x].\n", i);
> + =A0 =A0 =A0 while (!list_empty(&mhba->cmd_pool)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cmd =3D list_first_entry(&mhba->cmd_poo=
l, struct mvumi_cmd,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 queue_pointer);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del(&cmd->queue_pointer);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(cmd->frame);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(cmd);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return -ENOMEM;
> +}
> +
> +static int mvumi_get_ib_list_entry(struct mvumi_hba *mhba, void **ib=
_entry)
> +{
> + =A0 =A0 =A0 unsigned int ib_rp_reg, cur_ib_entry;
> +
> + =A0 =A0 =A0 if (atomic_read(&mhba->fw_outstanding) >=3D mhba->max_i=
o) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_warn(&mhba->pdev->dev, "firmware io=
 overflow.\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 ib_rp_reg =3D ioread32(mhba->mmio + CLA_INB_READ_POINTE=
R);
> +
> + =A0 =A0 =A0 if (unlikely(((ib_rp_reg & CL_SLOT_NUM_MASK) =3D=3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (mhba->ib_cur_slot & CL=
_SLOT_NUM_MASK)) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((ib_rp_reg & CL_POINTE=
R_TOGGLE) !=3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (mhba->ib_cur_slot & CL=
_POINTER_TOGGLE)))) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_warn(&mhba->pdev->dev, "no free slo=
t to use.\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 cur_ib_entry =3D mhba->ib_cur_slot & CL_SLOT_NUM_MASK;
> + =A0 =A0 =A0 cur_ib_entry++;
> + =A0 =A0 =A0 if (cur_ib_entry >=3D mhba->list_num_io) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cur_ib_entry -=3D mhba->list_num_io;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->ib_cur_slot ^=3D CL_POINTER_TOGGL=
E;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 mhba->ib_cur_slot &=3D ~CL_SLOT_NUM_MASK;
> + =A0 =A0 =A0 mhba->ib_cur_slot |=3D (cur_ib_entry & CL_SLOT_NUM_MASK=
);
> + =A0 =A0 =A0 *ib_entry =3D mhba->ib_list + cur_ib_entry * mhba->ib_m=
ax_size;
> + =A0 =A0 =A0 atomic_inc(&mhba->fw_outstanding);
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static void mvumi_send_ib_list_entry(struct mvumi_hba *mhba)
> +{
> + =A0 =A0 =A0 iowrite32(0xfff, mhba->ib_shadow);
> + =A0 =A0 =A0 iowrite32(mhba->ib_cur_slot, mhba->mmio + CLA_INB_WRITE=
_POINTER);
> +}
> +
> +static char mvumi_check_ob_frame(struct mvumi_hba *mhba,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int cur_obf, struct mvumi_rsp_=
frame *p_outb_frame)
> +{
> + =A0 =A0 =A0 unsigned short tag, request_id;
> +
> + =A0 =A0 =A0 udelay(1);
> + =A0 =A0 =A0 p_outb_frame =3D mhba->ob_list + cur_obf * mhba->ob_max=
_size;
> + =A0 =A0 =A0 request_id =3D p_outb_frame->request_id;
> + =A0 =A0 =A0 tag =3D p_outb_frame->tag;
> + =A0 =A0 =A0 if (tag > mhba->tag_pool.size) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->dev, "ob frame dat=
a error\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (mhba->tag_cmd[tag] =3D=3D NULL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->dev, "tag[0x%x] wi=
th NO command\n", tag);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> + =A0 =A0 =A0 } else if (mhba->tag_cmd[tag]->request_id !=3D request_=
id &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 mhba->request_id_enabled) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->de=
v, "request ID from FW:0x%x,"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 "cmd request ID:0x%x\n", request_id,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 mhba->tag_cmd[tag]->request_id);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static void mvumi_receive_ob_list_entry(struct mvumi_hba *mhba)
> +{
> + =A0 =A0 =A0 unsigned int ob_write_reg, ob_write_shadow_reg;
> + =A0 =A0 =A0 unsigned int cur_obf, assign_obf_end, i;
> + =A0 =A0 =A0 struct mvumi_ob_data *ob_data;
> + =A0 =A0 =A0 struct mvumi_rsp_frame *p_outb_frame;
> +
> + =A0 =A0 =A0 do {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ob_write_reg =3D ioread32(mhba->mmio + =
CLA_OUTB_COPY_POINTER);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ob_write_shadow_reg =3D ioread32(mhba->=
ob_shadow);
> + =A0 =A0 =A0 } while ((ob_write_reg & CL_SLOT_NUM_MASK) !=3D ob_writ=
e_shadow_reg);
> +
> + =A0 =A0 =A0 cur_obf =3D mhba->ob_cur_slot & CL_SLOT_NUM_MASK;
> + =A0 =A0 =A0 assign_obf_end =3D ob_write_reg & CL_SLOT_NUM_MASK;
> +
> + =A0 =A0 =A0 if ((ob_write_reg & CL_POINTER_TOGGLE) !=3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (mhba->=
ob_cur_slot & CL_POINTER_TOGGLE)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 assign_obf_end +=3D mhba->list_num_io;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 for (i =3D (assign_obf_end - cur_obf); i !=3D 0; i--) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cur_obf++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cur_obf >=3D mhba->list_num_io) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cur_obf -=3D mhba->list=
_num_io;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->ob_cur_slot ^=3D =
CL_POINTER_TOGGLE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 p_outb_frame =3D mhba->ob_list + cur_ob=
f * mhba->ob_max_size;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Copy pointer may point to entry in o=
utbound list
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 * =A0before entry has valid data
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(p_outb_frame->tag > mhba->=
tag_pool.size ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->tag_cmd[p_outb_fr=
ame->tag] =3D=3D NULL ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 p_outb_frame->request_i=
d !=3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->t=
ag_cmd[p_outb_frame->tag]->request_id))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mvumi_check_ob_fram=
e(mhba, cur_obf, p_outb_frame))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continu=
e;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!list_empty(&mhba->ob_data_list)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ob_data =3D (struct mvu=
mi_ob_data *)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_fi=
rst_entry(&mhba->ob_data_list,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 struct mvumi_ob_data, list);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del_init(&ob_data-=
>list);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ob_data =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cur_obf =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cur_obf=
 =3D mhba->list_num_io - 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->o=
b_cur_slot ^=3D CL_POINTER_TOGGLE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cur_obf=
 -=3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ob_data->data, p_outb_frame, mhb=
a->ob_max_size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 p_outb_frame->tag =3D 0xff;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_add_tail(&ob_data->list, &mhba->fr=
ee_ob_list);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 mhba->ob_cur_slot &=3D ~CL_SLOT_NUM_MASK;
> + =A0 =A0 =A0 mhba->ob_cur_slot |=3D (cur_obf & CL_SLOT_NUM_MASK);
> + =A0 =A0 =A0 iowrite32(mhba->ob_cur_slot, mhba->mmio + CLA_OUTB_READ=
_POINTER);
> +}
> +
> +static void mvumi_reset(void *regs)
> +{
> + =A0 =A0 =A0 iowrite32(0, regs + CPU_ENPOINTA_MASK_REG);
> + =A0 =A0 =A0 if (ioread32(regs + CPU_ARM_TO_PCIEA_MSG1) !=3D HANDSHA=
KE_DONESTATE)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> +
> + =A0 =A0 =A0 iowrite32(DRBL_SOFT_RESET, regs + CPU_PCIEA_TO_ARM_DRBL=
_REG);
> +}
> +
> +static unsigned char mvumi_start(struct mvumi_hba *mhba);
> +
> +static int mvumi_wait_for_outstanding(struct mvumi_hba *mhba)
> +{
> + =A0 =A0 =A0 mhba->fw_state =3D FW_STATE_ABORT;
> + =A0 =A0 =A0 mvumi_reset(mhba->mmio);
> +
> + =A0 =A0 =A0 if (mvumi_start(mhba))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return FAILED;
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return SUCCESS;
> +}
> +
> +static int mvumi_host_reset(struct scsi_cmnd *scmd)
> +{
> + =A0 =A0 =A0 struct mvumi_hba *mhba;
> +
> + =A0 =A0 =A0 mhba =3D (struct mvumi_hba *) scmd->device->host->hostd=
ata;
> +
> + =A0 =A0 =A0 scmd_printk(KERN_NOTICE, scmd, "RESET -%ld cmd=3D%x ret=
ries=3D%x\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 scmd->serial_number, sc=
md->cmnd[0], scmd->retries);
> +
> + =A0 =A0 =A0 return mvumi_wait_for_outstanding(mhba);
> +}
> +
> +static int mvumi_issue_blocked_cmd(struct mvumi_hba *mhba,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 struct mvumi_cmd *cmd)
> +{
> + =A0 =A0 =A0 unsigned long flags;
> +
> + =A0 =A0 =A0 cmd->cmd_status =3D REQ_STATUS_PENDING;
> +
> + =A0 =A0 =A0 if (atomic_read(&cmd->sync_cmd)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "last blocked cmd not f=
inished, sync_cmd =3D %d\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 atomic_read(&cmd->sync_cmd));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 atomic_inc(&cmd->sync_cmd);
> + =A0 =A0 =A0 spin_lock_irqsave(mhba->shost->host_lock, flags);
> + =A0 =A0 =A0 mhba->instancet->fire_cmd(mhba, cmd);
> + =A0 =A0 =A0 spin_unlock_irqrestore(mhba->shost->host_lock, flags);
> +
> + =A0 =A0 =A0 wait_event_timeout(mhba->int_cmd_wait_q,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 (cmd->cmd_status !=3D REQ_STATUS_PENDIN=
G),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 MVUMI_INTERNAL_CMD_WAIT_TIME * HZ);
> +
> + =A0 =A0 =A0 /* command timeout */
> + =A0 =A0 =A0 if (atomic_read(&cmd->sync_cmd)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irqsave(mhba->shost->host_loc=
k, flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&cmd->sync_cmd);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mhba->tag_cmd[cmd->frame->tag]) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->tag_cmd[cmd->fram=
e->tag] =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_warn(&mhba->pdev->d=
ev, "TIMEOUT:release tag [%d]\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cmd->frame->tag);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tag_release_one(mhba, &=
mhba->tag_pool, cmd->frame->tag);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!list_empty(&cmd->queue_pointer)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_warn(&mhba->pdev->d=
ev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "TIMEOU=
T:A internal command doesn't send!\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del_init(&cmd->que=
ue_pointer);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&mhba->fw_ou=
tstanding);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(mhba->shost->hos=
t_lock, flags);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static void mvumi_release_fw(struct mvumi_hba *mhba)
> +{
> + =A0 =A0 =A0 mvumi_free_cmds(mhba);
> + =A0 =A0 =A0 mvumi_release_mem_resource(mhba);
> + =A0 =A0 =A0 mvumi_unmap_pci_addr(mhba->pdev, mhba->base_addr);
> + =A0 =A0 =A0 kfree(mhba->handshake_page);
> + =A0 =A0 =A0 pci_release_regions(mhba->pdev);
> +}
> +
> +static unsigned char mvumi_flush_cache(struct mvumi_hba *mhba)
> +{
> + =A0 =A0 =A0 struct mvumi_cmd *cmd;
> + =A0 =A0 =A0 struct mvumi_msg_frame *frame;
> + =A0 =A0 =A0 unsigned char device_id, retry =3D 0;
> + =A0 =A0 =A0 unsigned char bitcount =3D sizeof(unsigned char) * 8;
> +
> + =A0 =A0 =A0 for (device_id =3D 0; device_id < mhba->max_target_id; =
device_id++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!(mhba->target_map[device_id / bitc=
ount] &
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (1 << (=
device_id % bitcount))))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> +get_cmd: =A0 =A0 =A0 cmd =3D mvumi_create_internal_cmd(mhba, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!cmd) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (retry++ >=3D 5) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err=
(&mhba->pdev->dev, "failed to get memory"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 " for internal flush cache cmd for "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 "device %d", device_id);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 retry =3D=
 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continu=
e;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ge=
t_cmd;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cmd->scmd =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cmd->cmd_status =3D REQ_STATUS_PENDING;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_set(&cmd->sync_cmd, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 frame =3D cmd->frame;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 frame->req_function =3D CL_FUN_SCSI_CMD=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 frame->device_id =3D device_id;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 frame->cmd_flag =3D CMD_FLAG_NON_DATA;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 frame->data_transfer_length =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 frame->cdb_length =3D MAX_COMMAND_SIZE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(frame->cdb, 0, MAX_COMMAND_SIZE)=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 frame->cdb[0] =3D SCSI_CMD_MARVELL_SPEC=
IFIC;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 frame->cdb[2] =3D CDB_CORE_SHUTDOWN;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvumi_issue_blocked_cmd(mhba, cmd);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cmd->cmd_status !=3D SAM_STAT_GOOD)=
 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->de=
v,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "device=
 %d flush cache failed, status=3D0x%x.\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 device_=
id, cmd->cmd_status);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvumi_delete_internal_cmd(mhba, cmd);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static unsigned char
> +mvumi_calculate_checksum(struct mvumi_hs_header *p_header,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned short len)
> +{
> + =A0 =A0 =A0 unsigned char *ptr;
> + =A0 =A0 =A0 unsigned char ret =3D 0, i;
> +
> + =A0 =A0 =A0 ptr =3D (unsigned char *) p_header->frame_content;
> + =A0 =A0 =A0 for (i =3D 0; i < len; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret ^=3D *ptr;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ptr++;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return ret;
> +}
> +
> +void mvumi_hs_build_page(struct mvumi_hba *mhba,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct =
mvumi_hs_header *hs_header)
> +{
> + =A0 =A0 =A0 struct mvumi_hs_page2 *hs_page2;
> + =A0 =A0 =A0 struct mvumi_hs_page4 *hs_page4;
> + =A0 =A0 =A0 struct mvumi_hs_page3 *hs_page3;
> + =A0 =A0 =A0 struct timeval time;
> + =A0 =A0 =A0 unsigned int local_time;
> +
> + =A0 =A0 =A0 switch (hs_header->page_code) {
> + =A0 =A0 =A0 case HS_PAGE_HOST_INFO:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_page2 =3D (struct mvumi_hs_page2 *) =
hs_header;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_header->frame_length =3D sizeof(*hs_=
page2) - 4;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(hs_header->frame_content, 0, hs_=
header->frame_length);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_page2->host_type =3D 3; /* 3 mean li=
nux*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_page2->host_ver.ver_major =3D VER_MA=
JOR;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_page2->host_ver.ver_minor =3D VER_MI=
NOR;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_page2->host_ver.ver_oem =3D VER_OEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_page2->host_ver.ver_build =3D VER_BU=
ILD;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_page2->system_io_bus =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_page2->slot_number =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_page2->intr_level =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_page2->intr_vector =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 do_gettimeofday(&time);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 local_time =3D (unsigned int) (time.tv_=
sec -
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 (sys_tz.tz_minuteswest * 60));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_page2->seconds_since1970 =3D local_t=
ime;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_header->checksum =3D mvumi_calculate=
_checksum(hs_header,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 hs_header->frame_length);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> +
> + =A0 =A0 =A0 case HS_PAGE_FIRM_CTL:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_page3 =3D (struct mvumi_hs_page3 *) =
hs_header;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_header->frame_length =3D sizeof(*hs_=
page3) - 4;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(hs_header->frame_content, 0, hs_=
header->frame_length);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_header->checksum =3D mvumi_calculate=
_checksum(hs_header,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 hs_header->frame_length);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> +
> + =A0 =A0 =A0 case HS_PAGE_CL_INFO:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_page4 =3D (struct mvumi_hs_page4 *) =
hs_header;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_header->frame_length =3D sizeof(*hs_=
page4) - 4;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(hs_header->frame_content, 0, hs_=
header->frame_length);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_page4->ib_baseaddr_l =3D lower_32_bi=
ts(mhba->ib_list_phys);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_page4->ib_baseaddr_h =3D upper_32_bi=
ts(mhba->ib_list_phys);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_page4->ob_baseaddr_l =3D lower_32_bi=
ts(mhba->ob_list_phys);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_page4->ob_baseaddr_h =3D upper_32_bi=
ts(mhba->ob_list_phys);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_page4->ib_entry_size =3D mhba->ib_ma=
x_size_setting;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_page4->ob_entry_size =3D mhba->ob_ma=
x_size_setting;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_page4->ob_depth =3D mhba->list_num_i=
o;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_page4->ib_depth =3D mhba->list_num_i=
o;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_header->checksum =3D mvumi_calculate=
_checksum(hs_header,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 hs_header->frame_length);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> +
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->dev, "cannot build=
 page, code[0x%x]\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_header->page_code);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 }
> +}
> +
> +/**
> + * mvumi_init_data - =A0 Initialize requested date for FW
> + * @mhba: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Adapter soft st=
ate
> + */
> +static int mvumi_init_data(struct mvumi_hba *mhba)
> +{
> + =A0 =A0 =A0 struct mvumi_ob_data *ob_pool;
> + =A0 =A0 =A0 struct mvumi_res *res_mgnt;
> + =A0 =A0 =A0 unsigned int tmp_size, offset, i;
> + =A0 =A0 =A0 void *virmem, *v;
> + =A0 =A0 =A0 dma_addr_t p;
> +
> + =A0 =A0 =A0 if (mhba->fw_flag & MVUMI_FW_ALLOC)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> +
> + =A0 =A0 =A0 tmp_size =3D mhba->ib_max_size * mhba->max_io;
> + =A0 =A0 =A0 tmp_size +=3D 128 + mhba->ob_max_size * mhba->max_io;
> + =A0 =A0 =A0 tmp_size +=3D 8 + sizeof(u32) + 16;
> +
> + =A0 =A0 =A0 res_mgnt =3D mvumi_alloc_mem_resource(mhba,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 RESOURCE_UNCACHED_MEMORY, tmp_size);
> + =A0 =A0 =A0 if (!res_mgnt) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "failed to allocate mem=
ory for inbound list\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail_alloc_dma_buf;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 p =3D res_mgnt->bus_addr;
> + =A0 =A0 =A0 v =3D res_mgnt->virt_addr;
> + =A0 =A0 =A0 /* ib_list */
> + =A0 =A0 =A0 offset =3D round_up(p, 128) - p;
> + =A0 =A0 =A0 p +=3D offset;
> + =A0 =A0 =A0 v +=3D offset;
> + =A0 =A0 =A0 mhba->ib_list =3D v;
> + =A0 =A0 =A0 mhba->ib_list_phys =3D p;
> + =A0 =A0 =A0 v +=3D mhba->ib_max_size * mhba->max_io;
> + =A0 =A0 =A0 p +=3D mhba->ib_max_size * mhba->max_io;
> + =A0 =A0 =A0 /* ib shadow */
> + =A0 =A0 =A0 offset =3D round_up(p, 8) - p;
> + =A0 =A0 =A0 p +=3D offset;
> + =A0 =A0 =A0 v +=3D offset;
> + =A0 =A0 =A0 mhba->ib_shadow =3D v;
> + =A0 =A0 =A0 mhba->ib_shadow_phys =3D p;
> + =A0 =A0 =A0 p +=3D sizeof(u32);
> + =A0 =A0 =A0 v +=3D sizeof(u32);
> + =A0 =A0 =A0 /* ob shadow */
> + =A0 =A0 =A0 offset =3D round_up(p, 8) - p;
> + =A0 =A0 =A0 p +=3D offset;
> + =A0 =A0 =A0 v +=3D offset;
> + =A0 =A0 =A0 mhba->ob_shadow =3D v;
> + =A0 =A0 =A0 mhba->ob_shadow_phys =3D p;
> + =A0 =A0 =A0 p +=3D 8;
> + =A0 =A0 =A0 v +=3D 8;
> +
> + =A0 =A0 =A0 /* ob list */
> + =A0 =A0 =A0 offset =3D round_up(p, 128) - p;
> + =A0 =A0 =A0 p +=3D offset;
> + =A0 =A0 =A0 v +=3D offset;
> +
> + =A0 =A0 =A0 mhba->ob_list =3D v;
> + =A0 =A0 =A0 mhba->ob_list_phys =3D p;
> +
> + =A0 =A0 =A0 /* ob data pool */
> + =A0 =A0 =A0 tmp_size =3D mhba->max_io * (mhba->ob_max_size + sizeof=
(*ob_pool));
> + =A0 =A0 =A0 tmp_size =3D round_up(tmp_size, 8);
> +
> + =A0 =A0 =A0 res_mgnt =3D mvumi_alloc_mem_resource(mhba,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 RESOURC=
E_CACHED_MEMORY, tmp_size);
> + =A0 =A0 =A0 if (!res_mgnt) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "failed to allocate mem=
ory for outbound data buffer\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail_alloc_dma_buf;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 virmem =3D res_mgnt->virt_addr;
> +
> + =A0 =A0 =A0 for (i =3D mhba->max_io; i !=3D 0; i--) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ob_pool =3D (struct mvumi_ob_data *) vi=
rmem;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_add_tail(&ob_pool->list, &mhba->ob=
_data_list);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 virmem +=3D mhba->ob_max_size + sizeof(=
*ob_pool);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 tmp_size =3D sizeof(unsigned short) * mhba->max_io +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(=
struct mvumi_cmd *) * mhba->max_io;
> + =A0 =A0 =A0 tmp_size +=3D round_up(mhba->max_target_id, sizeof(unsi=
gned char) * 8) /
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 (sizeof(unsigned char) * 8);
> +
> + =A0 =A0 =A0 res_mgnt =3D mvumi_alloc_mem_resource(mhba,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 RESOURC=
E_CACHED_MEMORY, tmp_size);
> + =A0 =A0 =A0 if (!res_mgnt) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "failed to allocate mem=
ory for tag and target map\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail_alloc_dma_buf;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 virmem =3D res_mgnt->virt_addr;
> + =A0 =A0 =A0 mhba->tag_pool.stack =3D virmem;
> + =A0 =A0 =A0 mhba->tag_pool.size =3D mhba->max_io;
> + =A0 =A0 =A0 tag_init(&mhba->tag_pool, mhba->max_io);
> + =A0 =A0 =A0 virmem +=3D sizeof(unsigned short) * mhba->max_io;
> +
> + =A0 =A0 =A0 mhba->tag_cmd =3D virmem;
> + =A0 =A0 =A0 virmem +=3D sizeof(struct mvumi_cmd *) * mhba->max_io;
> +
> + =A0 =A0 =A0 mhba->target_map =3D virmem;
> +
> + =A0 =A0 =A0 mhba->fw_flag |=3D MVUMI_FW_ALLOC;
> + =A0 =A0 =A0 return 0;
> +
> +fail_alloc_dma_buf:
> + =A0 =A0 =A0 mvumi_release_mem_resource(mhba);
> + =A0 =A0 =A0 return -1;
> +}
> +
> +static int mvumi_hs_process_page(struct mvumi_hba *mhba,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct =
mvumi_hs_header *hs_header)
> +{
> + =A0 =A0 =A0 struct mvumi_hs_page1 *hs_page1;
> + =A0 =A0 =A0 unsigned char page_checksum;
> +
> + =A0 =A0 =A0 page_checksum =3D mvumi_calculate_checksum(hs_header,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 hs_header->frame_length);
> + =A0 =A0 =A0 if (page_checksum !=3D hs_header->checksum) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->dev, "checksum err=
or\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 switch (hs_header->page_code) {
> + =A0 =A0 =A0 case HS_PAGE_FIRM_CAP:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_page1 =3D (struct mvumi_hs_page1 *) =
hs_header;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->max_io =3D hs_page1->max_io_suppo=
rt;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->list_num_io =3D hs_page1->cl_inou=
t_list_depth;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->max_transfer_size =3D hs_page1->m=
ax_transfer_size;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->max_target_id =3D hs_page1->max_d=
evices_support;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->hba_capability =3D hs_page1->capa=
bility;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->ib_max_size_setting =3D hs_page1-=
>cl_in_max_entry_size;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->ib_max_size =3D (1 << hs_page1->c=
l_in_max_entry_size) << 2;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->ob_max_size_setting =3D hs_page1-=
>cl_out_max_entry_size;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->ob_max_size =3D (1 << hs_page1->c=
l_out_max_entry_size) << 2;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_dbg(&mhba->pdev->dev, "FW version:%=
d\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 hs_page1->fw_ver.ver_build);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->dev, "handshake: p=
age code error\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return 0;
> +}
> +
> +/**
> + * mvumi_handshake - =A0 Move the FW to READY state
> + * @mhba: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
Adapter soft state
> + *
> + * During the initialization, FW passes can potentially be in any on=
e of
> + * several possible states. If the FW in operational, waiting-for-ha=
ndshake
> + * states, driver must take steps to bring it to ready state. Otherw=
ise, it
> + * has to wait for the ready state.
> + */
> +static int mvumi_handshake(struct mvumi_hba *mhba)
> +{
> + =A0 =A0 =A0 unsigned int hs_state, tmp, hs_fun;
> + =A0 =A0 =A0 struct mvumi_hs_header *hs_header;
> + =A0 =A0 =A0 void *regs =3D mhba->mmio;
> +
> + =A0 =A0 =A0 if (mhba->fw_state =3D=3D FW_STATE_STARTING)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_state =3D HS_S_START;
> + =A0 =A0 =A0 else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tmp =3D ioread32(regs + CPU_ARM_TO_PCIE=
A_MSG0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_state =3D HS_GET_STATE(tmp);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_dbg(&mhba->pdev->dev, "handshake st=
ate[0x%x].\n", hs_state);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (HS_GET_STATUS(tmp) !=3D HS_STATUS_O=
K) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->fw_state =3D FW_S=
TATE_STARTING;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 hs_fun =3D 0;
> + =A0 =A0 =A0 switch (hs_state) {
> + =A0 =A0 =A0 case HS_S_START:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->fw_state =3D FW_STATE_HANDSHAKING=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 HS_SET_STATUS(hs_fun, HS_STATUS_OK);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 HS_SET_STATE(hs_fun, HS_S_RESET);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iowrite32(HANDSHAKE_SIGNATURE, regs + C=
PU_PCIEA_TO_ARM_MSG1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iowrite32(hs_fun, regs + CPU_PCIEA_TO_A=
RM_MSG0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iowrite32(DRBL_HANDSHAKE, regs + CPU_PC=
IEA_TO_ARM_DRBL_REG);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> +
> + =A0 =A0 =A0 case HS_S_RESET:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iowrite32(lower_32_bits(mhba->handshake=
_page_phys),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 regs + CPU_PCIEA_TO_ARM_MSG1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iowrite32(upper_32_bits(mhba->handshake=
_page_phys),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 regs + CPU_ARM_TO_PCIEA_MSG1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 HS_SET_STATUS(hs_fun, HS_STATUS_OK);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 HS_SET_STATE(hs_fun, HS_S_PAGE_ADDR);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iowrite32(hs_fun, regs + CPU_PCIEA_TO_A=
RM_MSG0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iowrite32(DRBL_HANDSHAKE, regs + CPU_PC=
IEA_TO_ARM_DRBL_REG);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> +
> + =A0 =A0 =A0 case HS_S_PAGE_ADDR:
> + =A0 =A0 =A0 case HS_S_QUERY_PAGE:
> + =A0 =A0 =A0 case HS_S_SEND_PAGE:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_header =3D (struct mvumi_hs_header *=
) mhba->handshake_page;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (hs_header->page_code =3D=3D HS_PAGE=
_FIRM_CAP) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->hba_total_pages =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((struct mvumi_hs_page1=
 *) hs_header)->total_pages;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mhba->hba_total_pag=
es =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->h=
ba_total_pages =3D HS_PAGE_TOTAL-1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (hs_state =3D=3D HS_S_QUERY_PAGE) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mvumi_hs_process_pa=
ge(mhba, hs_header)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 HS_SET_=
STATE(hs_fun, HS_S_ABORT);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
-1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mvumi_init_data(mhb=
a)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 HS_SET_=
STATE(hs_fun, HS_S_ABORT);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
-1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (hs_state =3D=3D HS_S_PAGE_AD=
DR) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_header->page_code =3D=
 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->hba_total_pages =3D=
 HS_PAGE_TOTAL-1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((hs_header->page_code + 1) <=3D mhb=
a->hba_total_pages) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_header->page_code++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (hs_header->page_cod=
e !=3D HS_PAGE_FIRM_CAP) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvumi_h=
s_build_page(mhba, hs_header);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 HS_SET_=
STATE(hs_fun, HS_S_SEND_PAGE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 HS_SET_=
STATE(hs_fun, HS_S_QUERY_PAGE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 HS_SET_STATE(hs_fun, HS=
_S_END);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 HS_SET_STATUS(hs_fun, HS_STATUS_OK);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iowrite32(hs_fun, regs + CPU_PCIEA_TO_A=
RM_MSG0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iowrite32(DRBL_HANDSHAKE, regs + CPU_PC=
IEA_TO_ARM_DRBL_REG);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> +
> + =A0 =A0 =A0 case HS_S_END:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Set communication list ISR */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tmp =3D ioread32(regs + CPU_ENPOINTA_MA=
SK_REG);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tmp |=3D INT_MAP_COMAOUT | INT_MAP_COMA=
ERR;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iowrite32(tmp, regs + CPU_ENPOINTA_MASK=
_REG);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iowrite32(mhba->list_num_io, mhba->ib_s=
hadow);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Set InBound List Avaliable count sha=
dow */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iowrite32(lower_32_bits(mhba->ib_shadow=
_phys),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 regs + CLA_INB_AVAL_COUNT_BASEL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iowrite32(upper_32_bits(mhba->ib_shadow=
_phys),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 regs + CLA_INB_AVAL_COUNT_BASEH);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Set OutBound List Avaliable count sh=
adow */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iowrite32((mhba->list_num_io-1) | CL_PO=
INTER_TOGGLE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 mhba->ob_shadow);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iowrite32(lower_32_bits(mhba->ob_shadow=
_phys), regs + 0x5B0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iowrite32(upper_32_bits(mhba->ob_shadow=
_phys), regs + 0x5B4);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->ib_cur_slot =3D (mhba->list_num_i=
o - 1) | CL_POINTER_TOGGLE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->ob_cur_slot =3D (mhba->list_num_i=
o - 1) | CL_POINTER_TOGGLE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->fw_state =3D FW_STATE_STARTED;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->dev, "unknown hand=
shake state [0x%x].\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hs_state);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static unsigned char mvumi_handshake_event(struct mvumi_hba *mhba)
> +{
> + =A0 =A0 =A0 unsigned int isr_status;
> + =A0 =A0 =A0 unsigned long before;
> +
> + =A0 =A0 =A0 before =3D jiffies;
> + =A0 =A0 =A0 mvumi_handshake(mhba);
> + =A0 =A0 =A0 do {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 isr_status =3D mhba->instancet->read_fw=
_status_reg(mhba->mmio);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mhba->fw_state =3D=3D FW_STATE_STAR=
TED)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (time_after(jiffies, before + FW_MAX=
_DELAY * HZ)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->de=
v,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "no han=
dshake response at state 0x%x.\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhb=
a->fw_state);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->de=
v,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "isr : =
global=3D0x%x,status=3D0x%x.\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 mhba->global_isr, isr_status);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rmb();
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 usleep_range(1000, 2000);
> + =A0 =A0 =A0 } while (!(isr_status & DRBL_HANDSHAKE_ISR));
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static unsigned char mvumi_check_handshake(struct mvumi_hba *mhba)
> +{
> + =A0 =A0 =A0 void *regs =3D mhba->mmio;
> + =A0 =A0 =A0 unsigned int tmp;
> + =A0 =A0 =A0 unsigned long before;
> +
> + =A0 =A0 =A0 before =3D jiffies;
> + =A0 =A0 =A0 tmp =3D ioread32(regs + CPU_ARM_TO_PCIEA_MSG1);
> + =A0 =A0 =A0 while ((tmp !=3D HANDSHAKE_READYSTATE) && (tmp !=3D HAN=
DSHAKE_DONESTATE)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (tmp !=3D HANDSHAKE_READYSTATE)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iowrite32(DRBL_MU_RESET=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 regs + CPU_PCIEA_TO_ARM_DRBL_REG);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (time_after(jiffies, before + FW_MAX=
_DELAY * HZ)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->de=
v,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "invali=
d signature [0x%x].\n", tmp);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 usleep_range(1000, 2000);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rmb();
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tmp =3D ioread32(regs + CPU_ARM_TO_PCIE=
A_MSG1);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 mhba->fw_state =3D FW_STATE_STARTING;
> + =A0 =A0 =A0 dev_dbg(&mhba->pdev->dev, "start firmware handshake...\=
n");
> + =A0 =A0 =A0 do {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mvumi_handshake_event(mhba)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->de=
v,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 "handshake failed at state 0x%x.\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 mhba->fw_state);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 } while (mhba->fw_state !=3D FW_STATE_STARTED);
> +
> + =A0 =A0 =A0 dev_dbg(&mhba->pdev->dev, "firmware handshake done\n");
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static unsigned char mvumi_start(struct mvumi_hba *mhba)
> +{
> + =A0 =A0 =A0 void *regs =3D mhba->mmio;
> + =A0 =A0 =A0 unsigned int tmp;
> + =A0 =A0 =A0 /* clear Door bell */
> + =A0 =A0 =A0 tmp =3D ioread32(regs + CPU_ARM_TO_PCIEA_DRBL_REG);
> + =A0 =A0 =A0 iowrite32(tmp, regs + CPU_ARM_TO_PCIEA_DRBL_REG);
> +
> + =A0 =A0 =A0 iowrite32(0x3FFFFFFF, regs + CPU_ARM_TO_PCIEA_MASK_REG)=
;
> + =A0 =A0 =A0 tmp =3D ioread32(regs + CPU_ENPOINTA_MASK_REG) | INT_MA=
P_DL_CPU2PCIEA;
> + =A0 =A0 =A0 iowrite32(tmp, regs + CPU_ENPOINTA_MASK_REG);
> + =A0 =A0 =A0 if (mvumi_check_handshake(mhba))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +/**
> + * mvumi_complete_cmd - =A0 =A0 =A0 =A0Completes a command
> + * @mhba: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Adapter soft st=
ate
> + * @cmd: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Command to be c=
ompleted
> + */
> +static void mvumi_complete_cmd(struct mvumi_hba *mhba, struct mvumi_=
cmd *cmd,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 struct mvumi_rsp_frame *ob_frame)
> +{
> + =A0 =A0 =A0 struct scsi_cmnd *scmd =3D cmd->scmd;
> +
> + =A0 =A0 =A0 cmd->scmd->SCp.ptr =3D NULL;
> + =A0 =A0 =A0 scmd->result =3D ob_frame->req_status;
> +
> + =A0 =A0 =A0 switch (ob_frame->req_status) {
> + =A0 =A0 =A0 case SAM_STAT_GOOD:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 scmd->result |=3D DID_OK << 16;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case SAM_STAT_BUSY:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 scmd->result |=3D DID_BUS_BUSY << 16;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case SAM_STAT_CHECK_CONDITION:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 scmd->result |=3D (DID_OK << 16);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ob_frame->rsp_flag & CL_RSP_FLAG_SE=
NSEDATA) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(cmd->scmd->sense=
_buffer, ob_frame->payload,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(=
struct mvumi_sense_data));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 scmd->result |=3D =A0(D=
RIVER_SENSE << 24);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 scmd->result |=3D (DRIVER_INVALID << 24=
) | (DID_ABORT << 16);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (scsi_bufflen(scmd)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (scsi_sg_count(scmd)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pci_unmap_sg(mhba->pdev=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 scsi_sg=
list(scmd),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 scsi_sg=
_count(scmd),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (int) s=
cmd->sc_data_direction);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pci_unmap_single(mhba->=
pdev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 scmd->S=
Cp.dma_handle,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 scsi_bu=
fflen(scmd),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (int) s=
cmd->sc_data_direction);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 scmd->SCp.dma_handle =3D=
 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 cmd->scmd->scsi_done(scmd);
> + =A0 =A0 =A0 mvumi_return_cmd(mhba, cmd);
> +}
> +static void mvumi_complete_internal_cmd(struct mvumi_hba *mhba,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 struct mvumi_cmd *cmd,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 struct mvumi_rsp_frame *ob_frame)
> +{
> + =A0 =A0 =A0 if (atomic_read(&cmd->sync_cmd)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cmd->cmd_status =3D ob_frame->req_statu=
s;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((ob_frame->req_status =3D=3D SAM_ST=
AT_CHECK_CONDITION) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (ob_fra=
me->rsp_flag & CL_RSP_FLAG_SENSEDATA) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cmd->da=
ta_buf) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(cmd->data_buf, o=
b_frame->payload,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 sizeof(struct mvumi_sense_data));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&cmd->sync_cmd);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&mhba->int_cmd_wait_q);
> + =A0 =A0 =A0 }
> +}
> +
> +static void mvumi_show_event(struct mvumi_hba *mhba,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct mvumi_driver_eve=
nt *ptr)
> +{
> + =A0 =A0 =A0 unsigned int i;
> +
> + =A0 =A0 =A0 dev_warn(&mhba->pdev->dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Event[0x%x] id[0x%x] severity[0x%x] de=
vice id[0x%x]\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ptr->sequence_no, ptr->event_id, ptr->s=
everity, ptr->device_id);
> + =A0 =A0 =A0 if (ptr->param_count) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_WARNING "Event param(len 0x=
%x): ",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 ptr->param_count);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < ptr->param_count; i++=
)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_WARNING "0x=
%x ", ptr->params[i]);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_WARNING "\n");
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (ptr->sense_data_length) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_WARNING "Event sense data(l=
en 0x%x): ",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 ptr->sense_data_length);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < ptr->sense_data_lengt=
h; i++)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_WARNING "0x=
%x ", ptr->sense_data[i]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_WARNING "\n");
> + =A0 =A0 =A0 }
> +}
> +
> +static void mvumi_notification(struct mvumi_hba *mhba, u8 msg, void =
*buffer)
> +{
> + =A0 =A0 =A0 if (msg =3D=3D APICDB1_EVENT_GETEVENT) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int i, count;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct mvumi_driver_event *param =3D NU=
LL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct mvumi_event_req *er =3D buffer;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 count =3D er->count;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (count > MAX_EVENTS_RETURNED) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->de=
v, "event count[0x%x] is bigger"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 " than max event count[0x%x].\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 count, MAX_EVENTS_RETURNED);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < count; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 param =3D &er->events[i=
];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvumi_show_event(mhba, =
param);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +}
> +
> +static int mvumi_get_event(struct mvumi_hba *mhba, unsigned char msg=
)
> +{
> + =A0 =A0 =A0 struct mvumi_cmd *cmd;
> + =A0 =A0 =A0 struct mvumi_msg_frame *frame;
> +
> + =A0 =A0 =A0 cmd =3D mvumi_create_internal_cmd(mhba, 512);
> + =A0 =A0 =A0 if (!cmd)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> + =A0 =A0 =A0 cmd->scmd =3D NULL;
> + =A0 =A0 =A0 cmd->cmd_status =3D REQ_STATUS_PENDING;
> + =A0 =A0 =A0 atomic_set(&cmd->sync_cmd, 0);
> + =A0 =A0 =A0 frame =3D cmd->frame;
> + =A0 =A0 =A0 frame->device_id =3D 0;
> + =A0 =A0 =A0 frame->cmd_flag =3D CMD_FLAG_DATA_IN;
> + =A0 =A0 =A0 frame->req_function =3D CL_FUN_SCSI_CMD;
> + =A0 =A0 =A0 frame->cdb_length =3D MAX_COMMAND_SIZE;
> + =A0 =A0 =A0 frame->data_transfer_length =3D sizeof(struct mvumi_eve=
nt_req);
> + =A0 =A0 =A0 memset(frame->cdb, 0, MAX_COMMAND_SIZE);
> + =A0 =A0 =A0 frame->cdb[0] =3D APICDB0_EVENT;
> + =A0 =A0 =A0 frame->cdb[1] =3D msg;
> + =A0 =A0 =A0 mvumi_issue_blocked_cmd(mhba, cmd);
> +
> + =A0 =A0 =A0 if (cmd->cmd_status !=3D SAM_STAT_GOOD)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->dev, "get event fa=
iled, status=3D0x%x.\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cmd->cmd_status);
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvumi_notification(mhba, cmd->frame->cd=
b[1], cmd->data_buf);
> +
> + =A0 =A0 =A0 mvumi_delete_internal_cmd(mhba, cmd);
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static void mvumi_scan_events(struct work_struct *work)
> +{
> + =A0 =A0 =A0 struct mvumi_events_wq *mu_ev =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 container_of(work, struct mvumi_events_=
wq, work_q);
> +
> + =A0 =A0 =A0 mvumi_get_event(mu_ev->mhba, mu_ev->event);
> + =A0 =A0 =A0 kfree(mu_ev);
> +}
> +
> +static void mvumi_launch_events(struct mvumi_hba *mhba, u8 msg)
> +{
> + =A0 =A0 =A0 struct mvumi_events_wq *mu_ev;
> +
> + =A0 =A0 =A0 mu_ev =3D kzalloc(sizeof(*mu_ev), GFP_ATOMIC);
> + =A0 =A0 =A0 if (mu_ev) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 INIT_WORK(&mu_ev->work_q, mvumi_scan_ev=
ents);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mu_ev->mhba =3D mhba;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mu_ev->event =3D msg;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mu_ev->param =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 schedule_work(&mu_ev->work_q);
> + =A0 =A0 =A0 }
> +}
> +
> +static void mvumi_handle_clob(struct mvumi_hba *mhba)
> +{
> + =A0 =A0 =A0 struct mvumi_rsp_frame *ob_frame;
> + =A0 =A0 =A0 struct mvumi_cmd *cmd;
> + =A0 =A0 =A0 struct mvumi_ob_data *pool;
> +
> + =A0 =A0 =A0 while (!list_empty(&mhba->free_ob_list)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pool =3D list_first_entry(&mhba->free_o=
b_list,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 struct mvumi_ob_data, list);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del_init(&pool->list);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_add_tail(&pool->list, &mhba->ob_da=
ta_list);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ob_frame =3D (struct mvumi_rsp_frame *)=
 &pool->data[0];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cmd =3D mhba->tag_cmd[ob_frame->tag];
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&mhba->fw_outstanding);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->tag_cmd[ob_frame->tag] =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tag_release_one(mhba, &mhba->tag_pool, =
ob_frame->tag);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cmd->scmd)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvumi_complete_cmd(mhba=
, cmd, ob_frame);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvumi_complete_internal=
_cmd(mhba, cmd, ob_frame);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 mhba->instancet->fire_cmd(mhba, NULL);
> +}
> +
> +static irqreturn_t mvumi_isr_handler(int irq, void *devp)
> +{
> + =A0 =A0 =A0 struct mvumi_hba *mhba =3D (struct mvumi_hba *) devp;
> + =A0 =A0 =A0 unsigned long flags;
> +
> + =A0 =A0 =A0 spin_lock_irqsave(mhba->shost->host_lock, flags);
> + =A0 =A0 =A0 if (unlikely(mhba->instancet->clear_intr(mhba) || !mhba=
->global_isr)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(mhba->shost->hos=
t_lock, flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return IRQ_NONE;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (mhba->global_isr & INT_MAP_DL_CPU2PCIEA) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mhba->isr_status & DRBL_HANDSHAKE_I=
SR) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_warn(&mhba->pdev->d=
ev, "enter handshake again!\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvumi_handshake(mhba);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mhba->isr_status & DRBL_EVENT_NOTIF=
Y)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvumi_launch_events(mhb=
a, APICDB1_EVENT_GETEVENT);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (mhba->global_isr & INT_MAP_COMAOUT)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvumi_receive_ob_list_entry(mhba);
> +
> + =A0 =A0 =A0 mhba->global_isr =3D 0;
> + =A0 =A0 =A0 mhba->isr_status =3D 0;
> + =A0 =A0 =A0 if (mhba->fw_state =3D=3D FW_STATE_STARTED)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvumi_handle_clob(mhba);
> + =A0 =A0 =A0 spin_unlock_irqrestore(mhba->shost->host_lock, flags);
> + =A0 =A0 =A0 return IRQ_HANDLED;
> +}
> +
> +static enum mvumi_qc_result mvumi_send_command(struct mvumi_hba *mhb=
a,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 struct mvumi_cmd *cmd)
> +{
> + =A0 =A0 =A0 void *ib_entry;
> + =A0 =A0 =A0 struct mvumi_msg_frame *ib_frame;
> + =A0 =A0 =A0 unsigned int frame_len;
> +
> + =A0 =A0 =A0 ib_frame =3D cmd->frame;
> + =A0 =A0 =A0 if (unlikely(mhba->fw_state !=3D FW_STATE_STARTED)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_dbg(&mhba->pdev->dev, "firmware not=
 ready.\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return MV_QUEUE_COMMAND_RESULT_NO_RESOU=
RCE;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (tag_is_empty(&mhba->tag_pool)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_dbg(&mhba->pdev->dev, "no free tag.=
\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return MV_QUEUE_COMMAND_RESULT_NO_RESOU=
RCE;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (mvumi_get_ib_list_entry(mhba, &ib_entry))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return MV_QUEUE_COMMAND_RESULT_NO_RESOU=
RCE;
> +
> + =A0 =A0 =A0 cmd->frame->tag =3D tag_get_one(mhba, &mhba->tag_pool);
> + =A0 =A0 =A0 cmd->frame->request_id =3D mhba->io_seq++;
> + =A0 =A0 =A0 cmd->request_id =3D cmd->frame->request_id;
> + =A0 =A0 =A0 mhba->tag_cmd[cmd->frame->tag] =3D cmd;
> + =A0 =A0 =A0 frame_len =3D sizeof(*ib_frame) - 4 +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ib_fram=
e->sg_counts * sizeof(struct mvumi_sgl);
> + =A0 =A0 =A0 memcpy(ib_entry, ib_frame, frame_len);
> + =A0 =A0 =A0 return MV_QUEUE_COMMAND_RESULT_SENT;
> +}
> +
> +static void mvumi_fire_cmd(struct mvumi_hba *mhba, struct mvumi_cmd =
*cmd)
> +{
> + =A0 =A0 =A0 unsigned short num_of_cl_sent =3D 0;
> + =A0 =A0 =A0 enum mvumi_qc_result result;
> +
> + =A0 =A0 =A0 if (cmd)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_add_tail(&cmd->queue_pointer, &mhb=
a->waiting_req_list);
> +
> + =A0 =A0 =A0 while (!list_empty(&mhba->waiting_req_list)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cmd =3D list_first_entry(&mhba->waiting=
_req_list,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0struct mvumi_cmd, queue_pointer);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del_init(&cmd->queue_pointer);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 result =3D mvumi_send_command(mhba, cmd=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (result) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case MV_QUEUE_COMMAND_RESULT_SENT:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_of_cl_sent++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case MV_QUEUE_COMMAND_RESULT_NO_RESOURC=
E:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_add(&cmd->queue_po=
inter, &mhba->waiting_req_list);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (num_of_cl_sent > 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvumi_s=
end_ib_list_entry(mhba);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (num_of_cl_sent > 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvumi_send_ib_list_entry(mhba);
> +}
> +
> +/**
> + * mvumi_enable_intr - Enables interrupts
> + * @regs: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0FW register set
> + */
> +static void mvumi_enable_intr(void *regs)
> +{
> + =A0 =A0 =A0 unsigned int mask;
> +
> + =A0 =A0 =A0 iowrite32(0x3FFFFFFF, regs + CPU_ARM_TO_PCIEA_MASK_REG)=
;
> + =A0 =A0 =A0 mask =3D ioread32(regs + CPU_ENPOINTA_MASK_REG);
> + =A0 =A0 =A0 mask |=3D INT_MAP_DL_CPU2PCIEA | INT_MAP_COMAOUT | INT_=
MAP_COMAERR;
> + =A0 =A0 =A0 iowrite32(mask, regs + CPU_ENPOINTA_MASK_REG);
> +}
> +
> +/**
> + * mvumi_disable_intr -Disables interrupt
> + * @regs: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0FW register set
> + */
> +static void mvumi_disable_intr(void *regs)
> +{
> + =A0 =A0 =A0 unsigned int mask;
> +
> + =A0 =A0 =A0 iowrite32(0, regs + CPU_ARM_TO_PCIEA_MASK_REG);
> + =A0 =A0 =A0 mask =3D ioread32(regs + CPU_ENPOINTA_MASK_REG);
> + =A0 =A0 =A0 mask &=3D ~(INT_MAP_DL_CPU2PCIEA | INT_MAP_COMAOUT | IN=
T_MAP_COMAERR);
> + =A0 =A0 =A0 iowrite32(mask, regs + CPU_ENPOINTA_MASK_REG);
> +}
> +
> +static int mvumi_clear_intr(void *extend)
> +{
> + =A0 =A0 =A0 struct mvumi_hba *mhba =3D (struct mvumi_hba *) extend;
> + =A0 =A0 =A0 unsigned int status, isr_status =3D 0, tmp =3D 0;
> + =A0 =A0 =A0 void *regs =3D mhba->mmio;
> +
> + =A0 =A0 =A0 status =3D ioread32(regs + CPU_MAIN_INT_CAUSE_REG);
> + =A0 =A0 =A0 if (!(status & INT_MAP_MU) || status =3D=3D 0xFFFFFFFF)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> + =A0 =A0 =A0 if (unlikely(status & INT_MAP_COMAERR)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tmp =3D ioread32(regs + CLA_ISR_CAUSE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (tmp & (CLIC_IN_ERR_IRQ | CLIC_OUT_E=
RR_IRQ))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iowrite32(tmp & (CLIC_I=
N_ERR_IRQ | CLIC_OUT_ERR_IRQ),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 regs + CLA_ISR_CAUSE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 status ^=3D INT_MAP_COMAERR;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* inbound or outbound parity error, co=
mmand will timeout */
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (status & INT_MAP_COMAOUT) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tmp =3D ioread32(regs + CLA_ISR_CAUSE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (tmp & CLIC_OUT_IRQ)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iowrite32(tmp & CLIC_OU=
T_IRQ, regs + CLA_ISR_CAUSE);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (status & INT_MAP_DL_CPU2PCIEA) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 isr_status =3D ioread32(regs + CPU_ARM_=
TO_PCIEA_DRBL_REG);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (isr_status)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iowrite32(isr_status, r=
egs + CPU_ARM_TO_PCIEA_DRBL_REG);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 mhba->global_isr =3D status;
> + =A0 =A0 =A0 mhba->isr_status =3D isr_status;
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +/**
> + * mvumi_read_fw_status_reg - returns the current FW status value
> + * @regs: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0FW register set
> + */
> +static unsigned int mvumi_read_fw_status_reg(void *regs)
> +{
> + =A0 =A0 =A0 unsigned int status;
> +
> + =A0 =A0 =A0 status =3D ioread32(regs + CPU_ARM_TO_PCIEA_DRBL_REG);
> + =A0 =A0 =A0 if (status)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iowrite32(status, regs + CPU_ARM_TO_PCI=
EA_DRBL_REG);
> + =A0 =A0 =A0 return status;
> +}
> +
> +static struct mvumi_instance_template mvumi_instance_template =3D {
> + =A0 =A0 =A0 .fire_cmd =3D mvumi_fire_cmd,
> + =A0 =A0 =A0 .enable_intr =3D mvumi_enable_intr,
> + =A0 =A0 =A0 .disable_intr =3D mvumi_disable_intr,
> + =A0 =A0 =A0 .clear_intr =3D mvumi_clear_intr,
> + =A0 =A0 =A0 .read_fw_status_reg =3D mvumi_read_fw_status_reg,
> +};
> +
> +static int mvumi_slave_configure(struct scsi_device *sdev)
> +{
> + =A0 =A0 =A0 struct mvumi_hba *mhba;
> + =A0 =A0 =A0 unsigned char bitcount =3D sizeof(unsigned char) * 8;
> +
> + =A0 =A0 =A0 mhba =3D (struct mvumi_hba *) sdev->host->hostdata;
> + =A0 =A0 =A0 if (sdev->id >=3D mhba->max_target_id)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> +
> + =A0 =A0 =A0 mhba->target_map[sdev->id / bitcount] |=3D (1 << (sdev-=
>id % bitcount));
> + =A0 =A0 =A0 return 0;
> +}
> +
> +/**
> + * mvumi_build_frame - Prepares a direct cdb (DCDB) command
> + * @mhba: =A0 =A0 =A0 =A0 =A0 =A0 =A0Adapter soft state
> + * @scmd: =A0 =A0 =A0 =A0 =A0 =A0 =A0SCSI command
> + * @cmd: =A0 =A0 =A0 =A0 =A0 =A0 =A0 Command to be prepared in
> + *
> + * This function prepares CDB commands. These are typcially pass-thr=
ough
> + * commands to the devices.
> + */
> +static unsigned char mvumi_build_frame(struct mvumi_hba *mhba,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct =
scsi_cmnd *scmd, struct mvumi_cmd *cmd)
> +{
> + =A0 =A0 =A0 struct mvumi_msg_frame *pframe;
> +
> + =A0 =A0 =A0 cmd->scmd =3D scmd;
> + =A0 =A0 =A0 cmd->cmd_status =3D REQ_STATUS_PENDING;
> + =A0 =A0 =A0 pframe =3D cmd->frame;
> + =A0 =A0 =A0 pframe->device_id =3D ((unsigned short) scmd->device->i=
d) |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (((unsi=
gned short) scmd->device->lun) << 8);
> + =A0 =A0 =A0 pframe->cmd_flag =3D 0;
> +
> + =A0 =A0 =A0 switch (scmd->sc_data_direction) {
> + =A0 =A0 =A0 case DMA_NONE:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pframe->cmd_flag |=3D CMD_FLAG_NON_DATA=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case DMA_FROM_DEVICE:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pframe->cmd_flag |=3D CMD_FLAG_DATA_IN;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case DMA_TO_DEVICE:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pframe->cmd_flag |=3D CMD_FLAG_DATA_OUT=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case DMA_BIDIRECTIONAL:
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_warn(&mhba->pdev->dev, "unexpected =
data direction[%d] "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "cmd[0x%x]\n", scmd->sc=
_data_direction, scmd->cmnd[0]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto error;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 pframe->cdb_length =3D scmd->cmd_len;
> + =A0 =A0 =A0 memcpy(pframe->cdb, scmd->cmnd, pframe->cdb_length);
> + =A0 =A0 =A0 pframe->req_function =3D CL_FUN_SCSI_CMD;
> + =A0 =A0 =A0 if (scsi_bufflen(scmd)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mvumi_make_sgl(mhba, scmd, &pframe-=
>payload[0],
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &pframe->sg_counts))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto error;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pframe->data_transfer_length =3D scsi_b=
ufflen(scmd);
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pframe->sg_counts =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pframe->data_transfer_length =3D 0;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return 0;
> +
> +error:
> + =A0 =A0 =A0 scmd->result =3D (DID_OK << 16) | (DRIVER_SENSE << 24) =
|
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 SAM_STAT_CHECK_CONDITION;
> + =A0 =A0 =A0 scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_=
REQUEST, 0x24,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 0);
> + =A0 =A0 =A0 return -1;
> +}
> +
> +/**
> + * mvumi_queue_command - =A0 =A0 =A0 Queue entry point
> + * @scmd: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0SCSI command to=
 be queued
> + * @done: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Callback entry =
point
> + */
> +static int mvumi_queue_command(struct Scsi_Host *shost,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 struct scsi_cmnd *scmd)
> +{
> + =A0 =A0 =A0 struct mvumi_cmd *cmd;
> + =A0 =A0 =A0 struct mvumi_hba *mhba;
> + =A0 =A0 =A0 unsigned long irq_flags;
> +
> + =A0 =A0 =A0 spin_lock_irqsave(shost->host_lock, irq_flags);
> + =A0 =A0 =A0 scsi_cmd_get_serial(shost, scmd);
> +
> + =A0 =A0 =A0 mhba =3D (struct mvumi_hba *) shost->hostdata;
> + =A0 =A0 =A0 scmd->result =3D 0;
> + =A0 =A0 =A0 cmd =3D mvumi_get_cmd(mhba);
> + =A0 =A0 =A0 if (unlikely(!cmd)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(shost->host_lock=
, irq_flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return SCSI_MLQUEUE_HOST_BUSY;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (unlikely(mvumi_build_frame(mhba, scmd, cmd)))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_return_cmd;
> +
> + =A0 =A0 =A0 cmd->scmd =3D scmd;
> + =A0 =A0 =A0 scmd->SCp.ptr =3D (char *) cmd;
> + =A0 =A0 =A0 mhba->instancet->fire_cmd(mhba, cmd);
> + =A0 =A0 =A0 spin_unlock_irqrestore(shost->host_lock, irq_flags);
> + =A0 =A0 =A0 return 0;
> +
> +out_return_cmd:
> + =A0 =A0 =A0 mvumi_return_cmd(mhba, cmd);
> + =A0 =A0 =A0 scmd->scsi_done(scmd);
> + =A0 =A0 =A0 spin_unlock_irqrestore(shost->host_lock, irq_flags);
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static enum blk_eh_timer_return mvumi_timed_out(struct scsi_cmnd *sc=
md)
> +{
> + =A0 =A0 =A0 struct mvumi_cmd *cmd =3D (struct mvumi_cmd *) scmd->SC=
p.ptr;
> + =A0 =A0 =A0 struct Scsi_Host *host =3D scmd->device->host;
> + =A0 =A0 =A0 struct mvumi_hba *mhba =3D shost_priv(host);
> + =A0 =A0 =A0 unsigned long flags;
> +
> + =A0 =A0 =A0 spin_lock_irqsave(mhba->shost->host_lock, flags);
> +
> + =A0 =A0 =A0 if (mhba->tag_cmd[cmd->frame->tag]) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->tag_cmd[cmd->frame->tag] =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tag_release_one(mhba, &mhba->tag_pool, =
cmd->frame->tag);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (!list_empty(&cmd->queue_pointer))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del_init(&cmd->queue_pointer);
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&mhba->fw_outstanding);
> +
> + =A0 =A0 =A0 scmd->result =3D (DRIVER_INVALID << 24) | (DID_ABORT <<=
 16);
> + =A0 =A0 =A0 scmd->SCp.ptr =3D NULL;
> + =A0 =A0 =A0 if (scsi_bufflen(scmd)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (scsi_sg_count(scmd)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pci_unmap_sg(mhba->pdev=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 scsi_sg=
list(scmd),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 scsi_sg=
_count(scmd),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (int)sc=
md->sc_data_direction);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pci_unmap_single(mhba->=
pdev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 scmd->S=
Cp.dma_handle,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 scsi_bu=
fflen(scmd),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (int)sc=
md->sc_data_direction);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 scmd->SCp.dma_handle =3D=
 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 mvumi_return_cmd(mhba, cmd);
> + =A0 =A0 =A0 spin_unlock_irqrestore(mhba->shost->host_lock, flags);
> +
> + =A0 =A0 =A0 return BLK_EH_NOT_HANDLED;
> +}
> +
> +static int
> +mvumi_bios_param(struct scsi_device *sdev, struct block_device *bdev=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sector_t capacity, int =
geom[])
> +{
> + =A0 =A0 =A0 int heads, sectors;
> + =A0 =A0 =A0 sector_t cylinders;
> + =A0 =A0 =A0 unsigned long tmp;
> +
> + =A0 =A0 =A0 heads =3D 64;
> + =A0 =A0 =A0 sectors =3D 32;
> + =A0 =A0 =A0 tmp =3D heads * sectors;
> + =A0 =A0 =A0 cylinders =3D capacity;
> + =A0 =A0 =A0 sector_div(cylinders, tmp);
> +
> + =A0 =A0 =A0 if (capacity >=3D 0x200000) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 heads =3D 255;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sectors =3D 63;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tmp =3D heads * sectors;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cylinders =3D capacity;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sector_div(cylinders, tmp);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 geom[0] =3D heads;
> + =A0 =A0 =A0 geom[1] =3D sectors;
> + =A0 =A0 =A0 geom[2] =3D cylinders;
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static struct scsi_host_template mvumi_template =3D {
> +
> + =A0 =A0 =A0 .module =3D THIS_MODULE,
> + =A0 =A0 =A0 .name =3D "Marvell Storage Controller",
> + =A0 =A0 =A0 .slave_configure =3D mvumi_slave_configure,
> + =A0 =A0 =A0 .queuecommand =3D mvumi_queue_command,
> + =A0 =A0 =A0 .eh_host_reset_handler =3D mvumi_host_reset,
> + =A0 =A0 =A0 .bios_param =3D mvumi_bios_param,
> + =A0 =A0 =A0 .this_id =3D -1,
> +};
> +
> +static struct scsi_transport_template mvumi_transport_template =3D {
> + =A0 =A0 =A0 .eh_timed_out =3D mvumi_timed_out,
> +};
> +
> +/**
> + * mvumi_init_fw - =A0 =A0 Initializes the FW
> + * @mhba: =A0 =A0 =A0 =A0 =A0 =A0 =A0Adapter soft state
> + *
> + * This is the main function for initializing firmware.
> + */
> +static int mvumi_init_fw(struct mvumi_hba *mhba)
> +{
> + =A0 =A0 =A0 int ret =3D 0;
> +
> + =A0 =A0 =A0 if (pci_request_regions(mhba->pdev, MV_DRIVER_NAME)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->dev, "IO memory re=
gion busy!\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EBUSY;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 ret =3D mvumi_map_pci_addr(mhba->pdev, mhba->base_addr)=
;
> + =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail_ioremap;
> +
> + =A0 =A0 =A0 mhba->mmio =3D mhba->base_addr[0];
> +
> + =A0 =A0 =A0 switch (mhba->pdev->device) {
> + =A0 =A0 =A0 case PCI_DEVICE_ID_MARVELL_MV9143:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->instancet =3D &mvumi_instance_tem=
plate;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->io_seq =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->max_sge =3D MVUMI_MAX_SG_ENTRY;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->request_id_enabled =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->dev, "device 0x%x =
not supported!\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->pdev->device);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->instancet =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail_alloc_mem;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 dev_dbg(&mhba->pdev->dev, "device id : %04X is found.\n=
",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mhba->pdev->device);
> +
> + =A0 =A0 =A0 mhba->handshake_page =3D kzalloc(HSP_MAX_SIZE, GFP_KERN=
EL);
> + =A0 =A0 =A0 if (!mhba->handshake_page) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "failed to allocate mem=
ory for handshake\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail_alloc_mem;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 mhba->handshake_page_phys =3D virt_to_phys(mhba->handsh=
ake_page);
> +
> + =A0 =A0 =A0 if (mvumi_start(mhba)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail_ready_state;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 ret =3D mvumi_alloc_cmds(mhba);
> + =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail_ready_state;
> +
> + =A0 =A0 =A0 return 0;
> +
> +fail_ready_state:
> + =A0 =A0 =A0 mvumi_release_mem_resource(mhba);
> + =A0 =A0 =A0 kfree(mhba->handshake_page);
> +fail_alloc_mem:
> + =A0 =A0 =A0 mvumi_unmap_pci_addr(mhba->pdev, mhba->base_addr);
> +fail_ioremap:
> + =A0 =A0 =A0 pci_release_regions(mhba->pdev);
> +
> + =A0 =A0 =A0 return ret;
> +}
> +
> +/**
> + * mvumi_io_attach - =A0 Attaches this driver to SCSI mid-layer
> + * @mhba: =A0 =A0 =A0 =A0 =A0 =A0 =A0Adapter soft state
> + */
> +static int mvumi_io_attach(struct mvumi_hba *mhba)
> +{
> + =A0 =A0 =A0 struct Scsi_Host *host =3D mhba->shost;
> + =A0 =A0 =A0 int ret;
> + =A0 =A0 =A0 unsigned int max_sg =3D (mhba->ib_max_size + 4 -
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct mvumi_msg_frame)) / sizeo=
f(struct mvumi_sgl);
> +
> + =A0 =A0 =A0 host->irq =3D mhba->pdev->irq;
> + =A0 =A0 =A0 host->unique_id =3D mhba->unique_id;
> + =A0 =A0 =A0 host->can_queue =3D (mhba->max_io - 1) ? (mhba->max_io =
- 1) : 1;
> + =A0 =A0 =A0 host->sg_tablesize =3D mhba->max_sge > max_sg ? max_sg =
: mhba->max_sge;
> + =A0 =A0 =A0 host->max_sectors =3D mhba->max_transfer_size / 512;
> + =A0 =A0 =A0 host->cmd_per_lun =3D =A0(mhba->max_io - 1) ? (mhba->ma=
x_io - 1) : 1;
> + =A0 =A0 =A0 host->max_id =3D mhba->max_target_id;
> + =A0 =A0 =A0 host->max_cmd_len =3D MAX_COMMAND_SIZE;
> + =A0 =A0 =A0 host->transportt =3D &mvumi_transport_template;
> +
> + =A0 =A0 =A0 ret =3D scsi_add_host(host, &mhba->pdev->dev);
> + =A0 =A0 =A0 if (ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&mhba->pdev->dev, "scsi_add_hos=
t failed\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 mhba->fw_flag |=3D MVUMI_FW_ATTACH;
> + =A0 =A0 =A0 scsi_scan_host(host);
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +/**
> + * mvumi_probe_one - =A0 PCI hotplug entry point
> + * @pdev: =A0 =A0 =A0 =A0 =A0 =A0 =A0PCI device structure
> + * @id: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0PCI ids of su=
pported hotplugged adapter
> + */
> +static int __devinit mvumi_probe_one(struct pci_dev *pdev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 const struct pci_device_id *id)
> +{
> + =A0 =A0 =A0 struct Scsi_Host *host;
> + =A0 =A0 =A0 struct mvumi_hba *mhba;
> + =A0 =A0 =A0 int ret;
> +
> + =A0 =A0 =A0 dev_dbg(&pdev->dev, " %#4.04x:%#4.04x:%#4.04x:%#4.04x: =
",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pdev->vendor, pdev->dev=
ice, pdev->subsystem_vendor,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pdev->subsystem_device)=
;
> +
> + =A0 =A0 =A0 ret =3D pci_enable_device(pdev);
> + =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> +
> + =A0 =A0 =A0 pci_set_master(pdev);
> +
> + =A0 =A0 =A0 if (IS_DMA64) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D pci_set_dma_mask(pdev, DMA_BIT_=
MASK(64));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D pci_set_dma_mas=
k(pdev, DMA_BIT_MASK(32));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fa=
il_set_dma_mask;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D pci_set_dma_mask(pdev, DMA_BIT_=
MASK(32));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail_set_dma_mask;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 host =3D scsi_host_alloc(&mvumi_template, sizeof(*mhba)=
);
> + =A0 =A0 =A0 if (!host) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "scsi_host_alloc fa=
iled\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail_alloc_instance;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 mhba =3D shost_priv(host);
> +
> + =A0 =A0 =A0 INIT_LIST_HEAD(&mhba->cmd_pool);
> + =A0 =A0 =A0 INIT_LIST_HEAD(&mhba->ob_data_list);
> + =A0 =A0 =A0 INIT_LIST_HEAD(&mhba->free_ob_list);
> + =A0 =A0 =A0 INIT_LIST_HEAD(&mhba->res_list);
> + =A0 =A0 =A0 INIT_LIST_HEAD(&mhba->waiting_req_list);
> + =A0 =A0 =A0 atomic_set(&mhba->fw_outstanding, 0);
> + =A0 =A0 =A0 init_waitqueue_head(&mhba->int_cmd_wait_q);
> +
> + =A0 =A0 =A0 mhba->pdev =3D pdev;
> + =A0 =A0 =A0 mhba->shost =3D host;
> + =A0 =A0 =A0 mhba->unique_id =3D pdev->bus->number << 8 | pdev->devf=
n;
> +
> + =A0 =A0 =A0 ret =3D mvumi_init_fw(mhba);
> + =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail_init_fw;
> +
> + =A0 =A0 =A0 ret =3D request_irq(mhba->pdev->irq, mvumi_isr_handler,=
 IRQF_SHARED,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "mvumi"=
, mhba);
> + =A0 =A0 =A0 if (ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "failed to register=
 IRQ\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail_init_irq;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 mhba->instancet->enable_intr(mhba->mmio);
> + =A0 =A0 =A0 pci_set_drvdata(pdev, mhba);
> +
> + =A0 =A0 =A0 ret =3D mvumi_io_attach(mhba);
> + =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail_io_attach;
> + =A0 =A0 =A0 dev_dbg(&pdev->dev, "probe mvumi driver successfully.\n=
");
> +
> + =A0 =A0 =A0 return 0;
> +
> +fail_io_attach:
> + =A0 =A0 =A0 pci_set_drvdata(pdev, NULL);
> + =A0 =A0 =A0 mhba->instancet->disable_intr(mhba->mmio);
> + =A0 =A0 =A0 free_irq(mhba->pdev->irq, mhba);
> +fail_init_irq:
> + =A0 =A0 =A0 mvumi_release_fw(mhba);
> +fail_init_fw:
> + =A0 =A0 =A0 scsi_host_put(host);
> +
> +fail_alloc_instance:
> +fail_set_dma_mask:
> + =A0 =A0 =A0 pci_disable_device(pdev);
> +
> + =A0 =A0 =A0 return ret;
> +}
> +
> +static void mvumi_detach_one(struct pci_dev *pdev)
> +{
> + =A0 =A0 =A0 struct Scsi_Host *host;
> + =A0 =A0 =A0 struct mvumi_hba *mhba;
> +
> + =A0 =A0 =A0 mhba =3D pci_get_drvdata(pdev);
> + =A0 =A0 =A0 host =3D mhba->shost;
> + =A0 =A0 =A0 scsi_remove_host(mhba->shost);
> + =A0 =A0 =A0 mvumi_flush_cache(mhba);
> +
> + =A0 =A0 =A0 mhba->instancet->disable_intr(mhba->mmio);
> + =A0 =A0 =A0 free_irq(mhba->pdev->irq, mhba);
> + =A0 =A0 =A0 mvumi_release_fw(mhba);
> + =A0 =A0 =A0 scsi_host_put(host);
> + =A0 =A0 =A0 pci_set_drvdata(pdev, NULL);
> + =A0 =A0 =A0 pci_disable_device(pdev);
> + =A0 =A0 =A0 dev_dbg(&pdev->dev, "driver is removed!\n");
> +}
> +
> +/**
> + * mvumi_shutdown - =A0 =A0Shutdown entry point
> + * @device: =A0 =A0 =A0 =A0 =A0 =A0Generic device structure
> + */
> +static void mvumi_shutdown(struct pci_dev *pdev)
> +{
> + =A0 =A0 =A0 struct mvumi_hba *mhba =3D pci_get_drvdata(pdev);
> +
> + =A0 =A0 =A0 mvumi_flush_cache(mhba);
> +}
> +
> +static int mvumi_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> + =A0 =A0 =A0 struct mvumi_hba *mhba =3D NULL;
> +
> + =A0 =A0 =A0 mhba =3D pci_get_drvdata(pdev);
> + =A0 =A0 =A0 mvumi_flush_cache(mhba);
> +
> + =A0 =A0 =A0 pci_set_drvdata(pdev, mhba);
> + =A0 =A0 =A0 mhba->instancet->disable_intr(mhba->mmio);
> + =A0 =A0 =A0 free_irq(mhba->pdev->irq, mhba);
> + =A0 =A0 =A0 mvumi_unmap_pci_addr(pdev, mhba->base_addr);
> + =A0 =A0 =A0 pci_release_regions(pdev);
> + =A0 =A0 =A0 pci_save_state(pdev);
> + =A0 =A0 =A0 pci_disable_device(pdev);
> + =A0 =A0 =A0 pci_set_power_state(pdev, pci_choose_state(pdev, state)=
);
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static int mvumi_resume(struct pci_dev *pdev)
> +{
> + =A0 =A0 =A0 int ret;
> + =A0 =A0 =A0 struct mvumi_hba *mhba =3D NULL;
> +
> + =A0 =A0 =A0 mhba =3D pci_get_drvdata(pdev);
> +
> + =A0 =A0 =A0 pci_set_power_state(pdev, PCI_D0);
> + =A0 =A0 =A0 pci_enable_wake(pdev, PCI_D0, 0);
> + =A0 =A0 =A0 pci_restore_state(pdev);
> +
> + =A0 =A0 =A0 ret =3D pci_enable_device(pdev);
> + =A0 =A0 =A0 if (ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "enable device fail=
ed\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 pci_set_master(pdev);
> + =A0 =A0 =A0 if (IS_DMA64) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D pci_set_dma_mask(pdev, DMA_BIT_=
MASK(64));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D pci_set_dma_mas=
k(pdev, DMA_BIT_MASK(32));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fa=
il;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D pci_set_dma_mask(pdev, DMA_BIT_=
MASK(32));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 ret =3D pci_request_regions(mhba->pdev, MV_DRIVER_NAME)=
;
> + =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail;
> + =A0 =A0 =A0 ret =3D mvumi_map_pci_addr(mhba->pdev, mhba->base_addr)=
;
> + =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto release_regions;
> +
> + =A0 =A0 =A0 mhba->mmio =3D mhba->base_addr[0];
> + =A0 =A0 =A0 mvumi_reset(mhba->mmio);
> +
> + =A0 =A0 =A0 if (mvumi_start(mhba)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto unmap_pci_addr;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 ret =3D request_irq(mhba->pdev->irq, mvumi_isr_handler,=
 IRQF_SHARED,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "mvumi"=
, mhba);
> + =A0 =A0 =A0 if (ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "failed to register=
 IRQ\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto unmap_pci_addr;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 mhba->instancet->enable_intr(mhba->mmio);
> +
> + =A0 =A0 =A0 return 0;
> +
> +unmap_pci_addr:
> + =A0 =A0 =A0 mvumi_unmap_pci_addr(pdev, mhba->base_addr);
> +release_regions:
> + =A0 =A0 =A0 pci_release_regions(pdev);
> +fail:
> + =A0 =A0 =A0 pci_disable_device(pdev);
> +
> + =A0 =A0 =A0 return ret;
> +}
> +
> +static struct pci_driver mvumi_pci_driver =3D {
> +
> + =A0 =A0 =A0 .name =3D MV_DRIVER_NAME,
> + =A0 =A0 =A0 .id_table =3D mvumi_pci_table,
> + =A0 =A0 =A0 .probe =3D mvumi_probe_one,
> + =A0 =A0 =A0 .remove =3D __devexit_p(mvumi_detach_one),
> + =A0 =A0 =A0 .shutdown =3D mvumi_shutdown,
> +#ifdef CONFIG_PM
> + =A0 =A0 =A0 .suspend =3D mvumi_suspend,
> + =A0 =A0 =A0 .resume =3D mvumi_resume,
> +#endif
> +};
> +
> +/**
> + * mvumi_init - Driver load entry point
> + */
> +static int __init mvumi_init(void)
> +{
> + =A0 =A0 =A0 return pci_register_driver(&mvumi_pci_driver);
> +}
> +
> +/**
> + * mvumi_exit - Driver unload entry point
> + */
> +static void __exit mvumi_exit(void)
> +{
> +
> + =A0 =A0 =A0 pci_unregister_driver(&mvumi_pci_driver);
> +}
> +
> +module_init(mvumi_init);
> +module_exit(mvumi_exit);
> diff --git a/drivers/scsi/mvumi.h b/drivers/scsi/mvumi.h
> new file mode 100644
> index 0000000..10b9237
> --- /dev/null
> +++ b/drivers/scsi/mvumi.h
> @@ -0,0 +1,505 @@
> +/*
> + =A0* Marvell UMI head file
> + =A0*
> + =A0* Copyright 2011 Marvell. <jyli@marvell.com>
> + =A0*
> + =A0* This file is licensed under GPLv2.
> + =A0*
> + =A0* This program is free software; you can redistribute it and/or
> + =A0* modify it under the terms of the GNU General Public License as
> + =A0* published by the Free Software Foundation; version 2 of the
> + =A0* License.
> + =A0*
> + =A0* This program is distributed in the hope that it will be useful=
,
> + =A0* but WITHOUT ANY WARRANTY; without even the implied warranty of
> + =A0* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. =A0See th=
e GNU
> + =A0* General Public License for more details.
> + =A0*
> + =A0* You should have received a copy of the GNU General Public Lice=
nse
> + =A0* along with this program; if not, write to the Free Software
> + =A0* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111=
-1307
> + =A0* USA
> + */
> +
> +#ifndef MVUMI_H
> +#define MVUMI_H
> +
> +#define MAX_BASE_ADDRESS =A0 =A0 =A0 6
> +
> +#define VER_MAJOR =A0 =A0 =A0 =A0 =A0 =A0 =A01
> +#define VER_MINOR =A0 =A0 =A0 =A0 =A0 =A0 =A01
> +#define VER_OEM =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00
> +#define VER_BUILD =A0 =A0 =A0 =A0 =A0 =A0 =A01500
> +
> +#define MV_DRIVER_NAME =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "mvumi"
> +#define PCI_VENDOR_ID_MARVELL_2 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00x1b4=
b
> +#define PCI_DEVICE_ID_MARVELL_MV9143 =A0 0x9143
> +
> +#define MVUMI_INTERNAL_CMD_WAIT_TIME =A0 45
> +
> +#define IS_DMA64 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (sizeof=
(dma_addr_t) =3D=3D 8)
> +
> +enum mvumi_qc_result {
> + =A0 =A0 =A0 MV_QUEUE_COMMAND_RESULT_SENT =A0 =A0=3D 0,
> + =A0 =A0 =A0 MV_QUEUE_COMMAND_RESULT_NO_RESOURCE,
> +};
> +
> +enum {
> + =A0 =A0 =A0 /*******************************************/
> +
> + =A0 =A0 =A0 /* ARM Mbus Registers Map =A0 =A0 =A0 */
> +
> + =A0 =A0 =A0 /*******************************************/
> + =A0 =A0 =A0 CPU_MAIN_INT_CAUSE_REG =A0=3D 0x20200,
> + =A0 =A0 =A0 CPU_MAIN_IRQ_MASK_REG =A0 =3D 0x20204,
> + =A0 =A0 =A0 CPU_MAIN_FIQ_MASK_REG =A0 =3D 0x20208,
> + =A0 =A0 =A0 CPU_ENPOINTA_MASK_REG =A0 =3D 0x2020C,
> + =A0 =A0 =A0 CPU_ENPOINTB_MASK_REG =A0 =3D 0x20210,
> +
> + =A0 =A0 =A0 INT_MAP_COMAERR =A0 =A0 =A0 =A0 =3D 1 << 6,
> + =A0 =A0 =A0 INT_MAP_COMAIN =A0 =A0 =A0 =A0 =A0=3D 1 << 7,
> + =A0 =A0 =A0 INT_MAP_COMAOUT =A0 =A0 =A0 =A0 =3D 1 << 8,
> + =A0 =A0 =A0 INT_MAP_COMBERR =A0 =A0 =A0 =A0 =3D 1 << 9,
> + =A0 =A0 =A0 INT_MAP_COMBIN =A0 =A0 =A0 =A0 =A0=3D 1 << 10,
> + =A0 =A0 =A0 INT_MAP_COMBOUT =A0 =A0 =A0 =A0 =3D 1 << 11,
> +
> + =A0 =A0 =A0 INT_MAP_COMAINT =3D (INT_MAP_COMAOUT | INT_MAP_COMAERR)=
,
> + =A0 =A0 =A0 INT_MAP_COMBINT =3D (INT_MAP_COMBOUT | INT_MAP_COMBIN |=
 INT_MAP_COMBERR),
> +
> + =A0 =A0 =A0 INT_MAP_DL_PCIEA2CPU =A0 =A0=3D 1 << 0,
> + =A0 =A0 =A0 INT_MAP_DL_CPU2PCIEA =A0 =A0=3D 1 << 1,
> +
> + =A0 =A0 =A0 /***************************************/
> +
> + =A0 =A0 =A0 /* ARM Doorbell Registers Map =A0 =A0 =A0 =A0 =A0 */
> +
> + =A0 =A0 =A0 /***************************************/
> + =A0 =A0 =A0 CPU_PCIEA_TO_ARM_DRBL_REG =A0 =A0 =A0 =3D 0x20400,
> + =A0 =A0 =A0 CPU_PCIEA_TO_ARM_MASK_REG =A0 =A0 =A0 =3D 0x20404,
> + =A0 =A0 =A0 CPU_ARM_TO_PCIEA_DRBL_REG =A0 =A0 =A0 =3D 0x20408,
> + =A0 =A0 =A0 CPU_ARM_TO_PCIEA_MASK_REG =A0 =A0 =A0 =3D 0x2040C,
> +
> + =A0 =A0 =A0 DRBL_HANDSHAKE =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D 1=
 << 0,
> + =A0 =A0 =A0 DRBL_SOFT_RESET =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D 1 <=
< 1,
> + =A0 =A0 =A0 DRBL_BUS_CHANGE =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D 1 <=
< 2,
> + =A0 =A0 =A0 DRBL_EVENT_NOTIFY =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D 1 << =
3,
> + =A0 =A0 =A0 DRBL_MU_RESET =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D 1=
 << 4,
> + =A0 =A0 =A0 DRBL_HANDSHAKE_ISR =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D DRBL_=
HANDSHAKE,
> +
> + =A0 =A0 =A0 CPU_PCIEA_TO_ARM_MSG0 =A0 =A0 =A0 =A0 =A0 =3D 0x20430,
> + =A0 =A0 =A0 CPU_PCIEA_TO_ARM_MSG1 =A0 =A0 =A0 =A0 =A0 =3D 0x20434,
> + =A0 =A0 =A0 CPU_ARM_TO_PCIEA_MSG0 =A0 =A0 =A0 =A0 =A0 =3D 0x20438,
> + =A0 =A0 =A0 CPU_ARM_TO_PCIEA_MSG1 =A0 =A0 =A0 =A0 =A0 =3D 0x2043C,
> +
> + =A0 =A0 =A0 /*******************************************/
> +
> + =A0 =A0 =A0 /* ARM Communication List Registers Map =A0 =A0*/
> +
> + =A0 =A0 =A0 /*******************************************/
> + =A0 =A0 =A0 CLA_INB_LIST_BASEL =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D 0x500=
,
> + =A0 =A0 =A0 CLA_INB_LIST_BASEH =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D 0x504=
,
> + =A0 =A0 =A0 CLA_INB_AVAL_COUNT_BASEL =A0 =A0 =A0 =A0=3D 0x508,
> + =A0 =A0 =A0 CLA_INB_AVAL_COUNT_BASEH =A0 =A0 =A0 =A0=3D 0x50C,
> + =A0 =A0 =A0 CLA_INB_DESTI_LIST_BASEL =A0 =A0 =A0 =A0=3D 0x510,
> + =A0 =A0 =A0 CLA_INB_DESTI_LIST_BASEH =A0 =A0 =A0 =A0=3D 0x514,
> + =A0 =A0 =A0 CLA_INB_WRITE_POINTER =A0 =A0 =A0 =A0 =A0 =3D 0x518,
> + =A0 =A0 =A0 CLA_INB_READ_POINTER =A0 =A0 =A0 =A0 =A0 =A0=3D 0x51C,
> +
> + =A0 =A0 =A0 CLA_OUTB_LIST_BASEL =A0 =A0 =A0 =A0 =A0 =A0 =3D 0x530,
> + =A0 =A0 =A0 CLA_OUTB_LIST_BASEH =A0 =A0 =A0 =A0 =A0 =A0 =3D 0x534,
> + =A0 =A0 =A0 CLA_OUTB_SOURCE_LIST_BASEL =A0 =A0 =A0=3D 0x538,
> + =A0 =A0 =A0 CLA_OUTB_SOURCE_LIST_BASEH =A0 =A0 =A0=3D 0x53C,
> + =A0 =A0 =A0 CLA_OUTB_COPY_POINTER =A0 =A0 =A0 =A0 =A0 =3D 0x544,
> + =A0 =A0 =A0 CLA_OUTB_READ_POINTER =A0 =A0 =A0 =A0 =A0 =3D 0x548,
> +
> + =A0 =A0 =A0 CLA_ISR_CAUSE =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D 0=
x560,
> + =A0 =A0 =A0 CLA_ISR_MASK =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D=
 0x564,
> +
> + =A0 =A0 =A0 INT_MAP_MU =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D (INT_MAP_DL_C=
PU2PCIEA | INT_MAP_COMAINT),
> +
> + =A0 =A0 =A0 CL_POINTER_TOGGLE =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D 1 << =
12,
> +
> + =A0 =A0 =A0 CLIC_IN_IRQ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D=
 1 << 0,
> + =A0 =A0 =A0 CLIC_OUT_IRQ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D=
 1 << 1,
> + =A0 =A0 =A0 CLIC_IN_ERR_IRQ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D 1 <=
< 8,
> + =A0 =A0 =A0 CLIC_OUT_ERR_IRQ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D 1 <=
< 12,
> +
> + =A0 =A0 =A0 CL_SLOT_NUM_MASK =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D 0xF=
=46F,
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 * Command flag is the flag for the CDB command itself
> + =A0 =A0 =A0 */
> + =A0 =A0 =A0 /* 1-non data; 0-data command */
> + =A0 =A0 =A0 CMD_FLAG_NON_DATA =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D 1 << =
0,
> + =A0 =A0 =A0 CMD_FLAG_DMA =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D=
 1 << 1,
> + =A0 =A0 =A0 CMD_FLAG_PIO =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D=
 1 << 2,
> + =A0 =A0 =A0 /* 1-host read data */
> + =A0 =A0 =A0 CMD_FLAG_DATA_IN =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D 1 <=
< 3,
> + =A0 =A0 =A0 /* 1-host write data */
> + =A0 =A0 =A0 CMD_FLAG_DATA_OUT =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D 1 << =
4,
> +
> + =A0 =A0 =A0 SCSI_CMD_MARVELL_SPECIFIC =A0 =A0 =A0 =3D 0xE1,
> + =A0 =A0 =A0 CDB_CORE_SHUTDOWN =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D 0xB,
> +};
> +
> +#define APICDB0_EVENT =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00xF4
> +#define APICDB1_EVENT_GETEVENT =A0 =A0 =A0 =A0 0
> +#define MAX_EVENTS_RETURNED =A0 =A0 =A0 =A0 =A0 =A06
> +
> +struct mvumi_driver_event {
> + =A0 =A0 =A0 u32 =A0 =A0 time_stamp;
> + =A0 =A0 =A0 u32 =A0 =A0 sequence_no;
> + =A0 =A0 =A0 u32 =A0 =A0 event_id;
> + =A0 =A0 =A0 u8 =A0 =A0 =A0severity;
> + =A0 =A0 =A0 u8 =A0 =A0 =A0param_count;
> + =A0 =A0 =A0 u16 =A0 =A0 device_id;
> + =A0 =A0 =A0 u32 =A0 =A0 params[4];
> + =A0 =A0 =A0 u8 =A0 =A0 =A0sense_data_length;
> + =A0 =A0 =A0 u8 =A0 =A0 =A0Reserved1;
> + =A0 =A0 =A0 u8 =A0 =A0 =A0sense_data[30];
> +};
> +
> +struct mvumi_event_req {
> + =A0 =A0 =A0 unsigned char =A0 count;
> + =A0 =A0 =A0 unsigned char =A0 reserved[3];
> + =A0 =A0 =A0 struct mvumi_driver_event =A0events[MAX_EVENTS_RETURNED=
];
> +};
> +
> +struct mvumi_events_wq {
> + =A0 =A0 =A0 struct work_struct work_q;
> + =A0 =A0 =A0 struct mvumi_hba *mhba;
> + =A0 =A0 =A0 unsigned int event;
> + =A0 =A0 =A0 void *param;
> +};
> +
> +#define MVUMI_MAX_SG_ENTRY =A0 =A0 32
> +#define SGD_EOT =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(1L <=
< 27)
> +
> +struct mvumi_sgl {
> + =A0 =A0 =A0 u32 =A0 =A0 baseaddr_l;
> + =A0 =A0 =A0 u32 =A0 =A0 baseaddr_h;
> + =A0 =A0 =A0 u32 =A0 =A0 flags;
> + =A0 =A0 =A0 u32 =A0 =A0 size;
> +};
> +
> +struct mvumi_res {
> + =A0 =A0 =A0 struct list_head entry;
> + =A0 =A0 =A0 dma_addr_t bus_addr;
> + =A0 =A0 =A0 void *virt_addr;
> + =A0 =A0 =A0 unsigned int size;
> + =A0 =A0 =A0 unsigned short type; =A0 =A0/* enum Resource_Type */
> +};
> +
> +/* Resource type */
> +enum resource_type {
> + =A0 =A0 =A0 RESOURCE_CACHED_MEMORY =3D 0,
> + =A0 =A0 =A0 RESOURCE_UNCACHED_MEMORY
> +};
> +
> +struct mvumi_sense_data {
> + =A0 =A0 =A0 u8 error_eode:7;
> + =A0 =A0 =A0 u8 valid:1;
> + =A0 =A0 =A0 u8 segment_number;
> + =A0 =A0 =A0 u8 sense_key:4;
> + =A0 =A0 =A0 u8 reserved:1;
> + =A0 =A0 =A0 u8 incorrect_length:1;
> + =A0 =A0 =A0 u8 end_of_media:1;
> + =A0 =A0 =A0 u8 file_mark:1;
> + =A0 =A0 =A0 u8 information[4];
> + =A0 =A0 =A0 u8 additional_sense_length;
> + =A0 =A0 =A0 u8 command_specific_information[4];
> + =A0 =A0 =A0 u8 additional_sense_code;
> + =A0 =A0 =A0 u8 additional_sense_code_qualifier;
> + =A0 =A0 =A0 u8 field_replaceable_unit_code;
> + =A0 =A0 =A0 u8 sense_key_specific[3];
> +};
> +
> +/* Request initiator must set the status to REQ_STATUS_PENDING. */
> +#define REQ_STATUS_PENDING =A0 =A0 =A0 =A0 =A0 =A0 0x80
> +
> +struct mvumi_cmd {
> + =A0 =A0 =A0 struct list_head queue_pointer;
> + =A0 =A0 =A0 struct mvumi_msg_frame *frame;
> + =A0 =A0 =A0 struct scsi_cmnd *scmd;
> + =A0 =A0 =A0 atomic_t sync_cmd;
> + =A0 =A0 =A0 void *data_buf;
> + =A0 =A0 =A0 unsigned short request_id;
> + =A0 =A0 =A0 unsigned char cmd_status;
> +};
> +
> +/*
> + * the function type of the in bound frame
> + */
> +#define CL_FUN_SCSI_CMD =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A00x1
> +
> +struct mvumi_msg_frame {
> + =A0 =A0 =A0 u16 device_id;
> + =A0 =A0 =A0 u16 tag;
> + =A0 =A0 =A0 u8 cmd_flag;
> + =A0 =A0 =A0 u8 req_function;
> + =A0 =A0 =A0 u8 cdb_length;
> + =A0 =A0 =A0 u8 sg_counts;
> + =A0 =A0 =A0 u32 data_transfer_length;
> + =A0 =A0 =A0 u16 request_id;
> + =A0 =A0 =A0 u16 reserved1;
> + =A0 =A0 =A0 u8 cdb[MAX_COMMAND_SIZE];
> + =A0 =A0 =A0 u32 payload[1];
> +};
> +
> +/*
> + * the respond flag for data_payload of the out bound frame
> + */
> +#define CL_RSP_FLAG_NODATA =A0 =A0 =A0 =A0 =A0 =A0 0x0
> +#define CL_RSP_FLAG_SENSEDATA =A0 =A0 =A0 =A0 =A00x1
> +
> +struct mvumi_rsp_frame {
> + =A0 =A0 =A0 u16 device_id;
> + =A0 =A0 =A0 u16 tag;
> + =A0 =A0 =A0 u8 req_status;
> + =A0 =A0 =A0 u8 rsp_flag; =A0 =A0/* Indicates the type of Data_Paylo=
ad.*/
> + =A0 =A0 =A0 u16 request_id;
> + =A0 =A0 =A0 u32 payload[1];
> +};
> +
> +struct mvumi_ob_data {
> + =A0 =A0 =A0 struct list_head list;
> + =A0 =A0 =A0 unsigned char data[0];
> +};
> +
> +struct version_info {
> + =A0 =A0 =A0 u32 ver_major;
> + =A0 =A0 =A0 u32 ver_minor;
> + =A0 =A0 =A0 u32 ver_oem;
> + =A0 =A0 =A0 u32 ver_build;
> +};
> +
> +#define FW_MAX_DELAY =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 30
> +#define MVUMI_FW_BUSY =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(1U << 0)
> +#define MVUMI_FW_ATTACH =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0(1U << 1)
> +#define MVUMI_FW_ALLOC =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (1U << 2)
> +
> +/*
> + * State is the state of the MU
> + */
> +#define FW_STATE_IDLE =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00
> +#define FW_STATE_STARTING =A0 =A0 =A0 =A0 =A0 =A0 =A01
> +#define FW_STATE_HANDSHAKING =A0 =A0 =A0 =A0 =A0 2
> +#define FW_STATE_STARTED =A0 =A0 =A0 =A0 =A0 =A0 =A0 3
> +#define FW_STATE_ABORT =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 4
> +
> +#define HANDSHAKE_SIGNATURE =A0 =A0 =A0 =A0 =A0 =A00x5A5A5A5AL
> +#define HANDSHAKE_READYSTATE =A0 =A0 =A0 =A0 =A0 0x55AA5AA5L
> +#define HANDSHAKE_DONESTATE =A0 =A0 =A0 =A0 =A0 =A00x55AAA55AL
> +
> +/* HandShake Status definition */
> +#define HS_STATUS_OK =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1
> +#define HS_STATUS_ERR =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A02
> +#define HS_STATUS_INVALID =A0 =A0 =A0 =A0 =A0 =A0 =A03
> +
> +/* HandShake State/Cmd definition */
> +#define HS_S_START =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1
> +#define HS_S_RESET =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 2
> +#define HS_S_PAGE_ADDR =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 3
> +#define HS_S_QUERY_PAGE =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A04
> +#define HS_S_SEND_PAGE =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 5
> +#define HS_S_END =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 6
> +#define HS_S_ABORT =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 7
> +#define HS_PAGE_VERIFY_SIZE =A0 =A0 =A0 =A0 =A0 =A0128
> +
> +#define HS_GET_STATE(a) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0(a & 0xFFFF)
> +#define HS_GET_STATUS(a) =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((a & 0xFFFF000=
0) >> 16)
> +#define HS_SET_STATE(a, b) =A0 =A0 =A0 =A0 =A0 =A0 (a |=3D (b & 0xFF=
=46F))
> +#define HS_SET_STATUS(a, b) =A0 =A0 =A0 =A0 =A0 =A0(a |=3D ((b & 0xF=
=46FF) << 16))
> +
> +/* handshake frame */
> +struct mvumi_hs_frame {
> + =A0 =A0 =A0 u16 size;
> + =A0 =A0 =A0 /* host information */
> + =A0 =A0 =A0 u8 host_type;
> + =A0 =A0 =A0 u8 reserved_1[1];
> + =A0 =A0 =A0 struct version_info host_ver; /* bios or driver version=
 */
> +
> + =A0 =A0 =A0 /* controller information */
> + =A0 =A0 =A0 u32 system_io_bus;
> + =A0 =A0 =A0 u32 slot_number;
> + =A0 =A0 =A0 u32 intr_level;
> + =A0 =A0 =A0 u32 intr_vector;
> +
> + =A0 =A0 =A0 /* communication list configuration */
> + =A0 =A0 =A0 u32 ib_baseaddr_l;
> + =A0 =A0 =A0 u32 ib_baseaddr_h;
> + =A0 =A0 =A0 u32 ob_baseaddr_l;
> + =A0 =A0 =A0 u32 ob_baseaddr_h;
> +
> + =A0 =A0 =A0 u8 ib_entry_size;
> + =A0 =A0 =A0 u8 ob_entry_size;
> + =A0 =A0 =A0 u8 ob_depth;
> + =A0 =A0 =A0 u8 ib_depth;
> +
> + =A0 =A0 =A0 /* system time */
> + =A0 =A0 =A0 u64 seconds_since1970;
> +};
> +
> +struct mvumi_hs_header {
> + =A0 =A0 =A0 u8 =A0 =A0 =A0page_code;
> + =A0 =A0 =A0 u8 =A0 =A0 =A0checksum;
> + =A0 =A0 =A0 u16 =A0 =A0 frame_length;
> + =A0 =A0 =A0 u32 =A0 =A0 frame_content[1];
> +};
> +
> +/*
> + * the page code type of the handshake header
> + */
> +#define HS_PAGE_FIRM_CAP =A0 =A0 =A0 0x1
> +#define HS_PAGE_HOST_INFO =A0 =A0 =A00x2
> +#define HS_PAGE_FIRM_CTL =A0 =A0 =A0 0x3
> +#define HS_PAGE_CL_INFO =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00x4
> +#define HS_PAGE_TOTAL =A0 =A0 =A0 =A0 =A00x5
> +
> +#define HSP_SIZE(i) =A0 =A0sizeof(struct mvumi_hs_page##i)
> +
> +#define HSP_MAX_SIZE ({ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> + =A0 =A0 =A0 int size, m1, m2; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 \
> + =A0 =A0 =A0 m1 =3D max(HSP_SIZE(1), HSP_SIZE(3)); =A0 =A0 =A0 =A0 =A0=
 =A0 \
> + =A0 =A0 =A0 m2 =3D max(HSP_SIZE(2), HSP_SIZE(4)); =A0 =A0 =A0 =A0 =A0=
 =A0 \
> + =A0 =A0 =A0 size =3D max(m1, m2); =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 \
> + =A0 =A0 =A0 size; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
> +})
> +
> +/* The format of the page code for Firmware capability */
> +struct mvumi_hs_page1 {
> + =A0 =A0 =A0 u8 pagecode;
> + =A0 =A0 =A0 u8 checksum;
> + =A0 =A0 =A0 u16 frame_length;
> +
> + =A0 =A0 =A0 u16 number_of_ports;
> + =A0 =A0 =A0 u16 max_devices_support;
> + =A0 =A0 =A0 u16 max_io_support;
> + =A0 =A0 =A0 u16 umi_ver;
> + =A0 =A0 =A0 u32 max_transfer_size;
> + =A0 =A0 =A0 struct version_info fw_ver;
> + =A0 =A0 =A0 u8 cl_in_max_entry_size;
> + =A0 =A0 =A0 u8 cl_out_max_entry_size;
> + =A0 =A0 =A0 u8 cl_inout_list_depth;
> + =A0 =A0 =A0 u8 total_pages;
> + =A0 =A0 =A0 u16 capability;
> + =A0 =A0 =A0 u16 reserved1;
> +};
> +
> +/* The format of the page code for Host information */
> +struct mvumi_hs_page2 {
> + =A0 =A0 =A0 u8 pagecode;
> + =A0 =A0 =A0 u8 checksum;
> + =A0 =A0 =A0 u16 frame_length;
> +
> + =A0 =A0 =A0 u8 host_type;
> + =A0 =A0 =A0 u8 reserved[3];
> + =A0 =A0 =A0 struct version_info host_ver;
> + =A0 =A0 =A0 u32 system_io_bus;
> + =A0 =A0 =A0 u32 slot_number;
> + =A0 =A0 =A0 u32 intr_level;
> + =A0 =A0 =A0 u32 intr_vector;
> + =A0 =A0 =A0 u64 seconds_since1970;
> +};
> +
> +/* The format of the page code for firmware control =A0*/
> +struct mvumi_hs_page3 {
> + =A0 =A0 =A0 u8 =A0 =A0 =A0pagecode;
> + =A0 =A0 =A0 u8 =A0 =A0 =A0checksum;
> + =A0 =A0 =A0 u16 =A0 =A0 frame_length;
> + =A0 =A0 =A0 u16 =A0 =A0 control;
> + =A0 =A0 =A0 u8 =A0 =A0 =A0reserved[2];
> + =A0 =A0 =A0 u32 =A0 =A0 host_bufferaddr_l;
> + =A0 =A0 =A0 u32 =A0 =A0 host_bufferaddr_h;
> + =A0 =A0 =A0 u32 =A0 =A0 host_eventaddr_l;
> + =A0 =A0 =A0 u32 =A0 =A0 host_eventaddr_h;
> +};
> +
> +struct mvumi_hs_page4 {
> + =A0 =A0 =A0 u8 =A0 =A0 =A0pagecode;
> + =A0 =A0 =A0 u8 =A0 =A0 =A0checksum;
> + =A0 =A0 =A0 u16 =A0 =A0 frame_length;
> + =A0 =A0 =A0 u32 =A0 =A0 ib_baseaddr_l;
> + =A0 =A0 =A0 u32 =A0 =A0 ib_baseaddr_h;
> + =A0 =A0 =A0 u32 =A0 =A0 ob_baseaddr_l;
> + =A0 =A0 =A0 u32 =A0 =A0 ob_baseaddr_h;
> + =A0 =A0 =A0 u8 =A0 =A0 =A0ib_entry_size;
> + =A0 =A0 =A0 u8 =A0 =A0 =A0ob_entry_size;
> + =A0 =A0 =A0 u8 =A0 =A0 =A0ob_depth;
> + =A0 =A0 =A0 u8 =A0 =A0 =A0ib_depth;
> +};
> +
> +struct mvumi_tag {
> + =A0 =A0 =A0 unsigned short *stack;
> + =A0 =A0 =A0 unsigned short top;
> + =A0 =A0 =A0 unsigned short size;
> +};
> +
> +struct mvumi_hba {
> + =A0 =A0 =A0 void *base_addr[MAX_BASE_ADDRESS];
> + =A0 =A0 =A0 void *mmio;
> + =A0 =A0 =A0 struct list_head cmd_pool;
> + =A0 =A0 =A0 struct Scsi_Host *shost;
> + =A0 =A0 =A0 wait_queue_head_t int_cmd_wait_q;
> + =A0 =A0 =A0 struct pci_dev *pdev;
> + =A0 =A0 =A0 unsigned int unique_id;
> + =A0 =A0 =A0 atomic_t fw_outstanding;
> + =A0 =A0 =A0 struct mvumi_instance_template *instancet;
> +
> + =A0 =A0 =A0 void *ib_list;
> + =A0 =A0 =A0 dma_addr_t ib_list_phys;
> +
> + =A0 =A0 =A0 void *ob_list;
> + =A0 =A0 =A0 dma_addr_t ob_list_phys;
> +
> + =A0 =A0 =A0 void *ib_shadow;
> + =A0 =A0 =A0 dma_addr_t ib_shadow_phys;
> +
> + =A0 =A0 =A0 void *ob_shadow;
> + =A0 =A0 =A0 dma_addr_t ob_shadow_phys;
> +
> + =A0 =A0 =A0 void *handshake_page;
> + =A0 =A0 =A0 dma_addr_t handshake_page_phys;
> +
> + =A0 =A0 =A0 unsigned int global_isr;
> + =A0 =A0 =A0 unsigned int isr_status;
> +
> + =A0 =A0 =A0 unsigned short max_sge;
> + =A0 =A0 =A0 unsigned short max_target_id;
> + =A0 =A0 =A0 unsigned char *target_map;
> + =A0 =A0 =A0 unsigned int max_io;
> + =A0 =A0 =A0 unsigned int list_num_io;
> + =A0 =A0 =A0 unsigned int ib_max_size;
> + =A0 =A0 =A0 unsigned int ob_max_size;
> + =A0 =A0 =A0 unsigned int ib_max_size_setting;
> + =A0 =A0 =A0 unsigned int ob_max_size_setting;
> + =A0 =A0 =A0 unsigned int max_transfer_size;
> + =A0 =A0 =A0 unsigned char hba_total_pages;
> + =A0 =A0 =A0 unsigned char fw_flag;
> + =A0 =A0 =A0 unsigned char request_id_enabled;
> + =A0 =A0 =A0 unsigned short hba_capability;
> + =A0 =A0 =A0 unsigned short io_seq;
> +
> + =A0 =A0 =A0 unsigned int ib_cur_slot;
> + =A0 =A0 =A0 unsigned int ob_cur_slot;
> + =A0 =A0 =A0 unsigned int fw_state;
> +
> + =A0 =A0 =A0 struct list_head ob_data_list;
> + =A0 =A0 =A0 struct list_head free_ob_list;
> + =A0 =A0 =A0 struct list_head res_list;
> + =A0 =A0 =A0 struct list_head waiting_req_list;
> +
> + =A0 =A0 =A0 struct mvumi_tag tag_pool;
> + =A0 =A0 =A0 struct mvumi_cmd **tag_cmd;
> +};
> +
> +struct mvumi_instance_template {
> + =A0 =A0 =A0 void (*fire_cmd)(struct mvumi_hba *, struct mvumi_cmd *=
);
> + =A0 =A0 =A0 void (*enable_intr)(void *) ;
> + =A0 =A0 =A0 void (*disable_intr)(void *);
> + =A0 =A0 =A0 int (*clear_intr)(void *);
> + =A0 =A0 =A0 unsigned int (*read_fw_status_reg)(void *);
> +};
> +
> +extern struct timezone sys_tz;
> +#endif
> --
> 1.7.4.4
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
