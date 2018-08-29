From: Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH] scsi: ufs: Make sysfs flags writable
Date: Wed, 29 Aug 2018 14:50:01 +0300
Message-ID: <3f262cb6-104a-f9be-3ec0-33ec7ec63455@intel.com>
References: <20180820213455.15092-1-evgreen@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180820213455.15092-1-evgreen@chromium.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Evan Green <evgreen@chromium.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 21/08/18 00:34, Evan Green wrote:
> This change makes the UFS controller's sysfs flags writable. This
> will enable users to provision unprovisioned devices, and experiment
> with device features.
> 
> Signed-off-by: Evan Green <evgreen@chromium.org>

Seems like a good idea:

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
> This is a follow-on patch to another patch [1] that makes the UFS attributes
> writable.
> 
> [1] https://lore.kernel.org/patchwork/patch/972959/
> 
>  Documentation/ABI/testing/sysfs-driver-ufs | 18 +++++++---
>  drivers/scsi/ufs/ufs-sysfs.c               | 54 +++++++++++++++++++++++++-----
>  2 files changed, 58 insertions(+), 14 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
> index 016724ec26d5..6df8ccbc94f3 100644
> --- a/Documentation/ABI/testing/sysfs-driver-ufs
> +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> @@ -619,7 +619,6 @@ Date:		February 2018
>  Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
>  Description:	This file shows the device init status. The full information
>  		about the flag could be found at UFS specifications 2.1.
> -		The file is read only.
>  
>  What:		/sys/bus/platform/drivers/ufshcd/*/flags/permanent_wpe
>  Date:		February 2018
> @@ -627,7 +626,8 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
>  Description:	This file shows whether permanent write protection is enabled.
>  		The full information about the flag could be found at
>  		UFS specifications 2.1.
> -		The file is read only.
> +		Warning: This flag can only be written one time within the
> +		lifetime of the device. Once set, it cannot be unset.
>  
>  What:		/sys/bus/platform/drivers/ufshcd/*/flags/power_on_wpe
>  Date:		February 2018
> @@ -636,7 +636,7 @@ Description:	This file shows whether write protection is enabled on all
>  		logical units configured as power on write protected. The
>  		full information about the flag could be found at
>  		UFS specifications 2.1.
> -		The file is read only.
> +		Once set, this flag cannot be cleared without a device reset.
>  
>  What:		/sys/bus/platform/drivers/ufshcd/*/flags/bkops_enable
>  Date:		February 2018
> @@ -644,7 +644,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
>  Description:	This file shows whether the device background operations are
>  		enabled. The full information about the flag could be
>  		found at UFS specifications 2.1.
> -		The file is read only.
>  
>  What:		/sys/bus/platform/drivers/ufshcd/*/flags/life_span_mode_enable
>  Date:		February 2018
> @@ -654,13 +653,22 @@ Description:	This file shows whether the device life span mode is enabled.
>  		UFS specifications 2.1.
>  		The file is read only.
>  
> +What:		/sys/bus/platform/drivers/ufshcd/*/flags/purge_enable
> +Date:		August 2018
> +Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
> +Description:	This file shall only be set when the command queue of all
> +		logical units are empty and purge status is idle. This flag is
> +		automatically cleared by the UFS device when the operation
> +		completes or an error occurs. This flag is write-only, it
> +		cannot be read. Complete information about the flag can be
> +		found in the UFS specification 2.20A.
> +
>  What:		/sys/bus/platform/drivers/ufshcd/*/flags/phy_resource_removal
>  Date:		February 2018
>  Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
>  Description:	This file shows whether physical resource removal is enable.
>  		The full information about the flag could be found at
>  		UFS specifications 2.1.
> -		The file is read only.
>  
>  What:		/sys/bus/platform/drivers/ufshcd/*/flags/busy_rtc
>  Date:		February 2018
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
> index 8d9332bb7d0c..2da927f4b7ff 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -616,7 +616,7 @@ static const struct attribute_group ufs_sysfs_string_descriptors_group = {
>  	.attrs = ufs_sysfs_string_descriptors,
>  };
>  
> -#define UFS_FLAG(_name, _uname)						\
> +#define UFS_FLAG_SHOW(_name, _uname)					\
>  static ssize_t _name##_show(struct device *dev,				\
>  	struct device_attribute *attr, char *buf)			\
>  {									\
> @@ -626,17 +626,52 @@ static ssize_t _name##_show(struct device *dev,				\
>  		QUERY_FLAG_IDN##_uname, &flag))				\
>  		return -EINVAL;						\
>  	return sprintf(buf, "%s\n", flag ? "true" : "false");		\
> +}
> +
> +#define UFS_FLAG_STORE(_name, _uname)					\
> +static ssize_t _name##_store(struct device *dev,			\
> +	struct device_attribute *attr, const char *buf,			\
> +	size_t count)							\
> +{									\
> +	bool flag;							\
> +	struct ufs_hba *hba = dev_get_drvdata(dev);			\
> +	enum query_opcode op;						\
> +	if (kstrtobool(buf, &flag))					\
> +		return -EINVAL;						\
> +	op = flag ? UPIU_QUERY_OPCODE_SET_FLAG :			\
> +		UPIU_QUERY_OPCODE_CLEAR_FLAG;				\
> +	if (ufshcd_query_flag(hba, op, QUERY_FLAG_IDN##_uname, NULL))	\
> +		return -EINVAL;						\
> +	return count;							\
>  }									\
> +
> +#define UFS_FLAG_RO(_name, _uname)	\
> +UFS_FLAG_SHOW(_name, _uname)		\
>  static DEVICE_ATTR_RO(_name)
>  
> -UFS_FLAG(device_init, _FDEVICEINIT);
> -UFS_FLAG(permanent_wpe, _PERMANENT_WPE);
> -UFS_FLAG(power_on_wpe, _PWR_ON_WPE);
> -UFS_FLAG(bkops_enable, _BKOPS_EN);
> -UFS_FLAG(life_span_mode_enable, _LIFE_SPAN_MODE_ENABLE);
> -UFS_FLAG(phy_resource_removal, _FPHYRESOURCEREMOVAL);
> -UFS_FLAG(busy_rtc, _BUSY_RTC);
> -UFS_FLAG(disable_fw_update, _PERMANENTLY_DISABLE_FW_UPDATE);
> +#define UFS_FLAG_WO(_name, _uname)					\
> +UFS_FLAG_STORE(_name, _uname)						\
> +static ssize_t _name##_show(struct device *dev,				\
> +	struct device_attribute *attr, char *buf)			\
> +{									\
> +	return -EOPNOTSUPP;						\
> +}									\
> +static DEVICE_ATTR_RW(_name)
> +
> +#define UFS_FLAG_RW(_name, _uname)					\
> +UFS_FLAG_SHOW(_name, _uname)						\
> +UFS_FLAG_STORE(_name, _uname)						\
> +static DEVICE_ATTR_RW(_name)
> +
> +UFS_FLAG_RW(device_init, _FDEVICEINIT);
> +UFS_FLAG_RW(permanent_wpe, _PERMANENT_WPE);
> +UFS_FLAG_RW(power_on_wpe, _PWR_ON_WPE);
> +UFS_FLAG_RW(bkops_enable, _BKOPS_EN);
> +UFS_FLAG_RO(life_span_mode_enable, _LIFE_SPAN_MODE_ENABLE);
> +UFS_FLAG_WO(purge_enable, _PURGE_ENABLE);
> +UFS_FLAG_RW(phy_resource_removal, _FPHYRESOURCEREMOVAL);
> +UFS_FLAG_RO(busy_rtc, _BUSY_RTC);
> +UFS_FLAG_RO(disable_fw_update, _PERMANENTLY_DISABLE_FW_UPDATE);
>  
>  static struct attribute *ufs_sysfs_device_flags[] = {
>  	&dev_attr_device_init.attr,
> @@ -644,6 +679,7 @@ static struct attribute *ufs_sysfs_device_flags[] = {
>  	&dev_attr_power_on_wpe.attr,
>  	&dev_attr_bkops_enable.attr,
>  	&dev_attr_life_span_mode_enable.attr,
> +	&dev_attr_purge_enable.attr,
>  	&dev_attr_phy_resource_removal.attr,
>  	&dev_attr_busy_rtc.attr,
>  	&dev_attr_disable_fw_update.attr,
> 
