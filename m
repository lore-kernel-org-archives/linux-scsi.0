From: Sayali Lokhande <sayalil@codeaurora.org>
Subject: Re: [PATCH V5 2/2] scsi: ufs: Add configfs support for ufs
 provisioning
Date: Mon, 16 Jul 2018 13:40:21 +0530
Message-ID: <0dce9e9c-4f93-9857-72ee-f65ff195c41a@codeaurora.org>
References: <1530858040-13971-1-git-send-email-sayalil@codeaurora.org>
 <1530858040-13971-3-git-send-email-sayalil@codeaurora.org>
 <CAE=gft5U1-Jo-GvTF7sNAV3Q565AmuUrHpmBdxUL+UwkKxesqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAE=gft5U1-Jo-GvTF7sNAV3Q565AmuUrHpmBdxUL+UwkKxesqA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Evan Green <evgreen@chromium.org>
Cc: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, Rajendra Nayak <rnayak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, riteshh@codeaurora.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Evan,


On 7/9/2018 11:18 PM, Evan Green wrote:
> Hi Sayali,
> Thanks for the prompt spin.
>
> On Thu, Jul 5, 2018 at 11:21 PM Sayali Lokhande <sayalil@codeaurora.org> wrote:
>> This patch adds configfs support to provision ufs device at
> s/ufs/UFS/
Will update.
>> runtime. This feature can be primarily useful in factory or
>> assembly line as some devices may be required to be configured
>> multiple times during initial system development phase.
>> Configuration Descriptors can be written multiple times until
>> bConfigDescrLock attribute is zero.
>>
>> Configuration descriptor buffer consists of Device and Unit
>> descriptor configurable parameters which are parsed from vendor
>> specific provisioning file and then passed via configfs node at
>> runtime to provision ufs device.
>> CONFIG_CONFIGFS_FS needs to be enabled for using this feature.
>>
>> Usage:
>> 1) To read current configuration descriptor :
>>     cat /config/ufshcd/ufs_provision
>> 2) To provision ufs device:
>>     echo <config_desc_buf> > /config/ufshcd/ufs_provision
>>
>> Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
>> ---
>>   Documentation/ABI/testing/configfs-driver-ufs |  18 +++
>>   drivers/scsi/ufs/Makefile                     |   1 +
>>   drivers/scsi/ufs/ufs-configfs.c               | 172 ++++++++++++++++++++++++++
>>   drivers/scsi/ufs/ufshcd.c                     |   2 +
>>   drivers/scsi/ufs/ufshcd.h                     |  19 +++
>>   5 files changed, 212 insertions(+)
>>   create mode 100644 Documentation/ABI/testing/configfs-driver-ufs
>>   create mode 100644 drivers/scsi/ufs/ufs-configfs.c
>>
>> diff --git a/Documentation/ABI/testing/configfs-driver-ufs b/Documentation/ABI/testing/configfs-driver-ufs
>> new file mode 100644
>> index 0000000..dd16842
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/configfs-driver-ufs
>> @@ -0,0 +1,18 @@
>> +What:          /config/ufshcd/ufs_provision
>> +Date:          Jun 2018
>> +KernelVersion: 4.14
>> +Description:
>> +               This file shows the current ufs configuration descriptor set in device.
>> +               This can be used to provision ufs device if bConfigDescrLock is 0.
>> +               For more details, refer 14.1.6.3 Configuration Descriptor and
>> +               Table 14-12 — Unit Descriptor configurable parameters from specs for
> Can this be a regular dash, rather than some sort of exotic 0xE2 byte.
>
>> +               description of each configuration descriptor parameter.
>> +               Configuration descriptor buffer needs to be passed in space separated
>> +               format specificied as below:
>> +               echo <bLength> <bDescriptorIDN> <bConfDescContinue> <bBootEnable>
>> +               <bDescrAccessEn> <bInitPowerMode> <bHighPriorityLUN>
>> +               <bSecureRemovalType> <bInitActiveICCLevel> <wPeriodicRTCUpdate>
>> +               <0Bh:0Fh_ReservedAs_0> <bLUEnable> <bBootLunID> <bLUWriteProtect>
>> +               <bMemoryType> <dNumAllocUnits> <bDataReliability> <bLogicalBlockSize>
>> +               <bProvisioningType> <wContextCapabilities> <0Dh:0Fh_ReservedAs_0>
> I wonder if at this point we should be using a binary attribute rather
> than a text one. Since now you're basically just converting text to
> bytes, it's not very human anymore.
Use of binary attr was ruled out before. Pasting previous comments from 
Greg :
"binary attributes are meant for hardware value pass-through" type stuff.
Unless this is "raw" data straight from the hardware, binary does not work.
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
>> index 0000000..7d207fc
>> --- /dev/null
>> +++ b/drivers/scsi/ufs/ufs-configfs.c
>> @@ -0,0 +1,172 @@
>> +// SPDX-License-Identifier: GPL-2.0+
>> +// Copyright (c) 2018, Linux Foundation.
>> +
>> +#include <linux/configfs.h>
>> +#include <linux/err.h>
>> +#include <linux/string.h>
>> +
>> +#include "ufs.h"
>> +#include "ufshcd.h"
>> +
>> +static inline struct ufs_hba *config_item_to_hba(struct config_item *item)
>> +{
>> +       struct config_group *group = to_config_group(item);
>> +       struct configfs_subsystem *subsys = to_configfs_subsystem(group);
>> +       struct ufs_hba *hba = container_of(subsys, struct ufs_hba, subsys);
>> +
>> +       return hba ? hba : NULL;
>> +}
>> +
>> +static ssize_t ufs_provision_show(struct config_item *item, char *buf)
>> +{
>> +       u8 desc_buf[QUERY_DESC_CONFIGURATION_DEF_SIZE] = {0};
>> +       int buff_len = QUERY_DESC_CONFIGURATION_DEF_SIZE;
>> +       int i, ret, curr_len = 0;
>> +       struct ufs_hba *hba = config_item_to_hba(item);
>> +
>> +       if (!hba)
>> +               return snprintf(buf, PAGE_SIZE, "ufs hba is NULL!\n");
>> +
>> +       ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_READ_DESC,
>> +               QUERY_DESC_IDN_CONFIGURATION, 0, 0, desc_buf, &buff_len);
>> +
>> +       if (ret)
>> +               return snprintf(buf, PAGE_SIZE,
>> +               "Failed reading descriptor. desc_idn %d, opcode %x ret %d\n",
>> +               QUERY_DESC_IDN_CONFIGURATION,
>> +               UPIU_QUERY_OPCODE_READ_DESC, ret);
>> +
>> +       for (i = 0; i < buff_len; i++)
>> +               curr_len += snprintf((buf + curr_len), (PAGE_SIZE - curr_len),
>> +                               "0x%x ", desc_buf[i]);
>> +
>> +       return curr_len;
>> +}
>> +
>> +ssize_t ufshcd_desc_configfs_store(struct ufs_hba *hba,
>> +               const char *buf, size_t count)
>> +{
>> +       char *strbuf;
>> +       char *strbuf_copy;
>> +       u8 desc_buf[QUERY_DESC_CONFIGURATION_DEF_SIZE] = {0};
>> +       int buff_len = QUERY_DESC_CONFIGURATION_DEF_SIZE;
>> +       char *token;
>> +       int i, ret, value;
>> +       u32 bConfigDescrLock = 0;
>> +
>> +       /* reserve one byte for null termination */
>> +       strbuf = kmalloc(count + 1, GFP_KERNEL);
>> +       if (!strbuf)
>> +               return -ENOMEM;
>> +
>> +       strbuf_copy = strbuf;
>> +       strlcpy(strbuf, buf, count + 1);
>> +
>> +       if (!hba)
>> +               goto out;
>> +
>> +       /* Just return if bConfigDescrLock is already set */
>> +       ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
>> +               QUERY_ATTR_IDN_CONF_DESC_LOCK, 0, 0, &bConfigDescrLock);
>> +       if (ret) {
>> +               dev_err(hba->dev, "%s: Failed reading bConfigDescrLock %d, cannot re-provision device!\n",
>> +                       __func__, ret);
> I think ufshcd_query_attr has its own prints on failure, we probably
> don't need this one.
Will check and update.
>> +               goto out;
>> +       }
>> +       if (bConfigDescrLock) {
>> +               dev_err(hba->dev, "%s: bConfigDescrLock already set to %u, cannot re-provision device!\n",
>> +               __func__, bConfigDescrLock);
>> +               goto out;
>> +       }
>> +
>> +       for (i = 0; i < QUERY_DESC_CONFIGURATION_DEF_SIZE; i++) {
>> +               token = strsep(&strbuf, " ");
>> +               if (!token && i) {
>> +                       dev_dbg(hba->dev, "%s: token %s, i %d\n",
>> +                               __func__, token, i);
> You're printing token, which you know to be null. Is this print really useful?
Will check and update/remove this print.
>> +                       break;
>> +               }
>> +
>> +               ret = kstrtoint(token, 0, &value);
>> +               if (ret) {
>> +                       dev_err(hba->dev, "%s: kstrtoint failed %d %s\n",
>> +                               __func__, ret, token);
>> +                       break;
>> +               }
>> +               desc_buf[i] = (u8)value;
>> +               dev_dbg(hba->dev, " desc_buf[%d] 0x%x", i, desc_buf[i]);
> This print is probably a bit noisy. If you really want to dump the
> contents in the debug spew there's a print_hex_dump you can do after
> you break out of the loop. Then you could also remove the print for
> "token %s, i %d".
Will check and update.
>> +       }
>> +
>> +       /* Write configuration descriptor to provision ufs */
>> +       ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_WRITE_DESC,
>> +               QUERY_DESC_IDN_CONFIGURATION, 0, 0, desc_buf, &buff_len);
>> +
>> +       if (ret)
>> +               dev_err(hba->dev, "%s: Failed writing descriptor. desc_idn %d, opcode %x ret %d\n",
>> +               __func__, QUERY_DESC_IDN_CONFIGURATION,
>> +               UPIU_QUERY_OPCODE_WRITE_DESC, ret);
> This is basically already covered by prints inside
> ufshcd_query_descriptor_retry.
Will update.
>> +       else
>> +               dev_err(hba->dev, "%s: UFS Provisioning done, reboot now!\n",
>> +               __func__);
>> +
>> +out:
>> +       kfree(strbuf_copy);
>> +       return count;
>> +}
>> +
>> +static ssize_t ufs_provision_store(struct config_item *item,
>> +               const char *buf, size_t count)
>> +{
>> +       struct ufs_hba *hba = config_item_to_hba(item);
>> +
>> +       return ufshcd_desc_configfs_store(hba, buf, count);
>> +}
>> +
>> +static struct configfs_attribute ufshcd_attr_provision = {
>> +       .ca_name        = "ufs_provision",
>> +       .ca_mode        = 0666,
> This seems too permissive. You don't want just anybody to be able to
> re-provision the disk. Maybe 0644?
Agreed. will update.
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
>> +int ufshcd_configfs_init(struct ufs_hba *hba)
>> +{
>> +       int ret;
>> +       struct configfs_subsystem *subsys = &hba->subsys;
>> +
>> +       subsys->su_group = ufscfg_subsys.su_group;
>> +       config_group_init(&subsys->su_group);
>> +       mutex_init(&subsys->su_mutex);
>> +       ret = configfs_register_subsystem(subsys);
> Wait so for every host controller, you register a subsystem called
> "ufshcd"? Won't that result in a naming conflict when the second
> controller comes along? I was expecting to see subsystem registration
> happen once, probably in a driver init function, and then some sort of
> device specific registration happen here. You'd need a unique name for
> each controller, maybe the device name itself?
Agreed. Will check and pass device name itself during init.
> -Evan
