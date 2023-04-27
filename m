Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95375C77B61
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Apr 2023 10:05:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243249AbjD0KFZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Apr 2023 06:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243471AbjD0KFY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Apr 2023 06:05:24 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8D04C06
        for <linux-scsi@vger.kernel.org>; Thu, 27 Apr 2023 03:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682589922; x=1714125922;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qNt6DNKR89NUnLNN49LUGqNaFj/jmQfUPGoOjATOVek=;
  b=WBqTRGGngclav8pEv8KcE58h5cY0sycCGjQRk4FbPvjkXYU4AxSAdgZx
   VmhmIfIJAuTX1F66E3Vce7M9z8XQPOwvKro8w3zhpdhT18GVcuyABSxE5
   5bnZcmguHuIqbFCl3URKsRiJLbMbk5rU5lhRoWwGBBgyLkvuWst7i0iFU
   +uZ/B/Ly9B2/9bkFzIYB5FcJHypzC5uqJrAzK1V6Ez+NCrkl4wdoNBmEs
   6OrdyijIDRwJUtA1FZA9SLD3qY8PAQIOm11lis+KbPCf00w2ka2A6ghhQ
   ApirFGtE/H5rU9Yctt0yKWukYwAWA2hcNrp5ZbHrsevxhABfv+/7DC2Cz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="344838354"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="344838354"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 03:05:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="671722563"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="671722563"
Received: from lkp-server01.sh.intel.com (HELO 1e0e07564161) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 27 Apr 2023 03:05:19 -0700
Received: from kbuild by 1e0e07564161 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pryV4-00009v-1B;
        Thu, 27 Apr 2023 10:05:18 +0000
Date:   Thu, 27 Apr 2023 18:04:35 +0800
From:   kernel test robot <lkp@intel.com>
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com, bhazarika@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com
Subject: Re: [PATCH 1/7] qla2xxx: Multi-que support for TMF
Message-ID: <202304271702.GpIL391S-lkp@intel.com>
References: <20230427080351.9889-2-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427080351.9889-2-njavali@marvell.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Nilesh,

kernel test robot noticed the following build warnings:

[auto build test WARNING on c8e22b7a1694bb8d025ea636816472739d859145]

url:    https://github.com/intel-lab-lkp/linux/commits/Nilesh-Javali/qla2xxx-Multi-que-support-for-TMF/20230427-160555
base:   c8e22b7a1694bb8d025ea636816472739d859145
patch link:    https://lore.kernel.org/r/20230427080351.9889-2-njavali%40marvell.com
patch subject: [PATCH 1/7] qla2xxx: Multi-que support for TMF
config: ia64-allyesconfig (https://download.01.org/0day-ci/archive/20230427/202304271702.GpIL391S-lkp@intel.com/config)
compiler: ia64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/b9e8bdc4cd77acae5886c7c447d34d898bd1d821
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Nilesh-Javali/qla2xxx-Multi-que-support-for-TMF/20230427-160555
        git checkout b9e8bdc4cd77acae5886c7c447d34d898bd1d821
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 SHELL=/bin/bash drivers/scsi/qla2xxx/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304271702.GpIL391S-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/scsi/qla2xxx/qla_init.c:2024:1: warning: no previous prototype for '__qla2x00_async_tm_cmd' [-Wmissing-prototypes]
    2024 | __qla2x00_async_tm_cmd(struct tmf_arg *arg)
         | ^~~~~~~~~~~~~~~~~~~~~~


vim +/__qla2x00_async_tm_cmd +2024 drivers/scsi/qla2xxx/qla_init.c

  2022	
  2023	int
> 2024	__qla2x00_async_tm_cmd(struct tmf_arg *arg)
  2025	{
  2026		struct scsi_qla_host *vha = arg->vha;
  2027		struct srb_iocb *tm_iocb;
  2028		srb_t *sp;
  2029		unsigned long flags;
  2030		int rval = QLA_FUNCTION_FAILED;
  2031	
  2032		fc_port_t *fcport = arg->fcport;
  2033	
  2034		/* ref: INIT */
  2035		sp = qla2xxx_get_qpair_sp(vha, arg->qpair, fcport, GFP_KERNEL);
  2036		if (!sp)
  2037			goto done;
  2038	
  2039		qla_vha_mark_busy(vha);
  2040		sp->type = SRB_TM_CMD;
  2041		sp->name = "tmf";
  2042		qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha),
  2043				      qla2x00_tmf_sp_done);
  2044		sp->u.iocb_cmd.timeout = qla2x00_tmf_iocb_timeout;
  2045	
  2046		tm_iocb = &sp->u.iocb_cmd;
  2047		init_completion(&tm_iocb->u.tmf.comp);
  2048		tm_iocb->u.tmf.flags = arg->flags;
  2049		tm_iocb->u.tmf.lun = arg->lun;
  2050	
  2051		rval = qla2x00_start_sp(sp);
  2052		ql_dbg(ql_dbg_taskm, vha, 0x802f,
  2053		    "Async-tmf hdl=%x loop-id=%x portid=%02x%02x%02x ctrl=%x.\n",
  2054		    sp->handle, fcport->loop_id, fcport->d_id.b.domain,
  2055		    fcport->d_id.b.area, fcport->d_id.b.al_pa, arg->flags);
  2056	
  2057		if (rval != QLA_SUCCESS)
  2058			goto done_free_sp;
  2059		wait_for_completion(&tm_iocb->u.tmf.comp);
  2060	
  2061		rval = tm_iocb->u.tmf.data;
  2062	
  2063		if (rval != QLA_SUCCESS) {
  2064			ql_log(ql_log_warn, vha, 0x8030,
  2065			    "TM IOCB failed (%x).\n", rval);
  2066		}
  2067	
  2068		if (!test_bit(UNLOADING, &vha->dpc_flags) && !IS_QLAFX00(vha->hw)) {
  2069			flags = tm_iocb->u.tmf.flags;
  2070			if (flags & (TCF_LUN_RESET|TCF_ABORT_TASK_SET|
  2071				TCF_CLEAR_TASK_SET|TCF_CLEAR_ACA))
  2072				flags = MK_SYNC_ID_LUN;
  2073			else
  2074				flags = MK_SYNC_ID;
  2075	
  2076			qla2x00_marker(vha, sp->qpair,
  2077			    sp->fcport->loop_id, arg->lun, flags);
  2078		}
  2079	
  2080	done_free_sp:
  2081		/* ref: INIT */
  2082		kref_put(&sp->cmd_kref, qla2x00_sp_release);
  2083	done:
  2084		return rval;
  2085	}
  2086	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
