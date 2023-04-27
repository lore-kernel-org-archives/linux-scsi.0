Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A770C77B61
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Apr 2023 11:49:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243433AbjD0Lt0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Apr 2023 07:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242961AbjD0LtZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Apr 2023 07:49:25 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1E8E7
        for <linux-scsi@vger.kernel.org>; Thu, 27 Apr 2023 04:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682596163; x=1714132163;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=z2dWalpLD+qOjw0gB9Smg1m1h51jUqcpx9j78IhlTZg=;
  b=QWZ9745Mgo4LaER1ZPgElFEMC4kxSthj4HYPFwAt2czkDRa0RBu1U3/Y
   OTmuTDkEVWAhuqEPfxuhQkESHDC0i9D4UonCoa9Oe7X3QSL8iVH50ssVt
   fgj9GzvXKStzAn1Ini+ODOjrKSbVDbBDQl8VVb/2bqDK1xMexK4VGu77z
   PHZtGa0AaEeNnLnewYR9cdBRua9DisC8R9w2mq8WKXAoETCNHdY3u8rgj
   jE4/yi5cQrG2V0B3VVdejJBcC2e8mQjmXy03a53d6FWNiREHYKiMRVXE8
   khLjblo8eeh1eQJ2x7VRcY1CbcX88wkyLNjqPXlP6q8D+4w5q0jG9IVog
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="410441357"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="410441357"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 04:49:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="818500012"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="818500012"
Received: from lkp-server01.sh.intel.com (HELO 1e0e07564161) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 27 Apr 2023 04:49:21 -0700
Received: from kbuild by 1e0e07564161 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1ps07k-0000Cj-13;
        Thu, 27 Apr 2023 11:49:20 +0000
Date:   Thu, 27 Apr 2023 19:48:59 +0800
From:   kernel test robot <lkp@intel.com>
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com, bhazarika@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com
Subject: Re: [PATCH 3/7] qla2xxx: Fix task management cmd fail due to
 unavailable resource
Message-ID: <202304271952.NKNmoFzv-lkp@intel.com>
References: <20230427080351.9889-4-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427080351.9889-4-njavali@marvell.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Nilesh,

kernel test robot noticed the following build warnings:

[auto build test WARNING on c8e22b7a1694bb8d025ea636816472739d859145]

url:    https://github.com/intel-lab-lkp/linux/commits/Nilesh-Javali/qla2xxx-Multi-que-support-for-TMF/20230427-160555
base:   c8e22b7a1694bb8d025ea636816472739d859145
patch link:    https://lore.kernel.org/r/20230427080351.9889-4-njavali%40marvell.com
patch subject: [PATCH 3/7] qla2xxx: Fix task management cmd fail due to unavailable resource
config: ia64-allyesconfig (https://download.01.org/0day-ci/archive/20230427/202304271952.NKNmoFzv-lkp@intel.com/config)
compiler: ia64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/ea97bb99e7ceb449ede36ec249341061982a7f11
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Nilesh-Javali/qla2xxx-Multi-que-support-for-TMF/20230427-160555
        git checkout ea97bb99e7ceb449ede36ec249341061982a7f11
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 SHELL=/bin/bash drivers/scsi/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304271952.NKNmoFzv-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/scsi/qla2xxx/qla_init.c:2043:1: warning: no previous prototype for 'qla26xx_marker' [-Wmissing-prototypes]
    2043 | qla26xx_marker(struct tmf_arg *arg)
         | ^~~~~~~~~~~~~~
   drivers/scsi/qla2xxx/qla_init.c:2098:1: warning: no previous prototype for '__qla2x00_async_tm_cmd' [-Wmissing-prototypes]
    2098 | __qla2x00_async_tm_cmd(struct tmf_arg *arg)
         | ^~~~~~~~~~~~~~~~~~~~~~
>> drivers/scsi/qla2xxx/qla_init.c:2152:6: warning: no previous prototype for 'qla_put_tmf' [-Wmissing-prototypes]
    2152 | void qla_put_tmf(fc_port_t *fcport)
         |      ^~~~~~~~~~~


vim +/qla_put_tmf +2152 drivers/scsi/qla2xxx/qla_init.c

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
  2090	static void qla2x00_tmf_sp_done(srb_t *sp, int res)
  2091	{
  2092		struct srb_iocb *tmf = &sp->u.iocb_cmd;
  2093	
  2094		complete(&tmf->u.tmf.comp);
  2095	}
  2096	
  2097	int
  2098	__qla2x00_async_tm_cmd(struct tmf_arg *arg)
  2099	{
  2100		struct scsi_qla_host *vha = arg->vha;
  2101		struct srb_iocb *tm_iocb;
  2102		srb_t *sp;
  2103		int rval = QLA_FUNCTION_FAILED;
  2104	
  2105		fc_port_t *fcport = arg->fcport;
  2106	
  2107		/* ref: INIT */
  2108		sp = qla2xxx_get_qpair_sp(vha, arg->qpair, fcport, GFP_KERNEL);
  2109		if (!sp)
  2110			goto done;
  2111	
  2112		qla_vha_mark_busy(vha);
  2113		sp->type = SRB_TM_CMD;
  2114		sp->name = "tmf";
  2115		qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha),
  2116				      qla2x00_tmf_sp_done);
  2117		sp->u.iocb_cmd.timeout = qla2x00_tmf_iocb_timeout;
  2118	
  2119		tm_iocb = &sp->u.iocb_cmd;
  2120		init_completion(&tm_iocb->u.tmf.comp);
  2121		tm_iocb->u.tmf.flags = arg->flags;
  2122		tm_iocb->u.tmf.lun = arg->lun;
  2123	
  2124		START_SP_W_RETRIES(sp, rval);
  2125	
  2126		ql_dbg(ql_dbg_taskm, vha, 0x802f,
  2127		    "Async-tmf hdl=%x loop-id=%x portid=%06x ctrl=%x lun=%lld qp=%d rval=%x.\n",
  2128		    sp->handle, fcport->loop_id, fcport->d_id.b24,
  2129		    arg->flags, arg->lun, sp->qpair->id, rval);
  2130	
  2131		if (rval != QLA_SUCCESS)
  2132			goto done_free_sp;
  2133		wait_for_completion(&tm_iocb->u.tmf.comp);
  2134	
  2135		rval = tm_iocb->u.tmf.data;
  2136	
  2137		if (rval != QLA_SUCCESS) {
  2138			ql_log(ql_log_warn, vha, 0x8030,
  2139			    "TM IOCB failed (%x).\n", rval);
  2140		}
  2141	
  2142		if (!test_bit(UNLOADING, &vha->dpc_flags) && !IS_QLAFX00(vha->hw))
  2143			rval = qla26xx_marker(arg);
  2144	
  2145	done_free_sp:
  2146		/* ref: INIT */
  2147		kref_put(&sp->cmd_kref, qla2x00_sp_release);
  2148	done:
  2149		return rval;
  2150	}
  2151	
> 2152	void qla_put_tmf(fc_port_t *fcport)
  2153	{
  2154		struct scsi_qla_host *vha = fcport->vha;
  2155		struct qla_hw_data *ha = vha->hw;
  2156		unsigned long flags;
  2157	
  2158		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
  2159		fcport->active_tmf--;
  2160		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
  2161	}
  2162	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
