From: Sayali Lokhande <sayalil@codeaurora.org>
Subject: Re: [PATCH V12 2/2] scsi: ufs: Add configfs support for UFS
 provisioning
Date: Fri, 14 Sep 2018 14:24:34 +0530
Message-ID: <eed77b9a-6d57-37f8-7621-cb2aa0021672@codeaurora.org>
References: <1535626003-4966-1-git-send-email-sayalil@codeaurora.org>
 <1535626003-4966-3-git-send-email-sayalil@codeaurora.org>
 <b1a8913e-5baf-0bf1-96a4-c502c5ba733f@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b1a8913e-5baf-0bf1-96a4-c502c5ba733f@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Hunter <adrian.hunter@intel.com>, subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, evgreen@chromium.org, riteshh@codeaurora.org
Cc: stummala@codeaurora.org, jlbec@evilplan.org, linux-scsi@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On 9/12/2018 6:44 PM, Adrian Hunter wrote:
> On 30/08/18 13:46, Sayali Lokhande wrote:
>> This patch adds configfs support to provision UFS device at
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
>> CONFIG_CONFIGFS_FS and CONFIG_UFS_PROVISION needs to be enabled
>> for using this feature.
>>
>> Usage:
>> 1) To read current configuration descriptor with index X
>>     (where index X can be 0/1/2/3) :
>>     cat /config/XXXX.ufshc/ufs_config_desc_X
> Device name could be nearly anything, not necessarily in the form
> XXXX.ufshc, so maybe make this :
>
>      cat /config/<device name>/ufs_config_desc_X
Done.
>> 2) To write configuration descriptor with index X :
>>     echo <config_desc_buf> > /config/XXXX.ufshc/ufs_config_desc_X
> Ditto
Done.
>> Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
>> ---
>>   Documentation/ABI/testing/configfs-driver-ufs |  12 ++
>>   drivers/scsi/ufs/Kconfig                      |  10 ++
>>   drivers/scsi/ufs/Makefile                     |   1 +
>>   drivers/scsi/ufs/ufs-configfs.c               | 232 ++++++++++++++++++++++++++
>>   drivers/scsi/ufs/ufshcd.c                     |   3 +-
>>   drivers/scsi/ufs/ufshcd.h                     |  17 ++
>>   6 files changed, 274 insertions(+), 1 deletion(-)
>>   create mode 100644 Documentation/ABI/testing/configfs-driver-ufs
>>   create mode 100644 drivers/scsi/ufs/ufs-configfs.c
>>
>> diff --git a/Documentation/ABI/testing/configfs-driver-ufs b/Documentation/ABI/testing/configfs-driver-ufs
>> new file mode 100644
>> index 0000000..4302d57
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/configfs-driver-ufs
>> @@ -0,0 +1,12 @@
>> +What:		/config/*/ufs_config_desc_X
>> +Date:		Jun 2018
>> +KernelVersion:	4.19
> 4.20 now
Done.
>> +Description:
>> +		This file shows bytes of the current ufs configuration descriptor
>> +		with index X (where X = 0/1/2/3) set in device. This can be used to
>> +		provision ufs device if bConfigDescrLock is 0.
>> +		For more details, refer 14.1.6.3 Configuration Descriptor and
>> +		table 14-12 - Unit Descriptor configurable parameters from specs for
>> +		description and format of each configuration descriptor parameter.
>> +		Parameters of Configuration descriptor buffer for respective index
>> +		needs to be passed as bytes in space separated format.
>> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
>> index e27b4d4..a9a0a58 100644
>> --- a/drivers/scsi/ufs/Kconfig
>> +++ b/drivers/scsi/ufs/Kconfig
>> @@ -100,3 +100,13 @@ config SCSI_UFS_QCOM
>>   
>>   	  Select this if you have UFS controller on QCOM chipset.
>>   	  If unsure, say N.
>> +
>> +config UFS_PROVISION
> Better if this is config SCSI_UFS_PROVISION to avoid mixups with UFS filesystem
Done.
>> +	tristate "Runtime UFS Provisioning support"
> tristate won't work with what you have.  It will have to be bool
Done.
>> +	depends on SCSI_UFSHCD && CONFIGFS_FS
>> +	help
>> +	  This enables runtime UFS provisioning support. This can be used
>> +	  primarily during assembly line as some devices may be required to
>> +	  be configured multiple times during initial development phase.
>> +
>> +	  If unsure, say N.
>> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
>> index 918f579..00110ea 100644
>> --- a/drivers/scsi/ufs/Makefile
>> +++ b/drivers/scsi/ufs/Makefile
>> @@ -5,5 +5,6 @@ obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-d
>>   obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
>>   obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
>>   ufshcd-core-objs := ufshcd.o ufs-sysfs.o
>> +obj-$(CONFIG_UFS_PROVISION) += ufs-configfs.o
>>   obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
>>   obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
>> diff --git a/drivers/scsi/ufs/ufs-configfs.c b/drivers/scsi/ufs/ufs-configfs.c
>> new file mode 100644
>> index 0000000..a2c09c7
>> --- /dev/null
>> +++ b/drivers/scsi/ufs/ufs-configfs.c
>> @@ -0,0 +1,232 @@
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
>> +	struct config_group *group = to_config_group(item);
>> +	struct configfs_subsystem *subsys = to_configfs_subsystem(group);
>> +	struct ufs_hba *hba = container_of(subsys, struct ufs_hba, subsys);
>> +
>> +	return hba;
>> +}
>> +
>> +static ssize_t ufs_config_desc_show(struct config_item *item, char *buf,
>> +		u8 index)
>> +{
>> +	struct ufs_hba *hba = config_item_to_hba(item);
>> +	u8 *desc_buf = NULL;
>> +	int desc_buf_len = hba->desc_size.conf_desc;
>> +	int i, ret, curr_len = 0;
>> +
>> +	desc_buf = kzalloc(desc_buf_len, GFP_KERNEL);
>> +	if (!desc_buf)
>> +		return -ENOMEM;
>> +
>> +	ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_READ_DESC,
>> +		QUERY_DESC_IDN_CONFIGURATION, index, 0,
>> +		desc_buf, &desc_buf_len);
>> +	if (ret)
>> +		goto out;
>> +
>> +	for (i = 0; i < desc_buf_len; i++)
>> +		curr_len += snprintf((buf + curr_len), (PAGE_SIZE - curr_len),
>> +				"0x%x ", desc_buf[i]);
>> +
>> +out:
>> +	kfree(desc_buf);
>> +	if (ret)
>> +		return ret;
>> +	return curr_len;
> Could be:
>
> 	return ret ?: curr_len;
Done.
>> +}
>> +
>> +ssize_t ufshcd_desc_configfs_store(struct config_item *item,
>> +		const char *buf, size_t count, u8 index)
>> +{
>> +	char *strbuf;
>> +	char *strbuf_copy;
>> +	struct ufs_hba *hba = config_item_to_hba(item);
>> +	u8 *desc_buf = NULL;
>> +	int desc_buf_len = hba->desc_size.conf_desc;
>> +	char *token;
>> +	int i, ret;
>> +	u8 value;
>> +	u32 config_desc_lock = 0;
>> +
>> +	desc_buf = kzalloc(desc_buf_len, GFP_KERNEL);
>> +	if (!desc_buf)
>> +		return -ENOMEM;
>> +
>> +	/* reserve one byte for null termination */
>> +	strbuf = kmalloc(count + 1, GFP_KERNEL);
> buf is null-terminated so just use kstrdup()
Done.
>> +	if (!strbuf) {
>> +		ret = -ENOMEM;
>> +		goto out;
>> +	}
>> +
>> +	strbuf_copy = strbuf;
>> +	strlcpy(strbuf, buf, count + 1);
>> +
>> +	/* Just return if bConfigDescrLock is already set */
>> +	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
>> +		QUERY_ATTR_IDN_CONF_DESC_LOCK, 0, 0, &config_desc_lock);
>> +	if (ret)
>> +		goto out;
>> +
>> +	if (config_desc_lock) {
>> +		dev_err(hba->dev, "%s: bConfigDescrLock already set to %u, cannot re-provision device!\n",
>> +		__func__, config_desc_lock);
> Indenting is not ideal.  Consider some of the suggestions of:
> scripts/checkpatch.pl --strict
>
>> +		ret = -EINVAL;
>> +		goto out;
>> +	}
>> +
>> +	for (i = 0; i < desc_buf_len; i++) {
>> +		token = strsep(&strbuf_copy, " ");
>> +		if (!token && i)
> What is 'i' doing here?
Its not needed now. Will remove. (earlier I had some debug prints which 
used i).
> If the user does not supply enough bytes, the remainder will be overwritten
> by 0 which doesn't seem ideal.  It would be better to read desc_buf first.
Ok. Will first read the current config desc and then update with user 
passed parameters.
In this way, if user supplied bytes are less than desc length, we will 
retain the remaining old
configuration.
>> +			break;
>> +
>> +		ret = kstrtou8(token, 0, &value);
>> +		if (ret) {
>> +			dev_err(hba->dev, "%s: kstrtou8 failed %d %s\n",
> User may not understand 'kstrtou8'.  'Invalid value %s writing UFS
> configuration descriptor %u' would be better.
Done.
>> +				__func__, ret, token);
>> +			ret = -EINVAL;
>> +			goto out;
>> +		}
>> +		desc_buf[i] = value;
>> +	}
>> +
>> +	/* Write configuration descriptor to provision ufs */
>> +	ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_WRITE_DESC,
>> +		QUERY_DESC_IDN_CONFIGURATION, index, 0,
>> +		desc_buf, &desc_buf_len);
>> +	if (!ret)
>> +		dev_info(hba->dev, "%s: UFS Configuration Descriptor %u written\n",
>> +		__func__, index);
>> +
>> +out:
>> +	kfree(strbuf);
>> +	kfree(desc_buf);
>> +	if (ret)
>> +		return ret;
>> +	return count;
> Could be:
>
> 	return ret ?: count;
Done.
>> +}
>> +
>> +static ssize_t ufs_config_desc_0_show(struct config_item *item, char *buf)
>> +{
>> +	return ufs_config_desc_show(item, buf, 0);
>> +}
>> +
>> +static ssize_t ufs_config_desc_0_store(struct config_item *item,
>> +		const char *buf, size_t count)
>> +{
>> +	return ufshcd_desc_configfs_store(item, buf, count, 0);
>> +}
>> +
>> +static ssize_t ufs_config_desc_1_show(struct config_item *item, char *buf)
>> +{
>> +	return ufs_config_desc_show(item, buf, 1);
>> +}
>> +
>> +static ssize_t ufs_config_desc_1_store(struct config_item *item,
>> +		const char *buf, size_t count)
>> +{
>> +	return ufshcd_desc_configfs_store(item, buf, count, 1);
>> +}
>> +
>> +static ssize_t ufs_config_desc_2_show(struct config_item *item, char *buf)
>> +{
>> +	return ufs_config_desc_show(item, buf, 2);
>> +}
>> +
>> +static ssize_t ufs_config_desc_2_store(struct config_item *item,
>> +		const char *buf, size_t count)
>> +{
>> +	return ufshcd_desc_configfs_store(item, buf, count, 2);
>> +}
>> +
>> +static ssize_t ufs_config_desc_3_show(struct config_item *item, char *buf)
>> +{
>> +	return ufs_config_desc_show(item, buf, 3);
>> +}
>> +
>> +static ssize_t ufs_config_desc_3_store(struct config_item *item,
>> +		const char *buf, size_t count)
>> +{
>> +	return ufshcd_desc_configfs_store(item, buf, count, 3);
>> +}
>> +
>> +static struct configfs_attribute ufshcd_attr_provision_0 = {
>> +	.ca_name	= "ufs_config_desc_0",
>> +	.ca_mode	= 0644,
>> +	.ca_owner	= THIS_MODULE,
>> +	.show		= ufs_config_desc_0_show,
>> +	.store		= ufs_config_desc_0_store,
>> +};
>> +
>> +static struct configfs_attribute ufshcd_attr_provision_1 = {
>> +	.ca_name	= "ufs_config_desc_1",
>> +	.ca_mode	= 0644,
>> +	.ca_owner	= THIS_MODULE,
>> +	.show		= ufs_config_desc_1_show,
>> +	.store		= ufs_config_desc_1_store,
>> +};
>> +
>> +static struct configfs_attribute ufshcd_attr_provision_2 = {
>> +	.ca_name	= "ufs_config_desc_2",
>> +	.ca_mode	= 0644,
>> +	.ca_owner	= THIS_MODULE,
>> +	.show		= ufs_config_desc_2_show,
>> +	.store		= ufs_config_desc_2_store,
>> +};
>> +
>> +static struct configfs_attribute ufshcd_attr_provision_3 = {
>> +	.ca_name	= "ufs_config_desc_3",
>> +	.ca_mode	= 0644,
>> +	.ca_owner	= THIS_MODULE,
>> +	.show		= ufs_config_desc_3_show,
>> +	.store		= ufs_config_desc_3_store,
>> +};
>> +
>> +static struct configfs_attribute *ufshcd_attrs[] = {
>> +	&ufshcd_attr_provision_0,
>> +	&ufshcd_attr_provision_1,
>> +	&ufshcd_attr_provision_2,
>> +	&ufshcd_attr_provision_3,
>> +	NULL,
>> +};
>> +
>> +static struct config_item_type ufscfg_type = {
>> +	.ct_attrs	= ufshcd_attrs,
>> +	.ct_owner	= THIS_MODULE,
>> +};
>> +
>> +void ufshcd_configfs_init(struct ufs_hba *hba, const char *name)
>> +{
>> +	int ret;
>> +	struct config_item *cg_item;
>> +	struct configfs_subsystem *subsys;
>> +
>> +	cg_item = &hba->subsys.su_group.cg_item;
>> +	sprintf(cg_item->ci_namebuf, "%s", name);
>> +	cg_item->ci_type = &ufscfg_type;
>> +
>> +	subsys = &hba->subsys;
>> +	config_group_init(&subsys->su_group);
>> +	mutex_init(&subsys->su_mutex);
>> +	ret = configfs_register_subsystem(subsys);
>> +	if (ret)
>> +		pr_err("Error %d while registering subsystem %s\n",
>> +		       ret,
>> +		       subsys->su_group.cg_item.ci_namebuf);
>> +}
>> +
>> +void ufshcd_configfs_exit(struct ufs_hba *hba)
>> +{
>> +	configfs_unregister_subsystem(&hba->subsys);
>> +}
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index e01cdc0..608e23e 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -7711,6 +7711,7 @@ int ufshcd_shutdown(struct ufs_hba *hba)
>>   void ufshcd_remove(struct ufs_hba *hba)
>>   {
>>   	ufs_sysfs_remove_nodes(hba->dev);
>> +	ufshcd_configfs_exit(hba);
>>   	scsi_remove_host(hba->host);
>>   	/* disable interrupts */
>>   	ufshcd_disable_intr(hba, hba->intr_mask);
>> @@ -7965,7 +7966,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>>   
>>   	async_schedule(ufshcd_async_scan, hba);
>>   	ufs_sysfs_add_nodes(hba->dev);
>> -
>> +	ufshcd_configfs_init(hba, dev_name(hba->dev));
>>   	return 0;
>>   
>>   out_remove_scsi_host:
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>> index 45013b6..a340ca8 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -37,6 +37,7 @@
>>   #ifndef _UFSHCD_H
>>   #define _UFSHCD_H
>>   
>> +#include <linux/configfs.h>
>>   #include <linux/module.h>
>>   #include <linux/kernel.h>
>>   #include <linux/init.h>
>> @@ -515,6 +516,9 @@ struct ufs_hba {
>>   
>>   	struct Scsi_Host *host;
>>   	struct device *dev;
>> +#ifdef CONFIG_UFS_PROVISION
>> +	struct configfs_subsystem subsys;
>> +#endif
>>   	/*
>>   	 * This field is to keep a reference to "scsi_device" corresponding to
>>   	 * "UFS device" W-LU.
>> @@ -868,6 +872,19 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, int desc_index,
>>   int ufshcd_hold(struct ufs_hba *hba, bool async);
>>   void ufshcd_release(struct ufs_hba *hba);
>>   
>> +/* Expose UFS configfs API's */
>> +#ifndef CONFIG_UFS_PROVISION
>> +static inline void ufshcd_configfs_init(struct ufs_hba *hba, const char *name)
>> +{
>> +}
>> +static inline void ufshcd_configfs_exit(struct ufs_hba *hba)
>> +{
>> +}
>> +#else
>> +void ufshcd_configfs_init(struct ufs_hba *hba, const char *name);
>> +void ufshcd_configfs_exit(struct ufs_hba *hba);
>> +#endif
>> +
>>   int ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
>>   	int *desc_length);
>>   
>>
