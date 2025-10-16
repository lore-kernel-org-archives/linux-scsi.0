Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0009A311960
	for <linux-scsi@vger.kernel.org>; Thu, 16 Oct 2025 11:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760614644; cv=none; b=PPnCOwZQI6DxIocb8gHGYc+NItKNliekeqmjx4ZBS7jKaZ20MA+ilkEW7UhQQ5nmgkddys/nI/K+OiTakKLUEXzXKJGffS/17VJXKCxMTR5bcLUVHgEBdh0Tc0jDJNvrTn03sfqaBte/rFvSOQFvoFUFIw1NhY/hJErJcgnDVr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760614644; c=relaxed/simple;
	bh=YZyhW3/zD4wsvpKX9pQCxlZRiSg2TJ7KaVgbIyzqMmc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jwWdvKgsSJSnarCLgOG04Jo5Lp+D1LXSPq3NVNb0R8p6ujTd0QBa7Xyo31RmUchOp09xuzCGQfScJmmY9OaCIWY9gZNsmszfxpNdCJUhu4V7AW4xDUuA/7KdYJMwxK5QxDTcQfGr0fyxO4c0rBGEYoZWvix3560seM7JPF9qgjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cHiO3z8l; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cHiO3z8l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760614643; x=1792150643;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YZyhW3/zD4wsvpKX9pQCxlZRiSg2TJ7KaVgbIyzqMmc=;
  b=cHiO3z8l2SapVwm9i5MRZCNcfC+h9rQyCq6tIsLU/PJiTxPw8O3w1+Lc
   wFw9uQmJECfHCw7IumOCGAZUBXnwWVO+UlM5EJkaDexwqUqMyBp5hOCCw
   uibUZQMx5Qrl9WXF2RIrDGLDqoYDmFJkh4JGrZkhrmlW8txOg888wNJyM
   F+xjYZ0zAquWsU6TAmmCxNAw4KxhWyRoe2NvUW0GLdccx6Pb5xqhj9ETn
   c55pqdc7XeBOglVd6WvFvrnuwGhYl+gVs4nzqtvQtu+RIGG5rzZz7WIPr
   9vqcp+BpHRb0x2OPsCn9cyDouSC+B6ZJSgTqCYShqeaZ1ULSqJTWDcpUU
   Q==;
X-CSE-ConnectionGUID: tztS/6DISPWH9H5KnmdqYw==
X-CSE-MsgGUID: zgguptxJT42NBhP8kBtR9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11583"; a="73915729"
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="73915729"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 04:37:23 -0700
X-CSE-ConnectionGUID: q27nMgTnTZeyfYKzIUrScA==
X-CSE-MsgGUID: /VCgPrL7QSCQwy4q6Rc1GA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="181642217"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa010.jf.intel.com with ESMTP; 16 Oct 2025 04:37:21 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v9MIH-0004kp-32;
	Thu, 16 Oct 2025 11:37:17 +0000
Date: Thu, 16 Oct 2025 19:36:22 +0800
From: kernel test robot <lkp@intel.com>
To: wenxiong@linux.ibm.com, njavali@marvell.com, brking@linux.ibm.com,
	linux-scsi@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, wenxiong@us.ibm.com,
	Wen Xiong <wenxiong@linux.ibm.com>,
	Kyle Mahlkuch <Kyle.Mahlkuch@ibm.com>
Subject: Re: [PATCH 1/2] scsi/ipr: enable/disable IRQD_NO_BALANCING during
 reset
Message-ID: <202510161909.4qsMFXQL-lkp@intel.com>
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

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next linus/master v6.18-rc1 next-20251015]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/wenxiong-linux-ibm-com/scsi-ipr-enable-disable-IRQD_NO_BALANCING-during-reset/20251016-045452
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20251015205311.122963-2-wenxiong%40linux.ibm.com
patch subject: [PATCH 1/2] scsi/ipr: enable/disable IRQD_NO_BALANCING during reset
config: x86_64-buildonly-randconfig-004-20251016 (https://download.01.org/0day-ci/archive/20251016/202510161909.4qsMFXQL-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.4.0-5) 12.4.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251016/202510161909.4qsMFXQL-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510161909.4qsMFXQL-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/scsi/ipr.c: In function 'ipr_set_affinity_nobalance':
>> drivers/scsi/ipr.c:7864:25: error: implicit declaration of function 'irq_set_status_flags' [-Werror=implicit-function-declaration]
    7864 |                         irq_set_status_flags(irq, IRQ_NO_BALANCING);
         |                         ^~~~~~~~~~~~~~~~~~~~
>> drivers/scsi/ipr.c:7864:51: error: 'IRQ_NO_BALANCING' undeclared (first use in this function); did you mean 'IRQF_NOBALANCING'?
    7864 |                         irq_set_status_flags(irq, IRQ_NO_BALANCING);
         |                                                   ^~~~~~~~~~~~~~~~
         |                                                   IRQF_NOBALANCING
   drivers/scsi/ipr.c:7864:51: note: each undeclared identifier is reported only once for each function it appears in
>> drivers/scsi/ipr.c:7866:25: error: implicit declaration of function 'irq_clear_status_flags' [-Werror=implicit-function-declaration]
    7866 |                         irq_clear_status_flags(irq, IRQ_NO_BALANCING);
         |                         ^~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +/irq_set_status_flags +7864 drivers/scsi/ipr.c

  7845	
  7846	/**
  7847	 * ipr_set_affinity_nobalance
  7848	 * @oa_cfg:	ipr_ioa_cfg struct for an ipr device
  7849	 * @flag:	bool
  7850	 *	true: ensable "IRQ_NO_BALANCING" bit for msix interrupt
  7851	 *	false: disable "IRQ_NO_BALANCING" bit for msix interrupt
  7852	 * Description: This function will be called to disable/enable
  7853	 *	"IRQ_NO_BALANCING" to avoid irqbalance daemon
  7854	 *	kicking in during adapter reset.
  7855	 **/
  7856	static void ipr_set_affinity_nobalance(struct ipr_ioa_cfg *ioa_cfg, bool flag)
  7857	{
  7858		int irq, i;
  7859	
  7860		for (i = 0; i < ioa_cfg->nvectors; i++) {
  7861			irq = pci_irq_vector(ioa_cfg->pdev, i);
  7862	
  7863			if (flag)
> 7864				irq_set_status_flags(irq, IRQ_NO_BALANCING);
  7865			else
> 7866				irq_clear_status_flags(irq, IRQ_NO_BALANCING);
  7867		}
  7868	}
  7869	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
