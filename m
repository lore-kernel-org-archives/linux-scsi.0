Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF62DC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 10 May 2022 15:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243965AbiEJPXL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 May 2022 11:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346365AbiEJPWb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 May 2022 11:22:31 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E43F49272;
        Tue, 10 May 2022 08:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652195168; x=1683731168;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=smiA6bSsB2WHclcS8X/cNLnhHT+fvnRftsloF2vpp98=;
  b=QbxF7bOmZQSxyfqso3nfj18c2e+CPdG3zA1lUQcgBoP0FZjNN5LLLwXV
   vsJXDlDVg0zTgKKHt+x6uce7uyDPyNnb7rnITLcYqUtwEmGclfz4j3C4f
   r6hHWyBHc2hyxkKQXMrNv3jQTsrGIZLCyZmgnMct3h7S7Zf60DmhwOGwq
   BllPx21LtteBbqSKzbrOPepAXRYJLfTklTV3NJLDr4ZdZ8b7Q37s8IX6Q
   RMZrQ0QwpcOEPIr0TZE6CEK9z2AZnug7md7iUCWIVyXy0OIVwaX/Rz8aW
   7dIAW1ok7XqTGni4eRDsVpN55YZXC5Kl2gPGabLeLjnOLzpirv9bpyZPG
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="269066309"
X-IronPort-AV: E=Sophos;i="5.91,214,1647327600"; 
   d="scan'208";a="269066309"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 08:06:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,214,1647327600"; 
   d="scan'208";a="697123042"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 10 May 2022 08:06:06 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1noRR7-000I34-Fs;
        Tue, 10 May 2022 15:06:05 +0000
Date:   Tue, 10 May 2022 23:05:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Guixin Liu <kanie@linux.alibaba.com>, bostroesser@gmail.com,
        martin.petersen@oracle.com
Cc:     kbuild-all@lists.01.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH] scsi:tcmu: switch tcmu completion path to work queue
 context
Message-ID: <202205102245.Zg2ynlzX-lkp@intel.com>
References: <1652165414-15933-1-git-send-email-kanie@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1652165414-15933-1-git-send-email-kanie@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Guixin,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on v5.18-rc6 next-20220509]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Guixin-Liu/scsi-tcmu-switch-tcmu-completion-path-to-work-queue-context/20220510-145227
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
config: x86_64-rhel-8.3-kselftests (https://download.01.org/0day-ci/archive/20220510/202205102245.Zg2ynlzX-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/intel-lab-lkp/linux/commit/08884eca055feed72186261c64dea07df464946e
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Guixin-Liu/scsi-tcmu-switch-tcmu-completion-path-to-work-queue-context/20220510-145227
        git checkout 08884eca055feed72186261c64dea07df464946e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/target/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> drivers/target/target_core_user.c:229:25: sparse: sparse: symbol 'tcmu_comp_wq' was not declared. Should it be static?

Please review and possibly fold the followup patch.

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
