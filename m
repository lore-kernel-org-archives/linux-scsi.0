Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318CB1A3160;
	Sat, 14 Jun 2025 12:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749905454; cv=none; b=Huz7Hpv8Btd8Om3U5znyI35ZW8NJywIfwTaXDgf8/GkIP4yLYLqFgzjk/Z6/GS8O6di8TB88VDbZ3As3/8u15XT2mxL5YDKxoAnSSRRcT5rldlnLmfpKG0G0rUzSaggPgeJ6HyW0BigHMAC8XlJOGWvkmwejn9SfXf8+5dzuVe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749905454; c=relaxed/simple;
	bh=lFJYYQXq9oIDME04eSlHNN0+NsN/i1nbtydpkFkwH4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=npE+62jIJOvMj8+ymk+pgJQjKENc4BgeFehEjT1jU7PHA/MDXeTTDJMuRfEbANtebF5dc+gZyMYJmJT7f052bXCnHxj5hMtnU6DzlpgyaklDioQeIVLH6BOlzPtLz1VpBbYo+yI280xOFOOgSadLJKQIKI2QNYP52XY5G5fxFX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RJIVaoit; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RJIVaoit"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749905451; x=1781441451;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lFJYYQXq9oIDME04eSlHNN0+NsN/i1nbtydpkFkwH4s=;
  b=RJIVaoity4/nBYNN1kmZ15dUGm3YwOlYngvuFsqsuTyEt0TeUfMlrXCu
   2EsAZVTf8rdM+OjVy2At4XKrJJ/th1WRT7zuoyQfcNWM5anOWcBx2BTqZ
   OcrYZcuvawylVtDlLquIn9T/fmTYNz/iBf1AigwqjXFq4c/6bB7ftqVm0
   8VS4y2oRE/DRkYUz4pikCBpSi870HmN4gi01Kr8ib2BS9LDl0Yc9HTZiJ
   J9Fn/59cVkELCzwp+xrqgCozkm9eQAviA2W/6dysrLyZN2lJAMAxLu2OC
   k/u3JUV4dD0mPe1K+Y8CbAhcNjJSVxBGnGU6puZnfYmsalSaLm8d0W/hU
   w==;
X-CSE-ConnectionGUID: +4dvDqA/Tr2PReDBa0jAEQ==
X-CSE-MsgGUID: lTg+FEs/Rs+KVqJx3YDMXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11464"; a="63460831"
X-IronPort-AV: E=Sophos;i="6.16,236,1744095600"; 
   d="scan'208";a="63460831"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2025 05:50:51 -0700
X-CSE-ConnectionGUID: Cw3++vZETQ26IT/84DIU+Q==
X-CSE-MsgGUID: wQaK0AYCR3OyDPE+B9vKFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,236,1744095600"; 
   d="scan'208";a="147946527"
Received: from lkp-server01.sh.intel.com (HELO e8142ee1dce2) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 14 Jun 2025 05:50:45 -0700
Received: from kbuild by e8142ee1dce2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uQQLM-000DWE-1v;
	Sat, 14 Jun 2025 12:50:44 +0000
Date: Sat, 14 Jun 2025 20:50:25 +0800
From: kernel test robot <lkp@intel.com>
To: Steve Siwinski <stevensiwinski@gmail.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	gustavoars@kernel.org, James.Bottomley@hansenpartnership.com,
	kashyap.desai@broadcom.com, kees@kernel.org,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com, prayas.patel@broadcom.com,
	ranjan.kumar@broadcom.com, sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com, ssiwinski@atto.com,
	sumit.saxena@broadcom.com, bgrove@atto.com, tdoedline@atto.com
Subject: Re: [PATCH 2/2] scsi: mpi3mr: Add initialization for ATTO 24Gb SAS
 HBAs
Message-ID: <202506142037.j39pVyE8-lkp@intel.com>
References: <20250613202941.62114-2-ssiwinski@atto.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613202941.62114-2-ssiwinski@atto.com>

