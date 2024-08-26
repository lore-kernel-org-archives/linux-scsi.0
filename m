Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFEE17ADF0;
	Mon, 26 Aug 2024 13:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724677751; cv=none; b=brOvSIWFqJ/Rri1/RKkD9f4GMTfNpkRfoIZNGl17F4W/6jqyLlKewCvjsSfw11aW9OoHI7F7RGYB/HBHVaBbN/uAesBcKOTTGPbilxEtxPeoy/ceG7/orRFR8EukGzMU2VpscFmsuQiyWZ/qcg8RFYSrw92fL/GExac5Sz4//O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724677751; c=relaxed/simple;
	bh=/WCjiJBIK6wPuwAFTmjz+n++wdH29E6bztgRbxuVOWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M8WrsQYbSs2S4bIDYOPJu2AIQDxEjyscd3WL/T7e3JE6pm0RThpdUakeFi1ePBFhuMBOgnqKczoyY7bdfXNBy6XTXUy7pK6EwsCVkl6ItAnBcQjWwRo+AwS06PQiqTjh/JM43B4WVOyVQj9LJ3gDmm/r3CVcpUQZluZQ5GrEaEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BWSjh0B6; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BWSjh0B6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724677749; x=1756213749;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/WCjiJBIK6wPuwAFTmjz+n++wdH29E6bztgRbxuVOWA=;
  b=BWSjh0B6yz3WChQzcuXP45pXVo4t8I+2d3uBgkFOzwq3Hh+fhh+BWmv9
   lPMqbb/qmAskmTIQElM/nosen/2QeRNQk0UkTEyCjzzp6JqI0gjwqlouE
   519xW7mfpOhqExbFccWtZs4cGR/rin6oxT9cjulGf5yR/waA541MSl4tC
   aCuvT8zUtS/cZdw+jByudXzOzTm43MW0NmkCSfGST1zlMRiTNzLIRaCXc
   2Fhr2V4fLrkTCDdvnOOmbLzp2QCAJOB0Up+TDxQ7/8FWy5h0zYd+8RtFc
   1JlLzaLzlhd2nZRDpdQVhrkma3l5Smf0QTgHlYLPvvikLgCSPnrGOIQmE
   Q==;
X-CSE-ConnectionGUID: JtyqIcLNRXenWqAtKSOCsQ==
X-CSE-MsgGUID: PbSFcaF4TzmWI0lXtSawmA==
X-IronPort-AV: E=McAfee;i="6700,10204,11176"; a="26893621"
X-IronPort-AV: E=Sophos;i="6.10,177,1719903600"; 
   d="scan'208";a="26893621"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2024 06:09:08 -0700
X-CSE-ConnectionGUID: d/Gt1GFERQ6WkSjykXKe0Q==
X-CSE-MsgGUID: P/3ppt2LQhqjrLVsKm0KKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,177,1719903600"; 
   d="scan'208";a="62180489"
Received: from lkp-server01.sh.intel.com (HELO 9a732dc145d3) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 26 Aug 2024 06:09:04 -0700
Received: from kbuild by 9a732dc145d3 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1siZSw-000H6V-0G;
	Mon, 26 Aug 2024 13:09:02 +0000
Date: Mon, 26 Aug 2024 21:08:45 +0800
From: kernel test robot <lkp@intel.com>
To: Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
	avri.altman@wdc.com, bvanassche@acm.org, jejb@linux.ibm.com,
	martin.petersen@oracle.com, beanhuo@micron.com,
	adrian.hunter@intel.com, h10.kim@samsung.com, hy50.seo@samsung.com,
	sh425.lee@samsung.com, kwangwon.min@samsung.com,
	junwoo80.lee@samsung.com, wkon.kim@samsung.com
Cc: oe-kbuild-all@lists.linux.dev, Kiwoong Kim <kwmad.kim@samsung.com>
Subject: Re: [PATCH v2 1/2] scsi: ufs: core: introduce override_cqe_ocs
Message-ID: <202408262058.4pPayDSg-lkp@intel.com>
References: <6aaeaa5fd70f76a1ac751ae3c5a3f0e37bc697b1.1724325280.git.kwmad.kim@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6aaeaa5fd70f76a1ac751ae3c5a3f0e37bc697b1.1724325280.git.kwmad.kim@samsung.com>

