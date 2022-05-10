Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8A03C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 10 May 2022 12:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241429AbiEJMZf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 May 2022 08:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241255AbiEJMZe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 May 2022 08:25:34 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257908E1BC;
        Tue, 10 May 2022 05:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652185296; x=1683721296;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ba7w5672jcor8kZ7HMJwL7dsb7ihHkGiN0qrietfc4o=;
  b=HOQiJ4B4YLpiZGQXEwkBuIKEb2ddUxf2AAasRcKhcGqOl12bCwfPAb/Y
   GmgdahX+4vHir5+G4HlwK9W6IkaL+n3C7H9CE7hugPPsyQ3NR9I0WDSfN
   kG9VvolppNv8Lq6L/vAbiG1dJHtlAuGGQ9V3fMZYMmwOYLfeximR6YDtv
   Uw3c+OEo4Tw4xiO9cFqKgS80uTRiV/ZMi3ZwF/jwFnId3+6b8ohVtYabI
   mq5FUUkThERmL0QDqbSq124Qu/x1ID+XC0Wh4HlU9eQZnuRDYGj3CD37h
   1++6xWL8BK6+IsEIoaNYL8XOcrqF7c8mglsxmG05QXmbegTVo/yn8b9Np
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="269291945"
X-IronPort-AV: E=Sophos;i="5.91,214,1647327600"; 
   d="scan'208";a="269291945"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 05:21:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,214,1647327600"; 
   d="scan'208";a="697059637"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 10 May 2022 05:21:33 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1noOrt-000Hs2-0t;
        Tue, 10 May 2022 12:21:33 +0000
Date:   Tue, 10 May 2022 20:21:26 +0800
From:   kernel test robot <lkp@intel.com>
To:     Guixin Liu <kanie@linux.alibaba.com>, bostroesser@gmail.com,
        martin.petersen@oracle.com
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH] scsi:tcmu: switch tcmu completion path to work queue
 context
