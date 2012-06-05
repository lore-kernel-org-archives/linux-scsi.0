From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 1/1] [SCSI] scsi_debug: Add "removable" parameter
Date: Tue, 05 Jun 2012 09:16:30 -0700
Message-ID: <4FCE30DE.6090903@xenotime.net>
References: <20120605072528.GE3043@piware.de> <20120605072737.GF3043@piware.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120605072737.GF3043@piware.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Martin Pitt <martin.pitt@ubuntu.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, David Zeuthen <zeuthen@gmail.com>, Kay Sievers <kay@vrfy.org>
List-Id: linux-scsi@vger.kernel.org

On 06/05/2012 12:27 AM, Martin Pitt wrote:

> Add "removable" module parameter to set the "removable" attribute of any
> subsequently created debug block device. It is a writable driver option, so
> that you can switch between removable and "fixed" media block devices in
> between the add_host calls.
> 
> This is useful for being able to test the different behaviour/required
> privileges in e. g. the udisks test suite.
> 
> Signed-off-by: Martin Pitt <martin.pitt@ubuntu.com>
> Signed-off-by: David Zeuthen <zeuthen@gmail.com>
> ---
>  drivers/scsi/scsi_debug.c |   35 ++++++++++++++++++++++++++++++++---
>  1 files changed, 32 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 182d5a5..6eaa95e 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -109,6 +109,7 @@ static const char * scsi_debug_version_date = "20100324";
>  #define DEF_OPT_BLKS 64
>  #define DEF_PHYSBLK_EXP 0
>  #define DEF_PTYPE   0
> +#define DEF_REMOVABLE 0
>  #define DEF_SCSI_LEVEL   5    /* INQUIRY, byte2 [5->SPC-3] */
>  #define DEF_SECTOR_SIZE 512
>  #define DEF_UNMAP_ALIGNMENT 0
> @@ -180,6 +181,7 @@ static int scsi_debug_opt_blks = DEF_OPT_BLKS;
>  static int scsi_debug_opts = DEF_OPTS;
>  static int scsi_debug_physblk_exp = DEF_PHYSBLK_EXP;
>  static int scsi_debug_ptype = DEF_PTYPE; /* SCSI peripheral type (0==disk) */
> +static int scsi_debug_removable = DEF_REMOVABLE;
>  static int scsi_debug_scsi_level = DEF_SCSI_LEVEL;
>  static int scsi_debug_sector_size = DEF_SECTOR_SIZE;
>  static int scsi_debug_virtual_gb = DEF_VIRTUAL_GB;
> @@ -2754,6 +2755,7 @@ module_param_named(opt_blks, scsi_debug_opt_blks, int, S_IRUGO);
>  module_param_named(opts, scsi_debug_opts, int, S_IRUGO | S_IWUSR);
>  module_param_named(physblk_exp, scsi_debug_physblk_exp, int, S_IRUGO);
>  module_param_named(ptype, scsi_debug_ptype, int, S_IRUGO | S_IWUSR);
> +module_param_named(removable, scsi_debug_removable, int, S_IRUGO | S_IWUSR);
>  module_param_named(scsi_level, scsi_debug_scsi_level, int, S_IRUGO);
>  module_param_named(sector_size, scsi_debug_sector_size, int, S_IRUGO);
>  module_param_named(unmap_alignment, scsi_debug_unmap_alignment, int, S_IRUGO);
> @@ -2796,6 +2798,7 @@ MODULE_PARM_DESC(opt_blks, "optimal transfer length in block (def=64)");
>  MODULE_PARM_DESC(opts, "1->noise, 2->medium_err, 4->timeout, 8->recovered_err... (def=0)");
>  MODULE_PARM_DESC(physblk_exp, "physical block exponent (def=0)");
>  MODULE_PARM_DESC(ptype, "SCSI peripheral type(def=0[disk])");
> +MODULE_PARM_DESC(removable, "claim to have removable media (def=0)");
>  MODULE_PARM_DESC(scsi_level, "SCSI level to simulate(def=5[SPC-3])");
>  MODULE_PARM_DESC(sector_size, "logical block size in bytes (def=512)");
>  MODULE_PARM_DESC(unmap_alignment, "lowest aligned thin provisioning lba (def=0)");
> @@ -3205,6 +3208,25 @@ static ssize_t sdebug_map_show(struct device_driver *ddp, char *buf)
>  }
>  DRIVER_ATTR(map, S_IRUGO, sdebug_map_show, NULL);
>  
> +static ssize_t sdebug_removable_show(struct device_driver *ddp,
> +				     char *buf)
> +{
> +	return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_removable);
> +}
> +static ssize_t sdebug_removable_store(struct device_driver *ddp,
> +				      const char *buf, size_t count)
> +{
> +	int n;
> +
> +	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
> +		scsi_debug_removable = n;
> +		return count;
> +	}
> +	return -EINVAL;
> +}
> +DRIVER_ATTR(removable, S_IRUGO | S_IWUSR, sdebug_removable_show,
> +	    sdebug_removable_store);
> +
>  
>  /* Note: The following function creates attribute files in the
>     /sys/bus/pseudo/drivers/scsi_debug directory. The advantage of these
> @@ -3325,6 +3349,11 @@ static int __init scsi_debug_init(void)
>  		return -EINVAL;
>  	}
>  
> +	if (scsi_debug_removable > 1) {
> +		printk(KERN_ERR "scsi_debug_init: removable must be 0 or 1\n");
> +		return -EINVAL;
> +	}
> +


so why not make it a bool instead of an int value?


>  	if (scsi_debug_dev_size_mb < 1)
>  		scsi_debug_dev_size_mb = 1;  /* force minimum 1 MB ramdisk */
>  	sz = (unsigned long)scsi_debug_dev_size_mb * 1048576;



-- 
~Randy
