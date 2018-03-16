From: Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH] scsi: ufs: sysfs: reworking of the rpm_lvl and spm_lvl
 entries
Date: Fri, 16 Mar 2018 16:19:08 +0200
Message-ID: <fbea3b00-7497-cb3f-746f-65f793677568@intel.com>
References: <1519901286-17496-1-git-send-email-stanislav.nijnikov@wdc.com>
 <1519901286-17496-2-git-send-email-stanislav.nijnikov@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1519901286-17496-2-git-send-email-stanislav.nijnikov@wdc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, subhashj@codeaurora.org
Cc: alex.lemberg@wdc.com
List-Id: linux-scsi@vger.kernel.org

On 01/03/18 12:48, Stanislav Nijnikov wrote:
> Read from these files will return the integed value of the chosen power
> management level now. Separate entries were added to show the target
> UFS device and UIC link states. The description of the possible power
> managements levels was added to the ABI file. The on-write behaviour of
> these entries wasn't changed.
> 
> Signed-off-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  Documentation/ABI/testing/sysfs-driver-ufs | 67 ++++++++++++++++++++++
>  drivers/scsi/ufs/ufs-sysfs.c               | 92 +++++++++++++++---------------
>  2 files changed, 114 insertions(+), 45 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
> index 07f1c2f..83735f7 100644
> --- a/Documentation/ABI/testing/sysfs-driver-ufs
> +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> @@ -802,3 +802,70 @@ Description:	This file shows the The amount of physical memory needed
>  		the particular logical unit. The full information about
>  		the attribute could be found at UFS specifications 2.1.
>  		The file is read only.
> +
> +
> +What:		/sys/bus/platform/drivers/ufshcd/*/rpm_lvl
> +Date:		September 2014
> +Contact:	Subhash Jadavani <subhashj@codeaurora.org>
> +Description:	This entry could be used to set or show the UFS device
> +		runtime power management level. The current driver
> +		implementation supports 6 levels with next target states:
> +		0 - an UFS device will stay active, an UIC link will
> +		stay active
> +		1 - an UFS device will stay active, an UIC link will
> +		hibernate
> +		2 - an UFS device will moved to sleep, an UIC link will
> +		stay active
> +		3 - an UFS device will moved to sleep, an UIC link will
> +		hibernate
> +		4 - an UFS device will be powered off, an UIC link will
> +		hibernate
> +		5 - an UFS device will be powered off, an UIC link will
> +		be powered off
> +
> +What:		/sys/bus/platform/drivers/ufshcd/*/rpm_target_dev_state
> +Date:		February 2018
> +Contact:	Subhash Jadavani <subhashj@codeaurora.org>
> +Description:	This entry shows the target power mode of an UFS device
> +		for the chosen runtime power management level.
> +		The file is read only.
> +
> +What:		/sys/bus/platform/drivers/ufshcd/*/rpm_target_link_state
> +Date:		February 2018
> +Contact:	Subhash Jadavani <subhashj@codeaurora.org>
> +Description:	This entry shows the target state of an UFS UIC link
> +		for the chosen runtime power management level.
> +		The file is read only.
> +
> +What:		/sys/bus/platform/drivers/ufshcd/*/spm_lvl
> +Date:		September 2014
> +Contact:	Subhash Jadavani <subhashj@codeaurora.org>
> +Description:	This entry could be used to set or show the UFS device
> +		system power management level. The current driver
> +		implementation supports 6 levels with next target states:
> +		0 - an UFS device will stay active, an UIC link will
> +		stay active
> +		1 - an UFS device will stay active, an UIC link will
> +		hibernate
> +		2 - an UFS device will moved to sleep, an UIC link will
> +		stay active
> +		3 - an UFS device will moved to sleep, an UIC link will
> +		hibernate
> +		4 - an UFS device will be powered off, an UIC link will
> +		hibernate
> +		5 - an UFS device will be powered off, an UIC link will
> +		be powered off
> +
> +What:		/sys/bus/platform/drivers/ufshcd/*/spm_target_dev_state
> +Date:		February 2018
> +Contact:	Subhash Jadavani <subhashj@codeaurora.org>
> +Description:	This entry shows the target power mode of an UFS device
> +		for the chosen system power management level.
> +		The file is read only.
> +
> +What:		/sys/bus/platform/drivers/ufshcd/*/spm_target_link_state
> +Date:		February 2018
> +Contact:	Subhash Jadavani <subhashj@codeaurora.org>
> +Description:	This entry shows the target state of an UFS UIC link
> +		for the chosen system power management level.
> +		The file is read only.
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
> index cd7174d..4ff9e0b 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -57,29 +57,8 @@ static ssize_t rpm_lvl_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
>  	struct ufs_hba *hba = dev_get_drvdata(dev);
> -	int curr_len;
> -	u8 lvl;
> -
> -	curr_len = snprintf(buf, PAGE_SIZE,
> -			    "\nCurrent Runtime PM level [%d] => dev_state [%s] link_state [%s]\n",
> -			    hba->rpm_lvl,
> -			    ufschd_ufs_dev_pwr_mode_to_string(
> -				ufs_pm_lvl_states[hba->rpm_lvl].dev_state),
> -			    ufschd_uic_link_state_to_string(
> -				ufs_pm_lvl_states[hba->rpm_lvl].link_state));
> -
> -	curr_len += snprintf((buf + curr_len), (PAGE_SIZE - curr_len),
> -			     "\nAll available Runtime PM levels info:\n");
> -	for (lvl = UFS_PM_LVL_0; lvl < UFS_PM_LVL_MAX; lvl++)
> -		curr_len += snprintf((buf + curr_len), (PAGE_SIZE - curr_len),
> -				     "\tRuntime PM level [%d] => dev_state [%s] link_state [%s]\n",
> -				    lvl,
> -				    ufschd_ufs_dev_pwr_mode_to_string(
> -					ufs_pm_lvl_states[lvl].dev_state),
> -				    ufschd_uic_link_state_to_string(
> -					ufs_pm_lvl_states[lvl].link_state));
> -
> -	return curr_len;
> +
> +	return sprintf(buf, "%d\n", hba->rpm_lvl);
>  }
>  
>  static ssize_t rpm_lvl_store(struct device *dev,
> @@ -88,33 +67,30 @@ static ssize_t rpm_lvl_store(struct device *dev,
>  	return ufs_sysfs_pm_lvl_store(dev, attr, buf, count, true);
>  }
>  
> +static ssize_t rpm_target_dev_state_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%s\n", ufschd_ufs_dev_pwr_mode_to_string(
> +			ufs_pm_lvl_states[hba->rpm_lvl].dev_state));
> +}
> +
> +static ssize_t rpm_target_link_state_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%s\n", ufschd_uic_link_state_to_string(
> +			ufs_pm_lvl_states[hba->rpm_lvl].link_state));
> +}
> +
>  static ssize_t spm_lvl_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
>  	struct ufs_hba *hba = dev_get_drvdata(dev);
> -	int curr_len;
> -	u8 lvl;
> -
> -	curr_len = snprintf(buf, PAGE_SIZE,
> -			    "\nCurrent System PM level [%d] => dev_state [%s] link_state [%s]\n",
> -			    hba->spm_lvl,
> -			    ufschd_ufs_dev_pwr_mode_to_string(
> -				ufs_pm_lvl_states[hba->spm_lvl].dev_state),
> -			    ufschd_uic_link_state_to_string(
> -				ufs_pm_lvl_states[hba->spm_lvl].link_state));
>  
> -	curr_len += snprintf((buf + curr_len), (PAGE_SIZE - curr_len),
> -			     "\nAll available System PM levels info:\n");
> -	for (lvl = UFS_PM_LVL_0; lvl < UFS_PM_LVL_MAX; lvl++)
> -		curr_len += snprintf((buf + curr_len), (PAGE_SIZE - curr_len),
> -				     "\tSystem PM level [%d] => dev_state [%s] link_state [%s]\n",
> -				    lvl,
> -				    ufschd_ufs_dev_pwr_mode_to_string(
> -					ufs_pm_lvl_states[lvl].dev_state),
> -				    ufschd_uic_link_state_to_string(
> -					ufs_pm_lvl_states[lvl].link_state));
> -
> -	return curr_len;
> +	return sprintf(buf, "%d\n", hba->spm_lvl);
>  }
>  
>  static ssize_t spm_lvl_store(struct device *dev,
> @@ -123,12 +99,38 @@ static ssize_t spm_lvl_store(struct device *dev,
>  	return ufs_sysfs_pm_lvl_store(dev, attr, buf, count, false);
>  }
>  
> +static ssize_t spm_target_dev_state_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%s\n", ufschd_ufs_dev_pwr_mode_to_string(
> +				ufs_pm_lvl_states[hba->spm_lvl].dev_state));
> +}
> +
> +static ssize_t spm_target_link_state_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%s\n", ufschd_uic_link_state_to_string(
> +				ufs_pm_lvl_states[hba->spm_lvl].link_state));
> +}
> +
>  static DEVICE_ATTR_RW(rpm_lvl);
> +static DEVICE_ATTR_RO(rpm_target_dev_state);
> +static DEVICE_ATTR_RO(rpm_target_link_state);
>  static DEVICE_ATTR_RW(spm_lvl);
> +static DEVICE_ATTR_RO(spm_target_dev_state);
> +static DEVICE_ATTR_RO(spm_target_link_state);
>  
>  static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
>  	&dev_attr_rpm_lvl.attr,
> +	&dev_attr_rpm_target_dev_state.attr,
> +	&dev_attr_rpm_target_link_state.attr,
>  	&dev_attr_spm_lvl.attr,
> +	&dev_attr_spm_target_dev_state.attr,
> +	&dev_attr_spm_target_link_state.attr,
>  	NULL
>  };
>  
> 
