Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1937405F8;
	Wed,  3 Apr 2024 04:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712118251; cv=none; b=J7zOP8c3D4GH085Mx/faSYDW11PCck8BLCdN2Jq/gGT7GKwO12qzkceq379aK+TLYGjoy01tMuwGHvRSTdzr3XM6XZnbtgN/2OWjVTkToW17Ujmj3L4NAm8Lk9hVsp6eIxS57q0JMBsTgZVsJEH+id19y1kG+RKG5Aagi9TdAsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712118251; c=relaxed/simple;
	bh=kvZKyFnzaSdzkHLInBECq2A4x1BE0FyawGZWZBsWnfY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YLP3y4KHoVEXB+nDC3JB+udyPE7m75T2FQrtERonbNax6BQko+zmIGiQ/8rRI5Kr49eZjPqsaIMyKKv5ujYs2xIdr/V63An3jCdOmA7ATbMpGJq9byHsOEGL/xXQPn6SSXvkGX7R73zIWUQLT674zlyp82xmsmYFIc97G9pSMEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PPfRJjsJ; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PPfRJjsJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712118250; x=1743654250;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kvZKyFnzaSdzkHLInBECq2A4x1BE0FyawGZWZBsWnfY=;
  b=PPfRJjsJOX4oSmgLCsliSskMSRF+Hh9YHAe9cI7ElhhoujYqDT46taCm
   apr6zOxqDjzig3irLSY38S7hx1j3YY6JUZJ84qQol3NIm1wfdrCCvVOPl
   l4jbxQo7bdoZyCjMAymgIyhBwtazP8jVSO6eZo76r/IESlmstoDBECjHK
   g3G2g0jXhCuV4XMC2ytm95CDl/B3OCiVgCBNM0zJNbCpJcRGNQVO/GbSD
   SV8qpApYrKm6i8e1ABL+iIFL0eqKeVtwB3aH6lb9Hnm0VFaIV+B2fes/G
   Ui9drTkrN3TWSI59zUm0UDqc2JATdltwvPMw3U2gUPYD30RMHXZxh4Z4c
   Q==;
X-CSE-ConnectionGUID: RUOpfj9OQyKbWphjPWqPoA==
X-CSE-MsgGUID: wi+mdifZSoiNYn5jWw2HoQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11032"; a="11104933"
X-IronPort-AV: E=Sophos;i="6.07,176,1708416000"; 
   d="scan'208";a="11104933"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2024 21:24:09 -0700
X-CSE-ConnectionGUID: vr7UOS3ATjqARwTETHCDhA==
X-CSE-MsgGUID: bcwQ72D4S1KwGBlIGF571A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,176,1708416000"; 
   d="scan'208";a="22779970"
Received: from lkp-server02.sh.intel.com (HELO 90ee3aa53dbd) ([10.239.97.151])
  by fmviesa003.fm.intel.com with ESMTP; 02 Apr 2024 21:24:06 -0700
Received: from kbuild by 90ee3aa53dbd with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rrsAO-0001qZ-07;
	Wed, 03 Apr 2024 04:24:04 +0000
Date: Wed, 3 Apr 2024 12:23:07 +0800
From: kernel test robot <lkp@intel.com>
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v4 07/28] block: Introduce zone write plugging
Message-ID: <202404031242.Oy7q9BWh-lkp@intel.com>
References: <20240402123907.512027-8-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402123907.512027-8-dlemoal@kernel.org>

Hi Damien,

kernel test robot noticed the following build warnings:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on linus/master v6.9-rc2 next-20240402]
[cannot apply to jejb-scsi/for-next device-mapper-dm/for-next mkp-scsi/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Damien-Le-Moal/block-Restore-sector-of-flush-requests/20240402-204657
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
patch link:    https://lore.kernel.org/r/20240402123907.512027-8-dlemoal%40kernel.org
patch subject: [PATCH v4 07/28] block: Introduce zone write plugging
config: i386-buildonly-randconfig-003-20240403 (https://download.01.org/0day-ci/archive/20240403/202404031242.Oy7q9BWh-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240403/202404031242.Oy7q9BWh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202404031242.Oy7q9BWh-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> block/blk-zoned.c:1435:10: warning: variable 'ret' is uninitialized when used here [-Wuninitialized]
    1435 |                 return ret;
         |                        ^~~
   block/blk-zoned.c:1415:9: note: initialize the variable 'ret' to silence this warning
    1415 |         int ret;
         |                ^
         |                 = 0
   1 warning generated.


vim +/ret +1435 block/blk-zoned.c

  1410	
  1411	static int disk_alloc_zone_resources(struct gendisk *disk,
  1412					     unsigned int pool_size)
  1413	{
  1414		unsigned int i;
  1415		int ret;
  1416	
  1417		disk->zone_wplugs_hash_bits =
  1418			min(ilog2(pool_size) + 1, BLK_ZONE_WPLUG_MAX_HASH_BITS);
  1419	
  1420		disk->zone_wplugs_hash =
  1421			kcalloc(disk_zone_wplugs_hash_size(disk),
  1422				sizeof(struct hlist_head), GFP_KERNEL);
  1423		if (!disk->zone_wplugs_hash)
  1424			return -ENOMEM;
  1425	
  1426		for (i = 0; i < disk_zone_wplugs_hash_size(disk); i++)
  1427			INIT_HLIST_HEAD(&disk->zone_wplugs_hash[i]);
  1428	
  1429		disk->zone_wplugs_pool = mempool_create_kmalloc_pool(pool_size,
  1430							sizeof(struct blk_zone_wplug));
  1431		if (!disk->zone_wplugs_pool) {
  1432			kfree(disk->zone_wplugs_hash);
  1433			disk->zone_wplugs_hash = NULL;
  1434			disk->zone_wplugs_hash_bits = 0;
> 1435			return ret;
  1436		}
  1437	
  1438		return 0;
  1439	}
  1440	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
