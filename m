Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B5A277C81
	for <linux-scsi@vger.kernel.org>; Sat, 21 Mar 2026 16:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774110487; cv=none; b=bEGgCZDLt1D9h899pWG/QZEDg3UtQRnGYRlmIyx7RCTn+6f2DJk/r6UNywvRnOQe31Cv/D7u3lCMdV3dEbGgBYh7QbgOj2Fq2MFMYoBhcqd/hF9zme5rK8AMILEcdi9D0fzFo1XJEgIGsEFPNb1JtBYtidCG/sbiVcN5Gu6ntmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774110487; c=relaxed/simple;
	bh=bKSvlpGzvWl1NJW8wpKKGfnGcydapXBYhvh6GOGoIdg=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kMxVwfMfsU73J+R1RGZp3Bry59GU09xUumTiqd+8GcKjSa3NEkMEfzpYOCAb9bUFP4jIbH8XrXsO4jZsiQF2+f46+zW857K7bdqJmIwpPchRGlRYlSGQwhTh0Cv+uvDifbH6r//DDHkQV8kI17ggXfEZBpDLL6n/oIXIgRfvIlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H+7nTWvd; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H+7nTWvd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774110487; x=1805646487;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=bKSvlpGzvWl1NJW8wpKKGfnGcydapXBYhvh6GOGoIdg=;
  b=H+7nTWvdQmKkPtA6qFrPmaCLUnxkdMdXXyZqTyA2WAYHocWJXL6Lnfej
   RdCDGFxpum6vfo6Fi03lwLwjLsuEp4MmNQYmeY1BFtJGGwGfgMyCEmSGz
   DumvnIigTkKeG6GNW6RmevGf4SKalc+AcISSDTtnSvmyZZw/IeVawTFH3
   DZ9qRJgDbnZKv0l7yAF/VMrTXU5Cj/Vb53kM0Akd5cfTjU6v6JHFTxRov
   1UQGUdaFMxkSuMPi3gOTvvNZfHWorevZ8pDz0/vGfctv8A3vvzFXCckzu
   PMvh58DhSRtOa7zlQO1U0Xnke4VLS9j2q0GV+nJ77IJAg5NBhOyRb2q5g
   A==;
X-CSE-ConnectionGUID: ShG6GQytRh2c3lorYN57VQ==
X-CSE-MsgGUID: cYzSfQ8sQXGFOE84CvZUwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11736"; a="92554878"
X-IronPort-AV: E=Sophos;i="6.23,133,1770624000"; 
   d="scan'208";a="92554878"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2026 09:28:06 -0700
X-CSE-ConnectionGUID: D7kzaytGTPCATEuTZr76Og==
X-CSE-MsgGUID: yonfhxevS/GN97XTGiWsCw==
X-ExtLoop1: 1
Received: from lkp-server02.sh.intel.com (HELO d7fefbca0d04) ([10.239.97.151])
  by fmviesa003.fm.intel.com with ESMTP; 21 Mar 2026 09:28:04 -0700
Received: from kbuild by d7fefbca0d04 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w3zBB-0000000011N-3ikd;
	Sat, 21 Mar 2026 16:28:01 +0000
Date: Sun, 22 Mar 2026 00:27:52 +0800
From: kernel test robot <lkp@intel.com>
To: Rosen Penev <rosenp@gmail.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: be2iscsi: kzalloc + kcalloc to kzalloc_flex
Message-ID: <202603220006.d4ATnciA-lkp@intel.com>
References: <20260320010957.32355-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320010957.32355-1-rosenp@gmail.com>

