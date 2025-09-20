Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F092F2110E
	for <linux-scsi@vger.kernel.org>; Sat, 20 Sep 2025 01:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758332336; cv=none; b=cOsMP/nCS62LPr+dn7J0dowLBB/jrRc7v1wi9j0Xgmn2Sn3kTRerPlddap8dFyT8P/G+OWBwSSh1Tsbc/vPKgUfyKBIbmsR6cVIXgBY2rV70Eecljv+ctGc4mYdemCMySJHgeihYnykFVvg3K6LASHfbY+mJmUEGwyqobdIJtWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758332336; c=relaxed/simple;
	bh=0eoP9lTL22QFCpaEYjyGQCU7y0cT4seEWfVHb9AzdOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ANGBRQ8cIrjBH2JC9QMMZcfiHr6BGDO/KJMK7tCuJSLIL+V4Xw2QZDZ7lhFejAVE2ObT8TT0rFGPB9BoCHPZ1ehb3ZyjtbfufRd+kpOJsDcQz/37lC8qsePSQqEg9z8ZulvIuOZJQoCj+cjBhDqvSFURRm/3UvT3s0JzfEfO5A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nlf1J4xe; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nlf1J4xe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758332335; x=1789868335;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0eoP9lTL22QFCpaEYjyGQCU7y0cT4seEWfVHb9AzdOA=;
  b=Nlf1J4xeRlb/W6n97Vb4bo+JYZVDjhKmSkEn6ZTQaIho8AR1f5oZKV+6
   C6q9gpkHD2aESRRAWkSDoyC1Kd+juXdjxSC+BOODUTdZ7fcKPyT9/383R
   obf2proEKrIXfPWMHtLi5cjwGGprFGT9P77OWIr6e95rQ+jFVuVKY3hex
   l4hAlUeVwLr+cpZ+HJKXkjtJKqKVLC/IpPiQjjUes37PJEk0xO6A/fXj/
   5LiyhbczHjbyFhGyISgSIOxtD9xG5zxA2OiZ381sbjnUlGaKwF8T0CSrA
   8RDJ4hkLZCSnNd/i+Gmb9tFTUk/IF81wHFf8wPCCd6UoPAWz/3Va2zVe0
   A==;
X-CSE-ConnectionGUID: LsqVNFa2SnOvLunXFIrz4A==
X-CSE-MsgGUID: iQRr9uW4Sr61pj3iArR5Yg==
X-IronPort-AV: E=McAfee;i="6800,10657,11558"; a="71307996"
X-IronPort-AV: E=Sophos;i="6.18,279,1751266800"; 
   d="scan'208";a="71307996"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 18:38:54 -0700
X-CSE-ConnectionGUID: Y0wSdOavQbaKY4+4NaI7lg==
X-CSE-MsgGUID: DszBOhVeToWnoMFFhqnguA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,279,1751266800"; 
   d="scan'208";a="206918438"
Received: from lkp-server01.sh.intel.com (HELO 84a20bd60769) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 19 Sep 2025 18:38:52 -0700
Received: from kbuild by 84a20bd60769 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uzmYs-0004wt-05;
	Sat, 20 Sep 2025 01:38:50 +0000
Date: Sat, 20 Sep 2025 09:38:36 +0800
From: kernel test robot <lkp@intel.com>
To: doubled <doubled@leap-io-kernel.com>,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: leapraid: Add new scsi driver
Message-ID: <202509200958.X8eUlp0N-lkp@intel.com>
References: <20250919100032.3931476-1-doubled@leap-io-kernel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919100032.3931476-1-doubled@leap-io-kernel.com>

Hi doubled,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v6.17-rc6 next-20250919]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/doubled/scsi-leapraid-Add-new-scsi-driver/20250919-202535
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20250919100032.3931476-1-doubled%40leap-io-kernel.com
patch subject: [PATCH] scsi: leapraid: Add new scsi driver
config: i386-randconfig-002-20250920 (https://download.01.org/0day-ci/archive/20250920/202509200958.X8eUlp0N-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250920/202509200958.X8eUlp0N-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509200958.X8eUlp0N-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/scsi/leapraid/leapraid_func.c:7478:6: warning: variable 'adapter_state' set but not used [-Wunused-but-set-variable]
    7478 |         u32 adapter_state;
         |             ^
   drivers/scsi/leapraid/leapraid_func.c:93:1: warning: unused function 'leapraid_writeq' [-Wunused-function]
      93 | leapraid_writeq(__u64 info, void __iomem *addr,
         | ^~~~~~~~~~~~~~~
   2 warnings generated.
--
>> Warning: drivers/scsi/leapraid/leapraid_app.c:112 struct member 'r0' not described in 'leapraid_ioctl_adapter_info'
>> Warning: drivers/scsi/leapraid/leapraid_app.c:112 struct member 'r1' not described in 'leapraid_ioctl_adapter_info'
>> Warning: drivers/scsi/leapraid/leapraid_app.c:112 struct member 'r2' not described in 'leapraid_ioctl_adapter_info'


vim +/adapter_state +7478 drivers/scsi/leapraid/leapraid_func.c

  7473	
  7474	static int
  7475	leapraid_adapter_unit_reset(
  7476		struct leapraid_adapter *adapter)
  7477	{
> 7478		u32 adapter_state;
  7479		unsigned long flags;
  7480		int rc = 0;
  7481	
  7482		if (!(adapter->adapter_attr.features.adapter_caps &
  7483			 LEAPRAID_ADAPTER_FEATURES_CAP_EVENT_REPLAY))
  7484			return -EFAULT;
  7485	
  7486		dev_info(&adapter->pdev->dev, "fire unit reset\n");
  7487		writel(LEAPRAID_FUNC_ADAPTER_UNIT_RESET << LEAPRAID_DB_FUNC_SHIFT,
  7488			 &adapter->iomem_base->db);
  7489		if (leapraid_db_wait_ack_and_clear_int(adapter))
  7490			rc = -EFAULT;
  7491	
  7492		adapter_state = leapraid_get_adapter_state(adapter);
  7493		spin_lock_irqsave(&adapter->reset_desc.adapter_reset_lock,
  7494			 flags);
  7495		spin_unlock_irqrestore(&adapter->reset_desc.adapter_reset_lock,
  7496			 flags);
  7497	
  7498		if (!leapraid_wait_adapter_ready(adapter)) {
  7499			rc = -EFAULT;
  7500			goto out;
  7501		}
  7502	out:
  7503		dev_info(&adapter->pdev->dev, "unit reset: %s\n",
  7504			 ((rc == 0) ? "SUCCESS" : "FAILED"));
  7505		return rc;
  7506	}
  7507	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
