Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8B442AA0
	for <linux-scsi@vger.kernel.org>; Thu, 20 Jun 2024 21:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718918431; cv=none; b=i40ZGgkyRg4U6sWJn9gKvMdZxWd4sbnhb6uC4r0yNZCkVwHhZWekfRLrUzVyRfIbF5rbxHo41FlSPAmaDGAS7N7QkDuL9MVR6oUoEOmlRlv3ZQsQuxTHcyAEYnl9R1eX4wmiPhGo/W/YHoJxIpGiVfc1RuVDcvL0HUoUWuDe80A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718918431; c=relaxed/simple;
	bh=ztojyfQJf83puOWKP3fQ+YZnBh38UCHoolQsObXN/Sc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sW3Xu27C3mGSJB8qZ3vBGEQDkAPoe96oe65aWdWGAWKmGwiGW4Tcq9F5amTyMZ5mxltKX0kKzbOzMnx2PYGOfr+3PwQTM3dBXDX9JB2TJRk3YoEFgWUmxKBHvTU8ojqa4MjaPLleMKNnU6Jd7WuEwQzF5vbsceRf8cUjozn6LoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jRJGxpTR; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jRJGxpTR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718918431; x=1750454431;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ztojyfQJf83puOWKP3fQ+YZnBh38UCHoolQsObXN/Sc=;
  b=jRJGxpTRu/0if7t5VAQFOtjd7DTrstz9ScYLVfMGor0TvBZf6rCpyiao
   KJh3ezzsSju9idDU+DUZYqTMKcEUgkohxJNDmZy0oxzIR2/IoanzRzAdQ
   lz4Tz7qO3mg/k3tGguL0coqt6mjd2Zkc/ZkK8IoqNKz1P13N4YkvYdxBx
   myFeg0HfmO3A3iwXZMO93esuJBgjcOvF+qBJxAzQAQg8xetUkyodr0Vvc
   XzoUJtNc1ZWutmntbi//OgXgt6TUgsyGuj5mSsKbptCKQAwn8CYRKrWmT
   JXVxj0a63XSbjvXO7a0qAjCeizZk7S9fuC1L0nllHiDvNVL9lUhTvNonm
   Q==;
X-CSE-ConnectionGUID: IzvCZPJ4TLC/XdmnMU4M+g==
X-CSE-MsgGUID: v4ehuxzJQz2EXB+CDkbeJQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="27351349"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="27351349"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 14:20:30 -0700
X-CSE-ConnectionGUID: JqC5AgHPQNGUOj+X7G2E+g==
X-CSE-MsgGUID: 2nT3CQ5cSi614fiX3UadQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="42278997"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 20 Jun 2024 14:20:27 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sKPCi-0007xq-2H;
	Thu, 20 Jun 2024 21:20:24 +0000
Date: Fri, 21 Jun 2024 05:20:20 +0800
From: kernel test robot <lkp@intel.com>
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
	GR-QLogic-Storage-Upstream@marvell.com, agurumurthy@marvell.com,
	sdeodhar@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
Subject: Re: [PATCH 01/11] qla2xxx: unable to act on RSCN for port online
Message-ID: <202406210538.w875N70K-lkp@intel.com>
References: <20240618133739.35456-2-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240618133739.35456-2-njavali@marvell.com>

Hi Nilesh,

kernel test robot noticed the following build warnings:

[auto build test WARNING on e8a1d87b7983b461d1d625e2973cdaadc0bd8ff5]

url:    https://github.com/intel-lab-lkp/linux/commits/Nilesh-Javali/qla2xxx-unable-to-act-on-RSCN-for-port-online/20240618-223303
base:   e8a1d87b7983b461d1d625e2973cdaadc0bd8ff5
patch link:    https://lore.kernel.org/r/20240618133739.35456-2-njavali%40marvell.com
patch subject: [PATCH 01/11] qla2xxx: unable to act on RSCN for port online
config: x86_64-randconfig-161-20240620 (https://download.01.org/0day-ci/archive/20240621/202406210538.w875N70K-lkp@intel.com/config)
compiler: gcc-13 (Ubuntu 13.2.0-4ubuntu3) 13.2.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202406210538.w875N70K-lkp@intel.com/

smatch warnings:
drivers/scsi/qla2xxx/qla_inline.h:645 val_is_in_range() warn: always true condition '(val <= 4294967295) => (0-u32max <= u32max)'

vim +645 drivers/scsi/qla2xxx/qla_inline.h

   634	
   635	static inline bool val_is_in_range(u32 val, u32 start, u32 end)
   636	{
   637		if (start < end) {
   638			if (val >= start && val <= end)
   639				return true;
   640			else
   641				return false;
   642		}
   643	
   644		/* @end has wrapped */
 > 645		if (val >= start  && val <= 0xffffffffu)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
