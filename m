Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63097C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jan 2022 23:59:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbiAZX7a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jan 2022 18:59:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:50926 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229547AbiAZX73 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Jan 2022 18:59:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643241569; x=1674777569;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=APgJyUkB3FsL9JXOt1lh3AkCAhtQqbqNOGOZRE2ZTf8=;
  b=dzvm3RSR1xupw91Aw/Nti22WL4PyCQTfLllPaGy3fM+yvt+cbekAwp2R
   bExmnZQROXF09lyudamJNkqsreENr+ds9mwI43jXfbOsBoGhPYipcnMdm
   R7Nvtf4fHBSL3pJ38L8JjyyW/7/R+DUHYcLFREL0lp4FkfN/wxt/qJXGh
   uP9RIlePuCUl7JqnionmIeGNgdVHMVYkfpfPl7rc850JDs3W4DjpZxCB3
   aFJ1Cz58HV5O5AKjidflTe+2hKRZn7xfbVEdkX+dHtRpQ7R2DP44Jmnt9
   vVCYb/Zc4wi7w3kLaB6G7nzlp5Dx8S3ROBAMsJPvjNp+MPOC5Q9r7+tIC
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="234068864"
X-IronPort-AV: E=Sophos;i="5.88,319,1635231600"; 
   d="scan'208";a="234068864"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 15:59:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,319,1635231600"; 
   d="scan'208";a="477656288"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 26 Jan 2022 15:59:26 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nCsCD-000LpI-JU; Wed, 26 Jan 2022 23:59:25 +0000
Date:   Thu, 27 Jan 2022 07:58:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jinyoung CHOI <j-young.choi@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc:     kbuild-all@lists.01.org
Subject: Re: [PATCH] scsi: ufs: Add checking lifetime attribute for
 WriteBooster
Message-ID: <202201270725.pB39Qr9M-lkp@intel.com>
References: <1891546521.01643237281916.JavaMail.epsvc@epcpadp4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1891546521.01643237281916.JavaMail.epsvc@epcpadp4>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Jinyoung,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next v5.17-rc1 next-20220125]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Jinyoung-CHOI/scsi-ufs-Add-checking-lifetime-attribute-for-WriteBooster/20220127-064945
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
config: alpha-allmodconfig (https://download.01.org/0day-ci/archive/20220127/202201270725.pB39Qr9M-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/119120165af15780b5bdb5bf4bf59cfd8a2826ba
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jinyoung-CHOI/scsi-ufs-Add-checking-lifetime-attribute-for-WriteBooster/20220127-064945
        git checkout 119120165af15780b5bdb5bf4bf59cfd8a2826ba
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=alpha SHELL=/bin/bash drivers/scsi/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from include/linux/device.h:15,
                    from include/linux/async.h:14,
                    from drivers/scsi/ufs/ufshcd.c:12:
   drivers/scsi/ufs/ufshcd.c: In function 'ufshcd_is_wb_buf_lifetime_available':
>> drivers/scsi/ufs/ufshcd.c:5811:35: warning: '0' flag ignored with precision and '%X' gnu_printf format [-Wformat=]
    5811 |                 dev_err(hba->dev, "%s: WB buf lifetime is exhausted 0x%0.2X\n",
         |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/dev_printk.h:110:30: note: in definition of macro 'dev_printk_index_wrap'
     110 |                 _p_func(dev, fmt, ##__VA_ARGS__);                       \
         |                              ^~~
   include/linux/dev_printk.h:144:56: note: in expansion of macro 'dev_fmt'
     144 |         dev_printk_index_wrap(_dev_err, KERN_ERR, dev, dev_fmt(fmt), ##__VA_ARGS__)
         |                                                        ^~~~~~~
   drivers/scsi/ufs/ufshcd.c:5811:17: note: in expansion of macro 'dev_err'
    5811 |                 dev_err(hba->dev, "%s: WB buf lifetime is exhausted 0x%0.2X\n",
         |                 ^~~~~~~
   In file included from include/linux/printk.h:555,
                    from include/asm-generic/bug.h:22,
                    from arch/alpha/include/asm/bug.h:23,
                    from include/linux/bug.h:5,
                    from include/linux/thread_info.h:13,
                    from include/asm-generic/current.h:5,
                    from ./arch/alpha/include/generated/asm/current.h:1,
                    from include/linux/sched.h:12,
                    from include/linux/ratelimit.h:6,
                    from include/linux/dev_printk.h:16,
                    from include/linux/device.h:15,
                    from include/linux/async.h:14,
                    from drivers/scsi/ufs/ufshcd.c:12:
   drivers/scsi/ufs/ufshcd.c:5816:27: warning: '0' flag ignored with precision and '%X' gnu_printf format [-Wformat=]
    5816 |         dev_dbg(hba->dev, "%s: WB buf lifetime is 0x%0.2X\n",
         |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:134:29: note: in definition of macro '__dynamic_func_call'
     134 |                 func(&id, ##__VA_ARGS__);               \
         |                             ^~~~~~~~~~~
   include/linux/dynamic_debug.h:166:9: note: in expansion of macro '_dynamic_func_call'
     166 |         _dynamic_func_call(fmt,__dynamic_dev_dbg,               \
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/dev_printk.h:155:9: note: in expansion of macro 'dynamic_dev_dbg'
     155 |         dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~
   include/linux/dev_printk.h:155:30: note: in expansion of macro 'dev_fmt'
     155 |         dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
         |                              ^~~~~~~
   drivers/scsi/ufs/ufshcd.c:5816:9: note: in expansion of macro 'dev_dbg'
    5816 |         dev_dbg(hba->dev, "%s: WB buf lifetime is 0x%0.2X\n",
         |         ^~~~~~~


vim +5811 drivers/scsi/ufs/ufshcd.c

  5792	
  5793	static bool ufshcd_is_wb_buf_lifetime_available(struct ufs_hba *hba)
  5794	{
  5795		u32 lifetime;
  5796		int ret;
  5797		u8 index;
  5798	
  5799		index = ufshcd_wb_get_query_index(hba);
  5800		ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
  5801					      QUERY_ATTR_IDN_WB_BUFF_LIFE_TIME_EST,
  5802					      index, 0, &lifetime);
  5803		if (ret) {
  5804			dev_err(hba->dev,
  5805				"%s: bWriteBoosterBufferLifeTimeEst read failed %d\n",
  5806				__func__, ret);
  5807			return false;
  5808		}
  5809	
  5810		if (lifetime == UFS_WB_EXCEED_LIFETIME) {
> 5811			dev_err(hba->dev, "%s: WB buf lifetime is exhausted 0x%0.2X\n",
  5812				__func__, lifetime);
  5813			return false;
  5814		}
  5815	
  5816		dev_dbg(hba->dev, "%s: WB buf lifetime is 0x%0.2X\n",
  5817			__func__, lifetime);
  5818	
  5819		return true;
  5820	}
  5821	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
