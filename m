Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56992433DC
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 20:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726260086; cv=none; b=FKGRQ2MJtYlUuvM3f9iAW/OuTTdN4/qXc2wX903qzKyVCf2K1G9vfNhTqSJ7ZG0SQbRDK7R5WWlcHQV2tX5OMTIZScZdqp+Nb0burMpDsigLUS3bTIp8ZP4LuitzP6klf3qbQE0KRDDubrkQIuCyywOWgVddCmj7O/3JyjYn7C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726260086; c=relaxed/simple;
	bh=vXOiKlVMekuwn9qXKVwQZvUBLtBLMKmD1rbPA9wo58U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bry+whVhztjg3jKzTjE6Vv+0ApkfyYygKcG8CazC4ooxf1pysrGMOoMjDQBVlTolVA2COY3rAKPKtM3PxDQI+p8jh9DRjJzwNqe6MgfGPDt6SE2Btof3Vx/KQpbHFaZMc41a4syMzYWvM60oCQETaEYKW5TK8L9Cvy41WAezGf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m80bgP8d; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m80bgP8d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726260085; x=1757796085;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vXOiKlVMekuwn9qXKVwQZvUBLtBLMKmD1rbPA9wo58U=;
  b=m80bgP8d0RtOAMFU1FkjcNlLSVTUuSqpC6n8782Mza3Z2PrBJC5zjFRM
   uZOUkd6SmdZ5YBMBq2/3rSoB04E3tQhzDGgc7DW8qIxiRqc3NUmD2nkQq
   iNLVOf0AbpbbZbSpwdgta/wb2kff3c7LfI5vBqWkq+Ebqxg+bOCKXGaqP
   AdY1lpWcO6RQtotKtfcYUa5sOtrRP+Ca/HLcgrcE33qWRBLKFqNjYFuNU
   ErFKZHfvhEDYE+h7QunK1VrCAcKvlnGrGcVaHbNkxFjTWDU+ZfudBDNHU
   K6e7zkWHx2vW9ml93GBr7pOhF1nl5o12QaMr6iu6LD1moELxkejWGmYSD
   Q==;
X-CSE-ConnectionGUID: NnIao5cPS7SZ2fzw/7hhOA==
X-CSE-MsgGUID: DJaMO1uKQQGPdYnFCDQqpw==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="35848660"
X-IronPort-AV: E=Sophos;i="6.10,227,1719903600"; 
   d="scan'208";a="35848660"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2024 13:41:24 -0700
X-CSE-ConnectionGUID: hk7BigB0Q2yoHmNczF/WnA==
X-CSE-MsgGUID: 2JgYJntZQpG5TDOqC4FHlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,227,1719903600"; 
   d="scan'208";a="68966521"
Received: from lkp-server01.sh.intel.com (HELO 53e96f405c61) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 13 Sep 2024 13:41:21 -0700
Received: from kbuild by 53e96f405c61 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1spD6U-0006yM-2i;
	Fri, 13 Sep 2024 20:41:18 +0000
Date: Sat, 14 Sep 2024 04:40:57 +0800
From: kernel test robot <lkp@intel.com>
To: Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH v5 04/10] scsi: ufs: core: Introduce
 ufshcd_process_device_init_result()
Message-ID: <202409140417.VXgks1dM-lkp@intel.com>
References: <20240910215139.3352387-5-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910215139.3352387-5-bvanassche@acm.org>

Hi Bart,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[cannot apply to jejb-scsi/for-next linus/master v6.11-rc7 next-20240913]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Bart-Van-Assche/scsi-ufs-core-Introduce-ufshcd_add_scsi_host/20240911-055406
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20240910215139.3352387-5-bvanassche%40acm.org
patch subject: [PATCH v5 04/10] scsi: ufs: core: Introduce ufshcd_process_device_init_result()
config: i386-allyesconfig (https://download.01.org/0day-ci/archive/20240914/202409140417.VXgks1dM-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240914/202409140417.VXgks1dM-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409140417.VXgks1dM-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/ufs/core/ufshcd.c:7675: warning: Function parameter or struct member 'device_init_start' not described in 'ufshcd_process_device_init_result'
>> drivers/ufs/core/ufshcd.c:7675: warning: Excess function parameter 'start' description in 'ufshcd_process_device_init_result'


vim +7675 drivers/ufs/core/ufshcd.c

  7666	
  7667	/**
  7668	 * ufshcd_process_device_init_result - Process the ufshcd_device_init() result.
  7669	 * @hba: UFS host controller instance.
  7670	 * @start: time when the ufshcd_device_init() call started.
  7671	 * @ret: ufshcd_device_init() return value.
  7672	 */
  7673	static void ufshcd_process_device_init_result(struct ufs_hba *hba,
  7674						ktime_t device_init_start, int ret)
> 7675	{
  7676		unsigned long flags;
  7677	
  7678		spin_lock_irqsave(hba->host->host_lock, flags);
  7679		if (ret)
  7680			hba->ufshcd_state = UFSHCD_STATE_ERROR;
  7681		else if (hba->ufshcd_state == UFSHCD_STATE_RESET)
  7682			hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
  7683		spin_unlock_irqrestore(hba->host->host_lock, flags);
  7684	
  7685		trace_ufshcd_init(dev_name(hba->dev), ret,
  7686				ktime_to_us(ktime_sub(ktime_get(), device_init_start)),
  7687				hba->curr_dev_pwr_mode, hba->uic_link_state);
  7688	}
  7689	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
