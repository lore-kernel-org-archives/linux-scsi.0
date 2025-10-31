Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8435C2F0661
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 09:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761902935; cv=none; b=r5ofQ9qGv+foceC9a3afbIkCPjE5P+AS+8y/dLPYMHuNilwYdQ/oV8PvTUg1qMjCLBtEGxDC8oj0fJyTNIQ8YEJ5iGNVbA3lCGWWNF3VuCMKGwB9FAtRROE5+K0a8/XH1fOvJRNc+nvwrkcKbD2xYeXSKVoNYTTL6wJFfPShvsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761902935; c=relaxed/simple;
	bh=pw69mlM69E7ePqUmg/tWTDUUyqbW+9jUHvzlBiBYVVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lc4eAn0jCQj7+OZF3jEQsevwXQyNqWzAH4SHGY3k3VfnOqC0YVNxWEIqMU6r/g+9V2icfKaM4O+vH+lc7hsbe18c0UEtuUVUsV48CitMZgyo/+uj0HJ1oypaYnPXo6wSEMZ3OiKJ/mHqjLFmegQUHCpwtwxDIT3L4MGHBSbY2VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A2jSHxwr; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A2jSHxwr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761902934; x=1793438934;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pw69mlM69E7ePqUmg/tWTDUUyqbW+9jUHvzlBiBYVVA=;
  b=A2jSHxwrQITrjoSoQ2777+gZfxByov9bhkqO0BsaHh9nLHzcbMSlXn6L
   eWkrnZVTB+OjWqlsT6QlpuErCVVVw9OMqlKkfMOsAzhy+WlQzZVEuMf8n
   ud3UOP5JDjTtL4bFo4AJ58l/T2yaujGnfXE/bMGpXaXqNPCXyx9xzKgkv
   E1+xI0KDKkg4m22F3Dlzpahms9mDdPz+0j1Ew+5EreWiLzGZzFHWezQDj
   mKEbAk5l9+RbdOL4fjloVJZqaIFNUZWIv4pCiVyy43IEtwp+tmWTJxZd1
   s95mh0EyBtlvkjsl313HF05M8JWUEwgjGdwi7455GAwhz10bWul8HzCO3
   w==;
X-CSE-ConnectionGUID: t4uUkIiLRxi2s+fs5ZGRqA==
X-CSE-MsgGUID: TAkpOw0dQNKV8jj+DsWtMQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="63757963"
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="63757963"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 02:28:53 -0700
X-CSE-ConnectionGUID: u27EsdWNSjaC49T0vt4HOA==
X-CSE-MsgGUID: X3PADU+SRmSo+ELp6YGL4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="186310065"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa008.jf.intel.com with ESMTP; 31 Oct 2025 02:28:51 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vElRA-000Mwm-3D;
	Fri, 31 Oct 2025 09:28:48 +0000
Date: Fri, 31 Oct 2025 17:28:15 +0800
From: kernel test robot <lkp@intel.com>
To: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com, Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: Re: [PATCH v1 4/5] mpt3sas: Add firmware event requeue support for
 busy devices
Message-ID: <202510311720.NiDwRLwp-lkp@intel.com>
References: <20251029181058.39157-5-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029181058.39157-5-ranjan.kumar@broadcom.com>

Hi Ranjan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v6.18-rc3 next-20251030]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ranjan-Kumar/mpt3sas-Added-no_turs-flag-to-device-unblock-logic/20251030-025730
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20251029181058.39157-5-ranjan.kumar%40broadcom.com
patch subject: [PATCH v1 4/5] mpt3sas: Add firmware event requeue support for busy devices
config: i386-randconfig-054-20251030 (https://download.01.org/0day-ci/archive/20251031/202510311720.NiDwRLwp-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251031/202510311720.NiDwRLwp-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510311720.NiDwRLwp-lkp@intel.com/

All warnings (new ones prefixed by >>):

   Warning: drivers/scsi/mpt3sas/mpt3sas_scsih.c:276 struct member 'retries' not described in 'fw_event_work'
   Warning: drivers/scsi/mpt3sas/mpt3sas_scsih.c:276 struct member 'delayed_work_active' not described in 'fw_event_work'
   Warning: drivers/scsi/mpt3sas/mpt3sas_scsih.c:276 struct member 'delayed_work' not described in 'fw_event_work'
>> Warning: drivers/scsi/mpt3sas/mpt3sas_scsih.c:3667 function parameter 'delay' not described in '_scsih_fw_event_requeue'
   Warning: drivers/scsi/mpt3sas/mpt3sas_scsih.c:3920 function parameter 'no_turs' not described in '_scsih_ublock_io_all_device'
   Warning: drivers/scsi/mpt3sas/mpt3sas_scsih.c:3956 function parameter 'sas_address' not described in '_scsih_ublock_io_device_wait'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
