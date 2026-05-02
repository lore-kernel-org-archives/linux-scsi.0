Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7461EFFA1;
	Sat,  2 May 2026 10:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777716345; cv=none; b=WSph55sVKNSSNQK3EWC2kppYl3j9HFtfSCL97rCmeNbrE3e58ywGloj1y8R269GwYIFFahcVxYxEQ8EYqAM6v2eRnYzgEC7Jiyo620AB1m6bKRtvrD0a0mcyilQiJAm5OVrzXG0fH0w+fGxcFFTwseLHR1KLJGERhBSEPO++eD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777716345; c=relaxed/simple;
	bh=uq2bOvLEkmgCo8Bu84XCAzvOq4KhZu9o+xDJw1MQcZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G2gIdEXgkcoH/04YFAYN49asqU42GP11yrAVWIUKnFa+nNZlUiydIJstLHDvGStwbEq4l93cO5bGeU4NORn3GNiDmj/YBFOOPhDaJRKXpmEbeEjCl0Xecr5FJFsGh4jRcZtOB2npGkD62tIHeh5k13axZHspX2boo1ayeRhtY9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O9ab9ArZ; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O9ab9ArZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777716344; x=1809252344;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uq2bOvLEkmgCo8Bu84XCAzvOq4KhZu9o+xDJw1MQcZM=;
  b=O9ab9ArZy3v2WnxFPigWsAqB1TZaX3x00z3Gn32GoCHuTARXykolGvUD
   CttRPf36b9Ptypqso5LfSA343vfKJTlFZPu2i3sIHw/mSBnfKvj82XGey
   iLajYJzwbRJDS0RuUuXVnx9WVpYrGWXHfTnrKjShQMhTtW0iJa+A3Fcl2
   wNBLjRwTJWagLvXHX/pKc2qIOgZSCxAlwt5hna3r1/7V0DeUXF1CI9cFP
   NweGcttVEpaCkbHPWphFRLXoFXSoAN1O4gdQ5jCje/zDv3Vh1RODTEyst
   glHdErOeJ/VvG8TojyB3Zkk6/QfhnSVxwver/ZgnjDX6nqys+KrCHOAFR
   w==;
X-CSE-ConnectionGUID: 5JIPj4AGTB6YdzKo7OAupA==
X-CSE-MsgGUID: oHMXJ9+lRYaoCwj7kFAOuQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11773"; a="82528514"
X-IronPort-AV: E=Sophos;i="6.23,211,1770624000"; 
   d="scan'208";a="82528514"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2026 03:05:43 -0700
X-CSE-ConnectionGUID: hQnI6NktTc+wwvgZEXZuVw==
X-CSE-MsgGUID: VqP9tB1sRRm2FJXz5SU7Qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,211,1770624000"; 
   d="scan'208";a="231935543"
Received: from lkp-server01.sh.intel.com (HELO 781826d00641) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 02 May 2026 03:05:41 -0700
Received: from kbuild by 781826d00641 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wJ7E9-000000001Jd-45oj;
	Sat, 02 May 2026 10:05:37 +0000
Date: Sat, 2 May 2026 18:05:26 +0800
From: kernel test robot <lkp@intel.com>
To: Hongjie Fang <hongjiefang@asrmicro.com>, alim.akhtar@samsung.com,
	avri.altman@wdc.com, bvanassche@acm.org,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] scsi: ufs: core: call hibern8 notify when hibern8 cmd
 failed
Message-ID: <202605021742.XyNEfM7G-lkp@intel.com>
References: <20260430042212.3712251-1-hongjiefang@asrmicro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430042212.3712251-1-hongjiefang@asrmicro.com>

