Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DDF1DFFD;
	Tue,  2 Sep 2025 06:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756794744; cv=none; b=Oped70tVsVwm1ImWP4iKPO5mz2/M+tFnLdQpSERJrO6sBUUjzVm63iqEqT1v7S/GULXVF1x5cDWz1w4ZTWg5R5JC2Upk5Tbd05aSb8L6/qwXwbbLOlylUgVAL5Q2e1q379YQm5MXB73V9TuKq8/3fJAthnqWSgznvybnk8JRHCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756794744; c=relaxed/simple;
	bh=RMQkvomOLLAE9BCgJJ7rozPydCyG9TQK4oYVCVv2aYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PnXlD8RG40X6xOGhvZ7RRO+DmUgszk680aU3HvdpuAyjOvlHo+Fu6FdyuHQPnt/TRMzo23TVY5bNEuVUwwRPZ6gZC0w+txlW8YlOfGPR14ke7F41DwT7NIX5JaHAdnTVgt/yAx/hGyOuk7osCr6n7joJx/7L61ojt6BbM7K5Vy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DDRQAaBF; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DDRQAaBF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756794743; x=1788330743;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RMQkvomOLLAE9BCgJJ7rozPydCyG9TQK4oYVCVv2aYg=;
  b=DDRQAaBFNM6K354v5jJZCuRJVmoKb8O8txcpS4EbCGNmlf7lmfkxSZj+
   XE/uDYeaB/EuvHaaSnTTmxSn6/Ocmc6biQM/84q3ghebdRq9W/pGF4cOk
   6a4l7sR1tdAS1I/ZLrtysslHsAyx7eeyemSqNcvK2T8pnlCvgvY+3SzP7
   lDgXUg8dWWaHKmzvNwqs6h4bDa1SSD6VkMRgwuVtmAz2UEUq59cWfZVT+
   npqGi+hrvzQguttbeLRQc8tSCumIRSJ9v+ZQu5wfaVSQsYbgR1/eqEPxb
   SCpgy9UQxFiZe4W7esXbu4D8Dc9fzRkVQmMsYPryfQ5ja00P5ruM6vU7s
   g==;
X-CSE-ConnectionGUID: RHsJSnH4RAGCIvc2M2XAEg==
X-CSE-MsgGUID: nCAdhD6RRBKWSv7Clk5pbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="81635642"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="81635642"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 23:32:22 -0700
X-CSE-ConnectionGUID: msWB30CGTKybT0ha7abKAg==
X-CSE-MsgGUID: +QSl33vHQXaB9NE9KO9NEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="170741958"
Received: from lkp-server02.sh.intel.com (HELO 06ba48ef64e9) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 01 Sep 2025 23:32:17 -0700
Received: from kbuild by 06ba48ef64e9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1utKYK-0001Vj-35;
	Tue, 02 Sep 2025 06:31:58 +0000
Date: Tue, 2 Sep 2025 14:30:19 +0800
From: kernel test robot <lkp@intel.com>
To: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>, alim.akhtar@samsung.com,
	avri.altman@wdc.com, bvanassche@acm.org,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, peter.wang@mediatek.com,
	tanghuan@vivo.com, liu.song13@zte.com.cn, quic_nguyenb@quicinc.com,
	viro@zeniv.linux.org.uk, huobean@gmail.com, adrian.hunter@intel.com,
	can.guo@oss.qualcomm.com, ebiggers@kernel.org,
	neil.armstrong@linaro.org, angelogioacchino.delregno@collabora.com,
	quic_narepall@quicinc.com, quic_mnaresh@quicinc.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	nitin.rawat@oss.qualcomm.com, ziqi.chen@oss.qualcomm.com,
	zhongqiu.han@oss.qualcomm.com
Subject: Re: [PATCH] scsi: ufs: core: Fix data race in CPU latency PM QoS
 request handling
Message-ID: <202509021425.HuVijyYS-lkp@intel.com>
References: <20250901085117.86160-1-zhongqiu.han@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250901085117.86160-1-zhongqiu.han@oss.qualcomm.com>

