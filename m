Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C3A30CDB6
	for <linux-scsi@vger.kernel.org>; Sat, 17 Jan 2026 02:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768615541; cv=none; b=l4zqvgf7UvT1BjnfyvVQvlRegd275GXhdfLgpahEGOyK7pyiIiTDOZQtqjJUM9mT68TQfR8mfRG8SCQfvv3X5BlAm4ji4uSFW17R1uiPW2yF7CU90K/m4c++jliyt060NzY+RXncyn43PpjkFE4i/Q2OOYxjDQPa75MZa3HYYfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768615541; c=relaxed/simple;
	bh=h7Sl2joeSfECTM5ZoFqm0wKTMvEe5jWh6Z/mZZ09eoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=doxofQW9LzlEjHLTR6oSty5eC1deuEgfoJnjiqBoUPPsEzJApR3qd7hFVyY/50+G+Sa/vMnP/VsEmVKrauOikxUAgpi5HDtflM+85/PFzunv8SvadJTuEUDInE9ZcUZXfXF/O+J45ReCH4CFdp//GEPdPVG7LF4TDhEarmID8OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bk1druvf; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bk1druvf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768615539; x=1800151539;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=h7Sl2joeSfECTM5ZoFqm0wKTMvEe5jWh6Z/mZZ09eoU=;
  b=bk1druvfabMIeWFfCXT4Qz8gTG2NysbXVYKctWodXr9tqF5giNtg6C/6
   JbzhlnyHfcXrwH0RBCYxYrhpr+ecECds2hSqoylc/JPOga0OHws1H23ka
   R3oPBV5lxio6Z7tN6Kx4ylOnEuQNjhJBocqHzIZ4O+EUGSDy2Yz1Sf/dd
   RhCyhk3NmJzdlkYns8ZP7u8MRWJoWkhv82goXz3A8kJ8gIG99eoyC3b+I
   87epNfqANr2CQqYKAWlmU/g8S/esz6qA4sMPUOp+yZyrrcj5ULTQ59lRo
   QlX0RHl4Oa/wXhATG39cmerMdNjvpsjCL1HafH1kEr2y/kOPs7z4d8keE
   Q==;
X-CSE-ConnectionGUID: y8L7/b9STG2QazwL31+eGg==
X-CSE-MsgGUID: 3KbZx8DETqGJI1O1DbCE4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11673"; a="69844279"
X-IronPort-AV: E=Sophos;i="6.21,232,1763452800"; 
   d="scan'208";a="69844279"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 18:05:36 -0800
X-CSE-ConnectionGUID: toNzXDEsRMWnn/kmBJJeaQ==
X-CSE-MsgGUID: GPG5X80zRa2x579q4eMQNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,232,1763452800"; 
   d="scan'208";a="205285574"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 16 Jan 2026 18:05:33 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vgvgw-00000000LS4-3FMv;
	Sat, 17 Jan 2026 02:05:30 +0000
Date: Sat, 17 Jan 2026 10:05:16 +0800
From: kernel test robot <lkp@intel.com>
To: Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: Re: [PATCH 3/7] ufs: core: Redirect clock gating to RPM
Message-ID: <202601170903.r8uLs14E-lkp@intel.com>
References: <20260116182628.3255116-4-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116182628.3255116-4-bvanassche@acm.org>

