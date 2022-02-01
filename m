Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB92AC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 13:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238862AbiBANrE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 08:47:04 -0500
Received: from mga14.intel.com ([192.55.52.115]:22012 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230213AbiBANrD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Feb 2022 08:47:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643723223; x=1675259223;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zhANCAVRPMJKtTyZJ596l8+I84NvbmfarsdAm14y2lU=;
  b=UYGenkS6sE45CvZW4dpddxiZlDGOHQ1XPVp6LK05NiASG3aEJy8IstpS
   l62F/cSDVGKmMqHn8w8qwCW3QhaJNr3eVh5/J2Tb6PmrCZanpTQdMcwgH
   m4CwgSCogmQSZGuumLVViPzaFao8mBnUpbelyApL0kVzDMNaXXXDp7WgB
   QnE3Tiiy0kUSdJdnKtDwBVastuMUvRnMXmBk5s7GmVU6GL7zyG2lSKkyD
   P1ckrLl1BfYA8c11nQkIDBybfebAekwtaqlVbzgzKbmsORx+iMTmS1x4F
   Eem9/9nvmICboJkaVd6sdlb5K7VVi8Di4Vx5I+Etn0izXr0ZbxdVI5W7V
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="247908769"
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="247908769"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 05:46:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="768931254"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 01 Feb 2022 05:46:44 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nEtUZ-000TKI-Ta; Tue, 01 Feb 2022 13:46:43 +0000
Date:   Tue, 1 Feb 2022 21:46:18 +0800
From:   kernel test robot <lkp@intel.com>
To:     Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc:     kbuild-all@lists.01.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Bodo Stroesser <bostroesser@gmail.com>
Subject: Re: [PATCH v7 1/4] sgl_alloc_order: remove 4 GiB limit
Message-ID: <202202012125.JGVcLupw-lkp@intel.com>
References: <20220201034915.183117-2-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201034915.183117-2-dgilbert@interlog.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Douglas,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.17-rc2 next-20220131]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Douglas-Gilbert/scatterlist-add-new-capabilities/20220201-115047
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 26291c54e111ff6ba87a164d85d4a4e134b7315c
config: i386-randconfig-a003-20220131 (https://download.01.org/0day-ci/archive/20220201/202202012125.JGVcLupw-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/be1e80a043970c400c00709be739ab26f931331a
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Douglas-Gilbert/scatterlist-add-new-capabilities/20220201-115047
        git checkout be1e80a043970c400c00709be739ab26f931331a
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   ld: lib/scatterlist.o: in function `sgl_alloc_order':
>> lib/scatterlist.c:612: undefined reference to `__udivdi3'


vim +612 lib/scatterlist.c

   586	
   587	/**
   588	 * sgl_alloc_order - allocate a scatterlist with equally sized elements each
   589	 *		     of which has 2^@order continuous pages
   590	 * @length: Length in bytes of the scatterlist. Must be at least one
   591	 * @order:  Second argument for alloc_pages(). Each sgl element size will
   592	 *	    be (PAGE_SIZE*2^@order) bytes. @order must not exceed 16.
   593	 * @chainable: Whether or not to allocate an extra element in the scatterlist
   594	 *	       for scatterlist chaining purposes
   595	 * @gfp: Memory allocation flags
   596	 * @nent_p: [out] Number of entries in the scatterlist that have pages.
   597	 *		  Ignored if @nent_p is NULL.
   598	 *
   599	 * Returns: A pointer to an initialized scatterlist or %NULL upon failure.
   600	 */
   601	struct scatterlist *sgl_alloc_order(unsigned long long length,
   602					    unsigned int order, bool chainable,
   603					    gfp_t gfp, unsigned int *nent_p)
   604	{
   605		struct scatterlist *sgl, *sg;
   606		struct page *page;
   607		unsigned int nent, nalloc;
   608		u32 elem_len;
   609	
   610		if (length >> (PAGE_SHIFT + order) >= UINT_MAX)
   611			return NULL;
 > 612		nent = DIV_ROUND_UP(length, PAGE_SIZE << order);
   613	
   614		if (chainable) {
   615			if (check_add_overflow(nent, 1U, &nalloc))
   616				return NULL;
   617		} else {
   618			nalloc = nent;
   619		}
   620		sgl = kmalloc_array(nalloc, sizeof(struct scatterlist),
   621				    gfp & ~GFP_DMA);
   622		if (!sgl)
   623			return NULL;
   624	
   625		sg_init_table(sgl, nalloc);
   626		sg = sgl;
   627		while (length) {
   628			elem_len = min_t(u64, length, PAGE_SIZE << order);
   629			page = alloc_pages(gfp, order);
   630			if (!page) {
   631				sgl_free_order(sgl, order);
   632				return NULL;
   633			}
   634	
   635			sg_set_page(sg, page, elem_len, 0);
   636			length -= elem_len;
   637			sg = sg_next(sg);
   638		}
   639		WARN_ONCE(length, "length = %lld\n", length);
   640		if (nent_p)
   641			*nent_p = nent;
   642		return sgl;
   643	}
   644	EXPORT_SYMBOL(sgl_alloc_order);
   645	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