Hi Zhongqiu,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v6.17-rc4 next-20250901]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Zhongqiu-Han/scsi-ufs-core-Fix-data-race-in-CPU-latency-PM-QoS-request-handling/20250901-165540
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20250901085117.86160-1-zhongqiu.han%40oss.qualcomm.com
patch subject: [PATCH] scsi: ufs: core: Fix data race in CPU latency PM QoS request handling
config: arc-randconfig-002-20250902 (https://download.01.org/0day-ci/archive/20250902/202509021425.HuVijyYS-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 9.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250902/202509021425.HuVijyYS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509021425.HuVijyYS-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/ufs/core/ufshcd.c: In function 'ufshcd_pm_qos_init':
>> drivers/ufs/core/ufshcd.c:1052:2: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
    1052 |  if (hba->pm_qos_enabled)
         |  ^~
   drivers/ufs/core/ufshcd.c:1054:3: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
    1054 |   return;
         |   ^~~~~~
   drivers/ufs/core/ufshcd.c: In function 'ufshcd_pm_qos_exit':
   drivers/ufs/core/ufshcd.c:1072:2: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
    1072 |  if (!hba->pm_qos_enabled)
         |  ^~
   drivers/ufs/core/ufshcd.c:1074:3: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
    1074 |   return;
         |   ^~~~~~
   drivers/ufs/core/ufshcd.c: In function 'ufshcd_pm_qos_update':
   drivers/ufs/core/ufshcd.c:1090:2: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
    1090 |  if (!hba->pm_qos_enabled)
         |  ^~
   drivers/ufs/core/ufshcd.c:1092:3: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
    1092 |   return;
         |   ^~~~~~


vim +/if +1052 drivers/ufs/core/ufshcd.c

7a3e97b0dc4bba drivers/scsi/ufs/ufshcd.c Santosh Yaraganavi 2012-02-29  1043  
2777e73fc154e2 drivers/ufs/core/ufshcd.c Maramaina Naresh   2023-12-19  1044  /**
2777e73fc154e2 drivers/ufs/core/ufshcd.c Maramaina Naresh   2023-12-19  1045   * ufshcd_pm_qos_init - initialize PM QoS request
2777e73fc154e2 drivers/ufs/core/ufshcd.c Maramaina Naresh   2023-12-19  1046   * @hba: per adapter instance
2777e73fc154e2 drivers/ufs/core/ufshcd.c Maramaina Naresh   2023-12-19  1047   */
2777e73fc154e2 drivers/ufs/core/ufshcd.c Maramaina Naresh   2023-12-19  1048  void ufshcd_pm_qos_init(struct ufs_hba *hba)
2777e73fc154e2 drivers/ufs/core/ufshcd.c Maramaina Naresh   2023-12-19  1049  {
5824c3647e1ad8 drivers/ufs/core/ufshcd.c Zhongqiu Han       2025-09-01  1050  	mutex_lock(&hba->pm_qos_mutex);
2777e73fc154e2 drivers/ufs/core/ufshcd.c Maramaina Naresh   2023-12-19  1051  
2777e73fc154e2 drivers/ufs/core/ufshcd.c Maramaina Naresh   2023-12-19 @1052  	if (hba->pm_qos_enabled)
5824c3647e1ad8 drivers/ufs/core/ufshcd.c Zhongqiu Han       2025-09-01  1053  		mutex_unlock(&hba->pm_qos_mutex);
2777e73fc154e2 drivers/ufs/core/ufshcd.c Maramaina Naresh   2023-12-19  1054  		return;
2777e73fc154e2 drivers/ufs/core/ufshcd.c Maramaina Naresh   2023-12-19  1055  
2777e73fc154e2 drivers/ufs/core/ufshcd.c Maramaina Naresh   2023-12-19  1056  	cpu_latency_qos_add_request(&hba->pm_qos_req, PM_QOS_DEFAULT_VALUE);
2777e73fc154e2 drivers/ufs/core/ufshcd.c Maramaina Naresh   2023-12-19  1057  
2777e73fc154e2 drivers/ufs/core/ufshcd.c Maramaina Naresh   2023-12-19  1058  	if (cpu_latency_qos_request_active(&hba->pm_qos_req))
2777e73fc154e2 drivers/ufs/core/ufshcd.c Maramaina Naresh   2023-12-19  1059  		hba->pm_qos_enabled = true;
5824c3647e1ad8 drivers/ufs/core/ufshcd.c Zhongqiu Han       2025-09-01  1060  
5824c3647e1ad8 drivers/ufs/core/ufshcd.c Zhongqiu Han       2025-09-01  1061  	mutex_unlock(&hba->pm_qos_mutex);
2777e73fc154e2 drivers/ufs/core/ufshcd.c Maramaina Naresh   2023-12-19  1062  }
2777e73fc154e2 drivers/ufs/core/ufshcd.c Maramaina Naresh   2023-12-19  1063  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
