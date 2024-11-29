Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBD41A0B04;
	Fri, 29 Nov 2024 21:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732914418; cv=none; b=KO3kV2GEqhyRXJr4TSnjkPd4AggAR7vvPrfPaP+9ABJVJl6xQOamU9X9fR9lxJypxmDVUgPi/9J1ko44OHTTXkewq6PitlQOodN58yksrNXhQ6M/V5/NcxWCL4YoAHHoA8VwvhDjALB72+jdulXZ90FxMNBmqof4labpmwDJ2G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732914418; c=relaxed/simple;
	bh=KNG0fF7kHb67K3poJypspiJ6k0hHbpJD5se9XikRlWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sh8j/hqp64lmX78ZmEhcTiTwpxkdU+ICJ2XVG2OfjuIx0d6XPX9KVX3406c6WzdMutO02auttpqWoVd43B23oPLfFeCC8ov5vlDrZA5ak0w21XJWhg8IeXifHbEzFxW8yUEC54fKH3eOltMWJoD6cyxNZzY13RM9IWtmnt4P6RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PdsCuOi6; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PdsCuOi6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732914417; x=1764450417;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KNG0fF7kHb67K3poJypspiJ6k0hHbpJD5se9XikRlWc=;
  b=PdsCuOi6leuU1q4OjwiUOYpxwjz1cJ2I7OlNdrU1lWFL2XCZbt4dwURZ
   UHOgLgf3nbR2jmHNqZx7AkJ69rdKOQ1Iqo1HmVTrtLNM/JkoK2Uei/G5F
   Z3TmkeSFGYLf9w3ryfpzgcDEnyxlZDifTgoTerp9zEdCvykXkzE9COul6
   WJUcrfzE5jDLnRTknmZiYEfoayzWTg7aZ003IOLAtO72xZaLfxveZzx/M
   xVAZ6ceojTryayU2owtVcVF+KPNBqFCEvVYQyeemg2rxbFufaECFAfFiK
   /O2T1CRI89T0rfQ/sgt4sRNk0TyjN6MPXBN6QPxXVSiuDgvEQpQ7ktNFl
   g==;
X-CSE-ConnectionGUID: oCp59g/IS+enb7X7+tawMg==
X-CSE-MsgGUID: bx21potkRvCH1gdpW7TWrg==
X-IronPort-AV: E=McAfee;i="6700,10204,11271"; a="36012870"
X-IronPort-AV: E=Sophos;i="6.12,196,1728975600"; 
   d="scan'208";a="36012870"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2024 13:06:56 -0800
X-CSE-ConnectionGUID: IUqO8ZEbRTykY1960/vQ6g==
X-CSE-MsgGUID: /1sWLacUT9q2I+hnm1zdJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,196,1728975600"; 
   d="scan'208";a="92480813"
Received: from lkp-server01.sh.intel.com (HELO 5e2646291792) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 29 Nov 2024 13:06:54 -0800
Received: from kbuild by 5e2646291792 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tH8CR-0000hJ-0l;
	Fri, 29 Nov 2024 21:06:51 +0000
Date: Sat, 30 Nov 2024 05:05:54 +0800
From: kernel test robot <lkp@intel.com>
To: Anastasia Kovaleva <a.kovaleva@yadro.com>, martin.petersen@oracle.com,
	bootc@bootc.net, bostroesser@gmail.com, michael.christie@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, linux@yadro.com
Subject: Re: [PATCH 08/10] target: core: Use extended logs where possible
Message-ID: <202411300419.umKHNg4I-lkp@intel.com>
References: <20241129153056.6985-9-a.kovaleva@yadro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241129153056.6985-9-a.kovaleva@yadro.com>

Hi Anastasia,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on linus/master next-20241128]
[cannot apply to v6.12]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Anastasia-Kovaleva/target-core-Improve-SCSI-target-logs/20241129-234412
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20241129153056.6985-9-a.kovaleva%40yadro.com
patch subject: [PATCH 08/10] target: core: Use extended logs where possible
config: arc-randconfig-001-20241130 (https://download.01.org/0day-ci/archive/20241130/202411300419.umKHNg4I-lkp@intel.com/config)
compiler: arc-elf-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241130/202411300419.umKHNg4I-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411300419.umKHNg4I-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/target/target_core_pr.c:75:26: warning: 'pr_preempt_type_table_str' defined but not used [-Wunused-const-variable=]
      75 | static const char *const pr_preempt_type_table_str[] = {
         |                          ^~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/target/target_core_pr.c:64:26: warning: 'pr_register_type_table_str' defined but not used [-Wunused-const-variable=]
      64 | static const char *const pr_register_type_table_str[] = {
         |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/pr_preempt_type_table_str +75 drivers/target/target_core_pr.c

    63	
  > 64	static const char *const pr_register_type_table_str[] = {
    65		"REGISTER",
    66		"REGISTER_AND_IGNORE_EXISTING_KEY",
    67		"REGISTER_AND_MOVE",
    68	};
    69	
    70	enum preempt_type {
    71		PREEMPT,
    72		PREEMPT_AND_ABORT,
    73	};
    74	
  > 75	static const char *const pr_preempt_type_table_str[] = {
    76		"PREEMPT",
    77		"PREEMPT_AND_ABORT",
    78	};
    79	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
