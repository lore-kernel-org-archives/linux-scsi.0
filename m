Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5FD2FBDE0;
	Sat,  2 May 2026 13:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777730297; cv=none; b=U5BT4Ta+YFq71hOYWMtEWCl+Q9zLq5SVN8DnQ67A+XqjpSWcuRIvmxLf0zymKbsAGUHpuquSLs6IWICOzJ99APN1oOE8LoMjT922npNYxaKcrkalpNLLA2uR8KtAIek5kIoXtvSrUK9cg8zFSrmwmGN0FoqdD9vsmjB0Y0XXIDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777730297; c=relaxed/simple;
	bh=UfLEForVupm1MSHwxcg6G38uIqPC6qu5m7ewRH4XFHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ClzMGlUWN5//MfdcHxKXPP/5gT2XdWovrld7BfRhUWhRBljqNnTaWOaYv10YSkXpkplj5p0de96M+e303/WLLVLx/PUQPw9RePahynWnS/QM6LbSz+Z24K2PwcMLawn6/YpVzcWnafiIxU1Lh1vp2wXE0jMbXtm0ZDzdeIZcIZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=St4T7/Ap; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="St4T7/Ap"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777730296; x=1809266296;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UfLEForVupm1MSHwxcg6G38uIqPC6qu5m7ewRH4XFHc=;
  b=St4T7/ApGc0YfZW+tL1YNt4Niaeur8RQX6ih0rNqpOhPYcctM+gfo5wr
   Uhni1VUElrMdlS2DVkE+y+j9/XHJ6AMdlaA+lK62uCDN6oB8eDspphjCi
   Yk0ndX3cWOilWJ9dzPsPsPJXQBKwRbozRdhUIV/F3HcVelhkSXJmlBYQm
   inybvvj9Eap4POS4BnLADpUeXfnc2y7q0+iseClNk4yjKyIayGMtJiXVV
   xtx49hsPwR6vkVLG0dAe0YVMPJcKArjihEaMZ808bEE7Q9sbkaAQNFURu
   6t4+hvsxVMYaQedGL9pSk94Naz264KBWEStSRn0ft/JSXXiz+kCf8vHHi
   w==;
X-CSE-ConnectionGUID: mph+U+lKQHummuONON2heA==
X-CSE-MsgGUID: OmHIglx9QRaKWvJdjqkEVA==
X-IronPort-AV: E=McAfee;i="6800,10657,11774"; a="96091442"
X-IronPort-AV: E=Sophos;i="6.23,211,1770624000"; 
   d="scan'208";a="96091442"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2026 06:58:12 -0700
X-CSE-ConnectionGUID: TLLpC88TTneEn87bOTyujA==
X-CSE-MsgGUID: 1rscNHlxTTSnui+FQu/1FQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,211,1770624000"; 
   d="scan'208";a="231962269"
Received: from lkp-server01.sh.intel.com (HELO 781826d00641) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 02 May 2026 06:58:09 -0700
Received: from kbuild by 781826d00641 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wJAr8-000000001Qz-0kjs;
	Sat, 02 May 2026 13:58:06 +0000
Date: Sat, 2 May 2026 21:57:57 +0800
From: kernel test robot <lkp@intel.com>
To: Hongjie Fang <hongjiefang@asrmicro.com>, alim.akhtar@samsung.com,
	avri.altman@wdc.com, bvanassche@acm.org,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] scsi: ufs: core: call hibern8 notify when hibern8 cmd
 failed
Message-ID: <202605022153.181ENp5n-lkp@intel.com>
References: <20260430042212.3712251-1-hongjiefang@asrmicro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430042212.3712251-1-hongjiefang@asrmicro.com>

