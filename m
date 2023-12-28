Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC3F1FAB
	for <linux-scsi@vger.kernel.org>; Thu, 28 Dec 2023 01:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NoMxAmru"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703728440; x=1735264440;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FO3iTRX116ezNIrkmxRj4P+4PaUO5zWeJwg4IniOlWw=;
  b=NoMxAmruLDzNilG81OPKQ/MInTndXkz9K9tCKsAVK1qjYYx9Z8TdZQaY
   uneeUWjYuM4xMhh/FUoxVptevRV/BZ8l/IeYbi3+emXbkO6TLSRNP99Sv
   UHZRDmG47y/TmU5rM0wvf0bSiIGSQx0LFiEXqqPIRbWdLjkFj6+RQWIqe
   KuMvN+hP4st0ZLbt+HssSBzdzlSiLq7IgOl+ZUEzm3iDaBBmJE7nM+vSp
   dLaMcME/txhTwxH2XhH7xn6v2pF0XqL1EJcGh8LKPX3Brxi4WwkhlzqdB
   z5DuKdFLbA/leid/Qndo9i0di0hsydSdw0w0ryObgfpVG76IeoddVCcbt
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10936"; a="395391553"
X-IronPort-AV: E=Sophos;i="6.04,310,1695711600"; 
   d="scan'208";a="395391553"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2023 17:53:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10936"; a="771581453"
X-IronPort-AV: E=Sophos;i="6.04,310,1695711600"; 
   d="scan'208";a="771581453"
Received: from lkp-server02.sh.intel.com (HELO b07ab15da5fe) ([10.239.97.151])
  by orsmga007.jf.intel.com with ESMTP; 27 Dec 2023 17:53:56 -0800
Received: from kbuild by b07ab15da5fe with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rIfas-000Fvx-1B;
	Thu, 28 Dec 2023 01:53:54 +0000
