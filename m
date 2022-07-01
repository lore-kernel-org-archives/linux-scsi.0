Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32980C43334
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jul 2022 04:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbiGAEf3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Jul 2022 00:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiGAEf2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2022 00:35:28 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB4065D51;
        Thu, 30 Jun 2022 21:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656650127; x=1688186127;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qhHpSeK0yRiqHvWk4JBcgPwqSiR5I/r/15S4gQ1qe4w=;
  b=mf0crJvdm5V52Hr+3dP9ZW4sSyIL9weZ9X9ba4XROLnN5F0M23EW2rTN
   Dw9o/EeYFdKKU/XQyJwT/ooN+Mk9HMW1hvTCmAfcofrOktqwARyqbiUYK
   h3XEF7om6COPC8ke3nYANLTtt93naTzpU9bRRAd2i9AhKhuCdZofr0Vz/
   g653FZht0mMhpAKX5H34DHrjLggK5h4G/hsUkgTUm3rB6DlR/oVOCnFa7
   LmVYrxhKY3GN2UY5lj7iiBlcwU5BHkpF9z5yuj8fBRf0oHhkZN7O3GDED
   8xVa0pefownf3Js5wOrZw5I5tGJJ6VyRHbi96ozvigtPi35kUC2iPcQIw
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="281312379"
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="281312379"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 21:35:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="733915899"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 30 Jun 2022 21:35:25 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o78NJ-000DXK-7z;
        Fri, 01 Jul 2022 04:35:25 +0000
Date:   Fri, 1 Jul 2022 12:35:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     Anastasia Kovaleva <a.kovaleva@yadro.com>,
        target-devel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, linux-scsi@vger.kernel.org,
        linux@yadro.com
Subject: Re: [PATCH 3/3] target: core: Change the way target_xcopy_do_work
 sets restiction on max io
Message-ID: <202207011237.RwOL3m3V-lkp@intel.com>
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
[also build test ERROR on linus/master v5.19-rc4 next-20220630]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Anastasia-Kovaleva/Make-target-send-correct-io-limits/20220630-203342
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
config: i386-randconfig-a005 (https://download.01.org/0day-ci/archive/20220701/202207011237.RwOL3m3V-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/56a549ae44a7fa719292ad848e1f70fa745d0ece
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Anastasia-Kovaleva/Make-target-send-correct-io-limits/20220630-203342
        git checkout 56a549ae44a7fa719292ad848e1f70fa745d0ece
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   ld: drivers/target/target_core_xcopy.o: in function `target_xcopy_do_work':
>> target_core_xcopy.c:(.text+0x138d): undefined reference to `__udivdi3'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
