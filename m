Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 819BFC433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Jul 2022 11:47:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbiGBLr5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Jul 2022 07:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232020AbiGBLr4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jul 2022 07:47:56 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12FA1057E;
        Sat,  2 Jul 2022 04:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656762473; x=1688298473;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EgfBReJcpv18LXfQTe5cnePYbwlzCm1/gUujXSctsoI=;
  b=J26dcxHd4pE87Uowm/4LgQ7m1Nf6tAg4ewm1YtuMdJClJcMytuWlVm6O
   y3/DZ+DmYilw0KvctuEr55q5HdkN5t9nOQEyvMYIjr/24h5yhA/tHac6P
   HovoQpCwZ2cRDW5GQHArn0V1uryIQRJpZi+9miF+xdIlqKa9QVKh1QiMT
   x1ZcEnz78dDvmgfQVzHnie4rE/6SDCBkrWKMvRJKI6/IMs1DXzS/F+pnG
   2jgKcegq89CDUcizR0NF7Opdh2A/l1+VSf1IQGoroONEOaPiHvaPlJuZs
   7+vkbSzgiwoCw+X8ghRYKZXObMhigBMEZnKI3kdZo7T5DBt6+iojCYZZg
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10395"; a="346807371"
X-IronPort-AV: E=Sophos;i="5.92,239,1650956400"; 
   d="scan'208";a="346807371"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2022 04:47:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,239,1650956400"; 
   d="scan'208";a="918772599"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 02 Jul 2022 04:47:51 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o7bbK-000FCF-SQ;
        Sat, 02 Jul 2022 11:47:50 +0000
Date:   Sat, 2 Jul 2022 19:47:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Anastasia Kovaleva <a.kovaleva@yadro.com>,
        target-devel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, linux-scsi@vger.kernel.org,
        linux@yadro.com
Subject: Re: [PATCH 3/3] target: core: Change the way target_xcopy_do_work
 sets restiction on max io
Message-ID: <202207021939.V7V97GD3-lkp@intel.com>
References: <20220630122241.1658-4-a.kovaleva@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630122241.1658-4-a.kovaleva@yadro.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Anastasia,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on mkp-scsi/for-next]
[also build test ERROR on linus/master v5.19-rc4 next-20220701]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Anastasia-Kovaleva/Make-target-send-correct-io-limits/20220630-203342
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20220702/202207021939.V7V97GD3-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/56a549ae44a7fa719292ad848e1f70fa745d0ece
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Anastasia-Kovaleva/Make-target-send-correct-io-limits/20220630-203342
        git checkout 56a549ae44a7fa719292ad848e1f70fa745d0ece
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "__divdi3" [drivers/target/target_core_mod.ko] undefined!
>> ERROR: modpost: "__udivdi3" [drivers/target/target_core_mod.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
