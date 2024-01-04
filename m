Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F2F23749
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jan 2024 14:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eHmWKXWV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704380107; x=1735916107;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rLDxRZvmq5NvAKwa9UXfuPlqZ2XU8Rt24K3wgF1IxLc=;
  b=eHmWKXWVNIsCp1enyTpPda+GrrVD6KfPeshJsoiBpJNxTm7W4bu/nkhy
   +W4HUMKY/k/LdqD8sUxFXkY+yN1QD6L1noUDeNn9lsAUQ5J9Px18wA7PS
   I/26FwxjvolTl+NXpvSWvvQxEqQQIKMYMw/WxT281+CQgzdRQt1bHjAHz
   JNxkZG2H3TcYV+/H+nelgFq1ULUDX7GLmIUPkDIX9f7NnNg/LSLbev8k7
   LUE0WhAngrmxbEklogXdnB+r4gF7cyhPJOBZG/NdAl/ukdX3x1pjj7MZB
   /VpaPbqtFahdrvAdfBn6YrXV2geHWdH+MBAJMyTsg1hOwAG2xpVQET44E
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="4623687"
X-IronPort-AV: E=Sophos;i="6.04,331,1695711600"; 
   d="scan'208";a="4623687"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2024 06:55:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,331,1695711600"; 
   d="scan'208";a="28813354"
Received: from lkp-server02.sh.intel.com (HELO b07ab15da5fe) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 04 Jan 2024 06:55:00 -0800
Received: from kbuild by b07ab15da5fe with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rLP7Y-000NPy-0K;
	Thu, 04 Jan 2024 14:54:57 +0000
Date: Thu, 4 Jan 2024 22:54:29 +0800
From: kernel test robot <lkp@intel.com>
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com,
	lduncan@suse.com, cleech@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
	GR-QLogic-Storage-Upstream@marvell.com, jmeneghi@redhat.com
Subject: Re: [PATCH v2 1/3] uio: introduce UIO_MEM_DMA_COHERENT type
Message-ID: <202401042222.J9GOUiYL-lkp@intel.com>
References: <20240103091137.27142-2-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103091137.27142-2-njavali@marvell.com>

Hi Nilesh,

kernel test robot noticed the following build warnings:

[auto build test WARNING on char-misc/char-misc-testing]
[also build test WARNING on char-misc/char-misc-next char-misc/char-misc-linus linus/master v6.7-rc8 next-20240104]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Nilesh-Javali/uio-introduce-UIO_MEM_DMA_COHERENT-type/20240103-171531
base:   char-misc/char-misc-testing
patch link:    https://lore.kernel.org/r/20240103091137.27142-2-njavali%40marvell.com
patch subject: [PATCH v2 1/3] uio: introduce UIO_MEM_DMA_COHERENT type
config: arc-allmodconfig (https://download.01.org/0day-ci/archive/20240104/202401042222.J9GOUiYL-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240104/202401042222.J9GOUiYL-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202401042222.J9GOUiYL-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/uio/uio.c:27:
   drivers/uio/uio.c: In function 'uio_mmap_dma_coherent':
>> drivers/uio/uio.c:789:33: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
     789 |                                 (void *)mem->addr,
         |                                 ^
   include/linux/dma-mapping.h:424:63: note: in definition of macro 'dma_mmap_coherent'
     424 | #define dma_mmap_coherent(d, v, c, h, s) dma_mmap_attrs(d, v, c, h, s, 0)
         |                                                               ^


vim +789 drivers/uio/uio.c

   762	
   763	static int uio_mmap_dma_coherent(struct vm_area_struct *vma)
   764	{
   765		struct uio_device *idev = vma->vm_private_data;
   766		struct uio_mem *mem;
   767		int ret = 0;
   768		int mi;
   769	
   770		mi = uio_find_mem_index(vma);
   771		if (mi < 0)
   772			return -EINVAL;
   773	
   774		mem = idev->info->mem + mi;
   775	
   776		if (mem->dma_addr & ~PAGE_MASK)
   777			return -ENODEV;
   778		if (vma->vm_end - vma->vm_start > mem->size)
   779			return -EINVAL;
   780	
   781		/*
   782		 * UIO uses offset to index into the maps for a device.
   783		 * We need to clear vm_pgoff for dma_mmap_coherent.
   784		 */
   785		vma->vm_pgoff = 0;
   786	
   787		ret = dma_mmap_coherent(&idev->dev,
   788					vma,
 > 789					(void *)mem->addr,
   790					mem->dma_addr,
   791					vma->vm_end - vma->vm_start);
   792		vma->vm_pgoff = mi;
   793	
   794		return ret;
   795	}
   796	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
