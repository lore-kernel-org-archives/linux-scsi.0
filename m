From: Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH V9 2/2] scsi: ufs: Add configfs support for UFS provisioning
Date: Thu, 23 Aug 2018 10:19:34 -0700
Message-ID: <CAE=gft4kjaJV9+W1haH6j=8GmTKS4P-YA=2iAdzmF_hm6Us07g@mail.gmail.com>
References: <1534846649-2456-1-git-send-email-sayalil@codeaurora.org> <1534846649-2456-3-git-send-email-sayalil@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1534846649-2456-3-git-send-email-sayalil@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: sayalil@codeaurora.org
Cc: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, Rajendra Nayak <rnayak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, riteshh@codeaurora.org, adrian.hunter@intel.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 21, 2018 at 3:19 AM Sayali Lokhande <sayalil@codeaurora.org> wrote:
>
> This patch adds configfs support to provision UFS device at
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
>    cat /config/XXXX.ufshc/ufs_provision
> 2) To provision ufs device:
>    echo <config_desc_buf> > /config/XXXX.ufshc/ufs_provision
>
> Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
> ---
>  Documentation/ABI/testing/configfs-driver-ufs |  18 +++
>  drivers/scsi/ufs/Kconfig                      |  10 ++
>  drivers/scsi/ufs/Makefile                     |   1 +
>  drivers/scsi/ufs/ufs-configfs.c               | 157 ++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.c                     |   3 +-
>  drivers/scsi/ufs/ufshcd.h                     |  18 +++
>  6 files changed, 206 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/ABI/testing/configfs-driver-ufs
>  create mode 100644 drivers/scsi/ufs/ufs-configfs.c
>
> diff --git a/Documentation/ABI/testing/configfs-driver-ufs b/Documentation/ABI/testing/configfs-driver-ufs
> new file mode 100644
> index 0000000..eeee499c
> --- /dev/null
> +++ b/Documentation/ABI/testing/configfs-driver-ufs
> @@ -0,0 +1,18 @@
> +What:          /config/ufshcd/ufs_provision
> +Date:          Jun 2018
> +KernelVersion: 4.14
> +Description:
> +               This file shows the current ufs configuration descriptor set in device.
> +               This can be used to provision ufs device if bConfigDescrLock is 0.
> +               For more details, refer 14.1.6.3 Configuration Descriptor and
> +               Table 14-12 - Unit Descriptor configurable parameters from specs for
> +               description of each configuration descriptor parameter.
> +               Configuration descriptor buffer needs to be passed in space separated
> +               format specificied as below:
> +               echo <bLength> <bDescriptorIDN> <bConfDescContinue> <bBootEnable>
> +               <bDescrAccessEn> <bInitPowerMode> <bHighPriorityLUN>
> +               <bSecureRemovalType> <bInitActiveICCLevel> <wPeriodicRTCUpdate>
> +               <0Bh:0Fh_ReservedAs_0> <bLUEnable> <bBootLunID> <bLUWriteProtect>
> +               <bMemoryType> <dNumAllocUnits> <bDataReliability> <bLogicalBlockSize>
> +               <bProvisioningType> <wContextCapabilities> <0Dh:0Fh_ReservedAs_0>
> +               > /config/XXXX.ufshc/ufs_provision
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index e27b4d4..a9a0a58 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -100,3 +100,13 @@ config SCSI_UFS_QCOM
>
>           Select this if you have UFS controller on QCOM chipset.
>           If unsure, say N.
> +
> +config UFS_PROVISION
> +       tristate "Runtime UFS Provisioning support"
> +       depends on SCSI_UFSHCD && CONFIGFS_FS
> +       help
> +         This enables runtime UFS provisioning support. This can be used
> +         primarily during assembly line as some devices may be required to
> +         be configured multiple times during initial development phase.
> +
> +         If unsure, say N.
> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> index 918f579..00110ea 100644
> --- a/drivers/scsi/ufs/Makefile
> +++ b/drivers/scsi/ufs/Makefile
> @@ -5,5 +5,6 @@ obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-d
>  obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
>  obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
>  ufshcd-core-objs := ufshcd.o ufs-sysfs.o
> +obj-$(CONFIG_UFS_PROVISION) += ufs-configfs.o
>  obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
>  obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
> diff --git a/drivers/scsi/ufs/ufs-configfs.c b/drivers/scsi/ufs/ufs-configfs.c
> new file mode 100644
> index 0000000..09607e5
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufs-configfs.c
> @@ -0,0 +1,157 @@
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
> +static inline struct ufs_hba *config_item_to_hba(struct config_item *item)
> +{
> +       struct config_group *group = to_config_group(item);
> +       struct configfs_subsystem *subsys = to_configfs_subsystem(group);
> +       struct ufs_hba *hba = container_of(subsys, struct ufs_hba, subsys);
> +
> +       return subsys ? hba : NULL;
> +}
> +
> +static ssize_t ufs_provision_show(struct config_item *item, char *buf)
> +{
> +       u8 desc_buf[QUERY_DESC_CONFIGURATION_DEF_SIZE] = {0};
> +       int buff_len = QUERY_DESC_CONFIGURATION_DEF_SIZE;

This is a nit, but buff_len is really desc_buf_len. It's confusing
because you also do have a buffer named buf, which this variable is
not the length of.

> +       int i, ret, curr_len = 0;
> +       struct ufs_hba *hba = config_item_to_hba(item);
> +
> +       ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_READ_DESC,
> +               QUERY_DESC_IDN_CONFIGURATION, 0, 0, desc_buf, &buff_len);
> +
> +       if (ret)
> +               return ret;
> +
> +       for (i = 0; i < buff_len; i++)
> +               curr_len += snprintf((buf + curr_len), (PAGE_SIZE - curr_len),
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
> +       u8 desc_buf[QUERY_DESC_CONFIGURATION_DEF_SIZE] = {0};
> +       int buff_len = QUERY_DESC_CONFIGURATION_DEF_SIZE;

Same thing here, I suppose.

> +       char *token;
> +       int i, ret, value;
> +       u32 config_desc_lock = 0;
> +
> +       /* reserve one byte for null termination */
> +       strbuf = kmalloc(count + 1, GFP_KERNEL);
> +       if (!strbuf)
> +               return -ENOMEM;
> +
> +       strbuf_copy = strbuf;
> +       strlcpy(strbuf, buf, count + 1);
> +
> +       /* Just return if bConfigDescrLock is already set */
> +       ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +               QUERY_ATTR_IDN_CONF_DESC_LOCK, 0, 0, &config_desc_lock);
> +       if (ret)
> +               goto out;
> +
> +       if (config_desc_lock) {
> +               dev_err(hba->dev, "%s: bConfigDescrLock already set to %u, cannot re-provision device!\n",
> +               __func__, config_desc_lock);
> +               ret = -EINVAL;
> +               goto out;
> +       }
> +
> +       for (i = 0; i < QUERY_DESC_CONFIGURATION_DEF_SIZE; i++) {
> +               token = strsep(&strbuf, " ");
> +               if (!token && i)
> +                       break;

What happens if you pass an empty buffer (eg !token && !i)?
I just tried it. kstrtoint seems to fail gracefully, and I get the
print below. Fine.

> +
> +               ret = kstrtoint(token, 0, &value);
> +               if (ret) {
> +                       dev_err(hba->dev, "%s: kstrtoint failed %d %s\n",
> +                               __func__, ret, token);
> +                       ret = -EINVAL;
> +                       goto out;
> +               }
> +               desc_buf[i] = (u8)value;
> +       }
> +
> +       /* Write configuration descriptor to provision ufs */
> +       ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_WRITE_DESC,
> +               QUERY_DESC_IDN_CONFIGURATION, 0, 0, desc_buf, &buff_len);
> +
> +       if (!ret)
> +               dev_err(hba->dev, "%s: UFS Provisioning done, reboot now!\n",
> +               __func__);

