Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D141BC40;
	Tue, 13 Aug 2024 03:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723519512; cv=none; b=tFFWpvhjj3V+WBL3h/fvYr29P2M3+gXP4xGo9vLKgD0xGzDhlITAPCg83o+Ppa9FudEReD0Bcm3xeuqdi93lhYNF/RUMn6pg5it1sUzFQju8pMsq244p9SYHKvA1vmtbFaJHOKlgiLI3CFRfJmrDvHmB1oVq9xPhIBkq8QJ14NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723519512; c=relaxed/simple;
	bh=bcmsVURmVtNxAHeqBqR8yCiKC6IjMZhSkNykpQINtjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PbQK7EH0T+1zxHX8GqXZ2uBB7iSH0MXKD+LJoUmm+sKsoISRH0SVVCHkNa2oN6AjERWc5LrHdtpZRX4f84jzQjdTxWTP43+iK/gKIqetCdExTpu64vbDro/CaySIhmt282W6wi3nksCUXB4X4le7q+svPhoMGyMKmt9Z31O31hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jHeTj66Y; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jHeTj66Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723519511; x=1755055511;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bcmsVURmVtNxAHeqBqR8yCiKC6IjMZhSkNykpQINtjU=;
  b=jHeTj66YxVKB3RG7FuAXmlgrQ1S3YpE7GGa5QI4y3iHlTPruZSA2FD/O
   0ug8pFf6Czo3KOZvaXsQBeO37l5tfXfIaX3uSyS3YuvOwsvUC1a82RPoq
   Rt594u3klono9xfwroTxh27hGwQCuSuv4cBghlxt/cHeGOv92I2u+WVU7
   TjcNSe4jtzCtH2PwZiOHtqq+aK1h2mxKCKn664ESbosqEifych5N6vt6L
   N5PwIE8E0nHuNbJiHdDxN8DcZh8ygE9SVleETnL4dBOSj/ihaX3wQcZqR
   WvHAW1yUCkFKGDl6i2cAPSyldlYAquq8re2xUfgP02VuvL06Uci0WkSdp
   w==;
X-CSE-ConnectionGUID: SQVCkm41Tr2n/qoLutqmew==
X-CSE-MsgGUID: UUXWPzvrSrKHOUNPFFMuZQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="25451281"
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="25451281"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 20:25:10 -0700
X-CSE-ConnectionGUID: gAyDy4E+Q6abYjL+5f/GlA==
X-CSE-MsgGUID: hcMBZAIsS0mjRPbgD6e1tA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="81751551"
Received: from lkp-server01.sh.intel.com (HELO 9a732dc145d3) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 12 Aug 2024 20:25:06 -0700
Received: from kbuild by 9a732dc145d3 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sdi9f-000086-2p;
	Tue, 13 Aug 2024 03:25:03 +0000
Date: Tue, 13 Aug 2024 11:24:15 +0800
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
Subject: Re: [PATCH v1] scsi: ufs: core: introduce override_cqe_ocs
Message-ID: <202408131018.XQ8EvnAi-lkp@intel.com>
References: <1723446114-153235-1-git-send-email-kwmad.kim@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1723446114-153235-1-git-send-email-kwmad.kim@samsung.com>

Hi Kiwoong,

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next linus/master v6.11-rc3 next-20240812]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Kiwoong-Kim/scsi-ufs-core-introduce-override_cqe_ocs/20240812-151156
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/1723446114-153235-1-git-send-email-kwmad.kim%40samsung.com
patch subject: [PATCH v1] scsi: ufs: core: introduce override_cqe_ocs
config: i386-buildonly-randconfig-004-20240812 (https://download.01.org/0day-ci/archive/20240813/202408131018.XQ8EvnAi-lkp@intel.com/config)
compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240813/202408131018.XQ8EvnAi-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408131018.XQ8EvnAi-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/ufs/core/ufshcd.c:31:
>> drivers/ufs/core/ufshcd-priv.h:282:41: error: too few arguments to function call, expected 2, have 1
     282 |                 return hba->vops->override_cqe_ocs(hba);
         |                        ~~~~~~~~~~~~~~~~~~~~~~~~~~~    ^
>> drivers/ufs/core/ufshcd.c:828:39: error: use of undeclared identifier 'hba'
     828 |                 return ufshcd_vops_override_cqe_ocs(hba,
         |                                                     ^
   drivers/ufs/core/ufshcd.c:10340:44: warning: shift count >= width of type [-Wshift-count-overflow]
    10340 |                 if (!dma_set_mask_and_coherent(hba->dev, DMA_BIT_MASK(64)))
          |                                                          ^~~~~~~~~~~~~~~~
   include/linux/dma-mapping.h:77:54: note: expanded from macro 'DMA_BIT_MASK'
      77 | #define DMA_BIT_MASK(n) (((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
         |                                                      ^ ~~~
   1 warning and 2 errors generated.
--
   In file included from drivers/ufs/core/ufs-debugfs.c:8:
>> drivers/ufs/core/ufshcd-priv.h:282:41: error: too few arguments to function call, expected 2, have 1
     282 |                 return hba->vops->override_cqe_ocs(hba);
         |                        ~~~~~~~~~~~~~~~~~~~~~~~~~~~    ^
   1 error generated.


vim +282 drivers/ufs/core/ufshcd-priv.h

   277	
   278	static inline enum utp_ocs ufshcd_vops_override_cqe_ocs(struct ufs_hba *hba,
   279								enum utp_ocs ocs)
   280	{
   281		if (hba->vops && hba->vops->override_cqe_ocs)
 > 282			return hba->vops->override_cqe_ocs(hba);
   283	
   284		return ocs;
   285	}
   286	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
