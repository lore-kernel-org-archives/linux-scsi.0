Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E800A4C61
	for <linux-scsi@vger.kernel.org>; Sat, 16 Mar 2024 01:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710552872; cv=none; b=c3mTQBmb0cYeeTs1R7x6o4rrCCBo4OAqOcVo2+nOsdRT5fTe+YtPLHmJa1W/c+ZOs3uWo8dlyZeWD1vMnwhwGFh8mjPBeVW5eoy/9RrVEjsh5TmjxYibg0AWFTDupkPAi1Ynw6gVZitfWWLdtziXZC+nJyclQSDLc/SYaN4a2ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710552872; c=relaxed/simple;
	bh=SvLDBwOUqZV+K+QOlz7a+pCZMB7+vQLqmYBJsWljF7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rog66yws3BNiaXfOOG+5cStC4iegqmYbSQH5/qnjNMBzN9Q4rt17kFd109VRTssCHj2HCouZNO3UFY02OJFjHHjtprloZA38P+Ra0bcbLi5wpPn/JiZ+CNky+HAzbR0G5gHEM+VlcqNIPf6RCCw5pS/imVNeOlk4amqlLz8jWwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZBh24sYr; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZBh24sYr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710552870; x=1742088870;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SvLDBwOUqZV+K+QOlz7a+pCZMB7+vQLqmYBJsWljF7M=;
  b=ZBh24sYrev59uPoisFfrW+UbjKHQctZ6/BDLIyek68sHqGGVvkFaD3fK
   x7NegEOuifjOZnlzCPf8UrCsE3NzriWpWlVcD6gmDQbqGaHz6BSOwV2wC
   kzigv2lX2Z3DjNIldcS01F90GvJ2jwwuhAOP7gtdAEaY6NWBFBZjBD6hb
   zv9vVUw53EzJTAutH7zwcPX61P+tbyFiUAy/H+El1V4RTx28rH7+6q5Wo
   EASYrsFaOe/m0GBst3DkbEoVYHGc4UIJCzrFkaBso32+5FyLSzxhg6UW4
   7BFuXitZ1h3Gp7dHvrJBPSwsmyCRhFwmcRSQtRfWIr/HQS9iMVw65NcEU
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11014"; a="5298748"
X-IronPort-AV: E=Sophos;i="6.07,129,1708416000"; 
   d="scan'208";a="5298748"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 18:34:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,129,1708416000"; 
   d="scan'208";a="12928860"
Received: from lkp-server01.sh.intel.com (HELO b21307750695) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 15 Mar 2024 18:34:27 -0700
Received: from kbuild by b21307750695 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rlIwL-000Ewf-0T;
	Sat, 16 Mar 2024 01:34:25 +0000
Date: Sat, 16 Mar 2024 09:34:01 +0800
From: kernel test robot <lkp@intel.com>
To: Saurav Kashyap <skashyap@marvell.com>, martin.petersen@oracle.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>
Subject: Re: [PATCH 2/3] qedf: Wait for stag work during unload.
Message-ID: <202403160959.uNobO4UE-lkp@intel.com>
References: <20240315100600.19568-3-skashyap@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240315100600.19568-3-skashyap@marvell.com>

Hi Saurav,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next linus/master v6.8 next-20240315]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Saurav-Kashyap/qedf-Don-t-process-stag-work-during-unload-and-recovery/20240315-180830
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20240315100600.19568-3-skashyap%40marvell.com
patch subject: [PATCH 2/3] qedf: Wait for stag work during unload.
config: x86_64-allmodconfig (https://download.01.org/0day-ci/archive/20240316/202403160959.uNobO4UE-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240316/202403160959.uNobO4UE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202403160959.uNobO4UE-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/scsi/qedf/qedf_main.c:923:37: warning: variable 'qedf' is uninitialized when used here [-Wuninitialized]
     923 |                 clear_bit(QEDF_STAG_IN_PROGRESS, &qedf->flags);
         |                                                   ^~~~
   drivers/scsi/qedf/qedf_main.c:919:23: note: initialize the variable 'qedf' to silence this warning
     919 |         struct qedf_ctx *qedf;
         |                              ^
         |                               = NULL
   1 warning generated.


vim +/qedf +923 drivers/scsi/qedf/qedf_main.c

   915	
   916	/* Performs soft reset of qedf_ctx by simulating a link down/up */
   917	void qedf_ctx_soft_reset(struct fc_lport *lport)
   918	{
   919		struct qedf_ctx *qedf;
   920		struct qed_link_output if_link;
   921	
   922		if (lport->vport) {
 > 923			clear_bit(QEDF_STAG_IN_PROGRESS, &qedf->flags);
   924			printk_ratelimited("Cannot issue host reset on NPIV port.\n");
   925			return;
   926		}
   927	
   928		qedf = lport_priv(lport);
   929	
   930		qedf->flogi_pending = 0;
   931		/* For host reset, essentially do a soft link up/down */
   932		atomic_set(&qedf->link_state, QEDF_LINK_DOWN);
   933		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC,
   934			  "Queuing link down work.\n");
   935		queue_delayed_work(qedf->link_update_wq, &qedf->link_update,
   936		    0);
   937	
   938		if (qedf_wait_for_upload(qedf) == false) {
   939			QEDF_ERR(&qedf->dbg_ctx, "Could not upload all sessions.\n");
   940			WARN_ON(atomic_read(&qedf->num_offloads));
   941		}
   942	
   943		/* Before setting link up query physical link state */
   944		qed_ops->common->get_link(qedf->cdev, &if_link);
   945		/* Bail if the physical link is not up */
   946		if (!if_link.link_up) {
   947			QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC,
   948				  "Physical link is not up.\n");
   949			clear_bit(QEDF_STAG_IN_PROGRESS, &qedf->flags);
   950			return;
   951		}
   952		/* Flush and wait to make sure link down is processed */
   953		flush_delayed_work(&qedf->link_update);
   954		msleep(500);
   955	
   956		atomic_set(&qedf->link_state, QEDF_LINK_UP);
   957		qedf->vlan_id  = 0;
   958		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC,
   959			  "Queue link up work.\n");
   960		queue_delayed_work(qedf->link_update_wq, &qedf->link_update,
   961		    0);
   962		clear_bit(QEDF_STAG_IN_PROGRESS, &qedf->flags);
   963	}
   964	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
