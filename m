Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562B1372B5C;
	Wed,  4 Mar 2026 20:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772657259; cv=none; b=ij5YcS8xLXIFYRAzaNmWSGkM2f50fb3fqeH7Ba9PoO/OsEDLUSzq7zxQpLnW0bL98fZdJyPu/+Q5+oYmZRKJeyoftoZer1u37Imt6YkR82rN9ySRlZtpgA//8T7bEg2nymRqqFvSpsCxKSioEtA+k01CekpLJAiZ/3X+5yZwas4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772657259; c=relaxed/simple;
	bh=X+ZnfoW3n6oGaL/yvhNEmwBP5nPTP/NRRaMEpYwtc90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cNiuchIg5OdM4TKpkMCZz7WmMEJ5FvrzDpk1aBRMJLDTXAamOo6vTPrKFil9smGyQrxzW4fByMdZZagzoabA6g7Wcm8cpCdE3J9zSuxBcRgaddcYxE9F3m3O+ypurnRl6RzLQkj1F1wk/vXjw47eEX6JwwrMYtVVquHvzriZpLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hyEL8dDr; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hyEL8dDr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772657258; x=1804193258;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=X+ZnfoW3n6oGaL/yvhNEmwBP5nPTP/NRRaMEpYwtc90=;
  b=hyEL8dDrPVUcEGLLls6VezV6FQH75ISnzl3GpbC0JBF7sKHaLvVDzXfq
   x5RocjfnsbUMfOusOHJlO5gkmgk+X1/YIf/3d8Al/LMJFLbjnLg2IvyF/
   9twlXhVyJelQMmwm8KDaEZVbweHkETkWWTQCPRae+arw3J5x/FWMNqljr
   4QTbPlbk37tBTGe/B/m48LlXpku4Gvgz/U5yTQ3q11bwzf95ZfkHXwVZZ
   gCJHowUaBvbhOGjbpLCs1hXo/oiDTN/2ipfW3KaA02KExlw6lAqeJYIQ5
   rIXZadeN4WACTUkyjrjAU+6XaqpTfl+6yaTnxp7dDkJsV0nyc8szM5G2P
   A==;
X-CSE-ConnectionGUID: eXAMFMzeSGqi05f+gBnK1g==
X-CSE-MsgGUID: m4PSQY3iR9iuHLyEewck7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="85079033"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="85079033"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 12:47:37 -0800
X-CSE-ConnectionGUID: OgE2DpaoSOyEy0bQ1Ts5Lw==
X-CSE-MsgGUID: i9UQngh0RoSSQNLuqGj0qA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="223419138"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by orviesa005.jf.intel.com with ESMTP; 04 Mar 2026 12:47:33 -0800
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vxt7y-000000001lx-3Gba;
	Wed, 04 Mar 2026 20:47:30 +0000
Date: Wed, 4 Mar 2026 21:46:37 +0100
From: kernel test robot <lkp@intel.com>
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
	bvanassche@acm.org, beanhuo@micron.com, martin.petersen@oracle.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/11] scsi: ufs: core: Add support for TX Equalization
Message-ID: <202603042130.iNqLS3Zo-lkp@intel.com>
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
[also build test WARNING on jejb-scsi/for-next krzk/for-next linus/master v7.0-rc2 next-20260304]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Can-Guo/scsi-ufs-core-Introduce-a-new-ufshcd-vops-negotiate_pwr_mode/20260304-220245
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20260304135313.413688-5-can.guo%40oss.qualcomm.com
patch subject: [PATCH v2 04/11] scsi: ufs: core: Add support for TX Equalization
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260304/202603042130.iNqLS3Zo-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260304/202603042130.iNqLS3Zo-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603042130.iNqLS3Zo-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: drivers/ufs/core/ufs-txeq.c:56 cannot understand function prototype: 'const struct __ufs_tx_eq_preset'
>> Warning: drivers/ufs/core/ufs-txeq.c:77 cannot understand function prototype: 'const u32 pa_peer_rx_adapt_initial[UFS_HS_GEAR_MAX] ='
>> Warning: drivers/ufs/core/ufs-txeq.c:91 cannot understand function prototype: 'const u32 rx_adapt_initial_cap[UFS_HS_GEAR_MAX] ='
>> Warning: drivers/ufs/core/ufs-txeq.c:104 cannot understand function prototype: 'const u32 pa_tx_eq_setting[UFS_HS_GEAR_MAX] ='

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
