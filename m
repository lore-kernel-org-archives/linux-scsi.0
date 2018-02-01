From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v4 01/10] ufs: sysfs: attribute group for existing sysfs
 entries.
Date: Thu, 1 Feb 2018 17:59:23 +0100
Message-ID: <20180201165923.GA12838@kroah.com>
References: <1517501746-19075-1-git-send-email-stanislav.nijnikov@wdc.com>
 <1517501746-19075-2-git-send-email-stanislav.nijnikov@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47492 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752814AbeBAQ73 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Feb 2018 11:59:29 -0500
Content-Disposition: inline
In-Reply-To: <1517501746-19075-2-git-send-email-stanislav.nijnikov@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jaegeuk@kernel.org, alex.lemberg@wdc.com

On Thu, Feb 01, 2018 at 06:15:37PM +0200, Stanislav Nijnikov wrote:
> This patch introduces attribute group to show existing sysfs entries.
> 
> Signed-off-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
> ---
>  drivers/scsi/ufs/Makefile    |   3 +-
>  drivers/scsi/ufs/ufs-sysfs.c | 164 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufs-sysfs.h |  22 ++++++
>  drivers/scsi/ufs/ufshcd.c    | 156 ++--------------------------------------
>  drivers/scsi/ufs/ufshcd.h    |   2 +
>  5 files changed, 194 insertions(+), 153 deletions(-)
>  create mode 100644 drivers/scsi/ufs/ufs-sysfs.c
>  create mode 100644 drivers/scsi/ufs/ufs-sysfs.h
> 
> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> index 9310c6c..918f579 100644
> --- a/drivers/scsi/ufs/Makefile
> +++ b/drivers/scsi/ufs/Makefile
> @@ -3,6 +3,7 @@
>  obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o tc-dwc-g210.o
>  obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-dwc-g210.o
>  obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
> -obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o
> +obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
> +ufshcd-core-objs := ufshcd.o ufs-sysfs.o
>  obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
>  obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
> new file mode 100644
> index 0000000..cc68a90
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -0,0 +1,164 @@
> +//SPDX-License-Identifier: GPL-2.0-only
> +//Copyright (C) 2018 Western Digital Corporation
> +//This program is free software; you can redistribute it and/or modify it
> +//under the terms of the GNU General Public License as published by the
> +//Free Software Foundation; version 2.
> +//
> +//This program is distributed in the hope that it will be useful, but
> +//WITHOUT ANY WARRANTY; without even the implied warranty of
> +//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
> +//General Public License for more details.

No need to put the whole "This program" crud in the file here if you
have the SPDX line already.  We are going through the kernel tree and
removing all of the 700+ different ways we have this boilerplate code in
the tree, please do not add new ones.

Also, please put a ' ' after "//", it just looks ugly like this, don't
you think so?

Please fix this for all of the files you add in this patch series.

> +#include <linux/err.h>
> +#include <linux/string.h>
> +
> +#include "ufs-sysfs.h"
> +
> +static const char *ufschd_uic_link_state_to_string(
> +			enum uic_link_state state)
> +{
> +	switch (state) {
> +	case UIC_LINK_OFF_STATE:	return "OFF";
> +	case UIC_LINK_ACTIVE_STATE:	return "ACTIVE";
> +	case UIC_LINK_HIBERN8_STATE:	return "HIBERN8";
> +	default:			return "UNKNOWN";
> +	}
> +}
> +
> +static const char *ufschd_ufs_dev_pwr_mode_to_string(
> +			enum ufs_dev_pwr_mode state)
> +{
> +	switch (state) {
> +	case UFS_ACTIVE_PWR_MODE:	return "ACTIVE";
> +	case UFS_SLEEP_PWR_MODE:	return "SLEEP";
> +	case UFS_POWERDOWN_PWR_MODE:	return "POWERDOWN";
> +	default:			return "UNKNOWN";
> +	}
> +}
> +
> +static inline ssize_t ufs_sysfs_pm_lvl_store(struct device *dev,
> +					     struct device_attribute *attr,
> +					     const char *buf, size_t count,
> +					     bool rpm)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	unsigned long flags, value;
> +
> +	if (kstrtoul(buf, 0, &value))
> +		return -EINVAL;
> +
> +	if (value >= UFS_PM_LVL_MAX)
> +		return -EINVAL;
> +
> +	spin_lock_irqsave(hba->host->host_lock, flags);
> +	if (rpm)
> +		hba->rpm_lvl = value;
> +	else
> +		hba->spm_lvl = value;
> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> +	return count;
> +}
> +
> +static ssize_t rpm_lvl_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	int curr_len;
> +	u8 lvl;
> +
> +	curr_len = snprintf(buf, PAGE_SIZE,
> +			    "\nCurrent Runtime PM level [%d] => dev_state [%s] link_state [%s]\n",
> +			    hba->rpm_lvl,
> +			    ufschd_ufs_dev_pwr_mode_to_string(
> +				ufs_pm_lvl_states[hba->rpm_lvl].dev_state),
> +			    ufschd_uic_link_state_to_string(
> +				ufs_pm_lvl_states[hba->rpm_lvl].link_state));
> +
> +	curr_len += snprintf((buf + curr_len), (PAGE_SIZE - curr_len),
> +			     "\nAll available Runtime PM levels info:\n");
> +	for (lvl = UFS_PM_LVL_0; lvl < UFS_PM_LVL_MAX; lvl++)
> +		curr_len += snprintf((buf + curr_len), (PAGE_SIZE - curr_len),
> +				     "\tRuntime PM level [%d] => dev_state [%s] link_state [%s]\n",
> +				    lvl,
> +				    ufschd_ufs_dev_pwr_mode_to_string(
> +					ufs_pm_lvl_states[lvl].dev_state),
> +				    ufschd_uic_link_state_to_string(
> +					ufs_pm_lvl_states[lvl].link_state));
> +

