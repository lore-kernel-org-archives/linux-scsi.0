From: Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH V5 2/2] scsi: ufs: Add configfs support for ufs provisioning
Date: Mon, 9 Jul 2018 10:48:37 -0700
Message-ID: <CAE=gft5U1-Jo-GvTF7sNAV3Q565AmuUrHpmBdxUL+UwkKxesqA@mail.gmail.com>
References: <1530858040-13971-1-git-send-email-sayalil@codeaurora.org> <1530858040-13971-3-git-send-email-sayalil@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1530858040-13971-3-git-send-email-sayalil@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: sayalil@codeaurora.org
Cc: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, Rajendra Nayak <rnayak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, riteshh@codeaurora.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Sayali,
Thanks for the prompt spin.

On Thu, Jul 5, 2018 at 11:21 PM Sayali Lokhande <sayalil@codeaurora.org> wr=
ote:
>
> This patch adds configfs support to provision ufs device at

s/ufs/UFS/

> runtime. This feature can be primarily useful in factory or
> assembly line as some devices may be required to be configured
> multiple times during initial system development phase.
> Configuration Descriptors can be written multiple times until
> bConfigDescrLock attribute is zero.
>
> Configuration descriptor buffer consists of Device and Unit
> descriptor configurable parameters which are parsed from vendor
> specific provisioning file and then passed via configfs node at
> runtime to provision ufs device.
> CONFIG_CONFIGFS_FS needs to be enabled for using this feature.
>
> Usage:
> 1) To read current configuration descriptor :
>    cat /config/ufshcd/ufs_provision
> 2) To provision ufs device:
>    echo <config_desc_buf> > /config/ufshcd/ufs_provision
>
> Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
> ---
>  Documentation/ABI/testing/configfs-driver-ufs |  18 +++
>  drivers/scsi/ufs/Makefile                     |   1 +
>  drivers/scsi/ufs/ufs-configfs.c               | 172 ++++++++++++++++++++=
++++++
>  drivers/scsi/ufs/ufshcd.c                     |   2 +
>  drivers/scsi/ufs/ufshcd.h                     |  19 +++
>  5 files changed, 212 insertions(+)
>  create mode 100644 Documentation/ABI/testing/configfs-driver-ufs
>  create mode 100644 drivers/scsi/ufs/ufs-configfs.c
>
> diff --git a/Documentation/ABI/testing/configfs-driver-ufs b/Documentatio=
n/ABI/testing/configfs-driver-ufs
> new file mode 100644
> index 0000000..dd16842
> --- /dev/null
> +++ b/Documentation/ABI/testing/configfs-driver-ufs
> @@ -0,0 +1,18 @@
> +What:          /config/ufshcd/ufs_provision
> +Date:          Jun 2018
> +KernelVersion: 4.14
> +Description:
> +               This file shows the current ufs configuration descriptor =
set in device.
> +               This can be used to provision ufs device if bConfigDescrL=
ock is 0.
> +               For more details, refer 14.1.6.3 Configuration Descriptor=
 and
> +               Table 14-12 =E2=80=94 Unit Descriptor configurable parame=
ters from specs for

Can this be a regular dash, rather than some sort of exotic 0xE2 byte.

> +               description of each configuration descriptor parameter.
> +               Configuration descriptor buffer needs to be passed in spa=
ce separated
> +               format specificied as below:
> +               echo <bLength> <bDescriptorIDN> <bConfDescContinue> <bBoo=
tEnable>
> +               <bDescrAccessEn> <bInitPowerMode> <bHighPriorityLUN>
> +               <bSecureRemovalType> <bInitActiveICCLevel> <wPeriodicRTCU=
pdate>
> +               <0Bh:0Fh_ReservedAs_0> <bLUEnable> <bBootLunID> <bLUWrite=
Protect>
> +               <bMemoryType> <dNumAllocUnits> <bDataReliability> <bLogic=
alBlockSize>
> +               <bProvisioningType> <wContextCapabilities> <0Dh:0Fh_Reser=
vedAs_0>

I wonder if at this point we should be using a binary attribute rather
than a text one. Since now you're basically just converting text to
bytes, it's not very human anymore.

