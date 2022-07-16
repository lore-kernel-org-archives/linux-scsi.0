Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B740C43334
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Jul 2022 18:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiGPSof (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Jul 2022 14:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiGPSof (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Jul 2022 14:44:35 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16682CE2D
        for <linux-scsi@vger.kernel.org>; Sat, 16 Jul 2022 11:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657997074; x=1689533074;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tGOL5pssqjgCPLkVF2Hir1juj59SAfwJCQP2fI30hgo=;
  b=XsE5SpQbhm0C5jnGS7iUlfVqaqgkAr9hTcQO8Jxdgqstpo/mnDHDlx1U
   TddhbqNWvmwWNTjP+bVs68joOOolGx7HuoSjrrgKYF0B5VqlJeFr9iawX
   eRLf0gbt2WAPQVOuVcu5fPUVwZFdzmGFNzGm2mwhlkZoScxH+xbGfbf9P
   MpCvUGdHJTn5R0TP6rom1gYiXv1AVAMItCKDxGhrFHr308HBXhXvk56mR
   +npEPMutNNchX/9S7QKA+6xUib8VEFV8dw5MO+dzqQsy+WIEp/nw9cxey
   5oUrqClxvgzExiqG94w+aooslXWU0EPlfE9TTyuVK7qSOoL7KZbOlbTgJ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10410"; a="266407237"
X-IronPort-AV: E=Sophos;i="5.92,277,1650956400"; 
   d="scan'208";a="266407237"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2022 11:44:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,277,1650956400"; 
   d="scan'208";a="624238571"
Received: from lkp-server02.sh.intel.com (HELO ff137eb26ff1) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 16 Jul 2022 11:44:31 -0700
Received: from kbuild by ff137eb26ff1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oCmmF-0001za-4l;
        Sat, 16 Jul 2022 18:44:31 +0000
Date:   Sun, 17 Jul 2022 02:43:51 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 1/1] mpi3mr: Fix compilation errors observed on i386 arch
Message-ID: <202207170253.TJixMaQt-lkp@intel.com>
References: <20220715150219.16875-2-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715150219.16875-2-sreekanth.reddy@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Sreekanth,

I love your patch! Perhaps something to improve:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on next-20220714]
[cannot apply to jejb-scsi/for-next linus/master v5.19-rc6]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Sreekanth-Reddy/mpi3mr-Fix-compilation-errors-on-i386-arch/20220716-211058
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
config: i386-randconfig-a013 (https://download.01.org/0day-ci/archive/20220717/202207170253.TJixMaQt-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 07022e6cf9b5b3baa642be53d0b3c3f1c403dbfd)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/1fe83692304d301bd0737ed16c8bd1bcd8c0fa90
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Sreekanth-Reddy/mpi3mr-Fix-compilation-errors-on-i386-arch/20220716-211058
        git checkout 1fe83692304d301bd0737ed16c8bd1bcd8c0fa90
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/scsi/mpi3mr/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/scsi/mpi3mr/mpi3mr_os.c:1663:3: warning: 'memcpy' will always overflow; destination buffer has size 4, but size argument is 8 [-Wfortify-source]
                   memcpy((char *)&tg, fwevt->event_data, sizeof(u64));
                   ^
   arch/x86/include/asm/string_32.h:150:25: note: expanded from macro 'memcpy'
   #define memcpy(t, f, n) __builtin_memcpy(t, f, n)
                           ^
   1 warning generated.


vim +/memcpy +1663 drivers/scsi/mpi3mr/mpi3mr_os.c

  1601	
  1602	/**
  1603	 * mpi3mr_fwevt_bh - Firmware event bottomhalf handler
  1604	 * @mrioc: Adapter instance reference
  1605	 * @fwevt: Firmware event reference
  1606	 *
  1607	 * Identifies the firmware event and calls corresponding bottomg
  1608	 * half handler and sends event acknowledgment if required.
  1609	 *
  1610	 * Return: Nothing.
  1611	 */
  1612	static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
  1613		struct mpi3mr_fwevt *fwevt)
  1614	{
  1615		mpi3mr_fwevt_del_from_list(mrioc, fwevt);
  1616		mrioc->current_event = fwevt;
  1617	
  1618		if (mrioc->stop_drv_processing)
  1619			goto out;
  1620	
  1621		if (!fwevt->process_evt)
  1622			goto evt_ack;
  1623	
  1624		switch (fwevt->event_id) {
  1625		case MPI3_EVENT_DEVICE_ADDED:
  1626		{
  1627			struct mpi3_device_page0 *dev_pg0 =
  1628			    (struct mpi3_device_page0 *)fwevt->event_data;
  1629			mpi3mr_report_tgtdev_to_host(mrioc,
  1630			    le16_to_cpu(dev_pg0->persistent_id));
  1631			break;
  1632		}
  1633		case MPI3_EVENT_DEVICE_INFO_CHANGED:
  1634		{
  1635			mpi3mr_devinfochg_evt_bh(mrioc,
  1636			    (struct mpi3_device_page0 *)fwevt->event_data);
  1637			break;
  1638		}
  1639		case MPI3_EVENT_DEVICE_STATUS_CHANGE:
  1640		{
  1641			mpi3mr_devstatuschg_evt_bh(mrioc, fwevt);
  1642			break;
  1643		}
  1644		case MPI3_EVENT_SAS_TOPOLOGY_CHANGE_LIST:
  1645		{
  1646			mpi3mr_sastopochg_evt_bh(mrioc, fwevt);
  1647			break;
  1648		}
  1649		case MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
  1650		{
  1651			mpi3mr_pcietopochg_evt_bh(mrioc, fwevt);
  1652			break;
  1653		}
  1654		case MPI3_EVENT_LOG_DATA:
  1655		{
  1656			mpi3mr_logdata_evt_bh(mrioc, fwevt);
  1657			break;
  1658		}
  1659		case MPI3MR_DRIVER_EVENT_TG_QD_REDUCTION:
  1660		{
  1661			struct mpi3mr_throttle_group_info *tg;
  1662	
> 1663			memcpy((char *)&tg, fwevt->event_data, sizeof(u64));
  1664			dprint_event_bh(mrioc,
  1665			    "qd reduction event processed for tg_id(%d) reduction_needed(%d)\n",
  1666			    tg->id, tg->need_qd_reduction);
  1667			if (tg->need_qd_reduction) {
  1668				mpi3mr_set_qd_for_all_vd_in_tg(mrioc, tg);
  1669				tg->need_qd_reduction = 0;
  1670			}
  1671			break;
  1672		}
  1673		default:
  1674			break;
  1675		}
  1676	
  1677	evt_ack:
  1678		if (fwevt->send_ack)
  1679			mpi3mr_process_event_ack(mrioc, fwevt->event_id,
  1680			    fwevt->evt_ctx);
  1681	out:
  1682		/* Put fwevt reference count to neutralize kref_init increment */
  1683		mpi3mr_fwevt_put(fwevt);
  1684		mrioc->current_event = NULL;
  1685	}
  1686	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
