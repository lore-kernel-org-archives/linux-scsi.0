Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19D8288DA;
	Sat, 16 Aug 2025 23:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755386461; cv=none; b=RZbZ7Mxq+EaNW6/HMyiMCwxLKECmNIF1znU1S9Z8TQU35QHxZwRJTV3dOuNVA620le1yYRz4NifB0SpWp981xPC5jEWmxyNDefJQHIU2slVYaScHyasuhCxGQlJBd8NWUYO5HhwLNdF7LHfr9+H2UR8x8wz6GZPFH/mfPYoPMAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755386461; c=relaxed/simple;
	bh=PX00fDjME26NtcF3rtwkTRK5b6MjY2VErSrs21z9+XY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UJE9mp4qpoc19j0pTc90rAxBAQT0+qjaiTX3QLRp2H1Qh5LJgoI6jg90rS2rf6LPS4wO/GkRv41mPkWuE7TPynxEbd1j+1pa/Gh6llkg8qi2eCihHUMLyybPHKnQrbPcyl3F46asBNT75tFvaq53PFS6gu/iPhixPUTFXw4LDuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PcXUPMQz; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PcXUPMQz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755386458; x=1786922458;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PX00fDjME26NtcF3rtwkTRK5b6MjY2VErSrs21z9+XY=;
  b=PcXUPMQz92nex4DfitlaJw61tlFngL08lEXI5vZu9RV0Wkp2T/2Y1p7J
   6wIX00QqaE9Q9O7WJuJpMJ1o2b3d1NBJLsT1b52A2hIFyfcfOjmVzkQND
   pP94+TJXgF3QzMdlul7/e2wHzBI7pJG1DBh1zgluEnQhBQMfuC3X7gtTV
   bvGGvGzNbK9NlXAJ1slvRET/F2CS5v8KEjPTNC9NYfKxDGcOeNMGfviCR
   5Xp+uVOubHO/Qy58TWDvmgLSduBj06ZJmloMA2SgzlRgQfYmFm8Ho9jUJ
   spxd5yclm0Tckmq7fqSzGUX1weLAS+y/SCW+6JG5LQ34yBjyh42g8jwzq
   A==;
X-CSE-ConnectionGUID: 2ydO/A86SAqf/PMc8QkCPQ==
X-CSE-MsgGUID: MB/fKE3USHGcLYAeusZnnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11524"; a="80239182"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="80239182"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2025 16:20:58 -0700
X-CSE-ConnectionGUID: FXXlvn6jSf2hFf0JWKLZng==
X-CSE-MsgGUID: 9UiK7+5MSJakQAUYAb+Pxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="172491138"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa004.fm.intel.com with ESMTP; 16 Aug 2025 16:20:53 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1unQCR-000DGF-2o;
	Sat, 16 Aug 2025 23:20:45 +0000
Date: Sun, 17 Aug 2025 07:19:39 +0800
From: kernel test robot <lkp@intel.com>
To: JiangJianJun <jiangjianjun3@huawei.com>,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	hare@suse.de, bvanassche@acm.org, michael.christie@oracle.com,
	hch@infradead.org, haowenchao22@gmail.com, john.g.garry@oracle.com,
	hewenliang4@huawei.com, yangyun50@huawei.com, wuyifeng10@huawei.com,
	wubo40@huawei.com, yangxingui@h-partners.com
Subject: Re: [PATCH 10/14] scsi: scsi_error: Add helper to handle scsi
 target's error command list
Message-ID: <202508170715.5Q0ZpgmO-lkp@intel.com>
References: <20250816112417.3581253-11-jiangjianjun3@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816112417.3581253-11-jiangjianjun3@huawei.com>

Hi JiangJianJun,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v6.17-rc1 next-20250815]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/JiangJianJun/scsi-scsi_error-Define-framework-for-LUN-target-based-error-handle/20250816-185707
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20250816112417.3581253-11-jiangjianjun3%40huawei.com
patch subject: [PATCH 10/14] scsi: scsi_error: Add helper to handle scsi target's error command list
config: sh-randconfig-002-20250817 (https://download.01.org/0day-ci/archive/20250817/202508170715.5Q0ZpgmO-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 12.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250817/202508170715.5Q0ZpgmO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508170715.5Q0ZpgmO-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/scsi/scsi_error.c:46:
   drivers/scsi/scsi_error.c: In function 'starget_eh_reset_target':
>> drivers/scsi/scsi_error.c:2671:30: warning: '%s' directive argument is null [-Wformat-overflow=]
    2671 |                              "%s: Target reset %s\n", current->comm,
         |                              ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/scsi/scsi_logging.h:51:25: note: in definition of macro 'SCSI_CHECK_LOGGING'
      51 |                         CMD;                                    \
         |                         ^~~
   drivers/scsi/scsi_error.c:2670:9: note: in expansion of macro 'SCSI_LOG_ERROR_RECOVERY'
    2670 |         SCSI_LOG_ERROR_RECOVERY(3, starget_printk(KERN_INFO, starget,
         |         ^~~~~~~~~~~~~~~~~~~~~~~
   include/scsi/scsi_device.h:478:9: note: in expansion of macro 'dev_printk'
     478 |         dev_printk(prefix, &(starget)->dev, fmt, ##a)
         |         ^~~~~~~~~~
   drivers/scsi/scsi_error.c:2670:36: note: in expansion of macro 'starget_printk'
    2670 |         SCSI_LOG_ERROR_RECOVERY(3, starget_printk(KERN_INFO, starget,
         |                                    ^~~~~~~~~~~~~~
   drivers/scsi/scsi_error.c:2671:48: note: format string is defined here
    2671 |                              "%s: Target reset %s\n", current->comm,
         |                                                ^~


vim +2671 drivers/scsi/scsi_error.c

  2648	
  2649	static int starget_eh_reset_target(struct scsi_target *starget,
  2650					    struct list_head *work_q,
  2651					    struct list_head *done_q)
  2652	{
  2653		enum scsi_disposition rtn;
  2654		struct scsi_cmnd *scmd, *next;
  2655		LIST_HEAD(check_list);
  2656	
  2657		scmd = list_first_entry(work_q, struct scsi_cmnd, eh_entry);
  2658	
  2659		SCSI_LOG_ERROR_RECOVERY(3, starget_printk(KERN_INFO, starget,
  2660				     "%s: Sending target reset\n", current->comm));
  2661	
  2662		rtn = scsi_try_target_reset(scmd);
  2663		if (rtn != SUCCESS && rtn != FAST_IO_FAIL) {
  2664			SCSI_LOG_ERROR_RECOVERY(3, starget_printk(KERN_INFO, starget,
  2665					     "%s: Target reset failed\n",
  2666					     current->comm));
  2667			return 0;
  2668		}
  2669	
  2670		SCSI_LOG_ERROR_RECOVERY(3, starget_printk(KERN_INFO, starget,
> 2671				     "%s: Target reset %s\n", current->comm,
  2672					 scsi_mlreturn_string(rtn)));
  2673	
  2674		list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
  2675			if (rtn == SUCCESS)
  2676				list_move_tail(&scmd->eh_entry, &check_list);
  2677			else if (rtn == FAST_IO_FAIL)
  2678				scsi_eh_finish_cmd(scmd, done_q);
  2679		}
  2680	
  2681		return scsi_eh_test_devices(&check_list, work_q, done_q, 0);
  2682	}
  2683	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
