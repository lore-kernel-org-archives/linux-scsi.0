From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi_debug: Runtime-configurable sector size
Date: Thu, 05 Jun 2008 08:53:24 -0400
Message-ID: <4847E1C4.2070104@torque.net>
References: <yq18wxko6yc.fsf@sermon.lab.mkp.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elrond2.infotech.no ([82.134.31.41]:53749 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513AbYFEMxf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2008 08:53:35 -0400
In-Reply-To: <yq18wxko6yc.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
> Make scsi_debug sector size configurable at load time instead of being
> a #define.  Handy for testing 4KB sectors.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Signed-off-by: Douglas Gilbert <dougg@torque.net>


> ---
> 
> diff -r b1f69dded4b8 drivers/scsi/scsi_debug.c
> --- a/drivers/scsi/scsi_debug.c	Wed Apr 30 15:41:26 2008 -0400
> +++ b/drivers/scsi/scsi_debug.c	Wed Apr 30 16:08:12 2008 -0400
> @@ -94,6 +94,7 @@
>  #define DEF_VIRTUAL_GB   0
>  #define DEF_FAKE_RW	0
>  #define DEF_VPD_USE_HOSTNO 1
> +#define DEF_SECTOR_SIZE 512
>  
>  /* bit mask values for scsi_debug_opts */
>  #define SCSI_DEBUG_OPT_NOISE   1
> @@ -142,6 +143,7 @@
>  static int scsi_debug_virtual_gb = DEF_VIRTUAL_GB;
>  static int scsi_debug_fake_rw = DEF_FAKE_RW;
>  static int scsi_debug_vpd_use_hostno = DEF_VPD_USE_HOSTNO;
> +static int scsi_debug_sector_size = DEF_SECTOR_SIZE;
>  
>  static int scsi_debug_cmnd_count = 0;
>  
> @@ -156,11 +158,6 @@
>  static int sdebug_heads;		/* heads per disk */
>  static int sdebug_cylinders_per;	/* cylinders per surface */
>  static int sdebug_sectors_per;		/* sectors per cylinder */
> -
> -/* default sector size is 512 bytes, 2**9 bytes */
> -#define POW2_SECT_SIZE 9
> -#define SECT_SIZE (1 << POW2_SECT_SIZE)
> -#define SECT_SIZE_PER(TGT) SECT_SIZE
>  
>  #define SDEBUG_MAX_PARTS 4
>  
> @@ -878,8 +875,8 @@
>  		arr[2] = 0xff;
>  		arr[3] = 0xff;
>  	}
> -	arr[6] = (SECT_SIZE_PER(target) >> 8) & 0xff;
> -	arr[7] = SECT_SIZE_PER(target) & 0xff;
> +	arr[6] = (scsi_debug_sector_size >> 8) & 0xff;
> +	arr[7] = scsi_debug_sector_size & 0xff;
>  	return fill_from_dev_buffer(scp, arr, SDEBUG_READCAP_ARR_SZ);
>  }
>  
> @@ -902,10 +899,10 @@
>  	capac = sdebug_capacity - 1;
>  	for (k = 0; k < 8; ++k, capac >>= 8)
>  		arr[7 - k] = capac & 0xff;
> -	arr[8] = (SECT_SIZE_PER(target) >> 24) & 0xff;
> -	arr[9] = (SECT_SIZE_PER(target) >> 16) & 0xff;
> -	arr[10] = (SECT_SIZE_PER(target) >> 8) & 0xff;
> -	arr[11] = SECT_SIZE_PER(target) & 0xff;
> +	arr[8] = (scsi_debug_sector_size >> 24) & 0xff;
> +	arr[9] = (scsi_debug_sector_size >> 16) & 0xff;
> +	arr[10] = (scsi_debug_sector_size >> 8) & 0xff;
> +	arr[11] = scsi_debug_sector_size & 0xff;
>  	return fill_from_dev_buffer(scp, arr,
>  				    min(alloc_len, SDEBUG_READCAP16_ARR_SZ));
>  }
> @@ -1026,8 +1023,8 @@
>          memcpy(p, format_pg, sizeof(format_pg));
>          p[10] = (sdebug_sectors_per >> 8) & 0xff;
>          p[11] = sdebug_sectors_per & 0xff;
> -        p[12] = (SECT_SIZE >> 8) & 0xff;
> -        p[13] = SECT_SIZE & 0xff;
> +        p[12] = (scsi_debug_sector_size >> 8) & 0xff;
> +        p[13] = scsi_debug_sector_size & 0xff;
>          if (DEV_REMOVEABLE(target))
>                  p[20] |= 0x20; /* should agree with INQUIRY */
>          if (1 == pcontrol)
> @@ -1206,8 +1203,8 @@
>  			ap[2] = (sdebug_capacity >> 8) & 0xff;
>  			ap[3] = sdebug_capacity & 0xff;
>  		}
> -        	ap[6] = (SECT_SIZE_PER(target) >> 8) & 0xff;
> -        	ap[7] = SECT_SIZE_PER(target) & 0xff;
> +        	ap[6] = (scsi_debug_sector_size >> 8) & 0xff;
> +        	ap[7] = scsi_debug_sector_size & 0xff;
>  		offset += bd_len;
>  		ap = arr + offset;
>  	} else if (16 == bd_len) {
> @@ -1215,10 +1212,10 @@
>  
>          	for (k = 0; k < 8; ++k, capac >>= 8)
>                  	ap[7 - k] = capac & 0xff;
> -        	ap[12] = (SECT_SIZE_PER(target) >> 24) & 0xff;
> -        	ap[13] = (SECT_SIZE_PER(target) >> 16) & 0xff;
> -        	ap[14] = (SECT_SIZE_PER(target) >> 8) & 0xff;
> -        	ap[15] = SECT_SIZE_PER(target) & 0xff;
> +        	ap[12] = (scsi_debug_sector_size >> 24) & 0xff;
> +        	ap[13] = (scsi_debug_sector_size >> 16) & 0xff;
> +        	ap[14] = (scsi_debug_sector_size >> 8) & 0xff;
> +        	ap[15] = scsi_debug_sector_size & 0xff;
>  		offset += bd_len;
>  		ap = arr + offset;
>  	}
> @@ -1519,10 +1516,10 @@
>  	if (block + num > sdebug_store_sectors)
>  		rest = block + num - sdebug_store_sectors;
>  
> -	ret = func(scmd, fake_storep + (block * SECT_SIZE),
> -		   (num - rest) * SECT_SIZE);
> +	ret = func(scmd, fake_storep + (block * scsi_debug_sector_size),
> +		   (num - rest) * scsi_debug_sector_size);
>  	if (!ret && rest)
> -		ret = func(scmd, fake_storep, rest * SECT_SIZE);
> +		ret = func(scmd, fake_storep, rest * scsi_debug_sector_size);
>  
>  	return ret;
>  }
> @@ -1575,10 +1572,10 @@
>  	write_unlock_irqrestore(&atomic_rw, iflags);
>  	if (-1 == ret)
>  		return (DID_ERROR << 16);
> -	else if ((ret < (num * SECT_SIZE)) &&
> +	else if ((ret < (num * scsi_debug_sector_size)) &&
>  		 (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts))
>  		printk(KERN_INFO "scsi_debug: write: cdb indicated=%u, "
> -		       " IO sent=%d bytes\n", num * SECT_SIZE, ret);
> +		       " IO sent=%d bytes\n", num * scsi_debug_sector_size, ret);
>  	return 0;
>  }
>  
> @@ -2085,6 +2082,7 @@
>  module_param_named(virtual_gb, scsi_debug_virtual_gb, int, S_IRUGO | S_IWUSR);
>  module_param_named(vpd_use_hostno, scsi_debug_vpd_use_hostno, int,
>  		   S_IRUGO | S_IWUSR);
> +module_param_named(sector_size, scsi_debug_sector_size, int, S_IRUGO);
>  
>  MODULE_AUTHOR("Eric Youngdale + Douglas Gilbert");
>  MODULE_DESCRIPTION("SCSI debug adapter driver");
> @@ -2106,6 +2104,7 @@
>  MODULE_PARM_DESC(scsi_level, "SCSI level to simulate(def=5[SPC-3])");
>  MODULE_PARM_DESC(virtual_gb, "virtual gigabyte size (def=0 -> use dev_size_mb)");
>  MODULE_PARM_DESC(vpd_use_hostno, "0 -> dev ids ignore hostno (def=1 -> unique dev ids)");
> +MODULE_PARM_DESC(sector_size, "hardware sector size in bytes (def=512)");
>  
>  
>  static char sdebug_info[256];
> @@ -2158,8 +2157,9 @@
>  	    scsi_debug_dev_size_mb, scsi_debug_opts, scsi_debug_every_nth,
>  	    scsi_debug_cmnd_count, scsi_debug_delay,
>  	    scsi_debug_max_luns, scsi_debug_scsi_level,
> -	    SECT_SIZE, sdebug_cylinders_per, sdebug_heads, sdebug_sectors_per,
> -	    num_aborts, num_dev_resets, num_bus_resets, num_host_resets);
> +	    scsi_debug_sector_size, sdebug_cylinders_per, sdebug_heads,
> +	    sdebug_sectors_per, num_aborts, num_dev_resets, num_bus_resets,
> +	    num_host_resets);
>  	if (pos < offset) {
>  		len = 0;
>  		begin = pos;
> @@ -2434,6 +2434,12 @@
>  DRIVER_ATTR(vpd_use_hostno, S_IRUGO | S_IWUSR, sdebug_vpd_use_hostno_show,
>  	    sdebug_vpd_use_hostno_store);
>  
> +static ssize_t sdebug_sector_size_show(struct device_driver * ddp, char * buf)
> +{
> +	return scnprintf(buf, PAGE_SIZE, "%u\n", scsi_debug_sector_size);
> +}
> +DRIVER_ATTR(sector_size, S_IRUGO, sdebug_sector_size_show, NULL);
> +
>  /* Note: The following function creates attribute files in the
>     /sys/bus/pseudo/drivers/scsi_debug directory. The advantage of these
>     files (over those found in the /sys/module/scsi_debug/parameters
> @@ -2459,11 +2465,13 @@
>  	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_scsi_level);
>  	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_virtual_gb);
>  	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_vpd_use_hostno);
> +	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_sector_size);
>  	return ret;
>  }
>  
>  static void do_remove_driverfs_files(void)
>  {
> +	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_sector_size);
>  	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_vpd_use_hostno);
>  	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_virtual_gb);
>  	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_scsi_level);
> @@ -2499,10 +2507,22 @@
>  	int k;
>  	int ret;
>  
> +	switch (scsi_debug_sector_size) {
> +	case  512:
> +	case 1024:
> +	case 2048:
> +	case 4096:
> +		break;
> +	default:
> +		printk(KERN_ERR "scsi_debug_init: invalid sector_size %u\n",
> +		       scsi_debug_sector_size);
> +		return -EINVAL;
> +	}
> +
>  	if (scsi_debug_dev_size_mb < 1)
>  		scsi_debug_dev_size_mb = 1;  /* force minimum 1 MB ramdisk */
>  	sz = (unsigned long)scsi_debug_dev_size_mb * 1048576;
> -	sdebug_store_sectors = sz / SECT_SIZE;
> +	sdebug_store_sectors = sz / scsi_debug_sector_size;
>  	sdebug_capacity = get_sdebug_capacity();
>  
>  	/* play around with geometry, don't waste too much on track 0 */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

