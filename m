Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B9A19F137;
	Mon,  3 Aug 2026 12:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785761162; cv=none; b=LdCN5zCutnbF5P7IBuJfxn93RhULiFmuYrAYvY9LowDM6Jq6KWzNJWwi/9wpIdSWFzRVRIiRwe+HUnLya76C29Z8e/rBqJ8xGrnmC7GmHBA/kag/EXP0m2OS8KTyBeXh9uAbC744Q3pVp+2Suq35N5blBxKw9XeOGRRDlDOndQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785761162; c=relaxed/simple;
	bh=T5QKHnwn/S2vdmSJhquNthsYdNLeVOD3Buj2H3yn5jg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AfA/1e+hiRfe7IFjMJWgsteqUX5WKXJCHNiY5R2uscM8dHP2FS1o+zaaEQnjMTJt1ZwLoEwmcE64VchLzPBX/WOs4njVW8Jmv4x/1dot+Jqrc4kd4J3y70mU7Il9Gd9rEtKfpbs621Hp2Ftkcore2s61DNUgqBBhrOq+ykoXrC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kuqdvxUC; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kuqdvxUC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785761161; x=1817297161;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=T5QKHnwn/S2vdmSJhquNthsYdNLeVOD3Buj2H3yn5jg=;
  b=kuqdvxUCC3s0DiCHhv1psrlZDrHgavdXMzC1VqjRxUBR8uEkeIons8Av
   i9mgdRLarJdeC8dU7Rw9X1JxuAfwWjgQyGqO/u1Zvf8GrET3sDAkPAEMu
   kDhLCO9Mkck49XEt5IX8qj/boD1Wauk8mp+wZQTon2yOOGLj0ZL847+R3
   orjzllXIoKudU8fJnsqkC/+ZxjLpUMtS6pmCzTey7fKYDk73o7oIMV502
   P0hbomR0rJAaOsgogpQKkAlsouqQxPMFhWe+K8uQYIRgSDKGZuJ9mYN88
   xw2S5Sa9IO2+7ajor6Qpdi1qXl4YepNqEJqlKsFSYtVZ1v/XU5/k4iLB9
   g==;
X-CSE-ConnectionGUID: w1BoMroLTWejiSX3XiAt1Q==
X-CSE-MsgGUID: 24RCyaiTSzKojORDhcX6BA==
X-IronPort-AV: E=McAfee;i="6800,10657,11864"; a="90179353"
X-IronPort-AV: E=Sophos;i="6.25,202,1779174000"; 
   d="scan'208";a="90179353"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 05:45:59 -0700
X-CSE-ConnectionGUID: nXb4+WhSR0O0XAZ3iUezEA==
X-CSE-MsgGUID: 7P0f2UefRrWBtoPSdtH3kQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,202,1779174000"; 
   d="scan'208";a="257311977"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 03 Aug 2026 05:45:35 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wqs2u-000000006w1-2OOU;
	Mon, 03 Aug 2026 12:45:32 +0000
Date: Mon, 3 Aug 2026 20:45:21 +0800
From: kernel test robot <lkp@intel.com>
To: Laurence Oberman <loberman@redhat.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>
Cc: oe-kbuild-all@lists.linux.dev,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Laurence Oberman <loberman@redhat.com>,
	linux-hyperv@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: storvsc: Support manual scans for all Hyper-V
 targets
Message-ID: <202608032058.OkCwuEDu-lkp@intel.com>
References: <20260723151458.872265-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723151458.872265-1-loberman@redhat.com>

Hi Laurence,

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next linus/master v7.2-rc6 next-20260731]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Laurence-Oberman/scsi-storvsc-Support-manual-scans-for-all-Hyper-V-targets/20260803-141419
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20260723151458.872265-1-loberman%40redhat.com
patch subject: [PATCH] scsi: storvsc: Support manual scans for all Hyper-V targets
config: i386-allmodconfig (https://download.01.org/0day-ci/archive/20260803/202608032058.OkCwuEDu-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260803/202608032058.OkCwuEDu-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608032058.OkCwuEDu-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "scsi_scan_host_selected" [drivers/scsi/hv_storvsc.ko] undefined!

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
