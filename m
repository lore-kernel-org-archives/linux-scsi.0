Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90917183CC4;
	Thu, 22 Aug 2024 10:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724323148; cv=none; b=Vx7OUu0mcRzMVE3dIq+3eFGN+2k884k3xoTdxenv0EN9LsZY55FzwHR/RROx7sHO2SMiLgOCjXr9+BOJX5gFsEkK8fpzuI3YcgyxbkAGtTWEhpe2aTxTnnQ+AgWfUpn2+iTWX5iBoy3zXZjp8mfCZLV0K00yUIKiTs9NEzd0njo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724323148; c=relaxed/simple;
	bh=Io9HIxmoSqST+xmstMBwH5AUMwojE/puDceefBlKsTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qQTiqoSOEYs3GcXwhZ5I7XAND/p4ucfjD/G2U3DIAdqodf6PeIFTQ/WD5ocl2iR/AiwXWM31wjyIFmvhUvtFCCQpy6NkeQv4BkaMOe4LCZg+f2T2mNWZFu/81PEIv3uyTBJsgUN2/uhZuonzrIz2FgBkjT4lSygeDbSJ5HZd12I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CH6+LB2v; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CH6+LB2v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724323145; x=1755859145;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Io9HIxmoSqST+xmstMBwH5AUMwojE/puDceefBlKsTU=;
  b=CH6+LB2vZyYgW55xWQJ4dmgQW9WOk/w/PsUN+QgjkdKd1npE3dHSIYCQ
   tmb6WNjlU8ocGSRLAGxsw6uo7KHtXldTZ4BPnyM3S6V6hUi9TO38BLQPv
   m8n2V3SlPNvNMpEUPG4EAPmyA1ZsZ4ZOnlm3mQjCfVVh0k+Az/Ynda9oe
   VvgL2l3u/llr7MGCJsX2LDaFe9bhRQkoCHE0HwSMmpgfTbbJ7U7mKxY11
   xwbE6f/rmFSWVUw/ELOD7q+Pu62x19mark0zuHbXAZnrfJ888buAFO+V1
   a8N6SH9nE4BGELT7TGDJNErheBSCa+y40q0S+d7he8Gk26219xNf+cP+d
   A==;
X-CSE-ConnectionGUID: pv+1dAuDRha5DHxBpCAUiQ==
X-CSE-MsgGUID: Lf2gwXAjRW+c1/cwO1v6sw==
X-IronPort-AV: E=McAfee;i="6700,10204,11171"; a="33346049"
X-IronPort-AV: E=Sophos;i="6.10,166,1719903600"; 
   d="scan'208";a="33346049"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2024 03:39:04 -0700
X-CSE-ConnectionGUID: ZhXwxmwCT0KLnj6UUSK+1Q==
X-CSE-MsgGUID: mBz6vPkIRAiOT0CUj44S4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,166,1719903600"; 
   d="scan'208";a="92144920"
Received: from lkp-server01.sh.intel.com (HELO 9a732dc145d3) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 22 Aug 2024 03:39:02 -0700
Received: from kbuild by 9a732dc145d3 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sh5DX-000Cfy-1p;
	Thu, 22 Aug 2024 10:38:59 +0000
Date: Thu, 22 Aug 2024 18:38:40 +0800
From: kernel test robot <lkp@intel.com>
To: Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
	avri.altman@wdc.com, bvanassche@acm.org, jejb@linux.ibm.com,
	martin.petersen@oracle.com, beanhuo@micron.com,
	adrian.hunter@intel.com, h10.kim@samsung.com, hy50.seo@samsung.com,
	sh425.lee@samsung.com, kwangwon.min@samsung.com,
	junwoo80.lee@samsung.com, wkon.kim@samsung.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Kiwoong Kim <kwmad.kim@samsung.com>
Subject: Re: [PATCH v1 1/2] scsi: ufs: core: introduce override_cqe_ocs
Message-ID: <202408221823.jnozM7Ys-lkp@intel.com>
References: <895b69ac1e938490cd1d17b5f82b6f730bcd82c2.1724222619.git.kwmad.kim@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <895b69ac1e938490cd1d17b5f82b6f730bcd82c2.1724222619.git.kwmad.kim@samsung.com>

Hi Kiwoong,

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next krzk/for-next linus/master v6.11-rc4 next-20240822]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Kiwoong-Kim/scsi-ufs-core-introduce-override_cqe_ocs/20240821-144404
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/895b69ac1e938490cd1d17b5f82b6f730bcd82c2.1724222619.git.kwmad.kim%40samsung.com
patch subject: [PATCH v1 1/2] scsi: ufs: core: introduce override_cqe_ocs
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20240822/202408221823.jnozM7Ys-lkp@intel.com/config)
compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240822/202408221823.jnozM7Ys-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408221823.jnozM7Ys-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/ufs/core/ufshcd.c:828:39: error: use of undeclared identifier 'hba'
     828 |                 return ufshcd_vops_override_cqe_ocs(hba,
         |                                                     ^
   drivers/ufs/core/ufshcd.c:10344:44: warning: shift count >= width of type [-Wshift-count-overflow]
    10344 |                 if (!dma_set_mask_and_coherent(hba->dev, DMA_BIT_MASK(64)))
          |                                                          ^~~~~~~~~~~~~~~~
   include/linux/dma-mapping.h:77:54: note: expanded from macro 'DMA_BIT_MASK'
      77 | #define DMA_BIT_MASK(n) (((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
         |                                                      ^ ~~~
   1 warning and 1 error generated.


vim +/hba +828 drivers/ufs/core/ufshcd.c

   814	
   815	/**
   816	 * ufshcd_get_tr_ocs - Get the UTRD Overall Command Status
   817	 * @lrbp: pointer to local command reference block
   818	 * @cqe: pointer to the completion queue entry
   819	 *
   820	 * This function is used to get the OCS field from UTRD
   821	 *
   822	 * Return: the OCS field in the UTRD.
   823	 */
   824	static enum utp_ocs ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp,
   825					      struct cq_entry *cqe)
   826	{
   827		if (cqe)
 > 828			return ufshcd_vops_override_cqe_ocs(hba,
   829							    le32_to_cpu(cqe->status) &
   830							    MASK_OCS);
   831	
   832		return lrbp->utr_descriptor_ptr->header.ocs & MASK_OCS;
   833	}
   834	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
