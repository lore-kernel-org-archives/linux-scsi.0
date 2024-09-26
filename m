Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD5F13632B
	for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2024 14:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727359941; cv=none; b=opwSr3Xb0HEhHdJMiIWM7a4OhvlKmRBFI4j0mtaP/y+V/1Cet8ulV/Uceu6WUQdhgaDNHVZUIg6jBr9CUJByM2+/JxJ+QDMR48pjuvxNCTNJvkCrildg8vAYQ4LVyi0RipSSQ33UrvP2r/LwElLQzZsfO44lRoMn4ge6ZrTavJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727359941; c=relaxed/simple;
	bh=pMKxWpF1vDUnw6Eym12+Sx+fRvfPFS0/SnM1YmOSzWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OIb41umhbbTScAPtrsKNNHgK+hqiWByTyGs64+H2+6QII4vmxX4kCaqjfbIowyy6i073Cw4YhMQh28QpK9TwbjnFDELMP2zmWuVaI+uPY4nPtWD+InRhbuGQkClwJz46mphSNMJaP4USa7ZZIn47sGtNqsSqVkWfMtIcZjxNg4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L0puKO3M; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L0puKO3M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727359940; x=1758895940;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pMKxWpF1vDUnw6Eym12+Sx+fRvfPFS0/SnM1YmOSzWY=;
  b=L0puKO3MelBVO4nbp1sRkTua+ronpW9kSwQA3bgcFjAkXmBmnYMSTHVJ
   sXcfCPdgo4gINefpBY7zc4kmS5IJOOPPHdDbdCqK2uA9E8ajIIhkRIvWm
   QFlou5UqqYKdt+/o0mf9g87J7CzED0ptCPlPtduSLpGJeZT4q0X1seNtz
   9cECI1URuhlyNx022pQbNWW5RDHIdIADQOez/lyL6Cac+SXLAYre9/bYb
   v1AVP7tgP9VTxxmbmsG4rj/h59SWGSIXYs2RpR9e1l3K2DmZvcZrs34W7
   yEzazK39jg3hwOCOlFxOGsb+q+LMTLMGDvceGaN8j9hPdkqTa6tjsGibZ
   g==;
X-CSE-ConnectionGUID: dqBeWlvkTXCKmJILkgKOmg==
X-CSE-MsgGUID: E+enTM14QPGhc1wLiRoLNA==
X-IronPort-AV: E=McAfee;i="6700,10204,11207"; a="26610397"
X-IronPort-AV: E=Sophos;i="6.11,155,1725346800"; 
   d="scan'208";a="26610397"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2024 07:12:19 -0700
X-CSE-ConnectionGUID: F6vX/U6HSgWqzzcokI2EMg==
X-CSE-MsgGUID: 3VhJCZ0uTuSFbieHVg7hNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,155,1725346800"; 
   d="scan'208";a="72607121"
Received: from lkp-server01.sh.intel.com (HELO 53e96f405c61) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 26 Sep 2024 07:12:17 -0700
Received: from kbuild by 53e96f405c61 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1stpE6-000Kn5-29;
	Thu, 26 Sep 2024 14:12:14 +0000
Date: Thu, 26 Sep 2024 22:12:11 +0800
From: kernel test robot <lkp@intel.com>
To: Yihang Li <liyihang9@huawei.com>, James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-scsi@vger.kernel.org, linuxarm@huawei.com,
	liyihang9@huawei.com
Subject: Re: [PATCH 03/13] scsi: hisi_sas: Add firmware information check
Message-ID: <202409262135.mC6xdK2H-lkp@intel.com>
References: <20240926014332.3905399-4-liyihang9@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240926014332.3905399-4-liyihang9@huawei.com>

Hi Yihang,

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next linus/master v6.11 next-20240926]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yihang-Li/scsi-hisi_sas-Adjust-priority-of-registering-and-exiting-debugfs-for-security/20240926-094506
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20240926014332.3905399-4-liyihang9%40huawei.com
patch subject: [PATCH 03/13] scsi: hisi_sas: Add firmware information check
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20240926/202409262135.mC6xdK2H-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240926/202409262135.mC6xdK2H-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409262135.mC6xdK2H-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/scsi/hisi_sas/hisi_sas_main.c:2457:11: error: incompatible integer to pointer conversion returning 'int' from a function with result type 'struct Scsi_Host *' [-Wint-conversion]
    2457 |                         return error;
         |                                ^~~~~
   drivers/scsi/hisi_sas/hisi_sas_main.c:2460:41: warning: shift count >= width of type [-Wshift-count-overflow]
    2460 |         error = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
         |                                                ^~~~~~~~~~~~~~~~
   include/linux/dma-mapping.h:77:54: note: expanded from macro 'DMA_BIT_MASK'
      77 | #define DMA_BIT_MASK(n) (((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
         |                                                      ^ ~~~
   1 warning and 1 error generated.


vim +2457 drivers/scsi/hisi_sas/hisi_sas_main.c

  2424	
  2425	static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
  2426						      const struct hisi_sas_hw *hw)
  2427	{
  2428		struct resource *res;
  2429		struct Scsi_Host *shost;
  2430		struct hisi_hba *hisi_hba;
  2431		struct device *dev = &pdev->dev;
  2432		int error;
  2433	
  2434		shost = scsi_host_alloc(hw->sht, sizeof(*hisi_hba));
  2435		if (!shost) {
  2436			dev_err(dev, "scsi host alloc failed\n");
  2437			return NULL;
  2438		}
  2439		hisi_hba = shost_priv(shost);
  2440	
  2441		INIT_WORK(&hisi_hba->rst_work, hisi_sas_rst_work_handler);
  2442		hisi_hba->hw = hw;
  2443		hisi_hba->dev = dev;
  2444		hisi_hba->platform_dev = pdev;
  2445		hisi_hba->shost = shost;
  2446		SHOST_TO_SAS_HA(shost) = &hisi_hba->sha;
  2447	
  2448		timer_setup(&hisi_hba->timer, NULL, 0);
  2449	
  2450		if (hisi_sas_get_fw_info(hisi_hba) < 0)
  2451			goto err_out;
  2452	
  2453		if (hisi_hba->hw->fw_info_check) {
  2454			error = hisi_hba->hw->fw_info_check(hisi_hba);
  2455	
  2456			if (error)
> 2457				return error;
  2458		}
  2459	
  2460		error = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
  2461		if (error) {
  2462			dev_err(dev, "No usable DMA addressing method\n");
  2463			goto err_out;
  2464		}
  2465	
  2466		hisi_hba->regs = devm_platform_ioremap_resource(pdev, 0);
  2467		if (IS_ERR(hisi_hba->regs))
  2468			goto err_out;
  2469	
  2470		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
  2471		if (res) {
  2472			hisi_hba->sgpio_regs = devm_ioremap_resource(dev, res);
  2473			if (IS_ERR(hisi_hba->sgpio_regs))
  2474				goto err_out;
  2475		}
  2476	
  2477		if (hisi_sas_alloc(hisi_hba)) {
  2478			hisi_sas_free(hisi_hba);
  2479			goto err_out;
  2480		}
  2481	
  2482		return shost;
  2483	err_out:
  2484		scsi_host_put(shost);
  2485		dev_err(dev, "shost alloc failed\n");
  2486		return NULL;
  2487	}
  2488	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
