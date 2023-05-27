Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9107FC7EE2C
	for <linux-scsi@archiver.kernel.org>; Sat, 27 May 2023 19:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbjE0TvS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 May 2023 15:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjE0TvR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 May 2023 15:51:17 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002FABE;
        Sat, 27 May 2023 12:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685217076; x=1716753076;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=B5NMMKtpsLcHWp/IzYoY/4V62wxH/BnLO/v+P9sc2lk=;
  b=e+owQbZDIDdUY2xpQnnpJwkhXXv3LivGWLHRGAj8fdd8rJTzPhR3xN/6
   RvTpTj1aN9OWg6N1F/v6EYBI9SfnXQN9mzUfDJq9/l0FRs4qnTzCGR+sg
   JgkRdDoBfnbhfd//WYS/Q8g+pUU6b+8kxRow740563Csr+nNEyssfqfCS
   q+3tKLQvG/KNGb/BXzIx/h3ptXbJoa3nMbGc1gZ17vIpEFWMBw5VnKPUw
   qW8g7+8o4y59E0bO6k68Ya575jcgVXV2oub0K9qFKaQueo40vsIRD2R40
   YH9QXSBslz1m5GwAR2WdS8osPo3gEICadAqxfGX5p2XFI4ICBbsaP5hsD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10723"; a="356818100"
X-IronPort-AV: E=Sophos;i="6.00,197,1681196400"; 
   d="scan'208";a="356818100"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2023 12:51:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10723"; a="1035713233"
X-IronPort-AV: E=Sophos;i="6.00,197,1681196400"; 
   d="scan'208";a="1035713233"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 27 May 2023 12:51:13 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1q2zwW-000KA2-32;
        Sat, 27 May 2023 19:51:12 +0000
Date:   Sun, 28 May 2023 03:50:53 +0800
From:   kernel test robot <lkp@intel.com>
To:     Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>
Cc:     oe-kbuild-all@lists.linux.dev, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux@yadro.com,
        Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: Re: [PATCH 2/2] scsi: target: iblock: Report space allocation errors
Message-ID: <202305280314.CoHoeIlx-lkp@intel.com>
References: <20230517141537.80936-3-k.shelekhin@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517141537.80936-3-k.shelekhin@yadro.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Konstantin,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on linus/master v6.4-rc3]
[cannot apply to next-20230525]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Konstantin-Shelekhin/scsi-target-core-Add-sense-reason-for-space-allocation-errors/20230517-221755
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20230517141537.80936-3-k.shelekhin%40yadro.com
patch subject: [PATCH 2/2] scsi: target: iblock: Report space allocation errors
config: sparc-randconfig-s043-20230517 (https://download.01.org/0day-ci/archive/20230528/202305280314.CoHoeIlx-lkp@intel.com/config)
compiler: sparc-linux-gcc (GCC) 12.1.0
reproduce:
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/a1c912b7cd68155b131113eae148f7f79ef93676
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Konstantin-Shelekhin/scsi-target-core-Add-sense-reason-for-space-allocation-errors/20230517-221755
        git checkout a1c912b7cd68155b131113eae148f7f79ef93676
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 ~/bin/make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=sparc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 ~/bin/make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=sparc SHELL=/bin/bash drivers/target/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202305280314.CoHoeIlx-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/target/target_core_iblock.c:333:57: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected restricted blk_status_t [usertype] status @@     got int @@
   drivers/target/target_core_iblock.c:333:57: sparse:     expected restricted blk_status_t [usertype] status
   drivers/target/target_core_iblock.c:333:57: sparse:     got int
>> drivers/target/target_core_iblock.c:354:61: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int new @@     got restricted blk_status_t [usertype] bi_status @@
   drivers/target/target_core_iblock.c:354:61: sparse:     expected int new
   drivers/target/target_core_iblock.c:354:61: sparse:     got restricted blk_status_t [usertype] bi_status

vim +333 drivers/target/target_core_iblock.c

   324	
   325	static void iblock_complete_cmd(struct se_cmd *cmd)
   326	{
   327		struct iblock_req *ibr = cmd->priv;
   328		sense_reason_t reason;
   329	
   330		if (!refcount_dec_and_test(&ibr->pending))
   331			return;
   332	
 > 333		reason = iblock_blk_status_to_reason(atomic_read(&ibr->status));
   334	
   335		if (reason == TCM_NO_SENSE)
   336			target_complete_cmd(cmd, SAM_STAT_GOOD);
   337		else
   338			target_complete_cmd_with_sense(cmd, SAM_STAT_CHECK_CONDITION, reason);
   339	
   340		kfree(ibr);
   341	}
   342	
   343	static void iblock_bio_done(struct bio *bio)
   344	{
   345		struct se_cmd *cmd = bio->bi_private;
   346		struct iblock_req *ibr = cmd->priv;
   347	
   348		if (bio->bi_status) {
   349			pr_err("bio error: %p,  err: %d\n", bio, bio->bi_status);
   350			/*
   351			 * Set the error status of the iblock request to the error
   352			 * status of the first failed bio.
   353			 */
 > 354			atomic_cmpxchg(&ibr->status, BLK_STS_OK, bio->bi_status);
   355			smp_mb__after_atomic();
   356		}
   357	
   358		bio_put(bio);
   359	
   360		iblock_complete_cmd(cmd);
   361	}
   362	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
