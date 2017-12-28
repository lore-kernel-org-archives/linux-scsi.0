From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH v3 4/9] ufs: sysfs: health descriptor
Date: Thu, 28 Dec 2017 11:44:16 -0800
Message-ID: <20171228194416.GB47637@jaegeuk-macbookpro.roam.corp.google.com>
References: <1514467754-24499-1-git-send-email-stanislav.nijnikov@wdc.com>
 <1514467754-24499-5-git-send-email-stanislav.nijnikov@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1514467754-24499-5-git-send-email-stanislav.nijnikov@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, alex.lemberg@wdc.com
List-Id: linux-scsi@vger.kernel.org

On 12/28, Stanislav Nijnikov wrote:
> This patch introduces a sysfs group entry for the UFS health descriptor
> parameters. The group adds "health_descriptor" folder under the UFS driver
> sysfs entry (/sys/bus/platform/drivers/ufshcd/*). The parameters are shown
> as hexadecimal numbers. The full information about the parameters could be
> found at UFS specifications 2.1.
> 
> Signed-off-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>

It needs to remove the above SOB.

> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Reviewed-by: Jaegeuk Kim <jaegeuk@google.com>

> Signed-off-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
> ---
>  Documentation/ABI/testing/sysfs-driver-ufs | 28 ++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufs-sysfs.c               | 20 ++++++++++++++++++++
>  drivers/scsi/ufs/ufs.h                     | 11 +++++++++++
>  drivers/scsi/ufs/ufshcd.c                  |  8 ++++++++
>  drivers/scsi/ufs/ufshcd.h                  |  1 +
>  5 files changed, 68 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
> index 55134d3..6ba0f4d 100644
> --- a/Documentation/ABI/testing/sysfs-driver-ufs
> +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> @@ -413,3 +413,31 @@ Description:	This file shows the memory capacity adjustment factor for
>  		descriptor parameters. The full information about the
>  		descriptor could be found at UFS specifications 2.1.
>  		The file is read only.
> +
> +
> +What:		/sys/bus/platform/drivers/ufshcd/*/health_descriptor/eol_info
> +Date:		December 2017
> +Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
> +Description:	This file shows preend of life information. This is one
> +		of the UFS health descriptor parameters. The full
> +		information about the descriptor could be found at
> +		UFS specifications 2.1.
> +		The file is read only.
> +
> +What:		/sys/bus/platform/drivers/ufshcd/*/health_descriptor/life_time_estimation_a
> +Date:		December 2017
> +Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
> +Description:	This file shows indication of the device life time
> +		(method a). This is one of the UFS health descriptor
> +		parameters. The full information about the descriptor
> +		could be found at UFS specifications 2.1.
> +		The file is read only.
> +
> +What:		/sys/bus/platform/drivers/ufshcd/*/health_descriptor/life_time_estimation_b
> +Date:		December 2017
> +Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
> +Description:	This file shows indication of the device life time
> +		(method b). This is one of the UFS health descriptor
> +		parameters. The full information about the descriptor
> +		could be found at UFS specifications 2.1.
> +		The file is read only.
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
> index e439e92..ce6d27e 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -248,10 +248,30 @@ static const struct attribute_group ufs_sysfs_geometry_descriptor_group = {
>  	.attrs = ufs_sysfs_geometry_descriptor,
>  };
>  
> +#define UFS_HEALTH_DESC_PARAM(_name, _uname, _size)                     \
> +	UFS_DESC_PARAM(_name, _uname, HEALTH, _size)
> +
> +UFS_HEALTH_DESC_PARAM(eol_info, EOL_INFO, BYTE);
> +UFS_HEALTH_DESC_PARAM(life_time_estimation_a, LIFE_TIME_EST_A, BYTE);
> +UFS_HEALTH_DESC_PARAM(life_time_estimation_b, LIFE_TIME_EST_B, BYTE);
> +
> +static struct attribute *ufs_sysfs_health_descriptor[] = {
> +	&dev_attr_eol_info.attr,
> +	&dev_attr_life_time_estimation_a.attr,
> +	&dev_attr_life_time_estimation_b.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group ufs_sysfs_health_descriptor_group = {
> +	.name = "health_descriptor",
> +	.attrs = ufs_sysfs_health_descriptor,
> +};
> +
>  static const struct attribute_group *ufs_sysfs_groups[] = {
>  	&ufs_sysfs_device_descriptor_group,
>  	&ufs_sysfs_interconnect_descriptor_group,
>  	&ufs_sysfs_geometry_descriptor_group,
> +	&ufs_sysfs_health_descriptor_group,
>  	NULL,
>  };
>  
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index 04d41c8..6bfeedb 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -154,6 +154,7 @@ enum desc_idn {
>  	QUERY_DESC_IDN_RFU_1		= 0x6,
>  	QUERY_DESC_IDN_GEOMETRY		= 0x7,
>  	QUERY_DESC_IDN_POWER		= 0x8,
> +	QUERY_DESC_IDN_HEALTH           = 0x9,
>  	QUERY_DESC_IDN_MAX,
>  };
>  
> @@ -169,6 +170,7 @@ enum ufs_desc_def_size {
>  	QUERY_DESC_INTERCONNECT_DEF_SIZE	= 0x06,
>  	QUERY_DESC_GEOMETRY_DEF_SIZE		= 0x44,
>  	QUERY_DESC_POWER_DEF_SIZE		= 0x62,
> +	QUERY_DESC_HEALTH_DEF_SIZE		= 0x25,
>  };
>  
>  /* Unit descriptor parameters offsets in bytes*/
> @@ -274,6 +276,15 @@ enum geometry_desc_param {
>  	GEOMETRY_DESC_PARAM_OPT_LOG_BLK_SIZE	= 0x44,
>  };
>  
> +/* Health descriptor parameters offsets in bytes*/
> +enum health_desc_param {
> +	HEALTH_DESC_PARAM_LEN			= 0x0,
> +	HEALTH_DESC_PARAM_TYPE			= 0x1,
> +	HEALTH_DESC_PARAM_EOL_INFO		= 0x2,
> +	HEALTH_DESC_PARAM_LIFE_TIME_EST_A	= 0x3,
> +	HEALTH_DESC_PARAM_LIFE_TIME_EST_B	= 0x4,
> +};
> +
>  /*
>   * Logical Unit Write Protect
>   * 00h: LU not write protected
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 97dcb52..6ed31ca 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2987,6 +2987,9 @@ int ufshcd_map_desc_id_to_length(struct ufs_hba *hba,
>  	case QUERY_DESC_IDN_STRING:
>  		*desc_len = QUERY_DESC_MAX_SIZE;
>  		break;
> +	case QUERY_DESC_IDN_HEALTH:
> +		*desc_len = hba->desc_size.hlth_desc;
> +		break;
>  	case QUERY_DESC_IDN_RFU_0:
>  	case QUERY_DESC_IDN_RFU_1:
>  		*desc_len = 0;
> @@ -6298,6 +6301,10 @@ static void ufshcd_init_desc_sizes(struct ufs_hba *hba)
>  		&hba->desc_size.geom_desc);
>  	if (err)
>  		hba->desc_size.geom_desc = QUERY_DESC_GEOMETRY_DEF_SIZE;
> +	err = ufshcd_read_desc_length(hba, QUERY_DESC_IDN_HEALTH, 0,
> +		&hba->desc_size.hlth_desc);
> +	if (err)
> +		hba->desc_size.hlth_desc = QUERY_DESC_HEALTH_DEF_SIZE;
>  }
>  
>  static void ufshcd_def_desc_sizes(struct ufs_hba *hba)
> @@ -6308,6 +6315,7 @@ static void ufshcd_def_desc_sizes(struct ufs_hba *hba)
>  	hba->desc_size.conf_desc = QUERY_DESC_CONFIGURATION_DEF_SIZE;
>  	hba->desc_size.unit_desc = QUERY_DESC_UNIT_DEF_SIZE;
>  	hba->desc_size.geom_desc = QUERY_DESC_GEOMETRY_DEF_SIZE;
> +	hba->desc_size.hlth_desc = QUERY_DESC_HEALTH_DEF_SIZE;
>  }
>  
>  /**
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 6a0ec4b..2235e7d 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -229,6 +229,7 @@ struct ufs_desc_size {
>  	int interc_desc;
>  	int unit_desc;
>  	int conf_desc;
> +	int hlth_desc;
>  };
>  
>  /**
> -- 
> 2.7.4
