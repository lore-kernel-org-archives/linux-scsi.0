From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/2] scsi: ufs: introduce static sysfs entries
Date: Wed, 20 Dec 2017 09:02:21 +0100
Message-ID: <20171220080221.GB22932@kroah.com>
References: <20171219200254.23120-1-jaegeuk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171219200254.23120-1-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@google.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 19, 2017 at 12:02:53PM -0800, Jaegeuk Kim wrote:
> From: Jaegeuk Kim <jaegeuk@google.com>
> 
> This patch introduces attribute group to show existing sysfs entries.
> 
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 48 +++++++++++++++++++----------------------------
>  drivers/scsi/ufs/ufshcd.h |  2 --
>  2 files changed, 19 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 011c3369082c..12ff7daebb00 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7605,7 +7605,7 @@ static inline ssize_t ufshcd_pm_lvl_store(struct device *dev,
>  	return count;
>  }
>  
> -static ssize_t ufshcd_rpm_lvl_show(struct device *dev,
> +static ssize_t rpm_lvl_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
>  	struct ufs_hba *hba = dev_get_drvdata(dev);
> @@ -7634,24 +7634,13 @@ static ssize_t ufshcd_rpm_lvl_show(struct device *dev,
>  	return curr_len;
>  }
>  
> -static ssize_t ufshcd_rpm_lvl_store(struct device *dev,
> +static ssize_t rpm_lvl_store(struct device *dev,
>  		struct device_attribute *attr, const char *buf, size_t count)
>  {
>  	return ufshcd_pm_lvl_store(dev, attr, buf, count, true);
>  }
>  
> -static void ufshcd_add_rpm_lvl_sysfs_nodes(struct ufs_hba *hba)
> -{
> -	hba->rpm_lvl_attr.show = ufshcd_rpm_lvl_show;
> -	hba->rpm_lvl_attr.store = ufshcd_rpm_lvl_store;
> -	sysfs_attr_init(&hba->rpm_lvl_attr.attr);
> -	hba->rpm_lvl_attr.attr.name = "rpm_lvl";
> -	hba->rpm_lvl_attr.attr.mode = 0644;
> -	if (device_create_file(hba->dev, &hba->rpm_lvl_attr))
> -		dev_err(hba->dev, "Failed to create sysfs for rpm_lvl\n");
> -}
> -
> -static ssize_t ufshcd_spm_lvl_show(struct device *dev,
> +static ssize_t spm_lvl_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
>  	struct ufs_hba *hba = dev_get_drvdata(dev);
> @@ -7680,33 +7669,34 @@ static ssize_t ufshcd_spm_lvl_show(struct device *dev,
>  	return curr_len;
>  }
>  
> -static ssize_t ufshcd_spm_lvl_store(struct device *dev,
> +static ssize_t spm_lvl_store(struct device *dev,
>  		struct device_attribute *attr, const char *buf, size_t count)
>  {
>  	return ufshcd_pm_lvl_store(dev, attr, buf, count, false);
>  }
>  
> -static void ufshcd_add_spm_lvl_sysfs_nodes(struct ufs_hba *hba)
> -{
> -	hba->spm_lvl_attr.show = ufshcd_spm_lvl_show;
> -	hba->spm_lvl_attr.store = ufshcd_spm_lvl_store;
> -	sysfs_attr_init(&hba->spm_lvl_attr.attr);
> -	hba->spm_lvl_attr.attr.name = "spm_lvl";
> -	hba->spm_lvl_attr.attr.mode = 0644;
> -	if (device_create_file(hba->dev, &hba->spm_lvl_attr))
> -		dev_err(hba->dev, "Failed to create sysfs for spm_lvl\n");
> -}
> +static DEVICE_ATTR_RW(rpm_lvl);
> +static DEVICE_ATTR_RW(spm_lvl);
> +
> +static struct attribute *ufshcd_attrs[] = {
> +	&dev_attr_rpm_lvl.attr,
> +	&dev_attr_spm_lvl.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group ufshcd_attr_group = {
> +	.attrs = ufshcd_attrs,
> +};

ATTRIBUTE_GROUPS()?

>  static inline void ufshcd_add_sysfs_nodes(struct ufs_hba *hba)
>  {
> -	ufshcd_add_rpm_lvl_sysfs_nodes(hba);
> -	ufshcd_add_spm_lvl_sysfs_nodes(hba);
> +	if (sysfs_create_group(&hba->dev->kobj, &ufshcd_attr_group))
> +		dev_err(hba->dev, "Failed to create sysfs group\n");

That will turn this into sysfs_create_groups()

But really, you should be able to do this all "at once"  And really, it
should be a "default attribute group" that the driver core adds to the
device, but that's outside the scope of this patchset.

So for now, this is just fine, the attribute groups work is for an
add-on patch.  Thanks for working to get this upstream, I'm tired of
seeing all of the different variants of this driver floating around
out-of-tree.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
