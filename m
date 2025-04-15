Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48EE2556E;
	Tue, 15 Apr 2025 07:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744701493; cv=none; b=fQzxBWKsJ2o9LUSsk7luvlZugy1CaSPXAM8Hastp6DSc5kMjJ42ap8/B0bjPzlNiw6502OEoGohIs/o8V9riYKNZeOyeN+c/jBLzvgcwpGnB7jZh3sGfRRJKd33c5gTxFClRhKqZ7KlqGq1d7uEeUYk0dSfu6QGQ39LLYNKzZgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744701493; c=relaxed/simple;
	bh=Zm69Sjb8pQ7UhWYja2TUbVeqZ9mrWPrmnWdtmPZYjwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kB4CkvjTw0j0SLZg/yOcsyDbBxlJ98BIe2UPNEzILhBZuC+ykhKPQt3o+YPuaSM9v+5udLQkmAoKqQU1eKyXMvw1W2/s0nJhUv5vHnZOcCZTs3wD4ALuAEWIYptJ+Uw7l8K9hAXPSc+u4q2VXfE/D/aS1VMorgoID+JH8rnyluQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BY6BlCv/; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BY6BlCv/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744701489; x=1776237489;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Zm69Sjb8pQ7UhWYja2TUbVeqZ9mrWPrmnWdtmPZYjwg=;
  b=BY6BlCv/rJHgwTYEwchEKlLriRCXcrBDppfWYFrhm8TOOpgeCEnv5ByF
   8QEqpFOJbN4WO629VVqiGShGfLtWG1VSjfWXD4K9ehy+meZH4/DHK8zzV
   vGgiupimII3HbZ2D+IJBygQF817aWywSAxY0Rid7IYbv7fWNInCRSH+cp
   1/37di0QYSYDdQZLgbuUDkU8jmZM3tHTzufl7ceNZh0qkeXiUfLqpX13p
   ZhqQ6+OmAO1pAAMNz87Or56PaRHiLKjtW9K0gMvzq3/Il0G9n6Bvn2flD
   5F1EFj6P15tQxw4mPfcZxJORmBuctqA56xpd6baxV+I21UHKP0OAwwdz/
   Q==;
X-CSE-ConnectionGUID: 1BJyVKwiTTy0cuPRKlrWdg==
X-CSE-MsgGUID: eJbkxlHGTxi2sAY/toz+tw==
X-IronPort-AV: E=McAfee;i="6700,10204,11403"; a="45330413"
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="45330413"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 00:18:09 -0700
X-CSE-ConnectionGUID: F5e8jS9rQX2679lNv5HSNw==
X-CSE-MsgGUID: Er/3BfJaTiSBUhyzLn1qoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="135111420"
Received: from lkp-server01.sh.intel.com (HELO b207828170a5) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 15 Apr 2025 00:18:07 -0700
Received: from kbuild by b207828170a5 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1u4aYX-000FKU-1h;
	Tue, 15 Apr 2025 07:18:05 +0000
Date: Tue, 15 Apr 2025 15:17:39 +0800
From: kernel test robot <lkp@intel.com>
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>
Subject: Re: [PATCH 1/2] target: Move IO path stats to per cpu
Message-ID: <202504151524.Ar21ia6A-lkp@intel.com>
References: <20250413040500.20954-2-michael.christie@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250413040500.20954-2-michael.christie@oracle.com>