Hi Rosen,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v7.0-rc4 next-20260320]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Rosen-Penev/scsi-be2iscsi-kzalloc-kcalloc-to-kzalloc_flex/20260321-145321
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20260320010957.32355-1-rosenp%40gmail.com
patch subject: [PATCH] scsi: be2iscsi: kzalloc + kcalloc to kzalloc_flex
config: x86_64-rhel-9.4-ltp (https://download.01.org/0day-ci/archive/20260322/202603220006.d4ATnciA-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260322/202603220006.d4ATnciA-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603220006.d4ATnciA-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/scsi/be2iscsi/be_main.c: In function 'beiscsi_alloc_mem':
>> drivers/scsi/be2iscsi/be_main.c:2468:32: warning: variable 'phwi_ctrlr' set but not used [-Wunused-but-set-variable]
    2468 |         struct hwi_controller *phwi_ctrlr;
         |                                ^~~~~~~~~~


vim +/phwi_ctrlr +2468 drivers/scsi/be2iscsi/be_main.c

6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2464  
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2465  static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2466  {
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2467  	dma_addr_t bus_add;
a7909b396ba79a Jayamohan Kallickal 2013-04-05 @2468  	struct hwi_controller *phwi_ctrlr;
a7909b396ba79a Jayamohan Kallickal 2013-04-05  2469  	struct be_mem_descriptor *mem_descr;
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2470  	struct mem_array *mem_arr, *mem_arr_orig;
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2471  	unsigned int i, j, alloc_size, curr_alloc_size;
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2472  
7051e9804743be Rosen Penev         2026-03-19  2473  	phba->phwi_ctrlr = kzalloc_flex(*phba->phwi_ctrlr, wrb_context, phba->params.cxns_per_ctrl);
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2474  	if (!phba->phwi_ctrlr)
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2475  		return -ENOMEM;
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2476  
a7909b396ba79a Jayamohan Kallickal 2013-04-05  2477  	/* Allocate memory for wrb_context */
a7909b396ba79a Jayamohan Kallickal 2013-04-05  2478  	phwi_ctrlr = phba->phwi_ctrlr;
a7909b396ba79a Jayamohan Kallickal 2013-04-05  2479  
bf4afc53b77aea Linus Torvalds      2026-02-21  2480  	phba->init_mem = kzalloc_objs(*mem_descr, SE_MEM_MAX);
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2481  	if (!phba->init_mem) {
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2482  		kfree(phba->phwi_ctrlr);
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2483  		return -ENOMEM;
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2484  	}
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2485  
32a92f8c893269 Linus Torvalds      2026-02-21  2486  	mem_arr_orig = kmalloc_objs(*mem_arr_orig, BEISCSI_MAX_FRAGS_INIT);
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2487  	if (!mem_arr_orig) {
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2488  		kfree(phba->init_mem);
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2489  		kfree(phba->phwi_ctrlr);
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2490  		return -ENOMEM;
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2491  	}
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2492  
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2493  	mem_descr = phba->init_mem;
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2494  	for (i = 0; i < SE_MEM_MAX; i++) {
8a86e8336f37fd Jayamohan Kallickal 2013-09-28  2495  		if (!phba->mem_req[i]) {
8a86e8336f37fd Jayamohan Kallickal 2013-09-28  2496  			mem_descr->mem_array = NULL;
8a86e8336f37fd Jayamohan Kallickal 2013-09-28  2497  			mem_descr++;
8a86e8336f37fd Jayamohan Kallickal 2013-09-28  2498  			continue;
8a86e8336f37fd Jayamohan Kallickal 2013-09-28  2499  		}
8a86e8336f37fd Jayamohan Kallickal 2013-09-28  2500  
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2501  		j = 0;
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2502  		mem_arr = mem_arr_orig;
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2503  		alloc_size = phba->mem_req[i];
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2504  		memset(mem_arr, 0, sizeof(struct mem_array) *
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2505  		       BEISCSI_MAX_FRAGS_INIT);
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2506  		curr_alloc_size = min(be_max_phys_size * 1024, alloc_size);
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2507  		do {
26a4c991af99f1 Christoph Hellwig   2018-10-10  2508  			mem_arr->virtual_address =
26a4c991af99f1 Christoph Hellwig   2018-10-10  2509  				dma_alloc_coherent(&phba->pcidev->dev,
26a4c991af99f1 Christoph Hellwig   2018-10-10  2510  					curr_alloc_size, &bus_add, GFP_KERNEL);
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2511  			if (!mem_arr->virtual_address) {
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2512  				if (curr_alloc_size <= BE_MIN_MEM_SIZE)
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2513  					goto free_mem;
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2514  				if (curr_alloc_size -
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2515  					rounddown_pow_of_two(curr_alloc_size))
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2516  					curr_alloc_size = rounddown_pow_of_two
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2517  							     (curr_alloc_size);
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2518  				else
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2519  					curr_alloc_size = curr_alloc_size / 2;
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2520  			} else {
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2521  				mem_arr->bus_address.u.
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2522  				    a64.address = (__u64) bus_add;
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2523  				mem_arr->size = curr_alloc_size;
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2524  				alloc_size -= curr_alloc_size;
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2525  				curr_alloc_size = min(be_max_phys_size *
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2526  						      1024, alloc_size);
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2527  				j++;
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2528  				mem_arr++;
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2529  			}
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2530  		} while (alloc_size);
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2531  		mem_descr->num_elements = j;
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2532  		mem_descr->size_in_bytes = phba->mem_req[i];
bf4afc53b77aea Linus Torvalds      2026-02-21  2533  		mem_descr->mem_array = kmalloc_objs(*mem_arr, j);
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2534  		if (!mem_descr->mem_array)
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2535  			goto free_mem;
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2536  
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2537  		memcpy(mem_descr->mem_array, mem_arr_orig,
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2538  		       sizeof(struct mem_array) * j);
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2539  		mem_descr++;
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2540  	}
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2541  	kfree(mem_arr_orig);
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2542  	return 0;
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2543  free_mem:
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2544  	mem_descr->num_elements = j;
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2545  	while ((i) || (j)) {
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2546  		for (j = mem_descr->num_elements; j > 0; j--) {
26a4c991af99f1 Christoph Hellwig   2018-10-10  2547  			dma_free_coherent(&phba->pcidev->dev,
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2548  					    mem_descr->mem_array[j - 1].size,
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2549  					    mem_descr->mem_array[j - 1].
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2550  					    virtual_address,
457ff3b7dc3796 Jayamohan Kallickal 2010-07-22  2551  					    (unsigned long)mem_descr->
457ff3b7dc3796 Jayamohan Kallickal 2010-07-22  2552  					    mem_array[j - 1].
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2553  					    bus_address.u.a64.address);
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2554  		}
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2555  		if (i) {
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2556  			i--;
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2557  			kfree(mem_descr->mem_array);
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2558  			mem_descr--;
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2559  		}
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2560  	}
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2561  	kfree(mem_arr_orig);
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2562  	kfree(phba->init_mem);
a7909b396ba79a Jayamohan Kallickal 2013-04-05  2563  	kfree(phba->phwi_ctrlr->wrb_context);
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2564  	kfree(phba->phwi_ctrlr);
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2565  	return -ENOMEM;
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2566  }
6733b39a1301b0 Jayamohan Kallickal 2009-09-05  2567  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