Hi Hongjie,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v7.1-rc1 next-20260430]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Hongjie-Fang/scsi-ufs-core-call-hibern8-notify-when-hibern8-cmd-failed/20260501-050358
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20260430042212.3712251-1-hongjiefang%40asrmicro.com
patch subject: [PATCH v3] scsi: ufs: core: call hibern8 notify when hibern8 cmd failed
config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20260502/202605021742.XyNEfM7G-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260502/202605021742.XyNEfM7G-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605021742.XyNEfM7G-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/ufs/host/ufs-exynos.c: In function 'exynos_ufs_hce_enable_notify':
>> drivers/ufs/host/ufs-exynos.c:1614:9: warning: enumeration value 'ROLLBACK_CHANGE' not handled in switch [-Wswitch]
    1614 |         switch (status) {
         |         ^~~~~~
   drivers/ufs/host/ufs-exynos.c: In function 'exynos_ufs_link_startup_notify':
   drivers/ufs/host/ufs-exynos.c:1654:9: warning: enumeration value 'ROLLBACK_CHANGE' not handled in switch [-Wswitch]
    1654 |         switch (status) {
         |         ^~~~~~
   drivers/ufs/host/ufs-exynos.c: In function 'exynos_ufs_pwr_change_notify':
   drivers/ufs/host/ufs-exynos.c:1687:9: warning: enumeration value 'ROLLBACK_CHANGE' not handled in switch [-Wswitch]
    1687 |         switch (status) {
         |         ^~~~~~


vim +/ROLLBACK_CHANGE +1614 drivers/ufs/host/ufs-exynos.c

55f4b1f73631a08 drivers/scsi/ufs/ufs-exynos.c Alim Akhtar     2020-05-28  1607  
55f4b1f73631a08 drivers/scsi/ufs/ufs-exynos.c Alim Akhtar     2020-05-28  1608  static int exynos_ufs_hce_enable_notify(struct ufs_hba *hba,
55f4b1f73631a08 drivers/scsi/ufs/ufs-exynos.c Alim Akhtar     2020-05-28  1609  					enum ufs_notify_change_status status)
55f4b1f73631a08 drivers/scsi/ufs/ufs-exynos.c Alim Akhtar     2020-05-28  1610  {
55f4b1f73631a08 drivers/scsi/ufs/ufs-exynos.c Alim Akhtar     2020-05-28  1611  	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
55f4b1f73631a08 drivers/scsi/ufs/ufs-exynos.c Alim Akhtar     2020-05-28  1612  	int ret = 0;
55f4b1f73631a08 drivers/scsi/ufs/ufs-exynos.c Alim Akhtar     2020-05-28  1613  
55f4b1f73631a08 drivers/scsi/ufs/ufs-exynos.c Alim Akhtar     2020-05-28 @1614  	switch (status) {
55f4b1f73631a08 drivers/scsi/ufs/ufs-exynos.c Alim Akhtar     2020-05-28  1615  	case PRE_CHANGE:
9a80bc5debf74b0 drivers/ufs/host/ufs-exynos.c Bart Van Assche 2023-01-12  1616  		/*
9a80bc5debf74b0 drivers/ufs/host/ufs-exynos.c Bart Van Assche 2023-01-12  1617  		 * The maximum segment size must be set after scsi_host_alloc()
9a80bc5debf74b0 drivers/ufs/host/ufs-exynos.c Bart Van Assche 2023-01-12  1618  		 * has been called and before LUN scanning starts
9a80bc5debf74b0 drivers/ufs/host/ufs-exynos.c Bart Van Assche 2023-01-12  1619  		 * (ufshcd_async_scan()). Note: this callback may also be called
9a80bc5debf74b0 drivers/ufs/host/ufs-exynos.c Bart Van Assche 2023-01-12  1620  		 * from other functions than ufshcd_init().
9a80bc5debf74b0 drivers/ufs/host/ufs-exynos.c Bart Van Assche 2023-01-12  1621  		 */
c96499fcb403b18 drivers/ufs/host/ufs-exynos.c Eric Biggers    2024-07-08  1622  		hba->host->max_segment_size = DATA_UNIT_SIZE;
9a80bc5debf74b0 drivers/ufs/host/ufs-exynos.c Bart Van Assche 2023-01-12  1623  
52e5035f7b079be drivers/scsi/ufs/ufs-exynos.c Chanho Park     2021-10-18  1624  		if (ufs->drv_data->pre_hce_enable) {
52e5035f7b079be drivers/scsi/ufs/ufs-exynos.c Chanho Park     2021-10-18  1625  			ret = ufs->drv_data->pre_hce_enable(ufs);
52e5035f7b079be drivers/scsi/ufs/ufs-exynos.c Chanho Park     2021-10-18  1626  			if (ret)
52e5035f7b079be drivers/scsi/ufs/ufs-exynos.c Chanho Park     2021-10-18  1627  				return ret;
52e5035f7b079be drivers/scsi/ufs/ufs-exynos.c Chanho Park     2021-10-18  1628  		}
52e5035f7b079be drivers/scsi/ufs/ufs-exynos.c Chanho Park     2021-10-18  1629  
55f4b1f73631a08 drivers/scsi/ufs/ufs-exynos.c Alim Akhtar     2020-05-28  1630  		ret = exynos_ufs_host_reset(hba);
55f4b1f73631a08 drivers/scsi/ufs/ufs-exynos.c Alim Akhtar     2020-05-28  1631  		if (ret)
55f4b1f73631a08 drivers/scsi/ufs/ufs-exynos.c Alim Akhtar     2020-05-28  1632  			return ret;
55f4b1f73631a08 drivers/scsi/ufs/ufs-exynos.c Alim Akhtar     2020-05-28  1633  		exynos_ufs_dev_hw_reset(hba);
55f4b1f73631a08 drivers/scsi/ufs/ufs-exynos.c Alim Akhtar     2020-05-28  1634  		break;
55f4b1f73631a08 drivers/scsi/ufs/ufs-exynos.c Alim Akhtar     2020-05-28  1635  	case POST_CHANGE:
55f4b1f73631a08 drivers/scsi/ufs/ufs-exynos.c Alim Akhtar     2020-05-28  1636  		exynos_ufs_calc_pwm_clk_div(ufs);
55f4b1f73631a08 drivers/scsi/ufs/ufs-exynos.c Alim Akhtar     2020-05-28  1637  		if (!(ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL))
55f4b1f73631a08 drivers/scsi/ufs/ufs-exynos.c Alim Akhtar     2020-05-28  1638  			exynos_ufs_enable_auto_ctrl_hcc(ufs);
52e5035f7b079be drivers/scsi/ufs/ufs-exynos.c Chanho Park     2021-10-18  1639  
52e5035f7b079be drivers/scsi/ufs/ufs-exynos.c Chanho Park     2021-10-18  1640  		if (ufs->drv_data->post_hce_enable)
52e5035f7b079be drivers/scsi/ufs/ufs-exynos.c Chanho Park     2021-10-18  1641  			ret = ufs->drv_data->post_hce_enable(ufs);
52e5035f7b079be drivers/scsi/ufs/ufs-exynos.c Chanho Park     2021-10-18  1642  
55f4b1f73631a08 drivers/scsi/ufs/ufs-exynos.c Alim Akhtar     2020-05-28  1643  		break;
55f4b1f73631a08 drivers/scsi/ufs/ufs-exynos.c Alim Akhtar     2020-05-28  1644  	}
55f4b1f73631a08 drivers/scsi/ufs/ufs-exynos.c Alim Akhtar     2020-05-28  1645  
55f4b1f73631a08 drivers/scsi/ufs/ufs-exynos.c Alim Akhtar     2020-05-28  1646  	return ret;
55f4b1f73631a08 drivers/scsi/ufs/ufs-exynos.c Alim Akhtar     2020-05-28  1647  }
55f4b1f73631a08 drivers/scsi/ufs/ufs-exynos.c Alim Akhtar     2020-05-28  1648  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