Hi Kiwoong,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next krzk/for-next linus/master v6.11-rc5 next-20240826]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Kiwoong-Kim/scsi-ufs-ufs-exynos-implement-override_cqe_ocs/20240826-111954
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/6aaeaa5fd70f76a1ac751ae3c5a3f0e37bc697b1.1724325280.git.kwmad.kim%40samsung.com
patch subject: [PATCH v2 1/2] scsi: ufs: core: introduce override_cqe_ocs
config: i386-buildonly-randconfig-002-20240826 (https://download.01.org/0day-ci/archive/20240826/202408262058.4pPayDSg-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240826/202408262058.4pPayDSg-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408262058.4pPayDSg-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/ufs/core/ufshcd.c:827: warning: Function parameter or struct member 'hba' not described in 'ufshcd_get_tr_ocs'


vim +827 drivers/ufs/core/ufshcd.c

7a3e97b0dc4bba drivers/scsi/ufs/ufshcd.c Santosh Yaraganavi 2012-02-29  814  
7a3e97b0dc4bba drivers/scsi/ufs/ufshcd.c Santosh Yaraganavi 2012-02-29  815  /**
7a3e97b0dc4bba drivers/scsi/ufs/ufshcd.c Santosh Yaraganavi 2012-02-29  816   * ufshcd_get_tr_ocs - Get the UTRD Overall Command Status
8aa29f192ca675 drivers/scsi/ufs/ufshcd.c Bart Van Assche    2018-03-01  817   * @lrbp: pointer to local command reference block
c30d8d010b5efd drivers/ufs/core/ufshcd.c Asutosh Das        2023-01-13  818   * @cqe: pointer to the completion queue entry
7a3e97b0dc4bba drivers/scsi/ufs/ufshcd.c Santosh Yaraganavi 2012-02-29  819   *
7a3e97b0dc4bba drivers/scsi/ufs/ufshcd.c Santosh Yaraganavi 2012-02-29  820   * This function is used to get the OCS field from UTRD
3a17fefe0f1960 drivers/ufs/core/ufshcd.c Bart Van Assche    2023-07-27  821   *
3a17fefe0f1960 drivers/ufs/core/ufshcd.c Bart Van Assche    2023-07-27  822   * Return: the OCS field in the UTRD.
7a3e97b0dc4bba drivers/scsi/ufs/ufshcd.c Santosh Yaraganavi 2012-02-29  823   */
f214402c84a246 drivers/ufs/core/ufshcd.c Kiwoong Kim        2024-08-22  824  static enum utp_ocs ufshcd_get_tr_ocs(struct ufs_hba *hba,
f214402c84a246 drivers/ufs/core/ufshcd.c Kiwoong Kim        2024-08-22  825  				      struct ufshcd_lrb *lrbp,
c30d8d010b5efd drivers/ufs/core/ufshcd.c Asutosh Das        2023-01-13  826  				      struct cq_entry *cqe)
7a3e97b0dc4bba drivers/scsi/ufs/ufshcd.c Santosh Yaraganavi 2012-02-29 @827  {
c30d8d010b5efd drivers/ufs/core/ufshcd.c Asutosh Das        2023-01-13  828  	if (cqe)
f214402c84a246 drivers/ufs/core/ufshcd.c Kiwoong Kim        2024-08-22  829  		return ufshcd_vops_override_cqe_ocs(hba,
f214402c84a246 drivers/ufs/core/ufshcd.c Kiwoong Kim        2024-08-22  830  						    le32_to_cpu(cqe->status) &
f214402c84a246 drivers/ufs/core/ufshcd.c Kiwoong Kim        2024-08-22  831  						    MASK_OCS);
c30d8d010b5efd drivers/ufs/core/ufshcd.c Asutosh Das        2023-01-13  832  
67a2a8973832cb drivers/ufs/core/ufshcd.c Bart Van Assche    2023-07-27  833  	return lrbp->utr_descriptor_ptr->header.ocs & MASK_OCS;
7a3e97b0dc4bba drivers/scsi/ufs/ufshcd.c Santosh Yaraganavi 2012-02-29  834  }
7a3e97b0dc4bba drivers/scsi/ufs/ufshcd.c Santosh Yaraganavi 2012-02-29  835  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