Message-ID: <202205102014.hfkv5W49-lkp@intel.com>
References: <1652165414-15933-1-git-send-email-kanie@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1652165414-15933-1-git-send-email-kanie@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Guixin,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on v5.18-rc6 next-20220509]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Guixin-Liu/scsi-tcmu-switch-tcmu-completion-path-to-work-queue-context/20220510-145227
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
config: x86_64-randconfig-a003-20220509 (https://download.01.org/0day-ci/archive/20220510/202205102014.hfkv5W49-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 18dd123c56754edf62c7042dcf23185c3727610f)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/08884eca055feed72186261c64dea07df464946e
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Guixin-Liu/scsi-tcmu-switch-tcmu-completion-path-to-work-queue-context/20220510-145227
        git checkout 08884eca055feed72186261c64dea07df464946e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/target/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/target/target_core_user.c:3336:6: warning: variable 'ret' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (!tcmu_cmd_cache)
               ^~~~~~~~~~~~~~~
   drivers/target/target_core_user.c:3389:9: note: uninitialized use occurs here
           return ret;
                  ^~~
   drivers/target/target_core_user.c:3336:2: note: remove the 'if' if its condition is always false
           if (!tcmu_cmd_cache)
           ^~~~~~~~~~~~~~~~~~~~
   drivers/target/target_core_user.c:3321:9: note: initialize the variable 'ret' to silence this warning
           int ret, i, k, len = 0;
                  ^
                   = 0
   1 warning generated.


vim +3336 drivers/target/target_core_user.c

89ec9cfd3b644f Mike Christie      2017-11-28  3318  
7c9e7a6fe11c8d Andy Grover        2014-10-01  3319  static int __init tcmu_module_init(void)
7c9e7a6fe11c8d Andy Grover        2014-10-01  3320  {
801fc54d5d943e Bryant G. Ly       2017-06-06  3321  	int ret, i, k, len = 0;
7c9e7a6fe11c8d Andy Grover        2014-10-01  3322  
7c9e7a6fe11c8d Andy Grover        2014-10-01  3323  	BUILD_BUG_ON((sizeof(struct tcmu_cmd_entry) % TCMU_OP_ALIGN_SIZE) != 0);
7c9e7a6fe11c8d Andy Grover        2014-10-01  3324  
af1dd7ff46824a Mike Christie      2017-11-28  3325  	INIT_DELAYED_WORK(&tcmu_unmap_work, tcmu_unmap_work_fn);
9972cebb59a653 Mike Christie      2017-11-28  3326  
08884eca055fee Guixin Liu         2022-05-10  3327  	tcmu_comp_wq = alloc_workqueue("tcmu-comp-wq",
08884eca055fee Guixin Liu         2022-05-10  3328  			WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_SYSFS, 0);
08884eca055fee Guixin Liu         2022-05-10  3329  	if (!tcmu_comp_wq)
08884eca055fee Guixin Liu         2022-05-10  3330  		return -ENOMEM;
08884eca055fee Guixin Liu         2022-05-10  3331  
7c9e7a6fe11c8d Andy Grover        2014-10-01  3332  	tcmu_cmd_cache = kmem_cache_create("tcmu_cmd_cache",
7c9e7a6fe11c8d Andy Grover        2014-10-01  3333  				sizeof(struct tcmu_cmd),
7c9e7a6fe11c8d Andy Grover        2014-10-01  3334  				__alignof__(struct tcmu_cmd),
7c9e7a6fe11c8d Andy Grover        2014-10-01  3335  				0, NULL);
7c9e7a6fe11c8d Andy Grover        2014-10-01 @3336  	if (!tcmu_cmd_cache)
08884eca055fee Guixin Liu         2022-05-10  3337  		goto out_free_comp_wq;
7c9e7a6fe11c8d Andy Grover        2014-10-01  3338  
7c9e7a6fe11c8d Andy Grover        2014-10-01  3339  	tcmu_root_device = root_device_register("tcm_user");
7c9e7a6fe11c8d Andy Grover        2014-10-01  3340  	if (IS_ERR(tcmu_root_device)) {
7c9e7a6fe11c8d Andy Grover        2014-10-01  3341  		ret = PTR_ERR(tcmu_root_device);
7c9e7a6fe11c8d Andy Grover        2014-10-01  3342  		goto out_free_cache;
7c9e7a6fe11c8d Andy Grover        2014-10-01  3343  	}
7c9e7a6fe11c8d Andy Grover        2014-10-01  3344  
7c9e7a6fe11c8d Andy Grover        2014-10-01  3345  	ret = genl_register_family(&tcmu_genl_family);
7c9e7a6fe11c8d Andy Grover        2014-10-01  3346  	if (ret < 0) {
7c9e7a6fe11c8d Andy Grover        2014-10-01  3347  		goto out_unreg_device;
7c9e7a6fe11c8d Andy Grover        2014-10-01  3348  	}
7c9e7a6fe11c8d Andy Grover        2014-10-01  3349  
4703b6252b338e Bodo Stroesser     2020-04-27  3350  	for (i = 0; passthrough_attrib_attrs[i] != NULL; i++)
7d7a743543905a Nicholas Bellinger 2017-03-18  3351  		len += sizeof(struct configfs_attribute *);
4703b6252b338e Bodo Stroesser     2020-04-27  3352  	for (i = 0; passthrough_pr_attrib_attrs[i] != NULL; i++)
4703b6252b338e Bodo Stroesser     2020-04-27  3353  		len += sizeof(struct configfs_attribute *);
4703b6252b338e Bodo Stroesser     2020-04-27  3354  	for (i = 0; tcmu_attrib_attrs[i] != NULL; i++)
801fc54d5d943e Bryant G. Ly       2017-06-06  3355  		len += sizeof(struct configfs_attribute *);
801fc54d5d943e Bryant G. Ly       2017-06-06  3356  	len += sizeof(struct configfs_attribute *);
7d7a743543905a Nicholas Bellinger 2017-03-18  3357  
7d7a743543905a Nicholas Bellinger 2017-03-18  3358  	tcmu_attrs = kzalloc(len, GFP_KERNEL);
7d7a743543905a Nicholas Bellinger 2017-03-18  3359  	if (!tcmu_attrs) {
7d7a743543905a Nicholas Bellinger 2017-03-18  3360  		ret = -ENOMEM;
7d7a743543905a Nicholas Bellinger 2017-03-18  3361  		goto out_unreg_genl;
7d7a743543905a Nicholas Bellinger 2017-03-18  3362  	}
7d7a743543905a Nicholas Bellinger 2017-03-18  3363  
4703b6252b338e Bodo Stroesser     2020-04-27  3364  	for (i = 0; passthrough_attrib_attrs[i] != NULL; i++)
7d7a743543905a Nicholas Bellinger 2017-03-18  3365  		tcmu_attrs[i] = passthrough_attrib_attrs[i];
4703b6252b338e Bodo Stroesser     2020-04-27  3366  	for (k = 0; passthrough_pr_attrib_attrs[k] != NULL; k++)
4703b6252b338e Bodo Stroesser     2020-04-27  3367  		tcmu_attrs[i++] = passthrough_pr_attrib_attrs[k];
4703b6252b338e Bodo Stroesser     2020-04-27  3368  	for (k = 0; tcmu_attrib_attrs[k] != NULL; k++)
4703b6252b338e Bodo Stroesser     2020-04-27  3369  		tcmu_attrs[i++] = tcmu_attrib_attrs[k];
7d7a743543905a Nicholas Bellinger 2017-03-18  3370  	tcmu_ops.tb_dev_attrib_attrs = tcmu_attrs;
7d7a743543905a Nicholas Bellinger 2017-03-18  3371  
0a06d4309dc168 Christoph Hellwig  2015-05-10  3372  	ret = transport_backend_register(&tcmu_ops);
7c9e7a6fe11c8d Andy Grover        2014-10-01  3373  	if (ret)
7d7a743543905a Nicholas Bellinger 2017-03-18  3374  		goto out_attrs;
7c9e7a6fe11c8d Andy Grover        2014-10-01  3375  
7c9e7a6fe11c8d Andy Grover        2014-10-01  3376  	return 0;
7c9e7a6fe11c8d Andy Grover        2014-10-01  3377  
7d7a743543905a Nicholas Bellinger 2017-03-18  3378  out_attrs:
7d7a743543905a Nicholas Bellinger 2017-03-18  3379  	kfree(tcmu_attrs);
7c9e7a6fe11c8d Andy Grover        2014-10-01  3380  out_unreg_genl:
7c9e7a6fe11c8d Andy Grover        2014-10-01  3381  	genl_unregister_family(&tcmu_genl_family);
7c9e7a6fe11c8d Andy Grover        2014-10-01  3382  out_unreg_device:
7c9e7a6fe11c8d Andy Grover        2014-10-01  3383  	root_device_unregister(tcmu_root_device);
7c9e7a6fe11c8d Andy Grover        2014-10-01  3384  out_free_cache:
7c9e7a6fe11c8d Andy Grover        2014-10-01  3385  	kmem_cache_destroy(tcmu_cmd_cache);
08884eca055fee Guixin Liu         2022-05-10  3386  out_free_comp_wq:
08884eca055fee Guixin Liu         2022-05-10  3387  	destroy_workqueue(tcmu_comp_wq);
7c9e7a6fe11c8d Andy Grover        2014-10-01  3388  
7c9e7a6fe11c8d Andy Grover        2014-10-01  3389  	return ret;
7c9e7a6fe11c8d Andy Grover        2014-10-01  3390  }
7c9e7a6fe11c8d Andy Grover        2014-10-01  3391  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
