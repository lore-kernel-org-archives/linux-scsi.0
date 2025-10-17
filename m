Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA411F91E3
	for <linux-scsi@vger.kernel.org>; Fri, 17 Oct 2025 05:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760679663; cv=none; b=Tilnv0NJqFeakIf9kqTADPAcdsCwqGQ/c2dun2KKPLl5f1wpBAxhqDDwK6gfaPgVVDqAMjsZ/lqlmXQzFLH4Z9IIHxJxHsrqKjFBuNAR5PK8lin1+yUAMHjqJTGEZ2WpcqnK7s0r09bjle0sjFAf2WbhMOQZIiImSB64ZLdeBQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760679663; c=relaxed/simple;
	bh=nk8a3nTS2ZiYQSMxTZs0AsffxcznExOONHye0IkUBkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fvF2tMgQ+gjQrL+8PmNNNGDE6cBipQcYEV15UBdXs1CjE40qjG37UQRyCjvgvbdoCnyuel3/9LJDf0dqk5gYvvkmC2rw/NSNGoAXNDmNnnH8edzYFoRLr3NBuNT6bXva8MD8ZJUA4d2AzMwUaPTp1RHD8Q9JjLgaaFeqdaKak9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZE2le5LD; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZE2le5LD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760679662; x=1792215662;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nk8a3nTS2ZiYQSMxTZs0AsffxcznExOONHye0IkUBkI=;
  b=ZE2le5LDyLMQLD5x5eUsRsRNsSFPpIJciX8mqdAORGL81aSV4t02Selj
   0VyU4R+nN+XujL6jhTuMtcF0zx5m0bl1MQLg3R2GSTLf51S671dUI1GKo
   VJ96xQEaJG6eEZF2nqmd5fOXWHvKRAX5zYyQm5Nw9iFJjg9P58rcwCLw0
   Q4OcZq2F48YkXxSh5SVMqMUqfU/V0SHbTg0t3r84M11uB6pabbkbvtJSQ
   hltKFlnkZwnE422jI7O04cGBN0c5w3k+yPVTXaISBg+ZSKIlc76n9T8a+
   bkobnonvpMs2C3Wvb5KnQ16ebzsvwTeMyGuJ5X1I+0WArmqipsJWVmgGN
   Q==;
X-CSE-ConnectionGUID: rMaldQEGSHy3+/2OgwauGA==
X-CSE-MsgGUID: tDAMQcJmTcGv/B3UtmFePQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11584"; a="62930914"
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="62930914"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 22:41:02 -0700
X-CSE-ConnectionGUID: CCgILAifQNe6BbFh949fGQ==
X-CSE-MsgGUID: rxh9B2EVRM+ndhsuF1HwxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="181842838"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa010.jf.intel.com with ESMTP; 16 Oct 2025 22:41:00 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v9dCz-0005ZT-1K;
	Fri, 17 Oct 2025 05:40:57 +0000
Date: Fri, 17 Oct 2025 13:39:43 +0800
From: kernel test robot <lkp@intel.com>
To: wenxiong@linux.ibm.com, njavali@marvell.com, brking@linux.ibm.com,
	linux-scsi@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, wenxiong@us.ibm.com,
	Wen Xiong <wenxiong@linux.ibm.com>,
	Kyle Mahlkuch <Kyle.Mahlkuch@ibm.com>
Subject: Re: [PATCH 1/2] scsi/ipr: enable/disable IRQD_NO_BALANCING during
 reset
Message-ID: <202510171217.uI9F6N9y-lkp@intel.com>
References: <20251015205311.122963-2-wenxiong@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015205311.122963-2-wenxiong@linux.ibm.com>

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v6.18-rc1 next-20251016]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/wenxiong-linux-ibm-com/scsi-ipr-enable-disable-IRQD_NO_BALANCING-during-reset/20251016-045452
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20251015205311.122963-2-wenxiong%40linux.ibm.com
patch subject: [PATCH 1/2] scsi/ipr: enable/disable IRQD_NO_BALANCING during reset
config: loongarch-allyesconfig (https://download.01.org/0day-ci/archive/20251017/202510171217.uI9F6N9y-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 754ebc6ebb9fb9fbee7aef33478c74ea74949853)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251017/202510171217.uI9F6N9y-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510171217.uI9F6N9y-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: drivers/scsi/ipr.c:7856 function parameter 'ioa_cfg' not described in 'ipr_set_affinity_nobalance'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