Hi Mike,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on linus/master v6.15-rc2 next-20250414]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mike-Christie/target-Move-IO-path-stats-to-per-cpu/20250414-113809
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20250413040500.20954-2-michael.christie%40oracle.com
patch subject: [PATCH 1/2] target: Move IO path stats to per cpu
config: i386-buildonly-randconfig-003-20250415 (https://download.01.org/0day-ci/archive/20250415/202504151524.Ar21ia6A-lkp@intel.com/config)
compiler: clang version 20.1.2 (https://github.com/llvm/llvm-project 58df0ef89dd64126512e4ee27b4ac3fd8ddf6247)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250415/202504151524.Ar21ia6A-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202504151524.Ar21ia6A-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/target/target_core_stat.c:289:3: warning: variable 'cmds' is uninitialized when used here [-Wuninitialized]
     289 |                 cmds += stats->total_cmds;
         |                 ^~~~
   drivers/target/target_core_stat.c:285:10: note: initialize the variable 'cmds' to silence this warning
     285 |         u32 cmds;
         |                 ^
         |                  = 0
>> drivers/target/target_core_stat.c:306:3: warning: variable 'bytes' is uninitialized when used here [-Wuninitialized]
     306 |                 bytes += stats->read_bytes;
         |                 ^~~~~
   drivers/target/target_core_stat.c:302:11: note: initialize the variable 'bytes' to silence this warning
     302 |         u32 bytes;
         |                  ^
         |                   = 0
   drivers/target/target_core_stat.c:323:3: warning: variable 'bytes' is uninitialized when used here [-Wuninitialized]
     323 |                 bytes += stats->write_bytes;
         |                 ^~~~~
   drivers/target/target_core_stat.c:319:11: note: initialize the variable 'bytes' to silence this warning
     319 |         u32 bytes;
         |                  ^
         |                   = 0
   drivers/target/target_core_stat.c:1058:3: warning: variable 'cmds' is uninitialized when used here [-Wuninitialized]
    1058 |                 cmds += stats->total_cmds;
         |                 ^~~~
   drivers/target/target_core_stat.c:1047:10: note: initialize the variable 'cmds' to silence this warning
    1047 |         u32 cmds;
         |                 ^
         |                  = 0
   drivers/target/target_core_stat.c:1087:3: warning: variable 'bytes' is uninitialized when used here [-Wuninitialized]
    1087 |                 bytes += stats->read_bytes;
         |                 ^~~~~
   drivers/target/target_core_stat.c:1076:11: note: initialize the variable 'bytes' to silence this warning
    1076 |         u32 bytes;
         |                  ^
         |                   = 0
   drivers/target/target_core_stat.c:1116:3: warning: variable 'bytes' is uninitialized when used here [-Wuninitialized]
    1116 |                 bytes += stats->write_bytes;
         |                 ^~~~~
   drivers/target/target_core_stat.c:1105:11: note: initialize the variable 'bytes' to silence this warning
    1105 |         u32 bytes;
         |                  ^
         |                   = 0
   6 warnings generated.


vim +/cmds +289 drivers/target/target_core_stat.c

   278	
   279	static ssize_t target_stat_lu_num_cmds_show(struct config_item *item,
   280			char *page)
   281	{
   282		struct se_device *dev = to_stat_lu_dev(item);
   283		struct se_dev_io_stats *stats;
   284		unsigned int cpu;
   285		u32 cmds;
   286	
   287		for_each_possible_cpu(cpu) {
   288			stats = per_cpu_ptr(dev->stats, cpu);
 > 289			cmds += stats->total_cmds;
   290		}
   291	
   292		/* scsiLuNumCommands */
   293		return snprintf(page, PAGE_SIZE, "%u\n", cmds);
   294	}
   295	
   296	static ssize_t target_stat_lu_read_mbytes_show(struct config_item *item,
   297			char *page)
   298	{
   299		struct se_device *dev = to_stat_lu_dev(item);
   300		struct se_dev_io_stats *stats;
   301		unsigned int cpu;
   302		u32 bytes;
   303	
   304		for_each_possible_cpu(cpu) {
   305			stats = per_cpu_ptr(dev->stats, cpu);
 > 306			bytes += stats->read_bytes;
   307		}
   308	
   309		/* scsiLuReadMegaBytes */
   310		return snprintf(page, PAGE_SIZE, "%u\n", bytes >> 20);
   311	}
   312	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