> +               > /config/ufshcd/ufs_provision
> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> index 918f579..d438e74 100644
> --- a/drivers/scsi/ufs/Makefile
> +++ b/drivers/scsi/ufs/Makefile
> @@ -5,5 +5,6 @@ obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) +=3D tc-dwc-g210-p=
ltfrm.o ufshcd-dwc.o tc-d
>  obj-$(CONFIG_SCSI_UFS_QCOM) +=3D ufs-qcom.o
>  obj-$(CONFIG_SCSI_UFSHCD) +=3D ufshcd-core.o
>  ufshcd-core-objs :=3D ufshcd.o ufs-sysfs.o
> +obj-$(CONFIG_CONFIGFS_FS) +=3D ufs-configfs.o
>  obj-$(CONFIG_SCSI_UFSHCD_PCI) +=3D ufshcd-pci.o
>  obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) +=3D ufshcd-pltfrm.o
> diff --git a/drivers/scsi/ufs/ufs-configfs.c b/drivers/scsi/ufs/ufs-confi=
gfs.c
> new file mode 100644
> index 0000000..7d207fc
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufs-configfs.c
> @@ -0,0 +1,172 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +// Copyright (c) 2018, Linux Foundation.
> +
> +#include <linux/configfs.h>
> +#include <linux/err.h>
> +#include <linux/string.h>
> +
> +#include "ufs.h"
> +#include "ufshcd.h"
> +
> +static inline struct ufs_hba *config_item_to_hba(struct config_item *ite=
m)
> +{
> +       struct config_group *group =3D to_config_group(item);
> +       struct configfs_subsystem *subsys =3D to_configfs_subsystem(group=
);
> +       struct ufs_hba *hba =3D container_of(subsys, struct ufs_hba, subs=
ys);
> +
> +       return hba ? hba : NULL;
> +}
> +
> +static ssize_t ufs_provision_show(struct config_item *item, char *buf)
> +{
> +       u8 desc_buf[QUERY_DESC_CONFIGURATION_DEF_SIZE] =3D {0};
> +       int buff_len =3D QUERY_DESC_CONFIGURATION_DEF_SIZE;
> +       int i, ret, curr_len =3D 0;
> +       struct ufs_hba *hba =3D config_item_to_hba(item);
> +
> +       if (!hba)
> +               return snprintf(buf, PAGE_SIZE, "ufs hba is NULL!\n");
> +
> +       ret =3D ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_READ=
_DESC,
> +               QUERY_DESC_IDN_CONFIGURATION, 0, 0, desc_buf, &buff_len);
> +
> +       if (ret)
> +               return snprintf(buf, PAGE_SIZE,
> +               "Failed reading descriptor. desc_idn %d, opcode %x ret %d=
\n",
> +               QUERY_DESC_IDN_CONFIGURATION,
> +               UPIU_QUERY_OPCODE_READ_DESC, ret);
> +
> +       for (i =3D 0; i < buff_len; i++)
> +               curr_len +=3D snprintf((buf + curr_len), (PAGE_SIZE - cur=
r_len),
> +                               "0x%x ", desc_buf[i]);
> +
> +       return curr_len;
> +}
> +
> +ssize_t ufshcd_desc_configfs_store(struct ufs_hba *hba,
> +               const char *buf, size_t count)
> +{
> +       char *strbuf;
> +       char *strbuf_copy;
> +       u8 desc_buf[QUERY_DESC_CONFIGURATION_DEF_SIZE] =3D {0};
> +       int buff_len =3D QUERY_DESC_CONFIGURATION_DEF_SIZE;
> +       char *token;
> +       int i, ret, value;
> +       u32 bConfigDescrLock =3D 0;
> +
> +       /* reserve one byte for null termination */
> +       strbuf =3D kmalloc(count + 1, GFP_KERNEL);
> +       if (!strbuf)
> +               return -ENOMEM;
> +
> +       strbuf_copy =3D strbuf;
> +       strlcpy(strbuf, buf, count + 1);
> +
> +       if (!hba)
> +               goto out;
> +
> +       /* Just return if bConfigDescrLock is already set */
> +       ret =3D ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +               QUERY_ATTR_IDN_CONF_DESC_LOCK, 0, 0, &bConfigDescrLock);
> +       if (ret) {
> +               dev_err(hba->dev, "%s: Failed reading bConfigDescrLock %d=
, cannot re-provision device!\n",
> +                       __func__, ret);

I think ufshcd_query_attr has its own prints on failure, we probably
don't need this one.

> +               goto out;
> +       }
> +       if (bConfigDescrLock) {
> +               dev_err(hba->dev, "%s: bConfigDescrLock already set to %u=
, cannot re-provision device!\n",
> +               __func__, bConfigDescrLock);
> +               goto out;
> +       }
> +
> +       for (i =3D 0; i < QUERY_DESC_CONFIGURATION_DEF_SIZE; i++) {
> +               token =3D strsep(&strbuf, " ");
> +               if (!token && i) {
> +                       dev_dbg(hba->dev, "%s: token %s, i %d\n",
> +                               __func__, token, i);

You're printing token, which you know to be null. Is this print really usef=
ul?

> +                       break;
> +               }
> +
> +               ret =3D kstrtoint(token, 0, &value);
> +               if (ret) {
> +                       dev_err(hba->dev, "%s: kstrtoint failed %d %s\n",
> +                               __func__, ret, token);
> +                       break;
> +               }
> +               desc_buf[i] =3D (u8)value;
> +               dev_dbg(hba->dev, " desc_buf[%d] 0x%x", i, desc_buf[i]);

This print is probably a bit noisy. If you really want to dump the
contents in the debug spew there's a print_hex_dump you can do after
you break out of the loop. Then you could also remove the print for
"token %s, i %d".

> +       }
> +
> +       /* Write configuration descriptor to provision ufs */
> +       ret =3D ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_WRIT=
E_DESC,
> +               QUERY_DESC_IDN_CONFIGURATION, 0, 0, desc_buf, &buff_len);
> +
> +       if (ret)
> +               dev_err(hba->dev, "%s: Failed writing descriptor. desc_id=
n %d, opcode %x ret %d\n",
> +               __func__, QUERY_DESC_IDN_CONFIGURATION,
> +               UPIU_QUERY_OPCODE_WRITE_DESC, ret);

