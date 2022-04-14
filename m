Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E66C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Apr 2022 03:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239674AbiDNDK6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Apr 2022 23:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiDNDK5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2022 23:10:57 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1652B329A7;
        Wed, 13 Apr 2022 20:08:32 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VA0LT0e_1649905709;
Received: from 30.225.28.188(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VA0LT0e_1649905709)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 14 Apr 2022 11:08:30 +0800
Message-ID: <54f14cda-8eed-e486-b41d-5eefc56da526@linux.alibaba.com>
Date:   Thu, 14 Apr 2022 11:08:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v2] scsi: target: tcmu: Fix possible data corruption
Content-Language: en-US
To:     kernel test robot <lkp@intel.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, linux-block@vger.kernel.org,
        bostroesser@gmail.com
References: <20220411135958.21385-1-xiaoguang.wang@linux.alibaba.com>
 <202204121450.qYzuKGXT-lkp@intel.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <202204121450.qYzuKGXT-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

hi,

Thanks for this report, I'll add the Reported-by in V3 patch.
But before sending V3, I'd like to wait tcmu maintainer to have a brief review.

Regards,
Xiaoguang Wang

> Hi Xiaoguang,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on jejb-scsi/for-next]
> [also build test WARNING on v5.18-rc2 next-20220411]
> [cannot apply to mkp-scsi/for-next]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Xiaoguang-Wang/scsi-target-tcmu-Fix-possible-data-corruption/20220411-220214
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
> config: x86_64-rhel-8.3-kselftests (https://download.01.org/0day-ci/archive/20220412/202204121450.qYzuKGXT-lkp@intel.com/config)
> compiler: gcc-11 (Debian 11.2.0-19) 11.2.0
> reproduce:
>         # apt-get install sparse
>         # sparse version: v0.6.4-dirty
>         # https://github.com/intel-lab-lkp/linux/commit/2bceb529129db286e111bc3bae0b52b62b1fba07
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Xiaoguang-Wang/scsi-target-tcmu-Fix-possible-data-corruption/20220411-220214
>         git checkout 2bceb529129db286e111bc3bae0b52b62b1fba07
>         # save the config file to linux build tree
>         mkdir build_dir
>         make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/target/
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
>
> sparse warnings: (new ones prefixed by >>)
>>> drivers/target/target_core_user.c:1907:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int ret @@     got restricted vm_fault_t @@
>    drivers/target/target_core_user.c:1907:21: sparse:     expected int ret
>    drivers/target/target_core_user.c:1907:21: sparse:     got restricted vm_fault_t
>>> drivers/target/target_core_user.c:1911:16: sparse: sparse: incorrect type in return expression (different base types) @@     expected restricted vm_fault_t @@     got int ret @@
>    drivers/target/target_core_user.c:1911:16: sparse:     expected restricted vm_fault_t
>    drivers/target/target_core_user.c:1911:16: sparse:     got int ret
>
> vim +1907 drivers/target/target_core_user.c
>
>   1874	
>   1875	static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
>   1876	{
>   1877		struct tcmu_dev *udev = vmf->vma->vm_private_data;
>   1878		struct uio_info *info = &udev->uio_info;
>   1879		struct page *page;
>   1880		unsigned long offset;
>   1881		void *addr;
>   1882		int ret = 0;
>   1883	
>   1884		int mi = tcmu_find_mem_index(vmf->vma);
>   1885		if (mi < 0)
>   1886			return VM_FAULT_SIGBUS;
>   1887	
>   1888		/*
>   1889		 * We need to subtract mi because userspace uses offset = N*PAGE_SIZE
>   1890		 * to use mem[N].
>   1891		 */
>   1892		offset = (vmf->pgoff - mi) << PAGE_SHIFT;
>   1893	
>   1894		if (offset < udev->data_off) {
>   1895			/* For the vmalloc()ed cmd area pages */
>   1896			addr = (void *)(unsigned long)info->mem[mi].addr + offset;
>   1897			page = vmalloc_to_page(addr);
>   1898			get_page(page);
>   1899		} else {
>   1900			uint32_t dpi;
>   1901	
>   1902			/* For the dynamically growing data area pages */
>   1903			dpi = (offset - udev->data_off) / PAGE_SIZE;
>   1904			page = tcmu_try_get_data_page(udev, dpi);
>   1905			if (!page)
>   1906				return VM_FAULT_SIGBUS;
>> 1907			ret = VM_FAULT_LOCKED;
>   1908		}
>   1909	
>   1910		vmf->page = page;
>> 1911		return ret;
>   1912	}
>   1913	
>

