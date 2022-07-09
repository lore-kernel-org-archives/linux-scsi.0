Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5319C433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jul 2022 05:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiGIF3b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Jul 2022 01:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGIF3a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jul 2022 01:29:30 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C039F88752;
        Fri,  8 Jul 2022 22:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657344568; x=1688880568;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GwKMGDgEQOTMZAJyEWQoKSVfa5JoZEAuPF4dI30gQw0=;
  b=YZopXBC2PpZfYD4wM52Zg+AkBzty8tzAEsiG7z5aNVATInmiunCrd9bI
   TkzalQr8wm7gAPG1TgWg/3Ty4k7jdBQWr3WXE8/izKwXdAsKY+0U4QSiM
   n6OeaPWsWtUVraX5IQo07XBrr55iXW+8FM7f0o+zXS1FqvxAuRjDzJtzI
   wC9t9akd6m3fu5mkJrQeKMHdcatWqLJWPPZjhHhPLgU4WGkHYOiEF73xe
   nNyLXyfb9OxRQRe228xqWKLgHUMLyh5UaFBZiE0hImZhuJWL1uICX8+rA
   0DelXGfjSHFzF36RJSBLLp4jnuAZ40u7xxLoMqPKDxyEnB+Q+TdpML9sb
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10402"; a="346095872"
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="346095872"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 22:29:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="921219431"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 08 Jul 2022 22:29:25 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oA31w-000OLq-BB;
        Sat, 09 Jul 2022 05:29:24 +0000
Date:   Sat, 9 Jul 2022 13:29:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org,
        arnd@kernel.org
Cc:     kbuild-all@lists.01.org, linux-scsi@vger.kernel.org,
        geert@linux-m68k.org, Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH v1 2/4] m68k - set up platform device for mvme147_scsi
Message-ID: <202207091359.WPLQuHhB-lkp@intel.com>
References: <20220709001019.11149-3-schmitzmic@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220709001019.11149-3-schmitzmic@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Michael,

I love your patch! Perhaps something to improve:

[auto build test WARNING on geert-m68k/for-next]
[also build test WARNING on mkp-scsi/for-next jejb-scsi/for-next linus/master v5.19-rc5 next-20220708]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Michael-Schmitz/Convert-m68k-MVME147-WD33C93-SCSI-driver-to-DMA-API/20220709-081556
base:   https://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-next
config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20220709/202207091359.WPLQuHhB-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/3a5e770e42ebe8984096d0cd1d93a95a1d7b67e7
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Michael-Schmitz/Convert-m68k-MVME147-WD33C93-SCSI-driver-to-DMA-API/20220709-081556
        git checkout 3a5e770e42ebe8984096d0cd1d93a95a1d7b67e7
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash arch/m68k/mvme147/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   arch/m68k/mvme147/config.c:77:13: warning: no previous prototype for 'mvme147_init_IRQ' [-Wmissing-prototypes]
      77 | void __init mvme147_init_IRQ(void)
         |             ^~~~~~~~~~~~~~~~
>> arch/m68k/mvme147/config.c:198:12: warning: no previous prototype for 'mvme147_platform_init' [-Wmissing-prototypes]
     198 | int __init mvme147_platform_init(void)
         |            ^~~~~~~~~~~~~~~~~~~~~


vim +/mvme147_platform_init +198 arch/m68k/mvme147/config.c

   197	
 > 198	int __init mvme147_platform_init(void)
   199	{
   200		struct platform_device *pdev;
   201		int rv = 0;
   202	
   203		pdev = platform_device_register_simple("mvme147-scsi", -1,
   204			mvme147_scsi_rsrc, ARRAY_SIZE(mvme147_scsi_rsrc));
   205		if (IS_ERR(pdev))
   206			rv = PTR_ERR(pdev);
   207	
   208		return rv;
   209	}
   210	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
