Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11ACC1CCB5B
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 16:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724342906; cv=none; b=i4py4w+o17bMkzEMPw+bFeZm7EqfOYkgbLbbvurVbqBypC+zT5pY0URY1ImhXsIdu542LnXh//vChj3cAO3NPdfiy3UOQ2YkC2KtlTNn8+hbL/FMqWVBathQVWOzYLKjfJZ200nHRt94GdYC5BfPS0oDCrWyfco/Zo2u4P0pBVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724342906; c=relaxed/simple;
	bh=piHsSMiFp6L+2Kzdvx+uPcAWDn1QIGfy015ZQ3lLGxo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ehL1qTr/Qay7mjj0jIE9MtEOsMkQz8I0vp0nsy0xG/M7Uc3+mEN4WEdhHPTXb7AHVMze88RrPasalmozetwAdk4G0AB9gYu67XLZqbQZkGNT71aCmjSYWD0tSy0q/YEfzBFBj+1EuCsEbkuplhc+vustZ0lgzz1QtQwlBxv9b38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b86coBhO; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b86coBhO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724342903; x=1755878903;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=piHsSMiFp6L+2Kzdvx+uPcAWDn1QIGfy015ZQ3lLGxo=;
  b=b86coBhO5T1DLJEHDli7uTCCVRueWqvnHpEYxqu1Z6orMfPl8trJFOen
   mmXew7AyT/U+IzeJMyYztbnhTjmHToDqf5l4W4T6KxylI52ul0TqNqZiD
   vu311e9K0lRygQ6sBdnPIzhRQo/tXyAFANrToG2T9g+7gqlPPwvMO/rf1
   7UydH+0TdjB/xj/iGO6tnXzvjQNXnlWZZYfr8a8Hsw6odQK9TNTSd03gs
   jKysMO7Ebo+jyXWXd/L8lbg/PtBGceKIsd3Axi770tNwLGn02RO+9yaTv
   DwGcRtehk044AW/gMY5QszMp3YharXAenWmBqv4J/vFFfsaVe46l4LACG
   g==;
X-CSE-ConnectionGUID: UCU3aT2EQ8SRwx4Jex7wBA==
X-CSE-MsgGUID: UGwcKjgmS2e8QvVfHZ+5sw==
X-IronPort-AV: E=McAfee;i="6700,10204,11172"; a="40235498"
X-IronPort-AV: E=Sophos;i="6.10,167,1719903600"; 
   d="scan'208";a="40235498"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2024 09:08:21 -0700
X-CSE-ConnectionGUID: pLgoKq1nQoeLxaPj+ZU/xw==
X-CSE-MsgGUID: B98DqZ2JTOyNOUKULsNqlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,167,1719903600"; 
   d="scan'208";a="61169782"
Received: from lkp-server01.sh.intel.com (HELO 9a732dc145d3) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 22 Aug 2024 09:08:18 -0700
Received: from kbuild by 9a732dc145d3 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1shAMB-000Cxm-2y;
	Thu, 22 Aug 2024 16:08:15 +0000
Date: Fri, 23 Aug 2024 00:07:58 +0800
From: kernel test robot <lkp@intel.com>
To: Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Avri Altman <avri.altman@wdc.com>, Bean Huo <beanhuo@micron.com>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: Re: [PATCH 5/9] ufs: core: Move the ufshcd_device_init() call
Message-ID: <202408222305.wOhpxPXn-lkp@intel.com>
References: <20240819225102.2437307-6-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819225102.2437307-6-bvanassche@acm.org>

