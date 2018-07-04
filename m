From: Sayali Lokhande <sayalil@codeaurora.org>
Subject: Re: [PATCH V4 3/3] scsi: ufs: Add configfs support for ufs
 provisioning
Date: Wed, 4 Jul 2018 19:28:52 +0530
Message-ID: <e2ae7751-73ee-ad3d-8f33-e1219f36cad8@codeaurora.org>
References: <1529985829-18689-1-git-send-email-sayalil@codeaurora.org>
 <1529985829-18689-4-git-send-email-sayalil@codeaurora.org>
 <CAE=gft662O3oiFJnac-LV+Ne8v7hCdFe0N6cU1rdYkhXpDyWvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAE=gft662O3oiFJnac-LV+Ne8v7hCdFe0N6cU1rdYkhXpDyWvA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Evan Green <evgreen@chromium.org>
Cc: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, Rajendra Nayak <rnayak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, riteshh@codeaurora.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mka@chromium.org
List-Id: linux-scsi@vger.kernel.org

Hi Evan,

On 6/28/2018 12:09 AM, Evan Green wrote:
> Hi Sayali,
>
> On Mon, Jun 25, 2018 at 9:04 PM Sayali Lokhande <sayalil@codeaurora.org> wrote:
>> Add configfs support to provision ufs device at runtime.
>> Usage:
>> echo <desc_buf> > /config/ufshcd/ufs_provision
>> To check provisioning status:
>> cat /config/ufshcd/ufs_provision
>> 1 -> Success (Reboot device to check updated provisioning)
> This commit message could contain a bit more detail, including
> motivation and what goes into desc_buf. Also, the description of
> reading ufs_provision isn't really correct, is it? 1 doesn't indicate
> success, 1 just indicates bConfigDescrLock's value.
Agreed. Will add more details and also update code to show current 
configuration descriptor on reading ufs_provision.
>> Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
>> ---
>>   Documentation/ABI/testing/configfs-driver-ufs |  15 ++
>>   drivers/scsi/ufs/Makefile                     |   1 +
>>   drivers/scsi/ufs/ufs-configfs.c               | 198 ++++++++++++++++++++++++++
>>   drivers/scsi/ufs/ufs.h                        |   2 +
>>   drivers/scsi/ufs/ufshcd.c                     |   2 +
>>   drivers/scsi/ufs/ufshcd.h                     |  18 +++
>>   6 files changed, 236 insertions(+)
>>   create mode 100644 Documentation/ABI/testing/configfs-driver-ufs
>>   create mode 100644 drivers/scsi/ufs/ufs-configfs.c
>>
>> diff --git a/Documentation/ABI/testing/configfs-driver-ufs b/Documentation/ABI/testing/configfs-driver-ufs
>> new file mode 100644
>> index 0000000..f6ef38e
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/configfs-driver-ufs
>> @@ -0,0 +1,15 @@
>> +What:          /config/ufshcd/ufs_provision
>> +Date:          Jun 2018
>> +KernelVersion: 4.14
>> +Description:
>> +               This file shows the status of runtime ufs provisioning.
>> +               This can be used to provision ufs device if bConfigDescrLock is 0.
>> +               Configuration buffer needs to be written in space separated format
>> +               specificied as below:
>> +               echo <bNumberLU> <bBootEnable> <bDescrAccessEn> <bInitPowerMode>
>> +               <bHighPriorityLUN> <bSecureRemovalType> <bInitActiveICCLevel>
>> +               <wPeriodicRTCUpdate> <bConfigDescrLock> <LUNum> <bLUEnable>
>> +               <bBootLunID> <size_in_kb> <bDataReliability> <bLUWriteProtect>
>> +               <bMemoryType> <bLogicalBlockSize> <bProvisioningType>
>> +               <wContextCapabilities> <LUNtoGrow> <commit> <NumofLUNs>
>> +               > /config/ufshcd/ufs_provision
>> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
>> index 918f579..d438e74 100644
>> --- a/drivers/scsi/ufs/Makefile
>> +++ b/drivers/scsi/ufs/Makefile
>> @@ -5,5 +5,6 @@ obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-d
>>   obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
>>   obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
>>   ufshcd-core-objs := ufshcd.o ufs-sysfs.o
>> +obj-$(CONFIG_CONFIGFS_FS) += ufs-configfs.o
>>   obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
>>   obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
>> diff --git a/drivers/scsi/ufs/ufs-configfs.c b/drivers/scsi/ufs/ufs-configfs.c
>> new file mode 100644
>> index 0000000..614b017
>> --- /dev/null
>> +++ b/drivers/scsi/ufs/ufs-configfs.c
>> @@ -0,0 +1,198 @@
>> +/*
>> + * Copyright (c) 2018, Linux Foundation. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + */
> I believe there's a new SPDX license identification that they prefer
> you to use, at least according to:
> https://lwn.net/Articles/739183/
Agreed. Will use correct SPDX License format.
>> +
>> +#include <linux/err.h>
>> +#include <linux/string.h>
>> +#include <asm/unaligned.h>
>> +#include <linux/configfs.h>
> These should be alphabetized.
Agreed. Will update.
>> +
>> +#include "ufs.h"
>> +#include "ufshcd.h"
>> +
>> +struct ufs_hba *hba;
> How does this work if there is more than one UFS controller in the
> system? Given that there are both UFS cards and embedded UFS chips, I
> think multiple controllers needs to be supported.
Agreed. I will remove this global variable and instead pass it along in 
store/show() api's.
Currently I am anyway passing hba as part of ufshcd_configfs_init(hba); 
Will try to use same.
>> +
>> +static ssize_t ufs_provision_show(struct config_item *item, char *buf)
>> +{
>> +       return snprintf(buf, PAGE_SIZE, "provision_enabled = %x\n",
>> +               hba->provision_enabled);
> Why can't this show the current configuration, barring some of the
> weirder parameters like lun_to_grow, which I have comments about
> below. I'm not sure provision_enabled is very useful, given that we
> can already get at this attribute via sysfs.
Agreed. Will get rid of extra added parameters and will update this to 
show current configuration desc.
>> +}
>> +
>> +ssize_t ufshcd_desc_configfs_store(const char *buf, size_t count)
>> +{
>> +       struct ufs_config_descr *cfg = &hba->cfgs;
>> +       char *strbuf;
>> +       char *strbuf_copy;
>> +       int desc_buf[count];
> I believe with configfs, "count" can be up to PAGE_SIZE, which would
> mean usermode could size this array at 16K. That's too big, especially
> since you already know the maximum number of ints you're willing to
> take in, and it's not anywhere near that.
Agreed. Will replace count with actual size of configuration descriptor.
>> +       int *pt;
>> +       char *token;
>> +       int i, ret;
>> +       int value, commit = 0;
>> +       int num_luns = 0;
>> +       int KB_per_block = 4;
> What is this? Is this really fixed across all UFS devices?
Will get rid of these extra parameters added. and instead try to pass 
exact configuration descriptor parameters(as in spec).
>
>> +
>> +       /* reserve one byte for null termination */
>> +       strbuf = kmalloc(count + 1, GFP_KERNEL);
>> +       if (!strbuf)
>> +               return -ENOMEM;
>> +
>> +       strbuf_copy = strbuf;
>> +       strlcpy(strbuf, buf, count + 1);
>> +       memset(desc_buf, 0, count);
> This is zeroing count, which represents the number of characters
> coming in, but desc_buf is an array of ints.
Will update this.
>
>> +
>> +       /* Just return if bConfigDescrLock is already set */
>> +       ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
>> +               QUERY_ATTR_IDN_CONF_DESC_LOCK, 0, 0, &cfg->bConfigDescrLock);
>> +       if (ret) {
>> +               dev_err(hba->dev, "%s: Failed reading bConfigDescrLock %d, cannot re-provision device!\n",
>> +                       __func__, ret);
>> +               hba->provision_enabled = 0;
>> +               goto out;
>> +       }
>> +       if (cfg->bConfigDescrLock == 1) {
> This might just be my paranoia, but I generally prefer checks against
> zero, rather than checks specifically for one.
Ok . Will update it.
>
>> +               dev_err(hba->dev, "%s: bConfigDescrLock already set to %u, cannot re-provision device!\n",
>> +               __func__, cfg->bConfigDescrLock);
>> +               hba->provision_enabled = 0;
>> +               goto out;
>> +       }
>> +
>> +       for (i = 0; i < count; i++) {
>> +               token = strsep(&strbuf, " ");
>> +               if (!token && i) {
>> +                       num_luns = desc_buf[i-1];
>> +                       dev_dbg(hba->dev, "%s: token %s, num_luns %d\n",
>> +                               __func__, token, num_luns);
>> +                       if (num_luns > 8) {
> This is a magic number. Please make a define for this number. Then use
> that define to come up with a maximum size for desc_buf, rather than
> "count". Then you can iterate "i" up to the appropriate number based
> on the number of luns, rather than up to the number of characters in
> the string.
Agreed. I already know size of configuration desc. Will use same instead 
of "count".
>
>> +                               dev_err(hba->dev, "%s: Invalid num_luns %d\n",
>> +                               __func__, num_luns);
>> +                               hba->provision_enabled = 0;
>> +                               goto out;
>> +                       }
> I don't love that there's a num_luns parameter being fed in here at
> all. It would be better in my opinion if you could just faithfully
> pass along the members of the configuration descriptor directly,
> rather than having additional "features" like num_luns, commit, and
> lun_to_grow.
Agreed. Will update code to faithfully accept the entire configuration 
descriptor passed and will remove all extra sw params added (like 
num_luns, commit etc).
>> +                       break;
>> +               }
>> +
>> +               ret = kstrtoint(token, 0, &value);
>> +               if (ret) {
>> +                       dev_err(hba->dev, "%s: kstrtoint failed %d %s\n",
>> +                               __func__, ret, token);
>> +                       break;
>> +               }
>> +               desc_buf[i] = value;
>> +               dev_dbg(hba->dev, " desc_buf[%d] 0x%x", i, desc_buf[i]);
>> +       }
>> +
>> +       /* Fill in the descriptors with parsed configuration data */
>> +       pt = desc_buf;
>> +       cfg->bNumberLU = *pt++;
>> +       cfg->bBootEnable = *pt++;
>> +       cfg->bDescrAccessEn = *pt++;
>> +       cfg->bInitPowerMode = *pt++;
>> +       cfg->bHighPriorityLUN = *pt++;
>> +       cfg->bSecureRemovalType = *pt++;
>> +       cfg->bInitActiveICCLevel = *pt++;
>> +       cfg->wPeriodicRTCUpdate = *pt++;
>> +       cfg->bConfigDescrLock = *pt++;
>> +       dev_dbg(hba->dev, "%s: %u %u %u %u %u %u %u %u %u\n", __func__,
>> +       cfg->bNumberLU, cfg->bBootEnable, cfg->bDescrAccessEn,
>> +       cfg->bInitPowerMode, cfg->bHighPriorityLUN, cfg->bSecureRemovalType,
>> +       cfg->bInitActiveICCLevel, cfg->wPeriodicRTCUpdate,
>> +       cfg->bConfigDescrLock);
>> +
>> +       for (i = 0; i < num_luns; i++) {
>> +               cfg->unit[i].LUNum = *pt++;
>> +               cfg->unit[i].bLUEnable = *pt++;
>> +               cfg->unit[i].bBootLunID = *pt++;
>> +               /* dNumAllocUnits = size_in_kb/KB_per_block */
>> +               cfg->unit[i].dNumAllocUnits = (u32)(*pt++ / KB_per_block);
> It's awkward that pt is an int, since you then divide by 4. That means
> you lose two bits at the top. What if you want a size that includes
> those two bits? Also as per my comment above, if KB_per_block might be
> values other than 4, then you might lose even more bits. Perhaps this
> should just be set to *pt++ directly, rather than the mystery divide.
> It will be up to user mode to read the geometry descriptor to figure
> out how bytes correspond to allocation units.
Agreed. Will get rid of all these calculations from kernel code. Instead 
we can faithfully pass the configuration desc from configfs as is.
All these calculations (if required) can be done beforehand (in 
userspace or via some script).
>> +               cfg->unit[i].bDataReliability = *pt++;
>> +               cfg->unit[i].bLUWriteProtect = *pt++;
>> +               cfg->unit[i].bMemoryType = *pt++;
>> +               cfg->unit[i].bLogicalBlockSize = *pt++;
>> +               cfg->unit[i].bProvisioningType = *pt++;
>> +               cfg->unit[i].wContextCapabilities = *pt++;
>> +       }
> Do you validate that the number of ints you received corresponds to
> the number of LUNs, or does this just put uninitialized kernel stack
> in here? Oh, right, above you attempted to zero out desc_buf. What
> about cfg->unit[i] for i > num_luns?
Will get rid of these calculations here.
>
>> +
>> +       cfg->lun_to_grow = *pt++;
>> +       commit = *pt++;
>> +       cfg->num_luns = *pt;
>> +       dev_dbg(hba->dev, "%s: lun_to_grow %u, commit %u num_luns %u\n",
>> +               __func__, cfg->lun_to_grow, commit, cfg->num_luns);
>> +       if (commit == 1) {
> Is this a common thing in configfs? Why do we need this dry run
> feature, seeing as there's no real validation going on in this
> function anyway.
Will get rid of commit as check.
>> +               ret = ufshcd_do_config_device(hba);
>> +               if (!ret) {
>> +                       hba->provision_enabled = 1;
>> +                       dev_err(hba->dev,
>> +                       "%s: UFS Provisioning completed,num_luns %u, reboot now !\n",
>> +                       __func__, cfg->num_luns);
>> +               }
>> +       } else
>> +               dev_err(hba->dev, "%s: Invalid commit %u\n", __func__, commit);
>> +out:
>> +       kfree(strbuf_copy);
>> +       return count;
>> +}
>> +
>> +static ssize_t ufs_provision_store(struct config_item *item,
>> +               const char *buf, size_t count)
>> +{
>> +       return ufshcd_desc_configfs_store(buf, count);
>> +}
>> +
>> +static struct configfs_attribute ufshcd_attr_provision = {
>> +       .ca_name        = "ufs_provision",
>> +       .ca_mode        = S_IRUGO | S_IWUGO,
>> +       .ca_owner       = THIS_MODULE,
>> +       .show           = ufs_provision_show,
>> +       .store          = ufs_provision_store,
>> +};
>> +
>> +static struct configfs_attribute *ufshcd_attrs[] = {
>> +       &ufshcd_attr_provision,
>> +       NULL,
>> +};
>> +
>> +static struct config_item_type ufscfg_type = {
>> +       .ct_attrs       = ufshcd_attrs,
>> +       .ct_owner       = THIS_MODULE,
>> +};
>> +
>> +static struct configfs_subsystem ufscfg_subsys = {
>> +       .su_group = {
>> +               .cg_item = {
>> +                       .ci_namebuf = "ufshcd",
>> +                       .ci_type = &ufscfg_type,
>> +               },
>> +       },
>> +};
>> +
>> +int ufshcd_configfs_init(struct ufs_hba *hba_ufs)
>> +{
>> +       int ret;
>> +       struct configfs_subsystem *subsys = &ufscfg_subsys;
>> +
>> +       hba = hba_ufs;
>> +       config_group_init(&subsys->su_group);
>> +       mutex_init(&subsys->su_mutex);
>> +       ret = configfs_register_subsystem(subsys);
>> +       if (ret) {
>> +               pr_err("Error %d while registering subsystem %s\n",
>> +                      ret,
>> +                      subsys->su_group.cg_item.ci_namebuf);
>> +       }
>> +       return ret;
>> +}
>> +
>> +void ufshcd_configfs_exit(void)
>> +{
>> +       configfs_unregister_subsystem(&ufscfg_subsys);
>> +}
>> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
>> index 1f99904..0b497fc 100644
>> --- a/drivers/scsi/ufs/ufs.h
>> +++ b/drivers/scsi/ufs/ufs.h
>> @@ -427,6 +427,7 @@ enum {
>>   };
>>
>>   struct ufs_unit_desc {
>> +       u8         LUNum;
>>          u8     bLUEnable;              /* 1 for enabled LU */
>>          u8     bBootLunID;             /* 0 for using this LU for boot */
>>          u8     bLUWriteProtect;        /* 1 = power on WP, 2 = permanent WP */
>> @@ -451,6 +452,7 @@ struct ufs_config_descr {
>>          u32    qVendorConfigCode;      /* Vendor specific configuration code */
>>          struct ufs_unit_desc unit[8];
>>          u8      lun_to_grow;
>> +       u8 num_luns;
>>   };
> I don't like that these structs seem to be a blend of hardware and
> software definitions. For the most part they match the hardware spec,
> but then there are these random software accounting members sprinkled
> in that break that. It would be better if the hardware structures
> could be their own thing, and then additional structures can be
> created if software needs its own accounting. But I'm also not a fan
> of any of the software members here (num_luns, lun_to_grow, and
> LUNum), and I'm hoping we can get rid of them altogether by instead
> providing a more direct configfs interface to the config desciptor.
Will get rid of entire struct and provide more direct configfs interface 
to read/write
exact/entire configuration descriptor.
>>   /* Task management service response */
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 370a7c6..e980d5a 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -7892,6 +7892,7 @@ int ufshcd_shutdown(struct ufs_hba *hba)
>>   void ufshcd_remove(struct ufs_hba *hba)
>>   {
>>          ufs_sysfs_remove_nodes(hba->dev);
>> +       ufshcd_configfs_exit();
>>          scsi_remove_host(hba->host);
>>          /* disable interrupts */
>>          ufshcd_disable_intr(hba, hba->intr_mask);
>> @@ -8145,6 +8146,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>>
>>          async_schedule(ufshcd_async_scan, hba);
>>          ufs_sysfs_add_nodes(hba->dev);
>> +       ufshcd_configfs_init(hba);
>>
>>          return 0;
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>> index 0e6bf30..7d2fa89 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -41,6 +41,7 @@
>>   #include <linux/kernel.h>
>>   #include <linux/init.h>
>>   #include <linux/interrupt.h>
>> +#include <linux/configfs.h>
>>   #include <linux/io.h>
>>   #include <linux/delay.h>
>>   #include <linux/slab.h>
>> @@ -550,6 +551,7 @@ struct ufs_hba {
>>          bool is_irq_enabled;
>>          u32 dev_ref_clk_freq;
>>          struct ufs_config_descr cfgs;
>> +       bool provision_enabled;
>>
>>          /* Interrupt aggregation support is broken */
>>          #define UFSHCD_QUIRK_BROKEN_INTR_AGGR                   0x1
>> @@ -869,6 +871,22 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, int desc_index,
>>   int ufshcd_hold(struct ufs_hba *hba, bool async);
>>   void ufshcd_release(struct ufs_hba *hba);
>>   int ufshcd_do_config_device(struct ufs_hba *hba);
>> +/* Expose UFS configfs API's */
>> +ssize_t ufshcd_desc_configfs_store(const char *buf, size_t count);
>> +
>> +#ifdef CONFIG_CONFIGFS_FS
>> +int ufshcd_configfs_init(struct ufs_hba *hba_ufs);
>> +void ufshcd_configfs_exit(void);
>> +#else /* CONFIG_CONFIGFS_FS */
>> +int ufshcd_configfs_init(struct ufs_hba *hba_ufs)
>> +{
>> +       return 0;
>> +}
>> +
>> +void ufshcd_configfs_exit(void)
>> +{
>> +}
>> +#endif /* CONFIG_CONFIGFS_FS */
>>
>>   int ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
>>          int *desc_length);
>> --
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
>> a Linux Foundation Collaborative Project
>>
Thanks,
Sayali
