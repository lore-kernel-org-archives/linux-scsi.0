Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E723236D513
	for <linux-scsi@vger.kernel.org>; Sat, 29 Nov 2025 21:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764450035; cv=none; b=blbSPAr/E8ceS8tfKSHuLMFv/8LG4ObAmbNDl3+A8Hn3P+FS0rxLx/Dw9Vo7Ecxvdiiad2Hfzd0b3AXEbQVLnqQ7fRuIQ1AtHt2+VxoXJ+/pK/3OQeM+276znjbTja91ZP2aJA081QTJNeQQfRSBLwMgko9AcLGHvkCK/hO28UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764450035; c=relaxed/simple;
	bh=jFGH6JAZWVZctcxMT4SvYIg1yLcOJOKAySE0k39POAE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=otNtrR54FTf7HDt9X0wnn1DlcrRbwFPyFTQWkSxMRYcgBmXadR4aDv7xbodgF8JCMXIjtte4F7x/GhEo1MYgsqXr20kZ3DQi8Kh1rNiTRcMkPA1SoeMgLtokS9Vvl+86Z6BXcpXfW5mCYoSMe3krwUTTWFGgI0e4YZVxsqc8u8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cl4k5Xw5; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cl4k5Xw5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764450034; x=1795986034;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=jFGH6JAZWVZctcxMT4SvYIg1yLcOJOKAySE0k39POAE=;
  b=cl4k5Xw5jiV97pGxnByHQLHjr94vu2b6vsuaEGB7mUv1aF+UM10B7/Jq
   ISryDkFc1ITZk+Pbq/xyA6QxMu2G1cHseXA+mC3hlA4We6oEVYZwRcNiO
   aX/+mQo02u20y/ZcAIMNoTmarGqHPiUewcpGFCpY4/iZOG7zwYBMUJR/9
   nLGlia6CQ/NBPozUobWcDVklbOfbGtDOqalS7yrrUV169bD7DNu2B4hMR
   TU1p2dqFC+FMg4aDIwubXg4imBbD/wq22VkpQMNcth+osIMfZLWqN2kYP
   /emI5I1fcsg7U7Rl6Pkw0DAfcoTGCo8ybR1BE0Zd7aaIQkdUgoK53h6T5
   w==;
X-CSE-ConnectionGUID: vC6s5bmTRd+AfVIuWv614w==
X-CSE-MsgGUID: 7BKDAErnQvGhI116Y+h5Iw==
X-IronPort-AV: E=McAfee;i="6800,10657,11628"; a="77788355"
X-IronPort-AV: E=Sophos;i="6.20,237,1758610800"; 
   d="scan'208";a="77788355"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2025 13:00:33 -0800
X-CSE-ConnectionGUID: OckHkw/pSCCe1c5rmaNmUg==
X-CSE-MsgGUID: C5VZLRE9TcyfmPE/WE6oIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,237,1758610800"; 
   d="scan'208";a="194141200"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 29 Nov 2025 13:00:31 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vPS3R-000000007af-1Y35;
	Sat, 29 Nov 2025 21:00:29 +0000
Date: Sun, 30 Nov 2025 04:59:59 +0800
From: kernel test robot <lkp@intel.com>
To: Bean Huo <beanhuo@micron.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [jejb-scsi:misc 448/524] drivers/ufs/core/ufshcd.c:8950:undefined
 reference to `ufs_rpmb_probe'
Message-ID: <202511300443.h7sotuL0-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git misc
head:   82f78acd5a9270370ef4aa3f032ede25f3dc91ee
commit: b06b8c421485e0e96d7fd6aa614fb0b6f2778a03 [448/524] scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices
config: x86_64-randconfig-073-20251129 (https://download.01.org/0day-ci/archive/20251130/202511300443.h7sotuL0-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251130/202511300443.h7sotuL0-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511300443.h7sotuL0-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: vmlinux.o: in function `ufshcd_add_lus':
>> drivers/ufs/core/ufshcd.c:8950:(.text+0x17b6348): undefined reference to `ufs_rpmb_probe'
   ld: vmlinux.o: in function `ufshcd_remove':
>> drivers/ufs/core/ufshcd.c:10505:(.text+0x17b8ec4): undefined reference to `ufs_rpmb_remove'


vim +8950 drivers/ufs/core/ufshcd.c

  8909	
  8910	/**
  8911	 * ufshcd_add_lus - probe and add UFS logical units
  8912	 * @hba: per-adapter instance
  8913	 *
  8914	 * Return: 0 upon success; < 0 upon failure.
  8915	 */
  8916	static int ufshcd_add_lus(struct ufs_hba *hba)
  8917	{
  8918		int ret;
  8919	
  8920		/* Add required well known logical units to scsi mid layer */
  8921		ret = ufshcd_scsi_add_wlus(hba);
  8922		if (ret)
  8923			goto out;
  8924	
  8925		/* Initialize devfreq after UFS device is detected */
  8926		if (ufshcd_is_clkscaling_supported(hba)) {
  8927			memcpy(&hba->clk_scaling.saved_pwr_info,
  8928				&hba->pwr_info,
  8929				sizeof(struct ufs_pa_layer_attr));
  8930			hba->clk_scaling.is_allowed = true;
  8931	
  8932			ret = ufshcd_devfreq_init(hba);
  8933			if (ret)
  8934				goto out;
  8935	
  8936			hba->clk_scaling.is_enabled = true;
  8937			ufshcd_init_clk_scaling_sysfs(hba);
  8938		}
  8939	
  8940		/*
  8941		 * The RTC update code accesses the hba->ufs_device_wlun->sdev_gendev
  8942		 * pointer and hence must only be started after the WLUN pointer has
  8943		 * been initialized by ufshcd_scsi_add_wlus().
  8944		 */
  8945		schedule_delayed_work(&hba->ufs_rtc_update_work,
  8946				      msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));
  8947	
  8948		ufs_bsg_probe(hba);
  8949		scsi_scan_host(hba->host);
> 8950		ufs_rpmb_probe(hba);
  8951	
  8952	out:
  8953		return ret;
  8954	}
  8955	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
