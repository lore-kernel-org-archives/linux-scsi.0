Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32951FAE
	for <linux-scsi@vger.kernel.org>; Thu, 28 Dec 2023 03:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fWiv3Exu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703735843; x=1735271843;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mk9vjLBE16E5cw9AsYljxjFQ19doLUYDkWMNfeQ1O3I=;
  b=fWiv3Exupk2C/85VtfWIlFhbOX8jG3Avjvv7qyukkOWzqniL66vnG7lO
   NDqQ2X/gWDj+EzF2t41yVTYM3AQF7+N1kbeiEApGQR7FgJQATsM5P79N9
   4mff7XzPtYcWJD0uIIjFRcEWJ/WjYdtzMqftfmLsa69FNGJk60wdnFQmf
   eRttuQyy2vtZ56VWk6oedq676DnV5+YE3q63rZyCtGKd3kEV0dn/C6Tiy
   QUPM8r/YkWonSI/8futqykPA/KO7VlYQV1r9aq9ULLkQPUwk54CLmjRP5
   xEOrme3hzqpIbaJgbCJ+e8FwjlOjwsSPsPWJ1YDsSCn3hi/tcgTlcf6m0
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10936"; a="462925874"
X-IronPort-AV: E=Sophos;i="6.04,310,1695711600"; 
   d="scan'208";a="462925874"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2023 19:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10936"; a="728206850"
X-IronPort-AV: E=Sophos;i="6.04,310,1695711600"; 
   d="scan'208";a="728206850"
Received: from lkp-server02.sh.intel.com (HELO b07ab15da5fe) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 27 Dec 2023 19:57:21 -0800
Received: from kbuild by b07ab15da5fe with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rIhWI-000G1N-2h;
	Thu, 28 Dec 2023 03:57:18 +0000
Date: Thu, 28 Dec 2023 11:56:46 +0800
From: kernel test robot <lkp@intel.com>
To: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: Re: [PATCH v2 1/2] mpt3sas: Reload SBR without rebooting HBA
Message-ID: <202312281141.jDyPezRn-lkp@intel.com>
References: <20231227110610.18276-2-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231227110610.18276-2-ranjan.kumar@broadcom.com>

Hi Ranjan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v6.7-rc7 next-20231222]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ranjan-Kumar/mpt3sas-Reload-SBR-without-rebooting-HBA/20231227-191013
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20231227110610.18276-2-ranjan.kumar%40broadcom.com
patch subject: [PATCH v2 1/2] mpt3sas: Reload SBR without rebooting HBA
config: x86_64-randconfig-161-20231228 (https://download.01.org/0day-ci/archive/20231228/202312281141.jDyPezRn-lkp@intel.com/config)
compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231228/202312281141.jDyPezRn-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202312281141.jDyPezRn-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/scsi/mpt3sas/mpt3sas_ctl.c:2555: warning: Function parameter or member 'arg' not described in '_ctl_enable_diag_sbr_reload'


vim +2555 drivers/scsi/mpt3sas/mpt3sas_ctl.c

  2545	
  2546	/**
  2547	 * _ctl_enable_diag_sbr_reload - enable sbr reload bit
  2548	 * @ioc: per adapter object
  2549	 * @arg - user space buffer containing ioctl content
  2550	 *
  2551	 * Enable the SBR reload bit
  2552	 */
  2553	static int
  2554	_ctl_enable_diag_sbr_reload(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
> 2555	{
  2556		u32 ioc_state, host_diagnostic;
  2557	
  2558		if (ioc->shost_recovery ||
  2559		    ioc->pci_error_recovery || ioc->is_driver_loading ||
  2560		    ioc->remove_host)
  2561			return -EAGAIN;
  2562	
  2563		ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
  2564	
  2565		if (ioc_state != MPI2_IOC_STATE_OPERATIONAL)
  2566			return -EFAULT;
  2567	
  2568		host_diagnostic = ioc->base_readl(&ioc->chip->HostDiagnostic);
  2569	
  2570		if (host_diagnostic & MPI2_DIAG_SBR_RELOAD)
  2571			return 0;
  2572	
  2573		if (mutex_trylock(&ioc->hostdiag_unlock_mutex)) {
  2574			if (mpt3sas_base_unlock_and_get_host_diagnostic(ioc, &host_diagnostic)) {
  2575				mutex_unlock(&ioc->hostdiag_unlock_mutex);
  2576					return -EFAULT;
  2577			}
  2578		} else
  2579			return -EAGAIN;
  2580	
  2581		host_diagnostic |= MPI2_DIAG_SBR_RELOAD;
  2582		writel(host_diagnostic, &ioc->chip->HostDiagnostic);
  2583		host_diagnostic = ioc->base_readl(&ioc->chip->HostDiagnostic);
  2584		mpt3sas_base_lock_host_diagnostic(ioc);
  2585		mutex_unlock(&ioc->hostdiag_unlock_mutex);
  2586	
  2587		if (!(host_diagnostic & MPI2_DIAG_SBR_RELOAD)) {
  2588			ioc_err(ioc, "%s: Failed to set Diag SBR Reload Bit\n", __func__);
  2589			return -EFAULT;
  2590		}
  2591	
  2592		ioc_info(ioc, "%s: Successfully set the Diag SBR Reload Bit\n", __func__);
  2593		return 0;
  2594	}
  2595	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