sysfs if "one value per file", not "random text that someone has to
parse per file" please.

Huge hint, if you ever care about checking the size of the sysfs buffer
you are writing into, you are doing something really really wrong.


> +	return curr_len;
> +}
> +
> +static ssize_t rpm_lvl_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	return ufs_sysfs_pm_lvl_store(dev, attr, buf, count, true);
> +}
> +
> +static ssize_t spm_lvl_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	int curr_len;
> +	u8 lvl;
> +
> +	curr_len = snprintf(buf, PAGE_SIZE,
> +			    "\nCurrent System PM level [%d] => dev_state [%s] link_state [%s]\n",
> +			    hba->spm_lvl,
> +			    ufschd_ufs_dev_pwr_mode_to_string(
> +				ufs_pm_lvl_states[hba->spm_lvl].dev_state),
> +			    ufschd_uic_link_state_to_string(
> +				ufs_pm_lvl_states[hba->spm_lvl].link_state));
> +
> +	curr_len += snprintf((buf + curr_len), (PAGE_SIZE - curr_len),
> +			     "\nAll available System PM levels info:\n");
> +	for (lvl = UFS_PM_LVL_0; lvl < UFS_PM_LVL_MAX; lvl++)
> +		curr_len += snprintf((buf + curr_len), (PAGE_SIZE - curr_len),
> +				     "\tSystem PM level [%d] => dev_state [%s] link_state [%s]\n",
> +				    lvl,
> +				    ufschd_ufs_dev_pwr_mode_to_string(
> +					ufs_pm_lvl_states[lvl].dev_state),
> +				    ufschd_uic_link_state_to_string(
> +					ufs_pm_lvl_states[lvl].link_state));
> +

Same here, this output is not ok.

> +	return curr_len;
> +}
> +
> +static ssize_t spm_lvl_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	return ufs_sysfs_pm_lvl_store(dev, attr, buf, count, false);
> +}
> +
> +static DEVICE_ATTR_RW(rpm_lvl);
> +static DEVICE_ATTR_RW(spm_lvl);
> +
> +static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
> +	&dev_attr_rpm_lvl.attr,
> +	&dev_attr_spm_lvl.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group ufs_sysfs_default_group = {
> +	.attrs = ufs_sysfs_ufshcd_attrs,
> +};
> +
> +static const struct attribute_group *ufs_sysfs_groups[] = {
> +	&ufs_sysfs_default_group,
> +	NULL,
> +};

ATTRIBUTE_GROUPS() macro?

> +void ufs_sysfs_add_nodes(struct device *dev)
> +{
> +	int ret;
> +
> +	ret = sysfs_create_groups(&dev->kobj, ufs_sysfs_groups);
> +	if (ret)
> +		dev_err(dev,
> +			"%s: sysfs groups creation failed (err = %d)\n",
> +			__func__, ret);

Why not return 'ret' so you can do something with it?

thanks,

greg k-h
