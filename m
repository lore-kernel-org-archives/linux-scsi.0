Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E1914A4DD;
	Fri, 29 Nov 2024 22:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732918144; cv=none; b=n2j+vYOq0zBeS2IMjrEafibgvDxkBLJ/CIn2sQKE1KldVfxSYp++qIdGDnT3Wo+Xgz6z1/HbOoxBuvu44GQPEryyWiUAgZBpDBaoho+wFnM6ecZ/oGYXRyVxAkCIk9D4zfm7nZsls2GwcxTbpOEatjvL4F81KSCqk1QFvRHVgl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732918144; c=relaxed/simple;
	bh=oqhOF5Lt4O6T+qRNTx4oFZ055WA+4DxRG8bTeRQGq58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AcL/fjRdMjOvHO81Jr+Inr9c1OuIOvdvpGv9GJwsak4PMriS9AKd/BgW+eP0Wm4JM9u5Tpbl6ZeJxS+ZK1WgTenvr28XULVAxThCbrXTUuqGo133Osmbd3PQxRBbyhFSuESmrGAALc1hJ/j67HbXmv3nsWJLAFftV92e7dWfAvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FBNWCe5n; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FBNWCe5n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732918142; x=1764454142;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oqhOF5Lt4O6T+qRNTx4oFZ055WA+4DxRG8bTeRQGq58=;
  b=FBNWCe5nsn/yPcQ71GkiRcbpZq1Xe8MBan9KNfsNdiCHVbC9zhiztr3x
   oue7fKT1cFttplw2WoXACHNfAGZH65vdviGbMJHQzH6n8F0FPJ2Q3A+rv
   NESlOnRjzcnUIIb1fzfuvG11R/sUabHIpZT5cUdYLOMveVisJ74EPU/dW
   QgZlLf30K1O5egaglA4toDPCkb3cw7lcgeGuv3bz7csUj1so9n7Y+l/gr
   GdNmyFUdiyYB4zH1To8ozG7zf/SSPJsG2J5HSPSEjd9yJQejDdD6v1NhO
   NycYOhNKpZifCcVMbnt+VnmrX6eGeezBdhoOvBL8rk9UudLjhcQwe3eNb
   A==;
X-CSE-ConnectionGUID: gnoBITgARU2TH7YVP0jfPg==
X-CSE-MsgGUID: L71UBOklQf2nhYhcTOHn9w==
X-IronPort-AV: E=McAfee;i="6700,10204,11271"; a="55645267"
X-IronPort-AV: E=Sophos;i="6.12,196,1728975600"; 
   d="scan'208";a="55645267"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2024 14:09:01 -0800
X-CSE-ConnectionGUID: HjSoeJ9gSNeckpf0yApgCA==
X-CSE-MsgGUID: iTdoGfo2SMCrgWn1laVL4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,196,1728975600"; 
   d="scan'208";a="93048915"
Received: from lkp-server01.sh.intel.com (HELO 5e2646291792) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 29 Nov 2024 14:08:58 -0800
Received: from kbuild by 5e2646291792 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tH9AW-0000jJ-0S;
	Fri, 29 Nov 2024 22:08:56 +0000
Date: Sat, 30 Nov 2024 06:08:21 +0800
From: kernel test robot <lkp@intel.com>
To: Anastasia Kovaleva <a.kovaleva@yadro.com>, martin.petersen@oracle.com,
	bootc@bootc.net, bostroesser@gmail.com, michael.christie@oracle.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux@yadro.com
Subject: Re: [PATCH 08/10] target: core: Use extended logs where possible
Message-ID: <202411300554.nCMgLGMh-lkp@intel.com>
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
config: arm64-randconfig-003-20241130 (https://download.01.org/0day-ci/archive/20241130/202411300554.nCMgLGMh-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241130/202411300554.nCMgLGMh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411300554.nCMgLGMh-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/target/target_core_pr.c:64:26: warning: unused variable 'pr_register_type_table_str' [-Wunused-const-variable]
      64 | static const char *const pr_register_type_table_str[] = {
         |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/target/target_core_pr.c:75:26: warning: unused variable 'pr_preempt_type_table_str' [-Wunused-const-variable]
      75 | static const char *const pr_preempt_type_table_str[] = {
         |                          ^~~~~~~~~~~~~~~~~~~~~~~~~
   2 warnings generated.


vim +/pr_register_type_table_str +64 drivers/target/target_core_pr.c

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
