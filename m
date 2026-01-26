Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500D721B192;
	Mon, 26 Jan 2026 05:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769404849; cv=none; b=PwnPDB/GfhI95KqNeY+5SWHywpgIa6Okn0EZs91F5c/RZvtgwuJxBIfIVTJHBjMi4lYu9T2eQOEqYSM6HRmuLO9ph1PLv3hPvvfm2XUWD7vq3ELgSVInW5j1lmeYGDqJTJLg+xUywTZpqErCOcZ6q/vaNPSDLYA6VmbvkPGhHBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769404849; c=relaxed/simple;
	bh=lIIySIxjC+F/+hLCaAdTMtlygliQTbPaYAx9O5w1niM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ooHN0IhVsgpBbg3La3bQpfJEu8MN6UjpVgAv2BT8h55mbFZkDUCS4zuYu6ul617ziN6pSQItA/l0cfRCmHYe+0xYQaFk0o3Y0vpbl5x1NNMKz8JM2QwucrRMnTc3KBWxZgwKuKX2O5lJ7u9GZ3U0kT26XCk7SKrTZiQn8JkikVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jnyQW9We; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jnyQW9We"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769404849; x=1800940849;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lIIySIxjC+F/+hLCaAdTMtlygliQTbPaYAx9O5w1niM=;
  b=jnyQW9We4WFTioHd8qigtIRyCKdYwEquAv0CgOrAYE1yuJpMahsJL8WO
   SOpFi8X8E4kzDH99htzeFK4oZPxPBz84ufgejPOvp/Tayt6W3l33BNxsP
   RlSp0cP5KBg9CXXrEa69VkOH4uhDqdYo7QLz/iNzG/vNoNKa7wIbjkm55
   niFh+bXhrFdrBUGU4OwgWa6ncaTqYciBJsWcZZYm13z1nxtgd4legtpkx
   wL8gInpikgJ3omuwacD75+KX3OMIsWdGkJzJP3lDOJudJuwk9YpHaNmK+
   rOkbOOZY0emkzNKfU/MeZWtihcoc4Fx/FfOpqWNaYtCVA8s7gszVL81N5
   g==;
X-CSE-ConnectionGUID: JFLDQ8Z1RQae3/Fi7HUWZQ==
X-CSE-MsgGUID: f+XJ5FdMRSaaW1hdOp+55Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="93243272"
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="93243272"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2026 21:20:48 -0800
X-CSE-ConnectionGUID: shdXjNf4S0evh3rcUgSJqw==
X-CSE-MsgGUID: 7fFaf1RbTM+qk/O1vpVBxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="211688175"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 25 Jan 2026 21:20:45 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vkF1m-00000000Wve-1v2U;
	Mon, 26 Jan 2026 05:20:42 +0000
Date: Mon, 26 Jan 2026 13:20:13 +0800
From: kernel test robot <lkp@intel.com>
To: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>, sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Subject: Re: [PATCH] scsi: mpt3sas: fix a potential memory leak in
 scsih_pci_slot_reset()
Message-ID: <202601261539.Dt3EKe8y-lkp@intel.com>
References: <20260125161201.2156109-1-lihaoxiang@isrc.iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260125161201.2156109-1-lihaoxiang@isrc.iscas.ac.cn>

Hi Haoxiang,

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next linus/master v6.19-rc7 next-20260123]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Haoxiang-Li/scsi-mpt3sas-fix-a-potential-memory-leak-in-scsih_pci_slot_reset/20260126-001420
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20260125161201.2156109-1-lihaoxiang%40isrc.iscas.ac.cn
patch subject: [PATCH] scsi: mpt3sas: fix a potential memory leak in scsih_pci_slot_reset()
config: s390-allmodconfig (https://download.01.org/0day-ci/archive/20260126/202601261539.Dt3EKe8y-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260126/202601261539.Dt3EKe8y-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601261539.Dt3EKe8y-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/scsi/mpt3sas/mpt3sas_scsih.c:12533:2: error: call to undeclared function 'mpt3sas_base_unmap_resources'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    12533 |         mpt3sas_base_unmap_resources(ioc);
          |         ^
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:12533:2: note: did you mean 'mpt3sas_base_map_resources'?
   drivers/scsi/mpt3sas/mpt3sas_base.h:1700:5: note: 'mpt3sas_base_map_resources' declared here
    1700 | int mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc);
         |     ^
   1 error generated.


vim +/mpt3sas_base_unmap_resources +12533 drivers/scsi/mpt3sas/mpt3sas_scsih.c

 12496	
 12497	/**
 12498	 * scsih_pci_slot_reset - Called when PCI slot has been reset.
 12499	 * @pdev: PCI device struct
 12500	 *
 12501	 * Description: This routine is called by the pci error recovery
 12502	 * code after the PCI slot has been reset, just before we
 12503	 * should resume normal operations.
 12504	 */
 12505	static pci_ers_result_t
 12506	scsih_pci_slot_reset(struct pci_dev *pdev)
 12507	{
 12508		struct Scsi_Host *shost;
 12509		struct MPT3SAS_ADAPTER *ioc;
 12510		int rc;
 12511	
 12512		if (_scsih_get_shost_and_ioc(pdev, &shost, &ioc))
 12513			return PCI_ERS_RESULT_DISCONNECT;
 12514	
 12515		ioc_info(ioc, "PCI error: slot reset callback!!\n");
 12516	
 12517		ioc->pci_error_recovery = 0;
 12518		ioc->pdev = pdev;
 12519		pci_restore_state(pdev);
 12520		rc = mpt3sas_base_map_resources(ioc);
 12521		if (rc)
 12522			return PCI_ERS_RESULT_DISCONNECT;
 12523	
 12524		ioc_info(ioc, "Issuing Hard Reset as part of PCI Slot Reset\n");
 12525		rc = mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
 12526	
 12527		ioc_warn(ioc, "hard reset: %s\n",
 12528			 (rc == 0) ? "success" : "failed");
 12529	
 12530		if (!rc)
 12531			return PCI_ERS_RESULT_RECOVERED;
 12532	
 12533		mpt3sas_base_unmap_resources(ioc);
 12534		return PCI_ERS_RESULT_DISCONNECT;
 12535	}
 12536	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