Date: Thu, 28 Dec 2023 09:53:05 +0800
From: kernel test robot <lkp@intel.com>
To: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: Re: [PATCH v2 1/2] mpt3sas: Reload SBR without rebooting HBA
Message-ID: <202312280909.MZyhxwBL-lkp@intel.com>
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
config: x86_64-allmodconfig (https://download.01.org/0day-ci/archive/20231228/202312280909.MZyhxwBL-lkp@intel.com/config)
compiler: ClangBuiltLinux clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231228/202312280909.MZyhxwBL-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202312280909.MZyhxwBL-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/scsi/mpt3sas/mpt3sas_base.c:8025:4: warning: misleading indentation; statement is not part of the previous 'if' [-Wmisleading-indentation]
    8025 |                         msleep(MPI2_HARD_RESET_PCIE_SECOND_READ_DELAY_MICRO_SEC/1000);
         |                         ^
   drivers/scsi/mpt3sas/mpt3sas_base.c:8021:3: note: previous statement is here
    8021 |                 if (!(host_diagnostic & MPI2_DIAG_RESET_ADAPTER))
         |                 ^
   1 warning generated.


vim +/if +8025 drivers/scsi/mpt3sas/mpt3sas_base.c

2af5cddbc76400 Ranjan Kumar     2023-12-27  7976  
2af5cddbc76400 Ranjan Kumar     2023-12-27  7977  /**
2af5cddbc76400 Ranjan Kumar     2023-12-27  7978   * _base_diag_reset - the "big hammer" start of day reset
2af5cddbc76400 Ranjan Kumar     2023-12-27  7979   * @ioc: per adapter object
2af5cddbc76400 Ranjan Kumar     2023-12-27  7980   *
2af5cddbc76400 Ranjan Kumar     2023-12-27  7981   * Return: 0 for success, non-zero for failure.
2af5cddbc76400 Ranjan Kumar     2023-12-27  7982   */
2af5cddbc76400 Ranjan Kumar     2023-12-27  7983  static int
2af5cddbc76400 Ranjan Kumar     2023-12-27  7984  _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
2af5cddbc76400 Ranjan Kumar     2023-12-27  7985  {
2af5cddbc76400 Ranjan Kumar     2023-12-27  7986  	u32 host_diagnostic;
2af5cddbc76400 Ranjan Kumar     2023-12-27  7987  	u32 ioc_state;
2af5cddbc76400 Ranjan Kumar     2023-12-27  7988  	u32 count;
2af5cddbc76400 Ranjan Kumar     2023-12-27  7989  	u32 hcb_size;
2af5cddbc76400 Ranjan Kumar     2023-12-27  7990  
2af5cddbc76400 Ranjan Kumar     2023-12-27  7991  	ioc_info(ioc, "sending diag reset !!\n");
2af5cddbc76400 Ranjan Kumar     2023-12-27  7992  
2af5cddbc76400 Ranjan Kumar     2023-12-27  7993  	pci_cfg_access_lock(ioc->pdev);
f92363d1235949 Sreekanth Reddy  2012-11-30  7994  
2af5cddbc76400 Ranjan Kumar     2023-12-27  7995  	drsprintk(ioc, ioc_info(ioc, "clear interrupts\n"));
2af5cddbc76400 Ranjan Kumar     2023-12-27  7996  
2af5cddbc76400 Ranjan Kumar     2023-12-27  7997  	mutex_lock(&ioc->hostdiag_unlock_mutex);
2af5cddbc76400 Ranjan Kumar     2023-12-27  7998  	if (mpt3sas_base_unlock_and_get_host_diagnostic(ioc, &host_diagnostic))
2af5cddbc76400 Ranjan Kumar     2023-12-27  7999  		goto out;
2af5cddbc76400 Ranjan Kumar     2023-12-27  8000  
2af5cddbc76400 Ranjan Kumar     2023-12-27  8001  	hcb_size = ioc->base_readl(&ioc->chip->HCBSize);
919d8a3f3fef99 Joe Perches      2018-09-17  8002  	drsprintk(ioc, ioc_info(ioc, "diag reset: issued\n"));
f92363d1235949 Sreekanth Reddy  2012-11-30  8003  	writel(host_diagnostic | MPI2_DIAG_RESET_ADAPTER,
f92363d1235949 Sreekanth Reddy  2012-11-30  8004  	     &ioc->chip->HostDiagnostic);
f92363d1235949 Sreekanth Reddy  2012-11-30  8005  
b453ff84de6caf Sreekanth Reddy  2013-06-29  8006  	/* This delay allows the chip PCIe hardware time to finish reset tasks */
b453ff84de6caf Sreekanth Reddy  2013-06-29  8007  	msleep(MPI2_HARD_RESET_PCIE_FIRST_READ_DELAY_MICRO_SEC/1000);
f92363d1235949 Sreekanth Reddy  2012-11-30  8008  
b453ff84de6caf Sreekanth Reddy  2013-06-29  8009  	/* Approximately 300 second max wait */
b453ff84de6caf Sreekanth Reddy  2013-06-29  8010  	for (count = 0; count < (300000000 /
b453ff84de6caf Sreekanth Reddy  2013-06-29  8011  	    MPI2_HARD_RESET_PCIE_SECOND_READ_DELAY_MICRO_SEC); count++) {
f92363d1235949 Sreekanth Reddy  2012-11-30  8012  
4ca10f3e31745d Ranjan Kumar     2023-08-29  8013  		host_diagnostic = ioc->base_readl_ext_retry(&ioc->chip->HostDiagnostic);
f92363d1235949 Sreekanth Reddy  2012-11-30  8014  
5b061980e36282 Sreekanth Reddy  2019-12-26  8015  		if (host_diagnostic == 0xFFFFFFFF) {
5b061980e36282 Sreekanth Reddy  2019-12-26  8016  			ioc_info(ioc,
5b061980e36282 Sreekanth Reddy  2019-12-26  8017  			    "Invalid host diagnostic register value\n");
af6ec1eee5ed68 Suganath Prabu S 2020-07-30  8018  			_base_dump_reg_set(ioc);
f92363d1235949 Sreekanth Reddy  2012-11-30  8019  			goto out;
5b061980e36282 Sreekanth Reddy  2019-12-26  8020  		}
f92363d1235949 Sreekanth Reddy  2012-11-30  8021  		if (!(host_diagnostic & MPI2_DIAG_RESET_ADAPTER))
f92363d1235949 Sreekanth Reddy  2012-11-30  8022  			break;
f92363d1235949 Sreekanth Reddy  2012-11-30  8023  
2af5cddbc76400 Ranjan Kumar     2023-12-27  8024  		/* Wait to pass the second read delay window */
98c56ad32c33f0 Calvin Owens     2016-07-28 @8025  			msleep(MPI2_HARD_RESET_PCIE_SECOND_READ_DELAY_MICRO_SEC/1000);
f92363d1235949 Sreekanth Reddy  2012-11-30  8026  	}
f92363d1235949 Sreekanth Reddy  2012-11-30  8027  
f92363d1235949 Sreekanth Reddy  2012-11-30  8028  	if (host_diagnostic & MPI2_DIAG_HCB_MODE) {
f92363d1235949 Sreekanth Reddy  2012-11-30  8029  
919d8a3f3fef99 Joe Perches      2018-09-17  8030  		drsprintk(ioc,
2af5cddbc76400 Ranjan Kumar     2023-12-27  8031  			ioc_info(ioc, "restart the adapter assuming the\n"
2af5cddbc76400 Ranjan Kumar     2023-12-27  8032  					"HCB Address points to good F/W\n"));
f92363d1235949 Sreekanth Reddy  2012-11-30  8033  		host_diagnostic &= ~MPI2_DIAG_BOOT_DEVICE_SELECT_MASK;
f92363d1235949 Sreekanth Reddy  2012-11-30  8034  		host_diagnostic |= MPI2_DIAG_BOOT_DEVICE_SELECT_HCDW;
f92363d1235949 Sreekanth Reddy  2012-11-30  8035  		writel(host_diagnostic, &ioc->chip->HostDiagnostic);
f92363d1235949 Sreekanth Reddy  2012-11-30  8036  
919d8a3f3fef99 Joe Perches      2018-09-17  8037  		drsprintk(ioc, ioc_info(ioc, "re-enable the HCDW\n"));
f92363d1235949 Sreekanth Reddy  2012-11-30  8038  		writel(hcb_size | MPI2_HCB_SIZE_HCB_ENABLE,
f92363d1235949 Sreekanth Reddy  2012-11-30  8039  		    &ioc->chip->HCBSize);
f92363d1235949 Sreekanth Reddy  2012-11-30  8040  	}
f92363d1235949 Sreekanth Reddy  2012-11-30  8041  
919d8a3f3fef99 Joe Perches      2018-09-17  8042  	drsprintk(ioc, ioc_info(ioc, "restart the adapter\n"));
f92363d1235949 Sreekanth Reddy  2012-11-30  8043  	writel(host_diagnostic & ~MPI2_DIAG_HOLD_IOC_RESET,
f92363d1235949 Sreekanth Reddy  2012-11-30  8044  	    &ioc->chip->HostDiagnostic);
f92363d1235949 Sreekanth Reddy  2012-11-30  8045  
2af5cddbc76400 Ranjan Kumar     2023-12-27  8046  	mpt3sas_base_lock_host_diagnostic(ioc);
2af5cddbc76400 Ranjan Kumar     2023-12-27  8047  	mutex_unlock(&ioc->hostdiag_unlock_mutex);
f92363d1235949 Sreekanth Reddy  2012-11-30  8048  
919d8a3f3fef99 Joe Perches      2018-09-17  8049  	drsprintk(ioc, ioc_info(ioc, "Wait for FW to go to the READY state\n"));
98c56ad32c33f0 Calvin Owens     2016-07-28  8050  	ioc_state = _base_wait_on_iocstate(ioc, MPI2_IOC_STATE_READY, 20);
f92363d1235949 Sreekanth Reddy  2012-11-30  8051  	if (ioc_state) {
919d8a3f3fef99 Joe Perches      2018-09-17  8052  		ioc_err(ioc, "%s: failed going to ready state (ioc_state=0x%x)\n",
919d8a3f3fef99 Joe Perches      2018-09-17  8053  			__func__, ioc_state);
af6ec1eee5ed68 Suganath Prabu S 2020-07-30  8054  		_base_dump_reg_set(ioc);
f92363d1235949 Sreekanth Reddy  2012-11-30  8055  		goto out;
f92363d1235949 Sreekanth Reddy  2012-11-30  8056  	}
f92363d1235949 Sreekanth Reddy  2012-11-30  8057  
3c8604691d2acc Sreekanth Reddy  2021-03-30  8058  	pci_cfg_access_unlock(ioc->pdev);
919d8a3f3fef99 Joe Perches      2018-09-17  8059  	ioc_info(ioc, "diag reset: SUCCESS\n");
f92363d1235949 Sreekanth Reddy  2012-11-30  8060  	return 0;
f92363d1235949 Sreekanth Reddy  2012-11-30  8061  
f92363d1235949 Sreekanth Reddy  2012-11-30  8062   out:
3c8604691d2acc Sreekanth Reddy  2021-03-30  8063  	pci_cfg_access_unlock(ioc->pdev);
919d8a3f3fef99 Joe Perches      2018-09-17  8064  	ioc_err(ioc, "diag reset: FAILED\n");
2af5cddbc76400 Ranjan Kumar     2023-12-27  8065  	mutex_unlock(&ioc->hostdiag_unlock_mutex);
f92363d1235949 Sreekanth Reddy  2012-11-30  8066  	return -EFAULT;
f92363d1235949 Sreekanth Reddy  2012-11-30  8067  }
f92363d1235949 Sreekanth Reddy  2012-11-30  8068  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
