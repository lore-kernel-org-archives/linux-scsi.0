Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D287FC61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Feb 2023 04:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjBBEdR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Feb 2023 23:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbjBBEdP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2023 23:33:15 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458992884E
        for <linux-scsi@vger.kernel.org>; Wed,  1 Feb 2023 20:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675312394; x=1706848394;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Bi9zCorLY17vdzPYr0SEZUj7gYa2k2U+qt/PS0q4CNc=;
  b=f9xIhRpZw5Omn8UOr8UiRaE27xHyZTJw2cDgEdOFjlHiZZca5pWAfiql
   8zthw+MU6Mx4VFrcUgNTV9CA0DHpBullMrBaf+iBs6sqNteUoN5opvWnl
   d40Sk/caz6pk1eJwsj0qb2SWlwwgXSnmShLcuX/pUZPy9NNcx0KLDkKPh
   kgt6vzIFm2z98x3e9Vwz7YZtYnwITI7cBScbwXL0iAubKzEk/1nv6hBIG
   0IwYjPR2uorvPVhLWioX89tJgOm7fy6ZY43gi9aHNm+b7Ns7mbz3DTgrl
   WBikzyz47RTA5PDh79Z1kOEUezsMIui2bcFf9VAq+O+BaIlXv+r9uOvlb
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="316348280"
X-IronPort-AV: E=Sophos;i="5.97,266,1669104000"; 
   d="scan'208";a="316348280"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 20:33:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="910580217"
X-IronPort-AV: E=Sophos;i="5.97,266,1669104000"; 
   d="scan'208";a="910580217"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 01 Feb 2023 20:33:10 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pNRHZ-00069E-17;
        Thu, 02 Feb 2023 04:33:09 +0000
Date:   Thu, 2 Feb 2023 12:32:49 +0800
From:   kernel test robot <lkp@intel.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     oe-kbuild-all@lists.linux.dev, Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: Re: [PATCH 2/2] scsi: ufs: Use SYNCHRONIZE CACHE instead of FUA
Message-ID: <202302021202.mM5iFxSO-lkp@intel.com>
References: <20230201180637.2102556-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201180637.2102556-3-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

I love your patch! Yet something to improve:

[auto build test ERROR on mkp-scsi/for-next]
[also build test ERROR on jejb-scsi/for-next linus/master v6.2-rc6 next-20230202]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Bart-Van-Assche/scsi-core-Introduce-the-BLIST_BROKEN_FUA-flag/20230202-021019
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20230201180637.2102556-3-bvanassche%40acm.org
patch subject: [PATCH 2/2] scsi: ufs: Use SYNCHRONIZE CACHE instead of FUA
config: arm-randconfig-r046-20230130 (https://download.01.org/0day-ci/archive/20230202/202302021202.mM5iFxSO-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/4edde0173805f04faa8e79aab4de3e929ea4b7c0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Bart-Van-Assche/scsi-core-Introduce-the-BLIST_BROKEN_FUA-flag/20230202-021019
        git checkout 4edde0173805f04faa8e79aab4de3e929ea4b7c0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash drivers/ufs/core/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/ufs/core/ufshcd.c: In function 'ufshcd_slave_alloc':
>> drivers/ufs/core/ufshcd.c:5060:29: error: 'BLIST_BROKEN_FUA' undeclared (first use in this function)
    5060 |         sdev->sdev_bflags = BLIST_BROKEN_FUA;
         |                             ^~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:5060:29: note: each undeclared identifier is reported only once for each function it appears in


vim +/BLIST_BROKEN_FUA +5060 drivers/ufs/core/ufshcd.c

  5031	
  5032	/**
  5033	 * ufshcd_slave_alloc - handle initial SCSI device configurations
  5034	 * @sdev: pointer to SCSI device
  5035	 *
  5036	 * Returns success
  5037	 */
  5038	static int ufshcd_slave_alloc(struct scsi_device *sdev)
  5039	{
  5040		struct ufs_hba *hba;
  5041	
  5042		hba = shost_priv(sdev->host);
  5043	
  5044		/* Mode sense(6) is not supported by UFS, so use Mode sense(10) */
  5045		sdev->use_10_for_ms = 1;
  5046	
  5047		/* DBD field should be set to 1 in mode sense(10) */
  5048		sdev->set_dbd_for_ms = 1;
  5049	
  5050		/* allow SCSI layer to restart the device in case of errors */
  5051		sdev->allow_restart = 1;
  5052	
  5053		/* REPORT SUPPORTED OPERATION CODES is not supported */
  5054		sdev->no_report_opcodes = 1;
  5055	
  5056		/* WRITE_SAME command is not supported */
  5057		sdev->no_write_same = 1;
  5058	
  5059		/* Use SYNCHRONIZE CACHE instead of FUA to improve performance */
> 5060		sdev->sdev_bflags = BLIST_BROKEN_FUA;
  5061	
  5062		ufshcd_lu_init(hba, sdev);
  5063	
  5064		ufshcd_setup_links(hba, sdev);
  5065	
  5066		return 0;
  5067	}
  5068	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