Hi Bart,

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next linus/master v6.19-rc5 next-20260116]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Bart-Van-Assche/ufs-core-Change-the-type-of-an-ufshcd_clkgate_delay_set-argument/20260117-022907
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20260116182628.3255116-4-bvanassche%40acm.org
patch subject: [PATCH 3/7] ufs: core: Redirect clock gating to RPM
config: hexagon-randconfig-002-20260117 (https://download.01.org/0day-ci/archive/20260117/202601170903.r8uLs14E-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260117/202601170903.r8uLs14E-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601170903.r8uLs14E-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/ufs/core/ufshcd.c:2120:22: error: no member named 'use_autosuspend' in 'struct dev_pm_info'
    2120 |         if (!rpm_dev->power.use_autosuspend)
         |              ~~~~~~~~~~~~~~ ^
>> drivers/ufs/core/ufshcd.c:2123:48: error: no member named 'autosuspend_delay' in 'struct dev_pm_info'
    2123 |         return sysfs_emit(buf, "%u\n", rpm_dev->power.autosuspend_delay);
         |                                        ~~~~~~~~~~~~~~ ^
   drivers/ufs/core/ufshcd.c:2143:22: error: no member named 'use_autosuspend' in 'struct dev_pm_info'
    2143 |         if (!rpm_dev->power.use_autosuspend)
         |              ~~~~~~~~~~~~~~ ^
>> drivers/ufs/core/ufshcd.c:2158:57: error: no member named 'runtime_auto' in 'struct dev_pm_info'
    2158 |         return sysfs_emit(buf, "%d\n", ufs_rpm_dev(hba)->power.runtime_auto);
         |                                        ~~~~~~~~~~~~~~~~~~~~~~~ ^
   drivers/ufs/core/ufshcd.c:10656:44: warning: shift count >= width of type [-Wshift-count-overflow]
    10656 |                 if (!dma_set_mask_and_coherent(hba->dev, DMA_BIT_MASK(64)))
          |                                                          ^~~~~~~~~~~~~~~~
   include/linux/dma-mapping.h:93:54: note: expanded from macro 'DMA_BIT_MASK'
      93 | #define DMA_BIT_MASK(n) (((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
         |                                                      ^ ~~~
   1 warning and 4 errors generated.


vim +2120 drivers/ufs/core/ufshcd.c

  2113	
  2114	static ssize_t ufshcd_clkgate_delay_show(struct device *dev,
  2115			struct device_attribute *attr, char *buf)
  2116	{
  2117		struct ufs_hba *hba = dev_get_drvdata(dev);
  2118		struct device *rpm_dev = ufs_rpm_dev(hba);
  2119	
> 2120		if (!rpm_dev->power.use_autosuspend)
  2121			return -EIO;
  2122	
> 2123		return sysfs_emit(buf, "%u\n", rpm_dev->power.autosuspend_delay);
  2124	}
  2125	
  2126	void ufshcd_clkgate_delay_set(struct ufs_hba *hba, unsigned long value)
  2127	{
  2128		struct device *rpm_dev = ufs_rpm_dev(hba);
  2129	
  2130		device_lock(rpm_dev);
  2131		pm_runtime_set_autosuspend_delay(rpm_dev, value);
  2132		device_unlock(rpm_dev);
  2133	}
  2134	EXPORT_SYMBOL_GPL(ufshcd_clkgate_delay_set);
  2135	
  2136	static ssize_t ufshcd_clkgate_delay_store(struct device *dev,
  2137			struct device_attribute *attr, const char *buf, size_t count)
  2138	{
  2139		struct ufs_hba *hba = dev_get_drvdata(dev);
  2140		struct device *rpm_dev = ufs_rpm_dev(hba);
  2141		unsigned long value;
  2142	
  2143		if (!rpm_dev->power.use_autosuspend)
  2144			return -EIO;
  2145	
  2146		if (kstrtoul(buf, 0, &value))
  2147			return -EINVAL;
  2148	
  2149		ufshcd_clkgate_delay_set(hba, value);
  2150		return count;
  2151	}
  2152	
  2153	static ssize_t ufshcd_clkgate_enable_show(struct device *dev,
  2154			struct device_attribute *attr, char *buf)
  2155	{
  2156		struct ufs_hba *hba = dev_get_drvdata(dev);
  2157	
> 2158		return sysfs_emit(buf, "%d\n", ufs_rpm_dev(hba)->power.runtime_auto);
  2159	}
  2160	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
