Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBAF8405C;
	Wed,  3 Dec 2025 06:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764742585; cv=none; b=TXx+AD+HHI0+G497OnR7d/lIhyz2NG6rAhHfruJY+oNquLY8hVj0Cg8Yog9kWxtXNBw67aRicXOSB+WwX0UBFY8daBP/TE38ipNxNzy8RR+jCxxB7knue405+ArgOg7sVx5iAZJDOL2kguJZCqXXS12g5nPMzt/Dtv2FJrthluA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764742585; c=relaxed/simple;
	bh=JYLecQvYteNlmJUeIENj83iFe1jAfE+HHu23/MCPAg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HOmPcqiGUN0p9TZz/j2S6APs4gLrWcItDb5jZDxNtj76wXkOdveArsTf8FtMRUa90BkvxG3STdFZdu7LOlgtlPWj2e8gG8lFT9w4GEBu5tbpYx0rEa5bbHmYJiQaVRkeKAhzYCJHfVdB0uc7QKC6uricXt+Z0+/NoDzWCNQKQXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cshcfc2U; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cshcfc2U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764742584; x=1796278584;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JYLecQvYteNlmJUeIENj83iFe1jAfE+HHu23/MCPAg4=;
  b=Cshcfc2UgWsEdnCan5iRFH51CMQQEcZI9OivZPFeQb4TXpAds2Bm+R5G
   leYHYbLoyz20cgNjXChC2ydxYdm+OLSfaedvlx//mvGqOyABVJHIHJC4/
   4OF+uw1E/WmBCcbKl2w+X5k9JpVWVmoTq9M71VgHBrbQ8KY/qo9XQzTwA
   ZppiVU4blE38vKALMWwqaF/gUnEIX5lgNrd88k5eyatZWCyV7zb01rn8Y
   KFqDzvmk0pqoxbWVZTbxkiCy00p4PcgT9SUWgtdxaSlSMXy88xjVfYuju
   /r5WUsAeAIxqb6b0BvjQ6lR01kp2N9ZyC8Ysg6bmnsUlk2ZznH0wBuS5V
   w==;
X-CSE-ConnectionGUID: Lw5B20HJR++6Y7bAQo+NQg==
X-CSE-MsgGUID: xPohn2B9Tpy4g6Vv5wrCIA==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="66768805"
X-IronPort-AV: E=Sophos;i="6.20,245,1758610800"; 
   d="scan'208";a="66768805"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 22:16:22 -0800
X-CSE-ConnectionGUID: vcHkC3DQSLSiW5ELAzh+Rw==
X-CSE-MsgGUID: gToG5bTjQQ+sjGpdWBRfkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,245,1758610800"; 
   d="scan'208";a="194469183"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 02 Dec 2025 22:16:18 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vQg9v-00000000AeH-3pXm;
	Wed, 03 Dec 2025 06:16:15 +0000
Date: Wed, 3 Dec 2025 14:15:55 +0800
From: kernel test robot <lkp@intel.com>
To: Bean Huo <beanhuo@iokpp.de>, avri.altman@sandisk.com,
	bvanassche@acm.org, alim.akhtar@samsung.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, can.guo@oss.qualcomm.com,
	beanhuo@micron.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix link error when CONFIG_RPMB=m
Message-ID: <202512031316.SvDwnvhy-lkp@intel.com>
References: <20251130151508.3076994-1-beanhuo@iokpp.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251130151508.3076994-1-beanhuo@iokpp.de>

Hi Bean,

kernel test robot noticed the following build errors:

[auto build test ERROR on mkp-scsi/for-next]
[also build test ERROR on jejb-scsi/for-next mkp-scsi/6.19/scsi-queue next-20251202]
[cannot apply to linus/master v6.18]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Bean-Huo/scsi-ufs-core-Fix-link-error-when-CONFIG_RPMB-m/20251130-231759
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20251130151508.3076994-1-beanhuo%40iokpp.de
patch subject: [PATCH] scsi: ufs: core: Fix link error when CONFIG_RPMB=m
config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20251203/202512031316.SvDwnvhy-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251203/202512031316.SvDwnvhy-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512031316.SvDwnvhy-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/ufs/core/ufs-rpmb.c:135:5: error: redefinition of 'ufs_rpmb_probe'
     135 | int ufs_rpmb_probe(struct ufs_hba *hba)
         |     ^
   drivers/ufs/core/ufshcd-priv.h:445:19: note: previous definition is here
     445 | static inline int ufs_rpmb_probe(struct ufs_hba *hba)
         |                   ^