Hi Bart,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[cannot apply to jejb-scsi/for-next linus/master v6.11-rc4 next-20240822]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Bart-Van-Assche/ufs-core-Introduce-ufshcd_add_scsi_host/20240820-065414
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20240819225102.2437307-6-bvanassche%40acm.org
patch subject: [PATCH 5/9] ufs: core: Move the ufshcd_device_init() call
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20240822/202408222305.wOhpxPXn-lkp@intel.com/config)
compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240822/202408222305.wOhpxPXn-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408222305.wOhpxPXn-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/ufs/core/ufshcd.c:8871:6: warning: variable 'ret' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
    8871 |         if (!hba->pm_op_in_progress &&
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~
    8872 |             (hba->quirks & UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH)) {
         |             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:8911:6: note: uninitialized use occurs here
    8911 |         if (ret)
         |             ^~~
   drivers/ufs/core/ufshcd.c:8871:2: note: remove the 'if' if its condition is always true
    8871 |         if (!hba->pm_op_in_progress &&
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    8872 |             (hba->quirks & UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH)) {
         |             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:8871:6: warning: variable 'ret' is used uninitialized whenever '&&' condition is false [-Wsometimes-uninitialized]
    8871 |         if (!hba->pm_op_in_progress &&
         |             ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:8911:6: note: uninitialized use occurs here
    8911 |         if (ret)
         |             ^~~
   drivers/ufs/core/ufshcd.c:8871:6: note: remove the '&&' if its condition is always true
    8871 |         if (!hba->pm_op_in_progress &&
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:8869:9: note: initialize the variable 'ret' to silence this warning
    8869 |         int ret;
         |                ^
         |                 = 0
   2 warnings generated.


vim +8871 drivers/ufs/core/ufshcd.c

96a7141da33207 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2022-12-22  8856  
96a7141da33207 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2022-12-22  8857  /**
96a7141da33207 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2022-12-22  8858   * ufshcd_probe_hba - probe hba to detect device and initialize it
96a7141da33207 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2022-12-22  8859   * @hba: per-adapter instance
96a7141da33207 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2022-12-22  8860   *
96a7141da33207 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2022-12-22  8861   * Execute link-startup and verify device initialization
fd4bffb54dc0f6 drivers/ufs/core/ufshcd.c Bart Van Assche       2023-07-27  8862   *
fd4bffb54dc0f6 drivers/ufs/core/ufshcd.c Bart Van Assche       2023-07-27  8863   * Return: 0 upon success; < 0 upon failure.
96a7141da33207 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2022-12-22  8864   */
56161bc6c24d06 drivers/ufs/core/ufshcd.c Bart Van Assche       2024-08-19  8865  static int ufshcd_probe_hba(struct ufs_hba *hba)
96a7141da33207 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2022-12-22  8866  {
96a7141da33207 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2022-12-22  8867  	ktime_t start = ktime_get();
96a7141da33207 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2022-12-22  8868  	unsigned long flags;
96a7141da33207 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2022-12-22  8869  	int ret;
96a7141da33207 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2022-12-22  8870  
fc88ca19ad0989 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2023-09-08 @8871  	if (!hba->pm_op_in_progress &&
fc88ca19ad0989 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2023-09-08  8872  	    (hba->quirks & UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH)) {
96a7141da33207 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2022-12-22  8873  		/* Reset the device and controller before doing reinit */
96a7141da33207 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2022-12-22  8874  		ufshcd_device_reset(hba);
135c6eb27a85c8 drivers/ufs/core/ufshcd.c Joel Slebodnick       2024-06-13  8875  		ufs_put_device_desc(hba);
96a7141da33207 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2022-12-22  8876  		ufshcd_hba_stop(hba);
96a7141da33207 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2022-12-22  8877  		ufshcd_vops_reinit_notify(hba);
96a7141da33207 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2022-12-22  8878  		ret = ufshcd_hba_enable(hba);
96a7141da33207 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2022-12-22  8879  		if (ret) {
96a7141da33207 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2022-12-22  8880  			dev_err(hba->dev, "Host controller enable failed\n");
96a7141da33207 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2022-12-22  8881  			ufshcd_print_evt_hist(hba);
96a7141da33207 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2022-12-22  8882  			ufshcd_print_host_state(hba);
8643ae66ce749f drivers/scsi/ufs/ufshcd.c Dov Levenglick        2016-10-17  8883  			goto out;
8643ae66ce749f drivers/scsi/ufs/ufshcd.c Dov Levenglick        2016-10-17  8884  		}
96a7141da33207 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2022-12-22  8885  
96a7141da33207 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2022-12-22  8886  		/* Reinit the device */
56161bc6c24d06 drivers/ufs/core/ufshcd.c Bart Van Assche       2024-08-19  8887  		ret = ufshcd_device_init(hba, /*init_dev_params=*/false);
96a7141da33207 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2022-12-22  8888  		if (ret)
96a7141da33207 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2022-12-22  8889  			goto out;
7eb584db73bebb drivers/scsi/ufs/ufshcd.c Dolev Raviv           2014-09-25  8890  	}
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani      2014-09-25  8891  
96a7141da33207 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2022-12-22  8892  	ufshcd_print_pwr_info(hba);
96a7141da33207 drivers/ufs/core/ufshcd.c Manivannan Sadhasivam 2022-12-22  8893  
e89860f196fca3 drivers/scsi/ufs/ufshcd.c Can Guo               2020-03-26  8894  	/*
e89860f196fca3 drivers/scsi/ufs/ufshcd.c Can Guo               2020-03-26  8895  	 * bActiveICCLevel is volatile for UFS device (as per latest v2.1 spec)
e89860f196fca3 drivers/scsi/ufs/ufshcd.c Can Guo               2020-03-26  8896  	 * and for removable UFS card as well, hence always set the parameter.
e89860f196fca3 drivers/scsi/ufs/ufshcd.c Can Guo               2020-03-26  8897  	 * Note: Error handler may issue the device reset hence resetting
e89860f196fca3 drivers/scsi/ufs/ufshcd.c Can Guo               2020-03-26  8898  	 * bActiveICCLevel as well so it is always safe to set this here.
e89860f196fca3 drivers/scsi/ufs/ufshcd.c Can Guo               2020-03-26  8899  	 */
e89860f196fca3 drivers/scsi/ufs/ufshcd.c Can Guo               2020-03-26  8900  	ufshcd_set_active_icc_lvl(hba);
e89860f196fca3 drivers/scsi/ufs/ufshcd.c Can Guo               2020-03-26  8901  
4450a1653a935d drivers/ufs/core/ufshcd.c Jinyoung Choi         2022-08-04  8902  	/* Enable UFS Write Booster if supported */
4450a1653a935d drivers/ufs/core/ufshcd.c Jinyoung Choi         2022-08-04  8903  	ufshcd_configure_wb(hba);
4450a1653a935d drivers/ufs/core/ufshcd.c Jinyoung Choi         2022-08-04  8904  
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  8905  	if (hba->ee_usr_mask)
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  8906  		ufshcd_write_ee_control(hba);
bdf5c0bb4dd9e7 drivers/ufs/core/ufshcd.c Bart Van Assche       2023-12-14  8907  	ufshcd_configure_auto_hibern8(hba);
71d848b8d97ec0 drivers/scsi/ufs/ufshcd.c Can Guo               2019-11-14  8908  
5a0b0cb9bee767 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma    2013-07-30  8909  out:
4db7a23605973a drivers/scsi/ufs/ufshcd.c Can Guo               2020-08-09  8910  	spin_lock_irqsave(hba->host->host_lock, flags);
4db7a23605973a drivers/scsi/ufs/ufshcd.c Can Guo               2020-08-09  8911  	if (ret)
4db7a23605973a drivers/scsi/ufs/ufshcd.c Can Guo               2020-08-09  8912  		hba->ufshcd_state = UFSHCD_STATE_ERROR;
4db7a23605973a drivers/scsi/ufs/ufshcd.c Can Guo               2020-08-09  8913  	else if (hba->ufshcd_state == UFSHCD_STATE_RESET)
4db7a23605973a drivers/scsi/ufs/ufshcd.c Can Guo               2020-08-09  8914  		hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
4db7a23605973a drivers/scsi/ufs/ufshcd.c Can Guo               2020-08-09  8915  	spin_unlock_irqrestore(hba->host->host_lock, flags);
1d337ec2f35e69 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma    2014-09-25  8916  
7ff5ab47363334 drivers/scsi/ufs/ufshcd.c Subhash Jadavani      2016-12-22  8917  	trace_ufshcd_init(dev_name(hba->dev), ret,
7ff5ab47363334 drivers/scsi/ufs/ufshcd.c Subhash Jadavani      2016-12-22  8918  		ktime_to_us(ktime_sub(ktime_get(), start)),
73eba2be9203c0 drivers/scsi/ufs/ufshcd.c Subhash Jadavani      2017-01-10  8919  		hba->curr_dev_pwr_mode, hba->uic_link_state);
1d337ec2f35e69 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma    2014-09-25  8920  	return ret;
1d337ec2f35e69 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma    2014-09-25  8921  }
1d337ec2f35e69 drivers/scsi/ufs/ufshcd.c Sujit Reddy Thumma    2014-09-25  8922  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
