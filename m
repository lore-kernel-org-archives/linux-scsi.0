Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C28337C112;
	Mon,  5 Oct 2026 20:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791233356; cv=none; b=OX1URAVHlTpQgfM2HSGV+5YJ545GAV+Zwn0ugEnG5CBuUjCElqF/lbTvSqin+sH0n4TVibpbVEmtWJFbSTbv3jKhMPQvxzBwpI1MPKIimkUNCtZ0A2x0h5ATaMnvMufsH1Mf8FtSYjgMBT4081XTSdcv+NgVGkEykLYqD0ODx0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791233356; c=relaxed/simple;
	bh=b5eO6cu/x2LURXsfvcknrPjDXFK/Ia5yCd9i79Wafws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pZ/SObVPMW89QDR2fh3kfU6NtYd0O5GoLaNZBfN69nhRmBLoC/mRyfM95vSAaxal6KcoksslC5if2mxcYzKRxE4I9wM8IlUoLrKNoSxSNYpYoTI9E8XJUm7vMQfbMyGFNMhjkZqA8Nb59H9GG8GRVEAcywW8H5LvviQm2NSa1ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TZ9d8orD; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TZ9d8orD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791233354; x=1822769354;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=b5eO6cu/x2LURXsfvcknrPjDXFK/Ia5yCd9i79Wafws=;
  b=TZ9d8orD1lfmLxUkabt//8sE1lYoY9A6ZSz8GNTVwP92P4XfeNl49hTl
   ttVedSTbIHF0Wjs4t1P/tqUm+W8MjeRJ1Drv4Z4LjWHXGL/+obn7u8pur
   Fg3yS/JfmcbqrhqZ8vYiY8zKL4WEyOwQ4753566jY/IxMhzpAs85o6vLt
   TpL/ycy+s+jcTQK0MAMtzNCjjfBEOJKg13SerRphACvex+nwvocfAvVHp
   ppHRA+RAkDc9LJ9OJpOw2VqoXabefKCXMfu3Lg4RPPPKBRdN21CGoqoCV
   bqT0Uo9avXGF7ZuxZWBNzjMOe/ZJup4tTOHRSs0qnCdmwsalXtMH8BXkQ
   g==;
X-CSE-ConnectionGUID: 0aoYTR4nQAGtBEfWRKc1iA==
X-CSE-MsgGUID: 89lCgMUWSVODcLj2hk2N5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11926"; a="92025882"
X-IronPort-AV: E=Sophos;i="6.27,142,1787036400"; 
   d="scan'208";a="92025882"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2026 13:49:13 -0700
X-CSE-ConnectionGUID: ePiNLwHJTSeZCJ/q+1n7UA==
X-CSE-MsgGUID: JbVKTsJhSvOTL8cjoVt8Hw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,142,1787036400"; 
   d="scan'208";a="274712953"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 05 Oct 2026 13:49:12 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xDpcT-000000000pg-0eow;
	Mon, 05 Oct 2026 20:49:09 +0000
Date: Tue, 6 Oct 2026 04:48:47 +0800
From: kernel test robot <lkp@intel.com>
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 7/7] scsi: sd_zbc: define storage element management
 operations
Message-ID: <202610060413.UQ1Jyndv-lkp@intel.com>
References: <20261005094632.580753-8-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005094632.580753-8-dlemoal@kernel.org>

Hi Damien,

kernel test robot noticed the following build errors:

[auto build test ERROR on axboe/for-next]
[also build test ERROR on next-20261005]
[cannot apply to mkp-scsi/for-next jejb-scsi/for-next linus/master v7.3-rc6]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Damien-Le-Moal/block-fail-reads-to-offline-zones-early/20261005-184626
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git for-next
patch link:    https://lore.kernel.org/r/20261005094632.580753-8-dlemoal%40kernel.org
patch subject: [PATCH 7/7] scsi: sd_zbc: define storage element management operations
config: sparc-defconfig (https://download.01.org/0day-ci/archive/20261006/202610060413.UQ1Jyndv-lkp@intel.com/config)
compiler: sparc-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261006/202610060413.UQ1Jyndv-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610060413.UQ1Jyndv-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/scsi/sd.c:3940:35: error: lvalue required as unary '&' operand
    3940 |         .se_ops                 = &sd_zbc_se_ops,
         |                                   ^


vim +3940 drivers/scsi/sd.c

  3926	
  3927	static const struct block_device_operations sd_fops = {
  3928		.owner			= THIS_MODULE,
  3929		.open			= sd_open,
  3930		.release		= sd_release,
  3931		.ioctl			= sd_ioctl,
  3932		.getgeo			= sd_getgeo,
  3933		.compat_ioctl		= blkdev_compat_ptr_ioctl,
  3934		.check_events		= sd_check_events,
  3935		.unlock_native_capacity	= sd_unlock_native_capacity,
  3936		.report_zones		= sd_zbc_report_zones,
  3937		.get_unique_id		= sd_get_unique_id,
  3938		.free_disk		= scsi_disk_free_disk,
  3939		.pr_ops			= &sd_pr_ops,
> 3940		.se_ops			= &sd_zbc_se_ops,
  3941	};
  3942	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
