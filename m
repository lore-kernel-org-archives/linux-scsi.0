Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8C32C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 13:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238492AbiGSNZk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 09:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238446AbiGSNZ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 09:25:26 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521117C195;
        Tue, 19 Jul 2022 05:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658234476; x=1689770476;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=l2Zm2SaVyHBPX0GQKlXlsXm0B1fiKqlmOjDuj5VSgl0=;
  b=l2zvNC7JFaUASm+Yt+wmfnRTayZSeH6PgFMBlFUbKAvksS49/SZ4bou4
   imQrLLq20VPxjw4r2kAEEHWEuq10km3LJl3JgXNTijZadIgmJMlgkOrnn
   0UgQEBn9QCLxb9ApnNeANInQmTGIcmlh+V8JGm30WUr7OaZ7ZGCqyDiDa
   oN4mmZHPULoGTrFbUk58kQzJTU5JOuDi3ORupYzgsSnmyfwQbNe+pT6at
   jCOCB5GcjC59YdAsCdjSNB3+aeDlCoSMN+jjcmy+fpfUOfDe4AiPOhRlN
   VgE2UJYjjbuwwP17TBZSJzz5Qrcl1IupPE5FFNRNvDylfrrdtcZN3Cchl
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="286493884"
X-IronPort-AV: E=Sophos;i="5.92,284,1650956400"; 
   d="scan'208";a="286493884"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 05:41:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,284,1650956400"; 
   d="scan'208";a="724245168"
Received: from lkp-server02.sh.intel.com (HELO ff137eb26ff1) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 19 Jul 2022 05:41:13 -0700
Received: from kbuild by ff137eb26ff1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oDmXI-0005ea-J7;
        Tue, 19 Jul 2022 12:41:12 +0000
Date:   Tue, 19 Jul 2022 20:40:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, linux-scsi@vger.kernel.org,
        linux@yadro.com, Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH 3/6] scsi: target: core: dynamic opcode support in RSOC
Message-ID: <202207192030.yfVYkp2d-lkp@intel.com>
References: <20220718120117.4435-4-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718120117.4435-4-d.bogdanov@yadro.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Dmitry,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next linus/master v5.19-rc7 next-20220719]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Dmitry-Bogdanov/add-support-of-RSOC-command/20220718-200622
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
config: nios2-randconfig-s042-20220718 (https://download.01.org/0day-ci/archive/20220719/202207192030.yfVYkp2d-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/5aa6c10f37c99c3321ff7675ffbb6fea99219263
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Dmitry-Bogdanov/add-support-of-RSOC-command/20220718-200622
        git checkout 5aa6c10f37c99c3321ff7675ffbb6fea99219263
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=nios2 SHELL=/bin/bash drivers/target/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> drivers/target/target_core_spc.c:1927:20: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct t10_alua_tg_pt_gp *l_tg_pt_gp @@     got struct t10_alua_tg_pt_gp [noderef] __rcu *lun_tg_pt_gp @@
   drivers/target/target_core_spc.c:1927:20: sparse:     expected struct t10_alua_tg_pt_gp *l_tg_pt_gp
   drivers/target/target_core_spc.c:1927:20: sparse:     got struct t10_alua_tg_pt_gp [noderef] __rcu *lun_tg_pt_gp
   drivers/target/target_core_spc.c:2159:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int ret @@     got restricted sense_reason_t @@
   drivers/target/target_core_spc.c:2159:21: sparse:     expected int ret
   drivers/target/target_core_spc.c:2159:21: sparse:     got restricted sense_reason_t
   drivers/target/target_core_spc.c:2166:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int ret @@     got restricted sense_reason_t @@
   drivers/target/target_core_spc.c:2166:21: sparse:     expected int ret
   drivers/target/target_core_spc.c:2166:21: sparse:     got restricted sense_reason_t
   drivers/target/target_core_spc.c:2178:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int ret @@     got restricted sense_reason_t @@
   drivers/target/target_core_spc.c:2178:21: sparse:     expected int ret
   drivers/target/target_core_spc.c:2178:21: sparse:     got restricted sense_reason_t
   drivers/target/target_core_spc.c:2207:16: sparse: sparse: incorrect type in return expression (different base types) @@     expected restricted sense_reason_t @@     got int ret @@
   drivers/target/target_core_spc.c:2207:16: sparse:     expected restricted sense_reason_t
   drivers/target/target_core_spc.c:2207:16: sparse:     got int ret

vim +1927 drivers/target/target_core_spc.c

  1920	
  1921	static bool tcm_is_set_tpg_enabled(struct se_cmd *cmd)
  1922	{
  1923		struct t10_alua_tg_pt_gp *l_tg_pt_gp;
  1924		struct se_lun *l_lun = cmd->se_lun;
  1925	
  1926		spin_lock(&l_lun->lun_tg_pt_gp_lock);
> 1927		l_tg_pt_gp = l_lun->lun_tg_pt_gp;
  1928		if (!l_tg_pt_gp) {
  1929			spin_unlock(&l_lun->lun_tg_pt_gp_lock);
  1930			return false;
  1931		}
  1932		if (!(l_tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICIT_ALUA)) {
  1933			spin_unlock(&l_lun->lun_tg_pt_gp_lock);
  1934			return false;
  1935		}
  1936		spin_unlock(&l_lun->lun_tg_pt_gp_lock);
  1937	
  1938		return true;
  1939	}
  1940	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
