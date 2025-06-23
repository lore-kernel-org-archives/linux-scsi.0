Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24ED25F785;
	Mon, 23 Jun 2025 19:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750707429; cv=none; b=S4b//n5m/n+xjo7vjwBQzut2uGTta3JsInK1Nzp+/sd2A+JoGsEcyXSvTtkC+qpUsQSrId1lIcMmTbppYem5q7dGme4vE4m+eiLUXAJYsmeoipUxLAhKrixJa4ptCuTSfJQEpV2hoiR669ChP+UWnLpTxKZATXbAYWNik6wgeGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750707429; c=relaxed/simple;
	bh=v0l/kSzCzkRAEF3IzVpd0mV4Pu1tdJw3rT6WoxwZPY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bMgHBiwVTQTdxSnKWcU9VsymSDfqlUhnwDI1/jcH0YoqyKw6c1+7RZt5o2eCyrXDSpsYSX8eOuQrHh7Z86jt4pyzeuEsP3aR8E84vEQKfZmdTysb3xgxj2PAMzDWY9+bonL7wQBemD2nejRGc/DStJiYPDlyfW+xpbFiv57uvYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=niKVLOnG; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="niKVLOnG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750707427; x=1782243427;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=v0l/kSzCzkRAEF3IzVpd0mV4Pu1tdJw3rT6WoxwZPY4=;
  b=niKVLOnGwHimya2jYC3V8sq7P24vcy7aAh1qXfvXrA71BgIaVgL+hkLo
   WKb1wf/PqFfzwZtBI7J/Y7o8f/Mu/pVE8qgAMc4d5PySQovf1jKe0Zk0S
   woc+UfGjlsaTBIK8KatsESA1fAfgWJW+SvMRXBsmI+Y9E/+Uo64XcR7td
   8YyYblPN1TqDBCpJQV+pJ5EmFu/l+cEfSrmWCLzsf3DimH4BMod9H8beH
   CZfORE302AJCvsJBBKHy3QnHakm6ghvzv0LeDA8+MBK9RrCxOyzOOT/ML
   aOZ3akLLsIKzmBS6us/LEd0uAX6oIGW/uehTzRd78z1AZGX+i6/UstgCC
   w==;
X-CSE-ConnectionGUID: ilQYy/3nSpqfJjcpBScBSQ==
X-CSE-MsgGUID: 4O8AYm+jSMiJIdhgOwo9Pg==
X-IronPort-AV: E=McAfee;i="6800,10657,11473"; a="52800151"
X-IronPort-AV: E=Sophos;i="6.16,259,1744095600"; 
   d="scan'208";a="52800151"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2025 12:37:07 -0700
X-CSE-ConnectionGUID: cTsP7YDzSFigZVnd5INv8Q==
X-CSE-MsgGUID: EQwVesj3QDCai1JUp/ZuUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,259,1744095600"; 
   d="scan'208";a="151840786"
Received: from lkp-server01.sh.intel.com (HELO e8142ee1dce2) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 23 Jun 2025 12:37:04 -0700
Received: from kbuild by e8142ee1dce2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uTmyU-000PGg-0D;
	Mon, 23 Jun 2025 19:37:02 +0000
Date: Tue, 24 Jun 2025 03:36:23 +0800
From: kernel test robot <lkp@intel.com>
To: jackysliu <1972843537@qq.com>, skashyap@marvell.com
Cc: oe-kbuild-all@lists.linux.dev, jhasan@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	jackysliu <1972843537@qq.com>
Subject: Re: [PATCH] scsi: qedf: Fix a possible memory leak in
 qedf_prepare_sb()
Message-ID: <202506240340.fv6cXpyc-lkp@intel.com>
References: <tencent_3C5078D216712F6F21FC8792FADED59A3D09@qq.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_3C5078D216712F6F21FC8792FADED59A3D09@qq.com>

Hi jackysliu,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v6.16-rc3 next-20250623]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/jackysliu/scsi-qedf-Fix-a-possible-memory-leak-in-qedf_prepare_sb/20250617-180032
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/tencent_3C5078D216712F6F21FC8792FADED59A3D09%40qq.com
patch subject: [PATCH] scsi: qedf: Fix a possible memory leak in qedf_prepare_sb()
config: i386-randconfig-141-20250623 (https://download.01.org/0day-ci/archive/20250624/202506240340.fv6cXpyc-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202506240340.fv6cXpyc-lkp@intel.com/

New smatch warnings:
drivers/scsi/qedf/qedf_main.c:2814 qedf_prepare_sb() warn: inconsistent indenting

Old smatch warnings:
drivers/scsi/qedf/qedf_main.c:2816 qedf_prepare_sb() warn: inconsistent indenting

vim +2814 drivers/scsi/qedf/qedf_main.c

  2773	
  2774	static int qedf_prepare_sb(struct qedf_ctx *qedf)
  2775	{
  2776		int id;
  2777		struct qedf_fastpath *fp;
  2778		int ret;
  2779	
  2780		qedf->fp_array =
  2781		    kcalloc(qedf->num_queues, sizeof(struct qedf_fastpath),
  2782			GFP_KERNEL);
  2783	
  2784		if (!qedf->fp_array) {
  2785			QEDF_ERR(&(qedf->dbg_ctx), "fastpath array allocation "
  2786				  "failed.\n");
  2787			return -ENOMEM;
  2788		}
  2789	
  2790		for (id = 0; id < qedf->num_queues; id++) {
  2791			fp = &(qedf->fp_array[id]);
  2792			fp->sb_id = QEDF_SB_ID_NULL;
  2793			fp->sb_info = kcalloc(1, sizeof(*fp->sb_info), GFP_KERNEL);
  2794			if (!fp->sb_info) {
  2795				QEDF_ERR(&(qedf->dbg_ctx), "SB info struct "
  2796					  "allocation failed.\n");
  2797				goto err;
  2798			}
  2799			ret = qedf_alloc_and_init_sb(qedf, fp->sb_info, id);
  2800			if (ret) {
  2801				QEDF_ERR(&(qedf->dbg_ctx), "SB allocation and "
  2802					  "initialization failed.\n");
  2803				goto err;
  2804			}
  2805			fp->sb_id = id;
  2806			fp->qedf = qedf;
  2807			fp->cq_num_entries =
  2808			    qedf->global_queues[id]->cq_mem_size /
  2809			    sizeof(struct fcoe_cqe);
  2810		}
  2811	err:
  2812	for (int i = 0; i < id; i++) {
  2813		fp = &qedf->fp_array[i];
> 2814	if (fp->sb_info) {
  2815		qedf_free_sb(qedf, fp->sb_info);
  2816	kfree(fp->sb_info);
  2817	fp->sb_info = NULL;
  2818	}
  2819	}
  2820	kfree(qedf->fp_array);
  2821	qedf->fp_array = NULL;
  2822	return -ENOMEM;
  2823	}
  2824	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
