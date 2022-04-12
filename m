Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E16A2C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 06:36:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349420AbiDLGic (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 02:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350556AbiDLGiL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 02:38:11 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F8517E28;
        Mon, 11 Apr 2022 23:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649745294; x=1681281294;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=U2bI2kc29WQz0AuFpjAlNbe0yVQ+3fHgDX6AhtpiVv4=;
  b=C/PXC6gBbYin5GpIk22uJi1Sra4qQLa1hbk5opvgcrmnVeE74QuCSfC9
   JABXPVg+IN8CTPNv+t3h9/K9TeLobI1DyiTHfXi1/YPfctmY1fwKbjY3K
   pdUWauF7HBByxeRWYnw+zZX+XbIIUzSG9iZGIg79THIxPyvTZci50gLQG
   lp3RCKlL9tBwHSk2CCZNnTk82qtD2vKM2pohZ4wJoWZk/Zs85Tsqs+CrT
   UQtLbr1NLprsfqDg56dsra49VfrykcVEaVQ/WnuEzNlXL/1lRNrdydD5O
   ajSWFNwl2ZoEcBmY14ArjDdn0xi4Qry2lqm2a0+FwcjCAszsP2Lv/d8Gu
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10314"; a="325200595"
X-IronPort-AV: E=Sophos;i="5.90,253,1643702400"; 
   d="scan'208";a="325200595"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2022 23:34:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,253,1643702400"; 
   d="scan'208";a="572608900"
Received: from lkp-server02.sh.intel.com (HELO d3fc50ef50de) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 11 Apr 2022 23:34:52 -0700
Received: from kbuild by d3fc50ef50de with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1neA71-0002aK-Gk;
        Tue, 12 Apr 2022 06:34:51 +0000
Date:   Tue, 12 Apr 2022 14:33:56 +0800
From:   kernel test robot <lkp@intel.com>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, linux-block@vger.kernel.org,
        bostroesser@gmail.com
Subject: Re: [PATCH v2] scsi: target: tcmu: Fix possible data corruption
Message-ID: <202204121450.qYzuKGXT-lkp@intel.com>
References: <20220411135958.21385-1-xiaoguang.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411135958.21385-1-xiaoguang.wang@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Xiaoguang,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on v5.18-rc2 next-20220411]
[cannot apply to mkp-scsi/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Xiaoguang-Wang/scsi-target-tcmu-Fix-possible-data-corruption/20220411-220214
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
config: x86_64-rhel-8.3-kselftests (https://download.01.org/0day-ci/archive/20220412/202204121450.qYzuKGXT-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-19) 11.2.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/intel-lab-lkp/linux/commit/2bceb529129db286e111bc3bae0b52b62b1fba07
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Xiaoguang-Wang/scsi-target-tcmu-Fix-possible-data-corruption/20220411-220214
        git checkout 2bceb529129db286e111bc3bae0b52b62b1fba07
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/target/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> drivers/target/target_core_user.c:1907:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int ret @@     got restricted vm_fault_t @@
   drivers/target/target_core_user.c:1907:21: sparse:     expected int ret
   drivers/target/target_core_user.c:1907:21: sparse:     got restricted vm_fault_t
>> drivers/target/target_core_user.c:1911:16: sparse: sparse: incorrect type in return expression (different base types) @@     expected restricted vm_fault_t @@     got int ret @@
   drivers/target/target_core_user.c:1911:16: sparse:     expected restricted vm_fault_t
   drivers/target/target_core_user.c:1911:16: sparse:     got int ret

vim +1907 drivers/target/target_core_user.c

  1874	
  1875	static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
  1876	{
  1877		struct tcmu_dev *udev = vmf->vma->vm_private_data;
  1878		struct uio_info *info = &udev->uio_info;
  1879		struct page *page;
  1880		unsigned long offset;
  1881		void *addr;
  1882		int ret = 0;
  1883	
  1884		int mi = tcmu_find_mem_index(vmf->vma);
  1885		if (mi < 0)
  1886			return VM_FAULT_SIGBUS;
  1887	
  1888		/*
  1889		 * We need to subtract mi because userspace uses offset = N*PAGE_SIZE
  1890		 * to use mem[N].
  1891		 */
  1892		offset = (vmf->pgoff - mi) << PAGE_SHIFT;
  1893	
  1894		if (offset < udev->data_off) {
  1895			/* For the vmalloc()ed cmd area pages */
  1896			addr = (void *)(unsigned long)info->mem[mi].addr + offset;
  1897			page = vmalloc_to_page(addr);
  1898			get_page(page);
  1899		} else {
  1900			uint32_t dpi;
  1901	
  1902			/* For the dynamically growing data area pages */
  1903			dpi = (offset - udev->data_off) / PAGE_SIZE;
  1904			page = tcmu_try_get_data_page(udev, dpi);
  1905			if (!page)
  1906				return VM_FAULT_SIGBUS;
> 1907			ret = VM_FAULT_LOCKED;
  1908		}
  1909	
  1910		vmf->page = page;
> 1911		return ret;
  1912	}
  1913	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
