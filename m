Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5369C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Apr 2022 16:25:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbiDMQ2N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Apr 2022 12:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236838AbiDMQ2M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2022 12:28:12 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB3E26547
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2022 09:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649867150; x=1681403150;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Eh9weIB31ABIHjarMujiA+vm0gone30u06Pf4DMfNA4=;
  b=MLHAhr3Pr6iohK+Hu332/GS/IQZ0FxhGo8wwq0qvqsBAYjU1iGFFwKiu
   a4koZglbpw9EV5wWZv5xGWQ4KDDhjX9LJQGgakz7XpFl+ChXV+xkhvg0V
   teU5UUDsAQ5q03bMTfQq04oSXQu/MmurEqCIDQD3oQ3qwdnenTGTPiNyG
   DkDfIQiymG1oDVkphIMDQ40jS4d5NbDRDYQtBomWeLEQ8Q/VHbC3aiaS3
   yN7/a9VlcEwgx1AfcuJzC2W72dJ8Pxo20de+7PFlC2lwmiOaYYA9q7VF/
   7VUCwOkfJc9Vb/8/TQD9240bM/nF6uW/Xea9ESQ/5BJYFsBahhCL0tMwW
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="349147301"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="349147301"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 09:25:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="660992822"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 13 Apr 2022 09:25:27 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nefo6-0000Ri-Js;
        Wed, 13 Apr 2022 16:25:26 +0000
Date:   Thu, 14 Apr 2022 00:25:22 +0800
From:   kernel test robot <lkp@intel.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     kbuild-all@lists.01.org, James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: Re: [PATCH 20/26] lpfc: Fix field overload in lpfc_iocbq data
 structure
Message-ID: <202204140010.nJRJE8ye-lkp@intel.com>
References: <20220412222008.126521-21-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412222008.126521-21-jsmart2021@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,

I love your patch! Perhaps something to improve:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next v5.18-rc2 next-20220413]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/James-Smart/lpfc-Update-lpfc-to-revision-14-2-0-2/20220413-073746
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
config: mips-allmodconfig (https://download.01.org/0day-ci/archive/20220414/202204140010.nJRJE8ye-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/536304e3919a95bf3d790d78a9a79b862e4ef29c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review James-Smart/lpfc-Update-lpfc-to-revision-14-2-0-2/20220413-073746
        git checkout 536304e3919a95bf3d790d78a9a79b862e4ef29c
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=mips SHELL=/bin/bash drivers/scsi/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from include/linux/device.h:15,
                    from include/linux/blk_types.h:11,
                    from include/linux/blkdev.h:9,
                    from drivers/scsi/lpfc/lpfc_init.c:24:
   drivers/scsi/lpfc/lpfc_init.c: In function 'lpfc_new_io_buf':
>> drivers/scsi/lpfc/lpfc_logmsg.h:94:59: warning: format '%lx' expects argument of type 'long unsigned int', but argument 7 has type 'unsigned int' [-Wformat=]
      94 |                 dev_printk(level, &((phba)->pcidev)->dev, "%d:" \
         |                                                           ^~~~~
   include/linux/dev_printk.h:129:41: note: in definition of macro 'dev_printk'
     129 |                 _dev_printk(level, dev, fmt, ##__VA_ARGS__);            \
         |                                         ^~~
   drivers/scsi/lpfc/lpfc_init.c:4479:9: note: in expansion of macro 'lpfc_printf_log'
    4479 |         lpfc_printf_log(phba, KERN_INFO, LOG_NVME,
         |         ^~~~~~~~~~~~~~~


vim +94 drivers/scsi/lpfc/lpfc_logmsg.h

e8b62011d88d6f James Smart     2007-08-02  85  
dea3101e0a5c89 James Bottomley 2005-04-17  86  #define lpfc_printf_log(phba, level, mask, fmt, arg...) \
7f5f3d0d02aa2f James Smart     2008-02-08  87  do { \
f4b4c68f74dcd5 James Smart     2009-05-22  88  	{ uint32_t log_verbose = (phba)->pport ? \
f4b4c68f74dcd5 James Smart     2009-05-22  89  				 (phba)->pport->cfg_log_verbose : \
f4b4c68f74dcd5 James Smart     2009-05-22  90  				 (phba)->cfg_log_verbose; \
372c187b8a705c Dick Kennedy    2020-06-30  91  	if (((mask) & log_verbose) || (level[1] <= '3')) { \
30d9d4d7f38739 James Smart     2022-04-12  92  		if ((mask) & LOG_TRACE_EVENT && !log_verbose) \
372c187b8a705c Dick Kennedy    2020-06-30  93  			lpfc_dmp_dbg(phba); \
e8b62011d88d6f James Smart     2007-08-02 @94  		dev_printk(level, &((phba)->pcidev)->dev, "%d:" \

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
