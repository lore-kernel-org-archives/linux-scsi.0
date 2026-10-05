Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6074C1632DD;
	Mon,  5 Oct 2026 22:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791238583; cv=none; b=GYkAOj/dc1Alz/3vVe5AitSBRu3DX6qvW58vlTdqD1DTvouWpCXy4fMkCTKrhGAPl/L6gpfFkWahQNS0vmvDma2eLJSXKFaY3yEBLChersSdTcdbZNaSMMOf1AQKLVYvaRsxV+LL3BZCinn6E8C+qVcoTx6BU5L9v/D4zGwU+Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791238583; c=relaxed/simple;
	bh=YRzb5XzgZdiLrw4oEelHvtooHoQOb55BVmX2cQfX2ZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TQYsxkr70jWg3V4D7uczd+V8sX8H4d48QS5KiIpUxHNZCMQkPvkmwoKenGYFidHt3xqQNGKzC4Cw/UizPi86ylGHpxUx3/cGL606S5E60c6I0NtI8ri4xlPMO8KAcdqG/A1/LsDyx/hi7lE9yn8JL9poW4d8m/FDbCrq44AZNeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kdkxCVYl; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kdkxCVYl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791238578; x=1822774578;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YRzb5XzgZdiLrw4oEelHvtooHoQOb55BVmX2cQfX2ZE=;
  b=kdkxCVYlu9QPtjhLDgbsDwVp0hcE4k7SjH/qU+6nDgntX0IMWs5uUcVr
   FwiqLEvsN7kK2sqxsqMN8SPboRN2/lmlKu77pNQ6wo+fOQqE3QrMWs7am
   VKjJue/xF4+qIhvgpK72gitd8dExD94yOENWp77SXMRv28IwWNHH2nynh
   SbeMY7XZAfchNNQQ5YAixxA0Gqyhid+GLsm3p0iWplxK48d0G7yjA0P+x
   dGB69j/ylJe1+10tr13esQuga50BSmWP86s+eFaM6J3ezUOQlKWDvBD0k
   4lMuFGjcDpq6ShV57tvmP/XseQ79ohgtmpxr2vSoOBwOoPWfI4TjVMHYB
   w==;
X-CSE-ConnectionGUID: d06tBPa7Tb6ehZA/nh1cdA==
X-CSE-MsgGUID: DFU4dJKVTBW8d+bj5enzWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11926"; a="94796378"
X-IronPort-AV: E=Sophos;i="6.27,142,1787036400"; 
   d="scan'208";a="94796378"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2026 15:16:17 -0700
X-CSE-ConnectionGUID: toiu64uFR/qlm5y/xDtCgw==
X-CSE-MsgGUID: z9OHUPk9Si6BAEhR3n8fsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,142,1787036400"; 
   d="scan'208";a="304876960"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 05 Oct 2026 15:16:15 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xDqyi-000000000uS-1ilS;
	Mon, 05 Oct 2026 22:16:12 +0000
Date: Tue, 6 Oct 2026 06:15:43 +0800
From: kernel test robot <lkp@intel.com>
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 2/7] block: introduce storage element management
Message-ID: <202610060627.NVrcnIcL-lkp@intel.com>
References: <20261005094632.580753-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005094632.580753-3-dlemoal@kernel.org>

Hi Damien,

kernel test robot noticed the following build warnings:

[auto build test WARNING on axboe/for-next]
[also build test WARNING on next-20261005]
[cannot apply to mkp-scsi/for-next jejb-scsi/for-next linus/master v7.3-rc6]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Damien-Le-Moal/block-fail-reads-to-offline-zones-early/20261005-184626
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git for-next
patch link:    https://lore.kernel.org/r/20261005094632.580753-3-dlemoal%40kernel.org
patch subject: [PATCH 2/7] block: introduce storage element management
config: riscv-randconfig-1001-20261006 (https://download.01.org/0day-ci/archive/20261006/202610060627.NVrcnIcL-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261006/202610060627.NVrcnIcL-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610060627.NVrcnIcL-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: block/blk-zoned.c:2779 function parameter 'bdev' not described in 'bdev_report_storage_elements'
>> Warning: block/blk-zoned.c:2779 function parameter 'nr_elements' not described in 'bdev_report_storage_elements'
>> Warning: block/blk-zoned.c:2779 function parameter 'elements' not described in 'bdev_report_storage_elements'
>> Warning: block/blk-zoned.c:2807 function parameter 'bdev' not described in 'bdev_remove_storage_element'
>> Warning: block/blk-zoned.c:2807 function parameter 'element_id' not described in 'bdev_remove_storage_element'
>> Warning: block/blk-zoned.c:2859 function parameter 'bdev' not described in 'bdev_restore_storage_elements'
>> Warning: block/blk-zoned.c:2779 function parameter 'bdev' not described in 'bdev_report_storage_elements'
>> Warning: block/blk-zoned.c:2779 function parameter 'nr_elements' not described in 'bdev_report_storage_elements'
>> Warning: block/blk-zoned.c:2779 function parameter 'elements' not described in 'bdev_report_storage_elements'
>> Warning: block/blk-zoned.c:2807 function parameter 'bdev' not described in 'bdev_remove_storage_element'
>> Warning: block/blk-zoned.c:2807 function parameter 'element_id' not described in 'bdev_remove_storage_element'
>> Warning: block/blk-zoned.c:2859 function parameter 'bdev' not described in 'bdev_restore_storage_elements'

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