I wonder if this should maybe just be an info or debug message. It's
really not an error, it's a celebration!

> +
> +out:
> +       kfree(strbuf_copy);
> +       if (ret)
> +               return ret;
> +       return count;
> +}
> +
> +static ssize_t ufs_provision_store(struct config_item *item,
> +               const char *buf, size_t count)
> +{
> +       struct ufs_hba *hba = config_item_to_hba(item);
> +
> +       return ufshcd_desc_configfs_store(hba, buf, count);
> +}
> +
> +static struct configfs_attribute ufshcd_attr_provision = {
> +       .ca_name        = "ufs_provision",
> +       .ca_mode        = 0644,
> +       .ca_owner       = THIS_MODULE,
> +       .show           = ufs_provision_show,
> +       .store          = ufs_provision_store,
> +};
> +
> +static struct configfs_attribute *ufshcd_attrs[] = {
> +       &ufshcd_attr_provision,
> +       NULL,
> +};
> +
> +static struct config_item_type ufscfg_type = {
> +       .ct_attrs       = ufshcd_attrs,
> +       .ct_owner       = THIS_MODULE,
> +};
> +
> +static struct configfs_subsystem ufscfg_subsys = {
> +       .su_group = {
> +               .cg_item = {
> +                       .ci_type = &ufscfg_type,
> +               },
> +       },
> +};
> +
> +int ufshcd_configfs_init(struct ufs_hba *hba, const char *name)
> +{
> +       int ret;
> +       struct configfs_subsystem *subsys = &hba->subsys;
> +
> +       strncpy(ufscfg_subsys.su_group.cg_item.ci_namebuf, name, strlen(name));
> +       subsys->su_group = ufscfg_subsys.su_group;
> +       config_group_init(&subsys->su_group);
> +       mutex_init(&subsys->su_mutex);
> +       ret = configfs_register_subsystem(subsys);
> +       if (ret)
> +               pr_err("Error %d while registering subsystem %s\n",
> +                      ret,
> +                      subsys->su_group.cg_item.ci_namebuf);
> +
> +       return ret;
> +}
> +
> +void ufshcd_configfs_exit(void)
> +{
> +       configfs_unregister_subsystem(&ufscfg_subsys);
> +}
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index e946844..11b28bf 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7713,6 +7713,7 @@ int ufshcd_shutdown(struct ufs_hba *hba)
>  void ufshcd_remove(struct ufs_hba *hba)
>  {
>         ufs_sysfs_remove_nodes(hba->dev);
> +       ufshcd_configfs_exit();
>         scsi_remove_host(hba->host);
>         /* disable interrupts */
>         ufshcd_disable_intr(hba, hba->intr_mask);
> @@ -7967,7 +7968,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>
>         async_schedule(ufshcd_async_scan, hba);
>         ufs_sysfs_add_nodes(hba->dev);
> -
> +       ufshcd_configfs_init(hba, dev_name(hba->dev));

You init function has a return int, but you never check it. Either
remove the return type if you consider configfs initialization errors
non-fatal, or check the error here.

>         return 0;
>
>  out_remove_scsi_host:
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 45013b6..c5956b2 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -37,6 +37,7 @@
>  #ifndef _UFSHCD_H
>  #define _UFSHCD_H
>
> +#include <linux/configfs.h>
>  #include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/init.h>
> @@ -515,6 +516,9 @@ struct ufs_hba {
>
>         struct Scsi_Host *host;
>         struct device *dev;
> +#ifdef CONFIG_UFS_PROVISION
> +       struct configfs_subsystem subsys;
> +#endif
>         /*
>          * This field is to keep a reference to "scsi_device" corresponding to
>          * "UFS device" W-LU.
> @@ -868,6 +872,20 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, int desc_index,
>  int ufshcd_hold(struct ufs_hba *hba, bool async);
>  void ufshcd_release(struct ufs_hba *hba);
>
> +/* Expose UFS configfs API's */
> +#ifndef CONFIG_UFS_PROVISION
> +static inline int ufshcd_configfs_init(struct ufs_hba *hba, const char *name)
> +{
> +       return 0;
> +}
> +static inline void ufshcd_configfs_exit(void)
> +{
> +}
> +#else
> +int ufshcd_configfs_init(struct ufs_hba *hba, const char *name);
> +void ufshcd_configfs_exit(void);
> +#endif
> +
>  int ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
>         int *desc_length);
>
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
>