>> drivers/ufs/core/ufs-rpmb.c:234:6: error: redefinition of 'ufs_rpmb_remove'
     234 | void ufs_rpmb_remove(struct ufs_hba *hba)
         |      ^
   drivers/ufs/core/ufshcd-priv.h:449:20: note: previous definition is here
     449 | static inline void ufs_rpmb_remove(struct ufs_hba *hba)
         |                    ^
   2 errors generated.


vim +/ufs_rpmb_probe +135 drivers/ufs/core/ufs-rpmb.c

b06b8c421485e0 Bean Huo 2025-11-08  133  
b06b8c421485e0 Bean Huo 2025-11-08  134  /* UFS RPMB device registration */
b06b8c421485e0 Bean Huo 2025-11-08 @135  int ufs_rpmb_probe(struct ufs_hba *hba)
b06b8c421485e0 Bean Huo 2025-11-08  136  {
b06b8c421485e0 Bean Huo 2025-11-08  137  	struct ufs_rpmb_dev *ufs_rpmb, *it, *tmp;
b06b8c421485e0 Bean Huo 2025-11-08  138  	struct rpmb_dev *rdev;
b06b8c421485e0 Bean Huo 2025-11-08  139  	char *cid = NULL;
b06b8c421485e0 Bean Huo 2025-11-08  140  	int region;
b06b8c421485e0 Bean Huo 2025-11-08  141  	u32 cap;
b06b8c421485e0 Bean Huo 2025-11-08  142  	int ret;
b06b8c421485e0 Bean Huo 2025-11-08  143  
b06b8c421485e0 Bean Huo 2025-11-08  144  	if (!hba->ufs_rpmb_wlun || hba->dev_info.b_advanced_rpmb_en) {
b06b8c421485e0 Bean Huo 2025-11-08  145  		dev_info(hba->dev, "Skip OP-TEE RPMB registration\n");
b06b8c421485e0 Bean Huo 2025-11-08  146  		return -ENODEV;
b06b8c421485e0 Bean Huo 2025-11-08  147  	}
b06b8c421485e0 Bean Huo 2025-11-08  148  
b06b8c421485e0 Bean Huo 2025-11-08  149  	/* Check if device_id is available */
b06b8c421485e0 Bean Huo 2025-11-08  150  	if (!hba->dev_info.device_id) {
b06b8c421485e0 Bean Huo 2025-11-08  151  		dev_err(hba->dev, "UFS Device ID not available\n");
b06b8c421485e0 Bean Huo 2025-11-08  152  		return -EINVAL;
b06b8c421485e0 Bean Huo 2025-11-08  153  	}
b06b8c421485e0 Bean Huo 2025-11-08  154  
b06b8c421485e0 Bean Huo 2025-11-08  155  	INIT_LIST_HEAD(&hba->rpmbs);
b06b8c421485e0 Bean Huo 2025-11-08  156  
b06b8c421485e0 Bean Huo 2025-11-08  157  	struct rpmb_descr descr = {
b06b8c421485e0 Bean Huo 2025-11-08  158  		.type = RPMB_TYPE_UFS,
b06b8c421485e0 Bean Huo 2025-11-08  159  		.route_frames = ufs_rpmb_route_frames,
b06b8c421485e0 Bean Huo 2025-11-08  160  		.reliable_wr_count = hba->dev_info.rpmb_io_size,
b06b8c421485e0 Bean Huo 2025-11-08  161  	};
b06b8c421485e0 Bean Huo 2025-11-08  162  
b06b8c421485e0 Bean Huo 2025-11-08  163  	for (region = 0; region < ARRAY_SIZE(hba->dev_info.rpmb_region_size); region++) {
b06b8c421485e0 Bean Huo 2025-11-08  164  		cap = hba->dev_info.rpmb_region_size[region];
b06b8c421485e0 Bean Huo 2025-11-08  165  		if (!cap)
b06b8c421485e0 Bean Huo 2025-11-08  166  			continue;
b06b8c421485e0 Bean Huo 2025-11-08  167  
b06b8c421485e0 Bean Huo 2025-11-08  168  		ufs_rpmb = devm_kzalloc(hba->dev, sizeof(*ufs_rpmb), GFP_KERNEL);
b06b8c421485e0 Bean Huo 2025-11-08  169  		if (!ufs_rpmb) {
b06b8c421485e0 Bean Huo 2025-11-08  170  			ret = -ENOMEM;
b06b8c421485e0 Bean Huo 2025-11-08  171  			goto err_out;
b06b8c421485e0 Bean Huo 2025-11-08  172  		}
b06b8c421485e0 Bean Huo 2025-11-08  173  
b06b8c421485e0 Bean Huo 2025-11-08  174  		ufs_rpmb->hba = hba;
b06b8c421485e0 Bean Huo 2025-11-08  175  		ufs_rpmb->dev.parent = &hba->ufs_rpmb_wlun->sdev_gendev;
b06b8c421485e0 Bean Huo 2025-11-08  176  		ufs_rpmb->dev.bus = &ufs_rpmb_bus_type;
b06b8c421485e0 Bean Huo 2025-11-08  177  		ufs_rpmb->dev.release = ufs_rpmb_device_release;
b06b8c421485e0 Bean Huo 2025-11-08  178  		dev_set_name(&ufs_rpmb->dev, "ufs_rpmb%d", region);
b06b8c421485e0 Bean Huo 2025-11-08  179  
b06b8c421485e0 Bean Huo 2025-11-08  180  		/* Set driver data BEFORE device_register */
b06b8c421485e0 Bean Huo 2025-11-08  181  		dev_set_drvdata(&ufs_rpmb->dev, ufs_rpmb);
b06b8c421485e0 Bean Huo 2025-11-08  182  
b06b8c421485e0 Bean Huo 2025-11-08  183  		ret = device_register(&ufs_rpmb->dev);
b06b8c421485e0 Bean Huo 2025-11-08  184  		if (ret) {
b06b8c421485e0 Bean Huo 2025-11-08  185  			dev_err(hba->dev, "Failed to register UFS RPMB device %d\n", region);
b06b8c421485e0 Bean Huo 2025-11-08  186  			put_device(&ufs_rpmb->dev);
b06b8c421485e0 Bean Huo 2025-11-08  187  			goto err_out;
b06b8c421485e0 Bean Huo 2025-11-08  188  		}
b06b8c421485e0 Bean Huo 2025-11-08  189  
b06b8c421485e0 Bean Huo 2025-11-08  190  		/* Create unique ID by appending region number to device_id */
b06b8c421485e0 Bean Huo 2025-11-08  191  		cid = kasprintf(GFP_KERNEL, "%s-R%d", hba->dev_info.device_id, region);
b06b8c421485e0 Bean Huo 2025-11-08  192  		if (!cid) {
b06b8c421485e0 Bean Huo 2025-11-08  193  			device_unregister(&ufs_rpmb->dev);
b06b8c421485e0 Bean Huo 2025-11-08  194  			ret = -ENOMEM;
b06b8c421485e0 Bean Huo 2025-11-08  195  			goto err_out;
b06b8c421485e0 Bean Huo 2025-11-08  196  		}
b06b8c421485e0 Bean Huo 2025-11-08  197  
b06b8c421485e0 Bean Huo 2025-11-08  198  		descr.dev_id = cid;
b06b8c421485e0 Bean Huo 2025-11-08  199  		descr.dev_id_len = strlen(cid);
b06b8c421485e0 Bean Huo 2025-11-08  200  		descr.capacity = cap;
b06b8c421485e0 Bean Huo 2025-11-08  201  
b06b8c421485e0 Bean Huo 2025-11-08  202  		/* Register RPMB device */
b06b8c421485e0 Bean Huo 2025-11-08  203  		rdev = rpmb_dev_register(&ufs_rpmb->dev, &descr);
b06b8c421485e0 Bean Huo 2025-11-08  204  		if (IS_ERR(rdev)) {
b06b8c421485e0 Bean Huo 2025-11-08  205  			dev_err(hba->dev, "Failed to register UFS RPMB device.\n");
b06b8c421485e0 Bean Huo 2025-11-08  206  			device_unregister(&ufs_rpmb->dev);
b06b8c421485e0 Bean Huo 2025-11-08  207  			ret = PTR_ERR(rdev);
b06b8c421485e0 Bean Huo 2025-11-08  208  			goto err_out;
b06b8c421485e0 Bean Huo 2025-11-08  209  		}
b06b8c421485e0 Bean Huo 2025-11-08  210  
b06b8c421485e0 Bean Huo 2025-11-08  211  		kfree(cid);
b06b8c421485e0 Bean Huo 2025-11-08  212  		cid = NULL;
b06b8c421485e0 Bean Huo 2025-11-08  213  
b06b8c421485e0 Bean Huo 2025-11-08  214  		ufs_rpmb->rdev = rdev;
b06b8c421485e0 Bean Huo 2025-11-08  215  		ufs_rpmb->region_id = region;
b06b8c421485e0 Bean Huo 2025-11-08  216  
b06b8c421485e0 Bean Huo 2025-11-08  217  		list_add_tail(&ufs_rpmb->node, &hba->rpmbs);
b06b8c421485e0 Bean Huo 2025-11-08  218  
b06b8c421485e0 Bean Huo 2025-11-08  219  		dev_info(hba->dev, "UFS RPMB region %d registered (capacity=%u)\n", region, cap);
b06b8c421485e0 Bean Huo 2025-11-08  220  	}
b06b8c421485e0 Bean Huo 2025-11-08  221  
b06b8c421485e0 Bean Huo 2025-11-08  222  	return 0;
b06b8c421485e0 Bean Huo 2025-11-08  223  err_out:
b06b8c421485e0 Bean Huo 2025-11-08  224  	kfree(cid);
b06b8c421485e0 Bean Huo 2025-11-08  225  	list_for_each_entry_safe(it, tmp, &hba->rpmbs, node) {
b06b8c421485e0 Bean Huo 2025-11-08  226  		list_del(&it->node);
b06b8c421485e0 Bean Huo 2025-11-08  227  		device_unregister(&it->dev);
b06b8c421485e0 Bean Huo 2025-11-08  228  	}
b06b8c421485e0 Bean Huo 2025-11-08  229  
b06b8c421485e0 Bean Huo 2025-11-08  230  	return ret;
b06b8c421485e0 Bean Huo 2025-11-08  231  }
b06b8c421485e0 Bean Huo 2025-11-08  232  
b06b8c421485e0 Bean Huo 2025-11-08  233  /* UFS RPMB remove handler */
b06b8c421485e0 Bean Huo 2025-11-08 @234  void ufs_rpmb_remove(struct ufs_hba *hba)
b06b8c421485e0 Bean Huo 2025-11-08  235  {
b06b8c421485e0 Bean Huo 2025-11-08  236  	struct ufs_rpmb_dev *ufs_rpmb, *tmp;
b06b8c421485e0 Bean Huo 2025-11-08  237  
b06b8c421485e0 Bean Huo 2025-11-08  238  	if (list_empty(&hba->rpmbs))
b06b8c421485e0 Bean Huo 2025-11-08  239  		return;
b06b8c421485e0 Bean Huo 2025-11-08  240  
b06b8c421485e0 Bean Huo 2025-11-08  241  	/* Remove all registered RPMB devices */
b06b8c421485e0 Bean Huo 2025-11-08  242  	list_for_each_entry_safe(ufs_rpmb, tmp, &hba->rpmbs, node) {
b06b8c421485e0 Bean Huo 2025-11-08  243  		dev_info(hba->dev, "Removing UFS RPMB region %d\n", ufs_rpmb->region_id);
b06b8c421485e0 Bean Huo 2025-11-08  244  		/* Remove from list first */
b06b8c421485e0 Bean Huo 2025-11-08  245  		list_del(&ufs_rpmb->node);
b06b8c421485e0 Bean Huo 2025-11-08  246  		/* Unregister device */
b06b8c421485e0 Bean Huo 2025-11-08  247  		device_unregister(&ufs_rpmb->dev);
b06b8c421485e0 Bean Huo 2025-11-08  248  	}
b06b8c421485e0 Bean Huo 2025-11-08  249  
b06b8c421485e0 Bean Huo 2025-11-08  250  	dev_info(hba->dev, "All UFS RPMB devices unregistered\n");
b06b8c421485e0 Bean Huo 2025-11-08  251  }
b06b8c421485e0 Bean Huo 2025-11-08  252  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
