Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DAD219E8;
	Sat,  9 Aug 2025 08:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754727441; cv=none; b=VgDeREJb58+KLmg+v++ZSNg9xyPabXLRFKkWllJ0oH5fDzQ3zyWnhK5R9TI2bouIAL9FLVww+pHwhvHRVpRgZWxzeMNvgAPsIFRC2oS2E1FxLoak3YdaitrbkvHYUO22j72Wt79+xQmtgsxIL7WcCpultGJp3roNsb1wmKyJ+lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754727441; c=relaxed/simple;
	bh=2YSZy7Wa2RklNltVg30MuT+diQJQvzunPDVhj+9/SR0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qckTwOibGnEWcLSi7Ppn6uSGiBxuSCal7NIc5xynOSnFTW1Verze25SoHOJEOSr3mVibHR0a0y7UTjp6DF3DvEqPkbeIfQaaLpZNkvxr+ijG+orENYDMJvgzh/jmD3CMXuc/AQhMf+3Vvg6bUmWSi22fpvGz/sVs3pJlm3QBZDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ievb2aAE; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ievb2aAE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754727439; x=1786263439;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2YSZy7Wa2RklNltVg30MuT+diQJQvzunPDVhj+9/SR0=;
  b=ievb2aAEsLJVJ3AaOpwTeddO4F/Eh3HqZiId5BGuuRBGhzMWiydFWR61
   2euJGDZXlrZoQeFqUPWKYExn+xWGW7IblYns94Bcm5sE07Tz7urDzoz7a
   50gXj66qnMjeEVmWOBllIqVgh2LBAddsFredGulM7EDuOEnS3t4FUZEjM
   Kz//Hds28/Puj99ESXUaTaW/NdZh++l3BTxnHvYQWO8ZjehBfioSCoERN
   pP+KcL9LqU8tFQZwjWVpuSI8/cM5V6PgZ3Wmae7plGnp/8vkBy8mLNR85
   NCicxJnhGHA9itm85FVmz8lGvNUicDodIWv0XoT9+IbODp7ENEZo7hB/J
   Q==;
X-CSE-ConnectionGUID: /4x983GkRLmWcHL3yuzlAQ==
X-CSE-MsgGUID: /hO5qcNOTq+qHSzqVsHPDA==
X-IronPort-AV: E=McAfee;i="6800,10657,11515"; a="60864068"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="60864068"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2025 01:17:18 -0700
X-CSE-ConnectionGUID: LZnx3N6iS1u8B8S2+Ekigw==
X-CSE-MsgGUID: H05uyA1fQV6ht5YdS4wrqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="165816372"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa008.jf.intel.com with ESMTP; 09 Aug 2025 01:17:16 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ukelN-0004gc-1G;
	Sat, 09 Aug 2025 08:17:13 +0000
Date: Sat, 9 Aug 2025 16:17:09 +0800
From: kernel test robot <lkp@intel.com>
To: Abinash Singh <abinashsinghlalotra@gmail.com>, bvanassche@acm.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	James.Bottomley@hansenpartnership.com,
	abinashsinghlalotra@gmail.com, dlemoal@kernel.org,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Subject: Re: [PATCH v5 2/2] scsi: sd: Fix build warning in
 sd_revalidate_disk()
Message-ID: <202508091640.gvFPjI6O-lkp@intel.com>
References: <20250808205819.29517-3-abinashsinghlalotra@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250808205819.29517-3-abinashsinghlalotra@gmail.com>

Hi Abinash,

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next linus/master v6.16 next-20250808]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Abinash-Singh/scsi-sd-make-sd_revalidate_disk-return-void/20250809-045941
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20250808205819.29517-3-abinashsinghlalotra%40gmail.com
patch subject: [PATCH v5 2/2] scsi: sd: Fix build warning in sd_revalidate_disk()
config: x86_64-buildonly-randconfig-002-20250809 (https://download.01.org/0day-ci/archive/20250809/202508091640.gvFPjI6O-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250809/202508091640.gvFPjI6O-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508091640.gvFPjI6O-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/scsi/sd.c:3709:16: error: call to undeclared function 'size'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    3709 |         lim = kmalloc(size(*lim), GFP_KERNEL);
         |                       ^
   drivers/scsi/sd.c:3709:16: note: did you mean 'ksize'?
   include/linux/slab.h:491:8: note: 'ksize' declared here
     491 | size_t ksize(const void *objp);
         |        ^
   1 error generated.


vim +/size +3709 drivers/scsi/sd.c

  3683	
  3684	/**
  3685	 *	sd_revalidate_disk - called the first time a new disk is seen,
  3686	 *	performs disk spin up, read_capacity, etc.
  3687	 *	@disk: struct gendisk we care about
  3688	 **/
  3689	static void sd_revalidate_disk(struct gendisk *disk)
  3690	{
  3691		struct scsi_disk *sdkp = scsi_disk(disk);
  3692		struct scsi_device *sdp = sdkp->device;
  3693		sector_t old_capacity = sdkp->capacity;
  3694		struct queue_limits *lim = NULL;
  3695		unsigned char *buffer = NULL;
  3696		unsigned int dev_max;
  3697		int err;
  3698	
  3699		SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
  3700					      "sd_revalidate_disk\n"));
  3701	
  3702		/*
  3703		 * If the device is offline, don't try and read capacity or any
  3704		 * of the other niceties.
  3705		 */
  3706		if (!scsi_device_online(sdp))
  3707			goto out;
  3708	
