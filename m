Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64FB35DA50;
	Wed,  4 Mar 2026 23:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772666390; cv=none; b=RFUEw86UWTSXDQlguCcbbQM/5kBT2B/KqCkTf1MJTMsmcIuHh4XQVBYc2zlanTAcFNhiHAfa+J5IK8A9vetrXl2JBW8EpSbZbP5o1ppz0WMP6viHo2Rjf+1rJn02iRDscipE8fbliIOKcPSk9W1hJbhLI4ijf7/eoYsTVFDldfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772666390; c=relaxed/simple;
	bh=gmB/622tq9mZd/Wm9Ty746uquKblIhpsL7ubn7iZpxo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JHY7uwhgoZruYXB9jT4Z35wBuwYWUzXzj+2CKf14sHzJIQiF+v0UYNR3av03iiLX7E7hrVWQqTzveGgHFU1cUQuT+8JNvP1kAhl2uKGWXxftf/MOvmpz35SvNwqBN/LQ1h6Pek8A6UyPpAbusFchscXseAFGLZELMIkSBlVOesw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Edjxpkd+; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Edjxpkd+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772666390; x=1804202390;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gmB/622tq9mZd/Wm9Ty746uquKblIhpsL7ubn7iZpxo=;
  b=Edjxpkd+kMWd1a0s8uKyh/FGHCoKcMgL2p4wiSYCIDu3tNS0/Xtl4LO5
   VHvES1clvW90Y7eavfflTgzC3MiXFlf+Suh6YxrqcQBTWXvOSCGa0uiIB
   30V2v2TqzjgXUeEzDohZYpyY1TTi6xM3irknUXHgHNKcLwhnUkXgw/Kfo
   TZeCFyz1xwpKdVmPDd8CfP5DFyIq9OU0Ezl3Fcgm/u0RprHO+wz6QqZa3
   aICbWTq1d9XiJXEs2hx8X/JXgqerbfbnqyRlsSF15w5vJ6JUZsEqGY8cA
   qnuDxYwMmz7It8VZoiQPfhB26a1/ItFGsPVJY8Dob1FMqI2uEoxIsA4+Y
   Q==;
X-CSE-ConnectionGUID: HhSLpo7UTtmLZgogItv5RA==
X-CSE-MsgGUID: 4uIwoHyHST6l77U0jJ0+Uw==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="73649278"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="73649278"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 15:19:46 -0800
X-CSE-ConnectionGUID: D2ooWo0dSpunHAYZCODyJg==
X-CSE-MsgGUID: WxW7KA5DRn+vSMbpBddQ/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="245061410"
Received: from lkp-server01.sh.intel.com (HELO f27a57aa7a36) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 04 Mar 2026 15:19:42 -0800
Received: from kbuild by f27a57aa7a36 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vxvVD-000000004ff-0RKh;
	Wed, 04 Mar 2026 23:19:39 +0000
Date: Thu, 5 Mar 2026 07:18:50 +0800
From: kernel test robot <lkp@intel.com>
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
	bvanassche@acm.org, beanhuo@micron.com, martin.petersen@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
	Can Guo <can.guo@oss.qualcomm.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/11] scsi: ufs: core: Add support for TX Equalization
Message-ID: <202603050737.IgToFD5G-lkp@intel.com>
References: <20260304135313.413688-5-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304135313.413688-5-can.guo@oss.qualcomm.com>

Hi Can,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next krzk/for-next linus/master v7.0-rc2 next-20260303]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Can-Guo/scsi-ufs-core-Introduce-a-new-ufshcd-vops-negotiate_pwr_mode/20260304-220245
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20260304135313.413688-5-can.guo%40oss.qualcomm.com
patch subject: [PATCH v2 04/11] scsi: ufs: core: Add support for TX Equalization
config: i386-randconfig-r071-20260305 (https://download.01.org/0day-ci/archive/20260305/202603050737.IgToFD5G-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
smatch: v0.5.0-9004-gb810ac53
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260305/202603050737.IgToFD5G-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603050737.IgToFD5G-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: drivers/ufs/core/ufs-txeq.c:56 cannot understand function prototype: 'const struct __ufs_tx_eq_preset'
>> Warning: drivers/ufs/core/ufs-txeq.c:77 cannot understand function prototype: 'const u32 pa_peer_rx_adapt_initial[UFS_HS_GEAR_MAX] ='
>> Warning: drivers/ufs/core/ufs-txeq.c:91 cannot understand function prototype: 'const u32 rx_adapt_initial_cap[UFS_HS_GEAR_MAX] ='
>> Warning: drivers/ufs/core/ufs-txeq.c:104 cannot understand function prototype: 'const u32 pa_tx_eq_setting[UFS_HS_GEAR_MAX] ='

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
