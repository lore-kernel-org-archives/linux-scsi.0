Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F318C6FA8E
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Feb 2023 21:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjBXVFR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Feb 2023 16:05:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBXVFQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Feb 2023 16:05:16 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3428688F5;
        Fri, 24 Feb 2023 13:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677272714; x=1708808714;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QvJkybVoarogho5PoChkW7G6wkAPhofhMcqMsdG5it4=;
  b=UmpSaOcnmnzaUqvyiYcEgNYn/RXi4+y1DrbahFqFMQA2SB7GaLaLzzy2
   PDDHvVYySe6QCuiPxiJjyGOXHnyv1JgyS2gU4MGckYpOKzIM8dTfpK2sc
   BS86XQ2r4XCADBs4FwRCAX92XsYqPKKyz6NpKi3OWJtINmxPsCt1BBvrB
   x2+QC3rzwXx0RqNxPsbcGDJrF6n6HGLrHg8O2/CJ6OmsYXJfEY9NPxM9a
   OgC97oHRwUS8NFJ3GiYqhRzsOm4tP7fdqnRmqXcHu/W4mNynYmQQ1ZRK+
   g927bnKs7mYxO0TbvcqhZJ3z+qXuZjbCYXCZ69tOT30rm9QiyyQiG970u
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="419813029"
X-IronPort-AV: E=Sophos;i="5.97,325,1669104000"; 
   d="scan'208";a="419813029"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 13:05:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="666285820"
X-IronPort-AV: E=Sophos;i="5.97,325,1669104000"; 
   d="scan'208";a="666285820"
Received: from lkp-server01.sh.intel.com (HELO 3895f5c55ead) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 24 Feb 2023 13:05:08 -0800
Received: from kbuild by 3895f5c55ead with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pVfFb-0002j9-1U;
        Fri, 24 Feb 2023 21:05:07 +0000
Date:   Sat, 25 Feb 2023 05:04:09 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev,
        Mike Christie <michael.christie@oracle.com>
Subject: Re: [PATCH v4 13/18] nvme: Add pr_ops read_reservation support
Message-ID: <202302250448.cEVYdC1I-lkp@intel.com>
References: <20230224174502.321490-14-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224174502.321490-14-michael.christie@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Mike,

I love your patch! Perhaps something to improve:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next axboe-block/for-next linus/master v6.2 next-20230224]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mike-Christie/block-Rename-BLK_STS_NEXUS-to-BLK_STS_RESV_CONFLICT/20230225-024505
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20230224174502.321490-14-michael.christie%40oracle.com
patch subject: [PATCH v4 13/18] nvme: Add pr_ops read_reservation support
config: sparc-allyesconfig (https://download.01.org/0day-ci/archive/20230225/202302250448.cEVYdC1I-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/f66174eef73e332bdca3a158541875a4c2e617d1
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Mike-Christie/block-Rename-BLK_STS_NEXUS-to-BLK_STS_RESV_CONFLICT/20230225-024505
        git checkout f66174eef73e332bdca3a158541875a4c2e617d1
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc SHELL=/bin/bash drivers/nvme/host/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302250448.cEVYdC1I-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/nvme/host/pr.c: In function 'block_pr_type_from_nvme':
>> drivers/nvme/host/pr.c:43:24: warning: implicit conversion from 'enum nvme_pr_type' to 'enum pr_type' [-Wenum-conversion]
      43 |                 return NVME_PR_EXCLUSIVE_ACCESS_ALL_REGS;
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +43 drivers/nvme/host/pr.c

    28	
    29	static enum pr_type block_pr_type_from_nvme(enum nvme_pr_type type)
    30	{
    31		switch (type) {
    32		case NVME_PR_WRITE_EXCLUSIVE:
    33			return PR_WRITE_EXCLUSIVE;
    34		case NVME_PR_EXCLUSIVE_ACCESS:
    35			return PR_EXCLUSIVE_ACCESS;
    36		case NVME_PR_WRITE_EXCLUSIVE_REG_ONLY:
    37			return PR_WRITE_EXCLUSIVE_REG_ONLY;
    38		case NVME_PR_EXCLUSIVE_ACCESS_REG_ONLY:
    39			return PR_EXCLUSIVE_ACCESS_REG_ONLY;
    40		case NVME_PR_WRITE_EXCLUSIVE_ALL_REGS:
    41			return PR_WRITE_EXCLUSIVE_ALL_REGS;
    42		case NVME_PR_EXCLUSIVE_ACCESS_ALL_REGS:
  > 43			return NVME_PR_EXCLUSIVE_ACCESS_ALL_REGS;
    44		}
    45	
    46		return 0;
    47	}
    48	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
