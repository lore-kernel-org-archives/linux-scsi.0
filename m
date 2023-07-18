Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1729BEB64DC
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Jul 2023 17:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbjGRRGa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Jul 2023 13:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbjGRRG3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Jul 2023 13:06:29 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30974172D
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jul 2023 10:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689699965; x=1721235965;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yJFRJQs8KqumTLd5B1/7ME5Or8VvVbSGSVep5S2u8wA=;
  b=X6PuwLhWXtvbuRw0kOVHE1F/I1xHM27n6MSwwTHLbiC4TDorGqZkhFZo
   vGPMH0xNlN736aKfUQNtayK+obnwY6mSMheU0VvpruL5hfzXzVJKUd4GQ
   x33dbXvLshlyvrF1vOaNaLu3VQ5JlY441VlnlZ0veMKE7ol5+yORpFUCx
   0NuKOCIBjjfYQaMjdbNbkeVbxoJyzQfufvHg724osfl53TVy634D4tlwQ
   PEg4GbvgJFS3M6GTLqVPgRucrFg2PVHT0s4xbpUgheQ+iJLIraZOrFvwI
   AflwTMS+1QbC8VoWuGloRZxAsuhOD0v763aiQlvwJablJldxqT8LlJkVG
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="397104917"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="397104917"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 10:04:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="673998331"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="673998331"
Received: from lkp-server02.sh.intel.com (HELO 36946fcf73d7) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 18 Jul 2023 10:04:44 -0700
Received: from kbuild by 36946fcf73d7 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qLo7A-0001jj-32;
        Tue, 18 Jul 2023 17:04:08 +0000
Date:   Wed, 19 Jul 2023 01:02:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     oe-kbuild-all@lists.linux.dev, Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        ChanWoo Lee <cw9316.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Lu Hongfei <luhongfei@vivo.com>,
        Daniil Lunev <dlunev@chromium.org>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Can Guo <quic_cang@quicinc.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <arthur.simchaev@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Markus Fuchs <mklntf@gmail.com>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] scsi: ufs: Remove HPB support