> 3709		lim = kmalloc(size(*lim), GFP_KERNEL);
  3710		if (!lim) {
  3711			sd_printk(KERN_WARNING, sdkp,
  3712				"sd_revalidate_disk: Disk limit allocation failure.\n");
  3713			goto out;
  3714		}
  3715	
  3716		buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL);
  3717		if (!buffer) {
  3718			sd_printk(KERN_WARNING, sdkp, "sd_revalidate_disk: Memory "
  3719				  "allocation failure.\n");
  3720			goto out;
  3721		}
  3722	
  3723		sd_spinup_disk(sdkp);
  3724	
  3725		*lim = queue_limits_start_update(sdkp->disk->queue);
  3726	
  3727		/*
  3728		 * Without media there is no reason to ask; moreover, some devices
  3729		 * react badly if we do.
  3730		 */
  3731		if (sdkp->media_present) {
  3732			sd_read_capacity(sdkp, lim, buffer);
  3733			/*
  3734			 * Some USB/UAS devices return generic values for mode pages
  3735			 * until the media has been accessed. Trigger a READ operation
  3736			 * to force the device to populate mode pages.
  3737			 */
  3738			if (sdp->read_before_ms)
  3739				sd_read_block_zero(sdkp);
  3740			/*
  3741			 * set the default to rotational.  All non-rotational devices
  3742			 * support the block characteristics VPD page, which will
  3743			 * cause this to be updated correctly and any device which
  3744			 * doesn't support it should be treated as rotational.
  3745			 */
  3746			lim->features |= (BLK_FEAT_ROTATIONAL | BLK_FEAT_ADD_RANDOM);
  3747	
  3748			if (scsi_device_supports_vpd(sdp)) {
  3749				sd_read_block_provisioning(sdkp);
  3750				sd_read_block_limits(sdkp, lim);
  3751				sd_read_block_limits_ext(sdkp);
  3752				sd_read_block_characteristics(sdkp, lim);
  3753				sd_zbc_read_zones(sdkp, lim, buffer);
  3754			}
  3755	
  3756			sd_config_discard(sdkp, lim, sd_discard_mode(sdkp));
  3757	
  3758			sd_print_capacity(sdkp, old_capacity);
  3759	
  3760			sd_read_write_protect_flag(sdkp, buffer);
  3761			sd_read_cache_type(sdkp, buffer);
  3762			sd_read_io_hints(sdkp, buffer);
  3763			sd_read_app_tag_own(sdkp, buffer);
  3764			sd_read_write_same(sdkp, buffer);
  3765			sd_read_security(sdkp, buffer);
  3766			sd_config_protection(sdkp, lim);
  3767		}
  3768	
  3769		/*
  3770		 * We now have all cache related info, determine how we deal
  3771		 * with flush requests.
  3772		 */
  3773		sd_set_flush_flag(sdkp, lim);
  3774	
  3775		/* Initial block count limit based on CDB TRANSFER LENGTH field size. */
  3776		dev_max = sdp->use_16_for_rw ? SD_MAX_XFER_BLOCKS : SD_DEF_XFER_BLOCKS;
  3777	
  3778		/* Some devices report a maximum block count for READ/WRITE requests. */
  3779		dev_max = min_not_zero(dev_max, sdkp->max_xfer_blocks);
  3780		lim->max_dev_sectors = logical_to_sectors(sdp, dev_max);
  3781	
  3782		if (sd_validate_min_xfer_size(sdkp))
  3783			lim->io_min = logical_to_bytes(sdp, sdkp->min_xfer_blocks);
  3784		else
  3785			lim->io_min = 0;
  3786	
  3787		/*
  3788		 * Limit default to SCSI host optimal sector limit if set. There may be
  3789		 * an impact on performance for when the size of a request exceeds this
  3790		 * host limit.
  3791		 */
  3792		lim->io_opt = sdp->host->opt_sectors << SECTOR_SHIFT;
  3793		if (sd_validate_opt_xfer_size(sdkp, dev_max)) {
  3794			lim->io_opt = min_not_zero(lim->io_opt,
  3795					logical_to_bytes(sdp, sdkp->opt_xfer_blocks));
  3796		}
  3797	
  3798		sdkp->first_scan = 0;
  3799	
  3800		set_capacity_and_notify(disk, logical_to_sectors(sdp, sdkp->capacity));
  3801		sd_config_write_same(sdkp, lim);
  3802	
  3803		err = queue_limits_commit_update_frozen(sdkp->disk->queue, lim);
  3804		if (err)
  3805			goto out;
  3806	
  3807		/*
  3808		 * Query concurrent positioning ranges after
  3809		 * queue_limits_commit_update() unlocked q->limits_lock to avoid
  3810		 * deadlock with q->sysfs_dir_lock and q->sysfs_lock.
  3811		 */
  3812		if (sdkp->media_present && scsi_device_supports_vpd(sdp))
  3813			sd_read_cpr(sdkp);
  3814	
  3815		/*
  3816		 * For a zoned drive, revalidating the zones can be done only once
  3817		 * the gendisk capacity is set. So if this fails, set back the gendisk
  3818		 * capacity to 0.
  3819		 */
  3820		if (sd_zbc_revalidate_zones(sdkp))
  3821			set_capacity_and_notify(disk, 0);
  3822	
  3823	 out:
  3824		kfree(lim);
  3825		kfree(buffer);
  3826	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