Hi Steve,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v6.16-rc1 next-20250613]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steve-Siwinski/scsi-mpi3mr-Add-initialization-for-ATTO-24Gb-SAS-HBAs/20250614-043438
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20250613202941.62114-2-ssiwinski%40atto.com
patch subject: [PATCH 2/2] scsi: mpi3mr: Add initialization for ATTO 24Gb SAS HBAs
config: x86_64-buildonly-randconfig-002-20250614 (https://download.01.org/0day-ci/archive/20250614/202506142037.j39pVyE8-lkp@intel.com/config)
compiler: clang version 20.1.2 (https://github.com/llvm/llvm-project 58df0ef89dd64126512e4ee27b4ac3fd8ddf6247)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250614/202506142037.j39pVyE8-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202506142037.j39pVyE8-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/scsi/mpi3mr/mpi3mr_fw.c:1644:47: warning: variable 'scratch_pad0' set but not used [-Wunused-but-set-variable]
    1644 |         u32 host_diagnostic, ioc_status, ioc_config, scratch_pad0;
         |                                                      ^
>> drivers/scsi/mpi3mr/mpi3mr_fw.c:4272:6: warning: variable 'r' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
    4272 |         if (!driver_pg2)
         |             ^~~~~~~~~~~
   drivers/scsi/mpi3mr/mpi3mr_fw.c:4290:9: note: uninitialized use occurs here
    4290 |         return r;
         |                ^
   drivers/scsi/mpi3mr/mpi3mr_fw.c:4272:2: note: remove the 'if' if its condition is always false
    4272 |         if (!driver_pg2)
         |         ^~~~~~~~~~~~~~~~
    4273 |                 goto out;
         |                 ~~~~~~~~
   drivers/scsi/mpi3mr/mpi3mr_fw.c:4267:7: note: initialize the variable 'r' to silence this warning
    4267 |         int r;
         |              ^
         |               = 0
   2 warnings generated.
--
>> Warning: drivers/scsi/mpi3mr/mpi3mr_fw.c:4262 function parameter 'sas_address' not described in 'mpi3mr_atto_get_sas_addr'
>> Warning: drivers/scsi/mpi3mr/mpi3mr_fw.c:6468 function parameter 'man_pg5' not described in 'mpi3mr_cfg_get_man_pg5'
>> Warning: drivers/scsi/mpi3mr/mpi3mr_fw.c:6468 Excess function parameter 'io_unit_pg5' description in 'mpi3mr_cfg_get_man_pg5'
>> Warning: drivers/scsi/mpi3mr/mpi3mr_fw.c:6524 function parameter 'man_pg5' not described in 'mpi3mr_cfg_set_man_pg5'
>> Warning: drivers/scsi/mpi3mr/mpi3mr_fw.c:6524 Excess function parameter 'io_unit_pg5' description in 'mpi3mr_cfg_set_man_pg5'


vim +4272 drivers/scsi/mpi3mr/mpi3mr_fw.c

  4254	
  4255	/**
  4256	 * mpi3mr_atto_get_sas_addr - get the ATTO SAS address from driver page 2
  4257	 *
  4258	 * @mrioc: Adapter instance reference
  4259	 * @*sas_address: return sas address
  4260	 * Return: 0 for success, non-zero for failure.
  4261	 */
> 4262	static int mpi3mr_atto_get_sas_addr(struct mpi3mr_ioc *mrioc, union ATTO_SAS_ADDRESS *sas_address)
  4263	{
  4264		struct mpi3_driver_page2 *driver_pg2 = NULL;
  4265		struct ATTO_SAS_NVRAM *nvram;
  4266		u16 sz;
  4267		int r;
  4268		__be64 addr;
  4269	
  4270		sz = mpi3mr_cfg_get_page_size(mrioc, MPI3_CONFIG_PAGETYPE_DRIVER, 2);
  4271		driver_pg2 = kzalloc(sz, GFP_KERNEL);
> 4272		if (!driver_pg2)
  4273			goto out;
  4274	
  4275		r = mpi3mr_cfg_get_driver_pg2(mrioc, driver_pg2, sz, MPI3_CONFIG_ACTION_READ_PERSISTENT);
  4276		if (r)
  4277			goto out;
  4278	
  4279		nvram = (struct ATTO_SAS_NVRAM *) &driver_pg2->trigger;
  4280	
  4281		r = mpi3mr_atto_validate_nvram(mrioc, nvram);
  4282		if (r)
  4283			goto out;
  4284	
  4285		addr = *((__be64 *) nvram->sasaddr);
  4286		sas_address->q = cpu_to_le64(be64_to_cpu(addr));
  4287	
  4288	out:
  4289		kfree(driver_pg2);
  4290		return r;
  4291	}
  4292	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
