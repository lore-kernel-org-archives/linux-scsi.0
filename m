Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA672D77E6
	for <linux-scsi@vger.kernel.org>; Sat, 17 Jan 2026 02:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768616197; cv=none; b=qjTsn6/2KP8/2ot0/UwXkQTXkeX00aZMu2XNUdXWQ3zQstJ030jzNEoWtHGPwb0HIRaC/oXZ6NbpXw4ZFqMXoN1Nv8uUyDf5pzqQ9iKAebEt+TaWsWWENFUVCO4bWTW6GR+Kjyv2csWRV0k2OCuYFcWsEZvV8JJkTiQH65k0lHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768616197; c=relaxed/simple;
	bh=ehHmvddKhu/1zLxEAF1Zx5PCUPREqWQuv/zKmNhI24Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=huepzw7tjlUU6n5RI2i5MxlsCne7cfkSkBtGGaPLKGwVXzun/ZaR8Mb80zK6kSMSgFzXhlyJoO8PIAo29Bz/eP+ztjbs1/kVWzoKMUFIVYBYUeRvI2Jzua5SgHRhwDjatvcndsKy2DPwX4BtpNoVBye7EM3Kla+ZiIYffQOCVNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cId6Jc7+; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cId6Jc7+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768616196; x=1800152196;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ehHmvddKhu/1zLxEAF1Zx5PCUPREqWQuv/zKmNhI24Q=;
  b=cId6Jc7+b/T/vFTSXz83Yj0XEwtK++YwZ09g+nisODDXxZyiYz3TLx4M
   1MkH6A2kim5/ViXLBtymHEoU7L1gBmvDxTEYkhFQstsHq925XZ+o2GLet
   WQKLRwxyDp4cVFUAQjQ4MfWKP2uBvSg1Hh/49simi9Ilbx7JlImPSgHTA
   /SIV/MD23e+eTrV4Jg/KM3Q/89fYC9NpujmgtcrMcNBYGOVly5yROGHB8
   tgTHi+a27aPn27lcIDL4eRZ50dTHOM7bUHb9Ckbq8LEycNjGrbF+onz7L
   bERVT8EjKIGnFdh++2jYoDA4ISGUTpRRH1PhpF8OHNlokYzV6DCnGuVce
   A==;
X-CSE-ConnectionGUID: MoOdJ5RVT4ORGYLm71YduQ==
X-CSE-MsgGUID: fxuVAAULTTmcaDDJLB/7RA==
X-IronPort-AV: E=McAfee;i="6800,10657,11673"; a="95403593"
X-IronPort-AV: E=Sophos;i="6.21,232,1763452800"; 
   d="scan'208";a="95403593"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 18:16:36 -0800
X-CSE-ConnectionGUID: 4ox5l7MZT2+agctdgjvUeQ==
X-CSE-MsgGUID: cx77Z4M8R7GajrKDPDBIfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,232,1763452800"; 
   d="scan'208";a="205805333"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 16 Jan 2026 18:16:33 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vgvrb-00000000LSq-1NbF;
	Sat, 17 Jan 2026 02:16:31 +0000
Date: Sat, 17 Jan 2026 10:16:02 +0800
From: kernel test robot <lkp@intel.com>
To: Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: Re: [PATCH 3/7] ufs: core: Redirect clock gating to RPM
Message-ID: <202601170923.kY23MUEg-lkp@intel.com>
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

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v6.19-rc5 next-20260116]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Bart-Van-Assche/ufs-core-Change-the-type-of-an-ufshcd_clkgate_delay_set-argument/20260117-022907
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20260116182628.3255116-4-bvanassche%40acm.org
patch subject: [PATCH 3/7] ufs: core: Redirect clock gating to RPM
config: sparc-randconfig-002-20260117 (https://download.01.org/0day-ci/archive/20260117/202601170923.kY23MUEg-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260117/202601170923.kY23MUEg-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601170923.kY23MUEg-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/ufs/core/ufshcd.c: In function 'ufshcd_clkgate_delay_show':
   drivers/ufs/core/ufshcd.c:2120:22: error: 'struct dev_pm_info' has no member named 'use_autosuspend'; did you mean 'async_suspend'?
     if (!rpm_dev->power.use_autosuspend)
                         ^~~~~~~~~~~~~~~
                         async_suspend
   drivers/ufs/core/ufshcd.c:2123:47: error: 'struct dev_pm_info' has no member named 'autosuspend_delay'
     return sysfs_emit(buf, "%u\n", rpm_dev->power.autosuspend_delay);
                                                  ^
   drivers/ufs/core/ufshcd.c: In function 'ufshcd_clkgate_delay_store':
   drivers/ufs/core/ufshcd.c:2143:22: error: 'struct dev_pm_info' has no member named 'use_autosuspend'; did you mean 'async_suspend'?
     if (!rpm_dev->power.use_autosuspend)
                         ^~~~~~~~~~~~~~~
                         async_suspend
   drivers/ufs/core/ufshcd.c: In function 'ufshcd_clkgate_enable_show':
   drivers/ufs/core/ufshcd.c:2158:56: error: 'struct dev_pm_info' has no member named 'runtime_auto'
     return sysfs_emit(buf, "%d\n", ufs_rpm_dev(hba)->power.runtime_auto);
                                                           ^
>> drivers/ufs/core/ufshcd.c:2159:1: warning: control reaches end of non-void function [-Wreturn-type]
    }
    ^
   drivers/ufs/core/ufshcd.c: In function 'ufshcd_clkgate_delay_show':
   drivers/ufs/core/ufshcd.c:2124:1: warning: control reaches end of non-void function [-Wreturn-type]
    }
    ^


vim +2159 drivers/ufs/core/ufshcd.c

1ab27c9cf8b63d drivers/scsi/ufs/ufshcd.c Sahitya Tummala 2014-09-25  2152  
b427411abb3d61 drivers/scsi/ufs/ufshcd.c Sahitya Tummala 2016-12-22  2153  static ssize_t ufshcd_clkgate_enable_show(struct device *dev,
b427411abb3d61 drivers/scsi/ufs/ufshcd.c Sahitya Tummala 2016-12-22  2154  		struct device_attribute *attr, char *buf)
b427411abb3d61 drivers/scsi/ufs/ufshcd.c Sahitya Tummala 2016-12-22  2155  {
b427411abb3d61 drivers/scsi/ufs/ufshcd.c Sahitya Tummala 2016-12-22  2156  	struct ufs_hba *hba = dev_get_drvdata(dev);
b427411abb3d61 drivers/scsi/ufs/ufshcd.c Sahitya Tummala 2016-12-22  2157  
c24e59ff9dfa8d drivers/ufs/core/ufshcd.c Bart Van Assche 2026-01-16  2158  	return sysfs_emit(buf, "%d\n", ufs_rpm_dev(hba)->power.runtime_auto);
b427411abb3d61 drivers/scsi/ufs/ufshcd.c Sahitya Tummala 2016-12-22 @2159  }
b427411abb3d61 drivers/scsi/ufs/ufshcd.c Sahitya Tummala 2016-12-22  2160  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
