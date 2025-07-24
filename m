Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B356D281503;
	Thu, 24 Jul 2025 14:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753367195; cv=none; b=qd6OQO24dF8bsn69sOW7fKK09ovrUe/uW4fgu4Lpa7SfAm9wCpDc6y2kLAp0snU5OLKxIvIh485tcZRtGfBEIouW+J2qH+mZahUiGpJfdbw9ckuOL7GbTbVczpaCHss/UbeqaFZF8kNLQriwAdsqqk2+4tEYd9nIsx2QD05ViNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753367195; c=relaxed/simple;
	bh=3CSY5vdms7jSUG4+v5OJbEWth23RsnZgcHvbkL+j4oM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gBDvXvmtUVEDjhn++1TavjDwdbIBMyoHjvPO5caw1oZMLvzMKxvYjlWinzXOdh7g2USKJj7yJ0qZ+urIlBUDYCA/E9HBx7CfztBQXOaZ42zSO4tuf8LQn99rsfOJu2WIz+Q8ooLdEUGNITf3sYLqLY2EfhghpdohiFt4mGjPCC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LykvnjH1; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LykvnjH1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753367194; x=1784903194;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3CSY5vdms7jSUG4+v5OJbEWth23RsnZgcHvbkL+j4oM=;
  b=LykvnjH1GFO5Ss679IcQ8iBp0jQRuNiec3QT+hioOHlEiE6M0pYzRdTE
   RdGLB2RWrNB27LyKl0Ahkr0AzD2K6+JmxPAd8T4UeZUMbPIf92MJav2XW
   2AXtU7mA12pxxcSB8aDqwdag/tM5bj7WPEq6ZkxaWHHbO6wdeKMePVqgG
   xf1EILdYj2gB4czfES3rY0UJi77D8q0pJbWa3mVQBIygUXSUnr9OhtHaQ
   VyITuV5qMtq+9ukB+94P5hEYAz5GckEH4x4+qH3/sezo9umYmPK09HP6v
   3P+pTanB10fBHjm8C5vhu+vZSwbkf1TBA/Iua6odnlIlezBFF1ZCwuE63
   Q==;
X-CSE-ConnectionGUID: MR6LmlFdSuyjV+8NJ7pKFw==
X-CSE-MsgGUID: 1MzJFaFDQVOuxoK2oYnqUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="59489154"
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="59489154"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 07:26:34 -0700
X-CSE-ConnectionGUID: uVv4DPLUQMundO0upcPk0A==
X-CSE-MsgGUID: 2HqY5NtaQCy4Rw2QcF2oOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="160568627"
Received: from lkp-server01.sh.intel.com (HELO 9ee84586c615) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 24 Jul 2025 07:26:31 -0700
Received: from kbuild by 9ee84586c615 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uewtx-000KWN-1u;
	Thu, 24 Jul 2025 14:26:29 +0000
Date: Thu, 24 Jul 2025 22:26:13 +0800
From: kernel test robot <lkp@intel.com>
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>
Subject: Re: [PATCH 1/1] scsi: target: Move LUN stats to per CPU
Message-ID: <202507242247.rt3StU9U-lkp@intel.com>
References: <20250724004558.40993-1-michael.christie@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724004558.40993-1-michael.christie@oracle.com>

Hi Mike,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next linus/master v6.16-rc7 next-20250724]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mike-Christie/scsi-target-Move-LUN-stats-to-per-CPU/20250724-084852
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20250724004558.40993-1-michael.christie%40oracle.com
patch subject: [PATCH 1/1] scsi: target: Move LUN stats to per CPU
config: sparc64-randconfig-001-20250724 (https://download.01.org/0day-ci/archive/20250724/202507242247.rt3StU9U-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250724/202507242247.rt3StU9U-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507242247.rt3StU9U-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/target/target_core_tpg.c: In function 'core_tpg_alloc_lun':
>> drivers/target/target_core_tpg.c:612:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
     int ret;
         ^~~


vim +/ret +612 drivers/target/target_core_tpg.c

   606	
   607	struct se_lun *core_tpg_alloc_lun(
   608		struct se_portal_group *tpg,
   609		u64 unpacked_lun)
   610	{
   611		struct se_lun *lun;
 > 612		int ret;
   613	
   614		lun = kzalloc(sizeof(*lun), GFP_KERNEL);
   615		if (!lun) {
   616			pr_err("Unable to allocate se_lun memory\n");
   617			return ERR_PTR(-ENOMEM);
   618		}
   619	
   620		lun->lun_stats = alloc_percpu(struct scsi_port_stats);
   621		if (!lun->lun_stats) {
   622			pr_err("Unable to allocate se_lun stats memory\n");
   623			ret = -ENOMEM;
   624			goto free_lun;
   625		}
   626	
   627		lun->unpacked_lun = unpacked_lun;
   628		atomic_set(&lun->lun_acl_count, 0);
   629		init_completion(&lun->lun_shutdown_comp);
   630		INIT_LIST_HEAD(&lun->lun_deve_list);
   631		INIT_LIST_HEAD(&lun->lun_dev_link);
   632		atomic_set(&lun->lun_tg_pt_secondary_offline, 0);
   633		spin_lock_init(&lun->lun_deve_lock);
   634		mutex_init(&lun->lun_tg_pt_md_mutex);
   635		INIT_LIST_HEAD(&lun->lun_tg_pt_gp_link);
   636		spin_lock_init(&lun->lun_tg_pt_gp_lock);
   637		lun->lun_tpg = tpg;
   638	
   639		return lun;
   640	
   641	free_lun:
   642		kfree(lun);
   643		return ERR_PTR(-ENOMEM);
   644	}
   645	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
