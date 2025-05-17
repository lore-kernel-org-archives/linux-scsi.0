Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0A17A13A;
	Sat, 17 May 2025 05:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747459752; cv=none; b=cjWXN7oGLlBc7VOeW/lpDd46A6GMzga478B6LRndgg4tUG2zN8Nzz63jKGY3l8gw55sZGspdoPAPaYU5v62oDypmKRTMOzOO6bjMgrRPJ7N1xbjGjz8uY3Yvi6A82Olo+5YZ3gYDFTmXUMC2S0ynpNM02RKDEbODL7LTLnO2swc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747459752; c=relaxed/simple;
	bh=QHtTyWCABC/4jueRIsDSnE4V++TqQGVuI532zaEvZmk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GWFfxSM+W5td2+pbY4jCGnyezyI5+KdafrsMla61QwCixI6+2WpB20YGlM6Pi6YNQ2TjsylFab7j67rcOfce+pqrCA+0RWuEJGX6gi3fbn/FtRD+qU/JLtkEohwtG3mS+tPJ3Idx2HjAin5yWnoL/vQ5oLvfdWzymg8FUuowjBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oIHWcGrC; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oIHWcGrC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747459750; x=1778995750;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QHtTyWCABC/4jueRIsDSnE4V++TqQGVuI532zaEvZmk=;
  b=oIHWcGrC47r2PNuTWI39aG/42Nb9faZ0hM5hSVKSgeG6xEnEEUETXZxg
   PcGKXmjjM5vOteoQffea+6eEvzO025rxb2yBlmHqKb9iMiaGgXTiwdTxv
   O5lp/3XlJvXiI6YtCiAd+LJqT1GMed9vJb0baAiYcLFIRCU4PUUVdSFZs
   wh2IoMFRJpeA+rSbs3Dzd/sRpu5OqkzAoCAQksFId7Ru+6k0OHVlSjeUu
   XecS2yGkpdLl2fXtrx80K22oAmGOVBL9AGhvpBrev+QgokusDkJEigq2+
   67Ao5fUFD/l+ebQmgPSyfCZLHl+kNfDOk8tMg9K96zB8Tg6s59upF2Mly
   A==;
X-CSE-ConnectionGUID: TQoOVygfQjudHwjxDUcO5g==
X-CSE-MsgGUID: CFzHxUCHThqjBouczhOeVw==
X-IronPort-AV: E=McAfee;i="6700,10204,11435"; a="60092153"
X-IronPort-AV: E=Sophos;i="6.15,296,1739865600"; 
   d="scan'208";a="60092153"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 22:29:09 -0700
X-CSE-ConnectionGUID: ZHnUcQmRQ56m+ohm6iOk/w==
X-CSE-MsgGUID: TyCXuBZvQSyTPLBA1ZStDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,296,1739865600"; 
   d="scan'208";a="143864931"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 16 May 2025 22:29:06 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uGA6Z-000Jx5-2E;
	Sat, 17 May 2025 05:29:03 +0000
Date: Sat, 17 May 2025 13:28:22 +0800
From: kernel test robot <lkp@intel.com>
To: "ping.gao" <ping.gao@samsung.com>, alim.akhtar@samsung.com,
	avri.altman@wdc.com, bvanassche@acm.org,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	peter.wang@mediatek.com, minwoo.im@samsung.com,
	manivannan.sadhasivam@linaro.org, chenyuan0y@gmail.com,
	cw9316.lee@samsung.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] scsi: ufs: mcq: delete ufshcd_release_scsi_cmd in
 ufshcd_mcq_abort
Message-ID: <202505171237.VZSTTv75-lkp@intel.com>
References: <20250516083812.3894396-1-ping.gao@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250516083812.3894396-1-ping.gao@samsung.com>

Hi ping.gao,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v6.15-rc6 next-20250516]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/ping-gao/scsi-ufs-mcq-delete-ufshcd_release_scsi_cmd-in-ufshcd_mcq_abort/20250516-163807
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20250516083812.3894396-1-ping.gao%40samsung.com
patch subject: [PATCH] scsi: ufs: mcq: delete ufshcd_release_scsi_cmd in ufshcd_mcq_abort
config: arm-randconfig-004-20250517 (https://download.01.org/0day-ci/archive/20250517/202505171237.VZSTTv75-lkp@intel.com/config)
compiler: clang version 21.0.0git (https://github.com/llvm/llvm-project f819f46284f2a79790038e1f6649172789734ae8)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250517/202505171237.VZSTTv75-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505171237.VZSTTv75-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/ufs/core/ufs-mcq.c:677:16: warning: unused variable 'flags' [-Wunused-variable]
     677 |         unsigned long flags;
         |                       ^~~~~
   1 warning generated.


vim +/flags +677 drivers/ufs/core/ufs-mcq.c

f1304d4420777f Bao D. Nguyen   2023-05-29  663  
f1304d4420777f Bao D. Nguyen   2023-05-29  664  /**
f1304d4420777f Bao D. Nguyen   2023-05-29  665   * ufshcd_mcq_abort - Abort the command in MCQ.
317a38045ab763 Yang Li         2023-07-12  666   * @cmd: The command to be aborted.
f1304d4420777f Bao D. Nguyen   2023-05-29  667   *
3a17fefe0f1960 Bart Van Assche 2023-07-27  668   * Return: SUCCESS or FAILED error codes
f1304d4420777f Bao D. Nguyen   2023-05-29  669   */
f1304d4420777f Bao D. Nguyen   2023-05-29  670  int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
f1304d4420777f Bao D. Nguyen   2023-05-29  671  {
f1304d4420777f Bao D. Nguyen   2023-05-29  672  	struct Scsi_Host *host = cmd->device->host;
f1304d4420777f Bao D. Nguyen   2023-05-29  673  	struct ufs_hba *hba = shost_priv(host);
f1304d4420777f Bao D. Nguyen   2023-05-29  674  	int tag = scsi_cmd_to_rq(cmd)->tag;
f1304d4420777f Bao D. Nguyen   2023-05-29  675  	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
f1304d4420777f Bao D. Nguyen   2023-05-29  676  	struct ufs_hw_queue *hwq;
27900d7119c464 Peter Wang      2023-11-06 @677  	unsigned long flags;

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
