From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH RFC 8/9] [SCSI] Add sense and Unit Attention generation
 to scsi_debug
Date: Sat, 19 Jan 2013 13:43:19 -0500
Message-ID: <50FAE947.9090206@interlog.com>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com> <1358526434-1173-9-git-send-email-emilne@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:53995 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232Ab3ASSnZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Jan 2013 13:43:25 -0500
In-Reply-To: <1358526434-1173-9-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org

On 13-01-18 11:27 AM, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
>
> Added capability to scsi_debug to generate sense and Unit Attention
> conditions to exercise the enhanced sense and Unit Attention handling.
>
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>   drivers/scsi/scsi_debug.c | 133 ++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 133 insertions(+)
>
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 88f6d16..8fe9bcd 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -3051,10 +3051,27 @@ static ssize_t sdebug_max_luns_store(struct device_driver * ddp,
>   				     const char * buf, size_t count)
>   {
>           int n;
> +#ifdef CONFIG_SCSI_ENHANCED_UA
> +	struct sdebug_host_info *sdbg_host;
> +	struct sdebug_dev_info *devip;
> +#endif
>
>   	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
>   		scsi_debug_max_luns = n;
>   		sdebug_max_tgts_luns();
> +
> +#ifdef CONFIG_SCSI_ENHANCED_UA
> +		spin_lock(&sdebug_host_list_lock);
> +		list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
> +			list_for_each_entry(devip, &sdbg_host->dev_info_list,
> +					    dev_list) {
> +				mk_sense_buffer(devip, UNIT_ATTENTION,
> +						0x3f, 0x0e);
> +				devip->sense_pending = 1;
> +			}
> +		}
> +		spin_unlock(&sdebug_host_list_lock);
> +#endif
>   		return count;
>   	}
>   	return -EINVAL;
> @@ -3101,12 +3118,28 @@ static ssize_t sdebug_virtual_gb_store(struct device_driver * ddp,
>   				       const char * buf, size_t count)
>   {
>           int n;
> +#ifdef CONFIG_SCSI_ENHANCED_UA
> +	struct sdebug_host_info *sdbg_host;
> +	struct sdebug_dev_info *devip;
> +#endif
>
>   	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
>   		scsi_debug_virtual_gb = n;
>
>   		sdebug_capacity = get_sdebug_capacity();
>
> +#ifdef CONFIG_SCSI_ENHANCED_UA
> +		spin_lock(&sdebug_host_list_lock);
> +		list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
> +			list_for_each_entry(devip, &sdbg_host->dev_info_list,
> +					    dev_list) {
> +				mk_sense_buffer(devip, UNIT_ATTENTION,
> +						0x2a, 0x09);
> +				devip->sense_pending = 1;
> +			}
> +		}
> +		spin_unlock(&sdebug_host_list_lock);
> +#endif
>   		return count;
>   	}
>   	return -EINVAL;
> @@ -3233,6 +3266,90 @@ static ssize_t sdebug_sense_overflow_store(struct device_driver *ddp,
>   }
>   DRIVER_ATTR(sense_overflow, S_IWUSR, NULL, sdebug_sense_overflow_store);
>
> +#ifdef CONFIG_SCSI_ENHANCED_UA
> +static ssize_t sdebug_ua_overflow_store(struct device_driver *ddp,
> +					const char *buf, size_t count)
> +{
> +	int n;
> +	struct sdebug_host_info *sdbg_host;
> +	struct sdebug_dev_info *devip;
> +
> +	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
> +		spin_lock(&sdebug_host_list_lock);
> +		list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
> +			list_for_each_entry(devip, &sdbg_host->dev_info_list,
> +					    dev_list) {
> +				if (scsi_debug_dsense) {
> +					mk_sense_buffer(devip, UNIT_ATTENTION,
> +							0, 0);
> +					devip->sense_buff[7] = 8;
> +					devip->sense_buff[8] = 0x02;
> +					devip->sense_buff[9] = 0x06;
> +					devip->sense_buff[12] = 0x01;
> +				}
> +				devip->sense_pending = 1;
> +			}
> +		}
> +		spin_unlock(&sdebug_host_list_lock);
> +		return count;
> +	}
> +	return -EINVAL;
> +}
> +DRIVER_ATTR(ua_overflow, S_IWUSR, NULL, sdebug_ua_overflow_store);
> +
> +static ssize_t sdebug_soft_threshold_reached_store(struct device_driver *ddp,
> +						   const char *buf,
> +						   size_t count)
> +{
> +	int n;
> +	struct sdebug_host_info *sdbg_host;
> +	struct sdebug_dev_info *devip;
> +
> +	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
> +		spin_lock(&sdebug_host_list_lock);
> +		list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
> +			list_for_each_entry(devip, &sdbg_host->dev_info_list,
> +					    dev_list) {
> +				mk_sense_buffer(devip, UNIT_ATTENTION,
> +						0x38, 0x07);
> +				devip->sense_pending = 1;
> +			}
> +		}
> +		spin_unlock(&sdebug_host_list_lock);
> +		return count;
> +	}
> +	return -EINVAL;
> +}
> +DRIVER_ATTR(soft_threshold_reached, S_IWUSR, NULL,
> +	    sdebug_soft_threshold_reached_store);
> +
> +static ssize_t sdebug_mode_parameters_changed_store(struct device_driver *ddp,
> +						    const char *buf,
> +						    size_t count)
> +{
> +	int n;
> +	struct sdebug_host_info *sdbg_host;
> +	struct sdebug_dev_info *devip;
> +
> +	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
> +		spin_lock(&sdebug_host_list_lock);
> +		list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
> +			list_for_each_entry(devip, &sdbg_host->dev_info_list,
> +					    dev_list) {
> +				mk_sense_buffer(devip, UNIT_ATTENTION,
> +						0x2a, 0x01);
> +				devip->sense_pending = 1;
> +			}
> +		}
> +		spin_unlock(&sdebug_host_list_lock);
> +		return count;
> +	}
> +	return -EINVAL;
> +}
> +DRIVER_ATTR(mode_parameters_changed, S_IWUSR, NULL,
> +	    sdebug_mode_parameters_changed_store);
> +#endif
> +
>   /* Note: The following function creates attribute files in the
>      /sys/bus/pseudo/drivers/scsi_debug directory. The advantage of these
>      files (over those found in the /sys/module/scsi_debug/parameters
> @@ -3268,11 +3385,27 @@ static int do_create_driverfs_files(void)
>   	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_map);
>   	ret |= driver_create_file(&sdebug_driverfs_driver,
>   				  &driver_attr_sense_overflow);
> +#ifdef CONFIG_SCSI_ENHANCED_UA
> +	ret |= driver_create_file(&sdebug_driverfs_driver,
> +				  &driver_attr_ua_overflow);
> +	ret |= driver_create_file(&sdebug_driverfs_driver,
> +				  &driver_attr_soft_threshold_reached);
> +	ret |= driver_create_file(&sdebug_driverfs_driver,
> +				  &driver_attr_mode_parameters_changed);
> +#endif
>   	return ret;
>   }
>
>   static void do_remove_driverfs_files(void)
>   {
> +#ifdef CONFIG_SCSI_ENHANCED_UA
> +	driver_remove_file(&sdebug_driverfs_driver,
> +			   &driver_attr_mode_parameters_changed);
> +	driver_remove_file(&sdebug_driverfs_driver,
> +			   &driver_attr_soft_threshold_reached);
> +	driver_remove_file(&sdebug_driverfs_driver,
> +			   &driver_attr_ua_overflow);
> +#endif
>   	driver_remove_file(&sdebug_driverfs_driver,
>   			   &driver_attr_sense_overflow);
>   	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_map);

Ewan,
Looks good. Could you add MODULE_PARM_DESC macros (in
alphabetical order) for mode_parameters_changed,
soft_threshold_reached and ua_overflow?

Doug Gilbert