Hi Hongjie,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v7.1-rc1 next-20260430]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Hongjie-Fang/scsi-ufs-core-call-hibern8-notify-when-hibern8-cmd-failed/20260501-050358
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20260430042212.3712251-1-hongjiefang%40asrmicro.com
patch subject: [PATCH v3] scsi: ufs: core: call hibern8 notify when hibern8 cmd failed
config: arm-allyesconfig (https://download.01.org/0day-ci/archive/20260502/202605022153.181ENp5n-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260502/202605022153.181ENp5n-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605022153.181ENp5n-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/ufs/host/ufs-qcom.c: In function 'ufs_qcom_setup_clocks':
>> drivers/ufs/host/ufs-qcom.c:1433:9: warning: enumeration value 'ROLLBACK_CHANGE' not handled in switch [-Wswitch]
    1433 |         switch (status) {
         |         ^~~~~~


vim +/ROLLBACK_CHANGE +1433 drivers/ufs/host/ufs-qcom.c

81c0fc51b7a790 drivers/scsi/ufs/ufs-qcom.c Yaniv Gardi           2015-01-15  1401  
f06fcc7155dcbc drivers/scsi/ufs/ufs-qcom.c Yaniv Gardi           2015-10-28  1402  /**
f06fcc7155dcbc drivers/scsi/ufs/ufs-qcom.c Yaniv Gardi           2015-10-28  1403   * ufs_qcom_setup_clocks - enables/disable clocks
f06fcc7155dcbc drivers/scsi/ufs/ufs-qcom.c Yaniv Gardi           2015-10-28  1404   * @hba: host controller instance
f06fcc7155dcbc drivers/scsi/ufs/ufs-qcom.c Yaniv Gardi           2015-10-28  1405   * @on: If true, enable clocks else disable them.
1e879e8fa9f62e drivers/scsi/ufs/ufs-qcom.c Subhash Jadavani      2016-10-06  1406   * @status: PRE_CHANGE or POST_CHANGE notify
f06fcc7155dcbc drivers/scsi/ufs/ufs-qcom.c Yaniv Gardi           2015-10-28  1407   *
77d2fa54a94574 drivers/ufs/host/ufs-qcom.c Nitin Rawat           2025-05-26  1408   * There are certain clocks which comes from the PHY so it needs
77d2fa54a94574 drivers/ufs/host/ufs-qcom.c Nitin Rawat           2025-05-26  1409   * to be managed together along with controller clocks which also
77d2fa54a94574 drivers/ufs/host/ufs-qcom.c Nitin Rawat           2025-05-26  1410   * provides a better power saving. Hence keep phy_power_off/on calls
77d2fa54a94574 drivers/ufs/host/ufs-qcom.c Nitin Rawat           2025-05-26  1411   * in ufs_qcom_setup_clocks, so that PHY's regulators & clks can be
77d2fa54a94574 drivers/ufs/host/ufs-qcom.c Nitin Rawat           2025-05-26  1412   * turned on/off along with UFS's clocks.
77d2fa54a94574 drivers/ufs/host/ufs-qcom.c Nitin Rawat           2025-05-26  1413   *
3a17fefe0f1960 drivers/ufs/host/ufs-qcom.c Bart Van Assche       2023-07-27  1414   * Return: 0 on success, non-zero on failure.
f06fcc7155dcbc drivers/scsi/ufs/ufs-qcom.c Yaniv Gardi           2015-10-28  1415   */
1e879e8fa9f62e drivers/scsi/ufs/ufs-qcom.c Subhash Jadavani      2016-10-06  1416  static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on,
1e879e8fa9f62e drivers/scsi/ufs/ufs-qcom.c Subhash Jadavani      2016-10-06  1417  				 enum ufs_notify_change_status status)
81c0fc51b7a790 drivers/scsi/ufs/ufs-qcom.c Yaniv Gardi           2015-01-15  1418  {
1ce5898af55e23 drivers/scsi/ufs/ufs-qcom.c Yaniv Gardi           2015-10-28  1419  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
720fa0cb59e411 drivers/ufs/host/ufs-qcom.c Nitin Rawat           2025-06-23  1420  	struct phy *phy;
77d2fa54a94574 drivers/ufs/host/ufs-qcom.c Nitin Rawat           2025-05-26  1421  	int err;
81c0fc51b7a790 drivers/scsi/ufs/ufs-qcom.c Yaniv Gardi           2015-01-15  1422  
81c0fc51b7a790 drivers/scsi/ufs/ufs-qcom.c Yaniv Gardi           2015-01-15  1423  	/*
81c0fc51b7a790 drivers/scsi/ufs/ufs-qcom.c Yaniv Gardi           2015-01-15  1424  	 * In case ufs_qcom_init() is not yet done, simply ignore.
81c0fc51b7a790 drivers/scsi/ufs/ufs-qcom.c Yaniv Gardi           2015-01-15  1425  	 * This ufs_qcom_setup_clocks() shall be called from
81c0fc51b7a790 drivers/scsi/ufs/ufs-qcom.c Yaniv Gardi           2015-01-15  1426  	 * ufs_qcom_init() after init is done.
81c0fc51b7a790 drivers/scsi/ufs/ufs-qcom.c Yaniv Gardi           2015-01-15  1427  	 */
81c0fc51b7a790 drivers/scsi/ufs/ufs-qcom.c Yaniv Gardi           2015-01-15  1428  	if (!host)
81c0fc51b7a790 drivers/scsi/ufs/ufs-qcom.c Yaniv Gardi           2015-01-15  1429  		return 0;
81c0fc51b7a790 drivers/scsi/ufs/ufs-qcom.c Yaniv Gardi           2015-01-15  1430  
720fa0cb59e411 drivers/ufs/host/ufs-qcom.c Nitin Rawat           2025-06-23  1431  	phy = host->generic_phy;
720fa0cb59e411 drivers/ufs/host/ufs-qcom.c Nitin Rawat           2025-06-23  1432  
8240dd97cef424 drivers/scsi/ufs/ufs-qcom.c Can Guo               2020-02-10 @1433  	switch (status) {
8240dd97cef424 drivers/scsi/ufs/ufs-qcom.c Can Guo               2020-02-10  1434  	case PRE_CHANGE:
03ce80a1bb869f drivers/ufs/host/ufs-qcom.c Manivannan Sadhasivam 2023-07-31  1435  		if (on) {
03ce80a1bb869f drivers/ufs/host/ufs-qcom.c Manivannan Sadhasivam 2023-07-31  1436  			ufs_qcom_icc_update_bw(host);
c1553fc105dff2 drivers/ufs/host/ufs-qcom.c Palash Kambar         2025-09-09  1437  			if (ufs_qcom_is_link_hibern8(hba)) {
c1553fc105dff2 drivers/ufs/host/ufs-qcom.c Palash Kambar         2025-09-09  1438  				err = ufs_qcom_enable_lane_clks(host);
c1553fc105dff2 drivers/ufs/host/ufs-qcom.c Palash Kambar         2025-09-09  1439  				if (err) {
c1553fc105dff2 drivers/ufs/host/ufs-qcom.c Palash Kambar         2025-09-09  1440  					dev_err(hba->dev, "enable lane clks failed, ret=%d\n", err);
c1553fc105dff2 drivers/ufs/host/ufs-qcom.c Palash Kambar         2025-09-09  1441  					return err;
c1553fc105dff2 drivers/ufs/host/ufs-qcom.c Palash Kambar         2025-09-09  1442  				}
c1553fc105dff2 drivers/ufs/host/ufs-qcom.c Palash Kambar         2025-09-09  1443  			}
03ce80a1bb869f drivers/ufs/host/ufs-qcom.c Manivannan Sadhasivam 2023-07-31  1444  		} else {
feb3d79800ece1 drivers/scsi/ufs/ufs-qcom.c Vivek Gautam          2016-11-08  1445  			if (!ufs_qcom_is_link_active(hba)) {
81c0fc51b7a790 drivers/scsi/ufs/ufs-qcom.c Yaniv Gardi           2015-01-15  1446  				/* disable device ref_clk */
f06fcc7155dcbc drivers/scsi/ufs/ufs-qcom.c Yaniv Gardi           2015-10-28  1447  				ufs_qcom_dev_ref_clk_ctrl(host, false);
feb3d79800ece1 drivers/scsi/ufs/ufs-qcom.c Vivek Gautam          2016-11-08  1448  			}
77d2fa54a94574 drivers/ufs/host/ufs-qcom.c Nitin Rawat           2025-05-26  1449  
77d2fa54a94574 drivers/ufs/host/ufs-qcom.c Nitin Rawat           2025-05-26  1450  			err = phy_power_off(phy);
77d2fa54a94574 drivers/ufs/host/ufs-qcom.c Nitin Rawat           2025-05-26  1451  			if (err) {
77d2fa54a94574 drivers/ufs/host/ufs-qcom.c Nitin Rawat           2025-05-26  1452  				dev_err(hba->dev, "phy power off failed, ret=%d\n", err);
77d2fa54a94574 drivers/ufs/host/ufs-qcom.c Nitin Rawat           2025-05-26  1453  				return err;
77d2fa54a94574 drivers/ufs/host/ufs-qcom.c Nitin Rawat           2025-05-26  1454  			}
81c0fc51b7a790 drivers/scsi/ufs/ufs-qcom.c Yaniv Gardi           2015-01-15  1455  		}
8240dd97cef424 drivers/scsi/ufs/ufs-qcom.c Can Guo               2020-02-10  1456  		break;
8240dd97cef424 drivers/scsi/ufs/ufs-qcom.c Can Guo               2020-02-10  1457  	case POST_CHANGE:
8240dd97cef424 drivers/scsi/ufs/ufs-qcom.c Can Guo               2020-02-10  1458  		if (on) {
77d2fa54a94574 drivers/ufs/host/ufs-qcom.c Nitin Rawat           2025-05-26  1459  			err = phy_power_on(phy);
77d2fa54a94574 drivers/ufs/host/ufs-qcom.c Nitin Rawat           2025-05-26  1460  			if (err) {
77d2fa54a94574 drivers/ufs/host/ufs-qcom.c Nitin Rawat           2025-05-26  1461  				dev_err(hba->dev, "phy power on failed, ret = %d\n", err);
77d2fa54a94574 drivers/ufs/host/ufs-qcom.c Nitin Rawat           2025-05-26  1462  				return err;
77d2fa54a94574 drivers/ufs/host/ufs-qcom.c Nitin Rawat           2025-05-26  1463  			}
77d2fa54a94574 drivers/ufs/host/ufs-qcom.c Nitin Rawat           2025-05-26  1464  
8240dd97cef424 drivers/scsi/ufs/ufs-qcom.c Can Guo               2020-02-10  1465  			/* enable the device ref clock for HS mode*/
8240dd97cef424 drivers/scsi/ufs/ufs-qcom.c Can Guo               2020-02-10  1466  			if (ufshcd_is_hs_mode(&hba->pwr_info))
8240dd97cef424 drivers/scsi/ufs/ufs-qcom.c Can Guo               2020-02-10  1467  				ufs_qcom_dev_ref_clk_ctrl(host, true);
03ce80a1bb869f drivers/ufs/host/ufs-qcom.c Manivannan Sadhasivam 2023-07-31  1468  		} else {
c1553fc105dff2 drivers/ufs/host/ufs-qcom.c Palash Kambar         2025-09-09  1469  			if (ufs_qcom_is_link_hibern8(hba))
c1553fc105dff2 drivers/ufs/host/ufs-qcom.c Palash Kambar         2025-09-09  1470  				ufs_qcom_disable_lane_clks(host);
c1553fc105dff2 drivers/ufs/host/ufs-qcom.c Palash Kambar         2025-09-09  1471  
03ce80a1bb869f drivers/ufs/host/ufs-qcom.c Manivannan Sadhasivam 2023-07-31  1472  			ufs_qcom_icc_set_bw(host, ufs_qcom_bw_table[MODE_MIN][0][0].mem_bw,
03ce80a1bb869f drivers/ufs/host/ufs-qcom.c Manivannan Sadhasivam 2023-07-31  1473  					    ufs_qcom_bw_table[MODE_MIN][0][0].cfg_bw);
8240dd97cef424 drivers/scsi/ufs/ufs-qcom.c Can Guo               2020-02-10  1474  		}
8240dd97cef424 drivers/scsi/ufs/ufs-qcom.c Can Guo               2020-02-10  1475  		break;
8240dd97cef424 drivers/scsi/ufs/ufs-qcom.c Can Guo               2020-02-10  1476  	}
81c0fc51b7a790 drivers/scsi/ufs/ufs-qcom.c Yaniv Gardi           2015-01-15  1477  
c4adf171e834da drivers/scsi/ufs/ufs-qcom.c ChanWoo Lee           2021-09-07  1478  	return 0;
81c0fc51b7a790 drivers/scsi/ufs/ufs-qcom.c Yaniv Gardi           2015-01-15  1479  }
81c0fc51b7a790 drivers/scsi/ufs/ufs-qcom.c Yaniv Gardi           2015-01-15  1480  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
