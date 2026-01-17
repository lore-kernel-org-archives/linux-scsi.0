Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7222530FC0A
	for <linux-scsi@vger.kernel.org>; Sat, 17 Jan 2026 02:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768616206; cv=none; b=LljXxMjXlc2MEp13r6wspldUWlJg5WzvAdZon50JTwsa11wN96MY3Ii/htAwtgPCGdcb8oeoT+aJ0y/xQtfujWRoNGcpicWcNzIgBLcwbCLbslEeXF6juEhUlpWnKhF8E/WPUH9CnGEDWs3c+3VgCBfGTt8KQqwdRmv3uw0CbCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768616206; c=relaxed/simple;
	bh=+rrsvyBHN92mGZ0eJHrXFLbcu2n7Bqkz2nl6s25l2fM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pCPYHkn6WvwLjvU5HE/PBnj0DFEaLMRzjTKQWpEoocn2oGcS+Z/PtZTNPIxhEtY4xwJc7+sXU6bTrgWvLgIMtTdgIWk2Sx0QjJMF/2dplGkbok67i/HIP3dJOfRXhFyBdTUo6ho2tjjQP+lYI1KOgjW+3DgP/ryf/kPdWiZGhp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OemP3jgh; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OemP3jgh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768616204; x=1800152204;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+rrsvyBHN92mGZ0eJHrXFLbcu2n7Bqkz2nl6s25l2fM=;
  b=OemP3jghoLv8kjMDnaLAs4n1uMSgB7h+5M5iASO+EoN6U6RWaEhsrXXG
   wQnpdlh6tabTQqIP9hwBi+EZLNRNcMRysDv395OPjU6/+T2MneUauVY7G
   yjcwvLN9ZWjZd0uLuYQJrsUQbA1ppOnMiqPIAU+jqcj7vd62iAK1M8kqC
   6SlVcKECmBVal5bXJ+MLrvcbldyO2JkRZgjVrF1jC9q68qUWzMTYgs00Q
   p1noTR8Sjqw5sOgiikD4EcCzR18T5NxI7rPRtlR4Qii0tkt8i49Up4wKw
   RNoCGRXE62SaEEM2i+JLPRDxhg3+9hdNICmDeDXL4Qtg7ufG70/SFQ79T
   g==;
X-CSE-ConnectionGUID: K/dJPKQuRZiz4IfBUMxlVw==
X-CSE-MsgGUID: Y7fZEiHuRA+kO3cXIjzwrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11673"; a="69980084"
X-IronPort-AV: E=Sophos;i="6.21,232,1763452800"; 
   d="scan'208";a="69980084"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 18:16:44 -0800
X-CSE-ConnectionGUID: J7Bp/+H9QSO0WOmfqju5IA==
X-CSE-MsgGUID: eLPsMo5PT9q1ccxPKGnROQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,232,1763452800"; 
   d="scan'208";a="210257584"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 16 Jan 2026 18:16:33 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vgvrb-00000000LSs-1X95;
	Sat, 17 Jan 2026 02:16:31 +0000
Date: Sat, 17 Jan 2026 10:16:02 +0800
From: kernel test robot <lkp@intel.com>
To: Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: Re: [PATCH 5/7] ufs: core: Remove unused code and data structures
Message-ID: <202601170952.UMdlSqAD-lkp@intel.com>
References: <20260116182628.3255116-6-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116182628.3255116-6-bvanassche@acm.org>