This is basically already covered by prints inside
ufshcd_query_descriptor_retry.

> +       else
> +               dev_err(hba->dev, "%s: UFS Provisioning done, reboot now!=
\n",
> +               __func__);
> +
> +out:
> +       kfree(strbuf_copy);
> +       return count;
> +}
> +
> +static ssize_t ufs_provision_store(struct config_item *item,
> +               const char *buf, size_t count)
> +{
> +       struct ufs_hba *hba =3D config_item_to_hba(item);
> +
> +       return ufshcd_desc_configfs_store(hba, buf, count);
> +}
> +
> +static struct configfs_attribute ufshcd_attr_provision =3D {
> +       .ca_name        =3D "ufs_provision",
> +       .ca_mode        =3D 0666,

This seems too permissive. You don't want just anybody to be able to
re-provision the disk. Maybe 0644?

> +       .ca_owner       =3D THIS_MODULE,
> +       .show           =3D ufs_provision_show,
> +       .store          =3D ufs_provision_store,
> +};
> +
> +static struct configfs_attribute *ufshcd_attrs[] =3D {
> +       &ufshcd_attr_provision,
> +       NULL,
> +};
> +
> +static struct config_item_type ufscfg_type =3D {
> +       .ct_attrs       =3D ufshcd_attrs,
> +       .ct_owner       =3D THIS_MODULE,
> +};
> +
> +static struct configfs_subsystem ufscfg_subsys =3D {
> +       .su_group =3D {
> +               .cg_item =3D {
> +                       .ci_namebuf =3D "ufshcd",
> +                       .ci_type =3D &ufscfg_type,
> +               },
> +       },
> +};
> +
> +int ufshcd_configfs_init(struct ufs_hba *hba)
> +{
> +       int ret;
> +       struct configfs_subsystem *subsys =3D &hba->subsys;
> +
> +       subsys->su_group =3D ufscfg_subsys.su_group;
> +       config_group_init(&subsys->su_group);
> +       mutex_init(&subsys->su_mutex);
> +       ret =3D configfs_register_subsystem(subsys);

Wait so for every host controller, you register a subsystem called
"ufshcd"? Won't that result in a naming conflict when the second
controller comes along? I was expecting to see subsystem registration
happen once, probably in a driver init function, and then some sort of
device specific registration happen here. You'd need a unique name for
each controller, maybe the device name itself?

-Evan
