Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NUjuHNsC"
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FDE10D1
	for <linux-scsi@vger.kernel.org>; Thu,  7 Dec 2023 07:07:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701961677; x=1733497677;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=y8UPT+Z70Ay8XagVnVMa00TP4BbFOHOTSxDZdO7utXs=;
  b=NUjuHNsC6EMHVYxq4U8eAeJ7FpMfX5v3JgclLFcqk/4nuvQJdCb5dyhV
   nNmmx5r7NX8g2Jnqr9iDvvP+NkdmJxNyZIa8oJ2EDIK4Nh8NLr6FybOew
   pNUhDa5wBF0jSnmDCO1WEgPBYEM9TZfE+0p4KHZaZqwFZaS/cPG4HAlqV
   aOMGyu7ACZFBJDBKzn54p89QjkJzD1CTcZ2mlKDPW9svdt1p+gGrQ3lbZ
   Bm4r9DeuYzRQvu75zbS72EgGwwoPq0jaJybrMpcAq8hDjX3yAUHPoKjbK
   EXCR8cpj7j8ZVUY+FzZl2k520styUTpoSDekWVHomU517Fu4MEeP80kwj
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10917"; a="1350216"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="1350216"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2023 07:07:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10917"; a="945065976"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="945065976"
Received: from lkp-server02.sh.intel.com (HELO b07ab15da5fe) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 07 Dec 2023 07:07:53 -0800
Received: from kbuild by b07ab15da5fe with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rBFyg-000COf-1Q;
	Thu, 07 Dec 2023 15:07:50 +0000
Date: Thu, 7 Dec 2023 23:07:40 +0800
From: kernel test robot <lkp@intel.com>
To: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com, sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com, prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: Re: [PATCH v1 2/4] mpi3mr: Support PCIe Error Recovery callback
 handlers
Message-ID: <202312072213.uopHjdQV-lkp@intel.com>
References: <20231206152513.71253-3-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231206152513.71253-3-ranjan.kumar@broadcom.com>

Hi Ranjan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on next-20231207]
[cannot apply to jejb-scsi/for-next linus/master v6.7-rc4]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ranjan-Kumar/mpi3mr-Improve-Shutdown-times-when-firmware-has-faulted/20231207-004256
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20231206152513.71253-3-ranjan.kumar%40broadcom.com
patch subject: [PATCH v1 2/4] mpi3mr: Support PCIe Error Recovery callback handlers
config: arc-randconfig-001-20231207 (https://download.01.org/0day-ci/archive/20231207/202312072213.uopHjdQV-lkp@intel.com/config)
compiler: arc-elf-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231207/202312072213.uopHjdQV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202312072213.uopHjdQV-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/scsi/mpi3mr/mpi3mr_os.c:5272: warning: Function parameter or member 'mrioc' not described in 'mpi3mr_get_shost_and_mrioc'
>> drivers/scsi/mpi3mr/mpi3mr_os.c:5272: warning: Excess function parameter 'ioc' description in 'mpi3mr_get_shost_and_mrioc'


vim +5272 drivers/scsi/mpi3mr/mpi3mr_os.c

  5258	
  5259	/**
  5260	 * mpi3mr_get_shost_and_mrioc - get shost and ioc reference if
  5261	 *			they are valid
  5262	 * @pdev: PCI device struct
  5263	 * @shost: address to store scsi host reference
  5264	 * @ioc: address store HBA adapter reference
  5265	 *
  5266	 * Return: 0 if *shost and *ioc are not NULL otherwise -1.
  5267	 */
  5268	
  5269	static int
  5270	mpi3mr_get_shost_and_mrioc(struct pci_dev *pdev,
  5271		struct Scsi_Host **shost, struct mpi3mr_ioc **mrioc)
> 5272	{
  5273		*shost = pci_get_drvdata(pdev);
  5274		if (*shost == NULL) {
  5275			dev_err(&pdev->dev, "pdev's driver data is null\n");
  5276			return -1;
  5277		}
  5278	
  5279		*mrioc = shost_priv(*shost);
  5280		if (*mrioc == NULL) {
  5281			dev_err(&pdev->dev, "shost's private data is null\n");
  5282			*shost = NULL;
  5283			return -1;
  5284	}
  5285		return 0;
  5286	}
  5287	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
