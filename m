Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DF53E4109;
	Mon,  5 Oct 2026 21:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791236538; cv=none; b=CXN1Vxm0s7nXzxYNWfbFQhrvHVpQWD1tCvNjgLlnVAnS91DdYlghHDRwSGzeBm9eSEU20hN06HYojmU2KepNnl0d9kiA2/vFSAWu1DQleKJTFYyrK6GaKun2r6b2x0t8bIbDTVAEGuN7no2HqIJjlI71XoS4dxr5G8BwoHqK7T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791236538; c=relaxed/simple;
	bh=d0p63z1XCpSBm9OwrW68pYfgxFLv7BQ75z9Kpd9NBsI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q7HHsmpdow/ekcqHrbc1yNfqNXo/6MN/Q1/PCcIkEF7NxEwF9VKHRZkWxnxDZlXfIQCip8K5vWQsrnKB0ZNtjOBr/R0p6fwsMFV5oaHyQt4ptsP5NarulPRIqSjZxtHUOCRatO/9xx5vR4IpWWPaZgjcDyKq6eOjRji6TK7YTcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ft7lBNuc; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ft7lBNuc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791236536; x=1822772536;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=d0p63z1XCpSBm9OwrW68pYfgxFLv7BQ75z9Kpd9NBsI=;
  b=ft7lBNuchB7fFujNjXgIU27YSiF6yoOg4dVc7LyYaCMm/NDuLE+0QCKt
   sr+8X8LqVH4wXRnZNq8M8dvYdV9ElcUStuBwjle2e+SfeLt4EJPO2TqwO
   MqSNa6AA3Er4Se75pXoWeqF1SIyfzqq82yq+W7VQDByPbqEab6r4izTlg
   3FeEFoYZlDKMIIA/t74ijB8VHmahg7MCOTF7VvWQEW1sy9lqjeHaMiSpO
   RLNxb/DMy3SjtZo1Re6UyX+RmKbf69byO9zSWw1AXKVQP3FoSSZGp7QTx
   /2Y5ce5ezwsc1LugTYoH5YXydZvbroofTXDgze1I4gFWfcdaz41xG8gWT
   A==;
X-CSE-ConnectionGUID: L19Fehj8T1+my4CcyPzA2g==
X-CSE-MsgGUID: 8ezyq/RjR1mddmmABTXD+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11926"; a="101240880"
X-IronPort-AV: E=Sophos;i="6.27,142,1787036400"; 
   d="scan'208";a="101240880"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2026 14:42:15 -0700
X-CSE-ConnectionGUID: HaWRJfgQRiaH7vaSc63+Cw==
X-CSE-MsgGUID: rI0nLmMOSi+a9+LZOhvGQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,142,1787036400"; 
   d="scan'208";a="303197126"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 05 Oct 2026 14:42:14 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xDqRn-000000000sa-0D5A;
	Mon, 05 Oct 2026 21:42:11 +0000
Date: Tue, 6 Oct 2026 05:41:55 +0800
From: kernel test robot <lkp@intel.com>
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 7/7] scsi: sd_zbc: define storage element management
 operations
Message-ID: <202610060512.08JQbDV4-lkp@intel.com>
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
config: sparc64-defconfig (https://download.01.org/0day-ci/archive/20261006/202610060512.08JQbDV4-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 80cd965b6323b208519f8ab1d5ee86e4ea9862f4)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261006/202610060512.08JQbDV4-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610060512.08JQbDV4-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/scsi/sd.c:3940:14: error: cannot take the address of an rvalue of type 'void *'
    3940 |         .se_ops                 = &sd_zbc_se_ops,
         |                                   ^~~~~~~~~~~~~~
   1 error generated.


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
