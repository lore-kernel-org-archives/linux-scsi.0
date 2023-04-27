Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6464AC77B61
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Apr 2023 11:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243405AbjD0LH0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Apr 2023 07:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243264AbjD0LHZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Apr 2023 07:07:25 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CA710F3
        for <linux-scsi@vger.kernel.org>; Thu, 27 Apr 2023 04:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682593643; x=1714129643;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hynKrY1fJ97FgFxPsrCgm5MkuYd14B6UHLKpGBCYjWY=;
  b=JJyED0TlLHJN/zoF4ewKBMWIyQyyVPxFsd0nCbHuu2XbMCLtNg52cDzG
   OSTVWKkIJ+T52y3/VZTKUca/2cjr4jkFZTOzp8qpebeu281m+8clra1qy
   wxpkQPprpWc64MeK+vprrWzLlJJBwytvp0Z8k7h7Jl7qfGC/GBzHjtQPw
   ZJgr2SO3KmIL0Et8jutL+wIWSdGsqTRO+GUDA5RRZgV3loIw9GykK6QBZ
   8glWmLzySqkfTQZlk/vHHxTS2bW+pCzqyIfleZGnoYYTEjseaZhYRg3Jx
   T7H5LSL4/OHIh9IW9oVjPUYopPd/jm4gJzPXnK898YqbXdn5vptZ6Ht7O
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="347416734"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="347416734"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 04:07:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="868679629"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="868679629"
Received: from lkp-server01.sh.intel.com (HELO 1e0e07564161) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 27 Apr 2023 04:07:20 -0700
Received: from kbuild by 1e0e07564161 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1przT5-0000Bx-2c;
        Thu, 27 Apr 2023 11:07:19 +0000
Date:   Thu, 27 Apr 2023 19:06:51 +0800
From:   kernel test robot <lkp@intel.com>
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com, bhazarika@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com
Subject: Re: [PATCH 2/7] qla2xxx: Fix task management cmd failure
Message-ID: <202304271802.uCZfwQC1-lkp@intel.com>
References: <20230427080351.9889-3-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427080351.9889-3-njavali@marvell.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Nilesh,

kernel test robot noticed the following build warnings:

[auto build test WARNING on c8e22b7a1694bb8d025ea636816472739d859145]

url:    https://github.com/intel-lab-lkp/linux/commits/Nilesh-Javali/qla2xxx-Multi-que-support-for-TMF/20230427-160555
base:   c8e22b7a1694bb8d025ea636816472739d859145
patch link:    https://lore.kernel.org/r/20230427080351.9889-3-njavali%40marvell.com
patch subject: [PATCH 2/7] qla2xxx: Fix task management cmd failure
config: ia64-allyesconfig (https://download.01.org/0day-ci/archive/20230427/202304271802.uCZfwQC1-lkp@intel.com/config)
compiler: ia64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/c6708965eb88a81ea9d42ed583d9abe09e3a4251
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Nilesh-Javali/qla2xxx-Multi-que-support-for-TMF/20230427-160555
        git checkout c6708965eb88a81ea9d42ed583d9abe09e3a4251
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 SHELL=/bin/bash drivers/scsi/qla2xxx/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304271802.uCZfwQC1-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/scsi/qla2xxx/qla_init.c:2043:1: warning: no previous prototype for 'qla26xx_marker' [-Wmissing-prototypes]
    2043 | qla26xx_marker(struct tmf_arg *arg)
         | ^~~~~~~~~~~~~~
   drivers/scsi/qla2xxx/qla_init.c:2098:1: warning: no previous prototype for '__qla2x00_async_tm_cmd' [-Wmissing-prototypes]
    2098 | __qla2x00_async_tm_cmd(struct tmf_arg *arg)
         | ^~~~~~~~~~~~~~~~~~~~~~


vim +/qla26xx_marker +2043 drivers/scsi/qla2xxx/qla_init.c

  2041	
  2042	int
> 2043	qla26xx_marker(struct tmf_arg *arg)
  2044	{
  2045		struct scsi_qla_host *vha = arg->vha;
  2046		struct srb_iocb *tm_iocb;
  2047		srb_t *sp;
  2048		int rval = QLA_FUNCTION_FAILED;
  2049		fc_port_t *fcport = arg->fcport;
  2050	
  2051		/* ref: INIT */
  2052		sp = qla2xxx_get_qpair_sp(vha, arg->qpair, fcport, GFP_KERNEL);
  2053		if (!sp)
  2054			goto done;
  2055	
  2056		sp->type = SRB_MARKER;
  2057		sp->name = "marker";
  2058		qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha), qla_marker_sp_done);
  2059		sp->u.iocb_cmd.timeout = qla2x00_tmf_iocb_timeout;
  2060	
  2061		tm_iocb = &sp->u.iocb_cmd;
  2062		init_completion(&tm_iocb->u.tmf.comp);
  2063		tm_iocb->u.tmf.modifier = arg->modifier;
  2064		tm_iocb->u.tmf.lun = arg->lun;
  2065		tm_iocb->u.tmf.loop_id = fcport->loop_id;
  2066		tm_iocb->u.tmf.vp_index = vha->vp_idx;
  2067	
  2068		START_SP_W_RETRIES(sp, rval);
  2069	
  2070		ql_dbg(ql_dbg_taskm, vha, 0x8006,
  2071		    "Async-marker hdl=%x loop-id=%x portid=%06x modifier=%x lun=%lld qp=%d rval %d.\n",
  2072		    sp->handle, fcport->loop_id, fcport->d_id.b24,
  2073		    arg->modifier, arg->lun, sp->qpair->id, rval);
  2074	
  2075		if (rval != QLA_SUCCESS) {
  2076			ql_log(ql_log_warn, vha, 0x8031,
  2077			    "Marker IOCB failed (%x).\n", rval);
  2078			goto done_free_sp;
  2079		}
  2080	
  2081		wait_for_completion(&tm_iocb->u.tmf.comp);
  2082	
  2083	done_free_sp:
  2084		/* ref: INIT */
  2085		kref_put(&sp->cmd_kref, qla2x00_sp_release);
  2086	done:
  2087		return rval;
  2088	}
  2089	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