Hi Bart,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v6.19-rc5 next-20260116]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Bart-Van-Assche/ufs-core-Change-the-type-of-an-ufshcd_clkgate_delay_set-argument/20260117-022907
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20260116182628.3255116-6-bvanassche%40acm.org
patch subject: [PATCH 5/7] ufs: core: Remove unused code and data structures
config: i386-randconfig-141-20260117 (https://download.01.org/0day-ci/archive/20260117/202601170952.UMdlSqAD-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
smatch version: v0.5.0-8985-g2614ff1a
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260117/202601170952.UMdlSqAD-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601170952.UMdlSqAD-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/ufs/core/ufshcd.c: In function 'ufshcd_setup_clocks':
>> drivers/ufs/core/ufshcd.c:9304:14: warning: variable 'clk_state_changed' set but not used [-Wunused-but-set-variable]
    9304 |         bool clk_state_changed = false;
         |              ^~~~~~~~~~~~~~~~~


vim +/clk_state_changed +9304 drivers/ufs/core/ufshcd.c

6a771a656041f4 drivers/scsi/ufs/ufshcd.c Raviv Shvili       2014-09-25  9298  
81309c247a4dcd drivers/scsi/ufs/ufshcd.c Can Guo            2020-11-25  9299  static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9300  {
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9301  	int ret = 0;
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9302  	struct ufs_clk_info *clki;
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9303  	struct list_head *head = &hba->clk_list_head;
911a0771b6fa7b drivers/scsi/ufs/ufshcd.c Subhash Jadavani   2016-12-22 @9304  	bool clk_state_changed = false;
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9305  
566ec9ad315b46 drivers/scsi/ufs/ufshcd.c Szymon Mielczarek  2017-06-05  9306  	if (list_empty(head))
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9307  		goto out;
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9308  
1e879e8fa9f62e drivers/scsi/ufs/ufshcd.c Subhash Jadavani   2016-10-06  9309  	ret = ufshcd_vops_setup_clocks(hba, on, PRE_CHANGE);
1e879e8fa9f62e drivers/scsi/ufs/ufshcd.c Subhash Jadavani   2016-10-06  9310  	if (ret)
1e879e8fa9f62e drivers/scsi/ufs/ufshcd.c Subhash Jadavani   2016-10-06  9311  		return ret;
1e879e8fa9f62e drivers/scsi/ufs/ufshcd.c Subhash Jadavani   2016-10-06  9312  
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9313  	list_for_each_entry(clki, head, list) {
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9314  		if (!IS_ERR_OR_NULL(clki->clk)) {
81309c247a4dcd drivers/scsi/ufs/ufshcd.c Can Guo            2020-11-25  9315  			/*
81309c247a4dcd drivers/scsi/ufs/ufshcd.c Can Guo            2020-11-25  9316  			 * Don't disable clocks which are needed
81309c247a4dcd drivers/scsi/ufs/ufshcd.c Can Guo            2020-11-25  9317  			 * to keep the link active.
81309c247a4dcd drivers/scsi/ufs/ufshcd.c Can Guo            2020-11-25  9318  			 */
81309c247a4dcd drivers/scsi/ufs/ufshcd.c Can Guo            2020-11-25  9319  			if (ufshcd_is_link_active(hba) &&
81309c247a4dcd drivers/scsi/ufs/ufshcd.c Can Guo            2020-11-25  9320  			    clki->keep_link_active)
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani   2014-09-25  9321  				continue;
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani   2014-09-25  9322  
911a0771b6fa7b drivers/scsi/ufs/ufshcd.c Subhash Jadavani   2016-12-22  9323  			clk_state_changed = on ^ clki->enabled;
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9324  			if (on && !clki->enabled) {
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9325  				ret = clk_prepare_enable(clki->clk);
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9326  				if (ret) {
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9327  					dev_err(hba->dev, "%s: %s prepare enable failed, %d\n",
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9328  						__func__, clki->name, ret);
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9329  					goto out;
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9330  				}
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9331  			} else if (!on && clki->enabled) {
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9332  				clk_disable_unprepare(clki->clk);
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9333  			}
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9334  			clki->enabled = on;
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9335  			dev_dbg(hba->dev, "%s: clk: %s %sabled\n", __func__,
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9336  					clki->name, on ? "en" : "dis");
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9337  		}
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9338  	}
1ab27c9cf8b63d drivers/scsi/ufs/ufshcd.c Sahitya Tummala    2014-09-25  9339  
1e879e8fa9f62e drivers/scsi/ufs/ufshcd.c Subhash Jadavani   2016-10-06  9340  	ret = ufshcd_vops_setup_clocks(hba, on, POST_CHANGE);
1e879e8fa9f62e drivers/scsi/ufs/ufshcd.c Subhash Jadavani   2016-10-06  9341  	if (ret)
1e879e8fa9f62e drivers/scsi/ufs/ufshcd.c Subhash Jadavani   2016-10-06  9342  		return ret;
1e879e8fa9f62e drivers/scsi/ufs/ufshcd.c Subhash Jadavani   2016-10-06  9343  
2777e73fc154e2 drivers/ufs/core/ufshcd.c Maramaina Naresh   2023-12-19  9344  	if (!ufshcd_is_clkscaling_supported(hba))
2777e73fc154e2 drivers/ufs/core/ufshcd.c Maramaina Naresh   2023-12-19  9345  		ufshcd_pm_qos_update(hba, on);
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9346  out:
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9347  	if (ret) {
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9348  		list_for_each_entry(clki, head, list) {
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9349  			if (!IS_ERR_OR_NULL(clki->clk) && clki->enabled)
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9350  				clk_disable_unprepare(clki->clk);
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9351  		}
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9352  	}
7ff5ab47363334 drivers/scsi/ufs/ufshcd.c Subhash Jadavani   2016-12-22  9353  
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9354  	return ret;
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9355  }
c6e79dacd86fd7 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma 2014-09-25  9356  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
