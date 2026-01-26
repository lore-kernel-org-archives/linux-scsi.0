Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E560C262A6;
	Mon, 26 Jan 2026 05:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769404761; cv=none; b=Di4EaDbtAbc+35wePKSN/wHewMtVp3gq4SQdR4WksLLsZGrhAt3I/Avwk2/YG/toPg7XFBPExrSziCkOoXv7BPMJZkazttfcX1CyQbHs/PBwXtOMm5hwpecjCN4luCpd+hvIY8BHC6jR7vtf7qVJd1REuTbGOoxn8bWvStZt1i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769404761; c=relaxed/simple;
	bh=t/fa3a7X4u8DrISTvupz9KIcCGarM7GxWYjhFW0pueM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QypH/kWB0JRNNvZ/9/S+Mzv9X9ii64VSDiRKaSDNqf7d0bMlVTCQPLBWNvRzue00VaM2GwbngCD7/FAtPixQO6rs2J2XwYm+YhAyHorAWKKAKqxEKLDuF6CRUgI9RY2RI2c0x6Wfm2ZMHCwjSO+7eSlVCUb7m7FzJ4hf1bO43NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YtoQFOMP; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YtoQFOMP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769404760; x=1800940760;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=t/fa3a7X4u8DrISTvupz9KIcCGarM7GxWYjhFW0pueM=;
  b=YtoQFOMPbQnXrQQrWKkZJ3ZJuhi/+9W++vz0gXHvnd7DkK4nvKZgyshK
   uZk7IMjzncZ6+gKinym3+DUBBntAU24H14mIySwJYqoxR7UXgY+CEK4oY
   rY2ewIQKF7AgxbrSMwi73NMxwKHHBvZVn6sJgNsD6lb7zNykxJVthUD2P
   IC+JCVf3uQT2TK4gmhcHnhtnIXDctz4jmU3N5vokCY+eL/CK4r3u5lgjN
   8PKb7HKEvqkh+S+0hq4lN8r77XyLf3vm5pzroi5C2xRJIMxTLSVhantGT
   eY92LazP/vYz/dEDQRu7iHHXc8zQdjAkGmXfDwF3uDMv7OhHlbC6FJ1Dd
   A==;
X-CSE-ConnectionGUID: vIS0vtGfTra72kCEi9cjFw==
X-CSE-MsgGUID: j/gsvhGNQO6szn9bOJGK5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="74422224"
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="74422224"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2026 21:19:19 -0800
X-CSE-ConnectionGUID: uinJaD5ZTt2WBO+w+yhgCA==
X-CSE-MsgGUID: bX22nsKMT/ekVQcZPT+Unw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="206712129"
Received: from igk-lkp-server01.igk.intel.com (HELO afc5bfd7f602) ([10.211.93.152])
  by orviesa006.jf.intel.com with ESMTP; 25 Jan 2026 21:19:17 -0800
Received: from kbuild by afc5bfd7f602 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vkF0M-000000001R7-0xOA;
	Mon, 26 Jan 2026 05:19:14 +0000
Date: Mon, 26 Jan 2026 06:19:07 +0100
From: kernel test robot <lkp@intel.com>
To: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>, sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Subject: Re: [PATCH] scsi: mpt3sas: fix a potential memory leak in
 scsih_pci_slot_reset()
Message-ID: <202601260641.AHnz8FCz-lkp@intel.com>
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
config: x86_64-rhel-9.4-ltp (https://download.01.org/0day-ci/archive/20260126/202601260641.AHnz8FCz-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260126/202601260641.AHnz8FCz-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601260641.AHnz8FCz-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/scsi/mpt3sas/mpt3sas_scsih.c: In function 'scsih_pci_slot_reset':
>> drivers/scsi/mpt3sas/mpt3sas_scsih.c:12533:9: error: implicit declaration of function 'mpt3sas_base_unmap_resources'; did you mean 'mpt3sas_base_map_resources'? [-Wimplicit-function-declaration]
   12533 |         mpt3sas_base_unmap_resources(ioc);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |         mpt3sas_base_map_resources


vim +12533 drivers/scsi/mpt3sas/mpt3sas_scsih.c

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
