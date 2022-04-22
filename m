Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59119C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Apr 2022 17:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbiDVRdy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Apr 2022 13:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiDVRdv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Apr 2022 13:33:51 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CF7E3CCC
        for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2022 10:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650648652; x=1682184652;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/zACiCd/ijhvxGV+sw5ABcZAZs8o9JZypW7uhcbbDsI=;
  b=oChSRvrUV13I/5a0veHar6SAlFQpyqrF7mCY/JJx7ILNPZtdt9SbCUSq
   nlFJXgcxdx6x/GlKhhbJLjNKqgKxOaaAZEWpL2VDB82gFay6bnoUiO++Y
   pcc30NojbmSWoHu5bqnrsID5EQk7HNBX2RqZSswg54wQMm8r5N1QwtJb5
   ElnqmjX43iWyHz8kXU5yzyKJwCLXWVEoI4xUOZjxKMdX4uv+jnegvW1bl
   T6bvf/RhCvk1rMSK6wqGZBpLIEWOKaS4G/7uVpdRsisZqHgQJbW6eHfHh
   kkh0Z0jlxcYrBjqJPdbbdXmWCjqDKzhF9VpITtEzu527GFEA2fVT7kgaB
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="262330848"
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="262330848"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 10:25:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="594229944"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 22 Apr 2022 10:25:52 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nhx2W-000AOb-9E;
        Fri, 22 Apr 2022 17:25:52 +0000
Date:   Sat, 23 Apr 2022 01:25:10 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sumit Saxena <sumit.saxena@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     kbuild-all@lists.01.org, martin.petersen@oracle.com,
        bvanassche@acm.org, hch@lst.de, hare@suse.de,
        himanshu.madhani@oracle.com, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com, chandrakanth.patil@broadcom.com,
        sreekanth.reddy@broadcom.com, prayas.patel@broadcom.com,
        Sumit Saxena <sumit.saxena@broadcom.com>
Subject: Re: [PATCH v5 2/8] mpi3mr: add support for driver commands
Message-ID: <202204230148.eUwy76O1-lkp@intel.com>
References: <20220422115423.279805-3-sumit.saxena@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422115423.279805-3-sumit.saxena@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Sumit,

I love your patch! Yet something to improve:

[auto build test ERROR on mkp-scsi/for-next]
[also build test ERROR on jejb-scsi/for-next hch-configfs/for-next linus/master v5.18-rc3 next-20220422]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Sumit-Saxena/mpi3mr-add-BSG-interface-support-for-controller-management/20220422-201527
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20220423/202204230148.eUwy76O1-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/09bfe98846a8c4521955435e5cad41275f2581f2
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Sumit-Saxena/mpi3mr-add-BSG-interface-support-for-controller-management/20220422-201527
        git checkout 09bfe98846a8c4521955435e5cad41275f2581f2
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross W=1 O=build_dir ARCH=m68k prepare

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   scripts/genksyms/parse.y: warning: 9 shift/reduce conflicts [-Wconflicts-sr]
   scripts/genksyms/parse.y: warning: 5 reduce/reduce conflicts [-Wconflicts-rr]
   scripts/genksyms/parse.y: note: rerun with option '-Wcounterexamples' to generate conflict counterexamples
>> error: include/uapi/scsi/scsi_bsg_mpi3mr.h: missing "WITH Linux-syscall-note" for SPDX-License-Identifier
   make[2]: *** [scripts/Makefile.headersinst:63: usr/include/scsi/scsi_bsg_mpi3mr.h] Error 1
   make[2]: Target '__headers' not remade because of errors.
   make[1]: *** [Makefile:1280: headers] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:219: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