Message-ID: <202307190020.oxUXDCH1-lkp@intel.com>
References: <20230717193827.2001174-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230717193827.2001174-1-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on next-20230718]
[cannot apply to jejb-scsi/for-next linus/master v6.5-rc2]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Bart-Van-Assche/scsi-ufs-Remove-HPB-support/20230718-195403
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20230717193827.2001174-1-bvanassche%40acm.org
patch subject: [PATCH] scsi: ufs: Remove HPB support
config: loongarch-allyesconfig (https://download.01.org/0day-ci/archive/20230719/202307190020.oxUXDCH1-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 12.3.0
reproduce: (https://download.01.org/0day-ci/archive/20230719/202307190020.oxUXDCH1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202307190020.oxUXDCH1-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/ufs/core/ufshcd.c: In function 'ufs_get_device_desc':
>> drivers/ufs/core/ufshcd.c:8092:12: warning: variable 'b_ufs_feature_sup' set but not used [-Wunused-but-set-variable]
    8092 |         u8 b_ufs_feature_sup;
         |            ^~~~~~~~~~~~~~~~~


vim +/b_ufs_feature_sup +8092 drivers/ufs/core/ufshcd.c

c28c00ba4f0609 drivers/scsi/ufs/ufshcd.c Stanley Chu     2020-05-08  8087  
097500666ec991 drivers/scsi/ufs/ufshcd.c Bean Huo        2020-01-20  8088  static int ufs_get_device_desc(struct ufs_hba *hba)
c58ab7aab71e2c drivers/scsi/ufs/ufshcd.c Yaniv Gardi     2016-03-10  8089  {
c58ab7aab71e2c drivers/scsi/ufs/ufshcd.c Yaniv Gardi     2016-03-10  8090  	int err;
c58ab7aab71e2c drivers/scsi/ufs/ufshcd.c Yaniv Gardi     2016-03-10  8091  	u8 model_index;
f02bc9754a6887 drivers/scsi/ufs/ufshcd.c Daejun Park     2021-07-12 @8092  	u8 b_ufs_feature_sup;
bbe21d7a979245 drivers/scsi/ufs/ufshcd.c Kees Cook       2018-05-02  8093  	u8 *desc_buf;
097500666ec991 drivers/scsi/ufs/ufshcd.c Bean Huo        2020-01-20  8094  	struct ufs_dev_info *dev_info = &hba->dev_info;
4b828fe156a662 drivers/scsi/ufs/ufshcd.c Tomas Winkler   2019-07-30  8095  
f2a89b071b26b7 drivers/ufs/core/ufshcd.c Arthur Simchaev 2022-12-11  8096  	desc_buf = kzalloc(QUERY_DESC_MAX_SIZE, GFP_KERNEL);
bbe21d7a979245 drivers/scsi/ufs/ufshcd.c Kees Cook       2018-05-02  8097  	if (!desc_buf) {
bbe21d7a979245 drivers/scsi/ufs/ufshcd.c Kees Cook       2018-05-02  8098  		err = -ENOMEM;
bbe21d7a979245 drivers/scsi/ufs/ufshcd.c Kees Cook       2018-05-02  8099  		goto out;
bbe21d7a979245 drivers/scsi/ufs/ufshcd.c Kees Cook       2018-05-02  8100  	}
c58ab7aab71e2c drivers/scsi/ufs/ufshcd.c Yaniv Gardi     2016-03-10  8101  
c4607a09450d67 drivers/scsi/ufs/ufshcd.c Bean Huo        2020-06-03  8102  	err = ufshcd_read_desc_param(hba, QUERY_DESC_IDN_DEVICE, 0, 0, desc_buf,
f2a89b071b26b7 drivers/ufs/core/ufshcd.c Arthur Simchaev 2022-12-11  8103  				     QUERY_DESC_MAX_SIZE);
c58ab7aab71e2c drivers/scsi/ufs/ufshcd.c Yaniv Gardi     2016-03-10  8104  	if (err) {
c58ab7aab71e2c drivers/scsi/ufs/ufshcd.c Yaniv Gardi     2016-03-10  8105  		dev_err(hba->dev, "%s: Failed reading Device Desc. err = %d\n",
c58ab7aab71e2c drivers/scsi/ufs/ufshcd.c Yaniv Gardi     2016-03-10  8106  			__func__, err);
c58ab7aab71e2c drivers/scsi/ufs/ufshcd.c Yaniv Gardi     2016-03-10  8107  		goto out;
c58ab7aab71e2c drivers/scsi/ufs/ufshcd.c Yaniv Gardi     2016-03-10  8108  	}
c58ab7aab71e2c drivers/scsi/ufs/ufshcd.c Yaniv Gardi     2016-03-10  8109  
c58ab7aab71e2c drivers/scsi/ufs/ufshcd.c Yaniv Gardi     2016-03-10  8110  	/*
c58ab7aab71e2c drivers/scsi/ufs/ufshcd.c Yaniv Gardi     2016-03-10  8111  	 * getting vendor (manufacturerID) and Bank Index in big endian
c58ab7aab71e2c drivers/scsi/ufs/ufshcd.c Yaniv Gardi     2016-03-10  8112  	 * format
c58ab7aab71e2c drivers/scsi/ufs/ufshcd.c Yaniv Gardi     2016-03-10  8113  	 */
097500666ec991 drivers/scsi/ufs/ufshcd.c Bean Huo        2020-01-20  8114  	dev_info->wmanufacturerid = desc_buf[DEVICE_DESC_PARAM_MANF_ID] << 8 |
c58ab7aab71e2c drivers/scsi/ufs/ufshcd.c Yaniv Gardi     2016-03-10  8115  				     desc_buf[DEVICE_DESC_PARAM_MANF_ID + 1];
c58ab7aab71e2c drivers/scsi/ufs/ufshcd.c Yaniv Gardi     2016-03-10  8116  
09f17791e640dc drivers/scsi/ufs/ufshcd.c Can Guo         2020-02-10  8117  	/* getting Specification Version in big endian format */
09f17791e640dc drivers/scsi/ufs/ufshcd.c Can Guo         2020-02-10  8118  	dev_info->wspecversion = desc_buf[DEVICE_DESC_PARAM_SPEC_VER] << 8 |
09f17791e640dc drivers/scsi/ufs/ufshcd.c Can Guo         2020-02-10  8119  				      desc_buf[DEVICE_DESC_PARAM_SPEC_VER + 1];
7224c806876e46 drivers/ufs/core/ufshcd.c Asutosh Das     2023-01-13  8120  	dev_info->bqueuedepth = desc_buf[DEVICE_DESC_PARAM_Q_DPTH];
f02bc9754a6887 drivers/scsi/ufs/ufshcd.c Daejun Park     2021-07-12  8121  	b_ufs_feature_sup = desc_buf[DEVICE_DESC_PARAM_UFS_FEAT];
09f17791e640dc drivers/scsi/ufs/ufshcd.c Can Guo         2020-02-10  8122  
c58ab7aab71e2c drivers/scsi/ufs/ufshcd.c Yaniv Gardi     2016-03-10  8123  	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
3d17b9b5ab1155 drivers/scsi/ufs/ufshcd.c Asutosh Das     2020-04-22  8124  
4b828fe156a662 drivers/scsi/ufs/ufshcd.c Tomas Winkler   2019-07-30  8125  	err = ufshcd_read_string_desc(hba, model_index,
097500666ec991 drivers/scsi/ufs/ufshcd.c Bean Huo        2020-01-20  8126  				      &dev_info->model, SD_ASCII_STD);
4b828fe156a662 drivers/scsi/ufs/ufshcd.c Tomas Winkler   2019-07-30  8127  	if (err < 0) {
c58ab7aab71e2c drivers/scsi/ufs/ufshcd.c Yaniv Gardi     2016-03-10  8128  		dev_err(hba->dev, "%s: Failed reading Product Name. err = %d\n",
c58ab7aab71e2c drivers/scsi/ufs/ufshcd.c Yaniv Gardi     2016-03-10  8129  			__func__, err);
c58ab7aab71e2c drivers/scsi/ufs/ufshcd.c Yaniv Gardi     2016-03-10  8130  		goto out;
c58ab7aab71e2c drivers/scsi/ufs/ufshcd.c Yaniv Gardi     2016-03-10  8131  	}
c58ab7aab71e2c drivers/scsi/ufs/ufshcd.c Yaniv Gardi     2016-03-10  8132  
b294ff3e34490f drivers/scsi/ufs/ufshcd.c Asutosh Das     2021-04-23  8133  	hba->luns_avail = desc_buf[DEVICE_DESC_PARAM_NUM_LU] +
b294ff3e34490f drivers/scsi/ufs/ufshcd.c Asutosh Das     2021-04-23  8134  		desc_buf[DEVICE_DESC_PARAM_NUM_WLU];
b294ff3e34490f drivers/scsi/ufs/ufshcd.c Asutosh Das     2021-04-23  8135  
817d7e140283f4 drivers/scsi/ufs/ufshcd.c Stanley Chu     2020-05-08  8136  	ufs_fixup_device_setup(hba);
817d7e140283f4 drivers/scsi/ufs/ufshcd.c Stanley Chu     2020-05-08  8137  
817d7e140283f4 drivers/scsi/ufs/ufshcd.c Stanley Chu     2020-05-08  8138  	ufshcd_wb_probe(hba, desc_buf);
817d7e140283f4 drivers/scsi/ufs/ufshcd.c Stanley Chu     2020-05-08  8139  
e88e2d32200a17 drivers/scsi/ufs/ufshcd.c Avri Altman     2021-09-15  8140  	ufshcd_temp_notif_probe(hba, desc_buf);
e88e2d32200a17 drivers/scsi/ufs/ufshcd.c Avri Altman     2021-09-15  8141  
6e1d850acff947 drivers/ufs/core/ufshcd.c Asutosh Das     2023-01-13  8142  	if (hba->ext_iid_sup)
6e1d850acff947 drivers/ufs/core/ufshcd.c Asutosh Das     2023-01-13  8143  		ufshcd_ext_iid_probe(hba, desc_buf);
6e1d850acff947 drivers/ufs/core/ufshcd.c Asutosh Das     2023-01-13  8144  
4b828fe156a662 drivers/scsi/ufs/ufshcd.c Tomas Winkler   2019-07-30  8145  	/*
4b828fe156a662 drivers/scsi/ufs/ufshcd.c Tomas Winkler   2019-07-30  8146  	 * ufshcd_read_string_desc returns size of the string
4b828fe156a662 drivers/scsi/ufs/ufshcd.c Tomas Winkler   2019-07-30  8147  	 * reset the error value
4b828fe156a662 drivers/scsi/ufs/ufshcd.c Tomas Winkler   2019-07-30  8148  	 */
4b828fe156a662 drivers/scsi/ufs/ufshcd.c Tomas Winkler   2019-07-30  8149  	err = 0;
c58ab7aab71e2c drivers/scsi/ufs/ufshcd.c Yaniv Gardi     2016-03-10  8150  
c58ab7aab71e2c drivers/scsi/ufs/ufshcd.c Yaniv Gardi     2016-03-10  8151  out:
bbe21d7a979245 drivers/scsi/ufs/ufshcd.c Kees Cook       2018-05-02  8152  	kfree(desc_buf);
c58ab7aab71e2c drivers/scsi/ufs/ufshcd.c Yaniv Gardi     2016-03-10  8153  	return err;
c58ab7aab71e2c drivers/scsi/ufs/ufshcd.c Yaniv Gardi     2016-03-10  8154  }
c58ab7aab71e2c drivers/scsi/ufs/ufshcd.c Yaniv Gardi     2016-03-10  8155  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
