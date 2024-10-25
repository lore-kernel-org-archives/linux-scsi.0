Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2AA20EA50;
	Fri, 25 Oct 2024 19:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729885535; cv=none; b=IQw43yvAcLDLGBdTr6PL9BEDZXxcC2S5PWOH3Uc0ZL8xZ9wwXm8WXkRHkr89AzsXQcuPPGb4sQIvMMlYvPmhDYUgM6n4mdyopHCz9YHCUwdoOH3Z2pzVBUcVdDiuvRbn73QtnR/g6CgPN1Xa5ePIBky+jdzRF+uSrPJNOy0t9+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729885535; c=relaxed/simple;
	bh=Odm8rM5oG6O35cTkBqAj/y5K/dJEj/4GZ5eaaAaoIhE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NoT89M4EtKfbfNUOktovTsUOrlXlvW5CYjuM19yIgbgPu8EZi+pAJ4bMXcZja9DEB3wXiV7EQc7XEbBj16opo00klqkc6jjIcLm99L4NCrHgO48GvtEIWDlN/AGbVCWQb4Hbz/lrwtoPfYIGq7195e1klnuaaYshlf4Xs4efaCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZlFixrc1; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZlFixrc1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729885533; x=1761421533;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Odm8rM5oG6O35cTkBqAj/y5K/dJEj/4GZ5eaaAaoIhE=;
  b=ZlFixrc1o3OJ7LRpDkd/s4PR0nDS+pFK2bsOcV/8sd8jntlp0jXs/m3X
   20/lpqhOpThrKb0aRvTLZbTpSy/tggdymoWNZ+xIN6dnGWPevA/u46M4h
   lC3jwnE3k/3YGVzgrkvvMM2j2zZg370YnBqoP7ANMEGeVcBa147r+iRrH
   2B29XwnR5yBPvpA5aK28sJeW7CY1jjWo3M5tp8x5NrY2Of9GILk1mh3Tr
   agdET/RS+3sQpIRq7I+1ygaWBgS4Jz50239NxrEtVPBla66PDcFcRzNMJ
   mdUVfQ7eN7NxD6Mck3MY8Yzj2lWkB8R7F4/NxvO1G6BB3Avx8saAcLdRd
   Q==;
X-CSE-ConnectionGUID: 0SLS9YykT9Wsj1w1hNojDw==
X-CSE-MsgGUID: Egg5X3jXS5ajElwiXBjDNw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="29432378"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="29432378"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2024 12:45:33 -0700
X-CSE-ConnectionGUID: +xmLViUaSXaFuDaMWKK8sQ==
X-CSE-MsgGUID: 2XwIh/TkTOmQovypF9PlIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,232,1725346800"; 
   d="scan'208";a="104331697"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 25 Oct 2024 12:45:27 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t4QFR-000YpB-1b;
	Fri, 25 Oct 2024 19:45:25 +0000
Date: Sat, 26 Oct 2024 03:44:53 +0800
From: kernel test robot <lkp@intel.com>
To: Huan Tang <tanghuan@vivo.com>, alim.akhtar@samsung.com,
	avri.altman@wdc.com, bvanassche@acm.org,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	beanhuo@micron.com, luhongfei@vivo.com, quic_cang@quicinc.com,
	keosung.park@samsung.com, viro@zeniv.linux.org.uk,
	quic_mnaresh@quicinc.com, peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org, ahalaney@redhat.com,
	quic_nguyenb@quicinc.com, linux@weissschuh.net, ebiggers@google.com,
	minwoo.im@samsung.com, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, opensource.kernel@vivo.com,
	Huan Tang <tanghuan@vivo.com>
Subject: Re: [PATCH] ufs: core: Add WB buffer resize support
Message-ID: <202410260352.WRMItCze-lkp@intel.com>
References: <20241025085924.4855-1-tanghuan@vivo.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241025085924.4855-1-tanghuan@vivo.com>

Hi Huan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v6.12-rc4 next-20241025]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Huan-Tang/ufs-core-Add-WB-buffer-resize-support/20241025-170131
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20241025085924.4855-1-tanghuan%40vivo.com
patch subject: [PATCH] ufs: core: Add WB buffer resize support
config: arm-randconfig-004-20241026 (https://download.01.org/0day-ci/archive/20241026/202410260352.WRMItCze-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241026/202410260352.WRMItCze-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410260352.WRMItCze-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/ufs/core/ufs-sysfs.c: In function 'wb_toggle_buf_resize_store':
>> drivers/ufs/core/ufs-sysfs.c:419:12: warning: variable 'index' set but not used [-Wunused-but-set-variable]
     419 |         u8 index;
         |            ^~~~~


vim +/index +419 drivers/ufs/core/ufs-sysfs.c

   413	
   414	static ssize_t wb_toggle_buf_resize_store(struct device *dev,
   415			struct device_attribute *attr, const char *buf, size_t count)
   416	{
   417		struct ufs_hba *hba = dev_get_drvdata(dev);
   418		unsigned int wb_buf_resize_op;
 > 419		u8 index;
   420		ssize_t res;
   421	
   422		if (!ufshcd_is_wb_allowed(hba) || !hba->dev_info.wb_enabled ||
   423			!hba->dev_info.b_presrv_uspc_en) {
   424			dev_err(dev, "The WB buf resize is not allowed!\n");
   425			return -EOPNOTSUPP;
   426		}
   427	
   428		if (kstrtouint(buf, 0, &wb_buf_resize_op))
   429			return -EINVAL;
   430	
   431		if (wb_buf_resize_op != 0x01 && wb_buf_resize_op != 0x02) {
   432			dev_err(dev, "The operation %u is invalid!\n", wb_buf_resize_op);
   433			return -EINVAL;
   434		}
   435	
   436		down(&hba->host_sem);
   437		if (!ufshcd_is_user_access_allowed(hba)) {
   438			res = -EBUSY;
   439			goto out;
   440		}
   441	
   442		index = ufshcd_wb_get_query_index(hba);
   443		ufshcd_rpm_get_sync(hba);
   444		res = ufshcd_wb_toggle_buf_resize(hba, wb_buf_resize_op);
   445		ufshcd_rpm_put_sync(hba);
   446	
   447	out:
   448		up(&hba->host_sem);
   449		return res < 0 ? res : count;
   450	}
   451	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
