Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95AE6C001DE
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Aug 2023 06:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbjHBG2U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Aug 2023 02:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjHBG2S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2023 02:28:18 -0400
Received: from mgamail.intel.com (unknown [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E2526BA
        for <linux-scsi@vger.kernel.org>; Tue,  1 Aug 2023 23:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690957697; x=1722493697;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JAqHigCANm/GHKxKWVCTL5vDntCZpuz1yr5nqOR1EPU=;
  b=a42r+2U6iewD2dXqpbA6HRKNngqCfkpktYoEeOZ+FD4FP95CdHPZoxNo
   PjhvYndEwokxq7BTohmfWmLKiLdix4SPK8r7U11+zC/cUHU0enIyLfwzS
   x28Sbh50BC4jKsTziuxwK7I2kh3zKqmhshfksGwZrLu60XZSA3W4qJsaM
   4aAIbOGgtgJKNK9nhIUN9V1M6C0ZIXgX41qMDQgqpnd2ALTHUhV2ZliPs
   VcffGztXlWFKuG7OyA+Svi/cmTqTnejKbp9ZLH2lzZskklH1foamuO1aV
   IOouKwqI8wKAiS56MvC9RJLd9ZJNqaGmA8UeDuYtRA0V/NvGRyo1NKQh6
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="349094312"
X-IronPort-AV: E=Sophos;i="6.01,248,1684825200"; 
   d="scan'208";a="349094312"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 23:28:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="819062250"
X-IronPort-AV: E=Sophos;i="6.01,248,1684825200"; 
   d="scan'208";a="819062250"
Received: from lkp-server01.sh.intel.com (HELO d1ccc7e87e8f) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Aug 2023 23:28:15 -0700
Received: from kbuild by d1ccc7e87e8f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qR5LC-0000wd-1T;
        Wed, 02 Aug 2023 06:28:14 +0000
Date:   Wed, 2 Aug 2023 14:27:19 +0800
From:   kernel test robot <lkp@intel.com>
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com, agurumurthy@marvell.com,
        sdeodhar@marvell.com
Subject: Re: [PATCH 01/10] qla2xxx: Add NVMe Disconnect support
Message-ID: <202308021445.txlNq7UC-lkp@intel.com>
References: <20230801114057.27039-2-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230801114057.27039-2-njavali@marvell.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Nilesh,

kernel test robot noticed the following build errors:

[auto build test ERROR on 7e9609d2daea0ebe4add444b26b76479ecfda504]

url:    https://github.com/intel-lab-lkp/linux/commits/Nilesh-Javali/qla2xxx-Add-NVMe-Disconnect-support/20230801-194339
base:   7e9609d2daea0ebe4add444b26b76479ecfda504
patch link:    https://lore.kernel.org/r/20230801114057.27039-2-njavali%40marvell.com
patch subject: [PATCH 01/10] qla2xxx: Add NVMe Disconnect support
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20230802/202308021445.txlNq7UC-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce: (https://download.01.org/0day-ci/archive/20230802/202308021445.txlNq7UC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308021445.txlNq7UC-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

WARNING: modpost: missing MODULE_DESCRIPTION() in vmlinux.o
WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/kernel/cpu/mce/mce-inject.o
WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/kvm/kvm.o
WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/kvm/kvm-intel.o
WARNING: modpost: missing MODULE_DESCRIPTION() in mm/hwpoison-inject.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/cramfs/cramfs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/nfsd/nfsd.o
WARNING: modpost: missing MODULE_DESCRIPTION() in fs/btrfs/btrfs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in crypto/xor.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/acpi/nfit/nfit.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/block/brd.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/dax/hmem/dax_hmem.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/dax/device_dax.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/dax/kmem.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/dax/dax_pmem.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/isci/isci.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvme/host/nvme-core.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvme/host/nvme.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/net/netdevsim/netdevsim.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/cdrom/cdrom.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/devfreq/governor_simpleondemand.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/libnvdimm.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/nd_pmem.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/nd_btt.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/nd_e820.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/ip_tunnel.o
WARNING: modpost: missing MODULE_DESCRIPTION() in net/ipv4/udp_tunnel.o
>> ERROR: modpost: "nvme_fc_rcv_ls_req" [drivers/scsi/qla2xxx/qla2xxx.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
