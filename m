Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1D047A0A1;
	Fri, 27 Feb 2026 22:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772229886; cv=none; b=AsxUON6i2EFbe8zY8CObrwGU3mQbuZ15zAbazd05Fs5pDrUIsuaha1BL3x3JYyVSIIxnNbBU7MOmVruAj/2h5czlPMiva9YQdae00JgOOWrJecNA0HBlWA2K92rXEHrOOgs4WHHr0FVpVwsfynZkiwF4e9Vi40IjuD7dM3C0Ocw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772229886; c=relaxed/simple;
	bh=ouK951qdlEeemdN7HgFjXpMlqGO4LIUfC+5UqhAs1pQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZeBb9hI9Ky/LNKlVdM/ObX9Z8sPn9IP7ZGYuXLRrlMNVGAEY14HhQcFAllqq5OEhdNlDW61zCsTyOVzmmXeZ7eFhPp5lwfOTL0SRmiFtS3VDwiY+vZ6OvHI4omB4LiJA6nStovnjEp6xs/5sV4wG7HCaMJvJTYykWE+FSP5Vp+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F4xk1JYt; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F4xk1JYt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772229883; x=1803765883;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ouK951qdlEeemdN7HgFjXpMlqGO4LIUfC+5UqhAs1pQ=;
  b=F4xk1JYtFPrBZcIsxvdYo3yIC3h6hhiBJL/XXhfBaw2802dQTYRHsL0e
   6O7Q9jrtVXXVSeb4yv/08376NvYXrz9NJbbmaCyXqC+Fx1+IyXZZTCS16
   BHPADgFCmWs1zmYkoeEpGu4+1cBGub9NQUvdfzpEZkjYQg+QaraKBNduh
   9PFBSDhLegMXnUdnShvw0RwAR43iSxNXgbRqFsqCtg1wP7QVoqg377C3y
   NY9RHpMI21Enrfjo+gR4X1rRfkDuk4qQgHu0j9nbdanEgQA8zbztPjdNB
   pVCCt5W+9y+aRJdBI167SJBj5FpE51v1fT/UlJo+dNvphx0w8ybiumYI1
   w==;
X-CSE-ConnectionGUID: pgkEXo9oQMGt7uoeJ/fsIg==
X-CSE-MsgGUID: XaKviLKfRWGyRa2QcATBXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11714"; a="84787151"
X-IronPort-AV: E=Sophos;i="6.21,314,1763452800"; 
   d="scan'208";a="84787151"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2026 14:04:42 -0800
X-CSE-ConnectionGUID: ebp+KuMLTReF6W7sPIEPEg==
X-CSE-MsgGUID: Pi1cVNtcQZqIcVMp2xWZpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,314,1763452800"; 
   d="scan'208";a="217129224"
Received: from lkp-server02.sh.intel.com (HELO a3936d6a266d) ([10.239.97.151])
  by orviesa007.jf.intel.com with ESMTP; 27 Feb 2026 14:04:38 -0800
Received: from kbuild by a3936d6a266d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vw5wZ-00000000B6V-14lM;
	Fri, 27 Feb 2026 22:04:26 +0000
Date: Sat, 28 Feb 2026 06:04:04 +0800
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
Subject: Re: [PATCH 04/11] scsi: ufs: core: Add support for TX Equalization
Message-ID: <202602280620.QdtAqy55-lkp@intel.com>
References: <20260227160809.2620598-5-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227160809.2620598-5-can.guo@oss.qualcomm.com>

Hi Can,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next krzk/for-next linus/master v7.0-rc1 next-20260227]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Can-Guo/scsi-ufs-core-Introduce-a-new-ufshcd-vops-negotiate_pwr_mode/20260228-001946
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20260227160809.2620598-5-can.guo%40oss.qualcomm.com
patch subject: [PATCH 04/11] scsi: ufs: core: Add support for TX Equalization
config: riscv-randconfig-002-20260228 (https://download.01.org/0day-ci/archive/20260228/202602280620.QdtAqy55-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 9.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260228/202602280620.QdtAqy55-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602280620.QdtAqy55-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: drivers/ufs/core/ufs-txeq.c:503 function parameter 'adapt_cap' not described in 'adapt_cap_to_t_adapt'
>> Warning: drivers/ufs/core/ufs-txeq.c:529 function parameter 'adapt_cap' not described in 'adapt_cap_to_t_adapt_l0l3'
>> Warning: drivers/ufs/core/ufs-txeq.c:555 function parameter 'adapt_cap' not described in 'adapt_cap_to_t_adapt_l0l1l2l3'
>> Warning: drivers/ufs/core/ufs-txeq.c:503 function parameter 'adapt_cap' not described in 'adapt_cap_to_t_adapt'
>> Warning: drivers/ufs/core/ufs-txeq.c:529 function parameter 'adapt_cap' not described in 'adapt_cap_to_t_adapt_l0l3'
>> Warning: drivers/ufs/core/ufs-txeq.c:555 function parameter 'adapt_cap' not described in 'adapt_cap_to_t_adapt_l0l1l2l3'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
